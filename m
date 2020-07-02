Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABD1212779
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 17:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgGBPNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 11:13:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:52230 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729444AbgGBPNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 11:13:40 -0400
IronPort-SDR: iajELP3UsSF2IeDLnfZUX725wBoh4XSBQQ6StChvk5OTO67ZjMXUfZlhljr30Eqo1DtHgaK/5g
 nRlQPxm5fgIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="164978440"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="164978440"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 08:13:39 -0700
IronPort-SDR: 4Rx2c4iLRCuuqFUZdlbQd3DsK9c9h17DHJI0TfiqA205bfstBHUb/Pnav7X2d2yF4FFfAVkGqN
 jre45HTvBdog==
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="455552276"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.34]) ([10.255.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 08:13:37 -0700
Subject: Re: [PATCH v13 03/11] KVM: VMX: Set guest CET MSRs per KVM and host
 configuration
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com
References: <20200701080411.5802-1-weijiang.yang@intel.com>
 <20200701080411.5802-4-weijiang.yang@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <75f0ef0b-ce95-fd92-00df-4231ffa1fa8e@intel.com>
Date:   Thu, 2 Jul 2020 23:13:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701080411.5802-4-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/1/2020 4:04 PM, Yang Weijiang wrote:
> CET MSRs pass through guest directly to enhance performance. CET runtime
> control settings are stored in MSR_IA32_{U,S}_CET, Shadow Stack Pointer(SSP)
> are stored in MSR_IA32_PL{0,1,2,3}_SSP, SSP table base address is stored in
> MSR_IA32_INT_SSP_TAB, these MSRs are defined in kernel and re-used here.
> 
> MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user-mode protection,the MSR
> contents are switched between threads during scheduling, it makes sense to pass
> through them so that the guest kernel can use xsaves/xrstors to operate them
> efficiently. Other MSRs are used for non-user mode protection. See SDM for detailed
> info.
> 
> The difference between CET VMCS fields and CET MSRs is that,the former are used
> during VMEnter/VMExit, whereas the latter are used for CET state storage between
> task/thread scheduling.
> 
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 46 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/x86.c     |  3 +++
>   2 files changed, 49 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d52d470e36b1..97e766875a7e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3020,6 +3020,13 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long cr3)
>   		vmcs_writel(GUEST_CR3, guest_cr3);
>   }
>   
> +static bool is_cet_state_supported(struct kvm_vcpu *vcpu, u32 xss_states)
> +{
> +	return ((supported_xss & xss_states) &&
> +		(guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));
> +}
> +
>   int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7098,6 +7105,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>   		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>   }
>   
> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> +	bool incpt;
> +
> +	incpt = !is_cet_state_supported(vcpu, XFEATURE_MASK_CET_USER);
> +	/*
> +	 * U_CET is required for USER CET, and U_CET, PL3_SPP are bound as
> +	 * one component and controlled by IA32_XSS[bit 11].
> +	 */
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW,
> +				  incpt);
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW,
> +				  incpt);
> +
> +	incpt = !is_cet_state_supported(vcpu, XFEATURE_MASK_CET_KERNEL);
> +	/*
> +	 * S_CET is required for KERNEL CET, and PL0_SSP ... PL2_SSP are
> +	 * bound as one component and controlled by IA32_XSS[bit 12].
> +	 */
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW,
> +				  incpt);
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW,
> +				  incpt);
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW,
> +				  incpt);
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW,
> +				  incpt);
> +
> +	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> +	/* SSP_TAB is only available for KERNEL SHSTK.*/
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW,
> +				  incpt);
> +}
> +
>   static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7136,6 +7179,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>   			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
>   		}
>   	}
> +
> +	if (supported_xss & (XFEATURE_MASK_CET_KERNEL | XFEATURE_MASK_CET_USER))
> +		vmx_update_intercept_for_cet_msr(vcpu);
>   }
>   
>   static __init void vmx_set_cpu_caps(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c5835f9cb9ad..6390b62c12ed 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -186,6 +186,9 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>   				| XFEATURE_MASK_PKRU)
>   
> +#define KVM_SUPPORTED_XSS       (XFEATURE_MASK_CET_USER | \
> +				 XFEATURE_MASK_CET_KERNEL)
> +

This definition need to be moved to Patch 5?

>   u64 __read_mostly host_efer;
>   EXPORT_SYMBOL_GPL(host_efer);
>   
> 

