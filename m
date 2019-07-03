Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338965E9FD
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 19:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbfGCRCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 13:02:42 -0400
Received: from mail-eopbgr810079.outbound.protection.outlook.com ([40.107.81.79]:37275
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbfGCRCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 13:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYACtzuCqZCMdBkx4JyJnIh+w5U5BfxfyyJHVo0MWCg=;
 b=uoDqfXvxfGYiGTt8PHF9Xri4FaHBqvz9zfPL/34ySWV6uTldy0SaZQFleAg6vfWhsTrDwxBY5nfOnHTyTR0h13zWNWXftC/6qwZelF18DiNXxzagZhN1dE/RZ+/7Klz0nzJO1C1GmLdw7R6EuyFAfx4VZnoM22XXBkYyE0f4B3M=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYASPR01MB0055.namprd05.prod.outlook.com (20.179.90.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.15; Wed, 3 Jul 2019 17:02:36 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58%7]) with mapi id 15.20.2052.010; Wed, 3 Jul 2019
 17:02:36 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Juergen Gross <jgross@suse.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/9] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Thread-Topic: [PATCH v2 4/9] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Thread-Index: AQHVMW7qykCnng2DBUWUciRHoRZgF6a47Y6AgAAxzIA=
Date:   Wed, 3 Jul 2019 17:02:36 +0000
Message-ID: <A4BC0EDE-71F0-455D-964A-7250D005FB56@vmware.com>
References: <20190702235151.4377-1-namit@vmware.com>
 <20190702235151.4377-5-namit@vmware.com>
 <d89e2b57-8682-153e-33d8-98084e9983d6@suse.com>
