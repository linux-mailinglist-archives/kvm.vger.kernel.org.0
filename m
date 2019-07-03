Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EB15EB37
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 20:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfGCSJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 14:09:34 -0400
Received: from mail-eopbgr710042.outbound.protection.outlook.com ([40.107.71.42]:39184
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726473AbfGCSJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 14:09:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ks4KFvd6izQE4mew5mVjNp9QQ8yAwJTjhnXO88xOcC4=;
 b=J5lTubMLh1yWBra38NV/bU0w37w4hN+B9Y5mYlDirizx7/VwyGYeThtNR8+exVPipGg7BpCMnKmuPjg3UMWWFjhSid/zbYewhHGfNiJbMYCF9TBSVgDIN6NKSRWdxHb1GMDC2DCOsQbSgjLiaMwmYWx01untqOV0V1CoXSn/XMw=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4005.namprd05.prod.outlook.com (52.135.199.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.15; Wed, 3 Jul 2019 18:09:30 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::f493:3bba:aabf:dd58%7]) with mapi id 15.20.2052.010; Wed, 3 Jul 2019
 18:09:30 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
CC:     Juergen Gross <jgross@suse.com>, Sasha Levin <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm list <kvm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH v2 4/9] x86/mm/tlb: Flush remote and local
 TLBs concurrently
Thread-Topic: [Xen-devel] [PATCH v2 4/9] x86/mm/tlb: Flush remote and local
 TLBs concurrently
Thread-Index: AQHVMW7qykCnng2DBUWUciRHoRZgF6a47Y6AgAAxzICAAAuJAIAAByiA
Date:   Wed, 3 Jul 2019 18:09:30 +0000
Message-ID: <650C2A6A-F663-497C-9637-277219536DE4@vmware.com>
References: <20190702235151.4377-1-namit@vmware.com>
 <20190702235151.4377-5-namit@vmware.com>
 <d89e2b57-8682-153e-33d8-98084e9983d6@suse.com>
 <A4BC0EDE-71F0-455D-964A-7250D005FB56@vmware.com>
 <6038042c-917f-d361-5d79-f0205152fe00@citrix.com>
