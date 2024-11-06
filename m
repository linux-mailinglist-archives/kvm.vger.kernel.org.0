Return-Path: <kvm+bounces-31009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2781F9BF406
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C82AB24AA9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F0D206948;
	Wed,  6 Nov 2024 17:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="RCBd1X61"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD85720605D;
	Wed,  6 Nov 2024 17:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730912990; cv=none; b=ZHRG70xibUCMJtoV1YFyx+XNGuFoEesqLPsrxXB/nBHvJGDHK5c96QNhG/VLMEYdfEAWFethAgyJpLqcDquK+WUCLNcVsmnOWePcTbbMfpsqNhB9wK3b2m90v+bwsVIxSZEy4OzbouwGTZEvtzq430voK85yiegVsZJOIfSAKJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730912990; c=relaxed/simple;
	bh=IIMXLu0XRvZ+8U+JOvjW7CrjFM8KZSomWoMTCbipas4=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ooVZVUcJDadLpnXWvyxZ1ZY3jrejM5O/vVkd1tO0L5hM2Wt4Um/x3s90MjiVOljPJABCC3SKXgqLZCbcFM6bO3PrTsdrAs5ez6u6vobh2zULOuW/DixCRMao8FIUJ1eI8VNwhAQ6jRuDYqRmx86i8sHNh+9w08+BDtv8QYMfNB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=RCBd1X61; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730912988; x=1762448988;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=IIMXLu0XRvZ+8U+JOvjW7CrjFM8KZSomWoMTCbipas4=;
  b=RCBd1X61b8JpgA4cwj8XdHvDdy2W3PSdL+V7QTESKmGk/XW75SYd5t6D
   D8NvYqKn/jVxhaNZP2AOGo8x1xNR+dgpOZ6Js0hidQgyWWMuZDoAV7uTv
   A43hKM2FzRYeqWxgD5i4YO8qPR1YDMH16adcJZ4xpfv78rXfHJZbZuZ4t
   M=;
X-IronPort-AV: E=Sophos;i="6.11,263,1725321600"; 
   d="scan'208";a="144914788"
Subject: Re: [PATCH 2/5] arm64: add __READ_ONCE_EX()
Thread-Topic: [PATCH 2/5] arm64: add __READ_ONCE_EX()
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 17:09:48 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:6315]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.28.15:2525] with esmtp (Farcaster)
 id 20bcd19b-d844-41e7-b076-f7b9146dfb37; Wed, 6 Nov 2024 17:09:47 +0000 (UTC)
