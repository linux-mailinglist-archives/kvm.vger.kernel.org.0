Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7A6D67D8
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 18:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388276AbfJNQ6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 12:58:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731685AbfJNQ6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 12:58:53 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 49573811DE
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 16:58:52 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id t11so8727569wro.10
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 09:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=53yWgCHYFNYE0GMS0DhChsmHlwOC2QSDfMG0NJy6t7k=;
        b=cGHbXqNpy5ERpy7/jHHFlCZtIrNnOvMtwioGp7OVCj9OGKYuCbDY5qRqNzPEkg6AI/
         EsnKdSTNVdPoNi7zuBGjhpS1RYsFiuEzKcTdCmOg4BaV2G3Gdirm814AYcEqtz8VTyRs
         9kw/sjsbAQuzpKpZHeqe6RIXTSf+45kVYqpmdjLSlKMwWEYOizCk1WfRxjm+duJ7CWNe
         GOH3mhUT8qynE/L4QlW/I19mQ61/qIKKD5WDLQ53LB+LuHW0bnvDow0FCy2UxdaOYnFq
         CdL8Xw4dpYEx/41A4EJZPf8ErZQ8r7OFQfcsMNT7X1aQHQxlXtc46XYl+4c/2KWB1VaS
         iv+w==
X-Gm-Message-State: APjAAAUWNB4xbuB5EH9nqZKEJ8TUcx/CGLbijG2Ayn7yb+mH/n5EpiJv
        q9zuy7GzLZFND7zGSlt960kyK76h/J0AezAQ0huFQRrY8j5gvUqGQkPxVa8h3TFKqiDA32OoO7N
        Q6UaIQ7mhI3/Z
X-Received: by 2002:a5d:6506:: with SMTP id x6mr26216783wru.366.1571072330934;
        Mon, 14 Oct 2019 09:58:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy29QXNDkzs0ABnrp7L2o9CBgQDvW3W5YXovGGUlyudU4ScwmFpVyd0QdjMuduYFS4w2SAnnA==
X-Received: by 2002:a5d:6506:: with SMTP id x6mr26216765wru.366.1571072330677;
        Mon, 14 Oct 2019 09:58:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r27sm54134243wrc.55.2019.10.14.09.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 09:58:49 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
In-Reply-To: <20191014162247.61461-1-xiaoyao.li@intel.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
Date:   Mon, 14 Oct 2019 18:58:49 +0200
Message-ID: <87y2xn462e.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> They are duplicated codes to create vcpu.arch.{user,guest}_fpu in VMX
> and SVM. Make them common functions.
>
> No functional change intended.

Would it rather make sense to move this code to
kvm_arch_vcpu_create()/kvm_arch_vcpu_destroy() instead?

>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/svm.c     | 20 +++-----------------
>  arch/x86/kvm/vmx/vmx.c | 20 +++-----------------
>  arch/x86/kvm/x86.h     | 26 ++++++++++++++++++++++++++
>  3 files changed, 32 insertions(+), 34 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index e479ea9bc9da..0116a3c37a07 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2156,21 +2156,9 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
>  		goto out;
>  	}
>  
> -	svm->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
> -						     GFP_KERNEL_ACCOUNT);
> -	if (!svm->vcpu.arch.user_fpu) {
> -		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
> -		err = -ENOMEM;
> +	err = kvm_vcpu_create_fpu(&svm->vcpu);
> +	if (err)
>  		goto free_partial_svm;
> -	}
> -
> -	svm->vcpu.arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
> -						     GFP_KERNEL_ACCOUNT);
> -	if (!svm->vcpu.arch.guest_fpu) {
> -		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
> -		err = -ENOMEM;
> -		goto free_user_fpu;
> -	}
>  
>  	err = kvm_vcpu_init(&svm->vcpu, kvm, id);
>  	if (err)
> @@ -2231,9 +2219,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
>  uninit:
>  	kvm_vcpu_uninit(&svm->vcpu);
>  free_svm:
> -	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.guest_fpu);
> -free_user_fpu:
> -	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.user_fpu);
> +	kvm_vcpu_free_fpu(&svm->vcpu);
>  free_partial_svm:
>  	kmem_cache_free(kvm_vcpu_cache, svm);
>  out:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e660e28e9ae0..53d9298ff648 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6710,21 +6710,9 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  	if (!vmx)
>  		return ERR_PTR(-ENOMEM);
>  
> -	vmx->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
> -			GFP_KERNEL_ACCOUNT);
> -	if (!vmx->vcpu.arch.user_fpu) {
> -		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
> -		err = -ENOMEM;
> +	err = kvm_vcpu_create_fpu(&vmx->vcpu);
> +	if (err)
>  		goto free_partial_vcpu;
> -	}
> -
> -	vmx->vcpu.arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
> -			GFP_KERNEL_ACCOUNT);
> -	if (!vmx->vcpu.arch.guest_fpu) {
> -		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
> -		err = -ENOMEM;
> -		goto free_user_fpu;
> -	}
>  
>  	vmx->vpid = allocate_vpid();
>  
> @@ -6825,9 +6813,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  	kvm_vcpu_uninit(&vmx->vcpu);
>  free_vcpu:
>  	free_vpid(vmx->vpid);
> -	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
> -free_user_fpu:
> -	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
> +	kvm_vcpu_free_fpu(&vmx->vcpu);
>  free_partial_vcpu:
>  	kmem_cache_free(kvm_vcpu_cache, vmx);
>  	return ERR_PTR(err);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 45d82b8277e5..c27e7ac91337 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -367,4 +367,30 @@ static inline bool kvm_pat_valid(u64 data)
>  void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
>  void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
>  
> +static inline int kvm_vcpu_create_fpu(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
> +			GFP_KERNEL_ACCOUNT);
> +	if (!vcpu->arch.user_fpu) {
> +		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
> +		return -ENOMEM;
> +	}
> +
> +	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
> +			GFP_KERNEL_ACCOUNT);
> +	if (!vcpu->arch.guest_fpu) {
> +		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
> +		kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void kvm_vcpu_free_fpu(struct kvm_vcpu *vcpu)
> +{
> +	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
> +	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
> +}
> +
>  #endif

-- 
Vitaly
