Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BD9717404
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 05:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjEaDFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 23:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjEaDFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 23:05:30 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD48F9;
        Tue, 30 May 2023 20:05:28 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34V0Q62f008349;
        Tue, 30 May 2023 20:04:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=1AKvZytMg5dfAtoOSNxyqJjKLIuspyFisOHgpuYN15g=;
 b=rJsLwrQy3mzbeWP6P44qZeX7a7Y5K6U+BtEr6TY3ny+dt9gNJIIMRs2XgNIeedlmxtZ/
 5jGvay5FVSiKY3QuOknZI8odK04H/o6atjJAdaZKc3up7OTERtZ0XuYpsXHT17N3FxzM
 4FKjhFJPnpdrn3c+HsmYZHmXF0KcLODXp/Q/AZeK2rzHXX2XHZAUY8UM5Caa/Z8h3S7R
 RvvX8loY2E754ETIeErGyRO82XHMPoseQBXYq4CiclZTilBWPBUVWrAXTaVOqF86k+OO
 3OXopt78vXqZvKjsxBKeSFLhDyhjkPHmUOmpZPjzRh7E23Q8XLv6LO3ZVG8y0yJv8ECt CQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3qufd6rw4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 20:04:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qpswu6bCxpL7ss6ttyeGB5WMT7LvS/VTEf43gIyoDAIuor3MpjNFYTXVXkZ8adxqOz9QN7RODj0EZ/GE4hRCeXAgrp2RBd6LzlzUJgkdNC79YNq+jkZckIXsnFPVXFMk7isZ+AQbDD9KVFRKEyT8KeFAxKL9QmYRemGVE+dSUCJuO1MROOARyHlZCbYjQTwivuUCysFx8v/ji+W36JxAR9n40qt2FyQMkSFj+kLTw3ZDMqA/NI+rPaluLL0LVsf34e7KdgScYvIYeyAIQxRyUeWZ0Vpkxx3xgTw/4qXKiPky975/vsiIzLSb3LqEO6QIyzU8ascUyyjeQXHkhenLYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1AKvZytMg5dfAtoOSNxyqJjKLIuspyFisOHgpuYN15g=;
 b=bnQgerOCObPHfpmeHI2PxbajphnKQ/FAZIbfw14UtXiwLmdzTVjNKayIXY5Qze5UHYmBAaABHvwbnbAa997664FA6v0yMX78iCnx/VD8tSS6ncWVD/PebGqiyQEKLXSY0su73w32uK5yMYyNVwRuuY5GiONzY6Jo7lqKPisLEumUi/TO8jUK+zZU8frzd8fw/xwBa06E+nEuX/m4xcAWiaWfwM4xi1wS8bC964IpcCuCDpIpnbA1KiCFEjE9qMhRPHSQovOIxDmDK4/xrK4BjhJUt/1SFUE52fz6JJ6bUwv/XAYJyE1sN9G1dshOFmReKeja66PrDWBHI8aMTHwcgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1AKvZytMg5dfAtoOSNxyqJjKLIuspyFisOHgpuYN15g=;
 b=DrxnkBxy8QD8CHQi/9BTdw0i+PwH/RZdHLq7Q7Echg4igfu3imIRs/M0cfHUdvPHR89SH1OHlpZiUBqVuP+gbPa30Yq4jgpUtQPKPbds/FTLwKNS6NGbGqIGSXM4VuA2WOeo7l5dTl1Qp3L1glHNW4g8iCNBGbEsf1HLY5v5QNKNVrASxOqZcn43MdefXFzFYw0vYzby1FgWIEEOKQqQf3tOTSix3AlH/KizhwkZzFNpGUtHt4w5OBJGSYK9AvHoMG0EyqYcpwucargZTgrukyx6EMViA6u8tB/Kop8RzrXDp4ICMQfxHcpDLHqiKwQH1BplsxL2+RxPsMvJfT7srQ==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SA3PR02MB9995.namprd02.prod.outlook.com (2603:10b6:806:381::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 03:04:22 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 03:04:22 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Kyle Huey <me@kylehuey.com>,
        "neelnatu@google.com" <neelnatu@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK set
Thread-Topic: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK
 set
Thread-Index: AQHZkzGeQS8mbCm9w0qDUFkji8V8m69zY/WAgABO2IA=
Date:   Wed, 31 May 2023 03:04:22 +0000
Message-ID: <F4AFC5EE-9967-4117-BA85-ED82C106575C@nutanix.com>
References: <20230530200152.18961-1-jon@nutanix.com>
 <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
In-Reply-To: <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|SA3PR02MB9995:EE_
x-ms-office365-filtering-correlation-id: 14a10958-e706-4d7e-1ac9-08db6183bbc3
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7DGHqbPz0DhaNX6AlBqWzvYRoYSmSMVW3d2DVfUvu4ZEPd2bftBd1Llb9WmsKIP1HQNKCn209V0fYXqbJovd2nw5KT0AuyT/JleT6sVeF0ZfZnJF30WmTHyTuzBfe9ir0t89IJwfRWrNzbAe/aSOVHduJ26ZP2+7BGccNHfJi+9stlz3s9z2Fb/05C1kOZayuA4pB3enhnkxdEUhSVQT09HzYVVKUB1hLDx/gQ9PnMsUk2PPOnleB0ReveB5o+5dCXYLRarYi4cVjLEUAkl0jsR2Ynnk1jQN54U9uMJZ7IiXj7CB2omTMfZDiA+CpH2NiDGAZQbElEPwj8PCiJnyvNe3EoMIlAU941YlWS7wtXBi10YD1vxv6UxUTO3FzkHk5178r3mbnXfcYRjpzPs0wlZT+aPMxnQ3RA5PbGk9ldl2htuC+QEQkm3LQ9GQXqDpEXoFzTiOmWvuNf0xW4STTAee3m7wJkozUHcRo3ZD9zpa0UoH/qJt2NGko0nx4rfx2JL7qnp3MyzQYH+cE1ee54fH0MOc2zQjk+tAIEildak68t2XcoJsuT3XapChh59qlunnFECChBo3ZSIUphD8HKCpnQolTt2kmVPxmQG/VQl8yUGTk8BWkiNde8DegQHHLLHWc5NIiSlh933Q+tY4lQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199021)(6512007)(186003)(6506007)(53546011)(2906002)(2616005)(36756003)(38070700005)(4326008)(83380400001)(316002)(6916009)(66899021)(71200400001)(66446008)(91956017)(66946007)(64756008)(66476007)(76116006)(66556008)(6486002)(41300700001)(38100700002)(33656002)(54906003)(122000001)(478600001)(8676002)(8936002)(5660300002)(86362001)(7416002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWdoaU9NdDI3RitkUmdTWDdXdFhDbGY4SU55aW5KdXUvUlhwTmYyQzFpWnRT?=
 =?utf-8?B?S0N0d3VueEtrbzlNK2lNTEhSK1BjKzZBUS80Mm5VTGhTK3Eva0xHTmlocUF4?=
 =?utf-8?B?dXJoc0djZGl5TzI1ZEdCNUREbm9UMVNRTjgxY3FpWUNEcDAvelE0NjVRazdF?=
 =?utf-8?B?N2w3MSsvaVA1VkwrNHk5bFJUVGM3QmU0UXFqVU01Z3lpc3RKS29paXQxZWdM?=
 =?utf-8?B?SW16NVZVeTk3ZnA5SUpkc0R5K2FaVmF4OXNXZmw4N0Vuam9vaXIrQ1lvUDdz?=
 =?utf-8?B?V085RWhPckNCZXZ6UzhCS2cxWmVZcG5tMFhmWkM3T0dnOW14TXpFbFlxNjc2?=
 =?utf-8?B?SThEdC82aGNhS01oUWJBSW1OeUtVS21saTh1VVRaT0RDWXZ5eG9rL1pvNTky?=
 =?utf-8?B?WG1Xd2ZVLzNWaFVUM3dBNUM0RDZvcmtWVmlFK0Nta05GQitUanhlSFN0ZUcy?=
 =?utf-8?B?cWNLNGw0SmsrdStDNER5aDIxR3p3NkxyME1xSEZXSFF1UnNMOHR3NUNvUmMx?=
 =?utf-8?B?SjJFRW5JblUvTmRCTmpTTklESG1tQXNORlFPWnd1NSt5MVJMOFRrY2FMZXFu?=
 =?utf-8?B?VU1ZM0J2Y3o5T3hJbzBCcCtNZ2VyNldjMEhwUXN3Q0pmYkRYZi84di9YaXly?=
 =?utf-8?B?QXlhQ1ZEYXFzTjUrbGl3KzFtbWRlaUZKN3hOSFo4c3l4cWhJR25GYjdUNG1v?=
 =?utf-8?B?aEJwYlJJakxzbG9qT2k1MWhpejczam5rQXc5cUdGSWVVcGIyNjVxdFU2NjYw?=
 =?utf-8?B?VGFjd3FFUnNXY042L2tQalovRHlhMGxpbnlOalQzSm4zUkZ6NEhTeDhsYURh?=
 =?utf-8?B?UllFMDZYOVFHVFFPOTZRUnRFU2FIVGxTanBlQkVoVW4rOVZYWmxHaEMrb0lu?=
 =?utf-8?B?bUQ5QlFrZGVSdXVhS1ZUUnRVN1c4MXJDQmpncDVGa2kvN1dxNzhCLzJjZzhr?=
 =?utf-8?B?Mk85d2kveHdwaDJ3NkVBbFJqU2pGR0NZelVtRTZnYWRpZ1pLbG1XZWxENlY0?=
 =?utf-8?B?M3Q4NUNKbWpBYWlnTS92ZTF6SE5Ud1IrVG56aHNVN1RVVFZWcHBBTVZhbElV?=
 =?utf-8?B?VHcyTUdjTEJqTjd2S2ptYVdmZkFMbS9NNkhWalFOYVIxWlN2UDU1djhEU1k1?=
 =?utf-8?B?L3VHMWsranJFQ1loZFlHYkFlMDlVRlF2aE56czFqc0dtQzhrU3dwZTIraG9M?=
 =?utf-8?B?U21tOWc0RmsxN2RqVmtSUnZnSE9kL3lDb1FtbXQ4eXk2L1RWZGQwb3d1U0k3?=
 =?utf-8?B?OS81UG55N3piSDVRWHJ0dFh0cjU0RFJZNTFnbm9SR1A1SzlWbDRLRllXZ25V?=
 =?utf-8?B?MjQyM3l2WVpmRXhHNFlSdk5wK2VIQlk0S1BEZ0s3Mm9YdUhNTE9reUR1M2hv?=
 =?utf-8?B?SzlqbjdIRCs2ZUtvMmJsVlV3ZHZneWp0bVp1RnpLTXJ1cjUxRXlwUWJjc2NM?=
 =?utf-8?B?YzFIakkrZWlBV0VHM0hjeHVFMU5UOFM0QkFsSWpXdG5TSGpYWFZaU0pWd3Yr?=
 =?utf-8?B?WEh3NHJvOFptZFNsK2ZLd1BxYVd0WnNSdXRLZlpMUDQraWZRQWQvczcrWXJQ?=
 =?utf-8?B?MnBsWDFLSTdRT3VQdkhyVEkrQnZZaUFtSVRzcmVVRkllN05mQmdGbUh5S2tp?=
 =?utf-8?B?T09uZHkweS9TaVlzT0pha0JLc3NxdDJrYnl2MjNHRWF6K1hCdzRuUk5ENWs2?=
 =?utf-8?B?cTQ0OENvMFAvL3JrRENJTkxwZmNFNnpRWHM3SUhyUTJBSnhJWll0a1p3aEsv?=
 =?utf-8?B?K09hcmlwMDBkdjFvcTg5dzJBa3dIZ3ZvQ2ZKSkk1ZWJuNWVmRW9Db3IvY2d0?=
 =?utf-8?B?L2JDeDdxSTU2VWxjcE9iOEVaYWp6SHlEV2dEa0o2anhKOXB4WC8waWltSS9T?=
 =?utf-8?B?ZEhXQ0piWUhhT3FaMXNCWElPYjJmVVNBUlpiQk5ac0VKcjNqVlNBUUhvdHRo?=
 =?utf-8?B?Qk1ycGExNWR4V09MSFAwemxaekFxQ1NnU3B6aFloVDNXZW5sU3NlRDRhVTNv?=
 =?utf-8?B?TlpRL1pBdU15cWJuTHNBNWwwMVNMMnNTU2cvNm1uTlZXSHhQOVZtdUZlWEQ4?=
 =?utf-8?B?OVVyY2hnV3pZSm5ldjd1U2xrb1crYjBMUlY2cE0wY3Z3MXV5TmEyNGlZWjl2?=
 =?utf-8?B?eEIzSnhMaVF6WVJjNUFMWjRPbGZ3aE9rbmFCR1l0anE2OUxTNFFad0lheGtF?=
 =?utf-8?B?azFyOVFNL2tvOXJlckF6OVdLU09ZYy9RS0pnVlNNaGtidHgrTVl6eFFGd1pr?=
 =?utf-8?B?L3FsUHRGY1BKdnFIbFdsR1liNGJBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <105E6F7C84E41A49BB673BCC55DDB91C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a10958-e706-4d7e-1ac9-08db6183bbc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 03:04:22.1479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvAgfQBpW9FICfrIhlOimaiV8NFZ/Lx3eLja5SyHHlox3X82oXcYJrwgCsFEnXov0DejmMuCfeEmWGobuSMOeQsOh2BIlSI4RFoivYJazt8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR02MB9995
X-Proofpoint-ORIG-GUID: TikP5M17A0vbtn10zazWyKX4-z_dnbLF
X-Proofpoint-GUID: TikP5M17A0vbtn10zazWyKX4-z_dnbLF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_18,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDMwLCAyMDIzLCBhdCA2OjIyIFBNLCBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5z
ZW5AaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIDUvMzAvMjMgMTM6MDEsIEpvbiBLb2hsZXIg
d3JvdGU6DQo+PiBSZXNwZWN0IERJU0FCTEVEX01BU0sgd2hlbiBjbGVhcmluZyBYU0FWRSBmZWF0
dXJlcywgc3VjaCB0aGF0IGZlYXR1cmVzDQo+PiB0aGF0IGFyZSBkaXNhYmxlZCBkbyBub3QgYXBw
ZWFyIGluIHRoZSB4ZmVhdHVyZXMgbWFzay4NCj4gDQo+IE9uZSBzYW5pdHkgY2hlY2sgdGhhdCBJ
J2Qgc3VnZ2VzdCBhZG9wdGluZyBpcyAiSG93IG1hbnkgb3RoZXIgdXNlcnMgaW4NCj4gdGhlIGNv
ZGUgZG8gdGhpcz8iICBIb3cgbWFueSBESVNBQkxFRF9NQVNLX0JJVF9TRVQoKSB1c2VycyBhcmUg
dGhlcmU/DQoNCkdvb2QgdGlwLCB0aGFuayB5b3UuIEp1c3QgY3B1X2ZlYXR1cmVfZW5hYmxlZCgp
LCB0aG91Z2ggSSBmZWx0IHRoYXQgdXNpbmcNCkRJU0FCTEVEX01BU0tfQklUX1NFVCgpIHJlYWxs
eSBkb2VzIGNhcHR1cmUgKmV4YWN0bHkqIHdoYXQgSeKAmW0gdHJ5aW5nIHRvDQpkbyBoZXJlLiAN
Cg0KSGFwcHkgdG8gdGFrZSBzdWdnZXN0aW9ucywgcGVyaGFwcyAhY3B1X2ZlYXR1cmVfZW5hYmxl
ZChjaWQpIGluc3RlYWQ/DQoNCk9yLCBJIGRpZCBub29kbGUgd2l0aCB0aGUgaWRlYSBvZiBtYWtp
bmcgYSBjcHVfZmVhdHVyZV9kaXNhYmxlZCgpIGFzIGFuIA0KYWxpYXMgZm9yIERJU0FCTEVEX01B
U0tfQklUX1NFVCgpLCBidXQgdGhhdCBmZWx0IGxpa2UgYmxvYXRpbmcgdGhlIGNoYW5nZQ0KZm9y
IGxpdHRsZSBnYWluLg0KDQo+IA0KPj4gVGhpcyBpcyBpbXBvcnRhbnQgZm9yIGt2bV9sb2FkX3tn
dWVzdHxob3N0fV94c2F2ZV9zdGF0ZSwgd2hpY2ggbG9vaw0KPj4gYXQgaG9zdF94Y3IwIGFuZCB3
aWxsIGRvIGFuIGV4cGVuc2l2ZSB4c2V0YnYgd2hlbiB0aGUgZ3Vlc3QgYW5kIGhvc3QNCj4+IGRv
IG5vdCBtYXRjaC4NCj4gDQo+IElzIHRoYXQgdGhlIG9ubHkgcHJvYmxlbT8gIGt2bV9sb2FkX2d1
ZXN0X3hzYXZlX3N0YXRlKCkgc2VlbXMgdG8gaGF2ZQ0KPiBzb21lICNpZmRlZiBDT05GSUdfWDg2
X0lOVEVMX01FTU9SWV9QUk9URUNUSU9OX0tFWVMgY29kZSBhbmQgSSBjYW4ndA0KPiBpbWFnaW5l
IHRoYXQgS1ZNIGd1ZXN0cyBjYW4gZXZlbiB1c2UgUEtSVSBpZiB0aGlzIGNvZGUgaXMgY29tcGls
ZWQgb3V0Lg0KPiANCj4gQWxzbywgdGhpcyB3aWxsIHNldCBYRkVBVFVSRV9QS1JVIGluIHhjcjAg
YW5kIGdvIHRvIHRoZSB0cm91YmxlIG9mDQo+IFhTQVZFL1hSU1RPUidpbmcgaXQgYWxsIG92ZXIg
dGhlIHBsYWNlIGV2ZW4gZm9yIHJlZ3VsYXIgdGFza3MuDQoNCkNvcnJlY3QsIEtWTSBpc27igJl0
IHRoZSBvbmx5IGJlbmVmaWNpYXJ5IGhlcmUgYXMgeW91IHJpZ2h0bHkgcG9pbnRlZCBvdXQuIEni
gJltDQpoYXBweSB0byBjbGFyaWZ5IHRoYXQgaW4gdGhlIGNvbW1pdCBtc2cgaWYgeW914oCZZCBs
aWtlLiANCg0KQWxzbywgYWNrIG9uIHRoZSBpZmRlZuKAmXMsIEkgYWRkZWQgdGhvc2UgbXlzZWxm
IHdheSBiYWNrIHdoZW4sIHRoaXMgY2hhbmdlIGlzDQphbiBhZGRlbmR1bSB0byB0aGF0IG9uZSB0
byBudWtlIHRoZSB4c2V0YnYgb3ZlcmhlYWQuDQoNCj4+IEEgcHJpbWUgZXhhbXBsZSBpZiBDT05G
SUdfWDg2X0lOVEVMX01FTU9SWV9QUk9URUNUSU9OX0tFWVMgaXMgZGlzYWJsZWQsDQo+PiB0aGUg
Z3Vlc3QgT1Mgd2lsbCBub3Qgc2VlIFBLVSBtYXNrZWQ7IGhvd2V2ZXIsIHRoZSBndWVzdCB3aWxs
IGluY3VyDQo+PiB4c2V0YnYgc2luY2UgdGhlIGhvc3QgbWFzayB3aWxsIG5ldmVyIG1hdGNoIHRo
ZSBndWVzdCwgZXZlbiB0aG91Z2gNCj4+IERJU0FCTEVEX01BU0sxNiBoYXMgRElTQUJMRV9QS1Ug
c2V0Lg0KPiANCj4gT0ssIHNvIHlvdSBjYXJlIGJlY2F1c2UgeW91J3JlIHNlZWluZyBLVk0gZ28g
c2xvdy4gIFlvdSB0cmFja2VkIGl0IGRvd24NCj4gdG8gbG90cyBvZiBYU0VUQlYncz8gIFlvdSBz
YWlkLCAid2hhdCB0aGUgaGVjaywgd2h5IGlzIGl0IGRvaW5nIFhTRVRCVg0KPiBzbyBtdWNoPyIg
YW5kIHRyYWNrZWQgaXQgZG93biB0byAnbWF4X2ZlYXR1cmVzJyB3aGljaCB3ZSB1c2UgdG8gcG9w
dWxhdGUNCj4gWENSMD8NCg0KWWVzIGFuZCBZZXMsIHRoYXQgaXMgZXhhY3RseSBob3cgSSBhcnJp
dmVkIGhlcmUuIGt2bV9sb2FkX3tndWVzdHxob3N0fV94c2F2ZV9zdGF0ZQ0KaXMgb24gdGhlIGNy
aXRpY2FsIHBhdGggZm9yIHZtZXhpdCAvIHZtZW50cnkuIFRoaXMgb3ZlcmhlYWQgc3RpY2tzIG91
dCBsaWtlIGEgc29yZQ0KdGh1bWIgd2hlbiBsb29raW5nIGF0IHBlcmYgdG9wIG9yIHZpc3VhbGl6
aW5nIHRocmVhZHMgd2l0aCBhIGZsYW1lZ3JhcGggaWYgdGhlIGd1ZXN0LA0KZm9yIHdoYXRldmVy
IHJlYXNvbiwgaGFzIGEgZGlmZmVyZW50IHhjcjAgdGhhbiB0aGUgaG9zdC4gVGhhdCBpcyBlYXN5
IHRvIGRvIGlmIGd1ZXN0cw0KaGF2ZSBQS1UgbWFza2VkIG91dC4NCg0KPiANCj4+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rZXJuZWwvZnB1L3hzdGF0ZS5jIGIvYXJjaC94ODYva2VybmVsL2ZwdS94
c3RhdGUuYw0KPj4gaW5kZXggMGJhYjQ5N2M5NDM2Li4yMTFlZjgyYjUzZTMgMTAwNjQ0DQo+PiAt
LS0gYS9hcmNoL3g4Ni9rZXJuZWwvZnB1L3hzdGF0ZS5jDQo+PiArKysgYi9hcmNoL3g4Ni9rZXJu
ZWwvZnB1L3hzdGF0ZS5jDQo+PiBAQCAtNzk4LDcgKzc5OCw4IEBAIHZvaWQgX19pbml0IGZwdV9f
aW5pdF9zeXN0ZW1feHN0YXRlKHVuc2lnbmVkIGludCBsZWdhY3lfc2l6ZSkNCj4+IAkJdW5zaWdu
ZWQgc2hvcnQgY2lkID0geHNhdmVfY3B1aWRfZmVhdHVyZXNbaV07DQo+PiANCj4+IAkJLyogQ2Fy
ZWZ1bDogWDg2X0ZFQVRVUkVfRlBVIGlzIDAhICovDQo+PiAtCQlpZiAoKGkgIT0gWEZFQVRVUkVf
RlAgJiYgIWNpZCkgfHwgIWJvb3RfY3B1X2hhcyhjaWQpKQ0KPj4gKwkJaWYgKChpICE9IFhGRUFU
VVJFX0ZQICYmICFjaWQpIHx8ICFib290X2NwdV9oYXMoY2lkKSB8fA0KPj4gKwkJICAgIERJU0FC
TEVEX01BU0tfQklUX1NFVChjaWQpKQ0KPj4gCQkJZnB1X2tlcm5lbF9jZmcubWF4X2ZlYXR1cmVz
ICY9IH5CSVRfVUxMKGkpOw0KPj4gCX0NCj4gDQo+IEkgX3RoaW5rXyBJJ2QgcmF0aGVyIHRoaXMg
anVzdCBiZSBjcHVfZmVhdHVyZV9lbmFibGVkKGNpZCkgcmF0aGVyIHRoYW4NCj4gdXNpbmcgRElT
QUJMRURfTUFTS19CSVRfU0VUKCkgZGlyZWN0bHkuDQo+IA0KPiBCdXQsIEkgZ3Vlc3MgdGhpcyBw
cm9iYWJseSBhbHNvIGlzbid0IGEgYmlnIGRlYWwgZm9yIF9tb3N0XyBwZW9wbGUuICBBbnkNCj4g
c2FuZSBkaXN0cm8ga2VybmVsIHdpbGwganVzdCBzZXQgQ09ORklHX1g4Nl9JTlRFTF9NRU1PUllf
UFJPVEVDVElPTl9LRVlTDQo+IHNpbmNlIGl0J3MgcHJldHR5IHdpZGVzcHJlYWQgb24gbW9kZXJu
IENQVXMgYW5kIHdvcmtzIGFjcm9zcyBJbnRlbCBhbmQNCj4gQU1EIG5vdy4NCg0KQWNrLCBJ4oCZ
bSB1c2luZyBQS1UgYXMgdGhlIGtleSBleGFtcGxlIGhlcmUsIGJ1dCBsb29raW5nIGZvcndhcmQg
dGhpcyBpcyBtb3JlIG9mIGENCmNvcnJlY3RuZXNzIHRoaW5nIHRoYW4gYW55dGhpbmcgZWxzZS4g
SWYgZm9yIGFueSByZWFzb24sIGFueSB4c2F2ZSBmZWF0dXJlIGlzIGRpc2FibGVkDQpJbiB0aGUg
d2F5IHRoYXQgUEtVIGlzIGRpc2FibGVkLCBpdCB3aWxsIHNsaXAgdGhydSB0aGUgY3JhY2tzLg0K
DQpJZiBpdCB3b3VsZCBtYWtlIGl0IGNsZWFuZXIsIEnigJltIGhhcHB5IHRvIGRyb3AgdGhlIGV4
YW1wbGUgZnJvbSB0aGUgY29tbWl0IG1zZyB0bw0KcHJldmVudCBhbnkgY29uZnVzaW9uIHRoYXQg
dGhpcyBpcyBQS1Ugc3BlY2lmaWMgaW4gYW55IHdheS4NCg0KVGhvdWdodHM/DQoNCg==
