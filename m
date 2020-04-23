Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7BB1B61BC
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 19:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgDWRRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 13:17:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:37894 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729674AbgDWRRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 13:17:42 -0400
IronPort-SDR: 7i1e5Sa6H8R66NFHCf4IXGujrWcRzd9MiN4kyYSqf8WnXLujl+/8WbBHAlDpkaFmoZFH/h8nEl
 c4OnF3Ad1kmQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 10:17:41 -0700
IronPort-SDR: C+8HqkNbpAo+alPpmne6o+k4Lgva2d2a6YQM2ry7arMhr5vHJtuva2K8phzlVyCLjhdZw6/m5Q
 kpUpfSR7OCOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="457574661"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 23 Apr 2020 10:17:41 -0700
Date:   Thu, 23 Apr 2020 10:17:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 3/9] KVM: VMX: Set host/guest CET states for
 vmexit/vmentry
Message-ID: <20200423171741.GH17824@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-4-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326081847.5870-4-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 04:18:40PM +0800, Yang Weijiang wrote:
> "Load {guest,host} CET state" bit controls whether guest/host
> CET states will be loaded at VM entry/exit.
> Set default host kernel CET states to 0s in VMCS to avoid guest
> CET states leakage. When CR4.CET is cleared due to guest mode
> change, make guest CET states invalid in VMCS, this can happen,
> e.g., guest reboot.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/capabilities.h | 10 ++++++
>  arch/x86/kvm/vmx/vmx.c          | 56 +++++++++++++++++++++++++++++++--
>  2 files changed, 63 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 8903475f751e..565340352260 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -107,6 +107,16 @@ static inline bool cpu_has_vmx_mpx(void)
>  		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
>  }
>  
> +static inline bool cpu_has_cet_guest_load_ctrl(void)
> +{
> +	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_GUEST_CET_STATE);
> +}
> +
> +static inline bool cpu_has_cet_host_load_ctrl(void)
> +{
> +	return (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_HOST_CET_STATE);
> +}

We should bundle these together, same as we do for PERF_GLOBAL_CTRL.  Not
just for code clarity, but also for functionality, e.g. if KVM ends up on a
frankenstein CPU with VM_ENTRY_LOAD_CET_STATE and !VM_EXIT_LOAD_CET_STATE
then KVM will end up running with guest state.  This is also an argument
for not qualifying the control names with GUEST vs. HOST.

> +
>  static inline bool cpu_has_vmx_tpr_shadow(void)
>  {
>  	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_TPR_SHADOW;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1aca468d9a10..bd7cd175fd81 100644
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
> @@ -2456,7 +2457,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	      VM_EXIT_LOAD_IA32_EFER |
>  	      VM_EXIT_CLEAR_BNDCFGS |
>  	      VM_EXIT_PT_CONCEAL_PIP |
> -	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
> +	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
> +	      VM_EXIT_LOAD_HOST_CET_STATE;
>  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
>  				&_vmexit_control) < 0)
>  		return -EIO;
> @@ -2480,7 +2482,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	      VM_ENTRY_LOAD_IA32_EFER |
>  	      VM_ENTRY_LOAD_BNDCFGS |
>  	      VM_ENTRY_PT_CONCEAL_PIP |
> -	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
> +	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
> +	      VM_ENTRY_LOAD_GUEST_CET_STATE;
>  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
>  				&_vmentry_control) < 0)
>  		return -EIO;
> @@ -3040,6 +3043,12 @@ static bool is_cet_mode_allowed(struct kvm_vcpu *vcpu, u32 mode_mask)
>  		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));
>  }
>  
> +static bool is_cet_supported(struct kvm_vcpu *vcpu)
> +{
> +	return is_cet_mode_allowed(vcpu, XFEATURE_MASK_CET_USER |
> +				   XFEATURE_MASK_CET_KERNEL);
> +}
> +
>  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -3110,6 +3119,12 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
>  	}
>  
> +	if (!(hw_cr4 & X86_CR4_CET) && is_cet_supported(vcpu)) {
> +		vmcs_writel(GUEST_SSP, 0);
> +		vmcs_writel(GUEST_S_CET, 0);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);