In-Reply-To: <d89e2b57-8682-153e-33d8-98084e9983d6@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d82937b5-c8e6-4324-35e4-08d6ffd83fa0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYASPR01MB0055;
x-ms-traffictypediagnostic: BYASPR01MB0055:
x-microsoft-antispam-prvs: <BYASPR01MB0055AFF4910456681FF84AACD0FB0@BYASPR01MB0055.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(199004)(189003)(73956011)(76116006)(6246003)(54906003)(6512007)(316002)(486006)(6116002)(3846002)(6916009)(99286004)(25786009)(305945005)(86362001)(7736002)(66556008)(53936002)(64756008)(2906002)(66446008)(4326008)(66946007)(66476007)(76176011)(6506007)(102836004)(53546011)(5660300002)(33656002)(186003)(68736007)(26005)(256004)(478600001)(14454004)(6486002)(14444005)(6436002)(7416002)(2616005)(11346002)(446003)(476003)(229853002)(8936002)(36756003)(66066001)(81166006)(81156014)(8676002)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYASPR01MB0055;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bRkigeJHw+1MMReuCCKlpf/jW5QN+am0Y3t/Esa7tmebdn6NUVB3VTOWpnn2pbhfNpzpPRe3bLWsJ49SQHNrwiS/m3Xq4jDfwuNC0gsHwa6cFz1bEPaKae9kjRhZ3PEdKVTe6t0Xnz3ukKIVk+0pDK5/q0bfRKfNopygiNHysDi9mEOc2WPj+4y5EoEISvWDCmP4csLEiiSD/XxYJThdMNlwNBrhMNmm6YDsKR4s96dwVfF3FkA/HjV9pNnz9XmlpzijiEKfJush7LAMC5rsGZuOBBFFmOr1FfA+NqNG3eDUGcfU2m2r2nRjmVyYKkdcSpmqU7KmQHM1PMjtxmxEEPkXyfiQLTtVt9SNiLEkg+s+4SeS9R0XbJpCadeeedenZY9f9XkPtKcxQ/1PGKwPQa/s6Jyiny0UPiN1VfQd31o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4011894573807D4C87553D9A4DFD3426@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82937b5-c8e6-4324-35e4-08d6ffd83fa0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 17:02:36.3417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYASPR01MB0055
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdWwgMywgMjAxOSwgYXQgNzowNCBBTSwgSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2Uu
Y29tPiB3cm90ZToNCj4gDQo+IE9uIDAzLjA3LjE5IDAxOjUxLCBOYWRhdiBBbWl0IHdyb3RlOg0K
Pj4gVG8gaW1wcm92ZSBUTEIgc2hvb3Rkb3duIHBlcmZvcm1hbmNlLCBmbHVzaCB0aGUgcmVtb3Rl
IGFuZCBsb2NhbCBUTEJzDQo+PiBjb25jdXJyZW50bHkuIEludHJvZHVjZSBmbHVzaF90bGJfbXVs
dGkoKSB0aGF0IGRvZXMgc28uIEludHJvZHVjZQ0KPj4gcGFyYXZpcnR1YWwgdmVyc2lvbnMgb2Yg
Zmx1c2hfdGxiX211bHRpKCkgZm9yIEtWTSwgWGVuIGFuZCBoeXBlci12IChYZW4NCj4+IGFuZCBo
eXBlci12IGFyZSBvbmx5IGNvbXBpbGUtdGVzdGVkKS4NCj4+IFdoaWxlIHRoZSB1cGRhdGVkIHNt
cCBpbmZyYXN0cnVjdHVyZSBpcyBjYXBhYmxlIG9mIHJ1bm5pbmcgYSBmdW5jdGlvbiBvbg0KPj4g
YSBzaW5nbGUgbG9jYWwgY29yZSwgaXQgaXMgbm90IG9wdGltaXplZCBmb3IgdGhpcyBjYXNlLiBU
aGUgbXVsdGlwbGUNCj4+IGZ1bmN0aW9uIGNhbGxzIGFuZCB0aGUgaW5kaXJlY3QgYnJhbmNoIGlu
dHJvZHVjZSBzb21lIG92ZXJoZWFkLCBhbmQNCj4+IG1pZ2h0IG1ha2UgbG9jYWwgVExCIGZsdXNo
ZXMgc2xvd2VyIHRoYW4gdGhleSB3ZXJlIGJlZm9yZSB0aGUgcmVjZW50DQo+PiBjaGFuZ2VzLg0K
Pj4gQmVmb3JlIGNhbGxpbmcgdGhlIFNNUCBpbmZyYXN0cnVjdHVyZSwgY2hlY2sgaWYgb25seSBh
IGxvY2FsIFRMQiBmbHVzaA0KPj4gaXMgbmVlZGVkIHRvIHJlc3RvcmUgdGhlIGxvc3QgcGVyZm9y
bWFuY2UgaW4gdGhpcyBjb21tb24gY2FzZS4gVGhpcw0KPj4gcmVxdWlyZXMgdG8gY2hlY2sgbW1f
Y3B1bWFzaygpIG9uZSBtb3JlIHRpbWUsIGJ1dCB1bmxlc3MgdGhpcyBtYXNrIGlzDQo+PiB1cGRh
dGVkIHZlcnkgZnJlcXVlbnRseSwgdGhpcyBzaG91bGQgaW1wYWN0IHBlcmZvcm1hbmNlIG5lZ2F0
aXZlbHkuDQo+PiBDYzogIksuIFkuIFNyaW5pdmFzYW4iIDxreXNAbWljcm9zb2Z0LmNvbT4NCj4+
IENjOiBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPg0KPj4gQ2M6IFN0ZXBo
ZW4gSGVtbWluZ2VyIDxzdGhlbW1pbkBtaWNyb3NvZnQuY29tPg0KPj4gQ2M6IFNhc2hhIExldmlu
IDxzYXNoYWxAa2VybmVsLm9yZz4NCj4+IENjOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRy
b25peC5kZT4NCj4+IENjOiBJbmdvIE1vbG5hciA8bWluZ29AcmVkaGF0LmNvbT4NCj4+IENjOiBC
b3Jpc2xhdiBQZXRrb3YgPGJwQGFsaWVuOC5kZT4NCj4+IENjOiB4ODZAa2VybmVsLm9yZw0KPj4g
Q2M6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4+IENjOiBQYW9sbyBCb256aW5p
IDxwYm9uemluaUByZWRoYXQuY29tPg0KPj4gQ2M6IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBs
aW51eC5pbnRlbC5jb20+DQo+PiBDYzogQW5keSBMdXRvbWlyc2tpIDxsdXRvQGtlcm5lbC5vcmc+
DQo+PiBDYzogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPg0KPj4gQ2M6IEJv
cmlzIE9zdHJvdnNreSA8Ym9yaXMub3N0cm92c2t5QG9yYWNsZS5jb20+DQo+PiBDYzogbGludXgt
aHlwZXJ2QHZnZXIua2VybmVsLm9yZw0KPj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmcNCj4+IENjOiB2aXJ0dWFsaXphdGlvbkBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZw0KPj4g
Q2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCj4+IENjOiB4ZW4tZGV2ZWxAbGlzdHMueGVucHJvamVj
dC5vcmcNCj4+IFNpZ25lZC1vZmYtYnk6IE5hZGF2IEFtaXQgPG5hbWl0QHZtd2FyZS5jb20+DQo+
PiAtLS0NCj4+ICBhcmNoL3g4Ni9oeXBlcnYvbW11LmMgICAgICAgICAgICAgICAgIHwgMTMgKysr
LS0tDQo+PiAgYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQuaCAgICAgICB8ICA2ICstLQ0K
Pj4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0X3R5cGVzLmggfCAgNCArLQ0KPj4gIGFy
Y2gveDg2L2luY2x1ZGUvYXNtL3RsYmZsdXNoLmggICAgICAgfCAgOSArKy0tDQo+PiAgYXJjaC94
ODYvaW5jbHVkZS9hc20vdHJhY2UvaHlwZXJ2LmggICB8ICAyICstDQo+PiAgYXJjaC94ODYva2Vy
bmVsL2t2bS5jICAgICAgICAgICAgICAgICB8IDExICsrKy0tDQo+PiAgYXJjaC94ODYva2VybmVs
L3BhcmF2aXJ0LmMgICAgICAgICAgICB8ICAyICstDQo+PiAgYXJjaC94ODYvbW0vdGxiLmMgICAg
ICAgICAgICAgICAgICAgICB8IDY1ICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLQ0KPj4gIGFy
Y2gveDg2L3hlbi9tbXVfcHYuYyAgICAgICAgICAgICAgICAgfCAyMCArKysrKystLS0NCj4+ICBp
bmNsdWRlL3RyYWNlL2V2ZW50cy94ZW4uaCAgICAgICAgICAgIHwgIDIgKy0NCj4+ICAxMCBmaWxl
cyBjaGFuZ2VkLCA5MSBpbnNlcnRpb25zKCspLCA0MyBkZWxldGlvbnMoLSkNCj4gDQo+IC4uLg0K
PiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni94ZW4vbW11X3B2LmMgYi9hcmNoL3g4Ni94ZW4v
bW11X3B2LmMNCj4+IGluZGV4IGJlYjQ0ZTIyYWZkZi4uMTllNDgxZTZlOTA0IDEwMDY0NA0KPj4g
LS0tIGEvYXJjaC94ODYveGVuL21tdV9wdi5jDQo+PiArKysgYi9hcmNoL3g4Ni94ZW4vbW11X3B2
LmMNCj4+IEBAIC0xMzU1LDggKzEzNTUsOCBAQCBzdGF0aWMgdm9pZCB4ZW5fZmx1c2hfdGxiX29u
ZV91c2VyKHVuc2lnbmVkIGxvbmcgYWRkcikNCj4+ICAJcHJlZW1wdF9lbmFibGUoKTsNCj4+ICB9
DQo+PiAgLXN0YXRpYyB2b2lkIHhlbl9mbHVzaF90bGJfb3RoZXJzKGNvbnN0IHN0cnVjdCBjcHVt
YXNrICpjcHVzLA0KPj4gLQkJCQkgY29uc3Qgc3RydWN0IGZsdXNoX3RsYl9pbmZvICppbmZvKQ0K
Pj4gK3N0YXRpYyB2b2lkIHhlbl9mbHVzaF90bGJfbXVsdGkoY29uc3Qgc3RydWN0IGNwdW1hc2sg
KmNwdXMsDQo+PiArCQkJCWNvbnN0IHN0cnVjdCBmbHVzaF90bGJfaW5mbyAqaW5mbykNCj4+ICB7
DQo+PiAgCXN0cnVjdCB7DQo+PiAgCQlzdHJ1Y3QgbW11ZXh0X29wIG9wOw0KPj4gQEAgLTEzNjYs
NyArMTM2Niw3IEBAIHN0YXRpYyB2b2lkIHhlbl9mbHVzaF90bGJfb3RoZXJzKGNvbnN0IHN0cnVj
dCBjcHVtYXNrICpjcHVzLA0KPj4gIAljb25zdCBzaXplX3QgbWNfZW50cnlfc2l6ZSA9IHNpemVv
ZihhcmdzLT5vcCkgKw0KPj4gIAkJc2l6ZW9mKGFyZ3MtPm1hc2tbMF0pICogQklUU19UT19MT05H
UyhudW1fcG9zc2libGVfY3B1cygpKTsNCj4+ICAtCXRyYWNlX3hlbl9tbXVfZmx1c2hfdGxiX290
aGVycyhjcHVzLCBpbmZvLT5tbSwgaW5mby0+c3RhcnQsIGluZm8tPmVuZCk7DQo+PiArCXRyYWNl
X3hlbl9tbXVfZmx1c2hfdGxiX211bHRpKGNwdXMsIGluZm8tPm1tLCBpbmZvLT5zdGFydCwgaW5m
by0+ZW5kKTsNCj4+ICAgIAlpZiAoY3B1bWFza19lbXB0eShjcHVzKSkNCj4+ICAJCXJldHVybjsJ
CS8qIG5vdGhpbmcgdG8gZG8gKi8NCj4+IEBAIC0xMzc1LDkgKzEzNzUsMTcgQEAgc3RhdGljIHZv
aWQgeGVuX2ZsdXNoX3RsYl9vdGhlcnMoY29uc3Qgc3RydWN0IGNwdW1hc2sgKmNwdXMsDQo+PiAg
CWFyZ3MgPSBtY3MuYXJnczsNCj4+ICAJYXJncy0+b3AuYXJnMi52Y3B1bWFzayA9IHRvX2NwdW1h
c2soYXJncy0+bWFzayk7DQo+PiAgLQkvKiBSZW1vdmUgdXMsIGFuZCBhbnkgb2ZmbGluZSBDUFVT
LiAqLw0KPj4gKwkvKiBGbHVzaCBsb2NhbGx5IGlmIG5lZWRlZCBhbmQgcmVtb3ZlIHVzICovDQo+
PiArCWlmIChjcHVtYXNrX3Rlc3RfY3B1KHNtcF9wcm9jZXNzb3JfaWQoKSwgdG9fY3B1bWFzayhh
cmdzLT5tYXNrKSkpIHsNCj4+ICsJCWxvY2FsX2lycV9kaXNhYmxlKCk7DQo+PiArCQlmbHVzaF90
bGJfZnVuY19sb2NhbChpbmZvKTsNCj4gDQo+IEkgdGhpbmsgdGhpcyBpc24ndCB0aGUgY29ycmVj
dCBmdW5jdGlvbiBmb3IgUFYgZ3Vlc3RzLg0KPiANCj4gSW4gZmFjdCBpdCBzaG91bGQgYmUgbXVj
aCBlYXNpZXI6IGp1c3QgZG9uJ3QgY2xlYXIgdGhlIG93biBjcHUgZnJvbSB0aGUNCj4gbWFzaywg
dGhhdCdzIGFsbCB3aGF0J3MgbmVlZGVkLiBUaGUgaHlwZXJ2aXNvciBpcyBqdXN0IGZpbmUgaGF2
aW5nIHRoZQ0KPiBjdXJyZW50IGNwdSBpbiB0aGUgbWFzayBhbmQgaXQgd2lsbCBkbyB0aGUgcmln
aHQgdGhpbmcuDQoNClRoYW5rcy4gSSB3aWxsIGRvIHNvIGluIHYzLiBJIGRvbuKAmXQgdGhpbmsg
SHlwZXItViBwZW9wbGUgd291bGQgd2FudCB0byBkbw0KdGhlIHNhbWUsIHVuZm9ydHVuYXRlbHks
IHNpbmNlIGl0IHdvdWxkIGluZHVjZSBWTS1leGl0IG9uIFRMQiBmbHVzaGVzLiBCdXQNCmlmIHRo
ZXkgZG8gLSBJ4oCZbGwgYmUgYWJsZSBub3QgdG8gZXhwb3NlIGZsdXNoX3RsYl9mdW5jX2xvY2Fs
KCkuDQoNCg==
