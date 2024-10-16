Return-Path: <kvm+bounces-29005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C8D9A0DBE
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 17:13:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 660EC1F26ABB
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 15:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C08220E033;
	Wed, 16 Oct 2024 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="DdLhM13F"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF4F208203;
	Wed, 16 Oct 2024 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729091593; cv=none; b=CAIpbnEOpnGI+yPhQ0VhytuAd5qf1kwQCjn78cPcJ8sio/IyFtbQoOXbzF1GdUBkY5A7IR4edoykzbr0eIyKBr62SVv114qjox2NyaRVu3nkJ+1IHvX+ywphrpP8rFSA6QwdlJifw4KLSQaNGfShj/0NcLmo8Ybn1EeIs85NCA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729091593; c=relaxed/simple;
	bh=ERhlpQaFwpkWoGeJkFjW0T4n9IKqDDaynh+59lad5oQ=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tTgpupNuTcEoUToXV0JDEPwP/e2P7JRGg6tV1Tc5oZitkTL6oBruXNTWR5Cuhnp2bRi5NjFfj6ynm6jmbXVcoIYnqOz7mb/zEp9lYP7ZlXpHTFYL5RMYArI8uYUmPZHaZsbmazNaiH0uIl1lcIxdNf12IUVNuH7hnB8/+Nj+HPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=DdLhM13F; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1729091591; x=1760627591;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=ERhlpQaFwpkWoGeJkFjW0T4n9IKqDDaynh+59lad5oQ=;
  b=DdLhM13FkGqOVFXyOC8ACfy5BxmUv3lHZfiaRn2sqVQAU0mYXLRV7C3a
   tRBB8cm8BKfIvc98IQeLJtqkh48UXRowbwrPBf7hqJVegZkbBttBzlHpq
   lkJSQTEocgvzVBvvfobd1eBDwMJ7YK5uAyprZCeCWa4hnMcg4/y1IN6a5
   k=;
X-IronPort-AV: E=Sophos;i="6.11,208,1725321600"; 
   d="scan'208";a="239787056"
Subject: Re: [PATCH v8 11/11] arm64: support cpuidle-haltpoll
Thread-Topic: [PATCH v8 11/11] arm64: support cpuidle-haltpoll
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 15:13:08 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.38.20:51905]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.26:2525] with esmtp (Farcaster)
 id 62707680-f669-4d2a-9301-1ba89e47a75d; Wed, 16 Oct 2024 15:13:07 +0000 (UTC)
X-Farcaster-Flow-ID: 62707680-f669-4d2a-9301-1ba89e47a75d
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 16 Oct 2024 15:13:07 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 16 Oct 2024 15:13:07 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.035; Wed, 16 Oct 2024 15:13:07 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "wanpengli@tencent.com"
	<wanpengli@tencent.com>, "cl@gentwo.org" <cl@gentwo.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "misono.tomohiro@fujitsu.com"
	<misono.tomohiro@fujitsu.com>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"Okanovic, Haris" <harisokn@amazon.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>, "x86@kernel.org"
	<x86@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>
Thread-Index: AQHbD6I089E42RUrU0+2nrqNuvMS6LKJnIiA
Date: Wed, 16 Oct 2024 15:13:06 +0000
Message-ID: <01eef9aa44810e63f630de10e20902b0d3115ee0.camel@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
	 <20240925232425.2763385-12-ankur.a.arora@oracle.com>
