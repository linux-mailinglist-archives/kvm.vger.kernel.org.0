Return-Path: <kvm+bounces-28389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5532F998139
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAD981F221D4
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E231BD503;
	Thu, 10 Oct 2024 08:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KLKLnxzG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8411A1BD01A
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550661; cv=none; b=OM8shg8gKBwqbqLGZc1HYe2c6s6jjwFZZ6x+ta2FRb5B7FMejx3/19qi7qkAH3OmDLItnpSgFCQwpLo5tW1yZxsGyLzhpjLqrltVFhDd2mRgqZcv/u81iHpZ8RgJrYTHlAxzyFVkryTCk4NKeN6OBhgNRkFJCKJI9MhUwi+c34E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550661; c=relaxed/simple;
	bh=yMUiDyaDw0rmD/dvo9jvxidKU8GUMKeVKhtisHpbTEM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=u0R8BKgMN86OQJQGM0dYSp7LN9kRbTsRCOJqvE7zeXBWON/OlQZ1Y1KlQpWxLkHcG03/kkio7FpkRb4XElOhj8/FbL+ZAlMcNqTWmYNtxAjwmaDenHgrBjuDsQlxI2GEThJ413HNgLSJpJNjXdWISMcUq0JLqyztaTU3VZpSx44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KLKLnxzG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728550658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6TrX2zEj2ZgP1RN5eSGwq6SD54cXQjSCTkkf2QKYXQk=;
	b=KLKLnxzGPgyXI0l1z0pjqUSYBalk2AV2kafYs69U8iur4iA7DAq5dRhrb4M3uTIdEOdsPs
	ehSVFXBY2/7NCCv1ggaXlO2UNEwPoUzba4untKCbIGgi2VMnyQ8dvLaMT9934HGLDThY5y
	ldWREa3gJg+731t+Xnwg5QwXy79RmZ4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-byMjQFolO12vByCfMQw1VA-1; Thu, 10 Oct 2024 04:57:37 -0400
X-MC-Unique: byMjQFolO12vByCfMQw1VA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cb080ab53so5358235e9.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 01:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728550656; x=1729155456;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6TrX2zEj2ZgP1RN5eSGwq6SD54cXQjSCTkkf2QKYXQk=;
        b=qcLS7B2UJKq6nqgjJu7NqTwz7g8wPmUI7UP/+O2xoIs79Rt7n9QND3kTZo7QClkx+6
         WXWOg/JdvA83ymt66SJoiPSv/YCqb3PuY8Rqh1gC1dOQ7C8d5LoFATp5e8czwlzEbGkr
         3KZ84TZqxZpiH+urTKCPQQL7er0rxrLdXJs+jIGMdlK8uQV9ZVs8Bk1VoYbJZnAyHRTr
         2hAyImClPURVj9ldEH7Ec3ljUkLenT9jSJHRoP2St+rwRmj+k4/MBZfxTEIFoABBq8fX
         nNXLcsQRQHa2oFbz8RcqdiOp6wUd3wAI/vH5Fk8wTw439mFn6cj9pDeYFEIfSJR7t/Ia
         UqKg==
X-Forwarded-Encrypted: i=1; AJvYcCU5CjeaEri2YcksWXeb2AwfcC2RcW/zyPk6Hmh7ddktXfB410fzVCQ+0m/v+o+56popgyI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzqEUFsI9F45gs/wxkgjDs0KbGcEiEAN5Pska41vnd/U0wyPGn
	CMSwg2iBT9Uxn/0bCgt0uinb7soSB3yFpiIY2dFK/PZDUbxz3Hiokfx9oR54KGLlbufj5tdJnNI
	ozgRF0FGFBbKtYxKncK7GiVQDz8rL+vpwV6Shnk4boR2yMOhHcg==
X-Received: by 2002:adf:e5cc:0:b0:374:baeb:2ec with SMTP id ffacd0b85a97d-37d47e9dbd1mr2045006f8f.19.1728550656056;
        Thu, 10 Oct 2024 01:57:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtznOMy68s/vt2yJMLa35Bsj6so4bbqxkVQgeKXfgOXOylGrq3sapfjI90PeS2dco4Q6E5xg==
X-Received: by 2002:adf:e5cc:0:b0:374:baeb:2ec with SMTP id ffacd0b85a97d-37d47e9dbd1mr2044978f8f.19.1728550655529;
        Thu, 10 Oct 2024 01:57:35 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b6bcf50sm914167f8f.29.2024.10.10.01.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 01:57:35 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Nikolas Wipper <nikwip@amazon.de>
