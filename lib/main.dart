import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrawingBoard(),
    );
  }
}

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({Key? key}) : super(key: key);

  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  double? dx=0,dy=0, dxCurrent=0,dyCurrent=0;
  static late  Offset offset1,offset2;
  List<DrawingPoint?> drawingPoints = [];
  List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GestureDetector(
          onPanStart: (details) {
            setState(() {
              dx=details.localPosition.dx;//mine
              dy=details.localPosition.dy;//mine
              offset1=details.localPosition;//mine
              drawingPoints.add(DrawingPoint(
                details.localPosition,
                Paint()
                  ..color = Colors.teal
                  ..isAntiAlias = true
                  ..strokeWidth = strokeWidth
                  ..strokeCap = StrokeCap.round,
              ));
            });
          },
          onPanUpdate: (details) {
            setState(() {
              offset2=details.localPosition;//mine
              dx=details.localPosition.dx;//mine
              dy=details.localPosition.dy;//mine
              drawingPoints.add(DrawingPoint(
                details.localPosition,
                Paint()
                  ..color = selectedColor
                  ..isAntiAlias = true
                  ..strokeWidth = strokeWidth
                  ..strokeCap = StrokeCap.round,
              ));
            });
          },
          onPanEnd: (details) {
            setState(() {
              drawingPoints.add(null);
            });
          },
          child: CustomPaint(
            painter: _DrawingPainter(drawingPoints),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 30,
          child: Row(
            children: [
              Slider(
                  min: 0,
                  max: 40,
                  value: strokeWidth,
                  onChanged: (val) => setState(() => strokeWidth = val)),
              ElevatedButton(
                onPressed: () => setState(() => drawingPoints = []),
                child: Row(
                  children: [Icon(Icons.clear), Text('Clear Board')],
                ),
              ),
              Text('x=${dx!.round()}'),//mine
            ],
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                colors.length, (index) => _buildColorChose(colors[index])),
          ),
        ),
      ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        height: isSelected ? 55 : 40,
        width: isSelected ? 55 : 40,
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(
                    color: Colors.white,
                    width: 3,
                  )
                : null),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?>? drawingPoint;
  List<Offset> offsetList = [];

  @override
  void paint(Canvas canvas, Size size) {
    /*for (int i = 0; i < drawingPoint!.length; i++) {
      if (drawingPoint![i] != null && drawingPoint![i + 1] != null) {*/
        /*canvas.drawLine(drawingPoint![i]!.offset, drawingPoint![i + 1]!.offset,//TODO instead of drawLine
            drawingPoint![i]!.paint);*/

        /*canvas.drawLine(_DrawingBoardState.offset1, _DrawingBoardState.offset2,//TODO instead of drawLine
            drawingPoint![0]!.paint);//mine*/
        double radius = sqrt(pow(_DrawingBoardState.offset1.dx-_DrawingBoardState.offset2.dx,2)+
            pow(_DrawingBoardState.offset1.dy-_DrawingBoardState.offset2.dy,2));
        print('radius = $radius');
        Paint paint= Paint()
          ..color = Colors.amber
          ..isAntiAlias = true
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round;
        //canvas.drawCircle(_DrawingBoardState.offset1, radius, paint,);
        Rect rect = Rect.fromPoints(_DrawingBoardState.offset1, _DrawingBoardState.offset2);

        canvas.drawOval(rect, paint);
      /*} else if (drawingPoint![i] != null && drawingPoint![i + 1] == null) {
        offsetList.clear();
        offsetList.add(drawingPoint![i]!.offset);

        canvas.drawPoints(
            PointMode.points, offsetList, drawingPoint![i]!.paint);
      }
    }*/
    // TODO: implement paint
  }

  _DrawingPainter(this.drawingPoint);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
  }
}

class DrawingPoint {
  Offset offset;
  Paint paint;


  DrawingPoint(this.offset, this.paint);
}
