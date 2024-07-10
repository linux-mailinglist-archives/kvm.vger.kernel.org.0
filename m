Return-Path: <kvm+bounces-21301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C6A92CFE9
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 12:58:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AD8DB2CC0D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4E2192465;
	Wed, 10 Jul 2024 10:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="tyl29oBg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3591922F3;
	Wed, 10 Jul 2024 10:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720608421; cv=none; b=n6o38CvvVxIiqqJKY4jPkhZ3v/YkfFhPN791XKB3Umnsi6ypdq6BUlBMu7DwYEc82jgxauJxb16WoYWGTX6pqG/7PhLQDFtd21y8n78STl0TUQj0kkLO7R1j1VVCkUCnNsk3ptnr9bqKEi8SbC6iLU0WThdyZlBu80ZICTNzOjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720608421; c=relaxed/simple;
	bh=ztuSStAXhvcIqwsnovu5NJkOTktFcsIMB9/7zawsAbM=;
	h=Subject:Message-ID:Date:MIME-Version:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZY/k388J6hpDh/DB5dETzGVPY+h9wfPZ7dmCtLaPFXc9jMduY1iWDRFTwjXFAlwFT24u8FJQ62SiPpHO0o+OrtdbU0i3WIQAwOgimoqtnita2AKinw0G3yWGpNHMpVSSdOEjKTvEIpd1bh+Un9ND8v02IOIxxzgjBwd3tuHkQW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=tyl29oBg; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720608420; x=1752144420;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=GR3RYF2x4z71PGTH37bYL8ZnTYvy63iDSsj6p5E6Rvs=;
  b=tyl29oBgJrUe67RZcip1NfkjQkzPDATbrVGkeGliI35Eo/uXX5bnGf7y
   iljF2O4KKlVINUMx2D7cYJvs+qdJ3MuSKFpgeQ4EhwTvgtT18UirGbLyr
   rVMV9MR6SrpNziPDOxAg88/pD3Zhx1Uh9vwVPpkjkCS6uXugrrkIMuOzt
   g=;
X-IronPort-AV: E=Sophos;i="6.09,197,1716249600"; 
   d="scan'208";a="413498607"
Subject: Re: [RFC PATCH 3/8] kvm: pfncache: enlighten about gmem
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 10:46:53 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:20938]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.36.52:2525] with esmtp (Farcaster)
 id dda5124c-e65c-49a6-854e-c0a9073f11d3; Wed, 10 Jul 2024 10:46:52 +0000 (UTC)
X-Farcaster-Flow-ID: dda5124c-e65c-49a6-854e-c0a9073f11d3
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 10:46:52 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 10:46:51 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Wed, 10 Jul 2024 10:46:46 +0000
Message-ID: <b898824e-23eb-4226-9d55-cb4297b17d5c@amazon.co.uk>
Date: Wed, 10 Jul 2024 11:46:45 +0100
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
 <b89a2285-f595-42f6-a5a0-f7fc18f5f20e@amazon.co.uk>
 <9a0e63b7d45beca7b7a30debd3831f433626e5f6.camel@infradead.org>
From: Patrick Roy <roypat@amazon.co.uk>
Content-Language: en-US
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
In-Reply-To: <9a0e63b7d45beca7b7a30debd3831f433626e5f6.camel@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2024-07-10 at 11:20 +0100, David Woodhouse wrote:
> On Wed, 2024-07-10 at 10:49 +0100, Patrick Roy wrote:
>> On 7/9/24 15:36, David Woodhouse wrote:
> 
> I did? It isn't September yet, surely?

Argh, thanks for letting me know, I think I've whacked some sense into
my mail client now :)

>>> On Tue, 2024-07-09 at 14:20 +0100, Patrick Roy wrote:
>>>> KVM uses gfn_to_pfn_caches to cache translations from gfn all the way to
>>>> the pfn (for example, kvm-clock caches the page storing the page used
>>>> for guest/host communication this way). Unlike the gfn_to_hva_cache,
>>>> where no equivalent caching semantics were possible to gmem-backed gfns
>>>> (see also 858e8068a750 ("kvm: pfncache: enlighten about gmem")), here it
>>>> is possible to simply cache the pfn returned by `kvm_gmem_get_pfn`.
>>>>
>>>> Additionally, gfn_to_pfn_caches now invalidate whenever a cached gfn's
>>>> attributes are flipped from shared to private (or vice-versa).
>>>>
>>>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
>>>
>>> I can't see how this is safe from race conditions.
>>>
>>> When the GPC is invalidated from gfn_to_pfn_cache_invalidate_start()
>>> its *write* lock is taken and gpc->valid is set to false.
>>>
>>> In parallel, any code using the GPC to access guest memory will take
>>> the *read* lock, call kvm_gpc_check(), and then go ahead and use the
>>> pointer to its heart's content until eventually dropping the read lock.
>>>
>>> Since invalidation takes the write lock, it has to wait until the GPC
>>> is no longer in active use, and the pointer cannot be being
>>> dereferenced.
>>>
>>> How does this work for the kvm_mem_is_private() check. You've added a
>>> check in kvm_gpc_check(), but what if the pfn is made private
>>> immediately *after* that check? Unless the code path which makes the
>>> pfn private also takes the write lock, how is it safe?
>>
>> Ah, you're right - I did in fact overlook this. I do think that it works
>> out though: kvm_vm_set_mem_attributes, which is used for flipping
>> between shared/private, registers the range which had its attributes
>> changed for invalidation, and thus gfn_to_pfn_cache_invalidate_start
>> should get called for it (although I have to admit I do not immediately
>> see what the exact callstack for this looks like, so maybe I am
>> misunderstanding something about invalidation here?).
> 
> In that case, wouldn't that mean the explicit checks on gpc->is_private
> matching kvm_mem_is_private() would be redundant and you can remove
> them because you can trust that gpc->valid would be cleared?
> 

Right, yes, it would indeed mean that. I'll double-check my assumption
about the whole invalidation thing and adjust the code for the next
iteration!


