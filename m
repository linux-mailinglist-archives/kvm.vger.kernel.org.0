Return-Path: <kvm+bounces-13751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D83389A6BB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84C6D1F21F57
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 21:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4962C1791E1;
	Fri,  5 Apr 2024 21:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="hXluU3u3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1292A178CD9;
	Fri,  5 Apr 2024 21:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712353906; cv=none; b=B3qcisoZXMPhfXUpT6p56EEFrO3xV3ijvd9h/LJVFOhvSDRigwPvmXeRkYN1htT9lKK1H5stX4W+Gd29XMgc/TkksSRw+JY47VxmIroC3mtSqKUNYtXVzd7d1wMJhBafFxdUYQ7nLAxGxCZWKC8TudEoB/fFV+tcsDTce2krRow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712353906; c=relaxed/simple;
	bh=vNtahWUHoY/YLu4GXx/gtf+bHqqMSaubbSHgvz3384I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HtYnqMimxdg8pfoMOzQmrXG7bxf8gYedcIvcARXFipQzyLvn1Dp2ReP3LXEuelta0nCq3nbNLMECJUcX3OL81DKPsFAGpNb3jbTk2zmuewf14+wUd0D8i6wNFz0kOQy89zCVAN0ovDSQ5PMas8V0ze9MswI+wYa0o3rb0rclO2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=hXluU3u3; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1712353905; x=1743889905;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vNtahWUHoY/YLu4GXx/gtf+bHqqMSaubbSHgvz3384I=;
  b=hXluU3u3op4jgOXdkw5J+ObADwUp7wHZ6wTyh9Cr4MxIVTSOG6AeUtiS
   UCLRTGJT4u/uav8egsnRbcqU4Egw5sJPsrSdqnfIMweWtbMX4NfZAvpLt
   TulHDvsurdObAHfMqRDjltnG9ljLaVE9Lhp4kFaPBqgtuMZsGZnWbbfco
   0=;
X-IronPort-AV: E=Sophos;i="6.07,182,1708387200"; 
   d="scan'208";a="79148505"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 21:51:44 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.38.20:38255]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.222:2525] with esmtp (Farcaster)
 id 7e2f3bf9-2208-42a0-b475-dbe52d0ca4da; Fri, 5 Apr 2024 21:51:44 +0000 (UTC)
X-Farcaster-Flow-ID: 7e2f3bf9-2208-42a0-b475-dbe52d0ca4da
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Fri, 5 Apr 2024 21:51:44 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.28;
 Fri, 5 Apr 2024 21:51:43 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.028; Fri, 5 Apr 2024 21:51:43 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "mihai.carabas@oracle.com" <mihai.carabas@oracle.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "dianders@chromium.org" <dianders@chromium.org>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>, "mic@digikod.net"
	<mic@digikod.net>, "pmladek@suse.com" <pmladek@suse.com>,
	"wanpengli@tencent.com" <wanpengli@tencent.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"will@kernel.org" <will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "npiggin@gmail.com"
	<npiggin@gmail.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "rafael@kernel.org" <rafael@kernel.org>,
	"rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
	"juerg.haefliger@canonical.com" <juerg.haefliger@canonical.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Thread-Topic: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Thread-Index: AQHahgAj0rMfU3rQtUK6VuthoD2QJ7FaOuMA
Date: Fri, 5 Apr 2024 21:51:43 +0000
Message-ID: <7f3e540ad30f40ae51f1abda24b1bea2c8b648ea.camel@amazon.com>
References: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
	 <1707982910-27680-8-git-send-email-mihai.carabas@oracle.com>
