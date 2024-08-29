Return-Path: <kvm+bounces-25391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAC4964D06
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88158283831
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 17:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E141B6555;
	Thu, 29 Aug 2024 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="u8cwp/ma"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DE81B81A8
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 17:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724953330; cv=none; b=I9T7dfeKBFoZ+wwg7odVJjg5EjKedRgS50ZnmNKOzEGBCP/0PaQKEvb16C5jR86s4FrVZh9NsyiSdD2bpIb59NM1mPQ95anNRtGg1EfByZJ2peIlU863cWQV9sykekEm81VQvj5n0ihhY7KLXWPgqDbZG5abT/ZUXM7coeUUhVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724953330; c=relaxed/simple;
	bh=GXNfFknW+eFDm/XVS8v4ezPhinCsVB2PT/s9NNicyGA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bov2iAmNLUJO4Ip1hMmntoz9RP/lwT3ytYI5s7mxunJB6EUnM2St/rEn5BZcoMerv0bdSNFi0LjEUbH1G9dmtdExPICjCxSRVnliA6yHVWig52aCypUDL73hjhtI/RXG3ZXHYn9777++Z988A6xaEJsn+0lSKU/FxX7ymkr52bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=u8cwp/ma; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1724953329; x=1756489329;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GXNfFknW+eFDm/XVS8v4ezPhinCsVB2PT/s9NNicyGA=;
  b=u8cwp/mawX8CakSXxoY6GmlKYjC4WxVCPBkaExQf7A4UIlzAB/0UJSGN
   y3JKr0IWqbxnHoZxLRqb6QUtT9bk6YADXyMUo4gWFNXX2M7nkbtBG+wA4
   GfCbI42ZtZLkfrML9UM5QOQMTgQPSlxz9GjtTwgJo0OaCNtkfq3vf4XdM
   c=;
X-IronPort-AV: E=Sophos;i="6.10,186,1719878400"; 
   d="scan'208";a="325835284"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 17:42:06 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:2081]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.34.53:2525] with esmtp (Farcaster)
 id 949ff707-0992-4b24-a2e8-4bff21f2991f; Thu, 29 Aug 2024 17:42:04 +0000 (UTC)
X-Farcaster-Flow-ID: 949ff707-0992-4b24-a2e8-4bff21f2991f
Received: from EX19D032EUB004.ant.amazon.com (10.252.61.48) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 29 Aug 2024 17:42:03 +0000
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19D032EUB004.ant.amazon.com (10.252.61.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 29 Aug 2024 17:42:03 +0000
Received: from EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1]) by
 EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1%3]) with mapi id
 15.02.1258.034; Thu, 29 Aug 2024 17:42:03 +0000
From: "Stamatis, Ilias" <ilstam@amazon.co.uk>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Durrant, Paul" <pdurrant@amazon.co.uk>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>, "Woodhouse, David"
	<dwmw@amazon.co.uk>, "paul@xen.org" <paul@xen.org>
Subject: Re: [PATCH v3 2/6] KVM: Add KVM_CREATE_COALESCED_MMIO_BUFFER ioctl
Thread-Topic: [PATCH v3 2/6] KVM: Add KVM_CREATE_COALESCED_MMIO_BUFFER ioctl
Thread-Index: AQHa8wXfyjZ7gO5vVEGp4GYQ4RYS9LI8xjQAgAFeTYCAADxOgIAALhQA
Date: Thu, 29 Aug 2024 17:42:03 +0000
Message-ID: <3e3da65c764af0223a18deca0051ff7a3adf92fb.camel@amazon.co.uk>
References: <20240820133333.1724191-1-ilstam@amazon.com>
	 <20240820133333.1724191-3-ilstam@amazon.com> <Zs8yV4M0e4nZSdni@google.com>
	 <7af072f062cb4df5aac10540d4af994dc2fcd466.camel@amazon.co.uk>
	 <ZtCLx3zn3QznN8La@google.com>
