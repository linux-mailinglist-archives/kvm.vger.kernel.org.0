Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9F91C1ECE
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 22:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgEAUpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 16:45:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:59032 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgEAUpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 16:45:54 -0400
IronPort-SDR: OIppLwfTTqP32bZliSYwOFZ+ngcDRNl38S+XuGJshH+7B5hU8tWCRP0PJwbzKD5+DjS7iyfzQZ
 B+Y/AbbhSlcQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 13:45:53 -0700
IronPort-SDR: RMSJYqcQrQ1HIBlEZeL0qVYhE7fB3lBsXaT0dSHRSewub7z24Oy39QW6fY+LRf0xAX7T6ozb5s
 ZAyojy664rXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="460023847"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 01 May 2020 13:45:52 -0700
Date:   Fri, 1 May 2020 13:45:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Forrest Yuan Yu <yuanyu@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH RFC 1/1] KVM: x86: add KVM_HC_UCALL hypercall
Message-ID: <20200501204552.GD4760@linux.intel.com>
References: <20200501185147.208192-1-yuanyu@google.com>
 <20200501185147.208192-2-yuanyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501185147.208192-2-yuanyu@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 11:51:47AM -0700, Forrest Yuan Yu wrote:
> The purpose of this new hypercall is to exchange message between
> guest and hypervisor. For example, a guest may want to ask hypervisor
> to harden security by setting restricted access permission on guest
> SLAT entry. In this case, the guest can use this hypercall to send

Please do s/SLAT/TDP everywhere.  IMO, TDP is a less than stellar acronym,
e.g. what will we do if we go to three dimensions!?!?  But, we're stuck
with it :-)

> a message to the hypervisor which will do its job and send back
> anything it wants the guest to know.

Hrm, so this reintroduces KVM_EXIT_HYPERCALL without justifying _why_ it
needs to be reintroduced.  I'm not familiar with the history, but the
comments in the documentation advise "use KVM_EXIT_IO or KVM_EXIT_MMIO".

Off the top of my head, IO and/or MMIO has a few advantages:

  - Allows the guest kernel to delegate permissions to guest userspace,
    whereas KVM restrict hypercalls to CPL0.
  - Allows "pass-through", whereas VMCALL is unconditionally forwarded to
    L1.
  - Is vendor agnostic, e.g. VMX and SVM recognized different opcodes for
    VMCALL vs VMMCALL.
 
> Signed-off-by: Forrest Yuan Yu <yuanyu@google.com>
> ---
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index 01b081f6e7ea..ff313f6827bf 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -86,6 +86,9 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>                                                before using paravirtualized
>                                                sched yield.
>  
> +KVM_FEATURE_UCALL                 14          guest checks this feature bit
> +                                              before calling hypercall ucall.

Why make the UCALL a KVM CPUID feature?  I can understand wanting to query
KVM support from host userspace, but presumably the guest will care about
capabiliteis built on top of the UCALL, not the UCALL itself.

> +
>  KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                per-cpu warps are expeced in
>                                                kvmclock
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c5835f9cb9ad..388a4f89464d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3385,6 +3385,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_GET_MSR_FEATURES:
>  	case KVM_CAP_MSR_PLATFORM_INFO:
>  	case KVM_CAP_EXCEPTION_PAYLOAD:
> +	case KVM_CAP_UCALL:

For whatever reason I have a metnal block with UCALL, can we call this
KVM_CAP_USERSPACE_HYPERCALL

>  		r = 1;
>  		break;
>  	case KVM_CAP_SYNC_REGS:
> @@ -4895,6 +4896,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		kvm->arch.exception_payload_enabled = cap->args[0];
>  		r = 0;
>  		break;
> +	case KVM_CAP_UCALL:
> +		kvm->arch.hypercall_ucall_enabled = cap->args[0];
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -7554,6 +7559,19 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
>  		kvm_vcpu_yield_to(target);
>  }
>  
> +static int complete_hypercall(struct kvm_vcpu *vcpu)
> +{
> +	u64 ret = vcpu->run->hypercall.ret;
> +
> +	if (!is_64_bit_mode(vcpu))

Do we really anticipate adding support in 32-bit guests?  Honest question.

> +		ret = (u32)ret;
> +	kvm_rax_write(vcpu, ret);
> +
> +	++vcpu->stat.hypercalls;
> +
> +	return kvm_skip_emulated_instruction(vcpu);
> +}
> +
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long nr, a0, a1, a2, a3, ret;
> @@ -7605,17 +7623,26 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		kvm_sched_yield(vcpu->kvm, a0);
>  		ret = 0;
>  		break;
> +	case KVM_HC_UCALL:
> +		if (vcpu->kvm->arch.hypercall_ucall_enabled) {
> +			vcpu->run->hypercall.nr = nr;
> +			vcpu->run->hypercall.args[0] = a0;
> +			vcpu->run->hypercall.args[1] = a1;
> +			vcpu->run->hypercall.args[2] = a2;
> +			vcpu->run->hypercall.args[3] = a3;

If performance is a justification for a more direct userspace exit, why
limit it to just four parameters?  E.g. why not copy all registers to
kvm_sync_regs and reverse the process on the way back in?

> +			vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
> +			vcpu->arch.complete_userspace_io = complete_hypercall;
> +			return 0; // message is going to userspace
> +		}
> +		ret = -KVM_ENOSYS;
> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
>  	}
>  out:
> -	if (!op_64_bit)
> -		ret = (u32)ret;
> -	kvm_rax_write(vcpu, ret);
> -
> -	++vcpu->stat.hypercalls;
> -	return kvm_skip_emulated_instruction(vcpu);
> +	vcpu->run->hypercall.ret = ret;
> +	return complete_hypercall(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
