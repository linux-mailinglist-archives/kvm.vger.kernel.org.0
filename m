Return-Path: <kvm+bounces-31010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AFBD9BF42B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19A861F22712
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD8320651F;
	Wed,  6 Nov 2024 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="NlVBoAoZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34951DFDB3;
	Wed,  6 Nov 2024 17:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730913511; cv=none; b=sanfoVlsMEV88f9gxmZz6HMcAS6cteZbAHjvjvLHf5Hr0XMz/kTVtSR8P4o64JCMOOxSGb6cLXBZV3z6ro9NMDRQHUoymLt8KBk9sNXUuNsIgYpNTFnNQdMJE6e9/KnETUrS/alt8NUD5/DzydY+M36PtsCDXm08XZCSdmJxDOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730913511; c=relaxed/simple;
	bh=RS32UbC5YTGUMCM+H2KsQrM6zbTTFPULTJlP9ekHazQ=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Glmm7BfvTyDNkWCBYjUbdBYe6eHfvDpildpBwXzG0nURi/ryiZCXXSxA2BXP19yPHB+h4AdbSnzjONN7Xz4xZJvf8tLBV76jqJEjycEr2EeyWjXJ1mIEsw7tDIu0kqUdAZmLGrfEZD9QzeoJRwaNryM6RuIU6Gq0FneKwZmM8+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=NlVBoAoZ; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730913510; x=1762449510;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=RS32UbC5YTGUMCM+H2KsQrM6zbTTFPULTJlP9ekHazQ=;
  b=NlVBoAoZH0JlmpuO4ENRb/tmlLBaSDz1Az94eb65iWV+em1rt90xF4el
   Bg93xbz3NtLoorVFxwNS3DqLKnBRKH03ms85pDK7dVXnZQ5sJwl3UbhQR
   8z4Bo9pfbzpBKEjap9BPjMSR632pR8Obbj70ScsGTQQPvl7xDR3ERWeJN
   c=;
X-IronPort-AV: E=Sophos;i="6.11,263,1725321600"; 
   d="scan'208";a="437718798"
Subject: Re: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Thread-Topic: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 17:18:27 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:24002]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.195:2525] with esmtp (Farcaster)
 id 17d0382b-27f1-49a1-9c31-0687b6686f64; Wed, 6 Nov 2024 17:18:25 +0000 (UTC)
X-Farcaster-Flow-ID: 17d0382b-27f1-49a1-9c31-0687b6686f64
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 6 Nov 2024 17:18:25 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 6 Nov 2024 17:18:25 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.035; Wed, 6 Nov 2024 17:18:25 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "will@kernel.org" <will@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "wanpengli@tencent.com"
	<wanpengli@tencent.com>, "cl@gentwo.org" <cl@gentwo.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "misono.tomohiro@fujitsu.com"
	<misono.tomohiro@fujitsu.com>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>, "mtosatti@redhat.com"
	<mtosatti@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Okanovic, Haris"
	<harisokn@amazon.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>
Thread-Index: AQHbL7D0KO91MZWU0ESDfcp3e5ep6bKqIdAAgABekoA=
Date: Wed, 6 Nov 2024 17:18:25 +0000
Message-ID: <1d070075c2e2fdf014d0c0ecb8a48f88bc7d229d.camel@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
	 <20241105183041.1531976-1-harisokn@amazon.com>
	 <20241105183041.1531976-2-harisokn@amazon.com>
	 <20241106113953.GA13801@willie-the-truck>
