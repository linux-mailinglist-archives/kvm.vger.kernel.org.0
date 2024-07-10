Return-Path: <kvm+bounces-21293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 013FE92CE8E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 11:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F3A11F25822
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B876118FA26;
	Wed, 10 Jul 2024 09:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="FJQxJlOR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6B92B9C6;
	Wed, 10 Jul 2024 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720605025; cv=none; b=e30iPSOSsnW5riFvhuFpv7KC6fE6D9h2KeNjn6qEyzjrIBQ/vAOr2Izipemy5BjXLp3rX7z7BPA3F+764jl+mMbFzlUK7jyNtAJnKSdtqTxHdWKNUyePkq48/Bg5mxiksEWKgzdJpinNneZtlNUOiPNFNgBF3fEYv8z12M6ipdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720605025; c=relaxed/simple;
	bh=7Jq9ndq0jnacb56vEAnBrxlmlfBZFJgLzYnSnV0zVqk=;
	h=Subject:Message-ID:Date:MIME-Version:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uYSLnZqPl1cEDgUGlyih3vkZYbCPWbSLfsHknY6iLLvE3nPT+pom4dHM2cy+Ul/gLYFgaugS5FhZx1wmV1AHwi8dUc+ELdVq1mPzdRMQLK8sS+r8u/gtZA2dfli/eV7P7FG88xXgy2BSOHSqztgoq1KSdcUYAUPFczpHfv7Mt+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=FJQxJlOR; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720605024; x=1752141024;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=wWlHFuKGYfQe+7qWn8NY5kBRpARTw54+NYGwoDXEwGY=;
  b=FJQxJlORDmrEJkY7EfASVht8c9Msvm8ZDwPXXdIuAYzatmrGQoOoEaA8
   AN8cNfYZklk+hsd9nsGZpj5tRO4AVFC89pS4HHAu/pqpWgrnDJ6EMvsOf
   DKouGZluQv8rBLr0vU+uF6cOUuK0XjNtq8w1cn3cqGuKvenck84bwxIaZ
   g=;
X-IronPort-AV: E=Sophos;i="6.09,197,1716249600"; 
   d="scan'208";a="104186022"
Subject: Re: [RFC PATCH 3/8] kvm: pfncache: enlighten about gmem
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 09:50:04 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.38.20:56457]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.80:2525] with esmtp (Farcaster)
 id 17aaa3d3-f61c-40d6-940f-1ec90393b603; Wed, 10 Jul 2024 09:50:04 +0000 (UTC)
X-Farcaster-Flow-ID: 17aaa3d3-f61c-40d6-940f-1ec90393b603
Received: from EX19D020UWA004.ant.amazon.com (10.13.138.231) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 09:50:04 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D020UWA004.ant.amazon.com (10.13.138.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 09:50:04 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Wed, 10 Jul 2024 09:49:58 +0000
Message-ID: <b89a2285-f595-42f6-a5a0-f7fc18f5f20e@amazon.co.uk>
Date: Wed, 10 Jul 2024 10:49:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: David Woodhouse <dwmw2@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <akpm@linux-foundation.org>, <rppt@kernel.org>,
	<david@redhat.com>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<willy@infradead.org>, <graf@amazon.com>, <derekmn@amazon.com>,
	<kalyazin@amazon.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <dmatlack@google.com>, <tabba@google.com>,
	<chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>, James Gowans
	<jgowans@amazon.com>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-4-roypat@amazon.co.uk>
 <da6f5a4ceab71375beb2c21fb651010a7026718a.camel@infradead.org>
Content-Language: en-US
From: Patrick Roy <roypat@amazon.co.uk>
Autocrypt: addr=roypat@amazon.co.uk; keydata=
 xjMEY0UgYhYJKwYBBAHaRw8BAQdA7lj+ADr5b96qBcdINFVJSOg8RGtKthL5x77F2ABMh4PN
 NVBhdHJpY2sgUm95IChHaXRodWIga2V5IGFtYXpvbikgPHJveXBhdEBhbWF6b24uY28udWs+
 wpMEExYKADsWIQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbAwULCQgHAgIiAgYVCgkI
 CwIEFgIDAQIeBwIXgAAKCRBVg4tqeAbEAmQKAQC1jMl/KT9pQHEdALF7SA1iJ9tpA5ppl1J9
 AOIP7Nr9SwD/fvIWkq0QDnq69eK7HqW14CA7AToCF6NBqZ8r7ksi+QLOOARjRSBiEgorBgEE
 AZdVAQUBAQdAqoMhGmiXJ3DMGeXrlaDA+v/aF/ah7ARbFV4ukHyz+CkDAQgHwngEGBYKACAW
 IQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbDAAKCRBVg4tqeAbEAtjHAQDkh5jZRIsZ
 7JMNkPMSCd5PuSy0/Gdx8LGgsxxPMZwePgEAn5Tnh4fVbf00esnoK588bYQgJBioXtuXhtom
 8hlxFQM=
In-Reply-To: <da6f5a4ceab71375beb2c21fb651010a7026718a.camel@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On 7/9/24 15:36, David Woodhouse wrote:
> On Tue, 2024-07-09 at 14:20 +0100, Patrick Roy wrote:
>> KVM uses gfn_to_pfn_caches to cache translations from gfn all the way to
>> the pfn (for example, kvm-clock caches the page storing the page used
>> for guest/host communication this way). Unlike the gfn_to_hva_cache,
>> where no equivalent caching semantics were possible to gmem-backed gfns
>> (see also 858e8068a750 ("kvm: pfncache: enlighten about gmem")), here it
>> is possible to simply cache the pfn returned by `kvm_gmem_get_pfn`.
>>
>> Additionally, gfn_to_pfn_caches now invalidate whenever a cached gfn's
>> attributes are flipped from shared to private (or vice-versa).
>>
>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> 
> I can't see how this is safe from race conditions.
> 
> When the GPC is invalidated from gfn_to_pfn_cache_invalidate_start()
> its *write* lock is taken and gpc->valid is set to false.
> 
> In parallel, any code using the GPC to access guest memory will take
> the *read* lock, call kvm_gpc_check(), and then go ahead and use the
> pointer to its heart's content until eventually dropping the read lock.
> 
> Since invalidation takes the write lock, it has to wait until the GPC
> is no longer in active use, and the pointer cannot be being
> dereferenced.
> 
> How does this work for the kvm_mem_is_private() check. You've added a
> check in kvm_gpc_check(), but what if the pfn is made private
> immediately *after* that check? Unless the code path which makes the
> pfn private also takes the write lock, how is it safe?

Ah, you're right - I did in fact overlook this. I do think that it works
out though: kvm_vm_set_mem_attributes, which is used for flipping
between shared/private, registers the range which had its attributes
changed for invalidation, and thus gfn_to_pfn_cache_invalidate_start
should get called for it (although I have to admit I do not immediately
see what the exact callstack for this looks like, so maybe I am
misunderstanding something about invalidation here?).


