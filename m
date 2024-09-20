Return-Path: <kvm+bounces-27207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC99897D408
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 12:13:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D0691C20EE0
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 10:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52DEF13C827;
	Fri, 20 Sep 2024 10:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="iMisntQx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ECA1F60A
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 10:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726827178; cv=none; b=aBR6v9NrAJx4Thgus0KIGl2XsamhLQ0X0bHFUnHWyNMk+Fboqj/ezI3MsRxfD1qXHpBRy2zaXLcnpwt+3uJA75vZJPYF6DP4rk+u3KQ1c3Cgt0ZM2sfI85ClFmashEQF9vYku/rcrh3raUehTHweucvWe6DM2ZkxTvLeDpNpaok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726827178; c=relaxed/simple;
	bh=1JHmjw7QMNGDtqilEywwf0ed+pw5TjF6z/RCiXLxpGg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hpEQiCZfnxAnpQ5TicwbNXF8NOon+3Phu5V1Q1Aabz6kiF8Ax6T03FhkL+64gMXCxSToMfUP27CJlGV2gEIGX26aaLz5PPNEkmIguJHiKbtQYqwjIWxfAMRLCaZms12NQkKL27/Ii12CtyWn7DrJAZPixQz8qhVO5PniG/QcDHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=iMisntQx; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726827177; x=1758363177;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=1JHmjw7QMNGDtqilEywwf0ed+pw5TjF6z/RCiXLxpGg=;
  b=iMisntQxFFkHF7scX5n867+jjuRiEWA5qVuMUzaW/GisVV8L7pjkc8P7
   3Owv4vWmf/AAK5seUhiyfFOxyGeDtqmhyeqztxWTh8E4zLcWjA7FbJUxY
   0Pk46h/hv3SQkl5JpRKC2Yzqa7LUPaTdb/WsA0uHCR8SzR6NCLKEUUQ9F
   E=;
X-IronPort-AV: E=Sophos;i="6.10,244,1719878400"; 
   d="scan'208";a="456105080"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2024 10:12:51 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:58745]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.12:2525] with esmtp (Farcaster)
 id 0d98d482-c0d6-4f01-8e68-bb9bd4049837; Fri, 20 Sep 2024 10:12:49 +0000 (UTC)
