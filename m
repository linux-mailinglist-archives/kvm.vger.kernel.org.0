Return-Path: <kvm+bounces-14379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA708A2497
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 05:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1644284B1B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 03:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3BD18633;
	Fri, 12 Apr 2024 03:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G05EmPpD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDDC179A7;
	Fri, 12 Apr 2024 03:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712894209; cv=none; b=n7Dd6HA9jW5NiwS5slL1Z42tTafzj4RDV4GVwWlX3MR7LnMk6X1K+bQnJqcxd6vlwVbxDLuTs18FZrBDh145rp1ug70J5mANEI+ux7f6iu3F/WRtCoN68rQtsllbCe9JH2AHKXXdYpRd9wYTVaCd3pHagbTK+1HlG6LVdDU/Qbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712894209; c=relaxed/simple;
	bh=dVE8ejFYs+MmoDhg5v7XCWKQUXiBIQioayTntyIQX88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N2X2qC0c/RkkZxsF2M4tLUk2JU5/tRld4JemhoYVinP/sC0IjiuB/7aWJmprI0ByP2fkuH11sfj3F7hARmmpBGjALAuTNZ3bTDYDBp4Zwa2Dd1SOjX0BFgUt/beRZaOFTasmEm28+k6d7mwpxJ0/nU6pu6FbceC9Wij8hxygaXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G05EmPpD; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712894207; x=1744430207;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dVE8ejFYs+MmoDhg5v7XCWKQUXiBIQioayTntyIQX88=;
  b=G05EmPpDDahlkledEWD2W6amU7yDVdZa+bxVrADc6X0DrsV5zW/Yy7+P
   9S/RTT3dW95d2yRW4kT5TWGeTFtsMvdzJ8z3kguGRVKioTTyWFtXloDML
   JwqlMM2OZihY889LR+qsBmZKorohuJ94/Bfntyha9Vnzn9DxksF7RRhQX
   j0EXuOLcnrp9b8tfFXJFmDqg2/ye+a1Ob/kCo8gt334PaBNSTx72fc/2U
   RD5QyhYnq7r2dN9AfdAu04MJ1S/a0Fxa1pcFPBBVS0IYxYP7O8SE5HaYh
   KXIRSexVAeazjVnAmbc6p+KAgYQqbHSHl/7mawog72fz7GUdz+teaf15k
   g==;
