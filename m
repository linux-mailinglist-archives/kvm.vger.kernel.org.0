Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08171B350F
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 04:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgDVCgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 22:36:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:58101 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgDVCgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 22:36:03 -0400
IronPort-SDR: rcQQ8jISHmYDtZrNLGy9NP3lz87S93xhHHnRPmtqLlUKdGroyfKv+uMcynRq0IN+VehO+hLmJ7
 nOgA7Dr2X+Rw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 19:36:02 -0700
IronPort-SDR: KiEH+eCpJ+b1rvDh6nM1edRHIfKO2FwMXabHaZUZCSGpVa3qLtmyMs7AIq0s64hINoMJUjCR5p
 pZkZihwfxm6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,412,1580803200"; 
   d="scan'208";a="247341092"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 21 Apr 2020 19:36:02 -0700
Date:   Tue, 21 Apr 2020 19:36:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Subject: Re: [kvm PATCH 1/2] KVM: nVMX - enable VMX preemption timer migration
Message-ID: <20200422023601.GG17836@linux.intel.com>
References: <20200417183452.115762-1-makarandsonare@google.com>
 <20200417183452.115762-2-makarandsonare@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417183452.115762-2-makarandsonare@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 11:34:51AM -0700, Makarand Sonare wrote:
> From: Peter Shier <pshier@google.com>
> 
> Add new field to hold preemption timer remaining until expiration
> appended to struct kvm_vmx_nested_state_data. KVM_SET_NESTED_STATE restarts
> timer using migrated state regardless of whether L1 sets
> VM_EXIT_SAVE_VMX_PREEMPTION_TIMER.

