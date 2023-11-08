Return-Path: <kvm+bounces-1191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBCA27E55D2
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:54:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6045BB20FC6
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91CF8171B1;
	Wed,  8 Nov 2023 11:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="LY9HGlJW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB90D505;
	Wed,  8 Nov 2023 11:54:11 +0000 (UTC)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A278D1BDC;
	Wed,  8 Nov 2023 03:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699444452; x=1730980452;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jWN/NUNSusUsn6RI+uWdNC4hq5SKifKzdJsG8Aqpq4g=;
  b=LY9HGlJWVhar84lBUirhTmvqMduYSvpCBUjLLqAohojRfrsx7wgKKvUC
   qwME3++jc4/190FTsjjejlLxuXBkXxMffMpilP+z2r43glAyPVBojLQkF
   z7tSxAzKJg9LG1UJScNY45F6INgJBvb0L6QCoxEJLI5I/0bd9zRIf8AxA
   I=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="369121027"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:54:09 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com (Postfix) with ESMTPS id 57C24340127;
	Wed,  8 Nov 2023 11:54:05 +0000 (UTC)
Received: from EX19MTAUWB001.ant.amazon.com [10.0.7.35:5180]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.174:2525] with esmtp (Farcaster)
 id 72f21bb4-da44-4f0f-a384-27fe822589e0; Wed, 8 Nov 2023 11:54:04 +0000 (UTC)
X-Farcaster-Flow-ID: 72f21bb4-da44-4f0f-a384-27fe822589e0
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:54:03 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 11:53:59 +0000
Message-ID: <5fcefdf3-d1ff-4244-8b58-1da0cd7e4a4f@amazon.com>
Date: Wed, 8 Nov 2023 12:53:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 05/33] KVM: x86: hyper-v: Introduce VTL call/return
 prologues in hypercall page
