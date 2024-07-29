Return-Path: <kvm+bounces-22519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A75F93FC58
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 19:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 662491C2194E
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 17:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56FDD186E5C;
	Mon, 29 Jul 2024 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="CfrSkF6H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7B615ECD0;
	Mon, 29 Jul 2024 17:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722273653; cv=none; b=OfEsyhCnmLXMVs4U7gxpRi2tQRYCSCZpV/HiEZS14hDFp4gyO+PTFCrV8rh2TrEji0cIoIYAd/gZd06zi820wcFxL3VeHTpDyJHvHi9u0oF9YlSfPmPeJBfDJObAs9TdLOuqBUwr43t8cg/ETWCTS7C8zDslA4BXD/wHl55COzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722273653; c=relaxed/simple;
	bh=Sv4G657aeIIdPBA0+w3PRvoZkj774KyzLd398JdiGlo=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hco2e2PGzrNLByOpVO5fH8nzyN7DlktyO9S6GNY7+DxZ4ruTqC4iE+xz1pPVuV5+plrgVrzx03wtv0t8MPvFLLSDMyvYcFV/7rpDDi4KSfXJF7ocxXQ3cDozwkbPRRHQEm7Euj2AjyrrYv0/rsxaxR76XhC5qX2Ic7wpKw4oAqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=CfrSkF6H; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1722273649; x=1753809649;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=Sv4G657aeIIdPBA0+w3PRvoZkj774KyzLd398JdiGlo=;
  b=CfrSkF6HKRln20tJTwEUTC8SmpLb6UVsOcw7T3zjdYeGQXxzyDSQ5yzj
   +CFIHaPCw1UZ4rv0Y5Dr/zQemKbrnk/fniz9Te+a1lhj0wPHrYWT17rWq
   S1mqI+u+MvWfhhkzJwoULDw8N9nIz1/Ghi2/gq+xbwc8f9NmI8SxozuCC
   I=;
X-IronPort-AV: E=Sophos;i="6.09,246,1716249600"; 
   d="scan'208";a="670731969"
Subject: Re: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
Thread-Topic: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2024 17:20:45 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:44279]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.49.198:2525] with esmtp (Farcaster)
 id e0981944-4dff-42ca-8f3a-c47f62744bc1; Mon, 29 Jul 2024 17:20:44 +0000 (UTC)
X-Farcaster-Flow-ID: e0981944-4dff-42ca-8f3a-c47f62744bc1
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 29 Jul 2024 17:20:44 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 29 Jul 2024 17:20:44 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.034; Mon, 29 Jul 2024 17:20:44 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "wanpengli@tencent.com"
	<wanpengli@tencent.com>, "cl@gentwo.org" <cl@gentwo.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "misono.tomohiro@fujitsu.com"
	<misono.tomohiro@fujitsu.com>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "Okanovic, Haris" <harisokn@amazon.com>,
	"rafael@kernel.org" <rafael@kernel.org>, "sudeep.holla@arm.com"
	<sudeep.holla@arm.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>
Thread-Index: AQHa35mLdhQH4qvBikqC1hweZwAegbIN988A
Date: Mon, 29 Jul 2024 17:20:44 +0000
Message-ID: <5ba1e9b9bba7cafcd3cc831ff5f2407d81409632.camel@amazon.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
	 <20240726202134.627514-1-ankur.a.arora@oracle.com>
	 <20240726202134.627514-7-ankur.a.arora@oracle.com>