Can't we simply toggle the VM_{ENTRY,EXIT}_LOAD controls?  If CR4.CET=0 in
the guest, then presumably keeping host state loaded is ok?  I.e. won't
leak host information to the guest.

> +	}
> +
>  	vmcs_writel(CR4_READ_SHADOW, cr4);
>  	vmcs_writel(GUEST_CR4, hw_cr4);
>  	return 0;
> @@ -3939,6 +3954,12 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
>  
>  	if (cpu_has_load_ia32_efer())
>  		vmcs_write64(HOST_IA32_EFER, host_efer);
> +
> +	if (cpu_has_cet_host_load_ctrl()) {
> +		vmcs_writel(HOST_S_CET, 0);
> +		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
> +		vmcs_writel(HOST_SSP, 0);

This is unnecessary, the VMCS is zeroed on allocation.

And IIUC, this is only correct because the main shadow stack enabling only
adds user support.  Assuming that's correct, (a) it absolutely needs to be
called out in the changelog and (b) KVM needs a WARN in hardware_setup() to
guard against kernel shadow stack support being added without updating KVM,
e.g. something this (not sure the MSRs are correct):

	if (boot_cpu_has(X86_FEATURE_IBT) || boot_cpu_has(X86_FEATURE_SHSTK)) {
		rdmsrl(MSR_IA32_S_CET, cet_msr);
		WARN_ONCE(cet_msr, "KVM: S_CET in host will be lost");

	}
	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
		rdmsrl(MSR_IA32_PL0_SSP, cet_msr);
		WARN_ONCE(cet_msr, "KVM: PL0_SPP in host will be lost");
	}

> +	}
>  }
>  
>  void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
> @@ -5749,6 +5770,13 @@ void dump_vmcs(void)
>  		pr_err("InterruptStatus = %04x\n",
>  		       vmcs_read16(GUEST_INTR_STATUS));
>  
> +	if (vmentry_ctl & VM_ENTRY_LOAD_GUEST_CET_STATE) {
> +		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
> +		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
> +		pr_err("SSP TABLE = 0x%016lx\n",
> +		       vmcs_readl(GUEST_INTR_SSP_TABLE));
> +	}
> +
>  	pr_err("*** Host State ***\n");
>  	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
>  	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
> @@ -5831,6 +5859,13 @@ void dump_vmcs(void)
>  	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
>  		pr_err("Virtual processor ID = 0x%04x\n",
>  		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
> +	if (vmexit_ctl & VM_EXIT_LOAD_HOST_CET_STATE) {
> +		pr_err("S_CET = 0x%016lx\n", vmcs_readl(HOST_S_CET));
> +		pr_err("SSP = 0x%016lx\n", vmcs_readl(HOST_SSP));
> +		pr_err("SSP TABLE = 0x%016lx\n",
> +		       vmcs_readl(HOST_INTR_SSP_TABLE));
> +	}
> +
>  }
>  
>  /*
> @@ -7140,8 +7175,23 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> -	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
>  		vmx_update_intercept_for_cet_msr(vcpu);
> +
> +		if (cpu_has_cet_guest_load_ctrl() && is_cet_supported(vcpu))
> +			vm_entry_controls_setbit(to_vmx(vcpu),
> +						 VM_ENTRY_LOAD_GUEST_CET_STATE);
> +		else
> +			vm_entry_controls_clearbit(to_vmx(vcpu),
> +						   VM_ENTRY_LOAD_GUEST_CET_STATE);
> +
> +		if (cpu_has_cet_host_load_ctrl() && is_cet_supported(vcpu))
> +			vm_exit_controls_setbit(to_vmx(vcpu),
> +						VM_EXIT_LOAD_HOST_CET_STATE);
> +		else
> +			vm_exit_controls_clearbit(to_vmx(vcpu),
> +						  VM_EXIT_LOAD_HOST_CET_STATE);

As above, I think this can be done in vmx_set_cr4().

> +	}
>  }
>  
>  static __init void vmx_set_cpu_caps(void)
> -- 
> 2.17.2
> 
