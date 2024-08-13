Return-Path: <kvm+bounces-24064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F708950F0A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 23:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F72F284606
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 21:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D1A1AAE2B;
	Tue, 13 Aug 2024 21:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="YlFOBd/H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1881D1E86A;
	Tue, 13 Aug 2024 21:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723583696; cv=none; b=EGj2nu0IlhTcMANp8CIRUDJuCNPUoxDZDdW7iKg6s+st8AJidARxKDtWGLMkESQ7i47/Z84B1Gx96vZAkevfpIRh8Jq02cuX6gXETa8V5I+pRG1MUz1NIIu2FdApzWAVJqsCSpIM9cKBGh0pcnAd9fR+SXD4NE2sSBsHksaud/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723583696; c=relaxed/simple;
	bh=Ha7f+J7eWU7x//4IWkswxdzuEY5A5K74+qXLSEHyUJ0=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L8unaCdYdPKu6u+Ut8EWIU1LdlDLv/RvjvDwxw5z8XXs42pIqDee08ihNgWIZ8CqdCOZrwH7zMi9ref+MVkW+7ED30gO0zAnPKxBeOKvtBPoNu6jcWp43sI3POaz+KGQ5kHIjVWejI0+310BfENkpgdrAclE6arN7ZWzuencfrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=YlFOBd/H; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1723583694; x=1755119694;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=Ha7f+J7eWU7x//4IWkswxdzuEY5A5K74+qXLSEHyUJ0=;
  b=YlFOBd/H5lnWSrdPtlCzCDybi4BWRwYkE0UN85y/SqJqIlxdcVLtgDfg
   dYnaJjQeWQli1QB4CJD7HC3JNDxwFN5es11sUUCzm/p0K+lyZKPxg/GhW
   Cal7V2fsucJQAjMjoZXEYjbKNW3c18eWwNNLmLqLgjBcAqimVt/N358Ij
   c=;
X-IronPort-AV: E=Sophos;i="6.09,287,1716249600"; 
   d="scan'208";a="421059269"
Subject: Re: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
Thread-Topic: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 21:14:50 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.38.20:46971]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.18.29:2525] with esmtp (Farcaster)
 id e7f4b9b4-6c59-48a6-9058-f6c4dbcaf524; Tue, 13 Aug 2024 21:14:49 +0000 (UTC)
