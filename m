Return-Path: <kvm+bounces-10035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70EE1868B48
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AEB41C22361
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 08:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29F4130E36;
	Tue, 27 Feb 2024 08:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ngn80S+j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C53A12F371;
	Tue, 27 Feb 2024 08:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709023945; cv=none; b=g34O1xA7iA6VTxPG1ALo118TsxKo2wkGsz8p65t5bK9vNJC8nwNU9kRR0NCbPXzWLOjy9QjFx0TlBjczyMSSN3Uk8smudpfsqfWRpNSF+25pPZvpVZYniViLMyYz21ZXqT8cWxxr6wgblYiHsaCra7Le8GaO4JujPSMcJqYgY0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709023945; c=relaxed/simple;
	bh=H6HhWXVALwe0OTdndhkZ0PlEh8ogqps+QZQoDWcRxuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J4LFCcXrf6v6O3fUhMFlInJeSycGCZX7Z2YxUb0z+DE1uW+STZt77RzGISA0M9yXfRUnXessm+laaWJqYvnSlf8xpin6e5CEA3+aFtkYhDSEQPn069hSD/alaH9vCOqXp+9u2AXgYWzdpwV0dwkxATtqIa7gY0n34hyi1ylY9mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ngn80S+j; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709023944; x=1740559944;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H6HhWXVALwe0OTdndhkZ0PlEh8ogqps+QZQoDWcRxuU=;
  b=Ngn80S+js0NGTttOPQk2MnvY0RL9HYLBMZFu3msiVuAAVOs5Oz6NVaU9
   OI11qaH20uXZ15IQ/EuD87v5V4eL4vMBQn+XARyoUf5whXAwIr6NInEqi
   /MZXg/BQi/G+nFOmxvVbQeAEeooViehaLOjguBTZqLiiB+bOxMzB/ejNG
   SFrijNLteEt1/Ssp5pVAWpGB47Zdxyu3hhvRZ/AqcbTh6Gcu7g04lUkuE
   SzI4rqHBr8uw5ILBieOmetoIu1yyMPhLwdaSyM8IpPQY8RNVfoEl5Z1IM
   KcWQNKQhFldrhv2lHEJiFS06iw1/WsEwoHL5BYBb2mX+fGSCcYnq8aCBk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14777198"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="14777198"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 00:52:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="11704123"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.85]) ([10.238.9.85])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 00:52:04 -0800
Message-ID: <3b99cf5d-08c7-4ef1-84dd-ebbf246e601f@linux.intel.com>
Date: Tue, 27 Feb 2024 16:52:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 091/130] KVM: TDX: remove use of struct vcpu_vmx from
 posted_interrupt.c
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <6c7774a44515d6787c9512cb05c3b305e9b5855c.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <6c7774a44515d6787c9512cb05c3b305e9b5855c.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> As TDX will use posted_interrupt.c, the use of struct vcpu_vmx is a
> blocker.  Because the members of

Extra "of"

