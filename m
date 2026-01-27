Return-Path: <kvm+bounces-69184-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iDT9Ca0neGl7oQEAu9opvQ
	(envelope-from <kvm+bounces-69184-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 03:49:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B11348F346
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 03:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4FADF300EDE3
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 02:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462AF3009C1;
	Tue, 27 Jan 2026 02:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O6k41cIy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D838267AF2;
	Tue, 27 Jan 2026 02:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482006; cv=none; b=ePZ0CdvkaFOhgPz2Lgyi6nBAENGmD8G/rLMQRocvpuQeUvZmjYh/ciCRE6LLnNBmYQI4+B4eMT7bwikNH7U07UPLTSNY7Ev9+rsIUeTc6iToi6mYFkd0g8gizliuMhYBC0UtSxDXANt4/TnZfNG4rqQgl90VfrfTsWE/yxNEKm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482006; c=relaxed/simple;
	bh=Xzpbra9837QmDLbGjaczE5iqzi40M73MulfuqbJXidU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a1tE+DLblbk52RemVIzWUzdOHVscAb9+VLxAxa9mRSBEC1jW/xUz1LaOQ9rLdc6FvABgzLWt5cc8rej5npZhHi4o+Nxq5+/2klIh6Bd8M7BgheRxtOwqRJYyGGNZtWk3m/9+fpfz1cGkKOFiuKDxAXrQLWrFEZDPhGFZYbnyr2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O6k41cIy; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769482005; x=1801018005;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xzpbra9837QmDLbGjaczE5iqzi40M73MulfuqbJXidU=;
  b=O6k41cIyntRL3SCNroVKSdRyRQj7Zvdqoi5VVwkiTVikAC/z9nLp3ZTE
   EDe7wBBqAoZfGoVanSWSIP0M1cntDD8EkLdAm3pfILeVT5bjobSZuy+F6
   dU2Z/snr2mbuR5QajD/lfwdDdzG6FVeGyRPywtRH0a/hLoIzz1j94xfWa
   l2b0bROQnIzZ13ZRwnU8uXyIpYoy4jL5fKrwlr/9KXJM9/grwRkUGHxR5
   HbD+TJprj39oz78OeVhH/3kdKo9LUM4dm7YO3YgCMw2QCHoSPw3ytQ3xv
   Feg0cxDIxdPm9kQk85y+TBeypTQCqmHMYRUIN4ZkzjY0wd6oiN7AQRKJC
   g==;
X-CSE-ConnectionGUID: YAbV8aKWTf+59r82otY28A==
X-CSE-MsgGUID: TJ3WDcFrTb2UT5KJJ0+jRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="70561983"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="70561983"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 18:46:36 -0800
X-CSE-ConnectionGUID: Hwd3ZEaTQOCwNLoyhHOMBg==
X-CSE-MsgGUID: e69oU3gfRuGV/1sCtYyR7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="212393572"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 18:46:33 -0800
Message-ID: <e3905a0a-8582-4902-9ca7-03b6e3ce412c@linux.intel.com>
Date: Tue, 27 Jan 2026 10:46:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
To: Sean Christopherson <seanjc@google.com>,
 Xu Yilun <yilun.xu@linux.intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-3-seanjc@google.com> <aTe4QyE3h8LHOAMb@intel.com>
 <aUJUbcyz2DXmphtU@yilunxu-OptiPlex-7050> <aUL-J-MvdCrCtDp4@google.com>
 <aUS06wE6IvFti8Le@yilunxu-OptiPlex-7050> <aUVx20ZRjOzKgKqy@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aUVx20ZRjOzKgKqy@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_FROM(0.00)[bounces-69184-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:dkim,linux.intel.com:mid]
X-Rspamd-Queue-Id: B11348F346
X-Rspamd-Action: no action



On 12/19/2025 11:40 PM, Sean Christopherson wrote:
> On Fri, Dec 19, 2025, Xu Yilun wrote:
>> On Wed, Dec 17, 2025 at 11:01:59AM -0800, Sean Christopherson wrote:
>>> On Wed, Dec 17, 2025, Xu Yilun wrote:
>>>> Is it better we explicitly assert the preemption for x86_virt_get_cpu()
>>>> rather than embed the check in __this_cpu_inc_return()? We are not just
>>>> protecting the racing for the reference counter. We should ensure the
>>>> "counter increase + x86_virt_call(get_cpu)" can't be preempted.
>>>
>>> I don't have a strong preference.  Using __this_cpu_inc_return() without any
>>> nearby preemption_{enable,disable}() calls makes it quite clears that preemption
>>> is expected to be disabled by the caller.  But I'm also ok being explicit.
>>
>> Looking into __this_cpu_inc_return(), it finally calls
>> check_preemption_disabled() which doesn't strictly requires preemption.
>> It only ensures the context doesn't switch to another CPU. If the caller
>> is in cpuhp context, preemption is possible.
> 
> Hmm, right, the cpuhp thread is is_percpu_thread(), and KVM's hooks aren't
> considered atomic and so run with IRQs enabled.  In practice, it's "fine", because
> TDX also exclusively does x86_virt_get_cpu() from cpuhp, i.e. the two users are
> mutually exclusive, but relying on that behavior is gross.
> 

Side topic:
Isn't the name of check_preemption_disabled() confusing and arguably misleading?




