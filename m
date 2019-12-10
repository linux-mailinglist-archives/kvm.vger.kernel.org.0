Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86896119A7D
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 22:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfLJV7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 16:59:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:4479 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbfLJV7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 16:59:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 13:59:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="238317765"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 10 Dec 2019 13:58:59 -0800
Date:   Tue, 10 Dec 2019 13:58:59 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com, yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 7/7] KVM: X86: Add user-space access interface for CET
 MSRs
Message-ID: <20191210215859.GO15758@linux.intel.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-8-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101085222.27997-8-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 01, 2019 at 04:52:22PM +0800, Yang Weijiang wrote:
> There're two different places storing Guest CET states, states
> managed with XSAVES/XRSTORS, as restored/saved
> in previous patch, can be read/write directly from/to the MSRs.
> For those stored in VMCS fields, they're access via vmcs_read/
> vmcs_write.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 140 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c     |   3 +
>  2 files changed, 143 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bfb1b922a9ac..71aba264b5d2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1671,6 +1671,98 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>  	return 0;
>  }
>  
> +#define CET_MSR_RSVD_BITS_1    0x3
> +#define CET_MSR_RSVD_BITS_2   (0xF << 6)
> +
> +static bool cet_msr_write_allowed(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	u32 index = msr->index;
> +	u64 data = msr->data;
> +	u32 high_word = data >> 32;
> +
> +	if ((index == MSR_IA32_U_CET || index == MSR_IA32_S_CET) &&
> +	    (data & CET_MSR_RSVD_BITS_2))
> +		return false;
> +
> +	if (is_64_bit_mode(vcpu)) {
> +		if (is_noncanonical_address(data & PAGE_MASK, vcpu))

I don't think this is correct.  MSRs that contain an address usually only
fault on a non-canonical value and do the non-canonical check regardless
of mode.  E.g. VM-Enter's consistency checks on SYSENTER_E{I,S}P only care
about a canonical address and are not dependent on mode, and SYSENTER
itself states that bits 63:32 are ignored in 32-bit mode.  I assume the
same is true here.

If that is indeed the case, what about adding these to the common canonical
check in __kvm_set_msr()?  That'd cut down on the boilerplate here and
might make it easier to audit KVM's canonical checks.

> +			return false;
> +		else if ((index == MSR_IA32_PL0_SSP ||
> +			  index == MSR_IA32_PL1_SSP ||
> +			  index == MSR_IA32_PL2_SSP ||
> +			  index == MSR_IA32_PL3_SSP) &&
> +			  (data & CET_MSR_RSVD_BITS_1))
> +			return false;
> +	} else {
> +		if (msr->index == MSR_IA32_INT_SSP_TAB)
> +			return false;
> +		else if ((index == MSR_IA32_U_CET ||
> +			  index == MSR_IA32_S_CET ||
> +			  index == MSR_IA32_PL0_SSP ||
> +			  index == MSR_IA32_PL1_SSP ||
> +			  index == MSR_IA32_PL2_SSP ||
> +			  index == MSR_IA32_PL3_SSP) &&
> +			  (high_word & ~0ul))
> +			return false;
> +	}
> +
> +	return true;
> +}

This helper seems like overkill, e.g. it's filled with index-specific
checks, but is called from code that has already switched on the index.
Open coding the individual checks is likely more readable and would require
less code, especially if the canonical checks are cleaned up.

> +
> +static bool cet_msr_access_allowed(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	u64 kvm_xss;
> +	u32 index = msr->index;
> +
> +	if (is_guest_mode(vcpu))
> +		return false;

I may have missed this in an earlier discussion, does CET not support
nesting?

> +
> +	kvm_xss = kvm_supported_xss();
> +
> +	switch (index) {
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!boot_cpu_has(X86_FEATURE_SHSTK))
> +			return false;
> +		if (!msr->host_initiated) {
> +			if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> +				return false;
> +		} else {

This looks wrong, WRMSR from the guest only checks CPUID, it doesn't check
kvm_xss.

> +			if (index == MSR_IA32_PL3_SSP) {
> +				if (!(kvm_xss & XFEATURE_MASK_CET_USER))
> +					return false;
> +			} else {
> +				if (!(kvm_xss & XFEATURE_MASK_CET_KERNEL))
> +					return false;
> +			}
> +		}
> +		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:

Rather than bundle everything in a single access_allowed() helper, it might
be easier to have separate helpers for each class of MSR.   Except for the
guest_mode() check, there's no overlap between the classes.

> +		if (!boot_cpu_has(X86_FEATURE_SHSTK) &&
> +		    !boot_cpu_has(X86_FEATURE_IBT))
> +			return false;
> +
> +		if (!msr->host_initiated) {
> +			if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> +			    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> +				return false;
> +		} else if (index == MSR_IA32_U_CET &&
> +			   !(kvm_xss & XFEATURE_MASK_CET_USER))

Same comment about guest not checking kvm_xss.

> +			return false;
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!boot_cpu_has(X86_FEATURE_SHSTK))
> +			return false;
> +
> +		if (!msr->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> +			return false;
> +		break;
> +	default:
> +		return false;
> +	}
> +	return true;
> +}
>  /*
>   * Reads an msr value (of 'msr_index') into 'pdata'.
>   * Returns 0 on success, non-0 otherwise.
> @@ -1788,6 +1880,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>  		break;
> +	case MSR_IA32_S_CET:
> +		if (!cet_msr_access_allowed(vcpu, msr_info))
> +			return 1;
> +		msr_info->data = vmcs_readl(GUEST_S_CET);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!cet_msr_access_allowed(vcpu, msr_info))
> +			return 1;
> +		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +		break;
> +	case MSR_IA32_U_CET:
> +		if (!cet_msr_access_allowed(vcpu, msr_info))
> +			return 1;
> +		rdmsrl(MSR_IA32_U_CET, msr_info->data);
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!cet_msr_access_allowed(vcpu, msr_info))
> +			return 1;
> +		rdmsrl(msr_info->index, msr_info->data);
> +		break;
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> @@ -2039,6 +2151,34 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			vmx->pt_desc.guest.addr_a[index / 2] = data;
>  		break;
> +	case MSR_IA32_S_CET:
> +		if (!cet_msr_access_allowed(vcpu, msr_info))
> +			return 1;
> +		if (!cet_msr_write_allowed(vcpu, msr_info))
> +			return 1;
> +		vmcs_writel(GUEST_S_CET, data);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!cet_msr_access_allowed(vcpu, msr_info))
> +			return 1;
> +		if (!cet_msr_write_allowed(vcpu, msr_info))
> +			return 1;
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
> +		break;
> +	case MSR_IA32_U_CET:
> +		if (!cet_msr_access_allowed(vcpu, msr_info))
> +			return 1;
> +		if (!cet_msr_write_allowed(vcpu, msr_info))
> +			return 1;
> +		wrmsrl(MSR_IA32_U_CET, data);
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!cet_msr_access_allowed(vcpu, msr_info))
> +			return 1;
> +		if (!cet_msr_write_allowed(vcpu, msr_info))
> +			return 1;
> +		wrmsrl(msr_info->index, data);
> +		break;
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6275a75d5802..1bbe4550da90 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1143,6 +1143,9 @@ static u32 msrs_to_save[] = {
>  	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
>  	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
>  	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
> +	MSR_IA32_XSS, MSR_IA32_U_CET, MSR_IA32_S_CET,
> +	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
> +	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
>  };
>  
>  static unsigned num_msrs_to_save;
> -- 
> 2.17.2
> 
