Return-Path: <kvm+bounces-19748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29EE990A1AC
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 03:20:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33871B21806
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 01:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469578480;
	Mon, 17 Jun 2024 01:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n0cCjMS6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92490DDC9;
	Mon, 17 Jun 2024 01:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718587243; cv=none; b=X8hqlS2SLewgnkbMIfpwuJ1JcTN8Qa2GneucNjK79mMLYoUDK3t1l6FGmpNV3etCl5e4ANsR3Pss1FpgHWdOlNr5/tpQv3u4wiFgqXNUwfRJ7adDtzCERDwb4/YIqJAEolG0J+q4y+FeACigQyUW97aPstI2ZCr3CXofDFNLojo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718587243; c=relaxed/simple;
	bh=KrCVu5lgKQY6fzqaeV8xA84C9bbqRdhrHvdzoQI1BLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8zxfjjK01R9BQgNFNWyUmDXT99TOoMoZfi3zUJEEonRweA912Sh42jBKLc/gsqqc6rWx5vP8LAaFkdYjg0fTOQ84X3xWKJhtYe5RBFaxBOgyD0q3iXQ8eqMdO1Ep4J6ZPL4EFPvaExDi9MQR6ARBpKtHsmJFiI16hwnTDtboJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n0cCjMS6; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718587242; x=1750123242;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KrCVu5lgKQY6fzqaeV8xA84C9bbqRdhrHvdzoQI1BLs=;
  b=n0cCjMS6XRmsuJz0q+7IRfQ/iO9p2GkjeFOSJ9mxr1NwtQaGEE7jmPml
   FP02441rH8dkwHQUHTbRE6uoSEsuGoFBUE0iWToNcSQJQT1ceIzjv4iJ9
   E9D+PmtNdl37C6XQueux/+AjctyTPUEyWaVXKAJZKQDXeXUekI/vhux/g
   NK/KSZnqCGvfbj1Id0U8v7nGst7YCsghmAb3B4jXfxHN/jp4W2FBK01Wh
   yY8ECZOgAEB8wRRwSEf5Zg1yyWBTBPGebAHEgC7JsYiyPqDMYB1dCfHGk
   j3IofmVTwhjpbO/q6Z8HkkRLIRynEdO8oDClbDzuf2/XAMmYX9Ql1Nhih
   A==;
X-CSE-ConnectionGUID: M/m8wsKGSfyULW08zXCHnw==
X-CSE-MsgGUID: serxwB81R2CAHUrKwuiUgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11105"; a="32945786"
X-IronPort-AV: E=Sophos;i="6.08,243,1712646000"; 
   d="scan'208";a="32945786"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 18:20:41 -0700
X-CSE-ConnectionGUID: 3LFei8X/RDqWa4lfpcW7xQ==
X-CSE-MsgGUID: 5mZ66enSRmWQxdT6Pp2c7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,243,1712646000"; 
   d="scan'208";a="45491592"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.234.76]) ([10.124.234.76])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 18:20:38 -0700
