Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5167E13CA8B
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 18:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgAORNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 12:13:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:28601 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728909AbgAORNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 12:13:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2020 09:13:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,323,1574150400"; 
   d="scan'208";a="225639100"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 15 Jan 2020 09:13:20 -0800
Date:   Wed, 15 Jan 2020 09:13:20 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: Check GUEST_DR7 on vmentry of nested
 guests
Message-ID: <20200115171320.GA30449@linux.intel.com>
References: <20200115012541.8904-1-krish.sadhukhan@oracle.com>
 <20200115012541.8904-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115012541.8904-2-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 14, 2020 at 08:25:40PM -0500, Krish Sadhukhan wrote:
> According to section "Checks on Guest Control Registers, Debug Registers, and
> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> of nested guests:
> 
>     If the "load debug controls" VM-entry control is 1, bits 63:32 in the DR7
>     field must be 0.

Please explain *why* the check is being added to KVM.  Quoting the SDM is
very helpful in proving the correctness of the code, but it doesn't provide
any insight into why a guest field is being checked in software.  A tweaked
version of Jim's anaylsis from v1[*] would be perfect.

https://lkml.kernel.org/r/CALMp9eR2GQ_aerH-arOEpa08k8ZdtYCA5ftxHfDCo5fS1r3VtA@mail.gmail.com

> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 ++++++
>  arch/x86/kvm/x86.c        | 2 +-
>  arch/x86/kvm/x86.h        | 6 ++++++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4aea7d304beb..acde8a2f13e2 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2899,6 +2899,12 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
>  		return -EINVAL;
>  
> +#ifdef CONFIG_X86_64

Hmm, I'd prefer not to wrap this with CONFIG_X86_64.  From an architectural
perspective, the consistency check is performed if the CPU *supports* long
mode, irrespective of whether the CPU is actually in long mode.  KVM could
technically do something like static_cpu_has(X86_FEATURE_LM), but that's a
waste of code for everyone except the 0.00000000000001% of the population
running on Yonah, and nested 32-bit on 64-bit already fudges things with
respect to 64-bit CPU behavior.

Functionally, it'll be the same end result (and possibly a waste of cycles
on 32-bit KVM if the compiler doesn't optimize out kvm_dr7_valid()) as
having the CONFIG_X86_64 since kvm_dr7_valid() will always return true on
32-bit KVM (assuming @data is changed to an unsigned long).

Architecturally, 32-bit KVM on 64-bit harware is already in a grey area,
e.g. hardware VM-Entry still performs checks like GUEST_DR7[63:32]!=0,
they just can't fail on 32-bit KVM because KVM's VMWRITE to propgate
vmcs12->guest_dr7 to vmcs02.GUEST_DR7 will drop bits 63:32.

In other words, it's not an issue of functionality, I'd just prefer to keep
keep the constency checks themselves aligned with the SDM.

> +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> +	    !kvm_dr7_valid(vmcs12->guest_dr7))

Wrap !kvm_dr7_valid() with CC() so that it's traced.

> +		return -EINVAL;
> +#endif
> +
>  	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
>  	    CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
>  		return -EINVAL;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cf917139de6b..220f20a2f9c3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1064,7 +1064,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>  	case 5:
>  		/* fall through */
>  	default: /* 7 */
> -		if (val & 0xffffffff00000000ULL)
> +		if (!kvm_dr7_valid(val))
>  			return -1; /* #GP */
>  		vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
>  		kvm_update_dr7(vcpu);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 29391af8871d..76cd389ecf60 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -369,6 +369,12 @@ static inline bool kvm_pat_valid(u64 data)
>  	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
>  }
>  
> +static inline bool kvm_dr7_valid(u64 data)

Per Jim's feedback on v1, @data should be "unsigned long".

> +{
> +	/* Bits [63:32] are reserved */
> +	return ((data & 0xFFFFFFFF00000000ull) ? false : true);

Per Jim's feedback in v1, the ternary operator and second set of
parantheses are unnecessary.

	return !(data & 0xFFFFFFFF00000000ull);

or

	return data == (u32)data;

or

	return !(data >> 32);

I prefer the last one because (IMO) it's easier to visually parse than the
"& 0xFF..." variant and more explicit in what it's doing than the casting
variant.

> +}
> +
>  void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>  
> -- 
> 2.20.1
> 
