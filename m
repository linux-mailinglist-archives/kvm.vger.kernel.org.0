Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA34BB2192
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 16:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388414AbfIMOEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 10:04:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:43582 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388084AbfIMOEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 10:04:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 07:04:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="336899823"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 13 Sep 2019 07:04:51 -0700
Date:   Fri, 13 Sep 2019 07:04:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com
Subject: Re: [PATCH] kvm: nvmx: limit atomic switch MSRs
Message-ID: <20190913140451.GB31125@linux.intel.com>
References: <20190912181100.131124-1-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912181100.131124-1-marcorr@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 11:11:00AM -0700, Marc Orr wrote:
> Allowing an unlimited number of MSRs to be specified via the VMX
> load/store MSR lists (e.g., vm-entry MSR load list) is bad for two
> reasons. First, a guest can specify an unreasonable number of MSRs,
> forcing KVM to process all of them in software. Second, the SDM bounds
> the number of MSRs allowed to be packed into the atomic switch MSR lists.
> Quoting the appendix chapter, titled "MISCELLANEOUS DATA":

Super Nit: There are multiple appendices in the SDM, maybe this?

Quoting the "Miscellaneous Data" section in the "VMX Capability Reporting
Facility" appendix:

> "Bits 27:25 is used to compute the recommended maximum number of MSRs
> that should appear in the VM-exit MSR-store list, the VM-exit MSR-load
> list, or the VM-entry MSR-load list. Specifically, if the value bits
> 27:25 of IA32_VMX_MISC is N, then 512 * (N + 1) is the recommended
> maximum number of MSRs to be included in each list. If the limit is
> exceeded, undefined processor behavior may result (including a machine
> check during the VMX transition)."
> 
> Thus, force a VM-entry to fail due to MSR loading when the MSR load
> list is too large. Similarly, trigger an abort during a VM exit that
> encounters an MSR load list or MSR store list that is too large.
> 
> Test these new checks with the kvm-unit-test "x86: nvmx: test max atomic
> switch MSRs".
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
>  arch/x86/include/asm/vmx.h |  1 +
>  arch/x86/kvm/vmx/nested.c  | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index a39136b0d509..21c2a1d982e8 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -110,6 +110,7 @@
>  #define VMX_MISC_SAVE_EFER_LMA			0x00000020
>  #define VMX_MISC_ACTIVITY_HLT			0x00000040
>  #define VMX_MISC_ZERO_LEN_INS			0x40000000
> +#define VMX_MISC_MSR_LIST_INCREMENT             512

VMX_MISC_MSR_LIST_MULTIPLIER seems more appropriate.  INCREMENT makes it
sound like X number of entries get tacked on to the end.

>  
>  /* VMFUNC functions */
>  #define VMX_VMFUNC_EPTP_SWITCHING               0x00000001
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ced9fba32598..69c6fc5557d8 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -856,6 +856,17 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static u64 vmx_control_msr(u32 low, u32 high);

vmx_control_msr() is a 'static inline', just hoist it above this function.
It probably makes sense to move vmx_control_verify() too, maybe to just
below nested_vmx_abort()?

> +static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	u64 vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
> +				       vmx->nested.msrs.misc_high);
> +
> +	return (vmx_misc_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_INCREMENT;
> +}
> +
>  /*
>   * Load guest's/host's msr at nested entry/exit.
>   * return 0 for success, entry index for failure.
> @@ -865,9 +876,13 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>  	u32 i;
>  	struct vmx_msr_entry e;
>  	struct msr_data msr;
> +	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
>  
>  	msr.host_initiated = false;
>  	for (i = 0; i < count; i++) {
> +		if (unlikely(i >= max_msr_list_size))

Although the SDM gives us leeway to do whatever we please since it states
this is undefined behavior, KVM should at least be consistent between
nested_vmx_load_msr() and nested_vmx_load_msr().  Here it fails only after
processing the first N MSRs, while in the store case it fails immediately.

I'm guessing you opted for the divergent behavior because
nested_vmx_load_msr() returns the failing index for VM-Enter, but
nested_vmx_store_msr() has visible side effects too.  E.g. storing the
MSRs modifies memory, which could theoretically be read by other CPUs
since VMX abort only brings down the current logical CPU.

> +			goto fail;
> +
>  		if (kvm_vcpu_read_guest(vcpu, gpa + i * sizeof(e),
>  					&e, sizeof(e))) {
>  			pr_debug_ratelimited(
> @@ -899,6 +914,10 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>  {
>  	u32 i;
>  	struct vmx_msr_entry e;
> +	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
> +
> +	if (unlikely(count > max_msr_list_size))
> +		return -EINVAL;
>  
>  	for (i = 0; i < count; i++) {
>  		struct msr_data msr_info;
> -- 
> 2.23.0.237.gc6a4ce50a0-goog
> 
