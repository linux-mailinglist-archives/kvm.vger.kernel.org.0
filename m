Return-Path: <kvm+bounces-28048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93EB699274A
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 10:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C4A42842AA
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 08:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0524118DF6E;
	Mon,  7 Oct 2024 08:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="pgs0mvBR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAC618C010;
	Mon,  7 Oct 2024 08:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728290400; cv=none; b=tgZAQAr8Vi7rcQ3D5Bqj0D/BNCgfAw0N4ijdu3NOCgpKgvubfAYdypOrPX0O6lCkcuSbYyMYMfcelBPzgAKlVX6/yuGqOJGwxikf9kMSHadZgtzoD1PTZpcz2+y5PFT9wFmfBgPpbx9xxn5aaPpco0ZVtWwWB9PG6syhjqpOrSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728290400; c=relaxed/simple;
	bh=EBAjgvul+ZTB8DVmIuz8Y4+ZgX34R4lHsqOrjUlZgKc=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Lk2KUlFugWTNpvYw0sLWaUXiHMdYTL49EE5WiJMTlpHeVBgRutUsKqAdRo8tgC4H/ZPY3qjOD0lxLwqobVlQCyeF09wzZYQ1wsB3euiPGkFKwJtpuh39FS8E94ZiTMC+05UcexEwkESizUqk0ly0+IiK8ygPV1+ZmoyVx9A0VYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=pgs0mvBR; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1728290399; x=1759826399;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=EBAjgvul+ZTB8DVmIuz8Y4+ZgX34R4lHsqOrjUlZgKc=;
  b=pgs0mvBRtoSefTKT6YxJle5Od7eAzfxgNc2/86ucYbNtnbR6s3WGxA3/
   wMjz76Ajd+R6ctNZKrcngsJbQ3LX8MdmmQHMBQk+qEU3nWYBduiPVwgws
   QoLHU/qioxsv/nPwS83vLs4Kqdwq+h03OWxrgSpiWM3ET5TnpNfyhmnP5
   M=;
X-IronPort-AV: E=Sophos;i="6.11,183,1725321600"; 
   d="scan'208";a="237253782"
Subject: Re: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Thread-Topic: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 08:39:56 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:29908]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.11.190:2525] with esmtp (Farcaster)
 id 40ed856a-621f-402f-880b-1aefd5a3859d; Mon, 7 Oct 2024 08:39:54 +0000 (UTC)
