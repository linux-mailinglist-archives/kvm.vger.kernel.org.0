Return-Path: <kvm+bounces-26194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5C79728BA
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 07:00:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE3FB1C23E4E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 05:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D734616BE23;
	Tue, 10 Sep 2024 04:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VpiKvRlN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5603A152E1C;
	Tue, 10 Sep 2024 04:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725944394; cv=none; b=jSkqlx8hKjwa+/7I+F15a5lz/TRujeESSoZEB9rv7zGdbpCVVJ4ZJgrAvCgiGDwWpPPWm5RKMXdVUg4U6/kufo6wtSv3cBTCoXpZ2JI+EmRuZxeVRkfSVDT3gLS2zeg0ZJLs96PHI/XaeuCWF7pgJbiC1lYLCegy3LOGEGKePs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725944394; c=relaxed/simple;
	bh=SaAhyUtGBIY1iZNe+4szVGnESB03mvSjl2UoqlZLAW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dcsrjuFVKOTjhcdiA+bZlYA/RSC/o5/VlVE/i9TTMgiVi4Z8Nm7qqSRrgnkZoIIjhzI6WTK3u4Ny7qn8Hic3B8+uQ4YSOQEq9fNHlV6/qxoAnTwt7DO0MYtuqUXeih4SgsZZjbx6EDTg3YnwlaOCM94JPAqPLBY667denwBPqWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VpiKvRlN; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725944392; x=1757480392;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SaAhyUtGBIY1iZNe+4szVGnESB03mvSjl2UoqlZLAW4=;
  b=VpiKvRlN5c7AMsCbgCfW06UYOVo9JjnZ2lsx7jmfnfX+SPdsyN3mGWLG
   bhHB9GsRzm8VCDPB2Ge64D/TKnWuw1jX0esb0vG/a4yphlxdur2kD6Oe6
   dxB0x321m9r8N6zHz6y6gF6zGQnk1OiF0CKP3m+V1eqBE/xB5bGAbExK9
   sL1WGHHRMw+6oO+9gArZJQBbchrwhlaJZTj6W1lgmqEhRF4IQSHBSgQJo
   7sZpoN0z9/aJOAklgveDuLjzOqmXm2+/9mezBAO+y7EAnSfRlTIIVpyEC
   2rfL3rbgaAsSdOUqmAd5J8dlZdLb1hffLlt/L+twLavTTB+Po7+C7XAgo
   g==;
X-CSE-ConnectionGUID: fOg6A79/R1i80YBOtYFN4Q==
X-CSE-MsgGUID: mPzPGubuR+qgom18q6bmJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="13451244"
X-IronPort-AV: E=Sophos;i="6.10,216,1719903600"; 
   d="scan'208";a="13451244"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 21:59:52 -0700
X-CSE-ConnectionGUID: iANce5W6QlGW5SCyUuAqjA==
X-CSE-MsgGUID: YbQXgF+UQ/OY7cTgmPEO7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,216,1719903600"; 
   d="scan'208";a="67150140"
Received: from unknown (HELO [10.238.2.208]) ([10.238.2.208])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 21:59:47 -0700
Message-ID: <8d194eea-04a5-455d-91fc-d44aabec1ef6@linux.intel.com>
Date: Tue, 10 Sep 2024 12:59:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 12/58] perf: core/x86: Register a new vector for
 KVM GUEST PMI
To: Colton Lewis <coltonlewis@google.com>, Mingwei Zhang <mizhang@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, xiong.y.zhang@intel.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, manali.shukla@amd.com,
 sandipan.das@amd.com, jmattson@google.com, eranian@google.com,
 irogers@google.com, namhyung@kernel.org, gce-passthrou-pmu-dev@google.com,
 samantha.alt@intel.com, zhiyuan.lv@intel.com, yanfei.xu@intel.com,
 like.xu.linux@gmail.com, peterz@infradead.org, rananta@google.com,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <gsnt7cbkeavc.fsf@coltonlewis-kvm.c.googlers.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <gsnt7cbkeavc.fsf@coltonlewis-kvm.c.googlers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 9/10/2024 6:11 AM, Colton Lewis wrote:
> Hello,
>
> Mingwei Zhang <mizhang@google.com> writes:
>
>> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Create a new vector in the host IDT for kvm guest PMI handling within
>> mediated passthrough vPMU. In addition, guest PMI handler registration
>> is added into x86_set_kvm_irq_handler().
>> This is the preparation work to support mediated passthrough vPMU to
>> handle kvm guest PMIs without interference from PMI handler of the host
>> PMU.
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>   arch/x86/include/asm/hardirq.h                |  1 +
>>   arch/x86/include/asm/idtentry.h               |  1 +
>>   arch/x86/include/asm/irq_vectors.h            |  5 ++++-
>>   arch/x86/kernel/idt.c                         |  1 +
>>   arch/x86/kernel/irq.c                         | 21 +++++++++++++++++++
>>   .../beauty/arch/x86/include/asm/irq_vectors.h |  5 ++++-
>>   6 files changed, 32 insertions(+), 2 deletions(-)
>> diff --git a/arch/x86/include/asm/hardirq.h  
>> b/arch/x86/include/asm/hardirq.h
>> index c67fa6ad098a..42a396763c8d 100644
>> --- a/arch/x86/include/asm/hardirq.h
>> +++ b/arch/x86/include/asm/hardirq.h
>> @@ -19,6 +19,7 @@ typedef struct {
>>   	unsigned int kvm_posted_intr_ipis;
>>   	unsigned int kvm_posted_intr_wakeup_ipis;
>>   	unsigned int kvm_posted_intr_nested_ipis;
>> +	unsigned int kvm_guest_pmis;
>>   #endif
>>   	unsigned int x86_platform_ipis;	/* arch dependent */
>>   	unsigned int apic_perf_irqs;
>> diff --git a/arch/x86/include/asm/idtentry.h  
>> b/arch/x86/include/asm/idtentry.h
>> index d4f24499b256..7b1e3e542b1d 100644
>> --- a/arch/x86/include/asm/idtentry.h
>> +++ b/arch/x86/include/asm/idtentry.h
>> @@ -745,6 +745,7 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		 
>> sysvec_irq_work);
>>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
>>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	 
>> sysvec_kvm_posted_intr_wakeup_ipi);
>>   DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	 
>> sysvec_kvm_posted_intr_nested_ipi);
>> +DECLARE_IDTENTRY_SYSVEC(KVM_GUEST_PMI_VECTOR,	         
>> sysvec_kvm_guest_pmi_handler);
>>   #else
>>   # define fred_sysvec_kvm_posted_intr_ipi		NULL
>>   # define fred_sysvec_kvm_posted_intr_wakeup_ipi		NULL
>> diff --git a/arch/x86/include/asm/irq_vectors.h  
>> b/arch/x86/include/asm/irq_vectors.h
>> index 13aea8fc3d45..ada270e6f5cb 100644
>> --- a/arch/x86/include/asm/irq_vectors.h
>> +++ b/arch/x86/include/asm/irq_vectors.h
>> @@ -77,7 +77,10 @@
>>    */
>>   #define IRQ_WORK_VECTOR			0xf6
>> -/* 0xf5 - unused, was UV_BAU_MESSAGE */
>> +#if IS_ENABLED(CONFIG_KVM)
>> +#define KVM_GUEST_PMI_VECTOR		0xf5
>> +#endif
>> +
>>   #define DEFERRED_ERROR_VECTOR		0xf4
>>   /* Vector on which hypervisor callbacks will be delivered */
>> diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
>> index f445bec516a0..0bec4c7e2308 100644
>> --- a/arch/x86/kernel/idt.c
>> +++ b/arch/x86/kernel/idt.c
>> @@ -157,6 +157,7 @@ static const __initconst struct idt_data apic_idts[]  
>> = {
>>   	INTG(POSTED_INTR_VECTOR,		asm_sysvec_kvm_posted_intr_ipi),
>>   	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
>>   	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
>> +	INTG(KVM_GUEST_PMI_VECTOR,		asm_sysvec_kvm_guest_pmi_handler),
>
> There is a subtle inconsistency in that this code is guarded on
> CONFIG_HAVE_KVM when the #define KVM_GUEST_PMI_VECTOR is guarded on
> CONFIG_KVM. Beats me why there are two different flags that are so
> similar, but it is possible they have different values leading to
> compilation errors.
>
> I happened to hit this compilation error because make defconfig will
> define CONFIG_HAVE_KVM but not CONFIG_KVM. CONFIG_KVM is the more strict
> of the two because it depends on CONFIG_HAVE_KVM.
>
> This code should also be guarded on CONFIG_KVM.

Hi Colton,

 what's you kernel base? In latest code base, the CONFIG_HAVE_KVM has been
dropped and this part of code has been guarded by CONFIG_KVM.

Please see commit dcf0926e9b89 "x86: replace CONFIG_HAVE_KVM with
IS_ENABLED(CONFIG_KVM)". Thanks.


>
>>   # endif
>>   # ifdef CONFIG_IRQ_WORK
>>   	INTG(IRQ_WORK_VECTOR,			asm_sysvec_irq_work),
>> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
>> index 18cd418fe106..b29714e23fc4 100644
>> --- a/arch/x86/kernel/irq.c
>> +++ b/arch/x86/kernel/irq.c
>> @@ -183,6 +183,12 @@ int arch_show_interrupts(struct seq_file *p, int  
>> prec)
>>   		seq_printf(p, "%10u ",
>>   			   irq_stats(j)->kvm_posted_intr_wakeup_ipis);
>>   	seq_puts(p, "  Posted-interrupt wakeup event\n");
>> +
>> +	seq_printf(p, "%*s: ", prec, "VPMU");
>> +	for_each_online_cpu(j)
>> +		seq_printf(p, "%10u ",
>> +			   irq_stats(j)->kvm_guest_pmis);
>> +	seq_puts(p, " KVM GUEST PMI\n");
>>   #endif
>>   #ifdef CONFIG_X86_POSTED_MSI
>>   	seq_printf(p, "%*s: ", prec, "PMN");
>> @@ -311,6 +317,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
>>   #if IS_ENABLED(CONFIG_KVM)
>>   static void dummy_handler(void) {}
>>   static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
>> +static void (*kvm_guest_pmi_handler)(void) = dummy_handler;
>>   void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
>>   {
>> @@ -321,6 +328,10 @@ void x86_set_kvm_irq_handler(u8 vector, void  
>> (*handler)(void))
>>   	    (handler == dummy_handler ||
>>   	     kvm_posted_intr_wakeup_handler == dummy_handler))
>>   		kvm_posted_intr_wakeup_handler = handler;
>> +	else if (vector == KVM_GUEST_PMI_VECTOR &&
>> +		 (handler == dummy_handler ||
>> +		  kvm_guest_pmi_handler == dummy_handler))
>> +		kvm_guest_pmi_handler = handler;
>>   	else
>>   		WARN_ON_ONCE(1);
>> @@ -356,6 +367,16 @@  
>> DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm_posted_intr_nested_ipi)
>>   	apic_eoi();
>>   	inc_irq_stat(kvm_posted_intr_nested_ipis);
>>   }
>> +
>> +/*
>> + * Handler for KVM_GUEST_PMI_VECTOR.
>> + */
>> +DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_guest_pmi_handler)
>> +{
>> +	apic_eoi();
>> +	inc_irq_stat(kvm_guest_pmis);
>> +	kvm_guest_pmi_handler();
>> +}
>>   #endif
>>   #ifdef CONFIG_X86_POSTED_MSI
>> diff --git a/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h  
>> b/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
>> index 13aea8fc3d45..670dcee46631 100644
>> --- a/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
>> +++ b/tools/perf/trace/beauty/arch/x86/include/asm/irq_vectors.h
>> @@ -77,7 +77,10 @@
>>    */
>>   #define IRQ_WORK_VECTOR			0xf6
>> -/* 0xf5 - unused, was UV_BAU_MESSAGE */
>> +#if IS_ENABLED(CONFIG_KVM)
>> +#define KVM_GUEST_PMI_VECTOR           0xf5
>> +#endif
>> +
>>   #define DEFERRED_ERROR_VECTOR		0xf4
>>   /* Vector on which hypervisor callbacks will be delivered */

