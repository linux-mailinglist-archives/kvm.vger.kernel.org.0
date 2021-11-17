Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430CB454CD1
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 19:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbhKQSNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 13:13:24 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:62012 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239853AbhKQSNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 13:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1637172624; x=1668708624;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=L7eYNCatf98o0OVRz1xdXyOPpz/h225YkD6qGr3EHhU=;
  b=K8mFl9oTXaDIgT8PprXfJxRCm3AqvjQKRzPJbZPWhQnuQ/NJIXHWxP4L
   P2TRxMDAo5GSxUQYut0XtzzfRNI+qEuMYnAN0yGw/4Qa9PlAa0XjIGCg8
   LGB36GZiYV2OfHTOXnyISoGNaSiZ3Smo1F/ez6824+ZBx2xkJLmiUIaHW
   M=;
X-IronPort-AV: E=Sophos;i="5.87,241,1631577600"; 
   d="scan'208";a="155846001"
Subject: Re: There is a null-ptr-deref bug in kvm_dirty_ring_get in
 virt/kvm/dirty_ring.c
Thread-Topic: There is a null-ptr-deref bug in kvm_dirty_ring_get in virt/kvm/dirty_ring.c
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 17 Nov 2021 18:10:15 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com (Postfix) with ESMTPS id B99D88151D;
        Wed, 17 Nov 2021 18:10:12 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 17 Nov 2021 18:10:11 +0000
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 17 Nov 2021 18:10:11 +0000
Received: from EX13D08UEE001.ant.amazon.com ([10.43.62.126]) by
 EX13D08UEE001.ant.amazon.com ([10.43.62.126]) with mapi id 15.00.1497.026;
 Wed, 17 Nov 2021 18:10:11 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "butterflyhuangxx@gmail.com" <butterflyhuangxx@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AQHXxreOTE1P+MiJT0+87zK1gaBo/KwHon+AgAB2LACAABadAA==
Date:   Wed, 17 Nov 2021 18:10:11 +0000
Message-ID: <f83554ba7bfea1ab45d316db4b68569382727175.camel@amazon.co.uk>
References: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
         <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
         <4b739ed0ce31e459eb8af9f5b0e2b1516d8e4517.camel@amazon.co.uk>
         <20eddd70-7abb-e1a8-a003-62ed08fc1cac@redhat.com>
