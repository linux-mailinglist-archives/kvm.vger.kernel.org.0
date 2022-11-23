Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3E26361A3
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 15:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238565AbiKWO0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 09:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237901AbiKWO0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 09:26:12 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3890E70A26;
        Wed, 23 Nov 2022 06:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669213516; x=1700749516;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UHhnTNNtMwCP7uNqJzagpOTqajabY/a5lHkiJFYBEG4=;
  b=Gr8C9Q0Dct/lOXB0MT+e/9yFV/zg64pvbUU+5EGeuEnZ/kCqDRjQHJbE
   KuId54gYVnb699GiwTsXASlHFxu0qSaumNZXchCvi1NqUISJba8UF6IPT
   7FXqo1VgNOzJSj9HP6OhQVFgvzQpsQEbeKU3aU2yOBe2+RpPNnVySJP0w
   7sTR9By83vygYHBIT2vSLmRD9BV2D68yH0Kwfq1536IPB/5U/7AmdPsv/
   +VhBud9zFuv2K0T6/b3qeY3UARW0nbLeKH/studAuOV0K53WW1XeG1J2H
   amoyLEj3gLiSWzbUeKw+8n2eiKC9Uqe32Yb8C0nWwiAY1fIUwUQYeC3K+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="294464335"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="294464335"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 06:25:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="970877222"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="970877222"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.168.208]) ([10.249.168.208])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 06:25:13 -0800
Message-ID: <a9832926-8353-fd47-45aa-a6a5b85183e3@linux.intel.com>
Date:   Wed, 23 Nov 2022 22:25:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 098/108] KVM: TDX: Implement callbacks for MSR
 operations for TDX
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <1cacbda18e3c7dcccd92a7390b0ca7f4ba073f85.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <1cacbda18e3c7dcccd92a7390b0ca7f4ba073f85.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Implements set_msr/get_msr/has_emulated_msr methods for TDX to handle
> hypercall from guest TD for paravirtualized rdmsr and wrmsr.  The TDX
> module virtualizes MSRs.  For some MSRs, it injects #VE to the guest TD
> upon RDMSR or WRMSR.  The exact list of such MSRs are defined in the spec.

How does KVM handle the case that the userland wants to get the TD MSR list?

KVM_GET_MSR_INDEX_LIST will return the global KVM MSR list, which is 
different from the TD version.


>
> Upon #VE, the guest TD may execute hypercalls,
> TDG.VP.VMCALL<INSTRUCTION.RDMSR> and TDG.VP.VMCALL<INSTRUCTION.WRMSR>,
> which are defined in GHCI (Guest-Host Communication Interface) so that the
> host VMM (e.g. KVM) can virtualizes
can virtualize



