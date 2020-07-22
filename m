Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD7222A0BB
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 22:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732348AbgGVUbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 16:31:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:1245 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgGVUbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 16:31:04 -0400
IronPort-SDR: 4g+FHZA/WD0a53Tw+xml2PIPr0bEafxhqEhDAdNy3Lfgl3MxWUorhvl8alZvMbidnpkwUPwu6O
 5AgbwZ1VaS7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="150393042"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="150393042"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 13:31:03 -0700
IronPort-SDR: h9UJ9Hjz/CKF+t3OgpT9S+ChZfRfofGiNho85OF4Dv4WSPMTcjNG3Bcq283GWlfpCC7c5oqpvF
 fsFOAKPIDKkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="362827472"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 22 Jul 2020 13:31:03 -0700
Date:   Wed, 22 Jul 2020 13:31:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [RESEND v13 04/11] KVM: VMX: Configure CET settings upon guest
 CR0/4 changing
Message-ID: <20200722203103.GE9114@linux.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
 <20200716031627.11492-5-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716031627.11492-5-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 11:16:20AM +0800, Yang Weijiang wrote:
> CR4.CET is master control bit for CET function. There're mutual constrains
> between CR0.WP and CR4.CET, so need to check the dependent bit while changing
> the control registers.
> 
> The processor does not allow CR4.CET to be set if CR0.WP = 0,similarly, it does
> not allow CR0.WP to be cleared while CR4.CET = 1. In either case, KVM would
> inject #GP to guest.
> 
> CET state load bit is set/cleared along with CR4.CET bit set/clear.
> 
> Note:
> SHSTK and IBT features share one control MSR: MSR_IA32_{U,S}_CET, which means
> it's difficult to hide one feature from another in the case of SHSTK != IBT,
> after discussed in community, it's agreed to allow guest control two features
> independently as it won't introduce security hole.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/capabilities.h |  5 +++++
>  arch/x86/kvm/vmx/vmx.c          | 30 ++++++++++++++++++++++++++++--
>  arch/x86/kvm/x86.c              |  3 +++
>  3 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 4bbd8b448d22..dbc87c5997cc 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -103,6 +103,11 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
>  	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
>  }
>  
> +static inline bool cpu_has_load_cet_ctrl(void)
> +{
> +	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE) &&
> +		(vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_CET_STATE);

Nit, please align indentation.

> +}
>  static inline bool cpu_has_vmx_mpx(void)
>  {
>  	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a9f135c52cbc..0089943fbb31 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2510,7 +2510,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	      VM_EXIT_LOAD_IA32_EFER |
>  	      VM_EXIT_CLEAR_BNDCFGS |
>  	      VM_EXIT_PT_CONCEAL_PIP |
> -	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
> +	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
> +	      VM_EXIT_LOAD_CET_STATE;
>  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
>  				&_vmexit_control) < 0)
>  		return -EIO;
> @@ -2534,7 +2535,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	      VM_ENTRY_LOAD_IA32_EFER |
>  	      VM_ENTRY_LOAD_BNDCFGS |
>  	      VM_ENTRY_PT_CONCEAL_PIP |
> -	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
> +	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
> +	      VM_ENTRY_LOAD_CET_STATE;
>  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
>  				&_vmentry_control) < 0)
>  		return -EIO;
> @@ -3133,6 +3135,12 @@ static bool is_cet_state_supported(struct kvm_vcpu *vcpu, u32 xss_states)
>  		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));
>  }
>  
> +static bool is_cet_supported(struct kvm_vcpu *vcpu)
> +{
> +	return is_cet_state_supported(vcpu, XFEATURE_MASK_CET_USER |
> +				      XFEATURE_MASK_CET_KERNEL);
> +}
> +
>  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -3173,6 +3181,10 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  			return 1;
>  	}
>  
> +	if ((cr4 & X86_CR4_CET) && (!is_cet_supported(vcpu) ||

This is the wrong way to check CR4.CET support, and is in the wrong place.
The correct way to check support is to teach __cr4_reserved_bits() to mark
CET reserved if SHSTK and IBT are not supported.

It's the wrong place because the CR4.CET vs. CR0.WP check should _not_ be
done for nested transitions, which calls vmx_set_cr*() directly precisely
to avoid ordering problems.

> +	    !(kvm_read_cr0(vcpu) & X86_CR0_WP)))
> +		return 1;
> +
>  	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
>  		return 1;
>  
> @@ -3204,6 +3216,20 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
>  	}
>  
> +	if (cpu_has_load_cet_ctrl()) {
> +		if ((hw_cr4 & X86_CR4_CET) && is_cet_supported(vcpu)) {
> +			vm_entry_controls_setbit(to_vmx(vcpu),
> +						 VM_ENTRY_LOAD_CET_STATE);
> +			vm_exit_controls_setbit(to_vmx(vcpu),
> +						VM_EXIT_LOAD_CET_STATE);
> +		} else {
> +			vm_entry_controls_clearbit(to_vmx(vcpu),
> +						   VM_ENTRY_LOAD_CET_STATE);
> +			vm_exit_controls_clearbit(to_vmx(vcpu),
> +						  VM_EXIT_LOAD_CET_STATE);
> +		}
> +	}

Disabling the load based on CR4.CET is incorrect.  The MSRs are exposed to
the guest irrespective of CR4.CET, which means that _not_ loading guest
state will allow the guest to read the host values, i.e. will leak host
data to the guest.

On the other hand, we do need to explicitly clear the controls in
setup_vmcs_config() if only one is supported, otherwise it'd be possible to
load guest state on VM-Enter but not restore host state on VM-Exit.  That
shouldn't happen on real silicon, but is technically a legal configuration
and therefore theoretically possible for a VM

> +
>  	vmcs_writel(CR4_READ_SHADOW, cr4);
>  	vmcs_writel(GUEST_CR4, hw_cr4);
>  	return 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ea8a9dc9fbad..906e07039d59 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -815,6 +815,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
>  		return 1;
>  
> +	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
> +		return 1;
> +
>  	kvm_x86_ops.set_cr0(vcpu, cr0);
>  
>  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
> -- 
> 2.17.2
> 
