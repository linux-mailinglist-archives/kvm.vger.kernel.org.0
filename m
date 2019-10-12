Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10F66D4B51
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 02:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfJLASj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 20:18:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:25715 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfJLASj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 20:18:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 17:18:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,286,1566889200"; 
   d="scan'208";a="207536674"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 11 Oct 2019 17:18:38 -0700
Date:   Fri, 11 Oct 2019 17:18:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 2/5] KVM: VMX: Use wrmsr for switching between guest
 and host IA32_XSS
Message-ID: <20191012001838.GA11329@linux.intel.com>
References: <20191011194032.240572-1-aaronlewis@google.com>
 <20191011194032.240572-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011194032.240572-3-aaronlewis@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 11, 2019 at 12:40:29PM -0700, Aaron Lewis wrote:
> Set IA32_XSS for the guest and host during VM Enter and VM Exit
> transitions rather than by using the MSR-load areas.
> 
> By moving away from using the MSR-load area we can have a unified
> solution for both AMD and Intel.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm.c              |  7 +++++--
>  arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++------------
>  arch/x86/kvm/x86.c              | 23 +++++++++++++++++++----
>  arch/x86/kvm/x86.h              |  4 ++--
>  5 files changed, 37 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 50eb430b0ad8..634c2598e389 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -562,6 +562,7 @@ struct kvm_vcpu_arch {
>  	u64 smbase;
>  	u64 smi_count;
>  	bool tpr_access_reporting;
> +	bool xsaves_enabled;
>  	u64 ia32_xss;
>  	u64 microcode_version;
>  	u64 arch_capabilities;
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f8ecb6df5106..da69e95beb4d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5628,7 +5628,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	svm->vmcb->save.cr2 = vcpu->arch.cr2;
>  
>  	clgi();
> -	kvm_load_guest_xcr0(vcpu);
> +	kvm_load_guest_xsave_controls(vcpu);
>  
>  	if (lapic_in_kernel(vcpu) &&
>  		vcpu->arch.apic->lapic_timer.timer_advance_ns)
> @@ -5778,7 +5778,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>  		kvm_before_interrupt(&svm->vcpu);
>  
> -	kvm_put_guest_xcr0(vcpu);
> +	kvm_load_host_xsave_controls(vcpu);
>  	stgi();
>  
>  	/* Any pending NMI will happen here */
> @@ -5887,6 +5887,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> +				    boot_cpu_has(X86_FEATURE_XSAVES);

This looks very much like a functional change to SVM, which feels wrong
for a patch with a subject of "KVM: VMX: Use wrmsr for switching between
guest and host IA32_XSS" feels wrong.  Shouldn't this be unconditionally
set false in this patch, and then enabled in " kvm: svm: Add support for
XSAVES on AMD"?

> +
>  	/* Update nrips enabled cache */
>  	svm->nrips_enabled = !!guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 409e9a7323f1..ce3020914c69 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -106,8 +106,6 @@ module_param(enable_apicv, bool, S_IRUGO);
>  static bool __read_mostly nested = 1;
>  module_param(nested, bool, S_IRUGO);
>  
> -static u64 __read_mostly host_xss;
> -
>  bool __read_mostly enable_pml = 1;
>  module_param_named(pml, enable_pml, bool, S_IRUGO);
>  
> @@ -2074,11 +2072,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (data != 0)
>  			return 1;
>  		vcpu->arch.ia32_xss = data;
> -		if (vcpu->arch.ia32_xss != host_xss)
> -			add_atomic_switch_msr(vmx, MSR_IA32_XSS,
> -				vcpu->arch.ia32_xss, host_xss, false);
> -		else
> -			clear_atomic_switch_msr(vmx, MSR_IA32_XSS);

I'm pretty sure the "vmx_xsaves_supported()" check in this case statement
can be removed after this patch.  The host support check was necessary
when the MSR load/save list was being used, but moving to xsaves_enabled
means theres no risk of writing MSR_IA32_XSS when it's not supported.

>  		break;
>  	case MSR_IA32_RTIT_CTL:
>  		if ((pt_mode != PT_MODE_HOST_GUEST) ||
> @@ -4038,6 +4031,8 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  			guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>  			guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
>  
> +		vcpu->arch.xsaves_enabled = xsaves_enabled;

Doesn't this conflict with the direction of the previous patch, "KVM: VMX:
Remove unneeded check for X86_FEATURE_XSAVE"?  xsaves_enabled is %true iff
both XSAVE and XSAVES are exposed to the guest.

Alternatively, couldn't KVM check arch.xsaves_enabled in the MSR handling?

> +
>  		if (!xsaves_enabled)
>  			exec_control &= ~SECONDARY_EXEC_XSAVES;
>  
> @@ -6540,7 +6535,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
>  		vmx_set_interrupt_shadow(vcpu, 0);
>  
> -	kvm_load_guest_xcr0(vcpu);
> +	kvm_load_guest_xsave_controls(vcpu);
>  
>  	if (static_cpu_has(X86_FEATURE_PKU) &&
>  	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
> @@ -6647,7 +6642,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  			__write_pkru(vmx->host_pkru);
>  	}
>  
> -	kvm_put_guest_xcr0(vcpu);
> +	kvm_load_host_xsave_controls(vcpu);
>  
>  	vmx->nested.nested_run_pending = 0;
>  	vmx->idt_vectoring_info = 0;
> @@ -7091,6 +7086,12 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> +	/*
> +	 * This will be set back to true in vmx_compute_secondary_exec_control()
> +	 * if it should be true, so setting it to false here is okay.

Or simply:

	/* xsaves_enabled is recomputed in vmx_compute_secondary_exec_control(). */

> +	 */
> +	vcpu->arch.xsaves_enabled = false;
> +
>  	if (cpu_has_secondary_exec_ctrls()) {
>  		vmx_compute_secondary_exec_control(vmx);
>  		vmcs_set_secondary_exec_control(vmx);
> @@ -7599,9 +7600,6 @@ static __init int hardware_setup(void)
>  		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
>  	}
>  
> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
> -		rdmsrl(MSR_IA32_XSS, host_xss);
> -
>  	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
>  	    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
>  		enable_vpid = 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 661e2bf38526..a61570d7034b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -176,6 +176,8 @@ struct kvm_shared_msrs {
>  static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;
>  static struct kvm_shared_msrs __percpu *shared_msrs;
>  
> +static u64 __read_mostly host_xss;
> +
>  struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	{ "pf_fixed", VCPU_STAT(pf_fixed) },
>  	{ "pf_guest", VCPU_STAT(pf_guest) },
> @@ -812,27 +814,37 @@ void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
>  }
>  EXPORT_SYMBOL_GPL(kvm_lmsw);
>  
> -void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
> +void kvm_load_guest_xsave_controls(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
>  			!vcpu->guest_xcr0_loaded) {
>  		/* kvm_set_xcr() also depends on this */
>  		if (vcpu->arch.xcr0 != host_xcr0)
>  			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
> +
> +		if (vcpu->arch.xsaves_enabled &&
> +		    vcpu->arch.ia32_xss != host_xss)
> +			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
> +
>  		vcpu->guest_xcr0_loaded = 1;
>  	}
>  }
> -EXPORT_SYMBOL_GPL(kvm_load_guest_xcr0);
> +EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_controls);
>  
> -void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
> +void kvm_load_host_xsave_controls(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu->guest_xcr0_loaded) {
>  		if (vcpu->arch.xcr0 != host_xcr0)
>  			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
> +
> +		if (vcpu->arch.xsaves_enabled &&
> +		    vcpu->arch.ia32_xss != host_xss)
> +			wrmsrl(MSR_IA32_XSS, host_xss);
> +
>  		vcpu->guest_xcr0_loaded = 0;
>  	}
>  }
> -EXPORT_SYMBOL_GPL(kvm_put_guest_xcr0);
> +EXPORT_SYMBOL_GPL(kvm_load_host_xsave_controls);
>  
>  static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  {
> @@ -9293,6 +9305,9 @@ int kvm_arch_hardware_setup(void)
>  		kvm_default_tsc_scaling_ratio = 1ULL << kvm_tsc_scaling_ratio_frac_bits;
>  	}
>  
> +	if (boot_cpu_has(X86_FEATURE_XSAVES))
> +		rdmsrl(MSR_IA32_XSS, host_xss);

More code that goes beyond the subject of the patch, as host_xss is now
being read and potentially switched on SVM platforms.  I don't mind the
change itself being part of this patch (unlike setting xsaves_enabled),
but IMO the subject should make it more clear that this is a common x86
change.  Arguably this should be two patches, one to do what this subject
says and a second to move the code to common x86, but that seems like
overkill.

>  	kvm_init_msr_list();
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index dbf7442a822b..0d04e865665b 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -366,7 +366,7 @@ static inline bool kvm_pat_valid(u64 data)
>  	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
>  }
>  
> -void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
> -void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
> +void kvm_load_guest_xsave_controls(struct kvm_vcpu *vcpu);
> +void kvm_load_host_xsave_controls(struct kvm_vcpu *vcpu);
>  
>  #endif
> -- 
> 2.23.0.700.g56cf767bdb-goog
> 
