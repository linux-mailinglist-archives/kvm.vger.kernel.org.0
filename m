Return-Path: <kvm+bounces-26540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7299755FE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 16:50:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECC7F1F227CB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 14:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F17091AAE29;
	Wed, 11 Sep 2024 14:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="bZUczRWF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2846199FD1;
	Wed, 11 Sep 2024 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726066171; cv=none; b=eX9iWI5v7UFr9LcjE7rlMPCLL2oRROmeUHOK7VXc/wEl4CISafA6xVHQItfLAIe2UXbsvjR48ZiVSVb+hPnA6dJNNac9DDMgKEgO1pnBKrL8Kg/bStKipMXxh5A2JnHxW7L3ojtD1murF2xcygMPPvoMEMKCQtrFr8U1UexYN+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726066171; c=relaxed/simple;
	bh=scAyZjH0kO2jQcWW4CW3jkQRvYTGMi1QaqEryDuzt5U=;
	h=Subject:Message-ID:Date:MIME-Version:To:CC:References:From:
	 In-Reply-To:Content-Type; b=S9nTMpw+lQHAdxBEXAfT0HLSUVwiggDvZLb0OjlNsKIidL5fru2Zh938KSGJfxMSWycZCjt9HrzSY5fNbIlxzV5ZikyhLfDtyYfTqJbBxJCa9cOEOjl1nGDO8bcmRtyyo5vGOpz3ti9aPx9DUT5zcJilGKtBR2j5lOLvomYoJhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=bZUczRWF; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726066169; x=1757602169;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=scAyZjH0kO2jQcWW4CW3jkQRvYTGMi1QaqEryDuzt5U=;
  b=bZUczRWFKrmFwwwukMY9T26f/NUAmm37eWjm/0vFNZZNTjRB5hfaFJes
   fN4Yycif0PodAc3mUIza9up4+Dfk7HSsRaHTGnUn8rEtzqOLEp7nGrkJR
   fNDNBscAa0ovhkOBb6qT4nxai60wJHMcmQTA+kSMYu6gfRnYk5oL91DGn
   A=;
X-IronPort-AV: E=Sophos;i="6.10,220,1719878400"; 
   d="scan'208";a="367507981"
Subject: Re: [RFC PATCH 1/2] KVM: x86: Introduce KVM_{G, S}ET_ONE_REG uAPIs support
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 14:48:15 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.17.79:11251]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.25.181:2525] with esmtp (Farcaster)
 id ce165d01-0048-486b-b157-49c928969a21; Wed, 11 Sep 2024 14:48:14 +0000 (UTC)
X-Farcaster-Flow-ID: ce165d01-0048-486b-b157-49c928969a21
Received: from EX19D041EUB003.ant.amazon.com (10.252.61.118) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 14:48:14 +0000
Received: from [192.168.27.184] (10.1.212.24) by EX19D041EUB003.ant.amazon.com
 (10.252.61.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Wed, 11 Sep 2024
 14:48:11 +0000
Message-ID: <b4829ed2-5a34-4b5c-8770-3571a9381b19@amazon.de>
Date: Wed, 11 Sep 2024 16:48:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Sean Christopherson <seanjc@google.com>
CC: Yang Weijiang <weijiang.yang@intel.com>, <pbonzini@redhat.com>,
	<mlevitsk@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240509075423.156858-1-weijiang.yang@intel.com>
 <07b0b475-9f45-4476-a63d-291f940f9b4d@amazon.de>
 <ZuGpJtEPv1NtdYwM@google.com>
From: Nikolas Wipper <nikwip@amazon.de>
Content-Language: en-US
In-Reply-To: <ZuGpJtEPv1NtdYwM@google.com>
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D041EUB003.ant.amazon.com (10.252.61.118)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkIFNlcCAxMSwgMjAyNCBhdCAwNDozNiBQTSBVVEMrMDIwMCwgU2VhbiBDaHJpc3RvcGhl
cnNvbiB3cm90ZToKPiBPbiBXZWQsIFNlcCAxMSwgMjAyNCwgTmlrb2xhcyBXaXBwZXIgd3JvdGU6
Cj4+IEhhdmluZyB0aGlzIEFQSSwgYW5kIHNwZWNpZmljYWxseSBoYXZpbmcgYSBkZWZpbml0ZSBr
dm1fb25lX3JlZyBzdHJ1Y3R1cmUKPj4gZm9yIHg4NiByZWdpc3RlcnMsIHdvdWxkIGJlIGludGVy
ZXN0aW5nIGZvciByZWdpc3RlciBwaW5uaW5nL2ludGVyY2VwdHMuCj4+IFdpdGggb25lX3JlZyBm
b3IgeDg2IHRoZSBBUEkgY291bGQgYmUgcGxhdGZvcm0gYWdub3N0aWMgYW5kIHBvc3NpYmxlIGV2
ZW4KPj4gcmVwbGFjZSBNU1IgZmlsdGVycyBmb3IgeDg2Lgo+IAo+IEkgZG9uJ3QgZm9sbG93LiAg
TVNSIGZpbHRlcnMgbGV0IHVzZXJzcGFjZSBpbnRlcmNlcHQgYWNjZXNzZXMgZm9yIGEgdmFyaWV0
eSBvZgo+IHJlYXNvbnMsIHRoZXNlIEFQSXMgc2ltcGx5IHByb3ZpZGUgYSB3YXkgdG8gcmVhZC93
cml0ZSBhIHJlZ2lzdGVyIHZhbHVlIHRoYXQgaXMKPiBzdG9yZWQgaW4gS1ZNLiAgSSBkb24ndCBz
ZWUgaG93IHRoaXMgY291bGQgcmVwbGFjZSBNU1IgZmlsdGVycy4KCk5vcGUsIHRoYXQgd291bGQg
YmUgYW4gZW50aXJlbHkgZGlmZmVyZW50IEFQSSwgYnV0IGlmIHRoYXQgdXNlcyBvbmUgcmVnIElE
cyBpdApjb3VsZCBiZSB1bmlmaWVkIHRvIGNvdmVyIENScyBhbmQgTVNScyBhbGwgaW4gb25lLgoK
CgoKQW1hem9uIFdlYiBTZXJ2aWNlcyBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICkty
YXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBT
Y2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJs
b3R0ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAzNjUg
NTM4IDU5Nwo=


