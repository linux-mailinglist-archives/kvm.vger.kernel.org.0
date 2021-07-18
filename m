Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EBA3CCAA7
	for <lists+kvm@lfdr.de>; Sun, 18 Jul 2021 22:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhGRUpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jul 2021 16:45:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229615AbhGRUpq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 18 Jul 2021 16:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626640967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JboBw7DmcI9h7tX28Es0G4/IDQPgJaA4/TEau72JpOM=;
        b=CwDMHOTVb35dr1Pyvy1cjnHylIdBDpi3SiSZYPHt97lRivld3MVRtd+6iEBOU59o8YFA2p
        CBmXyPKumKcHC830bAQpnoJ9yru2axXoIaAf0VksvlBuE8b+xfr5rDF5SstbsZP2WaabUf
        6MoeqTrWyBQR29YzETjY8yg9SWxdsMg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-C5pFpLvUNAuqFffeaH0Clw-1; Sun, 18 Jul 2021 16:42:46 -0400
X-MC-Unique: C5pFpLvUNAuqFffeaH0Clw-1
Received: by mail-ed1-f71.google.com with SMTP id eg53-20020a05640228b5b02903ad3cc35040so6733053edb.11
        for <kvm@vger.kernel.org>; Sun, 18 Jul 2021 13:42:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JboBw7DmcI9h7tX28Es0G4/IDQPgJaA4/TEau72JpOM=;
        b=SZtxUKjtb/78kgOWu9nqEFP94OooAi1Qh+LuiI+F5iUCKg4llntJQCKV5ELXZ3+FV0
         NPV6ibeO1InLqkC6j3HOlZhQAp+b7s7EeqkAzLR1S4L59cHvA/uG1/DraX11tbasOOOR
         cWcL3r5CtoqmaLnUuT5BPWDKq94Z2p8auHYVikXQmuWBmwPoOuY9bxfQj6tCYIacPjaB
         IRzil/zA5tZGZaRXXUtBOj8hE0dJ1TFsFTlDCcDr2m39jDYDhihI9Pwzu88k87Tyx2Ef
         2x8y5O3hXoRUnJM4R9/fOG7HD6+1kjdQ1GKazaQ9KCkZLscB9dYJPMY0XppMqd5qaRYv
         mvlQ==
X-Gm-Message-State: AOAM533w0Vt0G/ZWQ7ZbY7Wc6+FGtybW4Lti3VhkYhWn6vjIYGxOusD5
        i0w3vPSi8rumJSKtEXFxqPAHhFoLMMGoOrwxnRlDbHK41djZfcn25EWYC00o3DoDtpzL4Jt9XXJ
        lit2ceXOLW4Qq
X-Received: by 2002:a17:906:794b:: with SMTP id l11mr23237353ejo.343.1626640965214;
        Sun, 18 Jul 2021 13:42:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwazpkz6hNS2tJXNYBKlKnGaiCSG8BqoHelHJBQ56dIywZPoNOO9T4Zr4nBRky4U8TjU6qlUA==
X-Received: by 2002:a17:906:794b:: with SMTP id l11mr23237346ejo.343.1626640965035;
        Sun, 18 Jul 2021 13:42:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id f1sm4837768edt.51.2021.07.18.13.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 13:42:44 -0700 (PDT)
Subject: Re: [PATCH v2 03/12] KVM: x86: Expose TSC offset controls to
 userspace
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Oliver Upton <oupton@gooogle.com>
References: <20210716212629.2232756-1-oupton@google.com>
 <20210716212629.2232756-4-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <deb0d356-0188-9df9-73cc-e5b81b6d39ca@redhat.com>
Date:   Sun, 18 Jul 2021 22:42:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716212629.2232756-4-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/21 23:26, Oliver Upton wrote:
> To date, VMM-directed TSC synchronization and migration has been a bit
> messy. KVM has some baked-in heuristics around TSC writes to infer if
> the VMM is attempting to synchronize. This is problematic, as it depends
> on host userspace writing to the guest's TSC within 1 second of the last
> write.
> 
> A much cleaner approach to configuring the guest's views of the TSC is to
> simply migrate the TSC offset for every vCPU. Offsets are idempotent,
> and thus not subject to change depending on when the VMM actually
> reads/writes values from/to KVM. The VMM can then read the TSC once with
> KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant when
> the guest is paused.
> 
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Oliver Upton <oupton@gooogle.com>
> ---
>   arch/x86/include/asm/kvm_host.h |   1 +
>   arch/x86/include/uapi/asm/kvm.h |   4 +
>   arch/x86/kvm/x86.c              | 166 ++++++++++++++++++++++++++++++++
>   3 files changed, 171 insertions(+)

This is missing documentation.  The documentation should also include 
the algorithm in https://www.spinics.net/lists/kvm-arm/msg47383.html 
(modulo the fact that KVM_GET/SET_CLOCK return or pass realtime_ns 
rather than kvmclock_ns - relatime_ns; which is fine of course).

