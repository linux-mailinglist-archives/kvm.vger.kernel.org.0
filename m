Return-Path: <kvm+bounces-13915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9557F89CCC0
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 22:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D2F3284180
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 20:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B88146A61;
	Mon,  8 Apr 2024 20:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="XOaP0oaB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451361272C4;
	Mon,  8 Apr 2024 20:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712606693; cv=none; b=XVQnMTDLN1G3WsPt9bncs7rs+6RYxnds/8zD3dj6zabt9UvaNqk9HGamk5jB71xrBBmHd85CD3IWW12Ivu1hUlHIlEaTS7jYUqJaRafW4uia3dyKzoTSS7qgv5tVkgm9rqm3MmymaSldeF9oyyJ9kMe+UBukVEs+65sqAaMtoUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712606693; c=relaxed/simple;
	bh=S9K9SCByMM0ty79uj3ySt7qPf8AIZdDC95KuiV37yiE=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z/BImb/VfqsNQzH6nVfMAO/79q+UpJ2IdhV5j6SqtfnfQdSMayu5sSJHR/LioL29tuMuhIEj0R/xJn50HgK/bNJ9bohBNotR1rsXoviSEErMC/7knBxTkLSdGuUaW2MxQKvDmd+noXedw1ASyTdB0FEbkwXHougdH+udqE4WEik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=XOaP0oaB; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1712606692; x=1744142692;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=S9K9SCByMM0ty79uj3ySt7qPf8AIZdDC95KuiV37yiE=;
  b=XOaP0oaBo7HVjnv2HoNhixcN0SVEHdjBQTdmL4krrsail25oXxPHPSLj
   oN+PRN6FaR2cZoZiykTP9zO1kaw5cX5Ugw6i4gsU2J/fTcCgfKcSkImFW
   DiojcCi7KLyEfqC41OpLyKWWIsahRujDUQE55VroroV/JmyvMg8VY9VKT
   8=;
X-IronPort-AV: E=Sophos;i="6.07,187,1708387200"; 
   d="scan'208";a="410040860"
Subject: Re: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Thread-Topic: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 20:04:50 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.21.151:2613]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.59.148:2525] with esmtp (Farcaster)
 id 5c05a5f2-5bd7-4620-b836-ee947f766195; Mon, 8 Apr 2024 20:04:49 +0000 (UTC)
X-Farcaster-Flow-ID: 5c05a5f2-5bd7-4620-b836-ee947f766195
Received: from EX19D001UWA002.ant.amazon.com (10.13.138.236) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 8 Apr 2024 20:04:49 +0000
Received: from EX19D001UWA003.ant.amazon.com (10.13.138.211) by
 EX19D001UWA002.ant.amazon.com (10.13.138.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.28;
 Mon, 8 Apr 2024 20:04:49 +0000
Received: from EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2]) by
 EX19D001UWA003.ant.amazon.com ([fe80::256a:26de:3ee6:48a2%7]) with mapi id
 15.02.1258.028; Mon, 8 Apr 2024 20:04:49 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dianders@chromium.org"
	<dianders@chromium.org>, "rick.p.edgecombe@intel.com"
	<rick.p.edgecombe@intel.com>, "rafael@kernel.org" <rafael@kernel.org>,
	"pmladek@suse.com" <pmladek@suse.com>, "wanpengli@tencent.com"
	<wanpengli@tencent.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"mihai.carabas@oracle.com" <mihai.carabas@oracle.com>, "will@kernel.org"
	<will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "mic@digikod.net" <mic@digikod.net>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Okanovic, Haris"
	<harisokn@amazon.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "juerg.haefliger@canonical.com"
	<juerg.haefliger@canonical.com>, "npiggin@gmail.com" <npiggin@gmail.com>,
	"x86@kernel.org" <x86@kernel.org>
