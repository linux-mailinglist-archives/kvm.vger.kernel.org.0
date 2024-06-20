Return-Path: <kvm+bounces-20060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30664910132
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 12:11:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2713285384
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 10:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6126E1A8C33;
	Thu, 20 Jun 2024 10:11:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F031D1A8C01;
	Thu, 20 Jun 2024 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718878265; cv=none; b=EVTVQ6kLO4ooEbJzawqCCmx1Wn2ktabRYC9qEyKyNVjDvczsmKYyFCFccb+8jT4yThTYrSWU3y7qF+ugVpQgDDgc5Xh+90na+v9XrwsRGaD2RE4BTBgrQElID3v98XmQTKHQKeXgs4ddZDuvd2bA4alW2pMy+iEhPirhmPKtwMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718878265; c=relaxed/simple;
	bh=P4nGO6WoNahjKeS7KnCYubElsszhtWZMVWf8oaNq4AY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cyyzFSxzDtSebbjGzFfXJPGj2DfBdFxqiX6EXduV4rJ46zTUxuScI0lkL0vHPvL8v0ZG5qt1CJK58Tf6IWVflKDTtmhX7P6DMOYxMCxivfxlPG1eGx5Ztgzb2yk72myuWlozTQwdNHyEp3OTvh5zTa8kcteX0gWC+Gj493bbly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4W4bnL6HGMz6K99B;
	Thu, 20 Jun 2024 18:09:26 +0800 (CST)
Received: from lhrpeml500006.china.huawei.com (unknown [7.191.161.198])
	by mail.maildlp.com (Postfix) with ESMTPS id EEE0314058E;
	Thu, 20 Jun 2024 18:10:59 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 11:10:59 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Thu, 20 Jun 2024 11:10:59 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Sean Christopherson <seanjc@google.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Huacai Chen
	<chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Anup Patel
	<anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, "Heiko
 Carstens" <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
	"Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Andy Lutomirski <luto@kernel.org>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>, "Anish
 Ghulati" <aghulati@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>,
	Andrew Thornton <andrewth@google.com>
