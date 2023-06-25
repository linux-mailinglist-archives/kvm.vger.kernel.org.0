Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A27773D343
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 21:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjFYTVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 15:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjFYTVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 15:21:07 -0400
Received: from MW2PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012007.outbound.protection.outlook.com [52.101.48.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF42A7
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 12:21:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5pxPI9qepiItE7rjc1CMt2txi9itBWOs2mjgoTAYlULTim3JIvO8+DGoJXh2d9z6G1ztKRbi3C3yHtHZVi3cMovDFRr839B17RT4RA1FfVeSWOTCaQjzyw/SIWMScyCdPsBOS90A/ez4/lj5GD6ODRT5po8HPRSr2Clg/uEc76ELlef+g65PDdT3LIoFhi59dbHjtY1HNFgb/1tjvFtrRWHipRSbAGc7wyNQmzsQtzZh24/HTPfJWzfUzxV+9Hmkwr41bTC2UdotPvWYmosf34SX0pqlDpLZJ38Nd7lK5oukNzVAbDY0m9Dloki67+LgPyCqOqnQSC2bFU0IU6NSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OvPKrlvp/jStZ6atSH+BgEhe+qe9iIVC3b/eoydQRNk=;
 b=QXXqP5ULdVzMMLX5VlipIj5gQwHfSDIl2j4LGIHEgqckSO1rVZiJNK0zOCsidzr48TN6atycgK/H4AsyW0HbAH+3pKUo4mAqjV5zlk3PNMJNOjxq7fYV7972rNtLQpPGz4fXUr+9eTrAgcVOKqZJN/qftbhW6usVQAog1BjErdbaJc2tM5MXPG2KLBkRD/GMpPOPV1e42Gp9yQHwDt3hlmm9fkU3qPzv3vwTVqjV4O7pNDHLQG294w62TvhjLzaHy3qVDFNACYPPVwgwFcikVsZMOfbhqZtZUeOWnU7mKs1GgPpKHdt/8OvrWv8N+sCE7ba2GLfqs4CLvZuaTQL+uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvPKrlvp/jStZ6atSH+BgEhe+qe9iIVC3b/eoydQRNk=;
 b=WTYjbBCy8/pjtzG4GsYKOCKzslkSnwQAgN8f6zDLTVePb5QKbLQGzx1VRJKS4S1vBF/M7aBNBQsg0x62hSFI0VBO4EqxhNgSh+sOFgK23y+KckCAOrn1GkRk8mohRZhpuA/Kj8gScd84FNVYHUHNbwMyBDe0iR+MV9FCdNKRFaE=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by IA1PR05MB9431.namprd05.prod.outlook.com (2603:10b6:208:42d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Sun, 25 Jun
 2023 19:21:01 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a%6]) with mapi id 15.20.6521.024; Sun, 25 Jun 2023
 19:21:00 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andrew Jones <andrew.jones@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/6] arm: keep efi debug information in a
 separate file
Thread-Topic: [kvm-unit-tests PATCH 1/6] arm: keep efi debug information in a
 separate file
Thread-Index: AQHZoL4GZBsAFKw9PkexB+GqtoP+DK+ZzJ+AgAImMYA=
Date:   Sun, 25 Jun 2023 19:21:00 +0000
Message-ID: <9F933A12-3AD8-4D9F-A4D4-99067F59AB1B@vmware.com>
References: <20230617014930.2070-1-namit@vmware.com>
 <20230617014930.2070-2-namit@vmware.com>
 <20230624-774d9b995f86fca17f3d3d89@orel>
