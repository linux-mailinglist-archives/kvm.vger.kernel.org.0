Return-Path: <kvm+bounces-13812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0791A89ACA8
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 20:43:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C5561C21514
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 18:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874874CB38;
	Sat,  6 Apr 2024 18:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="AXFowvsX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247C1481DE;
	Sat,  6 Apr 2024 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712428969; cv=none; b=oGdrBOfvfoHrUxQKjRYlj5//LQYpqSH7ahLdPmlpBSWA2cyusaRxCi4oj5WncNATIhaiyTnll3tSBgpgwRhY3iEhocGRp/6ONQTv3uF7AdXKKXbabyvAw6OvHoGdcU4t1CWV2x6dPVQ66h4K6xarRTLT8izxo/tdgomYq7ycJhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712428969; c=relaxed/simple;
	bh=gLAVxu8KHoNgflhSP1o9Xg0UT8ODjoT8j/oAbHJfQyY=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nnRE5Yx42gS6oD4aavqLRz2FPIC4C8DxdimeVgDpCoWdokRmhgrrmJSZPtt0OikFTT3H7wHqInPaw9iCc9V5boGSNGo3ptIOlTpac6x8tkPWBs5F6INsGsOMlz+TjzcQFzZkhVpH4YyhuosgU5+qssyuLACLMTItxlPfcK8UpTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=AXFowvsX; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1712428968; x=1743964968;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=gLAVxu8KHoNgflhSP1o9Xg0UT8ODjoT8j/oAbHJfQyY=;
  b=AXFowvsXjdHFudvWM38zlB5m+zS/zqhI1vtrMXDf/MAw0pz+MrVCQGrO
   4KOQN3LB1f6jz0Z7yoYAG+DKZ2LhkAf/G9Two682d1VTTwQFK3yL3uc69
   ol91uHWSFdP+TkKr/FB+XK+mhDCPfoItw9BKLtupgaSFaRy7HdLNFP3aF
   8=;
X-IronPort-AV: E=Sophos;i="6.07,183,1708387200"; 
   d="scan'208";a="337396067"
Subject: Re: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Thread-Topic: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 18:42:43 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.7.35:27027]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.59.87:2525] with esmtp (Farcaster)
 id 4f2e5d76-4265-43aa-8207-7fa4ea3e82a5; Sat, 6 Apr 2024 18:42:42 +0000 (UTC)
X-Farcaster-Flow-ID: 4f2e5d76-4265-43aa-8207-7fa4ea3e82a5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Sat, 6 Apr 2024 18:42:39 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.28;
 Sat, 6 Apr 2024 18:42:38 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.028; Sat, 6 Apr 2024 18:42:38 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dianders@chromium.org"
	<dianders@chromium.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "pmladek@suse.com"
	<pmladek@suse.com>, "wanpengli@tencent.com" <wanpengli@tencent.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "mihai.carabas@oracle.com"
	<mihai.carabas@oracle.com>, "arnd@arndb.de" <arnd@arndb.de>,
	"will@kernel.org" <will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "mic@digikod.net"
	<mic@digikod.net>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "npiggin@gmail.com" <npiggin@gmail.com>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "juerg.haefliger@canonical.com"
	<juerg.haefliger@canonical.com>, "x86@kernel.org" <x86@kernel.org>,
	"rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>
Thread-Index: AQHahgAj0rMfU3rQtUK6VuthoD2QJ7FaOuMAgAAXOYCAAUWwAA==
Date: Sat, 6 Apr 2024 18:42:38 +0000
Message-ID: <aada0beae0b3479bfa311eea94a3b595bb8e5835.camel@amazon.com>
References: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
	 <1707982910-27680-8-git-send-email-mihai.carabas@oracle.com>
	 <7f3e540ad30f40ae51f1abda24b1bea2c8b648ea.camel@amazon.com>
	 <87r0fjtn9y.fsf@oracle.com>
