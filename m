Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33A122A144
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 23:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgGVVUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 17:20:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:3530 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgGVVUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 17:20:37 -0400
IronPort-SDR: 6iaVSd4XYR7gaVao477hpJn+swBFv3IBqUkei7VFX5ldQaTR8Ib1RiLTFd69+PEeKsmLMcc7hc
 d5Wn9yVlkX+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="137925442"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="137925442"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:20:36 -0700
IronPort-SDR: ecS7zNPvOkn1uU0G8nxVrJSSgqIoeth/G/dOiHVaG4XrkwKTsw121yEi3mmACARvjfzxf8obdM
 8xCZcQh+YHGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="272115355"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jul 2020 14:20:35 -0700
Date:   Wed, 22 Jul 2020 14:20:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [RESEND v13 08/11] KVM: VMX: Enable CET support for nested VM
Message-ID: <20200722212035.GI9114@linux.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
 <20200716031627.11492-9-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716031627.11492-9-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 11:16:24AM +0800, Yang Weijiang wrote:
> CET MSRs pass through guests for performance consideration. Configure the
> MSRs to match L0/L1 settings so that nested VM is able to run with CET.
> 
> Add assertions for vmcs12 offset table initialization, these assertions can
> detect the mismatch of VMCS field encoding and data type at compiling time.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c |  34 +++++
>  arch/x86/kvm/vmx/vmcs12.c | 267 +++++++++++++++++++++++---------------
>  arch/x86/kvm/vmx/vmcs12.h |  14 +-
>  arch/x86/kvm/vmx/vmx.c    |  10 ++
>  4 files changed, 216 insertions(+), 109 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d4a4cec034d0..ddb1a69ce947 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -550,6 +550,18 @@ static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
>  	}
>  }
>  
> +static void nested_vmx_update_intercept_for_msr(struct kvm_vcpu *vcpu,

"update" is misleading.  That implies the helper can set or clear
interception, whereas this is purely a one-way ticket for disabling
intereption.  nested_vmx_cond_disable_intercept_for_msr() is the best I
could come up with.  It's long, but wrapping can be avoided with some
extra massaging.
> +						u32 msr,
> +						unsigned long *msr_bitmap_l1,
> +						unsigned long *msr_bitmap_l0,
> +						int type)
> +{
> +	if (!msr_write_intercepted_l01(vcpu, msr))
> +		nested_vmx_disable_intercept_for_msr(msr_bitmap_l1,
> +						     msr_bitmap_l0,
> +						     msr, type);

This can avoid wrapping by renaming variables and refactoring code:

	if (msr_write_intercepted_l01(vcpu, msr))
		return;

	nested_vmx_disable_intercept_for_msr(bitmap_12, bitmap_02, msr, type);

And since there are existing users, the helper should also be added in a
separate patch.  Doing so does two things: allows further consolidation of
code, and separates the new logic from the CET logic, e.g. if the new helper
is broken then (with luck) bisection will point at the helper patch and not
the CET patch.

> +}
> +
>  /*
>   * Merge L0's and L1's MSR bitmap, return false to indicate that
>   * we do not use the hardware.
> @@ -621,6 +633,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
>  					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
>  
> +	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
> +	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_U_CET,
> +					    msr_bitmap_l1, msr_bitmap_l0,
> +					    MSR_TYPE_RW);
> +	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
> +					    msr_bitmap_l1, msr_bitmap_l0,
> +					    MSR_TYPE_RW);
> +	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_S_CET,
> +					    msr_bitmap_l1, msr_bitmap_l0,
> +					    MSR_TYPE_RW);
> +	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
> +					    msr_bitmap_l1, msr_bitmap_l0,
> +					    MSR_TYPE_RW);
> +	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
> +					    msr_bitmap_l1, msr_bitmap_l0,
> +					    MSR_TYPE_RW);
> +	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
> +					    msr_bitmap_l1, msr_bitmap_l0,
> +					    MSR_TYPE_RW);
> +	nested_vmx_update_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
> +					    msr_bitmap_l1, msr_bitmap_l0,
> +					    MSR_TYPE_RW);
>  	/*
>  	 * Checking the L0->L1 bitmap is trying to verify two things:
>  	 *
> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> index c8e51c004f78..147e0d8eeab2 100644
> --- a/arch/x86/kvm/vmx/vmcs12.c
> +++ b/arch/x86/kvm/vmx/vmcs12.c
> @@ -4,31 +4,76 @@
>  
>  #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
>  #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
> -#define FIELD(number, name)	[ROL16(number, 6)] = VMCS12_OFFSET(name)
> -#define FIELD64(number, name)						\
> -	FIELD(number, name),						\
> -	[ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
> +

Again, this does not belong in this series.  At the very least, not in this
patch.  I also suspect we can use some macro shenanigans to automagically
detect the field size, i.e. isntead of having FIELDN, FIELD32, etc...

...

>  const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs_field_to_offset_table);
> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> index 80232daf00ff..016896c9e701 100644
> --- a/arch/x86/kvm/vmx/vmcs12.h
> +++ b/arch/x86/kvm/vmx/vmcs12.h
> @@ -115,7 +115,13 @@ struct __packed vmcs12 {
>  	natural_width host_ia32_sysenter_eip;
>  	natural_width host_rsp;
>  	natural_width host_rip;
> -	natural_width paddingl[8]; /* room for future expansion */
> +	natural_width host_s_cet;
> +	natural_width host_ssp;
> +	natural_width host_ssp_tbl;
> +	natural_width guest_s_cet;
> +	natural_width guest_ssp;
> +	natural_width guest_ssp_tbl;
> +	natural_width paddingl[2]; /* room for future expansion */
>  	u32 pin_based_vm_exec_control;
>  	u32 cpu_based_vm_exec_control;
>  	u32 exception_bitmap;
> @@ -295,6 +301,12 @@ static inline void vmx_check_vmcs12_offsets(void)
>  	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
>  	CHECK_OFFSET(host_rsp, 664);
>  	CHECK_OFFSET(host_rip, 672);
> +	CHECK_OFFSET(host_s_cet, 680);
> +	CHECK_OFFSET(host_ssp, 688);
> +	CHECK_OFFSET(host_ssp_tbl, 696);
> +	CHECK_OFFSET(guest_s_cet, 704);
> +	CHECK_OFFSET(guest_ssp, 712);
> +	CHECK_OFFSET(guest_ssp_tbl, 720);
>  	CHECK_OFFSET(pin_based_vm_exec_control, 744);
>  	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
>  	CHECK_OFFSET(exception_bitmap, 752);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4ce61427ed49..d465ff990094 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7321,6 +7321,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>  	cr4_fixed1_update(X86_CR4_PKE,        ecx, feature_bit(PKU));
>  	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
>  	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
> +	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
>  
>  #undef cr4_fixed1_update
>  }
> @@ -7340,6 +7341,15 @@ static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>  			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
>  		}
>  	}
> +
> +	if (is_cet_state_supported(vcpu, XFEATURE_MASK_CET_USER |
> +	    XFEATURE_MASK_CET_KERNEL)) {

I prefer the above MPX style of:

	if (kvm_cet_supported()) {
		bool cet_enabled = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
				   guest_cpuid_has(vcpu, X86_FEATURE_IBT);

		if (cet_enabled) {
			msrs->entry_ctls_high |= VM_ENTRY_LOAD_CET_STATE;
			msrs->exit_ctls_high |= VM_EXIT_LOAD_CET_STATE;
		} else {
			msrs->entry_ctls_high &= ~VM_ENTRY_LOAD_CET_STATE;
			msrs->exit_ctls_high &= ~VM_EXIT_LOAD_CET_STATE;
		}
	}

That's also more in line with the logic for computing secondary execution
controls.  Not that it really matters, but it means we're not updating the
MSRs when KVM doesn't support CET in the first place.

> +		vmx->nested.msrs.entry_ctls_high |= VM_ENTRY_LOAD_CET_STATE;
> +		vmx->nested.msrs.exit_ctls_high |= VM_EXIT_LOAD_CET_STATE;

The line lengths can be shortened by adding a prep patch to grab
vmx->nested.msrs in a local msrs variable, that way the extra level of
indentation doesn't need a wrap.  'vmx' itself is unnecessary.

> +	} else {
> +		vmx->nested.msrs.entry_ctls_high &= ~VM_ENTRY_LOAD_CET_STATE;
> +		vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_LOAD_CET_STATE;
> +	}
>  }
>  
>  static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> -- 
> 2.17.2
> 
