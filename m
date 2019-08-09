Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6D1877B4
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 12:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406130AbfHIKo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 06:44:57 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40307 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406114AbfHIKo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 06:44:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so97758825wrl.7
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 03:44:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9WzyURDH7ESFlnfzMS62H/D7+dda89YOvkjObehxwI4=;
        b=osNaPMSFjYpEURx2GxrztByNJTzMUrZuFKTC81Zft4wrwI50Qn78qAHCG59zhSuU+w
         pA2hQAdshw+pbW6xjVaahqBTwwzGvIJQbqZejD5FkIUt0h47HWRCXTEP0nJfRGao3QIU
         4UdTVYA6ugJt4Cg1v7jCmbub/6BZERDhkruxJQoHEuyNjZ1gALE/0V9gkkREdjEW1GzE
         bmPi465kVW6PPJkGFGVS40YJwuVB8irkUsTNovmL/5BozvlXEwbP+vC6KTjL5J1qbg0P
         TgblwNDfj4gih2ghkWMshx8XxHybvWuxqJXQoz2nLVCEYT4VXpxejTW/c70nFfC1xoJT
         /tqw==
X-Gm-Message-State: APjAAAWeURz4dRvjhp21gkZRkTcInHJOEbUpwyAySCjpmKcci/TJT6nV
        TQy6H5x9Yfjjzk0e9+n6Lzs0Hg==
X-Google-Smtp-Source: APXvYqyShx0+uf7pVce5ZDJOlO/Kcni/X/ot9S5XvNCwawUL4fIjZNa87xwbrVguDjFtFCSkw6VU0g==
X-Received: by 2002:adf:df8b:: with SMTP id z11mr22569218wrl.62.1565347494857;
        Fri, 09 Aug 2019 03:44:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id u1sm5907164wml.14.2019.08.09.03.44.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 03:44:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     lantianyu1986@gmail.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, corbet@lwn.net, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, michael.h.kelley@microsoft.com
Subject: Re: [PATCH 2/3] KVM/Hyper-V: Add new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH
In-Reply-To: <20190809094939.76093-3-Tianyu.Lan@microsoft.com>
References: <20190809094939.76093-1-Tianyu.Lan@microsoft.com> <20190809094939.76093-3-Tianyu.Lan@microsoft.com>
Date:   Fri, 09 Aug 2019 12:44:52 +0200
Message-ID: <87r25ubot7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

lantianyu1986@gmail.com writes:

> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>
> This patch adds new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH and let
> user space to enable direct tlb flush function when only Hyper-V
> hypervsior capability is exposed to VM. This patch also adds
> enable_direct_tlbflush callback in the struct kvm_x86_ops and
> platforms may use it to implement direct tlb flush support.
>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  Documentation/virtual/kvm/api.txt | 10 ++++++++++
>  arch/x86/include/asm/kvm_host.h   |  2 ++
>  arch/x86/kvm/x86.c                |  8 ++++++++
>  include/uapi/linux/kvm.h          |  1 +
>  4 files changed, 21 insertions(+)
>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 2cd6250b2896..45308ed6dd75 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -5289,3 +5289,13 @@ Architectures: x86
>  This capability indicates that KVM supports paravirtualized Hyper-V IPI send
>  hypercalls:
>  HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
> +8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
> +
> +Architecture: x86
> +
> +This capability indicates that KVM supports Hyper-V direct tlb flush function.
> +User space should enable this feature only when Hyper-V hypervisor capability
> +is exposed to guest and KVM profile is hided. Both Hyper-V and KVM hypercalls
> +use RAX and RCX registers to pass parameters. If KVM hypercall is exposed
> +to L2 guest with direct tlbflush enabled, Hyper-V may mistake KVM hypercall
> +for Hyper-V tlb flush Hypercall due to paremeter register overlap.

First, we need to explicitly state that this is for KVM on Hyper-V and
second, that this disables normal hypercall handling by KVM.

My take:

This capability indicates that KVM running on top of Hyper-V hypervisor
enables Direct TLB flush for its guests meaning that TLB flush
hypercalls are handled by Level 1 hypervisor (Hyper-V) bypassing KVM. 
Due to the different ABI for hypercall parameters between Hyper-V and
KVM, enabling this capability effectively disables all hypercall
handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
flush hypercalls by Hyper-C) so userspace should disable KVM
identification in CPUID.

I think we should also enforce this somehow leaving only Hyper-V style
hypercalls handling (for Windows guests) in place.

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0cc5b611a113..667d154e89d4 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1205,6 +1205,8 @@ struct kvm_x86_ops {
>  	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
>  
>  	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
> +
> +	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
>  };
>  
>  struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9d7b9e6a0939..a9d8ee7f7bf0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3183,6 +3183,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = kvm_x86_ops->get_nested_state ?
>  			kvm_x86_ops->get_nested_state(NULL, NULL, 0) : 0;
>  		break;
> +	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
> +		r = kvm_x86_ops->enable_direct_tlbflush ? 1 : 0;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -3953,6 +3956,11 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  				r = -EFAULT;
>  		}
>  		return r;
> +	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
> +		if (!kvm_x86_ops->enable_direct_tlbflush)
> +			return -ENOTTY;
> +
> +		return kvm_x86_ops->enable_direct_tlbflush(vcpu);
>  
>  	default:
>  		return -EINVAL;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a7c19540ce21..cb959bc925b1 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -996,6 +996,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
>  #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
>  #define KVM_CAP_PMU_EVENT_FILTER 173
> +#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 174
>  
>  #ifdef KVM_CAP_IRQ_ROUTING

-- 
Vitaly
