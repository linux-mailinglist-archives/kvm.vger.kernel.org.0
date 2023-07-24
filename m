Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA12575EED1
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjGXJOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjGXJOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:14:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27527F9
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690189995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//aPJH4zrPdTDxzMzJs7UJ4GFjBaI2aqgPX71P6a5dg=;
        b=EdpSH20O6hBtNaUWGY+aZ3dcIoEILO1mfnze/e7FrZHaufxALp2KCx91hpsThusL152tGF
        a1FytrawC7lAZaLJSzXV8GqA7tXakWmmZZdaLvP1e95mUqIkOR6NrCY2GVhaEtixKSyaz0
        SUlfvBSmZLok4fHfuHBRjo6PGMeugyQ=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-ClvYRsllMVOpEwj6K4HD1Q-1; Mon, 24 Jul 2023 05:13:14 -0400
X-MC-Unique: ClvYRsllMVOpEwj6K4HD1Q-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-262ef5650acso1002251a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690189992; x=1690794792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=//aPJH4zrPdTDxzMzJs7UJ4GFjBaI2aqgPX71P6a5dg=;
        b=HEmPXKxZ4gfkm+h344PTlhYNc0Mgmsa2nXzGPRIgP9NKZXYPDBMNsXvPQwb8B/3avA
         s3W8Ez8jQstAlY4/2sgeZDdg/wc7dNsPUyDj0/XkhQbTfT95iSNCOISLOTk69Wi+jN5+
         0pcUjQ/95d4cvx430Evuiv7Mtv7chF7YTD42qolmYtaGMDcvjySYf/6KsIFlAdIC+m9l
         JuEf5H4TaIFa3H1a2//y52K36TECjKxNbhVK+svalGqSqdeOM4h+Gh/YQDWW49NEGLSj
         JjkRaQ6afn0WTjUure7gRLQc2WJdv/zXTfot0C/EgnNooFytg2GiltKDsGAfwA0korKt
         NLfg==
X-Gm-Message-State: ABy/qLYz7YyLrHJEjHsGjzikvlwcfql5mmxjDnz6Xh8AWAuR5wDoV2/t
        x8tl1BC8Ji+XrM1yjkiE1+MmwC6NmRqQa0IVzSjHNfTVitrrJu2A/WFBgghOmSqwhADH7ZSlysA
        3yANarCk/le2a
X-Received: by 2002:a17:902:ce92:b0:1b8:1591:9f81 with SMTP id f18-20020a170902ce9200b001b815919f81mr12102532plg.4.1690189992436;
        Mon, 24 Jul 2023 02:13:12 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFYYex+PeZplrxlN0jNWs984ysaSZQSKu+vtitozLwa1hyTQD6SfImYNcNMAys3P7/0AANuTw==
X-Received: by 2002:a17:902:ce92:b0:1b8:1591:9f81 with SMTP id f18-20020a170902ce9200b001b815919f81mr12102507plg.4.1690189992175;
        Mon, 24 Jul 2023 02:13:12 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w7-20020a170902e88700b001b06c106844sm8389140plg.151.2023.07.24.02.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 02:13:11 -0700 (PDT)
Message-ID: <bab509a1-5096-4ca0-e043-898d941e200a@redhat.com>
Date:   Mon, 24 Jul 2023 17:13:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230722022251.3446223-1-rananta@google.com>
 <20230722022251.3446223-3-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230722022251.3446223-3-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/22/23 10:22, Raghavendra Rao Ananta wrote:
> Stop depending on CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL and opt to
> standardize on kvm_arch_flush_remote_tlbs() since it avoids
> duplicating the generic TLB stats across architectures that implement
> their own remote TLB flush.
> 
> This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
> path, but that is a small cost in comparison to flushing remote TLBs.
> 
> In addition, instead of just incrementing remote_tlb_flush_requests
> stat, the generic interface would also increment the
> remote_tlb_flush stat.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/Kconfig            | 1 -
>   arch/arm64/kvm/mmu.c              | 6 +++---
>   3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8b6096753740..7281222f24ef 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1111,6 +1111,9 @@ int __init kvm_set_ipa_limit(void);
>   #define __KVM_HAVE_ARCH_VM_ALLOC
>   struct kvm *kvm_arch_alloc_vm(void);
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> +
>   static inline bool kvm_vm_is_protected(struct kvm *kvm)
>   {
>   	return false;
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index f531da6b362e..6b730fcfee37 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -25,7 +25,6 @@ menuconfig KVM
>   	select MMU_NOTIFIER
>   	select PREEMPT_NOTIFIERS
>   	select HAVE_KVM_CPU_RELAX_INTERCEPT
> -	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
>   	select KVM_MMIO
>   	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>   	select KVM_XFER_TO_GUEST_WORK
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6db9ef288ec3..0ac721fa27f1 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -161,15 +161,15 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>   }
>   
>   /**
> - * kvm_flush_remote_tlbs() - flush all VM TLB entries for v7/8
> + * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
>    * @kvm:	pointer to kvm structure.
>    *
>    * Interface to HYP function to flush all VM TLB entries
>    */
> -void kvm_flush_remote_tlbs(struct kvm *kvm)
> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
> -	++kvm->stat.generic.remote_tlb_flush_requests;
>   	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> +	return 0;
>   }
>   
>   static bool kvm_is_device_pfn(unsigned long pfn)

-- 
Shaoqin