X-Farcaster-Flow-ID: e7f4b9b4-6c59-48a6-9058-f6c4dbcaf524
Received: from EX19D001UWA002.ant.amazon.com (10.13.138.236) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 13 Aug 2024 21:14:49 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA002.ant.amazon.com (10.13.138.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 13 Aug 2024 21:14:49 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.034; Tue, 13 Aug 2024 21:14:49 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "konrad.wilk@oracle.com"
	<konrad.wilk@oracle.com>, "cl@gentwo.org" <cl@gentwo.org>,
	"wanpengli@tencent.com" <wanpengli@tencent.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Okanovic, Haris"
	<harisokn@amazon.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mtosatti@redhat.com" <mtosatti@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>, "sudeep.holla@arm.com"
	<sudeep.holla@arm.com>
Thread-Index: AQHa35mLdhQH4qvBikqC1hweZwAegbIN988AgAAMBQCAF2c4AIAAOtIAgAAmlgA=
Date: Tue, 13 Aug 2024 21:14:49 +0000
Message-ID: <e86d3462d8a4923e1c64841aafc16936060a9907.camel@amazon.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
	 <20240726202134.627514-1-ankur.a.arora@oracle.com>
	 <20240726202134.627514-7-ankur.a.arora@oracle.com>
	 <5ba1e9b9bba7cafcd3cc831ff5f2407d81409632.camel@amazon.com>
	 <87ikwors8p.fsf@oracle.com>
	 <104d0ec31cb45477e27273e089402d4205ee4042.camel@amazon.com>
	 <87frr8qmj9.fsf@oracle.com>
In-Reply-To: <87frr8qmj9.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <CBF126D99BDDC34CBEF9A85A0B349D2C@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVHVlLCAyMDI0LTA4LTEzIGF0IDExOjU2IC0wNzAwLCBBbmt1ciBBcm9yYSB3cm90ZToNCj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiANCj4gT2thbm92aWMsIEhhcmlzIDxoYXJpc29rbkBhbWF6b24uY29tPiB3cml0ZXM6
DQo+IA0KPiA+IE9uIE1vbiwgMjAyNC0wNy0yOSBhdCAxMTowMiAtMDcwMCwgQW5rdXIgQXJvcmEg
d3JvdGU6DQo+ID4gPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRl
IG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1l
bnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVu
dCBpcyBzYWZlLg0KPiA+ID4gDQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gT2thbm92aWMsIEhhcmlz
IDxoYXJpc29rbkBhbWF6b24uY29tPiB3cml0ZXM6DQo+ID4gPiANCj4gPiA+ID4gT24gRnJpLCAy
MDI0LTA3LTI2IGF0IDEzOjIxIC0wNzAwLCBBbmt1ciBBcm9yYSB3cm90ZToNCj4gPiA+ID4gPiBD
QVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6
YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Ug
Y2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KPiA+
ID4gPiA+IA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEFkZCBhcmNoaXRlY3R1
cmFsIHN1cHBvcnQgZm9yIGNwdWlkbGUtaGFsdHBvbGwgZHJpdmVyIGJ5IGRlZmluaW5nDQo+ID4g
PiA+ID4gYXJjaF9oYWx0cG9sbF8qKCkuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gQWxzbyBkZWZp
bmUgQVJDSF9DUFVJRExFX0hBTFRQT0xMIHRvIGFsbG93IGNwdWlkbGUtaGFsdHBvbGwgdG8gYmUN
Cj4gPiA+ID4gPiBzZWxlY3RlZCwgYW5kIGdpdmVuIHRoYXQgd2UgaGF2ZSBhbiBvcHRpbWl6ZWQg
cG9sbGluZyBtZWNoYW5pc20NCj4gPiA+ID4gPiBpbiBzbXBfY29uZF9sb2FkKigpLCBzZWxlY3Qg
QVJDSF9IQVNfT1BUSU1JWkVEX1BPTEwuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gc21wX2NvbmRf
bG9hZCooKSBhcmUgaW1wbGVtZW50ZWQgdmlhIExEWFIsIFdGRSwgd2l0aCBMRFhSIGxvYWRpbmcN
Cj4gPiA+ID4gPiBhIG1lbW9yeSByZWdpb24gaW4gZXhjbHVzaXZlIHN0YXRlIGFuZCB0aGUgV0ZF
IHdhaXRpbmcgZm9yIGFueQ0KPiA+ID4gPiA+IHN0b3JlcyB0byBpdC4NCj4gPiA+ID4gPiANCj4g
PiA+ID4gPiBJbiB0aGUgZWRnZSBjYXNlIC0tIG5vIENQVSBzdG9yZXMgdG8gdGhlIHdhaXRlZCBy
ZWdpb24gYW5kIHRoZXJlJ3Mgbm8NCj4gPiA+ID4gPiBpbnRlcnJ1cHQgLS0gdGhlIGV2ZW50LXN0
cmVhbSB3aWxsIHByb3ZpZGUgdGhlIHRlcm1pbmF0aW5nIGNvbmRpdGlvbg0KPiA+ID4gPiA+IGVu
c3VyaW5nIHdlIGRvbid0IHdhaXQgZm9yZXZlciwgYnV0IGJlY2F1c2UgdGhlIGV2ZW50LXN0cmVh
bSBydW5zIGF0DQo+ID4gPiA+ID4gYSBmaXhlZCBmcmVxdWVuY3kgKGNvbmZpZ3VyZWQgYXQgMTBr
SHopIHdlIG1pZ2h0IHNwZW5kIG1vcmUgdGltZSBpbg0KPiA+ID4gPiA+IHRoZSBwb2xsaW5nIHN0
YWdlIHRoYW4gc3BlY2lmaWVkIGJ5IGNwdWlkbGVfcG9sbF90aW1lKCkuDQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gVGhpcyB3b3VsZCBvbmx5IGhhcHBlbiBpbiB0aGUgbGFzdCBpdGVyYXRpb24sIHNp
bmNlIG92ZXJzaG9vdGluZyB0aGUNCj4gPiA+ID4gPiBwb2xsX2xpbWl0IG1lYW5zIHRoZSBnb3Zl
cm5vciBtb3ZlcyBvdXQgb2YgdGhlIHBvbGxpbmcgc3RhZ2UuDQo+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gU2lnbmVkLW9mZi1ieTogQW5rdXIgQXJvcmEgPGFua3VyLmEuYXJvcmFAb3JhY2xlLmNvbT4N
Cj4gPiA+ID4gPiAtLS0NCj4gPiA+ID4gPiAgYXJjaC9hcm02NC9LY29uZmlnICAgICAgICAgICAg
ICAgICAgICAgICAgfCAxMCArKysrKysrKysrDQo+ID4gPiA+ID4gIGFyY2gvYXJtNjQvaW5jbHVk
ZS9hc20vY3B1aWRsZV9oYWx0cG9sbC5oIHwgIDkgKysrKysrKysrDQo+ID4gPiA+ID4gIGFyY2gv
YXJtNjQva2VybmVsL2NwdWlkbGUuYyAgICAgICAgICAgICAgIHwgMjMgKysrKysrKysrKysrKysr
KysrKysrKysNCj4gPiA+ID4gPiAgMyBmaWxlcyBjaGFuZ2VkLCA0MiBpbnNlcnRpb25zKCspDQo+
ID4gPiA+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2NwdWlk
bGVfaGFsdHBvbGwuaA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L0tjb25maWcgYi9hcmNoL2FybTY0L0tjb25maWcNCj4gPiA+ID4gPiBpbmRleCA1ZDkxMjU5
ZWU3YjUuLmNmMWM2NjgxZWIwYSAxMDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9hcmNoL2FybTY0L0tj
b25maWcNCj4gPiA+ID4gPiArKysgYi9hcmNoL2FybTY0L0tjb25maWcNCj4gPiA+ID4gPiBAQCAt
MzUsNiArMzUsNyBAQCBjb25maWcgQVJNNjQNCj4gPiA+ID4gPiAgICAgICAgIHNlbGVjdCBBUkNI
X0hBU19NRU1CQVJSSUVSX1NZTkNfQ09SRQ0KPiA+ID4gPiA+ICAgICAgICAgc2VsZWN0IEFSQ0hf
SEFTX05NSV9TQUZFX1RISVNfQ1BVX09QUw0KPiA+ID4gPiA+ICAgICAgICAgc2VsZWN0IEFSQ0hf
SEFTX05PTl9PVkVSTEFQUElOR19BRERSRVNTX1NQQUNFDQo+ID4gPiA+ID4gKyAgICAgICBzZWxl
Y3QgQVJDSF9IQVNfT1BUSU1JWkVEX1BPTEwNCj4gPiA+ID4gPiAgICAgICAgIHNlbGVjdCBBUkNI
X0hBU19QVEVfREVWTUFQDQo+ID4gPiA+ID4gICAgICAgICBzZWxlY3QgQVJDSF9IQVNfUFRFX1NQ
RUNJQUwNCj4gPiA+ID4gPiAgICAgICAgIHNlbGVjdCBBUkNIX0hBU19IV19QVEVfWU9VTkcNCj4g
PiA+ID4gPiBAQCAtMjM3Niw2ICsyMzc3LDE1IEBAIGNvbmZpZyBBUkNIX0hJQkVSTkFUSU9OX0hF
QURFUg0KPiA+ID4gPiA+ICBjb25maWcgQVJDSF9TVVNQRU5EX1BPU1NJQkxFDQo+ID4gPiA+ID4g
ICAgICAgICBkZWZfYm9vbCB5DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gK2NvbmZpZyBBUkNIX0NQ
VUlETEVfSEFMVFBPTEwNCj4gPiA+ID4gPiArICAgICAgIGJvb2wgIkVuYWJsZSBzZWxlY3Rpb24g
b2YgdGhlIGNwdWlkbGUtaGFsdHBvbGwgZHJpdmVyIg0KPiA+ID4gPiA+ICsgICAgICAgZGVmYXVs
dCBuDQo+ID4gPiA+ID4gKyAgICAgICBoZWxwDQo+ID4gPiA+ID4gKyAgICAgICAgIGNwdWlkbGUt
aGFsdHBvbGwgYWxsb3dzIGZvciBhZGFwdGl2ZSBwb2xsaW5nIGJhc2VkIG9uDQo+ID4gPiA+ID4g
KyAgICAgICAgIGN1cnJlbnQgbG9hZCBiZWZvcmUgZW50ZXJpbmcgdGhlIGlkbGUgc3RhdGUuDQo+
ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICsgICAgICAgICBTb21lIHZpcnR1YWxpemVkIHdvcmtsb2Fk
cyBiZW5lZml0IGZyb20gdXNpbmcgaXQuDQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICBlbmRtZW51
ICMgIlBvd2VyIG1hbmFnZW1lbnQgb3B0aW9ucyINCj4gPiA+ID4gPiANCj4gPiA+ID4gPiAgbWVu
dSAiQ1BVIFBvd2VyIE1hbmFnZW1lbnQiDQo+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQvaW5jbHVkZS9hc20vY3B1aWRsZV9oYWx0cG9sbC5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS9jcHVpZGxlX2hhbHRwb2xsLmgNCj4gPiA+ID4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+
ID4gPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uNjVmMjg5NDA3YTZjDQo+ID4gPiA+ID4gLS0tIC9k
ZXYvbnVsbA0KPiA+ID4gPiA+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1aWRsZV9o
YWx0cG9sbC5oDQo+ID4gPiA+ID4gQEAgLTAsMCArMSw5IEBADQo+ID4gPiA+ID4gKy8qIFNQRFgt
TGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wICovDQo+ID4gPiA+ID4gKyNpZm5kZWYgX0FSQ0hf
SEFMVFBPTExfSA0KPiA+ID4gPiA+ICsjZGVmaW5lIF9BUkNIX0hBTFRQT0xMX0gNCj4gPiA+ID4g
PiArDQo+ID4gPiA+ID4gK3N0YXRpYyBpbmxpbmUgdm9pZCBhcmNoX2hhbHRwb2xsX2VuYWJsZSh1
bnNpZ25lZCBpbnQgY3B1KSB7IH0NCj4gPiA+ID4gPiArc3RhdGljIGlubGluZSB2b2lkIGFyY2hf
aGFsdHBvbGxfZGlzYWJsZSh1bnNpZ25lZCBpbnQgY3B1KSB7IH0NCj4gPiA+ID4gPiArDQo+ID4g
PiA+ID4gK2Jvb2wgYXJjaF9oYWx0cG9sbF93YW50KGJvb2wgZm9yY2UpOw0KPiA+ID4gPiA+ICsj
ZW5kaWYNCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rZXJuZWwvY3B1aWRsZS5j
IGIvYXJjaC9hcm02NC9rZXJuZWwvY3B1aWRsZS5jDQo+ID4gPiA+ID4gaW5kZXggZjM3MjI5NTIw
N2ZiLi4zMzRkZjgyYTBlYWMgMTAwNjQ0DQo+ID4gPiA+ID4gLS0tIGEvYXJjaC9hcm02NC9rZXJu
ZWwvY3B1aWRsZS5jDQo+ID4gPiA+ID4gKysrIGIvYXJjaC9hcm02NC9rZXJuZWwvY3B1aWRsZS5j
DQo+ID4gPiA+ID4gQEAgLTcyLDMgKzcyLDI2IEBAIF9fY3B1aWRsZSBpbnQgYWNwaV9wcm9jZXNz
b3JfZmZoX2xwaV9lbnRlcihzdHJ1Y3QgYWNwaV9scGlfc3RhdGUgKmxwaSkNCj4gPiA+ID4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBscGktPmluZGV4LCBz
dGF0ZSk7DQo+ID4gPiA+ID4gIH0NCj4gPiA+ID4gPiAgI2VuZGlmDQo+ID4gPiA+ID4gKw0KPiA+
ID4gPiA+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfSEFMVFBPTExfQ1BVSURMRSkNCj4gPiA+ID4g
PiArDQo+ID4gPiA+ID4gKyNpbmNsdWRlIDxhc20vY3B1aWRsZV9oYWx0cG9sbC5oPg0KPiA+ID4g
PiA+ICsNCj4gPiA+ID4gPiArYm9vbCBhcmNoX2hhbHRwb2xsX3dhbnQoYm9vbCBmb3JjZSkNCj4g
PiA+ID4gPiArew0KPiA+ID4gPiA+ICsgICAgICAgLyoNCj4gPiA+ID4gPiArICAgICAgICAqIEVu
YWJsaW5nIGhhbHRwb2xsIHJlcXVpcmVzIHR3byB0aGluZ3M6DQo+ID4gPiA+ID4gKyAgICAgICAg
Kg0KPiA+ID4gPiA+ICsgICAgICAgICogLSBFdmVudCBzdHJlYW0gc3VwcG9ydCB0byBwcm92aWRl
IGEgdGVybWluYXRpbmcgY29uZGl0aW9uIHRvIHRoZQ0KPiA+ID4gPiA+ICsgICAgICAgICogICBX
RkUgaW4gdGhlIHBvbGwgbG9vcC4NCj4gPiA+ID4gPiArICAgICAgICAqDQo+ID4gPiA+ID4gKyAg
ICAgICAgKiAtIEtWTSBzdXBwb3J0IGZvciBhcmNoX2hhbHRwb2xsX2VuYWJsZSgpLCBhcmNoX2hh
bHRwb2xsX2VuYWJsZSgpLg0KPiA+ID4gPiANCj4gPiA+ID4gdHlwbzogImFyY2hfaGFsdHBvbGxf
ZW5hYmxlIiBhbmQgImFyY2hfaGFsdHBvbGxfZW5hYmxlIg0KPiA+ID4gPiANCj4gPiA+ID4gPiAr
ICAgICAgICAqDQo+ID4gPiA+ID4gKyAgICAgICAgKiBHaXZlbiB0aGF0IHRoZSBzZWNvbmQgaXMg
bWlzc2luZywgYWxsb3cgaGFsdHBvbGwgdG8gb25seSBiZSBmb3JjZQ0KPiA+ID4gPiA+ICsgICAg
ICAgICogbG9hZGVkLg0KPiA+ID4gPiA+ICsgICAgICAgICovDQo+ID4gPiA+ID4gKyAgICAgICBy
ZXR1cm4gKGFyY2hfdGltZXJfZXZ0c3RybV9hdmFpbGFibGUoKSAmJiBmYWxzZSkgfHwgZm9yY2U7
DQo+ID4gPiA+IA0KPiA+ID4gPiBUaGlzIHNob3VsZCBhbHdheXMgZXZhbHVhdGUgZmFsc2Ugd2l0
aG91dCBmb3JjZS4gUGVyaGFwcyB5b3UgbWVhbnQNCj4gPiA+ID4gc29tZXRoaW5nIGxpa2UgdGhp
cz8NCj4gPiA+ID4gDQo+ID4gPiA+IGBgYA0KPiA+ID4gPiAtICAgICAgIHJldHVybiAoYXJjaF90
aW1lcl9ldnRzdHJtX2F2YWlsYWJsZSgpICYmIGZhbHNlKSB8fCBmb3JjZTsNCj4gPiA+ID4gKyAg
ICAgICByZXR1cm4gYXJjaF90aW1lcl9ldnRzdHJtX2F2YWlsYWJsZSgpIHx8IGZvcmNlOw0KPiA+
ID4gPiBgYGANCj4gPiA+IA0KPiA+ID4gTm8uIFRoaXMgd2FzIGludGVudGlvbmFsLiBBcyBJIG1l
bml0b24gaW4gdGhlIGNvbW1lbnQgYWJvdmUsIHJpZ2h0IG5vdw0KPiA+ID4gdGhlIEtWTSBzdXBw
b3J0IGlzIG1pc3NpbmcuIFdoaWNoIG1lYW5zIHRoYXQgdGhlIGd1ZXN0IGhhcyBubyB3YXkgdG8N
Cj4gPiA+IHRlbGwgdGhlIGhvc3QgdG8gbm90IHBvbGwgYXMgcGFydCBvZiBob3N0IGhhbHRwb2xs
Lg0KPiA+ID4gDQo+ID4gPiBVbnRpbCB0aGF0IGlzIGF2YWlsYWJsZSwgb25seSBhbGxvdyBmb3Jj
ZSBsb2FkaW5nLg0KPiA+IA0KPiA+IEkgc2VlLCBhcm02NCdzIGt2bSBpcyBtaXNzaW5nIHRoZSBw
b2xsIGNvbnRyb2wgbWVjaGFuaXNtLg0KPiA+IA0KPiA+IEknbGwgZm9sbG93LXVwIHlvdXIgY2hh
bmdlcyB3aXRoIGEgcGF0Y2ggZm9yIEFXUyBHcmF2aXRvbjsgc3RpbGwgc2VlaW5nDQo+ID4gdGhl
IHNhbWUgcGVyZm9ybWFuY2UgZ2FpbnMuDQo+IA0KPiBFeGNlbGxlbnQuIENvdWxkIHlvdSBDYyBt
ZSB3aGVuIHlvdSBzZW5kIG91dCB5b3VyIGNoYW5nZXM/DQoNCldpbGwgZG8NCg0KLS0gSGFyaXMg
T2thbm92aWMNCg0KPiANCj4gPiBUZXN0ZWQtYnk6IEhhcmlzIE9rYW5vdmljIDxoYXJpc29rbkBh
bWF6b24uY29tPg0KPiANCj4gVGhhbmtzIQ0KPiANCj4gLS0NCj4gYW5rdXINCg0K

