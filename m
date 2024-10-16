Return-Path: <kvm+bounces-29025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE29E9A1133
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 20:05:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E00251C20CE6
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B65D6212EF9;
	Wed, 16 Oct 2024 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="ca3EDRxR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F58E14A09E;
	Wed, 16 Oct 2024 18:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101888; cv=none; b=aPDa8CgmyBunvXi3NybNO6mHo6WWaMVx+pTxRI65cVfoNzJW/S4Oj90KNUQF/zxsj6BF2eHqTOpbSjS3GfEqVVog+S8DjEyp6SUdW5mTxs0ybTteYvB2K6AEB5MVu4epLOuKluOty1T/L+l+NjUssIXwVqqGAAsJnmD5LHFC8yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101888; c=relaxed/simple;
	bh=3SwVYbFol5wtjFCHhhGi1RnZJPVNjLTg+Hl+nxFfvos=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rgsoq/Ud2wdj6G+GIRs/QrBucCwqAu1NnLoSdIuN+YdoranC2oXy57zHi4pYnB9smDoZqQEkINV+BcAheNwfPm0jSBCjPcyxiqO8/6Qt9B2EM3V39qhydo0QQs3LebMPtQznxRPRQEC20NExXv23JDX8Xzg4f4oKHQ6WduzIkbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=ca3EDRxR; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1729101887; x=1760637887;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=3SwVYbFol5wtjFCHhhGi1RnZJPVNjLTg+Hl+nxFfvos=;
  b=ca3EDRxRHZyrlI0mlzha2Rob/oCFGgWogXDeIfPVIiCDCfFK0rRHTt5S
   S2ETmd3/XdjsOUP/1M5b2Z2JLIXCHUPVBzn3dkhunHU7fvTbb/RuxUljz
   K1pMqsUlikXmmZL+TGzTiyX/6aBVjcxYb3dKPl3WD4WVr3k7TmGHVYsKb
   0=;
X-IronPort-AV: E=Sophos;i="6.11,208,1725321600"; 
   d="scan'208";a="461374783"
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via smp_cond_load_relaxed()
Thread-Topic: [PATCH v8 01/11] cpuidle/poll_state: poll via smp_cond_load_relaxed()
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 18:04:46 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.7.35:53735]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.7.250:2525] with esmtp (Farcaster)
 id 41eded31-3b27-4e62-b809-d97a7328555c; Wed, 16 Oct 2024 18:04:46 +0000 (UTC)
