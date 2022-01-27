Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C7849E52B
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 15:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242562AbiA0Owt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 09:52:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53858 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242696AbiA0Owo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 09:52:44 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20R2i8c6027476
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 06:52:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=POuSnQTLrViN9T1EEOlUF76qQp6KqvYJWCNjp0X8MZM=;
 b=DLaW0y2sWOXl/vQaAN7SfXpdZRmmvEmhCGFk2AxaIKlGNkrJtnCZxCo3W1kWhCMN8YFp
 e3AOI8ToK+drRo/VLG7LXYSKU7ErNXFH2F/7q8i+7ZLAYWfsR5iGauA9/O1VY24UAwUx
 wf0Sdy+yXHVXHNusVGvqJMt1EW9x1J45fb8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dujv3u16q-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 06:52:42 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 06:52:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWeIcoUcPhRd+Zoa7OZkJU8Gc+2YTKaUoCYyG1/vGZGGjemiSeCNn1t4p14D3++j0RxsukOahLY+IuVfLy8O8KQLnguQgwdn4r4KMSVtqhH4OP0Rcs3/PzExG7KEVPHTWSTuCmEMwRRx1JG/gObSzgWGtE27KDmDO1kbJPjH9LtorQO8Tex4YfEG1znYInzR2CgX/thzDg7YdKA2KWk9Am9KohHJaZNFZwSs25wAWCDNyi9NlVrgtoHHgmD0JRmFsfgBIavNK182KFDru3n4S6q3nnxHyZ8i2gbiR/ee6MmZ/YWEtRuzePWR06B5LMWKwpiTc+wMy6ygIyVZk4ajmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POuSnQTLrViN9T1EEOlUF76qQp6KqvYJWCNjp0X8MZM=;
 b=QIKXfb9QJFF8SgkxYMf0lHBDPq6jl3gYq0rVS3IIfoofHWTsbj+kSL/4APfqcF1eB0vE8QRJLLDamo1WWQw+liw5I2tuHlywQ+/JRZx7QMJBIeT2x9gsUNbrulqf5J0fjHiWNJfgiO1snGwsK3WUhIUXbx3y1yk6LqhJLpuvevFZFo4NQqglXs9riHaRM+O0XkQ7uJgMmYSb/pc8/kztkqBKm5GmtzBadrlxKI3iOBu//C61eWc/bc4IlMZMeY/QDIqQRXLxbv3kXM9pK6YS/Cya80PV+2DV7XjMm/2X7HeqYRWmiS2nJKtmA55av7IfgjeAeoJG3dYuG9oq0VpLwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MN2PR15MB4287.namprd15.prod.outlook.com (2603:10b6:208:1b6::13)
 by SN7PR15MB4160.namprd15.prod.outlook.com (2603:10b6:806:10e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 14:52:39 +0000
Received: from MN2PR15MB4287.namprd15.prod.outlook.com
 ([fe80::3102:7e69:9b1:3d30]) by MN2PR15MB4287.namprd15.prod.outlook.com
 ([fe80::3102:7e69:9b1:3d30%6]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 14:52:39 +0000
From:   Chris Mason <clm@fb.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Boris Burkov <boris@bur.io>,
        Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Thread-Topic: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Thread-Index: AQHYEu6ezDBN9b9XPkaUx3YvgIhZsax12f4AgAAUH4CAAA5vgIAAzhqAgAAqi4A=
Date:   Thu, 27 Jan 2022 14:52:39 +0000
Message-ID: <DFECB1B9-9A83-48B2-92F1-74D8BA77C728@fb.com>
References: <08b5b2c516b81788ca411dc031d403de4594755e.1643226777.git.boris@bur.io>
 <YfHEJpP+1c9QZxA0@google.com> <YfHVB5RmLZn2ku5M@zen>
 <3876CE62-6E66-4CCE-ADED-69010EA72394@fb.com>
 <3f4efc3d-f351-0fcb-e231-b422ea262f66@redhat.com>
In-Reply-To: <3f4efc3d-f351-0fcb-e231-b422ea262f66@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdf3feed-9ac2-448e-eec7-08d9e1a4aa4b
x-ms-traffictypediagnostic: SN7PR15MB4160:EE_
x-microsoft-antispam-prvs: <SN7PR15MB41605EEF105501CD98988037D3219@SN7PR15MB4160.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: syxpVR9scZd/TwzIVpeTbFccMLufyD53M+ff0b7cnSZG9rEjW/M+sDv5jz1fQ6zfRQMKY43slLtEOkeoNsHncYR9ezhnp9sw4Z77u6791JF9kpsWe3hRNY3OhpsRPEhmQULbKQjvNFBJVy16OTRRyfWancZSUQTiXu/uozVzedPqCueHH4qcAI88AqNWuJQ6cvSIIn9z0VFizgN+ox53FmcAmptsSN0MOcoHc0ZCCxsBKJIK9UT7Xi8xGPo3vbvZqKxccfGe1WtsYYvCxV6j3gXu0tdapuDXAKB6bF9Se+YQtINCWbLQ2qyl7xvYIFmP7n9R2zvXEglica91+mW2afY4TkUI7MsZ28Cn4LVBblRD1nkqXJfqsd2p/+T1KxRJ/bpmMSqx1TyfZxQ49cYZBpzAJmCSCo9aaf/3BJzdE1H31elOm44fqhe04/suj40ONJZ2NRkMSjmm+41vDCXoIrPmvaYNIDXx2vhomOcrtEmG3cLfGpeGH+TKrTFW6k7fFqOLVe3rRgZhA9m2ECXfO2jOqJ06xeCsoru7xr4KtSlRg7BkDpjA5KDZhAhlNL7BqPd9duM6gZ7TM2zbK+TJAIqABl4/LfNprVAtEBQ+75YizxGFWrzdslD5d/cSMS3+jJBqB0Yx3sT4umsmtyJIbJeXLR2XWsHR06J0Krizwd+KKqDiocFZ2XuH4A68EX65+FpyjqQD0LDFTXLI8Slv4OCpf88kLamSNwUouZ4pBYwasliZ6BhgWBOqIfSOn86ABzzvgz4eXP3lfF3hNPOMIT+4G4JMMuR0L6Fwy28xjErNdFafkNDw7Ojh2f/3ayZEMkeQdALjWiKr0T9GJ7ookw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR15MB4287.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(316002)(76116006)(66946007)(6916009)(6506007)(6512007)(508600001)(4326008)(5660300002)(66446008)(66476007)(64756008)(66556008)(8676002)(53546011)(8936002)(36756003)(966005)(6486002)(71200400001)(33656002)(2906002)(2616005)(38070700005)(54906003)(38100700002)(122000001)(186003)(14143004)(45980500001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTdpL0dKbWRwQlU0SXZRcnNQSDE0OUVRZlUxSEpJVmF3TndTVE9zMlMzVndE?=
 =?utf-8?B?UDByeGdqTVN1UGlERjlOdWNyenhLWkF2ZERUUDNhRTdVTXZqdW12c1k0N01D?=
 =?utf-8?B?dHRoWGNQNEU0eGU1VDQ3VWV4dEkxMjVtd3lIaTN1YzhmbFI2eXlOczdiU1FU?=
 =?utf-8?B?NFd4bmxhZmxZbE0zcmVLbEJod3Y1bTA5WG95SWo4enBaQlB3Q1hmb3JFLzVV?=
 =?utf-8?B?d280MFVKZTlUbWdsd1dDQ1RlM1E4dHppQWt1WVBHQXlpR1c2aEduMytOWG5W?=
 =?utf-8?B?akRMV3dUNWE1T0NtV2VaMmViN2doWVJLdEF1N2JFMytvZ285d1BOc2MwcDEy?=
 =?utf-8?B?N2pOTUN1MTViNlBwTmF0aDRsU0cxMkMyUmhvWlhIWVF1Y294MmlWVXdvK1hz?=
 =?utf-8?B?cm5RWng0L291dzFjcFhGR0ZBQm5mTkIzTHpQc3hmc0FuZWgzZFhkVi80V3Fo?=
 =?utf-8?B?YnUyU3g5YVdIMURlQVhsN1UyWlRDMklCa0p1bFVpYXZFOXNKK1NoTHhuQzgw?=
 =?utf-8?B?UWViS2I0NUlHbzkydlZVNVN4Z1BCQUMyUUtRSEgzWjlCL2kyYjFtTThHa2c2?=
 =?utf-8?B?bWRsKzhuNmw0dXJ1cjNNNkpGQnRydEZNaS84ZTNUUnBqUHlHTitVWURIMzFT?=
 =?utf-8?B?VTFxU0hYZ05TanJCZllLcVczekg0T044UkkrbGxzUnNPT01nWjY2dUIyRGpF?=
 =?utf-8?B?TVpqK1dQcDV5MGZKUjB3U1NkZWRRQnRnc294REJ6SFJhMjBKdkM0bU10cjRw?=
 =?utf-8?B?ZmltSzEzS3B5MUlzY1JjbjRkVFVrYnVMbVM3dkpsVUtyb0RRVlFvY0Z0UHVM?=
 =?utf-8?B?bnlIVlJMU2hXclZVT1cxWjFCcm96L3JtMWRjcEErOTl5a2UwVy9BRlNlcmJB?=
 =?utf-8?B?UEhvSjBNa012UFlkM0hNbjYwcDFnNFNGV255T3RSS2V3QVlmbW42cEVObGVh?=
 =?utf-8?B?bmVINFBvK25PaWlyTDlVTVZNTGhEWUhiTGh0bHBTcHpQVlZMcmNxVXNoQXVP?=
 =?utf-8?B?Ky9hUEd1WmpOSHpCQ25GK1ByNEVNMmoxNDVNMitybFhlaDZxU3NubFJvOEwy?=
 =?utf-8?B?WDF0Q2phcTVMRS80UmdDTzdtRDNPNG1OZTFlQlUxbnA4YmhnaU11cDZ4Rmtx?=
 =?utf-8?B?M25BWlN5ZVZhMGxJbnR3YldXcXd5TnNuRklrY0I5MGVjNUV4MEdMK3RiNHc4?=
 =?utf-8?B?c0RNWDNGMWRmNVBsNEkvT0YrYUJYaDlxRnh6QzBOOGo4aGE0ek9PbHFERGJZ?=
 =?utf-8?B?WnJ3Q1J0VDBCVVdqS2h6eDFDUzhjcVZxOUR3TlZmNUROcTQzZnFlNnFjdXJI?=
 =?utf-8?B?cHlobTlDVjVYSkhvWmtTWEtRaVAyZ1lCMFZHanVMbXdyTkN5b2kwR2RuS0FC?=
 =?utf-8?B?ME5WcWpyTGxrNzFUbzRUSFpVd3Zzd2dXWEs4dVNyRzJLd1JBVm11YkFxN1gz?=
 =?utf-8?B?b3dadDZnNkFtcWNCVGxxcDQyMWFQQ3FyN1FiNmFXRTFiNm1QYWN0L2x2aTlX?=
 =?utf-8?B?TVY1NyszSDBibjlmUFV5dXFJVEoxS2d2SUREVFh2SC9zWWk5ZmMxK3F6QzVy?=
 =?utf-8?B?Z29iY0V0dExrYVlUdGRSZ1FaTzA4ak9saHBLYm9FOWN6TWExMlFIK09UNkpU?=
 =?utf-8?B?RUNsVmdVa1h2Y0FXT3Zqd3NHSGlUbGJmZ2hkd1Z0MGh5R2hjOTVjYThqUU8y?=
 =?utf-8?B?R2YrVWZEbm5DZERWQVoxdGF3ZjFTT0MvajBQYXFVekVYOUdNelc2YlBRSVNP?=
 =?utf-8?B?dEIwdzRPdjArSWRkWm0vSjk0VE9wVGFxNUk0eGRSMlBrT0ZuNHlaUmhIVml1?=
 =?utf-8?B?UjU4ZjVUeEo1NHF4NkNHT0UrL2lMR215dFZpQTZkeG9kK0krbkc0WGh3UXNY?=
 =?utf-8?B?OUphMmcraVVBUVVyVDVzakJFMmZNTEo4ejBiV2tDSGRRQkJ1dENWeXF6MWs3?=
 =?utf-8?B?dnZTKzNnekd5SUljZ240bGtQSjYxV09NeVEzVm9oeGNaY2o4K1JoOHZQbjZB?=
 =?utf-8?B?a0JldDFKd0k5L3FYQ1piL3E0NXN1TWhob2l6dHpTQTVKaHVmNVpvcmNMZEls?=
 =?utf-8?B?Z2ErcVZ2dU9TNURkQnowcmo5NUJUcG15UUZjKzZZMVJFWHRuMXVCQWZESVBk?=
 =?utf-8?B?NENoOEJOSis4bnVWbDMyN3BkL2VLSTBLbkRBOUxzb1MzMDdrZy9tRUdXa0VN?=
 =?utf-8?B?dlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F640C4BA7AFE241B5DD339C7379D0D6@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR15MB4287.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdf3feed-9ac2-448e-eec7-08d9e1a4aa4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 14:52:39.6687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QkqPT+boPSEHc8/KQRJPEmnvzvZdBdIOrCl2UzsCRksR80LB8t+2JfUOLwrDsBAc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4160
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Moz4pCJsTsKTUbSm3y4Ks1PqXX8VXh6a
X-Proofpoint-GUID: Moz4pCJsTsKTUbSm3y4Ks1PqXX8VXh6a
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=843 spamscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201270090
X-FB-Internal: deliver
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IE9uIEphbiAyNywgMjAyMiwgYXQgNzoyMCBBTSwgUGFvbG8gQm9uemluaSA8cGJvbnppbmlA
cmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiAxLzI3LzIyIDAxOjAyLCBDaHJpcyBNYXNvbiB3
cm90ZToNCj4+IEZyb20gdGhlIGJ0cmZzIHNpZGUsIGJhcmUgY2FsbHMgdG8gc2V0X3BhZ2VfZGly
dHkoKSBhcmUgc3Vib3B0aW1hbCwNCj4+IHNpbmNlIGl0IGRvZXNu4oCZdCBnbyB0aHJvdWdoIHRo
ZSAtPnBhZ2VfbWt3cml0ZSgpIGRhbmNlIHRoYXQgd2UgdXNlIHRvDQo+PiBwcm9wZXJseSBDT1cg
dGhpbmdzLiAgSXTigJlzIHN0aWxsIG11Y2ggYmV0dGVyIHRoYW4gU2V0UGFnZURpcnR5KCksIGJ1
dA0KPj4gSeKAmWQgbG92ZSB0byB1bmRlcnN0YW5kIHdoeSBrdm0gbmVlZHMgdG8gZGlydHkgdGhl
IHBhZ2Ugc28gd2UgY2FuDQo+PiBmaWd1cmUgb3V0IGhvdyB0byBnbyB0aHJvdWdoIHRoZSBub3Jt
YWwgbW1hcCBmaWxlIGlvIHBhdGhzLg0KPiBTaG91bGRuJ3QgLT5wYWdlX21rd3JpdGUoKSBvY2N1
ciBhdCB0aGUgcG9pbnQgb2YgZ2V0X3VzZXJfcGFnZXMsIHN1Y2ggYXMgdmlhIGhhbmRsZV9tbV9m
YXVsdC0+aGFuZGxlX3B0ZV9mYXVsdC0+ZG9fZmF1bHQtPmRvX3NoYXJlZF9mYXVsdD8gIFRoYXQg
YWx3YXlzIGhhcHBlbnMgYmVmb3JlIFNldFBhZ2VEaXJ0eSgpLCBvciBzZXRfcGFnZV9kaXJ0eSgp
IGFmdGVyIEJvcmlzJ3MgcGF0Y2guDQoNCnBhZ2VfbWt3cml0ZSgpIGlzIHdoZXJlIGJ0cmZzIGRv
ZXMgaXRzIENPVyBzZXR1cCwgd2FpdHMgZm9yIElPIGluIGZsaWdodCwgYW5kIGFsc28gc2V0cyB0
aGUgcGFnZSBkaXJ0eS4gIElmIHRoYXTigJlzIGFscmVhZHkgaGFwcGVuaW5nIGZvciB0aGVzZSBw
YWdlcywgZG8gd2UgbmVlZCBhbiBhZGRpdGlvbmFsIHNldF9wYWdlX2RpcnR5KCkgYXQgYWxsPw0K
DQpCb3JpcyBmb3VuZCBodHRwczovL2xpc3RzLm9wZW53YWxsLm5ldC9saW51eC1rZXJuZWwvMjAx
Ni8wMi8xMS83MDIsIHdoZXJlIE1heGltIHN1Z2dlc3RzIGp1c3QgZHJvcHBpbmcgdGhlIFNldFBh
Z2VEaXJ0eSgpIG9uIGZpbGUgYmFjayBwYWdlcy4NCg0KVGhlIHByb2JsZW0gd2l0aCBiYXJlIHNl
dF9wYWdlX2RpcnR5KCkgY2FsbHMgaXMgdGhhdCBpdCBieXBhc3NlcyBvdXIgc3luY2hyb25pemF0
aW9uIGZvciBzdGFibGUgcGFnZXMuICBXZSBoYXZlIHRvIHN1cHBvcnQgaXQgYmVjYXVzZSBvZiB3
ZWlyZCBnZXRfdXNlcl9wYWdlcygpIGNvcm5lcnMsIGJ1dCBwYWdlX213a3JpdGUoKSBpcyBtdWNo
IHByZWZlcnJlZC4gIEhvcGVmdWxseSBvdXIgdXNlIG9mIGNsZWFyX3BhZ2VfZGlydHlfZm9yX2lv
KCkgbWFrZXMgc3VyZSB0aGF0IGFueSBtb2RpZmljYXRpb25zIHRvIHRoZSBwYWdlIGdvIHRocm91
Z2ggcGFnZV9ta3dyaXRlKCkgYWdhaW4sIHNvIEkgdGhpbmsgTWF4aW3igJlzIHBhdGNoIG1pZ2h0
IGp1c3QgYmUgY29ycmVjdC4NCg0KLWNocmlz
