Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4C449E554
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 16:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238801AbiA0PAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 10:00:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235483AbiA0PAq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 10:00:46 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20REuegi000654
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 07:00:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GRcrIr1gX0kHQmVMS9cm4xJeXE4kFAS5T39vBuMVnpU=;
 b=oJSAAzf2e4i++Fas+yoQ8ul/SIobVVcAUJBwBDBA4PQJPqC1Sl2g5PvQGXEJwYvRzKJI
 gum/UsQ1GEjSKsCXLE2hT6czwmM3dYSuR7vt4GMud07Ti0CzJFAQo+O+XAqBPUUnmHoB
 hAVoMN1ef90uY9joz9/NGhK25tu0ewFpP1E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3dujwbb3ep-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 07:00:45 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 07:00:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSVNJUE4wfJVPiL3o8HWhzi9eawsaQ7xHsfcZHtI7EX3iHPiUMBGIpjpOO4W/ouDLUTGq+1BIWFz8mDPJeg6stHR0uhBlBR9xRtcdjdO8gftKjQX/ye/E9hSWql3hZA+5/c9kuBz5LJmiGNsSfpwT179LZUXBPLWK08qwMqeNfBdLXsibgmNXmYD+t7M0aS+ObEQxvhPLhWhtrN6rZYvDodyXutzEB3Ttq/fOcK4OTudHyx+WWnQFP7qCfPqwMF7kJOtph7Zri7CXGhuYYUUrO5LBpt9IEfLSoewwpF55RwyTaGEKRE8C1VaRorFQm3DE2DclCrnA1kk0JAfmzRdtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRcrIr1gX0kHQmVMS9cm4xJeXE4kFAS5T39vBuMVnpU=;
 b=GnHch6UvEdPDKgYH/RIxK1uKXhfZa3YgJVW+DjgoqbQqybrBpUFmf3delabR4fgkEsxTNNfKLN4PPp21jLu85d9pRIk06/iVQuP4/F+YwsIrJDfNJFIB2zz52KxVii7T0j68sy9ebfmiLIijghVmW3WHiv/42w+4hvMfisZJD+7vPbYiMc83B3WaNgpl6PBzZQAdRN1D+IUCtoNPRrUU+YdYCBButsDY+XcpgCrwqmtEAcKKTNmVnXcCUSDZMqzd6Suw6raw3PGfsikrXjnjddmbevIKcFK/1QoN/NKwJL6HWfeFrnZ51VD5PTEnXGK94GeKlDwZFUG1M/7xRwBYVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MN2PR15MB4287.namprd15.prod.outlook.com (2603:10b6:208:1b6::13)
 by DM6PR15MB3782.namprd15.prod.outlook.com (2603:10b6:5:2bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 15:00:42 +0000
Received: from MN2PR15MB4287.namprd15.prod.outlook.com
 ([fe80::3102:7e69:9b1:3d30]) by MN2PR15MB4287.namprd15.prod.outlook.com
 ([fe80::3102:7e69:9b1:3d30%6]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 15:00:42 +0000
From:   Chris Mason <clm@fb.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Boris Burkov <boris@bur.io>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Thread-Topic: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Thread-Index: AQHYEu6ezDBN9b9XPkaUx3YvgIhZsax12f4AgAAUH4CAAA5vgIAAGk+AgADglYA=
Date:   Thu, 27 Jan 2022 15:00:42 +0000
Message-ID: <8D468962-7231-4000-935C-E4CD43BB0108@fb.com>
References: <08b5b2c516b81788ca411dc031d403de4594755e.1643226777.git.boris@bur.io>
 <YfHEJpP+1c9QZxA0@google.com> <YfHVB5RmLZn2ku5M@zen>
 <3876CE62-6E66-4CCE-ADED-69010EA72394@fb.com> <YfH3NR+g0uRIruCc@google.com>
In-Reply-To: <YfH3NR+g0uRIruCc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61e1a4ef-69da-4e01-3891-08d9e1a5ca1c
x-ms-traffictypediagnostic: DM6PR15MB3782:EE_
x-microsoft-antispam-prvs: <DM6PR15MB37820E0CAC65F088F94EF50BD3219@DM6PR15MB3782.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CqlrZh7tegdbVMQruHHd132DUdQsp6HUVihW0BNMx20GtQRvG+Ah1f4kkE1wmD+qJyGK+Gp7Njf9SquiAPh4ZZalfOytAsp8I4loo8elghoyJcEJaTzna6BTliqSsmO/yIwfu8DYvji+hh9buwLsQtDU3K8lVM+P4PrqMdIsDyQucGWrZzSuTzigwXdLP5gdC8FYJVHXRzG35IFanQPow8dUfg8TaeRbLAbbi8zBqDQrgMWSxlXo8skQAZ6l95RlXb67IlJx6stIpOS+mLOp4y8bgVFqajM3zPdt2tYdry7w1e5qovRkL3gR38tEhp+t1C+l5bmeMW2IMvUxRKwskj9qe3+hCFGAE9omn64ZV50WXsuDHICHgu83OPfmKCP+EwCfnudsyaZY7oqBH4nXjMXfac5tMALwOTaoaXMZU0T6kZX0cKnViKATfuQ6QSeHA6Xgat1a+WLfd0cq704EPc09J3VVUNOiA5mOLmJFBsN5NATNzGsqUY4WmwNBA4VkCjnk2h4ed3xT6Uqzqo9nvQmtS9owHxk97SmbZk1gnv8xQGI+Lv/c6rPBUmLrDbSbpf1ksfqfx81REWdw3ryDeTGOJNMwMSV+1o4YU9GreYRyxTuycgA1HuLFj+cqoRlrFkKRQkjDXG/Fdtc+cP37j1SYa9O8jk3c3np6bsXiDRzOiq45Fwu06gycISN7RHr9ZmE7C28pGSxI1nUc6QC9aZ5oJQvf9x5JLP83K6DYr/cy/JKh+MxvaKEafOOdyZmLx43B2SqR6lDXPOyRT0cnPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR15MB4287.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(2906002)(8936002)(8676002)(316002)(4326008)(6512007)(6486002)(38070700005)(2616005)(6506007)(53546011)(186003)(54906003)(5660300002)(6916009)(71200400001)(508600001)(36756003)(76116006)(66446008)(83380400001)(33656002)(38100700002)(122000001)(66946007)(66556008)(66476007)(64756008)(14143004)(45980500001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWdnZStTWUlDWEJUbzROSkVpazBKZE5pVWJxa1g5MGorUXVsWUpuNzJLd3dV?=
 =?utf-8?B?VVNGUERWdDh5NjlKS25UMUxzMElIM21IMWpyazVOSUdjSUVDV0JKam5RODl4?=
 =?utf-8?B?b0FSUk9IZ1NMSWNQWmw3djBmcldLWjRrQzNGUnpuZ1lBbjN6STIweEoxVzlO?=
 =?utf-8?B?TEVMdXdEZzI1NXFIM3lXMzBCeHZNTzhxa2JZc2xTUW1ZdHFISmFHaEJUOUlG?=
 =?utf-8?B?bytXb3FUL2ZzTU84ckpLeitlNi9xdDZmaU1DdnBGYkxlY2NrODY0YWpsNE9w?=
 =?utf-8?B?d3F6aWZySFhKcWduRDZsZXJja05acTBrcWFnaGdUbFM5N1BsU2FnT2pxb2VH?=
 =?utf-8?B?SkhsR0gzNWR1czNGaDJ3MVV3aFR4ZHRxMEMwbSt4aWpEcTFmNDVxclpNL1F1?=
 =?utf-8?B?cVhTTXk5eUtQODhoeXllcTJDbEVCMFRtVnlFeUM1VFR5MzVENmxYL2U1RERX?=
 =?utf-8?B?N3RHM1luSnU3TUpaSTI1VzNEKzJCUmxCeUFUWmlKa24yOXR2NWNOcHJIaUhk?=
 =?utf-8?B?WFRLYWx4R2NBYXJHLzUrSThVYnZLUHVaWkg0YXF2NloyaldoS2dpcy9pUXVk?=
 =?utf-8?B?dEtoWldHZG00RFhpQk9NSE5mQjRMZDdIUGtaN1ZTc21mZVJ0S1FQNFprYjJw?=
 =?utf-8?B?N2xKcll1TkI3d3Y2MzFjSXNLNEw0U04yNy93bWsrNlh4cW5FUUNWUHFaV3V3?=
 =?utf-8?B?SXlsaW05WEs0ZFBVZmpJVUtwbk9DTE1UZ1NiWFRmVnBINVFGR2E1R2lsRmJw?=
 =?utf-8?B?L1QrTmJkRE5UOVlnTXZ6RjNFVVh5OEVRdnFIVmNLQ2xQS2h5Ym9QTFNVY3Zx?=
 =?utf-8?B?SXFYUUw2M05icDdXVUpiVDVWcGdKNTBqOHlROS9qRERKaGJaU1owYmRxem95?=
 =?utf-8?B?aXFOTGluVFdzbWpzWjFCeUtQQ2wyS1UrRHliUTBSNjJPVDI5OVBvcFgrbTVt?=
 =?utf-8?B?cVVsd1BjNXU3TDdLSGZWV2lpb3U1STA5eGluUlFmWEExZ1FIUVV5bGhPcWxI?=
 =?utf-8?B?Q2pSQ0hrY3lTODE2SE9qeUJ2d3pLc2xRQkI4MUp2ZWwvNmt3dzF3aWhzRVc5?=
 =?utf-8?B?ak5sT0tzbmJvcmIwVjFFMjA4SDVYRTVOeHpTU2RialMxUGIwRlUvQVRuMlFV?=
 =?utf-8?B?V3d4dDczb2lNWWxMa3hSbktnU2pZL1pWNFZxM0huSE5sVlQzcXZJd2crUGZI?=
 =?utf-8?B?SVVFV2xzTUFLK09ETlBCczdSTUlHT001QW1NL25mQ2YyRlNaV3ZtRktrRW9I?=
 =?utf-8?B?c2w0L0FLNjgyUUtaaTZJdGZ5NnNKN1ZzR0k2Ny94TVdoeDFQbU0vbzN4TnBL?=
 =?utf-8?B?bTVaUzNxQXpLK2tJVTFCQ1V3eUxIdHlNUUlvM1l3REgzMHlxSC9BemhReXNi?=
 =?utf-8?B?K01BVHRlZG5FZE1xeUlFbDY5NzU3MDhXdjNoTDdLWG9RNXBqUFdtZ3VRT0E1?=
 =?utf-8?B?U3dxbXlFSG5uYzcvZzZCdTBmM1hiQzlzaGxGckc4N01RZVo3alE2Qkc0TGc0?=
 =?utf-8?B?WkNmV3hnS01SdUt0enZzK2VWT0lpVzI2L1BtU0EzT3dseHZWajh4T0o0MUE3?=
 =?utf-8?B?MlRDNUM5dEhFK1JheENZSjFWYkVXR2lKRm0wbTN3UGl3anA5WFg4cU55Y21D?=
 =?utf-8?B?TGFUZFNFeGNHc2FPZmJYTlBKVjNmaGRDUXA5S1QxWk9vUFRTbkQyUkEvMkhk?=
 =?utf-8?B?Y2Q0cTh2SnlKaWVOL1o4c3QxMVowNFczV0Eyd0ZqeGpQT25pcXB1RHJMa2lN?=
 =?utf-8?B?Wk9jTytMSmhoY2lRTTltRi8zQnFqbUFwa1dvSUlnWHhiSHpxMXhHVHhlODk3?=
 =?utf-8?B?eVlHVXUvNW41UzVaaW1wcVVFMmtKVCtFUG0ra2UrMk5Xb1l3ZkVZTllpN0pS?=
 =?utf-8?B?RDZ4SUpjemx4QmVKWEQrdldZcWk5d1VKWnpxZStOQ1cycGZORW9qWUNrQk1E?=
 =?utf-8?B?a1drUDZ1all0VnNybG5kL21ZNUJ1dHl3VmRIcXJXZWJVWFFWbDR6S0NBbytj?=
 =?utf-8?B?RTcrZGRGWnBYeFdlSkVKb1l0SE92M0U4dXpXSjRBWHpsaERxeDMrdWhwSXJm?=
 =?utf-8?B?Z1pyU0JxR0NJaFgyR0dCY3RCNnNPTjJHZytzUzkvYUZxcC9DMkFjU1JsWVdG?=
 =?utf-8?B?QTV1OSs4UVlxUDBsb1NRSmZEalFyL1NtM2JVMnJUUHU3UTV2Rk84Y2kvc2Jr?=
 =?utf-8?B?a0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <016EB57A7B3B304E864408E60696612B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR15MB4287.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e1a4ef-69da-4e01-3891-08d9e1a5ca1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 15:00:42.5867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qsAD2L/s5uci6G+dPM46rrK+8CRB/SjxBJiH7VLqeL0AI1F2S0LKLPGVPdWkW8ZL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3782
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: qYyUj_yk3O7Rq6EQbkVBXlMG8QHl1e5q
X-Proofpoint-ORIG-GUID: qYyUj_yk3O7Rq6EQbkVBXlMG8QHl1e5q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201270092
X-FB-Internal: deliver
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IE9uIEphbiAyNiwgMjAyMiwgYXQgODozNiBQTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vh
bmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBKYW4gMjcsIDIwMjIsIENocmlz
IE1hc29uIHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBKYW4gMjYsIDIwMjIsIGF0IDY6MTEgUE0s
IEJvcmlzIEJ1cmtvdiA8Ym9yaXNAYnVyLmlvPiB3cm90ZToNCj4+PiANCj4+PiBPbiBXZWQsIEph
biAyNiwgMjAyMiBhdCAwOTo1OTowMlBNICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3Rl
Og0KPj4+PiBPbiBXZWQsIEphbiAyNiwgMjAyMiwgQm9yaXMgQnVya292IHdyb3RlOg0KPj4+Pj4g
SSB0ZXN0ZWQgdGhpcyBmaXggb24gdGhlIHdvcmtsb2FkIGFuZCBpdCBkaWQgcHJldmVudCB0aGUg
aGFuZ3MuIEhvd2V2ZXIsDQo+Pj4+PiBJIGFtIHVuc3VyZSBpZiB0aGUgZml4IGlzIGFwcHJvcHJp
YXRlIGZyb20gYSBsb2NraW5nIHBlcnNwZWN0aXZlLCBzbyBJDQo+Pj4+PiBob3BlIHRvIGRyYXcg
c29tZSBleHRyYSBhdHRlbnRpb24gdG8gdGhhdCBhc3BlY3QuIHNldF9wYWdlX2RpcnR5X2xvY2sg
aW4NCj4+Pj4+IG1tL3BhZ2Utd3JpdGViYWNrLmMgaGFzIGEgY29tbWVudCBhYm91dCBsb2NraW5n
IHRoYXQgc2F5cyBzZXRfcGFnZV9kaXJ0eQ0KPj4+Pj4gc2hvdWxkIGJlIGNhbGxlZCB3aXRoIHRo
ZSBwYWdlIGxvY2tlZCBvciB3aGlsZSBkZWZpbml0ZWx5IGhvbGRpbmcgYQ0KPj4+Pj4gcmVmZXJl
bmNlIHRvIHRoZSBtYXBwaW5nJ3MgaG9zdCBpbm9kZS4gSSBiZWxpZXZlIHRoYXQgdGhlIG1tYXAg
c2hvdWxkDQo+Pj4+PiBoYXZlIHRoYXQgcmVmZXJlbmNlLCBzbyBmb3IgZmVhciBvZiBodXJ0aW5n
IEtWTSBwZXJmb3JtYW5jZSBvcg0KPj4+Pj4gaW50cm9kdWNpbmcgYSBkZWFkbG9jaywgSSBvcHRl
ZCBmb3IgdGhlIHVubG9ja2VkIHZhcmlhbnQuDQo+Pj4+IA0KPj4+PiBLVk0gZG9lc24ndCBob2xk
IGEgcmVmZXJlbmNlIHBlciBzZSwgYnV0IGl0IGRvZXMgc3Vic2NyaWJlIHRvIG1tdV9ub3RpZmll
ciBldmVudHMNCj4+Pj4gYW5kIHdpbGwgbm90IG1hcmsgdGhlIHBhZ2UgZGlydHkgYWZ0ZXIgS1ZN
IGhhcyBiZWVuIGluc3RydWN0ZWQgdG8gdW5tYXAgdGhlIHBhZ2UNCj4+Pj4gKGJhcnJpbmcgYnVn
cywgd2hpY2ggd2UndmUgaGFkIGEgc2xldyBvZikuICBTbyB5ZWFoLCB0aGUgdW5sb2NrZWQgdmFy
aWFudCBzaG91bGQNCj4+Pj4gYmUgc2FmZS4NCj4+Pj4gDQo+Pj4+IElzIGl0IGZlYXNpYmxlIHRv
IHRyaWdnZXIgdGhpcyBiZWhhdmlvciBpbiBhIHNlbGZ0ZXN0PyAgS1ZNIGhhcyBoYWQsIGFuZCBw
cm9iYWJseQ0KPj4+PiBzdGlsbCBoYXMsIG1hbnkgYnVncyB0aGF0IGFsbCBib2lsIGRvd24gdG8g
S1ZNIGFzc3VtaW5nIGd1ZXN0IG1lbW9yeSBpcyBiYWNrZWQgYnkNCj4+Pj4gZWl0aGVyIGFub255
bW91cyBtZW1vcnkgb3Igc29tZXRoaW5nIGxpa2Ugc2htZW0vSHVnZVRMQkZTL21lbWZkIHRoYXQg
aXNuJ3QgdHlwaWNhbGx5DQo+Pj4+IHRydW5jYXRlZCBieSB0aGUgaG9zdC4NCj4+PiANCj4+PiBJ
IGhhdmVuJ3QgYmVlbiBhYmxlIHRvIGlzb2xhdGUgYSByZXByb2R1Y2VyLCB5ZXQuIEkgYW0gYSBi
aXQgc3R1bXBlZA0KPj4+IGJlY2F1c2UgdGhlcmUgaXNuJ3QgYSBsb3QgZm9yIG1lIHRvIGdvIG9m
ZiBmcm9tIHRoYXQgc3RhY2sgSSBzaGFyZWQtLXRoZQ0KPj4+IGJlc3QgSSBoYXZlIHNvIGZhciBp
cyB0aGF0IEkgbmVlZCB0byB0cmljayBLVk0gaW50byBlbXVsYXRpbmcNCj4+PiBpbnN0cnVjdGlv
bnMgYXQgc29tZSBwb2ludCB0byBnZXQgdG8gdGhpcyAnY29tcGxldGVfdXNlcnNwYWNlX2lvJw0K
Pj4+IGNvZGVwYXRoPyBJIHdpbGwga2VlcCB0cnlpbmcsIHNpbmNlIEkgdGhpbmsgaXQgd291bGQg
YmUgdmFsdWFibGUgdG8ga25vdw0KPj4+IHdoYXQgZXhhY3RseSBoYXBwZW5lZC4gT3BlbiB0byB0
cnkgYW55IHN1Z2dlc3Rpb25zIHlvdSBtaWdodCBoYXZlIGFzDQo+Pj4gd2VsbC4NCj4+IA0KPj4g
RnJvbSB0aGUgYnRyZnMgc2lkZSwgYmFyZSBjYWxscyB0byBzZXRfcGFnZV9kaXJ0eSgpIGFyZSBz
dWJvcHRpbWFsLCBzaW5jZSBpdA0KPj4gZG9lc27igJl0IGdvIHRocm91Z2ggdGhlIC0+cGFnZV9t
a3dyaXRlKCkgZGFuY2UgdGhhdCB3ZSB1c2UgdG8gcHJvcGVybHkgQ09XDQo+PiB0aGluZ3MuICBJ
dOKAmXMgc3RpbGwgbXVjaCBiZXR0ZXIgdGhhbiBTZXRQYWdlRGlydHkoKSwgYnV0IEnigJlkIGxv
dmUgdG8NCj4+IHVuZGVyc3RhbmQgd2h5IGt2bSBuZWVkcyB0byBkaXJ0eSB0aGUgcGFnZSBzbyB3
ZSBjYW4gZmlndXJlIG91dCBob3cgdG8gZ28NCj4+IHRocm91Z2ggdGhlIG5vcm1hbCBtbWFwIGZp
bGUgaW8gcGF0aHMuDQo+IA0KPiBBaCwgaXMgdGhlIGlzc3VlIHRoYXQgd3JpdGViYWNrIGdldHMg
c3R1Y2sgYmVjYXVzZSBLVk0gcGVycGV0dWFsbHkgbWFya3MgdGhlDQo+IHBhZ2UgYXMgZGlydHk/
ICBUaGUgcGFnZSBpbiBxdWVzdGlvbiBzaG91bGQgaGF2ZSBhbHJlYWR5IGdvbmUgdGhyb3VnaCAt
PnBhZ2VfbWt3cml0ZSgpLg0KPiBPdXRzaWRlIG9mIG9uZSBvciB0d28gaW50ZXJuYWwgbW1hcHMg
dGhhdCBLVk0gZnVsbHkgY29udHJvbHMgYW5kIGFyZSBhbm9ueW1vdXMgbWVtb3J5LA0KPiBLVk0g
ZG9lc24ndCBtb2RpZnkgVk1Bcy4gIEtWTSBpcyBjYWxsaW5nIFNldFBhZ2VEaXJ0eSgpIHRvIG1h
cmsgdGhhdCBpdCBoYXMgd3JpdHRlbg0KPiB0byB0aGUgcGFnZTsgS1ZNIGVpdGhlciB3aGVuIGl0
IHVubWFwcyB0aGUgcGFnZSBmcm9tIHRoZSBndWVzdCwgb3IgaW4gdGhpcyBjYXNlLCB3aGVuDQo+
IGl0IGt1bm1hcCgpJ3MgYSBwYWdlIEtWTSBpdHNlbGYgYWNjZXNzZWQuDQo+IA0KDQpJIHRoaW5r
IEtWTSBpcyBqdXN0IGNhbGxpbmcgU2V0UGFnZURpcnR5KCkgb25jZS4gIFRoZSBwcm9ibGVtIGlz
IHRoYXQgU2V0UGFnZURpcnR5KCkganVzdCBmbGlwcyB0aGUgYml0IGFuZCBkb2VzbuKAmXQgc2V0
IGFueSBvZiB0aGUgdGFncyBpbiB0aGUgcmFkaXggdHJlZSwgc28gd2UgY2FuIGVhc2lseSBoaXQg
dGhpcyBjaGVjayBpbiBmaWxlbWFwX2ZkYXRhd3JpdGVfd2JjKCk6DQoNCiAgICAgICAgaWYgKCFt
YXBwaW5nX2Nhbl93cml0ZWJhY2sobWFwcGluZykgfHwNCiAgICAgICAgICAgICFtYXBwaW5nX3Rh
Z2dlZChtYXBwaW5nLCBQQUdFQ0FDSEVfVEFHX0RJUlRZKSkNCiAgICAgICAgICAgICAgICByZXR1
cm4gMDsNCg0KU2luY2UgYWxtb3N0IGV2ZXJ5b25lIHdyaXRpbmcgZGlydHkgcGFnZXMgdG8gZGlz
ayB3YW5kZXJzIHRocm91Z2ggYSBjaGVjayBvciBzZWFyY2ggZm9yIHRhZ2dlZCBwYWdlcywgdGhl
IHBhZ2UganVzdCBuZXZlciBnZXRzIHdyaXR0ZW4gYXQgYWxsLg0KDQo+IEJhc2VkIG9uIHRoZSBj
YWxsIHN0YWNrLCBteSBiZXN0IGd1ZXN0IGlzIHRoYXQgS1ZNIGlzIHVkcGF0aW5nIHN0ZWFsX3Rp
bWUgaW5mby4NCj4gVGhhdCdzIHRyaWdnZXJlZCB3aGVuIHRoZSB2Q1BVIGlzIChyZSlsb2FkZWQs
IHdoaWNoIHdvdWxkIGV4cGxhaW4gdGhlIGNvcnJlbGF0aW9uDQo+IHRvIGNvbXBsZXRlX3VzZXJz
cGFjZV9pbygpIGFzIEtWTSB1bmxvYWRzPT5yZWxvYWRzIHRoZSB2Q1BVIGJlZm9yZS9hZnRlciBl
eGl0aW5nDQo+IHRvIHVzZXJzcGFjZSB0byBoYW5kbGUgZW11bGF0ZSBJL08uDQo+IA0KPiBPaCEg
IEkgYXNzdW1lIHRoYXQgdGhlIHBhZ2UgaXMgZWl0aGVyIHVubWFwcGVkIG9yIG1hZGUgcmVhZC1v
bmx5IGJlZm9yZSB3cml0ZWJhY2s/DQo+IHY1LjYgKGFuZCBtYW55IGtlcm5lbHMgc2luY2UpIGhh
ZCBhIGJ1ZyB3aGVyZSBLVk0gd291bGQgIm1pc3MiIG1tdV9ub3RpZmllciBldmVudHMNCj4gZm9y
IHRoZSBzdGVhbF90aW1lIGNhY2hlLiAgSXQncyBiYXNpY2FsbHkgYSB1c2UtYWZ0ZXItZnJlZSBp
c3N1ZSBhdCB0aGF0IHBvaW50LiAgQ29tbWl0DQo+IDdlMjE3NWViZDY5NSAoIktWTTogeDg2OiBG
aXggcmVjb3JkaW5nIG9mIGd1ZXN0IHN0ZWFsIHRpbWUgLyBwcmVlbXB0ZWQgc3RhdHVz4oCdKQ0K
DQpPaCwgbG9va3MgbGlrZSB3ZSBhcmUgbWlzc2luZyB0aGF0IG9uZSwgaW50ZXJlc3RpbmcuICBX
ZSB1c2UgY2xlYXJfcGFnZV9kaXJ0eV9mb3JfaW8oKSBiZWZvcmUgd3JpdGluZyBwYWdlcywgc28g
eWVzIGl0IGRvZXMgZ2V0IHNldCByZWFkb25seSB2aWEgcGFnZV9ta2NsZWFuKCkNCg0KLWNocmlz
DQoNCg==
