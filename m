Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6609075405D
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 19:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbjGNRUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 13:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjGNRUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 13:20:17 -0400
Received: from MW2PR02CU002.outbound.protection.outlook.com (mail-westus2azon11013008.outbound.protection.outlook.com [52.101.49.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678BB1BC9
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 10:20:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ae5uRGjrc2yYhSmesz8UAlL9YOYOc5qLsUls9a1AE55oPUs6RIJfnueJL4bmuIOsZWN3X0O7QAV3dlOut9gMLRD1/L+QloSj0OwKabDGBGPjjLF4WQDlkWUP9WuOsCdWSXR0LfHfBuo6UFWkPdm75M2VS4Kkd3LAAGkqCnTudzvwYUurMKnExEWk3JJFwoOmXybQw79NwZuMja8kZfcZufodydnk4EA9qI4PrQU89JxuQS1rC9MQrHhJ7joJGaTLuXv+2ngd3XW10HxUPfj41hyjEpqJKLjFEv2Psc1qzXwnkUMHW/7HgWQD5vwnS3GPKG96348Sot27aVsQSRi7Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5X7ir25eyHMp/IY4t9DnoMbfTle/GGEdlvZu6SZN5M=;
 b=jQJXL9uttKkWgjMD1TzTWJY5NJiIpJrE831h0HWdgkKTRX9oYwX+P7aWiwRA6cLxmNtfD+3Qr8ijoNVIzNDwUoM2ldinFCAXgoBmt8Z3m1caCeyngOBmlC7xqf8aUBJqda+vnLNmOMC5kgTJosQ1fLNzV+mEWqealWDuCYqU9BOvwqOtuR9LbhEECYoM+e9CxiuJyuT2lDcabCN2dVZ5GkZ8Ezvpbwip2vJxugwSbDS1+hd4upT2a6Otz6fLoPHzzHkiu/0RYAdPb8Y9ZSCACvrBVGgbaODNWzGXBCjvfQiWRTyklERnckoFLHpcfUodzNf6dGURVt3ldf4vlXGr0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5X7ir25eyHMp/IY4t9DnoMbfTle/GGEdlvZu6SZN5M=;
 b=H/JGET7OU15aR1na7DaXhy783tt3fzgVt+zbqpoWjf7dxB0PQeIsmKMaF9Odme1uR1cca57tvfKZi3AmQVpRHqJR6/RkdgH/UKGTzGaJAWQY/eOF+IL7yYXKq2YnFLSbZC4CUcpbvdyTWEVNE+D8XafgLPlMlFl3o1Yh+lwJYPg=
Received: from SA1PR05MB8534.namprd05.prod.outlook.com (2603:10b6:806:1dd::19)
 by SN7PR05MB7551.namprd05.prod.outlook.com (2603:10b6:806:102::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Fri, 14 Jul
 2023 17:20:14 +0000
Received: from SA1PR05MB8534.namprd05.prod.outlook.com
 ([fe80::b4eb:7a17:62c8:72c9]) by SA1PR05MB8534.namprd05.prod.outlook.com
 ([fe80::b4eb:7a17:62c8:72c9%3]) with mapi id 15.20.6588.027; Fri, 14 Jul 2023
 17:20:13 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
CC:     Andrew Jones <andrew.jones@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 2/2] arm64: ensure tlbi is safe
Thread-Topic: [kvm-unit-tests PATCH 2/2] arm64: ensure tlbi is safe
Thread-Index: AQHZoLuV480luUQQNUeU49oQ76lU7q+5QdkAgABriYA=
Date:   Fri, 14 Jul 2023 17:20:13 +0000
Message-ID: <CCDDCFF3-C580-494A-B542-00C0A99B11D1@vmware.com>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-3-namit@vmware.com>
 <ZLEoL8NbvmRNysJF@monolith.localdoman>
In-Reply-To: <ZLEoL8NbvmRNysJF@monolith.localdoman>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR05MB8534:EE_|SN7PR05MB7551:EE_
x-ms-office365-filtering-correlation-id: d6843999-2cf6-4c71-6d65-08db848e95ee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YR+5ci4SmlrverrrS9s8YMW84Uri19RQOCboi2/itm5YkPzGLOwCRKHNn3ZaYbgPCjeR0B8Q+KZPLriYokntSC3YppwVExYgS8NY4woKQJ+xFh0rsswZyEQfaLWcQw56aKNvY/UKUqeMJDKbR5Q0S+sjHsjAPdr3GU5146+Bi0xlAE/vGHi0fkqrcciOIhiwm99eIg1nxWSL1PDBeVSB/C1CxFZ7Rw+wd7o1SCGdLw9kYb/F21nCWXuHrqfmSQuIGejh9nJrGTDyDjnx8tdrMOVMqnbYF1XSz71UGksQFPTMhNJeitOyra4UiggnPe4XQYa1FiPePMsu/5iz3gavfsONUtXMKc4oVFGygCdwdpwNYQosLZ+3zHvzcLUX4nHPhvlAxTS+KrZSyAEcCK2gfLuctzJn7zB4rt7tt87KjL00CXKeFz3PTuwxg5UZUeexGkCN6AyZ+yBaK5AKuf+MVS0UeCGdy8poYa333uzurg6ks4HyvjVrdmT4kIu/sw73++Pka51ryr2usgs5eUdRaN4L8rXp7wf1yAAN5tiBWplzvWUbSsdRrO8WRocFbFFrc3EbNdaxB7jWeDLssKYASasTOZ3ZDvlY+xIOWJ6xZ/8jN6fGmQVh+STJcQr7bgmAo+KxeJVU9hBwhflDawHgRUl59k2SoVjTEMmq6uWAPGw4RLZp6skC9lm9JUjo8v6I6n1H+PqLQAT1RWf4JD1hLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8534.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199021)(71200400001)(316002)(6512007)(6486002)(4326008)(54906003)(66446008)(122000001)(91956017)(66476007)(38100700002)(76116006)(38070700005)(478600001)(36756003)(66946007)(2906002)(64756008)(66556008)(6916009)(2616005)(83380400001)(5660300002)(8676002)(8936002)(186003)(6506007)(26005)(33656002)(41300700001)(53546011)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amg4dkN3K3dvcElRYVJqbVIweXE4KzloZnNaTGphM3FvTmxDTTJPM0YvMVJR?=
 =?utf-8?B?UlZSVk1Ud05GTUhhbTlUUVlZSFIxNzNuajBoUG9OTjBKcmpxd0VneW55T2d6?=
 =?utf-8?B?ZjcvK2hMWTVOQkZxQjRkZHZPMTJkQjZudUs2UDFIbWU3ZmNyTG5leFRJOTJS?=
 =?utf-8?B?eU1SRkJyTmJ2VWRUSFB6UnNjZUlHQkgrazJLLzMwbHFZQjJUZzBsYnR2VnBl?=
 =?utf-8?B?bE5iQzJBanVPbzE2VG1XUHMwZjJUV0hrS2hvTlVieWc2MjBUS0NlL3hoMzhK?=
 =?utf-8?B?WlVnRUIvSTBBYzhJRnZFalljMUtHREJuMk01L3ZKVlJZVHFjWksyS0FscUJh?=
 =?utf-8?B?L0F2ZDljV1VTN29wY2tDWGZ1T0dzK1Z3NTVpdkRBTCtLYXVTcjZsWkIwV1hE?=
 =?utf-8?B?bFBYMHV6di8yT2ViZHlaaWNLeXVwRXp3QXBxMmRnU3NrMFJOd3doZlM4dDNL?=
 =?utf-8?B?Y0JzUEtIcTlyWkJlOHdoQ3VHVzQ2bDRWRzRINlgzR0U1SDNLQWdjb1JTSytW?=
 =?utf-8?B?dWhJcUptQThrVE1QUWZ2eHYzbmlvYkJXVDNjOSs1VVR1UmcyaEZyVVBKMnN5?=
 =?utf-8?B?QVdSbDc4RE1MUUErV0JQK2J1V0FORTRjZE14aHBJVzhhRXB4ejJqaWJkVXF0?=
 =?utf-8?B?WnllWkRacmVyQ1JxaTBYYTZNZTNpc3JVZ2ZMZzFnVWZkNDVWcHVQSXZLRXFz?=
 =?utf-8?B?aWRsbGFmTlpqZVUzd28wM1RtWGsrL2k4OS9oTE5BcFVEaHVvYXZoa1VJa04r?=
 =?utf-8?B?YkFkU3BpSW9VNVJmNW82anZRTFRXM1hMTTMwdUtTQ3hFdDNudTFKZEVLbjdI?=
 =?utf-8?B?eCs2UlpGTGpidzE2MkFrZ1dsYUp5MHVuQWlIeU1RR2o5dWdFUjFLNndRdHNp?=
 =?utf-8?B?RE1SOW4rVEpvUjlac0s5ZGRudVAvKzdtUnRLVkxxRVZDZVdQbzcxb3ZqVVFk?=
 =?utf-8?B?SjlIMWZIbXhYNHhoQVcyTTNiZ1grb3U5NXk3NWZRbWRYQXlKTHlBZHZxWERL?=
 =?utf-8?B?U0RBczJUNFA0eGJHYmJuNHNSb08wdGcwUG5HNWVGTUhWSi9LeFNFNi9GTDJY?=
 =?utf-8?B?Umw5VVZxV0xsQUlJQjFDNEVTZUlXTW01YyszZTZJQjRQcmtKakE1Q0dYNUpm?=
 =?utf-8?B?eUh3NE16alh4R3E2VFIyYmpWTkxiUnZzbnJQdFd2NWMxV2lsOGJGV0c0ZW9E?=
 =?utf-8?B?cTFsS2RBeC9oWGFsVjlqUm5TY2FoaW9NUGhSdDF6ZExYdFZZeXNoOW0zTS9E?=
 =?utf-8?B?d0hseDVwV2FyT1c4UlNMZXE2NFkwYkhGQzJwZFVpR1lnVXNpTnZ4aHNVLzcr?=
 =?utf-8?B?MjRzcVdhRjB6bHppZlBqWUd1MW5scStmU2oyb2VyRk9yU1E5bW9aZ28wNnd1?=
 =?utf-8?B?UjJSanhWOEdCWGFiR3plbWRIbmhaZXM3amlWd0ZOcDBLMURJZWxxNzZTK0x6?=
 =?utf-8?B?QTk3RVdIU0NXK2VTQThyc3p6bkhjM0RTSjlBblkyeGxueE9mSXMwR1BNc1Qv?=
 =?utf-8?B?Q0loTDlBZzNncWdwcm9UWW5velJnazJWblV4Qy9yUDJISVovc2tjODhSa3o0?=
 =?utf-8?B?elJnc2FOS0pmNUlDdGU2Z0VMWlEzTDdmdVhydWlWaWFGUjVrd3pNeDgxaUJN?=
 =?utf-8?B?NUJKeTFqMU5YajdhUU9TYzI0S1dDMHArdWphZnJZbDVGM2F4bUdXVVU5d3dG?=
 =?utf-8?B?M3loazB3cmRGWnhERDlRenNEVXJLKzB1TWRaaHoydVVwNFBGS0lSbUJMWmlJ?=
 =?utf-8?B?SUlnY05uZE44Q1Iwc0NCUjVic3dEczdSZ2xqSW1JeWFhS2xNWC9SbkUwS1E2?=
 =?utf-8?B?U1RTTmpOZm5pWFlyeWNYUlhBdE42QnQxYTgxendqR0EySEpBZG1yWnVIa1I4?=
 =?utf-8?B?dWpqYWJ4bG5CNjhCVGxpdytkSFhjSzI1OG52U3NBeUYzcTkrZ3VVbFMzd1Vp?=
 =?utf-8?B?dE90dlZFTisrcUJPZnNsR0ZZMEZYbTIyWFJjRDdUZTFaZXdmb1pwZjlITWNC?=
 =?utf-8?B?UWNWdzdYQXpFZkVKeFZod2xkQlpnMmhDcEp0dmthNzg0RjFCWlZCLzlsYkxs?=
 =?utf-8?B?VHoyaEZJemVPU0k5NEtnZzBrZUROY1FhT2RGM1JxZmZlaHJLWlpFeHA1Q2xj?=
 =?utf-8?Q?0mX3I+X7a4RA+Sx38pJbCCie2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E56751975EE51F4399E1D848E7DE7151@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8534.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6843999-2cf6-4c71-6d65-08db848e95ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2023 17:20:13.8533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qL2JT0X5+001lKHjEyVHzdscWniWKZbCjLwUnWK0JFYiO0aTnRVRDBht4j3cLTiLyaavGdjlg8jAiefskrhqaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR05MB7551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVsIDE0LCAyMDIzLCBhdCAzOjU1IEFNLCBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4
YW5kcnUuZWxpc2VpQGFybS5jb20+IHdyb3RlOg0KPiANCj4gISEgRXh0ZXJuYWwgRW1haWwNCj4g
DQo+IEhpLA0KPiANCj4gT24gU2F0LCBKdW4gMTcsIDIwMjMgYXQgMDE6MzE6MzhBTSArMDAwMCwg
TmFkYXYgQW1pdCB3cm90ZToNCj4+IEZyb206IE5hZGF2IEFtaXQgPG5hbWl0QHZtd2FyZS5jb20+
DQo+PiANCj4+IFdoaWxlIG5vIHJlYWwgcHJvYmxlbSB3YXMgZW5jb3VudGVyZWQsIGhhdmluZyBh
biBpbmxpbmUgYXNzZW1ibHkgd2l0aG91dA0KPj4gdm9sYXRpbGUga2V5d29yZCBhbmQgb3V0cHV0
IGNhbiBhbGxvdyB0aGUgY29tcGlsZXIgdG8gaWdub3JlIGl0LiBBbmQNCj4+IHdpdGhvdXQgYSBt
ZW1vcnkgY2xvYmJlciwgcG90ZW50aWFsbHkgcmVvcmRlciBpdC4NCj4+IA0KPj4gQWRkIHZvbGF0
aWxlIGFuZCBtZW1vcnkgY2xvYmJlci4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogTmFkYXYgQW1p
dCA8bmFtaXRAdm13YXJlLmNvbT4NCj4+IC0tLQ0KPj4gbGliL2FybTY0L2FzbS9tbXUuaCB8IDQg
KystLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4+IA0KPj4gZGlmZiAtLWdpdCBhL2xpYi9hcm02NC9hc20vbW11LmggYi9saWIvYXJtNjQvYXNt
L21tdS5oDQo+PiBpbmRleCA1YzI3ZWRiLi5jZjk0NDAzIDEwMDY0NA0KPj4gLS0tIGEvbGliL2Fy
bTY0L2FzbS9tbXUuaA0KPj4gKysrIGIvbGliL2FybTY0L2FzbS9tbXUuaA0KPj4gQEAgLTE0LDcg
KzE0LDcgQEANCj4+IHN0YXRpYyBpbmxpbmUgdm9pZCBmbHVzaF90bGJfYWxsKHZvaWQpDQo+PiB7
DQo+PiAgICAgIGRzYihpc2hzdCk7DQo+PiAtICAgICBhc20oInRsYmkgICAgICAgdm1hbGxlMWlz
Iik7DQo+IA0KPiBGcm9tIHRoZSBnYXMgbWFudWFsIFsxXToNCj4gDQo+ICJhc20gc3RhdGVtZW50
cyB0aGF0IGhhdmUgbm8gb3V0cHV0IG9wZXJhbmRzIGFuZCBhc20gZ290byBzdGF0ZW1lbnRzLCBh
cmUNCj4gaW1wbGljaXRseSB2b2xhdGlsZS4iDQo+IA0KPiBMb29rcyB0byBtZSBsaWtlIGJvdGgg
VExCSXMgZmFsbCBpbnRvIHRoaXMgY2F0ZWdvcnkuDQo+IA0KPiBBbmQgSSB0aGluayB0aGUgIm1l
bW9yeSIgY2xvYmJlciBpcyBub3QgbmVlZGVkIGJlY2F1c2UgdGhlIGRzYiBtYWNybyBiZWZvcmUg
YW5kDQo+IGFmdGVyIHRoZSBUTEJJIGFscmVhZHkgaGF2ZSBpdC4NCg0KWW91IGFyZSBjb21wbGV0
ZWx5IGNvcnJlY3QuIEkgZm9yZ290IGFib3V0IHRoZSBpbXBsaWNpdCDigJx2b2xhdGlsZeKAnS4N
Cg0KVGhpcyBvbmUgY2FuIGJlIGRyb3BwZWQuDQoNCg==
