Return-Path: <kvm+bounces-39405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC63A46C65
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB4EF7A20B1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7DD2745E;
	Wed, 26 Feb 2025 20:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="a2gWU94g"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3012755E0;
	Wed, 26 Feb 2025 20:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601649; cv=none; b=eecPGwVCVIieDJs3AOXq5JCcAeXdOKI1iY88CA3q9GDRd0El7bfhswMnA9+Z6wnnmW4yO/AAHYX0m7clzZgBdfaDm+PL5sudMYiGQGIWapwL6Kd3FhJVuIu4EO28g2DiZVNu0Ubet9AUoMtkQZdCcgtDBdM7tKSv8T9E8Eg3Efw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601649; c=relaxed/simple;
	bh=QvIBKbsliRFoiTNHdhDNRZs+tCwBcWNNiJ13qTRAjIY=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QVAefNJeLhflMwqQmlhDs24oJnYQAvnFz+5xYOjRDuyVrz6eTmqNgW9rAANQiscyti2QSz9jXmqscxMd1edffj9E4+GF6cz55aWd1HXKQkUcGPYeE8Vw0QStUDfdqt5mU0mz7UA7mT41vAycetq9SjpVJS7um5XjseKVvHUKpqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=a2gWU94g; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1740601649; x=1772137649;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=QvIBKbsliRFoiTNHdhDNRZs+tCwBcWNNiJ13qTRAjIY=;
  b=a2gWU94gRvqB0tDLMqLZBglnDH/TXSDoLrsRS+ZwNRyyIjrMOC1qG+BI
   2GCI3SNDYigACXfNEMmaDeG8vG61SlNNBIWsFF06EPKOzaYE3EvBUOUMY
   65PY+9atXZP1FEXmgU15FldUU+x3+8BjKTO8Rp3w5fFwIgtfHh27go238
   w=;
X-IronPort-AV: E=Sophos;i="6.13,318,1732579200"; 
   d="scan'208";a="470274279"
Subject: Re: [RFC PATCH 0/3] kvm,sched: Add gtime halted
Thread-Topic: [RFC PATCH 0/3] kvm,sched: Add gtime halted
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 20:27:25 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:47712]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.12.5:2525] with esmtp (Farcaster)
 id 21cb27f8-ab5c-452c-a5ba-8809d63106f3; Wed, 26 Feb 2025 20:27:23 +0000 (UTC)
X-Farcaster-Flow-ID: 21cb27f8-ab5c-452c-a5ba-8809d63106f3
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 26 Feb 2025 20:27:22 +0000
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 26 Feb 2025 20:27:22 +0000
Received: from EX19D003EUB001.ant.amazon.com ([fe80::f153:3fae:905b:eb06]) by
 EX19D003EUB001.ant.amazon.com ([fe80::f153:3fae:905b:eb06%3]) with mapi id
 15.02.1544.014; Wed, 26 Feb 2025 20:27:22 +0000
From: "Sieber, Fernand" <sieberf@amazon.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Thread-Index: AQHbgkNzVJp2ED40h0CgqrtlEaNsE7NY5JiAgAEwCQA=
Date: Wed, 26 Feb 2025 20:27:22 +0000
Message-ID: <e8cd99b4c4f93a581203449db9caee29b9751373.camel@amazon.com>
References: <20250218202618.567363-1-sieberf@amazon.com>
	 <Z755r4S_7BLbHlWa@google.com>
In-Reply-To: <Z755r4S_7BLbHlWa@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAB3A6A753CF0E4BBB22A2316E0399FB@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64

