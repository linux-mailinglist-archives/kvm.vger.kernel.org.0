Return-Path: <kvm+bounces-28454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E98C998B19
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 17:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B2A2293BA5
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 15:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D5E01CBEA7;
	Thu, 10 Oct 2024 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="NqSAje06"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50FD1CB309;
	Thu, 10 Oct 2024 15:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728573139; cv=none; b=bghxGybJebt8/kw6JXIEge8OPd1t1kye3mrML0rf2tED+dveOQZ8vBYS7bM3rufhMX4jvhGu+odrH3XEio/+tNyO55B4QAto5lY2P6rk+VnFfjERVHEdu86u+1HpjwlQceVEVQiKgG5VQJbSIIeQYB7x156S9+mIyiRAN/o8X9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728573139; c=relaxed/simple;
	bh=XYbYMyrvyIZznB5NrpkR3LG5qcSt9nJ42W4qjIjJPrY=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GvXxyCHylVnhwGFbInP8ew6qrC34w5lEVkRy8KMfCGiP9qlSmhGZctzJ+rKgbsDD6omhq51TQDB+zdKpsYljglBgn464WI5YmVCJ3W0c/7w2BRVQi2bkKG+9qeq1uQt0MlOBydwPzfXv9038ZEkXC7POQTDSZZUJEvM0JcjqkWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=NqSAje06; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1728573138; x=1760109138;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=XYbYMyrvyIZznB5NrpkR3LG5qcSt9nJ42W4qjIjJPrY=;
  b=NqSAje06bXGmt+6LHi5gvcYmBNDgSUv7XZgrAnOLeIGJuhjxz3iuZKTD
   ZGnpZH39sEUtbz9cUx+du+sBmgJX3qu11/mSzML7lMKexkw7F9TqZFVTx
   EIoAtY20NImb0ZTRXlv1U/Y1XskahQMXS4j/O6PtR1bB8RazIANe3iBwo
   Q=;
X-IronPort-AV: E=Sophos;i="6.11,193,1725321600"; 
   d="scan'208";a="459640414"
Subject: Re: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Thread-Topic: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 15:12:11 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:42932]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.0.200:2525] with esmtp (Farcaster)
 id 90e4b000-0dbf-4a04-b95f-00a5f0e18b9e; Thu, 10 Oct 2024 15:12:10 +0000 (UTC)
