Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3F822A0FB
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 22:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbgGVUy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 16:54:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:9762 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgGVUyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 16:54:55 -0400
IronPort-SDR: /6WZl5G5DNztRbZtI9wNI2ZnZzwX42hwjzskD5IcwtvwrT/89xmoDa54Yh9uNYbq+C0kcr9jle
 gU/TV/v9C8VA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="211966740"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="211966740"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 13:54:53 -0700
IronPort-SDR: 3ENumOhItmntmMsngni8U/2vViYi3EExKfwpFKEoDhL+8OM/g12x03X01NddLb0rwb6rqEMpn+
 3BxsCx5Gp6HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="288412431"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 22 Jul 2020 13:54:53 -0700
Date:   Wed, 22 Jul 2020 13:54:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [RESEND v13 07/11] KVM: x86: Add userspace access interface for
 CET MSRs
Message-ID: <20200722205453.GH9114@linux.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
 <20200716031627.11492-8-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716031627.11492-8-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 11:16:23AM +0800, Yang Weijiang wrote:
> There're two different places storing Guest CET states, states managed
> with XSAVES/XRSTORS, as restored/saved in previous patch, can be read/write
> directly from/to the MSRs. For those stored in VMCS fields, they're access
> via vmcs_read/vmcs_write.
> 
> To correctly read/write the CET MSRs, it's necessary to check whether the
> kernel FPU context switch happened and reload guest FPU context if needed.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/uapi/asm/kvm_para.h |   7 +-
>  arch/x86/kvm/vmx/vmx.c               | 148 +++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c                   |   4 +
>  3 files changed, 156 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 812e9b4c1114..2d3422dc4c81 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -47,12 +47,13 @@
>  /* Custom MSRs falls in the range 0x4b564d00-0x4b564dff */
>  #define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
>  #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
> -#define MSR_KVM_ASYNC_PF_EN 0x4b564d02
> -#define MSR_KVM_STEAL_TIME  0x4b564d03
> -#define MSR_KVM_PV_EOI_EN      0x4b564d04
> +#define MSR_KVM_ASYNC_PF_EN	0x4b564d02
> +#define MSR_KVM_STEAL_TIME	0x4b564d03
> +#define MSR_KVM_PV_EOI_EN	0x4b564d04

Again, not a bad change, but doesn't belong in this patch/series.

>  #define MSR_KVM_POLL_CONTROL	0x4b564d05
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
> +#define MSR_KVM_GUEST_SSP	0x4b564d08

Adding the synthetic MSR should be a separate patch, both for bisection and
to provide the justification for adding the synthetic MSR (and to call out
that it's host VMM only).

>  struct kvm_steal_time {
>  	__u64 steal;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0089943fbb31..4ce61427ed49 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1819,6 +1819,94 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>  	}
>  }
>  
> +static void vmx_get_xsave_msr(struct msr_data *msr_info)
> +{
> +	local_irq_disable();
> +	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> +		switch_fpu_return();
> +	rdmsrl(msr_info->index, msr_info->data);
> +	local_irq_enable();
> +}
> +
> +static void vmx_set_xsave_msr(struct msr_data *msr_info)
> +{
> +	local_irq_disable();
> +	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> +		switch_fpu_return();
> +	wrmsrl(msr_info->index, msr_info->data);
> +	local_irq_enable();
> +}
> +
> +#define CET_MSR_RSVD_BITS_1  GENMASK(2, 0)
> +#define CET_MSR_RSVD_BITS_2  GENMASK(9, 6)

Rather than use #defines, we can use a single case statement to perform
the reserved bit checks for U_CET/S_CET and all the SSP MSRs.  I'm not
totally against using macros, but to do so we really need informative
names, e.g. RSVD_BITS_1/2 are way too arbitrary.  And coming up with names
is always hard, so it seems easier to avoid the issue entirely :-).

> +static bool cet_check_msr_valid(struct kvm_vcpu *vcpu,
> +				struct msr_data *msr, u64 rsvd_bits)

For me, "check" is still ambiguous with respect to the return.  It's also
longer than "is", e.g. changing these to cet_is_msr_{valid,accessible}()
shortens lines and avoids a few wraps.

