Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6441449D685
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 01:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbiA0AC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 19:02:56 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11280 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233700AbiA0ACx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 19:02:53 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20QL2BcU008909
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 16:02:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3HdLoIXba0gSxzcqjOs6x0Br50aKeIn2Io+CsRP570c=;
 b=kSDPkr0hoNg+T/G8b6wDislc4wJ3IhnmhpgMBisN5LslUJ1O7/+H4nLr1oKUNs+QQ/L9
 mjTQFPfM3sfxIdST8c4lrZxrkwPw7tDEdkO7pw2CgVclFWSoYoY96X82dyqpkUrYPrIm
 Wq1YgszgBs/1BP4SmVqFn1101F3+GlJsfiI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3dtmrx22s3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 16:02:52 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 26 Jan 2022 16:02:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wg61m3YyRs9is3vWL7nNW0zm7KK0JhWJxFjMgWz4GZlYo9IYI+1/HtX6LSuZjL/M3vZzPxV+5tkVyNDiLHOhR4ZugyEKRhSLp1OJrKR7hadqEb/6NYmhMa13pEBqUAbQA9kj5i618f3xTE5LuExpE8XzNdnBIdQI+YOfVWj7gA22dxkWkaGs4HNjsAl8mwcknVvcWKmgm/cd7Jae4BJaXHFaF/A0Bdth1OFXXrU74ddR80F0q8MrrbMd3ontvzYgi6voMHjvpgkE5JfvTbEn7sUGRV7iJSRdMkRcpP4UY+TzhGJCoyROiNCb5HpJJvyehvc+WrzPSsfkFdLC+TpgAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3HdLoIXba0gSxzcqjOs6x0Br50aKeIn2Io+CsRP570c=;
 b=XPpA17M7zSaHFuv9FaYPPC7Q7IOEC1cXwDRPRmW7/YLPL+bo4N+/4CP2ONF6rwmHpjvBg+VGJ1htQ8cy4C+e51+KD7p96uO7PcIVyz8X3pUSyD26jRgj5BilLZlBLcaO1eY+pyi5FU1ySSzgwwxXo9qnA/f6GFhDrBSyoTDizgUUei4RELuChUZqRLIgMmnB8xTKYzXMwZPjXFp7quzT3mkOA0HumhMXIRZRFdEId5B/nonvlxsA6FsHgTfj/2PN4JCu2Q1hWFtNl37Ub8ocX75EmhBVhfIDNtk4bl2HTP8CKUdFlUZDKUzq2izOtX7zln7QTs0WTYMaIwBROfswCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MN2PR15MB4287.namprd15.prod.outlook.com (2603:10b6:208:1b6::13)
 by SN6PR1501MB1982.namprd15.prod.outlook.com (2603:10b6:805:d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 00:02:44 +0000
Received: from MN2PR15MB4287.namprd15.prod.outlook.com
 ([fe80::3102:7e69:9b1:3d30]) by MN2PR15MB4287.namprd15.prod.outlook.com
 ([fe80::3102:7e69:9b1:3d30%6]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 00:02:44 +0000
From:   Chris Mason <clm@fb.com>
To:     Boris Burkov <boris@bur.io>
CC:     Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Thread-Topic: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Thread-Index: AQHYEu6ezDBN9b9XPkaUx3YvgIhZsax12f4AgAAUH4CAAA5vgA==
Date:   Thu, 27 Jan 2022 00:02:44 +0000
Message-ID: <3876CE62-6E66-4CCE-ADED-69010EA72394@fb.com>
References: <08b5b2c516b81788ca411dc031d403de4594755e.1643226777.git.boris@bur.io>
 <YfHEJpP+1c9QZxA0@google.com> <YfHVB5RmLZn2ku5M@zen>
In-Reply-To: <YfHVB5RmLZn2ku5M@zen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1161693-5751-4531-37da-08d9e128582c
x-ms-traffictypediagnostic: SN6PR1501MB1982:EE_
x-microsoft-antispam-prvs: <SN6PR1501MB1982334407B2FC8575133C6FD3219@SN6PR1501MB1982.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oo/6EOOTm2Ht/fPYJH5KbtF6/aYkWPswGjPpepJ5DPuDehuJvgCDtv/61+4oIEspVmGgYmQIQG2/yME5YFvXv0W6w0uTx8N/YayqLxt2LaMzhB53CVVEfV7i0ogQo4ojjPAVIaMKgJGwAq3LrzG8tN8bDwA5+76FXZ7khRmFGZX93Pq1lQqw7XHIUMCKsGq80aRlX6J1X4VIpwNyKVyKSNNCGer6Yjj3Ki/n1/3RQZT6EWPEEAdmg+o+xPwhLAi5HGO3h5somlWJXZEuQY9ShQb2BEWFfL8O+ZIoI3H3LLMiaGDPiGT+J942/SSDn60Vq8wpA1SDBnDlS1IIOTn2eVwQuAufYxux/XvEH1WnOAzpksOT8yy7hgH51ZxUWQv28fyYeiMmsq7R2C/pUtFhACb0WG7xcDQZDv2nck8n7kbgngsRJtU5m2y8Ebg4zu6RmsH/GFACydD/qHibGSxbz6qBq46ZLFz/h91X3kSdRXJmvpSeb+97G96bPSnrgM/BNY1b8B2M6Mx90P/fT5AUPeQD8Rja3Uic6yVd9V3fPb+TDT2229+bFGt0vN2mcZwHdlbz7igPhP56EzUxUgHmm4M7RC0yaSG/Wp5es8P0T+jvV7F2oTOZ8UCruEiKrDZbLs5HEmjssYB8B8eZVqcZYs+75inHGjMTsO2/olzVxe5zYOpviI3GM4mv6Fk4fZuJxwHl7h9M9/xdm0NwXnEY2yELcPnSu/Zw9Y0CJJKE+qsz+jPQWGrtayF1NBOEMF50iYxdDcAwNvaaMQFeGiu5gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR15MB4287.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(38100700002)(66946007)(5660300002)(66476007)(2906002)(38070700005)(66556008)(76116006)(66446008)(316002)(6916009)(64756008)(8676002)(8936002)(86362001)(4326008)(2616005)(508600001)(6512007)(83380400001)(53546011)(71200400001)(33656002)(122000001)(6486002)(6506007)(36756003)(186003)(14143004)(45980500001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2MzR0h4Y215U2pRd1k1THd6MUlzWGU0UGF2Z3lWN3JYOW9nbE1iQU94QTRT?=
 =?utf-8?B?KzY3cnZwSTkyRC8weU13Mis3MEdCeVVWc3VjcHkvNXlXMWl0ckRzVWU4TkEx?=
 =?utf-8?B?NWRtd3BLaHYyTlplRUYxcDFzeFBKSnJ1OGZoME1SM3Y3SGpQNTdmZUZ4UVVY?=
 =?utf-8?B?Y1M1UzRORzdtZ1VtUEhubVFZdWRiVzluUFlXT2puSEFhaUdVaXEyNUpDeWlt?=
 =?utf-8?B?ZzJ0cjMrdDRqa2xrYU9TckRxeWhpUzRtYnZvdkM1YmZVS1B3bndZNU1qQ2NJ?=
 =?utf-8?B?RTNIWk5pMUNZNzhqVVAyNHMxSnI0b29xY0hIU0FIN2FQaElKbEczd3pTTWNi?=
 =?utf-8?B?ejFnMUFzU3ZlWG5jL3pzNHdDdmV3bkVwS0pzaFlRVHZhd1FnMHZPc3B4dmh4?=
 =?utf-8?B?Q01hem9Hekl4OGo2czllVjBDK2hPbThEVjVvbmwwVlpoTElqQndvSmVoeVlq?=
 =?utf-8?B?bzRPSm04cXFhUS9SUy81VUY5aHcwWkUxUTQzUmVBaVFmdnBsTzZ3QW1RQUt0?=
 =?utf-8?B?R1pVWXB1bEhJNEhlOEdlUjRFQzBaSXFFYWZxQW5iU1ZrbWFJSzRNcFdUU2Ja?=
 =?utf-8?B?UnJGeVJRZC96Rjl4ZnBvcE9mVlJhdUFYQ1hiZmRvZTRIOFJzQTJoMWVkNFVo?=
 =?utf-8?B?ZEczRkRGVUIyQzEvZnNsNXFYNkU1RktRaDZIRkZPTDQ5YzBHRzlkcWxjNWZt?=
 =?utf-8?B?ZFI0MVRPa0dWK0lMSkJ4RU9BclpHZGgxYStpWkNhdXZkcktVVWdvVVpIWTNN?=
 =?utf-8?B?UmRJV2J2K2FmZ0U1NEpEbHdVZnIyanpuby9FMDFObjNyVFpPR0NKei9TYWR1?=
 =?utf-8?B?bElRWEhqSVV3bUpzdWgyV3RwaW5zZEVmRWNlZzJJUTREZWZpTGR5MjZ5TWhY?=
 =?utf-8?B?SUJIWDlxQmtRK01Jb2xBV1FWQlZmMUtCZ0FrTkQ1cktiZjYrTGlEak1EMmhi?=
 =?utf-8?B?NG1wbDl3UUh1cWUwOVNpVEJGd3I0YVBhU1g4WUNQekpQYzVIelhYVzFrT05p?=
 =?utf-8?B?MGV6eldnMUJBK1FVd0xvYXdWM2NvU1RWQTJha1EyVElXNElQaXVCUDhFOWVw?=
 =?utf-8?B?ZE12ekI0OUlpb1JsMDNjSWt6Q1VZeThDdGZnZXVyZ0hDTm1yOVBzN2VLWk0v?=
 =?utf-8?B?SnlKbWVEeWxTZ2hlRVIvSlJ5bTNvSy9RV2lLQnh1Q3JyMy9MMW1aNHVZUnNO?=
 =?utf-8?B?Q1B0YjBSdE1WQ3ZkR1dXVG9VeXY0U0RyVXlLRW16cWpnRStrV2ZXdm1PWEZO?=
 =?utf-8?B?akxQMU90VDhWTlFqeEdkMG9BeEdPVmJVUXgreWY4QUNUZi9sVEQraHNnZURZ?=
 =?utf-8?B?MzhicEd6OEszSkp4ZnNwZjE2ckZaN3pCY1AwR1EzbjNPc0VOeWdub1BGNThO?=
 =?utf-8?B?Q0R2VUtwMjh5SVpxcFNEdW1ITUZrV0M5ejBadVRlRjJrZ1lJWERDVmhsVU9z?=
 =?utf-8?B?eDNDTDl5bFBiZTdOWkoyWUtJVjI0T2h2dkdpZ20wVGFvVGhoWTllZEVPLzA2?=
 =?utf-8?B?Z2FOQ1BMcEVhano1TjUrbUMxNG1FdlJCL1lUb0I0VnBDM0pYaHo5Ulk2TDJ2?=
 =?utf-8?B?alhSME84SzZpLzBMWFkvd3BBaWg5QWVrZmFsNWEwMFEveGZ2cHpWUVRzZmFF?=
 =?utf-8?B?RzdOdDNUUmpyNE9OajMyWkpWczh4L2dMY1BjaUNwSTRTUCtRa3hjMHowWE5S?=
 =?utf-8?B?c3JOU3JBTldELzdidEVMTHFtWDc5NVFSRTI2dUpTTEdDZCtyemZFb1hFUHZx?=
 =?utf-8?B?VjNXQ1BVaHI0QlJMZ2g5Rnk3RzJ3TkpVMjZmcUtYa2tQaHRKL1FmRktjRmxQ?=
 =?utf-8?B?Z1hPRm4vU3BYZEdJc2xrMlcrWkpZRDJvemxqM3huci9KUlJQMklybnRzTXlV?=
 =?utf-8?B?ckpMVkNHdzZtSEVWeHpEaWpBenZZS09wWEtjeTJBZjhETVRVWUtxOVFTWTIw?=
 =?utf-8?B?WTdQL3ZUMzFWOXpZdHpBMnppeU1pNlVXZ3NMKzhJMnNYNHlsc0w0WmhLVXpk?=
 =?utf-8?B?ZFpLZElubG1McHQxZTE3M2xHb0FuejFKSTZ2cVBRN2NjblRMMjBxczJoZ2tk?=
 =?utf-8?B?Y0s4UDk0ZC9WRndWU2F6MlJ1MU5GVTE4RHF3UCtjTWxHTUZRUm5MMk9pT3Nh?=
 =?utf-8?B?eWxCTVBVdkFuN1RrZlk2eXgzNVhVSkhrdWZGOTl5SDdUM1MyWXBFTExiU3JM?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <45F8EF78686E644DB578C4E4BF1728C2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR15MB4287.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1161693-5751-4531-37da-08d9e128582c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 00:02:44.2932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6EqrQRbyKpiErh2/EZALeqqh+jb2Yb7Tv/sG0AWiLTAraCKYu607BQNj8bPuBAZI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB1982
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: KueEY4z3xsRL5W5JI643AOwZYr2bPXRN
X-Proofpoint-ORIG-GUID: KueEY4z3xsRL5W5JI643AOwZYr2bPXRN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_09,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201260136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSmFuIDI2LCAyMDIyLCBhdCA2OjExIFBNLCBCb3JpcyBCdXJrb3YgPGJvcmlzQGJ1
ci5pbz4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIEphbiAyNiwgMjAyMiBhdCAwOTo1OTowMlBNICsw
MDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPj4gT24gV2VkLCBKYW4gMjYsIDIwMjIs
IEJvcmlzIEJ1cmtvdiB3cm90ZToNCj4+PiBJIHRlc3RlZCB0aGlzIGZpeCBvbiB0aGUgd29ya2xv
YWQgYW5kIGl0IGRpZCBwcmV2ZW50IHRoZSBoYW5ncy4gSG93ZXZlciwNCj4+PiBJIGFtIHVuc3Vy
ZSBpZiB0aGUgZml4IGlzIGFwcHJvcHJpYXRlIGZyb20gYSBsb2NraW5nIHBlcnNwZWN0aXZlLCBz
byBJDQo+Pj4gaG9wZSB0byBkcmF3IHNvbWUgZXh0cmEgYXR0ZW50aW9uIHRvIHRoYXQgYXNwZWN0
LiBzZXRfcGFnZV9kaXJ0eV9sb2NrIGluDQo+Pj4gbW0vcGFnZS13cml0ZWJhY2suYyBoYXMgYSBj
b21tZW50IGFib3V0IGxvY2tpbmcgdGhhdCBzYXlzIHNldF9wYWdlX2RpcnR5DQo+Pj4gc2hvdWxk
IGJlIGNhbGxlZCB3aXRoIHRoZSBwYWdlIGxvY2tlZCBvciB3aGlsZSBkZWZpbml0ZWx5IGhvbGRp
bmcgYQ0KPj4+IHJlZmVyZW5jZSB0byB0aGUgbWFwcGluZydzIGhvc3QgaW5vZGUuIEkgYmVsaWV2
ZSB0aGF0IHRoZSBtbWFwIHNob3VsZA0KPj4+IGhhdmUgdGhhdCByZWZlcmVuY2UsIHNvIGZvciBm
ZWFyIG9mIGh1cnRpbmcgS1ZNIHBlcmZvcm1hbmNlIG9yDQo+Pj4gaW50cm9kdWNpbmcgYSBkZWFk
bG9jaywgSSBvcHRlZCBmb3IgdGhlIHVubG9ja2VkIHZhcmlhbnQuDQo+PiANCj4+IEtWTSBkb2Vz
bid0IGhvbGQgYSByZWZlcmVuY2UgcGVyIHNlLCBidXQgaXQgZG9lcyBzdWJzY3JpYmUgdG8gbW11
X25vdGlmaWVyIGV2ZW50cw0KPj4gYW5kIHdpbGwgbm90IG1hcmsgdGhlIHBhZ2UgZGlydHkgYWZ0
ZXIgS1ZNIGhhcyBiZWVuIGluc3RydWN0ZWQgdG8gdW5tYXAgdGhlIHBhZ2UNCj4+IChiYXJyaW5n
IGJ1Z3MsIHdoaWNoIHdlJ3ZlIGhhZCBhIHNsZXcgb2YpLiAgU28geWVhaCwgdGhlIHVubG9ja2Vk
IHZhcmlhbnQgc2hvdWxkDQo+PiBiZSBzYWZlLg0KPj4gDQo+PiBJcyBpdCBmZWFzaWJsZSB0byB0
cmlnZ2VyIHRoaXMgYmVoYXZpb3IgaW4gYSBzZWxmdGVzdD8gIEtWTSBoYXMgaGFkLCBhbmQgcHJv
YmFibHkNCj4+IHN0aWxsIGhhcywgbWFueSBidWdzIHRoYXQgYWxsIGJvaWwgZG93biB0byBLVk0g
YXNzdW1pbmcgZ3Vlc3QgbWVtb3J5IGlzIGJhY2tlZCBieQ0KPj4gZWl0aGVyIGFub255bW91cyBt
ZW1vcnkgb3Igc29tZXRoaW5nIGxpa2Ugc2htZW0vSHVnZVRMQkZTL21lbWZkIHRoYXQgaXNuJ3Qg
dHlwaWNhbGx5DQo+PiB0cnVuY2F0ZWQgYnkgdGhlIGhvc3QuDQo+IA0KPiBJIGhhdmVuJ3QgYmVl
biBhYmxlIHRvIGlzb2xhdGUgYSByZXByb2R1Y2VyLCB5ZXQuIEkgYW0gYSBiaXQgc3R1bXBlZA0K
PiBiZWNhdXNlIHRoZXJlIGlzbid0IGEgbG90IGZvciBtZSB0byBnbyBvZmYgZnJvbSB0aGF0IHN0
YWNrIEkgc2hhcmVkLS10aGUNCj4gYmVzdCBJIGhhdmUgc28gZmFyIGlzIHRoYXQgSSBuZWVkIHRv
IHRyaWNrIEtWTSBpbnRvIGVtdWxhdGluZw0KPiBpbnN0cnVjdGlvbnMgYXQgc29tZSBwb2ludCB0
byBnZXQgdG8gdGhpcyAnY29tcGxldGVfdXNlcnNwYWNlX2lvJw0KPiBjb2RlcGF0aD8gSSB3aWxs
IGtlZXAgdHJ5aW5nLCBzaW5jZSBJIHRoaW5rIGl0IHdvdWxkIGJlIHZhbHVhYmxlIHRvIGtub3cN
Cj4gd2hhdCBleGFjdGx5IGhhcHBlbmVkLiBPcGVuIHRvIHRyeSBhbnkgc3VnZ2VzdGlvbnMgeW91
IG1pZ2h0IGhhdmUgYXMNCj4gd2VsbC4NCg0KRnJvbSB0aGUgYnRyZnMgc2lkZSwgYmFyZSBjYWxs
cyB0byBzZXRfcGFnZV9kaXJ0eSgpIGFyZSBzdWJvcHRpbWFsLCBzaW5jZSBpdCBkb2VzbuKAmXQg
Z28gdGhyb3VnaCB0aGUgLT5wYWdlX21rd3JpdGUoKSBkYW5jZSB0aGF0IHdlIHVzZSB0byBwcm9w
ZXJseSBDT1cgdGhpbmdzLiAgSXTigJlzIHN0aWxsIG11Y2ggYmV0dGVyIHRoYW4gU2V0UGFnZURp
cnR5KCksIGJ1dCBJ4oCZZCBsb3ZlIHRvIHVuZGVyc3RhbmQgd2h5IGt2bSBuZWVkcyB0byBkaXJ0
eSB0aGUgcGFnZSBzbyB3ZSBjYW4gZmlndXJlIG91dCBob3cgdG8gZ28gdGhyb3VnaCB0aGUgbm9y
bWFsIG1tYXAgZmlsZSBpbyBwYXRocy4NCg0KLWNocmlzDQoNCg==
