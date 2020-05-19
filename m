Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0141D8C8D
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 02:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgESAtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 20:49:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54984 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726374AbgESAtm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 20:49:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589849379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ko5CMj42evelnIPEhLMzE03601ZUppJ5YzruOidsd/Q=;
        b=FvuWJeLCrZfuB5NBXp0aZXIN6I99H85t3Pw2SNe2rmtCJk8qpSbIeoCTj5w1n1JvT+vwk4
        fvWA5dy2ay6SGPQNIM4/cwNgpa+4/pw0LhQhtkM9onQGJuZ76hluZanVFSfY5Csd31/mO6
        xRQMkYGkFLTP/qlaS6/OvS9uz0wdsyg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-I-r7rvKEMxqfiN41pF1-_w-1; Mon, 18 May 2020 20:49:37 -0400
X-MC-Unique: I-r7rvKEMxqfiN41pF1-_w-1
Received: by mail-wr1-f70.google.com with SMTP id 90so6425643wrg.23
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 17:49:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Ko5CMj42evelnIPEhLMzE03601ZUppJ5YzruOidsd/Q=;
        b=W6FXB4cVlC0NurQrzxUo6DzfrzCgHd1YUZCK1+BGhLaBIlpk0k1OQ3jc7HZdo0DsPh
         m0MxgIa6DXd82Onax9bM9mXHjahmEATi0T003DIaOxsDGl5ecmuwosMprYgbeauBBBNF
         j0sV7D5UYLM0ol9oultvI7VWhgnFE7bYQxkAW79mB03kVXpfIOhlEiIaEzl90CZLKjXB
         H9ULIH8unsMYa4HfmgkLBQQeb9yGFXGq8oiQV6aE3o9iptkU6OZahyeu7YMc0B5tdSRP
         dvPXtN5wJux4SB747SauRUs/KmsyPGang4cpf6z9rKY/pywNrzF/A3P3lU6liuMofZAR
         0N2Q==
X-Gm-Message-State: AOAM531jwQIxuDRrRp6JbUeACdsWLoPtEn9WghuoAD52aApNADH8SFRB
        Ob+6UBO0hxha6ccASywaDi29qfNU7kktbiSEX4fjx1UGexMzPxo4eXrcFkqpr1nXhc35wlF+MsX
        +rgT9UolM++Hm
X-Received: by 2002:a5d:6144:: with SMTP id y4mr23172928wrt.185.1589849376124;
        Mon, 18 May 2020 17:49:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwe6AQxPXIXk+WuNqUW27W/ycQjdzVoDWTv2Rh4DG9FLD0IDmf786PbN7vNwhAlG3qT3Rp2YQ==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr23172905wrt.185.1589849375782;
        Mon, 18 May 2020 17:49:35 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s11sm18329197wrp.79.2020.05.18.17.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 17:49:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Subject: Re: [PATCH  1/2] KVM: nVMX: Fix VMX preemption timer migration
In-Reply-To: <20200518201600.255669-2-makarandsonare@google.com>
References: <20200518201600.255669-1-makarandsonare@google.com> <20200518201600.255669-2-makarandsonare@google.com>
Date:   Tue, 19 May 2020 02:49:33 +0200
Message-ID: <875zcsvjdu.fsf@vitty.brq.redhat.com>
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
>  Documentation/virt/kvm/api.rst        |  4 ++
>  arch/x86/include/uapi/asm/kvm.h       |  2 +
>  arch/x86/kvm/vmx/nested.c             | 61 ++++++++++++++++++++++++---
>  arch/x86/kvm/vmx/vmx.h                |  1 +
>  arch/x86/kvm/x86.c                    |  3 +-
>  include/uapi/linux/kvm.h              |  1 +
>  tools/arch/x86/include/uapi/asm/kvm.h |  2 +
>  7 files changed, 67 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d871dacb984e9..b410815772970 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4326,6 +4326,9 @@ Errors:
>    #define KVM_STATE_NESTED_RUN_PENDING		0x00000002
>    #define KVM_STATE_NESTED_EVMCS		0x00000004
>  