In-Reply-To: <87r0fjtn9y.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF6AE65E0E8B0C4199A2083815D37F12@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI0LTA0LTA1IGF0IDE2OjE0IC0wNzAwLCBBbmt1ciBBcm9yYSB3cm90ZToNCj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiANCj4gT2thbm92aWMsIEhhcmlzIDxoYXJpc29rbkBhbWF6b24uY29tPiB3cml0ZXM6
DQo+IA0KPiA+IE9uIFRodSwgMjAyNC0wMi0xNSBhdCAwOTo0MSArMDIwMCwgTWloYWkgQ2FyYWJh
cyB3cm90ZToNCj4gPiA+IGNwdV9yZWxheCBvbiBBUk02NCBkb2VzIGEgc2ltcGxlICJ5aWVsZCIu
IFRodXMgd2UgcmVwbGFjZSBpdCB3aXRoDQo+ID4gPiBzbXBfY29uZF9sb2FkX3JlbGF4ZWQgd2hp
Y2ggYmFzaWNhbGx5IGRvZXMgYSAid2ZlIi4NCj4gPiA+IA0KPiA+ID4gU3VnZ2VzdGVkLWJ5OiBQ
ZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5
OiBNaWhhaSBDYXJhYmFzIDxtaWhhaS5jYXJhYmFzQG9yYWNsZS5jb20+DQo+ID4gPiAtLS0NCj4g
PiA+ICBkcml2ZXJzL2NwdWlkbGUvcG9sbF9zdGF0ZS5jIHwgMTUgKysrKysrKysrKy0tLS0tDQo+
ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+
ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWlkbGUvcG9sbF9zdGF0ZS5jIGIv
ZHJpdmVycy9jcHVpZGxlL3BvbGxfc3RhdGUuYw0KPiA+ID4gaW5kZXggOWI2ZDkwYTcyNjAxLi4x
ZTQ1YmU5MDZlNzIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL2NwdWlkbGUvcG9sbF9zdGF0
ZS5jDQo+ID4gPiArKysgYi9kcml2ZXJzL2NwdWlkbGUvcG9sbF9zdGF0ZS5jDQo+ID4gPiBAQCAt
MTMsNiArMTMsNyBAQA0KPiA+ID4gIHN0YXRpYyBpbnQgX19jcHVpZGxlIHBvbGxfaWRsZShzdHJ1
Y3QgY3B1aWRsZV9kZXZpY2UgKmRldiwNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBzdHJ1Y3QgY3B1aWRsZV9kcml2ZXIgKmRydiwgaW50IGluZGV4KQ0KPiA+ID4gIHsNCj4gPiA+
ICsgICAgdW5zaWduZWQgbG9uZyByZXQ7DQo+ID4gPiAgICAgIHU2NCB0aW1lX3N0YXJ0Ow0KPiA+
ID4gDQo+ID4gPiAgICAgIHRpbWVfc3RhcnQgPSBsb2NhbF9jbG9ja19ub2luc3RyKCk7DQo+ID4g
PiBAQCAtMjYsMTIgKzI3LDE2IEBAIHN0YXRpYyBpbnQgX19jcHVpZGxlIHBvbGxfaWRsZShzdHJ1
Y3QgY3B1aWRsZV9kZXZpY2UgKmRldiwNCj4gPiA+IA0KPiA+ID4gICAgICAgICAgICAgIGxpbWl0
ID0gY3B1aWRsZV9wb2xsX3RpbWUoZHJ2LCBkZXYpOw0KPiA+ID4gDQo+ID4gPiAtICAgICAgICAg
ICAgd2hpbGUgKCFuZWVkX3Jlc2NoZWQoKSkgew0KPiA+ID4gLSAgICAgICAgICAgICAgICAgICAg
Y3B1X3JlbGF4KCk7DQo+ID4gPiAtICAgICAgICAgICAgICAgICAgICBpZiAobG9vcF9jb3VudCsr
IDwgUE9MTF9JRExFX1JFTEFYX0NPVU5UKQ0KPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBjb250aW51ZTsNCj4gPiA+IC0NCj4gPiA+ICsgICAgICAgICAgICBmb3IgKDs7KSB7DQo+
ID4gPiAgICAgICAgICAgICAgICAgICAgICBsb29wX2NvdW50ID0gMDsNCj4gPiA+ICsNCj4gPiA+
ICsgICAgICAgICAgICAgICAgICAgIHJldCA9IHNtcF9jb25kX2xvYWRfcmVsYXhlZCgmY3VycmVu
dF90aHJlYWRfaW5mbygpLT5mbGFncywNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBWQUwgJiBfVElGX05FRURfUkVTQ0hFRCB8fA0KPiA+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxvb3BfY291
bnQrKyA+PSBQT0xMX0lETEVfUkVMQVhfQ09VTlQpOw0KPiA+IA0KPiA+IElzIGl0IG5lY2Vzc2Fy
eSB0byByZXBlYXQgdGhpcyAyMDAgdGltZXMgd2l0aCBhIHdmZSBwb2xsPw0KPiANCj4gVGhlIFBP
TExfSURMRV9SRUxBWF9DT1VOVCBpcyB0aGVyZSBiZWNhdXNlIG9uIHg4NiBlYWNoIGNwdV9yZWxh
eCgpDQo+IGl0ZXJhdGlvbiBpcyBtdWNoIHNob3J0ZXIuDQo+IA0KPiBXaXRoIFdGRSwgaXQgbWFr
ZXMgbGVzcyBzZW5zZS4NCj4gDQo+ID4gRG9lcyBrdm0gbm90IGltcGxlbWVudCBhIHRpbWVvdXQg
cGVyaW9kPw0KPiANCj4gTm90IHlldCwgYnV0IGl0IGRvZXMgYmVjb21lIG1vcmUgdXNlZnVsIGFm
dGVyIGEgV0ZFIGhhbHRwb2xsIGlzDQo+IGF2YWlsYWJsZSBvbiBBUk02NC4NCg0KTm90ZSB0aGF0
IGt2bSBjb25kaXRpb25hbGx5IHRyYXBzIFdGRSBhbmQgV0ZJIGJhc2VkIG9uIG51bWJlciBvZiBo
b3N0DQpDUFUgdGFza3MuIFZNcyB3aWxsIHNvbWV0aW1lcyBzZWUgaGFyZHdhcmUgYmVoYXZpb3Ig
LSBwb3RlbnRpYWxseQ0KcG9sbGluZyBmb3IgYSBsb25nIHRpbWUgYmVmb3JlIGVudGVyaW5nIFdG
SS4NCg0KaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvbGF0ZXN0L3NvdXJjZS9hcmNo
L2FybTY0L2t2bS9hcm0uYyNMNDU5DQoNCj4gDQo+IEhhbHRwb2xsIGRvZXMgaGF2ZSBhIHRpbWVv
dXQsIHdoaWNoIHlvdSBzaG91bGQgYmUgYWJsZSB0byB0dW5lIHZpYQ0KPiAvc3lzL21vZHVsZS9o
YWx0cG9sbC9wYXJhbWV0ZXJzLyBidXQgdGhhdCwgb2YgY291cnNlLCB3b24ndCBoZWxwIGhlcmUu
DQo+IA0KPiA+IENvdWxkIHlvdSBtYWtlIGl0IGNvbmZpZ3VyYWJsZT8gVGhpcyBwYXRjaCBpbXBy
b3ZlcyBjZXJ0YWluIHdvcmtsb2Fkcw0KPiA+IG9uIEFXUyBHcmF2aXRvbiBpbnN0YW5jZXMgYXMg
d2VsbCwgYnV0IGJsb2NrcyB1cCB0byA2bXMgaW4gMjAwICogMzB1cw0KPiA+IGluY3JlbWVudHMg
YmVmb3JlIGdvaW5nIHRvIHdmaSwgd2hpY2ggaXMgYSBiaXQgZXhjZXNzaXZlLg0KPiANCj4gWWVh
aCwgdGhpcyBsb29rcyBsaWtlIGEgcHJvYmxlbS4gV2UgY291bGQgc29sdmUgaXQgYnkgbWFraW5n
IGl0IGFuDQo+IGFyY2hpdGVjdHVyYWwgcGFyYW1ldGVyLiBUaG91Z2ggSSB3b3JyeSBhYm91dCBB
Uk0gcGxhdGZvcm1zIHdpdGgNCj4gbXVjaCBzbWFsbGVyIGRlZmF1bHQgdGltZW91dHMuDQo+IFRo
ZSBvdGhlciBwb3NzaWJpbGl0eSBpcyB1c2luZyBXRkVUIGluIHRoZSBwcmltaXRpdmUsIGJ1dCB0
aGVuIHdlDQo+IGhhdmUgdGhhdCBkZXBlbmRlbmN5IGFuZCB0aGF0J3MgYSBiaWdnZXIgY2hhbmdl
Lg0KDQpTZWUgYXJtNjQncyBkZWxheSgpIGZvciBpbnNwaXJhdGlvbjoNCg0KaHR0cHM6Ly9lbGl4
aXIuYm9vdGxpbi5jb20vbGludXgvdjYuOS1yYzIvc291cmNlL2FyY2gvYXJtNjQvbGliL2RlbGF5
LmMjTDI2DQoNCj4gDQo+IFdpbGwgYWRkcmVzcyB0aGlzIGluIHRoZSBuZXh0IHZlcnNpb24uDQo+
IA0KPiBUaGFua3MgZm9yIHBvaW50aW5nIHRoaXMgb3V0Lg0KPiANCj4gLS0NCj4gYW5rdXINCg0K