Paolo

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e527d7259415..45134b7b14d6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1070,6 +1070,7 @@ struct kvm_arch {
>   	u64 last_tsc_nsec;
>   	u64 last_tsc_write;
>   	u32 last_tsc_khz;
> +	u64 last_tsc_offset;
>   	u64 cur_tsc_nsec;
>   	u64 cur_tsc_write;
>   	u64 cur_tsc_offset;
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index a6c327f8ad9e..0b22e1e84e78 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -503,4 +503,8 @@ struct kvm_pmu_event_filter {
>   #define KVM_PMU_EVENT_ALLOW 0
>   #define KVM_PMU_EVENT_DENY 1
>   
> +/* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
> +#define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
> +#define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e1b7c8b67428..d22de0a1988a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2411,6 +2411,11 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
>   	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
>   }
>   
> +static u64 kvm_vcpu_read_tsc_offset(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.l1_tsc_offset;
> +}
> +
>   static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier)
>   {
>   	vcpu->arch.l1_tsc_scaling_ratio = l1_multiplier;
> @@ -2467,6 +2472,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>   	kvm->arch.last_tsc_nsec = ns;
>   	kvm->arch.last_tsc_write = tsc;
>   	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
> +	kvm->arch.last_tsc_offset = offset;
>   
>   	vcpu->arch.last_guest_tsc = tsc;
>   
> @@ -4914,6 +4920,136 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> +static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	int r;
> +
> +	switch (attr->attr) {
> +	case KVM_VCPU_TSC_OFFSET:
> +		r = 0;
> +		break;
> +	default:
> +		r = -ENXIO;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	void __user *uaddr = (void __user *)attr->addr;
> +	int r;
> +
> +	switch (attr->attr) {
> +	case KVM_VCPU_TSC_OFFSET: {
> +		u64 offset;
> +
> +		offset = kvm_vcpu_read_tsc_offset(vcpu);
> +		r = -EFAULT;
> +		if (copy_to_user(uaddr, &offset, sizeof(offset)))
> +			break;
> +
> +		r = 0;
> +	}
> +	default:
> +		r = -ENXIO;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	void __user *uaddr = (void __user *)attr->addr;
> +	struct kvm *kvm = vcpu->kvm;
> +	int r;
> +
> +	switch (attr->attr) {
> +	case KVM_VCPU_TSC_OFFSET: {
> +		u64 offset, tsc, ns;
> +		unsigned long flags;
> +		bool matched;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&offset, uaddr, sizeof(offset)))
> +			break;
> +
> +		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
> +
> +		matched = (vcpu->arch.virtual_tsc_khz &&
> +			   kvm->arch.last_tsc_khz == vcpu->arch.virtual_tsc_khz &&
> +			   kvm->arch.last_tsc_offset == offset);
> +
> +		tsc = kvm_scale_tsc(vcpu, rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
> +		ns = get_kvmclock_base_ns();
> +
> +		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
> +		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
> +
> +		r = 0;
> +		break;
> +	}
> +	default:
> +		r = -ENXIO;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_vcpu_ioctl_has_device_attr(struct kvm_vcpu *vcpu,
> +					  struct kvm_device_attr *attr)
> +{
> +	int r;
> +
> +	switch (attr->group) {
> +	case KVM_VCPU_TSC_CTRL:
> +		r = kvm_arch_tsc_has_attr(vcpu, attr);
> +		break;
> +	default:
> +		r = -ENXIO;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_vcpu_ioctl_get_device_attr(struct kvm_vcpu *vcpu,
> +					  struct kvm_device_attr *attr)
> +{
> +	int r;
> +
> +	switch (attr->group) {
> +	case KVM_VCPU_TSC_CTRL:
> +		r = kvm_arch_tsc_get_attr(vcpu, attr);
> +		break;
> +	default:
> +		r = -ENXIO;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_vcpu_ioctl_set_device_attr(struct kvm_vcpu *vcpu,
> +					  struct kvm_device_attr *attr)
> +{
> +	int r;
> +
> +	switch (attr->group) {
> +	case KVM_VCPU_TSC_CTRL:
> +		r = kvm_arch_tsc_set_attr(vcpu, attr);
> +		break;
> +	default:
> +		r = -ENXIO;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
>   static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>   				     struct kvm_enable_cap *cap)
>   {
> @@ -5368,6 +5504,36 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		r = __set_sregs2(vcpu, u.sregs2);
>   		break;
>   	}
> +	case KVM_HAS_DEVICE_ATTR: {
> +		struct kvm_device_attr attr;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&attr, argp, sizeof(attr)))
> +			goto out;
> +
> +		r = kvm_vcpu_ioctl_has_device_attr(vcpu, &attr);
> +		break;
> +	}
> +	case KVM_GET_DEVICE_ATTR: {
> +		struct kvm_device_attr attr;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&attr, argp, sizeof(attr)))
> +			goto out;
> +
> +		r = kvm_vcpu_ioctl_get_device_attr(vcpu, &attr);
> +		break;
> +	}
> +	case KVM_SET_DEVICE_ATTR: {
> +		struct kvm_device_attr attr;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&attr, argp, sizeof(attr)))
> +			goto out;
> +
> +		r = kvm_vcpu_ioctl_set_device_attr(vcpu, &attr);
> +		break;
> +	}
>   	default:
>   		r = -EINVAL;
>   	}
> 

