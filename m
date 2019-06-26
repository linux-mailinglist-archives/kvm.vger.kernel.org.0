Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280AE56257
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 08:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFZGaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 02:30:55 -0400
Received: from mail-eopbgr810049.outbound.protection.outlook.com ([40.107.81.49]:59436
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725797AbfFZGaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 02:30:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+MBTEAyv7tlY6uaAJWtiQ1MDjmhug/hy/JAVXRk7iE=;
 b=Q90AGY3BOLFDS8ASYX0WGIW0an5rnbJXB6svJaTCBQ6dIdlM9ocENm7uhfS/CyBtCvv3lAP/ODSi64HMKGlJDUEdeRheidF3vu0tHqskbS3ysyQHpXIDWH990mFLUHdiHCP4Owm3VU3lTRcTVXvHq0BCuOF0K9LRu0yoyPOK3wM=
Received: from BL0PR05MB4772.namprd05.prod.outlook.com (20.177.145.81) by
 BL0PR05MB4625.namprd05.prod.outlook.com (20.177.144.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.12; Wed, 26 Jun 2019 06:30:50 +0000
Received: from BL0PR05MB4772.namprd05.prod.outlook.com
 ([fe80::a5e7:cf08:74dc:c2a3]) by BL0PR05MB4772.namprd05.prod.outlook.com
 ([fe80::a5e7:cf08:74dc:c2a3%5]) with mapi id 15.20.2008.007; Wed, 26 Jun 2019
 06:30:50 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/9] KVM: x86: Provide paravirtualized flush_tlb_multi()
Thread-Topic: [PATCH 6/9] KVM: x86: Provide paravirtualized flush_tlb_multi()
Thread-Index: AQHVIbQq2DFUsKveqk6vAXwf0z5KPqas+eUAgABThoCAAA9+AIAAAcoAgAAELwCAACsYgA==
Date:   Wed, 26 Jun 2019 06:30:50 +0000
Message-ID: <A52332CE-80A2-4705-ABB0-3CDDB7AEC889@vmware.com>
References: <20190613064813.8102-1-namit@vmware.com>
 <20190613064813.8102-7-namit@vmware.com>
 <cb28f2b4-92f0-f075-648e-dddfdbdd2e3c@intel.com>
 <401C4384-98A1-4C27-8F71-4848F4B4A440@vmware.com>
 <CALCETrWcUWw8ep-n6RaOeojnL924xOM7g7eb9g=3DRwOHQAgnA@mail.gmail.com>
 <35755C67-E8EB-48C3-8343-BB9ABEB4E32C@vmware.com>
 <CALCETrUPKj1rRn1bKDYkwZ8cv1navBne72kTCtGHjnhTM0cOVw@mail.gmail.com>
In-Reply-To: <CALCETrUPKj1rRn1bKDYkwZ8cv1navBne72kTCtGHjnhTM0cOVw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [204.134.128.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8bc29c8-7e50-4803-cea2-08d6f9ffd50c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BL0PR05MB4625;
x-ms-traffictypediagnostic: BL0PR05MB4625:
x-microsoft-antispam-prvs: <BL0PR05MB4625C89ADCC8E88771B00C99D0E20@BL0PR05MB4625.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(376002)(366004)(39860400002)(51444003)(54534003)(199004)(189003)(51914003)(68736007)(476003)(66066001)(6916009)(66476007)(76116006)(66946007)(66446008)(486006)(66556008)(64756008)(53936002)(53546011)(6512007)(86362001)(6436002)(478600001)(71200400001)(71190400001)(73956011)(6506007)(6486002)(102836004)(7736002)(446003)(3846002)(6116002)(11346002)(81166006)(2616005)(229853002)(81156014)(2906002)(305945005)(8936002)(25786009)(26005)(99286004)(14454004)(8676002)(54906003)(4326008)(5660300002)(256004)(33656002)(14444005)(36756003)(316002)(7416002)(76176011)(186003)(6246003)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4625;H:BL0PR05MB4772.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oQa0tUEDzIWP9S7FIW50VRBk7dpxJMhhg5P0cjOTA/uqk5lQQxldd4DbWe85Et/qLRzI9mLUblXkTWR1R5QEldtAT/fjteWD3fP2oJL9HXYCPw/bvOUi4xIcqY55A8CVD/roHSlKakY1fCvNaf69Sgr9/VqJ9lbv+fUfNGvClSCJk/AVw6qY6rLqSPLPmgMUg2mKpsT5SzvWAMV76npX3fyVIbuREievrEwl2vL89JT9lKLz2aRWke7jYXMRFWZbx9yV1KfavroYN80AsmrieGwxLJL4pn4DYA/LhHOotV3ZZX0zRFLRIdGK84XmtZ3DHpeT0vu4hJ5MU3sGgfTQEjDvZXRreuMiSTU8YpJblU7OiE3ozOZZJtOoq3dO2fLuCpQj9Y5jRhSsH7R+AuaC7QSDbKZDyftpZa/Wmh2zeJU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BB022BE2D1B37499824B6ABFBB8BEAD@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8bc29c8-7e50-4803-cea2-08d6f9ffd50c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 06:30:50.3308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4625
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdW4gMjUsIDIwMTksIGF0IDg6NTYgUE0sIEFuZHkgTHV0b21pcnNraSA8bHV0b0BrZXJu
ZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIFR1ZSwgSnVuIDI1LCAyMDE5IGF0IDg6NDEgUE0gTmFk
YXYgQW1pdCA8bmFtaXRAdm13YXJlLmNvbT4gd3JvdGU6DQo+Pj4gT24gSnVuIDI1LCAyMDE5LCBh
dCA4OjM1IFBNLCBBbmR5IEx1dG9taXJza2kgPGx1dG9Aa2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4g
DQo+Pj4gT24gVHVlLCBKdW4gMjUsIDIwMTkgYXQgNzozOSBQTSBOYWRhdiBBbWl0IDxuYW1pdEB2
bXdhcmUuY29tPiB3cm90ZToNCj4+Pj4+IE9uIEp1biAyNSwgMjAxOSwgYXQgMjo0MCBQTSwgRGF2
ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4gd3JvdGU6DQo+Pj4+PiANCj4+Pj4+IE9u
IDYvMTIvMTkgMTE6NDggUE0sIE5hZGF2IEFtaXQgd3JvdGU6DQo+Pj4+Pj4gU3VwcG9ydCB0aGUg
bmV3IGludGVyZmFjZSBvZiBmbHVzaF90bGJfbXVsdGksIHdoaWNoIGFsc28gZmx1c2hlcyB0aGUN
Cj4+Pj4+PiBsb2NhbCBDUFUncyBUTEIsIGluc3RlYWQgb2YgZmx1c2hfdGxiX290aGVycyB0aGF0
IGRvZXMgbm90LiBUaGlzDQo+Pj4+Pj4gaW50ZXJmYWNlIGlzIG1vcmUgcGVyZm9ybWFudCBzaW5j
ZSBpdCBwYXJhbGxlbGl6ZSByZW1vdGUgYW5kIGxvY2FsIFRMQg0KPj4+Pj4+IGZsdXNoZXMuDQo+
Pj4+Pj4gDQo+Pj4+Pj4gVGhlIGFjdHVhbCBpbXBsZW1lbnRhdGlvbiBvZiBmbHVzaF90bGJfbXVs
dGkoKSBpcyBhbG1vc3QgaWRlbnRpY2FsIHRvDQo+Pj4+Pj4gdGhhdCBvZiBmbHVzaF90bGJfb3Ro
ZXJzKCkuDQo+Pj4+PiANCj4+Pj4+IFRoaXMgY29uZnVzZWQgbWUgYSBiaXQuICBJIHRob3VnaHQg
d2UgZGlkbid0IHN1cHBvcnQgcGFyYXZpcnR1YWxpemVkDQo+Pj4+PiBmbHVzaF90bGJfbXVsdGko
KSBmcm9tIHJlYWRpbmcgZWFybGllciBpbiB0aGUgc2VyaWVzLg0KPj4+Pj4gDQo+Pj4+PiBCdXQs
IGl0IHNlZW1zIGxpa2UgdGhhdCBtaWdodCBiZSBYZW4tb25seSBhbmQgZG9lc24ndCBhcHBseSB0
byBLVk0gYW5kDQo+Pj4+PiBwYXJhdmlydHVhbGl6ZWQgS1ZNIGhhcyBubyBwcm9ibGVtIHN1cHBv
cnRpbmcgZmx1c2hfdGxiX211bHRpKCkuICBJcw0KPj4+Pj4gdGhhdCByaWdodD8gIEl0IG1pZ2h0
IGJlIGdvb2QgdG8gaW5jbHVkZSBzb21lIG9mIHRoYXQgYmFja2dyb3VuZCBpbiB0aGUNCj4+Pj4+
IGNoYW5nZWxvZyB0byBzZXQgdGhlIGNvbnRleHQuDQo+Pj4+IA0KPj4+PiBJ4oCZbGwgdHJ5IHRv
IGltcHJvdmUgdGhlIGNoYW5nZS1sb2dzIGEgYml0LiBUaGVyZSBpcyBubyBpbmhlcmVudCByZWFz
b24gZm9yDQo+Pj4+IFBWIFRMQi1mbHVzaGVycyBub3QgdG8gaW1wbGVtZW50IHRoZWlyIG93biBm
bHVzaF90bGJfbXVsdGkoKS4gSXQgaXMgbGVmdA0KPj4+PiBmb3IgZnV0dXJlIHdvcmssIGFuZCBo
ZXJlIGFyZSBzb21lIHJlYXNvbnM6DQo+Pj4+IA0KPj4+PiAxLiBIeXBlci1WL1hlbiBUTEItZmx1
c2hpbmcgY29kZSBpcyBub3QgdmVyeSBzaW1wbGUNCj4+Pj4gMi4gSSBkb27igJl0IGhhdmUgYSBw
cm9wZXIgc2V0dXANCj4+Pj4gMy4gSSBhbSBsYXp5DQo+Pj4gDQo+Pj4gSW4gdGhlIGxvbmcgcnVu
LCBJIHRoaW5rIHRoYXQgd2UncmUgZ29pbmcgdG8gd2FudCBhIHdheSBmb3Igb25lIENQVSB0bw0K
Pj4+IGRvIGEgcmVtb3RlIGZsdXNoIGFuZCB0aGVuLCB3aXRoIGFwcHJvcHJpYXRlIGxvY2tpbmcs
IHVwZGF0ZSB0aGUNCj4+PiB0bGJfZ2VuIGZpZWxkcyBmb3IgdGhlIHJlbW90ZSBDUFUuICBHZXR0
aW5nIHRoaXMgcmlnaHQgbWF5IGJlIGEgYml0DQo+Pj4gbm9udHJpdmlhbC4NCj4+IA0KPj4gV2hh
dCBkbyB5b3UgbWVhbiBieSDigJxkbyBhIHJlbW90ZSBmbHVzaOKAnT8NCj4gDQo+IEkgbWVhbiBh
IFBWLWFzc2lzdGVkIGZsdXNoIG9uIGEgQ1BVIG90aGVyIHRoYW4gdGhlIENQVSB0aGF0IHN0YXJ0
ZWQNCj4gaXQuICBJZiB5b3UgbG9vayBhdCBmbHVzaF90bGJfZnVuY19jb21tb24oKSwgaXQncyBk
b2luZyBzb21lIHdvcmsgdGhhdA0KPiBpcyByYXRoZXIgZmFuY2llciB0aGFuIGp1c3QgZmx1c2hp
bmcgdGhlIFRMQi4gIEJ5IHJlcGxhY2luZyBpdCB3aXRoDQo+IGp1c3QgYSBwdXJlIGZsdXNoIG9u
IFhlbiBvciBIeXBlci1WLCB3ZSdyZSBsb3NpbmcgdGhlIHBvdGVudGlhbCBDUjMNCj4gc3dpdGNo
IGFuZCB0aGlzIGJpdDoNCj4gDQo+ICAgICAgICAvKiBCb3RoIHBhdGhzIGFib3ZlIHVwZGF0ZSBv
dXIgc3RhdGUgdG8gbW1fdGxiX2dlbi4gKi8NCj4gICAgICAgIHRoaXNfY3B1X3dyaXRlKGNwdV90
bGJzdGF0ZS5jdHhzW2xvYWRlZF9tbV9hc2lkXS50bGJfZ2VuLCBtbV90bGJfZ2VuKTsNCj4gDQo+
IFNraXBwaW5nIHRoZSBmb3JtZXIgY2FuIGh1cnQgaWRsZSBwZXJmb3JtYW5jZSwgYWx0aG91Z2gg
d2Ugc2hvdWxkDQo+IGNvbnNpZGVyIGp1c3QgZGlzYWJsaW5nIGFsbCB0aGUgbGF6eSBvcHRpbWl6
YXRpb25zIG9uIHN5c3RlbXMgd2l0aCBQVg0KPiBmbHVzaC4gIChBbmQgSSd2ZSBhc2tlZCBJbnRl
bCB0byBoZWxwIHVzIG91dCBoZXJlIGluIGZ1dHVyZSBoYXJkd2FyZS4NCj4gSSBoYXZlIG5vIGlk
ZWEgd2hhdCB0aGUgcmVzdWx0IG9mIGFza2luZyB3aWxsIGJlLikgIFNraXBwaW5nIHRoZQ0KPiBj
cHVfdGxic3RhdGUgd3JpdGUgbWVhbnMgdGhhdCB3ZSB3aWxsIGRvIHVubmVjZXNzYXJ5IGZsdXNo
ZXMgaW4gdGhlDQo+IGZ1dHVyZSwgYW5kIHRoYXQncyBub3QgZG9pbmcgdXMgYW55IGZhdm9ycy4N
Cj4gDQo+IEluIHByaW5jaXBsZSwgd2Ugc2hvdWxkIGJlIGFibGUgdG8gZG8gc29tZXRoaW5nIGxp
a2U6DQo+IA0KPiBmbHVzaF90bGJfbXVsdGkoLi4uKTsNCj4gZm9yKGVhY2ggQ1BVIHRoYXQgZ290
IGZsdXNoZWQpIHsNCj4gIHNwaW5fbG9jayhzb21ldGhpbmcgYXBwcm9wcmlhdGU/KTsNCj4gIHBl
cl9jcHVfd3JpdGUoY3B1LCBjcHVfdGxic3RhdGUuY3R4c1tsb2FkZWRfbW1fYXNpZF0udGxiX2dl
biwgZi0+bmV3X3RsYl9nZW4pOw0KPiAgc3Bpbl91bmxvY2soLi4uKTsNCj4gfQ0KPiANCj4gd2l0
aCB0aGUgY2F2ZWF0IHRoYXQgaXQncyBtb3JlIGNvbXBsaWNhdGVkIHRoYW4gdGhpcyBpZiB0aGUg
Zmx1c2ggaXMgYQ0KPiBwYXJ0aWFsIGZsdXNoLCBhbmQgdGhhdCB3ZSdsbCB3YW50IHRvIGNoZWNr
IHRoYXQgdGhlIGN0eF9pZCBzdGlsbA0KPiBtYXRjaGVzLCBldGMuDQo+IA0KPiBEb2VzIHRoaXMg
bWFrZSBzZW5zZT8NCg0KVGhhbmtzIGZvciB0aGUgZGV0YWlsZWQgZXhwbGFuYXRpb24uIExldCBt
ZSBjaGVjayB0aGF0IEkgZ290IGl0IHJpZ2h0LiANCg0KWW91IHdhbnQgdG8gb3B0aW1pemUgY2Fz
ZXMgaW4gd2hpY2g6DQoNCjEuIEEgdmlydHVhbCBtYWNoaW5lDQoNCjIuIFdoaWNoIGlzc3VlcyBt
dHVsdGlwbGUgKHJlbW90ZSkgVExCIHNob290ZG93bnMNCg0KMi4gVG8gcmVtb3RlIHZDUFUgd2hp
Y2ggaXMgcHJlZW1wdGVkIGJ5IHRoZSBoeXBlcnZpc29yDQoNCjQuIEFuZCB1bmxpa2UgS1ZNLCB0
aGUgaHlwZXJ2aXNvciBkb2VzIG5vdCBwcm92aWRlIGZhY2lsaXRpZXMgZm9yIHRoZSBWTSB0bw0K
a25vdyB3aGljaCB2Q1BVIGlzIHByZWVtcHRlZCwgYW5kIGF0b21pY2FsbHkgcmVxdWVzdCBUTEIg
Zmx1c2ggd2hlbiB0aGUgdkNQVQ0KaXMgc2NoZWR1bGVkLg0KDQpSaWdodD8NCg0K
