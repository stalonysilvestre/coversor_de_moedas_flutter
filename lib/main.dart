import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const request="https://api.hgbrasil.com/finance?format=json&key=60dj7606";

void main()async{
  
  runApp(MaterialApp(
    home: Home(),
     theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        hintStyle: TextStyle(color: Colors.amber),
      )),
  ));
}

Future<Map> getData() async{
http.Response response = await http.get(request);
return json.decode(response.body);

}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

final realControler=TextEditingController();
final dolarControler=TextEditingController();
final euroControler=TextEditingController();

double dolar;
double euro;
void _realChanged(String text){
  if(text.isEmpty){
    _reset();
    return;
  }
  double real=double.parse(text);
  dolarControler.text=(real/dolar).toStringAsFixed(2);
  euroControler.text=(real/euro).toStringAsFixed(2);
}
void _dolarChanged(String text){
  if(text.isEmpty){
    _reset();
    return;
  }
  double dolar=double.parse(text);
  realControler.text=(dolar * this.dolar).toStringAsFixed(2);
  euroControler.text=(dolar * this.dolar/euro).toStringAsFixed(2);

}
void _euroChanged(String text){
  if(text.isEmpty){
    _reset();
    return;
  }
  double euro=double.parse(text);
  realControler.text=(euro * this.euro).toStringAsFixed(2);
  dolarControler.text=((euro * this.euro)/dolar).toStringAsFixed(2);

}
void _reset(){
  realControler.text="";
  dolarControler.text="";
  euroControler.text="";

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.black,
      appBar: AppBar(
        title:Text( "\$ Conversor de moedas \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
        IconButton(icon: Icon(Icons.refresh), onPressed: _reset),
        ],
      ),
      body: FutureBuilder <Map>(
        future: getData(),
        builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados...",
                style: TextStyle(color:Colors.amber,
                fontSize: 25.0),
                textAlign: TextAlign.center,) ,
                );
                default:
                if(snapshot.hasError){
                  return Center(
                child: Text("Erro ao Carregar Dados",
                style: TextStyle(color:Colors.amber,
                fontSize: 25.0),
                textAlign: TextAlign.center,) ,
                );
                }
                else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                        buildTextField("Reais", "R\$", realControler, _realChanged),
                        Divider(),
                        buildTextField("Dólares", "US\$", dolarControler, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", euroControler, _euroChanged),
                      ],
                    ),
                  );
                }
            }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
return  TextField(
  controller: c,
     decoration: InputDecoration(
       labelText: label,
        labelStyle: TextStyle(color:Colors.amber),
         border: OutlineInputBorder(),
           prefixText: prefix
             ),
               style: TextStyle(
                color: Colors.amber,fontSize: 25.0
             ),
             onChanged: f,
             keyboardType: TextInputType.numberWithOptions(decimal: true),
           );
}