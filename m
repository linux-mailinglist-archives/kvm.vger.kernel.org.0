Return-Path: <kvm+bounces-25342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73EEB9642E1
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 13:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2836E28645B
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 11:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C159918FC72;
	Thu, 29 Aug 2024 11:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="HJ1iZRxp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3989474
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 11:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724930454; cv=none; b=Tr6+CoUCvCVyrwNAy6lSaWeN1dLwT2AUHc7k/VjXnt6SLphfCfQA3+QLhXDvV4u4H0fkJnJu+dt+tOTDxLjRDJFlLlZepMbk4+Ffd0psc2zsFFeKLpCUsXdbkOhnYy9Sc6ME1jdKK6tNEbb8GKs21rCa7y/KPfeskrr19bZ86Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724930454; c=relaxed/simple;
	bh=ShJb5Epq1byOuw6FVvc33JX5kgvVHNvjyRq/Es/p0LY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fLRu/Y4H56lVDIBI6c3wXYTHo/1OIE513cEcFIaiyTDQOg8u/FTPfJy3+bJp9vBf89360tqgXjhgiquFATlfQnaUOlkj+7MbHI7lt/y88L39CHhDHYlh66SzKUcEgXd+odE9tJz3H4hv4xvQ0B2fCUF5gcFQIiqIyAafvJku9kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=HJ1iZRxp; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1724930453; x=1756466453;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ShJb5Epq1byOuw6FVvc33JX5kgvVHNvjyRq/Es/p0LY=;
  b=HJ1iZRxpPqcCRg8rSL69cyyzf41vhowfg7Y6ZypdE7N0PFbWniiMzIfa
   3cgBAuwW723sS3t1tuWNlmQSA30rDqfVGYTTR5bqB86Jul1GWe2Vte/zb
   yPemh7ebfrMzv0bJ+8/kDcfpr6p7z78+pj0DeSZMwsXJX+uV2pVXg/Mza
   E=;
X-IronPort-AV: E=Sophos;i="6.10,185,1719878400"; 
   d="scan'208";a="676936208"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 11:20:50 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:55025]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.37.143:2525] with esmtp (Farcaster)
 id 20f6468e-881b-4322-b524-0482609ac3c4; Thu, 29 Aug 2024 11:20:48 +0000 (UTC)
X-Farcaster-Flow-ID: 20f6468e-881b-4322-b524-0482609ac3c4
Received: from EX19D018EUA001.ant.amazon.com (10.252.50.145) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 29 Aug 2024 11:20:48 +0000
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19D018EUA001.ant.amazon.com (10.252.50.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 29 Aug 2024 11:20:48 +0000
Received: from EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1]) by
 EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1%3]) with mapi id
 15.02.1258.034; Thu, 29 Aug 2024 11:20:48 +0000
From: "Stamatis, Ilias" <ilstam@amazon.co.uk>
To: "Stamatis, Ilias" <ilstam@amazon.co.uk>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Durrant, Paul" <pdurrant@amazon.co.uk>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>, "Woodhouse, David"
	<dwmw@amazon.co.uk>, "paul@xen.org" <paul@xen.org>
Subject: Re: [PATCH v3 2/6] KVM: Add KVM_CREATE_COALESCED_MMIO_BUFFER ioctl
Thread-Topic: [PATCH v3 2/6] KVM: Add KVM_CREATE_COALESCED_MMIO_BUFFER ioctl
Thread-Index: AQHa8wXfyjZ7gO5vVEGp4GYQ4RYS9LI8xjQAgAFeTYA=
Date: Thu, 29 Aug 2024 11:20:48 +0000
Message-ID: <7af072f062cb4df5aac10540d4af994dc2fcd466.camel@amazon.co.uk>
References: <20240820133333.1724191-1-ilstam@amazon.com>
	 <20240820133333.1724191-3-ilstam@amazon.com> <Zs8yV4M0e4nZSdni@google.com>