X-Farcaster-Flow-ID: 90e4b000-0dbf-4a04-b95f-00a5f0e18b9e
Received: from EX19D004EUC002.ant.amazon.com (10.252.51.225) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 10 Oct 2024 15:12:10 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D004EUC002.ant.amazon.com (10.252.51.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 10 Oct 2024 15:12:09 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1258.034; Thu, 10 Oct 2024 15:12:09 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "jgg@ziepe.ca" <jgg@ziepe.ca>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "kw@linux.com" <kw@linux.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "madvenka@linux.microsoft.com"
	<madvenka@linux.microsoft.com>, "anthony.yznaga@oracle.com"
	<anthony.yznaga@oracle.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Saenz Julienne, Nicolas"
	<nsaenz@amazon.es>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "dwmw2@infradead.org"
	<dwmw2@infradead.org>, "steven.sistare@oracle.com"
	<steven.sistare@oracle.com>, "Graf (AWS), Alexander" <graf@amazon.de>,
	"will@kernel.org" <will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>,
	"maz@kernel.org" <maz@kernel.org>
Thread-Index: AQHbCCwuWjwUDEQNSEmjPqzUeT3bK7Jz6OkAgAcvr4CAAAJBgIAAAo+AgABl3QCAAu2RAIAADFAAgAHADQA=
Date: Thu, 10 Oct 2024 15:12:09 +0000
Message-ID: <673df8a09723d3398ca9e9c638893547b0b0ec63.camel@amazon.com>
References: <20240916113102.710522-1-jgowans@amazon.com>
	 <20240916113102.710522-6-jgowans@amazon.com>
	 <20241002185520.GL1369530@ziepe.ca>
	 <d6328467adc9b7512f6dd88a6f8f843b8efdc154.camel@amazon.com>
	 <e458d48a797043b7efc853fc65b9c4d043b12ed4.camel@infradead.org>
	 <1d331c55a299d414e49ba5eb6f46dccb525bf788.camel@amazon.com>
	 <20241007150138.GM2456194@ziepe.ca>
	 <b76aa005c0fb75199cbb1fa0790858b9c808c90a.camel@amazon.com>
	 <20241009122830.GF762027@ziepe.ca>
In-Reply-To: <20241009122830.GF762027@ziepe.ca>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8E3F23707ECCD428D0DF754138CB191@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTEwLTA5IGF0IDA5OjI4IC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFdlZCwgT2N0IDA5LCAyMDI0IGF0IDExOjQ0OjMwQU0gKzAwMDAsIEdvd2FucywgSmFt
ZXMgd3JvdGU6DQo+IA0KPiA+IE9rYXksIGJ1dCBpbiBnZW5lcmFsIHRoaXMgc3RpbGwgbWVhbnMg
dGhhdCB0aGUgcGFnZSB0YWJsZXMgbXVzdCBoYXZlDQo+ID4gZXhhY3RseSB0aGUgc2FtZSB0cmFu
c2xhdGlvbnMgaWYgd2UgdHJ5IHRvIHN3aXRjaCBmcm9tIG9uZSBzZXQgdG8NCj4gPiBhbm90aGVy
LiBJZiBpdCBpcyBwb3NzaWJsZSB0byBjaGFuZ2UgdHJhbnNsYXRpb25zIHRoZW4gdHJhbnNsYXRp
b24gdGFibGUNCj4gPiBlbnRyaWVzIGNvdWxkIGJlIGNyZWF0ZWQgYXQgZGlmZmVyZW50IGdyYW51
bGFyaXR5IChQVEUsIFBNRCwgUFVEKSBsZXZlbA0KPiA+IHdoaWNoIHdvdWxkIHZpb2xhdGUgdGhp
cyByZXF1aXJlbWVudC4NCj4gDQo+IFllcywgYnV0IHdlIHN0cml2ZSB0byBtYWtlIHBhZ2UgdGFi
bGVzIGNvbnNpc3RlbnRseSBhbmQgaXQgaXNuJ3QgdGhhdA0KPiBvZnRlbiB0aGF0IHdlIGdldCBu
ZXcgZmVhdHVyZXMgdGhhdCB3b3VsZCBjaGFuZyB0aGUgbGF5b3V0IChjb250aWcgYml0DQo+IGZv
ciBpbnN0YW5jZSkuIEknZCBzdWdnZXN0IGluIHRoZXNlIGNhc2VzIHlvdSdkIGFkZCBzb21lIGNy
ZWF0aW9uIGZsYWcNCj4gdG8gdGhlIEhXUFQgdGhhdCBjYW4gaW5oaWJpdCB0aGUgbmV3IGZlYXR1
cmUgYW5kIHlvdXIgVk1NIHdpbGwgZGVhbA0KPiB3aXRoIGl0Lg0KPiANCj4gT3IgeW91IHN3ZWVw
IGl0IGFuZCBtYW51YWxseSBzcGxpdC9qb2luIHRvIGRlYWwgd2l0aCBCQk0gPCBsZXZlbA0KPiAy
LiBHZW5lcmljIHB0IHdpbGwgaGF2ZSBjb2RlIHRvIGRvIGFsbCBvZiB0aGlzIHNvIGl0IGlzIG5v
dCB0aGF0IGJhZC4NCj4gDQo+IElmIHRoaXMgbGl0dGxlIGlzc3VlIGFscmVhZHkgc2NhcmVzIHlv
dSB0aGVuIEkgZG9uJ3QgdGhpbmsgSSB3YW50IHRvDQo+IHNlZSB5b3Ugc2VyaWFsaXplIGFueXRo
aW5nIG1vcmUgY29tcGxleCwgdGhlcmUgYXJlIGVuZGxlc3Mgc2NlbmFyaW9zDQo+IGZvciBjb21w
YXRpYmlsaXR5IHByb2JsZW1zIDpcDQoNClRoZSB0aGluZ3MgdGhhdCBzY2FyZSBtZSBpcyBzb21l
IHN1YnRsZSBwYWdlIHRhYmxlIGRpZmZlcmVuY2Ugd2hpY2gNCmNhdXNlcyBzaWxlbnQgZGF0YSBj
b3JydXB0aW9uLi4uIFRoaXMgaXMgb25lIG9mIHRoZSByZWFzb25zIEkgbGlrZWQgcmUtDQp1c2lu
ZyB0aGUgZXhpc3RpbmcgdGFibGVzLCB0aGVyZSBpcyBubyB3YXkgZm9yIHRoaXMgc29ydCBvZiBz
dWJ0bGUgYnVnDQp0byBoYXBwZW4uDQpJbiBnZW5lcmFsIEkgYWdyZWUgd2l0aCB5b3VyIHBvaW50
IGFib3V0IHJlZHVjaW5nIHRoZSBjb21wbGV4aXR5IG9mIHdoYXQNCndlIHNlcmlhbGlzZSBhbmQg
cmF0aGVyIGV4ZXJjaXNpbmcgdGhlIG1hY2hpbmVyeSBhZ2FpbiBhZnRlciBrZXhlYyB0bw0KY3Jl
YXRlIGZyZXNoIG9iamVjdHMuIFRoZSBvbmx5ICg/KSBjb3VudGVyIHBvaW50IHRvIHRoYXQgaXMg
YWJvdXQNCnBlcmZvcm1hbmNlIG9mIGFueXRoaW5nIGluIHRoZSBob3QgcGF0aCAoZGlzY3Vzc2Vk
IG1vcmUgYmVsb3cpLg0KDQoNCj4gDQo+ID4gSWYgd2Ugc2F5IHRoYXQgdG8gYmUgc2FmZS9jb3Jy
ZWN0IGluIHRoZSBnZW5lcmFsIGNhc2UgdGhlbiBpdCBpcw0KPiA+IG5lY2Vzc2FyeSBmb3IgdGhl
IHRyYW5zbGF0aW9ucyB0byBiZSAqZXhhY3RseSogdGhlIHNhbWUgYmVmb3JlIGFuZCBhZnRlcg0K
PiA+IGtleGVjLCBpcyB0aGVyZSBhbnkgYmVuZWZpdCB0byBidWlsZGluZyBuZXcgdHJhbnNsYXRp
b24gdGFibGVzIGFuZA0KPiA+IHN3aXRjaGluZyB0byB0aGVtPyBXZSBtYXkgYXMgd2VsbCBjb250
aW51ZSB0byB1c2UgdGhlIGV4YWN0IHNhbWUgcGFnZQ0KPiA+IHRhYmxlcyBhbmQgY29uc3RydWN0
IGlvbW11ZmQgb2JqZWN0cyAoSU9BUywgZXRjKSB0byBtYXRjaC4NCj4gDQo+IFRoZSBiZW5pZml0
IGlzIHByaW5jaXBhbGx5IHRoYXQgeW91IGRpZCBhbGwgdGhlIG1hY2hpbmVyeSB0byBnZXQgdXAg
dG8NCj4gdGhhdCBwb2ludCwgaW5jbHVkaW5nIHJlLXBpbm5pbmcgYW5kIHNvIGZvcnRoIGFsbCB0
aGUgbWVtb3J5LCBpbnN0ZWFkDQo+IG9mIHRyeWluZyB0byBtYWdpY2FsbHkgcmVjb3ZlciB0aGF0
IGFkZGl0aW9uYWwgc3RhdGUuDQo+IA0KPiBUaGlzIGlzIHRoZSBwaGlsb3NvcGh5IHRoYXQgeW91
IHJlcGxheSBpbnN0ZWFkIG9mIGRlLXNlcmlhbGl6ZSwgc28geW91DQo+IGhhdmUgdG8gcmVwbGF5
IGludG8gYSBwYWdlIHRhYmxlIGF0IHNvbWUgbGV2ZWwgdG8gbWFrZSB0aGF0IHdvcmsuDQoNCldl
IGNvdWxkIGhhdmUgc29tZSAic2tpcF9wZ3RhYmxlX3VwZGF0ZSIgZmxhZyB3aGljaCB0aGUgcmVw
bGF5IG1hY2hpbmVyeQ0Kc2V0cywgYWxsb3dpbmcgSU9NTVVGRCB0byBjcmVhdGUgZnJlc2ggb2Jq
ZWN0cyBpbnRlcm5hbGx5IGFuZCBsZWF2ZSB0aGUNCnBhZ2UgdGFibGVzIGFsb25lPw0KDQpBbnl3
YXksIHRoYXQgc29ydCBvZiB0aGluZyBpcyBhIHBvdGVudGlhbCBmdXR1cmUgb3B0aW1pc2F0aW9u
IHdlIGNvdWxkDQpkby4gSW4gdGhlIGludGVyZXN0cyBvZiBtYWtpbmcgcHJvZ3Jlc3MgSSdsbCBy
ZS13b3JrIHRoaXMgUkZDIHRvIHJlLQ0KY3JlYXRlIGV2ZXJ5dGhpbmcgKGlvbW11ZmQgb2JqZWN0
cywgSU9NTVUgZHJpdmVyIGRvbWFpbnMgYW5kIHBhZ2UNCnRhYmxlcykgYW5kIGRvIHRoZSBhdG9t
aWMgaGFuZG92ZXIgb2YgcGFnZSB0YWJsZXMgYWZ0ZXIgcmUtDQppbml0aWFsaXNhdGlvbi4NCg0K
PiANCj4gDQo+ID4gdGhlbiBpdCB3b3VsZCBiZSB1c2VmdWwgdG8gYXZvaWQgcmVidWlsZGluZyBp
ZGVudGljYWwgdGFibGVzLiBNYXliZSBpdA0KPiA+IGVuZHMgdXAgYmVpbmcgaW4gdGhlICJ3YXJt
IiBwYXRoIC0gdGhlIFZNIGNhbiBzdGFydCBydW5uaW5nIGJ1dCB3aWxsDQo+ID4gc2xlZXAgaWYg
dGFraW5nIGEgcGFnZSBmYXVsdCBiZWZvcmUgSU9NTVVGRCBpcyByZS1pbml0YWxpc2VkLi4uDQo+
IA0KPiBJIGRpZG4ndCB0aGluayB5b3UnZCBzdXBwb3J0IHBhZ2UgZmF1bHRzPyBUaGVyZSBhcmUg
YmlnZ2VyIGlzc3VlcyBoZXJlDQo+IGlmIHlvdSBleHBlY3QgdG8gaGF2ZSBhIHZJT01NVSBpbiB0
aGUgZ3Vlc3QuDQoNCnZJT01NVSBpcyBvbmUgY2FzZSwgYnV0IGFub3RoZXIgaXMgbWVtb3J5IG92
ZXJzdWJzY3JpcHRpb24uIFdpdGggUFJJL0FUUw0Kd2UgY2FuIG92ZXJzdWJzY3JpYmUgbWVtb3J5
IHdoaWNoIGlzIERNQSBtYXBwZWQuIEluIHRoYXQgY2FzZSBhIHBhZ2UNCmZhdWx0IHdvdWxkIGJl
IGEgYmxvY2tpbmcgb3BlcmF0aW9uIHVudGlsIElPTU1VRkQgaXMgYWxsIHNldCB1cCBhbmQNCnJl
YWR5IHRvIGdvLiBJIHN1c3BlY3QgdGhlcmUgd2lsbCBiZSBiZW5lZml0IGluIGdldHRpbmcgdGhp
cyBmYXN0LCBidXQNCmFzIGxvbmcgYXMgd2UgaGF2ZSBhIHBhdGggdG8gb3B0aW1pc2UgaXQgaW4g
ZnV0dXJlIEknbSB0b3RhbGx5IGZpbmUgdG8NCnN0YXJ0IHdpdGggcmUtY3JlYXRpbmcgZXZlcnl0
aGluZy4NCg0KSkcNCg==

