Return-Path: <kvm+bounces-1194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DEB67E5602
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 13:14:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE6EB1C209E0
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F135917744;
	Wed,  8 Nov 2023 12:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="UAIvibXx"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8750F14261;
	Wed,  8 Nov 2023 12:14:50 +0000 (UTC)
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2C51BCC;
	Wed,  8 Nov 2023 04:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699445690; x=1730981690;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HC36Ic5vU7omWBY0SwtuooMHv5k3SrI7LvT/SSxo9Tk=;
  b=UAIvibXxAWdJxLmjs0dlY7alWjgt2Sk1JEwdU/j7Q6ogbmkrNz3aWvB6
   aMAQ13sBQ0lsfTAZ9NzsL7ohsULZKJvecv8lsleQbmP0+0uXZa4ym52AL
   y1jR86eFPR4mSJnGZtyjwuDdIUv8d/SaI96zCaCLd9TqQyRKSQG4vzoP7
   8=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="250888169"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 12:14:47 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com (Postfix) with ESMTPS id 7CD6D40D98;
	Wed,  8 Nov 2023 12:14:46 +0000 (UTC)
Received: from EX19MTAUWC002.ant.amazon.com [10.0.38.20:26166]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.26:2525] with esmtp (Farcaster)
 id a4d7dcf4-27be-434f-a1a3-5e675ca05558; Wed, 8 Nov 2023 12:14:46 +0000 (UTC)
X-Farcaster-Flow-ID: a4d7dcf4-27be-434f-a1a3-5e675ca05558
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 12:14:45 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 12:14:42 +0000
Message-ID: <b9c6ad26-ce8b-45f3-b856-8e6be2497f6e@amazon.com>
Date: Wed, 8 Nov 2023 13:14:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 11/33] KVM: x86: hyper-v: Handle GET/SET_VP_REGISTER hcall
 in user-space
Content-Language: en-US
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-12-nsaenz@amazon.com>
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20231108111806.92604-12-nsaenz@amazon.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D035UWA002.ant.amazon.com (10.13.139.60) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDA4LjExLjIzIDEyOjE3LCBOaWNvbGFzIFNhZW56IEp1bGllbm5lIHdyb3RlOgo+IExldCB1
c2VyLXNwYWNlIGhhbmRsZSBIVkNBTExfR0VUX1ZQX1JFR0lTVEVSUyBhbmQKPiBIVkNBTExfU0VU
X1ZQX1JFR0lTVEVSUyB0aHJvdWdoIHRoZSBLVk1fRVhJVF9IWVBFUlZfSFZDQUxMIGV4aXQgcmVh
c29uLgo+IEFkZGl0aW9uYWxseSwgZXhwb3NlIHRoZSBjcHVpZCBiaXQuCj4KPiBTaWduZWQtb2Zm
LWJ5OiBOaWNvbGFzIFNhZW56IEp1bGllbm5lIDxuc2FlbnpAYW1hem9uLmNvbT4KPiAtLS0KPiAg
IGFyY2gveDg2L2t2bS9oeXBlcnYuYyAgICAgICAgICAgICB8IDkgKysrKysrKysrCj4gICBpbmNs
dWRlL2FzbS1nZW5lcmljL2h5cGVydi10bGZzLmggfCAxICsKPiAgIDIgZmlsZXMgY2hhbmdlZCwg
MTAgaW5zZXJ0aW9ucygrKQo+Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9oeXBlcnYuYyBi
L2FyY2gveDg2L2t2bS9oeXBlcnYuYwo+IGluZGV4IGNhYWE4NTk5MzJjNS4uYTM5NzBkNTJlZWYx
IDEwMDY0NAo+IC0tLSBhL2FyY2gveDg2L2t2bS9oeXBlcnYuYwo+ICsrKyBiL2FyY2gveDg2L2t2
bS9oeXBlcnYuYwo+IEBAIC0yNDU2LDYgKzI0NTYsOSBAQCBzdGF0aWMgdm9pZCBrdm1faHZfd3Jp
dGVfeG1tKHN0cnVjdCBrdm1faHlwZXJ2X3htbV9yZWcgKnhtbSkKPiAgIAo+ICAgc3RhdGljIGJv
b2wga3ZtX2h2X2lzX3htbV9vdXRwdXRfaGNhbGwodTE2IGNvZGUpCj4gICB7Cj4gKwlpZiAoY29k
ZSA9PSBIVkNBTExfR0VUX1ZQX1JFR0lTVEVSUykKPiArCQlyZXR1cm4gdHJ1ZTsKPiArCj4gICAJ
cmV0dXJuIGZhbHNlOwo+ICAgfQo+ICAgCj4gQEAgLTI1MjAsNiArMjUyMyw4IEBAIHN0YXRpYyBi
b29sIGlzX3htbV9mYXN0X2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX2h2X2hjYWxsICpoYykKPiAgIAlj
YXNlIEhWQ0FMTF9GTFVTSF9WSVJUVUFMX0FERFJFU1NfTElTVF9FWDoKPiAgIAljYXNlIEhWQ0FM
TF9GTFVTSF9WSVJUVUFMX0FERFJFU1NfU1BBQ0VfRVg6Cj4gICAJY2FzZSBIVkNBTExfU0VORF9J
UElfRVg6Cj4gKwljYXNlIEhWQ0FMTF9HRVRfVlBfUkVHSVNURVJTOgo+ICsJY2FzZSBIVkNBTExf
U0VUX1ZQX1JFR0lTVEVSUzoKPiAgIAkJcmV0dXJuIHRydWU7Cj4gICAJfQo+ICAgCj4gQEAgLTI3
MzgsNiArMjc0Myw5IEBAIGludCBrdm1faHZfaHlwZXJjYWxsKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSkKPiAgIAkJCWJyZWFrOwo+ICAgCQl9Cj4gICAJCWdvdG8gaHlwZXJjYWxsX3VzZXJzcGFjZV9l
eGl0Owo+ICsJY2FzZSBIVkNBTExfR0VUX1ZQX1JFR0lTVEVSUzoKPiArCWNhc2UgSFZDQUxMX1NF
VF9WUF9SRUdJU1RFUlM6Cj4gKwkJZ290byBoeXBlcmNhbGxfdXNlcnNwYWNlX2V4aXQ7Cj4gICAJ
ZGVmYXVsdDoKPiAgIAkJcmV0ID0gSFZfU1RBVFVTX0lOVkFMSURfSFlQRVJDQUxMX0NPREU7Cj4g
ICAJCWJyZWFrOwo+IEBAIC0yOTAzLDYgKzI5MTEsNyBAQCBpbnQga3ZtX2dldF9odl9jcHVpZChz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fY3B1aWQyICpjcHVpZCwKPiAgIAkJCWVu
dC0+ZWJ4IHw9IEhWX1BPU1RfTUVTU0FHRVM7Cj4gICAJCQllbnQtPmVieCB8PSBIVl9TSUdOQUxf
RVZFTlRTOwo+ICAgCQkJZW50LT5lYnggfD0gSFZfRU5BQkxFX0VYVEVOREVEX0hZUEVSQ0FMTFM7
Cj4gKwkJCWVudC0+ZWJ4IHw9IEhWX0FDQ0VTU19WUF9SRUdJU1RFUlM7CgoKRG8gd2UgbmVlZCB0
byBndWFyZCB0aGlzPwoKCkFsZXgKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFu
eSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENo
cmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJp
Y2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlE
OiBERSAyODkgMjM3IDg3OQoKCg==