Cc: Nicolas Saenz Julienne <nsaenz@amazon.com>, Alexander Graf
 <graf@amazon.de>, James Gowans <jgowans@amazon.com>,
 nh-open-source@amazon.com, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Nikolas Wipper <nik.wipper@gmx.de>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Nikolas
 Wipper <nikwip@amazon.de>
Subject: Re: [PATCH 5/7] KVM: x86: Implement KVM_HYPERV_SET_TLB_FLUSH_INHIBIT
In-Reply-To: <20241004140810.34231-6-nikwip@amazon.de>
References: <20241004140810.34231-1-nikwip@amazon.de>
 <20241004140810.34231-6-nikwip@amazon.de>
Date: Thu, 10 Oct 2024 10:57:34 +0200
Message-ID: <878quwgwsh.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Nikolas Wipper <nikwip@amazon.de> writes:

> Implement KVM_HYPERV_SET_TLB_FLUSH_INHIBIT for x86. Apart from setting/
> clearing the internal TLB flush inhibit flag this ioctl also wakes up
> vCPUs suspended and waiting on this vCPU.
>
> When the flag is set, a vCPU trying to flush the inhibited vCPUs TLB with
> a Hyper-V hyper-call suspendeds until the bit is cleared again. The hyper-
> call finishes internally, but the instruction isn't skipped, and execution
> doesn't return to the guest. This behaviour and the suspended state itself
> are specified in Microsoft's "Hypervisor Top Level Functional
> Specification" (TLFS).
>
> To maintain thread safety during suspension and unsuspension, the IOCTL
> uses the KVM SRCU. After flipping the flush inhibit flag, it synchronizes
> SRCU to ensure that all running TLB flush attempts that saw the old state,
> finish before the IOCTL exits. If the flag was changed to inhibit new TLB
> flushes, this guarantees that no TLB flushes happen once the ioctl exits.
> If the flag was changed to no longer inhibit TLB flushes, the
> synchronization ensures that all suspended CPUs finished entering the
> suspended state properly, so they can be unsuspended again.
>
> Once TLB flushes are no longer inhibited, all suspended vCPUs are
> unsuspended.
>
> Signed-off-by: Nikolas Wipper <nikwip@amazon.de>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/hyperv.c           | 22 ++++++++++++++++++++
>  arch/x86/kvm/x86.c              | 37 +++++++++++++++++++++++++++++++++
>  3 files changed, 61 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7571ac578884..ab3a9beb61a2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -698,6 +698,8 @@ struct kvm_vcpu_hv {
>  
>  	bool suspended;
>  	int waiting_on;
> +
> +	int tlb_flush_inhibit;

This is basically boolean, right? And we only make it 'int' to be able
to store 'u8' from the ioctl? This doesn't look very clean. Do you
envision anything but '1'/'0' in 'inhibit'? If not, maybe we can just
make it a flag (and e.g. extend 'flags' to be u32/u64)? This way we can
convert 'tlb_flush_inhibit' to a normal bool.

>  };
>  
>  struct kvm_hypervisor_cpuid {
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index e68fbc0c7fc1..40ea8340838f 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2137,6 +2137,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		bitmap_zero(vcpu_mask, KVM_MAX_VCPUS);
>  
>  		kvm_for_each_vcpu(i, v, kvm) {
> +			if (READ_ONCE(v->arch.hyperv->tlb_flush_inhibit))
> +				goto ret_suspend;
> +
>  			__set_bit(i, vcpu_mask);
>  		}
>  	} else if (!is_guest_mode(vcpu)) {
> @@ -2148,6 +2151,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  				__clear_bit(i, vcpu_mask);
>  				continue;
>  			}
> +
> +			if (READ_ONCE(v->arch.hyperv->tlb_flush_inhibit))
> +				goto ret_suspend;
>  		}
>  	} else {
>  		struct kvm_vcpu_hv *hv_v;
> @@ -2175,6 +2181,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  						    sparse_banks))
>  				continue;
>  
> +			if (READ_ONCE(v->arch.hyperv->tlb_flush_inhibit))
> +				goto ret_suspend;
> +

These READ_ONCEs make me think I misunderstand something here, please
bear with me :-).

Like we're trying to protect against 'tlb_flush_inhibit' being read
somewhere in the beginning of the function and want to generate real
memory accesses. But what happens if tlb_flush_inhibit changes right
_after_ we checked it here and _before_ we actuall do
kvm_make_vcpus_request_mask()? Wouldn't it be a problem? In case it
would, I think we need to reverse the order: do
kvm_make_vcpus_request_mask() anyway and after it go through vcpu_mask
checking whether any of the affected vCPUs has 'tlb_flush_inhibit' and
if it does, suspend the caller.

