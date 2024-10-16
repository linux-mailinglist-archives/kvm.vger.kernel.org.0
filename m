Return-Path: <kvm+bounces-29006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2179A0DCA
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 17:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EEC81F26AC3
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 15:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0ECC20F5CE;
	Wed, 16 Oct 2024 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="V4xFNbMf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3975120E01E;
	Wed, 16 Oct 2024 15:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729091619; cv=none; b=Ps186gYUk9cGD/3wdNyvy+F+TsmribsblcNKNPi1uVrDMKWlWMA5OF59+yfFQIjR7KwDS8N+QDthwLibuFo2pSw8pnleujyF5xgCutNolwK3QtzWXkVQSVk/sw+1DchWmOCRL5dN911Adrhd9qsLSmEfMen0+ZBMv3tmMYApZEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729091619; c=relaxed/simple;
	bh=RbNoppU1jJEGR3Vd1Y0PaSScVe5f5fou0RTSnQVa8/M=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PagRik3FkeWlRAk9/VB9sDwsewxXPkY6VrP99CaioYei3KnijVoWz6fh48IxLIrvKzQCtIgZUANyvoRIOOZvc5gPCrY0g6qrB9TKXg0qkASL6BNBOzxhu/pTJpVc5XiMcldQ+fStwUAN6ReSzKyKydLd2FMwxxvxKiSGKciE7+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=V4xFNbMf; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1729091618; x=1760627618;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=RbNoppU1jJEGR3Vd1Y0PaSScVe5f5fou0RTSnQVa8/M=;
  b=V4xFNbMfElfix0SDo2+HaEJDgXYviaSbCsM1FOl5fof/6Cr2LdmGHgM8
   nCklzKtmzUdSenryKb8uTe6kcfiaiZ/zXju11MLmmrtlC96LwTnng58SK
   9S772VxWW7Z1OaHlMBWi9SYJK1YxWzvimve1cXSVdyM9ktvizPPn4Zpid
   Y=;
X-IronPort-AV: E=Sophos;i="6.11,208,1725321600"; 
   d="scan'208";a="33725006"
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via smp_cond_load_relaxed()
Thread-Topic: [PATCH v8 01/11] cpuidle/poll_state: poll via smp_cond_load_relaxed()
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 15:13:35 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.38.20:30986]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.37.107:2525] with esmtp (Farcaster)
 id 6f9f4824-dc53-49cb-9ebc-0b9ca29d87dc; Wed, 16 Oct 2024 15:13:33 +0000 (UTC)
