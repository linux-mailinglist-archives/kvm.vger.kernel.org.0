Return-Path: <kvm+bounces-1189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2987E55BE
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D35B51C20A8A
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69DA6171A5;
	Wed,  8 Nov 2023 11:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="sF+2Q81j"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF5115EB2;
	Wed,  8 Nov 2023 11:44:50 +0000 (UTC)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FD81A5;
	Wed,  8 Nov 2023 03:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699443890; x=1730979890;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EXmb/az1PNhhuG3ndExhJQnVdZ2AAuMSCygQdhmDLC4=;
  b=sF+2Q81jYX4kzAFVS/jbbj+FapJbCcU0r1Vxscsim8p5gkV/VxA9/dfJ
   pQUALCkl2jaSBh0dOhvK1zLYoMQzaNbbhypVChQCJnNgO7md+CXtS33Hz
   4ti1kyxQeIL2276xmAo7CFIgAGAosLKZQ4Whw1+cQR6LwpbAODwGGs5OX
   Y=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="375135748"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:44:43 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1d-m6i4x-e651a362.us-east-1.amazon.com (Postfix) with ESMTPS id 5F6A880725;
	Wed,  8 Nov 2023 11:44:38 +0000 (UTC)
Received: from EX19MTAUWB001.ant.amazon.com [10.0.7.35:14190]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.174:2525] with esmtp (Farcaster)
 id 5a70746a-13cb-496d-8a3f-f2f2e32c7e45; Wed, 8 Nov 2023 11:44:37 +0000 (UTC)