> the MSRs.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 34 ++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.c     | 63 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |  6 ++++
>   arch/x86/kvm/x86.c         |  1 -
>   arch/x86/kvm/x86.h         |  2 ++
>   5 files changed, 102 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 74c561e3eb46..3a8a4fdf1ce7 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -195,6 +195,34 @@ static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>   	vmx_handle_exit_irqoff(vcpu);
>   }
>   
> +static int vt_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> +{
> +	if (unlikely(is_td_vcpu(vcpu)))
> +		return tdx_set_msr(vcpu, msr_info);
> +
> +	return vmx_set_msr(vcpu, msr_info);
> +}
> +
> +/*
> + * The kvm parameter can be NULL (module initialization, or invocation before
> + * VM creation). Be sure to check the kvm parameter before using it.
> + */
> +static bool vt_has_emulated_msr(struct kvm *kvm, u32 index)
> +{
> +	if (kvm && is_td(kvm))
> +		return tdx_is_emulated_msr(index, true);
> +
> +	return vmx_has_emulated_msr(kvm, index);
> +}
> +
> +static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> +{
> +	if (unlikely(is_td_vcpu(vcpu)))
> +		return tdx_get_msr(vcpu, msr_info);
> +
> +	return vmx_get_msr(vcpu, msr_info);
> +}
> +
>   static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>   {
>   	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
> @@ -431,7 +459,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.hardware_enable = vt_hardware_enable,
>   	.hardware_disable = vt_hardware_disable,
> -	.has_emulated_msr = vmx_has_emulated_msr,
> +	.has_emulated_msr = vt_has_emulated_msr,
>   
>   	.is_vm_type_supported = vt_is_vm_type_supported,
>   	.vm_size = sizeof(struct kvm_vmx),
> @@ -451,8 +479,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.update_exception_bitmap = vmx_update_exception_bitmap,
>   	.get_msr_feature = vmx_get_msr_feature,
> -	.get_msr = vmx_get_msr,
> -	.set_msr = vmx_set_msr,
> +	.get_msr = vt_get_msr,
> +	.set_msr = vt_set_msr,
>   	.get_segment_base = vmx_get_segment_base,
>   	.get_segment = vmx_get_segment,
>   	.set_segment = vmx_set_segment,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 50e9352464a9..b820475ce0ab 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1489,6 +1489,69 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>   	*error_code = 0;
>   }
>   
> +bool tdx_is_emulated_msr(u32 index, bool write)
> +{
> +	switch (index) {
> +	case MSR_IA32_UCODE_REV:
> +	case MSR_IA32_ARCH_CAPABILITIES:
> +	case MSR_IA32_POWER_CTL:
> +	case MSR_MTRRcap:
> +	case 0x200 ... 0x26f:
> +		/* IA32_MTRR_PHYS{BASE, MASK}, IA32_MTRR_FIX*_* */
> +	case MSR_IA32_CR_PAT:
> +	case MSR_MTRRdefType:
> +	case MSR_IA32_TSC_DEADLINE:
> +	case MSR_IA32_MISC_ENABLE:
> +	case MSR_KVM_STEAL_TIME:
> +	case MSR_KVM_POLL_CONTROL:
> +	case MSR_PLATFORM_INFO:
> +	case MSR_MISC_FEATURES_ENABLES:
> +	case MSR_IA32_MCG_CAP:
> +	case MSR_IA32_MCG_STATUS:
> +	case MSR_IA32_MCG_CTL:
> +	case MSR_IA32_MCG_EXT_CTL:
> +	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> +	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
> +		/* MSR_IA32_MCx_{CTL, STATUS, ADDR, MISC, CTL2} */
> +		return true;
> +	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
> +		/*
> +		 * x2APIC registers that are virtualized by the CPU can't be
> +		 * emulated, KVM doesn't have access to the virtual APIC page.
> +		 */
> +		switch (index) {
> +		case X2APIC_MSR(APIC_TASKPRI):
> +		case X2APIC_MSR(APIC_PROCPRI):
> +		case X2APIC_MSR(APIC_EOI):
> +		case X2APIC_MSR(APIC_ISR) ... X2APIC_MSR(APIC_ISR + APIC_ISR_NR):
> +		case X2APIC_MSR(APIC_TMR) ... X2APIC_MSR(APIC_TMR + APIC_ISR_NR):
> +		case X2APIC_MSR(APIC_IRR) ... X2APIC_MSR(APIC_IRR + APIC_ISR_NR):
> +			return false;
> +		default:
> +			return true;
> +		}
> +	case MSR_IA32_APICBASE:
> +	case MSR_EFER:
> +		return !write;
> +	default:
> +		return false;
> +	}
> +}
> +
> +int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	if (tdx_is_emulated_msr(msr->index, false))
> +		return kvm_get_msr_common(vcpu, msr);
> +	return 1;
> +}
> +
> +int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	if (tdx_is_emulated_msr(msr->index, true))
> +		return kvm_set_msr_common(vcpu, msr);
> +	return 1;
> +}
> +
>   int tdx_dev_ioctl(void __user *argp)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index d02619f64b6e..8b9399b154f3 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -162,6 +162,9 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>   void tdx_inject_nmi(struct kvm_vcpu *vcpu);
>   void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>   		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
> +bool tdx_is_emulated_msr(u32 index, bool write);
> +int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
> +int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
>   
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -200,6 +203,9 @@ static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mo
>   static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
>   				     u64 *info2, u32 *intr_info, u32 *error_code) {}
> +static inline bool tdx_is_emulated_msr(u32 index, bool write) { return false; }
> +static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
> +static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
>   
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2eacc4929d5d..5304b27f2566 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -85,7 +85,6 @@
>   #include "trace.h"
>   
>   #define MAX_IO_MSRS 256
> -#define KVM_MAX_MCE_BANKS 32
>   
>   struct kvm_caps kvm_caps __read_mostly = {
>   	.supported_mce_cap = MCG_CTL_P | MCG_SER_P,
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 829d3134c1eb..1d77c39821ae 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -8,6 +8,8 @@
>   #include "kvm_cache_regs.h"
>   #include "kvm_emulate.h"
>   
> +#define KVM_MAX_MCE_BANKS 32
> +
>   struct kvm_caps {
>   	/* control of guest tsc rate supported? */
>   	bool has_tsc_control;
