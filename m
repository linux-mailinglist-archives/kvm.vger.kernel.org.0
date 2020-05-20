Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD71C1DBAC9
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgETRJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:09:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43262 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726619AbgETRJQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 13:09:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589994553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lxi8/BPUjKMD0FAvDKR24T1QMLUGZ6icNwMh1agJP9U=;
        b=dMDGpEe+trQfleE3KX6cAqA3/tNCQ7bDCsrAJ4xhqe+JwVdQ8fVFgAjmNfGyr/K3rf5h7T
        k6+4JGJcOVxEXUTs9UFUMndjbhlcN+oBF5p8mUBeHU/DiltYEDYkekco2iXbFAS2xztvpz
        cLL+/HTefKgK6n8eI45DpMTjS+gUGlU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-unJNy8hgPYGSVRG3li5U-g-1; Wed, 20 May 2020 13:09:02 -0400
X-MC-Unique: unJNy8hgPYGSVRG3li5U-g-1
Received: by mail-ej1-f69.google.com with SMTP id t18so1628232ejg.2
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 10:09:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Lxi8/BPUjKMD0FAvDKR24T1QMLUGZ6icNwMh1agJP9U=;
        b=KRlErG4dqg/rsDWMi5NSRU6IHxChAGO2RBLLtnsi97cOePLC4Ijdg2CRShk3qD6eqc
         CrPSpRTmDPQF0+Lj/K/tatknxBl87U6pzahCuqEDpplQ4Czm3SJ3iKGwbFwBcEYepyll
         0A7UCvsRQKtl5O3FCi8LCdk5tYzmLwwBihY/nKF9Wf9pSXS0c+D7QFnY0WhSOb/ryKVR
         /FujCJNj+bUYH1ppQZwFnP/o8UHAU7p+OjHJkA+uR4hBb+dGlUnpWrFy5PENu/zTiSJY
         6B2/DAX0m2YpPoVVinuSBRhIjEFxXH7WjCCWfGsZBGrCR009nW9UOHr+IDm0XynIB5Wc
         YP/g==
X-Gm-Message-State: AOAM533NZphqGmS50leMhn7Ci6Z7echHvKLGIqcE9tHl59y5B7wP9UdC
        BWCWOVAyTKFTBcWmS174OF7TffXl/bNtKgZbC5fUYg8vn5fS9g9jWqFclCOwoiwyRSKSyq5CF8C
        IErny7aqK6shF
X-Received: by 2002:a17:906:3943:: with SMTP id g3mr19283eje.489.1589994540777;
        Wed, 20 May 2020 10:09:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjvLdkGmU1u7gc3RtRP6ckNi4tYD7jJecmqIeCEEixu7l05qx7HXH3xIbFlIvI7LLFtHCdQQ==
X-Received: by 2002:a17:906:3943:: with SMTP id g3mr19253eje.489.1589994540374;
        Wed, 20 May 2020 10:09:00 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id gl19sm2236536ejb.34.2020.05.20.10.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 10:08:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Makarand Sonare <makarandsonare@google.com>, kvm@vger.kernel.org
Cc:     pshier@google.com, jmattson@google.com
Subject: Re: [PATCH  v2 1/2] KVM: nVMX: Fix VMX preemption timer migration
In-Reply-To: <20200519222238.213574-2-makarandsonare@google.com>
References: <20200519222238.213574-1-makarandsonare@google.com> <20200519222238.213574-2-makarandsonare@google.com>
Date:   Wed, 20 May 2020 19:08:58 +0200
Message-ID: <87v9kqsfdh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Makarand Sonare <makarandsonare@google.com> writes:

> From: Peter Shier <pshier@google.com>
>
> Add new field to hold preemption timer expiration deadline
> appended to struct kvm_vmx_nested_state_data. This is to prevent
> the first VM-Enter after migration from incorrectly restarting the timer
> with the full timer value instead of partially decayed timer value.
> KVM_SET_NESTED_STATE restarts timer using migrated state regardless
> of whether L1 sets VM_EXIT_SAVE_VMX_PREEMPTION_TIMER.
>
> Fixes: cf8b84f48a593 ("kvm: nVMX: Prepare for checkpointing L2 state")
>
> Signed-off-by: Peter Shier <pshier@google.com>
> Signed-off-by: Makarand Sonare <makarandsonare@google.com>
> Change-Id: I6446aba5a547afa667f0ef4620b1b76115bf3753
> ---
>  Documentation/virt/kvm/api.rst  |  4 +++
>  arch/x86/include/uapi/asm/kvm.h |  3 ++
>  arch/x86/kvm/vmx/nested.c       | 56 +++++++++++++++++++++++++++++----
>  arch/x86/kvm/vmx/vmx.h          |  1 +
>  arch/x86/kvm/x86.c              |  3 +-
>  include/uapi/linux/kvm.h        |  1 +
>  6 files changed, 61 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d871dacb984e9..b410815772970 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4326,6 +4326,9 @@ Errors:
>    #define KVM_STATE_NESTED_RUN_PENDING		0x00000002
>    #define KVM_STATE_NESTED_EVMCS		0x00000004
>
> +  /* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
> +  #define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
> +
>    #define KVM_STATE_NESTED_FORMAT_VMX		0
>    #define KVM_STATE_NESTED_FORMAT_SVM		1
>
> @@ -4346,6 +4349,7 @@ Errors:
>    struct kvm_vmx_nested_state_data {
>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>  	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> +	__u64 preemption_timer_deadline;
>    };
>
>  This ioctl copies the vcpu's nested virtualization state from the kernel to
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 3f3f780c8c650..13dca545554dc 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -391,6 +391,8 @@ struct kvm_sync_regs {
>  #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
>  #define KVM_STATE_NESTED_EVMCS		0x00000004
>  #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
> +/* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
> +#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
>
>  #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
>  #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
> @@ -400,6 +402,7 @@ struct kvm_sync_regs {
>  struct kvm_vmx_nested_state_data {
>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>  	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> +	__u64 preemption_timer_deadline;
>  };
>
>  struct kvm_vmx_nested_state_hdr {
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 51ebb60e1533a..318b753743902 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2092,9 +2092,9 @@ static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
>  	return HRTIMER_NORESTART;
>  }
>
> -static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
> +static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
> +					u64 preemption_timeout)
>  {
> -	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>
>  	/*
> @@ -3353,8 +3353,20 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	 * the timer.
>  	 */
>  	vmx->nested.preemption_timer_expired = false;
> -	if (nested_cpu_has_preemption_timer(vmcs12))
> -		vmx_start_preemption_timer(vcpu);
> +	if (nested_cpu_has_preemption_timer(vmcs12)) {
> +		u64 timer_value = 0;
> +		u64 l1_scaled_tsc_value = (kvm_read_l1_tsc(vcpu, rdtsc())
> +					   >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE);
> +
> +		if (from_vmentry) {
> +			timer_value = vmcs12->vmx_preemption_timer_value;
> +			vmx->nested.preemption_timer_deadline = timer_value +
> +								l1_scaled_tsc_value;
> +		} else if (l1_scaled_tsc_value <= vmx->nested.preemption_timer_deadline)
> +			timer_value = vmx->nested.preemption_timer_deadline -
> +				      l1_scaled_tsc_value;
> +		vmx_start_preemption_timer(vcpu, timer_value);
> +	}
>
>  	/*
>  	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
> @@ -3962,9 +3974,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
>
>  	if (nested_cpu_has_preemption_timer(vmcs12) &&
> -	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> +	    !vmx->nested.nested_run_pending) {
> +		if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
>  			vmcs12->vmx_preemption_timer_value =
>  				vmx_get_preemption_timer_value(vcpu);
> +	}
>
>  	/*
>  	 * In some cases (usually, nested EPT), L2 is allowed to change its
> @@ -5939,6 +5953,12 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>
>  			if (vmx->nested.mtf_pending)
>  				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
> +
> +			if (nested_cpu_has_preemption_timer(vmcs12)) {
> +				kvm_state.flags |=
> +					KVM_STATE_NESTED_PREEMPTION_TIMER;
> +				kvm_state.size += sizeof(user_vmx_nested_state->preemption_timer_deadline);
> +			}
>  		}
>  	}
>
> @@ -5970,6 +5990,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>
>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->shadow_vmcs12) < VMCS12_SIZE);
> +	BUILD_BUG_ON(sizeof(user_vmx_nested_state->preemption_timer_deadline)
> +		    != sizeof(vmx->nested.preemption_timer_deadline));
> +
>
>  	/*
>  	 * Copy over the full allocated size of vmcs12 rather than just the size
> @@ -5985,6 +6008,12 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  			return -EFAULT;
>  	}
>
> +	if (kvm_state.flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
> +		if (put_user(vmx->nested.preemption_timer_deadline,
> +			     &user_vmx_nested_state->preemption_timer_deadline))
> +			return -EFAULT;
> +	}
> +
>  out:
>  	return kvm_state.size;
>  }
> @@ -6056,7 +6085,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	 */
>  	if (is_smm(vcpu) ?
>  		(kvm_state->flags &
> -		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
> +		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING |
> +		  KVM_STATE_NESTED_PREEMPTION_TIMER))
>  		: kvm_state->hdr.vmx.smm.flags)
>  		return -EINVAL;
>
> @@ -6146,6 +6176,20 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  			goto error_guest_mode;
>  	}
>
> +	if (kvm_state->flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
> +
> +		if (kvm_state->size <
> +		    sizeof(*kvm_state) +
> +		    sizeof(user_vmx_nested_state->vmcs12) + sizeof(vmx->nested.preemption_timer_deadline))
> +			goto error_guest_mode;

I'm not sure this check is entirely correct.

kvm_state->size can now be:

- (1) sizeof(*kvm_state) + sizeof(user_vmx_nested_state->vmcs12) when no
  shadow vmcs/preemtion timer flags
- (1) + sizeof(*shadow_vmcs12)) when shadow vmcs and no preemtion
  timer.