In-Reply-To: <20230624-774d9b995f86fca17f3d3d89@orel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|IA1PR05MB9431:EE_
x-ms-office365-filtering-correlation-id: 098ebe0e-3dda-4a3b-7fd2-08db75b14f83
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JF0ZxvaWEsXEJcHOyIpNVqfO9ucMMvqlXWT8h48sWsvi468sWVTXWybLWt13quWhvMX2ZG3lavVEIggDTOF3g/8Pw+UgQlx156nPF6NGw36Ycn1AcvT4k9qCX3Odv1kap0t0z3YkINMZRucEAOcuKnUGXZMIQBsVEgzgusK9QtlUb6Ih2HcrVxctvbfEUvLUKjESVqGTPwXpwqqF/9JJ+oLdc7h43bhXAzk+YTY/Klql9MCpJLBYMhjKp+i9ZJk8lMcFSvUtdFCZFvhtEcIb8hUZL0z7HFYh0iZDznhkdEQCRow7Sc9MLcdSEExLhV7J/qSmjqd/I4ghBg2UlHPvNL8mtWKgS+wxl0awBqFkiL6LkBLz/P5E7wMYPi8s7NzfGJf+AyzoI2T6YA60zAPIHWmfBnTnZcC+3ga8QtUCNME4qD8p5CBo4bl5vLPnOHZNZVx+Sd/Hoyve/viF01NfeIiph9Euj/CBdNq5ucs+Te4tVVnNNAGyCOezBbec1zKjEG9aFLCW8R/gyvJ/QDfPT+Jlv9ujuJ2Jix/W2uLnByX017tK+ph5TUd5+pjE7tsxdcS115lY3ur5LgoakZRCG/tvNW660/MFiWxiuWwXS6B1dRL6dCUtAiwjnrrU16eroZ4UnhcBCtaF9NMVy/kCUPDvlsvc60YS1ImDlHO8y2Gb/WAE/od5cPM9cRr3NeVNERQF8ohtCJk6aSiSqeDrfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199021)(5660300002)(4326008)(76116006)(66946007)(66556008)(66476007)(6916009)(66446008)(33656002)(64756008)(478600001)(36756003)(316002)(8676002)(8936002)(2906002)(54906003)(38070700005)(86362001)(41300700001)(6486002)(53546011)(6512007)(6506007)(26005)(186003)(38100700002)(71200400001)(122000001)(83380400001)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDdUaUdCMXN4TmJXa0h1TTJjelZOUDhBREs3anBIMXpRd2tsWjQvd052UkZR?=
 =?utf-8?B?elg4OG1na3JmamQvckpCK1JGVzdMNDJWbGdHMlJTRUxDMHp3eCs1OHdJZUNI?=
 =?utf-8?B?cUMvakV2K0J4TU03SDFGSU9oQlZ4NlpBY0R6alhxWnpJTHlKRGZ6b2lKUlNP?=
 =?utf-8?B?b2tkU1dyWkJLOEtHQkpiVWk2UkVSUmRFanEzZGY1RzhFcUlZZkdEU0U5dXlR?=
 =?utf-8?B?RklxMExEUG5lTEpvVEpTZVhRSlJYb0pZMGZzV2t2SGRuZXhyVlQ5RE1LTGRh?=
 =?utf-8?B?RGZZT2dZVU5hOWF2K1p5bU1MbEwvUE5lS1VhSkdEN1BhQjVPam9iSDVqR2Jp?=
 =?utf-8?B?bzJMSU0yeVc2MmdxbkYvV2tTTXkvVEc0SVFRNFRsQ0xZTnRuU29RTWRqL0ti?=
 =?utf-8?B?cGh6OXZxWXYzUHc2MzZvZGlVNUlYNHhCbGNGcFJoT2RpTnVPcGRDZ3J4VGI0?=
 =?utf-8?B?TmN2V043d1czY1NCTnRKVTBnUW43WnBaRVY5UlhjZGJGdXdPUEY3L3UvYWhE?=
 =?utf-8?B?YU04WjROeU83LzJjcFZCN0k0MEwwTGVCTmRnSk1jSG1JeUVpMmx2S2dBb0I0?=
 =?utf-8?B?Y2FVajloQ21qM2dTRUhuSE4xemlkR2drOXUySGlyY2lROW5ORXFhNDJ1LzNM?=
 =?utf-8?B?b1hkM2tEOUhFd3BoYUFIUktLNGlacWlzVjN2ems3QUNhVVBGNmJ4VHVGQXl4?=
 =?utf-8?B?dGtnbHB5MEZTRERMUk1iVDFkWU16Nm5mbm9nQmxsekFpRk1LYnZoZ1dGdFZh?=
 =?utf-8?B?bE5EQ0ROY05xSGl3bHJNYUNibXdqdFNBU01qbGJJZ0lYSHhLRkVCZUlEdzVw?=
 =?utf-8?B?dHNBaXN0bUgwZW9jOWkyak1hYmhhcjJnZWlvREk2Y2I4RFB2ckNXYU1VblVs?=
 =?utf-8?B?Q21LWXdCdndmRnVXY0Nlc1kzRnROS0wzSXBGY0NnY0FkdTUwL0ZhbkZvQVdn?=
 =?utf-8?B?NVBkSFZIMjdMK2hVTmlKR3J3TnZxVU9lY0d4MWtNRmRVdkk1QmduL05nUWNG?=
 =?utf-8?B?RUYzdzhiTkp4bjR4QXBSdzNIYVp4U0ozMjg1dlFKOTdrUW41RUNTR0x5UzZt?=
 =?utf-8?B?MkRkd1QvVldhQmlsVXV6M29tVk9ybDBOU0YxR3dPemg3dWtGaUJZWFhONUVE?=
 =?utf-8?B?bUE2STdBemJnWVJlanFSK2ppeVltdFNuOUlsMWs1b1VTOVJsZnRVWklpSzM1?=
 =?utf-8?B?Qzk0Mm03aDFIdkErVFNQV3h6cWUxUjIxOXRySVQ3Tlg0NWFEODE5WmZMMURE?=
 =?utf-8?B?ZkYxWDVkTkJuYUl6NHhQQTdsejBxeXlJU1d5b1FGb1ZYYWVxWjBjcWdaTHdK?=
 =?utf-8?B?RUpGN0d1VCsyWlJoZGkrNUJLa3RlWTJHWnhOdUpPYWZ4YUVrVjBBcmxpclJj?=
 =?utf-8?B?YXR4UEI4akJCVlF3V2FLWjZCQjJ6RWdhb2pwZGdpVzRjaXRoTGRUUXkzZEJq?=
 =?utf-8?B?VDRsY0NXNDlyRFZXcko2bHVXTWZWbmhtekIzVlZqbXo0UGFRakhLYlhFR0h3?=
 =?utf-8?B?LzFCUVZMakxkcUNqeUVqaUNvU1dGZS94anY5cDAzVzV0SGhQdktZRy9YSzJj?=
 =?utf-8?B?NVFFL3N1Qyt1S0ZCdGp5VGUrR2c1U0xrVzNEVDFjUzFsZ2R6S2krWWdXc3V4?=
 =?utf-8?B?c05uVkVmMG9QbW1QTUp1SUU4K2ZqdzdCUU1ZRGZOUW14SE1HblI2aGxkcks4?=
 =?utf-8?B?eFRUK2VXRWp2SitlMWlBNy9NRU1vRHhqNm50eXc2RCtIaUkvbzcvcEFyZUh6?=
 =?utf-8?B?WWRIUnpHVWwveEg0NU9MajhRbFJjNXJEUElIMkNqVVdlMFhNVk4wRTlPakhL?=
 =?utf-8?B?SnZuNHBlTVp2Nlo4ZUovdnpGbHI2U1dZQkhjbEg1b2llc2lSYzFWN1lTbzNp?=
 =?utf-8?B?c1F5NEZ2OCtuSDllNEVITTBGaW9KL0lpdkZFcGNCa29HblV2eWZUWWZvWDRE?=
 =?utf-8?B?MzhYbGUzeHYwdmhxTytweGFiaXNmUkpaaDk4ZkFDdXNjQnNJYXpKZ2JzWTc1?=
 =?utf-8?B?b0dkMnhleXV4Mk9FSzN5ZHZrQm1ZMFl2MEdFS2FLNzFBT3RBUUZuL25WRHc2?=
 =?utf-8?B?MFd1YzJOU1ZEV1VGQ3VCN2dENkQwMlVFRkdONnEyY2xteEpNc3VkeUVwanBx?=
 =?utf-8?Q?FmWkYLypthUSWZe+V+SM51VlA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <842B3F70318DA84DA5DA3CEE8A6DB66E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 098ebe0e-3dda-4a3b-7fd2-08db75b14f83
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2023 19:21:00.6379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nyg6XRVKb6aWysuB7i/F0cgodQI0i25kiZuFRKSvdxPbjOVk6uFnFiKkxPOc+23LOdPloavfM9FisdY6272V9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR05MB9431
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVuIDI0LCAyMDIzLCBhdCAzOjMxIEFNLCBBbmRyZXcgSm9uZXMgPGFuZHJldy5q
b25lc0BsaW51eC5kZXY+IHdyb3RlOg0KPiANCj4gISEgRXh0ZXJuYWwgRW1haWwNCj4gDQo+IE9u
IFNhdCwgSnVuIDE3LCAyMDIzIGF0IDAxOjQ5OjI1QU0gKzAwMDAsIE5hZGF2IEFtaXQgd3JvdGU6
DQo+PiBGcm9tOiBOYWRhdiBBbWl0IDxuYW1pdEB2bXdhcmUuY29tPg0KPj4gDQo+PiBEZWJ1Z2dp
bmcgdGVzdHMgdGhhdCBydW4gb24gRUZJIGlzIGhhcmQgYmVjYXVzZSB0aGUgZGVidWcgaW5mb3Jt
YXRpb24gaXMNCj4+IG5vdCBpbmNsdWRlZCBpbiB0aGUgRUZJIGZpbGUuIER1bXAgaXQgaW50byBh
IHNlcGFyZWF0ZSAuZGVidWcgZmlsZSB0bw0KPj4gYWxsb3cgdGhlIHVzZSBvZiBnZGIgb3IgcHJl
dHR5X3ByaW50X3N0YWNrcyBzY3JpcHQuDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IE5hZGF2IEFt
aXQgPG5hbWl0QHZtd2FyZS5jb20+DQo+PiAtLS0NCj4+IGFybS9NYWtlZmlsZS5jb21tb24gfCA1
ICsrKystDQo+PiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQo+PiANCj4+IGRpZmYgLS1naXQgYS9hcm0vTWFrZWZpbGUuY29tbW9uIGIvYXJtL01ha2VmaWxl
LmNvbW1vbg0KPj4gaW5kZXggZDYwY2Y4Yy4uZjkwNDcwMiAxMDA2NDQNCj4+IC0tLSBhL2FybS9N
YWtlZmlsZS5jb21tb24NCj4+ICsrKyBiL2FybS9NYWtlZmlsZS5jb21tb24NCj4+IEBAIC02OSw3
ICs2OSw3IEBAIEZMQVRMSUJTID0gJChsaWJjZmxhdCkgJChMSUJGRFRfYXJjaGl2ZSkgJChsaWJl
YWJpKQ0KPj4gaWZlcSAoJChDT05GSUdfRUZJKSx5KQ0KPj4gJS5zbzogRUZJX0xERkxBR1MgKz0g
LWRlZnN5bT1FRklfU1VCU1lTVEVNPTB4YSAtLW5vLXVuZGVmaW5lZA0KPj4gJS5zbzogJS5vICQo
RkxBVExJQlMpICQoU1JDRElSKS9hcm0vZWZpL2VsZl9hYXJjaDY0X2VmaS5sZHMgJChjc3RhcnQu
bykNCj4+IC0gICAgICQoQ0MpICQoQ0ZMQUdTKSAtYyAtbyAkKEA6LnNvPS5hdXgubykgJChTUkNE
SVIpL2xpYi9hdXhpbmZvLmMgXA0KPj4gKyAgICAgJChDQykgJChDRkxBR1MpIC1jIC1nIC1vICQo
QDouc289LmF1eC5vKSAkKFNSQ0RJUikvbGliL2F1eGluZm8uYyBcDQo+PiAgICAgICAgICAgICAg
LURQUk9HTkFNRT1cIiQoQDouc289LmVmaSlcIiAtREFVWEZMQUdTPSQoQVVYRkxBR1MpDQo+PiAg
ICAgICQoTEQpICQoRUZJX0xERkxBR1MpIC1vICRAIC1UICQoU1JDRElSKS9hcm0vZWZpL2VsZl9h
YXJjaDY0X2VmaS5sZHMgXA0KPj4gICAgICAgICAgICAgICQoZmlsdGVyICUubywgJF4pICQoRkxB
VExJQlMpICQoQDouc289LmF1eC5vKSBcDQo+PiBAQCAtNzgsNiArNzgsOSBAQCBpZmVxICgkKENP
TkZJR19FRkkpLHkpDQo+PiANCj4+ICUuZWZpOiAlLnNvDQo+PiAgICAgICQoY2FsbCBhcmNoX2Vs
Zl9jaGVjaywgJF4pDQo+PiArICAgICAkKE9CSkNPUFkpIC0tb25seS1rZWVwLWRlYnVnICReICRA
LmRlYnVnDQo+PiArICAgICAkKE9CSkNPUFkpIC0tc3RyaXAtZGVidWcgJF4NCj4+ICsgICAgICQo
T0JKQ09QWSkgLS1hZGQtZ251LWRlYnVnbGluaz0kQC5kZWJ1ZyAkXg0KPj4gICAgICAkKE9CSkNP
UFkpIFwNCj4+ICAgICAgICAgICAgICAtaiAudGV4dCAtaiAuc2RhdGEgLWogLmRhdGEgLWogLmR5
bmFtaWMgLWogLmR5bnN5bSBcDQo+PiAgICAgICAgICAgICAgLWogLnJlbCAtaiAucmVsYSAtaiAu
cmVsLiogLWogLnJlbGEuKiAtaiAucmVsKiAtaiAucmVsYSogXA0KPj4gLS0NCj4+IDIuMzQuMQ0K
Pj4gDQo+IA0KPiBXZSBhbHNvIG5lZWQgYSBjaGFuZ2UgdG8gYXJtX2NsZWFuIHRvIGNsZWFuIHRo
ZXNlIG5ldyBmaWxlcyB1cC4gT3IsIHNpbmNlDQo+IHdlIHByb2JhYmx5IHdhbnQgdGhlbSBmb3Ig
eDg2IGFzIHdlbGwgYW5kIHdlIGFscmVhZHkgaGF2ZSBvdGhlciBlZmkNCj4gY2xlYW51cCB0byBk
bywgdGhlbiBtYXliZSB3ZSBzaG91bGQgaGF2ZSBhIGNvbW1vbiBlZmlfY2xlYW4gaW4gdGhlIHRv
cC0NCj4gbGV2ZWwgTWFrZWZpbGUgd2hpY2ggeDg2J3MgYW5kIGFybSdzIGNsZWFuIHVzZSB0byBj
bGVhbiB1cCBhbGwgZWZpIHJlbGF0ZWQNCj4gZmlsZXMuDQoNClsgSSBhZ2dyZWdhdGUgbXkgcmVz
cG9uc2UgdG8gYm90aCBvZiB5b3VyIGVtYWlscyBdDQoNClRoYW5rcyENCg0KSSB3aWxsIGNyZWF0
ZSAuZGVidWcgZmlsZXMgZm9yIHg4NiwgYnV0IEkgYW0gZ29pbmcgdG8gcmVtb3ZlIHRoZSDigJgt
Z+KAmSBvcHRpb24uDQpJZiBhbnlvbmUgd2FudHMgaXQsIGhlIHdvdWxkIG5lZWQgdG8gcHJvdmlk
ZSBDRkxBR1MgZHVyaW5nIGNvbmZpZ3VyZS4NCg0KSSB3aWxsIGNsZWFudXAgdGhlIC5kZWJ1ZyBm
aWxlcyBmb3IgZWFjaCBhcmNoIHNlcGFyYXRlbHkgc2luY2Ugb3RoZXIgZmlsZXMNCmFyZSBjbGVh
bnVw4oCZZCB0aGF0IHdheS4NCg0K
