Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1D88BB9A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 16:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbfHMOfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 10:35:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:28349 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729404AbfHMOfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 10:35:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 07:35:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,381,1559545200"; 
   d="scan'208";a="170413157"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 13 Aug 2019 07:35:01 -0700
Date:   Tue, 13 Aug 2019 07:35:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nikita Leshenko <nikita.leshchenko@oracle.com>
Cc:     kvm@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH] KVM: nVMX: Check that HLT activity state is supported
Message-ID: <20190813143501.GA13991@linux.intel.com>
References: <20190813131303.137684-1-nikita.leshchenko@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813131303.137684-1-nikita.leshchenko@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 04:13:03PM +0300, Nikita Leshenko wrote:
> Fail VM entry if GUEST_ACTIVITY_HLT is unsupported. According to "SDM A.6 -
> Miscellaneous Data", VM entry should fail if the HLT activity is not marked as
> supported on IA32_VMX_MISC MSR.
> 
> Usermode might disable GUEST_ACTIVITY_HLT support in the vCPU with
> vmx_restore_vmx_misc(). Before this commit VM entries would have succeeded
> anyway.

Is there a use case for disabling GUEST_ACTIVITY_HLT?  Or can we simply
disallow writes to IA32_VMX_MISC that disable GUEST_ACTIVITY_HLT?

To disable GUEST_ACTIVITY_HLT, userspace also has to make
CPU_BASED_HLT_EXITING a "must be 1" control, otherwise KVM will be
presenting a bogus model to L1.

The bad model is visible to L1 if CPU_BASED_HLT_EXITING is set by L0,
i.e. KVM is running without kvm_hlt_in_guest(), and cleared by L1.  In
that case, a HLT from L2 will be handled in L0.  L0 will set the state to
KVM_MP_STATE_HALTED and report to L1 (on a nested VM-Exit, e.g. INTR),
that the activity state is GUEST_ACTIVITY_HLT, which from L1's perspective
doesn't exist.

> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 16 ++++++++++++----
>  arch/x86/kvm/vmx/nested.h |  5 +++++
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 46af3a5e9209..3165e2f7992f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2656,11 +2656,19 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
>  /*
>   * Checks related to Guest Non-register State
>   */
> -static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
> +static int nested_check_guest_non_reg_state(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  {
> -	if (vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE &&
> -	    vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT)
> +	switch (vmcs12->guest_activity_state) {
> +	case GUEST_ACTIVITY_ACTIVE:
> +		/* Always supported */
> +		break;
> +	case GUEST_ACTIVITY_HLT:
> +		if (!nested_cpu_has_activity_state_hlt(vcpu))
> +			return -EINVAL;
> +		break;
> +	default:
>  		return -EINVAL;
> +	}
>  
>  	return 0;
>  }
> @@ -2710,7 +2718,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  	     (vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD)))
>  		return -EINVAL;
>  
> -	if (nested_check_guest_non_reg_state(vmcs12))
> +	if (nested_check_guest_non_reg_state(vcpu, vmcs12))
>  		return -EINVAL;
>  
>  	return 0;
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index e847ff1019a2..4a294d3ff820 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -123,6 +123,11 @@ static inline bool nested_cpu_has_zero_length_injection(struct kvm_vcpu *vcpu)
>  	return to_vmx(vcpu)->nested.msrs.misc_low & VMX_MISC_ZERO_LEN_INS;
>  }
>  
> +static inline bool nested_cpu_has_activity_state_hlt(struct kvm_vcpu *vcpu)
> +{
> +	return to_vmx(vcpu)->nested.msrs.misc_low & VMX_MISC_ACTIVITY_HLT;
> +}
> +
>  static inline bool nested_cpu_supports_monitor_trap_flag(struct kvm_vcpu *vcpu)
>  {
>  	return to_vmx(vcpu)->nested.msrs.procbased_ctls_high &
> -- 
> 2.20.1
> 
