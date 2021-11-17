Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEC3454421
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 10:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhKQJte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 04:49:34 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:32605 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbhKQJtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 04:49:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1637142395; x=1668678395;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=LEmI6WBXYcxTJDRa9KaSwTD+aAFNr6PKPnhicl5YcUU=;
  b=BN9Leuvx/5S2DtA0b/WNW7fEChkhjWJUwl5+tD8FqOFokgYnX/6ChiNH
   /y2joDLg5FMHkS4Ypj/jCzuSTeFpvmw2vJv3hDtzEdBxSmw9owhQLrcay
   jE21EGvIzxHaW1PTbFd5KWNPmbQOxRou8nQ30ieXBv2+tOAJ34Cw/uyw/
   k=;
X-IronPort-AV: E=Sophos;i="5.87,241,1631577600"; 
   d="scan'208";a="42073659"
Subject: Re: There is a null-ptr-deref bug in kvm_dirty_ring_get in
 virt/kvm/dirty_ring.c
Thread-Topic: There is a null-ptr-deref bug in kvm_dirty_ring_get in virt/kvm/dirty_ring.c
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 17 Nov 2021 09:46:19 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com (Postfix) with ESMTPS id 7722541591;
        Wed, 17 Nov 2021 09:46:19 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 17 Nov 2021 09:46:19 +0000
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 17 Nov 2021 09:46:18 +0000
Received: from EX13D08UEE001.ant.amazon.com ([10.43.62.126]) by
 EX13D08UEE001.ant.amazon.com ([10.43.62.126]) with mapi id 15.00.1497.026;
 Wed, 17 Nov 2021 09:46:18 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "butterflyhuangxx@gmail.com" <butterflyhuangxx@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AQHXxreOTE1P+MiJT0+87zK1gaBo/KwHon+A
Date:   Wed, 17 Nov 2021 09:46:18 +0000
Message-ID: <4b739ed0ce31e459eb8af9f5b0e2b1516d8e4517.camel@amazon.co.uk>
References: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
         <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
