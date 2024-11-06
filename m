Return-Path: <kvm+bounces-31034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 941229BF7FF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C05831C2185D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 20:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56CE120C324;
	Wed,  6 Nov 2024 20:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="IvGxv2Gw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9532208231;
	Wed,  6 Nov 2024 20:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730925089; cv=none; b=fpA6eBFkRxiZPe8N4dcZavkDmJtZylu+ZCUq1+7z4Xpg+ZKGXcfz0/pYmOazWub6Oo94TD6ALr6a82R9iqVlpal+zlHvuPZfp9Xde56A/7sG1vm8/SfarOIJXFsDDLG8ZdG0czRu857uepJ4usFhk9SzV/BdDLfoKo7+PPRBB8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730925089; c=relaxed/simple;
	bh=MflW0vb8GWjHmqnfkMb59e1fzxAGhpXY553YgwUL6nY=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CMt5OvQfgVKI0wYTrsMAOZvEfDfYpiiuSrgrNsXQvWZgcoprV/fKLJG1jZcuqO729kYnL4JJbCW0MeBVvX++c3ZFqSqxMIm6JritKgG5q4Hn3AUCUTGA+15OnO2Y8V4mlmb97WE6E6s+GFEIF3z/gjUg+wKZ3SSxhiel+vXS/5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=IvGxv2Gw; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730925087; x=1762461087;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=MflW0vb8GWjHmqnfkMb59e1fzxAGhpXY553YgwUL6nY=;
  b=IvGxv2GwLCG0Fziir90L/MgZE5/pYTci0+IdkZoGYKmCeIPuVE9fCp5J
   NakIMCCYktpUeoUyhqvzzvU3yWAK1qY+e7Rdh3bZuyUBFRXbnIVhXmgM0
   E5WcDNEi1TPAaqE4C1VgI6Zn7cOyLLSC1F8ItWna3dlalilO7TfZLJrHj
   Y=;
X-IronPort-AV: E=Sophos;i="6.11,263,1725321600"; 
   d="scan'208";a="143941776"
Subject: Re: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Thread-Topic: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 20:31:26 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.38.20:58957]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.42:2525] with esmtp (Farcaster)
 id 74b238a2-6a8e-4c07-8121-184743ad2cf5; Wed, 6 Nov 2024 20:31:26 +0000 (UTC)