X-Farcaster-Flow-ID: 20bcd19b-d844-41e7-b076-f7b9146dfb37
Received: from EX19D001UWA002.ant.amazon.com (10.13.138.236) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 6 Nov 2024 17:09:46 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA002.ant.amazon.com (10.13.138.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 6 Nov 2024 17:09:45 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.035; Wed, 6 Nov 2024 17:09:45 +0000
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
Thread-Index: AQHbL7D9P6U0yGi3sU+ODiwZGjE2xLKqIrGAgABbR4A=
Date: Wed, 6 Nov 2024 17:09:45 +0000
Message-ID: <53b33d48c81b35bb3567ab19308f309b0f320e6a.camel@amazon.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
	 <20241105183041.1531976-1-harisokn@amazon.com>
	 <20241105183041.1531976-3-harisokn@amazon.com>
	 <20241106114302.GB13801@willie-the-truck>
In-Reply-To: <20241106114302.GB13801@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1BFC01D4A71E44A8101937144D111AF@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTExLTA2IGF0IDExOjQzICswMDAwLCBXaWxsIERlYWNvbiB3cm90ZToNCj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiANCj4gT24gVHVlLCBOb3YgMDUsIDIwMjQgYXQgMTI6MzA6MzhQTSAtMDYwMCwgSGFy
aXMgT2thbm92aWMgd3JvdGU6DQo+ID4gUGVyZm9ybSBhbiBleGNsdXNpdmUgbG9hZCwgd2hpY2gg
YXRvbWljYWxseSBsb2FkcyBhIHdvcmQgYW5kIGFybXMgdGhlDQo+ID4gZXhjbHVzaXZlIG1vbml0
b3IgdG8gZW5hYmxlIHdmZXQoKS93ZmUoKSBhY2NlbGVyYXRlZCBwb2xsaW5nLg0KPiA+IA0KPiA+
IGh0dHBzOi8vZGV2ZWxvcGVyLmFybS5jb20vZG9jdW1lbnRhdGlvbi9kaHQwMDA4L2EvYXJtLXN5
bmNocm9uaXphdGlvbi1wcmltaXRpdmVzL2V4Y2x1c2l2ZS1hY2Nlc3Nlcy9leGNsdXNpdmUtbW9u
aXRvcnMNCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBIYXJpcyBPa2Fub3ZpYyA8aGFyaXNva25A
YW1hem9uLmNvbT4NCj4gPiAtLS0NCj4gPiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9yZWFkZXgu
aCB8IDQ2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgNDYgaW5zZXJ0aW9ucygrKQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9yZWFkZXguaA0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0
L2luY2x1ZGUvYXNtL3JlYWRleC5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9yZWFkZXguaA0K
PiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi41MTk2M2Mz
MTA3ZTENCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS9yZWFkZXguaA0KPiA+IEBAIC0wLDAgKzEsNDYgQEANCj4gPiArLyogU1BEWC1MaWNlbnNlLUlk
ZW50aWZpZXI6IEdQTC0yLjAgKi8NCj4gPiArLyoNCj4gPiArICogQmFzZWQgb24gYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9yd29uY2UuaA0KPiA+ICsgKg0KPiA+ICsgKiBDb3B5cmlnaHQgKEMpIDIw
MjAgR29vZ2xlIExMQy4NCj4gPiArICogQ29weXJpZ2h0IChDKSAyMDI0IEFtYXpvbi5jb20sIElu
Yy4gb3IgaXRzIGFmZmlsaWF0ZXMuDQo+ID4gKyAqLw0KPiA+ICsNCj4gPiArI2lmbmRlZiBfX0FT
TV9SRUFERVhfSA0KPiA+ICsjZGVmaW5lIF9fQVNNX1JFQURFWF9IDQo+ID4gKw0KPiA+ICsjZGVm
aW5lIF9fTE9BRF9FWChzZngsIHJlZ3MuLi4pICJsZGF4ciIgI3NmeCAiXHQiICNyZWdzDQo+ID4g
Kw0KPiA+ICsjZGVmaW5lIF9fUkVBRF9PTkNFX0VYKHgpICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyh7ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiArICAgICB0eXBl
b2YoJih4KSkgX194ID0gJih4KTsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgXA0KPiA+ICsgICAgIGludCBhdG9taWMgPSAxOyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAgICAgdW5pb24geyBfX3VucXVhbF9zY2Fs
YXJfdHlwZW9mKCpfX3gpIF9fdmFsOyBjaGFyIF9fY1sxXTsgfSBfX3U7IFwNCj4gPiArICAgICBz
d2l0Y2ggKHNpemVvZih4KSkgeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgXA0KPiA+ICsgICAgIGNhc2UgMTogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAgICAgICAgICAgICBhc20gdm9sYXRp
bGUoX19MT0FEX0VYKGIsICV3MCwgJTEpICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgOiAiPXIiICgqKF9fdTggKilfX3UuX19jKSAgICAgICAgICAgICAg
ICAgICAgICAgXA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICA6ICJRIiAoKl9feCkgOiAibWVt
b3J5Iik7ICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAgICAgICAgICAgICBicmVhazsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiAr
ICAgICBjYXNlIDI6ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgXA0KPiA+ICsgICAgICAgICAgICAgYXNtIHZvbGF0aWxlKF9fTE9BRF9FWCho
LCAldzAsICUxKSAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgIDogIj1yIiAoKihfX3UxNiAqKV9fdS5fX2MpICAgICAgICAgICAgICAgICAgICAgIFwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgOiAiUSIgKCpfX3gpIDogIm1lbW9yeSIpOyAgICAgICAg
ICAgICAgICAgICAgICAgXA0KPiA+ICsgICAgICAgICAgICAgYnJlYWs7ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAgICAgY2FzZSA0OiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwN
Cj4gPiArICAgICAgICAgICAgIGFzbSB2b2xhdGlsZShfX0xPQURfRVgoLCAldzAsICUxKSAgICAg
ICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICA6ICI9ciIgKCoo
X191MzIgKilfX3UuX19jKSAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgIDogIlEiICgqX194KSA6ICJtZW1vcnkiKTsgICAgICAgICAgICAgICAgICAgICAg
IFwNCj4gPiArICAgICAgICAgICAgIGJyZWFrOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAgIGNhc2UgODogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAgICAgICAg
ICAgICBhc20gdm9sYXRpbGUoX19MT0FEX0VYKCwgJTAsICUxKSAgICAgICAgICAgICAgICAgICAg
ICAgIFwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgOiAiPXIiICgqKF9fdTY0ICopX191Ll9f
YykgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICA6ICJR
IiAoKl9feCkgOiAibWVtb3J5Iik7ICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAgICAg
ICAgICAgICBicmVhazsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIFwNCj4gPiArICAgICBkZWZhdWx0OiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAgICAgICAgICAgYXRvbWljID0g
MDsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAg
ICAgfSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIFwNCj4gPiArICAgICBhdG9taWMgPyAodHlwZW9mKCpfX3gpKV9fdS5fX3ZhbCA6
ICgqKHZvbGF0aWxlIHR5cGVvZihfX3gpKV9feCk7XA0KPiA+ICt9KQ0KPiANCj4gSSB0aGluayB0
aGlzIGlzIGEgYmFkIGlkZWEuIExvYWQtZXhjbHVzaXZlIG5lZWRzIHRvIGJlIHVzZWQgdmVyeSBj
YXJlZnVsbHksDQo+IHByZWZlcmFibHkgd2hlbiB5b3UncmUgYWJsZSB0byBzZWUgZXhhY3RseSB3
aGF0IGluc3RydWN0aW9ucyBpdCdzDQo+IGludGVyYWN0aW5nIHdpdGguIEJ5IG1ha2luZyB0aGlz
IGludG8gYSBtYWNybywgd2UncmUgYXQgdGhlIG1lcmN5IG9mIHRoZQ0KPiBjb21waWxlciBhbmQg
d2UgZ2l2ZSB0aGUgd3JvbmcgaW1wcmVzc2lvbiB0aGF0IHlvdSBjb3VsZCBlLmcuIGJ1aWxkIGF0
b21pYw0KPiBjcml0aWNhbCBzZWN0aW9ucyBvdXQgb2YgdGhpcyBtYWNyby4NCj4gDQo+IFNvIEkn
bSBmYWlybHkgc3Ryb25nbHkgYWdhaW5zdCB0aGlzIGludGVyZmFjZS4NCg0KRmFpciBwb2ludC4g
SSdsbCBwb3N0IGFuIGFsdGVybmF0ZSBkZWxheSgpIGltcGxlbWVudGF0aW9uIGluIGFzbS4gSXQn
cw0KYSBzaW1wbGUgcm91dGluZS4NCg0KPiANCj4gV2lsbA0KDQo=

