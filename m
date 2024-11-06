Return-Path: <kvm+bounces-31014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA2EC9BF477
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9105B1F246F9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E854C2071F9;
	Wed,  6 Nov 2024 17:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="MrkOjQe0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F342645;
	Wed,  6 Nov 2024 17:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730914985; cv=none; b=BtJN1xgT2ObCDK8et+IEjMAipKnRAwVl6ByHsuD3bu4Aye/8uJEslmWV1KCNWT58V0NEhTdIMkP5/nuIVHZSZ1PGHwghDCegdW9XVj+p2OiKwGoODwzaqwSt6U0NgaNUzv95skVaSqnamy4wiRFs64uDJT3KzaUCAL/BMVofreE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730914985; c=relaxed/simple;
	bh=W1X5rDQFCgExyY0Epc7bMWiWhw1daz1M7vG9x/tyeiI=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lALwwDEwYgGW+Z/3AQedUySX1kA2LAEgbFpUamjBL4fE8qKgnSr1PRq6K/RuHULG+QI+QFQ6D1kF+rQz8DRCUzG8ihyD2sSvl28XgZRzH4i6xRMJ/F2J+LRNjYuwvQ7zYzFFcVxH9lpKrLpQ1Dv/B5p2aoHmVE+OOcSpTdcTpR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=MrkOjQe0; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730914984; x=1762450984;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=W1X5rDQFCgExyY0Epc7bMWiWhw1daz1M7vG9x/tyeiI=;
  b=MrkOjQe0MisOUna8rEmX/60/hDiN0teAU8g0vK6d3Uk22qOq2NykLFfp
   da6hDQvJIC0oaJV7DjEy0yPgBHxPNAxbQR36RrlPyoHrPnEMzEfliAdUt
   lhM/p7E0Nz9jVLyxnid97W+vSr8bW0SVrJcy3NM/nQmj4wYB4urXZ07In
   U=;
X-IronPort-AV: E=Sophos;i="6.11,263,1725321600"; 
   d="scan'208";a="693553406"
Subject: Re: [PATCH 3/5] arm64: refactor delay() to enable polling for value
Thread-Topic: [PATCH 3/5] arm64: refactor delay() to enable polling for value
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 17:42:55 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.7.35:13502]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.1.168:2525] with esmtp (Farcaster)
 id 4ebbe4e2-78ed-4697-b2ed-e404fbebf4fe; Wed, 6 Nov 2024 17:42:39 +0000 (UTC)
X-Farcaster-Flow-ID: 4ebbe4e2-78ed-4697-b2ed-e404fbebf4fe
Received: from EX19D001UWA002.ant.amazon.com (10.13.138.236) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 6 Nov 2024 17:42:39 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA002.ant.amazon.com (10.13.138.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 6 Nov 2024 17:42:38 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.035; Wed, 6 Nov 2024 17:42:38 +0000
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
Thread-Index: AQHbL7EHko86fTfE7kuIbrTyhHlrvrKpFnIAgAFwtgA=
Date: Wed, 6 Nov 2024 17:42:38 +0000
Message-ID: <193a81555a87a6d499fbe889406eeb2014465ec5.camel@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
	 <20241105183041.1531976-1-harisokn@amazon.com>
	 <20241105183041.1531976-4-harisokn@amazon.com>
	 <efd92a03-f5a9-ba9b-338f-b9a5ad93174f@gentwo.org>
In-Reply-To: <efd92a03-f5a9-ba9b-338f-b9a5ad93174f@gentwo.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9E0998F1AEF2E4095A2603921A4002F@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVHVlLCAyMDI0LTExLTA1IGF0IDExOjQyIC0wODAwLCBDaHJpc3RvcGggTGFtZXRlciAoQW1w
ZXJlKSB3cm90ZToNCj4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lk
ZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2ht
ZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRl
bnQgaXMgc2FmZS4NCj4gDQo+IA0KPiANCj4gT24gVHVlLCA1IE5vdiAyMDI0LCBIYXJpcyBPa2Fu
b3ZpYyB3cm90ZToNCj4gDQo+ID4gLSNkZWZpbmUgVVNFQ1NfVE9fQ1lDTEVTKHRpbWVfdXNlY3Mp
ICAgICAgICAgICAgICAgICAgXA0KPiA+IC0gICAgIHhsb29wc190b19jeWNsZXMoKHRpbWVfdXNl
Y3MpICogMHgxMEM3VUwpDQo+ID4gLQ0KPiA+IC1zdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcg
eGxvb3BzX3RvX2N5Y2xlcyh1bnNpZ25lZCBsb25nIHhsb29wcykNCj4gPiArc3RhdGljIGlubGlu
ZSB1NjQgeGxvb3BzX3RvX2N5Y2xlcyh1NjQgeGxvb3BzKQ0KPiA+ICB7DQo+ID4gICAgICAgcmV0
dXJuICh4bG9vcHMgKiBsb29wc19wZXJfamlmZnkgKiBIWikgPj4gMzI7DQo+ID4gIH0NCj4gPiAN
Cj4gPiAtdm9pZCBfX2RlbGF5KHVuc2lnbmVkIGxvbmcgY3ljbGVzKQ0KPiA+ICsjZGVmaW5lIFVT
RUNTX1RPX1hMT09QUyh0aW1lX3VzZWNzKSBcDQo+ID4gKyAgICAgKCh0aW1lX3VzZWNzKSAqIDB4
MTBDN1VMKQ0KPiA+ICsNCj4gPiArI2RlZmluZSBVU0VDU19UT19DWUNMRVModGltZV91c2Vjcykg
XA0KPiA+ICsgICAgIHhsb29wc190b19jeWNsZXMoVVNFQ1NfVE9fWExPT1BTKHRpbWVfdXNlY3Mp
KQ0KPiA+ICsNCj4gDQo+IA0KPiA+ICsjZGVmaW5lIE5TRUNTX1RPX1hMT09QUyh0aW1lX25zZWNz
KSBcDQo+ID4gKyAgICAgKCh0aW1lX25zZWNzKSAqIDB4MTBDN1VMKQ0KPiANCj4gVGhlIGNvbnN0
YW50IGhlcmUgaXMgdGhlIHNhbWUgdmFsdWUgYXMgZm9yIG1pY3Jvc2Vjb25kcy4gSWYgSSByZW1l
bWJlcg0KPiBjb3JyZWN0bHkgaXRzIDVVTCBmb3IgbmFub3NlY29uZHMuDQo+IA0KDQpZb3UncmUg
cmlnaHQsIGdvb2QgY2F0Y2guIFNob3VsZCBiZSBgbnNlY3MgKiAweDVVTGAgcGVyIG9sZCBjb2Rl
Lg0KDQo=

