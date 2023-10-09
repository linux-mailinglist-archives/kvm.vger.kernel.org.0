Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A543F7BD20A
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 04:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345004AbjJICpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 22:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjJICpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 22:45:01 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2065.outbound.protection.outlook.com [40.107.117.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5264EAB;
        Sun,  8 Oct 2023 19:44:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pf+ICbrFp+sM9FslOOqMZgWAKy6vdutV3cmvS0EZioVz3p9VTmSDIIVJCXdOK0OkVrgPWsQUkV8Mx8s3UuvToVs/tUgtloQtLEICFkwbUck6KMqLsZjUdgc4dh493fRGX/yo+44EtJ719Lmqvhx0tsYD+VYdho554x6HxFzePFiLDk1tUMKmW88NU33ULJn0lGU/NsXCE1V9cmEbzeebEn5R3aKCpWcgQ52Dyv4tmgkrLp1xz8isxoU9tLXXRYdrocz2FsdqpWAbyJsQMueflI8OzRd9wOFs0AnIIKatzeVyD7YQsadqRMRBYGk1GR6cy7AiR9u6+DxA1TTWOrZ/WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etuuW4P4mTwK+bdxnpOgFnFGgmrjKgri1BI3zFeuYBc=;
 b=Ita93t6nsronEzq7ga4ElAu6tqSSIIYb2re9nf7XHdG3ht9YUvroFKBrVRXziifoLEdOBuO+qqU12u9YzDVMFAoDvbPsh3aP/u0yC24Y2Hg4etL00++xnSvcRZtDodOVT6aFzgestKU/TIlFZJmZFVLwNlhK1xi1lfiGl7z2Us6fGvM3mB9ezFpi4pfdU6oyThNjgKVJj6cnU33J6PVlo0oM9WxsUueVK/ePKZsrMgt5KA67YqUD4+5nACIeAn/oAv3xzY5uw10RriJX8qgKK74I4l8tLTCBh85jTMIvlY0BflZkJ3Qhl6atS9KqRzjtDD4D9NtZo2viFLXbhgzmcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etuuW4P4mTwK+bdxnpOgFnFGgmrjKgri1BI3zFeuYBc=;
 b=jY0RrilTWFQ+hulv6PqwUj3vhe2jW7OUBMAU6G+OMdQpAZetRfu4MBPkKEDTDCXrXwmocwpvhHe2O5o/imil25uXjLW1OjLe8Eo00hWU08XFw/8J+V35K0Dw4QorVH8bQVXIBG5UAuCCWTQin8CQ3BPClxhwa5yvkHYvnCG2HkM/Sz+oqx5uEqmD2I2Kqkx/kT2LMrn0I+TVacLZXH42etsQ2FPNWn28gXCIp3GXA6JeW4jHofbO/YL3ivZbcFACnNoj+vZ6AuEBzkuuLNzxemF9GA/vvLmBirzE4DVn1k46KDj2wlvmEMWuyaiUGU/kNaZXB/Br4FFo+m97D5wCCw==
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by TYZPR06MB5370.apcprd06.prod.outlook.com (2603:1096:400:1f1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Mon, 9 Oct
 2023 02:44:56 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd%4]) with mapi id 15.20.6863.032; Mon, 9 Oct 2023
 02:44:55 +0000
From:   Liming Wu <liming.wu@jaguarmicro.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Michael S . Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "398776277@qq.com" <398776277@qq.com>
Subject: RE: [PATCH 2/2] tools/virtio: Add hints when module is not installed
Thread-Topic: [PATCH 2/2] tools/virtio: Add hints when module is not installed
Thread-Index: AQHZ8DZkHxOeTkT7QUeUsqhNEqlG57A/YU8AgAFyauA=
Date:   Mon, 9 Oct 2023 02:44:55 +0000
Message-ID: <PSAPR06MB3942238B1D7218934A2BB8B4E1CEA@PSAPR06MB3942.apcprd06.prod.outlook.com>
References: <20230926050021.717-1-liming.wu@jaguarmicro.com>
 <20230926050021.717-2-liming.wu@jaguarmicro.com>
 <CACGkMEujvBtAx=1eTqSrzyjBde=0xpC9D0sRVC7wHHf_aqfqwg@mail.gmail.com>
