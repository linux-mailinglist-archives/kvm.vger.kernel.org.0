Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE4D178515
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 22:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgCCVvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 16:51:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:37937 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgCCVvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 16:51:55 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 13:51:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="274395561"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2020 13:51:53 -0800
Date:   Tue, 3 Mar 2020 13:51:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v9 3/7] KVM: VMX: Pass through CET related MSRs
Message-ID: <20200303215153.GA1439@linux.intel.com>
References: <20191227021133.11993-1-weijiang.yang@intel.com>
 <20191227021133.11993-4-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227021133.11993-4-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 27, 2019 at 10:11:29AM +0800, Yang Weijiang wrote:
> CET MSRs pass through Guest directly to enhance performance.
> CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
> Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
> SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
> these MSRs are defined in kernel and re-used here.
> 
> MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user mode protection,
> the contents could differ from process to process, therefore,
> kernel needs to save/restore them during context switch, it makes
> sense to pass through them so that the guest kernel can
> use xsaves/xrstors to operate them efficiently. Other MSRs are used
> for non-user mode protection. See CET spec for detailed info.
> 
> The difference between CET VMCS state fields and xsave components is that,
> the former used for CET state storage during VMEnter/VMExit,
> whereas the latter used for state retention between Guest task/process
> switch.
> 
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/cpuid.h   |  2 ++
>  arch/x86/kvm/vmx/vmx.c | 48 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index d78a61408243..1d77b880084d 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -27,6 +27,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  
>  int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
>  
> +u64 kvm_supported_xss(void);
> +
>  static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
>  {
>  	return vcpu->arch.maxphyaddr;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 477173e4a85d..61fc846c7ef3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7091,6 +7091,52 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>  }
>  
> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> +
> +	/*
> +	 * U_CET is required for USER CET, per CET spec., meanwhile U_CET and
> +	 * PL3_SPP are a bundle for USER CET xsaves.
> +	 */
> +	if ((kvm_supported_xss() & XFEATURE_MASK_CET_USER) &&
> +	    (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))) {
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW);
> +	} else {
> +		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW, true);
> +		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW, true);
> +	}

I prefer the style of pt_update_intercept_for_msr(), e.g.

	flag = (kvm_supported_xss() & XFEATURE_MASK_CET_USER) &&
		(guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
		 guest_cpuid_has(vcpu, X86_FEATURE_IBT));

	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW, flag);
	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW, flag);


	flag = (kvm_supported_xss() & XFEATURE_MASK_CET_KERNEL) &&
		(guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
		 guest_cpuid_has(vcpu, X86_FEATURE_IBT));

	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW, flag);
	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW, flag);
	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW, flag);
	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW, flag);

	/* SSP_TAB only available for KERNEL SHSTK.*/
	flag &= guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, flag);


> +	/*
> +	 * S_CET is required for KERNEL CET, meanwhile PL0_SSP ... PL2_SSP are a bundle
> +	 * for CET KERNEL xsaves.
> +	 */
> +	if ((kvm_supported_xss() & XFEATURE_MASK_CET_KERNEL) &&
> +	    (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))) {
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW);
> +
> +		/* SSP_TAB only available for KERNEL SHSTK.*/
> +		if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> +			vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB,
> +						      MSR_TYPE_RW);
> +		else
> +			vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB,
> +						  MSR_TYPE_RW, true);
> +	} else {
> +		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW, true);
> +		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW, true);
> +		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW, true);
> +		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW, true);
> +		vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, true);
> +	}
> +}
> +
>  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7115,6 +7161,8 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
>  			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
>  		update_intel_pt_cfg(vcpu);
> +
> +	vmx_update_intercept_for_cet_msr(vcpu);
>  }
>  
>  static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> -- 
> 2.17.2
> 