X-CSE-ConnectionGUID: 5DihpX39QQeEad9sYDCllg==
X-CSE-MsgGUID: VBphGpeeQiSHAUs8eq+n5w==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8513944"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8513944"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 20:56:46 -0700
X-CSE-ConnectionGUID: 8byiRHh6T9WVfrl5fPiPqQ==
X-CSE-MsgGUID: QmCvFNmcRU+rsn+K2OoAmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="21160772"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.244.162]) ([10.124.244.162])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 20:56:42 -0700
Message-ID: <3b4f03f8-146f-46ce-b729-046e9444d9e4@linux.intel.com>
Date: Fri, 12 Apr 2024 11:56:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/41] perf: core/x86: Add support to register a new
 vector for PMI handling
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-5-xiong.y.zhang@linux.intel.com>
 <ZhgZdqAB6LlvJLof@google.com>
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <ZhgZdqAB6LlvJLof@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/12/2024 1:10 AM, Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>> From: Xiong Zhang <xiong.y.zhang@intel.com>
>>
>> Create a new vector in the host IDT for PMI handling within a passthrough
>> vPMU implementation. In addition, add a function to allow the registration
>> of the handler and a function to switch the PMI handler.
>>
>> This is the preparation work to support KVM passthrough vPMU to handle its
>> own PMIs without interference from PMI handler of the host PMU.
>>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/include/asm/hardirq.h           |  1 +
>>  arch/x86/include/asm/idtentry.h          |  1 +
>>  arch/x86/include/asm/irq.h               |  1 +
>>  arch/x86/include/asm/irq_vectors.h       |  2 +-
>>  arch/x86/kernel/idt.c                    |  1 +
>>  arch/x86/kernel/irq.c                    | 29 ++++++++++++++++++++++++
>>  tools/arch/x86/include/asm/irq_vectors.h |  1 +
>>  7 files changed, 35 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
>> index 66837b8c67f1..c1e2c1a480bf 100644
>> --- a/arch/x86/include/asm/hardirq.h
>> +++ b/arch/x86/include/asm/hardirq.h
>> @@ -19,6 +19,7 @@ typedef struct {
>>  	unsigned int kvm_posted_intr_ipis;
>>  	unsigned int kvm_posted_intr_wakeup_ipis;
>>  	unsigned int kvm_posted_intr_nested_ipis;
>> +	unsigned int kvm_vpmu_pmis;
> 
> Somewhat off topic, does anyone actually ever use these particular stats?  If the
> desire is to track _all_ IRQs, why not have an array and bump the counts in common
> code?
it is used in arch_show_interrupts() for /proc/interrupts.
> 
>>  #endif
>>  	unsigned int x86_platform_ipis;	/* arch dependent */
>>  	unsigned int apic_perf_irqs;
>> diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
>> index 05fd175cec7d..d1b58366bc21 100644
>> --- a/arch/x86/include/asm/idtentry.h
>> +++ b/arch/x86/include/asm/idtentry.h
>> @@ -675,6 +675,7 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
>>  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
>>  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	sysvec_kvm_posted_intr_wakeup_ipi);
>>  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested_ipi);
>> +DECLARE_IDTENTRY_SYSVEC(KVM_VPMU_VECTOR,	        sysvec_kvm_vpmu_handler);
> 
> I vote for KVM_VIRTUAL_PMI_VECTOR.  I don't see any reasy to abbreviate "virtual",
> and the vector is a for a Performance Monitoring Interupt.
yes, KVM_GUEST_PMI_VECTOR in your next reply is better.
> 
>>  #endif
>>  
>>  #if IS_ENABLED(CONFIG_HYPERV)
>> diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
>> index 836c170d3087..ee268f42d04a 100644
>> --- a/arch/x86/include/asm/irq.h
>> +++ b/arch/x86/include/asm/irq.h
>> @@ -31,6 +31,7 @@ extern void fixup_irqs(void);
>>  
>>  #ifdef CONFIG_HAVE_KVM
>>  extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
>> +extern void kvm_set_vpmu_handler(void (*handler)(void));
> 
> virtual_pmi_handler()
> 
>>  #endif
>>  
>>  extern void (*x86_platform_ipi_callback)(void);
>> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
>> index 3a19904c2db6..120403572307 100644
>> --- a/arch/x86/include/asm/irq_vectors.h
>> +++ b/arch/x86/include/asm/irq_vectors.h
>> @@ -77,7 +77,7 @@
>>   */
>>  #define IRQ_WORK_VECTOR			0xf6
>>  
>> -/* 0xf5 - unused, was UV_BAU_MESSAGE */
>> +#define KVM_VPMU_VECTOR			0xf5
> 
> This should be inside
> 
> 	#ifdef CONFIG_HAVE_KVM
> 
> no?
yes, it should have #if IS_ENABLED(CONFIG_KVM)
> 
>>  #define DEFERRED_ERROR_VECTOR		0xf4
>>  
>>  /* Vector on which hypervisor callbacks will be delivered */
>> diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
>> index 8857abc706e4..6944eec251f4 100644
>> --- a/arch/x86/kernel/idt.c
>> +++ b/arch/x86/kernel/idt.c
>> @@ -157,6 +157,7 @@ static const __initconst struct idt_data apic_idts[] = {
>>  	INTG(POSTED_INTR_VECTOR,		asm_sysvec_kvm_posted_intr_ipi),
>>  	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
>>  	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
>> +	INTG(KVM_VPMU_VECTOR,		        asm_sysvec_kvm_vpmu_handler),
> 
> kvm_virtual_pmi_handler
> 
>> @@ -332,6 +351,16 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_nested_ipi)
>>  	apic_eoi();
>>  	inc_irq_stat(kvm_posted_intr_nested_ipis);
>>  }
>> +
>> +/*
>> + * Handler for KVM_PT_PMU_VECTOR.
> 
> Heh, not sure where the PT part came from...
I will change it to KVM_GUEST_PMI_VECTOR
> 
>> + */
>> +DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_vpmu_handler)
>> +{
>> +	apic_eoi();
>> +	inc_irq_stat(kvm_vpmu_pmis);
>> +	kvm_vpmu_handler();
>> +}
>>  #endif
>>  
>>  
>> diff --git a/tools/arch/x86/include/asm/irq_vectors.h b/tools/arch/x86/include/asm/irq_vectors.h
>> index 3a19904c2db6..3773e60f1af8 100644
>> --- a/tools/arch/x86/include/asm/irq_vectors.h
>> +++ b/tools/arch/x86/include/asm/irq_vectors.h
>> @@ -85,6 +85,7 @@
>>  
>>  /* Vector for KVM to deliver posted interrupt IPI */
>>  #ifdef CONFIG_HAVE_KVM
>> +#define KVM_VPMU_VECTOR			0xf5
> 
> Heh, and your copy+paste is out of date.
Get it. 0xf5 isn't aligned with 0xf2, and the above comment should be moved prior POSTED_INTR_VECTOR

thanks
> 
>>  #define POSTED_INTR_VECTOR		0xf2
>>  #define POSTED_INTR_WAKEUP_VECTOR	0xf1
>>  #define POSTED_INTR_NESTED_VECTOR	0xf0
>> -- 
>> 2.34.1
>>