In-Reply-To: <20241106113953.GA13801@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <9617A0F4EB9ED64E80C1CE412977270C@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTExLTA2IGF0IDExOjM5ICswMDAwLCBXaWxsIERlYWNvbiB3cm90ZToNCj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiANCj4gT24gVHVlLCBOb3YgMDUsIDIwMjQgYXQgMTI6MzA6MzdQTSAtMDYwMCwgSGFy
aXMgT2thbm92aWMgd3JvdGU6DQo+ID4gUmVsYXhlZCBwb2xsIHVudGlsIGRlc2lyZWQgbWFzay92
YWx1ZSBpcyBvYnNlcnZlZCBhdCB0aGUgc3BlY2lmaWVkDQo+ID4gYWRkcmVzcyBvciB0aW1lb3V0
Lg0KPiA+IA0KPiA+IFRoaXMgbWFjcm8gaXMgYSBzcGVjaWFsaXphdGlvbiBvZiB0aGUgZ2VuZXJp
YyBzbXBfY29uZF9sb2FkX3JlbGF4ZWQoKSwNCj4gPiB3aGljaCB0YWtlcyBhIHNpbXBsZSBtYXNr
L3ZhbHVlIGNvbmRpdGlvbiAodmNvbmQpIGluc3RlYWQgb2YgYW4NCj4gPiBhcmJpdHJhcnkgZXhw
cmVzc2lvbi4gSXQgYWxsb3dzIGFyY2hpdGVjdHVyZXMgdG8gYmV0dGVyIHNwZWNpYWxpemUgdGhl
DQo+ID4gaW1wbGVtZW50YXRpb24sIGUuZy4gdG8gZW5hYmxlIHdmZSgpIHBvbGxpbmcgb2YgdGhl
IGFkZHJlc3Mgb24gYXJtLg0KPiANCj4gVGhpcyBkb2Vzbid0IG1ha2Ugc2Vuc2UgdG8gbWUuIFRo
ZSBleGlzdGluZyBzbXBfY29uZF9sb2FkKCkgZnVuY3Rpb25zDQo+IGFscmVhZHkgdXNlIHdmZSBv
biBhcm02NCBhbmQgSSBkb24ndCBzZWUgd2h5IHdlIG5lZWQgYSBzcGVjaWFsIGhlbHBlcg0KPiBq
dXN0IHRvIGRvIGEgbWFzay4NCg0KV2UgY2FuJ3QgdHVybiBhbiBhcmJpdHJhcnkgQyBleHByZXNz
aW9uIGludG8gYSB3ZmUoKS93ZmV0KCkgZXhpdA0KY29uZGl0aW9uLCB3aGljaCBpcyBvbmUgb2Yg
dGhlIGlucHV0cyB0byB0aGUgZXhpc3Rpbmcgc21wX2NvbmRfbG9hZCgpLg0KVGhpcyBBUEkgaXMg
dGhlcmVmb3JlIG1vcmUgYW1lbmFibGUgdG8gaGFyZHdhcmUgYWNjZWxlcmF0aW9uLg0KDQo+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IEhhcmlzIE9rYW5vdmljIDxoYXJpc29rbkBhbWF6b24uY29tPg0K
PiA+IC0tLQ0KPiA+ICBpbmNsdWRlL2FzbS1nZW5lcmljL2JhcnJpZXIuaCB8IDI1ICsrKysrKysr
KysrKysrKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKykN
Cj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tZ2VuZXJpYy9iYXJyaWVyLmggYi9p
bmNsdWRlL2FzbS1nZW5lcmljL2JhcnJpZXIuaA0KPiA+IGluZGV4IGQ0ZjU4MWMxZTIxZC4uMTEy
MDI3ZWFiYmZjIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvYXNtLWdlbmVyaWMvYmFycmllci5o
DQo+ID4gKysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy9iYXJyaWVyLmgNCj4gPiBAQCAtMjU2LDYg
KzI1NiwzMSBAQCBkbyB7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICB9KQ0KPiA+ICAjZW5kaWYNCj4gPiAN
Cj4gPiArLyoqDQo+ID4gKyAqIHNtcF92Y29uZF9sb2FkX3JlbGF4ZWQoKSAtIChTcGluKSB3YWl0
IHVudGlsIGFuIGV4cGVjdGVkIHZhbHVlIGF0IGFkZHJlc3MNCj4gPiArICogd2l0aCBubyBvcmRl
cmluZyBndWFyYW50ZWVzLiBTcGlucyB1bnRpbCBgKCphZGRyICYgbWFzaykgPT0gdmFsYCBvcg0K
PiA+ICsgKiBgbnNlY3NgIGVsYXBzZSwgYW5kIHJldHVybnMgdGhlIGxhc3Qgb2JzZXJ2ZWQgYCph
ZGRyYCB2YWx1ZS4NCj4gPiArICoNCj4gPiArICogQG5zZWNzOiB0aW1lb3V0IGluIG5hbm9zZWNv
bmRzDQo+ID4gKyAqIEBhZGRyOiBwb2ludGVyIHRvIGFuIGludGVnZXINCj4gPiArICogQG1hc2s6
IGEgYml0IG1hc2sgYXBwbGllZCB0byByZWFkIHZhbHVlcw0KPiA+ICsgKiBAdmFsOiBFeHBlY3Rl
ZCB2YWx1ZSB3aXRoIG1hc2sNCj4gPiArICovDQo+ID4gKyNpZm5kZWYgc21wX3Zjb25kX2xvYWRf
cmVsYXhlZA0KPiANCj4gSSBrbm93IG5hbWluZyBpcyBoYXJkLCBidXQgInZjb25kIiBpcyBlc3Bl
Y2lhbGx5IHRlcnJpYmxlLg0KPiBQZXJoYXBzIHNtcF9jb25kX2xvYWRfdGltZW91dCgpPw0KDQpJ
IGFncmVlLCBuYW1pbmcgaXMgaGFyZCEgSSB3YXMgdHJ5aW5nIHRvIGRpZmZlcmVudGlhdGUgaXQg
ZnJvbQ0Kc21wX2NvbmRfbG9hZCgpIGluIHNvbWUgbWVhbmluZ2Z1bCB3YXkgLSB0aGF0IG9uZSBp
cyBhbiAiZXhwcmVzc2lvbiINCmNvbmRpdGlvbiB0aGlzIG9uZSBpcyBhICJ2YWx1ZSIgY29uZGl0
aW9uLg0KDQpJJ2xsIHRoaW5rIGl0IG92ZXIgYSBiaXQgbW9yZS4NCg0KPiANCj4gV2lsbA0KDQo=