In-Reply-To: <ZtCLx3zn3QznN8La@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4101C612755994DA0845159E2F82551@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gVGh1LCAyMDI0LTA4LTI5IGF0IDA3OjU1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEF1ZyAyOSwgMjAyNCwgSWxpYXMgU3RhbWF0aXMgd3JvdGU6DQo+ID4g
T24gV2VkLCAyMDI0LTA4LTI4IGF0IDA3OjI1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gPiByZXR1cm5zIGEgZmlsZSBkZXNjcmlwdG9yIHRvIHRoZSBjYWxsZXIgYnV0
IGRvZXMgbm90IGFsbG9jYXRlIGEgcmluZw0KPiA+ID4gPiBidWZmZXIuIFVzZXJzcGFjZSBjYW4g
dGhlbiBwYXNzIHRoaXMgZmQgdG8gbW1hcCgpIHRvIGFjdHVhbGx5IGFsbG9jYXRlIGENCj4gPiA+
ID4gYnVmZmVyIGFuZCBtYXAgaXQgdG8gaXRzIGFkZHJlc3Mgc3BhY2UuDQo+ID4gPiA+IA0KPiA+
ID4gPiBTdWJzZXF1ZW50IHBhdGNoZXMgd2lsbCBhbGxvdyB1c2Vyc3BhY2UgdG86DQo+ID4gPiA+
IA0KPiA+ID4gPiAtIEFzc29jaWF0ZSB0aGUgZmQgd2l0aCBhIGNvYWxlc2Npbmcgem9uZSB3aGVu
IHJlZ2lzdGVyaW5nIGl0IHNvIHRoYXQNCj4gPiA+ID4gICB3cml0ZXMgdG8gdGhhdCB6b25lIGFy
ZSBhY2N1bXVsYXRlZCBpbiB0aGF0IHNwZWNpZmljIHJpbmcgYnVmZmVyDQo+ID4gPiA+ICAgcmF0
aGVyIHRoYW4gdGhlIFZNLXdpZGUgb25lLg0KPiA+ID4gPiAtIFBvbGwgZm9yIE1NSU8gd3JpdGVz
IHVzaW5nIHRoaXMgZmQuDQo+ID4gPiANCj4gPiA+IFdoeT8gIEkgZ2V0IHRoZSBkZXNpcmUgZm9y
IGEgZG9vcmJlbGwsIGJ1dCBLVk0gYWxyZWFkeSBzdXBwb3J0cyAiZmFzdCIgSS9PIGZvcg0KPiA+
ID4gZG9vcmJlbGxzLsKgDQo+ID4gDQo+ID4gV2hhdCBkbyB5b3UgcmVmZXIgdG8gaGVyZT8gaW9l
dmVudGZkPyANCj4gDQo+IFlhLg0KPiANCj4gPiBDb3JyZWN0IG1lIGlmIEkgYW0gd3JvbmcsIGJ1
dCBteSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgd2l0aCBhbg0KPiA+IGlvZXZlbnRmZCB0aGUgd3Jp
dGUgdmFsdWUgaXMgbm90IGF2YWlsYWJsZS4gQW5kIHRoYXQgaXMgYSBwcm9ibGVtIHdoZW4NCj4g
PiB0aGF0IHZhbHVlIGlzIGEgaGVhZCBvciB0YWlsIHBvaW50ZXIuIA0KPiANCj4gQWguICBDYW4g
eW91IGRlc2NyaWJlIChvciBwb2ludCBhdCkgYW4gZXhhbXBsZSBkZXZpY2U/ICBJIGRvbid0IHJl
YWQgbWFueSBkZXZpY2UNCj4gc3BlY3MgKHVuZGVyc3RhdGVtZW50KS4gIEl0IHdvdWxkIGJlIGhl
bHBmdWwgdG8gaGF2ZSBhIGNvbmNyZXRlIHVzZSBjYXNlIGZvcg0KPiByZXZpZXdpbmcgdGhlIGRl
c2lnbiBpdHNlbGYuDQoNCkludGVsIDgyNTk5IFZGIGlzIG9uZSBzdWNoIGV4YW1wbGUuIEkgYmVs
aWV2ZSBOVk1lIGlzIGFub3RoZXIgZXhhbXBsZS4NCg0KPiANCj4gSW4gYSBwZXJmZWN0IHdvcmxk
LCBwb2xsKCkgc3VwcG9ydCB3b3VsZCBjb21lIGZyb20gYSB0aGlyZCBwYXJ0eSBmaWxlIHR5cGUs
IGFzDQo+IHRoaXMgZG9lc24ndCBzZWVtIF90aGF0XyB1bmlxdWUgKHRvIEtWTSkuICBCdXQgQUZB
SUNUIHRoZXJlIGlzbid0IGFuIGV4aXN0aW5nDQo+IHR5cGUgdGhhdCBpcyBhIGdvb2QgZml0LCBw
cm9iYWJseSBiZWNhdXNlIGl0J3Mgc3VjaCBhIHNpbXBsZSB0aGluZy4NCg0K