In-Reply-To: <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.61.150]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DE2CA63E476C446BBD868BFDE90C188@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIxLTEwLTIxIGF0IDIyOjA4ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAxOC8xMC8yMSAxOToxNCwgYnV0dDNyZmx5aDRjayB3cm90ZToNCj4gPiB7DQo+ID4gc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1ID0ga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKTsgIC8vLS0tLS0tLT4g
aW52b2tlDQo+ID4ga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKSB0byBnZXQgYSB2Y3B1Lg0KPiA+IA0K
PiA+IFdBUk5fT05fT05DRSh2Y3B1LT5rdm0gIT0ga3ZtKTsgWzFdDQo+ID4gDQo+ID4gcmV0dXJu
ICZ2Y3B1LT5kaXJ0eV9yaW5nOw0KPiA+IH0NCj4gPiBgYGANCj4gPiBidXQgd2UgaGFkIG5vdCBj
YWxsZWQgS1ZNX0NSRUFURV9WQ1BVIGlvY3RsIHRvIGNyZWF0ZSBhIGt2bV92Y3B1IHNvDQo+ID4g
dmNwdSBpcyBOVUxMLg0KPiANCj4gSXQncyBub3QganVzdCBiZWNhdXNlIHRoZXJlIHdhcyBubyBj
YWxsIHRvIEtWTV9DUkVBVEVfVkNQVTsgaW4gZ2VuZXJhbA0KPiBrdm0tPmRpcnR5X3Jpbmdfc2l6
ZSBvbmx5IHdvcmtzIGlmIGFsbCB3cml0ZXMgYXJlIGFzc29jaWF0ZWQgdG8gYQ0KPiBzcGVjaWZp
YyB2Q1BVLCB3aGljaCBpcyBub3QgdGhlIGNhc2UgZm9yIHRoZSBvbmUgb2YNCj4ga3ZtX3hlbl9z
aGFyZWRfaW5mb19pbml0Lg0KPiANCj4gRGF2aWQsIHdoYXQgZG8geW91IHRoaW5rPyAgTWFraW5n
IGRpcnR5LXBhZ2UgcmluZyBidWZmZXIgaW5jb21wYXRpYmxlDQo+IHdpdGggWGVuIGlzIHVnbHkg
YW5kIEknZCByYXRoZXIgYXZvaWQgaXQ7IHRha2luZyB0aGUgbXV0ZXggZm9yIHZjcHUgMCBpcw0K
PiBub3QgYW4gb3B0aW9uIGJlY2F1c2UsIGFzIHRoZSByZXBvcnRlciBzYWlkLCB5b3UgbWlnaHQg
bm90IGhhdmUgZXZlbg0KPiBjcmVhdGVkIGEgdkNQVSB5ZXQgd2hlbiB5b3UgY2FsbCBLVk1fWEVO
X0hWTV9TRVRfQVRUUi4gIFRoZSByZW1haW5pbmcNCj4gb3B0aW9uIHdvdWxkIGJlIGp1c3QgImRv
IG5vdCBtYXJrIHRoZSBwYWdlIGFzIGRpcnR5IGlmIHRoZSByaW5nIGJ1ZmZlcg0KPiBpcyBhY3Rp
dmUiLiAgVGhpcyBpcyBmZWFzaWJsZSBiZWNhdXNlIHVzZXJzcGFjZSBpdHNlbGYgaGFzIHBhc3Nl
ZCB0aGUNCj4gc2hhcmVkIGluZm8gZ2ZuOyBidXQgYWdhaW4sIGl0J3MgdWdseS4uLg0KDQpJIHRo
aW5rIEkgYW0gY29taW5nIHRvIHF1aXRlIGxpa2UgdGhhdCAncmVtYWluaW5nIG9wdGlvbicgYXMg
bG9uZyBhcyB3ZQ0KcmVwaHJhc2UgaXQgYXMgZm9sbG93czoNCg0KIEtWTSBkb2VzIG5vdCBtYXJr
IHRoZSBzaGFyZWRfaW5mbyBwYWdlIGFzIGRpcnR5LCBhbmQgdXNlcnNwYWNlIGlzDQogZXhwZWN0
ZWQgdG8gKmFzc3VtZSogdGhhdCBpdCBpcyBkaXJ0eSBhdCBhbGwgdGltZXMuIEl0J3MgdXNlZCBm
b3INCiBkZWxpdmVyaW5nIGV2ZW50IGNoYW5uZWwgaW50ZXJydXB0cyBhbmQgdGhlIG92ZXJoZWFk
IG9mIG1hcmtpbmcgaXQNCiBkaXJ0eSBlYWNoIHRpbWUgaXMganVzdCBwb2ludGxlc3MuDQoNCkkn
dmUgbWVyZ2VkIHRoZSBwYXRjaCBJIHNlbnQgeWVzdGVyZGF5IGludG8gbXkgcGZuY2FjaGUgc2Vy
aWVzIGJlY2F1c2UNCkkgcmVhbGlzZWQgd2UgbmVlZGVkIHRoZSBzYW1lIHRoZXJlLCBidXQgSSds
bCBsb29rIGF0IG1ha2luZyB0aGUgWGVuDQpjb2RlICpub3QqIG1hcmsgdGhlIHNoaW5mbyBwYWdl
IGRpcnR5IHdoZW4gaXQgd3JpdGVzIHRoZSBjbG9jayBkYXRhDQp0aGVyZS4NCgoKCkFtYXpvbiBE
ZXZlbG9wbWVudCBDZW50cmUgKExvbmRvbikgTHRkLiBSZWdpc3RlcmVkIGluIEVuZ2xhbmQgYW5k
IFdhbGVzIHdpdGggcmVnaXN0cmF0aW9uIG51bWJlciAwNDU0MzIzMiB3aXRoIGl0cyByZWdpc3Rl
cmVkIG9mZmljZSBhdCAxIFByaW5jaXBhbCBQbGFjZSwgV29yc2hpcCBTdHJlZXQsIExvbmRvbiBF
QzJBIDJGQSwgVW5pdGVkIEtpbmdkb20uCgoK

