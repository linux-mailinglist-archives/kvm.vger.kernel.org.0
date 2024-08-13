Return-Path: <kvm+bounces-24022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 31123950903
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 925A8B2587A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 742331A0701;
	Tue, 13 Aug 2024 15:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="br6V0BHU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D499B1991BE;
	Tue, 13 Aug 2024 15:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723562777; cv=none; b=fie3bN/PcDTW1Nlwf2jg6zJKU6/nWQ+9FTfvelfY1bdmooo/SWWyPiYUSh9KS//7D0Y0R8Sz+xZiXQ4u9AcgJryDH9kVj18HJfafmpCJNdewT0Y+Lulx/aEKGeObfxJQqUkVKWCFO7ot8jc5XS+hvoJ9l4gdIZ/PcpQqRnmyPhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723562777; c=relaxed/simple;
	bh=/hMt4SvjZSqfHxfRtii8cHre8n+msWXRYZNv7+c628w=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sUZH7TcETmUZ0sC1I5KNcQqQEGia06KrmrxIfFCM1ugPfZa6FDnk6eM6CY7Y32RbNPplPpFi17Rf7qVCwgY0LSN+nRLa4WsallJvVGnTc3OxzkPTp5j7QQfSLAcRlCylL8BOa8pHVxQq4/fy0A5j7C1/dN27ods01I1hhvCEJxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=br6V0BHU; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1723562777; x=1755098777;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=/hMt4SvjZSqfHxfRtii8cHre8n+msWXRYZNv7+c628w=;
  b=br6V0BHUmQq3bEEOmuzXTKORk0NV38M/JYFGs+nAA2fCz03PL6/oNF7d
   XoZ6iePfrcmlOfScVBOmqmFcTsHMXrUPRGOihntUvFMgeTrsPBMe4D5BR
   vieZxOvvdXcjUlvxWQwF/detLGihFw0AygUYXYM29/KBuG2ChYDTdq8Am
   E=;
X-IronPort-AV: E=Sophos;i="6.09,286,1716249600"; 
   d="scan'208";a="652312371"
Subject: Re: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
Thread-Topic: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 15:26:14 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.7.35:20665]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.24:2525] with esmtp (Farcaster)
 id 96bd94f0-695e-4804-9fe5-4063d2b6ecde; Tue, 13 Aug 2024 15:26:12 +0000 (UTC)
