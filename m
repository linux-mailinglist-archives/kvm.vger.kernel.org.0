Return-Path: <kvm+bounces-1199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EC687E5672
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 13:40:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 389882814A0
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B0B10A26;
	Wed,  8 Nov 2023 12:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="EUbBfEC/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2975D63C1;
	Wed,  8 Nov 2023 12:40:30 +0000 (UTC)
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE40B1BF0;
	Wed,  8 Nov 2023 04:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699447230; x=1730983230;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0INXsWYvtLqes441yMpJeoo1nwyUIZ6UTzvYqHMB+U4=;
  b=EUbBfEC/pqP431P+m7+isNN57idWCC77mylKf4Ozs2jP4bgIDCKCUOF6
   S7RXdmJwk9qwarib9sxd/2kdaFSeQl35tOs2dIXRqY5MrFbeDUV8LO+Y/
   tqqqntaEH7C5ZVcPcXuyc/1hZrgau/Qe0yxWfsZAjj/VJge/my8CUhQUg
   k=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="614880351"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 12:40:28 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com (Postfix) with ESMTPS id 8216CE1997;
	Wed,  8 Nov 2023 12:40:24 +0000 (UTC)
Received: from EX19MTAUWB001.ant.amazon.com [10.0.7.35:63615]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.241:2525] with esmtp (Farcaster)
 id 722fe19b-527e-44ce-a47a-8e6d5ad03ba4; Wed, 8 Nov 2023 12:40:23 +0000 (UTC)
X-Farcaster-Flow-ID: 722fe19b-527e-44ce-a47a-8e6d5ad03ba4
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 12:40:23 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 12:40:19 +0000
Message-ID: <2573d04d-feff-4119-a79c-dbf9b85e62fd@amazon.com>
Date: Wed, 8 Nov 2023 13:40:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 29/33] KVM: VMX: Save instruction length on EPT violation
Content-Language: en-US
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-30-nsaenz@amazon.com>
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20231108111806.92604-30-nsaenz@amazon.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D032UWA002.ant.amazon.com (10.13.139.81) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDA4LjExLjIzIDEyOjE4LCBOaWNvbGFzIFNhZW56IEp1bGllbm5lIHdyb3RlOgo+IFNhdmUg
dGhlIGxlbmd0aCBvZiB0aGUgaW5zdHJ1Y3Rpb24gdGhhdCB0cmlnZ2VyZWQgYW4gRVBUIHZpb2xh
dGlvbiBpbgo+IHN0cnVjdCBrdm1fdmNwdV9hcmNoLiBUaGlzIHdpbGwgYmUgdXNlZCB0byBwb3B1
bGF0ZSBIeXBlci1WIFZTTSBtZW1vcnkKPiBpbnRlcmNlcHQgbWVzc2FnZXMuCj4KPiBTaWduZWQt
b2ZmLWJ5OiBOaWNvbGFzIFNhZW56IEp1bGllbm5lIDxuc2FlbnpAYW1hem9uLmNvbT4KCgpJbiB2
MSwgcGxlYXNlIGRvIHRoaXMgZm9yIFNWTSBhcyB3ZWxsIDopCgoKQWxleAoKCgoKCkFtYXpvbiBE
ZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxp
bgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNz
CkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkx
NzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==


