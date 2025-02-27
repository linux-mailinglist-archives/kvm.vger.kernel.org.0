Return-Path: <kvm+bounces-39542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0C28A47669
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 08:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA4D316F4F5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 07:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C79221551;
	Thu, 27 Feb 2025 07:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Wb5+Zqi6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B1213777E;
	Thu, 27 Feb 2025 07:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740640819; cv=none; b=EPgZS2A5ZbTkiP1L5I4ouQ7lBrepONosUuYTCcq3D0zvHof590AevEQ8WGTfOz+qUGuNpjE6eXY11Cg9kKfoCHxytaeiVtcjqs9rI+KHy4t0jYIeTYoHo5tqUnQQkLUCdAxQtoxLqBqIDvD0vpp4iRoLUGNuIQiPmATAdV4Vc28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740640819; c=relaxed/simple;
	bh=jX/RUXtYKsOq/GMka6gQOeYgILirvp+hdNk3FPVAZeg=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WqKPxVvV1JYSL/E3JFrxkjlrGEZH9vpW3fwUPwYcvNazul3+vc2bLG2R388YDu/ONKhOF4H3hCpmCUUubov4toYVKs02nyL4pOP5YunlKhaZWy3vh7OcPSVzwPhCfpuVBHsQWqpHgsh4KPeW30ZlteNOSNnwHcNbzkIGPKw27vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=Wb5+Zqi6; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1740640818; x=1772176818;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=jX/RUXtYKsOq/GMka6gQOeYgILirvp+hdNk3FPVAZeg=;
  b=Wb5+Zqi6c0biRPdSacKQ+LmELqIvGvMpnW1lBtbaI8tSmj9M97kLWQG2
   0RYWdh6gl/MZ34v3GH4zpr3B7ZdLgBaUqypN29maoqAVNyBxMV9nIlvLt
   GlqJdpTMysQIRxpgylO7D0VFHNOxMuubYZYl5o5VuVuU4Xnf50kXbEDJx
   M=;
X-IronPort-AV: E=Sophos;i="6.13,319,1732579200"; 
   d="scan'208";a="274749904"
Subject: Re: [RFC PATCH 0/3] kvm,sched: Add gtime halted
Thread-Topic: [RFC PATCH 0/3] kvm,sched: Add gtime halted
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 07:20:14 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:27198]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.12.5:2525] with esmtp (Farcaster)
 id daa47828-8222-44de-8671-1a2b78b59a83; Thu, 27 Feb 2025 07:20:12 +0000 (UTC)
