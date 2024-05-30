Return-Path: <kvm+bounces-18460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 375AB8D5600
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 01:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A6EA1C2473D
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2726618412B;
	Thu, 30 May 2024 23:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="kRb1Cgbw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF31113B290;
	Thu, 30 May 2024 23:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717110441; cv=none; b=dri+55zDO2Vngj6qx89CAJjPTZ/wngBy21cDmPLnOJ2FrIbG0buKvaMTO7Ri6o77TIqTcKlu/Qna9xjMm4/9XtHgpcZx4rb8Q3yJdfBS3JXr2u+s/eMZ2U3mwjf4C95+GRH+nOt63FLS415aavq3EolBr0r6n7fTyiO172BBC7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717110441; c=relaxed/simple;
	bh=UXgFUVzVSDMMvUX7mRD7oyLSyRc2yEC9lDBRlpoEZZo=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YW2AY4zCIWxD7QikkrajPBMGUit4fRP9+h+G/xEbgK+kGuUFzd7L0Gx9buHuInW0IRFC5+LIhlk5+NTugXXgvSZAPZzA8Aj3JufBhlWLdaUuCBWaKKJgfjDxe2eOB2rtqKnitpfvpxv6hntNVyLgr64yo4MjU0sBMC9xc1In5dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=kRb1Cgbw; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1717110440; x=1748646440;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=UXgFUVzVSDMMvUX7mRD7oyLSyRc2yEC9lDBRlpoEZZo=;
  b=kRb1Cgbw5pH4rdsnw0f7WMVCw3dwX+ZOfIrrb3XNCl59FCBbRnxHJsaV
   /WeSuyxUKiCDDYZVtdx3f23VnHcUyK1YTwU+AnuKF8KCeISH6zaACwJtS
   Rcdcmn6ZxzSchzbm3zlc/pQ5zrMX6tUxa2OR3F0qzZvY2DEtiQhWD2ZSD
   U=;
X-IronPort-AV: E=Sophos;i="6.08,202,1712620800"; 
   d="scan'208";a="299904217"
Subject: Re: [PATCH 8/9] arm64: support cpuidle-haltpoll
Thread-Topic: [PATCH 8/9] arm64: support cpuidle-haltpoll
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 23:07:19 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:13629]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.28:2525] with esmtp (Farcaster)
 id e9f696c0-703f-49e5-9889-2e0bf8db9fb1; Thu, 30 May 2024 23:07:18 +0000 (UTC)
