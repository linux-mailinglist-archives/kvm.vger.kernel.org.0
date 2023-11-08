Return-Path: <kvm+bounces-1233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B517E5C65
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 18:28:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55FB6B20D42
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E0132C75;
	Wed,  8 Nov 2023 17:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="OUC5VGJV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE81732C67;
	Wed,  8 Nov 2023 17:27:51 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C7610D9;
	Wed,  8 Nov 2023 09:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699464471; x=1731000471;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hBzmNII0I3GifFKe/JRW/XiwCLaYSx9NjN5qNg4RJqU=;
  b=OUC5VGJVVKj0M8aIcUJUnKeSGSFRbmu1t3xOj2kZjIo7+A55lauE3qPb
   w7K6hAFpg7Wq3XSQnrKuwtnNpL/blB1x4m91l4+fxwzHQCUN88czUYKF0
   v4FSZe23qXBSQjh/oKdcZEX/85veYnMNDV3Wf9qVqMWQI5WtsAlqYyvjo
   k=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="42137507"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 17:27:47 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 83739A0CD9;
	Wed,  8 Nov 2023 17:27:43 +0000 (UTC)
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:49948]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.26:2525] with esmtp (Farcaster)
 id fda2a43b-2f90-4542-9a2c-16f8fb6acca0; Wed, 8 Nov 2023 17:27:42 +0000 (UTC)
X-Farcaster-Flow-ID: fda2a43b-2f90-4542-9a2c-16f8fb6acca0
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 17:27:40 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 17:27:36 +0000
Message-ID: <c867cd1f-9060-4db9-8a00-4b513f32c2b7@amazon.com>
Date: Wed, 8 Nov 2023 18:27:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 29/33] KVM: VMX: Save instruction length on EPT violation
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Nicolas Saenz Julienne
	<nsaenz@amazon.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-30-nsaenz@amazon.com> <ZUvDZUbUR4s_9VNG@google.com>
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <ZUvDZUbUR4s_9VNG@google.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D040UWA004.ant.amazon.com (10.13.139.93) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDA4LjExLjIzIDE4OjIwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOgo+IE9uIFdlZCwg
Tm92IDA4LCAyMDIzLCBOaWNvbGFzIFNhZW56IEp1bGllbm5lIHdyb3RlOgo+PiBTYXZlIHRoZSBs
ZW5ndGggb2YgdGhlIGluc3RydWN0aW9uIHRoYXQgdHJpZ2dlcmVkIGFuIEVQVCB2aW9sYXRpb24g
aW4KPj4gc3RydWN0IGt2bV92Y3B1X2FyY2guIFRoaXMgd2lsbCBiZSB1c2VkIHRvIHBvcHVsYXRl
IEh5cGVyLVYgVlNNIG1lbW9yeQo+PiBpbnRlcmNlcHQgbWVzc2FnZXMuCj4gVGhpcyBpcyBzaWxs
eSBhbmQgdW5uZWNlc3NhcmlseSBvYmZ1c2NhdGVzICp3aHkqIChhcyBteSByZXNwb25zZSByZWdh
cmRpbmcgU1ZNCj4gc2hvd3MpLCBpLmUuIHRoYXQgdGhpcyBpcyAibmVlZGVkIiBiZWN1YXNlIHRo
ZSB2YWx1ZSBpcyBjb25zdW1lZCBieSBhICpkaWZmZXJlbnQqCj4gdkNQVSwgbm90IGJlY2F1c2Ug
b2YgcGVyZm9ybWFuY2UgY29uY2VybnMuCj4KPiBJdCdzIGFsc28gYnJva2VuLCBBRkFJQ1Qgbm90
aGluZyBwcmV2ZW50cyB0aGUgaW50ZXJjZXB0ZWQgdkNQVSBmcm9tIGhpdHRpbmcgYQo+IGRpZmZl
cmVudCBFUFQgdmlvbGF0aW9uIGJlZm9yZSB0aGUgdGFyZ2V0IHZDUFUgY29uc3VtZXMgZXhpdF9p
bnN0cnVjdGlvbl9sZW4uCj4KPiBIb2x5IGNvdy4gIEFsbCBvZiBkZWxpdmVyX2dwYV9pbnRlcmNl
cHQoKSBpcyB3aWxkbHkgdW5zYWZlLiAgQXNpZGUgZnJvbSByYWNlCj4gY29uZGl0aW9ucywgd2hp
Y2ggaW4gYW5kIG9mIHRoZW1zZWx2ZXMgYXJlIGEgbm9uLXN0YXJ0ZXIsIG5vdGhpbmcgZ3VhcmFu
dGVlcyB0aGF0Cj4gdGhlIGludGVyY2VwdGVkIHZDUFUgYWN0dWFsbHkgY2FjaGVkIGFsbCBvZiB0
aGUgaW5mb3JtYXRpb24gdGhhdCBpcyBoZWxkIGluIGl0cyBWTUNTLgo+Cj4gVGhlIHNhbmUgd2F5
IHRvIGRvIHRoaXMgaXMgdG8gc25hcHNob3QgKmFsbCogaW5mb3JtYXRpb24gb24gdGhlIGludGVy
Y2VwdGVkIHZDUFUsCj4gYW5kIHRoZW4gaGFuZCB0aGF0IG9mZiBhcyBhIHBheWxvYWQgdG8gdGhl
IHRhcmdldCB2Q1BVLiAgVGhhdCBpcywgYXNzdW1pbmcgdGhlCj4gY3Jvc3MtdkNQVSBzdHVmZiBp
cyBhY3R1YWxseSBuZWNlc3NhcnkuICBBdCBhIGdsYW5jZSwgSSBkb24ndCBzZWUgYW55dGhpbmcg
dGhhdAo+IGV4cGxhaW5zICp3aHkqLgoKCll1cCwgSSBiZWxpZXZlIHlvdSByZXBlYXRlZCB0aGUg
Y29tbWVudCBJIGhhZCBvbiB0aGUgZnVuY3Rpb24gLSBhbmQgCk5pY29sYXMgYWxyZWFkeSBhZ3Jl
ZWQgOikuIFRoaXMgc2hvdWxkIGdvIHRocm91Z2ggdXNlciBzcGFjZSB3aGljaCAKYXV0b21hdGlj
YWxseSBtZWFucyB5b3UgbmVlZCB0byBidWJibGUgdXAgYWxsIG5lY2Vzc2FyeSB0cmFwIGRhdGEg
dG8gCnVzZXIgc3BhY2Ugb24gdGhlIGZhdWx0aW5nIHZDUFUgYW5kIHRoZW4gaW5qZWN0IHRoZSBm
dWxsIHNldCBvZiBkYXRhIAppbnRvIHRoZSByZWNlaXZpbmcgb25lLgoKTXkgcG9pbnQgd2l0aCB0
aGUgY29tbWVudCBvbiB0aGlzIHBhdGNoIHdhcyAiRG9uJ3QgYnJlYWsgQU1EIChvciBhbmNpZW50
IApWTVggd2l0aG91dCBpbnN0cnVjdGlvbiBsZW5ndGggZGVjb2RpbmcgW0RvZXMgdGhhdCBleGlz
dD8gSSBrbm93IFNWTSBoYXMgCm9sZCBDUFVzIHRoYXQgZG9uJ3QgZG8gaXRdKSBwbGVhc2UiLgoK
CkFsZXgKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5z
dHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVn
ZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5i
dXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3
OQoKCg==


