Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952601B7857
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 16:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgDXOdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 10:33:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:7544 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgDXOdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 10:33:11 -0400
IronPort-SDR: G0KmGyhhepGDusXNnU4v0U3Oti5v/cgASRQuH8mSm5wVXRXEi7OoJqLNS08Aa5P3qttU/5HeUU
 Mx4/3fbTWhaw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 07:33:11 -0700
IronPort-SDR: sMwyW81kwAtGr4NBexWDLf3iM00OgV/pJ1yJpqwqlxdkeXCwSQPf1m9nFUijs+1oyBujInUiRW
 U03BwhmO7Ztg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="301559150"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Apr 2020 07:33:09 -0700
Date:   Fri, 24 Apr 2020 22:35:10 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 3/9] KVM: VMX: Set host/guest CET states for
 vmexit/vmentry
Message-ID: <20200424143510.GH24039@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-4-weijiang.yang@intel.com>
 <20200423171741.GH17824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423171741.GH17824@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 10:17:41AM -0700, Sean Christopherson wrote:
> On Thu, Mar 26, 2020 at 04:18:40PM +0800, Yang Weijiang wrote:
> > "Load {guest,host} CET state" bit controls whether guest/host
> > CET states will be loaded at VM entry/exit.
> > Set default host kernel CET states to 0s in VMCS to avoid guest
> > CET states leakage. When CR4.CET is cleared due to guest mode
> > change, make guest CET states invalid in VMCS, this can happen,
> > e.g., guest reboot.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/capabilities.h | 10 ++++++
> >  arch/x86/kvm/vmx/vmx.c          | 56 +++++++++++++++++++++++++++++++--
> >  2 files changed, 63 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> > index 8903475f751e..565340352260 100644
> > --- a/arch/x86/kvm/vmx/capabilities.h
> > +++ b/arch/x86/kvm/vmx/capabilities.h
> > @@ -107,6 +107,16 @@ static inline bool cpu_has_vmx_mpx(void)
> >  		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
> >  }
> >  
> > +static inline bool cpu_has_cet_guest_load_ctrl(void)
> > +{
> > +	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +}
> > +
> > +static inline bool cpu_has_cet_host_load_ctrl(void)
> > +{
> > +	return (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_HOST_CET_STATE);
> > +}
> 
> We should bundle these together, same as we do for PERF_GLOBAL_CTRL.  Not
> just for code clarity, but also for functionality, e.g. if KVM ends up on a
> frankenstein CPU with VM_ENTRY_LOAD_CET_STATE and !VM_EXIT_LOAD_CET_STATE
> then KVM will end up running with guest state.  This is also an argument
> for not qualifying the control names with GUEST vs. HOST.
Cannot agree with you more! Thank you!
Will fix them.

> > +
> >  static inline bool cpu_has_vmx_tpr_shadow(void)
> >  {
> >  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -3110,6 +3119,12 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
> >  	}
> >  
> > +	if (!(hw_cr4 & X86_CR4_CET) && is_cet_supported(vcpu)) {
> > +		vmcs_writel(GUEST_SSP, 0);
> > +		vmcs_writel(GUEST_S_CET, 0);
> > +		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
> 
> Can't we simply toggle the VM_{ENTRY,EXIT}_LOAD controls?  If CR4.CET=0 in
> the guest, then presumably keeping host state loaded is ok?  I.e. won't
> leak host information to the guest.
>
Yes, it's doable, let me change it.

> > +	}
> > +
> >  	vmcs_writel(CR4_READ_SHADOW, cr4);
> >  	vmcs_writel(GUEST_CR4, hw_cr4);
> >  	return 0;
> > @@ -3939,6 +3954,12 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
> >  
> >  	if (cpu_has_load_ia32_efer())
> >  		vmcs_write64(HOST_IA32_EFER, host_efer);
> > +
> > +	if (cpu_has_cet_host_load_ctrl()) {
> > +		vmcs_writel(HOST_S_CET, 0);
> > +		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
> > +		vmcs_writel(HOST_SSP, 0);
> 
> This is unnecessary, the VMCS is zeroed on allocation.
> 
> And IIUC, this is only correct because the main shadow stack enabling only
> adds user support.  Assuming that's correct, (a) it absolutely needs to be
> called out in the changelog and (b) KVM needs a WARN in hardware_setup() to
> guard against kernel shadow stack support being added without updating KVM,
> e.g. something this (not sure the MSRs are correct):
> 
> 	if (boot_cpu_has(X86_FEATURE_IBT) || boot_cpu_has(X86_FEATURE_SHSTK)) {
> 		rdmsrl(MSR_IA32_S_CET, cet_msr);
> 		WARN_ONCE(cet_msr, "KVM: S_CET in host will be lost");
> 
> 	}
> 	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
> 		rdmsrl(MSR_IA32_PL0_SSP, cet_msr);
> 		WARN_ONCE(cet_msr, "KVM: PL0_SPP in host will be lost");
> 	}
> 
Yes, just wanted to make host CET stuffs invalid before kernel mode
CET is available. OK, will follow your advice, thanks!

> > +	}
> >  }

> >  /*
> > @@ -7140,8 +7175,23 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> >  	}
> >  
> >  	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > -	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> > +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
> >  		vmx_update_intercept_for_cet_msr(vcpu);
> > +
> > +		if (cpu_has_cet_guest_load_ctrl() && is_cet_supported(vcpu))
> > +			vm_entry_controls_setbit(to_vmx(vcpu),
> > +						 VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +		else
> > +			vm_entry_controls_clearbit(to_vmx(vcpu),
> > +						   VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +
> > +		if (cpu_has_cet_host_load_ctrl() && is_cet_supported(vcpu))
> > +			vm_exit_controls_setbit(to_vmx(vcpu),
> > +						VM_EXIT_LOAD_HOST_CET_STATE);
> > +		else
> > +			vm_exit_controls_clearbit(to_vmx(vcpu),
> > +						  VM_EXIT_LOAD_HOST_CET_STATE);
> 
> As above, I think this can be done in vmx_set_cr4().
>
Hmm, it's in vmx_set_cr4() in early versions, OK, will move them back.

> > +	}
> >  }
> >  
> >  static __init void vmx_set_cpu_caps(void)
> > -- 
> > 2.17.2
> > 
