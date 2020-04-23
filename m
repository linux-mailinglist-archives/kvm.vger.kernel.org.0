Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AF71B60E7
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 18:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgDWQ1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 12:27:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:50587 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729501AbgDWQ1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 12:27:53 -0400
IronPort-SDR: 716TsGxCYu7thOnZl2s/frk+5p8E8UTYVYRM/DVgy47McgdXJFLaNlbKBKTn9Zqqi4ehk7UBuB
 OG4pppHJl9zQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 09:27:52 -0700
IronPort-SDR: 5kXOuM2uVerxbxgUzYJtD9TzWkezD5LZ3KlWvBsQoiewd/rrq1+Tb2EuMISm5sdm6Elb6aKepW
 ytEHz01XNBtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="256039533"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 09:27:50 -0700
Date:   Thu, 23 Apr 2020 09:27:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 2/9] KVM: VMX: Set guest CET MSRs per KVM and host
 configuration
Message-ID: <20200423162749.GG17824@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-3-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326081847.5870-3-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 04:18:39PM +0800, Yang Weijiang wrote:
> CET MSRs pass through guest directly to enhance performance.
> CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
> Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
> SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
> these MSRs are defined in kernel and re-used here.
> 
> MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user-mode protection,
> the MSR contents are switched between threads during scheduling,
> it makes sense to pass through them so that the guest kernel can
> use xsaves/xrstors to operate them efficiently. Other MSRs are used
> for non-user mode protection. See SDM for detailed info.
> 
> The difference between CET VMCS fields and CET MSRs is that,the former
> are used during VMEnter/VMExit, whereas the latter are used for CET
> state storage between task/thread scheduling.
> 
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 860e5f4a9f7b..1aca468d9a10 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3033,6 +3033,13 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  		vmcs_writel(GUEST_CR3, guest_cr3);
>  }
>  
> +static bool is_cet_mode_allowed(struct kvm_vcpu *vcpu, u32 mode_mask)

CET itself isn't a mode.  And since this ends up being an inner helper for
is_cet_supported(), I think __is_cet_supported() would be the way to go.

Even @mode_mask is a bit confusing without the context of it being kernel
vs. user.  The callers are very readable, e.g. I'd much prefer passing the
mask as opposed to doing 'bool kernel'.  Maybe s/mode_mask/cet_mask?  That
doesn't exactly make things super clear, but at least the reader knows the
mask is for CET features.

> +{
> +	return ((supported_xss & mode_mask) &&
> +		(guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));
> +}
> +
>  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7064,6 +7071,35 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>  }
>  
> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> +	bool flag;

Maybe s/flag/incpt or something to make it more obvious that the bool is
true if we want to intercept?  vmx_set_intercept_for_msr()s's @value isn't
any better :-/.

> +
> +	flag = !is_cet_mode_allowed(vcpu, XFEATURE_MASK_CET_USER);
> +	/*
> +	 * U_CET is required for USER CET, and U_CET, PL3_SPP are bound as
> +	 * one component and controlled by IA32_XSS[bit 11].
> +	 */
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW, flag);
> +
> +	flag = !is_cet_mode_allowed(vcpu, XFEATURE_MASK_CET_KERNEL);
> +	/*
> +	 * S_CET is required for KERNEL CET, and PL0_SSP ... PL2_SSP are
> +	 * bound as one component and controlled by IA32_XSS[bit 12].
> +	 */
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW, flag);
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW, flag);
> +
> +	flag |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> +	/* SSP_TAB is only available for KERNEL SHSTK.*/
> +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, flag);
> +}
> +
>  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7102,6 +7138,10 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
>  		}
>  	}
> +
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> +		vmx_update_intercept_for_cet_msr(vcpu);

This is wrong, it will miss the case where userspace double configures CPUID
and goes from CET=1 to CET=0.  This should instead be:

	if (supported_xss & (XFEATURE_MASK_CET_KERNEL | XFEATURE_MASK_CET_USER))
		vmx_update_intercept_for_cet_msr(vcpu);

>  }
>  
>  static __init void vmx_set_cpu_caps(void)
> -- 
> 2.17.2
> 