T24gVHVlLCAyMDI1LTAyLTI1IGF0IDE4OjE3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiANCj4gDQo+IE9uIFR1ZSwgRmViIDE4LCAyMDI1LCBGZXJuYW5kIFNpZWJlciB3cm90
ZToNCj4gPiBXaXRoIGd1ZXN0IGhsdCwgcGF1c2UgYW5kIG13YWl0IHBhc3MgdGhyb3VnaCwgdGhl
IGh5cGVydmlzb3IgbG9zZXMNCj4gPiB2aXNpYmlsaXR5IG9uIHJlYWwgZ3Vlc3QgY3B1IGFjdGl2
aXR5LiBGcm9tIHRoZSBwb2ludCBvZiB2aWV3IG9mDQo+ID4gdGhlDQo+ID4gaG9zdCwgc3VjaCB2
Y3B1cyBhcmUgYWx3YXlzIDEwMCUgYWN0aXZlIGV2ZW4gd2hlbiB0aGUgZ3Vlc3QgaXMNCj4gPiBj
b21wbGV0ZWx5IGhhbHRlZC4NCj4gPiANCj4gPiBUeXBpY2FsbHkgaGx0LCBwYXVzZSBhbmQgbXdh
aXQgcGFzcyB0aHJvdWdoIGlzIG9ubHkgaW1wbGVtZW50ZWQgb24NCj4gPiBub24tdGltZXNoYXJl
ZCBwY3B1cy4gSG93ZXZlciwgdGhlcmUgYXJlIGNhc2VzIHdoZXJlIHRoaXMNCj4gPiBhc3N1bXB0
aW9uDQo+ID4gY2Fubm90IGJlIHN0cmljdGx5IG1ldCBhcyBzb21lIG9jY2FzaW9uYWwgaG91c2Vr
ZWVwaW5nIHdvcmsgbmVlZHMNCj4gPiB0byBiZQ0KPiANCj4gV2hhdCBob3VzZWtlZXBpbmcgd29y
az8NCg0KSW4gdGhlIGNhc2UgdGhhdCB3YW50IHRvIHNvbHZlLCBob3VzZWtlZXBpbmcgd29yayBp
cyBtYWlubHkgdXNlcnNwYWNlDQp0YXNrcyBpbXBsZW1lbnRpbmcgaHlwZXJ2aXNvciBmdW5jdGlv
bmFsaXR5IHN1Y2ggYXMgZ2F0aGVyaW5nIG1ldHJpY3MsDQpwZXJmb3JtaW5nIGhlYWx0aCBjaGVj
a3MsIGhhbmRsaW5nIFZNIGxpZmVjeWNsZSwgZXRjLg0KDQpUaGUgcGxhdGZvcm1zIGRvbid0IGhh
dmUgZGVkaWNhdGVkIGNwdXMgZm9yIGhvdXNla2VlcGluZyBwdXJwb3NlcyBhbmQNCnRyeSBhcyBt
dWNoIGFzIHBvc3NpYmxlIHRvIGZ1bGx5IGRlZGljYXRlIHRoZSBjcHVzIHRvIFZNcywgaGVuY2UN
CkhMVC9NV0FJVCBwYXNzIHRocm91Z2guIFRoZSBob3VzZWtlZXBpbmcgd29yayBpcyBsb3cgYnV0
IGNhbiBzdGlsbA0KaW50ZXJmZXJlIHdpdGggZ3Vlc3RzIHRoYXQgYXJlIHJ1bm5pbmcgdmVyeSBs
YXRlbmN5IHNlbnNpdGl2ZQ0Kb3BlcmF0aW9ucyBvbiBhIHN1YnNldCBvZiB2Q1BVcyAoZS5nIGlk
bGUgcG9sbCksIHdoaWNoIGlzIHdoYXQgd2Ugd2FudA0KdG8gZGV0ZWN0IGFuZCBhdm9pZC4NCg0K
PiANCj4gPiBzY2hlZHVsZWQgb24gc3VjaCBjcHVzIHdoaWxlIHdlIGdlbmVyYWxseSB3YW50IHRv
IHByZXNlcnZlIHRoZSBwYXNzDQo+ID4gdGhyb3VnaCBwZXJmb3JtYW5jZSBnYWlucy4gVGhpcyBh
cHBsaWVzIGZvciBzeXN0ZW0gd2hpY2ggZG9uJ3QgaGF2ZQ0KPiA+IGRlZGljYXRlZCBjcHVzIGZv
ciBob3VzZWtlZXBpbmcgcHVycG9zZXMuDQo+ID4gDQo+ID4gSW4gc3VjaCBjYXNlcywgdGhlIGxh
Y2sgb2YgdmlzaWJpbGl0eSBvZiB0aGUgaHlwZXJ2aXNvciBpcw0KPiA+IHByb2JsZW1hdGljDQo+
ID4gZnJvbSBhIGxvYWQgYmFsYW5jaW5nIHBvaW50IG9mIHZpZXcuIEluIHRoZSBhYnNlbmNlIG9m
IGEgYmV0dGVyDQo+ID4gc2lnbmFsLA0KPiA+IGl0IHdpbGwgcHJlZW10IHZjcHVzIGF0IHJhbmRv
bS4gRm9yIGV4YW1wbGUgaXQgY291bGQgZGVjaWRlIHRvDQo+ID4gaW50ZXJydXB0DQo+ID4gYSB2
Y3B1IGRvaW5nIGNyaXRpY2FsIGlkbGUgcG9sbCB3b3JrIHdoaWxlIGFub3RoZXIgdmNwdSBzaXRz
IGlkbGUuDQo+ID4gDQo+ID4gQW5vdGhlciBtb3RpdmF0aW9uIGZvciBnYWluaW5nIHZpc2liaWxp
dHkgaW50byByZWFsIGd1ZXN0IGNwdQ0KPiA+IGFjdGl2aXR5DQo+ID4gaXMgdG8gZW5hYmxlIHRo
ZSBoeXBlcnZpc29yIHRvIHZlbmQgbWV0cmljcyBhYm91dCBpdCBmb3IgZXh0ZXJuYWwNCj4gPiBj
b25zdW1wdGlvbi4NCj4gDQo+IFN1Y2ggYXM/DQoNCkFuIGV4YW1wbGUgaXMgZmVlZGluZyBWTSB1
dGlsaXNhdGlvbiBtZXRyaWNzIHRvIG90aGVyIHN5c3RlbXMgbGlrZSBhdXRvDQpzY2FsaW5nIG9m
IGd1ZXN0IGFwcGxpY2F0aW9ucy4gV2hpbGUgaXQgaXMgcG9zc2libGUgdG8gaW1wbGVtZW50IHRo
aXMNCmZ1bmN0aW9uYWxpdHkgcHVyZWx5IG9uIHRoZSBndWVzdCBzaWRlLCBoYXZpbmcgdGhlIGh5
cGVydmlzb3IgaGFuZGxpbmcNCml0IG1lYW5zIHRoYXQgaXQncyBhdmFpbGFibGUgb3V0IG9mIHRo
ZSBib3ggZm9yIGFsbCBWTXMgaW4gYSBzdGFuZGFyZA0Kd2F5IHdpdGhvdXQgcmVseWluZyBvbiBn
dWVzdCBzaWRlIGNvbmZpZ3VyYXRpb24uDQoNCj4gDQo+ID4gSW4gdGhpcyBSRkMgd2UgaW50cm9k
dWNlIHRoZSBjb25jZXB0IG9mIGd1ZXN0IGhhbHRlZCB0aW1lIHRvDQo+ID4gYWRkcmVzcw0KPiA+
IHRoZXNlIGNvbmNlcm5zLiBHdWVzdCBoYWx0ZWQgdGltZSAoZ3RpbWVfaGFsdGVkKSBhY2NvdW50
cyBmb3INCj4gPiBjeWNsZXMNCj4gPiBzcGVudCBpbiBndWVzdCBtb2RlIHdoaWxlIHRoZSBjcHUg
aXMgaGFsdGVkLiBndGltZV9oYWx0ZWQgcmVsaWVzIG9uDQo+ID4gbWVhc3VyaW5nIHRoZSBtcGVy
ZiBtc3IgcmVnaXN0ZXIgKHg4NikgYXJvdW5kIFZNIGVudGVyL2V4aXRzIHRvDQo+ID4gY29tcHV0
ZQ0KPiA+IHRoZSBudW1iZXIgb2YgdW5oYWx0ZWQgY3ljbGVzOyBoYWx0ZWQgY3ljbGVzIGFyZSB0
aGVuIGRlcml2ZWQgZnJvbQ0KPiA+IHRoZQ0KPiA+IHRzYyBkaWZmZXJlbmNlIG1pbnVzIHRoZSBt
cGVyZiBkaWZmZXJlbmNlLg0KPiANCj4gSU1PLCB0aGVyZSBhcmUgYmV0dGVyIHdheXMgdG8gc29s
dmUgdGhpcyB0aGFuIGhhdmluZyBLVk0gc2FtcGxlIE1QRVJGDQo+IG9uIGV2ZXJ5DQo+IGVudHJ5
IGFuZCBleGl0Lg0KPiANCj4gVGhlIGtlcm5lbCBhbHJlYWR5IHNhbXBsZXMgQVBFUkYvTVBSRUYg
b24gZXZlcnkgdGljayBhbmQgcHJvdmlkZXMNCj4gdGhhdCBpbmZvcm1hdGlvbg0KPiB2aWEgL3By
b2MvY3B1aW5mbywganVzdCB1c2UgdGhhdC7CoCBJZiB5b3VyIHVzZXJzcGFjZSBpcyB1bmFibGUg
dG8gdXNlDQo+IC9wcm9jL2NwdWluZm8NCj4gb3Igc2ltaWxhciwgdGhhdCBuZWVkcyB0byBiZSBl
eHBsYWluZWQuDQoNCklmIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHkgd2hhdCB5b3UgYXJlIHN1Z2dl
c3RpbmcgaXMgdG8gaGF2ZSB1c2Vyc3BhY2UNCnJlZ3VsYXJseSBzYW1wbGluZyB0aGVzZSB2YWx1
ZXMgdG8gZGV0ZWN0IHRoZSBtb3N0IGlkbGUgQ1BVcyBhbmQgdGhlbg0KdXNlIENQVSBhZmZpbml0
eSB0byByZXBpbiBob3VzZWtlZXBpbmcgdGFza3MgdG8gdGhlc2UuIFdoaWxlIGl0J3MNCnBvc3Np
YmxlIHRoaXMgZXNzZW50aWFsbHkgcmVxdWlyZXMgdG8gaW1wbGVtZW50IGFub3RoZXIgc2NoZWR1
bGluZw0KbGF5ZXIgaW4gdXNlcnNwYWNlIHRocm91Z2ggY29uc3RhbnQgcmUtcGlubmluZyBvZiB0
YXNrcy4gVGhpcyBhbHNvDQpyZXF1aXJlcyB0byBjb25zdGFudGx5IGlkZW50aWZ5IHRoZSBmdWxs
IHNldCBvZiB0YXNrcyB0aGF0IGNhbiBpbmR1Y2UNCnVuZGVzaXJhYmxlIG92ZXJoZWFkIHNvIHRo
YXQgdGhleSBjYW4gYmUgcGlubmVkIGFjY29yZGluZ2x5LiBGb3IgdGhlc2UNCnJlYXNvbnMgd2Ug
d291bGQgcmF0aGVyIHdhbnQgdGhlIGxvZ2ljIHRvIGJlIGltcGxlbWVudGVkIGRpcmVjdGx5IGlu
DQp0aGUgc2NoZWR1bGVyLg0KDQo+IA0KPiBBbmQgaWYgeW91J3JlIHJ1bm5pbmcgdkNQVXMgb24g
dGlja2xlc3MgQ1BVcywgYW5kIHlvdSdyZSBkb2luZw0KPiBITFQvTVdBSVQgcGFzc3Rocm91Z2gs
DQo+ICphbmQqIHlvdSB3YW50IHRvIHNjaGVkdWxlIG90aGVyIHRhc2tzIG9uIHRob3NlIENQVXMs
IHRoZW4gSU1PIHlvdSdyZQ0KPiBhYnVzaW5nIGFsbA0KPiBvZiB0aG9zZSB0aGluZ3MgYW5kIGl0
J3Mgbm90IEtWTSdzIHByb2JsZW0gdG8gc29sdmUsIGVzcGVjaWFsbHkgbm93DQo+IHRoYXQgc2No
ZWRfZXh0DQo+IGlzIGEgdGhpbmcuDQoNCldlIGFyZSBydW5uaW5nIHZDUFVzIHdpdGggdGlja3Ms
IHRoZSByZXN0IG9mIHlvdXIgb2JzZXJ2YXRpb25zIGFyZQ0KY29ycmVjdC4NCg0KPiANCj4gPiBn
dGltZV9oYWx0ZWQgaXMgZXhwb3NlZCB0byBwcm9jLzxwaWQ+L3N0YXQgYXMgYSBuZXcgZW50cnks
IHdoaWNoDQo+ID4gZW5hYmxlcw0KPiA+IHVzZXJzIHRvIG1vbml0b3IgcmVhbCBndWVzdCBhY3Rp
dml0eS4NCj4gPiANCj4gPiBndGltZV9oYWx0ZWQgaXMgYWxzbyBwbHVtYmVkIHRvIHRoZSBzY2hl
ZHVsZXIgaW5mcmFzdHJ1Y3R1cmUgdG8NCj4gPiBkaXNjb3VudA0KPiA+IGhhbHRlZCBjeWNsZXMg
ZnJvbSBmYWlyIGxvYWQgYWNjb3VudGluZy4gVGhpcyBlbmxpZ2h0ZW5zIHRoZSBsb2FkDQo+ID4g
YmFsYW5jZXIgdG8gcmVhbCBndWVzdCBhY3Rpdml0eSBmb3IgYmV0dGVyIHRhc2sgcGxhY2VtZW50
Lg0KPiA+IA0KPiA+IFRoaXMgaW5pdGlhbCBSRkMgaGFzIGEgZmV3IGxpbWl0YXRpb25zIGFuZCBv
cGVuIHF1ZXN0aW9uczoNCj4gPiAqIG9ubHkgdGhlIHg4NiBpbmZyYXN0cnVjdHVyZSBpcyBzdXBw
b3J0ZWQgYXMgaXQgcmVsaWVzIG9uDQo+ID4gYXJjaGl0ZWN0dXJlDQo+ID4gwqAgZGVwZW5kZW50
IHJlZ2lzdGVycy4gRnV0dXJlIGRldmVsb3BtZW50IHdpbGwgZXh0ZW5kIHRoaXMgdG8gQVJNLg0K
PiA+ICogd2UgYXNzdW1lIHRoYXQgbXBlcmYgYWNjdW11bGF0ZXMgYXMgdGhlIHNhbWUgcmF0ZSBh
cyB0c2MuIFdoaWxlIEkNCj4gPiBhbQ0KPiA+IMKgIG5vdCBjZXJ0YWluIHdoZXRoZXIgdGhpcyBh
c3N1bXB0aW9uIGlzIGV2ZXIgdmlvbGF0ZWQsIHRoZSBzcGVjDQo+ID4gZG9lc24ndA0KPiA+IMKg
IHNlZW0gdG8gb2ZmZXIgdGhpcyBndWFyYW50ZWUgWzFdIHNvIHdlIG1heSB3YW50IHRvIGNhbGli
cmF0ZQ0KPiA+IG1wZXJmLg0KPiA+ICogdGhlIHNjaGVkIGVubGlnaHRlbm1lbnQgbG9naWMgcmVs
aWVzIG9uIHBlcmlvZGljIGd0aW1lX2hhbHRlZA0KPiA+IHVwZGF0ZXMuDQo+ID4gwqAgQXMgc3Vj
aCwgaXQgaXMgaW5jb21wYXRpYmxlIHdpdGggbm9oeiBmdWxsIGJlY2F1c2UgdGhpcyBjb3VsZA0K
PiA+IHJlc3VsdA0KPiA+IMKgIGluIGxvbmcgcGVyaW9kcyBvZiBubyB1cGRhdGUgZm9sbG93ZWQg
YnkgYSBtYXNzaXZlIGhhbHRlZCB0aW1lDQo+ID4gdXBkYXRlDQo+ID4gwqAgd2hpY2ggZG9lc24n
dCBwbGF5IHdlbGwgd2l0aCB0aGUgZXhpc3RpbmcgUEVMVCBpbnRlZ3JhdGlvbi4gSXQgaXMNCj4g
PiDCoCBwb3NzaWJsZSB0byBhZGRyZXNzIHRoaXMgbGltaXRhdGlvbiB3aXRoIGdlbmVyYWxpemVk
LCBtb3JlDQo+ID4gY29tcGxleA0KPiA+IMKgIGFjY291bnRpbmcuDQoNCgoKCkFtYXpvbiBEZXZl
bG9wbWVudCBDZW50cmUgKFNvdXRoIEFmcmljYSkgKFByb3ByaWV0YXJ5KSBMaW1pdGVkCjI5IEdv
Z29zb2EgU3RyZWV0LCBPYnNlcnZhdG9yeSwgQ2FwZSBUb3duLCBXZXN0ZXJuIENhcGUsIDc5MjUs
IFNvdXRoIEFmcmljYQpSZWdpc3RyYXRpb24gTnVtYmVyOiAyMDA0IC8gMDM0NDYzIC8gMDcK


