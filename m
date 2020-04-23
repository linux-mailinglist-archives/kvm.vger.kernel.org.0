Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27841B6318
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 20:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgDWSOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 14:14:08 -0400
Received: from mga05.intel.com ([192.55.52.43]:39222 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730042AbgDWSOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 14:14:08 -0400
IronPort-SDR: l/7nngsIIVOzXWyCodYSfKqDTL7iKCxDIr+ZMQozLdpLwrX6bxXloDM2kDe/ePf92Sd8AGE9VC
 uYb6UL4AnrBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 11:14:07 -0700
IronPort-SDR: n6O+tei/TZKssUMSN1ddj46BDAlluaZsK7sDuMgWxXnWgll3uW2NOCcxZNgJKsyPhgKsOczBbu
 Wrdg2O7ag1nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="274315244"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 23 Apr 2020 11:14:07 -0700
Date:   Thu, 23 Apr 2020 11:14:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 7/9] KVM: X86: Add userspace access interface for CET
 MSRs
Message-ID: <20200423181406.GK17824@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-8-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200326081847.5870-8-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 04:18:44PM +0800, Yang Weijiang wrote:
> +#define CET_MSR_RSVD_BITS_1  GENMASK(1, 0)
> +#define CET_MSR_RSVD_BITS_2  GENMASK(9, 6)
> +
> +static bool cet_check_msr_write(struct kvm_vcpu *vcpu,

s/cet_check_msr_write/is_cet_msr_valid

Otherwise the polarity of the return value isn't obvious.

> +				struct msr_data *msr,

Unnecessary newline.

> +				u64 mask)

s/mask/rsvd_bits

> +{
> +	u64 data = msr->data;
> +	u32 high_word = data >> 32;
> +
> +	if (data & mask)
> +		return false;
> +
> +	if (!is_64_bit_mode(vcpu) && high_word)
> +		return false;

As I called out before, this is wrong.  AFAIK, the CPU never depends on
WRMSR to prevent loading bits 63:32, software can simply do WRMSR and then
transition back to 32-bit mode.  Yes, the shadow stack itself is 32 bits,
but the internal value is still 64 bits.  This is backed up by the CALL
pseudocode:

  IF ShadowStackEnabled(CPL)
    IF (EFER.LMA and DEST(CodeSegmentSelector).L) = 0
      (* If target is legacy or compatibility mode then the SSP must be in low 4GB *)
      IF (SSP & 0xFFFFFFFF00000000 != 0)
        THEN #GP(0); FI;
  FI;

as well as RDSSP:

  IF CPL = 3
    IF CR4.CET & IA32_U_CET.SH_STK_EN
      IF (operand size is 64 bit)
        THEN
          Dest ← SSP;
        ELSE
          Dest ← SSP[31:0];
      FI;
    FI;
  ELSE

> +
> +	return true;
> +}
> +
> +static bool cet_check_ssp_msr_access(struct kvm_vcpu *vcpu,
> +				     struct msr_data *msr)

Similar to above, the polarity of the return isn't obvious.  Maybe
is_cet_ssp_msr_accessible()?

I'd prefer to pass in @index, passing the full @msr makes it look like
this helper might also check msr->data.

