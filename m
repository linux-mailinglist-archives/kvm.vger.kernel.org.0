Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99AD5D06BA
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 06:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfJIErf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 00:47:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:40112 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbfJIErf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 00:47:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 21:47:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="183955396"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 08 Oct 2019 21:47:32 -0700
Date:   Wed, 9 Oct 2019 12:49:30 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [Patch 2/6] KVM: VMX: Use wrmsr for switching between guest and
 host IA32_XSS
Message-ID: <20191009044930.GA27370@local-michael-cet-test>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009004142.225377-2-aaronlewis@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 08, 2019 at 05:41:38PM -0700, Aaron Lewis wrote:
> Set IA32_XSS for the guest and host during VM Enter and VM Exit
> transitions rather than by using the MSR-load areas.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/svm.c     |  4 ++--
>  arch/x86/kvm/vmx/vmx.c | 14 ++------------
>  arch/x86/kvm/x86.c     | 25 +++++++++++++++++++++----
>  arch/x86/kvm/x86.h     |  4 ++--
>  4 files changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f8ecb6df5106..e2d7a7738c76 100644
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
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 409e9a7323f1..ff5ba28abecb 100644
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
>  		break;
>  	case MSR_IA32_RTIT_CTL:
>  		if ((pt_mode != PT_MODE_HOST_GUEST) ||
> @@ -6540,7 +6533,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
>  		vmx_set_interrupt_shadow(vcpu, 0);
>  
> -	kvm_load_guest_xcr0(vcpu);
> +	kvm_load_guest_xsave_controls(vcpu);
>  
>  	if (static_cpu_has(X86_FEATURE_PKU) &&
>  	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
> @@ -6647,7 +6640,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  			__write_pkru(vmx->host_pkru);
>  	}
>  
> -	kvm_put_guest_xcr0(vcpu);
> +	kvm_load_host_xsave_controls(vcpu);
>  
>  	vmx->nested.nested_run_pending = 0;
>  	vmx->idt_vectoring_info = 0;
> @@ -7599,9 +7592,6 @@ static __init int hardware_setup(void)
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
> index 661e2bf38526..e90e658fd8a9 100644
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
> @@ -812,27 +814,39 @@ void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
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
> +		if (kvm_x86_ops->xsaves_supported() &&
> +		    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
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
> +		if (kvm_x86_ops->xsaves_supported() &&
> +		    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
Should it check guest/VMX XSAVES support before load *host*
XSS states?
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
> @@ -9293,6 +9307,9 @@ int kvm_arch_hardware_setup(void)
>  		kvm_default_tsc_scaling_ratio = 1ULL << kvm_tsc_scaling_ratio_frac_bits;
>  	}
>  
> +	if (boot_cpu_has(X86_FEATURE_XSAVES))
> +		rdmsrl(MSR_IA32_XSS, host_xss);
> +
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
> 2.23.0.581.g78d2f28ef7-goog
