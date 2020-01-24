Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA80514791B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 09:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAXIAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 03:00:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:56308 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgAXIAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 03:00:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 00:00:19 -0800
X-IronPort-AV: E=Sophos;i="5.70,357,1574150400"; 
   d="scan'208";a="220948305"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.171.129]) ([10.249.171.129])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Jan 2020 00:00:17 -0800
Subject: Re: [PATCH] KVM: x86: avoid incorrect writes to host
 MSR_IA32_SPEC_CTRL
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@redhat.com>
References: <1579614487-44583-3-git-send-email-pbonzini@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <8b960dfe-620b-b649-d377-e5bb1556bb48@intel.com>
Date:   Fri, 24 Jan 2020 16:00:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579614487-44583-3-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/2020 9:48 PM, Paolo Bonzini wrote:
> If the guest is configured to have SPEC_CTRL but the host does not
> (which is a nonsensical configuration but these are not explicitly
> forbidden) then a host-initiated MSR write can write vmx->spec_ctrl
> (respectively svm->spec_ctrl) and trigger a #GP when KVM tries to
> restore the host value of the MSR.  Add a more comprehensive check
> for valid bits of SPEC_CTRL, covering host CPUID flags and,
> since we are at it and it is more correct that way, guest CPUID
> flags too.
> 
> For AMD, remove the unnecessary is_guest_mode check around setting
> the MSR interception bitmap, so that the code looks the same as
> for Intel.
> 
> Cc: Jim Mattson <jmattson@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm.c     |  9 +++------
>   arch/x86/kvm/vmx/vmx.c |  7 +++----
>   arch/x86/kvm/x86.c     | 22 ++++++++++++++++++++++
>   arch/x86/kvm/x86.h     |  1 +
>   4 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index b7c5369c7998..235a7e51de96 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -4324,12 +4324,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
>   			return 1;
>   
> -		/* The STIBP bit doesn't fault even if it's not advertised */
> -		if (data & ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD))
> +		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
>   			return 1;
>   
>   		svm->spec_ctrl = data;
> -
>   		if (!data)
>   			break;
>   
> @@ -4353,13 +4351,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   
>   		if (data & ~PRED_CMD_IBPB)
>   			return 1;
> -
> +		if (!boot_cpu_has(X86_FEATURE_AMD_IBPB))
> +			return 1;
>   		if (!data)
>   			break;
>   
>   		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
> -		if (is_guest_mode(vcpu))
> -			break;
>   		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
>   		break;
>   	case MSR_AMD64_VIRT_SPEC_CTRL:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bdbf27e92851..112d2314231d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1998,12 +1998,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
>   			return 1;
>   
> -		/* The STIBP bit doesn't fault even if it's not advertised */
> -		if (data & ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD))
> +		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
>   			return 1;
>   
>   		vmx->spec_ctrl = data;
> -
>   		if (!data)
>   			break;
>   
> @@ -2037,7 +2035,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   
>   		if (data & ~PRED_CMD_IBPB)
>   			return 1;
> -
> +		if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> +			return 1;
>   		if (!data)
>   			break;
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9f24f5d16854..141fb129c6bf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10389,6 +10389,28 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>   }
>   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>   
> +bool kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)

The return type should be u64.

> +{
> +	uint64_t bits = SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD;
> +
> +	/* The STIBP bit doesn't fault even if it's not advertised */
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS))
> +		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
> +	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
> +	    !boot_cpu_has(X86_FEATURE_AMD_IBRS))
> +		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
> +
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD) &&
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
> +		bits &= ~SPEC_CTRL_SSBD;
> +	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) &&
> +	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
> +		bits &= ~SPEC_CTRL_SSBD;
> +
> +	return bits;
> +}
> +EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
>   
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index ab715cee3653..bc38ac695776 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -367,5 +367,6 @@ static inline bool kvm_pat_valid(u64 data)
>   
>   void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>   void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
> +bool kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
>   
>   #endif
> 

