Return-Path: <kvm+bounces-31018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 459409BF4F0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9BE71F23985
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2D4208969;
	Wed,  6 Nov 2024 18:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="wFn4G1r0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F99208231;
	Wed,  6 Nov 2024 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730916818; cv=none; b=EaqxpoNguEs3WjCSxcBKBZKTZY8Srd0AdRuI0HavoTrfxhnqB8aklMh8wUe5F1eAaJ/rF3gdHPy9LZq3WmIi4fOdjUxS9MMKPOpb1St8Z6eM8KTcDxIR6X8npyDFy+UX5oSFUV8J03dksnj5Uk0WTkb+PwuKeyvbc5WuOJdi/Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730916818; c=relaxed/simple;
	bh=B3lss5ZlgQtcQZUPoV/47IsRa1rCtwlXbhAIjG8ICcA=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JBR6le4GNdRuSfHTBzg1tko5X82QVcUbd2vnWazur6gqkNJ8Qh3E3rxy/RQj2S7mfkyJm0f6p6SZ1QaQ3JrnuSI9DMLKxa+rWEIDGEKxAVy4qfC7jnZknCOytn9x5Myai/CSP12o0Xr2X+Tjbgxa1Nw19ltb65rUFNKwPcIo4LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=wFn4G1r0; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730916817; x=1762452817;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=B3lss5ZlgQtcQZUPoV/47IsRa1rCtwlXbhAIjG8ICcA=;
  b=wFn4G1r0KziQ60+xOK6HtRYZty0/u7NiRHntnu4vHwVJoqUqgmGm0vz+
   OdqfcIpmTN/bspkfXCb9A7aaDopKgMHYXGJmpUXpVmQm+STr492f0+2q7
   A4yNWb5Q/9arj9HjPrItf8SlwhBFM13+Rbv3Y9sPUX+SUn0U5Gx+sEFMo
   g=;
X-IronPort-AV: E=Sophos;i="6.11,263,1725321600"; 
   d="scan'208";a="144934645"
Subject: Re: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Thread-Topic: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 18:13:36 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:4517]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.42:2525] with esmtp (Farcaster)
 id d9d6835a-7d5a-4cca-bcdf-5b1fad2f4435; Wed, 6 Nov 2024 18:13:36 +0000 (UTC)
X-Farcaster-Flow-ID: d9d6835a-7d5a-4cca-bcdf-5b1fad2f4435
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 6 Nov 2024 18:13:35 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 6 Nov 2024 18:13:35 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.035; Wed, 6 Nov 2024 18:13:35 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "catalin.marinas@arm.com" <catalin.marinas@arm.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "wanpengli@tencent.com"
	<wanpengli@tencent.com>, "cl@gentwo.org" <cl@gentwo.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "misono.tomohiro@fujitsu.com"
	<misono.tomohiro@fujitsu.com>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "Okanovic, Haris" <harisokn@amazon.com>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "mtosatti@redhat.com"
	<mtosatti@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>
Thread-Index: AQHbL7D0KO91MZWU0ESDfcp3e5ep6bKqGPiAgAB21IA=
Date: Wed, 6 Nov 2024 18:13:35 +0000
Message-ID: <b62d938111c6ce52b91d0f2e3922857c5d4ef253.camel@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
	 <20241105183041.1531976-1-harisokn@amazon.com>
	 <20241105183041.1531976-2-harisokn@amazon.com> <ZytOH2oigoC-qVLK@arm.com>
