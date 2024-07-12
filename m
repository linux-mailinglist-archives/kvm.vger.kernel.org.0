Return-Path: <kvm+bounces-21572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C386F9300A8
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 21:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5DD81C211F9
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A928A225D9;
	Fri, 12 Jul 2024 19:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="BTyVHX/y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC0422315
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 19:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720811021; cv=none; b=Rd1noOsBf7k4Gi6RYdiqZGbVSW/RzTfbphRPJifION0ty3UeZTRgn7xz9B5AXv8mIdy74bCovILTsuLkk21RSMcN2u/dZnfksA/fJEfY3zZer+CUkPS4qqQhzcVSyn6gUuYrK6eOmRn17GBOjegR8MgYNL28Bzi971nndFbC7AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720811021; c=relaxed/simple;
	bh=bLgjDfReROPHVtWwqm6hLAlmucB93HGmSm268RIKh/A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=anAV7nLg49+ojIg94QQ36FvoT04GcQ6iVfMWvBSupDbENBScxB02IYwxTYijrpGYVYrtDDWBunUV0ZHI0haGPoJtWl4Ak01W4s6KqWmkv7Y5bWGMc0jkNkPBaBp98Qb3w9TjZIvfN9MAvv2wHJ+5YdGaeU43na+bPJc1gS4QGko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=BTyVHX/y; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720811020; x=1752347020;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bLgjDfReROPHVtWwqm6hLAlmucB93HGmSm268RIKh/A=;
  b=BTyVHX/y3O99wTr1/Z9aeNmwe7WAHFhae5+iTvQbiDuOQ9GBofZ5gK8u
   rMfKKQNq1Gb+f+b5zTpEC0iPUPrRDjQjKRUcP01XsILSQXodPnGUbcMBu
   dA5RtY0WgdmrWLP+fSeH5SHGajkc59YPwVSemnbpWjPhMYesW0Asdh39U
   c=;
X-IronPort-AV: E=Sophos;i="6.09,203,1716249600"; 
   d="scan'208";a="434313253"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2024 19:03:34 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.43.254:53733]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.43.109:2525] with esmtp (Farcaster)
 id 8cb4a223-da34-457e-8ff9-8bcc9a66d7ef; Fri, 12 Jul 2024 19:03:32 +0000 (UTC)
X-Farcaster-Flow-ID: 8cb4a223-da34-457e-8ff9-8bcc9a66d7ef
Received: from EX19D018EUA003.ant.amazon.com (10.252.50.163) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 12 Jul 2024 19:03:32 +0000
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19D018EUA003.ant.amazon.com (10.252.50.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 12 Jul 2024 19:03:32 +0000
Received: from EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1]) by
 EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1%3]) with mapi id
 15.02.1258.034; Fri, 12 Jul 2024 19:03:32 +0000
From: "Stamatis, Ilias" <ilstam@amazon.co.uk>
To: "Stamatis, Ilias" <ilstam@amazon.co.uk>, "Kagan, Roman" <rkagan@amazon.de>
CC: "Durrant, Paul" <pdurrant@amazon.co.uk>, "levinsasha928@gmail.com"
	<levinsasha928@gmail.com>, "avi@redhat.com" <avi@redhat.com>,
	"mst@redhat.com" <mst@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Woodhouse, David" <dwmw@amazon.co.uk>
Subject: Re: [PATCH 1/6] KVM: Fix coalesced_mmio_has_room()
Thread-Topic: [PATCH 1/6] KVM: Fix coalesced_mmio_has_room()
Thread-Index: AQHa0qbUgU1Cf7ZX1kuueDwP9wRW37HzQp2AgAA0OIA=
Date: Fri, 12 Jul 2024 19:03:32 +0000
Message-ID: <125da420a114efe4ea1a8f8b5f98bbf5fc7f91ae.camel@amazon.co.uk>
References: <20240710085259.2125131-1-ilstam@amazon.com>
	 <20240710085259.2125131-2-ilstam@amazon.com>
	 <ZpFSA4CA1FaS4iWV@u40bc5e070a0153.ant.amazon.com>