In-Reply-To: <20240925232425.2763385-12-ankur.a.arora@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <C90BC314EE720149A3B3172E85F4A3AD@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTA5LTI1IGF0IDE2OjI0IC0wNzAwLCBBbmt1ciBBcm9yYSB3cm90ZToNCj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiANCj4gQWRkIGFyY2hpdGVjdHVyYWwgc3VwcG9ydCBmb3IgdGhlIGNwdWlkbGUtaGFs
dHBvbGwgZHJpdmVyIGJ5IGRlZmluaW5nDQo+IGFyY2hfaGFsdHBvbGxfKigpLiBBbHNvIGRlZmlu
ZSBBUkNIX0NQVUlETEVfSEFMVFBPTEwgdG8gYWxsb3cNCj4gY3B1aWRsZS1oYWx0cG9sbCB0byBi
ZSBzZWxlY3RlZC4NCj4gDQo+IEhhbHRwb2xsIHVzZXMgcG9sbF9pZGxlKCkgdG8gZG8gdGhlIGFj
dHVhbCBwb2xsaW5nLiBUaGlzIGluIHR1cm4NCj4gdXNlcyBzbXBfY29uZF9sb2FkKigpIHRvIHdh
aXQgdW50aWwgdGhlcmUncyBhIHNwZWNpZmljIHN0b3JlIHRvDQo+IGEgY2FjaGVsaW5lLg0KPiBJ
biB0aGUgZWRnZSBjYXNlIC0tIG5vIHN0b3JlcyB0byB0aGUgY2FjaGVsaW5lIGFuZCBubyBpbnRl
cnJ1cHQgLS0NCj4gdGhlIGV2ZW50LXN0cmVhbSBwcm92aWRlcyB0aGUgdGVybWluYXRpbmcgY29u
ZGl0aW9uIGVuc3VyaW5nIHdlDQo+IGRvbid0IHdhaXQgZm9yZXZlci4gQnV0IGJlY2F1c2UgdGhl
IGV2ZW50LXN0cmVhbSBydW5zIGF0IGEgZml4ZWQNCj4gZnJlcXVlbmN5IChjb25maWd1cmVkIGF0
IDEwa0h6KSBoYWx0cG9sbCBtaWdodCBzcGVuZCBtb3JlIHRpbWUgaW4NCj4gdGhlIHBvbGxpbmcg
c3RhZ2UgdGhhbiBzcGVjaWZpZWQgYnkgY3B1aWRsZV9wb2xsX3RpbWUoKS4NCj4gDQo+IFRoaXMg
d291bGQgb25seSBoYXBwZW4gaW4gdGhlIGxhc3QgaXRlcmF0aW9uLCBzaW5jZSBvdmVyc2hvb3Rp
bmcgdGhlDQo+IHBvbGxfbGltaXQgbWVhbnMgdGhlIGdvdmVybm9yIHdpbGwgbW92ZSBvdXQgb2Yg
dGhlIHBvbGxpbmcgc3RhZ2UuDQo+IA0KPiBUZXN0ZWQtYnk6IEhhcmlzIE9rYW5vdmljIDxoYXJp
c29rbkBhbWF6b24uY29tPg0KPiBUZXN0ZWQtYnk6IE1pc29ubyBUb21vaGlybyA8bWlzb25vLnRv
bW9oaXJvQGZ1aml0c3UuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbmt1ciBBcm9yYSA8YW5rdXIu
YS5hcm9yYUBvcmFjbGUuY29tPg0KPiAtLS0NCj4gIGFyY2gvYXJtNjQvS2NvbmZpZyAgICAgICAg
ICAgICAgICAgICAgICAgIHwgIDYgKysrKysrDQo+ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2Nw
dWlkbGVfaGFsdHBvbGwuaCB8IDI0ICsrKysrKysrKysrKysrKysrKysrKysrDQo+ICAyIGZpbGVz
IGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKykNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL2NwdWlkbGVfaGFsdHBvbGwuaA0KPiANCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvYXJtNjQvS2NvbmZpZyBiL2FyY2gvYXJtNjQvS2NvbmZpZw0KPiBpbmRleCBlZjljMjJjM2Nm
ZjIuLjVmYzk5ZWJhMjJiMiAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9LY29uZmlnDQo+ICsr
KyBiL2FyY2gvYXJtNjQvS2NvbmZpZw0KPiBAQCAtMjQxNSw2ICsyNDE1LDEyIEBAIGNvbmZpZyBB
UkNIX0hJQkVSTkFUSU9OX0hFQURFUg0KPiAgY29uZmlnIEFSQ0hfU1VTUEVORF9QT1NTSUJMRQ0K
PiAgICAgICAgIGRlZl9ib29sIHkNCj4gDQo+ICtjb25maWcgQVJDSF9DUFVJRExFX0hBTFRQT0xM
DQo+ICsgICAgICAgYm9vbCAiRW5hYmxlIHNlbGVjdGlvbiBvZiB0aGUgY3B1aWRsZS1oYWx0cG9s
bCBkcml2ZXIiDQo+ICsgICAgICAgaGVscA0KPiArICAgICAgICAgY3B1aWRsZS1oYWx0cG9sbCBh
bGxvd3MgZm9yIGFkYXB0aXZlIHBvbGxpbmcgYmFzZWQgb24NCj4gKyAgICAgICAgIGN1cnJlbnQg
bG9hZCBiZWZvcmUgZW50ZXJpbmcgdGhlIGlkbGUgc3RhdGUuDQo+ICsNCj4gIGVuZG1lbnUgIyAi
UG93ZXIgbWFuYWdlbWVudCBvcHRpb25zIg0KPiANCj4gIG1lbnUgIkNQVSBQb3dlciBNYW5hZ2Vt
ZW50Ig0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9jcHVpZGxlX2hhbHRw
b2xsLmggYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2NwdWlkbGVfaGFsdHBvbGwuaA0KPiBuZXcg
ZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAuLjkxZjBiZTcwNzYyOQ0KPiAt
LS0gL2Rldi9udWxsDQo+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1aWRsZV9oYWx0
cG9sbC5oDQo+IEBAIC0wLDAgKzEsMjQgQEANCj4gKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wICovDQo+ICsNCj4gKyNpZm5kZWYgX0FSQ0hfSEFMVFBPTExfSA0KPiArI2RlZmlu
ZSBfQVJDSF9IQUxUUE9MTF9IDQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgdm9pZCBhcmNoX2hhbHRw
b2xsX2VuYWJsZSh1bnNpZ25lZCBpbnQgY3B1KSB7IH0NCj4gK3N0YXRpYyBpbmxpbmUgdm9pZCBh
cmNoX2hhbHRwb2xsX2Rpc2FibGUodW5zaWduZWQgaW50IGNwdSkgeyB9DQo+ICsNCj4gK3N0YXRp
YyBpbmxpbmUgYm9vbCBhcmNoX2hhbHRwb2xsX3dhbnQoYm9vbCBmb3JjZSkNCj4gK3sNCj4gKyAg
ICAgICAvKg0KPiArICAgICAgICAqIEVuYWJsaW5nIGhhbHRwb2xsIHJlcXVpcmVzIHR3byB0aGlu
Z3M6DQo+ICsgICAgICAgICoNCj4gKyAgICAgICAgKiAtIEV2ZW50IHN0cmVhbSBzdXBwb3J0IHRv
IHByb3ZpZGUgYSB0ZXJtaW5hdGluZyBjb25kaXRpb24gdG8gdGhlDQo+ICsgICAgICAgICogICBX
RkUgaW4gdGhlIHBvbGwgbG9vcC4NCg0KSSBtaXNzZWQgdGhpcyBlYXJsaWVyOiBXaHkgZGlkIHlv
dSBkcm9wIGFyY2hfdGltZXJfZXZ0c3RybV9hdmFpbGFibGUoKT8NCg0KPiArICAgICAgICAqDQo+
ICsgICAgICAgICogLSBLVk0gc3VwcG9ydCBmb3IgYXJjaF9oYWx0cG9sbF9lbmFibGUoKSwgYXJj
aF9oYWx0cG9sbF9kaXNhYmxlKCkuDQo+ICsgICAgICAgICoNCj4gKyAgICAgICAgKiBHaXZlbiB0
aGF0IHRoZSBzZWNvbmQgaXMgbWlzc2luZywgb25seSBhbGxvdyBmb3JjZSBsb2FkaW5nIGZvcg0K
PiArICAgICAgICAqIGhhbHRwb2xsLg0KPiArICAgICAgICAqLw0KPiArICAgICAgIHJldHVybiBm
b3JjZTsNCj4gK30NCj4gKyNlbmRpZg0KPiAtLQ0KPiAyLjQzLjUNCj4gDQoNCg==