Subject: RE: [PATCH 00/26] KVM: vfio: Hide KVM internals from others
Thread-Topic: [PATCH 00/26] KVM: vfio: Hide KVM internals from others
Thread-Index: AQHZ6DUkZqOCX4TQLUabDzpapjtX9LHSHHZQ
Date: Thu, 20 Jun 2024 10:10:59 +0000
Message-ID: <504fa0a7264d4762afda2f13c3525ce5@huawei.com>
References: <20230916003118.2540661-1-seanjc@google.com>
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VhbiBDaHJpc3RvcGhl
cnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFNhdHVyZGF5LCBTZXB0ZW1iZXIgMTYs
IDIwMjMgMTozMSBBTQ0KPiBUbzogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJt
LmNvbT47IFdpbGwgRGVhY29uDQo+IDx3aWxsQGtlcm5lbC5vcmc+OyBNYXJjIFp5bmdpZXIgPG1h
ekBrZXJuZWwub3JnPjsgT2xpdmVyIFVwdG9uDQo+IDxvbGl2ZXIudXB0b25AbGludXguZGV2Pjsg
SHVhY2FpIENoZW4gPGNoZW5odWFjYWlAa2VybmVsLm9yZz47IE1pY2hhZWwNCj4gRWxsZXJtYW4g
PG1wZUBlbGxlcm1hbi5pZC5hdT47IEFudXAgUGF0ZWwgPGFudXBAYnJhaW5mYXVsdC5vcmc+OyBQ
YXVsDQo+IFdhbG1zbGV5IDxwYXVsLndhbG1zbGV5QHNpZml2ZS5jb20+OyBQYWxtZXIgRGFiYmVs
dA0KPiA8cGFsbWVyQGRhYmJlbHQuY29tPjsgQWxiZXJ0IE91IDxhb3VAZWVjcy5iZXJrZWxleS5l
ZHU+OyBIZWlrbw0KPiBDYXJzdGVucyA8aGNhQGxpbnV4LmlibS5jb20+OyBWYXNpbHkgR29yYmlr
IDxnb3JAbGludXguaWJtLmNvbT47DQo+IEFsZXhhbmRlciBHb3JkZWV2IDxhZ29yZGVldkBsaW51
eC5pYm0uY29tPjsgQ2hyaXN0aWFuIEJvcm50cmFlZ2VyDQo+IDxib3JudHJhZWdlckBsaW51eC5p
Ym0uY29tPjsgSmFub3NjaCBGcmFuayA8ZnJhbmtqYUBsaW51eC5pYm0uY29tPjsNCj4gQ2xhdWRp
byBJbWJyZW5kYSA8aW1icmVuZGFAbGludXguaWJtLmNvbT47IFRob21hcyBHbGVpeG5lcg0KPiA8
dGdseEBsaW51dHJvbml4LmRlPjsgSW5nbyBNb2xuYXIgPG1pbmdvQHJlZGhhdC5jb20+OyBCb3Jp
c2xhdiBQZXRrb3YNCj4gPGJwQGFsaWVuOC5kZT47IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBs
aW51eC5pbnRlbC5jb20+Ow0KPiB4ODZAa2VybmVsLm9yZzsgUGV0ZXIgWmlqbHN0cmEgPHBldGVy
ekBpbmZyYWRlYWQub3JnPjsgQXJuYWxkbyBDYXJ2YWxobyBkZQ0KPiBNZWxvIDxhY21lQGtlcm5l
bC5vcmc+OyBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT47DQo+IFBhb2xv
IEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+OyBUb255IEtyb3dpYWsNCj4gPGFrcm93aWFr
QGxpbnV4LmlibS5jb20+OyBIYWxpbCBQYXNpYyA8cGFzaWNAbGludXguaWJtLmNvbT47IEphc29u
IEhlcm5lDQo+IDxqamhlcm5lQGxpbnV4LmlibS5jb20+OyBIYXJhbGQgRnJldWRlbmJlcmdlciA8
ZnJldWRlQGxpbnV4LmlibS5jb20+Ow0KPiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNv
bkByZWRoYXQuY29tPjsgQW5keSBMdXRvbWlyc2tpDQo+IDxsdXRvQGtlcm5lbC5vcmc+DQo+IENj
OiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGt2bWFybUBsaXN0cy5saW51
eC5kZXY7IGxpbnV4LQ0KPiBtaXBzQHZnZXIua2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9y
ZzsgbGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5vcmc7DQo+IGt2bS1yaXNjdkBsaXN0cy5pbmZy
YWRlYWQub3JnOyBsaW51eC1yaXNjdkBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC0NCj4gczM5
MEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXBl
cmYtDQo+IHVzZXJzQHZnZXIua2VybmVsLm9yZzsgQW5pc2ggR2h1bGF0aSA8YWdodWxhdGlAZ29v
Z2xlLmNvbT47IFZlbmthdGVzaA0KPiBTcmluaXZhcyA8dmVua2F0ZXNoc0BjaHJvbWl1bS5vcmc+
OyBBbmRyZXcgVGhvcm50b24NCj4gPGFuZHJld3RoQGdvb2dsZS5jb20+DQo+IFN1YmplY3Q6IFtQ
QVRDSCAwMC8yNl0gS1ZNOiB2ZmlvOiBIaWRlIEtWTSBpbnRlcm5hbHMgZnJvbSBvdGhlcnMNCj4g
DQo+IFRoaXMgaXMgYSBib3JkZXJsaW5lIFJGQyBzZXJpZXMgdG8gaGlkZSBLVk0ncyBpbnRlcm5h
bHMgZnJvbSB0aGUgcmVzdCBvZg0KPiB0aGUga2VybmVsLCB3aGVyZSAiaW50ZXJuYWxzIiBtZWFu
cyBkYXRhIHN0cnVjdHVyZXMsIGVudW1zLCAjZGVmaW5lcywNCj4gQVBJcywgZXRjLiB0aGF0IGFy
ZSBpbnRlbmRlZCB0byBiZSBLVk0tb25seSwgYnV0IGFyZSBleHBvc2VkIGV2ZXJ5d2hlcmUNCj4g
ZHVlIHRvIGt2bV9ob3N0LmggKGFuZCBvdGhlciBoZWFkZXJzKSBsaXZpbmcgaW4gdGhlIGdsb2Jh
bCBpbmNsdWRlIHBhdGhzLg0KPiANCj4gVGhlIG1vdGl2aWF0aW9uIGZvciBoaWRpbmcgS1ZNJ3Mg
aW50ZXJuYWxzIGlzIHRvIGFsbG93ICpzYWZlbHkqIGxvYWRpbmcgYQ0KPiAibmV3IiBLVk0gbW9k
dWxlIHdpdGhvdXQgaGF2aW5nIHRvIHJlYm9vdCB0aGUgaG9zdC4gIFdoZXJlICJuZXciIGRvZXNu
J3QNCj4gaGF2ZSB0byBiZSBzdHJpY3RseSBuZXdlciwganVzdCBhIGRpZmZlcmVudCBpbmNhcm5h
dGlvbiBvZiBLVk0uICBIaWRpbmcNCj4gS1ZNJ3MgaW50ZXJuYWxzIG1lYW5zIHRob3NlIGFzc2V0
cyBjYW4gY2hhbmdlIGFjcm9zcyBLVk0gaW5zdGFuY2VzDQo+IHdpdGhvdXQNCj4gYnJlYWtpbmcg
dGhpbmdzLCBlLmcuIHdvdWxkIGFsbG93IG1vZGlmeWluZyB0aGUgbGF5b3V0IG9mIHN0cnVjdCBr
dm1fdmNwdQ0KPiB0byBpbnRyb2R1Y2UgbmV3IGZpZWxkcyByZWxhdGVkIHRvIGEgbmV3IGZlYXR1
cmUgb3IgbWl0aWdhdGlvbiBmb3IgaGFyZHdhcmUNCj4gYnVncy4NCj4gDQo+IFRoZSBlbmQgZ29h
bCBmb3IgYWxsIG9mIHRoaXMgaXMgdG8gYWxsb3cgbG9hZGluZyBhbmQgcnVubmluZyBtdWx0aXBs
ZQ0KPiBpbnN0YW5jZXMgb2YgS1ZNICh0aGUgbW9kdWxlKSBzaW11bHRhbmVvdXNseSBvbiBhIHNp
bmdsZSBob3N0LCBlLmcuIHRvDQo+IGRlcGxveSBmaXhlcywgbWl0aWdhdGlvbnMsIGFuZC9vciBu
ZXcgZmVhdHVyZXMgd2l0aG91dCBoYXZpbmcgdG8gZHJhaW4NCj4gYWxsIFZNcyBmcm9tIHRoZSBo
b3N0Lg0KPiANCj4gRm9yIG5vdywgdGhlIGltbWVkaWF0ZSBnb2FsIGlzIHRvIGdldCBLVk0gdG8g
YSBzdGF0ZSB3aGVyZSBLVk0geDg2IGRvZXNuJ3QNCj4gZXhwb3NlIGFueXRoaW5nIHRvIHRoZSBi
cm9hZGVyIHdvcmxkIHRoYXQgaXNuJ3QgaW50ZW5kZWQgZm9yIGV4dGVybmFsDQo+IGNvbnN1bXB0
aW9uLCBlLmcuIHRoZSBwYWdlIHdyaXRlLXRyYWNraW5nIEFQSXMgdXNlZCBieSBLVk0tR1QuDQo+
IA0KPiBJIHNheSB0aGlzIGlzIGJvcmRlcmxpbmUgUkZDIGJlY2F1c2UgSSBkb24ndCB0aGluayBJ
J3ZlICJmb3JtYWxseSIgcHJvcG9zZWQNCj4gdGhlIGlkZWEgb2YgaGlkaW5nIEtWTSBpbnRlcm5h
bHMgYmVmb3JlIG5vdy4gIEkgZGVjaWRlZCBub3QgdG8gdGFnIHRoaXMgUkZDDQo+IGJlY2F1c2Ug
dGhlIGNoYW5nZXMgZW5kZWQgdXAgYmVpbmcgbm90IF90aGF0XyBpbnZhc2l2ZSwgYW5kIGV2ZXJ5
dGhpbmcNCj4gYmVmb3JlIHRoZSBsYXN0IHNpeCBwYXRjaGVzIGlzIHdvcnRod2hpbGUgZXZlbiBp
ZiBoaWRpbmcgaW50ZXJuYWxzIGlzDQo+IHVsdGltYXRlbHkgcmVqZWN0ZWQgKElNTykuDQo+IA0K
PiBUaGlzIHdvdWxkIGlkZWFsbHkgYmUgfjUgc2VwYXJhdGUgc2VyaWVzLCBhbmQgSSBjZXJ0YWlu
bHkgaGF2ZSBubyBvYmplY3Rpb24NCj4gaWYgdGhhdCdzIGhvdyB3ZSB3YW50IHRvIGdldCB0aGlz
IHN0dWZmIG1lcmdlZC4gIEUuZy4gKDEpIFZGSU8gY2xlYW51cHMsDQo+ICgyKSBkcm9wIEhBVkVf
S1ZNLCAoMykgY2xlYW4gdXAgbWFrZWZpbGVzLCAoNCkgeDg2IHBlcmYgY2xlYW51cCwgYW5kDQo+
ICg1KSBmaW5hbCBwdXNoIGZvciBoaWRpbmcgc3RhdGUuICBUaGUgSEFWRV9LVk0gYW5kIHZpcnQv
a3ZtIGluY2x1ZGUgc3R1ZmYNCj4gaXNuJ3Qgc3RyaWN0bHkgbmVjZXNzYXJ5LCBidXQgSSBpbmNs
dWRlZCB0aGVtIGhlcmUgYmVjYXVzZSB0aGV5J3JlDQo+IHJlbGF0aXZlbHkgbWlub3IgKGluIHRo
ZSBncmFuZCBzY2hlbWUpLg0KDQpIaSBTZWFuLA0KDQpKdXN0IHRob3VnaHQgb2YgY2hlY2tpbmcg
d2l0aCB5b3Ugb24gdGhpcyBzZXJpZXMuIERvIHlvdSBoYXZlIHBsYW5zIHRvIHJldml2ZSB0aGlz
DQpzZXJpZXM/IFRoZSByZWFzb24gSSBhbSBhc2tpbmcgaXMsIG9uIEFSTTY0L0tWTSBzaWRlIHdl
IGRvIGhhdmUgYSByZXF1aXJlbWVudA0KdG8gc2hhcmUgdGhlIEtWTSBWTUlEIHdpdGggU01NVVYz
LiBQbGVhc2Ugc2VlIHRoZSBSRkMgSSBzZW50IG91dCBlYXJsaWVyIHRoaXMNCnllYXJbMV0uIFRo
ZSBzZXJpZXMgYmFzaWNhbGx5IHByb3ZpZGVzIGEgd2F5IGZvciBLVk0gdG8gcGluIGEgVk1JRCBh
bmQgYWxzbw0KYXNzb2NpYXRlcyBhbiBpb21tdWZkIGN0eCB3aXRoIGEgc3RydWN0IGt2bSAqIHRv
IHJldHJpZXZlIHRoYXQgVk1JRC4gDQoNCkFzIG1lbnRpb25lZCBhYm92ZSwgc29tZSBvZiB0aGUg
cGF0Y2hlcyBpbiB0aGlzIHNlcmllcyhlc3BlY2lhbGx5IDEtNCAmIDYpIHRoYXQNCmRvZXMgdGhl
IFZGSU8gY2xlYW51cHMgYW5kIGRyb3BwaW5nIENPTkZJR19LVk1fVkZJTyBsb29rcyB2ZXJ5IHN0
cmFpZ2h0Zm9yd2FyZA0KYW5kIHVzZWZ1bC4gSSBhbSB0aGlua2luZyBvZiBpbmNsdWRpbmcgdGhv
c2Ugd2hlbiBJIHJlLXNwaW4gbXkgUkZDIHNlcmllcywgaWYgdGhhdOKAmXMgb2suDQoNClBsZWFz
ZSBsZXQgbWUga25vdyB5b3VyIHRob3VnaHRzLg0KDQpUaGFua3MsDQpTaGFtZWVyDQoNClsxXS4g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtaW9tbXUvMjAyNDAyMDkxMTU4MjQuR0EyOTIy
NDQ2QG15cmljYS8NCg0K