In-Reply-To: <20eddd70-7abb-e1a8-a003-62ed08fc1cac@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.61.150]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2FD3256A0D8374293D2EFDD32743229@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIxLTExLTE3IGF0IDE3OjQ5ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAxMS8xNy8yMSAxMDo0NiwgV29vZGhvdXNlLCBEYXZpZCB3cm90ZToNCj4gPiA+IFRoZSBy
ZW1haW5pbmcNCj4gPiA+IG9wdGlvbiB3b3VsZCBiZSBqdXN0ICJkbyBub3QgbWFyayB0aGUgcGFn
ZSBhcyBkaXJ0eSBpZiB0aGUgcmluZyBidWZmZXINCj4gPiA+IGlzIGFjdGl2ZSIuICBUaGlzIGlz
IGZlYXNpYmxlIGJlY2F1c2UgdXNlcnNwYWNlIGl0c2VsZiBoYXMgcGFzc2VkIHRoZQ0KPiA+ID4g
c2hhcmVkIGluZm8gZ2ZuOyBidXQgYWdhaW4sIGl0J3MgdWdseS4uLg0KPiA+IEkgdGhpbmsgSSBh
bSBjb21pbmcgdG8gcXVpdGUgbGlrZSB0aGF0ICdyZW1haW5pbmcgb3B0aW9uJyBhcyBsb25nIGFz
IHdlDQo+ID4gcmVwaHJhc2UgaXQgYXMgZm9sbG93czoNCj4gPiANCj4gPiAgIEtWTSBkb2VzIG5v
dCBtYXJrIHRoZSBzaGFyZWRfaW5mbyBwYWdlIGFzIGRpcnR5LCBhbmQgdXNlcnNwYWNlIGlzDQo+
ID4gICBleHBlY3RlZCB0byphc3N1bWUqICB0aGF0IGl0IGlzIGRpcnR5IGF0IGFsbCB0aW1lcy4g
SXQncyB1c2VkIGZvcg0KPiA+ICAgZGVsaXZlcmluZyBldmVudCBjaGFubmVsIGludGVycnVwdHMg
YW5kIHRoZSBvdmVyaGVhZCBvZiBtYXJraW5nIGl0DQo+ID4gICBkaXJ0eSBlYWNoIHRpbWUgaXMg
anVzdCBwb2ludGxlc3MuDQo+IA0KPiBGb3IgdGhlIGNhc2Ugb2YgZGlydHktYml0bWFwLCBvbmUg
c29sdXRpb24gY291bGQgYmUgdG8gb25seSBzZXQgYSBib29sDQo+IGFuZCBhY3R1YWxseSBtYXJr
IHRoZSBwYWdlIGRpcnR5IGxhemlseSwgYXQgdGhlIHRpbWUgb2YNCj4gS1ZNX0dFVF9ESVJUWV9M
T0cuICBGb3IgZGlydHktcmluZywgSSBhZ3JlZSB0aGF0IGl0J3MgZWFzaWVzdCBpZg0KPiB1c2Vy
c3BhY2UganVzdCAia25vd3MiIHRoZSBwYWdlIGlzIGRpcnR5Lg0KDQpUQkggd2UgZ2V0IHRoYXQg
Zm9ybWVyIGJlaGF2aW91ciBmb3IgZnJlZSBpZiB3ZSBqdXN0IGRvIHRoZSBhY2Nlc3MgdmlhDQp0
aGUgc2hpbnkgbmV3IGdmbl90b19wZm5fY2FjaGUuIFRoZSBwYWdlIGlzIG1hcmtlZCBkaXJ0eSBv
bmNlLCB3aGVuIHRoZQ0KY2FjaGUgaXMgaW52YWxpZGF0ZWQuIEkgd2FzIGFjdHVhbGx5IHRlbXB0
ZWQgdG8gYXZvaWQgZXZlbiBzZXR0aW5nIHRoZQ0KZGlydHkgYml0IGV2ZW4gd2hlbiB3ZSB3cml0
ZSB0byB0aGUgc2hpbmZvIHBhZ2UuDQoNCk5vbmUgb2Ygd2hpY2ggKmltbWVkaWF0ZWx5KiBzb2x2
ZXMgaXQgZm9yIHRoZSB3YWxsIGNsb2NrIHBhcnQgYmVjYXVzZQ0Kd2UganVzdCBjYWxsIHRoZSBz
YW1lIGt2bV93cml0ZV93YWxsX2Nsb2NrKCkgdGhhdCB0aGUgS1ZNIE1TUiB2ZXJzaW9uDQppbnZv
a2VzLCBhbmQgdGhhdCB1c2VzIGt2bV93cml0ZV9ndWVzdCgpLg0KDQpJIHRoaW5rIEknbGwganVz
dCByZWltcGxlbWVudCB0aGUgaW50ZXJlc3RpbmcgcGFydCBvZg0Ka3ZtX3dyaXRlX3dhbGxfY2xv
Y2soKSBkaXJlY3RseSBpbiBrdm1feGVuX3NoYXJlZF9pbmZvX2luaXQoKS4gSSBkb24ndA0KbXVj
aCBsaWtlIHRoZSBkdXBsaWNhdGlvbiBidXQgaXQgaXNuJ3QgbXVjaCBhbmQgaXQncyB0aGUgc2lt
cGxlc3QNCm9wdGlvbiBJIHNlZS4gQW5kIGl0IGFjdHVhbGx5IHNpbXBsaWZpZXMga3ZtX3dyaXRl
X3dhbGxfY2xvY2soKSB3aGljaA0Kbm8gbG9uZ2VyIG5lZWRzIHRoZSAnc2VjX2hpX29mcycgYXJn
dW1lbnQuIEFuZCB0aGUgWGVuIHZlcnNpb24gaXMgYWxzbw0Kc2ltcGxlciBiZWNhdXNlIGl0IGNh
biBqdXN0IGFjY2VzcyB0aGUga2VybmVsIG1hcHBpbmcgZGlyZWN0bHkuDQoKCgpBbWF6b24gRGV2
ZWxvcG1lbnQgQ2VudHJlIChMb25kb24pIEx0ZC4gUmVnaXN0ZXJlZCBpbiBFbmdsYW5kIGFuZCBX
YWxlcyB3aXRoIHJlZ2lzdHJhdGlvbiBudW1iZXIgMDQ1NDMyMzIgd2l0aCBpdHMgcmVnaXN0ZXJl
ZCBvZmZpY2UgYXQgMSBQcmluY2lwYWwgUGxhY2UsIFdvcnNoaXAgU3RyZWV0LCBMb25kb24gRUMy
QSAyRkEsIFVuaXRlZCBLaW5nZG9tLgoKCg==

