Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0228B4047
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 20:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390342AbfIPS1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 14:27:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:41081 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfIPS1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 14:27:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 11:27:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,513,1559545200"; 
   d="scan'208";a="180524098"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 16 Sep 2019 11:27:07 -0700
Date:   Mon, 16 Sep 2019 11:27:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v4 6/9] KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL vm
 control if supported
Message-ID: <20190916182707.GJ18871@linux.intel.com>
References: <20190906210313.128316-1-oupton@google.com>
 <20190906210313.128316-7-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906210313.128316-7-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 06, 2019 at 02:03:10PM -0700, Oliver Upton wrote:
> The "load IA32_PERF_GLOBAL_CTRL" bit for VM-entry and VM-exit should
> only be exposed to the guest if IA32_PERF_GLOBAL_CTRL is a valid MSR.
> Create a new helper to allow pmu_refresh() to update the VM-entry and
> VM-exit controls to ensure PMU values are initialized when performing
> the is_valid_msr() check.

Can you describe how this is functionally correct?  At a glance, it looks
like KVM already handles PERF_GLOBAL_CTRL, this is just allowing it to be
loaded via VMX transitions?  Assuming that's true, including such info in
the changelog is extremely helpful, e.g. to differentiate between a minor
enhancement and a significant addition to what KVM virtualizes.

> Suggested-by: Jim Mattson <jmattson@google.com>
> Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c |  3 +++
>  arch/x86/kvm/vmx/vmx.c       | 21 +++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h       |  1 +

Can the helper be placed in nested.{c.h} instead of vmx.{c,h}?

>  3 files changed, 25 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 963766d631ad..2dc7be724321 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -16,6 +16,7 @@
>  #include "cpuid.h"
>  #include "lapic.h"
>  #include "pmu.h"
> +#include "vmx.h"
>  
>  static struct kvm_event_hw_type_mapping intel_arch_events[] = {
>  	/* Index must match CPUID 0x0A.EBX bit vector */
> @@ -314,6 +315,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
>  	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
>  		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
> +
> +	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
>  }
>  
>  static void intel_pmu_init(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 570a233e272b..5b0664bff23b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6417,6 +6417,27 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
>  	}
>  }
>  
> +void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx;
> +
> +	if (!nested_vmx_allowed(vcpu))
> +		return;
> +
> +	vmx = to_vmx(vcpu);
> +	if (intel_pmu_ops.is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
> +		vmx->nested.msrs.entry_ctls_high |=
> +				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		vmx->nested.msrs.exit_ctls_high |=
> +				VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +	} else {
> +		vmx->nested.msrs.entry_ctls_high &=
> +				~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		vmx->nested.msrs.exit_ctls_high &=
> +				~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +	}
> +}
> +
>  bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
>  
>  static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 82d0bc3a4d52..e06884cf88ad 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -331,6 +331,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
>  void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
>  void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
> +void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
>  
>  #define POSTED_INTR_ON  0
>  #define POSTED_INTR_SN  1
> -- 
> 2.23.0.187.g17f5b7556c-goog
> 