> +{
> +	u64 data = msr->data;
> +	u32 index = msr->index;
> +
> +	if ((index == MSR_IA32_PL0_SSP || index == MSR_IA32_PL1_SSP ||
> +	    index == MSR_IA32_PL2_SSP || index == MSR_IA32_PL3_SSP ||
> +	    index == MSR_IA32_INT_SSP_TAB || index == MSR_KVM_GUEST_SSP) &&
> +	    is_noncanonical_address(data, vcpu))
> +		return false;
> +
> +	if ((index  == MSR_IA32_S_CET || index == MSR_IA32_U_CET) &&
> +	    data & MSR_IA32_CET_ENDBR_EN) {

I'm pretty sure conditioning the canonical check on ENDBR_EN is wrong.  The
SDM is ambiguous, but I peeked at internal simulator code and it performs
the check regardless of ENDBR_EN.  Can you double check on silicon?

> +		u64 bitmap_base = data >> 12;
> +
> +		if (is_noncanonical_address(bitmap_base, vcpu))

This is wrong.  The canonical check needs to be performed on the unshifted
value.

Putting this together with the above check, this whole function boils down
to:

	return !(data & rsvd_bits) && is_noncanonical_address(data, vcpu));

At that point, I don't see much value in a separate helper as the entire
check can be squeezed onto a single line.  It'll poke out a few chars, but
I think that's ok.

> +			return false;
> +	}
> +
> +	return !(data & rsvd_bits);
> +}
> +
> +static bool cet_check_ssp_msr_accessible(struct kvm_vcpu *vcpu,
> +					 struct msr_data *msr)
> +{
> +	u32 index = msr->index;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SHSTK))

This is pointless, we need a full kvm_cet_supported() check, e.g. if CET
is supported by the kernel but not KVM.  That exists as the supported_xss
check below, but _that_ check actually needs to be against
vcpu->arch.guest_supported_xss.

> +		return false;
> +
> +	if (!msr->host_initiated &&

If the suported_xss/kvm_cet_supported() check is hoisted up, then the
host_initiated case can be short-circuited immediately.

With some further massaging, this becomes:

	u64 mask;

	if (!kvm_cet_supported())
		return false;

	if (msr->host_initiated)
		return true;

	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
	    msr->index == MSR_KVM_GUEST_SSP)
		return false;

	if (msr->index == MSR_IA32_INT_SSP_TAB)
		return true;

	mask = (msr->index == MSR_IA32_PL3_SSP) ? XFEATURE_MASK_CET_USER :
						  XFEATURE_MASK_CET_KERNEL;
	return !!(vcpu->arch.guest_supported_xss & mask);

I think that gets all the cases correct?  The INT_SSP_TAB without CET_USER
or CET_KERNEL is weird, but that'd be an unusable model so it's probably not
worth spending much time on what's the least insane approach.

> +	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> +		return false;
> +
> +	if (index == MSR_KVM_GUEST_SSP)
> +		return msr->host_initiated &&
> +		       guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> +
> +	if (index == MSR_IA32_INT_SSP_TAB)
> +		return true;
> +
> +	if (index == MSR_IA32_PL3_SSP)
> +		return supported_xss & XFEATURE_MASK_CET_USER;
> +
> +	return supported_xss & XFEATURE_MASK_CET_KERNEL;
> +}
> +
> +static bool cet_check_ctl_msr_accessible(struct kvm_vcpu *vcpu,
> +					 struct msr_data *msr)
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
> +	if (index == MSR_IA32_U_CET)
> +		return supported_xss & XFEATURE_MASK_CET_USER;
> +
> +	return supported_xss & XFEATURE_MASK_CET_KERNEL;

Same comments as above.

