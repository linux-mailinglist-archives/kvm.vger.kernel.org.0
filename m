Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6643E6A9387
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 10:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjCCJPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 04:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCCJPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 04:15:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124C3149A7
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 01:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677834897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wnl4G7Xh5CvB+FtHVG1C7RoK/+CAnEZD+17PHCsomsk=;
        b=TWCt55kR6f5V+yjK8OxAEbGlQp+oXrPJQP5jSqT/j2m54QJ2YG52WgvZKuLJRaQoqjHDnp
        cRUga4B3ecZF/vFiIBeOr0TwExTMB6HcB6qKHylI1duDLSNkSXXjzf9gott1cT7G3ncXIb
        GhXGmqqTYCi2pEjWPeHPfEriPlg+MrE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-Ezj1rjf0Ov-MHdjR879lFw-1; Fri, 03 Mar 2023 04:14:56 -0500
X-MC-Unique: Ezj1rjf0Ov-MHdjR879lFw-1
Received: by mail-qv1-f69.google.com with SMTP id m1-20020a05621402a100b004bb706b3a27so1060137qvv.20
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 01:14:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677834895;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wnl4G7Xh5CvB+FtHVG1C7RoK/+CAnEZD+17PHCsomsk=;
        b=YfE9qkL4llPw7nRQG8Eoci/tSxikYUfVL4bPgRqMu1IJU1YF+SrW42yMJAmdSvkKo9
         u9Or5UZHw1uegYNSY5b0/yh3KMWMfFNnZVQuPsTFWlQBw/J2mxpOhpmgZ8tuCCXP3vTy
         0gRi4Ff92QATPBibnZP6rOEHmoiwfZaIyfsa4gesMYl9EQyiQ4+V+plbCeZSyxpJqy7c
         Gm/EyozogVnIGR85ldze2PN1KWXVaW6i5je0ZvDQfLPEF1V6Yl67ZJUslv/N94Rg1vql
         7Le2oSLeDCA6Np1GtOHmOQyqdB7i3w2LMU6LrIDL0CsoPlZyFPKo0eOiGqW1RutdltkE
         qluw==
X-Gm-Message-State: AO0yUKVa5WUefV2OpTglrTKm+dMl1NIb482Mv73n+F8FmKPcj7YxNrhJ
        cxIOtobD4knRugjU381t9iyhPPAEK2VYUo2HRNjgpaEyHEW+eb3l1A4fL86rXh48GxsSmqRzqQD
        sTjRPTqopddN/
X-Received: by 2002:a0c:f252:0:b0:56e:89b9:9a92 with SMTP id z18-20020a0cf252000000b0056e89b99a92mr1677886qvl.0.1677834895606;
        Fri, 03 Mar 2023 01:14:55 -0800 (PST)
X-Google-Smtp-Source: AK7set8Oon3JEryPmpvkzn4BXeyH+owWGVq0cEzAlMUQ2IC/xiSsTl75uAXSBNWx0LttYq51PFDSXQ==
X-Received: by 2002:a0c:f252:0:b0:56e:89b9:9a92 with SMTP id z18-20020a0cf252000000b0056e89b99a92mr1677844qvl.0.1677834895127;
        Fri, 03 Mar 2023 01:14:55 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d11-20020a05620a158b00b0073b8745fd39sm1323195qkk.110.2023.03.03.01.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:14:54 -0800 (PST)
Message-ID: <78db9523-880c-2899-2cee-a07dc9b8f282@redhat.com>
Date:   Fri, 3 Mar 2023 17:14:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-7-ricarkol@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-7-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/2/23 05:09, Ricardo Koller wrote:
> Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd() into it. A
> future commit will add some more things to do inside of
> kvm_uninit_stage2_mmu().
> 
> No functional change intended.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_mmu.h | 1 +
>   arch/arm64/kvm/mmu.c             | 7 ++++++-
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index e4a7e6369499..058f3ae5bc26 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -167,6 +167,7 @@ void free_hyp_pgds(void);
>   
>   void stage2_unmap_vm(struct kvm *kvm);
>   int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
> +void kvm_uninit_stage2_mmu(struct kvm *kvm);
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>   int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   			  phys_addr_t pa, unsigned long size, bool writable);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d2c5e6992459..812633a75e74 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -766,6 +766,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	return err;
>   }
>   
> +void kvm_uninit_stage2_mmu(struct kvm *kvm)
> +{
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +}
> +
>   static void stage2_unmap_memslot(struct kvm *kvm,
>   				 struct kvm_memory_slot *memslot)
>   {
> @@ -1855,7 +1860,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
>   
>   void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   {
> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +	kvm_uninit_stage2_mmu(kvm);
>   }
>   
>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm,

-- 
Shaoqin