>  			__set_bit(i, vcpu_mask);
>  		}
>  	}
> @@ -2193,6 +2202,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	/* We always do full TLB flush, set 'Reps completed' = 'Rep Count' */
>  	return (u64)HV_STATUS_SUCCESS |
>  		((u64)hc->rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
> +ret_suspend:
> +	kvm_hv_vcpu_suspend_tlb_flush(vcpu, v->vcpu_id);
> +	return -EBUSY;
>  }
>  
>  static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
> @@ -2380,6 +2392,13 @@ static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
>  	u32 tlb_lock_count = 0;
>  	int ret;
>  
> +	/*
> +	 * Reached when the hyper-call resulted in a suspension of the vCPU.
> +	 * The instruction will be re-tried once the vCPU is unsuspended.
> +	 */
> +	if (kvm_hv_vcpu_suspended(vcpu))
> +		return 1;
> +
>  	if (hv_result_success(result) && is_guest_mode(vcpu) &&
>  	    kvm_hv_is_tlb_flush_hcall(vcpu) &&
>  	    kvm_read_guest(vcpu->kvm, to_hv_vcpu(vcpu)->nested.pa_page_gpa,
> @@ -2919,6 +2938,9 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  
>  void kvm_hv_vcpu_suspend_tlb_flush(struct kvm_vcpu *vcpu, int vcpu_id)
>  {
> +	RCU_LOCKDEP_WARN(!srcu_read_lock_held(&vcpu->kvm->srcu),
> +			 "Suspicious Hyper-V TLB flush inhibit usage\n");
> +
>  	/* waiting_on's store should happen before suspended's */
>  	WRITE_ONCE(vcpu->arch.hyperv->waiting_on, vcpu_id);
>  	WRITE_ONCE(vcpu->arch.hyperv->suspended, true);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 18d0a300e79a..1f925e32a927 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4642,6 +4642,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_HYPERV_CPUID:
>  	case KVM_CAP_HYPERV_ENFORCE_CPUID:
>  	case KVM_CAP_SYS_HYPERV_CPUID:
> +	case KVM_CAP_HYPERV_TLB_FLUSH_INHIBIT:
>  #endif
>  	case KVM_CAP_PCI_SEGMENT:
>  	case KVM_CAP_DEBUGREGS:
> @@ -5853,6 +5854,31 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +static int kvm_vcpu_ioctl_set_tlb_flush_inhibit(struct kvm_vcpu *vcpu,
> +						struct kvm_hyperv_tlb_flush_inhibit *set)
> +{
> +	if (set->inhibit == READ_ONCE(vcpu->arch.hyperv->tlb_flush_inhibit))
> +		return 0;
> +
> +	WRITE_ONCE(vcpu->arch.hyperv->tlb_flush_inhibit, set->inhibit);

As you say before, vCPU ioctls are serialized and noone else sets
tlb_flush_inhibit, do I understand correctly that
READ_ONCE()/WRITE_ONCE() are redundant here?

> +
> +	/*
> +	 * synchronize_srcu() ensures that:
> +	 * - On inhibit, all concurrent TLB flushes finished before this ioctl
> +	 *   exits.
> +	 * - On uninhibit, there are no longer vCPUs being suspended due to this
> +	 *   inhibit.
> +	 * This function can't race with itself, because vCPU IOCTLs are
> +	 * serialized, so if the inhibit bit is already the desired value this
> +	 * synchronization has already happened.
> +	 */
> +	synchronize_srcu(&vcpu->kvm->srcu);
> +	if (!set->inhibit)
> +		kvm_hv_vcpu_unsuspend_tlb_flush(vcpu);
> +
> +	return 0;
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
> @@ -6306,6 +6332,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_SET_DEVICE_ATTR:
>  		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
>  		break;
> +#ifdef CONFIG_KVM_HYPERV
> +	case KVM_HYPERV_SET_TLB_FLUSH_INHIBIT: {
> +		struct kvm_hyperv_tlb_flush_inhibit set;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&set, argp, sizeof(set)))
> +			goto out;
> +		r = kvm_vcpu_ioctl_set_tlb_flush_inhibit(vcpu, &set);
> +		break;
> +	}
> +#endif
>  	default:
>  		r = -EINVAL;
>  	}

-- 
Vitaly