In-Reply-To: <6038042c-917f-d361-5d79-f0205152fe00@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5bf02382-3a71-4497-2622-08d6ffe19862
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB4005;
x-ms-traffictypediagnostic: BYAPR05MB4005:
x-microsoft-antispam-prvs: <BYAPR05MB40056F9B947B67F537CD7AE8D0FB0@BYAPR05MB4005.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(189003)(199004)(71190400001)(33656002)(486006)(71200400001)(81156014)(36756003)(81166006)(8936002)(8676002)(7736002)(3846002)(6116002)(6486002)(6916009)(256004)(4326008)(14444005)(25786009)(5660300002)(7416002)(478600001)(68736007)(305945005)(66066001)(14454004)(6506007)(6246003)(73956011)(66476007)(6512007)(66556008)(102836004)(53936002)(76176011)(99286004)(186003)(53546011)(446003)(2906002)(26005)(54906003)(316002)(86362001)(6436002)(11346002)(476003)(64756008)(2616005)(76116006)(66446008)(66946007)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4005;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 68exr1ESOGjcD4Z2ljLKK0AV067PXfEosBcIaYffVI2T8q9xr3/wk24Hh9tuIAO/WxWM+bBN4DC29ljSHGyUtyWeiC1xRFUxU8aVN97Czz0aDql499YiALMpJcbuEqRYfJWsGT+iJfohwm45ErjDkACHhjvm3oJzuIxemN5P14IGoNM2ZrRJQhHvhrecdWB4AP1z6v2mHpjhUDbo4y+kgYVCmICh0XLTIkhES+GkXuPZmp3CfswxyxaHk2n4J7qDwEhheUO+xspvzUFK34KtGPudDDC4OZijk22puTOSkIkk5oEP8U99obuP+LvVkT3zUvRsvpRns0oUXXMogVjrduHYbivfprW7gr343WRkA1NBxVWOURldVxut1iRoX1481ZBhMSJuZLHarMP/p3oEP7LWz2pj9K4dsxK4VnJHPjE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15EE35CEB468C14C81A624C3722A5E35@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf02382-3a71-4497-2622-08d6ffe19862
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 18:09:30.6858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4005
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBKdWwgMywgMjAxOSwgYXQgMTA6NDMgQU0sIEFuZHJldyBDb29wZXIgPGFuZHJldy5jb29w
ZXIzQGNpdHJpeC5jb20+IHdyb3RlOg0KPiANCj4gT24gMDMvMDcvMjAxOSAxODowMiwgTmFkYXYg
QW1pdCB3cm90ZToNCj4+PiBPbiBKdWwgMywgMjAxOSwgYXQgNzowNCBBTSwgSnVlcmdlbiBHcm9z
cyA8amdyb3NzQHN1c2UuY29tPiB3cm90ZToNCj4+PiANCj4+PiBPbiAwMy4wNy4xOSAwMTo1MSwg
TmFkYXYgQW1pdCB3cm90ZToNCj4+Pj4gVG8gaW1wcm92ZSBUTEIgc2hvb3Rkb3duIHBlcmZvcm1h
bmNlLCBmbHVzaCB0aGUgcmVtb3RlIGFuZCBsb2NhbCBUTEJzDQo+Pj4+IGNvbmN1cnJlbnRseS4g
SW50cm9kdWNlIGZsdXNoX3RsYl9tdWx0aSgpIHRoYXQgZG9lcyBzby4gSW50cm9kdWNlDQo+Pj4+
IHBhcmF2aXJ0dWFsIHZlcnNpb25zIG9mIGZsdXNoX3RsYl9tdWx0aSgpIGZvciBLVk0sIFhlbiBh
bmQgaHlwZXItdiAoWGVuDQo+Pj4+IGFuZCBoeXBlci12IGFyZSBvbmx5IGNvbXBpbGUtdGVzdGVk
KS4NCj4+Pj4gV2hpbGUgdGhlIHVwZGF0ZWQgc21wIGluZnJhc3RydWN0dXJlIGlzIGNhcGFibGUg
b2YgcnVubmluZyBhIGZ1bmN0aW9uIG9uDQo+Pj4+IGEgc2luZ2xlIGxvY2FsIGNvcmUsIGl0IGlz
IG5vdCBvcHRpbWl6ZWQgZm9yIHRoaXMgY2FzZS4gVGhlIG11bHRpcGxlDQo+Pj4+IGZ1bmN0aW9u
IGNhbGxzIGFuZCB0aGUgaW5kaXJlY3QgYnJhbmNoIGludHJvZHVjZSBzb21lIG92ZXJoZWFkLCBh
bmQNCj4+Pj4gbWlnaHQgbWFrZSBsb2NhbCBUTEIgZmx1c2hlcyBzbG93ZXIgdGhhbiB0aGV5IHdl
cmUgYmVmb3JlIHRoZSByZWNlbnQNCj4+Pj4gY2hhbmdlcy4NCj4+Pj4gQmVmb3JlIGNhbGxpbmcg
dGhlIFNNUCBpbmZyYXN0cnVjdHVyZSwgY2hlY2sgaWYgb25seSBhIGxvY2FsIFRMQiBmbHVzaA0K
Pj4+PiBpcyBuZWVkZWQgdG8gcmVzdG9yZSB0aGUgbG9zdCBwZXJmb3JtYW5jZSBpbiB0aGlzIGNv
bW1vbiBjYXNlLiBUaGlzDQo+Pj4+IHJlcXVpcmVzIHRvIGNoZWNrIG1tX2NwdW1hc2soKSBvbmUg
bW9yZSB0aW1lLCBidXQgdW5sZXNzIHRoaXMgbWFzayBpcw0KPj4+PiB1cGRhdGVkIHZlcnkgZnJl
cXVlbnRseSwgdGhpcyBzaG91bGQgaW1wYWN0IHBlcmZvcm1hbmNlIG5lZ2F0aXZlbHkuDQo+Pj4+
IENjOiAiSy4gWS4gU3Jpbml2YXNhbiIgPGt5c0BtaWNyb3NvZnQuY29tPg0KPj4+PiBDYzogSGFp
eWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4NCj4+Pj4gQ2M6IFN0ZXBoZW4gSGVt
bWluZ2VyIDxzdGhlbW1pbkBtaWNyb3NvZnQuY29tPg0KPj4+PiBDYzogU2FzaGEgTGV2aW4gPHNh
c2hhbEBrZXJuZWwub3JnPg0KPj4+PiBDYzogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9u
aXguZGU+DQo+Pj4+IENjOiBJbmdvIE1vbG5hciA8bWluZ29AcmVkaGF0LmNvbT4NCj4+Pj4gQ2M6
IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRlPg0KPj4+PiBDYzogeDg2QGtlcm5lbC5vcmcN
Cj4+Pj4gQ2M6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4+Pj4gQ2M6IFBhb2xv
IEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+DQo+Pj4+IENjOiBEYXZlIEhhbnNlbiA8ZGF2
ZS5oYW5zZW5AbGludXguaW50ZWwuY29tPg0KPj4+PiBDYzogQW5keSBMdXRvbWlyc2tpIDxsdXRv
QGtlcm5lbC5vcmc+DQo+Pj4+IENjOiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5v
cmc+DQo+Pj4+IENjOiBCb3JpcyBPc3Ryb3Zza3kgPGJvcmlzLm9zdHJvdnNreUBvcmFjbGUuY29t
Pg0KPj4+PiBDYzogbGludXgtaHlwZXJ2QHZnZXIua2VybmVsLm9yZw0KPj4+PiBDYzogbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZw0KPj4+PiBDYzogdmlydHVhbGl6YXRpb25AbGlzdHMubGlu
dXgtZm91bmRhdGlvbi5vcmcNCj4+Pj4gQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCj4+Pj4gQ2M6
IHhlbi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZw0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBOYWRh
diBBbWl0IDxuYW1pdEB2bXdhcmUuY29tPg0KPj4+PiAtLS0NCj4+Pj4gYXJjaC94ODYvaHlwZXJ2
L21tdS5jICAgICAgICAgICAgICAgICB8IDEzICsrKy0tLQ0KPj4+PiBhcmNoL3g4Ni9pbmNsdWRl
L2FzbS9wYXJhdmlydC5oICAgICAgIHwgIDYgKy0tDQo+Pj4+IGFyY2gveDg2L2luY2x1ZGUvYXNt
L3BhcmF2aXJ0X3R5cGVzLmggfCAgNCArLQ0KPj4+PiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS90bGJm
bHVzaC5oICAgICAgIHwgIDkgKystLQ0KPj4+PiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS90cmFjZS9o
eXBlcnYuaCAgIHwgIDIgKy0NCj4+Pj4gYXJjaC94ODYva2VybmVsL2t2bS5jICAgICAgICAgICAg
ICAgICB8IDExICsrKy0tDQo+Pj4+IGFyY2gveDg2L2tlcm5lbC9wYXJhdmlydC5jICAgICAgICAg
ICAgfCAgMiArLQ0KPj4+PiBhcmNoL3g4Ni9tbS90bGIuYyAgICAgICAgICAgICAgICAgICAgIHwg
NjUgKysrKysrKysrKysrKysrKysrKystLS0tLS0tDQo+Pj4+IGFyY2gveDg2L3hlbi9tbXVfcHYu
YyAgICAgICAgICAgICAgICAgfCAyMCArKysrKystLS0NCj4+Pj4gaW5jbHVkZS90cmFjZS9ldmVu
dHMveGVuLmggICAgICAgICAgICB8ICAyICstDQo+Pj4+IDEwIGZpbGVzIGNoYW5nZWQsIDkxIGlu
c2VydGlvbnMoKyksIDQzIGRlbGV0aW9ucygtKQ0KPj4+IC4uLg0KPj4+IA0KPj4+PiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYveGVuL21tdV9wdi5jIGIvYXJjaC94ODYveGVuL21tdV9wdi5jDQo+Pj4+
IGluZGV4IGJlYjQ0ZTIyYWZkZi4uMTllNDgxZTZlOTA0IDEwMDY0NA0KPj4+PiAtLS0gYS9hcmNo
L3g4Ni94ZW4vbW11X3B2LmMNCj4+Pj4gKysrIGIvYXJjaC94ODYveGVuL21tdV9wdi5jDQo+Pj4+
IEBAIC0xMzU1LDggKzEzNTUsOCBAQCBzdGF0aWMgdm9pZCB4ZW5fZmx1c2hfdGxiX29uZV91c2Vy
KHVuc2lnbmVkIGxvbmcgYWRkcikNCj4+Pj4gCXByZWVtcHRfZW5hYmxlKCk7DQo+Pj4+IH0NCj4+
Pj4gLXN0YXRpYyB2b2lkIHhlbl9mbHVzaF90bGJfb3RoZXJzKGNvbnN0IHN0cnVjdCBjcHVtYXNr
ICpjcHVzLA0KPj4+PiAtCQkJCSBjb25zdCBzdHJ1Y3QgZmx1c2hfdGxiX2luZm8gKmluZm8pDQo+
Pj4+ICtzdGF0aWMgdm9pZCB4ZW5fZmx1c2hfdGxiX211bHRpKGNvbnN0IHN0cnVjdCBjcHVtYXNr
ICpjcHVzLA0KPj4+PiArCQkJCWNvbnN0IHN0cnVjdCBmbHVzaF90bGJfaW5mbyAqaW5mbykNCj4+
Pj4gew0KPj4+PiAJc3RydWN0IHsNCj4+Pj4gCQlzdHJ1Y3QgbW11ZXh0X29wIG9wOw0KPj4+PiBA
QCAtMTM2Niw3ICsxMzY2LDcgQEAgc3RhdGljIHZvaWQgeGVuX2ZsdXNoX3RsYl9vdGhlcnMoY29u
c3Qgc3RydWN0IGNwdW1hc2sgKmNwdXMsDQo+Pj4+IAljb25zdCBzaXplX3QgbWNfZW50cnlfc2l6
ZSA9IHNpemVvZihhcmdzLT5vcCkgKw0KPj4+PiAJCXNpemVvZihhcmdzLT5tYXNrWzBdKSAqIEJJ
VFNfVE9fTE9OR1MobnVtX3Bvc3NpYmxlX2NwdXMoKSk7DQo+Pj4+IC0JdHJhY2VfeGVuX21tdV9m
bHVzaF90bGJfb3RoZXJzKGNwdXMsIGluZm8tPm1tLCBpbmZvLT5zdGFydCwgaW5mby0+ZW5kKTsN
Cj4+Pj4gKwl0cmFjZV94ZW5fbW11X2ZsdXNoX3RsYl9tdWx0aShjcHVzLCBpbmZvLT5tbSwgaW5m
by0+c3RhcnQsIGluZm8tPmVuZCk7DQo+Pj4+ICAgCWlmIChjcHVtYXNrX2VtcHR5KGNwdXMpKQ0K
Pj4+PiAJCXJldHVybjsJCS8qIG5vdGhpbmcgdG8gZG8gKi8NCj4+Pj4gQEAgLTEzNzUsOSArMTM3
NSwxNyBAQCBzdGF0aWMgdm9pZCB4ZW5fZmx1c2hfdGxiX290aGVycyhjb25zdCBzdHJ1Y3QgY3B1
bWFzayAqY3B1cywNCj4+Pj4gCWFyZ3MgPSBtY3MuYXJnczsNCj4+Pj4gCWFyZ3MtPm9wLmFyZzIu
dmNwdW1hc2sgPSB0b19jcHVtYXNrKGFyZ3MtPm1hc2spOw0KPj4+PiAtCS8qIFJlbW92ZSB1cywg
YW5kIGFueSBvZmZsaW5lIENQVVMuICovDQo+Pj4+ICsJLyogRmx1c2ggbG9jYWxseSBpZiBuZWVk
ZWQgYW5kIHJlbW92ZSB1cyAqLw0KPj4+PiArCWlmIChjcHVtYXNrX3Rlc3RfY3B1KHNtcF9wcm9j
ZXNzb3JfaWQoKSwgdG9fY3B1bWFzayhhcmdzLT5tYXNrKSkpIHsNCj4+Pj4gKwkJbG9jYWxfaXJx
X2Rpc2FibGUoKTsNCj4+Pj4gKwkJZmx1c2hfdGxiX2Z1bmNfbG9jYWwoaW5mbyk7DQo+Pj4gSSB0
aGluayB0aGlzIGlzbid0IHRoZSBjb3JyZWN0IGZ1bmN0aW9uIGZvciBQViBndWVzdHMuDQo+Pj4g
DQo+Pj4gSW4gZmFjdCBpdCBzaG91bGQgYmUgbXVjaCBlYXNpZXI6IGp1c3QgZG9uJ3QgY2xlYXIg
dGhlIG93biBjcHUgZnJvbSB0aGUNCj4+PiBtYXNrLCB0aGF0J3MgYWxsIHdoYXQncyBuZWVkZWQu
IFRoZSBoeXBlcnZpc29yIGlzIGp1c3QgZmluZSBoYXZpbmcgdGhlDQo+Pj4gY3VycmVudCBjcHUg
aW4gdGhlIG1hc2sgYW5kIGl0IHdpbGwgZG8gdGhlIHJpZ2h0IHRoaW5nLg0KPj4gVGhhbmtzLiBJ
IHdpbGwgZG8gc28gaW4gdjMuIEkgZG9u4oCZdCB0aGluayBIeXBlci1WIHBlb3BsZSB3b3VsZCB3
YW50IHRvIGRvDQo+PiB0aGUgc2FtZSwgdW5mb3J0dW5hdGVseSwgc2luY2UgaXQgd291bGQgaW5k
dWNlIFZNLWV4aXQgb24gVExCIGZsdXNoZXMuDQo+IA0KPiBXaHkgZG8geW91IGJlbGlldmUgdGhl
IHZtZXhpdCBtYXR0ZXJzPyAgWW91J3JlIHRhbGtpbmcgb25lIGFueXdheSBmb3INCj4gdGhlIElQ
SS4NCj4gDQo+IEludGVsIG9ubHkgaGF2ZSB2aXJ0dWFsaXNlZCBzZWxmLUlQSSwgYW5kIHdoaWxl
IEFNRCBkbyBoYXZlIHdvcmtpbmcNCj4gbm9uLXNlbGYgSVBJcywgeW91IHN0aWxsIHRha2UgYSB2
bWV4aXQgYW55d2F5IGlmIGFueSBkZXN0aW5hdGlvbiB2Y3B1DQo+IGlzbid0IGN1cnJlbnRseSBy
dW5uaW5nIGluIG5vbi1yb290IG1vZGUgKElJUkMpLg0KPiANCj4gQXQgdGhhdCBwb2ludCwgeW91
IG1pZ2h0IGFzIHdlbGwgaGF2ZSB0aGUgaHlwZXJ2aXNvciBkbyBhbGwgdGhlIGhhcmQNCj4gd29y
ayB2aWEgYSBtdWx0aS1jcHUgc2hvb3Rkb3duL2ZsdXNoIGh5cGVyY2FsbCwgcmF0aGVyIHRoYW4g
dHJ5aW5nIHRvDQo+IGFycmFuZ2UgaXQgbG9jYWxseS4NCg0KSSBmb3Jnb3QgdGhhdCB4ZW5fZmx1
c2hfdGxiX211bHRpKCkgc2hvdWxkIGFjdHVhbGx5IG9ubHkgYmUgY2FsbGVkIHdoZW4NCnRoZXJl
IGFyZSBzb21lIHJlbW90ZSBDUFVzIChhcyBJIG9wdGltaXplZCB0aGUgY2FzZSBpbiB3aGljaCB0
aGVyZSBpcyBvbmx5IGENCnNpbmdsZSBsb2NhbCBDUFUgdGhhdCBuZWVkcyB0byBiZSBmbHVzaGVk
KSwgc28geW91IGFyZSByaWdodC4NCg0K