- (1) + sizeof(vmx->nested.preemption_timer_deadline) when preemtion
  timer and no shadow vmcs
- (1) + sizeof(*shadow_vmcs12)) +
  sizeof(vmx->nested.preemption_timer_deadline) when both shadow vmcs
  and preemption timer.

(I don't even want to think what happens when we add something else here
:-))

I.e. your check will pass when e.g. the total size is '(1) +
sizeof(*shadow_vmcs12))' but it is wrong, you need more!

I suggest we add a logic to calculate the required size:

  required_size = sizeof(*kvm_state) +  sizeof(user_vmx_nested_state->vmcs12)
  if (shadow_vmcs_present)
      required_size += sizeof(*shadow_vmcs12);
  if (preemption_timer_present)
      required_size += sizeof(vmx->nested.preemption_timer_deadline);
  ...

But ...

> +
> +		if (get_user(vmx->nested.preemption_timer_deadline,
> +			     &user_vmx_nested_state->preemption_timer_deadline)) {

... tt also seems that we expect user_vmx_nested_state to always have
all fields, e.g. here the offset of 'preemption_timer_deadline' is
static, we always expect it to be after shadow vmcs. I think we need a
way to calculate the offset dynamically and not require everything to be
present.

> +			ret = -EFAULT;
> +			goto error_guest_mode;
> +		}
> +	}
> +
>  	if (nested_vmx_check_controls(vcpu, vmcs12) ||
>  	    nested_vmx_check_host_state(vcpu, vmcs12) ||
>  	    nested_vmx_check_guest_state(vcpu, vmcs12, &ignored))
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 298ddef79d009..db697400755fb 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -169,6 +169,7 @@ struct nested_vmx {
>  	u16 posted_intr_nv;
>
>  	struct hrtimer preemption_timer;
> +	u64 preemption_timer_deadline;
>  	bool preemption_timer_expired;
>
>  	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 471fccf7f8501..ba9e62ffbb4cd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3418,6 +3418,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_MSR_PLATFORM_INFO:
>  	case KVM_CAP_EXCEPTION_PAYLOAD:
>  	case KVM_CAP_SET_GUEST_DEBUG:
> +	case KVM_CAP_NESTED_STATE_PREEMPTION_TIMER:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SYNC_REGS:
> @@ -4626,7 +4627,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>
>  		if (kvm_state.flags &
>  		    ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
> -		      | KVM_STATE_NESTED_EVMCS))
> +		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_PREEMPTION_TIMER))
>  			break;
>
>  		/* nested_run_pending implies guest_mode.  */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ac9eba0289d1b..0868dce12a715 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1018,6 +1018,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_PROTECTED 180
>  #define KVM_CAP_PPC_SECURE_GUEST 181
>  #define KVM_CAP_HALT_POLL 182
> +#define KVM_CAP_NESTED_STATE_PREEMPTION_TIMER 183
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> --
> 2.26.2.761.g0e0b3e54be-goog
>

-- 
Vitaly