The changelog should call out that simply stuffing vmcs12 will cause
incorrect behavior because the second (and later) VM-Enter after migration
will restart the timer with the wrong value.  It took me a bit to piece
together why the extra field was needed.

 
> -static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
> +static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
> +					u64 preemption_timeout)
>  {
> -	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
>  	/*
> @@ -3293,8 +3294,15 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	 * the timer.
>  	 */
>  	vmx->nested.preemption_timer_expired = false;
> -	if (nested_cpu_has_preemption_timer(vmcs12))
> -		vmx_start_preemption_timer(vcpu);
> +	if (nested_cpu_has_preemption_timer(vmcs12)) {
> +		u64 preemption_timeout;

timer_value would be shorter, and IMO, a better name as well.  I'd even go
so far as to say throw on a follow-up patch to rename the variable in
vmx_start_preemption_timer.

> +		if (from_vmentry)
> +			preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;

vmcs12 is already available.

> +		else
> +			preemption_timeout = vmx->nested.preemption_timer_remaining;
> +		vmx_start_preemption_timer(vcpu, preemption_timeout);
> +	}
>  
>  	/*
>  	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
> @@ -3888,10 +3896,13 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  	else
>  		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
>  
> -	if (nested_cpu_has_preemption_timer(vmcs12) &&
> -	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> +	if (nested_cpu_has_preemption_timer(vmcs12)) {
> +		vmx->nested.preemption_timer_remaining =
> +			vmx_get_preemption_timer_value(vcpu);
> +		if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
>  			vmcs12->vmx_preemption_timer_value =
> -				vmx_get_preemption_timer_value(vcpu);
> +				vmx->nested.preemption_timer_remaining;
> +	}
>  
>  	/*
>  	 * In some cases (usually, nested EPT), L2 is allowed to change its
> @@ -5759,6 +5770,13 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  
>  			if (vmx->nested.mtf_pending)
>  				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
> +
> +			if (nested_cpu_has_preemption_timer(vmcs12)) {
> +				kvm_state.flags |=
> +					KVM_STATE_NESTED_PREEMPTION_TIMER;
> +				kvm_state.size +=
> +					sizeof(user_vmx_nested_state->preemption_timer_remaining);
> +			}
>  		}
>  	}
>  
> @@ -5790,6 +5808,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  
>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->shadow_vmcs12) < VMCS12_SIZE);
> +	BUILD_BUG_ON(sizeof(user_vmx_nested_state->preemption_timer_remaining)
> +		    != sizeof(vmx->nested.preemption_timer_remaining));
> +
>  
>  	/*
>  	 * Copy over the full allocated size of vmcs12 rather than just the size
> @@ -5805,6 +5826,13 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  			return -EFAULT;
>  	}
>  
> +	if (kvm_state.flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
> +		if (copy_to_user(&user_vmx_nested_state->preemption_timer_remaining,
> +				 &vmx->nested.preemption_timer_remaining,
> +				 sizeof(vmx->nested.preemption_timer_remaining)))
> +			return -EFAULT;

Isn't this suitable for put_user()?  That would allow dropping the
long-winded BUILD_BUG_ON.

> +	}
> +
>  out:
>  	return kvm_state.size;
>  }
> @@ -5876,7 +5904,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	 */
>  	if (is_smm(vcpu) ?
>  		(kvm_state->flags &
> -		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
> +		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING |
> +		  KVM_STATE_NESTED_PREEMPTION_TIMER))
>  		: kvm_state->hdr.vmx.smm.flags)
>  		return -EINVAL;
>  
> @@ -5966,6 +5995,23 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  			goto error_guest_mode;
>  	}
>  
> +	if (kvm_state->flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
> +
> +		if (kvm_state->size <
> +		    sizeof(*kvm_state) +
> +		    sizeof(user_vmx_nested_state->vmcs12) +
> +		    sizeof(user_vmx_nested_state->shadow_vmcs12) +
> +		    sizeof(user_vmx_nested_state->preemption_timer_remaining))

		if (kvm_state->size <
		    offsetof(struct kvm_nested_state, vmx) +
		    offsetofend(struct kvm_nested_state_data,
				preemption_timer_remaining))


> +			goto error_guest_mode;
> +
> +		if (copy_from_user(&vmx->nested.preemption_timer_remaining,
> +				   &user_vmx_nested_state->preemption_timer_remaining,
> +				   sizeof(user_vmx_nested_state->preemption_timer_remaining))) {
> +			ret = -EFAULT;
> +			goto error_guest_mode;
> +		}
> +	}
> +
>  	if (nested_vmx_check_controls(vcpu, vmcs12) ||
>  	    nested_vmx_check_host_state(vcpu, vmcs12) ||
>  	    nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index aab9df55336ef..0098c7dc2e254 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -167,6 +167,7 @@ struct nested_vmx {
>  	u16 posted_intr_nv;
>  
>  	struct hrtimer preemption_timer;
> +	u32 preemption_timer_remaining;
>  	bool preemption_timer_expired;
>  
>  	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 027dfd278a973..ddad6305a0d23 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3374,6 +3374,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_GET_MSR_FEATURES:
>  	case KVM_CAP_MSR_PLATFORM_INFO:
>  	case KVM_CAP_EXCEPTION_PAYLOAD:
> +	case KVM_CAP_NESTED_PREEMPTION_TIMER:

Maybe KVM_CAP_NESTED_STATE_PREEMPTION_TIMER?

>  		r = 1;
>  		break;
>  	case KVM_CAP_SYNC_REGS:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 428c7dde6b4b3..489c3df0b49c8 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_VCPU_RESETS 179
>  #define KVM_CAP_S390_PROTECTED 180
>  #define KVM_CAP_PPC_SECURE_GUEST 181
> +#define KVM_CAP_NESTED_PREEMPTION_TIMER 182
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 3f3f780c8c650..ac8e5d391356c 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -391,6 +391,8 @@ struct kvm_sync_regs {
>  #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
>  #define KVM_STATE_NESTED_EVMCS		0x00000004
>  #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
> +/* Available with KVM_CAP_NESTED_PREEMPTION_TIMER */
> +#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
>  
>  #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
>  #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
> -- 
> 2.26.1.301.g55bc3eb7cb9-goog
> 