Thread-Index: AQHahgAj0rMfU3rQtUK6VuthoD2QJ7FaOuMAgAAXOYCAAUWwAIADJkCAgAAV9oA=
Date: Mon, 8 Apr 2024 20:04:49 +0000
Message-ID: <b5ace5416d1a24b510555bfa03aff4cc35a52cb3.camel@amazon.com>
References: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
	 <1707982910-27680-8-git-send-email-mihai.carabas@oracle.com>
	 <7f3e540ad30f40ae51f1abda24b1bea2c8b648ea.camel@amazon.com>
	 <87r0fjtn9y.fsf@oracle.com>
	 <aada0beae0b3479bfa311eea94a3b595bb8e5835.camel@amazon.com>
	 <87il0rsnf0.fsf@oracle.com>
In-Reply-To: <87il0rsnf0.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <7424BB664F26AD4896FB1D47A7C36049@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDI0LTA0LTA4IGF0IDExOjQ2IC0wNzAwLCBBbmt1ciBBcm9yYSB3cm90ZToNCj4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiANCj4gT2thbm92aWMsIEhhcmlzIDxoYXJpc29rbkBhbWF6b24uY29tPiB3cml0ZXM6
DQo+IA0KPiA+IE9uIEZyaSwgMjAyNC0wNC0wNSBhdCAxNjoxNCAtMDcwMCwgQW5rdXIgQXJvcmEg
d3JvdGU6DQo+ID4gPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRl
IG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1l
bnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVu
dCBpcyBzYWZlLg0KPiA+ID4gDQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gT2thbm92aWMsIEhhcmlz
IDxoYXJpc29rbkBhbWF6b24uY29tPiB3cml0ZXM6DQo+ID4gPiANCj4gPiA+ID4gT24gVGh1LCAy
MDI0LTAyLTE1IGF0IDA5OjQxICswMjAwLCBNaWhhaSBDYXJhYmFzIHdyb3RlOg0KPiA+ID4gPiA+
IGNwdV9yZWxheCBvbiBBUk02NCBkb2VzIGEgc2ltcGxlICJ5aWVsZCIuIFRodXMgd2UgcmVwbGFj
ZSBpdCB3aXRoDQo+ID4gPiA+ID4gc21wX2NvbmRfbG9hZF9yZWxheGVkIHdoaWNoIGJhc2ljYWxs
eSBkb2VzIGEgIndmZSIuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gU3VnZ2VzdGVkLWJ5OiBQZXRl
ciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+DQo+ID4gPiA+ID4gU2lnbmVkLW9mZi1i
eTogTWloYWkgQ2FyYWJhcyA8bWloYWkuY2FyYWJhc0BvcmFjbGUuY29tPg0KPiA+ID4gPiA+IC0t
LQ0KPiA+ID4gPiA+ICBkcml2ZXJzL2NwdWlkbGUvcG9sbF9zdGF0ZS5jIHwgMTUgKysrKysrKysr
Ky0tLS0tDQo+ID4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA1IGRl
bGV0aW9ucygtKQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2Nw
dWlkbGUvcG9sbF9zdGF0ZS5jIGIvZHJpdmVycy9jcHVpZGxlL3BvbGxfc3RhdGUuYw0KPiA+ID4g
PiA+IGluZGV4IDliNmQ5MGE3MjYwMS4uMWU0NWJlOTA2ZTcyIDEwMDY0NA0KPiA+ID4gPiA+IC0t
LSBhL2RyaXZlcnMvY3B1aWRsZS9wb2xsX3N0YXRlLmMNCj4gPiA+ID4gPiArKysgYi9kcml2ZXJz
L2NwdWlkbGUvcG9sbF9zdGF0ZS5jDQo+ID4gPiA+ID4gQEAgLTEzLDYgKzEzLDcgQEANCj4gPiA+
ID4gPiAgc3RhdGljIGludCBfX2NwdWlkbGUgcG9sbF9pZGxlKHN0cnVjdCBjcHVpZGxlX2Rldmlj
ZSAqZGV2LA0KPiA+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgY3B1
aWRsZV9kcml2ZXIgKmRydiwgaW50IGluZGV4KQ0KPiA+ID4gPiA+ICB7DQo+ID4gPiA+ID4gKyAg
ICB1bnNpZ25lZCBsb25nIHJldDsNCj4gPiA+ID4gPiAgICAgIHU2NCB0aW1lX3N0YXJ0Ow0KPiA+
ID4gPiA+IA0KPiA+ID4gPiA+ICAgICAgdGltZV9zdGFydCA9IGxvY2FsX2Nsb2NrX25vaW5zdHIo
KTsNCj4gPiA+ID4gPiBAQCAtMjYsMTIgKzI3LDE2IEBAIHN0YXRpYyBpbnQgX19jcHVpZGxlIHBv
bGxfaWRsZShzdHJ1Y3QgY3B1aWRsZV9kZXZpY2UgKmRldiwNCj4gPiA+ID4gPiANCj4gPiA+ID4g
PiAgICAgICAgICAgICAgbGltaXQgPSBjcHVpZGxlX3BvbGxfdGltZShkcnYsIGRldik7DQo+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gLSAgICAgICAgICAgIHdoaWxlICghbmVlZF9yZXNjaGVkKCkpIHsN
Cj4gPiA+ID4gPiAtICAgICAgICAgICAgICAgICAgICBjcHVfcmVsYXgoKTsNCj4gPiA+ID4gPiAt
ICAgICAgICAgICAgICAgICAgICBpZiAobG9vcF9jb3VudCsrIDwgUE9MTF9JRExFX1JFTEFYX0NP
VU5UKQ0KPiA+ID4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+
ID4gPiA+ID4gLQ0KPiA+ID4gPiA+ICsgICAgICAgICAgICBmb3IgKDs7KSB7DQo+ID4gPiA+ID4g
ICAgICAgICAgICAgICAgICAgICAgbG9vcF9jb3VudCA9IDA7DQo+ID4gPiA+ID4gKw0KPiA+ID4g
PiA+ICsgICAgICAgICAgICAgICAgICAgIHJldCA9IHNtcF9jb25kX2xvYWRfcmVsYXhlZCgmY3Vy
cmVudF90aHJlYWRfaW5mbygpLT5mbGFncywNCj4gPiA+ID4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgVkFMICYgX1RJRl9ORUVEX1JFU0NIRUQgfHwN
Cj4gPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgbG9vcF9jb3VudCsrID49IFBPTExfSURMRV9SRUxBWF9DT1VOVCk7DQo+ID4gPiA+IA0KPiA+
ID4gPiBJcyBpdCBuZWNlc3NhcnkgdG8gcmVwZWF0IHRoaXMgMjAwIHRpbWVzIHdpdGggYSB3ZmUg
cG9sbD8NCj4gPiA+IA0KPiA+ID4gVGhlIFBPTExfSURMRV9SRUxBWF9DT1VOVCBpcyB0aGVyZSBi
ZWNhdXNlIG9uIHg4NiBlYWNoIGNwdV9yZWxheCgpDQo+ID4gPiBpdGVyYXRpb24gaXMgbXVjaCBz
aG9ydGVyLg0KPiA+ID4gDQo+ID4gPiBXaXRoIFdGRSwgaXQgbWFrZXMgbGVzcyBzZW5zZS4NCj4g
PiA+IA0KPiA+ID4gPiBEb2VzIGt2bSBub3QgaW1wbGVtZW50IGEgdGltZW91dCBwZXJpb2Q/DQo+
ID4gPiANCj4gPiA+IE5vdCB5ZXQsIGJ1dCBpdCBkb2VzIGJlY29tZSBtb3JlIHVzZWZ1bCBhZnRl
ciBhIFdGRSBoYWx0cG9sbCBpcw0KPiA+ID4gYXZhaWxhYmxlIG9uIEFSTTY0Lg0KPiA+IA0KPiA+
IE5vdGUgdGhhdCBrdm0gY29uZGl0aW9uYWxseSB0cmFwcyBXRkUgYW5kIFdGSSBiYXNlZCBvbiBu
dW1iZXIgb2YgaG9zdA0KPiA+IENQVSB0YXNrcy4gVk1zIHdpbGwgc29tZXRpbWVzIHNlZSBoYXJk
d2FyZSBiZWhhdmlvciAtIHBvdGVudGlhbGx5DQo+ID4gcG9sbGluZyBmb3IgYSBsb25nIHRpbWUg
YmVmb3JlIGVudGVyaW5nIFdGSS4NCj4gPiANCj4gPiBodHRwczovL2VsaXhpci5ib290bGluLmNv
bS9saW51eC9sYXRlc3Qvc291cmNlL2FyY2gvYXJtNjQva3ZtL2FybS5jI0w0NTkNCj4gDQo+IFll
YWguIFRoZXJlIHdhcyBhIGRpc2N1c3Npb24gb24gdGhpcw0KPiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9sa21sLzg3MXFjNnF1ZnkuZnNmQG9yYWNsZS5jb20vLg0KPiANCj4gPiA+IEhhbHRwb2xs
IGRvZXMgaGF2ZSBhIHRpbWVvdXQsIHdoaWNoIHlvdSBzaG91bGQgYmUgYWJsZSB0byB0dW5lIHZp
YQ0KPiA+ID4gL3N5cy9tb2R1bGUvaGFsdHBvbGwvcGFyYW1ldGVycy8gYnV0IHRoYXQsIG9mIGNv
dXJzZSwgd29uJ3QgaGVscCBoZXJlLg0KPiA+ID4gDQo+ID4gPiA+IENvdWxkIHlvdSBtYWtlIGl0
IGNvbmZpZ3VyYWJsZT8gVGhpcyBwYXRjaCBpbXByb3ZlcyBjZXJ0YWluIHdvcmtsb2Fkcw0KPiA+
ID4gPiBvbiBBV1MgR3Jhdml0b24gaW5zdGFuY2VzIGFzIHdlbGwsIGJ1dCBibG9ja3MgdXAgdG8g
Nm1zIGluIDIwMCAqIDMwdXMNCj4gPiA+ID4gaW5jcmVtZW50cyBiZWZvcmUgZ29pbmcgdG8gd2Zp
LCB3aGljaCBpcyBhIGJpdCBleGNlc3NpdmUuDQo+ID4gPiANCj4gPiA+IFllYWgsIHRoaXMgbG9v
a3MgbGlrZSBhIHByb2JsZW0uIFdlIGNvdWxkIHNvbHZlIGl0IGJ5IG1ha2luZyBpdCBhbg0KPiA+
ID4gYXJjaGl0ZWN0dXJhbCBwYXJhbWV0ZXIuIFRob3VnaCBJIHdvcnJ5IGFib3V0IEFSTSBwbGF0
Zm9ybXMgd2l0aA0KPiA+ID4gbXVjaCBzbWFsbGVyIGRlZmF1bHQgdGltZW91dHMuDQo+ID4gPiBU
aGUgb3RoZXIgcG9zc2liaWxpdHkgaXMgdXNpbmcgV0ZFVCBpbiB0aGUgcHJpbWl0aXZlLCBidXQg
dGhlbiB3ZQ0KPiA+ID4gaGF2ZSB0aGF0IGRlcGVuZGVuY3kgYW5kIHRoYXQncyBhIGJpZ2dlciBj
aGFuZ2UuDQo+ID4gDQo+ID4gU2VlIGFybTY0J3MgZGVsYXkoKSBmb3IgaW5zcGlyYXRpb246DQo+
ID4gDQo+ID4gaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjYuOS1yYzIvc291cmNl
L2FyY2gvYXJtNjQvbGliL2RlbGF5LmMjTDI2DQo+IA0KPiBTdXJlLCB0aGF0IHBhcnQgaXMgc3Ry
YWlnaHQtZm9yd2FyZCBlbm91Z2guIEhvd2V2ZXIsIHRoaXMgd2lsbCBuZWVkIGEgZmFsbGJhY2sN
Cj4gdGhlIGNhc2Ugd2hlbiBXRkVUIGlzIG5vdCBhdmFpbGFibGUuIEFuZCwgYmVjYXVzZSB0aGlz
IHBhdGggaXMgdXNlZCBvbiB4ODYsDQo+IHNvIHdlIG5lZWQgYSBjcm9zcyBwbGF0Zm9ybSBzbXBf
Y29uZCp0aW1lb3V0KCkuIFRob3VnaCBnaXZlbiB0aGF0IHRoZSB4ODYNCj4gdmVyc2lvbiBpcyBi
YXNlZCBvbiBjcHVfcmVsYXgoKSB0aGVuIHRoYXQgY291bGQganVzdCBmb2xkIHRoZSBzY2hlZF9j
bG9jaygpDQo+IGNoZWNrIGluLg0KDQpJIHdhcyB0cnlpbmcgdG8gcG9pbnQgb3V0IGhvdyBkZWxh
eSgpIGhhbmRsZXMgZGlmZmVyZW50IGNvbmZpZ3VyYXRpb25zOg0KSXQgcHJlZmVycyBXRkVUIHdo
ZW4gYXZhaWxhYmxlLCBmYWxscyBiYWNrIHRvIFdGRSB3aGVuIGV2ZW50IHN0cmVhbSBpcw0KYXZh
aWxhYmxlLCBhbmQgZmluYWxseSBmYWxscyBiYWNrIHRvIGNwdV9yZWxheCgpIGFzIGxhc3QgcmVz
b3J0LiBTYW1lDQpsb2dpYyBjYW4gYXBwbHkgaGVyZS4gVGhlIHg4NiBjYXNlIGNhbiBhbHdheXMg
dXNlIGNwdV9yZWxheCgpIGZhbGxiYWNrLA0KZm9yIHNhbWUgYmVoYXZpb3IgYXMgc21wX2NvbmRf
bG9hZF9yZWxheGVkKCkuDQoNClJlIHlvdXIgY29uY2VybiBhYm91dCAiQVJNIHBsYXRmb3JtcyB3
aXRoIG11Y2ggc21hbGxlciBkZWZhdWx0DQp0aW1lb3V0cyI6IFlvdSBjb3VsZCBkbyBzb21ldGhp
bmcgZGlmZmVyZW50IHdoZW4gYXJjaF90aW1lcl9nZXRfcmF0ZSgpDQppcyB0b28gc21hbGwuIEFs
dGhvdWdoIEknbSBub3Qgc3VyZSB0aGlzIGlzIGEgaHVnZSBjb25jZXJuLCBnaXZlbiB0aGF0DQpk
ZWxheSgpIGRvZXNuJ3Qgc2VlbSB0byBjYXJlIGluIHRoZSBXRkUgY2FzZS4NCg0KLS0gSGFyaXMg
T2thbm92aWMNCg0KPiANCj4gTWF5YmUgYW5vdGhlciBwbGFjZSB0byBkbyB0aGlzIHdvdWxkIGJl
IGJ5IEtWTSBmb3JjaW5nIGEgV0ZFIHRpbWVvdXQuIEFyZ3VhYmx5DQo+IHRoYXQgaXMgbmVlZGVk
IHJlZ2FyZGxlc3Mgb2Ygd2hldGhlciB3ZSB1c2UgYSBzbXBfY29uZCp0aW1lb3V0KCkgb3Igbm90
Lg0KPiANCj4gLS0NCj4gYW5rdXINCg0K