In-Reply-To: <Zs8yV4M0e4nZSdni@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7CB6E1B79CDE84DB5F421421573E65B@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTA4LTI4IGF0IDA3OjI1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEF1ZyAyMCwgMjAyNCwgSWxpYXMgU3RhbWF0aXMgd3JvdGU6DQo+ID4g
VGhlIGN1cnJlbnQgTU1JTyBjb2FsZXNjaW5nIGRlc2lnbiBoYXMgYSBmZXcgZHJhd2JhY2tzIHdo
aWNoIGxpbWl0IGl0cw0KPiA+IHVzZWZ1bG5lc3MuIEN1cnJlbnRseSBhbGwgY29hbGVzY2VkIE1N
SU8gem9uZXMgdXNlIHRoZSBzYW1lIHJpbmcgYnVmZmVyLg0KPiA+IFRoYXQgbWVhbnMgdGhhdCB1
cG9uIGEgdXNlcnNwYWNlIGV4aXQgd2UgaGF2ZSB0byBoYW5kbGUgcG90ZW50aWFsbHkNCj4gPiB1
bnJlbGF0ZWQgTU1JTyB3cml0ZXMgc3luY2hyb25vdXNseS4gQW5kIGEgVk0td2lkZSBsb2NrIG5l
ZWRzIHRvIGJlDQo+ID4gdGFrZW4gaW4gdGhlIGtlcm5lbCB3aGVuIGFuIE1NSU8gZXhpdCBvY2N1
cnMuDQo+ID4gDQo+ID4gQWRkaXRpb25hbGx5LCB0aGVyZSBpcyBubyBkaXJlY3Qgd2F5IGZvciB1
c2Vyc3BhY2UgdG8gYmUgbm90aWZpZWQgYWJvdXQNCj4gPiBjb2FsZXNjZWQgTU1JTyB3cml0ZXMu
IElmIHRoZSBuZXh0IE1NSU8gZXhpdCB0byB1c2Vyc3BhY2UgaXMgd2hlbiB0aGUNCj4gPiByaW5n
IGJ1ZmZlciBoYXMgZmlsbGVkIHRoZW4gYSBzdWJzdGFudGlhbCAoYW5kIHVuYm91bmRlZCkgYW1v
dW50IG9mIHRpbWUNCj4gPiBtYXkgaGF2ZSBwYXNzZWQgc2luY2UgdGhlIGZpcnN0IGNvYWxlc2Nl
ZCBNTUlPLg0KPiA+IA0KPiA+IEFkZCBhIEtWTV9DUkVBVEVfQ09BTEVTQ0VEX01NSU9fQlVGRkVS
IGlvY3RsIHRvIEtWTS4gVGhpcyBpb2N0bCBzaW1wbHkNCj4gDQo+IFdoeSBhbGxvY2F0ZSB0aGUg
YnVmZmVyIGluIEtWTT8gIEl0IGFsbG93cyByZXVzaW5nIGNvYWxlc2NlZF9tbWlvX3dyaXRlKCkg
d2l0aG91dA0KPiBuZWVkaW5nIHtnZXQscHV0fV91c2VyKCkgb3IgYW55IGZvcm0gb2Yga21hcCgp
LCBidXQgaXQgYWRkcyBjb21wbGV4aXR5IChxdWl0ZSBhDQo+IGJpdCBpbiBmYWN0KSB0byBLVk0g
YW5kIGluaGVyaXRzIG1hbnkgb2YgdGhlIHJlc3RyaWN0aW9ucyBhbmQgd2FydHMgb2YgdGhlIGV4
aXN0aW5nDQo+IGNvYWxlc2NlZCBJL08gaW1wbGVtZW50YXRpb24uDQo+IA0KPiBFLmcuIHRoZSBz
aXplIG9mIHRoZSByaW5nIGJ1ZmZlciBpcyAiZml4ZWQiLCB5ZXQgdmFyaWFibGUgYmFzZWQgb24g
dGhlIGhvc3Qga2VybmVsDQo+IHBhZ2Ugc2l6ZS4NCj4gDQo+IFdoeSBub3QgZ28gd2l0aCBhIEJZ
T0IgbW9kZWw/ICBFLmcuIHNvIHRoYXQgdXNlcnNwYWNlIGNhbiBleHBsaWNpdGx5IGRlZmluZSB0
aGUNCj4gYnVmZmVyIHNpemUgdG8gYmVzdCBmaXQgdGhlIHByb3BlcnRpZXMgb2YgdGhlIEkvTyBy
YW5nZSwgYW5kIHRvIGF2b2lkIGFkZGl0aW9uYWwNCj4gY29tcGxleGl0eSBpbiBLVk0uDQoNCkZh
aXIgZW5vdWdoLiBJIHVzZWQgdGhlIG9yaWdpbmFsIGltcGxlbWVudGF0aW9uIGFzIGEgZ3VpZGUs
IGJ1dCBsZXQncw0KZG8gaXQgUmlnaHTihKIgdGhpcyB0aW1lLg0KDQo+IA0KPiA+IHJldHVybnMg
YSBmaWxlIGRlc2NyaXB0b3IgdG8gdGhlIGNhbGxlciBidXQgZG9lcyBub3QgYWxsb2NhdGUgYSBy
aW5nDQo+ID4gYnVmZmVyLiBVc2Vyc3BhY2UgY2FuIHRoZW4gcGFzcyB0aGlzIGZkIHRvIG1tYXAo
KSB0byBhY3R1YWxseSBhbGxvY2F0ZSBhDQo+ID4gYnVmZmVyIGFuZCBtYXAgaXQgdG8gaXRzIGFk
ZHJlc3Mgc3BhY2UuDQo+ID4gDQo+ID4gU3Vic2VxdWVudCBwYXRjaGVzIHdpbGwgYWxsb3cgdXNl
cnNwYWNlIHRvOg0KPiA+IA0KPiA+IC0gQXNzb2NpYXRlIHRoZSBmZCB3aXRoIGEgY29hbGVzY2lu
ZyB6b25lIHdoZW4gcmVnaXN0ZXJpbmcgaXQgc28gdGhhdA0KPiA+ICAgd3JpdGVzIHRvIHRoYXQg
em9uZSBhcmUgYWNjdW11bGF0ZWQgaW4gdGhhdCBzcGVjaWZpYyByaW5nIGJ1ZmZlcg0KPiA+ICAg
cmF0aGVyIHRoYW4gdGhlIFZNLXdpZGUgb25lLg0KPiA+IC0gUG9sbCBmb3IgTU1JTyB3cml0ZXMg
dXNpbmcgdGhpcyBmZC4NCj4gDQo+IFdoeT8gIEkgZ2V0IHRoZSBkZXNpcmUgZm9yIGEgZG9vcmJl
bGwsIGJ1dCBLVk0gYWxyZWFkeSBzdXBwb3J0cyAiZmFzdCIgSS9PIGZvcg0KPiBkb29yYmVsbHMu
wqANCg0KV2hhdCBkbyB5b3UgcmVmZXIgdG8gaGVyZT8gaW9ldmVudGZkPyANCg0KQ29ycmVjdCBt
ZSBpZiBJIGFtIHdyb25nLCBidXQgbXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IHdpdGggYW4NCmlv
ZXZlbnRmZCB0aGUgd3JpdGUgdmFsdWUgaXMgbm90IGF2YWlsYWJsZS4gQW5kIHRoYXQgaXMgYSBw
cm9ibGVtIHdoZW4NCnRoYXQgdmFsdWUgaXMgYSBoZWFkIG9yIHRhaWwgcG9pbnRlci4gDQoNCkkg
YWxzbyByZWFsaXNlZCB0aGF0IEkgbmVlZCB0byBpbXByb3ZlIG15IGNvbW1pdCBtZXNzYWdlcy4N
Cg0KPiAgVGhlIG9ubHkgdXNlIGNhc2UgSSBjYW4gdGhpbmsgb2YgaXMgd2hlcmUgdGhlIGRvb3Ji
ZWxsIHNpdHMgaW4gdGhlDQo+IHNhbWUgcmVnaW9uIGFzIHRoZSBkYXRhIHBheWxvYWQsIGJ1dCB0
aGF0IGVzc2VudGlhbGx5IGp1c3Qgc2F2ZXMgYW4gZW50cnkgaW4NCj4gS1ZNJ3MgTU1JTyBidXMg
KG9yIEkgc3VwcG9zZSB0d28gZW50cmllcyBpZiB0aGUgZG9vcmJlbGwgaXMgaW4gdGhlIG1pZGRs
ZSBvZg0KPiB0aGUgcmVnaW9uKS4NCj4gDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogSWxpYXMg
U3RhbWF0aXMgPGlsc3RhbUBhbWF6b24uY29tPg0KPiA+IFJldmlld2VkLWJ5OiBQYXVsIER1cnJh
bnQgPHBhdWxAeGVuLm9yZz4NCj4gPiAtLS0NCj4gDQo+IC4uLg0KPiANCj4gDQo+ID4gK3N0YXRp
YyB2b2lkIGNvYWxlc2NlZF9tbWlvX2J1ZmZlcl92bWFfY2xvc2Uoc3RydWN0IHZtX2FyZWFfc3Ry
dWN0ICp2bWEpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBrdm1fY29hbGVzY2VkX21taW9fYnVmZmVy
X2RldiAqZGV2ID0gdm1hLT52bV9wcml2YXRlX2RhdGE7DQo+ID4gKw0KPiA+ICsJc3Bpbl9sb2Nr
KCZkZXYtPnJpbmdfbG9jayk7DQo+ID4gKw0KPiA+ICsJdmZyZWUoZGV2LT5yaW5nKTsNCj4gPiAr
CWRldi0+cmluZyA9IE5VTEw7DQo+ID4gKw0KPiA+ICsJc3Bpbl91bmxvY2soJmRldi0+cmluZ19s
b2NrKTsNCj4gDQo+IEkgZG91YnQgdGhpcyBpcyBjb3JyZWN0LiAgSSBkb24ndCBzZWUgVk1fRE9O
VENPUFksIGFuZCBzbyB1c2Vyc3BhY2UgY2FuIGNyZWF0ZSBhDQo+IHNlY29uZCAob3IgbW9yZSkg
Vk1BIGJ5IGZvcmtpbmcsIGFuZCB0aGVuIEtWTSB3aWxsIGhpdCBhIFVBRiBpZiBhbnkgb2YgdGhl
IFZNQXMNCj4gaXMgY2xvc2VkLg0KDQpPb3BzLiBXaWxsIGZpeC4NCg0KPiANCj4gPiArfQ0KPiA+
ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCB2bV9vcGVyYXRpb25zX3N0cnVjdCBjb2FsZXNj
ZWRfbW1pb19idWZmZXJfdm1fb3BzID0gew0KPiA+ICsJLmNsb3NlID0gY29hbGVzY2VkX21taW9f
YnVmZmVyX3ZtYV9jbG9zZSwNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgY29hbGVz
Y2VkX21taW9fYnVmZmVyX21tYXAoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCB2bV9hcmVhX3N0
cnVjdCAqdm1hKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3Qga3ZtX2NvYWxlc2NlZF9tbWlvX2J1ZmZl
cl9kZXYgKmRldiA9IGZpbGUtPnByaXZhdGVfZGF0YTsNCj4gPiArCXVuc2lnbmVkIGxvbmcgcGZu
Ow0KPiA+ICsJaW50IHJldCA9IDA7DQo+ID4gKw0KPiA+ICsJc3Bpbl9sb2NrKCZkZXYtPnJpbmdf
bG9jayk7DQo+ID4gKw0KPiA+ICsJaWYgKGRldi0+cmluZykgew0KPiANCj4gUmVzdHJpY3Rpbmcg
dXNlcnNwYWNlIHRvIGEgc2luZ2xlIG1tYXAoKSBpcyBhIHZlcnkgYml6YXJyZSByZXN0cmljdGlv
bi4NCj4gDQoNCkhtbSwgeW91IGFyZSByaWdodC4gRXZlbiBpZiB0aGUgYnVmZmVyIGlzIGFsbG9j
YXRlZCBpbiB0aGUga2VybmVsLCBhbmQNCm9uZSB3YXMgYWxsb2NhdGVkIGFscmVhZHkgd2Ugc2hv
dWxkIGxldCB0aGUgdXNlciBtYXAgaXQgdG8gbXVsdGlwbGUNCmFkZHJlc3Nlcy4gSSB3aWxsIGZp
eCB0aGF0IHRvby4NCg0KPiA+ICsJCXJldCA9IC1FQlVTWTsNCj4gPiArCQlnb3RvIG91dF91bmxv
Y2s7DQo+ID4gKwl9DQoNClRoYW5rcyBmb3IgdGhlIHJldmlldy4NCg0KSWxpYXMNCg0K

