Return-Path: <kvm+bounces-25137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9374796078D
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 12:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 198F12821B8
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 10:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F43919DF74;
	Tue, 27 Aug 2024 10:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="dlwzdtdN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0B6182B2
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 10:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724754926; cv=none; b=uoLVhYp4m0in+WFB4OROx+J2zhwN2JME1CtYBv8UCdUY82+rbdAEtVyXrCJui7qhZNGS1c/w9l8yp+EIlQe5isZwKP8bE9WCAY4hzmIjfcdRoCJOqyoCrSCQD+/BDTOOgHYBSj2ZBKa414atVY2qG02N0q9gdT60fB97fHIQ9+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724754926; c=relaxed/simple;
	bh=SiFD4PONuUuyfZKvmIQhjY2gwgaM9F1s4jTcMngdEa8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V+5xBBuyQ/iDpCrEaPnEooV7rvWBkRQIxfJeSQfLo4M/4z9fmsIjBEMz+ecG8QkfcaTpAEH1kvzaDR47Jo6O8TAOpBohC4I6+IT3jGFpLmf8mEzRK2B/nYBFqPS27tgZT6FJMViXgyY+roZ6TJf8JMPCi4fPfM3QOLd9WsQ+Kio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=dlwzdtdN; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1724754924; x=1756290924;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SiFD4PONuUuyfZKvmIQhjY2gwgaM9F1s4jTcMngdEa8=;
  b=dlwzdtdN1EEDZoZE5T+pn9wRFsR1OD1l/3vlumJ+WS2MtOBS9PxlrxFN
   Tur41sxl+O5FazCSS0/6ZEAhnquN6iMww11+R1m6yX2Q0P7G6YbHdrKrt
   UozedrcUftyM+I3W/aG7jmQl50Chpb9jL4kUKk4w19fa6/+N+hGzx/Uq9
   s=;
X-IronPort-AV: E=Sophos;i="6.10,180,1719878400"; 
   d="scan'208";a="119683107"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 10:35:21 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:8543]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.7.11:2525] with esmtp (Farcaster)
 id f6e6a4d5-c08f-4d74-a6e6-399954a66ecd; Tue, 27 Aug 2024 10:35:21 +0000 (UTC)
X-Farcaster-Flow-ID: f6e6a4d5-c08f-4d74-a6e6-399954a66ecd
Received: from EX19D018EUA001.ant.amazon.com (10.252.50.145) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 27 Aug 2024 10:35:20 +0000
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19D018EUA001.ant.amazon.com (10.252.50.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 27 Aug 2024 10:35:20 +0000
Received: from EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1]) by
 EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1%3]) with mapi id
 15.02.1258.034; Tue, 27 Aug 2024 10:35:20 +0000
From: "Stamatis, Ilias" <ilstam@amazon.co.uk>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Stamatis, Ilias" <ilstam@amazon.co.uk>,
	"seanjc@google.com" <seanjc@google.com>
CC: "nh-open-source@amazon.com" <nh-open-source@amazon.com>, "Durrant, Paul"
	<pdurrant@amazon.co.uk>, "Woodhouse, David" <dwmw@amazon.co.uk>
Subject: Re:  [PATCH v2 0/6] KVM: Improve MMIO Coalescing API
Thread-Topic: [PATCH v2 0/6] KVM: Improve MMIO Coalescing API
Thread-Index: AQHa+GzQXkC3BZ+Z1keeK9l4T4uGAQ==
Date: Tue, 27 Aug 2024 10:35:20 +0000
Message-ID: <a6868d49f658ee8f935aee4910696e817b0c4b92.camel@amazon.co.uk>
References: <20240718193543.624039-1-ilstam@amazon.com>
	 <172442195625.3956685.13979535644680422623.b4-ty@google.com>
