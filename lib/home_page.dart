import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning_hub/courses_page.dart';
import 'backend.dart';

class HomePage extends StatefulWidget {
  final GoogleSignInAccount account;

  HomePage({this.account});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  GoogleSignInAccount account;

  void _pushCoursesPage(GoogleSignInAccount account) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => CoursesPage(
                account: widget.account,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    account = widget.account;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.swap_horiz),
              onPressed: () {
                signOut();
                setState(() {
                  account = null;
                });
              }),
        ],
      ),
      body: isSignedIn(account)
          ? Text("Signed in!")
          : FutureBuilder(
              future: signIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  account = snapshot.data;
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Text("Account Name: ${account.displayName}"),
                        Image.network(account.photoUrl),
                        RaisedButton(
                          onPressed: () => _pushCoursesPage(account),
                        )
                      ],
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
    );
  }
}