X-Farcaster-Flow-ID: 5a70746a-13cb-496d-8a3f-f2f2e32c7e45
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:44:37 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 11:44:34 +0000
Message-ID: <82c5a8c8-2c3c-43dc-95c2-4d465fe63985@amazon.com>
Date: Wed, 8 Nov 2023 12:44:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 03/33] KVM: x86: hyper-v: Introduce XMM output support
Content-Language: en-US
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-4-nsaenz@amazon.com>
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20231108111806.92604-4-nsaenz@amazon.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDA4LjExLjIzIDEyOjE3LCBOaWNvbGFzIFNhZW56IEp1bGllbm5lIHdyb3RlOgo+IFByZXBh
cmUgaW5mcmFzdHJ1Y3R1cmUgdG8gYmUgYWJsZSB0byByZXR1cm4gZGF0YSB0aHJvdWdoIHRoZSBY
TU0KPiByZWdpc3RlcnMgd2hlbiBIeXBlci1WIGh5cGVyY2FsbHMgYXJlIGlzc3VlcyBpbiBmYXN0
IG1vZGUuIFRoZSBYTU0KPiByZWdpc3RlcnMgYXJlIGV4cG9zZWQgdG8gdXNlci1zcGFjZSB0aHJv
dWdoIEtWTV9FWElUX0hZUEVSVl9IQ0FMTCBhbmQKPiByZXN0b3JlZCBvbiBzdWNjZXNzZnVsIGh5
cGVyY2FsbCBjb21wbGV0aW9uLgo+Cj4gU2lnbmVkLW9mZi1ieTogTmljb2xhcyBTYWVueiBKdWxp
ZW5uZSA8bnNhZW56QGFtYXpvbi5jb20+Cj4gLS0tCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9o
eXBlcnYtdGxmcy5oIHwgIDIgKy0KPiAgIGFyY2gveDg2L2t2bS9oeXBlcnYuYyAgICAgICAgICAg
ICAgfCAzMyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0KPiAgIGluY2x1ZGUvdWFwaS9s
aW51eC9rdm0uaCAgICAgICAgICAgfCAgNiArKysrKysKPiAgIDMgZmlsZXMgY2hhbmdlZCwgMzkg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9oeXBlcnYtdGxmcy5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vaHlwZXJ2LXRs
ZnMuaAo+IGluZGV4IDJmZjI2ZjUzY2Q2Mi4uYWY1OTRhYTY1MzA3IDEwMDY0NAo+IC0tLSBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2h5cGVydi10bGZzLmgKPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9oeXBlcnYtdGxmcy5oCj4gQEAgLTQ5LDcgKzQ5LDcgQEAKPiAgIC8qIFN1cHBvcnQgZm9y
IHBoeXNpY2FsIENQVSBkeW5hbWljIHBhcnRpdGlvbmluZyBldmVudHMgaXMgYXZhaWxhYmxlKi8K
PiAgICNkZWZpbmUgSFZfWDY0X0NQVV9EWU5BTUlDX1BBUlRJVElPTklOR19BVkFJTEFCTEUJQklU
KDMpCj4gICAvKgo+IC0gKiBTdXBwb3J0IGZvciBwYXNzaW5nIGh5cGVyY2FsbCBpbnB1dCBwYXJh
bWV0ZXIgYmxvY2sgdmlhIFhNTQo+ICsgKiBTdXBwb3J0IGZvciBwYXNzaW5nIGh5cGVyY2FsbCBp
bnB1dCBhbmQgb3V0cHV0IHBhcmFtZXRlciBibG9jayB2aWEgWE1NCj4gICAgKiByZWdpc3RlcnMg
aXMgYXZhaWxhYmxlCj4gICAgKi8KPiAgICNkZWZpbmUgSFZfWDY0X0hZUEVSQ0FMTF9YTU1fSU5Q
VVRfQVZBSUxBQkxFCQlCSVQoNCkKPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2h5cGVydi5j
IGIvYXJjaC94ODYva3ZtL2h5cGVydi5jCj4gaW5kZXggMjM4YWZkNzMzNWU0Li5lMWJjODYxYWIz
YjAgMTAwNjQ0Cj4gLS0tIGEvYXJjaC94ODYva3ZtL2h5cGVydi5jCj4gKysrIGIvYXJjaC94ODYv
a3ZtL2h5cGVydi5jCj4gQEAgLTE4MTUsNiArMTgxNSw3IEBAIHN0cnVjdCBrdm1faHZfaGNhbGwg
ewo+ICAgCXUxNiByZXBfaWR4Owo+ICAgCWJvb2wgZmFzdDsKPiAgIAlib29sIHJlcDsKPiArCWJv
b2wgeG1tX2RpcnR5Owo+ICAgCXNzZTEyOF90IHhtbVtIVl9IWVBFUkNBTExfTUFYX1hNTV9SRUdJ
U1RFUlNdOwo+ICAgCj4gICAJLyoKPiBAQCAtMjM0Niw5ICsyMzQ3LDMzIEBAIHN0YXRpYyBpbnQg
a3ZtX2h2X2h5cGVyY2FsbF9jb21wbGV0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCByZXN1
bHQpCj4gICAJcmV0dXJuIHJldDsKPiAgIH0KPiAgIAo+ICtzdGF0aWMgdm9pZCBrdm1faHZfd3Jp
dGVfeG1tKHN0cnVjdCBrdm1faHlwZXJ2X3htbV9yZWcgKnhtbSkKPiArewo+ICsJaW50IHJlZzsK
PiArCj4gKwlrdm1fZnB1X2dldCgpOwo+ICsJZm9yIChyZWcgPSAwOyByZWcgPCBIVl9IWVBFUkNB
TExfTUFYX1hNTV9SRUdJU1RFUlM7IHJlZysrKSB7Cj4gKwkJY29uc3Qgc3NlMTI4X3QgZGF0YSA9
IHNzZTEyOCh4bW1bcmVnXS5sb3csIHhtbVtyZWddLmhpZ2gpOwo+ICsJCV9rdm1fd3JpdGVfc3Nl
X3JlZyhyZWcsICZkYXRhKTsKPiArCX0KPiArCWt2bV9mcHVfcHV0KCk7Cj4gK30KPiArCj4gK3N0
YXRpYyBib29sIGt2bV9odl9pc194bW1fb3V0cHV0X2hjYWxsKHUxNiBjb2RlKQo+ICt7Cj4gKwly
ZXR1cm4gZmFsc2U7Cj4gK30KPiArCj4gICBzdGF0aWMgaW50IGt2bV9odl9oeXBlcmNhbGxfY29t
cGxldGVfdXNlcnNwYWNlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiAgIHsKPiAtCXJldHVybiBr
dm1faHZfaHlwZXJjYWxsX2NvbXBsZXRlKHZjcHUsIHZjcHUtPnJ1bi0+aHlwZXJ2LnUuaGNhbGwu
cmVzdWx0KTsKPiArCWJvb2wgZmFzdCA9ICEhKHZjcHUtPnJ1bi0+aHlwZXJ2LnUuaGNhbGwuaW5w
dXQgJiBIVl9IWVBFUkNBTExfRkFTVF9CSVQpOwo+ICsJdTE2IGNvZGUgPSB2Y3B1LT5ydW4tPmh5
cGVydi51LmhjYWxsLmlucHV0ICYgMHhmZmZmOwo+ICsJdTY0IHJlc3VsdCA9IHZjcHUtPnJ1bi0+
aHlwZXJ2LnUuaGNhbGwucmVzdWx0Owo+ICsKPiArCWlmIChrdm1faHZfaXNfeG1tX291dHB1dF9o
Y2FsbChjb2RlKSAmJiBodl9yZXN1bHRfc3VjY2VzcyhyZXN1bHQpICYmIGZhc3QpCj4gKwkJa3Zt
X2h2X3dyaXRlX3htbSh2Y3B1LT5ydW4tPmh5cGVydi51LmhjYWxsLnhtbSk7Cj4gKwo+ICsJcmV0
dXJuIGt2bV9odl9oeXBlcmNhbGxfY29tcGxldGUodmNwdSwgcmVzdWx0KTsKPiAgIH0KPiAgIAo+
ICAgc3RhdGljIHUxNiBrdm1faHZjYWxsX3NpZ25hbF9ldmVudChzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIHN0cnVjdCBrdm1faHZfaGNhbGwgKmhjKQo+IEBAIC0yNjIzLDYgKzI2NDgsOSBAQCBpbnQg
a3ZtX2h2X2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4gICAJCWJyZWFrOwo+ICAg
CX0KPiAgIAo+ICsJaWYgKChyZXQgJiBIVl9IWVBFUkNBTExfUkVTVUxUX01BU0spID09IEhWX1NU
QVRVU19TVUNDRVNTICYmIGhjLnhtbV9kaXJ0eSkKPiArCQlrdm1faHZfd3JpdGVfeG1tKChzdHJ1
Y3Qga3ZtX2h5cGVydl94bW1fcmVnKiloYy54bW0pOwo+ICsKPiAgIGh5cGVyY2FsbF9jb21wbGV0
ZToKPiAgIAlyZXR1cm4ga3ZtX2h2X2h5cGVyY2FsbF9jb21wbGV0ZSh2Y3B1LCByZXQpOwo+ICAg
Cj4gQEAgLTI2MzIsNiArMjY2MCw4IEBAIGludCBrdm1faHZfaHlwZXJjYWxsKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkKPiAgIAl2Y3B1LT5ydW4tPmh5cGVydi51LmhjYWxsLmlucHV0ID0gaGMucGFy
YW07Cj4gICAJdmNwdS0+cnVuLT5oeXBlcnYudS5oY2FsbC5wYXJhbXNbMF0gPSBoYy5pbmdwYTsK
PiAgIAl2Y3B1LT5ydW4tPmh5cGVydi51LmhjYWxsLnBhcmFtc1sxXSA9IGhjLm91dGdwYTsKPiAr
CWlmIChoYy5mYXN0KQo+ICsJCW1lbWNweSh2Y3B1LT5ydW4tPmh5cGVydi51LmhjYWxsLnhtbSwg
aGMueG1tLCBzaXplb2YoaGMueG1tKSk7Cj4gICAJdmNwdS0+YXJjaC5jb21wbGV0ZV91c2Vyc3Bh
Y2VfaW8gPSBrdm1faHZfaHlwZXJjYWxsX2NvbXBsZXRlX3VzZXJzcGFjZTsKPiAgIAlyZXR1cm4g
MDsKPiAgIH0KPiBAQCAtMjc4MCw2ICsyODEwLDcgQEAgaW50IGt2bV9nZXRfaHZfY3B1aWQoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX2NwdWlkMiAqY3B1aWQsCj4gICAJCQllbnQt
PmVieCB8PSBIVl9FTkFCTEVfRVhURU5ERURfSFlQRVJDQUxMUzsKPiAgIAo+ICAgCQkJZW50LT5l
ZHggfD0gSFZfWDY0X0hZUEVSQ0FMTF9YTU1fSU5QVVRfQVZBSUxBQkxFOwo+ICsJCQllbnQtPmVk
eCB8PSBIVl9YNjRfSFlQRVJDQUxMX1hNTV9PVVRQVVRfQVZBSUxBQkxFOwoKClNob3VsZG4ndCB0
aGlzIGJlIGd1YXJkZWQgYnkgYW4gRU5BQkxFX0NBUCB0byBtYWtlIHN1cmUgb2xkIHVzZXIgc3Bh
Y2UgCnRoYXQgZG9lc24ndCBrbm93IGFib3V0IHhtbSBvdXRwdXRzIGlzIHN0aWxsIGFibGUgdG8g
cnVuIHdpdGggbmV3ZXIga2VybmVscz8KCgo+ICAgCQkJZW50LT5lZHggfD0gSFZfRkVBVFVSRV9G
UkVRVUVOQ1lfTVNSU19BVkFJTEFCTEU7Cj4gICAJCQllbnQtPmVkeCB8PSBIVl9GRUFUVVJFX0dV
RVNUX0NSQVNIX01TUl9BVkFJTEFCTEU7Cj4gICAKPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBp
L2xpbnV4L2t2bS5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oCj4gaW5kZXggZDdhMDE3NjZi
ZjIxLi41Y2UwNmExZWVlMmIgMTAwNjQ0Cj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5o
Cj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oCj4gQEAgLTE5Miw2ICsxOTIsMTEgQEAg
c3RydWN0IGt2bV9zMzkwX2NtbWFfbG9nIHsKPiAgIAlfX3U2NCB2YWx1ZXM7Cj4gICB9Owo+ICAg
Cj4gK3N0cnVjdCBrdm1faHlwZXJ2X3htbV9yZWcgewo+ICsJX191NjQgbG93Owo+ICsJX191NjQg
aGlnaDsKPiArfTsKPiArCj4gICBzdHJ1Y3Qga3ZtX2h5cGVydl9leGl0IHsKPiAgICNkZWZpbmUg
S1ZNX0VYSVRfSFlQRVJWX1NZTklDICAgICAgICAgIDEKPiAgICNkZWZpbmUgS1ZNX0VYSVRfSFlQ
RVJWX0hDQUxMICAgICAgICAgIDIKPiBAQCAtMjEwLDYgKzIxNSw3IEBAIHN0cnVjdCBrdm1faHlw
ZXJ2X2V4aXQgewo+ICAgCQkJX191NjQgaW5wdXQ7Cj4gICAJCQlfX3U2NCByZXN1bHQ7Cj4gICAJ
CQlfX3U2NCBwYXJhbXNbMl07Cj4gKwkJCXN0cnVjdCBrdm1faHlwZXJ2X3htbV9yZWcgeG1tWzZd
OwoKCldvdWxkIHRoaXMgY2hhbmdlIHRoZSBzaXplIG9mIHN0cnVjdCBrdm1faHlwZXJ2X2V4aXQ/
IEFuZCBpZiBzbywgCndvdWxkbid0IHRoYXQgcG90ZW50aWFsbHkgYmUgYSBVQUJJIGJyZWFrYWdl
PwoKCkFsZXgKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVz
ZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hs
YWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0
ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3
IDg3OQoKCg==


