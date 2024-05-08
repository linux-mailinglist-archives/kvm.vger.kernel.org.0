Return-Path: <kvm+bounces-16990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A53328BF920
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 10:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BB4028175E
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C56E5381D;
	Wed,  8 May 2024 08:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nayoButw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14099476;
	Wed,  8 May 2024 08:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715158661; cv=none; b=X6B1YYef/073pq+Zmq8kmba6BFn8CctnYpQxIX68IqZzOU163/bm4mdYIdj1f+IVhV7DkiwJJYqwxMzVW4UoipCuH8xWDcTZr+l8wXZfdmHA0rF74vRD9yXan3pQLQ6uqOgYIdkg7VUHZymIrvIWClSAAPjxKNZKdfyFRN9gwg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715158661; c=relaxed/simple;
	bh=Ncv95Zn6ApL7dBl2x+J+PKjip161LDRUyImBP6m5FLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eHuHCYguYkydvefr/SNVYM/Xz+qIGwboYQ2Lu79yoQluB3J/FuRWCkQs8NCFLUb0GWve+XhwmAsoMgqKABo2Qd7rvqD5lZ4lAyDh98tk4d+w3ixgmmiP27JPIastf/InfCZ/yrCX9diW4GQnjMj1psDHiWGrVHiezVjogT5Lzew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nayoButw; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715158660; x=1746694660;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ncv95Zn6ApL7dBl2x+J+PKjip161LDRUyImBP6m5FLo=;
  b=nayoButwXmYca6xzRGNwmR7NhLwp7oxWxlpU+hwzdaS4eDgFhZHftf/c
   OIRUOFgUmv/KMfYEwMGd+2qvuTz71Q/9+DTbb7jKp+0OjI0PR0n858WdZ
   STs/k3vBvwoj4H/AdM6mSiU/n8ZsQiAdVuCkZfaE34KNHfIibTRHNV5gL
   AsxfT77ORRe00XCRutVM3pBrUSblgN9CCbtnAnSF7Y+NPNz4o9clDoF5K
   yRpL07oQLU5+9U/SoUgqVwBcSxrNA0pY4taiFdpLkR5vycq8ISdKW8/n3
   r8asEcesaqN/Wl5vHOuImRKnyHpzGYoAhYDpEiaYcWmy70AHHZowMTPjO
   A==;
X-CSE-ConnectionGUID: LzG5g3kZRKW/8xuOqt8Xhw==
X-CSE-MsgGUID: Icgg0/jKRY2pJdiClEUWjg==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11130094"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="11130094"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 01:57:40 -0700
X-CSE-ConnectionGUID: cFNV1HXoQT+6z81mgllYcw==
X-CSE-MsgGUID: 8pbmZin9RCColV1IskblHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="52028438"
Received: from tiesheng-mobl.ccr.corp.intel.com (HELO [10.124.225.233]) ([10.124.225.233])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 01:57:34 -0700
Message-ID: <912b03ed-0a6b-4946-9887-c6a448c33662@linux.intel.com>
Date: Wed, 8 May 2024 16:57:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/54] KVM: x86: Extract x86_set_kvm_irq_handler()
 function
To: Peter Zijlstra <peterz@infradead.org>, Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-11-mizhang@google.com>
 <20240507091801.GU40213@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <20240507091801.GU40213@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/7/2024 5:18 PM, Peter Zijlstra wrote:
> On Mon, May 06, 2024 at 05:29:35AM +0000, Mingwei Zhang wrote:
>> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>
>> KVM needs to register irq handler for POSTED_INTR_WAKEUP_VECTOR and
>> KVM_GUEST_PMI_VECTOR, a common function x86_set_kvm_irq_handler() is
>> extracted to reduce exports function and duplicated code.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> ---
>>  arch/x86/include/asm/irq.h |  3 +--
>>  arch/x86/kernel/irq.c      | 27 +++++++++++----------------
>>  arch/x86/kvm/vmx/vmx.c     |  4 ++--
>>  3 files changed, 14 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
>> index 2483f6ef5d4e..050a247b69b4 100644
>> --- a/arch/x86/include/asm/irq.h
>> +++ b/arch/x86/include/asm/irq.h
>> @@ -30,8 +30,7 @@ struct irq_desc;
>>  extern void fixup_irqs(void);
>>  
>>  #if IS_ENABLED(CONFIG_KVM)
>> -extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
>> -void kvm_set_guest_pmi_handler(void (*handler)(void));
>> +void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void));
>>  #endif
>>  
>>  extern void (*x86_platform_ipi_callback)(void);
>> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
>> index 22c10e5c50af..3ada69c50951 100644
>> --- a/arch/x86/kernel/irq.c
>> +++ b/arch/x86/kernel/irq.c
>> @@ -302,27 +302,22 @@ static void dummy_handler(void) {}
>>  static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
>>  static void (*kvm_guest_pmi_handler)(void) = dummy_handler;
>>  
>> -void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
>> +void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
>>  {
>> -	if (handler)
>> +	if (!handler)
>> +		handler = dummy_handler;
>> +
>> +	if (vector == POSTED_INTR_WAKEUP_VECTOR)
>>  		kvm_posted_intr_wakeup_handler = handler;
>> -	else {
>> -		kvm_posted_intr_wakeup_handler = dummy_handler;
>> -		synchronize_rcu();
>> -	}
>> -}
>> -EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
>> -
>> -void kvm_set_guest_pmi_handler(void (*handler)(void))
>> -{
>> -	if (handler) {
>> +	else if (vector == KVM_GUEST_PMI_VECTOR)
>>  		kvm_guest_pmi_handler = handler;
>> -	} else {
>> -		kvm_guest_pmi_handler = dummy_handler;
>> +	else
>> +		WARN_ON_ONCE(1);
>> +
>> +	if (handler == dummy_handler)
>>  		synchronize_rcu();
>> -	}
>>  }
>> -EXPORT_SYMBOL_GPL(kvm_set_guest_pmi_handler);
>> +EXPORT_SYMBOL_GPL(x86_set_kvm_irq_handler);
> 
> Can't you just squash this into the previous patch? I mean, what's the
> point of this back and forth?
Ok, I will put this before the previous patch, and let previous patch use
this directly.
> 
>> +void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
>>  {
>> +	if (!handler)
>> +		handler = dummy_handler;
>> +
>> +	if (vector == POSTED_INTR_WAKEUP_VECTOR)
>>  		kvm_posted_intr_wakeup_handler = handler;
>> +	else if (vector == KVM_GUEST_PMI_VECTOR)
>>  		kvm_guest_pmi_handler = handler;
>> +	else
>> +		WARN_ON_ONCE(1);
>> +
>> +	if (handler == dummy_handler)
>>  		synchronize_rcu();
>>  }
>> +EXPORT_SYMBOL_GPL(x86_set_kvm_irq_handler);
> 
> So what about:
> 
>  x86_set_kvm_irq_handler(foo, handler1);
>  x86_set_kvm_irq_handler(foo, handler2);
> 
>  ?
> 
> I'm fairly sure you either want to enforce a NULL<->handler transition,
> or add some additional synchronize stuff.
> 
> Hmm?
yes, x86_set_kvm_irq_handler() is called once for each vector at
kvm/kvm_intel module_init() and module_exit(). so we should enforce a
NULL<->handler transition.

thanks
> 
> 