> +{
> +	u32 index = msr->index;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SHSTK))
> +		return false;
> +
> +	if (!msr->host_initiated &&
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> +		return false;
> +
> +	if (index == MSR_IA32_INT_SSP_TAB)
> +		return true;
> +
> +	if (index == MSR_IA32_PL3_SSP) {
> +		if (!(supported_xss & XFEATURE_MASK_CET_USER))
> +			return false;
> +	} else if (!(supported_xss & XFEATURE_MASK_CET_KERNEL)) {
> +		return false;
> +	}

	if (index == MSR_IA32_PL3_SSP)
		return supported_xss & XFEATURE_MASK_CET_USER;

	/* MSR_IA32_PL[0-2]_SSP */
	return supported_xss & XFEATURE_MASK_CET_KERNEL;
> +
> +	return true;
> +}
> +
> +static bool cet_check_ctl_msr_access(struct kvm_vcpu *vcpu,

is_cet_ctl_msr_accessible?

> +				     struct msr_data *msr)
> +{
> +	u32 index = msr->index;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SHSTK) &&
> +	    !boot_cpu_has(X86_FEATURE_IBT))
> +		return false;
> +
> +	if (!msr->host_initiated &&
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> +		return false;
> +
> +	if (index == MSR_IA32_U_CET) {
> +		if (!(supported_xss & XFEATURE_MASK_CET_USER))
> +			return false;
> +	} else if (!(supported_xss & XFEATURE_MASK_CET_KERNEL)) {
> +		return false;
> +	}

Same as above:

	if (index == MSR_IA32_U_CET)
		return supported_xss & XFEATURE_MASK_CET_USER;

	return supported_xss & XFEATURE_MASK_CET_KERNEL;
> +
> +	return true;
> +}
>  /*
>   * Reads an msr value (of 'msr_index') into 'pdata'.
>   * Returns 0 on success, non-0 otherwise.
> @@ -1941,6 +2026,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>  		break;
> +	case MSR_IA32_S_CET:
> +		if (!cet_check_ctl_msr_access(vcpu, msr_info))
> +			return 1;
> +		msr_info->data = vmcs_readl(GUEST_S_CET);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!cet_check_ssp_msr_access(vcpu, msr_info))
> +			return 1;
> +		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +		break;
> +	case MSR_IA32_U_CET:
> +		if (!cet_check_ctl_msr_access(vcpu, msr_info))
> +			return 1;
> +		vmx_get_xsave_msr(msr_info);
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!cet_check_ssp_msr_access(vcpu, msr_info))
> +			return 1;
> +		vmx_get_xsave_msr(msr_info);
> +		break;
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> @@ -2197,6 +2302,34 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			vmx->pt_desc.guest.addr_a[index / 2] = data;
>  		break;
> +	case MSR_IA32_S_CET:
> +		if (!cet_check_ctl_msr_access(vcpu, msr_info))
> +			return 1;
> +		if (!cet_check_msr_write(vcpu, msr_info, CET_MSR_RSVD_BITS_2))
> +			return 1;
> +		vmcs_writel(GUEST_S_CET, data);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!cet_check_ctl_msr_access(vcpu, msr_info))
> +			return 1;
> +		if (!is_64_bit_mode(vcpu))

This is wrong, the SDM explicitly calls out the !64 case:

  IA32_INTERRUPT_SSP_TABLE_ADDR (64 bits; 32 bits on processors that do not
  support Intel 64 architecture).

> +			return 1;
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
> +		break;
> +	case MSR_IA32_U_CET:
> +		if (!cet_check_ctl_msr_access(vcpu, msr_info))
> +			return 1;
> +		if (!cet_check_msr_write(vcpu, msr_info, CET_MSR_RSVD_BITS_2))
> +			return 1;
> +		vmx_set_xsave_msr(msr_info);
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!cet_check_ssp_msr_access(vcpu, msr_info))
> +			return 1;
> +		if (!cet_check_msr_write(vcpu, msr_info, CET_MSR_RSVD_BITS_1))
> +			return 1;
> +		vmx_set_xsave_msr(msr_info);
> +		break;
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9654d779bdab..9e89ee6a09e1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1229,6 +1229,10 @@ static const u32 msrs_to_save_all[] = {
>  	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
>  	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
>  	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> +
> +	MSR_IA32_XSS, MSR_IA32_U_CET, MSR_IA32_S_CET,
> +	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
> +	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
>  };
>  
>  static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
> @@ -1504,6 +1508,13 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  		 * invokes 64-bit SYSENTER.
>  		 */
>  		data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (is_noncanonical_address(data, vcpu))

IMO the canonical check belongs in cet_check_msr_write().  The above checks
are for MSRs that are common to VMX and SVM, i.e. the common check saves
having to duplicate the logic.  If SVM picks up CET support, then they'll
presumably want to share all of the checks, not just the canonical piece.

> +			return 1;
>  	}
>  
>  	msr.data = data;
> -- 
> 2.17.2
> 
