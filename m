Return-Path: <kvm+bounces-31012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A33F9BF469
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:39:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BFE31F24588
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFEC12076AA;
	Wed,  6 Nov 2024 17:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="goHplJ1v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA972645;
	Wed,  6 Nov 2024 17:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730914752; cv=none; b=o9GI02wt5YMMU/xKHAxip8dAc66CNNTC7LfjEo7SchU2vbbrxaL3dEnpFUXv/efqexni/6RiaSRsts4PYtaHpU22KIeVINxFYYix4M9h4CgGSFkWZmbrOOLKpuH0gMz5CWoKJt32S1v73+DyeKlNHh5bo4+YBwH/UfCz4EectbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730914752; c=relaxed/simple;
	bh=8kci1woKxcuU8zna+ejYhzw1IeAp8nkCktOAQyR/1z4=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tMxTR8WfbOrcNe5nbyp0bGCkblp51LhBzyWT7fo3rO6azYv5dYHKWK0S8F6nSYbslxzWs+CPjDdcRg1KDiBsNkvc4fv0+dFiXqSbwOI9lFV1ddOFrOtLtyEdV8188kBf9VC0MDH3zZQss7HOxJZxjS5NQ4MuARIlN44y1d9TXKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=goHplJ1v; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730914751; x=1762450751;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=8kci1woKxcuU8zna+ejYhzw1IeAp8nkCktOAQyR/1z4=;
  b=goHplJ1vHtk4J5thQAY76l+kVeOcEExVUDsKNhywS6NfoEp7K1LIhUaC
   wTHIaDr7PKJxP3+Wgxj6ZnBknL8C5cGRC+V5rtAC9IU+Bxk1YCqaWrmWU
   agyhRTnNWXVgUrB4NYJZEOgGmUVyGDkDpEOTF9W3RrsggrfIrw8AH75v4
   g=;
X-IronPort-AV: E=Sophos;i="6.11,263,1725321600"; 
   d="scan'208";a="382940829"
Subject: Re: [PATCH 3/5] arm64: refactor delay() to enable polling for value
Thread-Topic: [PATCH 3/5] arm64: refactor delay() to enable polling for value
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 17:39:10 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.21.151:14779]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.195:2525] with esmtp (Farcaster)
 id 0e147bef-d664-4db1-81e7-192215fe6e62; Wed, 6 Nov 2024 17:38:55 +0000 (UTC)
X-Farcaster-Flow-ID: 0e147bef-d664-4db1-81e7-192215fe6e62
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 6 Nov 2024 17:38:55 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 6 Nov 2024 17:38:55 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.035; Wed, 6 Nov 2024 17:38:55 +0000
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
Thread-Index: AQHbL7EHko86fTfE7kuIbrTyhHlrvrKp+i8AgACL7gA=
Date: Wed, 6 Nov 2024 17:38:55 +0000
Message-ID: <3156dcdbddc9b1f692bc45adba0893bcc9b58035.camel@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
	 <20241105183041.1531976-1-harisokn@amazon.com>
	 <20241105183041.1531976-4-harisokn@amazon.com> <Zys0TAHZzqbGst93@arm.com>
In-Reply-To: <Zys0TAHZzqbGst93@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA38280D1CE6BB43BA5C6CB9D142F899@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTExLTA2IGF0IDA5OjE4ICswMDAwLCBDYXRhbGluIE1hcmluYXMgd3JvdGU6
DQo+IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9y
Z2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUu
DQo+IA0KPiANCj4gDQo+IE9uIFR1ZSwgTm92IDA1LCAyMDI0IGF0IDEyOjMwOjM5UE0gLTA2MDAs
IEhhcmlzIE9rYW5vdmljIHdyb3RlOg0KPiA+ICsgICAgICAgICAgICAgZG8gew0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICBjdXIgPSBfX1JFQURfT05DRV9FWCgqYWRkcik7DQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgIGlmICgoY3VyICYgbWFzaykgPT0gdmFsKSB7DQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIH0N
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgd2ZldChlbmQpOw0KPiANCj4gQ29uc3RydWN0cyBs
aWtlIHRoaXMgbmVlZCB0byBiZSBlbnRpcmVseSBpbiBhc3NlbWJseS4gVGhlIGNvbXBpbGVyIG1h
eQ0KPiBzcGlsbCAnY3VyJyBvbnRvIHRoZSBzdGFjayBhbmQgdGhlIHdyaXRlIGNvdWxkIGNsZWFy
IHRoZSBleGNsdXNpdmUNCj4gbW9uaXRvciB3aGljaCBtYWtlcyB0aGUgd2ZldCByZXR1cm4gaW1t
ZWRpYXRlbHkuIFRoYXQncyBoaWdobHkgQ1BVDQo+IGltcGxlbWVudGF0aW9uIHNwZWNpZmljIGJ1
dCBpdCdzIHRoZSByZWFzb24gd2UgaGF2ZSBmdW5jdGlvbnMgbGlrZQ0KPiBfX2NtcHdhaXQoKSBp
biBhc3NlbWJseSAob3Igd2hhdGV2ZXIgZWxzZSBkZWFscyB3aXRoIGV4Y2x1c2l2ZXMpLiBJT1cs
DQo+IHdlIGNhbid0IGhhdmUgb3RoZXIgbWVtb3J5IGFjY2Vzc2VzIGJldHdlZW4gdGhlIExEWFIg
YW5kIHdoYXRldmVyIGlzDQo+IGNvbnN1bWluZyB0aGUgZXhjbHVzaXZlIG1vbml0b3IgYXJtZWQg
c3RhdGUgKHR5cGljYWxseSBTVFhSIGJ1dCBXRkUvV0ZFVA0KPiBjYW4gYmUgYW5vdGhlcikuDQoN
CkFncmVlZCwgd2lsbCByZXdyaXRlIHBhcnRzIG9mIGRlbGF5KCkgaW4gYXNtLg0KDQo+IA0KPiAt
LQ0KPiBDYXRhbGluDQoNCg==