X-Farcaster-Flow-ID: 6f9f4824-dc53-49cb-9ebc-0b9ca29d87dc
Received: from EX19D001UWA004.ant.amazon.com (10.13.138.251) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 16 Oct 2024 15:13:33 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA004.ant.amazon.com (10.13.138.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 16 Oct 2024 15:13:33 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.035; Wed, 16 Oct 2024 15:13:33 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
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
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Okanovic, Haris"
	<harisokn@amazon.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mtosatti@redhat.com" <mtosatti@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>
Thread-Index: AQHbD6IrafcYoukOUEmO4vkMpFXSV7KH1W0AgAHHPIA=
Date: Wed, 16 Oct 2024 15:13:33 +0000
Message-ID: <7f7ffdcdb79eee0e8a545f544120495477832cd5.camel@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
	 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
	 <Zw5aPAuVi5sxdN5-@arm.com>
In-Reply-To: <Zw5aPAuVi5sxdN5-@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <33D05FD08416A74EA8AC33C9DA3B4688@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVHVlLCAyMDI0LTEwLTE1IGF0IDEzOjA0ICswMTAwLCBDYXRhbGluIE1hcmluYXMgd3JvdGU6
DQo+IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9y
Z2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUu
DQo+IA0KPiANCj4gDQo+IE9uIFdlZCwgU2VwIDI1LCAyMDI0IGF0IDA0OjI0OjE1UE0gLTA3MDAs
IEFua3VyIEFyb3JhIHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWlkbGUvcG9s
bF9zdGF0ZS5jIGIvZHJpdmVycy9jcHVpZGxlL3BvbGxfc3RhdGUuYw0KPiA+IGluZGV4IDliNmQ5
MGE3MjYwMS4uZmMxMjA0NDI2MTU4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvY3B1aWRsZS9w
b2xsX3N0YXRlLmMNCj4gPiArKysgYi9kcml2ZXJzL2NwdWlkbGUvcG9sbF9zdGF0ZS5jDQo+ID4g
QEAgLTIxLDIxICsyMSwyMCBAQCBzdGF0aWMgaW50IF9fY3B1aWRsZSBwb2xsX2lkbGUoc3RydWN0
IGNwdWlkbGVfZGV2aWNlICpkZXYsDQo+ID4gDQo+ID4gICAgICAgcmF3X2xvY2FsX2lycV9lbmFi
bGUoKTsNCj4gPiAgICAgICBpZiAoIWN1cnJlbnRfc2V0X3BvbGxpbmdfYW5kX3Rlc3QoKSkgew0K
PiA+IC0gICAgICAgICAgICAgdW5zaWduZWQgaW50IGxvb3BfY291bnQgPSAwOw0KPiA+ICAgICAg
ICAgICAgICAgdTY0IGxpbWl0Ow0KPiA+IA0KPiA+ICAgICAgICAgICAgICAgbGltaXQgPSBjcHVp
ZGxlX3BvbGxfdGltZShkcnYsIGRldik7DQo+ID4gDQo+ID4gICAgICAgICAgICAgICB3aGlsZSAo
IW5lZWRfcmVzY2hlZCgpKSB7DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgIGNwdV9yZWxheCgp
Ow0KPiA+IC0gICAgICAgICAgICAgICAgICAgICBpZiAobG9vcF9jb3VudCsrIDwgUE9MTF9JRExF
X1JFTEFYX0NPVU5UKQ0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVl
Ow0KPiA+IC0NCj4gPiAtICAgICAgICAgICAgICAgICAgICAgbG9vcF9jb3VudCA9IDA7DQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCBsb29wX2NvdW50ID0gMDsNCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgaWYgKGxvY2FsX2Nsb2NrX25vaW5zdHIoKSAtIHRpbWVfc3Rh
cnQgPiBsaW1pdCkgew0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRldi0+cG9s
bF90aW1lX2xpbWl0ID0gdHJ1ZTsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBi
cmVhazsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+ICsNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgc21wX2NvbmRfbG9hZF9yZWxheGVkKCZjdXJyZW50X3RocmVhZF9pbmZvKCkt
PmZsYWdzLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
VkFMICYgX1RJRl9ORUVEX1JFU0NIRUQgfHwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGxvb3BfY291bnQrKyA+PSBQT0xMX0lETEVfUkVMQVhfQ09VTlQp
Ow0KPiANCj4gVGhlIGFib3ZlIGlzIG5vdCBndWFyYW50ZWVkIHRvIG1ha2UgcHJvZ3Jlc3MgaWYg
X1RJRl9ORUVEX1JFU0NIRUQgaXMNCj4gbmV2ZXIgc2V0LiBXaXRoIHRoZSBldmVudCBzdHJlYW0g
ZW5hYmxlZCBvbiBhcm02NCwgdGhlIFdGRSB3aWxsDQo+IGV2ZW50dWFsbHkgYmUgd29rZW4gdXAs
IGxvb3BfY291bnQgaW5jcmVtZW50ZWQgYW5kIHRoZSBjb25kaXRpb24gd291bGQNCj4gYmVjb21l
IHRydWUuIEhvd2V2ZXIsIHRoZSBzbXBfY29uZF9sb2FkX3JlbGF4ZWQoKSBzZW1hbnRpY3MgcmVx
dWlyZSB0aGF0DQo+IGEgZGlmZmVyZW50IGFnZW50IHVwZGF0ZXMgdGhlIHZhcmlhYmxlIGJlaW5n
IHdhaXRlZCBvbiwgbm90IHRoZSB3YWl0aW5nDQo+IENQVSB1cGRhdGluZyBpdCBpdHNlbGYuIEFs
c28gbm90ZSB0aGF0IHRoZSBldmVudCBzdHJlYW0gY2FuIGJlIGRpc2FibGVkDQo+IG9uIGFybTY0
IG9uIHRoZSBrZXJuZWwgY29tbWFuZCBsaW5lLg0KDQpBbHRlcm5hdGVseSBjb3VsZCB3ZSBjb25k
aXRpb24gYXJjaF9oYWx0cG9sbF93YW50KCkgb24NCmFyY2hfdGltZXJfZXZ0c3RybV9hdmFpbGFi
bGUoKSwgbGlrZSB2Nz8NCg0KPiANCj4gRG9lcyB0aGUgY29kZSBhYm92ZSBicmVhayBhbnkgb3Ro
ZXIgYXJjaGl0ZWN0dXJlPyBJJ2Qgc2F5IGlmIHlvdSB3YW50DQo+IHNvbWV0aGluZyBsaWtlIHRo
aXMsIGJldHRlciBpbnRyb2R1Y2UgYSBuZXcgc21wX2NvbmRfbG9hZF90aW1lb3V0KCkNCj4gQVBJ
LiBUaGUgYWJvdmUgbG9va3MgbGlrZSBhIGhhY2sgdGhhdCBtYXkgb25seSB3b3JrIG9uIGFybTY0
IHdoZW4gdGhlDQo+IGV2ZW50IHN0cmVhbSBpcyBlbmFibGVkLg0KPiANCj4gQSBnZW5lcmljIG9w
dGlvbiBpcyB1ZGVsYXkoKSAob24gYXJtNjQgaXQgd291bGQgdXNlIFdGRS9XRkVUIGJ5DQo+IGRl
ZmF1bHQpLiBOb3Qgc3VyZSBob3cgaW1wb3J0YW50IGl0IGlzIGZvciBwb2xsX2lkbGUoKSBidXQg
dGhlIGRvd25zaWRlDQo+IG9mIHVkZWxheSgpIHRoYXQgaXQgd29uJ3QgYmUgYWJsZSB0byBhbHNv
IHBvbGwgbmVlZF9yZXNjaGVkKCkgd2hpbGUNCj4gd2FpdGluZyBmb3IgdGhlIHRpbWVvdXQuIElm
IHRoaXMgbWF0dGVycywgeW91IGNvdWxkIGluc3RlYWQgbWFrZSBzbWFsbGVyDQo+IHVkZWxheSgp
IGNhbGxzLiBZZXQgYW5vdGhlciBwcm9ibGVtLCBJIGRvbid0IGtub3cgaG93IGVuZXJneSBlZmZp
Y2llbnQNCj4gdWRlbGF5KCkgaXMgb24geDg2IHZzIGNwdV9yZWxheCgpLg0KPiANCj4gU28gbWF5
YmUgYW4gc21wX2NvbmRfbG9hZF90aW1lb3V0KCkgd291bGQgYmUgYmV0dGVyLCBpbXBsZW1lbnRl
ZCB3aXRoDQo+IGNwdV9yZWxheCgpIGdlbmVyaWNhbGx5IGFuZCB0aGUgYXJtNjQgd291bGQgdXNl
IExEWFIsIFdGRSBhbmQgcmVseSBvbg0KPiB0aGUgZXZlbnQgc3RyZWFtIChvciBmYWxsIGJhY2sg
dG8gY3B1X3JlbGF4KCkgaWYgdGhlIGV2ZW50IHN0cmVhbSBpcw0KPiBkaXNhYmxlZCkuDQo+IA0K
PiAtLQ0KPiBDYXRhbGluDQoNCg==

