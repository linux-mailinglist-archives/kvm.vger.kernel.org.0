Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 438BC1195C0
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 22:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfLJVXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 16:23:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:58948 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbfLJVXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 16:23:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 13:23:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,300,1571727600"; 
   d="scan'208";a="264656217"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Dec 2019 13:23:06 -0800
Date:   Tue, 10 Dec 2019 13:23:05 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com, yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 4/7] KVM: VMX: Load CET states on vmentry/vmexit
Message-ID: <20191210212305.GM15758@linux.intel.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-5-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101085222.27997-5-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 01, 2019 at 04:52:19PM +0800, Yang Weijiang wrote:
> "Load {guest,host} CET state" bit controls whether guest/host
> CET states will be loaded at VM entry/exit. Before doing that,
> KVM needs to check if CET is both enabled on host and guest.
> 
> Note: SHSTK and IBT features share one control MSR:
> MSR_IA32_{U,S}_CET, which means it's difficult to hide
> one feature from another in the case of SHSTK != IBT,
> after discussed in community, it's agreed to allow Guest
> control two features independently as it won't introduce
> security hole.
> 
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---

...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index db03d9dc1297..e392e818e7eb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -44,6 +44,7 @@
>  #include <asm/spec-ctrl.h>
>  #include <asm/virtext.h>
>  #include <asm/vmx.h>
> +#include <asm/cet.h>
>  
>  #include "capabilities.h"
>  #include "cpuid.h"
> @@ -2336,7 +2337,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	      VM_EXIT_LOAD_IA32_EFER |
>  	      VM_EXIT_CLEAR_BNDCFGS |
>  	      VM_EXIT_PT_CONCEAL_PIP |
> -	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
> +	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
> +	      VM_EXIT_LOAD_HOST_CET_STATE;
>  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
>  				&_vmexit_control) < 0)
>  		return -EIO;
> @@ -2360,7 +2362,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	      VM_ENTRY_LOAD_IA32_EFER |
>  	      VM_ENTRY_LOAD_BNDCFGS |
>  	      VM_ENTRY_PT_CONCEAL_PIP |
> -	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
> +	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
> +	      VM_ENTRY_LOAD_GUEST_CET_STATE;
>  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
>  				&_vmentry_control) < 0)
>  		return -EIO;
> @@ -2834,6 +2837,9 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long hw_cr0;
>  
> +	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
> +		cr0 |= X86_CR0_WP;

Huh?  What's the interaction between CR4.CET and CR0.WP?  If there really
is some non-standard interaction then it needs to be documented in at least
the changelog and probably with a comment as well.

> +
>  	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);
>  	if (enable_unrestricted_guest)
>  		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
> @@ -2936,6 +2942,22 @@ static bool guest_cet_allowed(struct kvm_vcpu *vcpu, u32 feature, u32 mode)
>  	return false;
>  }
>  
> +bool is_cet_bit_allowed(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long cr0;
> +	bool cet_allowed;
> +
> +	cr0 = kvm_read_cr0(vcpu);
> +	cet_allowed = guest_cet_allowed(vcpu, X86_FEATURE_SHSTK,
> +					XFEATURE_MASK_CET_USER) ||
> +		      guest_cet_allowed(vcpu, X86_FEATURE_IBT,
> +					XFEATURE_MASK_CET_USER);
> +	if ((cr0 & X86_CR0_WP) && cet_allowed)
> +		return true;

So, attempting to set CR4.CET if CR0.WP=0 takes a #GP?  But attempting
to clear CR0.WP if CR4.CET=1 is ignored?

> +
> +	return false;
> +}
> +
>  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -2976,6 +2998,9 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  			return 1;
>  	}
>  
> +	if ((cr4 & X86_CR4_CET) && !is_cet_bit_allowed(vcpu))
> +		return 1;
> +
>  	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
>  		return 1;
>  
> @@ -3839,6 +3864,12 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
>  
>  	if (cpu_has_load_ia32_efer())
>  		vmcs_write64(HOST_IA32_EFER, host_efer);
> +
> +	if (cpu_has_load_host_cet_states_ctrl()) {
> +		vmcs_writel(HOST_S_CET, 0);
> +		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
> +		vmcs_writel(HOST_SSP, 0);
> +	}
>  }
>  
>  void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
> @@ -6436,6 +6467,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long cr3, cr4;
> +	bool cet_allowed;
>  
>  	/* Record the guest's net vcpu time for enforced NMI injections. */
>  	if (unlikely(!enable_vnmi &&
> @@ -6466,6 +6498,25 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  		vmx->loaded_vmcs->host_state.cr3 = cr3;
>  	}
>  
> +	/* To be aligned with kernel code, only user mode is supported now. */
> +	cet_allowed = guest_cet_allowed(vcpu, X86_FEATURE_SHSTK,
> +					XFEATURE_MASK_CET_USER) ||
> +		      guest_cet_allowed(vcpu, X86_FEATURE_IBT,
> +					XFEATURE_MASK_CET_USER);
> +	if (cpu_has_load_guest_cet_states_ctrl() && cet_allowed)
> +		vmcs_set_bits(VM_ENTRY_CONTROLS,
> +			      VM_ENTRY_LOAD_GUEST_CET_STATE);
> +	else
> +		vmcs_clear_bits(VM_ENTRY_CONTROLS,
> +				VM_ENTRY_LOAD_GUEST_CET_STATE);
> +
> +	if (cpu_has_load_host_cet_states_ctrl() && cet_allowed)
> +		vmcs_set_bits(VM_EXIT_CONTROLS,
> +			      VM_EXIT_LOAD_HOST_CET_STATE);
> +	else
> +		vmcs_clear_bits(VM_EXIT_CONTROLS,
> +				VM_EXIT_LOAD_HOST_CET_STATE);
> +
>  	cr4 = cr4_read_shadow();
>  	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
>  		vmcs_writel(HOST_CR4, cr4);
> -- 
> 2.17.2
> 
