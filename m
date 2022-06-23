Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEAA5588A2
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 21:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiFWTYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 15:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiFWTXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 15:23:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F054C7C53D
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:30:52 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NHurg0011020
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:30:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : cc : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8Re881DENuCkajHoiutZGB/ZT98+nitvElG5k6DCqos=;
 b=CHQgjDscAlQWUlgM8a6di4W20/syb7JiahIQcdDfE0KquTITgqacwXtHJ3yyBDDFk1hd
 EOEZLOJvEjMyVMVIWvVss3/X0UQixpHhhhxHOYH4wrsc8LowHb9GuMm4CtvhzKtHtVk6
 SdoQKcwXMWofM4Z/MgCF9747Fh2FWa8EO+g= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gvua991b4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:30:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7HQJ4MxGKqfSD3oi0kLhhPdIsU+7hdfCBGHVmbRDZ2klIObAfGrXHhF22AaBwtFqkc2nJDYu6cY+z1NLvjBT9eAVlvti5GTMwNoiPrHtjyrBK/TeSfGF7/v8EElYxvyDRhzzX79Q9ngvN3Aa2uCtx4Uc+hHel/E0/14JPOc0VZtb7ROe1PqjzFOJQ0R1yv3I4O+F6dxvLl2HKyYwqlIsCw1YNYC7siLWQSW6GMHyJQUVMHNhX1QOsQo6DLj7EPx8u1n3HB1goU6iaq/zMxegOCmOP5JJRdpERleAmnbJpopbZu0ncMQ20b4KBWwDjFn+RBp/CXJcb++3TCSoGazBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Re881DENuCkajHoiutZGB/ZT98+nitvElG5k6DCqos=;
 b=ALXgF2ffjnZ4s1kX32qe+xvb5Wh8W70D6Nvj39WVEbOgOYtUpOjBti4qiiAaEziHUw0b/D7tN8HObHNmEv/x0Ja8oruPx3MuWgn3/+ZdqKOCS8wQGRj8HSIJEBAWJp6jjVD+I64vuxcjPSOd6GaSL8Ce7OwIsaMDv9DpzOBlareI/1M8pr+qnJTchmXnihKAvzDxjNLVMN/c/XgP8r6PidO6d74HtnKCUfSJvn6Yqxv9mMWNkEIDKQGDC2RRExZcyI/vJOsWLmtT1Qx2l5fg34rDbH9Uno0dHtJAjZwlk7YS5L+uXTVqrYBX8soIHOmUk/+Y6f+o0OTNyZANcmeWkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB3032.namprd15.prod.outlook.com (2603:10b6:a03:ff::11)
 by BN6PR15MB1236.namprd15.prod.outlook.com (2603:10b6:404:e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 18:30:50 +0000
Received: from BYAPR15MB3032.namprd15.prod.outlook.com
 ([fe80::70d0:8133:42cc:f134]) by BYAPR15MB3032.namprd15.prod.outlook.com
 ([fe80::70d0:8133:42cc:f134%6]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 18:30:49 +0000
From:   Peter Delevoryas <pdel@fb.com>
CC:     Peter Delevoryas <pdel@fb.com>,
        =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@kaod.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "eduardo@habkost.net" <eduardo@habkost.net>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        "ani@anisinha.ca" <ani@anisinha.ca>,
        Cameron Esfahani via <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 06/14] aspeed: Add system-memory QOM link to SoC
Thread-Topic: [PATCH 06/14] aspeed: Add system-memory QOM link to SoC
Thread-Index: AQHYhvTPUJH87CoavEisp1v6WTjh+K1c7DYAgABkmYA=
Date:   Thu, 23 Jun 2022 18:30:49 +0000
Message-ID: <6C5B3AB8-C5B3-4249-B0F4-AEC3B5FF302E@fb.com>
References: <20220623095825.2038562-1-pdel@fb.com>
 <20220623095825.2038562-7-pdel@fb.com>
 <CAFEAcA-F59JEVBVYSdGX4KcS5d+EB4dNoZ2iE1aitSvo3B7Yfw@mail.gmail.com>
In-Reply-To: <CAFEAcA-F59JEVBVYSdGX4KcS5d+EB4dNoZ2iE1aitSvo3B7Yfw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50d8f282-7b01-4a8c-bcb6-08da55467f54
x-ms-traffictypediagnostic: BN6PR15MB1236:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sEPhfNsDBnPPgfoJN4WWEhsFPXHekf6fT78YOHzZqCMYdfnBhBmMxjSdm5AYMinDm4zHUJ0t+YHYZuP2c45tIoCnS8KeGlwZoX/sXsnzX2rY29RlaTKicCkTxJf8nAcSnSh405czuZTrzy3PnedcFsvK4jXQAV7hVz/xbv13xeyKtlNb3OP+tRJNoGOjQCC9Fv2VAKFSpI35j9Z4Eboq/nfjKTlriZiPxhm1NJOpof/gL/IvF3lrctAQHf+2dEsa6wrjwAtIGXURxWjMG2G1CTOAN8+/nheubMYYyIkpz+plyc+qSo455NWm/9HajmBzdXycxpNrr8HQ+tN2wc4kIvR3hInfLw82sCTnE9uOond2rGt/1RcStWJeyd5mHK21wlH82gK0AVyhswKo8yzVq7YVGa2MsF26INZiDy/pS76sopi6qM7U9q0lI56M3c7+eFXzDxFR7MA8D37QyDJ32Qn4OflbKQ9phtYs/n+JokyTTJUi+x0f7uNxQEbee2oxHeKEZ5ki8nP7AOKeloF6dGoF0IDaXbL+4dLxUu9shQUwenhDMxARKFPJPNHkhIgqKu5OkHWNd6mYfTmVFrf9ocdzSWuvGlCEE/7PBLr1Wj8y2HDChlDIfqvmEPlTxr+YWAFVAvW3zHpr9ODQm9/ID022rokxabIKjt3p82MimXKD53Oc/SC9Y3C/jljbH/Wocooih24OFdDizWIGc1IEVfAYpFPYp+5ZKshm9mmsJ1s5vE+PRGXGGXhB5qoYs6g8ijrkom/N0pssICFXz7m92es2Jy1PjEi4yBDsAYZygMcAjxsOpuhyMyYmMAva4+qXwurtGbkL2NpvRCAnNaM0KA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB3032.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(316002)(41300700001)(4744005)(54906003)(6486002)(478600001)(36756003)(66556008)(53546011)(71200400001)(76116006)(6512007)(66476007)(7416002)(8936002)(64756008)(66446008)(4326008)(33656002)(66946007)(2906002)(2616005)(8676002)(186003)(5660300002)(6506007)(86362001)(38070700005)(109986005)(38100700002)(122000001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sjg3VE16bXpKOXMrdWVONWtXZm9VS3VZUUdxdUNuUDhSeFdiWmNQUnh3RlRO?=
 =?utf-8?B?V2wyUVZzK3NKV1psOXNOWVJvN2d4M052djU4eFBhMGJwN3o1MWxycnFPZlJY?=
 =?utf-8?B?enFqdTdOQkJCNmJMMmsxZ0pmMUJlL2dzbDhyTFpQRkh6S29LakVyOU5MN21a?=
 =?utf-8?B?b29BdHp2TklBcGpvOVM2NklFTnRudUltYmxqNlZ4QkJreURvSmhuWlRrZjM2?=
 =?utf-8?B?eVBRbzBkN0ZGUzFjWDVYSHBNZzBzbjBnOVNEdHducGtJRzZYNGsxa0t3dktC?=
 =?utf-8?B?TjZjeDBOTUt2MVBpNlNFak0rL3VQdXNMVUMxRENwSDliV1psRzlJN1NuU0tQ?=
 =?utf-8?B?VmUyTjdiVDdSWXB3ei9FeEJTUWJsYitXWXNrT0QzS3B2QW1mV2dlT0Q2NTFH?=
 =?utf-8?B?OS9UdDFLOWpmODZjYjl4c2R0bXlZUElmQmhMZ1lHdFcyUndUTEJteDhycE8r?=
 =?utf-8?B?MzFTbTNoemNMMlgxR1RrbkQ0WGFGZk1ZdzdQSmZPSVkzSmlUZzl4ajhtWlVa?=
 =?utf-8?B?Z0duNHlYeTBvdmlTaUhLRzFTYjBhL0N6NGRIMnE2R2xUbnRCSElKQ1BtS0lL?=
 =?utf-8?B?VXk3TzJieUE5elAyYkNmRFlUU2ttSThnMEtlbVhZcFFDWVR3YWFmM1RzWFdW?=
 =?utf-8?B?NVNPUmFoanBuVm1ZVE5TTS9lc05IK2oyZkpnWmtVUjk5bVNmOEFXbnY1dzdO?=
 =?utf-8?B?WHJQeHhoUEVxV2JKU1IxMDZ1ck55R3FIcnlCOXBLSDJ1YUVxei9hTjhPbnFL?=
 =?utf-8?B?OWZiMmtxNGVSQ1kvbGZJRUNSZWFHeWdNbDYxeGtEMWUycjc1NTY1dDlER1cr?=
 =?utf-8?B?bWJwUGxRNEJIcEEzbWNDUnhZbStoU0tncDBUNDNFYSs1Z2srM0JOR3JLWlU4?=
 =?utf-8?B?c2IzYW85SGFTYmVMaEdVeWtTM3R3YnQ1TnpZbCtVMXRwNjRwbEZuV1lpZ29K?=
 =?utf-8?B?cWo0d1dsRWxjbkMxN2JrYnFKTFk4UFVUaUhDZ0FqYVNNYTRMZkRDMThXVjQw?=
 =?utf-8?B?WDR3Q3ZPR2ZYRGcvVU1UMUpQU1ZjWGlxNk9aQi9ZdTZGbnEzOWo3Nk1pSHJC?=
 =?utf-8?B?MmVhMTNRbTkySnVBVEhSTmJEbURESWh5MnZGSlV6MWN6N1c4THAvSEFsOXZx?=
 =?utf-8?B?bkM2UjkwOWNBcVh5b3QzK2Y2dVVnNGJITGpmOEx4OGprTXZQSTliVCtVWHU0?=
 =?utf-8?B?bktWdUJZdEV2MGtybkFXRm9QVW13L1kvcmVDcTJwOGRJREFXOEhZUlVHTWJH?=
 =?utf-8?B?Q2k0dFFWTHBmZ1I1UXFaOVdZd2tNSlZsMDU0Rmg4eGY1c0ErWmlTTHdzRmYr?=
 =?utf-8?B?L0pqZDRLK3hoL3l4VVcyV0t2VnpqYmU1YmZVcktzTzlyZ0lOeVZNUE1HNWFP?=
 =?utf-8?B?czYxN3hxanBZOElUakFLRFc3SUJGd1dJSjdlM3NZTFQzYTR1NFBpTkdVSEJK?=
 =?utf-8?B?ZGI1anhvbzd1RGR0R29EcXVXdUw0eElaOFpNbGw3ell1eU90MFBXLy9aVmFL?=
 =?utf-8?B?eFp6UkZBc3haejdDaHkxU2hWT2JtK0g3K0wrZWVwYlFwbTZWMFJaYlkvYll6?=
 =?utf-8?B?Tnp5Nk05cFNLbmlpZzNkQ1lzUC9oTWdkNnViT1dSNG4vaGRmUnVtM2JBREpm?=
 =?utf-8?B?LzArNlJ3MFZkSXJXYWJsL3hWT0l3WUlyS1RuMnF6NzNsT0tQQzJuVDMvTUl0?=
 =?utf-8?B?ZXpZVkxka2xNVFhPQXQ5L1ZGd3BzR0ZNb2pyY3JSTW81VHBpb2k4aHBSM2Uv?=
 =?utf-8?B?b1AyNHMzSjMrbHBHQ1hEVy9HUHZyc3VmMU44MTVnV2lwRDRxZ3F4T25pd0hT?=
 =?utf-8?B?a29SblJHYzV0N2RxbzNhY1p4MFA5allNQ1RoQ0RVSDU1N0EzNjdxWWdjNjVP?=
 =?utf-8?B?NFk4SW9tTEs1SDd1eUUvYWdLUWgxS1RRZEVIcUEySkx1Y2xFK0xVZWl3eVMx?=
 =?utf-8?B?S2FLUGdoRFVYMmErbHZtd0V0N0x5U2hEODlpRkF2K0UweTlBMGFaRnpZQysr?=
 =?utf-8?B?cm93OW1kMlV0dGhkWnVoQ3JnMUVwOGc4NmVBcjFuaUNJdDZwOHhIVmFSWFBI?=
 =?utf-8?B?b0RmVUZFT0hDZ0ljUlAyTXBpZEtrM2pZVExSa2RJaG5vZnEwUlJPZ3cxR2hl?=
 =?utf-8?B?c3V6SEVLMUZjSEoxQmpvYVRXaXBoNTUrT3cxMnBFVlBZTFBJWnN4RzgzcEJV?=
 =?utf-8?B?cU12ZThDMFdwZzlJRUlRSGdBUGFSdVVyZlFxV2JTZkJ5cXZVOWV5YzE1OVFm?=
 =?utf-8?B?Q29acmxzQm9lcmNvN3ZRTTR2V3N6UkNkaVNUYmx5czVpVXNTalRCVm5ZbmZ1?=
 =?utf-8?B?TlZaUXZrTkNQRnpMREErL3QvYkNpUFhLT2tsK0grWlRRcmZaYll4dFJqbTJr?=
 =?utf-8?Q?76R75kSgS8SLhHR0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B92A433052D3984099E7A7E35864D004@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB3032.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d8f282-7b01-4a8c-bcb6-08da55467f54
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 18:30:49.8052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CaSXjH4h7kaK3WTbS/LPCCu3WKx/Bjg3rawB84ARXfHKKKgJrQGQFbBi15cP2Ghe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1236
X-Proofpoint-ORIG-GUID: sNvpMpyXZYXGUrR9XmEsuMAaOFG5H_jH
X-Proofpoint-GUID: sNvpMpyXZYXGUrR9XmEsuMAaOFG5H_jH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_08,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVuIDIzLCAyMDIyLCBhdCA1OjMwIEFNLCBQZXRlciBNYXlkZWxsIDxwZXRlci5t
YXlkZWxsQGxpbmFyby5vcmc+IHdyb3RlOg0KPiANCj4gT24gVGh1LCAyMyBKdW4gMjAyMiBhdCAx
MjozMSwgUGV0ZXIgRGVsZXZvcnlhcyA8cGRlbEBmYi5jb20+IHdyb3RlOg0KPj4gDQo+PiBSaWdo
dCBub3cgaXQncyBqdXN0IGRlZmluZWQgYXMgdGhlIHJlZ3VsYXIgZ2xvYmFsIHN5c3RlbSBtZW1v
cnkuIElmIHdlDQo+PiBtaWdyYXRlIGFsbCB0aGUgU29DIGNvZGUgdG8gdXNlIHRoaXMgcHJvcGVy
dHkgaW5zdGVhZCBvZiBkaXJlY3RseSBjYWxsaW5nDQo+PiBnZXRfc3lzdGVtX21lbW9yeSgpLCB0
aGVuIHdlIGNhbiByZXN0cmljdCB0aGUgbWVtb3J5IGNvbnRhaW5lciBmb3IgdGhlIFNvQywNCj4+
IHdoaWNoIHdpbGwgYmUgdXNlZnVsIGZvciBtdWx0aS1Tb0MgbWFjaGluZXMuDQo+PiANCj4+IFNp
Z25lZC1vZmYtYnk6IFBldGVyIERlbGV2b3J5YXMgPHBkZWxAZmIuY29tPg0KPiANCj4+IHN0YXRp
YyBQcm9wZXJ0eSBhc3BlZWRfc29jX3Byb3BlcnRpZXNbXSA9IHsNCj4+ICsgICAgREVGSU5FX1BS
T1BfTElOSygic3lzdGVtLW1lbW9yeSIsIEFzcGVlZFNvQ1N0YXRlLCBzeXN0ZW1fbWVtb3J5LA0K
Pj4gKyAgICAgICAgICAgICAgICAgICAgIFRZUEVfTUVNT1JZX1JFR0lPTiwgTWVtb3J5UmVnaW9u
ICopLA0KPiANCj4gVG8gdGhlIGV4dGVudCB0aGF0IHdlIGhhdmUgYSBjb252ZW50aW9uLCB3ZSB0
ZW5kIHRvIGNhbGwgdGhpcw0KPiBwcm9wZXJ0eSBvbiBhbiBTb0Mgb3IgQ1BVICJtZW1vcnkiLCBJ
IHRoaW5rLiAoQmV0dGVyIHN1Z2dlc3Rpb25zDQo+IHdlbGNvbWUuLi4pDQoNCk9oIG9vcHMsIHll
cywgaW4gaGluZHNpZ2h0IHRoYXQgaXMgdmVyeSBvYnZpb3VzLiBJ4oCZbGwgY2hhbmdlDQp0aGlz
IGZyb20g4oCcc3lzdGVtLW1lbW9yeeKAnSB0byDigJxtZW1vcnnigJ0uDQoNCj4gDQo+IC0tIFBN
TQ0KDQo=
