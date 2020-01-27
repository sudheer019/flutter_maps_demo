import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapDisplayScreens extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MapDisplayScreensState();
  }
}

class MapDisplayScreensState extends State<MapDisplayScreens> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  bool isLoading = false;
  String errorMessage;
  LocationData currentLocation;

  // final center = LatLng(lat, lng);
  var center;
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(17.3998, 78.4771);
  MapType _currentMapType = MapType.normal;
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  @override
  Widget build(BuildContext context) {
    getUserLocation();
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.blue[700],
        ),
      key: homeScaffoldKey,
      body: new SingleChildScrollView(
        child:
        Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
                mapType: _currentMapType,
              ),
            )
          ],
        ),
      )
    );
  }

 /* void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }*/

  void refresh() async {
   //  center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ?LatLng(17.3998, 78.4771) : center, zoom: 15.0)));
    //  getNearbyPlaces(center);
  }

  Future<LatLng> getUserLocation() async {
    LocationData currentLocation;
    final location = new Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
       center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }
/*void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }*/
}