Not your fault but KVM_STATE_NESTED_MTF_PENDING seems to be missing here

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
> index 3f3f780c8c650..20d5832bab215 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -391,6 +391,7 @@ struct kvm_sync_regs {
>  #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
>  #define KVM_STATE_NESTED_EVMCS		0x00000004
>  #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
> +#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010

and here you don't have the "/* Available with
KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */" comment you put to api.rst. I
think it would be better to keep them in sync.

>  
>  #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
>  #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
> @@ -400,6 +401,7 @@ struct kvm_sync_regs {
>  struct kvm_vmx_nested_state_data {
>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>  	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> +	__u64 preemption_timer_deadline;
>  };
>  
>  struct kvm_vmx_nested_state_hdr {
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 51ebb60e1533a..badb82a39ac04 100644
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
> @@ -3353,8 +3353,24 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	 * the timer.
>  	 */
>  	vmx->nested.preemption_timer_expired = false;
> -	if (nested_cpu_has_preemption_timer(vmcs12))
> -		vmx_start_preemption_timer(vcpu);
> +	if (nested_cpu_has_preemption_timer(vmcs12)) {
> +		u64 timer_value;
> +		u64 l1_tsc_value = kvm_read_l1_tsc(vcpu, rdtsc());
> +
> +		if (from_vmentry) {
> +			timer_value = vmcs12->vmx_preemption_timer_value;
> +			vmx->nested.preemption_timer_deadline = timer_value +
> +				(l1_tsc_value >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE);
> +		} else {
> +			if ((l1_tsc_value >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE) >
> +			    vmx->nested.preemption_timer_deadline)
> +				timer_value = 0;
> +			else
> +				timer_value = vmx->nested.preemption_timer_deadline -
> +					(l1_tsc_value >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE);
> +		}
> +		vmx_start_preemption_timer(vcpu, timer_value);
> +	}
>  
>  	/*
>  	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
> @@ -3962,9 +3978,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
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
> @@ -5939,6 +5957,13 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  
>  			if (vmx->nested.mtf_pending)
>  				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
> +
> +			if (nested_cpu_has_preemption_timer(vmcs12)) {
> +				kvm_state.flags |=
> +					KVM_STATE_NESTED_PREEMPTION_TIMER;
> +				kvm_state.size = offsetof(struct kvm_nested_state, data.vmx) +
> +						 offsetofend(struct kvm_vmx_nested_state_data, preemption_timer_deadline);

Hm, here we seem to drop all previous calculations for the
kvm_state.size (like if shadow vmcs was present or not). I think this
should just be

 kvm_state.size +=  sizeof(user_vmx_nested_state.preemption_timer_deadline);

instead.

> +			}
>  		}
>  	}
>  
> @@ -5970,6 +5995,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  
>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->shadow_vmcs12) < VMCS12_SIZE);
> +	BUILD_BUG_ON(sizeof(user_vmx_nested_state->preemption_timer_deadline)
> +		    != sizeof(vmx->nested.preemption_timer_deadline));
> +
>  
>  	/*
>  	 * Copy over the full allocated size of vmcs12 rather than just the size
> @@ -5985,6 +6013,12 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
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
> @@ -6056,7 +6090,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	 */
>  	if (is_smm(vcpu) ?
>  		(kvm_state->flags &
> -		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
> +		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING |
> +		  KVM_STATE_NESTED_PREEMPTION_TIMER))
>  		: kvm_state->hdr.vmx.smm.flags)
>  		return -EINVAL;
>  
> @@ -6146,6 +6181,20 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  			goto error_guest_mode;
>  	}
>  
> +	if (kvm_state->flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
> +
> +		if (kvm_state->size <
> +		    offsetof(struct kvm_nested_state, data.vmx) +
> +		    offsetofend(struct kvm_vmx_nested_state_data, preemption_timer_deadline))

This also doesn't seem to be correct. E.g. what if there is no shadow
vmcs data in the saved state?

> +			goto error_guest_mode;
> +
> +		if (get_user(vmx->nested.preemption_timer_deadline,
> +			     &user_vmx_nested_state->preemption_timer_deadline)) {
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
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 3f3f780c8c650..60701178b9cc1 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -391,6 +391,8 @@ struct kvm_sync_regs {
>  #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
>  #define KVM_STATE_NESTED_EVMCS		0x00000004
>  #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
> +/* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
> +#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
>  
>  #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
>  #define KVM_STATE_NESTED_SMM_VMXON	0x00000002

It seems tools/arch/x86/include/uapi/asm/kvm.h is usually updated
separately (not sure it's the right thing to do though..)

-- 
Vitaly

