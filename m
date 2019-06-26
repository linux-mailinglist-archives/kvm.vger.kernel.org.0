Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D242C56084
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 05:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfFZDlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 23:41:44 -0400
Received: from mail-eopbgr800083.outbound.protection.outlook.com ([40.107.80.83]:3956
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726867AbfFZDln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 23:41:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=beT+GnWI52iaZbiNZfwAiwcuJMFMKlvcJrLgDOZUrWw=;
 b=XZtnwI4n/Zw/eG162D/wwY7bpOjTcW/4DdgtfmUxTezNQtE7/MB0gonkjfkhYU83X71Rayqr6P3K0qX8CI94/fXgluw9jLYX+HSmDPXO3J08R3wxIV4uicVgUbxAyjknp/4crHCla82Nnb6LYFIfI96kWJfS8V5hkdrSt6/kjmY=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4808.namprd05.prod.outlook.com (52.135.235.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Wed, 26 Jun 2019 03:41:37 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58%7]) with mapi id 15.20.2008.007; Wed, 26 Jun 2019
 03:41:37 +0000
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
Thread-Index: AQHVIbQq2DFUsKveqk6vAXwf0z5KPqas+eUAgABThoCAAA9+AIAAAcoA
Date:   Wed, 26 Jun 2019 03:41:37 +0000
Message-ID: <35755C67-E8EB-48C3-8343-BB9ABEB4E32C@vmware.com>
References: <20190613064813.8102-1-namit@vmware.com>
 <20190613064813.8102-7-namit@vmware.com>
 <cb28f2b4-92f0-f075-648e-dddfdbdd2e3c@intel.com>
 <401C4384-98A1-4C27-8F71-4848F4B4A440@vmware.com>
 <CALCETrWcUWw8ep-n6RaOeojnL924xOM7g7eb9g=3DRwOHQAgnA@mail.gmail.com>
