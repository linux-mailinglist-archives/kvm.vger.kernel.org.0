Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0DE178CDB
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 09:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387758AbgCDIwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 03:52:11 -0500
Received: from mga07.intel.com ([134.134.136.100]:16742 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgCDIwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 03:52:11 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 00:52:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,513,1574150400"; 
   d="scan'208";a="240388574"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 04 Mar 2020 00:52:07 -0800
Date:   Wed, 4 Mar 2020 16:55:37 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v9 4/7] KVM: VMX: Load CET states on vmentry/vmexit
Message-ID: <20200304085537.GC5831@local-michael-cet-test.sh.intel.com>
References: <20191227021133.11993-1-weijiang.yang@intel.com>
 <20191227021133.11993-5-weijiang.yang@intel.com>
 <20200303220618.GB1439@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303220618.GB1439@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 02:06:18PM -0800, Sean Christopherson wrote:
> On Fri, Dec 27, 2019 at 10:11:30AM +0800, Yang Weijiang wrote:
> > "Load {guest,host} CET state" bit controls whether guest/host
> > CET states will be loaded at VM entry/exit. Before doing that,
> > KVM needs to check if CET can be enabled both on host and guest.
> > 
> > Note:
> > 1)The processor does not allow CR4.CET to be set if CR0.WP = 0,
> >   similarly, it does not allow CR0.WP to be cleared while CR4.CET = 1.
> >   In either case, KVM would inject #GP to guest.
> > 
> > 2)SHSTK and IBT features share one control MSR:
> >   MSR_IA32_{U,S}_CET, which means it's difficult to hide
> >   one feature from another in the case of SHSTK != IBT,
> >   after discussed in community, it's agreed to allow Guest
> >   control two features independently as it won't introduce
> >   security hole.
> > 
> > Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/capabilities.h | 10 ++++++
> >  arch/x86/kvm/vmx/vmx.c          | 56 +++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/x86.c              |  3 ++
> >  3 files changed, 67 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> > index 7aa69716d516..4a67d35a42a2 100644
> > --- a/arch/x86/kvm/vmx/capabilities.h
> > +++ b/arch/x86/kvm/vmx/capabilities.h
> > @@ -106,6 +106,16 @@ static inline bool vmx_mpx_supported(void)
> >  		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
> >  }
> >  
> > +static inline bool cpu_has_load_guest_cet_states_ctrl(void)
> > +{
> > +	return ((vmcs_config.vmentry_ctrl) & VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +}
> > +
> > +static inline bool cpu_has_load_host_cet_states_ctrl(void)
> > +{
> > +	return ((vmcs_config.vmexit_ctrl) & VM_EXIT_LOAD_HOST_CET_STATE);
> 
> No need for parantheses around vmcs_config.vmexit_ctrl.
> 
> > +}
> > +
> >  static inline bool cpu_has_vmx_tpr_shadow(void)
> >  {
> >  	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_TPR_SHADOW;
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 61fc846c7ef3..95063cc7da89 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -44,6 +44,7 @@
> >  #include <asm/spec-ctrl.h>
> >  #include <asm/virtext.h>
> >  #include <asm/vmx.h>
> > +#include <asm/cet.h>
> >  
> >  #include "capabilities.h"
> >  #include "cpuid.h"
> > @@ -2445,7 +2446,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> >  	      VM_EXIT_LOAD_IA32_EFER |
> >  	      VM_EXIT_CLEAR_BNDCFGS |
> >  	      VM_EXIT_PT_CONCEAL_PIP |
> > -	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
> > +	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
> > +	      VM_EXIT_LOAD_HOST_CET_STATE;
> >  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
> >  				&_vmexit_control) < 0)
> >  		return -EIO;
> > @@ -2469,7 +2471,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> >  	      VM_ENTRY_LOAD_IA32_EFER |
> >  	      VM_ENTRY_LOAD_BNDCFGS |
> >  	      VM_ENTRY_PT_CONCEAL_PIP |
> > -	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
> > +	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
> > +	      VM_ENTRY_LOAD_GUEST_CET_STATE;
> >  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
> >  				&_vmentry_control) < 0)
> >  		return -EIO;
> > @@ -3027,6 +3030,25 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >  	vmcs_writel(GUEST_CR3, guest_cr3);
> >  }
> >  
> > +bool is_cet_bit_allowed(struct kvm_vcpu *vcpu)
> 
> This should be static.  I'd also include cr4 in the name, e.g.
> 
>   static bool is_cr4_set_allowed(...)
> 
>
Got it, thank you!
> > +{
> > +	u64 kvm_xss = kvm_supported_xss();
> > +	unsigned long cr0;
> > +	bool cet_allowed;
> > +
> > +	cr0 = kvm_read_cr0(vcpu);
> > +
> > +	/* Right now, only user-mode CET is supported.*/
> > +	cet_allowed = (kvm_xss & XFEATURE_MASK_CET_USER) &&
> > +		      (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > +		      guest_cpuid_has(vcpu, X86_FEATURE_IBT));
> 
> Probably makes sense to add a "is_cet_supported()" helper.  That'd reduce
> the amount of copy+paste and would probably add clarity to most flows.

Good suggestion, wrapping the code in a helper looks better :-)
> 
> > +
> > +	if ((cr0 & X86_CR0_WP) && cet_allowed)
> > +		return true;
> > +
> > +	return false;
> 
> 	return (cr0 & X86_CR0_WP) && cet_allowed;
> 
> Even better, especially if you add is_cet_supported(), to avoid VMREAD of
> CR0 when CET isn't supported.
> 
> 	return is_cet_supported() && (kvm_read_cr0(vcpu) & X86_CR0_WP);
> 
> At that point, you can probably even forgo the helper, e.g.
> 
> 	if ((cr4 & X86_CR4_CET) &&
> 	    (!is_cet_supported() || !(kvm_read_cr0(vcpu) & X86_CR0_WP)))
> 		return 1;
> 
OK, will tweak the code, thank you!
> > +}
> > +
> >  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -3067,6 +3089,9 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  			return 1;
> >  	}
> >  
> > +	if ((cr4 & X86_CR4_CET) && !is_cet_bit_allowed(vcpu))
> > +		return 1;
> > +
> >  	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
> >  		return 1;
> >  
> > @@ -3930,6 +3955,12 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
> >  
> >  	if (cpu_has_load_ia32_efer())
> >  		vmcs_write64(HOST_IA32_EFER, host_efer);
> > +
> > +	if (cpu_has_load_host_cet_states_ctrl()) {
> > +		vmcs_writel(HOST_S_CET, 0);
> > +		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
> > +		vmcs_writel(HOST_SSP, 0);
> > +	}
> >  }
> >  
> >  void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
> > @@ -6499,7 +6530,9 @@ bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
> >  static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +	u64 kvm_xss = kvm_supported_xss();
> >  	unsigned long cr3, cr4;
> > +	bool cet_allowed;
> >  
> >  	/* Record the guest's net vcpu time for enforced NMI injections. */
> >  	if (unlikely(!enable_vnmi &&
> > @@ -6530,6 +6563,25 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  		vmx->loaded_vmcs->host_state.cr3 = cr3;
> >  	}
> >  
> > +	/* Right now, only user-mode CET is supported.*/
> > +	cet_allowed = (kvm_xss & XFEATURE_MASK_CET_USER) &&
> > +		      (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > +		      guest_cpuid_has(vcpu, X86_FEATURE_IBT));
> > +
> > +	if (cpu_has_load_guest_cet_states_ctrl() && cet_allowed)
> > +		vmcs_set_bits(VM_ENTRY_CONTROLS,
> > +			      VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +	else
> > +		vmcs_clear_bits(VM_ENTRY_CONTROLS,
> > +				VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +
> > +	if (cpu_has_load_host_cet_states_ctrl() && cet_allowed)
> > +		vmcs_set_bits(VM_EXIT_CONTROLS,
> > +			      VM_EXIT_LOAD_HOST_CET_STATE);
> > +	else
> > +		vmcs_clear_bits(VM_EXIT_CONTROLS,
> > +				VM_EXIT_LOAD_HOST_CET_STATE);
> 
> Why are you clearing VMCS bits in vmx_vcpu_run()?  Unless I'm missing
> something, these can go in vmx_cpuid_update().
Yes, I need to find a good place to do the work, thank you for pointing
it out.
> 
> > +
> >  	cr4 = cr4_read_shadow();
> >  	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
> >  		vmcs_writel(HOST_CR4, cr4);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a9b1140d0508..b27d97eaec24 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -788,6 +788,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> >  	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
> >  		return 1;
> >  
> > +	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
> > +		return 1;
> > +
> >  	kvm_x86_ops->set_cr0(vcpu, cr0);
> >  
> >  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
> > -- 
> > 2.17.2
> > 
