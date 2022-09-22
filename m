Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A265E6FA9
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 00:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiIVWXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 18:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiIVWXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 18:23:13 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020026.outbound.protection.outlook.com [52.101.61.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FEB112FD0;
        Thu, 22 Sep 2022 15:22:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPT70Y+L8RxLq5v+lF8W8GhLb5cO0QxlqUWVYWvee3/+hVC9ZmahYPbFxtoeQzfjp9AO2Y+H2LPxCnZzXR2CwCsIdZjpi4igNamUk2kLsAp/iTF1zKDR/5535bHbuSScajDOK/6DoOWblNAVFYA4DsSaszpN3DAO0fucohjPitCVQVTZuRs8B2ugcdyASqBLKf8iH7bCG+oW+QxOrhRn95VO/GxLA3Qgldu66Vjdh1j5VlXqwob+j3NsJHQWPmRihhkHZKFnMIbVQbsZMgVgNVkDyampeR9C/fl6ZIAKoAyRGj+6CFK27dPFZh5Gz4mAIcE+t12+WZdOCxE8GJ6gpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LL0lTRU4SCMKa0Uj7F1ea/NHnM/WwWLWO/k9Tk2AWk=;
 b=dTyi+NkzvN2Hbm7dpi66aHKYlZKX+ixDQ0Yd1O5W01C3cAwY5Rh0e9dKvrnBuiyD55KbhgbeBrthn74PRlF8ODCZ8a59MYTHmai02Y20sLLdAFR4tvOdKoVI+DUhJhKctMMejyV1ZO1GclV0bBbQgvKtDubF0VMpnjMcDtLMPUiMuafZlwkUnT95gyakfmmpl+jfuSEbs6rTUDGq1DZDvWXd6kKJhllOxB0HzLFSvFQCx7fS0FiNiiT8n2SgwOsbwIwUSOHdOF+g3pDW/bVBJdDXcsz431Egr6IJGi2BaJ5RaNmNRJSQg83Gfj6E7eDbEIfJ+CY8R9GJVJqkdK4tzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LL0lTRU4SCMKa0Uj7F1ea/NHnM/WwWLWO/k9Tk2AWk=;
 b=j1Tbv67M92OkfB4x7tsfCcE2V5ZkZi7zmv6mdVU0sWcSLbTGHWi+8N5khQpwIe+dsOGoS/hYVltgvtaC5sln3Ss57BnXaEYm4Nu5gs46mUd1N/Mp8pG/CKMROdJgmIQAdZZJgx3oGaofed789eWdjAK3Kq9WsAK/73X3FTofFIs=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DM6PR21MB1356.namprd21.prod.outlook.com (2603:10b6:5:175::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.7; Thu, 22 Sep
 2022 22:21:59 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::17f5:70e:721f:df7e]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::17f5:70e:721f:df7e%4]) with mapi id 15.20.5676.007; Thu, 22 Sep 2022
 22:21:59 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sean Christopherson <seanjc@google.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/4] x86/hyperv: KVM: Rename "hv_enlightenments" to
 "hv_vmcb_enlightenments"
Thread-Topic: [PATCH 4/4] x86/hyperv: KVM: Rename "hv_enlightenments" to
 "hv_vmcb_enlightenments"
Thread-Index: AQHYzfcMSDACIaKTWki/ZRC7WDLsKK3sBzwQ
Date:   Thu, 22 Sep 2022 22:21:59 +0000
Message-ID: <BYAPR21MB16881F2C50CB0DE225E62A43D74E9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20220921201607.3156750-1-seanjc@google.com>
 <20220921201607.3156750-5-seanjc@google.com>