In-Reply-To: <ZpFSA4CA1FaS4iWV@u40bc5e070a0153.ant.amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <82EC2966163F8F41899829E7C8B6DA13@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI0LTA3LTEyIGF0IDE3OjU1ICswMjAwLCBSb21hbiBLYWdhbiB3cm90ZToNCj4g
T24gV2VkLCBKdWwgMTAsIDIwMjQgYXQgMDk6NTI6NTRBTSArMDEwMCwgSWxpYXMgU3RhbWF0aXMg
d3JvdGU6DQo+ID4gVGhlIGZvbGxvd2luZyBjYWxjdWxhdGlvbiB1c2VkIGluIGNvYWxlc2NlZF9t
bWlvX2hhc19yb29tKCkgdG8gY2hlY2sNCj4gPiB3aGV0aGVyIHRoZSByaW5nIGJ1ZmZlciBpcyBm
dWxsIGlzIHdyb25nIGFuZCBvbmx5IGFsbG93cyBoYWxmIHRoZSBidWZmZXINCj4gPiB0byBiZSB1
c2VkLg0KPiA+IA0KPiA+IGF2YWlsID0gKHJpbmctPmZpcnN0IC0gbGFzdCAtIDEpICUgS1ZNX0NP
QUxFU0NFRF9NTUlPX01BWDsNCj4gPiBpZiAoYXZhaWwgPT0gMCkNCj4gPiAJLyogZnVsbCAqLw0K
PiA+IA0KPiA+IFRoZSAlIG9wZXJhdG9yIGluIEMgaXMgbm90IHRoZSBtb2R1bG8gb3BlcmF0b3Ig
YnV0IHRoZSByZW1haW5kZXINCj4gPiBvcGVyYXRvci4gTW9kdWxvIGFuZCByZW1haW5kZXIgb3Bl
cmF0b3JzIGRpZmZlciB3aXRoIHJlc3BlY3QgdG8gbmVnYXRpdmUNCj4gPiB2YWx1ZXMuIEJ1dCBh
bGwgdmFsdWVzIGFyZSB1bnNpZ25lZCBpbiB0aGlzIGNhc2UgYW55d2F5Lg0KPiA+IA0KPiA+IFRo
ZSBhYm92ZSBtaWdodCBoYXZlIHdvcmtlZCBhcyBleHBlY3RlZCBpbiBweXRob24gZm9yIGV4YW1w
bGU6DQo+ID4gPiA+ID4gKC04NikgJSAxNzANCj4gPiA4NA0KPiA+IA0KPiA+IEhvd2V2ZXIgaXQg
ZG9lc24ndCB3b3JrIHRoZSBzYW1lIHdheSBpbiBDLg0KPiA+IA0KPiA+IHByaW50ZigiYXZhaWw6
ICVkXG4iLCAoLTg2KSAlIDE3MCk7DQo+ID4gcHJpbnRmKCJhdmFpbDogJXVcbiIsICgtODYpICUg
MTcwKTsNCj4gPiBwcmludGYoImF2YWlsOiAldVxuIiwgKC04NnUpICUgMTcwdSk7DQo+ID4gDQo+
ID4gVXNpbmcgZ2NjLTExIHRoZXNlIHByaW50Og0KPiA+IA0KPiA+IGF2YWlsOiAtODYNCj4gPiBh
dmFpbDogNDI5NDk2NzIxMA0KPiA+IGF2YWlsOiAwDQo+IA0KPiBXaGVyZSBleGFjdGx5IGRvIHlv
dSBzZWUgYSBwcm9ibGVtPyAgQXMgeW91IGNvcnJlY3RseSBwb2ludCBvdXQsIGFsbA0KPiB2YWx1
ZXMgYXJlIHVuc2lnbmVkLCBzbyB1bnNpZ25lZCBhcml0aG1ldGljcyB3aXRoIHdyYXBhcm91bmQg
YXBwbGllcywNCj4gYW5kIHRoZW4gJSBvcGVyYXRvciBpcyBhcHBsaWVkIHRvIHRoZSByZXN1bHRp
bmcgdW5zaWduZWQgdmFsdWUuICBPdXQNCj4geW91ciB0aHJlZSBleGFtcGxlcywgb25seSB0aGUg
bGFzdCBvbmUgaXMgcmVsZXZhbnQsIGFuZCBpdCdzIHBlcmZlY3RseQ0KPiB0aGUgaW50ZW5kZWQg
YmVoYXZpb3IuDQo+IA0KPiBUaGFua3MsDQo+IFJvbWFuLg0KDQpLVk1fQ09BTEVTQ0VEX01NSU9f
TUFYIG9uIHg4NiBpcyAxNzAsIHdoaWNoIG1lYW5zIHRoZSByaW5nIGJ1ZmZlciBoYXMNCjE3MCBl
bnRyaWVzICgxNjkgb2Ygd2hpY2ggc2hvdWxkIGJlIHVzYWJsZSkuIA0KDQpJZiBmaXJzdCA9IDAg
YW5kIGxhc3QgPSA4NSB0aGVuIHRoZSBjYWxjdWxhdGlvbiBnaXZlcyAwIGF2YWlsYWJsZQ0KZW50
cmllcyBpbiB3aGljaCBjYXNlIHdlIGNvbnNpZGVyIHRoZSBidWZmZXIgdG8gYmUgZnVsbCBhbmQg
d2UgZXhpdCB0bw0KdXNlcnNwYWNlLiBCdXQgd2Ugc2hvdWxkbid0IGFzIHRoZXJlIGFyZSBzdGls
bCA4NCB1bnVzZWQgZW50cmllcy4NCg0KU28gSSBkb24ndCBzZWUgaG93IHRoaXMgY291bGQgaGF2
ZSBiZWVuIHRoZSBpbnRlbmRlZCBiZWhhdmlvdXIuIA0KDQpJbGlhcw0K

