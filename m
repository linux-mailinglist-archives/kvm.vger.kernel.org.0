Return-Path: <kvm+bounces-25136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DEF296067B
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 11:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7457EB23ADD
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EDA419DF9F;
	Tue, 27 Aug 2024 09:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="Top51QoP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B7219B3EE;
	Tue, 27 Aug 2024 09:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724752621; cv=none; b=ECUROAQUr/84U6eCbTawUBlHlVMRxMO7/nSb0OsbZhLRZg+sWKo/5MbwMwQrXY2xZsdm/VmMriuVSqODcr/e78kQ3TXHTGx8RJ2ULkTW+SGhUOM9zpPMlHdeQjyzRoVeWxbIKhkPXM2IipNgVD7kt8ROfGpc7gi7IwGzmq7PmYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724752621; c=relaxed/simple;
	bh=RWSZeaefIBg93jQXCXZ2QL3r8R7WrzWCZfNIjIo+xC0=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rc9oSmBWiQGh5YJ9iBzmYP1JzntcqdB83GPU+Wx3lS9kGRE7S0pSdvNycY15irVgUf7JqCO0p4dweX0ao5W79YLQXWZ9uTBDg3ncpbEqvDZDKSdXoTIaa7mjn70FgMLaApLZ2pFan9g94De9V6/9ILDQOIBrETcFZo/mSkPUvfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=Top51QoP; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1724752620; x=1756288620;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=RWSZeaefIBg93jQXCXZ2QL3r8R7WrzWCZfNIjIo+xC0=;
  b=Top51QoPQfkf+QEs+nwUoGYlOMmKMpnDjYWWLYOC2L6hpPSwNNjuyoaX
   Hyck1hNERsFSXEf57MPRPCGYlOdgIDaDm5l+kwNaD0A6B+T/ZRmSHECVL
   tK6HJLe/8quYvF48uvkQkIioZCqsd/dcbWGu6alEjUeI83MmOXH/5nRmD
   Y=;
X-IronPort-AV: E=Sophos;i="6.10,180,1719878400"; 
   d="scan'208";a="655053123"
Subject: Re: [PATCH 2/2] KVM: Clean up coalesced MMIO ring full check
Thread-Topic: [PATCH 2/2] KVM: Clean up coalesced MMIO ring full check
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 09:56:56 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:51087]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.6.142:2525] with esmtp (Farcaster)
 id b398acf2-985f-4ee2-9dd7-f0d0cec5c951; Tue, 27 Aug 2024 09:56:54 +0000 (UTC)
X-Farcaster-Flow-ID: b398acf2-985f-4ee2-9dd7-f0d0cec5c951
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 27 Aug 2024 09:56:54 +0000
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 27 Aug 2024 09:56:54 +0000
Received: from EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1]) by
 EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1%3]) with mapi id
 15.02.1258.034; Tue, 27 Aug 2024 09:56:54 +0000
From: "Stamatis, Ilias" <ilstam@amazon.co.uk>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Stamatis, Ilias" <ilstam@amazon.co.uk>,
	"anup@brainfault.org" <anup@brainfault.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "paul@xen.org" <paul@xen.org>
Thread-Index: AQHa9ZCx8A2EzgbgdEWpUdHZm2E42rI644WA
Date: Tue, 27 Aug 2024 09:56:54 +0000
Message-ID: <f8ce24507b836170e1ca5df8586a3478c164386d.camel@amazon.co.uk>
References: <20240823191354.4141950-1-seanjc@google.com>
	 <20240823191354.4141950-3-seanjc@google.com>