X-Farcaster-Flow-ID: daa47828-8222-44de-8671-1a2b78b59a83
Received: from EX19D003EUB004.ant.amazon.com (10.252.51.121) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 27 Feb 2025 07:20:11 +0000
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19D003EUB004.ant.amazon.com (10.252.51.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 27 Feb 2025 07:20:11 +0000
Received: from EX19D003EUB001.ant.amazon.com ([fe80::f153:3fae:905b:eb06]) by
 EX19D003EUB001.ant.amazon.com ([fe80::f153:3fae:905b:eb06%3]) with mapi id
 15.02.1544.014; Thu, 27 Feb 2025 07:20:11 +0000
From: "Sieber, Fernand" <sieberf@amazon.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Thread-Index: AQHbgkNzVJp2ED40h0CgqrtlEaNsE7NY5JiAgAEwCQCAAAnJgIAArRaA
Date: Thu, 27 Feb 2025 07:20:11 +0000
Message-ID: <f114eb3a8a21e1cd1a120db32258340504464458.camel@amazon.com>
References: <20250218202618.567363-1-sieberf@amazon.com>
	 <Z755r4S_7BLbHlWa@google.com>
	 <e8cd99b4c4f93a581203449db9caee29b9751373.camel@amazon.com>
	 <Z7-A76KjcYB8HAP8@google.com>
In-Reply-To: <Z7-A76KjcYB8HAP8@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF34274FA4AB7D44A00A7E2BDEE076EF@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64

T24gV2VkLCAyMDI1LTAyLTI2IGF0IDEzOjAwIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEZlYiAyNiwgMjAyNSwgRmVybmFuZCBTaWViZXIgd3JvdGU6DQo+ID4g
T24gVHVlLCAyMDI1LTAyLTI1IGF0IDE4OjE3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gPiBJbiB0aGlzIFJGQyB3ZSBpbnRyb2R1Y2UgdGhlIGNvbmNlcHQgb2YgZ3Vl
c3QgaGFsdGVkIHRpbWUgdG8NCj4gPiA+ID4gYWRkcmVzcw0KPiA+ID4gPiB0aGVzZSBjb25jZXJu
cy4gR3Vlc3QgaGFsdGVkIHRpbWUgKGd0aW1lX2hhbHRlZCkgYWNjb3VudHMgZm9yDQo+ID4gPiA+
IGN5Y2xlcw0KPiA+ID4gPiBzcGVudCBpbiBndWVzdCBtb2RlIHdoaWxlIHRoZSBjcHUgaXMgaGFs
dGVkLiBndGltZV9oYWx0ZWQNCj4gPiA+ID4gcmVsaWVzIG9uDQo+ID4gPiA+IG1lYXN1cmluZyB0
aGUgbXBlcmYgbXNyIHJlZ2lzdGVyICh4ODYpIGFyb3VuZCBWTSBlbnRlci9leGl0cyB0bw0KPiA+
ID4gPiBjb21wdXRlDQo+ID4gPiA+IHRoZSBudW1iZXIgb2YgdW5oYWx0ZWQgY3ljbGVzOyBoYWx0
ZWQgY3ljbGVzIGFyZSB0aGVuIGRlcml2ZWQNCj4gPiA+ID4gZnJvbSB0aGUNCj4gPiA+ID4gdHNj
IGRpZmZlcmVuY2UgbWludXMgdGhlIG1wZXJmIGRpZmZlcmVuY2UuDQo+ID4gPiANCj4gPiA+IElN
TywgdGhlcmUgYXJlIGJldHRlciB3YXlzIHRvIHNvbHZlIHRoaXMgdGhhbiBoYXZpbmcgS1ZNIHNh
bXBsZQ0KPiA+ID4gTVBFUkYgb24NCj4gPiA+IGV2ZXJ5IGVudHJ5IGFuZCBleGl0Lg0KPiA+ID4g
DQo+ID4gPiBUaGUga2VybmVsIGFscmVhZHkgc2FtcGxlcyBBUEVSRi9NUFJFRiBvbiBldmVyeSB0
aWNrIGFuZCBwcm92aWRlcw0KPiA+ID4gdGhhdA0KPiA+ID4gaW5mb3JtYXRpb24gdmlhIC9wcm9j
L2NwdWluZm8sIGp1c3QgdXNlIHRoYXQuwqAgSWYgeW91ciB1c2Vyc3BhY2UNCj4gPiA+IGlzIHVu
YWJsZQ0KPiA+ID4gdG8gdXNlIC9wcm9jL2NwdWluZm8gb3Igc2ltaWxhciwgdGhhdCBuZWVkcyB0
byBiZSBleHBsYWluZWQuDQo+ID4gDQo+ID4gSWYgSSB1bmRlcnN0YW5kIGNvcnJlY3RseSB3aGF0
IHlvdSBhcmUgc3VnZ2VzdGluZyBpcyB0byBoYXZlDQo+ID4gdXNlcnNwYWNlDQo+ID4gcmVndWxh
cmx5IHNhbXBsaW5nIHRoZXNlIHZhbHVlcyB0byBkZXRlY3QgdGhlIG1vc3QgaWRsZSBDUFVzIGFu
ZA0KPiA+IHRoZW4NCj4gPiB1c2UgQ1BVIGFmZmluaXR5IHRvIHJlcGluIGhvdXNla2VlcGluZyB0
YXNrcyB0byB0aGVzZS4gV2hpbGUgaXQncw0KPiA+IHBvc3NpYmxlIHRoaXMgZXNzZW50aWFsbHkg
cmVxdWlyZXMgdG8gaW1wbGVtZW50IGFub3RoZXIgc2NoZWR1bGluZw0KPiA+IGxheWVyIGluIHVz
ZXJzcGFjZSB0aHJvdWdoIGNvbnN0YW50IHJlLXBpbm5pbmcgb2YgdGFza3MuIFRoaXMgYWxzbw0K
PiA+IHJlcXVpcmVzIHRvIGNvbnN0YW50bHkgaWRlbnRpZnkgdGhlIGZ1bGwgc2V0IG9mIHRhc2tz
IHRoYXQgY2FuDQo+ID4gaW5kdWNlDQo+ID4gdW5kZXNpcmFibGUgb3ZlcmhlYWQgc28gdGhhdCB0
aGV5IGNhbiBiZSBwaW5uZWQgYWNjb3JkaW5nbHkuIEZvcg0KPiA+IHRoZXNlDQo+ID4gcmVhc29u
cyB3ZSB3b3VsZCByYXRoZXIgd2FudCB0aGUgbG9naWMgdG8gYmUgaW1wbGVtZW50ZWQgZGlyZWN0
bHkNCj4gPiBpbg0KPiA+IHRoZSBzY2hlZHVsZXIuDQo+ID4gDQo+ID4gPiBBbmQgaWYgeW91J3Jl
IHJ1bm5pbmcgdkNQVXMgb24gdGlja2xlc3MgQ1BVcywgYW5kIHlvdSdyZSBkb2luZw0KPiA+ID4g
SExUL01XQUlUDQo+ID4gPiBwYXNzdGhyb3VnaCwgKmFuZCogeW91IHdhbnQgdG8gc2NoZWR1bGUg
b3RoZXIgdGFza3Mgb24gdGhvc2UNCj4gPiA+IENQVXMsIHRoZW4gSU1PDQo+ID4gPiB5b3UncmUg
YWJ1c2luZyBhbGwgb2YgdGhvc2UgdGhpbmdzIGFuZCBpdCdzIG5vdCBLVk0ncyBwcm9ibGVtIHRv
DQo+ID4gPiBzb2x2ZSwNCj4gPiA+IGVzcGVjaWFsbHkgbm93IHRoYXQgc2NoZWRfZXh0IGlzIGEg
dGhpbmcuDQo+ID4gDQo+ID4gV2UgYXJlIHJ1bm5pbmcgdkNQVXMgd2l0aCB0aWNrcywgdGhlIHJl
c3Qgb2YgeW91ciBvYnNlcnZhdGlvbnMgYXJlDQo+ID4gY29ycmVjdC4NCj4gDQo+IElmIHRoZXJl
J3MgYSBob3N0IHRpY2ssIHdoeSBkbyB5b3UgbmVlZCBLVk0ncyBoZWxwIHRvIG1ha2Ugc2NoZWR1
bGluZw0KPiBkZWNpc2lvbnM/DQo+IEl0IHNvdW5kcyBsaWtlIHdoYXQgeW91IHdhbnQgaXMgYSBz
Y2hlZHVsZXIgdGhhdCBpcyBwcmltYXJpbHkgZHJpdmVuDQo+IGJ5IE1QRVJGDQo+IChhbmQgQVBF
UkY/KSwgYW5kIHNjaGVkX3RpY2soKSA9PiBhcmNoX3NjYWxlX2ZyZXFfdGljaygpIGFscmVhZHkN
Cj4ga25vd3MgYWJvdXQgTVBFUkYuDQoNCkhhdmluZyB0aGUgbWVhc3VyZSBhcm91bmQgVk0gZW50
ZXIvZXhpdCBtYWtlcyBpdCBlYXN5IHRvIGF0dHJpYnV0ZSB0aGUNCnVuaGFsdGVkIGN5Y2xlcyB0
byBhIHNwZWNpZmljIHRhc2sgKHZDUFUpLCB3aGljaCBzb2x2ZXMgYm90aCBvdXIgdXNlDQpjYXNl
cyBvZiBWTSBtZXRyaWNzIGFuZCBzY2hlZHVsaW5nLiBUaGF0IHNhaWQgd2UgbWF5IGJlIGFibGUg
dG8gYXZvaWQNCml0IGFuZCBhY2hpZXZlIHRoZSBzYW1lIHJlc3VsdHMuDQoNCmkuZQ0KKiB0aGUg
Vk0gbWV0cmljcyB1c2UgY2FzZSBjYW4gYmUgc29sdmVkIGJ5IHVzaW5nIC9wcm9jL2NwdWluZm8g
ZnJvbQ0KdXNlcnNwYWNlLg0KKiBmb3IgdGhlIHNjaGVkdWxpbmcgdXNlIGNhc2UsIHRoZSB0aWNr
IGJhc2VkIHNhbXBsaW5nIG9mIE1QRVJGIG1lYW5zDQp3ZSBjb3VsZCBwb3RlbnRpYWxseSBpbnRy
b2R1Y2UgYSBjb3JyZWN0aW5nIGZhY3RvciBvbiBQRUxUIGFjY291bnRpbmcNCm9mIHBpbm5lZCB2
Q1BVIHRhc2tzIGJhc2VkIG9uIGl0cyB2YWx1ZSAoc2ltaWxhciB0byB3aGF0IEkgZG8gaW4gdGhl
DQpsYXN0IHBhdGNoIG9mIHRoZSBzZXJpZXMpLg0KDQpUaGUgY29tYmluYXRpb24gb2YgdGhlc2Ug
d291bGQgcmVtb3ZlIHRoZSByZXF1aXJlbWVudCBvZiBhZGRpbmcgYW55DQpsb2dpYyBhcm91bmQg
Vk0gZW50cmVyL2V4aXQgdG8gc3VwcG9ydCBvdXIgdXNlIGNhc2VzLg0KDQpJJ20gaGFwcHkgdG8g
cHJvdG90eXBlIHRoYXQgaWYgd2UgdGhpbmsgaXQncyBnb2luZyBpbiB0aGUgcmlnaHQNCmRpcmVj
dGlvbj8NCg0KCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRyZSAoU291dGggQWZyaWNhKSAoUHJv
cHJpZXRhcnkpIExpbWl0ZWQKMjkgR29nb3NvYSBTdHJlZXQsIE9ic2VydmF0b3J5LCBDYXBlIFRv
d24sIFdlc3Rlcm4gQ2FwZSwgNzkyNSwgU291dGggQWZyaWNhClJlZ2lzdHJhdGlvbiBOdW1iZXI6
IDIwMDQgLyAwMzQ0NjMgLyAwNwo=


