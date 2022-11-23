Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F80863631B
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238596AbiKWPR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238594AbiKWPRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:17:50 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD2F642A;
        Wed, 23 Nov 2022 07:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669216668; x=1700752668;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZCM2vViPNVFNv0ayj0f1ccsV7hs8c3mpjRKIDt2Jnm4=;
  b=eHt0oWNzuGU1vcRd6G9XfMomzBPEpBcNRcEAwhi2b7N6c7sf8gwQob/H
   9yj6CaUMZpv7Y6rE6AbgUMV0Nb7dQNk8kS7NCeQLccFuXqI/KgOpma7Vt
   RSW/fchqLqJ0r1VxX/B7uQfjWOp/7Jc8U+cJE8dOkChKugEw8bQexHJEz
   vnlFSQKKI+T+qB++oLf8xHHF+Z98YSvlSShFcjWdDRCTCSNy4IqM+FwjV
   zUMgW9qsQXBb1UMbxQ55wMu2PAijN/jekEmabohcqmUNy9Y72HuLua+Ad
   zmbO5QFFY6VmKJSWBvykarOAjbmDDiT2fSNSN+LnW5mEKlf2gf2cotgA1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="314122910"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="314122910"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:17:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="886986793"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="886986793"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.168.208]) ([10.249.168.208])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:17:46 -0800
Message-ID: <ea9cbd65-be61-036c-715f-ac4604d0cb73@linux.intel.com>
Date:   Wed, 23 Nov 2022 23:17:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 104/108] KVM: TDX: Silently ignore INIT/SIPI
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <a888bb4d30de2e57b0eb5e61189349c86cab1a70.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <a888bb4d30de2e57b0eb5e61189349c86cab1a70.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
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
>   arch/x86/kvm/lapic.c               | 19 ++++++++++++-------
>   arch/x86/kvm/svm/svm.c             |  1 +
>   arch/x86/kvm/vmx/main.c            | 22 +++++++++++++++++++++-
>   5 files changed, 37 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 17c3828d42a3..4e9b96480716 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -140,6 +140,7 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
>   KVM_X86_OP(msr_filter_changed)
>   KVM_X86_OP(complete_emulated_msr)
>   KVM_X86_OP(vcpu_deliver_sipi_vector)
> +KVM_X86_OP(vcpu_deliver_init)
>   KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>   KVM_X86_OP(check_processor_compatibility)
>   
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 094fff5414e1..df67ca7b23d3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1706,6 +1706,7 @@ struct kvm_x86_ops {
>   	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>   
>   	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> +	void (*vcpu_deliver_init)(struct kvm_vcpu *vcpu);
>   
>   	/*
>   	 * Returns vCPU specific APICv inhibit reasons
> @@ -1914,6 +1915,7 @@ int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
>   void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
>   int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector, int seg);
>   void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
> +void kvm_vcpu_deliver_init(struct kvm_vcpu *vcpu);
>   
>   int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>   		    int reason, bool has_error_code, u32 error_code);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 7a1d612bd138..7393d858ed72 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -3035,6 +3035,16 @@ int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
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
> @@ -3066,13 +3076,8 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
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
> index 2bcf2e1a5271..5d56b0f1f595 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4857,6 +4857,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.complete_emulated_msr = svm_complete_emulated_msr,
>   
>   	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> +	.vcpu_deliver_init = kvm_vcpu_deliver_init,
>   	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
>   };
>   
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 4acba8d8cb27..d776d5d169d0 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -286,6 +286,25 @@ static void vt_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
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

Is it better to add WARN_ON_ONCE in the above two functions for TD case?


>   static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -627,7 +646,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.msr_filter_changed = vmx_msr_filter_changed,
>   	.complete_emulated_msr = kvm_complete_insn_gp,
>   
> -	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> +	.vcpu_deliver_sipi_vector = vt_vcpu_deliver_sipi_vector,
> +	.vcpu_deliver_init = vt_vcpu_deliver_init,
>   
>   	.dev_mem_enc_ioctl = tdx_dev_ioctl,
>   	.mem_enc_ioctl = vt_mem_enc_ioctl,