In-Reply-To: <172442195625.3956685.13979535644680422623.b4-ty@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4A79106905EB547B28009D55FCD3234@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI0LTA4LTIzIGF0IDE2OjQ3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIDE4IEp1bCAyMDI0IDIwOjM1OjM3ICswMTAwLCBJbGlhcyBTdGFtYXRp
cyB3cm90ZToNCj4gPiBUaGUgY3VycmVudCBNTUlPIGNvYWxlc2NpbmcgZGVzaWduIGhhcyBhIGZl
dyBkcmF3YmFja3Mgd2hpY2ggbGltaXQgaXRzDQo+ID4gdXNlZnVsbmVzcy4gQ3VycmVudGx5IGFs
bCBjb2FsZXNjZWQgTU1JTyB6b25lcyB1c2UgdGhlIHNhbWUgcmluZyBidWZmZXIuDQo+ID4gVGhh
dCBtZWFucyB0aGF0IHVwb24gYSB1c2Vyc3BhY2UgZXhpdCB3ZSBoYXZlIHRvIGhhbmRsZSBwb3Rl
bnRpYWxseQ0KPiA+IHVucmVsYXRlZCBNTUlPIHdyaXRlcyBzeW5jaHJvbm91c2x5LiBBbmQgYSBW
TS13aWRlIGxvY2sgbmVlZHMgdG8gYmUNCj4gPiB0YWtlbiBpbiB0aGUga2VybmVsIHdoZW4gYW4g
TU1JTyBleGl0IG9jY3Vycy4NCj4gPiANCj4gPiBBZGRpdGlvbmFsbHksIHRoZXJlIGlzIG5vIGRp
cmVjdCB3YXkgZm9yIHVzZXJzcGFjZSB0byBiZSBub3RpZmllZCBhYm91dA0KPiA+IGNvYWxlc2Nl
ZCBNTUlPIHdyaXRlcy4gSWYgdGhlIG5leHQgTU1JTyBleGl0IHRvIHVzZXJzcGFjZSBpcyB3aGVu
IHRoZQ0KPiA+IHJpbmcgYnVmZmVyIGhhcyBmaWxsZWQgdGhlbiBhIHN1YnN0YW50aWFsIChhbmQg
dW5ib3VuZGVkKSBhbW91bnQgb2YgdGltZQ0KPiA+IG1heSBoYXZlIHBhc3NlZCBzaW5jZSB0aGUg
Zmlyc3QgY29hbGVzY2VkIE1NSU8uDQo+ID4gDQo+ID4gWy4uLl0NCj4gDQo+IEFwcGxpZWQgcGF0
Y2ggMSB0byBrdm0teDg2IGdlbmVyaWMuICBJIGRlbGliZXJhdGVseSBkaWRuJ3QgcHV0IHRoaXMg
aW4gZml4ZXMgb3INCj4gQ2M6IGl0IGZvciBzdGFibGUsIGFzIHRoZSBidWcgaGFzIGJlZW4gYXJv
dW5kIGZvciBzb29vIGxvbmcgd2l0aG91dCBhbnlvbmUNCj4gbm90aWNpbmcgdGhhdCB0aGVyZSdz
IGJhc2ljYWxseSB6ZXJvIGNoYW5jZSB0aGF0IHRoZSBidWcgaXMgYWN0aXZlbHkgY2F1c2luZw0K
PiBpc3N1ZXMuDQo+IA0KPiBJIGFsc28gcmV3b3JrZWQgYW5kIGV4cGFuZGVkIHRoZSBjaGFuZ2Vs
b2cgc2lnbmlmaWNhbnRseSB0byBtYWtlIGl0IG1vcmUgY2xlYXINCj4gd2h5IHRoaW5ncyBicmVh
aywgd2hhdCB0aGUgZmFsbG91dCBpcyAoS1ZNIGNhbiBfc29tZXRpbWVzXyB1c2UgdGhlIGZ1bGwg
cmluZyksDQo+IGFuZCB0byBjYWxsIG91dCB0aGF0IHRoZSBsb2NrbGVzcyBzY2hlbWUgdGhhdCB0
aGUgYnVnZ3kgY29tbWl0IHdhcyBwcmVwYXJpbmcNCj4gZm9yIG5ldmVyIHNlZW1zIHRvIGhhdmUg
bGFuZGVkLg0KPiANCj4gUGxlYXNlIHRha2UgYSBnYW5kZXIgYXQgdGhlIGNoYW5nZWxvZyBhbmQg
aG9sbGVyIGlmIEkgbWVzc2VkIGFueXRoaW5nIHVwLg0KPiANCj4gWzEvNl0gS1ZNOiBGaXggY29h
bGVzY2VkX21taW9faGFzX3Jvb20oKSB0byBhdm9pZCBwcmVtYXR1cmUgdXNlcnNwYWNlIGV4aXQN
Cj4gICAgICAgaHR0cHM6Ly9naXRodWIuY29tL2t2bS14ODYvbGludXgvY29tbWl0LzkyZjZkNDEz
MDQ5Nw0KPiANCj4gLS0NCj4gaHR0cHM6Ly9naXRodWIuY29tL2t2bS14ODYvbGludXgvdHJlZS9u
ZXh0DQoNCkl0IGxvb2tzIGdvb2QsIHRoYW5rcy4NCg0KPiBEb2gsIEkgYXBwbGllZCB2MiBpbnN0
ZWFkIG9mIHYzLiAgVGhvdWdoIHVubGVzcyBtaW5lIGV5ZXMgZGVjZWl2ZSBtZSwNCj4gdGhleSdy
ZSB0aGUgc2FtZS4NCg0KVGhleSBhcmUgdGhlIHNhbWUgaW5kZWVkLg0KDQpJJ20gbm90IGVudGly
ZWx5IHN1cmUgd2hhdCdzIHRoZSByZWNvbW1lbmRlZCB0aGluZyB0byBkbyB3aGVuIHVwZGF0aW5n
DQpvbmx5IHNvbWUgb2YgdGhlIHBhdGNoZXMgb2YgYSBzZXJpZXMsIHdoZXRoZXIgdG8gc2VuZCBu
ZXcgdmVyc2lvbnMgZm9yDQp0aGUgcmV2aXNlZCBwYXRjaGVzIG9ubHkgb3IgcmVzZW5kIGV2ZXJ5
dGhpbmcuIEkgb3B0ZWQgdG8gZG8gdGhlIGxhdHRlcg0KYW5kIHRoZW4gSSBjYWxsZWQgb3V0IHRo
ZSBjaGFuZ2VzIGJldHdlZW4gdjIgYW5kIHYzIGluc2lkZSB0aGUgcGF0Y2hlcw0KdGhhdCB3ZXJl
IGFjdHVhbGx5IG1vZGlmaWVkLg0KDQpUaGFua3MsDQpJbGlhcw0KDQo=

