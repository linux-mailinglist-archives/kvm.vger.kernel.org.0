Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB58C5D902
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 02:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfGCAcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 20:32:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:56996 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfGCAcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 20:32:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jul 2019 17:32:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,445,1557212400"; 
   d="scan'208";a="315414213"
Received: from unknown (HELO [10.239.196.136]) ([10.239.196.136])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2019 17:32:48 -0700
Subject: Re: [PATCH v6 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com
References: <20190621055747.17060-1-tao3.xu@intel.com>
 <20190621055747.17060-3-tao3.xu@intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <121358d9-f330-da38-aae3-bd194aee75b0@intel.com>
Date:   Wed, 3 Jul 2019 08:32:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190621055747.17060-3-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping ;)
On 6/21/2019 1:57 PM, Tao Xu wrote:
> UMWAIT and TPAUSE instructions use IA32_UMWAIT_CONTROL at MSR index E1H
> to determines the maximum time in TSC-quanta that the processor can reside
> in either C0.1 or C0.2.
> 
> This patch emulates MSR IA32_UMWAIT_CONTROL in guest and differentiate
> IA32_UMWAIT_CONTROL between host and guest. The variable
> mwait_control_cached in arch/x86/power/umwait.c caches the MSR value, so
> this patch uses it to avoid frequently rdmsr of IA32_UMWAIT_CONTROL.
> 
> Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
> Signed-off-by: Tao Xu <tao3.xu@intel.com>
> ---
> 
> Changes in v6:
> 	add check msr_info->host_initiated in get/set msr(Xiaoyao)
> 	restore the atomic_switch_umwait_control_msr()(Xiaoyao)
> 	rebase the patch because the kernel dependcy patch updated to
> 	v5: https://lkml.org/lkml/2019/6/19/972
> ---
>   arch/x86/kernel/cpu/umwait.c |  3 ++-
>   arch/x86/kvm/vmx/vmx.c       | 33 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.h       |  3 +++
>   arch/x86/kvm/x86.c           |  1 +
>   4 files changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
> index 4b2aff7b2d4d..db5c193ef136 100644
> --- a/arch/x86/kernel/cpu/umwait.c
> +++ b/arch/x86/kernel/cpu/umwait.c
> @@ -15,7 +15,8 @@
>    * MSR value. By default, umwait max time is 100000 in TSC-quanta and C0.2
>    * is enabled
>    */
> -static u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLED);
> +u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLED);
> +EXPORT_SYMBOL_GPL(umwait_control_cached);
>   
>   /*
>    * Serialize access to umwait_control_cached and IA32_UMWAIT_CONTROL MSR
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b35bfac30a34..0d81cb9b96cf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1679,6 +1679,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   #endif
>   	case MSR_EFER:
>   		return kvm_get_msr_common(vcpu, msr_info);
> +	case MSR_IA32_UMWAIT_CONTROL:
> +		if (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG))
> +			return 1;
> +
> +		msr_info->data = vmx->msr_ia32_umwait_control;
> +		break;
>   	case MSR_IA32_SPEC_CTRL:
>   		if (!msr_info->host_initiated &&
>   		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> @@ -1841,6 +1848,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 1;
>   		vmcs_write64(GUEST_BNDCFGS, data);
>   		break;
> +	case MSR_IA32_UMWAIT_CONTROL:
> +		if (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG))
> +			return 1;
> +
> +		/* The reserved bit IA32_UMWAIT_CONTROL[1] should be zero */
> +		if (data & BIT_ULL(1))
> +			return 1;
> +
> +		vmx->msr_ia32_umwait_control = data;
> +		break;
>   	case MSR_IA32_SPEC_CTRL:
>   		if (!msr_info->host_initiated &&
>   		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> @@ -4126,6 +4144,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	vmx->rmode.vm86_active = 0;
>   	vmx->spec_ctrl = 0;
>   
> +	vmx->msr_ia32_umwait_control = 0;
> +
>   	vcpu->arch.microcode_version = 0x100000000ULL;
>   	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
>   	kvm_set_cr8(vcpu, 0);
> @@ -6339,6 +6359,16 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>   					msrs[i].host, false);
>   }
>   
> +static void atomic_switch_umwait_control_msr(struct vcpu_vmx *vmx)
> +{
> +	if (vmx->msr_ia32_umwait_control != umwait_control_cached)
> +		add_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL,
> +			vmx->msr_ia32_umwait_control,
> +			umwait_control_cached, false);
> +	else
> +		clear_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL);
> +}
> +
>   static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
>   {
>   	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
> @@ -6447,6 +6477,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	atomic_switch_perf_msrs(vmx);
>   
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG))
> +		atomic_switch_umwait_control_msr(vmx);
> +
>   	vmx_update_hv_timer(vcpu);
>   
>   	/*
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 61128b48c503..8485bec7c38a 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -14,6 +14,8 @@
>   extern const u32 vmx_msr_index[];
>   extern u64 host_efer;
>   
> +extern u32 umwait_control_cached;
> +
>   #define MSR_TYPE_R	1
>   #define MSR_TYPE_W	2
>   #define MSR_TYPE_RW	3
> @@ -194,6 +196,7 @@ struct vcpu_vmx {
>   #endif
>   
>   	u64		      spec_ctrl;
> +	u64		      msr_ia32_umwait_control;
>   
>   	u32 vm_entry_controls_shadow;
>   	u32 vm_exit_controls_shadow;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83aefd759846..4480de459bf4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1138,6 +1138,7 @@ static u32 msrs_to_save[] = {
>   	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
>   	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
>   	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
> +	MSR_IA32_UMWAIT_CONTROL,
>   };
>   
>   static unsigned num_msrs_to_save;
> 

