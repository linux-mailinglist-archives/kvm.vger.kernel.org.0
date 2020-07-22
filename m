Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6815B22A09D
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 22:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgGVUOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 16:14:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:5765 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgGVUOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 16:14:45 -0400
IronPort-SDR: geoAAs1tLuEpC960nkpQIqjnle4sQDTDNGASp95u5eFCVsUcMkUnwDCbJ6JhfEiRXCnp8E42oj
 csY8pA0h51Qg==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="149596481"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="149596481"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 13:14:44 -0700
IronPort-SDR: sJk5YV1JL3JCyBwvZGyFggoOXg6ZWKzFlDEIhVOjLLep/SXIlqkEQfM8XIekrCZoUYyaZWJeEO
 lPkqHxbWRFiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="462584581"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 22 Jul 2020 13:14:44 -0700
Date:   Wed, 22 Jul 2020 13:14:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [RESEND v13 03/11] KVM: VMX: Set guest CET MSRs per KVM and host
 configuration
Message-ID: <20200722201444.GD9114@linux.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
 <20200716031627.11492-4-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716031627.11492-4-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 11:16:19AM +0800, Yang Weijiang wrote:
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

I moved this patch until after CET virtualization is enabled.  Functionally,
KVM should be able to virtualize CET without allowing the guest to access
the MSRs directly.  Moving this after CET enabling will allow bisecting this
specific patch, e.g. if there's a problem with pass-through but not basic
support, or vice versa, and will also allow better testing of the MSR access
code.  At least, that's the theory.
 
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 46 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c     |  3 +++
>  2 files changed, 49 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 13745f2a5ecd..a9f135c52cbc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3126,6 +3126,13 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
>  		vmcs_writel(GUEST_CR3, guest_cr3);
>  }
>  
> +static bool is_cet_state_supported(struct kvm_vcpu *vcpu, u32 xss_states)

s/xss_states/xss_state, i.e. make it singular instead of plural to match the
function name, and because the below check is at best ambiguous for multiple
states, e.g. it arguably should be ((supported_xss & xss_states) == xss_states).

> +{
> +	return ((supported_xss & xss_states) &&

Nit, the () around the entire statement is unnecessary.

Checking supported_xss is incorrect, this needs to check guest_supported_xss.

> +		(guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));

Nit, please align inner statements, e.g. so it looks like:

               (guest_cpuid_has(...) ||
                guest_cpuid_has(...)))

> +}
> +
>  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7230,6 +7237,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>  }
>  
> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;

Naming the local 'bitmap' will avoid wrapping lines.  Everything except
INT_SSP_TAB fits under 80 chars, and for that one it's ok to poke out a bit.

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

This is wrong, PL3_SSP should be intercepted if IBT is supported by SHSTK is
not.  Weird XSAVES virtualization hole aside, we need to be consistent with
the emulation of the MSRs.

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
>  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7268,6 +7311,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
>  		}
>  	}
> +
> +	if (supported_xss & (XFEATURE_MASK_CET_KERNEL | XFEATURE_MASK_CET_USER))

Given that the proposed kernel support bundles USER and KERNEL together, we
can simplify the KVM implementation by adding kvm_cet_supported(), with a
similar implementation to MPX:

static inline bool kvm_cet_supported(void)
{
	const u64 mask = XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL;

	return (supported_xss & mask) == mask;
}

> +		vmx_update_intercept_for_cet_msr(vcpu);
>  }
>  
>  static __init void vmx_set_cpu_caps(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f83b28..ea8a9dc9fbad 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -184,6 +184,9 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
>  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>  				| XFEATURE_MASK_PKRU)
>  
> +#define KVM_SUPPORTED_XSS       (XFEATURE_MASK_CET_USER | \
> +				 XFEATURE_MASK_CET_KERNEL)

Xiaoyao called out that this belongs in a later patch, which it does, but we
can actually do away with it entirely.  Because CET is dependent on multiple
features and feature flags, we can't do a straight mask in any case, i.e.
having KVM_SUPPORTED_XSS doesn't add value as VMX needs to manually set the
CET flags anyways.

>  u64 __read_mostly host_efer;
>  EXPORT_SYMBOL_GPL(host_efer);
>  
> -- 
> 2.17.2
> 
