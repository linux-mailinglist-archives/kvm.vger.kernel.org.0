Return-Path: <kvm+bounces-31008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55EF79BF3F0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15325286F9E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2608206514;
	Wed,  6 Nov 2024 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="EAtQ1/zk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ED71DE4EF;
	Wed,  6 Nov 2024 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730912816; cv=none; b=PqlJiVuVd0Lt6e1o8v1/iy+jbGOPuQy62oRozg6lfb+0cmxuo3317YuFmKvZpto34os5rDERZTP/m27+aKINoHjpAy8PWHgwwXZ+Tmc5n5yr22LqoGq+CP3C5p9PoDVZXoKAeIx8QzVtYwmn+bZ+lvlMcHgD5IywfK1aghVaux0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730912816; c=relaxed/simple;
	bh=Pz81Pbck5wcyAI6JbvV2ZyEMZPVsLQdxsAgLdb8/Imw=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nCl8eeox/u4GOYg8AT1hWVwmilh60JmzTMq7PFvOlhyv94TtuAIlxGxzW98DHqxm10TCHZAmFVO10f7e9xovLxhGNvnk7JcPROX312sC5p0ValWtwhQhJPNmInQ2B59OsSMzqIW1Cg300Vpt7OB538zzAdpzywWkzrxWiAN7NdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=EAtQ1/zk; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730912815; x=1762448815;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=Pz81Pbck5wcyAI6JbvV2ZyEMZPVsLQdxsAgLdb8/Imw=;
  b=EAtQ1/zkUr5uda3dtYCmxLUjFaOFXx50TP6R/jdY2yS34z6zEDmNV+WZ
   Pq32Us+v1Z0QMAWFZTlSGeeBjQXbLcN3K2kxNN7Cxa3A2JMwCS6x/pw+G
   qabO3nH60NUEe+CyLVo49e2ZBkJwZi8/omx6s3tDZZpv01wpxIAnhv0dh
   0=;
X-IronPort-AV: E=Sophos;i="6.11,263,1725321600"; 
   d="scan'208";a="144914035"
Subject: Re: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Thread-Topic: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 17:06:54 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.7.35:44945]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.195:2525] with esmtp (Farcaster)
 id 5bdf6e78-b305-43b2-b302-077e2957626d; Wed, 6 Nov 2024 17:06:54 +0000 (UTC)
X-Farcaster-Flow-ID: 5bdf6e78-b305-43b2-b302-077e2957626d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 6 Nov 2024 17:06:54 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 6 Nov 2024 17:06:54 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.035; Wed, 6 Nov 2024 17:06:54 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "cl@gentwo.org" <cl@gentwo.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "wanpengli@tencent.com"
	<wanpengli@tencent.com>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "misono.tomohiro@fujitsu.com"
	<misono.tomohiro@fujitsu.com>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Okanovic, Haris"
	<harisokn@amazon.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mtosatti@redhat.com" <mtosatti@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>
Thread-Index: AQHbL7D0KO91MZWU0ESDfcp3e5ep6bKpFJ6AgAFojYA=
Date: Wed, 6 Nov 2024 17:06:53 +0000
Message-ID: <2306e1b324c135d7d2bf961202657031d02ad4b0.camel@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
	 <20241105183041.1531976-1-harisokn@amazon.com>
	 <20241105183041.1531976-2-harisokn@amazon.com>
	 <f46a71b5-8e0f-c2a9-b3f8-d499c10f227a@gentwo.org>
In-Reply-To: <f46a71b5-8e0f-c2a9-b3f8-d499c10f227a@gentwo.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <764253D7DEDA7049AEB8E76EECF8AB1B@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVHVlLCAyMDI0LTExLTA1IGF0IDExOjM2IC0wODAwLCBDaHJpc3RvcGggTGFtZXRlciAoQW1w
ZXJlKSB3cm90ZToNCj4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lk
ZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2ht
ZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRl
bnQgaXMgc2FmZS4NCj4gDQo+IA0KPiANCj4gT24gVHVlLCA1IE5vdiAyMDI0LCBIYXJpcyBPa2Fu
b3ZpYyB3cm90ZToNCj4gDQo+ID4gKy8qKg0KPiA+ICsgKiBzbXBfdmNvbmRfbG9hZF9yZWxheGVk
KCkgLSAoU3Bpbikgd2FpdCB1bnRpbCBhbiBleHBlY3RlZCB2YWx1ZSBhdCBhZGRyZXNzDQo+ID4g
KyAqIHdpdGggbm8gb3JkZXJpbmcgZ3VhcmFudGVlcy4gU3BpbnMgdW50aWwgYCgqYWRkciAmIG1h
c2spID09IHZhbGAgb3INCj4gPiArICogYG5zZWNzYCBlbGFwc2UsIGFuZCByZXR1cm5zIHRoZSBs
YXN0IG9ic2VydmVkIGAqYWRkcmAgdmFsdWUuDQo+ID4gKyAqDQo+ID4gKyAqIEBuc2VjczogdGlt
ZW91dCBpbiBuYW5vc2Vjb25kcw0KPiANCj4gUGxlYXNlIHVzZSBhbiBhYnNvbHV0ZSB0aW1lIGlu
IG5zZWNzIGluc3RlYWQgb2YgYSB0aW1lb3V0Lg0KDQpJIHdlbnQgd2l0aCByZWxhdGl2ZSB0aW1l
IGJlY2F1c2UgaXQgY2xvY2sgYWdub3N0aWMuIEkgYWdyZWUgZGVhZGxpbmUNCmlzIG5pY2VyIGJl
Y2F1c2UgaXQgY2FuIHByb3BhZ2F0ZSBkb3duIGxheWVycyBvZiBmdW5jdGlvbnMsIGJ1dCBpdCBw
aW5zDQp0aGUgY2FsbGVyIHRvIHNpbmdsZSB0aW1lIGJhc2UuDQoNCj4gWW91IGRvIG5vdCBrbm93
DQo+IHdoYXQgd2lsbCBoYXBwZW4gdG8geW91ciBleGVjdXRpb24gdGhyZWFkIHVudGlsIHRoZSBs
b2NhbF9jbG9ja19ub2luc3RyKCkNCj4gaXMgcnVuLg0KDQoNCk5vdCBzdXJlIHdoYXQgeW91IG1l
YW4uIENvdWxkIHlvdSBwZXJoYXBzIGdpdmUgYW4gZXhhbXBsZSB3aGVyZSBpdA0Kd291bGQgYnJl
YWs/DQoNCj4gDQo+IA0KDQpPbmUgYWx0ZXJuYXRpdmUgaXMgdG8gZG8gdGltZWtlZXBpbmcgd2l0
aCBkZWxheSgpIGluIGFsbCBjYXNlcywgdG8NCmRlY291cGxlIGZyb20gc2NoZWQvY2xvY2suDQoN
Cg==