In-Reply-To: <CACGkMEujvBtAx=1eTqSrzyjBde=0xpC9D0sRVC7wHHf_aqfqwg@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR06MB3942:EE_|TYZPR06MB5370:EE_
x-ms-office365-filtering-correlation-id: f77448a6-f59c-4e8b-0cc0-08dbc871b8b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cTBazXIjpWZ/WpNWG9wUVYXT/gdUZS++VUm5KrZD3Lcbz75z6QI0fwGERhLAWs1csjeFDBKDKHBxpyloMysz263DhcbPoisUGrsYoQiJgqzZcyE19FKWzdQIm3jFW0vOVL2yunR7tRso0AxPBOHMaFSjiBnfgYtglt1fOPb2DIvxF9kZKs84hgN0j7Jh4Z/ec3uxgS8NXO/TynDHRvOQcLuiLhaEs8GU6P+o2eynHexIkeSzpmupFU6l8tsg7hbj1nKzl1QaVcuulQztu2CqvW2KiSC6mpzHvlavehXkwXIx+MAJrl2dg4ptxYjRbKEhnW8m1RBsBw8xx+x0gP2G7pP7riZo6MiEZQzlInGhnvDiVD1i3xrJZ+k2PjGRrS4BpgimNIvEfkxpzNsThOIiU2gbGmd+GDbyn4kVpwaEoeOf9BClHlSHDEiiLuTcfSwPWljVDv67iP8MDaC0lGig41FIS7dG8otiXCxKnYGE84tWv77fQO0Eke0YxY7Y+yaQFqOyyeOX9HW8LrI7pRDf7nt/M5ret8pohd/LZIH+3p4QLa3Ub+ckAvF7FmVUJEpcGsbSJIyicbJeR0qgoLIEL3FkKhO+j31J85jBCv0R5X3SmojT2m9GpDNVXVbs2WKT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39830400003)(376002)(136003)(366004)(346002)(396003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(55016003)(83380400001)(66946007)(26005)(316002)(66476007)(66556008)(66446008)(54906003)(76116006)(6916009)(64756008)(8936002)(8676002)(4326008)(5660300002)(52536014)(41300700001)(44832011)(7696005)(53546011)(6506007)(71200400001)(9686003)(2906002)(478600001)(33656002)(38070700005)(38100700002)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTJkeXhlVDM1a042ZEdjSm9HZnZVN1ZvR2FidURCK2pUNkluUGd1YjMwRld2?=
 =?utf-8?B?WXJsYWlhVVBwTitpSEZOQlNnb0dkbjNxUWxXQzk0a0F1RXhTKzJRaGp4R0Rn?=
 =?utf-8?B?bzJHKysxMUdDQ1FLZlJBdE1FM1AzN3h4RXpXR3lzd1ROUWxsY2daTk43V0Ja?=
 =?utf-8?B?Wm03MkhvbUp0eVVCdUVBdTlwcUZjRU1zbEdzamJFbVY2MldGQk0yQUFFU3hm?=
 =?utf-8?B?U21DK0hoQlg4S3E1MUdoNEpJcGxZNUkrdmsrZGZ6V1RUTXkrMzBpaVFEcU5u?=
 =?utf-8?B?aFE1VVIwVlJlL2l0RlRSZnlHVlpRazdGWUZqb0FieUszZ0VUU3JsWmszNDl4?=
 =?utf-8?B?UnpCVWVSRzRLMVJ3SllGY1U5VDdZSDZyc3FDNG1aUHI0cU9lT2l1ckxqdkNm?=
 =?utf-8?B?MmlnODNoay9Qck9zVjJFVlpVUTNuUTg2K1FUdU5XcW5Fd2NxZzdtRXMzNFor?=
 =?utf-8?B?N0JlY0VIM1F0QjhlakNQWUV2RGIyeWNoN1hiRldVUXRFem5NUUhjdVE2b25u?=
 =?utf-8?B?TExHSXg2VEhuenZ1dWh4aG9DaUtrU1pxWVAvOEpYR3dJOWsrV2lwMVNEV0li?=
 =?utf-8?B?S2piWm8zb01EY0RRdkQyNE5hd1JVdGxGSVgxWHBteWlYalFBOWhzK0pDcW9C?=
 =?utf-8?B?S09IK0hNaFFVRHVlK3czeXV4VFQxUlduVE1oR29TV1FZbks3YVptM21ISllF?=
 =?utf-8?B?eFRqSzhoQlNSNzZIcTVJN2Y0bENlREpBSWRLOFlGSlR0cGN3TzhYR0diaWNp?=
 =?utf-8?B?Tk9EVlFFZC9KQ05vTzNnckI5cU9lSXFQZFUwTTBlTm9Lemg1ckdoMGJNY2dJ?=
 =?utf-8?B?c0ZnVm1teXVVZGFTanduRS9jbXV3UTBqdG9nNXdWWGhlZ3Fzdng2T1NUalYr?=
 =?utf-8?B?SWlMY1UrcmFrdUd1a0JHYllISHZjbFlPRU9qYjFIQUUzdndCK1FKOWRnM2Qr?=
 =?utf-8?B?R1ZBTHlLTk5GaVFMYmxaaFRnbmI4SFJXblFhUXRJcGN0WGFsQU9yTEcyQkZG?=
 =?utf-8?B?K1FOT21mY0w0Y0IxRWJrK3p2ZmJIZmNUeHcxTE9IZkFXcUQzMWJCOHdDSEhk?=
 =?utf-8?B?WndRSG9NTWNINWZIbXJIVk5raDY0T2dWcEROd1VSdmlubkc1RU9ydHRPYklX?=
 =?utf-8?B?TUFzTXVHUVhYSXJHOHZ1eDhGU2NNNFlndmhrNUZ5dmJxZWx5TjlLTzBaNjBj?=
 =?utf-8?B?WXNUa3dSL1hHVjl3aUloTzcxeFlxY1BMUysra3cyLzlTd2xEd3JDc0dCblNZ?=
 =?utf-8?B?VjdKMGdmMzJHU05DOFhwcFJ1Qm1acytzUStNQUpSZVBWYVQrZ2JZRkNJYzBn?=
 =?utf-8?B?cVJoYXpQQ015N1d4a05WRzNZQjhwREppcW12TFJzUjFJRmFwcnYxNGVoUEY3?=
 =?utf-8?B?VE1LMTVjV2VXUDF5RVZ4SHlTdGUxcWpqNW52NTZoT2lZa0w1WmhoRk0zUUZW?=
 =?utf-8?B?SkNxcXBaUkI3bmtYQXJnNTZiL0ZoMzJQZndkVjlPdFdTV2pTdkM2YmFqSlN2?=
 =?utf-8?B?NTROUkRiamRkSDc3dUNweGhzMW5ORk90aVhaMFg5TU1aUVdIZDVGNUtlZnJL?=
 =?utf-8?B?aEhKcjUrTitnWVphSVpBT2xnK280UUgveHNZZS85eDRrTkRhMmtPdEw4ak12?=
 =?utf-8?B?bUdwREkrTGVsMXBRNkV0WXBjTzRCWnBvWjlzcSszY1Vlbms5aDAzOSt2b1R3?=
 =?utf-8?B?NjBNU0pFeW9VT09kVk1kNGFEQjAyL01BaVNobGRadlJzNFU3enlTcTBVa3Ix?=
 =?utf-8?B?UTNpbnVqSXRpcmFTOUFERERhS3FzS3F1YXdycUQzYXhkMzI5TmQxNWE2blgz?=
 =?utf-8?B?TnAyVUtmQ2tpTSs0b2R1RVUrZ1MyZGxqY3h3N1Z5TnA2azJ3QnF3bUF2M3Jt?=
 =?utf-8?B?eFkwY3ZLdnBTTHVZbDBhcFRGN3I1OWJhdHd2UmtsNC9hLzBtZCs2TVZyekRL?=
 =?utf-8?B?LzZtOHhER3RrUXJwRlFqUEVJMG9oaDhmbWZTRHFrSjZ6YjN5RHlwakFXeVVz?=
 =?utf-8?B?NytiK3dFaGlHcUUzMUpMWEJjUDk1anRTTTJZT2ovU3l6cUh2V0VLSmJMVGcy?=
 =?utf-8?B?bGZycU0vMlpycVZlaWpUY244M1FnZ1pGa05Pa3hBVjh1OFQxZnNIdmdxc2lR?=
 =?utf-8?Q?/LwUxAbEchsh9NLRj3Zusak0k?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f77448a6-f59c-4e8b-0cc0-08dbc871b8b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2023 02:44:55.8158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r9uSokWAcx14mW1l3Wuwkp0UKIHhTzZssJxOANRtm0EYZtzrbmAjjkua4zVO/Nd6M1Wv1NOxZ2DXT9IjLAy4noKq7Gc18+/PM7fHhtPObNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5370
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gV2FuZyA8amFz
b3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogU3VuZGF5LCBPY3RvYmVyIDgsIDIwMjMgMTI6MzYg
UE0NCj4gVG86IExpbWluZyBXdSA8bGltaW5nLnd1QGphZ3Vhcm1pY3JvLmNvbT4NCj4gQ2M6IE1p
Y2hhZWwgUyAuIFRzaXJraW4gPG1zdEByZWRoYXQuY29tPjsga3ZtQHZnZXIua2VybmVsLm9yZzsN
Cj4gdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyAzOTg3NzYyNzdA
cXEuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi8yXSB0b29scy92aXJ0aW86IEFkZCBoaW50
cyB3aGVuIG1vZHVsZSBpcyBub3QgaW5zdGFsbGVkDQo+IA0KPiBPbiBUdWUsIFNlcCAyNiwgMjAy
MyBhdCAxOjAw4oCvUE0gPGxpbWluZy53dUBqYWd1YXJtaWNyby5jb20+IHdyb3RlOg0KPiA+DQo+
ID4gRnJvbTogTGltaW5nIFd1IDxsaW1pbmcud3VAamFndWFybWljcm8uY29tPg0KPiA+DQo+ID4g
TmVlZCB0byBpbnNtb2Qgdmhvc3RfdGVzdC5rbyBiZWZvcmUgcnVuIHZpcnRpb190ZXN0Lg0KPiA+
IEdpdmUgc29tZSBoaW50cyB0byB1c2Vycy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpbWlu
ZyBXdSA8bGltaW5nLnd1QGphZ3Vhcm1pY3JvLmNvbT4NCj4gPiAtLS0NCj4gPiAgdG9vbHMvdmly
dGlvL3ZpcnRpb190ZXN0LmMgfCA0ICsrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0
aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL3Rvb2xzL3ZpcnRpby92aXJ0aW9fdGVzdC5j
IGIvdG9vbHMvdmlydGlvL3ZpcnRpb190ZXN0LmMNCj4gPiBpbmRleCAwMjhmNTRlNjg1NGEuLmNl
MmM0ZDkzZDczNSAxMDA2NDQNCj4gPiAtLS0gYS90b29scy92aXJ0aW8vdmlydGlvX3Rlc3QuYw0K
PiA+ICsrKyBiL3Rvb2xzL3ZpcnRpby92aXJ0aW9fdGVzdC5jDQo+ID4gQEAgLTEzNSw2ICsxMzUs
MTAgQEAgc3RhdGljIHZvaWQgdmRldl9pbmZvX2luaXQoc3RydWN0IHZkZXZfaW5mbyogZGV2LA0K
PiB1bnNpZ25lZCBsb25nIGxvbmcgZmVhdHVyZXMpDQo+ID4gICAgICAgICBkZXYtPmJ1ZiA9IG1h
bGxvYyhkZXYtPmJ1Zl9zaXplKTsNCj4gPiAgICAgICAgIGFzc2VydChkZXYtPmJ1Zik7DQo+ID4g
ICAgICAgICBkZXYtPmNvbnRyb2wgPSBvcGVuKCIvZGV2L3Zob3N0LXRlc3QiLCBPX1JEV1IpOw0K
PiA+ICsNCj4gPiArICAgICAgIGlmIChkZXYtPmNvbnRyb2wgPCAwKQ0KPiA+ICsgICAgICAgICAg
ICAgICBmcHJpbnRmKHN0ZGVyciwgIkluc3RhbGwgdmhvc3RfdGVzdCBtb2R1bGUiIFwNCj4gPiAr
ICAgICAgICAgICAgICAgIiguL3Zob3N0X3Rlc3Qvdmhvc3RfdGVzdC5rbykgZmlyc3RseVxuIik7
DQo+IA0KPiBUaGVyZSBzaG91bGQgYmUgbWFueSBvdGhlciByZWFzb25zIHRvIGZhaWwgZm9yIG9w
ZW4oKS4NCj4gDQo+IExldCdzIHVzZSBzdHJlcnJvcigpPw0KWWVzLCAgVGhhbmtzIGZvciB0aGUg
cmV2aWV3LiANClBsZWFzZSByZWNoZWNrZWQgdGhlIGNvZGUgYXMgZm9sbG93Og0KLS0tIGEvdG9v
bHMvdmlydGlvL3ZpcnRpb190ZXN0LmMNCisrKyBiL3Rvb2xzL3ZpcnRpby92aXJ0aW9fdGVzdC5j
DQpAQCAtMTM1LDYgKzEzNSwxMSBAQCBzdGF0aWMgdm9pZCB2ZGV2X2luZm9faW5pdChzdHJ1Y3Qg
dmRldl9pbmZvKiBkZXYsIHVuc2lnbmVkIGxvbmcgbG9uZyBmZWF0dXJlcykNCiAgICAgICAgZGV2
LT5idWYgPSBtYWxsb2MoZGV2LT5idWZfc2l6ZSk7DQogICAgICAgIGFzc2VydChkZXYtPmJ1Zik7
DQogICAgICAgIGRldi0+Y29udHJvbCA9IG9wZW4oIi9kZXYvdmhvc3QtdGVzdCIsIE9fUkRXUik7
DQorDQorICAgICAgIGlmIChkZXYtPmNvbnRyb2wgPT0gTlVMTCkNCisgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwNCisgICAgICAgICAgICAgICAgICAgICAgICIlczogQ2hlY2sgd2hldGhl
ciB2aG9zdF90ZXN0LmtvIGlzIGluc3RhbGxlZC5cbiIsDQorICAgICAgICAgICAgICAgICAgICAg
ICBzdHJlcnJvcihlcnJubykpOw0KICAgICAgICBhc3NlcnQoZGV2LT5jb250cm9sID49IDApOw0K
ICAgICAgICByID0gaW9jdGwoZGV2LT5jb250cm9sLCBWSE9TVF9TRVRfT1dORVIsIE5VTEwpOw0K
ICAgICAgICBhc3NlcnQociA+PSAwKTsNCiANClRoYW5rcw0KDQo=
