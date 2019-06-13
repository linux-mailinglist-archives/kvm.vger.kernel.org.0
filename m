Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADEA446FC
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393111AbfFMQz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:55:59 -0400
Received: from mail-eopbgr800049.outbound.protection.outlook.com ([40.107.80.49]:53520
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729978AbfFMBuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 21:50:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBsZwzkyRFgqWrKVo3vWztHlpAF27k6yAqQw7p6aWPY=;
 b=d8IvevMfqazynwRoJntOMXblDaCdi/CFQ4ctftUlailZLO6EUBUd8HagPTCqFfXK7isDacQvD7oDCQo19r2OpioR0TIS7eo+TOpYOW8fCGl4aCi040hhiVS0TdLMxBHv4Kppp43fKkXdpYTQAm0EKfRIb7Hap/h44cbI4VxTNAo=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4645.namprd05.prod.outlook.com (52.135.233.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.5; Thu, 13 Jun 2019 01:50:46 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::134:af66:bedb:ead9]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::134:af66:bedb:ead9%3]) with mapi id 15.20.1987.008; Thu, 13 Jun 2019
 01:50:46 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Dave Hansen <dave.hansen@intel.com>,
        Marius Hillenbrand <mhillenb@amazon.de>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
Thread-Topic: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
Thread-Index: AQHVIYeR2j5VBjf3eUa9RwR3XpurVaaY0cWA
Date:   Thu, 13 Jun 2019 01:50:46 +0000
Message-ID: <F05B97DB-34BD-44CF-AC6A-945D7AD39C38@vmware.com>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
In-Reply-To: <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 895ec96d-bbc8-4be5-c726-08d6efa18de1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB4645;
x-ms-traffictypediagnostic: BYAPR05MB4645:
x-microsoft-antispam-prvs: <BYAPR05MB4645394FA52FE5C12B763D0DD0EF0@BYAPR05MB4645.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(396003)(136003)(366004)(199004)(189003)(76176011)(8936002)(26005)(53546011)(99286004)(2616005)(186003)(446003)(256004)(4326008)(14444005)(476003)(36756003)(11346002)(73956011)(66446008)(76116006)(66946007)(6506007)(66556008)(64756008)(102836004)(66476007)(86362001)(68736007)(6436002)(229853002)(6486002)(81166006)(6916009)(6512007)(33656002)(71190400001)(5660300002)(7736002)(7416002)(305945005)(3846002)(71200400001)(6116002)(81156014)(316002)(486006)(66066001)(53936002)(2906002)(8676002)(6246003)(54906003)(478600001)(25786009)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4645;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9ol76ApUCVv8/YrhLcE1unQ3QOvFetz2iAtTDjl06FpEfLAN9XXY3e20ATYdffa4S78b2d1dwvmqIaSdHQPk6b5TfwO3AY86xJKtLZcAGKs31rNcWdGf7wE0ZY2mOiuxH2LS3BViDtol5CRMtxNpR0Viwl+kXaLHIfWVmvmgS0Ajx6LYLX74NwMFNmQOBLg35UlYomMlTT8v/HmtCKpncjYMo26PEizi95AwbLmsnSo43PefLwuP98/C0aXOVd7mJ1PABP/o52yiRJysAMNe9gWF/mqekrBXFsQuLd43bqf229wUBFQMifi70ZBRJo/4ccGwgapKnsUvVBbYBPgIGWgJwCwLwN7b/uRHdMQRzMerC1N/5fy+c650X7i2JFiGritVuvv5Nby1YUgAWattuNfbn8Ju1HQNAzYWpAQIT0Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC6CAD422C9C324592B81075EE26ED66@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895ec96d-bbc8-4be5-c726-08d6efa18de1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 01:50:46.6682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4645
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdW4gMTIsIDIwMTksIGF0IDY6MzAgUE0sIEFuZHkgTHV0b21pcnNraSA8bHV0b0BrZXJu
ZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgSnVuIDEyLCAyMDE5IGF0IDE6MjcgUE0gQW5k
eSBMdXRvbWlyc2tpIDxsdXRvQGFtYWNhcGl0YWwubmV0PiB3cm90ZToNCj4+PiBPbiBKdW4gMTIs
IDIwMTksIGF0IDEyOjU1IFBNLCBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPiB3
cm90ZToNCj4+PiANCj4+Pj4gT24gNi8xMi8xOSAxMDowOCBBTSwgTWFyaXVzIEhpbGxlbmJyYW5k
IHdyb3RlOg0KPj4+PiBUaGlzIHBhdGNoIHNlcmllcyBwcm9wb3NlcyB0byBpbnRyb2R1Y2UgYSBy
ZWdpb24gZm9yIHdoYXQgd2UgY2FsbA0KPj4+PiBwcm9jZXNzLWxvY2FsIG1lbW9yeSBpbnRvIHRo
ZSBrZXJuZWwncyB2aXJ0dWFsIGFkZHJlc3Mgc3BhY2UuDQo+Pj4gDQo+Pj4gSXQgbWlnaHQgYmUg
ZnVuIHRvIGNjIHNvbWUgeDg2IGZvbGtzIG9uIHRoaXMgc2VyaWVzLiAgVGhleSBtaWdodCBoYXZl
DQo+Pj4gc29tZSByZWxldmFudCBvcGluaW9ucy4gOykNCj4+PiANCj4+PiBBIGZldyBoaWdoLWxl
dmVsIHF1ZXN0aW9uczoNCj4+PiANCj4+PiBXaHkgZ28gdG8gYWxsIHRoaXMgdHJvdWJsZSB0byBo
aWRlIGd1ZXN0IHN0YXRlIGxpa2UgcmVnaXN0ZXJzIGlmIGFsbCB0aGUNCj4+PiBndWVzdCBkYXRh
IGl0c2VsZiBpcyBzdGlsbCBtYXBwZWQ/DQo+Pj4gDQo+Pj4gV2hlcmUncyB0aGUgY29udGV4dC1z
d2l0Y2hpbmcgY29kZT8gIERpZCBJIGp1c3QgbWlzcyBpdD8NCj4+PiANCj4+PiBXZSd2ZSBkaXNj
dXNzZWQgaGF2aW5nIHBlci1jcHUgcGFnZSB0YWJsZXMgd2hlcmUgYSBnaXZlbiBQR0QgaXMgb25s
eSBpbg0KPj4+IHVzZSBmcm9tIG9uZSBDUFUgYXQgYSB0aW1lLiAgSSAqdGhpbmsqIHRoaXMgc2No
ZW1lIHN0aWxsIHdvcmtzIGluIHN1Y2ggYQ0KPj4+IGNhc2UsIGl0IGp1c3QgYWRkcyBvbmUgbW9y
ZSBQR0QgZW50cnkgdGhhdCB3b3VsZCBoYXZlIHRvIGNvbnRleHQtc3dpdGNoZWQuDQo+PiANCj4+
IEZhaXIgd2FybmluZzogTGludXMgaXMgb24gcmVjb3JkIGFzIGFic29sdXRlbHkgaGF0aW5nIHRo
aXMgaWRlYS4gSGUgbWlnaHQgY2hhbmdlIGhpcyBtaW5kLCBidXQgaXTigJlzIGFuIHVwaGlsbCBi
YXR0bGUuDQo+IA0KPiBJIGxvb2tlZCBhdCB0aGUgcGF0Y2gsIGFuZCBpdCAoc2Vuc2libHkpIGhh
cyBub3RoaW5nIHRvIGRvIHdpdGgNCj4gcGVyLWNwdSBQR0RzLiAgU28gaXQncyBpbiBncmVhdCBz
aGFwZSENCj4gDQo+IFNlcmlvdXNseSwgdGhvdWdoLCBoZXJlIGFyZSBzb21lIHZlcnkgaGlnaC1s
ZXZlbCByZXZpZXcgY29tbWVudHM6DQo+IA0KPiBQbGVhc2UgZG9uJ3QgY2FsbCBpdCAicHJvY2Vz
cyBsb2NhbCIsIHNpbmNlICJwcm9jZXNzIiBpcyBtZWFuaW5nbGVzcy4NCj4gQ2FsbCBpdCAibW0g
bG9jYWwiIG9yIHNvbWV0aGluZyBsaWtlIHRoYXQuDQo+IA0KPiBXZSBhbHJlYWR5IGhhdmUgYSBw
ZXItbW0ga2VybmVsIG1hcHBpbmc6IHRoZSBMRFQuICBTbyBwbGVhc2Ugbml4IGFsbA0KPiB0aGUg
Y29kZSB0aGF0IGFkZHMgYSBuZXcgVkEgcmVnaW9uLCBldGMsIGV4Y2VwdCB0byB0aGUgZXh0ZW50
IHRoYXQNCj4gc29tZSBvZiBpdCBjb25zaXN0cyBvZiB2YWxpZCBjbGVhbnVwcyBpbiBhbmQgb2Yg
aXRzZWxmLiAgSW5zdGVhZCwNCj4gcGxlYXNlIHJlZmFjdG9yIHRoZSBMRFQgY29kZSAoYXJjaC94
ODYva2VybmVsL2xkdC5jLCBtYWlubHkpIHRvIG1ha2UNCj4gaXQgdXNlIGEgbW9yZSBnZW5lcmFs
ICJtbSBsb2NhbCIgYWRkcmVzcyByYW5nZSwgYW5kIHRoZW4gcmV1c2UgdGhlDQo+IHNhbWUgaW5m
cmFzdHJ1Y3R1cmUgZm9yIG90aGVyIGZhbmN5IHRoaW5ncy4gIFRoZSBjb2RlIHRoYXQgbWFrZXMg
aXQNCj4gS0FTTFItYWJsZSBzaG91bGQgYmUgaW4gaXRzIHZlcnkgb3duIHBhdGNoIHRoYXQgYXBw
bGllcyAqYWZ0ZXIqIHRoZQ0KPiBjb2RlIHRoYXQgbWFrZXMgaXQgYWxsIHdvcmsgc28gdGhhdCwg
d2hlbiB0aGUgS0FTTFIgcGFydCBjYXVzZXMgYQ0KPiBjcmFzaCwgd2UgY2FuIGJpc2VjdCBpdC4N
Cj4gDQo+ICsgLyoNCj4gKyAqIEZhdWx0cyBpbiBwcm9jZXNzLWxvY2FsIG1lbW9yeSBtYXkgYmUg
Y2F1c2VkIGJ5IHByb2Nlc3MtbG9jYWwNCj4gKyAqIGFkZHJlc3NlcyBsZWFraW5nIGludG8gb3Ro
ZXIgY29udGV4dHMuDQo+ICsgKiB0YmQ6IHdhcm4gYW5kIGhhbmRsZSBncmFjZWZ1bGx5Lg0KPiAr
ICovDQo+ICsgaWYgKHVubGlrZWx5KGZhdWx0X2luX3Byb2Nlc3NfbG9jYWwoYWRkcmVzcykpKSB7
DQo+ICsgcHJfZXJyKCJwYWdlIGZhdWx0IGluIFBST0NMT0NBTCBhdCAlbHgiLCBhZGRyZXNzKTsN
Cj4gKyBmb3JjZV9zaWdfZmF1bHQoU0lHU0VHViwgU0VHVl9NQVBFUlIsICh2b2lkIF9fdXNlciAq
KWFkZHJlc3MsIGN1cnJlbnQpOw0KPiArIH0NCj4gKw0KPiANCj4gSHVoPyAgRWl0aGVyIGl0J3Mg
YW4gT09QUyBvciB5b3Ugc2hvdWxkbid0IHByaW50IGFueSBzcGVjaWFsDQo+IGRlYnVnZ2luZy4g
IEFzIGl0IGlzLCB5b3UncmUganVzdCBibGF0YW50bHkgbGVha2luZyB0aGUgYWRkcmVzcyBvZiB0
aGUNCj4gbW0tbG9jYWwgcmFuZ2UgdG8gbWFsaWNpb3VzIHVzZXIgcHJvZ3JhbXMuDQo+IA0KPiBB
bHNvLCB5b3Ugc2hvdWxkIElNTyBjb25zaWRlciB1c2luZyB0aGlzIG1lY2hhbmlzbSBmb3Iga21h
cF9hdG9taWMoKS4NCj4gSGksIE5hZGF2IQ0KDQpXZWxsLCBzb21lIGNvbnRleHQgZm9yIHRoZSDi
gJxoaeKAnSB3b3VsZCBoYXZlIGJlZW4gaGVscGZ1bC4gKERvIEkgaGF2ZSBhIGJ1Zw0KYW5kIEkg
c3RpbGwgZG9u4oCZdCB1bmRlcnN0YW5kIGl0PykNCg0KUGVyaGFwcyB5b3UgcmVnYXJkIHNvbWUg
dXNlLWNhc2UgZm9yIGEgc2ltaWxhciBtZWNoYW5pc20gdGhhdCBJIG1lbnRpb25lZA0KYmVmb3Jl
LiBJIGRpZCBpbXBsZW1lbnQgc29tZXRoaW5nIHNpbWlsYXIgKGJ1dCBub3QgdGhlIHdheSB0aGF0
IHlvdSB3YW50ZWQpDQp0byBpbXByb3ZlIHRoZSBwZXJmb3JtYW5jZSBvZiBzZWNjb21wIGFuZCBz
eXN0ZW0tY2FsbHMgd2hlbiByZXRwb2xpbmVzIGFyZQ0KdXNlZC4gSSBzZXQgcGVyLW1tIGNvZGUg
YXJlYSB0aGF0IGhlbGQgY29kZSB0aGF0IHVzZWQgZGlyZWN0IGNhbGxzIHRvIGludm9rZQ0Kc2Vj
Y29tcCBmaWx0ZXJzIGFuZCBmcmVxdWVudGx5IHVzZWQgc3lzdGVtLWNhbGxzLg0KDQpNeSBtZWNo
YW5pc20sIEkgdGhpbmssIGlzIG1vcmUgbm90IHN1aXRhYmxlIGZvciB0aGlzIHVzZS1jYXNlLiBJ
IG5lZWRlZCBteQ0KY29kZS1wYWdlIHRvIGJlIGF0IHRoZSBzYW1lIDJHQiByYW5nZSBhcyB0aGUg
a2VybmVsIHRleHQvbW9kdWxlcywgd2hpY2ggZG9lcw0KY29tcGxpY2F0ZSB0aGluZ3MuIER1ZSB0
byB0aGUgc2FtZSByZWFzb24sIGl0IGlzIGFsc28gbGltaXRlZCBpbiB0aGUgc2l6ZSBvZg0KdGhl
IGRhdGEvY29kZSB0aGF0IGl0IGNhbiBob2xkLg0KDQo=