X-Farcaster-Flow-ID: 40ed856a-621f-402f-880b-1aefd5a3859d
Received: from EX19D004EUC002.ant.amazon.com (10.252.51.225) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 7 Oct 2024 08:39:54 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D004EUC002.ant.amazon.com (10.252.51.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 7 Oct 2024 08:39:54 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1258.034; Mon, 7 Oct 2024 08:39:54 +0000
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
	"will@kernel.org" <will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>
Thread-Index: AQHbCCwuWjwUDEQNSEmjPqzUeT3bK7Jz6OkAgAcvr4A=
Date: Mon, 7 Oct 2024 08:39:53 +0000
Message-ID: <d6328467adc9b7512f6dd88a6f8f843b8efdc154.camel@amazon.com>
References: <20240916113102.710522-1-jgowans@amazon.com>
	 <20240916113102.710522-6-jgowans@amazon.com>
	 <20241002185520.GL1369530@ziepe.ca>
In-Reply-To: <20241002185520.GL1369530@ziepe.ca>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <212419BEF6508A4BAF19C4A337C1FD5D@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gV2VkLCAyMDI0LTEwLTAyIGF0IDE1OjU1IC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIE1vbiwgU2VwIDE2LCAyMDI0IGF0IDAxOjMwOjU0UE0gKzAyMDAsIEphbWVzIEdvd2Fu
cyB3cm90ZToNCj4gPiBOb3cgYWN0dWFsbHkgaW1wbGVtZW50aW5nIHRoZSBzZXJpYWxpc2UgY2Fs
bGJhY2sgZm9yIGlvbW11ZmQuDQo+ID4gT24gS0hPIGFjdGl2YXRlLCBpdGVyYXRlIHRocm91Z2gg
YWxsIHBlcnNpc3RlZCBkb21haW5zIGFuZCB3cml0ZSB0aGVpcg0KPiA+IG1ldGFkYXRhIHRvIHRo
ZSBkZXZpY2UgdHJlZSBmb3JtYXQuIEZvciBub3cganVzdCBhIGZldyBmaWVsZHMgYXJlDQo+ID4g
c2VyaWFsaXNlZCB0byBkZW1vbnN0cmF0ZSB0aGUgY29uY2VwdC4gVG8gYWN0dWFsbHkgbWFrZSB0
aGlzIHVzZWZ1bCBhDQo+ID4gbG90IG1vcmUgZmllbGQgYW5kIHJlbGF0ZWQgb2JqZWN0cyB3aWxs
IG5lZWQgdG8gYmUgc2VyaWFsaXNlZCB0b28uDQo+IA0KPiBCdXQgaXNuJ3QgdGhhdCBhIHJhdGhl
ciBkaWZmaWN1bHQgcHJvYmxlbT8gVGhlICJhIGxvdCBtb3JlIGZpZWxkcyINCj4gaW5jbHVkZSB0
aGluZ3MgbGlrZSBwb2ludGVycyB0byB0aGUgbW0gc3RydWN0LCB0aGUgdXNlcl9zdHJ1Y3QgYW5k
DQo+IHRhc2tfc3RydWN0LCB0aGVuIGFsbCB0aGUgcGlubmluZyBhY2NvdW50aW5nIGFzIHdlbGwu
DQo+IA0KPiBDb21pbmcgd29yayBleHRlbmRzIHRoaXMgdG8gbWVtZmRzIGFuZCBtb3JlIGlzIGNv
bWluZy4gSSB3b3VsZCBleHBlY3QNCj4gdGhpcyBLSE8gc3R1ZmYgdG8gdXNlIHRoZSBtZW1mZC1s
aWtlIHBhdGggdG8gYWNjZXNzIHRoZSBwaHlzaWNhbCBWTQ0KPiBtZW1vcnkgdG9vLg0KPiANCj4g
SSB0aGluayBleHBlY3RpbmcgdG8gc2VyaWFsaXplIGFuZCByZXN0b3JlIGV2ZXJ5dGhpbmcgbGlr
ZSB0aGlzIGlzDQo+IHByb2JhYmx5IG11Y2ggdG9vIGNvbXBsaWNhdGVkLg0KDQpPbiByZWZsZWN0
aW9uIEkgdGhpbmsgeW91J3JlIHJpZ2h0IC0gdGhpcyB3aWxsIGJlIGNvbXBsZXggYm90aCBmcm9t
IGENCmRldmVsb3BtZW50IGFuZCBhIG1haW50ZW5hbmNlIHBlcnNwZWN0aXZlLCB0cnlpbmcgdG8g
bWFrZSBzdXJlIHdlDQpzZXJpYWxpc2UgYWxsIHRoZSBuZWNlc3Nhcnkgc3RhdGUgYW5kIHJlY29u
c3RydWN0IGl0IGNvcnJlY3RseS4gRXZlbg0KbW9yZSBjb21wbGV4IHdoZW4gc3RydWN0cyBhcmUg
cmVmYWN0b3JlZC9jaGFuZ2VkIGFjcm9zcyBrZXJuZWwgdmVyc2lvbnMuDQpBbiBpbXBvcnRhbnQg
cmVxdWlyZW1lbnQgb2YgdGhpcyBmdW5jdGlvbmFsaXR5IGlzIHRoZSBhYmlsaXR5IHRvIGtleGVj
DQpiZXR3ZWVuIGRpZmZlcmVudCBrZXJuZWwgdmVyc2lvbnMgaW5jbHVkaW5nIGdvaW5nIGJhY2sg
dG8gYW4gb2xkZXINCmtlcm5lbCB2ZXJzaW9uIGluIHRoZSBjYXNlIG9mIGEgcm9sbGJhY2suDQoN
ClNvLCBsZXQncyBsb29rIGF0IG90aGVyIG9wdGlvbnM6DQoNCj4gDQo+IElmIHlvdSBjb3VsZCBq
dXN0IHJldGFpbiBhIHNtYWxsIHBvcnRpb24gYW5kIHRoZW4gZGlyZWN0bHkgcmVjb25zdHJ1Y3QN
Cj4gdGhlIG1pc3NpbmcgcGFydHMgaXQgc2VlbXMgbGlrZSBpdCB3b3VsZCBiZSBtb3JlIG1haW50
YWluYWJsZS4NCg0KSSB0aGluayB3ZSBoYXZlIHR3byBvdGhlciBwb3NzaWJsZSBhcHByb2FjaGVz
IGhlcmU6DQoNCjEuIFdoYXQgdGhpcyBSRkMgaXMgc2tldGNoaW5nIG91dCwgc2VyaWFsaXNpbmcg
ZmllbGRzIGZyb20gdGhlIHN0cnVjdHMNCmFuZCBzZXR0aW5nIHRob3NlIGZpZWxkcyBhZ2FpbiBv
biBkZXNlcmlhbGlzZS4gQXMgeW91IHBvaW50IG91dCB0aGlzDQp3aWxsIGJlIGNvbXBsaWNhdGVk
Lg0KDQoyLiBHZXQgdXNlcnNwYWNlIHRvIGRvIHRoZSB3b3JrOiB1c2Vyc3BhY2UgbmVlZHMgdG8g
cmUtZG8gdGhlIGlvY3Rscw0KYWZ0ZXIga2V4ZWMgdG8gcmVjb25zdHJ1Y3QgdGhlIG9iamVjdHMu
IE15IG1haW4gaXNzdWUgd2l0aCB0aGlzIGFwcHJvYWNoDQppcyB0aGF0IHRoZSBrZXJuZWwgbmVl
ZHMgdG8gZG8gc29tZSBzb3J0IG9mIHRydXN0IGJ1dCB2ZXJpZnkgYXBwcm9hY2ggdG8NCmVuc3Vy
ZSB0aGF0IHVzZXJzcGFjZSBjb25zdHJ1Y3RzIGV2ZXJ5dGhpbmcgdGhlIHNhbWUgd2F5IGFmdGVy
IGtleGVjIGFzDQppdCB3YXMgYmVmb3JlIGtleGVjLiBXZSBkb24ndCB3YW50IHRvIGVuZCB1cCBp
biBhIHN0YXRlIHdoZXJlIHRoZQ0KaW9tbXVmZCBvYmplY3RzIGRvbid0IG1hdGNoIHRoZSBwZXJz
aXN0ZWQgcGFnZSB0YWJsZXMuDQoNCjMuIFNlcmlhbGlzZSBhbmQgcmVwbHkgdGhlIGlvY3Rscy4g
SW9jdGwgQVBJcyBhbmQgcGF5bG9hZHMgc2hvdWxkDQoobXVzdD8pIGJlIHN0YWJsZSBhY3Jvc3Mg
a2VybmVsIHZlcnNpb25zLiBJZiBJT01NVUZEIHJlY29yZHMgdGhlIGlvY3Rscw0KZXhlY3V0ZWQg
YnkgdXNlcnNwYWNlIHRoZW4gaXQgY291bGQgcmVwbGF5IHRoZW0gYXMgcGFydCBvZiBkZXNlcmlh
bGlzZQ0KYW5kIGdpdmUgdXNlcnNwYWNlIGEgaGFuZGxlIHRvIHRoZSByZXN1bHRpbmcgb2JqZWN0
cyBhZnRlciBrZXhlYy4gVGhpcw0Kd2F5IHdlIGFyZSBndWFyYW50ZWVkIGNvbnNpc3RlbnQgaW9t
bXVmZCAvIElPQVMgb2JqZWN0cy4gQnkgImNvbnNpc3RlbnQiDQpJIG1lYW4gdGhleSBhcmUgdGhl
IHNhbWUgYXMgYmVmb3JlIGtleGVjIGFuZCBtYXRjaCB0aGUgcGVyc2lzdGVkIHBhZ2UNCnRhYmxl
cy4gQnkgaGF2aW5nIHRoZSBrZXJuZWwgZG8gdGhpcyBpdCBtZWFucyBpdCBkb2Vzbid0IG5lZWQg
dG8gZGVwZW5kDQpvbiB1c2Vyc3BhY2UgZG9pbmcgdGhlIGNvcnJlY3QgdGhpbmcuDQoNCldoYXQg
ZG8geW91IHRoaW5rIG9mIHRoaXMgM3JkIGFwcHJvYWNoPyBJIGNhbiB0cnkgdG8gc2tldGNoIGl0
IG91dCBhbmQNCnNlbmQgYW5vdGhlciBSRkMgaWYgeW91IHRoaW5rIGl0IHNvdW5kcyByZWFzb25h
YmxlLg0KDQo+IA0KPiBJZSAicmVjb3ZlciIgYSBIV1BUIGZyb20gYSBLSE8gb24gYSBtYW51YWxs
eSBjcmVhdGVkIGEgSU9BUyB3aXRoIHRoZQ0KPiByaWdodCAibWVtZmQiIGZvciB0aGUgYmFja2lu
ZyBzdG9yYWdlLiBUaGVuIHRoZSByZWNvdmVyeSBjYW4ganVzdA0KPiB2YWxpZGF0ZSB0aGF0IHRo
aW5ncyBhcmUgY29ycmVjdCBhbmQgYWRvcHQgdGhlIGlvbW11X2RvbWFpbiBhcyB0aGUNCj4gaHdw
dC4NCg0KVGhpcyBzb3VuZHMgbW9yZSBsaWtlIG9wdGlvbiAyIHdoZXJlIHdlIGV4cGVjdCB1c2Vy
c3BhY2UgdG8gcmUtZHJpdmUgdGhlDQppb2N0bHMsIGJ1dCB2ZXJpZnkgdGhhdCB0aGV5IGhhdmUg
Y29ycmVzcG9uZGluZyBwYXlsb2FkcyBhcyBiZWZvcmUga2V4ZWMNCnNvIHRoYXQgaW9tbXVmZCBv
YmplY3RzIGFyZSBjb25zaXN0ZW50IHdpdGggcGVyc2lzdGVkIHBhZ2UgdGFibGVzLg0KSWYgdGhl
IGtlcm5lbCBpcyBkb2luZyB2ZXJpZmljYXRpb24gd291bGRuJ3QgaXQgYmUgYmV0dGVyIGZvciB0
aGUga2VybmVsDQp0byBkbyB0aGUgaW9jdGwgd29yayBpdHNlbGYgYW5kIGdpdmUgdGhlIHJlc3Vs
dGluZyBvYmplY3RzIHRvIHVzZXJzcGFjZT8NCg0KPiANCj4gRXZlbnR1YWxseSB5b3UnbGwgd2Fu
dCB0aGlzIHRvIHdvcmsgZm9yIHRoZSB2aW9tbXVzIGFzIHdlbGwsIGFuZCB0aGF0DQo+IHNlZW1z
IGxpa2UgYSBsb3QgbW9yZSB0cmlja3kgY29tcGxleGl0eS4uDQo+IA0KPiBKYXNvbg0KDQo=