In-Reply-To: <CALCETrWcUWw8ep-n6RaOeojnL924xOM7g7eb9g=3DRwOHQAgnA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [204.134.128.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58e169ea-a6fd-447a-13f4-08d6f9e83183
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB4808;
x-ms-traffictypediagnostic: BYAPR05MB4808:
x-microsoft-antispam-prvs: <BYAPR05MB4808EF17C9331CF062C6DB7AD0E20@BYAPR05MB4808.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(346002)(376002)(366004)(54534003)(51444003)(189003)(199004)(5660300002)(316002)(36756003)(7416002)(66446008)(2616005)(53546011)(14454004)(2906002)(66476007)(86362001)(99286004)(81166006)(81156014)(64756008)(8936002)(3846002)(102836004)(66946007)(6116002)(6506007)(76176011)(26005)(305945005)(7736002)(486006)(8676002)(476003)(73956011)(68736007)(91956017)(76116006)(54906003)(71190400001)(4326008)(66556008)(478600001)(71200400001)(6436002)(6916009)(229853002)(14444005)(6512007)(33656002)(256004)(66066001)(446003)(25786009)(6246003)(6486002)(11346002)(186003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4808;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3ctMZzIE1fOAPiFXBafjRtThAFxcrHMnw30nOzYOFjLuKuURfF+DVu08KbdXd1nniK14f45SJbDiLGIOf+bAHAH9zEUx/cO2O5Y+Lye9GLPEl9TktP3aSDsaF8kExE1vU9ckB7eEjVVnPZGrDkjlxbEn9ebcGFcSM8ebHFGFHRDLTRvMIoRAOjQSKH1fVOMiihH38Xi8ENzyf9Xyrkd8W0YdeL/Ha7JcfKe4MZbiKyksQpbJqLzeC7kuAN25//I+pnrSzfl6Q2w6UjafUwUnVbGqyBr+FDAIV7Wyzqiu09LM4ePn2E0FfO1lJ0K5NqK3LEGuXfPuzHL+3ieHTnxgEyc4ZwXniIxuXlS1A1Wzd/xhF6hJcqFwpDnAsOmwn7YiT01/QVgYUgplt6PyDBKIA9dS77V7Xz6oKCDrXnEz7gE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB0FFD6350543642ACE024F2FCB38150@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e169ea-a6fd-447a-13f4-08d6f9e83183
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 03:41:37.6757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4808
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdW4gMjUsIDIwMTksIGF0IDg6MzUgUE0sIEFuZHkgTHV0b21pcnNraSA8bHV0b0BrZXJu
ZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIFR1ZSwgSnVuIDI1LCAyMDE5IGF0IDc6MzkgUE0gTmFk
YXYgQW1pdCA8bmFtaXRAdm13YXJlLmNvbT4gd3JvdGU6DQo+Pj4gT24gSnVuIDI1LCAyMDE5LCBh
dCAyOjQwIFBNLCBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPiB3cm90ZToNCj4+
PiANCj4+PiBPbiA2LzEyLzE5IDExOjQ4IFBNLCBOYWRhdiBBbWl0IHdyb3RlOg0KPj4+PiBTdXBw
b3J0IHRoZSBuZXcgaW50ZXJmYWNlIG9mIGZsdXNoX3RsYl9tdWx0aSwgd2hpY2ggYWxzbyBmbHVz
aGVzIHRoZQ0KPj4+PiBsb2NhbCBDUFUncyBUTEIsIGluc3RlYWQgb2YgZmx1c2hfdGxiX290aGVy
cyB0aGF0IGRvZXMgbm90LiBUaGlzDQo+Pj4+IGludGVyZmFjZSBpcyBtb3JlIHBlcmZvcm1hbnQg
c2luY2UgaXQgcGFyYWxsZWxpemUgcmVtb3RlIGFuZCBsb2NhbCBUTEINCj4+Pj4gZmx1c2hlcy4N
Cj4+Pj4gDQo+Pj4+IFRoZSBhY3R1YWwgaW1wbGVtZW50YXRpb24gb2YgZmx1c2hfdGxiX211bHRp
KCkgaXMgYWxtb3N0IGlkZW50aWNhbCB0bw0KPj4+PiB0aGF0IG9mIGZsdXNoX3RsYl9vdGhlcnMo
KS4NCj4+PiANCj4+PiBUaGlzIGNvbmZ1c2VkIG1lIGEgYml0LiAgSSB0aG91Z2h0IHdlIGRpZG4n
dCBzdXBwb3J0IHBhcmF2aXJ0dWFsaXplZA0KPj4+IGZsdXNoX3RsYl9tdWx0aSgpIGZyb20gcmVh
ZGluZyBlYXJsaWVyIGluIHRoZSBzZXJpZXMuDQo+Pj4gDQo+Pj4gQnV0LCBpdCBzZWVtcyBsaWtl
IHRoYXQgbWlnaHQgYmUgWGVuLW9ubHkgYW5kIGRvZXNuJ3QgYXBwbHkgdG8gS1ZNIGFuZA0KPj4+
IHBhcmF2aXJ0dWFsaXplZCBLVk0gaGFzIG5vIHByb2JsZW0gc3VwcG9ydGluZyBmbHVzaF90bGJf
bXVsdGkoKS4gIElzDQo+Pj4gdGhhdCByaWdodD8gIEl0IG1pZ2h0IGJlIGdvb2QgdG8gaW5jbHVk
ZSBzb21lIG9mIHRoYXQgYmFja2dyb3VuZCBpbiB0aGUNCj4+PiBjaGFuZ2Vsb2cgdG8gc2V0IHRo
ZSBjb250ZXh0Lg0KPj4gDQo+PiBJ4oCZbGwgdHJ5IHRvIGltcHJvdmUgdGhlIGNoYW5nZS1sb2dz
IGEgYml0LiBUaGVyZSBpcyBubyBpbmhlcmVudCByZWFzb24gZm9yDQo+PiBQViBUTEItZmx1c2hl
cnMgbm90IHRvIGltcGxlbWVudCB0aGVpciBvd24gZmx1c2hfdGxiX211bHRpKCkuIEl0IGlzIGxl
ZnQNCj4+IGZvciBmdXR1cmUgd29yaywgYW5kIGhlcmUgYXJlIHNvbWUgcmVhc29uczoNCj4+IA0K
Pj4gMS4gSHlwZXItVi9YZW4gVExCLWZsdXNoaW5nIGNvZGUgaXMgbm90IHZlcnkgc2ltcGxlDQo+
PiAyLiBJIGRvbuKAmXQgaGF2ZSBhIHByb3BlciBzZXR1cA0KPj4gMy4gSSBhbSBsYXp5DQo+IA0K
PiBJbiB0aGUgbG9uZyBydW4sIEkgdGhpbmsgdGhhdCB3ZSdyZSBnb2luZyB0byB3YW50IGEgd2F5
IGZvciBvbmUgQ1BVIHRvDQo+IGRvIGEgcmVtb3RlIGZsdXNoIGFuZCB0aGVuLCB3aXRoIGFwcHJv
cHJpYXRlIGxvY2tpbmcsIHVwZGF0ZSB0aGUNCj4gdGxiX2dlbiBmaWVsZHMgZm9yIHRoZSByZW1v
dGUgQ1BVLiAgR2V0dGluZyB0aGlzIHJpZ2h0IG1heSBiZSBhIGJpdA0KPiBub250cml2aWFsLg0K
DQpXaGF0IGRvIHlvdSBtZWFuIGJ5IOKAnGRvIGEgcmVtb3RlIGZsdXNo4oCdPw0KDQo=