X-Farcaster-Flow-ID: 74b238a2-6a8e-4c07-8121-184743ad2cf5
Received: from EX19D001UWA002.ant.amazon.com (10.13.138.236) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 6 Nov 2024 20:31:25 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA002.ant.amazon.com (10.13.138.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 6 Nov 2024 20:31:25 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.035; Wed, 6 Nov 2024 20:31:25 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "catalin.marinas@arm.com" <catalin.marinas@arm.com>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mtosatti@redhat.com"
	<mtosatti@redhat.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "cl@gentwo.org"
	<cl@gentwo.org>, "wanpengli@tencent.com" <wanpengli@tencent.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "misono.tomohiro@fujitsu.com"
	<misono.tomohiro@fujitsu.com>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"sudeep.holla@arm.com" <sudeep.holla@arm.com>, "Okanovic, Haris"
	<harisokn@amazon.com>, "rafael@kernel.org" <rafael@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Thread-Index: AQHbL7D0KO91MZWU0ESDfcp3e5ep6bKqGPiAgAB21ICAAByPAIAACfOA
Date: Wed, 6 Nov 2024 20:31:25 +0000
Message-ID: <efa0646d397294aa413a46cfb7f8e1d9e1f327b1.camel@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
	 <20241105183041.1531976-1-harisokn@amazon.com>
	 <20241105183041.1531976-2-harisokn@amazon.com> <ZytOH2oigoC-qVLK@arm.com>
	 <b62d938111c6ce52b91d0f2e3922857c5d4ef253.camel@amazon.com>
	 <ZyvJwjfKgnqMpM9P@arm.com>
In-Reply-To: <ZyvJwjfKgnqMpM9P@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DAB45472D525F4AA2B09807535F01B2@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTExLTA2IGF0IDE5OjU1ICswMDAwLCBDYXRhbGluIE1hcmluYXMgd3JvdGU6
DQo+IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9y
Z2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUu
DQo+IA0KPiANCj4gDQo+IE9uIFdlZCwgTm92IDA2LCAyMDI0IGF0IDA2OjEzOjM1UE0gKzAwMDAs
IE9rYW5vdmljLCBIYXJpcyB3cm90ZToNCj4gPiBPbiBXZWQsIDIwMjQtMTEtMDYgYXQgMTE6MDgg
KzAwMDAsIENhdGFsaW4gTWFyaW5hcyB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgTm92IDA1LCAyMDI0
IGF0IDEyOjMwOjM3UE0gLTA2MDAsIEhhcmlzIE9rYW5vdmljIHdyb3RlOg0KPiA+ID4gPiBkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9hc20tZ2VuZXJpYy9iYXJyaWVyLmggYi9pbmNsdWRlL2FzbS1nZW5l
cmljL2JhcnJpZXIuaA0KPiA+ID4gPiBpbmRleCBkNGY1ODFjMWUyMWQuLjExMjAyN2VhYmJmYyAx
MDA2NDQNCj4gPiA+ID4gLS0tIGEvaW5jbHVkZS9hc20tZ2VuZXJpYy9iYXJyaWVyLmgNCj4gPiA+
ID4gKysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy9iYXJyaWVyLmgNCj4gPiA+ID4gQEAgLTI1Niw2
ICsyNTYsMzEgQEAgZG8geyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiA+ID4gIH0pDQo+ID4gPiA+ICAjZW5k
aWYNCj4gPiA+ID4gDQo+ID4gPiA+ICsvKioNCj4gPiA+ID4gKyAqIHNtcF92Y29uZF9sb2FkX3Jl
bGF4ZWQoKSAtIChTcGluKSB3YWl0IHVudGlsIGFuIGV4cGVjdGVkIHZhbHVlIGF0IGFkZHJlc3MN
Cj4gPiA+ID4gKyAqIHdpdGggbm8gb3JkZXJpbmcgZ3VhcmFudGVlcy4gU3BpbnMgdW50aWwgYCgq
YWRkciAmIG1hc2spID09IHZhbGAgb3INCj4gPiA+ID4gKyAqIGBuc2Vjc2AgZWxhcHNlLCBhbmQg
cmV0dXJucyB0aGUgbGFzdCBvYnNlcnZlZCBgKmFkZHJgIHZhbHVlLg0KPiA+ID4gPiArICoNCj4g
PiA+ID4gKyAqIEBuc2VjczogdGltZW91dCBpbiBuYW5vc2Vjb25kcw0KPiA+ID4gDQo+ID4gPiBG
V0lXLCBJIGRvbid0IG1pbmQgdGhlIHJlbGF0aXZlIHRpbWVvdXQsIGl0IG1ha2VzIHRoZSBBUEkg
ZWFzaWVyIHRvIHVzZS4NCj4gPiA+IFllcywgaXQgbWF5IHRha2UgbG9uZ2VyIGluIGFic29sdXRl
IHRpbWUgaWYgdGhlIHRocmVhZCBpcyBzY2hlZHVsZWQgb3V0DQo+ID4gPiBiZWZvcmUgbG9jYWxf
Y2xvY2tfbm9pbnN0cigpIGlzIHJlYWQgYnV0IHRoZSBzYW1lIGNhbiBoYXBwZW4gaW4gdGhlDQo+
ID4gPiBjYWxsZXIgYW55d2F5LiBJdCdzIHNpbWlsYXIgdG8gdWRlbGF5KCksIGl0IGNhbiB0YWtl
IGxvbmdlciBpZiB0aGUNCj4gPiA+IHRocmVhZCBpcyBzY2hlZHVsZWQgb3V0Lg0KPiA+ID4gDQo+
ID4gPiA+ICsgKiBAYWRkcjogcG9pbnRlciB0byBhbiBpbnRlZ2VyDQo+ID4gPiA+ICsgKiBAbWFz
azogYSBiaXQgbWFzayBhcHBsaWVkIHRvIHJlYWQgdmFsdWVzDQo+ID4gPiA+ICsgKiBAdmFsOiBF
eHBlY3RlZCB2YWx1ZSB3aXRoIG1hc2sNCj4gPiA+ID4gKyAqLw0KPiA+ID4gPiArI2lmbmRlZiBz
bXBfdmNvbmRfbG9hZF9yZWxheGVkDQo+ID4gPiA+ICsjZGVmaW5lIHNtcF92Y29uZF9sb2FkX3Jl
bGF4ZWQobnNlY3MsIGFkZHIsIG1hc2ssIHZhbCkgKHsgICAgXA0KPiA+ID4gPiArICAgICBjb25z
dCB1NjQgX19zdGFydCA9IGxvY2FsX2Nsb2NrX25vaW5zdHIoKTsgICAgICAgICAgICAgIFwNCj4g
PiA+ID4gKyAgICAgdTY0IF9fbnNlY3MgPSAobnNlY3MpOyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBcDQo+ID4gPiA+ICsgICAgIHR5cGVvZihhZGRyKSBfX2FkZHIgPSAoYWRkcik7
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ID4gPiArICAgICB0eXBlb2YoKl9fYWRk
cikgX19tYXNrID0gKG1hc2spOyAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiA+ID4gKyAg
ICAgdHlwZW9mKCpfX2FkZHIpIF9fdmFsID0gKHZhbCk7ICAgICAgICAgICAgICAgICAgICAgICAg
ICBcDQo+ID4gPiA+ICsgICAgIHR5cGVvZigqX19hZGRyKSBfX2N1cjsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXA0KPiA+ID4gPiArICAgICBzbXBfY29uZF9sb2FkX3JlbGF4ZWQo
X19hZGRyLCAoICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiA+ID4gKyAgICAgICAgICAg
ICAoVkFMICYgX19tYXNrKSA9PSBfX3ZhbCB8fCAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4g
PiA+ICsgICAgICAgICAgICAgbG9jYWxfY2xvY2tfbm9pbnN0cigpIC0gX19zdGFydCA+IF9fbnNl
Y3MgICAgICAgXA0KPiA+ID4gPiArICAgICApKTsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiA+ID4gK30pDQo+ID4gPiANCj4gPiA+IFRo
ZSBnZW5lcmljIGltcGxlbWVudGF0aW9uIGhhcyB0aGUgc2FtZSBwcm9ibGVtIGFzIEFua3VyJ3Mg
Y3VycmVudA0KPiA+ID4gc2VyaWVzLiBzbXBfY29uZF9sb2FkX3JlbGF4ZWQoKSBjYW4ndCB3YWl0
IG9uIGFueXRoaW5nIG90aGVyIHRoYW4gdGhlDQo+ID4gPiB2YXJpYWJsZSBhdCBfX2FkZHIuIElm
IGl0IGdvZXMgaW50byBhIFdGRSwgdGhlcmUncyBub3RoaW5nIGV4ZWN1dGVkIHRvDQo+ID4gPiBy
ZWFkIHRoZSB0aW1lciBhbmQgY2hlY2sgZm9yIHByb2dyZXNzLiBBbnkgZ2VuZXJpYyBpbXBsZW1l
bnRhdGlvbiBvZg0KPiA+ID4gc3VjaCBmdW5jdGlvbiB3b3VsZCBoYXZlIHRvIHVzZSBjcHVfcmVs
YXgoKSBhbmQgcG9sbGluZy4NCj4gPiANCj4gPiBIb3cgd291bGQgdGhlIGNhbGxlciBlbnRlciB3
ZmUoKT8gQ2FuIHlvdSBnaXZlIGEgc3BlY2lmaWMgc2NlbmFyaW8gdGhhdA0KPiA+IHlvdSdyZSBj
b25jZXJuZWQgYWJvdXQ/DQo+IA0KPiBMZXQncyB0YWtlIHRoZSBhcm02NCBleGFtcGxlIHdpdGgg
dGhlIGV2ZW50IHN0cmVhbSBkaXNhYmxlZC4gV2l0aG91dCB0aGUNCj4gc3Vic2VxdWVudCBwYXRj
aGVzIGltcGxlbWVudGluZyBzbXBfdmNvbmRfbG9hZF9yZWxheGVkKCksIGp1c3QgZXhwYW5kDQo+
IHRoZSBhcm02NCBzbXBfY29uZF9sb2FkX3JlbGF4ZWQoKSBpbXBsZW1lbnRhdGlvbiBpbiB0aGUg
YWJvdmUgbWFjcm8uIElmDQo+IHRoZSB0aW1lciBjaGVjayBkb2Vzbid0IHRyaWdnZXIgYW4gZXhp
dCBmcm9tIHRoZSBsb29wLA0KPiBfX2NtcHdhaXRfcmVsYXhlZCgpIG9ubHkgd2FpdHMgb24gdGhl
IHZhcmlhYmxlIHRvIGNoYW5nZSBpdHMgdmFsdWUsDQo+IG5vdGhpbmcgdG8gZG8gd2l0aCB0aGUg
dGltZXIuDQo+IA0KPiA+IFRoaXMgY29kZSBhbHJlYWR5IHJlZHVjZXMgdG8gYSByZWxheGVkIHBv
bGwsIHNvbWV0aGluZyBsaWtlIHRoaXM6DQo+ID4gDQo+ID4gYGBgDQo+ID4gc3RhcnQgPSBjbG9j
aygpOw0KPiA+IHdoaWxlKChSRUFEX09OQ0UoKmFkZHIpICYgbWFzaykgIT0gdmFsICYmIChjbG9j
aygpIC0gc3RhcnQpIDwgbnNlY3MpIHsNCj4gPiAgIGNwdV9yZWxheCgpOw0KPiA+IH0NCj4gPiBg
YGANCj4gDQo+IFdlbGwsIHRoYXQncyBpZiB5b3UgYWxzbyB1c2UgdGhlIGdlbmVyaWMgaW1wbGVt
ZW50YXRpb24gb2YNCj4gc21wX2NvbmRfbG9hZF9yZWxheGVkKCkgYnV0IGhhdmUgeW91IGNoZWNr
ZWQgYWxsIHRoZSBvdGhlciBhcmNoaXRlY3R1cmVzDQo+IHRoYXQgZG9uJ3QgZG8gc29tZXRoaW5n
IHNpbWlsYXIgdG8gdGhlIGFybTY0IHdmZSAocmlzY3YgY29tZXMgY2xvc2UpPw0KPiBFdmVuIGlm
IGFsbCBvdGhlciBhcmNoaXRlY3R1cmVzIGp1c3QgdXNlIGEgY3B1X3JlbGF4KCksIHRoYXQncyBz
dGlsbA0KPiBhYnVzaW5nIHRoZSBzbXBfY29uZF9sb2FkX3JlbGF4ZWQoKSBzZW1hbnRpY3MuIEFu
ZCB3aGF0IGlmIG9uZSBwbGFjZXMNCj4gYW5vdGhlciBsb29wIGluIHRoZWlyIF9fY21wd2FpdCgp
PyBUaGF0J3MgYWxsb3dlZCBiZWNhdXNlIHlvdSBhcmUNCj4gc3VwcG9zZWQgdG8gd2FpdCBvbiBh
IHNpbmdsZSB2YXJpYWJsZSB0byBjaGFuZ2Ugbm90IG9uIG11bHRpcGxlIHN0YXRlcy4NCg0KSSBz
ZWUgd2hhdCB5b3UgbWVhbiBub3cgLSBJIGdsb3NzZWQgb3ZlciB0aGUgdXNlIG9mIF9fY21wd2Fp
dF9yZWxheGVkKCkNCmluIHNtcF9jb25kX2xvYWRfcmVsYXhlZCgpLiBJJ2xsIHBvc3QgYW5vdGhl
ciByZXYgd2l0aCB0aGUgZml4LCBzaW1pbGFyDQp0byB0aGUgYWJvdmUgInJlZHVjZWQiIGNvZGUu
DQoNCj4gDQo+IC0tDQo+IENhdGFsaW4NCg0KDQo=