X-Farcaster-Flow-ID: 41eded31-3b27-4e62-b809-d97a7328555c
Received: from EX19D001UWA004.ant.amazon.com (10.13.138.251) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 16 Oct 2024 18:04:45 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA004.ant.amazon.com (10.13.138.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 16 Oct 2024 18:04:45 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.035; Wed, 16 Oct 2024 18:04:45 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mtosatti@redhat.com"
	<mtosatti@redhat.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "cl@gentwo.org"
	<cl@gentwo.org>, "wanpengli@tencent.com" <wanpengli@tencent.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "misono.tomohiro@fujitsu.com"
	<misono.tomohiro@fujitsu.com>, "arnd@arndb.de" <arnd@arndb.de>,
	"will@kernel.org" <will@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"sudeep.holla@arm.com" <sudeep.holla@arm.com>, "Okanovic, Haris"
	<harisokn@amazon.com>, "rafael@kernel.org" <rafael@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>
Thread-Index: AQHbD6IrafcYoukOUEmO4vkMpFXSV7KH1W0AgAHHPICAAB7zgIAAEOEA
Date: Wed, 16 Oct 2024 18:04:45 +0000
Message-ID: <d468117895b5a14b7ff30de7fd4da3edbf1a6b73.camel@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
	 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
	 <Zw5aPAuVi5sxdN5-@arm.com>
	 <7f7ffdcdb79eee0e8a545f544120495477832cd5.camel@amazon.com>
	 <87wmi8ou7g.fsf@oracle.com>
In-Reply-To: <87wmi8ou7g.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6D0E47BE666414CB400B6DA09E84439@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTEwLTE2IGF0IDEwOjA0IC0wNzAwLCBBbmt1ciBBcm9yYSB3cm90ZToNCj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiANCj4gT2thbm92aWMsIEhhcmlzIDxoYXJpc29rbkBhbWF6b24uY29tPiB3cml0ZXM6
DQo+IA0KPiA+IE9uIFR1ZSwgMjAyNC0xMC0xNSBhdCAxMzowNCArMDEwMCwgQ2F0YWxpbiBNYXJp
bmFzIHdyb3RlOg0KPiA+ID4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0
c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNv
bnRlbnQgaXMgc2FmZS4NCj4gPiA+IA0KPiA+ID4gDQo+ID4gPiANCj4gPiA+IE9uIFdlZCwgU2Vw
IDI1LCAyMDI0IGF0IDA0OjI0OjE1UE0gLTA3MDAsIEFua3VyIEFyb3JhIHdyb3RlOg0KPiA+ID4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVpZGxlL3BvbGxfc3RhdGUuYyBiL2RyaXZlcnMvY3B1
aWRsZS9wb2xsX3N0YXRlLmMNCj4gPiA+ID4gaW5kZXggOWI2ZDkwYTcyNjAxLi5mYzEyMDQ0MjYx
NTggMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2RyaXZlcnMvY3B1aWRsZS9wb2xsX3N0YXRlLmMNCj4g
PiA+ID4gKysrIGIvZHJpdmVycy9jcHVpZGxlL3BvbGxfc3RhdGUuYw0KPiA+ID4gPiBAQCAtMjEs
MjEgKzIxLDIwIEBAIHN0YXRpYyBpbnQgX19jcHVpZGxlIHBvbGxfaWRsZShzdHJ1Y3QgY3B1aWRs
ZV9kZXZpY2UgKmRldiwNCj4gPiA+ID4gDQo+ID4gPiA+ICAgICAgIHJhd19sb2NhbF9pcnFfZW5h
YmxlKCk7DQo+ID4gPiA+ICAgICAgIGlmICghY3VycmVudF9zZXRfcG9sbGluZ19hbmRfdGVzdCgp
KSB7DQo+ID4gPiA+IC0gICAgICAgICAgICAgdW5zaWduZWQgaW50IGxvb3BfY291bnQgPSAwOw0K
PiA+ID4gPiAgICAgICAgICAgICAgIHU2NCBsaW1pdDsNCj4gPiA+ID4gDQo+ID4gPiA+ICAgICAg
ICAgICAgICAgbGltaXQgPSBjcHVpZGxlX3BvbGxfdGltZShkcnYsIGRldik7DQo+ID4gPiA+IA0K
PiA+ID4gPiAgICAgICAgICAgICAgIHdoaWxlICghbmVlZF9yZXNjaGVkKCkpIHsNCj4gPiA+ID4g
LSAgICAgICAgICAgICAgICAgICAgIGNwdV9yZWxheCgpOw0KPiA+ID4gPiAtICAgICAgICAgICAg
ICAgICAgICAgaWYgKGxvb3BfY291bnQrKyA8IFBPTExfSURMRV9SRUxBWF9DT1VOVCkNCj4gPiA+
ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+ID4gPiA+IC0NCj4g
PiA+ID4gLSAgICAgICAgICAgICAgICAgICAgIGxvb3BfY291bnQgPSAwOw0KPiA+ID4gPiArICAg
ICAgICAgICAgICAgICAgICAgdW5zaWduZWQgaW50IGxvb3BfY291bnQgPSAwOw0KPiA+ID4gPiAg
ICAgICAgICAgICAgICAgICAgICAgaWYgKGxvY2FsX2Nsb2NrX25vaW5zdHIoKSAtIHRpbWVfc3Rh
cnQgPiBsaW1pdCkgew0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXYt
PnBvbGxfdGltZV9saW1pdCA9IHRydWU7DQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGJyZWFrOw0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+ID4gPiAr
DQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICBzbXBfY29uZF9sb2FkX3JlbGF4ZWQoJmN1
cnJlbnRfdGhyZWFkX2luZm8oKS0+ZmxhZ3MsDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgVkFMICYgX1RJRl9ORUVEX1JFU0NIRUQgfHwNCj4gPiA+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb29wX2NvdW50
KysgPj0gUE9MTF9JRExFX1JFTEFYX0NPVU5UKTsNCj4gPiA+IA0KPiA+ID4gVGhlIGFib3ZlIGlz
IG5vdCBndWFyYW50ZWVkIHRvIG1ha2UgcHJvZ3Jlc3MgaWYgX1RJRl9ORUVEX1JFU0NIRUQgaXMN
Cj4gPiA+IG5ldmVyIHNldC4gV2l0aCB0aGUgZXZlbnQgc3RyZWFtIGVuYWJsZWQgb24gYXJtNjQs
IHRoZSBXRkUgd2lsbA0KPiA+ID4gZXZlbnR1YWxseSBiZSB3b2tlbiB1cCwgbG9vcF9jb3VudCBp
bmNyZW1lbnRlZCBhbmQgdGhlIGNvbmRpdGlvbiB3b3VsZA0KPiA+ID4gYmVjb21lIHRydWUuIEhv
d2V2ZXIsIHRoZSBzbXBfY29uZF9sb2FkX3JlbGF4ZWQoKSBzZW1hbnRpY3MgcmVxdWlyZSB0aGF0
DQo+ID4gPiBhIGRpZmZlcmVudCBhZ2VudCB1cGRhdGVzIHRoZSB2YXJpYWJsZSBiZWluZyB3YWl0
ZWQgb24sIG5vdCB0aGUgd2FpdGluZw0KPiA+ID4gQ1BVIHVwZGF0aW5nIGl0IGl0c2VsZi4gQWxz
byBub3RlIHRoYXQgdGhlIGV2ZW50IHN0cmVhbSBjYW4gYmUgZGlzYWJsZWQNCj4gPiA+IG9uIGFy
bTY0IG9uIHRoZSBrZXJuZWwgY29tbWFuZCBsaW5lLg0KPiA+IA0KPiA+IEFsdGVybmF0ZWx5IGNv
dWxkIHdlIGNvbmRpdGlvbiBhcmNoX2hhbHRwb2xsX3dhbnQoKSBvbg0KPiA+IGFyY2hfdGltZXJf
ZXZ0c3RybV9hdmFpbGFibGUoKSwgbGlrZSB2Nz8NCj4gDQo+IFllcywgSSdtIHRoaW5raW5nIG9m
IHN0YWdpbmcgaXQgc29tZXdoYXQgbGlrZSB0aGF0LiBGaXJzdCBhbg0KPiBzbXBfY29uZF9sb2Fk
X3JlbGF4ZWQoKSB3aGljaCBnZXRzIHJpZCBvZiB0aGlzIGlzc3VlLCBmb2xsb3dlZCBieQ0KPiBv
bmUgYmFzZWQgb24gc21wX2NvbmRfbG9hZF9yZWxheGVkX3RpbWVvdXQoKS4NCj4gDQo+IFRoYXQg
c2FpZCwgY29uZGl0aW9uaW5nIGp1c3QgYXJjaF9oYWx0cG9sbF93YW50KCkgd29uJ3Qgc3VmZmlj
ZSBzaW5jZQ0KPiB3aGF0IENhdGFsaW4gcG9pbnRlZCBvdXQgYWZmZWN0cyBhbGwgdXNlcnMgb2Yg
cG9sbF9pZGxlKCksIG5vdCBqdXN0DQo+IGhhbHRwb2xsLg0KDQpUaGUgb25seSBvdGhlciB1c2Vy
cyBJIHNlZSB0b2RheSBhcmUgYXBtX2luaXQoKSBhbmQNCmFjcGlfcHJvY2Vzc29yX3NldHVwX2Nz
dGF0ZXMoKSwgYm90aCBpbiB4ODYgcGF0aC4gUGVyaGFwcyBub3QgaWRlYWwsDQpidXQgc2hvdWxk
IGJlIHN1ZmZpY2llbnQuDQoNCj4gDQo+IFJpZ2h0IG5vdyB0aGVyZSdzIG9ubHkgaGFsdHBvbGwg
YnV0IHRoZXJlIGFyZSBmdXR1cmUgdXNlcnMgbGlrZQ0KPiB6aGVuZ2xpZmVuZyB3aXRoIGEgcGF0
Y2ggZm9yIGFjcGktaWRsZSBoZXJlOg0KPiANCj4gICBodHRwczovL2xvcmUua2VybmVsLm9yZy9h
bGwvZjhhMWY4NWItYzRiZi00YzM4LTgxYmYtNzI4ZjcyYTRmMmZlQGh1YXdlaS5jb20vDQo+IA0K
PiA+ID4gRG9lcyB0aGUgY29kZSBhYm92ZSBicmVhayBhbnkgb3RoZXIgYXJjaGl0ZWN0dXJlPyBJ
J2Qgc2F5IGlmIHlvdSB3YW50DQo+ID4gPiBzb21ldGhpbmcgbGlrZSB0aGlzLCBiZXR0ZXIgaW50
cm9kdWNlIGEgbmV3IHNtcF9jb25kX2xvYWRfdGltZW91dCgpDQo+ID4gPiBBUEkuIFRoZSBhYm92
ZSBsb29rcyBsaWtlIGEgaGFjayB0aGF0IG1heSBvbmx5IHdvcmsgb24gYXJtNjQgd2hlbiB0aGUN
Cj4gPiA+IGV2ZW50IHN0cmVhbSBpcyBlbmFibGVkLg0KPiA+ID4gDQo+ID4gPiBBIGdlbmVyaWMg
b3B0aW9uIGlzIHVkZWxheSgpIChvbiBhcm02NCBpdCB3b3VsZCB1c2UgV0ZFL1dGRVQgYnkNCj4g
PiA+IGRlZmF1bHQpLiBOb3Qgc3VyZSBob3cgaW1wb3J0YW50IGl0IGlzIGZvciBwb2xsX2lkbGUo
KSBidXQgdGhlIGRvd25zaWRlDQo+ID4gPiBvZiB1ZGVsYXkoKSB0aGF0IGl0IHdvbid0IGJlIGFi
bGUgdG8gYWxzbyBwb2xsIG5lZWRfcmVzY2hlZCgpIHdoaWxlDQo+ID4gPiB3YWl0aW5nIGZvciB0
aGUgdGltZW91dC4gSWYgdGhpcyBtYXR0ZXJzLCB5b3UgY291bGQgaW5zdGVhZCBtYWtlIHNtYWxs
ZXINCj4gPiA+IHVkZWxheSgpIGNhbGxzLiBZZXQgYW5vdGhlciBwcm9ibGVtLCBJIGRvbid0IGtu
b3cgaG93IGVuZXJneSBlZmZpY2llbnQNCj4gPiA+IHVkZWxheSgpIGlzIG9uIHg4NiB2cyBjcHVf
cmVsYXgoKS4NCj4gPiA+IA0KPiA+ID4gU28gbWF5YmUgYW4gc21wX2NvbmRfbG9hZF90aW1lb3V0
KCkgd291bGQgYmUgYmV0dGVyLCBpbXBsZW1lbnRlZCB3aXRoDQo+ID4gPiBjcHVfcmVsYXgoKSBn
ZW5lcmljYWxseSBhbmQgdGhlIGFybTY0IHdvdWxkIHVzZSBMRFhSLCBXRkUgYW5kIHJlbHkgb24N
Cj4gPiA+IHRoZSBldmVudCBzdHJlYW0gKG9yIGZhbGwgYmFjayB0byBjcHVfcmVsYXgoKSBpZiB0
aGUgZXZlbnQgc3RyZWFtIGlzDQo+ID4gPiBkaXNhYmxlZCkuDQo+ID4gPiANCj4gPiA+IC0tDQo+
ID4gPiBDYXRhbGluDQo+IA0KPiANCj4gLS0NCj4gYW5rdXINCg0K