Message-ID: <c45a1448-09ee-4750-bf86-28295dfc6089@linux.intel.com>
Date: Mon, 17 Jun 2024 09:20:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 117/130] KVM: TDX: Silently ignore INIT/SIPI
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a4225de42be0f7568c5ecb5c22f2029f8e91d62.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <4a4225de42be0f7568c5ecb5c22f2029f8e91d62.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> The TDX module API doesn't provide API for VMM to inject INIT IPI and SIPI.
> Instead it defines the different protocols to boot application processors.
> Ignore INIT and SIPI events for the TDX guest.
>
> There are two options. 1) (silently) ignore INIT/SIPI request or 2) return
> error to guest TDs somehow.  Given that TDX guest is paravirtualized to
> boot AP, the option 1 is chosen for simplicity.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    |  2 ++
>   arch/x86/kvm/lapic.c               | 19 +++++++++++-------
>   arch/x86/kvm/svm/svm.c             |  1 +
>   arch/x86/kvm/vmx/main.c            | 32 ++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.c             |  4 ++--
>   6 files changed, 48 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 22d93d4124c8..85c04aad6ab3 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -149,6 +149,7 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
>   KVM_X86_OP(msr_filter_changed)
>   KVM_X86_OP(complete_emulated_msr)
>   KVM_X86_OP(vcpu_deliver_sipi_vector)
> +KVM_X86_OP(vcpu_deliver_init)
>   KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>   KVM_X86_OP_OPTIONAL(get_untagged_addr)
>   KVM_X86_OP_OPTIONAL_RET0(gmem_max_level)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index bb8be091f996..2686c080820b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1836,6 +1836,7 @@ struct kvm_x86_ops {
>   	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>   
>   	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> +	void (*vcpu_deliver_init)(struct kvm_vcpu *vcpu);
>   
>   	/*
>   	 * Returns vCPU specific APICv inhibit reasons
> @@ -2092,6 +2093,7 @@ void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
>   void kvm_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
>   int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector, int seg);
>   void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
> +void kvm_vcpu_deliver_init(struct kvm_vcpu *vcpu);
>   
>   int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>   		    int reason, bool has_error_code, u32 error_code);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 8025c7f614e0..431074679e83 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -3268,6 +3268,16 @@ int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
>   	return 0;
>   }
>   
> +void kvm_vcpu_deliver_init(struct kvm_vcpu *vcpu)
> +{
> +	kvm_vcpu_reset(vcpu, true);
> +	if (kvm_vcpu_is_bsp(vcpu))
> +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +	else
> +		vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> +}
> +EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_init);
> +
>   int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -3299,13 +3309,8 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>   		return 0;
>   	}
>   
> -	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
> -		kvm_vcpu_reset(vcpu, true);
> -		if (kvm_vcpu_is_bsp(apic->vcpu))
> -			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> -		else
> -			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> -	}
> +	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events))
> +		static_call(kvm_x86_vcpu_deliver_init)(vcpu);
>   	if (test_and_clear_bit(KVM_APIC_SIPI, &apic->pending_events)) {
>   		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
>   			/* evaluate pending_events before reading the vector */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f76dd52d29ba..27546d993809 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5037,6 +5037,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.complete_emulated_msr = svm_complete_emulated_msr,
>   
>   	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> +	.vcpu_deliver_init = kvm_vcpu_deliver_init,
>   	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
>   };
>   
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 4f3b872cd401..84d2dc818cf7 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -320,6 +320,14 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
>   }
>   #endif
>   
> +static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return true;

Since for TD, INIT is always blocked, then in kvm_apic_accept_events(), 
the code path to handle INIT/SIPI delivery will not be called, i.e, the 
OPs .vcpu_deliver_init() and .vcpu_deliver_sipi_vector() are never 
called for TD.
Seems no need to add the new interface  vcpu_deliver_init or the new 
wrapper vt_vcpu_deliver_sipi_vector().

And consider the INIT/SIPI for TD:
- Normally, for TD, INIT ans SIPI should not be set in APIC's 
pending_events.
   Maybe we can call KVM_BUG_ON() in vt_apic_init_signal_blocked() for TD?
- If INIT and SIPI are allowed be set in APIC's pending_events for 
somehow, the current code has a problem, it will never clear INIT bit in 
APIC's pending_events.
   Then kvm_apic_accept_events() needs to execute more check code if 
INIT was once set.
   INIT bit should be cleared with this assumption.



> +
> +	return vmx_apic_init_signal_blocked(vcpu);
> +}
> +
>   static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
>   {
>   	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
> @@ -348,6 +356,25 @@ static void vt_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>   	vmx_deliver_interrupt(apic, delivery_mode, trig_mode, vector);
>   }
>   
> +static void vt_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	kvm_vcpu_deliver_sipi_vector(vcpu, vector);
> +}
> +
> +static void vt_vcpu_deliver_init(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		/* TDX doesn't support INIT.  Ignore INIT event */
> +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +		return;
> +	}
> +
> +	kvm_vcpu_deliver_init(vcpu);
> +}
> +
>   static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu)) {
> @@ -744,13 +771,14 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   #endif
>   
>   	.check_emulate_instruction = vmx_check_emulate_instruction,
> -	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> +	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
>   	.migrate_timers = vmx_migrate_timers,
>   
>   	.msr_filter_changed = vt_msr_filter_changed,
>   	.complete_emulated_msr = kvm_complete_insn_gp,
>   
> -	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> +	.vcpu_deliver_sipi_vector = vt_vcpu_deliver_sipi_vector,
> +	.vcpu_deliver_init = vt_vcpu_deliver_init,
>   
>   	.get_untagged_addr = vmx_get_untagged_addr,
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index d9b36373e7d0..4c7c83105342 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -769,8 +769,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   {
>   
> -	/* Ignore INIT silently because TDX doesn't support INIT event. */
> -	if (init_event)
> +	/* vcpu_deliver_init method silently discards INIT event. */
> +	if (KVM_BUG_ON(init_event, vcpu->kvm))
>   		return;
>   	if (KVM_BUG_ON(is_td_vcpu_created(to_tdx(vcpu)), vcpu->kvm))
>   		return;


