Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15462B4460
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 01:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbfIPXCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 19:02:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:47684 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730434AbfIPXCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 19:02:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 16:02:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,514,1559545200"; 
   d="scan'208";a="270345856"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 16 Sep 2019 16:02:29 -0700
Date:   Mon, 16 Sep 2019 16:02:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com
Subject: Re: [PATCH v2] kvm: nvmx: limit atomic switch MSRs
Message-ID: <20190916230229.GO18871@linux.intel.com>
References: <20190914003940.203636-1-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914003940.203636-1-marcorr@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 13, 2019 at 05:39:40PM -0700, Marc Orr wrote:
> Allowing an unlimited number of MSRs to be specified via the VMX
> load/store MSR lists (e.g., vm-entry MSR load list) is bad for two
> reasons. First, a guest can specify an unreasonable number of MSRs,
> forcing KVM to process all of them in software. Second, the SDM bounds
> the number of MSRs allowed to be packed into the atomic switch MSR lists.
> Quoting the "Miscellaneous Data" section in the "VMX Capability
> Reporting Facility" appendix:
> 
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

It's probably redundant/obvious, but I think it's worth calling out that
this is arbitrary KVM behavior, e.g. replace "Thus," with something like:

  Because KVM needs to protect itself and can't model "undefined processor
  behavior", arbitrarily

The changelog (and maybe a comment in the code) should also state that
the count is intentionally not pre-checked so as to maintain compability
with hardware inasmuch as possible.  That's a subtlety that's likely to
lead to "cleanup" in the future :-)

Code itself looks good, with the spurious vmx_control_msr() removed.

> Test these new checks with the kvm-unit-test "x86: nvmx: test max atomic
> switch MSRs".
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
> v1 -> v2
> * Updated description to distinguish the relevant appendix.
> * Renamed VMX_MISC_MSR_LIST_INCREMENT to VMX_MISC_MSR_LIST_MULTIPLIER.
> * Moved vmx_control_msr() and vmx_control_verify() up in the source.
> * Modified nested_vmx_store_msr() to fail lazily, like
>   nested_vmx_load_msr().
> 
>  arch/x86/include/asm/vmx.h |  1 +
>  arch/x86/kvm/vmx/nested.c  | 41 ++++++++++++++++++++++++++++----------
>  2 files changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index a39136b0d509..a1f6ed187ccd 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -110,6 +110,7 @@
>  #define VMX_MISC_SAVE_EFER_LMA			0x00000020
>  #define VMX_MISC_ACTIVITY_HLT			0x00000040
>  #define VMX_MISC_ZERO_LEN_INS			0x40000000
> +#define VMX_MISC_MSR_LIST_MULTIPLIER		512
>  
>  /* VMFUNC functions */
>  #define VMX_VMFUNC_EPTP_SWITCHING               0x00000001
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ced9fba32598..bca0167b8bdd 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -190,6 +190,16 @@ static void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
>  	pr_debug_ratelimited("kvm: nested vmx abort, indicator %d\n", indicator);
>  }
>  
> +static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> +{
> +	return fixed_bits_valid(control, low, high);
> +}
> +
> +static inline u64 vmx_control_msr(u32 low, u32 high)
> +{
> +	return low | ((u64)high << 32);
> +}
> +
>  static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
>  {
>  	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
> @@ -856,6 +866,17 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static u64 vmx_control_msr(u32 low, u32 high);
> +
> +static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	u64 vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
> +				       vmx->nested.msrs.misc_high);
> +
> +	return (vmx_miscd_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_MULTIPLIER;
> +}
> +
>  /*
>   * Load guest's/host's msr at nested entry/exit.
>   * return 0 for success, entry index for failure.
> @@ -865,9 +886,13 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>  	u32 i;
>  	struct vmx_msr_entry e;
>  	struct msr_data msr;
> +	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
>  
>  	msr.host_initiated = false;
>  	for (i = 0; i < count; i++) {
> +		if (unlikely(i >= max_msr_list_size))
> +			goto fail;
> +
>  		if (kvm_vcpu_read_guest(vcpu, gpa + i * sizeof(e),
>  					&e, sizeof(e))) {
>  			pr_debug_ratelimited(
> @@ -899,9 +924,14 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>  {
>  	u32 i;
>  	struct vmx_msr_entry e;
> +	u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
>  
>  	for (i = 0; i < count; i++) {
>  		struct msr_data msr_info;
> +
> +		if (unlikely(i >= max_msr_list_size))
> +			return -EINVAL;
> +
>  		if (kvm_vcpu_read_guest(vcpu,
>  					gpa + i * sizeof(e),
>  					&e, 2 * sizeof(u32))) {
> @@ -1009,17 +1039,6 @@ static u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
>  	return vmx->nested.vpid02 ? vmx->nested.vpid02 : vmx->vpid;
>  }
>  
> -
> -static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> -{
> -	return fixed_bits_valid(control, low, high);
> -}
> -
> -static inline u64 vmx_control_msr(u32 low, u32 high)
> -{
> -	return low | ((u64)high << 32);
> -}
> -
>  static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
>  {
>  	superset &= mask;
> -- 
> 2.23.0.237.gc6a4ce50a0-goog
> 
