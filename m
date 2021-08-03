Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A029C3DE917
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 11:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbhHCJAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 05:00:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234740AbhHCJAj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 05:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627981229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Q7/xPZm8jUnnjCMCdU0R6LgFCbSeWcpFM+7y2Jr/KQ=;
        b=Gy9jfYn2yB5Sezmh0Aug/hb+3+rkKUKkYWHt1wcYY/NbEk42Sou0CwVmNibuenSqI7YbSK
        2hj9rh77Jl2x5alPV7Jwo2imUoIMgdVWVqsYMNAmUE5GUzTPGpvTKDwslmg/L6mEeP3hIQ
        eyfXRGMpTgoYKwINp5oIT0sGuS3O7KE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-D0Effw4IMv-0UpNHHkuosw-1; Tue, 03 Aug 2021 05:00:27 -0400
X-MC-Unique: D0Effw4IMv-0UpNHHkuosw-1
Received: by mail-wm1-f69.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so3707651wmj.8
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 02:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Q7/xPZm8jUnnjCMCdU0R6LgFCbSeWcpFM+7y2Jr/KQ=;
        b=Tco/Y3JV05FdS1BOB6GRxRBHNvEjRpzJila6uHVeLdBRwSn25OpCQlPoqD6PAbFBrJ
         Is0YaeV49l2i+XzFgT/PUk9tej9kunFRA1H+KVBhUXM+Gf9N+/++B0Mr19kEH9JH1qK2
         UQoTl5avVMK7Mn7fg/kvIrSEeRQ4xxMxCw3V3ghjCK6S3/n8+Y+gekh6B1FtU61vgICu
         a6lh4PrhulSugoyRmr/oIr12kdWurl907kpLjKUgxODynsJDvuEmGisCXpF8B759N9Tx
         1h+DMuYS9RfjR71Z3liGLX106o7EBW4f21DNrhhOX9hmYwDPceXgifw7J/LRvn4Tiwq6
         bUPA==
X-Gm-Message-State: AOAM532jdM2LPQx9rezEegqcGHJp91pp818lTuIpfG8USUgi9wVD14ev
        cECGLkUwa7HF1PQc/d6DbBATzH7WZA8ccYLrd8oILfgnOdxSV2EcMfUCw5uuaMQT2r8ew9FXpQc
        Ei8FsplGJPxUL
X-Received: by 2002:a7b:cc98:: with SMTP id p24mr3165687wma.118.1627981226477;
        Tue, 03 Aug 2021 02:00:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykQE+5VkJxZIVMbxOmNBn0QTX3WJWN0Jt8B5Z7DzZM/I/IFQQ7DsCaWyGb+4kCxVZ7I5vUxg==
X-Received: by 2002:a7b:cc98:: with SMTP id p24mr3165653wma.118.1627981226235;
        Tue, 03 Aug 2021 02:00:26 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id n11sm16313687wrs.81.2021.08.03.02.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 02:00:25 -0700 (PDT)
Subject: Re: [PATCH v3 02/12] KVM: x86/mmu: bump mmu notifier count in
 kvm_zap_gfn_range
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
 <20210802183329.2309921-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8cae345b-767d-69fe-b7dc-7be559c18e2a@redhat.com>
Date:   Tue, 3 Aug 2021 11:00:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802183329.2309921-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 20:33, Maxim Levitsky wrote:
> This together with previous patch, ensures that
> kvm_zap_gfn_range doesn't race with page fault
> running on another vcpu, and will make this page fault code
> retry instead.
> 
> This is based on a patch suggested by Sean Christopherson:
> https://lkml.org/lkml/2021/7/22/1025
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/mmu/mmu.c   | 4 ++++
>   include/linux/kvm_host.h | 5 +++++
>   virt/kvm/kvm_main.c      | 7 +++++--
>   3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9d78cb1c0f35..9da635e383c2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5640,6 +5640,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>   
>   	write_lock(&kvm->mmu_lock);
>   
> +	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
> +
>   	if (kvm_memslots_have_rmaps(kvm)) {
>   		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>   			slots = __kvm_memslots(kvm, i);
> @@ -5671,6 +5673,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>   	if (flush)
>   		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
>   
> +	kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
> +
>   	write_unlock(&kvm->mmu_lock);
>   }
>   
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9d6b4ad407b8..962e11a73e8e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -985,6 +985,11 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
>   void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>   #endif
>   
> +void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
> +				   unsigned long end);
> +void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
> +				   unsigned long end);
> +
>   long kvm_arch_dev_ioctl(struct file *filp,
>   			unsigned int ioctl, unsigned long arg);
>   long kvm_arch_vcpu_ioctl(struct file *filp,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a96cbe24c688..71042cd807b3 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -608,7 +608,7 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>   	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
>   }
>   
> -static void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
> +void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
>   				   unsigned long end)
>   {
>   	/*
> @@ -636,6 +636,7 @@ static void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
>   			max(kvm->mmu_notifier_range_end, end);
>   	}
>   }
> +EXPORT_SYMBOL_GPL(kvm_inc_notifier_count);
>   
>   static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>   					const struct mmu_notifier_range *range)
> @@ -670,7 +671,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>   	return 0;
>   }
>   
> -static void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
> +void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
>   				   unsigned long end)
>   {
>   	/*
> @@ -687,6 +688,8 @@ static void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
>   	 */
>   	kvm->mmu_notifier_count--;
>   }
> +EXPORT_SYMBOL_GPL(kvm_dec_notifier_count);
> +
>   
>   static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
>   					const struct mmu_notifier_range *range)
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