> +}
>  /*
>   * Reads an msr value (of 'msr_index') into 'pdata'.
>   * Returns 0 on success, non-0 otherwise.
> @@ -1951,6 +2039,31 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>  		break;
> +	case MSR_KVM_GUEST_SSP:
> +		if (!cet_check_ssp_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		msr_info->data = vmcs_readl(GUEST_SSP);
> +		break;
> +	case MSR_IA32_S_CET:
> +		if (!cet_check_ctl_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		msr_info->data = vmcs_readl(GUEST_S_CET);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!cet_check_ssp_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +		break;
> +	case MSR_IA32_U_CET:
> +		if (!cet_check_ctl_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		vmx_get_xsave_msr(msr_info);
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!cet_check_ssp_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		vmx_get_xsave_msr(msr_info);
> +		break;
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> @@ -2221,6 +2334,41 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			vmx->pt_desc.guest.addr_a[index / 2] = data;
>  		break;
> +	case MSR_KVM_GUEST_SSP:
> +		if (!cet_check_ssp_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		if (!cet_check_msr_valid(vcpu, msr_info, CET_MSR_RSVD_BITS_1))
> +			return 1;
> +		vmcs_writel(GUEST_SSP, data);
> +		break;
> +	case MSR_IA32_S_CET:
> +		if (!cet_check_ctl_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		if (!cet_check_msr_valid(vcpu, msr_info, CET_MSR_RSVD_BITS_2))
> +			return 1;
> +		vmcs_writel(GUEST_S_CET, data);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!cet_check_ctl_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		if (!cet_check_msr_valid(vcpu, msr_info, 0))
> +			return 1;
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
> +		break;
> +	case MSR_IA32_U_CET:
> +		if (!cet_check_ctl_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		if (!cet_check_msr_valid(vcpu, msr_info, CET_MSR_RSVD_BITS_2))
> +			return 1;
> +		vmx_set_xsave_msr(msr_info);
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!cet_check_ssp_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		if (!cet_check_msr_valid(vcpu, msr_info, CET_MSR_RSVD_BITS_1))
> +			return 1;
> +		vmx_set_xsave_msr(msr_info);

There are essentially three groups: S_CET/U_SET, INT_SSP_TAB, and all the SSP
MSRs.  If we group them together, then the reserved bit and canonical checks
naturally get combined.  It requires an extra check to direct to the VMCS vs.
XSAVE state, but this isn't a fast path and it cuts down on the duplicate code
without having to add more utility functions.  E.g.

	case MSR_IA32_S_CET:
	case MSR_IA32_U_CET:
		if (!cet_is_control_msr_accessible(vcpu, msr_info))
			return 1;
		if ((data & GENMASK(9, 6)) || is_noncanonical_address(data, vcpu))
			return 1;
		if (msr_index == MSR_IA32_S_CET)
			vmcs_writel(GUEST_S_CET, data);
		else
			vmx_set_xsave_msr(msr_info);
		break;
	case MSR_IA32_INT_SSP_TAB:
		if (!cet_is_control_msr_accessible(vcpu, msr_info))
			return 1;
		if (is_noncanonical_address(data, vcpu))
			return 1;
		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
		break;
	case MSR_KVM_GUEST_SSP:
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
			return 1;
		if ((data & GENMASK(2, 0)) || is_noncanonical_address(data, vcpu))
			return 1;
		if (msr_index == MSR_KVM_GUEST_SSP)
			vmcs_writel(GUEST_SSP, data);
		else
			vmx_set_xsave_msr(msr_info);
		break;


> +		break;
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c437ddc22ad6..c71a9ceac05e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1234,6 +1234,10 @@ static const u32 msrs_to_save_all[] = {
>  	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
>  	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
>  	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> +
> +	MSR_IA32_XSS, MSR_IA32_U_CET, MSR_IA32_S_CET,
> +	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
> +	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB, MSR_KVM_GUEST_SSP,
>  };

It's somewhat arbitrary, but I think it makes sense to report the MSRs as
to-be-saved in a separate patch.  The XSS change definitely should be its
own patch.  Then, with the synthetic MSR as a separate patch, we end up
with a sequence like:

9398804f6577 KVM: x86: Report XSS as an MSR to be saved if there are supported features
...
5bc17d5211ed KVM: x86: Load guest fpu state when accessing MSRs managed by XSAVES
e96552044086 KVM: VMX: Emulate reads and writes to CET MSRs
a853510b851d KVM: VMX: Add a synthetic MSR to allow userspace VMM to access GUEST_SSP
9aef9270286b KVM: x86: Report CET MSRs as to-be-saved if CET is supported

Another required change is that all these MSRs need to be conditionally
reported based on KVM support, i.e. handled in kvm_init_msr_list().
