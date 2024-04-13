Return-Path: <kvm+bounces-14586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 876A78A3A12
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 03:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA622B21DF5
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 01:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959AB9450;
	Sat, 13 Apr 2024 01:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RUeBHJvZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9808E4C65;
	Sat, 13 Apr 2024 01:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712971037; cv=none; b=Te9jWApM8bP1D5EHitTT9t71AhOHdzatuRFJnE5swLTmzpexQ1oVdMWxRO92RUKxijqxhQ8/DlqXk/KF6s1pP/S2dzggQ6hwNNULhmUhsx53NprweVJ7snYkJqSeS38WnmZmaBNaEadTFNPtIsDhKeCUMRe1chSFkOWj7Xd5Q1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712971037; c=relaxed/simple;
	bh=55ReJDyVB5r2W4OxOdSNq8Xwma1suCauO6ERsIH+3YM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l4Hxk7vkk3zekPgIarX+t0syEeQPlZ9nCKB0Ud6VCizj7k0aZhFEeWZr+5KK6w8vKysrPJqcPY77nstqkXhZ7MHB1HxnTP1V+S+p+Zp4SUAI8cAuPq6WGZVxqBsAXEa6ELrbz9Q+odFFxIz8dFm0PUBw2iLgmJTaRRRi7kyIl+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RUeBHJvZ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712971036; x=1744507036;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=55ReJDyVB5r2W4OxOdSNq8Xwma1suCauO6ERsIH+3YM=;
  b=RUeBHJvZk06UdP5/+F+P7HL0RrHQ+O4EUGpx5h4yKA+y7sSlCLEvYBjw
   dJQFQChYv1VHebpXZj8Q1swU5BDcQeGMjooY7lg1jExceOrazfKXQqXsS
   Wn29UTmthk8AsIQ30X9TgqKgoR1b1lf4EwNu/Fj2J143UfmSXRWwj6L11
   HqJdm3Fl1kEcKV/CE5pLVoZ2der6JTW/MjNvGjtFCjN6vuOwH7OyVdWqn
   FFebDb3ulXtldGfrQogx1mEmrlYm0qMCZ//fjSGBilcz7taM5w9JBeoLS
   WOdgmJHtGSJd3kZUMZbG1gwomyB9WR5Hq9LfB1AhDxIY5khD5hG0MAb2d
   Q==;
X-CSE-ConnectionGUID: E9BsqdqGQKyX4jE/qxQ+nQ==
X-CSE-MsgGUID: Q2Sk2oqRRnWFhxGqRWnpOA==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="12229258"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="12229258"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 18:17:15 -0700
X-CSE-ConnectionGUID: rNDCJI7GT9+wTEVUKQjFhQ==
X-CSE-MsgGUID: /w0TusEkQH2JSdxijFUqDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21883896"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 18:17:10 -0700
Message-ID: <71f037d5-38bb-4493-878f-19adc02af2df@linux.intel.com>
Date: Sat, 13 Apr 2024 09:17:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/41] perf: core/x86: Add support to register a new
 vector for PMI handling
To: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-5-xiong.y.zhang@linux.intel.com>
 <ZhgZdqAB6LlvJLof@google.com>
 <3b4f03f8-146f-46ce-b729-046e9444d9e4@linux.intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <3b4f03f8-146f-46ce-b729-046e9444d9e4@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/12/2024 11:56 AM, Zhang, Xiong Y wrote:
>
> On 4/12/2024 1:10 AM, Sean Christopherson wrote:
>> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>>> From: Xiong Zhang <xiong.y.zhang@intel.com>
>>>
>>> Create a new vector in the host IDT for PMI handling within a passthrough
>>> vPMU implementation. In addition, add a function to allow the registration
>>> of the handler and a function to switch the PMI handler.
>>>
>>> This is the preparation work to support KVM passthrough vPMU to handle its
>>> own PMIs without interference from PMI handler of the host PMU.
>>>
>>> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>> ---
>>>   arch/x86/include/asm/hardirq.h           |  1 +
>>>   arch/x86/include/asm/idtentry.h          |  1 +
>>>   arch/x86/include/asm/irq.h               |  1 +
>>>   arch/x86/include/asm/irq_vectors.h       |  2 +-
>>>   arch/x86/kernel/idt.c                    |  1 +
>>>   arch/x86/kernel/irq.c                    | 29 ++++++++++++++++++++++++
>>>   tools/arch/x86/include/asm/irq_vectors.h |  1 +
>>>   7 files changed, 35 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
>>> index 66837b8c67f1..c1e2c1a480bf 100644
>>> --- a/arch/x86/include/asm/hardirq.h
>>> +++ b/arch/x86/include/asm/hardirq.h
>>> @@ -19,6 +19,7 @@ typedef struct {
>>>   	unsigned int kvm_posted_intr_ipis;
>>>   	unsigned int kvm_posted_intr_wakeup_ipis;
>>>   	unsigned int kvm_posted_intr_nested_ipis;
>>> +	unsigned int kvm_vpmu_pmis;
>> Somewhat off topic, does anyone actually ever use these particular stats?  If the
>> desire is to track _all_ IRQs, why not have an array and bump the counts in common
>> code?
> it is used in arch_show_interrupts() for /proc/interrupts.

Yes, these interrupt stats are useful, e.g. when we analyze the VM-EXIT 
performance overhead, if the vm-exits are caused by external interrupt, 
we usually need to look at these interrupt stats and check which exact 
interrupt causes the vm-exits.

>>>   #endif
>>>   	unsigned int x86_platform_ipis;	/* arch dependent */
>>>   	unsigned int apic_perf_irqs;
>>> diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
>>> index 05fd175cec7d..d1b58366bc21 100644
>>> --- a/arch/x86/include/asm/idtentry.h
>>> +++ b/arch/x86/include/asm/idtentry.h
>>> @@ -675,6 +675,7 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
>>>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
>>>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	sysvec_kvm_posted_intr_wakeup_ipi);
>>>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested_ipi);
>>> +DECLARE_IDTENTRY_SYSVEC(KVM_VPMU_VECTOR,	        sysvec_kvm_vpmu_handler);
>> I vote for KVM_VIRTUAL_PMI_VECTOR.  I don't see any reasy to abbreviate "virtual",
>> and the vector is a for a Performance Monitoring Interupt.
> yes, KVM_GUEST_PMI_VECTOR in your next reply is better.
>>>   #endif
>>>   
>>>   #if IS_ENABLED(CONFIG_HYPERV)
>>> diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
>>> index 836c170d3087..ee268f42d04a 100644
>>> --- a/arch/x86/include/asm/irq.h
>>> +++ b/arch/x86/include/asm/irq.h
>>> @@ -31,6 +31,7 @@ extern void fixup_irqs(void);
>>>   
>>>   #ifdef CONFIG_HAVE_KVM
>>>   extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
>>> +extern void kvm_set_vpmu_handler(void (*handler)(void));
>> virtual_pmi_handler()
>>
>>>   #endif
>>>   
>>>   extern void (*x86_platform_ipi_callback)(void);
>>> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
>>> index 3a19904c2db6..120403572307 100644
>>> --- a/arch/x86/include/asm/irq_vectors.h
>>> +++ b/arch/x86/include/asm/irq_vectors.h
>>> @@ -77,7 +77,7 @@
>>>    */
>>>   #define IRQ_WORK_VECTOR			0xf6
>>>   
>>> -/* 0xf5 - unused, was UV_BAU_MESSAGE */
>>> +#define KVM_VPMU_VECTOR			0xf5
>> This should be inside
>>
>> 	#ifdef CONFIG_HAVE_KVM
>>
>> no?
> yes, it should have #if IS_ENABLED(CONFIG_KVM)
>>>   #define DEFERRED_ERROR_VECTOR		0xf4
>>>   
>>>   /* Vector on which hypervisor callbacks will be delivered */
>>> diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
>>> index 8857abc706e4..6944eec251f4 100644
>>> --- a/arch/x86/kernel/idt.c
>>> +++ b/arch/x86/kernel/idt.c
>>> @@ -157,6 +157,7 @@ static const __initconst struct idt_data apic_idts[] = {
>>>   	INTG(POSTED_INTR_VECTOR,		asm_sysvec_kvm_posted_intr_ipi),
>>>   	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
>>>   	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
>>> +	INTG(KVM_VPMU_VECTOR,		        asm_sysvec_kvm_vpmu_handler),
>> kvm_virtual_pmi_handler
>>
>>> @@ -332,6 +351,16 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_nested_ipi)
>>>   	apic_eoi();
>>>   	inc_irq_stat(kvm_posted_intr_nested_ipis);
>>>   }
>>> +
>>> +/*
>>> + * Handler for KVM_PT_PMU_VECTOR.
>> Heh, not sure where the PT part came from...
> I will change it to KVM_GUEST_PMI_VECTOR
>>> + */
>>> +DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_vpmu_handler)
>>> +{
>>> +	apic_eoi();
>>> +	inc_irq_stat(kvm_vpmu_pmis);
>>> +	kvm_vpmu_handler();
>>> +}
>>>   #endif
>>>   
>>>   
>>> diff --git a/tools/arch/x86/include/asm/irq_vectors.h b/tools/arch/x86/include/asm/irq_vectors.h
>>> index 3a19904c2db6..3773e60f1af8 100644
>>> --- a/tools/arch/x86/include/asm/irq_vectors.h
>>> +++ b/tools/arch/x86/include/asm/irq_vectors.h
>>> @@ -85,6 +85,7 @@
>>>   
>>>   /* Vector for KVM to deliver posted interrupt IPI */
>>>   #ifdef CONFIG_HAVE_KVM
>>> +#define KVM_VPMU_VECTOR			0xf5
>> Heh, and your copy+paste is out of date.
> Get it. 0xf5 isn't aligned with 0xf2, and the above comment should be moved prior POSTED_INTR_VECTOR
>
> thanks
>>>   #define POSTED_INTR_VECTOR		0xf2
>>>   #define POSTED_INTR_WAKEUP_VECTOR	0xf1
>>>   #define POSTED_INTR_NESTED_VECTOR	0xf0
>>> -- 
>>> 2.34.1
>>>