X-Farcaster-Flow-ID: 0d98d482-c0d6-4f01-8e68-bb9bd4049837
Received: from EX19D017EUB004.ant.amazon.com (10.252.51.70) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 20 Sep 2024 10:12:49 +0000
Received: from EX19D018EUC002.ant.amazon.com (10.252.51.143) by
 EX19D017EUB004.ant.amazon.com (10.252.51.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 20 Sep 2024 10:12:49 +0000
Received: from EX19D018EUC002.ant.amazon.com ([fe80::59f1:9703:f248:892f]) by
 EX19D018EUC002.ant.amazon.com ([fe80::59f1:9703:f248:892f%3]) with mapi id
 15.02.1258.034; Fri, 20 Sep 2024 10:12:49 +0000
From: "Janpoladyan, Lilit" <lilitj@amazon.de>
To: Oliver Upton <oliver.upton@linux.dev>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org"
	<maz@kernel.org>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "Zamler, Shiran" <shiranz@amazon.com>
Subject: Re: [PATCH 0/8] *** RFC: ARM KVM dirty tracking device ***
Thread-Topic: [PATCH 0/8] *** RFC: ARM KVM dirty tracking device ***
Thread-Index: AQHbCd9gSIT2Jn71hUWtg2pZwkDFcrJe1C6AgAHE4wA=
Date: Fri, 20 Sep 2024 10:12:49 +0000
Message-ID: <56DFFCE6-C626-4621-8DF7-A39A72143A54@amazon.de>
References: <20240918152807.25135-1-lilitj@amazon.com>
 <Zuvq18Nrgy6j_pZW@linux.dev>
In-Reply-To: <Zuvq18Nrgy6j_pZW@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <98EEDE6D8E8E854F852A8CD02E0DDF09@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64

SGkgT2xpdmVyLA0KDQrvu79PbiAxOS4wOS4yNCwgMTE6MTIsICJPbGl2ZXIgVXB0b24iIDxvbGl2
ZXIudXB0b25AbGludXguZGV2IDxtYWlsdG86b2xpdmVyLnVwdG9uQGxpbnV4LmRldj4+IHdyb3Rl
Og0KDQo+IEhpIExpbGl0LA0KDQoNCj4gK2NjIGt2bWFybSBtYWlsaW5nIGxpc3QsIGdldF9tYWlu
dGFpbmVyIGlzIHlvdXIgZnJpZW5kIDopDQoNCg0KPiBPbiBXZWQsIFNlcCAxOCwgMjAyNCBhdCAw
MzoyNzo1OVBNICswMDAwLCBMaWxpdCBKYW5wb2xhZHlhbiB3cm90ZToNCj4gPiBBbiBleGFtcGxl
IG9mIGEgZGV2aWNlIHRoYXQgdHJhY2tzIGFjY2Vzc2VzIHRvIHN0YWdlLTIgdHJhbnNsYXRpb25z
IGFuZCB3aWxsDQo+ID4gaW1wbGVtZW50IHBhZ2VfdHJhY2tpbmdfZGV2aWNlIGludGVyZmFjZSBp
cyBBV1MgR3Jhdml0b24gUGFnZSBUcmFja2luZyBBZ2VudA0KPiA+IChQVEEpLiBXZSdsbCBiZSBw
b3N0aW5nIGNvZGUgZm9yIHRoZSBHcmF2aXRvbiBQVEEgZGV2aWNlIGRyaXZlciBpbiBhIHNlcGFy
YXRlDQo+ID4gc2VyaWVzIG9mIHBhdGNoZXMuDQoNCg0KPiBJbiBvcmRlciB0byBhY3R1YWxseSBy
ZXZpZXcgdGhlc2UgcGF0Y2hlcywgd2UgbmVlZCB0byBzZWUgYW4NCj4gaW1wbGVtZW50YXRpb24g
b2Ygc3VjaCBhIHBhZ2UgdHJhY2tpbmcgZGV2aWNlLiBPdGhlcndpc2UgaXQncyBoYXJkIHRvDQo+
IHRlbGwgdGhhdCB0aGUgaW50ZXJmYWNlIGFjY29tcGxpc2hlcyB0aGUgcmlnaHQgYWJzdHJhY3Rp
b25zLg0KDQpXZSdsbCBiZSBwb3N0aW5nIGRyaXZlciBwYXRjaGVzIGluIHRoZSBjb21pbmcgd2Vl
a3MsIHRoZXkgc2hvdWxkIGV4cGxhaW4gZGV2aWNlDQpmdW5jdGlvbmFsaXR5Lg0KDQoNCj4gQmV5
b25kIHRoYXQsIEkgaGF2ZSBzb21lIHJlc2VydmF0aW9ucyBhYm91dCBtYWludGFpbmluZyBzdXBw
b3J0IGZvcg0KPiBmZWF0dXJlcyB0aGF0IGNhbm5vdCBhY3R1YWxseSBiZSB0ZXN0ZWQgb3V0c2lk
ZSBvZiB5b3VyIG93biBlbnZpcm9ubWVudC4NCg0KSSB1bmRlcnN0YW5kLCB3ZSdsbCBzZWUgaG93
IHdlIGNhbiBlbXVsYXRlIHRoZSBmdW5jdGlvbmFsaXR5IGFuZCBtYWtlIGludGVyZmFjZQ0KdGVz
dGFibGUuDQoNCj4gPiBXaGVuIEFSTSBhcmNoaXRlY3R1cmFsIHNvbHV0aW9uIChGRUFUX0hEQlNT
IGZlYXR1cmUpIGlzIGF2YWlsYWJsZSwgd2UgaW50ZW5kIHRvDQo+ID4gdXNlIGl0IHZpYSB0aGUg
c2FtZSBpbnRlcmZhY2UgbW9zdCBsaWtlbHkgd2l0aCBhZGFwdGF0aW9ucy4NCg0KDQo+IFdpbGwg
dGhlIFBUQSBzdHVmZiBldmVudHVhbGx5IGdldCByZXRpcmVkIG9uY2UgeW91IGdldCBzdXBwb3J0
IGZvciBGRUFUX0hEQlNTDQo+IGluIGhhcmR3YXJlPw0KDQpXZSdkIG5lZWQgdG8ga2VlcCB0aGUg
aW50ZXJmYWNlIGZvciBhcyBsb25nIGFzIGhhcmR3YXJlIHdpdGhvdXQgRkVBVF9IREJTUw0KYnV0
IHdpdGggUFRBIGlzIGluIHVzZSwgaGVuY2UgdGhlIGF0dGVtcHQgb2YgZ2VuZXJhbGlzYXRpb24u
DQoNCj4gSSB0aGluayB0aGUgYmVzdCB3YXkgZm9yd2FyZCBoZXJlIGlzIHRvIGltcGxlbWVudCB0
aGUgYXJjaGl0ZWN0dXJlLCBhbmQNCj4gaG9wZWZ1bGx5IGFmdGVyIHRoYXQgeW91ciBsZWdhY3kg
ZHJpdmVyIGNhbiBiZSBtYWRlIHRvIGZpdCB0aGUNCj4gaW50ZXJmYWNlLiBUaGUgRlZQIGltcGxl
bWVudHMgRkVBVF9IREJTUywgc28gdGhlcmUncyBzb21lIChzbG93KQ0KPiByZWZlcmVuY2UgaGFy
ZHdhcmUgdG8gdGVzdCBhZ2FpbnN0Lg0KDQpUaGFua3MgZm9yIHRoZSBpZGVhLCB3ZSdsbCB0ZXN0
IHdpdGggRlZQLCBidXQgd2UnZCBuZWVkIEZFQVRfSERCU1MNCmRvY3VtZW50YXRpb24gZm9yIHRo
YXQuIEkgZG9uJ3QgdGhpbmsgaXQncyBhdmFpbGFibGUgeWV0LCBpcyBpdD8NCg0KPiBUaGlzIGlz
IGEgdmVyeSBpbnRlcmVzdGluZyBmZWF0dXJlLCBzbyBob3BlZnVsbHkgd2UgY2FuIG1vdmUgdG93
YXJkcw0KPiBzb21ldGhpbmcgd29ya2FibGUuDQoNCg0KPiAtLSANCj4gVGhhbmtzLA0KPiBPbGl2
ZXINCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2ssIHdlJ2xsIGJlIHdvcmtpbmcgb24gdGhlIGRp
c2N1c3NlZCBwb2ludHMsDQpMaWxpdA0KDQoKCgpBbWF6b24gV2ViIFNlcnZpY2VzIERldmVsb3Bt
ZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2No
YWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0
cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDI1Nzc2NCBCClNp
dHo6IEJlcmxpbgpVc3QtSUQ6IERFIDM2NSA1MzggNTk3Cg==


