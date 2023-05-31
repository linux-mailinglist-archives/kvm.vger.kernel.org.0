Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83781718AB7
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 22:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjEaUDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 16:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjEaUDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 16:03:38 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CFFC0;
        Wed, 31 May 2023 13:03:37 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VJPfvC003244;
        Wed, 31 May 2023 13:02:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=YAVRCDCNugkkU0QRQJFvFhQoDh0G7Xw+oh04whjvBjo=;
 b=UBMY+z5J3a2BqkLhxan+A5uJisbCAIFVz9xZZXiy1pSdIDBy7gCVgLIZI4NZxKCb/mVe
 +XPERuIAKssff4o5C5bONPgYSqD+t3iH3w7AV9UtqmPkxtktM1Z9RBmbzXmQj8PoImYO
 KVfPspKo5Jc6RXAYDufSw/dvt42g1KG9SR9ZwMoSWMhK6Xr9KQK4o+uy0wL0jdPeYZgF
 BIWiIhm1GwbbkO9jXFyLYUVTNaRQkFoMlsMJkxVf2iSfcQctZ7YFNz+fSmb6InYWPcgG
 iRMULCB9SoeFgTaDRMrVNflGlXy5imTSOrZ1oOGRloKQ0eUOuMCSoNLgHAm6BJQHftZ3 nw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3qugxdgajy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 13:01:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPvVO4rCOeUT2BqEA+g2C4CPzAxuK5PbmSXueF6mK2S/Zv3/i1LjkLHy6Wb6350lFErCT9lVVfSuhtkfqlAaC64uCISnPA6Zh94B7k6ivhRZAN+W00mD+OxqPml0DSGM+FdIeudd+OQqjJ2tumqz3yaXDc0Xlh/xDcQjf+l3Qu0C6L0yuCYx5jVYj+NUNSuinSFIoXyNCJWIFU4PYwov+YoIPM2ZtIrdIEnKJ3z0IpCY9UiixsVa03IB5ceYOncctMoFwxxfLWlDvsq2NwzdSllWee+S0EM2DlqKMZzwcsGf+hHk4QvUDqybPugVbTSEJyBXk1ib4BhDWHnnQoBAdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAVRCDCNugkkU0QRQJFvFhQoDh0G7Xw+oh04whjvBjo=;
 b=H8PHA2ZjkfsnScn5WO2ZCrIlOwHVlKk9Xeku1e2b3mmPcwceFQ4/vYBsd4xn3zX1DxO9r3qBHGZ3bZg6lv55Vy0H2eMZzSYAcSL54LbY83A/vfB7rsDhqUYFVZ5IpgIVRGIpUuVQak+frXWJH/8BfncQBsRtyAW0sKTzD/T4pSbY9yrRX1IEb6ePnPO7RfTxyslHvwycyP1v6Sq0wnC3Kt3cJs5nPqKMLvItDZVZ5OecO6LYKDv/bSDHE372rkeQBc/IhvNYyhmz6Sd0HuEOaPvtPqRsHCvkLUiB1qDkiFPMyQLVkkBbvvm+0MSpdy6hce6XChXOiNPmvH6dFGiCyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAVRCDCNugkkU0QRQJFvFhQoDh0G7Xw+oh04whjvBjo=;
 b=CVsJZYHvqM0SwM/iA8uN6RPuqzu7zEpbzJ/Qt7/NxtRRJKzxBzI52+9T2N6Tq8AQ4716+KwkqRNRkuXEws0780sFPEEgdO+RfyqLX4I9SsLPRqZaG9/q6jJQrm0p1Rhnho5e9psLaJgfJ2CAJtNXoaye2NjdHdiK1RZfWQL07s6lLtZ+sI2bn/rjUwXSHQQe8pMetQJQaaTLhuT03Ww2eiSZb1Y5rmi5upzqhexGt51ZhFUvCq96bCru9a3HDxX0W/RxWAAtRgaGlVlBhS3BGbCPdcOx1SoWoEyLaZuyWzVaXKywrGjvOw3iC0PoK3QIcCj2Et56XnaYTpQyPWKcpw==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DM8PR02MB8279.namprd02.prod.outlook.com (2603:10b6:5:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 20:01:21 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 20:01:21 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK set
Thread-Topic: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK
 set
Thread-Index: AQHZkzGeQS8mbCm9w0qDUFkji8V8m69zY/WAgABO2ICAAOFbgIAAOsmA
Date:   Wed, 31 May 2023 20:01:21 +0000
Message-ID: <E17EFDD7-C54A-4532-B1D3-D567557FC54B@nutanix.com>
References: <20230530200152.18961-1-jon@nutanix.com>
 <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
 <F4AFC5EE-9967-4117-BA85-ED82C106575C@nutanix.com>
 <ZHd2P6D142rCByrm@google.com>
In-Reply-To: <ZHd2P6D142rCByrm@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|DM8PR02MB8279:EE_
x-ms-office365-filtering-correlation-id: 5aece5f9-3373-4e53-aea2-08db6211cdfe
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qb+b8At2IYZLv5/TCCYotEWobtA/aJw3LldHsQyrUUjHae9ruB8m9Qwt6qU38d9zZbHTrw/C+pShhiJfOS6kEErzRbT+1MynG6X5HsIqLNp4e3qF4weSwahZX+Znx94aWCDh4vvZXEDU+IuFDSCOl1wOsQBx+X/c3hDWhbqvaikwFPk4w40mpzbFDsG3eccldJedqVieUV9zry2KBvBFzNQVrmCD6runnd+6x7fx2JNywpkcdFE4gOAGAXMAQjT/SbUtsIDEazWiuOxEkPLCB9X9715gJ8EAnXmpT6kUSLgtv3XSfmJvE1NCASRHjjcTzNtNON+PKC5O/67WtL6buqJNm9VHUyBtgO1LsgbDizZXGC23rppmTuvzhrhvzy6A2aw/wiPiEGCAIvqfR8U5ZEowNRADwPT5RxEsPkqTcq3+LLFAvuhlZB+8jdVXCfPGOJGoWGnIvCJwtnXRNzRsppe4QMs/5PqIc63uApZzJ2ExW07dZy3MhH9W3qGvpjlMnsGJ1NPF9j1o8OFGXIxsMEZrbreHvyF5axmeMpZRO+Ks3kPozwRjaim3BS/9rgewPfYU7cuU3WEKrPr2oRdsfUehjHnyTn3MQiAGofPQYXuOB7xYzKkQZw84Xtb57CBg1U7zp18fk3b6ch7X+5084w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199021)(6512007)(6506007)(186003)(83380400001)(53546011)(2906002)(2616005)(36756003)(38070700005)(4326008)(316002)(66899021)(6916009)(64756008)(66556008)(66446008)(76116006)(91956017)(66476007)(66946007)(6486002)(41300700001)(122000001)(54906003)(33656002)(71200400001)(38100700002)(478600001)(8676002)(5660300002)(86362001)(8936002)(7416002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmJ5eDRtVGc1QjlicVk2eS9GMVMwa1FYWmNKN3J5QWo1M1RCVi8zZUR5TFd4?=
 =?utf-8?B?bUU1cG55dzk2UzJaMDM5cjlneDBURkR0VGpHc3JQbXl5WXhSdlhEVlNCeERM?=
 =?utf-8?B?czZmUG5wSVh4RlFIS25EdGVTaDVDMnhuWGpzUXlHRGdGRlRKMDdvVTl6ZStt?=
 =?utf-8?B?d2NCa2tCRXo2dnJLRFRIdjdvNGdJZTlqcERzN2hOWjByM0MyazJQbXZ4R2lJ?=
 =?utf-8?B?SXdPWWkyaWdvUEYzak9YVG9QVVl1djZMS040TjBXL2ZRQUlabm9vQ2hoSHZr?=
 =?utf-8?B?ZGNVbkFsbkcxVGNQaXBvVVRTVzd6bnlUU05mYXVzQ1ZJditGL1NQRjNBcU1V?=
 =?utf-8?B?QW1sT2tqYnlibTZJeEVVeEMvQ0MyalhzUUtaVDF4L1JzUjlJd0JTVmFKN25U?=
 =?utf-8?B?ZndwRmpPYzd3cm0reUh3M3owMDBSNWhobmlOdG5BNTFLNytzYUpVN21hN1Fw?=
 =?utf-8?B?QjlGd0xqL3pqSEd2RllCdHEvNXJMWkY5ZDVFb216dWEzalJBanlFbkZtRkVw?=
 =?utf-8?B?dDNwbCtNalVnT1Y1bEFWeUdXMWZkSUpKVDlLelBZaTA1aWwrMjIrN0pkOENF?=
 =?utf-8?B?NU9LWjZLdWNzUVlkL0VvRHdOMHpPQ3hsUXk0ak8vNlhXNW5URkh6WkdVUkti?=
 =?utf-8?B?M0xUVlFmUkRNVlkrakJTYWl3aTg4aTFkdlpSbGhWVmpZcUxnOWVOcHhpWEtq?=
 =?utf-8?B?TmdPSTJLTG1IaHFXK3labkZxMkxlcUx1aU9qNjFPODYyY3c1eUx5Qkc4OFM1?=
 =?utf-8?B?YkxNWUJnT3lLQnJGR1FwMnp4TkpQVFY4VDY3Z3lvdXpNRHBJb0Nxa29iWG1R?=
 =?utf-8?B?d1hScEFSWCt2TEhiRHFrQ1cxQkpBV1RqaXJPVEdGY1FyRDNhdjNYVHRGUFh5?=
 =?utf-8?B?bFRrd1J0azlhTU4weXJ2dzBmTENiT21ISGw1dE9CVnRDNS9USVhJSWpjcDlO?=
 =?utf-8?B?bEZjTGhMb1ZqR0dTYVJTdnNUeW1vWTlGNkdUQjRHQjZMa3o5eGovZ3VQMG1E?=
 =?utf-8?B?R0hhT0U1NEdqNHFSL0pZWkE1Y3dqU3pzQkFqVHJKN2pTenJUVW05TDVCRmVO?=
 =?utf-8?B?VnA5RjJTcU1ZbWYyU2Y3K01WTEZJSGVtQzBRUFlKb3g0WFo1Y2xyNEc5dmlV?=
 =?utf-8?B?ZC9ua2gxczRWZW1xQU9IMUNJMWh1TkJHSlRuNjU3YUhENHp5OGdlcElybGRZ?=
 =?utf-8?B?dVZpWjNpcHhHdXlXbTVmUHpaLzZrZzRoR3JhNmNmVlMxTFZrQm9CV29WTExU?=
 =?utf-8?B?UU0zQ25NRkVlOEtNbnZpUjhjYUZYbHlIeENqYTgrOVdnVlNEcmlHWkIvc21M?=
 =?utf-8?B?WmZpMFBrM04ycmoxNFFhVnQzRHJXcEdQZHJ5Y293ZmQ1cFZEWnNOZFBEL0cr?=
 =?utf-8?B?dms1TGdwejhKeVVCWjBYU0JXcmZtS2NhUkUzWFJiNW5MaFgzKzB5ZzZMTFpv?=
 =?utf-8?B?VG9xQ1huV0xsa2VVdmw5ODB5SmNOL2JwSHFXV1Z3S1RvSU9hTHloT2FvVG01?=
 =?utf-8?B?VVQrYlZ1ZTUrMjZPSGFWQkdLU3pzTFR5S21BYi9tbG0xMUJzMjFQMVBKZ1Jm?=
 =?utf-8?B?UUViRWp5ZFVESzFDKzNFTlNxSXZvcVFTclB2OXphSFpTaWNrTm81b2t3dnY4?=
 =?utf-8?B?QVAxNVNxZVN2enZOenFoSjBIYzFiMjViYU9TcWZyNWhKdk9yak8ramh0ZXZP?=
 =?utf-8?B?akdpbUhrNnlsSUVPY2UvRzZpZ29nY00vOGNZOFBCaVlMdXFHNmZnQUNCUEND?=
 =?utf-8?B?bTh0UUxsWnZmUmVxMGo1RWZDa2ZDR0NSOEFtZERmNFVCelRWdzZlbUZnMGg3?=
 =?utf-8?B?T2ZGZHJPMFZTY3F2NEQ2N2d2Q0VmeDJLTnZkaE9qaXNvYXo0UGoydUQ4d0dJ?=
 =?utf-8?B?OVMwTm9Kc1ZHQW9nb0hvVnVoL0trWUVNN1RwMktyTFBMRnZWYWFSQVZtT2RX?=
 =?utf-8?B?TCtwUzNNdVBmTjhRdzJzdDljMlE4V0NxM0p6YkxWaUZ5UzQ1R25DQWVEclBw?=
 =?utf-8?B?NTdiR1UyQkxWVHJmYUdHRFU4aWVJc2UzZko3K3pONmlmQnBuQ2FxMkZ4dk5m?=
 =?utf-8?B?RFFMZzdhNW15dU91QVZ1RzlDblcxdFFTa3B5WHZSbWpxTlhOMkVITUN0WFVo?=
 =?utf-8?B?TCtLdDN2ZTIxZFNGOU9SZXhsdVIzUjdSaUVRSFUyeWNNbGpzZHVBN1NBODVN?=
 =?utf-8?B?UktubVFxYVpWWHd2YTg2WTQ2R1hveEUzSFlKSFVuZkhRVFB2STFnRjdULytV?=
 =?utf-8?Q?9mALQZr7xEhv6izydqyRjA+FtImQGd0NkiWYSeUTxE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F41A4D947E0AE14A8F1B2CCCA218D6EE@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aece5f9-3373-4e53-aea2-08db6211cdfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 20:01:21.2525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +TgHjayM2JvUhkZVFnipiVaGMlVMuGCedOS3OVh891IW/hbPkOm3Ack/urOfL06t41EdfpEeLaqBcfigT2JHVr8v/sDDTwckbkr3IOBWnrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8279
X-Proofpoint-GUID: tw1wbD_mQTt6IxO5_-nRZVVgd5VifmIA
X-Proofpoint-ORIG-GUID: tw1wbD_mQTt6IxO5_-nRZVVgd5VifmIA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_14,2023-05-31_03,2023-05-22_02
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

DQoNCj4gT24gTWF5IDMxLCAyMDIzLCBhdCAxMjozMCBQTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBNYXkgMzEsIDIwMjMsIEpv
biBLb2hsZXIgd3JvdGU6DQo+PiANCj4+PiBPbiBNYXkgMzAsIDIwMjMsIGF0IDY6MjIgUE0sIERh
dmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBpbnRlbC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIDUv
MzAvMjMgMTM6MDEsIEpvbiBLb2hsZXIgd3JvdGU6DQo+Pj4gSXMgdGhhdCB0aGUgb25seSBwcm9i
bGVtPyAga3ZtX2xvYWRfZ3Vlc3RfeHNhdmVfc3RhdGUoKSBzZWVtcyB0byBoYXZlDQo+Pj4gc29t
ZSAjaWZkZWYgQ09ORklHX1g4Nl9JTlRFTF9NRU1PUllfUFJPVEVDVElPTl9LRVlTIGNvZGUgYW5k
IEkgY2FuJ3QNCj4+PiBpbWFnaW5lIHRoYXQgS1ZNIGd1ZXN0cyBjYW4gZXZlbiB1c2UgUEtSVSBp
ZiB0aGlzIGNvZGUgaXMgY29tcGlsZWQgb3V0Lg0KPiANCj4gLi4uDQo+IA0KPj4+PiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva2VybmVsL2ZwdS94c3RhdGUuYyBiL2FyY2gveDg2L2tlcm5lbC9mcHUv
eHN0YXRlLmMNCj4+Pj4gaW5kZXggMGJhYjQ5N2M5NDM2Li4yMTFlZjgyYjUzZTMgMTAwNjQ0DQo+
Pj4+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9mcHUveHN0YXRlLmMNCj4+Pj4gKysrIGIvYXJjaC94
ODYva2VybmVsL2ZwdS94c3RhdGUuYw0KPj4+PiBAQCAtNzk4LDcgKzc5OCw4IEBAIHZvaWQgX19p
bml0IGZwdV9faW5pdF9zeXN0ZW1feHN0YXRlKHVuc2lnbmVkIGludCBsZWdhY3lfc2l6ZSkNCj4+
Pj4gCQl1bnNpZ25lZCBzaG9ydCBjaWQgPSB4c2F2ZV9jcHVpZF9mZWF0dXJlc1tpXTsNCj4+Pj4g
DQo+Pj4+IAkJLyogQ2FyZWZ1bDogWDg2X0ZFQVRVUkVfRlBVIGlzIDAhICovDQo+Pj4+IC0JCWlm
ICgoaSAhPSBYRkVBVFVSRV9GUCAmJiAhY2lkKSB8fCAhYm9vdF9jcHVfaGFzKGNpZCkpDQo+Pj4+
ICsJCWlmICgoaSAhPSBYRkVBVFVSRV9GUCAmJiAhY2lkKSB8fCAhYm9vdF9jcHVfaGFzKGNpZCkg
fHwNCj4+Pj4gKwkJICAgIERJU0FCTEVEX01BU0tfQklUX1NFVChjaWQpKQ0KPj4+PiAJCQlmcHVf
a2VybmVsX2NmZy5tYXhfZmVhdHVyZXMgJj0gfkJJVF9VTEwoaSk7DQo+Pj4+IAl9DQo+Pj4gDQo+
Pj4gSSBfdGhpbmtfIEknZCByYXRoZXIgdGhpcyBqdXN0IGJlIGNwdV9mZWF0dXJlX2VuYWJsZWQo
Y2lkKSByYXRoZXIgdGhhbg0KPj4+IHVzaW5nIERJU0FCTEVEX01BU0tfQklUX1NFVCgpIGRpcmVj
dGx5Lg0KPiANCj4gKzEsIHhzdGF0ZS5jIHVzZXMgY3B1X2ZlYXR1cmVfZW5hYmxlZCgpIGFsbCBv
dmVyIHRoZSBwbGFjZSwgYW5kIElNTyBlZmZlY3RpdmVseQ0KPiBvcGVuIGNvZGluZyBjcHVfZmVh
dHVyZV9lbmFibGVkKCkgeWllbGRzIGxlc3MgaW50dWl0aXZlIGNvZGUuDQoNCkFjaywgdGhhbmsg
eW91IGZvciB0aGUgZmVlZGJhY2sNCg0KPiANCj4gQW5kIG9uIHRoZSBLVk0gc2lkZSwgd2UgY2Fu
IGFuZCBzaG91bGQgcmVwbGFjZSB0aGUgI2lmZGVmIHdpdGggY3B1X2ZlYXR1cmVfZW5hYmxlZCgp
DQo+IChJJ2xsIHBvc3QgYSBwYXRjaCksIGFzIG1vZGVybiBjb21waWxlcnMgYXJlIGNsZXZlciBl
bm91Z2ggdG8gY29tcGxldGVseSBvcHRpbWl6ZQ0KPiBvdXQgdGhlIGNvZGUgd2hlbiBDT05GSUdf
WDg2X0lOVEVMX01FTU9SWV9QUk9URUNUSU9OX0tFWVM9bi4gIEF0IHRoYXQgcG9pbnQsIHVzaW5n
DQo+IGNwdV9mZWF0dXJlX2VuYWJsZWQoKSBpbiBib3RoIEtWTSBhbmQgeHN0YXRlLmMgd2lsbCBw
cm92aWRlIGEgbmljZSBiaXQgb2Ygc3ltbWV0cnkuDQoNCk9rLCB0aGFua3MgZm9yIGhlbHBpbmcg
dG8gY2xlYW4gdGhhdCB1cCwgSSBhcHByZWNpYXRlIGl0Lg0KDQo+IA0KPiBDYXZlYXQgIzE6IGNw
dV9mZWF0dXJlX2VuYWJsZWQoKSBoYXMgYSBmbGF3IHRoYXQncyByZWxldmFudCB0byB0aGlzIGNv
ZGU6IGluIHRoZQ0KPiB1bmxpa2VseSBzY2VuYXJpbyB0aGF0IHRoZSBjb21waWxlciBkb2Vzbid0
IHJlc29sdmUgImNpZCIgdG8gYSBjb21waWxlLXRpbWUNCj4gY29uc3RhbnQgdmFsdWUsIGNwdV9m
ZWF0dXJlX2VuYWJsZWQoKSB3b24ndCBxdWVyeSBESVNBQkxFRF9NQVNLX0JJVF9TRVQoKS4gIEkg
ZG9uJ3QNCj4gc2VlIGFueSBvdGhlciB1c2Ugb2YgY3B1X2ZlYXR1cmVfZW5hYmxlZCgpIHdpdGhv
dXQgYSBoYXJkY29kZWQgWDg2X0ZFQVRVUkVfKiwgYW5kDQo+IHRoZSBiZWxvdyBjb21waWxlcyB3
aXRoIG15IGNvbmZpZywgc28gSSB0aGluay9ob3BlIHdlIGNhbiBqdXN0IHJlcXVpcmUgYSBjb21w
aWxlLXRpbWUNCj4gY29uc3RhbnQgd2hlbiB1c2luZyBjcHVfZmVhdHVyZV9lbmFibGVkKCkuDQo+
IA0KDQpZZWEgSSB0aGluayB0aGF0IHNob3VsZCB3b3JrLiBJ4oCZbGwgY2x1YiB0aGF0IGludG8g
djIgb2YgdGhpcyBwYXRjaC4NCg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20v
Y3B1ZmVhdHVyZS5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oDQo+IGluZGV4
IGNlMGM4ZjdkMzIxOC4uODg2MjAwZmJmOGQ5IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9jcHVmZWF0dXJlLmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVh
dHVyZS5oDQo+IEBAIC0xNDEsOCArMTQxLDExIEBAIGV4dGVybiBjb25zdCBjaGFyICogY29uc3Qg
eDg2X2J1Z19mbGFnc1tOQlVHSU5UUyozMl07DQo+ICAqIHN1cHBvcnRpbmcgYSBwb3NzaWJsZSBn
dWVzdCBmZWF0dXJlIHdoZXJlIGhvc3Qgc3VwcG9ydCBmb3IgaXQNCj4gICogaXMgbm90IHJlbGV2
YW50Lg0KPiAgKi8NCj4gLSNkZWZpbmUgY3B1X2ZlYXR1cmVfZW5hYmxlZChiaXQpICAgICAgIFwN
Cj4gLSAgICAgICAoX19idWlsdGluX2NvbnN0YW50X3AoYml0KSAmJiBESVNBQkxFRF9NQVNLX0JJ
VF9TRVQoYml0KSA/IDAgOiBzdGF0aWNfY3B1X2hhcyhiaXQpKQ0KPiArI2RlZmluZSBjcHVfZmVh
dHVyZV9lbmFibGVkKGJpdCkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiArKHsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgXA0KPiArICAgICAgIEJVSUxEX0JVR19PTighX19idWlsdGluX2NvbnN0YW50X3AoYml0KSk7
ICAgICAgICAgICAgICAgXA0KPiArICAgICAgIERJU0FCTEVEX01BU0tfQklUX1NFVChiaXQpID8g
MCA6IHN0YXRpY19jcHVfaGFzKGJpdCk7ICAgXA0KPiArfSkNCj4gDQo+ICNkZWZpbmUgYm9vdF9j
cHVfaGFzKGJpdCkgICAgICBjcHVfaGFzKCZib290X2NwdV9kYXRhLCBiaXQpDQo+IA0KPiBDYXZl
YXQgIzI6IFVzaW5nIGNwdV9mZWF0dXJlX2VuYWJsZWQoKSBjb3VsZCBzdWJ0bHkgYnJlYWsgS1ZN
LCBhcyBLVk0gYWR2ZXJ0aXNlcw0KPiBzdXBwb3J0IGZvciBmZWF0dXJlcyBiYXNlZCBvbiBib290
X2NwdV9kYXRhLiAgRS5nLiBpZiBhIGZlYXR1cmUgd2VyZSBkaXNhYmxlZCBieQ0KPiBLY29uZmln
IGJ1dCBwcmVzZW50IGluIGhhcmR3YXJlLCBLVk0gd291bGQgYWxsb3cgdGhlIGd1ZXN0IHRvIHVz
ZSB0aGUgZmVhdHVyZQ0KPiB3aXRob3V0IHByb3Blcmx5IGNvbnRleHQgc3dpdGNoaW5nIHRoZSBk
YXRhLiAgUEtVIGlzbid0IHByb2JsZW1hdGljIGJlY2F1c2UgS1ZNDQo+IGV4cGxpY2l0bHkgZ2F0
ZXMgUEtVIG9uIGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9PU1BLRSksIGJ1dCBLVk0gbGVhcm5l
ZCB0aGF0DQo+IGxlc3NvbiB0aGUgaGFyZCB3YXkgKHNlZSBjb21taXQgYzQ2OTI2OGNkNTIzLCAi
S1ZNOiB4ODY6IGJsb2NrIGd1ZXN0IHByb3RlY3Rpb24NCj4ga2V5cyB1bmxlc3MgdGhlIGhvc3Qg
aGFzIHRoZW0gZW5hYmxlZCIpLiAgRXhwb3NpbmcgYSBmZWF0dXJlIHRoYXQncyBkaXNhYmxlZCBp
bg0KPiB0aGUgaG9zdCBpc24ndCBjb21wbGV0ZWx5IGFic3VyZCwgZS5nLiBLVk0gYWxyZWFkeSBl
ZmZlY3RpdmVseSBkb2VzIHRoaXMgZm9yIE1QWC4NCj4gVGhlIG9ubHkgcmVhc29uIHVzaW5nIGNw
dV9mZWF0dXJlX2VuYWJsZWQoKSB3b3VsZG4ndCBiZSBwcm9ibGVtYXRpYyBmb3IgTVBYIGlzDQo+
IGJlY2F1c2UgdGhlcmUncyBubyBsb25nZXIgYSBLY29uZmlnIGZvciBNUFguDQo+IA0KPiBJJ20g
dG90YWxseSBvayBnYXRpbmcgeGZlYXR1cmUgYml0cyBvbiBjcHVfZmVhdHVyZV9lbmFibGVkKCks
IGJ1dCB0aGVyZSBzaG91bGQgYmUNCj4gYSBwcmVwIHBhdGNoIGZvciBLVk0gdG8gY2xlYXIgZmVh
dHVyZXMgYml0cyBpbiBrdm1fY3B1X2NhcHMgaWYgdGhlIGNvcnJlc3BvbmRpbmcNCj4gWENSMC9Y
U1MgYml0IGlzIG5vdCBzZXQgaW4gdGhlIGhvc3QuICBJZiBLVk0gZXZlciB3YW50cyB0byBleHBv
c2UgYW4geHN0YXRlIGZlYXR1cmUNCj4gKG90aGVyIHRoYW4gTVBYKSB0aGF0J3MgZGlzYWJsZWQg
aW4gdGhlIGhvc3QsIHRoZW4gd2UgY2FuIHJldmlzaXQNCj4gZnB1X19pbml0X3N5c3RlbV94c3Rh
dGUoKS4gIEJ1dCB3ZSBuZWVkIHRvIGVuc3VyZSB0aGUgImZhaWx1cmUiIG1vZGUgaXMgdGhhdA0K
PiBLVk0gZG9lc24ndCBhZHZlcnRpc2UgdGhlIGZlYXR1cmUsIGFzIG9wcG9zZWQgdG8gYWR2ZXJ0
aXNpbmcgYSBmZWF0dXJlIHdpdGhvdXQNCj4gd2l0aG91dCBjb250ZXh0IHN3aXRjaGluZyBpdHMg
ZGF0YS4NCg0KDQpMb29raW5nIGludG8gdGhpcywgdHJ5aW5nIHRvIHVuZGVyc3RhbmQgdGhlIGNv
bW1lbnQgYWJvdXQgYSBmZWF0dXJlIGJlaW5nIHVzZWQNCndpdGhvdXQgY29udGV4dCBzd2l0Y2hp
bmcgaXRzIGRhdGEuIA0KDQpJbiBfX2t2bV94ODZfdmVuZG9yX2luaXQoKSB3ZeKAmXJlIGFscmVh
ZHkgcG9wdWxhdGluZyBob3N0X3hjcjAgdXNpbmcgdGhlIA0KWENSX1hGRUFUVVJFX0VOQUJMRURf
TUFTSywgd2hpY2ggc2hvdWxkIGJlIHBvcHVsYXRlZCBvbiBib290DQpieSBmcHVfX2luaXRfY3B1
X3hzdGF0ZSgpLCB3aGljaCBoYXBwZW5zIGFsbW9zdCBpbW1lZGlhdGVseSBhZnRlciB0aGUgY29k
ZSB0aGF0IEkNCm1vZGlmaWVkIGluIHRoaXMgY29tbWl0LiANCg0KVGhhdCB0aGVuIGZsb3dzIGlu
dG8gZ3Vlc3Rfc3VwcG9ydGVkX3hjcjAgKGFzIHdlbGwgYXMgdXNlcl94ZmVhdHVyZXMpLiANCmd1
ZXN0X3N1cHBvcnRlZF94Y3IwIGlzIHRoZW4gcGx1bWJlZCBpbnRvIF9fa3ZtX3NldF94Y3IsIHdo
aWNoIHNwZWNpZmljYWxseSBzYXlzDQp0aGF0IHdl4oCZcmUgdXNpbmcgdGhhdCB0byBwcmV2ZW50
IHRoZSBndWVzdCBmcm9tIHNldHRpbmcgYml0cyB0aGF0IHdlIHdvbuKAmXQgc2F2ZSBpbiB0aGUN
CmZpcnN0IHBsYWNlLg0KDQogICAgLyoNCiAgICAgKiBEbyBub3QgYWxsb3cgdGhlIGd1ZXN0IHRv
IHNldCBiaXRzIHRoYXQgd2UgZG8gbm90IHN1cHBvcnQNCiAgICAgKiBzYXZpbmcuICBIb3dldmVy
LCB4Y3IwIGJpdCAwIGlzIGFsd2F5cyBzZXQsIGV2ZW4gaWYgdGhlDQogICAgICogZW11bGF0ZWQg
Q1BVIGRvZXMgbm90IHN1cHBvcnQgWFNBVkUgKHNlZSBrdm1fdmNwdV9yZXNldCgpKS4NCiAgICAg
Ki8NCiAgICB2YWxpZF9iaXRzID0gdmNwdS0+YXJjaC5ndWVzdF9zdXBwb3J0ZWRfeGNyMCB8IFhG
RUFUVVJFX01BU0tfRlA7DQoNCldvdWxkbuKAmXQgdGhpcyBtZWFuIHRoYXQgdGhlICpndWVzdCog
eHN0YXRlIGluaXRpYWxpemF0aW9uIHdvdWxkIG5vdCBzZWUgYSBnaXZlbg0KZmVhdHVyZSB0b28g
YW5kIHRha2UgY2FyZSBvZiB0aGUgcHJvYmxlbSBuYXR1cmFsbHk/DQoNCk9yIGFyZSB5b3Ugc2F5
aW5nIHlvdeKAmWQgd2FudCBhbiBldmVuIG1vcmUgZGV0YWlsZWQgY2xlYXJpbmc/DQoNCj4gDQo+
Pj4gQnV0LCBJIGd1ZXNzIHRoaXMgcHJvYmFibHkgYWxzbyBpc24ndCBhIGJpZyBkZWFsIGZvciBf
bW9zdF8gcGVvcGxlLiAgQW55DQo+Pj4gc2FuZSBkaXN0cm8ga2VybmVsIHdpbGwganVzdCBzZXQg
Q09ORklHX1g4Nl9JTlRFTF9NRU1PUllfUFJPVEVDVElPTl9LRVlTDQo+Pj4gc2luY2UgaXQncyBw
cmV0dHkgd2lkZXNwcmVhZCBvbiBtb2Rlcm4gQ1BVcyBhbmQgd29ya3MgYWNyb3NzIEludGVsIGFu
ZA0KPj4+IEFNRCBub3cuDQo+PiANCj4+IEFjaywgSeKAmW0gdXNpbmcgUEtVIGFzIHRoZSBrZXkg
ZXhhbXBsZSBoZXJlLCBidXQgbG9va2luZyBmb3J3YXJkIHRoaXMgaXMgbW9yZSBvZiBhDQo+PiBj
b3JyZWN0bmVzcyB0aGluZyB0aGFuIGFueXRoaW5nIGVsc2UuIElmIGZvciBhbnkgcmVhc29uLCBh
bnkgeHNhdmUgZmVhdHVyZSBpcyBkaXNhYmxlZA0KPj4gSW4gdGhlIHdheSB0aGF0IFBLVSBpcyBk
aXNhYmxlZCwgaXQgd2lsbCBzbGlwIHRocnUgdGhlIGNyYWNrcy4NCj4gDQo+IEknZCBiZSBjYXJl
ZnVsIGFib3V0IGJpbGxpbmcgdGhpcyBhcyBhIGNvcnJlY3RuZXNzIHRoaW5nLiAgU2VlIGFib3Zl
Lg0KDQpGYWlyIGVub3VnaC4gSeKAmWxsIHNlZSBhYm91dCBzaW1wbGlmeWluZyB0aGUgY29tbWl0
IG1zZyB3aGVuIHdlIGdldCB0aHJ1IHRoZSBjb21tZW50cw0Kb24gdGhpcyB0aHJlYWQuDQoNCg==