In-Reply-To: <20240726202134.627514-7-ankur.a.arora@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <338444219319FC438F56EE1DDAE69CFB@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI0LTA3LTI2IGF0IDEzOjIxIC0wNzAwLCBBbmt1ciBBcm9yYSB3cm90ZToNCj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiANCj4gQWRkIGFyY2hpdGVjdHVyYWwgc3VwcG9ydCBmb3IgY3B1aWRsZS1oYWx0cG9s
bCBkcml2ZXIgYnkgZGVmaW5pbmcNCj4gYXJjaF9oYWx0cG9sbF8qKCkuDQo+IA0KPiBBbHNvIGRl
ZmluZSBBUkNIX0NQVUlETEVfSEFMVFBPTEwgdG8gYWxsb3cgY3B1aWRsZS1oYWx0cG9sbCB0byBi
ZQ0KPiBzZWxlY3RlZCwgYW5kIGdpdmVuIHRoYXQgd2UgaGF2ZSBhbiBvcHRpbWl6ZWQgcG9sbGlu
ZyBtZWNoYW5pc20NCj4gaW4gc21wX2NvbmRfbG9hZCooKSwgc2VsZWN0IEFSQ0hfSEFTX09QVElN
SVpFRF9QT0xMLg0KPiANCj4gc21wX2NvbmRfbG9hZCooKSBhcmUgaW1wbGVtZW50ZWQgdmlhIExE
WFIsIFdGRSwgd2l0aCBMRFhSIGxvYWRpbmcNCj4gYSBtZW1vcnkgcmVnaW9uIGluIGV4Y2x1c2l2
ZSBzdGF0ZSBhbmQgdGhlIFdGRSB3YWl0aW5nIGZvciBhbnkNCj4gc3RvcmVzIHRvIGl0Lg0KPiAN
Cj4gSW4gdGhlIGVkZ2UgY2FzZSAtLSBubyBDUFUgc3RvcmVzIHRvIHRoZSB3YWl0ZWQgcmVnaW9u
IGFuZCB0aGVyZSdzIG5vDQo+IGludGVycnVwdCAtLSB0aGUgZXZlbnQtc3RyZWFtIHdpbGwgcHJv
dmlkZSB0aGUgdGVybWluYXRpbmcgY29uZGl0aW9uDQo+IGVuc3VyaW5nIHdlIGRvbid0IHdhaXQg
Zm9yZXZlciwgYnV0IGJlY2F1c2UgdGhlIGV2ZW50LXN0cmVhbSBydW5zIGF0DQo+IGEgZml4ZWQg
ZnJlcXVlbmN5IChjb25maWd1cmVkIGF0IDEwa0h6KSB3ZSBtaWdodCBzcGVuZCBtb3JlIHRpbWUg
aW4NCj4gdGhlIHBvbGxpbmcgc3RhZ2UgdGhhbiBzcGVjaWZpZWQgYnkgY3B1aWRsZV9wb2xsX3Rp
bWUoKS4NCj4gDQo+IFRoaXMgd291bGQgb25seSBoYXBwZW4gaW4gdGhlIGxhc3QgaXRlcmF0aW9u
LCBzaW5jZSBvdmVyc2hvb3RpbmcgdGhlDQo+IHBvbGxfbGltaXQgbWVhbnMgdGhlIGdvdmVybm9y
IG1vdmVzIG91dCBvZiB0aGUgcG9sbGluZyBzdGFnZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFu
a3VyIEFyb3JhIDxhbmt1ci5hLmFyb3JhQG9yYWNsZS5jb20+DQo+IC0tLQ0KPiAgYXJjaC9hcm02
NC9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgfCAxMCArKysrKysrKysrDQo+ICBhcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2NwdWlkbGVfaGFsdHBvbGwuaCB8ICA5ICsrKysrKysrKw0KPiAg
YXJjaC9hcm02NC9rZXJuZWwvY3B1aWRsZS5jICAgICAgICAgICAgICAgfCAyMyArKysrKysrKysr
KysrKysrKysrKysrKw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA0MiBpbnNlcnRpb25zKCspDQo+ICBj
cmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9jcHVpZGxlX2hhbHRwb2xs
LmgNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L0tjb25maWcgYi9hcmNoL2FybTY0L0tj
b25maWcNCj4gaW5kZXggNWQ5MTI1OWVlN2I1Li5jZjFjNjY4MWViMGEgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gvYXJtNjQvS2NvbmZpZw0KPiArKysgYi9hcmNoL2FybTY0L0tjb25maWcNCj4gQEAgLTM1
LDYgKzM1LDcgQEAgY29uZmlnIEFSTTY0DQo+ICAgICAgICAgc2VsZWN0IEFSQ0hfSEFTX01FTUJB
UlJJRVJfU1lOQ19DT1JFDQo+ICAgICAgICAgc2VsZWN0IEFSQ0hfSEFTX05NSV9TQUZFX1RISVNf
Q1BVX09QUw0KPiAgICAgICAgIHNlbGVjdCBBUkNIX0hBU19OT05fT1ZFUkxBUFBJTkdfQUREUkVT
U19TUEFDRQ0KPiArICAgICAgIHNlbGVjdCBBUkNIX0hBU19PUFRJTUlaRURfUE9MTA0KPiAgICAg
ICAgIHNlbGVjdCBBUkNIX0hBU19QVEVfREVWTUFQDQo+ICAgICAgICAgc2VsZWN0IEFSQ0hfSEFT
X1BURV9TUEVDSUFMDQo+ICAgICAgICAgc2VsZWN0IEFSQ0hfSEFTX0hXX1BURV9ZT1VORw0KPiBA
QCAtMjM3Niw2ICsyMzc3LDE1IEBAIGNvbmZpZyBBUkNIX0hJQkVSTkFUSU9OX0hFQURFUg0KPiAg
Y29uZmlnIEFSQ0hfU1VTUEVORF9QT1NTSUJMRQ0KPiAgICAgICAgIGRlZl9ib29sIHkNCj4gDQo+
ICtjb25maWcgQVJDSF9DUFVJRExFX0hBTFRQT0xMDQo+ICsgICAgICAgYm9vbCAiRW5hYmxlIHNl
bGVjdGlvbiBvZiB0aGUgY3B1aWRsZS1oYWx0cG9sbCBkcml2ZXIiDQo+ICsgICAgICAgZGVmYXVs
dCBuDQo+ICsgICAgICAgaGVscA0KPiArICAgICAgICAgY3B1aWRsZS1oYWx0cG9sbCBhbGxvd3Mg
Zm9yIGFkYXB0aXZlIHBvbGxpbmcgYmFzZWQgb24NCj4gKyAgICAgICAgIGN1cnJlbnQgbG9hZCBi
ZWZvcmUgZW50ZXJpbmcgdGhlIGlkbGUgc3RhdGUuDQo+ICsNCj4gKyAgICAgICAgIFNvbWUgdmly
dHVhbGl6ZWQgd29ya2xvYWRzIGJlbmVmaXQgZnJvbSB1c2luZyBpdC4NCj4gKw0KPiAgZW5kbWVu
dSAjICJQb3dlciBtYW5hZ2VtZW50IG9wdGlvbnMiDQo+IA0KPiAgbWVudSAiQ1BVIFBvd2VyIE1h
bmFnZW1lbnQiDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2NwdWlkbGVf
aGFsdHBvbGwuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1aWRsZV9oYWx0cG9sbC5oDQo+
IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMC4uNjVmMjg5NDA3YTZj
DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9jcHVpZGxl
X2hhbHRwb2xsLmgNCj4gQEAgLTAsMCArMSw5IEBADQo+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRp
ZmllcjogR1BMLTIuMCAqLw0KPiArI2lmbmRlZiBfQVJDSF9IQUxUUE9MTF9IDQo+ICsjZGVmaW5l
IF9BUkNIX0hBTFRQT0xMX0gNCj4gKw0KPiArc3RhdGljIGlubGluZSB2b2lkIGFyY2hfaGFsdHBv
bGxfZW5hYmxlKHVuc2lnbmVkIGludCBjcHUpIHsgfQ0KPiArc3RhdGljIGlubGluZSB2b2lkIGFy
Y2hfaGFsdHBvbGxfZGlzYWJsZSh1bnNpZ25lZCBpbnQgY3B1KSB7IH0NCj4gKw0KPiArYm9vbCBh
cmNoX2hhbHRwb2xsX3dhbnQoYm9vbCBmb3JjZSk7DQo+ICsjZW5kaWYNCj4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQva2VybmVsL2NwdWlkbGUuYyBiL2FyY2gvYXJtNjQva2VybmVsL2NwdWlkbGUu
Yw0KPiBpbmRleCBmMzcyMjk1MjA3ZmIuLjMzNGRmODJhMGVhYyAxMDA2NDQNCj4gLS0tIGEvYXJj
aC9hcm02NC9rZXJuZWwvY3B1aWRsZS5jDQo+ICsrKyBiL2FyY2gvYXJtNjQva2VybmVsL2NwdWlk
bGUuYw0KPiBAQCAtNzIsMyArNzIsMjYgQEAgX19jcHVpZGxlIGludCBhY3BpX3Byb2Nlc3Nvcl9m
ZmhfbHBpX2VudGVyKHN0cnVjdCBhY3BpX2xwaV9zdGF0ZSAqbHBpKQ0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBscGktPmluZGV4LCBzdGF0ZSk7DQo+ICB9
DQo+ICAjZW5kaWYNCj4gKw0KPiArI2lmIElTX0VOQUJMRUQoQ09ORklHX0hBTFRQT0xMX0NQVUlE
TEUpDQo+ICsNCj4gKyNpbmNsdWRlIDxhc20vY3B1aWRsZV9oYWx0cG9sbC5oPg0KPiArDQo+ICti
b29sIGFyY2hfaGFsdHBvbGxfd2FudChib29sIGZvcmNlKQ0KPiArew0KPiArICAgICAgIC8qDQo+
ICsgICAgICAgICogRW5hYmxpbmcgaGFsdHBvbGwgcmVxdWlyZXMgdHdvIHRoaW5nczoNCj4gKyAg
ICAgICAgKg0KPiArICAgICAgICAqIC0gRXZlbnQgc3RyZWFtIHN1cHBvcnQgdG8gcHJvdmlkZSBh
IHRlcm1pbmF0aW5nIGNvbmRpdGlvbiB0byB0aGUNCj4gKyAgICAgICAgKiAgIFdGRSBpbiB0aGUg
cG9sbCBsb29wLg0KPiArICAgICAgICAqDQo+ICsgICAgICAgICogLSBLVk0gc3VwcG9ydCBmb3Ig
YXJjaF9oYWx0cG9sbF9lbmFibGUoKSwgYXJjaF9oYWx0cG9sbF9lbmFibGUoKS4NCg0KdHlwbzog
ImFyY2hfaGFsdHBvbGxfZW5hYmxlIiBhbmQgImFyY2hfaGFsdHBvbGxfZW5hYmxlIg0KDQo+ICsg
ICAgICAgICoNCj4gKyAgICAgICAgKiBHaXZlbiB0aGF0IHRoZSBzZWNvbmQgaXMgbWlzc2luZywg
YWxsb3cgaGFsdHBvbGwgdG8gb25seSBiZSBmb3JjZQ0KPiArICAgICAgICAqIGxvYWRlZC4NCj4g
KyAgICAgICAgKi8NCj4gKyAgICAgICByZXR1cm4gKGFyY2hfdGltZXJfZXZ0c3RybV9hdmFpbGFi
bGUoKSAmJiBmYWxzZSkgfHwgZm9yY2U7DQoNClRoaXMgc2hvdWxkIGFsd2F5cyBldmFsdWF0ZSBm
YWxzZSB3aXRob3V0IGZvcmNlLiBQZXJoYXBzIHlvdSBtZWFudA0Kc29tZXRoaW5nIGxpa2UgdGhp
cz8NCg0KYGBgDQotICAgICAgIHJldHVybiAoYXJjaF90aW1lcl9ldnRzdHJtX2F2YWlsYWJsZSgp
ICYmIGZhbHNlKSB8fCBmb3JjZTsNCisgICAgICAgcmV0dXJuIGFyY2hfdGltZXJfZXZ0c3RybV9h
dmFpbGFibGUoKSB8fCBmb3JjZTsNCmBgYA0KDQpSZWdhcmRzLA0KSGFyaXMgT2thbm92aWMNCg0K
PiArfQ0KPiArDQo+ICtFWFBPUlRfU1lNQk9MX0dQTChhcmNoX2hhbHRwb2xsX3dhbnQpOw0KPiAr
I2VuZGlmDQo+IC0tDQo+IDIuNDMuNQ0KPiANCg0K