In-Reply-To: <ZytOH2oigoC-qVLK@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F8D000EE926994C84000A51FF37FABE@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTExLTA2IGF0IDExOjA4ICswMDAwLCBDYXRhbGluIE1hcmluYXMgd3JvdGU6
DQo+IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9y
Z2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUu
DQo+IA0KPiANCj4gDQo+IE9uIFR1ZSwgTm92IDA1LCAyMDI0IGF0IDEyOjMwOjM3UE0gLTA2MDAs
IEhhcmlzIE9rYW5vdmljIHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS1nZW5l
cmljL2JhcnJpZXIuaCBiL2luY2x1ZGUvYXNtLWdlbmVyaWMvYmFycmllci5oDQo+ID4gaW5kZXgg
ZDRmNTgxYzFlMjFkLi4xMTIwMjdlYWJiZmMgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9hc20t
Z2VuZXJpYy9iYXJyaWVyLmgNCj4gPiArKysgYi9pbmNsdWRlL2FzbS1nZW5lcmljL2JhcnJpZXIu
aA0KPiA+IEBAIC0yNTYsNiArMjU2LDMxIEBAIGRvIHsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gIH0pDQo+
ID4gICNlbmRpZg0KPiA+IA0KPiA+ICsvKioNCj4gPiArICogc21wX3Zjb25kX2xvYWRfcmVsYXhl
ZCgpIC0gKFNwaW4pIHdhaXQgdW50aWwgYW4gZXhwZWN0ZWQgdmFsdWUgYXQgYWRkcmVzcw0KPiA+
ICsgKiB3aXRoIG5vIG9yZGVyaW5nIGd1YXJhbnRlZXMuIFNwaW5zIHVudGlsIGAoKmFkZHIgJiBt
YXNrKSA9PSB2YWxgIG9yDQo+ID4gKyAqIGBuc2Vjc2AgZWxhcHNlLCBhbmQgcmV0dXJucyB0aGUg
bGFzdCBvYnNlcnZlZCBgKmFkZHJgIHZhbHVlLg0KPiA+ICsgKg0KPiA+ICsgKiBAbnNlY3M6IHRp
bWVvdXQgaW4gbmFub3NlY29uZHMNCj4gDQo+IEZXSVcsIEkgZG9uJ3QgbWluZCB0aGUgcmVsYXRp
dmUgdGltZW91dCwgaXQgbWFrZXMgdGhlIEFQSSBlYXNpZXIgdG8gdXNlLg0KPiBZZXMsIGl0IG1h
eSB0YWtlIGxvbmdlciBpbiBhYnNvbHV0ZSB0aW1lIGlmIHRoZSB0aHJlYWQgaXMgc2NoZWR1bGVk
IG91dA0KPiBiZWZvcmUgbG9jYWxfY2xvY2tfbm9pbnN0cigpIGlzIHJlYWQgYnV0IHRoZSBzYW1l
IGNhbiBoYXBwZW4gaW4gdGhlDQo+IGNhbGxlciBhbnl3YXkuIEl0J3Mgc2ltaWxhciB0byB1ZGVs
YXkoKSwgaXQgY2FuIHRha2UgbG9uZ2VyIGlmIHRoZQ0KPiB0aHJlYWQgaXMgc2NoZWR1bGVkIG91
dC4NCj4gDQo+ID4gKyAqIEBhZGRyOiBwb2ludGVyIHRvIGFuIGludGVnZXINCj4gPiArICogQG1h
c2s6IGEgYml0IG1hc2sgYXBwbGllZCB0byByZWFkIHZhbHVlcw0KPiA+ICsgKiBAdmFsOiBFeHBl
Y3RlZCB2YWx1ZSB3aXRoIG1hc2sNCj4gPiArICovDQo+ID4gKyNpZm5kZWYgc21wX3Zjb25kX2xv
YWRfcmVsYXhlZA0KPiA+ICsjZGVmaW5lIHNtcF92Y29uZF9sb2FkX3JlbGF4ZWQobnNlY3MsIGFk
ZHIsIG1hc2ssIHZhbCkgKHsgICAgXA0KPiA+ICsgICAgIGNvbnN0IHU2NCBfX3N0YXJ0ID0gbG9j
YWxfY2xvY2tfbm9pbnN0cigpOyAgICAgICAgICAgICAgXA0KPiA+ICsgICAgIHU2NCBfX25zZWNz
ID0gKG5zZWNzKTsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAg
IHR5cGVvZihhZGRyKSBfX2FkZHIgPSAoYWRkcik7ICAgICAgICAgICAgICAgICAgICAgICAgICAg
XA0KPiA+ICsgICAgIHR5cGVvZigqX19hZGRyKSBfX21hc2sgPSAobWFzayk7ICAgICAgICAgICAg
ICAgICAgICAgICAgXA0KPiA+ICsgICAgIHR5cGVvZigqX19hZGRyKSBfX3ZhbCA9ICh2YWwpOyAg
ICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAgIHR5cGVvZigqX19hZGRyKSBfX2N1
cjsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAgIHNtcF9jb25k
X2xvYWRfcmVsYXhlZChfX2FkZHIsICggICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsg
ICAgICAgICAgICAgKFZBTCAmIF9fbWFzaykgPT0gX192YWwgfHwgICAgICAgICAgICAgICAgICAg
ICAgXA0KPiA+ICsgICAgICAgICAgICAgbG9jYWxfY2xvY2tfbm9pbnN0cigpIC0gX19zdGFydCA+
IF9fbnNlY3MgICAgICAgXA0KPiA+ICsgICAgICkpOyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICt9KQ0KPiANCj4gVGhlIGdlbmVyaWMg
aW1wbGVtZW50YXRpb24gaGFzIHRoZSBzYW1lIHByb2JsZW0gYXMgQW5rdXIncyBjdXJyZW50DQo+
IHNlcmllcy4gc21wX2NvbmRfbG9hZF9yZWxheGVkKCkgY2FuJ3Qgd2FpdCBvbiBhbnl0aGluZyBv
dGhlciB0aGFuIHRoZQ0KPiB2YXJpYWJsZSBhdCBfX2FkZHIuIElmIGl0IGdvZXMgaW50byBhIFdG
RSwgdGhlcmUncyBub3RoaW5nIGV4ZWN1dGVkIHRvDQo+IHJlYWQgdGhlIHRpbWVyIGFuZCBjaGVj
ayBmb3IgcHJvZ3Jlc3MuIEFueSBnZW5lcmljIGltcGxlbWVudGF0aW9uIG9mDQo+IHN1Y2ggZnVu
Y3Rpb24gd291bGQgaGF2ZSB0byB1c2UgY3B1X3JlbGF4KCkgYW5kIHBvbGxpbmcuDQoNCkhvdyB3
b3VsZCB0aGUgY2FsbGVyIGVudGVyIHdmZSgpPyBDYW4geW91IGdpdmUgYSBzcGVjaWZpYyBzY2Vu
YXJpbyB0aGF0DQp5b3UncmUgY29uY2VybmVkIGFib3V0Pw0KDQpUaGlzIGNvZGUgYWxyZWFkeSBy
ZWR1Y2VzIHRvIGEgcmVsYXhlZCBwb2xsLCBzb21ldGhpbmcgbGlrZSB0aGlzOg0KDQpgYGANCnN0
YXJ0ID0gY2xvY2soKTsNCndoaWxlKChSRUFEX09OQ0UoKmFkZHIpICYgbWFzaykgIT0gdmFsICYm
IChjbG9jaygpIC0gc3RhcnQpIDwgbnNlY3MpIHsNCiAgY3B1X3JlbGF4KCk7DQp9DQpgYGANCg0K
PiANCj4gLS0NCj4gQ2F0YWxpbg0KDQo=