In-Reply-To: <20240823191354.4141950-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEE4F6C14E2545419D0E88C899647B43@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI0LTA4LTIzIGF0IDEyOjEzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGb2xkIGNvYWxlc2NlZF9tbWlvX2hhc19yb29tKCkgaW50byBpdHMgc29sZSBjYWxs
ZXIsIGNvYWxlc2NlZF9tbWlvX3dyaXRlKCksDQo+IGFzIGl0J3MgcmVhbGx5IGp1c3QgYSBzaW5n
bGUgbGluZSBvZiBjb2RlLCBoYXMgYSBnb29meSByZXR1cm4gdmFsdWUsIGFuZA0KPiBpcyB1bm5l
Y2Vzc2FyaWx5IGJyaXR0bGUuDQo+IA0KPiBFLmcuIGlmIGNvYWxlc2NlZF9tbWlvX2hhc19yb29t
KCkgd2VyZSB0byBjaGVjayByaW5nLT5sYXN0IGRpcmVjdGx5LCBvcg0KPiB0aGUgY2FsbGVyIGZh
aWxlZCB0byB1c2UgUkVBRF9PTkNFKCksIEtWTSB3b3VsZCBiZSBzdXNjZXB0aWJsZSB0byBUT0NU
T1UNCj4gYXR0YWNrcyBmcm9tIHVzZXJzcGFjZS4NCj4gDQo+IE9wcG9ydHVuaXN0aWNhbGx5IGFk
ZCBhIGNvbW1lbnQgZXhwbGFpbmluZyB3aHkgb24gZWFydGggS1ZNIGxlYXZlcyBvbmUNCj4gZW50
cnkgZnJlZSwgd2hpY2ggbWF5IG5vdCBiZSBvYnZpb3VzIHRvIHJlYWRlcnMgdGhhdCBhcmVuJ3Qg
ZmFtYWlsaWFyIHdpdGgNCg0Kcy9mYW1haWxpYXIvZmFtaWxpYXINCg0KPiByaW5nIGJ1ZmZlcnMu
DQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IENjOiBJbGlhcyBT
dGFtYXRpcyA8aWxzdGFtQGFtYXpvbi5jb20+DQo+IENjOiBQYXVsIER1cnJhbnQgPHBhdWxAeGVu
Lm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2ds
ZS5jb20+DQo+IC0tLQ0KPiAgdmlydC9rdm0vY29hbGVzY2VkX21taW8uYyB8IDI5ICsrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCsp
LCAyMSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9jb2FsZXNjZWRf
bW1pby5jIGIvdmlydC9rdm0vY29hbGVzY2VkX21taW8uYw0KPiBpbmRleCAxODRjNWM0MGM5YzEu
LjM3NWQ2Mjg1NDc1ZSAxMDA2NDQNCj4gLS0tIGEvdmlydC9rdm0vY29hbGVzY2VkX21taW8uYw0K
PiArKysgYi92aXJ0L2t2bS9jb2FsZXNjZWRfbW1pby5jDQo+IEBAIC00MCwyNSArNDAsNiBAQCBz
dGF0aWMgaW50IGNvYWxlc2NlZF9tbWlvX2luX3JhbmdlKHN0cnVjdCBrdm1fY29hbGVzY2VkX21t
aW9fZGV2ICpkZXYsDQo+ICAgICAgICAgcmV0dXJuIDE7DQo+ICB9DQo+IA0KPiAtc3RhdGljIGlu
dCBjb2FsZXNjZWRfbW1pb19oYXNfcm9vbShzdHJ1Y3Qga3ZtX2NvYWxlc2NlZF9tbWlvX2RldiAq
ZGV2LCB1MzIgbGFzdCkNCj4gLXsNCj4gLSAgICAgICBzdHJ1Y3Qga3ZtX2NvYWxlc2NlZF9tbWlv
X3JpbmcgKnJpbmc7DQo+IC0NCj4gLSAgICAgICAvKiBBcmUgd2UgYWJsZSB0byBiYXRjaCBpdCA/
ICovDQo+IC0NCj4gLSAgICAgICAvKiBsYXN0IGlzIHRoZSBmaXJzdCBmcmVlIGVudHJ5DQo+IC0g
ICAgICAgICogY2hlY2sgaWYgd2UgZG9uJ3QgbWVldCB0aGUgZmlyc3QgdXNlZCBlbnRyeQ0KPiAt
ICAgICAgICAqIHRoZXJlIGlzIGFsd2F5cyBvbmUgdW51c2VkIGVudHJ5IGluIHRoZSBidWZmZXIN
Cj4gLSAgICAgICAgKi8NCj4gLSAgICAgICByaW5nID0gZGV2LT5rdm0tPmNvYWxlc2NlZF9tbWlv
X3Jpbmc7DQo+IC0gICAgICAgaWYgKChsYXN0ICsgMSkgJSBLVk1fQ09BTEVTQ0VEX01NSU9fTUFY
ID09IFJFQURfT05DRShyaW5nLT5maXJzdCkpIHsNCj4gLSAgICAgICAgICAgICAgIC8qIGZ1bGwg
Ki8NCj4gLSAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiAtICAgICAgIH0NCj4gLQ0KPiAtICAg
ICAgIHJldHVybiAxOw0KPiAtfQ0KPiAtDQo+ICBzdGF0aWMgaW50IGNvYWxlc2NlZF9tbWlvX3dy
aXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBzdHJ1Y3Qga3ZtX2lvX2RldmljZSAqdGhpcywgZ3BhX3QgYWRkciwNCj4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBpbnQgbGVuLCBjb25zdCB2b2lkICp2YWwpDQo+IEBAIC03
Miw5ICs1MywxNSBAQCBzdGF0aWMgaW50IGNvYWxlc2NlZF9tbWlvX3dyaXRlKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwNCj4gDQo+ICAgICAgICAgc3Bpbl9sb2NrKCZkZXYtPmt2bS0+cmluZ19sb2Nr
KTsNCj4gDQo+ICsgICAgICAgLyoNCj4gKyAgICAgICAgKiBsYXN0IGlzIHRoZSBpbmRleCBvZiB0
aGUgZW50cnkgdG8gZmlsbC4gIFZlcmlmeSB1c2Vyc3BhY2UgaGFzbid0DQo+ICsgICAgICAgICog
c2V0IGxhc3QgdG8gYmUgb3V0IG9mIHJhbmdlLCBhbmQgdGhhdCB0aGVyZSBpcyByb29tIGluIHRo
ZSByaW5nLg0KPiArICAgICAgICAqIExlYXZlIG9uZSBlbnRyeSBmcmVlIGluIHRoZSByaW5nIHNv
IHRoYXQgdXNlcnNwYWNlIGNhbiBkaWZmZXJlbnRpYXRlDQo+ICsgICAgICAgICogYmV0d2VlbiBh
biBlbXB0eSByaW5nIGFuZCBhIGZ1bGwgcmluZy4NCj4gKyAgICAgICAgKi8NCj4gICAgICAgICBp
bnNlcnQgPSBSRUFEX09OQ0UocmluZy0+bGFzdCk7DQo+IC0gICAgICAgaWYgKCFjb2FsZXNjZWRf
bW1pb19oYXNfcm9vbShkZXYsIGluc2VydCkgfHwNCj4gLSAgICAgICAgICAgaW5zZXJ0ID49IEtW
TV9DT0FMRVNDRURfTU1JT19NQVgpIHsNCj4gKyAgICAgICBpZiAoaW5zZXJ0ID49IEtWTV9DT0FM
RVNDRURfTU1JT19NQVggfHwNCj4gKyAgICAgICAgICAgKGluc2VydCArIDEpICUgS1ZNX0NPQUxF
U0NFRF9NTUlPX01BWCA9PSBSRUFEX09OQ0UocmluZy0+Zmlyc3QpKSB7DQo+ICAgICAgICAgICAg
ICAgICBzcGluX3VubG9jaygmZGV2LT5rdm0tPnJpbmdfbG9jayk7DQo+ICAgICAgICAgICAgICAg
ICByZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICAgICAgICAgfQ0KPiAtLQ0KPiAyLjQ2LjAuMjk1Lmcz
YjllYThhMzhhLWdvb2cNCj4gDQoNClJldmlld2VkLWJ5OiBJbGlhcyBTdGFtYXRpcyA8aWxzdGFt
QGFtYXpvbi5jb20+DQo=