X-Farcaster-Flow-ID: e9f696c0-703f-49e5-9889-2e0bf8db9fb1
Received: from EX19D001UWA002.ant.amazon.com (10.13.138.236) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Thu, 30 May 2024 23:07:18 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA002.ant.amazon.com (10.13.138.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.28;
 Thu, 30 May 2024 23:07:18 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.028; Thu, 30 May 2024 23:07:18 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "wanpengli@tencent.com"
	<wanpengli@tencent.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>, "lenb@kernel.org"
	<lenb@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "will@kernel.org"
	<will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "Okanovic, Haris" <harisokn@amazon.com>,
	"rafael@kernel.org" <rafael@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>
Thread-Index: AQHamy2ih2zHEXQ7TU2Y0lcrXsZX2LGwld+A
Date: Thu, 30 May 2024 23:07:18 +0000
Message-ID: <41a184a3f5695061487e86a6da5eb87c140dbe3c.camel@amazon.com>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
	 <20240430183730.561960-9-ankur.a.arora@oracle.com>
In-Reply-To: <20240430183730.561960-9-ankur.a.arora@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9896794B0B406479E6B08FBFE80755D@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVHVlLCAyMDI0LTA0LTMwIGF0IDExOjM3IC0wNzAwLCBBbmt1ciBBcm9yYSB3cm90ZToNCj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiANCj4gQWRkIGFyY2hpdGVjdHVyYWwgc3VwcG9ydCBmb3IgdGhlIGNwdWlkbGUtaGFs
dHBvbGwgZHJpdmVyIGJ5IGRlZmluaW5nDQo+IGFyY2hfaGFsdHBvbGxfKigpLiBBbHNvIHNlbGVj
dCBBUkNIX0hBU19PUFRJTUlaRURfUE9MTCBzaW5jZSB3ZSBoYXZlDQo+IGFuIG9wdGltaXplZCBw
b2xsaW5nIG1lY2hhbmlzbSB2aWEgc21wX2NvbmRfbG9hZCooKS4NCj4gDQo+IEFkZCB0aGUgY29u
ZmlndXJhdGlvbiBvcHRpb24sIEFSQ0hfQ1BVSURMRV9IQUxUUE9MTCB0byBhbGxvdw0KPiBjcHVp
ZGxlLWhhbHRwb2xsIHRvIGJlIHNlbGVjdGVkLg0KPiANCj4gTm90ZSB0aGF0IHdlIGxpbWl0IGNw
dWlkbGUtaGFsdHBvbGwgc3VwcG9ydCB0byB3aGVuIHRoZSBldmVudC1zdHJlYW0gaXMNCj4gYXZh
aWxhYmxlLiBUaGlzIGlzIG5lY2Vzc2FyeSBiZWNhdXNlIHBvbGxpbmcgdmlhIHNtcF9jb25kX2xv
YWRfcmVsYXhlZCgpDQo+IHVzZXMgV0ZFIHRvIHdhaXQgZm9yIGEgc3RvcmUgd2hpY2ggbWlnaHQg
bm90IGhhcHBlbiBmb3IgYW4gcHJvbG9uZ2VkDQo+IHBlcmlvZCBvZiB0aW1lLiBTbywgZW5zdXJl
IHRoZSBldmVudC1zdHJlYW0gaXMgYXJvdW5kIHRvIHByb3ZpZGUgYQ0KPiB0ZXJtaW5hdGluZyBj
b25kaXRpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbmt1ciBBcm9yYSA8YW5rdXIuYS5hcm9y
YUBvcmFjbGUuY29tPg0KPiAtLS0NCj4gIGFyY2gvYXJtNjQvS2NvbmZpZyAgICAgICAgICAgICAg
ICAgICAgICAgIHwgMTAgKysrKysrKysrKw0KPiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9jcHVp
ZGxlX2hhbHRwb2xsLmggfCAyMSArKysrKysrKysrKysrKysrKysrKysNCj4gIDIgZmlsZXMgY2hh
bmdlZCwgMzEgaW5zZXJ0aW9ucygrKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvYXJtNjQv
aW5jbHVkZS9hc20vY3B1aWRsZV9oYWx0cG9sbC5oDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9LY29uZmlnIGIvYXJjaC9hcm02NC9LY29uZmlnDQo+IGluZGV4IDdiMTFjOThiM2U4NC4u
NmYyZGYxNjJiMTBlIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybTY0L0tjb25maWcNCj4gKysrIGIv
YXJjaC9hcm02NC9LY29uZmlnDQo+IEBAIC0zNCw2ICszNCw3IEBAIGNvbmZpZyBBUk02NA0KPiAg
ICAgICAgIHNlbGVjdCBBUkNIX0hBU19NRU1CQVJSSUVSX1NZTkNfQ09SRQ0KPiAgICAgICAgIHNl
bGVjdCBBUkNIX0hBU19OTUlfU0FGRV9USElTX0NQVV9PUFMNCj4gICAgICAgICBzZWxlY3QgQVJD
SF9IQVNfTk9OX09WRVJMQVBQSU5HX0FERFJFU1NfU1BBQ0UNCj4gKyAgICAgICBzZWxlY3QgQVJD
SF9IQVNfT1BUSU1JWkVEX1BPTEwNCj4gICAgICAgICBzZWxlY3QgQVJDSF9IQVNfUFRFX0RFVk1B
UA0KPiAgICAgICAgIHNlbGVjdCBBUkNIX0hBU19QVEVfU1BFQ0lBTA0KPiAgICAgICAgIHNlbGVj
dCBBUkNIX0hBU19IV19QVEVfWU9VTkcNCj4gQEAgLTIzMzEsNiArMjMzMiwxNSBAQCBjb25maWcg
QVJDSF9ISUJFUk5BVElPTl9IRUFERVINCj4gIGNvbmZpZyBBUkNIX1NVU1BFTkRfUE9TU0lCTEUN
Cj4gICAgICAgICBkZWZfYm9vbCB5DQo+IA0KPiArY29uZmlnIEFSQ0hfQ1BVSURMRV9IQUxUUE9M
TA0KPiArICAgICAgIGJvb2wgIkVuYWJsZSBzZWxlY3Rpb24gb2YgdGhlIGNwdWlkbGUtaGFsdHBv
bGwgZHJpdmVyIg0KPiArICAgICAgIGRlZmF1bHQgbg0KPiArICAgICAgIGhlbHANCj4gKyAgICAg
ICAgIGNwdWlkbGUtaGFsdHBvbGwgYWxsb3dzIGZvciBhZGFwdGl2ZSBwb2xsaW5nIGJhc2VkIG9u
DQo+ICsgICAgICAgICBjdXJyZW50IGxvYWQgYmVmb3JlIGVudGVyaW5nIHRoZSBpZGxlIHN0YXRl
Lg0KPiArDQo+ICsgICAgICAgICBTb21lIHZpcnR1YWxpemVkIHdvcmtsb2FkcyBiZW5lZml0IGZy
b20gdXNpbmcgaXQuDQo+ICsNCj4gIGVuZG1lbnUgIyAiUG93ZXIgbWFuYWdlbWVudCBvcHRpb25z
Ig0KPiANCj4gIG1lbnUgIkNQVSBQb3dlciBNYW5hZ2VtZW50Ig0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9jcHVpZGxlX2hhbHRwb2xsLmggYi9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL2NwdWlkbGVfaGFsdHBvbGwuaA0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRl
eCAwMDAwMDAwMDAwMDAuLmE3OWJkZWM3ZjUxNg0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL2Fy
Y2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1aWRsZV9oYWx0cG9sbC5oDQo+IEBAIC0wLDAgKzEsMjEg
QEANCj4gKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wICovDQo+ICsjaWZuZGVm
IF9BU01fSEFMVFBPTExfSA0KPiArI2RlZmluZSBfQVNNX0hBTFRQT0xMX0gNCj4gKw0KPiArc3Rh
dGljIGlubGluZSB2b2lkIGFyY2hfaGFsdHBvbGxfZW5hYmxlKHVuc2lnbmVkIGludCBjcHUpDQo+
ICt7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgdm9pZCBhcmNoX2hhbHRwb2xsX2Rpc2Fi
bGUodW5zaWduZWQgaW50IGNwdSkNCj4gK3sNCj4gK30NCj4gKw0KPiArc3RhdGljIGlubGluZSBi
b29sIGFyY2hfaGFsdHBvbGxfc3VwcG9ydGVkKHZvaWQpDQo+ICt7DQo+ICsgICAgICAgLyoNCj4g
KyAgICAgICAgKiBFbnN1cmUgdGhlIGV2ZW50IHN0cmVhbSBpcyBhdmFpbGFibGUgdG8gcHJvdmlk
ZSBhIHRlcm1pbmF0aW5nDQo+ICsgICAgICAgICogY29uZGl0aW9uIHRvIHRoZSBXRkUgaW4gdGhl
IHBvbGwgbG9vcC4NCj4gKyAgICAgICAgKi8NCj4gKyAgICAgICByZXR1cm4gYXJjaF90aW1lcl9l
dnRzdHJtX2F2YWlsYWJsZSgpOw0KDQpOb3RlIHRoaXMgZmFpbHMgYnVpbGQgd2hlbiBDT05GSUdf
SEFMVFBPTExfQ1BVSURMRT1tIChtb2R1bGUpOg0KDQpFUlJPUjogbW9kcG9zdDogImFyY2hfY3B1
X2lkbGUiIFtkcml2ZXJzL2NwdWlkbGUvY3B1aWRsZS1oYWx0cG9sbC5rb10NCnVuZGVmaW5lZCEg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAN
CkVSUk9SOiBtb2Rwb3N0OiAiYXJjaF90aW1lcl9ldnRzdHJtX2F2YWlsYWJsZSINCltkcml2ZXJz
L2NwdWlkbGUvY3B1aWRsZS1oYWx0cG9sbC5rb10gdW5kZWZpbmVkISAgICAgICAgICAgICAgICAg
ICAgICANCm1ha2VbMl06ICoqKiBbc2NyaXB0cy9NYWtlZmlsZS5tb2Rwb3N0OjE0NTogTW9kdWxl
LnN5bXZlcnNdIEVycm9yIDENCm1ha2VbMV06ICoqKiBbL2hvbWUvdWJ1bnR1L2xpbnV4L01ha2Vm
aWxlOjE4ODY6IG1vZHBvc3RdIEVycm9yIDINCm1ha2U6ICoqKiBbTWFrZWZpbGU6MjQwOiBfX3N1
Yi1tYWtlXSBFcnJvciAyDQoNCllvdSBjb3VsZCBhZGQgRVhQT1JUX1NZTUJPTF8qKCkncyBvbiB0
aGUgYWJvdmUgaGVscGVycyBvciByZXN0cmljdA0KSEFMVFBPTExfQ1BVSURMRSBtb2R1bGUgdG8g
YnVpbHQtaW4gKHJlbW92ZSAidHJpc3RhdGUiIEtjb25maWcpLg0KDQpPdGhlcndpc2UsIGV2ZXJ5
dGhpbmcgd29ya2VkIGZvciBtZSB3aGVuIGJ1aWx0LWluICg9eSkgYXRvcCA2LjEwLjANCig0YTRi
ZTFhKS4gSSBzZWUgc2ltaWxhciBwZXJmb3JtYW5jZSBnYWlucyBpbiBgcGVyZiBiZW5jaGAgb24g
QVdTDQpHcmF2aXRvbjMgYzdnLjE2eGxhcmdlLg0KDQpSZWdhcmRzLA0KSGFyaXMgT2thbm92aWMN
Cg0KPiArfQ0KPiArI2VuZGlmDQo+IC0tDQo+IDIuMzkuMw0KPiANCg0K