Content-Language: en-US
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-6-nsaenz@amazon.com>
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20231108111806.92604-6-nsaenz@amazon.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D040UWA003.ant.amazon.com (10.13.139.6) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDA4LjExLjIzIDEyOjE3LCBOaWNvbGFzIFNhZW56IEp1bGllbm5lIHdyb3RlOgo+IFZUTCBj
YWxsL3JldHVybiBoeXBlcmNhbGxzIGhhdmUgdGhlaXIgb3duIGVudHJ5IHBvaW50cyBpbiB0aGUg
aHlwZXJjYWxsCj4gcGFnZSBiZWNhdXNlIHRoZXkgZG9uJ3QgZm9sbG93IG5vcm1hbCBoeXBlci12
IGh5cGVyY2FsbCBjb252ZW50aW9ucy4KPiBNb3ZlIHRoZSBWVEwgY2FsbC9yZXR1cm4gY29udHJv
bCBpbnB1dCBpbnRvIEVDWC9SQVggYW5kIHNldCB0aGUKPiBoeXBlcmNhbGwgY29kZSBpbnRvIEVB
WC9SQ1ggYmVmb3JlIGNhbGxpbmcgdGhlIGh5cGVyY2FsbCBpbnN0cnVjdGlvbiBpbgo+IG9yZGVy
IHRvIGJlIGFibGUgdG8gdXNlIHRoZSBIeXBlci1WIGh5cGVyY2FsbCBlbnRyeSBmdW5jdGlvbi4K
Pgo+IEd1ZXN0cyBjYW4gcmVhZCBhbiBlbXVsYXRlZCBjb2RlIHBhZ2Ugb2Zmc2V0cyByZWdpc3Rl
ciB0byBrbm93IHRoZQo+IG9mZnNldHMgaW50byB0aGUgaHlwZXJjYWxsIHBhZ2UgZm9yIHRoZSBW
VEwgY2FsbC9yZXR1cm4gZW50cmllcy4KPgo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgU2Flbnog
SnVsaWVubmUgPG5zYWVuekBhbWF6b24uY29tPgo+Cj4gLS0tCj4KPiBNeSB0cmVlIGhhcyB0aGUg
YWRkaXRpb25hbCBwYXRjaCwgd2UncmUgc3RpbGwgdHJ5aW5nIHRvIHVuZGVyc3RhbmQgdW5kZXIK
PiB3aGF0IGNvbmRpdGlvbnMgV2luZG93cyBleHBlY3RzIHRoZSBvZmZzZXQgdG8gYmUgZml4ZWQu
Cj4KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2h5cGVydi5jIGIvYXJjaC94ODYva3ZtL2h5
cGVydi5jCj4gaW5kZXggNTRmN2YzNmE4OWJmLi45ZjJlYThjMzQ0NDcgMTAwNjQ0Cj4gLS0tIGEv
YXJjaC94ODYva3ZtL2h5cGVydi5jCj4gKysrIGIvYXJjaC94ODYva3ZtL2h5cGVydi5jCj4gQEAg
LTI5NCw2ICsyOTQsNyBAQCBzdGF0aWMgaW50IHBhdGNoX2h5cGVyY2FsbF9wYWdlKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgdTY0IGRhdGEpCj4KPiAgICAgICAgICAvKiBWVEwgY2FsbC9yZXR1cm4g
ZW50cmllcyAqLwo+ICAgICAgICAgIGlmICgha3ZtX3hlbl9oeXBlcmNhbGxfZW5hYmxlZChrdm0p
ICYmIGt2bV9odl92c21fZW5hYmxlZChrdm0pKSB7Cj4gKyAgICAgICAgICAgICAgIGkgPSAyMjsK
PiAgICNpZmRlZiBDT05GSUdfWDg2XzY0Cj4gICAgICAgICAgICAgICAgICBpZiAoaXNfNjRfYml0
X21vZGUodmNwdSkpIHsKPiAgICAgICAgICAgICAgICAgICAgICAgICAgLyoKPiAtLS0KPiAgIGFy
Y2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggICB8ICAyICsKPiAgIGFyY2gveDg2L2t2bS9o
eXBlcnYuYyAgICAgICAgICAgICB8IDc4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0K
PiAgIGluY2x1ZGUvYXNtLWdlbmVyaWMvaHlwZXJ2LXRsZnMuaCB8IDExICsrKysrCj4gICAzIGZp
bGVzIGNoYW5nZWQsIDkwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20va3ZtX2hvc3QuaAo+IGluZGV4IGEyZjIyNGY5NTQwNC4uMDBjZDIxYjA5ZjhjIDEwMDY0NAo+
IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPiArKysgYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9rdm1faG9zdC5oCj4gQEAgLTExMDUsNiArMTEwNSw4IEBAIHN0cnVjdCBrdm1f
aHYgewo+ICAgCXU2NCBodl90c2NfZW11bGF0aW9uX3N0YXR1czsKPiAgIAl1NjQgaHZfaW52dHNj
X2NvbnRyb2w7Cj4gICAKPiArCXVuaW9uIGh2X3JlZ2lzdGVyX3ZzbV9jb2RlX3BhZ2Vfb2Zmc2V0
cyB2c21fY29kZV9wYWdlX29mZnNldHM7Cj4gKwo+ICAgCS8qIEhvdyBtYW55IHZDUFVzIGhhdmUg
VlAgaW5kZXggIT0gdkNQVSBpbmRleCAqLwo+ICAgCWF0b21pY190IG51bV9taXNtYXRjaGVkX3Zw
X2luZGV4ZXM7Cj4gICAKPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2h5cGVydi5jIGIvYXJj
aC94ODYva3ZtL2h5cGVydi5jCj4gaW5kZXggNzhkMDUzMDQyNjY3Li5kNGIxYjUzZWE2M2QgMTAw
NjQ0Cj4gLS0tIGEvYXJjaC94ODYva3ZtL2h5cGVydi5jCj4gKysrIGIvYXJjaC94ODYva3ZtL2h5
cGVydi5jCj4gQEAgLTI1OSw3ICsyNTksOCBAQCBzdGF0aWMgdm9pZCBzeW5pY19leGl0KHN0cnVj
dCBrdm1fdmNwdV9odl9zeW5pYyAqc3luaWMsIHUzMiBtc3IpCj4gICBzdGF0aWMgaW50IHBhdGNo
X2h5cGVyY2FsbF9wYWdlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IGRhdGEpCj4gICB7Cj4g
ICAJc3RydWN0IGt2bSAqa3ZtID0gdmNwdS0+a3ZtOwo+IC0JdTggaW5zdHJ1Y3Rpb25zWzldOwo+
ICsJc3RydWN0IGt2bV9odiAqaHYgPSB0b19rdm1faHYoa3ZtKTsKPiArCXU4IGluc3RydWN0aW9u
c1sweDMwXTsKPiAgIAlpbnQgaSA9IDA7Cj4gICAJdTY0IGFkZHI7Cj4gICAKPiBAQCAtMjg1LDYg
KzI4Niw4MSBAQCBzdGF0aWMgaW50IHBhdGNoX2h5cGVyY2FsbF9wYWdlKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwgdTY0IGRhdGEpCj4gICAJLyogcmV0ICovCj4gICAJKCh1bnNpZ25lZCBjaGFyICop
aW5zdHJ1Y3Rpb25zKVtpKytdID0gMHhjMzsKPiAgIAo+ICsJLyogVlRMIGNhbGwvcmV0dXJuIGVu
dHJpZXMgKi8KPiArCWlmICgha3ZtX3hlbl9oeXBlcmNhbGxfZW5hYmxlZChrdm0pICYmIGt2bV9o
dl92c21fZW5hYmxlZChrdm0pKSB7CgoKWW91IGRvbid0IGludHJvZHVjZSBrdm1faHZfdnNtX2Vu
YWJsZWQoKSBiZWZvcmUuIFBsZWFzZSBkbyBhIHF1aWNrIHRlc3QgCmJ1aWxkIG9mIGFsbCBpbmRp
dmlkdWFsIGNvbW1pdHMgb2YgeW91ciBwYXRjaCBzZXQgZm9yIHYxIDopLgoKCj4gKyNpZmRlZiBD
T05GSUdfWDg2XzY0CgoKV2h5IGRvIHlvdSBuZWVkIHRoZSBpZmRlZiBoZXJlPyBpc19sb25nX21v
ZGUoKSBhbHJlYWR5IGhhcyBhbiBpZmRlZiB0aGF0IAp3aWxsIGFsd2F5cyByZXR1cm4gZmFsc2Ug
Zm9yIGlzXzY0X2JpdF9tb2RlKCkgb24gMzJiaXQgaG9zdHMuCgoKPiArCQlpZiAoaXNfNjRfYml0
X21vZGUodmNwdSkpIHsKPiArCQkJLyoKPiArCQkJICogVlRMIGNhbGwgNjQtYml0IGVudHJ5IHBy
b2xvZ3VlOgo+ICsJCQkgKiAJbW92ICVyY3gsICVyYXgKPiArCQkJICogCW1vdiAkMHgxMSwgJWVj
eAo+ICsJCQkgKiAJam1wIDA6Cj4gKwkJCSAqLwo+ICsJCQlodi0+dnNtX2NvZGVfcGFnZV9vZmZz
ZXRzLnZ0bF9jYWxsX29mZnNldCA9IGk7Cj4gKwkJCWluc3RydWN0aW9uc1tpKytdID0gMHg0ODsK
PiArCQkJaW5zdHJ1Y3Rpb25zW2krK10gPSAweDg5Owo+ICsJCQlpbnN0cnVjdGlvbnNbaSsrXSA9
IDB4Yzg7Cj4gKwkJCWluc3RydWN0aW9uc1tpKytdID0gMHhiOTsKPiArCQkJaW5zdHJ1Y3Rpb25z
W2krK10gPSAweDExOwo+ICsJCQlpbnN0cnVjdGlvbnNbaSsrXSA9IDB4MDA7Cj4gKwkJCWluc3Ry
dWN0aW9uc1tpKytdID0gMHgwMDsKPiArCQkJaW5zdHJ1Y3Rpb25zW2krK10gPSAweDAwOwo+ICsJ
CQlpbnN0cnVjdGlvbnNbaSsrXSA9IDB4ZWI7Cj4gKwkJCWluc3RydWN0aW9uc1tpKytdID0gMHhl
MDsKCgpJIHRoaW5rIGl0IHdvdWxkIGJlIGEgbG90IGVhc2llciB0byByZWFkIChiZWNhdXNlIGl0
J3MgZGVuc2VyKSBpZiB5b3UgCm1vdmUgdGhlIG9wY29kZXMgaW50byBhIGNoYXJhY3RlciBhcnJh
eToKCmNoYXIgdnRsX2VudHJ5W10gPSB7IDB4NDgsIDB4ODksIDB4YzgsIDB4YjksIDB4MTEsIDB4
MDAsIDB4MDAsIDB4MDAuIAoweGViLCAweGUwIH07CgphbmQgdGhlbiBqdXN0IG1lbWNweSgpLgoK
CkFsZXgKCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vu
c3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFl
Z2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVu
YnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4
NzkKCgo=