In-Reply-To: <20220921201607.3156750-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b9ee7d94-8a87-4865-8913-b1e0beaef9ec;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-22T22:20:55Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DM6PR21MB1356:EE_
x-ms-office365-filtering-correlation-id: 7e00139f-7cc5-4b18-f677-08da9ce8ddab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rU/1RPbujvFrlzfwGgzjQZ6Dyp4m+vw/Hcj4Cd9jQ4j2X7MGf+ALO0RsflINAkz7cC1ugZvGeP9+yBkFUrPG0SRJcDcAcTJtVJOId1JH4JxXPennJop052VGkMBPm22TzTYa+5km94JKyvMkfGiTVyoFx+ibX7ep7om2Rt3iazkeYYG946g0DaFZ7Y+xTib1supNHSVSQGR76TVfP4PLbii4fZtTZ43Dx3pT6Kmtqsy52BJPgqS/ZLa8wwSj33djbGhgTh+YBA9tlBfBedagjC3uw16o7Lnsg4qc4YrYkC6I7YrvtKcxS9MP5F8/t0mAq26tfxSuaIda0Lpyb4VTLUF6z8yVRyvcqZzr2NGXhf4bILgVS/qKC+q9eW0rMAIldzoePtlkmGg+1dtRUK1A3v+1Hyt94USXfTz8NLeSM3fE0aQIpUEDmGf8Ve1smXX7qMxPFxHK0PfaaWxzmlUsAwuxrQIxyxSHiHaajBjsAIi1+r3llhLCcqD4KQDB9yyyrvkHULQsp4K6oHpcNi3vDXykEt1zVxu3TsD988MJk9jDO16xacYX7uy0TVFptQO0kSE6N6zciGS730PdMFOuqbyZXLOy1zbB68/bQoxmZwved9cyGQ0t1yEHHTKeTv7tXZVg6n4b2p2iUukstG6n6E9TRdF09DBv50MZTR/La5UHcf4HftsW63REuNJ3sa5TNZ6B36cRp1/4571+K3epZZV3xLudi22jp0MSY6to7UAnhrwXxwWjYYYd1Vp0J7SFWxHV0DCyofr3C3LjRVgEmm/eYs96QKc8mVX17OUoybtoKvOtD4bA/2LkScPc9X7y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199015)(52536014)(2906002)(8990500004)(9686003)(82950400001)(4326008)(8676002)(7696005)(6506007)(41300700001)(5660300002)(38100700002)(8936002)(82960400001)(26005)(186003)(55016003)(64756008)(122000001)(38070700005)(86362001)(83380400001)(33656002)(66446008)(66476007)(54906003)(316002)(110136005)(478600001)(71200400001)(10290500003)(66946007)(76116006)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVRNSUNUWkhUNVJ4c2Qva3hoUGFZTjZoMXV2QkdKWjdOUkoyOWRmenNmb254?=
 =?utf-8?B?b1Q0Zlg1WkJsQndZYkQrbHlYWEJudXh0M0FkOEhGbERld3BIQzlENlIyMkRl?=
 =?utf-8?B?ZkNmUzNyRUxTaGZXUmdqeDdTRnpEQU80cVV1WElUZUhIVms2UnowMEpuZitJ?=
 =?utf-8?B?dTFZR1ZTWjVweUN2MlFjaHpVWlpmeDlVOWY2dXFRdUpJK0s4Sy9kYzlNQ2lo?=
 =?utf-8?B?dXh3bXF0NnliUnhzMUlzY2ZRaXpZbjVqcW94VEVyZ2ZPc3Y1QmwvYWZQV1gw?=
 =?utf-8?B?T0M0ano4b3ZRTWdxcEwxSENUalE0L1BZdWdiKzRhWDhrQmY0QnRac2RYdTNZ?=
 =?utf-8?B?REVpbXRLeXBacVBMM2t1dC9yTVBpR3hoMm1EQUFoMk9NSHZUWWI5cm5vNmVy?=
 =?utf-8?B?TGdvVk1DeVdIZ2c3L2hHcXlHQlU5UlBsOGNPZG1vVFFiNm8rcEd6S1FjajdK?=
 =?utf-8?B?U1JmL0RxYjVFNUoxS2EwUmJmR2NCVmVGdmduV2JCUkk4Wjk2VytRYjgwc2Z6?=
 =?utf-8?B?NU53dlI3Uk5EV3FBQXFHTnYzbWNjdlFRZGdyalNsN2FYcXh3OXlwU2xMQitE?=
 =?utf-8?B?UEZMdGkvZmhxaE9hWVplYU04STdveDFaWVdERElHYTVMMVU5OVVJTGJlT3lJ?=
 =?utf-8?B?dWJiTFljelhheUpla1FWU3VQdmpuN0xzelFDTTh1KzErSDc5RGdFd2RnUW9J?=
 =?utf-8?B?S1JubzNxdXdqQkpqbTVab2w2eHRZVncreXVWZ1IxeTBBeEphUDR4dE40Uklr?=
 =?utf-8?B?N0hBRUdGcm44U21IRDFYRjh2aXdGVHZkdTRiZHZFSzk2VUk2dU5RZnNiNURq?=
 =?utf-8?B?R05uVndYNEo2aEdFeHpDRDVMVkpLYjdnZ1NuWlpFMmZlMlBoMVJ0dHN5Nlhu?=
 =?utf-8?B?Uy9pYmhQZE9IY1ZPTTFRaG1lNWJZOEsySU5VNjA0aDdMeFAxR3NYZkErRnAx?=
 =?utf-8?B?ZVBmcXhVVHpzbFpEcXBCUzU2Uk9qVkE1WG1QTDZsdUxOUWZKSW9XOExQV3NZ?=
 =?utf-8?B?V3BITkdOL2w5Q3ZoZlFRQWVqSS80YXJJZERNRzNsaFpKWVByZWVLRk96WnBm?=
 =?utf-8?B?MUpLeVYycjF3cFdOamxDbUlEbEx5TkpZYnFlVFFNSWFnc0lmdHo3MjkxK1pl?=
 =?utf-8?B?ZXNmYXE2dUpPMTMzS0dyUlBVbENVd0dIaUVkMjZLNXdqUkk5Y0c1NFJYTFVk?=
 =?utf-8?B?bG5nU3hjNEdhQTRRaDl6dWRvcUNJOTVEN05SZGYwbHZ1NytDVlhqTEtrcWVz?=
 =?utf-8?B?NXczbkpUa3RvTGs3YWpld3J2WW1JemtHdWJoeEdoMk1mUGFoNURTVkpIRElU?=
 =?utf-8?B?WW9uZDdQbGhZeFBtYTcwZ2pBN3dhay93MWF5UGlyYis3YllmL3dyRVdpQXA0?=
 =?utf-8?B?WTdnTCtiK2dFbFRNYjM3aCs3RWhGVnBwcittYldrSmQzdnhWQ1BtSWw4KytO?=
 =?utf-8?B?djNLckNXMERXQlhNcFd4TzBPYUI3Sy9mSjNWcjI1RjF4N0M2YWdZZEF3R0pl?=
 =?utf-8?B?UUhjaGw5Z0hNSWRrUHJMa2o1b3JuOWk0TU5EMFhYM3ZhL1c2Tm9naExZRHUv?=
 =?utf-8?B?alFZM2dJU3lNTTJwZjZBdnJjRDUvcDRWNnE5cGZ3UTRCSGM1YnBHRTYweUsv?=
 =?utf-8?B?akFTYnpHTkMwcHhQOWtyaDJBcG1rckI1ako0RGQvOWplNUcxdXN2bktjeXJR?=
 =?utf-8?B?VEVpMUtyOFllQ210cnpiay80d0IwMjBpRlB3aGdsU1FrVUJaWFE5aW1aZkJq?=
 =?utf-8?B?anNkU2tJVFpvZVdIcDVtUlMxdlh1b0FSY3BNVzcrVmV1WmtrOWV2VDZHT1FH?=
 =?utf-8?B?SkJ4L084UnZvVDlNNUY4MmRjS24xRTF4K0FLNjJPZjdaTURGTWJZcjlnL1pM?=
 =?utf-8?B?N2FQSkVTcFpUTHdNYU8xODVMWjBkd2FZZWlHcTJ5NXJNUnRpU1c2cXBRYURh?=
 =?utf-8?B?NFZ0ZVFIMUVrSElSaVFIbW8xbjlaMmFSYUt6SzNGN3JObkczUngzUUZqQno5?=
 =?utf-8?B?cXplaEc2b0hyc01XSUx5OWFKa0J6K2I1bTdrVFRHUzJScE1ubldIeHdmZm1q?=
 =?utf-8?B?c3cyVzNIU1k4bUNJSjRGb0I5UlBFL0Q3NUd4NytVZUFMNHphY2o3cHQrOEgw?=
 =?utf-8?B?MmdzNXB0ZHNEZWZrcnVCOWhaemhXaHd0L0o2U3pCdzlXclI4TVRDTzJwQWlt?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e00139f-7cc5-4b18-f677-08da9ce8ddab
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 22:21:59.1257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ulFWWjGD/0Ugh/OczNL8Qgfzhz8BI+QURKIp7LtYkIXBMQ/AtfPob57xUvHB/eBQrE5+lMukRGQ4wQyTfn9HN5Q0q5RFWVE1rN+xprKaP/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1356
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+IFNlbnQ6IFdlZG5l
c2RheSwgU2VwdGVtYmVyIDIxLCAyMDIyIDE6MTYgUE0NCj4gDQo+IE5vdyB0aGF0IEtWTSBpc24n
dCBsaXR0ZXJlZCB3aXRoICJzdHJ1Y3QgaHZfZW5saWdodGVubWVudHMiIGNhc3RzLCByZW5hbWUN
Cj4gdGhlIHN0cnVjdCB0byAiaHZfdm1jYl9lbmxpZ2h0ZW5tZW50cyIgdG8gaGlnaGxpZ2h0IHRo
ZSBmYWN0IHRoYXQgdGhlDQo+IHN0cnVjdCBpcyBzcGVjaWZpY2FsbHkgZm9yIFNWTSdzIFZNQ0Iu
DQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gIGFy
Y2gveDg2L2luY2x1ZGUvYXNtL2h5cGVydi10bGZzLmggICAgICAgICAgICAgICAgICAgfCAyICst
DQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9zdm0uaCAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwgMiArLQ0KPiAgYXJjaC94ODYva3ZtL3N2bS9uZXN0ZWQuYyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8IDIgKy0NCj4gIGFyY2gveDg2L2t2bS9zdm0vc3ZtLmggICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAyICstDQo+ICBhcmNoL3g4Ni9rdm0vc3ZtL3N2bV9vbmh5cGVydi5j
ICAgICAgICAgICAgICAgICAgICAgIHwgMiArLQ0KPiAgYXJjaC94ODYva3ZtL3N2bS9zdm1fb25o
eXBlcnYuaCAgICAgICAgICAgICAgICAgICAgICB8IDYgKysrLS0tDQo+ICB0b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9rdm0vaW5jbHVkZS94ODZfNjQvc3ZtLmggICAgIHwgNCArKy0tDQo+ICB0b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0veDg2XzY0L2h5cGVydl9zdm1fdGVzdC5jIHwgMiArLQ0K
PiAgOCBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9oeXBlcnYtdGxmcy5oIGIvYXJj
aC94ODYvaW5jbHVkZS9hc20vaHlwZXJ2LXRsZnMuaA0KPiBpbmRleCA0YzRmODFkYWY1YTIuLmY3
YTQzMWJjYjJjMyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vaHlwZXJ2LXRs
ZnMuaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9oeXBlcnYtdGxmcy5oDQo+IEBAIC01
ODgsNyArNTg4LDcgQEAgc3RydWN0IGh2X2VubGlnaHRlbmVkX3ZtY3Mgew0KPiAgICogSHlwZXIt
ViB1c2VzIHRoZSBzb2Z0d2FyZSByZXNlcnZlZCAzMiBieXRlcyBpbiBWTUNCIGNvbnRyb2wgYXJl
YSB0byBleHBvc2UNCj4gICAqIFNWTSBlbmxpZ2h0ZW5tZW50cyB0byBndWVzdHMuDQo+ICAgKi8N
Cj4gLXN0cnVjdCBodl9lbmxpZ2h0ZW5tZW50cyB7DQo+ICtzdHJ1Y3QgaHZfdm1jYl9lbmxpZ2h0
ZW5tZW50cyB7DQo+ICAJc3RydWN0IF9fcGFja2VkIGh2X2VubGlnaHRlbm1lbnRzX2NvbnRyb2wg
ew0KPiAgCQl1MzIgbmVzdGVkX2ZsdXNoX2h5cGVyY2FsbDoxOw0KPiAgCQl1MzIgbXNyX2JpdG1h
cDoxOw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vc3ZtLmggYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9zdm0uaA0KPiBpbmRleCA2YmVmZWQyYjMwYTYuLjYyMWYwNjRiYjdjYyAx
MDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vc3ZtLmgNCj4gKysrIGIvYXJjaC94
ODYvaW5jbHVkZS9hc20vc3ZtLmgNCj4gQEAgLTE2NCw3ICsxNjQsNyBAQCBzdHJ1Y3QgX19hdHRy
aWJ1dGVfXyAoKF9fcGFja2VkX18pKSB2bWNiX2NvbnRyb2xfYXJlYSB7DQo+ICAJICogZm9yIHVz
ZSBieSBoeXBlcnZpc29yL3NvZnR3YXJlLg0KPiAgCSAqLw0KPiAgCXVuaW9uIHsNCj4gLQkJc3Ry
dWN0IGh2X2VubGlnaHRlbm1lbnRzIGh2X2VubGlnaHRlbm1lbnRzOw0KPiArCQlzdHJ1Y3QgaHZf
dm1jYl9lbmxpZ2h0ZW5tZW50cyBodl9lbmxpZ2h0ZW5tZW50czsNCj4gIAkJdTggcmVzZXJ2ZWRf
c3dbMzJdOw0KPiAgCX07DQo+ICB9Ow0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS9u
ZXN0ZWQuYyBiL2FyY2gveDg2L2t2bS9zdm0vbmVzdGVkLmMNCj4gaW5kZXggYTZhODdkOTc0M2Nl
Li5iYzlmYjRkYmYwYWUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0vbmVzdGVkLmMN
Cj4gKysrIGIvYXJjaC94ODYva3ZtL3N2bS9uZXN0ZWQuYw0KPiBAQCAtMjAxLDcgKzIwMSw3IEBA
IHZvaWQgcmVjYWxjX2ludGVyY2VwdHMoc3RydWN0IHZjcHVfc3ZtICpzdm0pDQo+ICAgKi8NCj4g
IHN0YXRpYyBib29sIG5lc3RlZF9zdm1fdm1ydW5fbXNycG0oc3RydWN0IHZjcHVfc3ZtICpzdm0p
DQo+ICB7DQo+IC0Jc3RydWN0IGh2X2VubGlnaHRlbm1lbnRzICpodmUgPSAmc3ZtLT5uZXN0ZWQu
Y3RsLmh2X2VubGlnaHRlbm1lbnRzOw0KPiArCXN0cnVjdCBodl92bWNiX2VubGlnaHRlbm1lbnRz
ICpodmUgPSAmc3ZtLT5uZXN0ZWQuY3RsLmh2X2VubGlnaHRlbm1lbnRzOw0KPiAgCWludCBpOw0K
PiANCj4gIAkvKg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS9zdm0uaCBiL2FyY2gv
eDg2L2t2bS9zdm0vc3ZtLmgNCj4gaW5kZXggOWViMmZjNzY3MzJmLi41ZTExNzhiYzlhNjQgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmgNCj4gKysrIGIvYXJjaC94ODYva3Zt
L3N2bS9zdm0uaA0KPiBAQCAtMTUyLDcgKzE1Miw3IEBAIHN0cnVjdCB2bWNiX2N0cmxfYXJlYV9j
YWNoZWQgew0KPiAgCXU2NCB2aXJ0X2V4dDsNCj4gIAl1MzIgY2xlYW47DQo+ICAJdW5pb24gew0K
PiAtCQlzdHJ1Y3QgaHZfZW5saWdodGVubWVudHMgaHZfZW5saWdodGVubWVudHM7DQo+ICsJCXN0
cnVjdCBodl92bWNiX2VubGlnaHRlbm1lbnRzIGh2X2VubGlnaHRlbm1lbnRzOw0KPiAgCQl1OCBy
ZXNlcnZlZF9zd1szMl07DQo+ICAJfTsNCj4gIH07DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0vc3ZtL3N2bV9vbmh5cGVydi5jIGIvYXJjaC94ODYva3ZtL3N2bS9zdm1fb25oeXBlcnYuYw0K
PiBpbmRleCA1ZDQwMzY2MTFhMzcuLjBiNjU3YzdjZDIxYiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94
ODYva3ZtL3N2bS9zdm1fb25oeXBlcnYuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bV9v
bmh5cGVydi5jDQo+IEBAIC0xNiw3ICsxNiw3IEBADQo+IA0KPiAgaW50IHN2bV9odl9lbmFibGVf
ZGlyZWN0X3RsYmZsdXNoKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gIHsNCj4gLQlzdHJ1Y3Qg
aHZfZW5saWdodGVubWVudHMgKmh2ZTsNCj4gKwlzdHJ1Y3QgaHZfdm1jYl9lbmxpZ2h0ZW5tZW50
cyAqaHZlOw0KPiAgCXN0cnVjdCBodl9wYXJ0aXRpb25fYXNzaXN0X3BnICoqcF9odl9wYV9wZyA9
DQo+ICAJCQkmdG9fa3ZtX2h2KHZjcHUtPmt2bSktPmh2X3BhX3BnOw0KPiANCj4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2t2bS9zdm0vc3ZtX29uaHlwZXJ2LmgNCj4gYi9hcmNoL3g4Ni9rdm0vc3Zt
L3N2bV9vbmh5cGVydi5oDQo+IGluZGV4IGM4ZjgwNDUzMDViZS4uZTA4Y2Q3MTkyNTU5IDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bV9vbmh5cGVydi5oDQo+ICsrKyBiL2FyY2gv
eDg2L2t2bS9zdm0vc3ZtX29uaHlwZXJ2LmgNCj4gQEAgLTE4LDcgKzE4LDcgQEAgaW50IHN2bV9o
dl9lbmFibGVfZGlyZWN0X3RsYmZsdXNoKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+IA0KPiAg
c3RhdGljIGlubGluZSB2b2lkIHN2bV9odl9pbml0X3ZtY2Ioc3RydWN0IHZtY2IgKnZtY2IpDQo+
ICB7DQo+IC0Jc3RydWN0IGh2X2VubGlnaHRlbm1lbnRzICpodmUgPSAmdm1jYi0+Y29udHJvbC5o
dl9lbmxpZ2h0ZW5tZW50czsNCj4gKwlzdHJ1Y3QgaHZfdm1jYl9lbmxpZ2h0ZW5tZW50cyAqaHZl
ID0gJnZtY2ItPmNvbnRyb2wuaHZfZW5saWdodGVubWVudHM7DQo+IA0KPiAgCUJVSUxEX0JVR19P
TihzaXplb2Yodm1jYi0+Y29udHJvbC5odl9lbmxpZ2h0ZW5tZW50cykgIT0NCj4gIAkJICAgICBz
aXplb2Yodm1jYi0+Y29udHJvbC5yZXNlcnZlZF9zdykpOw0KPiBAQCAtNjMsNyArNjMsNyBAQCBz
dGF0aWMgaW5saW5lIHZvaWQgc3ZtX2h2X3ZtY2JfZGlydHlfbmVzdGVkX2VubGlnaHRlbm1lbnRz
KA0KPiAgCQlzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICB7DQo+ICAJc3RydWN0IHZtY2IgKnZt
Y2IgPSB0b19zdm0odmNwdSktPnZtY2I7DQo+IC0Jc3RydWN0IGh2X2VubGlnaHRlbm1lbnRzICpo
dmUgPSAmdm1jYi0+Y29udHJvbC5odl9lbmxpZ2h0ZW5tZW50czsNCj4gKwlzdHJ1Y3QgaHZfdm1j
Yl9lbmxpZ2h0ZW5tZW50cyAqaHZlID0gJnZtY2ItPmNvbnRyb2wuaHZfZW5saWdodGVubWVudHM7
DQo+IA0KPiAgCWlmIChodmUtPmh2X2VubGlnaHRlbm1lbnRzX2NvbnRyb2wubXNyX2JpdG1hcCkN
Cj4gIAkJdm1jYl9tYXJrX2RpcnR5KHZtY2IsIFZNQ0JfSFZfTkVTVEVEX0VOTElHSFRFTk1FTlRT
KTsNCj4gQEAgLTcxLDcgKzcxLDcgQEAgc3RhdGljIGlubGluZSB2b2lkIHN2bV9odl92bWNiX2Rp
cnR5X25lc3RlZF9lbmxpZ2h0ZW5tZW50cygNCj4gDQo+ICBzdGF0aWMgaW5saW5lIHZvaWQgc3Zt
X2h2X3VwZGF0ZV92cF9pZChzdHJ1Y3Qgdm1jYiAqdm1jYiwgc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KQ0KPiAgew0KPiAtCXN0cnVjdCBodl9lbmxpZ2h0ZW5tZW50cyAqaHZlID0gJnZtY2ItPmNvbnRy
b2wuaHZfZW5saWdodGVubWVudHM7DQo+ICsJc3RydWN0IGh2X3ZtY2JfZW5saWdodGVubWVudHMg
Kmh2ZSA9ICZ2bWNiLT5jb250cm9sLmh2X2VubGlnaHRlbm1lbnRzOw0KPiAgCXUzMiB2cF9pbmRl
eCA9IGt2bV9odl9nZXRfdnBpbmRleCh2Y3B1KTsNCj4gDQo+ICAJaWYgKGh2ZS0+aHZfdnBfaWQg
IT0gdnBfaW5kZXgpIHsNCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2
bS9pbmNsdWRlL3g4Nl82NC9zdm0uaA0KPiBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9p
bmNsdWRlL3g4Nl82NC9zdm0uaA0KPiBpbmRleCAwYzMyNTQ5YzZiNjQuLjQ5MjkyMTkwYzIxOSAx
MDA2NDQNCj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2luY2x1ZGUveDg2XzY0
L3N2bS5oDQo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9pbmNsdWRlL3g4Nl82
NC9zdm0uaA0KPiBAQCAtNTgsNyArNTgsNyBAQCBlbnVtIHsNCj4gIAlJTlRFUkNFUFRfUkRQUlUs
DQo+ICB9Ow0KPiANCj4gLXN0cnVjdCBodl9lbmxpZ2h0ZW5tZW50cyB7DQo+ICtzdHJ1Y3QgaHZf
dm1jYl9lbmxpZ2h0ZW5tZW50cyB7DQo+ICAJc3RydWN0IF9fcGFja2VkIGh2X2VubGlnaHRlbm1l
bnRzX2NvbnRyb2wgew0KPiAgCQl1MzIgbmVzdGVkX2ZsdXNoX2h5cGVyY2FsbDoxOw0KPiAgCQl1
MzIgbXNyX2JpdG1hcDoxOw0KPiBAQCAtMTI0LDcgKzEyNCw3IEBAIHN0cnVjdCBfX2F0dHJpYnV0
ZV9fICgoX19wYWNrZWRfXykpIHZtY2JfY29udHJvbF9hcmVhIHsNCj4gIAkgKiBmb3IgdXNlIGJ5
IGh5cGVydmlzb3Ivc29mdHdhcmUuDQo+ICAJICovDQo+ICAJdW5pb24gew0KPiAtCQlzdHJ1Y3Qg
aHZfZW5saWdodGVubWVudHMgaHZfZW5saWdodGVubWVudHM7DQo+ICsJCXN0cnVjdCBodl92bWNi
X2VubGlnaHRlbm1lbnRzIGh2X2VubGlnaHRlbm1lbnRzOw0KPiAgCQl1OCByZXNlcnZlZF9zd1sz
Ml07DQo+ICAJfTsNCj4gIH07DQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9rdm0veDg2XzY0L2h5cGVydl9zdm1fdGVzdC5jDQo+IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMva3ZtL3g4Nl82NC9oeXBlcnZfc3ZtX3Rlc3QuYw0KPiBpbmRleCA4MWIyMDRlZTUwOWEuLmY4
ZTQzYzc5OGM4NiAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL3g4
Nl82NC9oeXBlcnZfc3ZtX3Rlc3QuYw0KPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9r
dm0veDg2XzY0L2h5cGVydl9zdm1fdGVzdC5jDQo+IEBAIC00Niw3ICs0Niw3IEBAIHN0YXRpYyB2
b2lkIF9fYXR0cmlidXRlX18oKF9fZmxhdHRlbl9fKSkgZ3Vlc3RfY29kZShzdHJ1Y3QNCj4gc3Zt
X3Rlc3RfZGF0YSAqc3ZtKQ0KPiAgew0KPiAgCXVuc2lnbmVkIGxvbmcgbDJfZ3Vlc3Rfc3RhY2tb
TDJfR1VFU1RfU1RBQ0tfU0laRV07DQo+ICAJc3RydWN0IHZtY2IgKnZtY2IgPSBzdm0tPnZtY2I7
DQo+IC0Jc3RydWN0IGh2X2VubGlnaHRlbm1lbnRzICpodmUgPSAmdm1jYi0+Y29udHJvbC5odl9l
bmxpZ2h0ZW5tZW50czsNCj4gKwlzdHJ1Y3QgaHZfdm1jYl9lbmxpZ2h0ZW5tZW50cyAqaHZlID0g
JnZtY2ItPmNvbnRyb2wuaHZfZW5saWdodGVubWVudHM7DQo+IA0KPiAgCUdVRVNUX1NZTkMoMSk7
DQo+IA0KPiAtLQ0KPiAyLjM3LjMuOTY4LmdhNmI0YjA4MGU0LWdvb2cNCg0KUmV2aWV3ZWQtYnk6
IE1pY2hhZWwgS2VsbGV5IDxtaWtlbGxleUBtaWNyb3NvZnQuY29tPg0K