> struct pi_desc pi_desc and struct
> list_head pi_wakeup_list are only used in posted_interrupt.c, introduce
> common structure, struct vcpu_pi, make vcpu_vmx and vcpu_tdx has same
> layout in the top of structure.
>
> To minimize the diff size, avoid code conversion like,
> vmx->pi_desc => vmx->common->pi_desc.  Instead add compile time check
> if the layout is expected.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/posted_intr.c | 41 ++++++++++++++++++++++++++--------
>   arch/x86/kvm/vmx/posted_intr.h | 11 +++++++++
>   arch/x86/kvm/vmx/tdx.c         |  1 +
>   arch/x86/kvm/vmx/tdx.h         |  8 +++++++
>   arch/x86/kvm/vmx/vmx.h         | 14 +++++++-----
>   5 files changed, 60 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index af662312fd07..b66add9da0f3 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -11,6 +11,7 @@
>   #include "posted_intr.h"
>   #include "trace.h"
>   #include "vmx.h"
> +#include "tdx.h"
>   
>   /*
>    * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
> @@ -31,9 +32,29 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
>    */
>   static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
>   
> +/*
> + * The layout of the head of struct vcpu_vmx and struct vcpu_tdx must match with
> + * struct vcpu_pi.
> + */
> +static_assert(offsetof(struct vcpu_pi, pi_desc) ==
> +	      offsetof(struct vcpu_vmx, pi_desc));
> +static_assert(offsetof(struct vcpu_pi, pi_wakeup_list) ==
> +	      offsetof(struct vcpu_vmx, pi_wakeup_list));
> +#ifdef CONFIG_INTEL_TDX_HOST
> +static_assert(offsetof(struct vcpu_pi, pi_desc) ==
> +	      offsetof(struct vcpu_tdx, pi_desc));
> +static_assert(offsetof(struct vcpu_pi, pi_wakeup_list) ==
> +	      offsetof(struct vcpu_tdx, pi_wakeup_list));
> +#endif
> +
> +static inline struct vcpu_pi *vcpu_to_pi(struct kvm_vcpu *vcpu)
> +{
> +	return (struct vcpu_pi *)vcpu;
> +}
> +
>   static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
>   {
> -	return &(to_vmx(vcpu)->pi_desc);
> +	return &vcpu_to_pi(vcpu)->pi_desc;
>   }
>   
>   static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
> @@ -52,8 +73,8 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
>   
>   void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>   {
> -	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct vcpu_pi *vcpu_pi = vcpu_to_pi(vcpu);
> +	struct pi_desc *pi_desc = &vcpu_pi->pi_desc;
>   	struct pi_desc old, new;
>   	unsigned long flags;
>   	unsigned int dest;
> @@ -90,7 +111,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>   	 */
>   	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
>   		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> -		list_del(&vmx->pi_wakeup_list);
> +		list_del(&vcpu_pi->pi_wakeup_list);
>   		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>   	}
>   
> @@ -145,15 +166,15 @@ static bool vmx_can_use_vtd_pi(struct kvm *kvm)
>    */
>   static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>   {
> -	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct vcpu_pi *vcpu_pi = vcpu_to_pi(vcpu);
> +	struct pi_desc *pi_desc = &vcpu_pi->pi_desc;
>   	struct pi_desc old, new;
>   	unsigned long flags;
>   
>   	local_irq_save(flags);
>   
>   	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> -	list_add_tail(&vmx->pi_wakeup_list,
> +	list_add_tail(&vcpu_pi->pi_wakeup_list,
>   		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
>   	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>   
> @@ -190,7 +211,8 @@ static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
>   	 * notification vector is switched to the one that calls
>   	 * back to the pi_wakeup_handler() function.
>   	 */
> -	return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
> +	return (vmx_can_use_ipiv(vcpu) && !is_td_vcpu(vcpu)) ||
> +		vmx_can_use_vtd_pi(vcpu->kvm);
>   }
>   
>   void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
> @@ -200,7 +222,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>   	if (!vmx_needs_pi_wakeup(vcpu))
>   		return;
>   
> -	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
> +	if (kvm_vcpu_is_blocking(vcpu) &&
> +	    (is_td_vcpu(vcpu) || !vmx_interrupt_blocked(vcpu)))
>   		pi_enable_wakeup_handler(vcpu);
>   
>   	/*
> diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
> index 26992076552e..2fe8222308b2 100644
> --- a/arch/x86/kvm/vmx/posted_intr.h
> +++ b/arch/x86/kvm/vmx/posted_intr.h
> @@ -94,6 +94,17 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
>   			(unsigned long *)&pi_desc->control);
>   }
>   
> +struct vcpu_pi {
> +	struct kvm_vcpu	vcpu;
> +
> +	/* Posted interrupt descriptor */
> +	struct pi_desc pi_desc;
> +
> +	/* Used if this vCPU is waiting for PI notification wakeup. */
> +	struct list_head pi_wakeup_list;
> +	/* Until here common layout betwwn vcpu_vmx and vcpu_tdx. */

s/betwwn/between

Also, in pi_wakeup_handler(), it is still using struct vcpu_vmx, but it 
could
be vcpu_tdx.
Functionally it is OK, however, since you have added vcpu_pi, should it use
vcpu_pi instead of vcpu_vmx in pi_wakeup_handler()?

> +};
> +
>   void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
>   void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
>   void pi_wakeup_handler(void);
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index a5b52aa6d153..1da58c36217c 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -584,6 +584,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   
>   	fpstate_set_confidential(&vcpu->arch.guest_fpu);
>   	vcpu->arch.apic->guest_apic_protected = true;
> +	INIT_LIST_HEAD(&tdx->pi_wakeup_list);
>   
>   	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
>   
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 7f8c78f06508..eaffa7384725 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -4,6 +4,7 @@
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
>   
> +#include "posted_intr.h"
>   #include "pmu_intel.h"
>   #include "tdx_ops.h"
>   
> @@ -69,6 +70,13 @@ union tdx_exit_reason {
>   struct vcpu_tdx {
>   	struct kvm_vcpu	vcpu;
>   
> +	/* Posted interrupt descriptor */
> +	struct pi_desc pi_desc;
> +
> +	/* Used if this vCPU is waiting for PI notification wakeup. */
> +	struct list_head pi_wakeup_list;
> +	/* Until here same layout to struct vcpu_pi. */
> +
>   	unsigned long tdvpr_pa;
>   	unsigned long *tdvpx_pa;
>   	bool td_vcpu_created;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 79ff54f08fee..634a9a250b95 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -235,6 +235,14 @@ struct nested_vmx {
>   
>   struct vcpu_vmx {
>   	struct kvm_vcpu       vcpu;
> +
> +	/* Posted interrupt descriptor */
> +	struct pi_desc pi_desc;
> +
> +	/* Used if this vCPU is waiting for PI notification wakeup. */
> +	struct list_head pi_wakeup_list;
> +	/* Until here same layout to struct vcpu_pi. */
> +
>   	u8                    fail;
>   	u8		      x2apic_msr_bitmap_mode;
>   
> @@ -304,12 +312,6 @@ struct vcpu_vmx {
>   
>   	union vmx_exit_reason exit_reason;
>   
> -	/* Posted interrupt descriptor */
> -	struct pi_desc pi_desc;
> -
> -	/* Used if this vCPU is waiting for PI notification wakeup. */
> -	struct list_head pi_wakeup_list;
> -
>   	/* Support for a guest hypervisor (nested VMX) */
>   	struct nested_vmx nested;
>   


