Return-Path: <kvm+bounces-54820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E432EB28939
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 02:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40B21AA5403
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 00:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DA41BC3F;
	Sat, 16 Aug 2025 00:24:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4237261C;
	Sat, 16 Aug 2025 00:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755303855; cv=none; b=IyHu08DlCManFlPIK7lJD6n4e9QwzS5cKDW081JviZhzSYxmdF2pd/QqteoUXOiYxLwfpU4gXQ2A2IDtXt+SwvKtYzqtXLEozVT1Npu7UN31EoBoDLTKXVLCHwTnTmuJgSITzEqcu35o2Dn/F3KDwsKqY+dydfOHWTDtMDDC7wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755303855; c=relaxed/simple;
	bh=h6qhI4JvAbbz5b6iy/hFjeFUi+3euXdKMWZO9EP+OH0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=EZKN2KHpzt4SH2EIE73BSsFtQPEcA042gWUnJHlb74ttd3UE6a9YqD+CIXziiiA9cklZ2rEvd/4m9U74vh7h6hjVXHSgEj0hqudJDrOM3OWFtv+4g0rflopOWNIo7m4S1O0TsolOshpKK8qZ61k4IxC85CAhovrzEUv0tC87Njk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Keir Fraser <keirf@google.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Eric Auger
	<eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier
	<maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>
Subject: RE: [PATCH v2 4/4] KVM: Avoid synchronize_srcu() in
 kvm_io_bus_register_dev()
Thread-Topic: [PATCH v2 4/4] KVM: Avoid synchronize_srcu() in
 kvm_io_bus_register_dev()
Thread-Index: AdwOQ+K17Q5s1iAHSD65a3R3+0RRAg==
Date: Sat, 16 Aug 2025 00:23:30 +0000
Message-ID: <b778c98abb4b425186bfeb1f9bed0c7a@baidu.com>
Accept-Language: zh-CN, en-US
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
X-FEAS-Client-IP: 172.31.50.46
X-FE-Policy-ID: 52:10:53:SYSTEM

DQoNCj4gDQo+IERldmljZSBNTUlPIHJlZ2lzdHJhdGlvbiBtYXkgaGFwcGVuIHF1aXRlIGZyZXF1
ZW50bHkgZHVyaW5nIFZNIGJvb3QsIGFuZA0KPiB0aGUgU1JDVSBzeW5jaHJvbml6YXRpb24gZWFj
aCB0aW1lIGhhcyBhIG1lYXN1cmFibGUgZWZmZWN0IG9uIFZNIHN0YXJ0dXANCj4gdGltZS4gSW4g
b3VyIGV4cGVyaW1lbnRzIGl0IGNhbiBhY2NvdW50IGZvciBhcm91bmQgMjUlIG9mIGEgVk0ncyBz
dGFydHVwIHRpbWUuDQo+IA0KPiBSZXBsYWNlIHRoZSBzeW5jaHJvbml6YXRpb24gd2l0aCBhIGRl
ZmVycmVkIGZyZWUgb2YgdGhlIG9sZCBrdm1faW9fYnVzDQo+IHN0cnVjdHVyZS4NCj4gDQoNClRl
c3RlZC1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KDQpUaGFua3MNCg0K
LUxpDQoNCj4gU2lnbmVkLW9mZi1ieTogS2VpciBGcmFzZXIgPGtlaXJmQGdvb2dsZS5jb20+DQo+
IC0tLQ0KPiAgaW5jbHVkZS9saW51eC9rdm1faG9zdC5oIHwgIDEgKw0KPiAgdmlydC9rdm0va3Zt
X21haW4uYyAgICAgIHwgMTAgKysrKysrKystLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51
eC9rdm1faG9zdC5oIGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oIGluZGV4DQo+IDkxMzIxNDhm
YjQ2Ny4uODAyY2E0NmY3NTM3IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0
LmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oDQo+IEBAIC0yMDUsNiArMjA1LDcg
QEAgc3RydWN0IGt2bV9pb19yYW5nZSB7ICBzdHJ1Y3Qga3ZtX2lvX2J1cyB7DQo+ICAJaW50IGRl
dl9jb3VudDsNCj4gIAlpbnQgaW9ldmVudGZkX2NvdW50Ow0KPiArCXN0cnVjdCByY3VfaGVhZCBy
Y3U7DQo+ICAJc3RydWN0IGt2bV9pb19yYW5nZSByYW5nZVtdOw0KPiAgfTsNCj4gDQo+IGRpZmYg
LS1naXQgYS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4uYyBpbmRleA0K
PiA5ZWMzYjk2Yjk2NjYuLmY2OTBhNDk5N2EwZiAxMDA2NDQNCj4gLS0tIGEvdmlydC9rdm0va3Zt
X21haW4uYw0KPiArKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5jDQo+IEBAIC01OTQ4LDYgKzU5NDgs
MTMgQEAgaW50IGt2bV9pb19idXNfcmVhZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+IGVudW0g
a3ZtX2J1cyBidXNfaWR4LCBncGFfdCBhZGRyLCAgfQ0KPiBFWFBPUlRfU1lNQk9MX0dQTChrdm1f
aW9fYnVzX3JlYWQpOw0KPiANCj4gK3N0YXRpYyB2b2lkIF9fZnJlZV9idXMoc3RydWN0IHJjdV9o
ZWFkICpyY3UpIHsNCj4gKwlzdHJ1Y3Qga3ZtX2lvX2J1cyAqYnVzID0gY29udGFpbmVyX29mKHJj
dSwgc3RydWN0IGt2bV9pb19idXMsIHJjdSk7DQo+ICsNCj4gKwlrZnJlZShidXMpOw0KPiArfQ0K
PiArDQo+ICBpbnQga3ZtX2lvX2J1c19yZWdpc3Rlcl9kZXYoc3RydWN0IGt2bSAqa3ZtLCBlbnVt
IGt2bV9idXMgYnVzX2lkeCwgZ3BhX3QNCj4gYWRkciwNCj4gIAkJCSAgICBpbnQgbGVuLCBzdHJ1
Y3Qga3ZtX2lvX2RldmljZSAqZGV2KSAgeyBAQCAtNTk4Niw4DQo+ICs1OTkzLDcgQEAgaW50IGt2
bV9pb19idXNfcmVnaXN0ZXJfZGV2KHN0cnVjdCBrdm0gKmt2bSwgZW51bSBrdm1fYnVzDQo+IGJ1
c19pZHgsIGdwYV90IGFkZHIsDQo+ICAJbWVtY3B5KG5ld19idXMtPnJhbmdlICsgaSArIDEsIGJ1
cy0+cmFuZ2UgKyBpLA0KPiAgCQkoYnVzLT5kZXZfY291bnQgLSBpKSAqIHNpemVvZihzdHJ1Y3Qg
a3ZtX2lvX3JhbmdlKSk7DQo+ICAJcmN1X2Fzc2lnbl9wb2ludGVyKGt2bS0+YnVzZXNbYnVzX2lk
eF0sIG5ld19idXMpOw0KPiAtCXN5bmNocm9uaXplX3NyY3VfZXhwZWRpdGVkKCZrdm0tPnNyY3Up
Ow0KPiAtCWtmcmVlKGJ1cyk7DQo+ICsJY2FsbF9zcmN1KCZrdm0tPnNyY3UsICZidXMtPnJjdSwg
X19mcmVlX2J1cyk7DQo+IA0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAtLQ0KPiAyLjUwLjAuNzI3
LmdiZjdkYzE4ZmY0LWdvb2cNCj4gDQoNCg==