In-Reply-To: <1707982910-27680-8-git-send-email-mihai.carabas@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <5085DAE90D860D488EC7F7953547FE48@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVGh1LCAyMDI0LTAyLTE1IGF0IDA5OjQxICswMjAwLCBNaWhhaSBDYXJhYmFzIHdyb3RlOg0K
PiBjcHVfcmVsYXggb24gQVJNNjQgZG9lcyBhIHNpbXBsZSAieWllbGQiLiBUaHVzIHdlIHJlcGxh
Y2UgaXQgd2l0aA0KPiBzbXBfY29uZF9sb2FkX3JlbGF4ZWQgd2hpY2ggYmFzaWNhbGx5IGRvZXMg
YSAid2ZlIi4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZy
YWRlYWQub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBNaWhhaSBDYXJhYmFzIDxtaWhhaS5jYXJhYmFz
QG9yYWNsZS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9jcHVpZGxlL3BvbGxfc3RhdGUuYyB8IDE1
ICsrKysrKysrKystLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDUg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVpZGxlL3BvbGxfc3Rh
dGUuYyBiL2RyaXZlcnMvY3B1aWRsZS9wb2xsX3N0YXRlLmMNCj4gaW5kZXggOWI2ZDkwYTcyNjAx
Li4xZTQ1YmU5MDZlNzIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3B1aWRsZS9wb2xsX3N0YXRl
LmMNCj4gKysrIGIvZHJpdmVycy9jcHVpZGxlL3BvbGxfc3RhdGUuYw0KPiBAQCAtMTMsNiArMTMs
NyBAQA0KPiAgc3RhdGljIGludCBfX2NwdWlkbGUgcG9sbF9pZGxlKHN0cnVjdCBjcHVpZGxlX2Rl
dmljZSAqZGV2LA0KPiAgCQkJICAgICAgIHN0cnVjdCBjcHVpZGxlX2RyaXZlciAqZHJ2LCBpbnQg
aW5kZXgpDQo+ICB7DQo+ICsJdW5zaWduZWQgbG9uZyByZXQ7DQo+ICAJdTY0IHRpbWVfc3RhcnQ7
DQo+ICANCj4gIAl0aW1lX3N0YXJ0ID0gbG9jYWxfY2xvY2tfbm9pbnN0cigpOw0KPiBAQCAtMjYs
MTIgKzI3LDE2IEBAIHN0YXRpYyBpbnQgX19jcHVpZGxlIHBvbGxfaWRsZShzdHJ1Y3QgY3B1aWRs
ZV9kZXZpY2UgKmRldiwNCj4gIA0KPiAgCQlsaW1pdCA9IGNwdWlkbGVfcG9sbF90aW1lKGRydiwg
ZGV2KTsNCj4gIA0KPiAtCQl3aGlsZSAoIW5lZWRfcmVzY2hlZCgpKSB7DQo+IC0JCQljcHVfcmVs
YXgoKTsNCj4gLQkJCWlmIChsb29wX2NvdW50KysgPCBQT0xMX0lETEVfUkVMQVhfQ09VTlQpDQo+
IC0JCQkJY29udGludWU7DQo+IC0NCj4gKwkJZm9yICg7Oykgew0KPiAgCQkJbG9vcF9jb3VudCA9
IDA7DQo+ICsNCj4gKwkJCXJldCA9IHNtcF9jb25kX2xvYWRfcmVsYXhlZCgmY3VycmVudF90aHJl
YWRfaW5mbygpLT5mbGFncywNCj4gKwkJCQkJCSAgICBWQUwgJiBfVElGX05FRURfUkVTQ0hFRCB8
fA0KPiArCQkJCQkJICAgIGxvb3BfY291bnQrKyA+PSBQT0xMX0lETEVfUkVMQVhfQ09VTlQpOw0K
DQpJcyBpdCBuZWNlc3NhcnkgdG8gcmVwZWF0IHRoaXMgMjAwIHRpbWVzIHdpdGggYSB3ZmUgcG9s
bD8gRG9lcyBrdm0gbm90DQppbXBsZW1lbnQgYSB0aW1lb3V0IHBlcmlvZD8NCg0KQ291bGQgeW91
IG1ha2UgaXQgY29uZmlndXJhYmxlPyBUaGlzIHBhdGNoIGltcHJvdmVzIGNlcnRhaW4gd29ya2xv
YWRzDQpvbiBBV1MgR3Jhdml0b24gaW5zdGFuY2VzIGFzIHdlbGwsIGJ1dCBibG9ja3MgdXAgdG8g
Nm1zIGluIDIwMCAqIDMwdXMNCmluY3JlbWVudHMgYmVmb3JlIGdvaW5nIHRvIHdmaSwgd2hpY2gg
aXMgYSBiaXQgZXhjZXNzaXZlLg0KDQo+ICsNCj4gKwkJCWlmICghKHJldCAmIF9USUZfTkVFRF9S
RVNDSEVEKSkNCj4gKwkJCQlicmVhazsNCj4gKw0KPiAgCQkJaWYgKGxvY2FsX2Nsb2NrX25vaW5z
dHIoKSAtIHRpbWVfc3RhcnQgPiBsaW1pdCkgew0KPiAgCQkJCWRldi0+cG9sbF90aW1lX2xpbWl0
ID0gdHJ1ZTsNCj4gIAkJCQlicmVhazsNCg0K