X-Farcaster-Flow-ID: 96bd94f0-695e-4804-9fe5-4063d2b6ecde
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 13 Aug 2024 15:26:12 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA003.ant.amazon.com (10.13.138.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 13 Aug 2024 15:26:12 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.034; Tue, 13 Aug 2024 15:26:12 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "wanpengli@tencent.com"
	<wanpengli@tencent.com>, "cl@gentwo.org" <cl@gentwo.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "misono.tomohiro@fujitsu.com"
	<misono.tomohiro@fujitsu.com>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Okanovic, Haris"
	<harisokn@amazon.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mtosatti@redhat.com" <mtosatti@redhat.com>,
	"rafael@kernel.org" <rafael@kernel.org>, "sudeep.holla@arm.com"
	<sudeep.holla@arm.com>
Thread-Index: AQHa35mLdhQH4qvBikqC1hweZwAegbIN988AgAAMBQCAF2c4AA==
Date: Tue, 13 Aug 2024 15:26:11 +0000
Message-ID: <104d0ec31cb45477e27273e089402d4205ee4042.camel@amazon.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
	 <20240726202134.627514-1-ankur.a.arora@oracle.com>
	 <20240726202134.627514-7-ankur.a.arora@oracle.com>
	 <5ba1e9b9bba7cafcd3cc831ff5f2407d81409632.camel@amazon.com>
	 <87ikwors8p.fsf@oracle.com>
In-Reply-To: <87ikwors8p.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <6549F0F970A7214B834B61B298F16EFD@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDI0LTA3LTI5IGF0IDExOjAyIC0wNzAwLCBBbmt1ciBBcm9yYSB3cm90ZToNCj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiANCj4gT2thbm92aWMsIEhhcmlzIDxoYXJpc29rbkBhbWF6b24uY29tPiB3cml0ZXM6
DQo+IA0KPiA+IE9uIEZyaSwgMjAyNC0wNy0yNiBhdCAxMzoyMSAtMDcwMCwgQW5rdXIgQXJvcmEg
d3JvdGU6DQo+ID4gPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRl
IG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1l
bnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVu
dCBpcyBzYWZlLg0KPiA+ID4gDQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gQWRkIGFyY2hpdGVjdHVy
YWwgc3VwcG9ydCBmb3IgY3B1aWRsZS1oYWx0cG9sbCBkcml2ZXIgYnkgZGVmaW5pbmcNCj4gPiA+
IGFyY2hfaGFsdHBvbGxfKigpLg0KPiA+ID4gDQo+ID4gPiBBbHNvIGRlZmluZSBBUkNIX0NQVUlE
TEVfSEFMVFBPTEwgdG8gYWxsb3cgY3B1aWRsZS1oYWx0cG9sbCB0byBiZQ0KPiA+ID4gc2VsZWN0
ZWQsIGFuZCBnaXZlbiB0aGF0IHdlIGhhdmUgYW4gb3B0aW1pemVkIHBvbGxpbmcgbWVjaGFuaXNt
DQo+ID4gPiBpbiBzbXBfY29uZF9sb2FkKigpLCBzZWxlY3QgQVJDSF9IQVNfT1BUSU1JWkVEX1BP
TEwuDQo+ID4gPiANCj4gPiA+IHNtcF9jb25kX2xvYWQqKCkgYXJlIGltcGxlbWVudGVkIHZpYSBM
RFhSLCBXRkUsIHdpdGggTERYUiBsb2FkaW5nDQo+ID4gPiBhIG1lbW9yeSByZWdpb24gaW4gZXhj
bHVzaXZlIHN0YXRlIGFuZCB0aGUgV0ZFIHdhaXRpbmcgZm9yIGFueQ0KPiA+ID4gc3RvcmVzIHRv
IGl0Lg0KPiA+ID4gDQo+ID4gPiBJbiB0aGUgZWRnZSBjYXNlIC0tIG5vIENQVSBzdG9yZXMgdG8g
dGhlIHdhaXRlZCByZWdpb24gYW5kIHRoZXJlJ3Mgbm8NCj4gPiA+IGludGVycnVwdCAtLSB0aGUg
ZXZlbnQtc3RyZWFtIHdpbGwgcHJvdmlkZSB0aGUgdGVybWluYXRpbmcgY29uZGl0aW9uDQo+ID4g
PiBlbnN1cmluZyB3ZSBkb24ndCB3YWl0IGZvcmV2ZXIsIGJ1dCBiZWNhdXNlIHRoZSBldmVudC1z
dHJlYW0gcnVucyBhdA0KPiA+ID4gYSBmaXhlZCBmcmVxdWVuY3kgKGNvbmZpZ3VyZWQgYXQgMTBr
SHopIHdlIG1pZ2h0IHNwZW5kIG1vcmUgdGltZSBpbg0KPiA+ID4gdGhlIHBvbGxpbmcgc3RhZ2Ug
dGhhbiBzcGVjaWZpZWQgYnkgY3B1aWRsZV9wb2xsX3RpbWUoKS4NCj4gPiA+IA0KPiA+ID4gVGhp
cyB3b3VsZCBvbmx5IGhhcHBlbiBpbiB0aGUgbGFzdCBpdGVyYXRpb24sIHNpbmNlIG92ZXJzaG9v
dGluZyB0aGUNCj4gPiA+IHBvbGxfbGltaXQgbWVhbnMgdGhlIGdvdmVybm9yIG1vdmVzIG91dCBv
ZiB0aGUgcG9sbGluZyBzdGFnZS4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQW5rdXIg
QXJvcmEgPGFua3VyLmEuYXJvcmFAb3JhY2xlLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGFyY2gv
YXJtNjQvS2NvbmZpZyAgICAgICAgICAgICAgICAgICAgICAgIHwgMTAgKysrKysrKysrKw0KPiA+
ID4gIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1aWRsZV9oYWx0cG9sbC5oIHwgIDkgKysrKysr
KysrDQo+ID4gPiAgYXJjaC9hcm02NC9rZXJuZWwvY3B1aWRsZS5jICAgICAgICAgICAgICAgfCAy
MyArKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gIDMgZmlsZXMgY2hhbmdlZCwgNDIgaW5z
ZXJ0aW9ucygrKQ0KPiA+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybTY0L2luY2x1ZGUv
YXNtL2NwdWlkbGVfaGFsdHBvbGwuaA0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9LY29uZmlnIGIvYXJjaC9hcm02NC9LY29uZmlnDQo+ID4gPiBpbmRleCA1ZDkxMjU5ZWU3
YjUuLmNmMWM2NjgxZWIwYSAxMDA2NDQNCj4gPiA+IC0tLSBhL2FyY2gvYXJtNjQvS2NvbmZpZw0K
PiA+ID4gKysrIGIvYXJjaC9hcm02NC9LY29uZmlnDQo+ID4gPiBAQCAtMzUsNiArMzUsNyBAQCBj
b25maWcgQVJNNjQNCj4gPiA+ICAgICAgICAgc2VsZWN0IEFSQ0hfSEFTX01FTUJBUlJJRVJfU1lO
Q19DT1JFDQo+ID4gPiAgICAgICAgIHNlbGVjdCBBUkNIX0hBU19OTUlfU0FGRV9USElTX0NQVV9P
UFMNCj4gPiA+ICAgICAgICAgc2VsZWN0IEFSQ0hfSEFTX05PTl9PVkVSTEFQUElOR19BRERSRVNT
X1NQQUNFDQo+ID4gPiArICAgICAgIHNlbGVjdCBBUkNIX0hBU19PUFRJTUlaRURfUE9MTA0KPiA+
ID4gICAgICAgICBzZWxlY3QgQVJDSF9IQVNfUFRFX0RFVk1BUA0KPiA+ID4gICAgICAgICBzZWxl
Y3QgQVJDSF9IQVNfUFRFX1NQRUNJQUwNCj4gPiA+ICAgICAgICAgc2VsZWN0IEFSQ0hfSEFTX0hX
X1BURV9ZT1VORw0KPiA+ID4gQEAgLTIzNzYsNiArMjM3NywxNSBAQCBjb25maWcgQVJDSF9ISUJF
Uk5BVElPTl9IRUFERVINCj4gPiA+ICBjb25maWcgQVJDSF9TVVNQRU5EX1BPU1NJQkxFDQo+ID4g
PiAgICAgICAgIGRlZl9ib29sIHkNCj4gPiA+IA0KPiA+ID4gK2NvbmZpZyBBUkNIX0NQVUlETEVf
SEFMVFBPTEwNCj4gPiA+ICsgICAgICAgYm9vbCAiRW5hYmxlIHNlbGVjdGlvbiBvZiB0aGUgY3B1
aWRsZS1oYWx0cG9sbCBkcml2ZXIiDQo+ID4gPiArICAgICAgIGRlZmF1bHQgbg0KPiA+ID4gKyAg
ICAgICBoZWxwDQo+ID4gPiArICAgICAgICAgY3B1aWRsZS1oYWx0cG9sbCBhbGxvd3MgZm9yIGFk
YXB0aXZlIHBvbGxpbmcgYmFzZWQgb24NCj4gPiA+ICsgICAgICAgICBjdXJyZW50IGxvYWQgYmVm
b3JlIGVudGVyaW5nIHRoZSBpZGxlIHN0YXRlLg0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICAgIFNv
bWUgdmlydHVhbGl6ZWQgd29ya2xvYWRzIGJlbmVmaXQgZnJvbSB1c2luZyBpdC4NCj4gPiA+ICsN
Cj4gPiA+ICBlbmRtZW51ICMgIlBvd2VyIG1hbmFnZW1lbnQgb3B0aW9ucyINCj4gPiA+IA0KPiA+
ID4gIG1lbnUgIkNQVSBQb3dlciBNYW5hZ2VtZW50Ig0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQvaW5jbHVkZS9hc20vY3B1aWRsZV9oYWx0cG9sbC5oIGIvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9jcHVpZGxlX2hhbHRwb2xsLmgNCj4gPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4g
PiBpbmRleCAwMDAwMDAwMDAwMDAuLjY1ZjI4OTQwN2E2Yw0KPiA+ID4gLS0tIC9kZXYvbnVsbA0K
PiA+ID4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9jcHVpZGxlX2hhbHRwb2xsLmgNCj4g
PiA+IEBAIC0wLDAgKzEsOSBAQA0KPiA+ID4gKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBH
UEwtMi4wICovDQo+ID4gPiArI2lmbmRlZiBfQVJDSF9IQUxUUE9MTF9IDQo+ID4gPiArI2RlZmlu
ZSBfQVJDSF9IQUxUUE9MTF9IDQo+ID4gPiArDQo+ID4gPiArc3RhdGljIGlubGluZSB2b2lkIGFy
Y2hfaGFsdHBvbGxfZW5hYmxlKHVuc2lnbmVkIGludCBjcHUpIHsgfQ0KPiA+ID4gK3N0YXRpYyBp
bmxpbmUgdm9pZCBhcmNoX2hhbHRwb2xsX2Rpc2FibGUodW5zaWduZWQgaW50IGNwdSkgeyB9DQo+
ID4gPiArDQo+ID4gPiArYm9vbCBhcmNoX2hhbHRwb2xsX3dhbnQoYm9vbCBmb3JjZSk7DQo+ID4g
PiArI2VuZGlmDQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rZXJuZWwvY3B1aWRsZS5j
IGIvYXJjaC9hcm02NC9rZXJuZWwvY3B1aWRsZS5jDQo+ID4gPiBpbmRleCBmMzcyMjk1MjA3ZmIu
LjMzNGRmODJhMGVhYyAxMDA2NDQNCj4gPiA+IC0tLSBhL2FyY2gvYXJtNjQva2VybmVsL2NwdWlk
bGUuYw0KPiA+ID4gKysrIGIvYXJjaC9hcm02NC9rZXJuZWwvY3B1aWRsZS5jDQo+ID4gPiBAQCAt
NzIsMyArNzIsMjYgQEAgX19jcHVpZGxlIGludCBhY3BpX3Byb2Nlc3Nvcl9mZmhfbHBpX2VudGVy
KHN0cnVjdCBhY3BpX2xwaV9zdGF0ZSAqbHBpKQ0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgbHBpLT5pbmRleCwgc3RhdGUpOw0KPiA+ID4gIH0NCj4g
PiA+ICAjZW5kaWYNCj4gPiA+ICsNCj4gPiA+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfSEFMVFBP
TExfQ1BVSURMRSkNCj4gPiA+ICsNCj4gPiA+ICsjaW5jbHVkZSA8YXNtL2NwdWlkbGVfaGFsdHBv
bGwuaD4NCj4gPiA+ICsNCj4gPiA+ICtib29sIGFyY2hfaGFsdHBvbGxfd2FudChib29sIGZvcmNl
KQ0KPiA+ID4gK3sNCj4gPiA+ICsgICAgICAgLyoNCj4gPiA+ICsgICAgICAgICogRW5hYmxpbmcg
aGFsdHBvbGwgcmVxdWlyZXMgdHdvIHRoaW5nczoNCj4gPiA+ICsgICAgICAgICoNCj4gPiA+ICsg
ICAgICAgICogLSBFdmVudCBzdHJlYW0gc3VwcG9ydCB0byBwcm92aWRlIGEgdGVybWluYXRpbmcg
Y29uZGl0aW9uIHRvIHRoZQ0KPiA+ID4gKyAgICAgICAgKiAgIFdGRSBpbiB0aGUgcG9sbCBsb29w
Lg0KPiA+ID4gKyAgICAgICAgKg0KPiA+ID4gKyAgICAgICAgKiAtIEtWTSBzdXBwb3J0IGZvciBh
cmNoX2hhbHRwb2xsX2VuYWJsZSgpLCBhcmNoX2hhbHRwb2xsX2VuYWJsZSgpLg0KPiA+IA0KPiA+
IHR5cG86ICJhcmNoX2hhbHRwb2xsX2VuYWJsZSIgYW5kICJhcmNoX2hhbHRwb2xsX2VuYWJsZSIN
Cj4gPiANCj4gPiA+ICsgICAgICAgICoNCj4gPiA+ICsgICAgICAgICogR2l2ZW4gdGhhdCB0aGUg
c2Vjb25kIGlzIG1pc3NpbmcsIGFsbG93IGhhbHRwb2xsIHRvIG9ubHkgYmUgZm9yY2UNCj4gPiA+
ICsgICAgICAgICogbG9hZGVkLg0KPiA+ID4gKyAgICAgICAgKi8NCj4gPiA+ICsgICAgICAgcmV0
dXJuIChhcmNoX3RpbWVyX2V2dHN0cm1fYXZhaWxhYmxlKCkgJiYgZmFsc2UpIHx8IGZvcmNlOw0K
PiA+IA0KPiA+IFRoaXMgc2hvdWxkIGFsd2F5cyBldmFsdWF0ZSBmYWxzZSB3aXRob3V0IGZvcmNl
LiBQZXJoYXBzIHlvdSBtZWFudA0KPiA+IHNvbWV0aGluZyBsaWtlIHRoaXM/DQo+ID4gDQo+ID4g
YGBgDQo+ID4gLSAgICAgICByZXR1cm4gKGFyY2hfdGltZXJfZXZ0c3RybV9hdmFpbGFibGUoKSAm
JiBmYWxzZSkgfHwgZm9yY2U7DQo+ID4gKyAgICAgICByZXR1cm4gYXJjaF90aW1lcl9ldnRzdHJt
X2F2YWlsYWJsZSgpIHx8IGZvcmNlOw0KPiA+IGBgYA0KPiANCj4gTm8uIFRoaXMgd2FzIGludGVu
dGlvbmFsLiBBcyBJIG1lbml0b24gaW4gdGhlIGNvbW1lbnQgYWJvdmUsIHJpZ2h0IG5vdw0KPiB0
aGUgS1ZNIHN1cHBvcnQgaXMgbWlzc2luZy4gV2hpY2ggbWVhbnMgdGhhdCB0aGUgZ3Vlc3QgaGFz
IG5vIHdheSB0bw0KPiB0ZWxsIHRoZSBob3N0IHRvIG5vdCBwb2xsIGFzIHBhcnQgb2YgaG9zdCBo
YWx0cG9sbC4NCj4gDQo+IFVudGlsIHRoYXQgaXMgYXZhaWxhYmxlLCBvbmx5IGFsbG93IGZvcmNl
IGxvYWRpbmcuDQoNCkkgc2VlLCBhcm02NCdzIGt2bSBpcyBtaXNzaW5nIHRoZSBwb2xsIGNvbnRy
b2wgbWVjaGFuaXNtLg0KDQpJJ2xsIGZvbGxvdy11cCB5b3VyIGNoYW5nZXMgd2l0aCBhIHBhdGNo
IGZvciBBV1MgR3Jhdml0b247IHN0aWxsIHNlZWluZw0KdGhlIHNhbWUgcGVyZm9ybWFuY2UgZ2Fp
bnMuDQoNClRlc3RlZC1ieTogSGFyaXMgT2thbm92aWMgPGhhcmlzb2tuQGFtYXpvbi5jb20+DQoN
Cj4gDQo+IC0tDQo+IGFua3VyDQoNCg==

