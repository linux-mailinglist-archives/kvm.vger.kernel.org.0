Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79674747A73
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 01:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjGDXj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 19:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjGDXjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 19:39:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F20BD
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 16:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688513923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SWDhkOVApoINIA9ZPTjwVACEMtw6P7Jwrml0wL1EZHc=;
        b=OUBYMBo3vWBhzsbumsrIvLhaSqR5cjD1cIS/acQk6XIDkjVCFXz9QudtkCd9vw008QxeLA
        PqVrVZuAV5wTiU5MDKFHe1syGbOq8WrZyfas8FVS0BggCUW4d8Rv7RJccP3qiUvgjY58jj
        Dztr0UoJ+3f+8As+bReBv5X4490xWQk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-sHUD6qIGPrWNjakzMJ0Leg-1; Tue, 04 Jul 2023 19:38:42 -0400
X-MC-Unique: sHUD6qIGPrWNjakzMJ0Leg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-262dc0ba9ceso8551314a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 16:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688513921; x=1691105921;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SWDhkOVApoINIA9ZPTjwVACEMtw6P7Jwrml0wL1EZHc=;
        b=Jq7wLRVm/sED3Xk3jxwz9d9Qf8yhDftmd2iwFoF8fPpv2CFrbR3ttQUHWmdwE26HxG
         K8mDejnrvIw4Fc0L1h+Jko5bkoZmhLDh4IJMtZnMGAOE49FguxShJxjB3cwxIhs9kG0+
         cJpi1jLBBcwIWWxbmT1OHLCtIYtzMIjXWSkr7rmuJSnFHdWpA0EvylpKP7hJWh85DKp1
         A1wNuP7/M5BW1bGsCGnxwPkJhqM2kuPhW14BbnR+fohlQjV5fXjvRCYMe2K5fzXELM45
         E5+nedqV0UKC9IwuqUA+KWqdcyXIVWiGbaqgS88qTkCZNRrZukAJzoqnpcClHq2UOi1f
         2MyA==
X-Gm-Message-State: ABy/qLbMPRB1qoWtRlFXSbheA7cC+60bC206FhmV5rcuOZhKxOx9L5Yp
        hfvbgRc9e4VMXZ75Kc2TcL0JphcKtqWht8fS2aqn6RypeKj1v8PS1suauEJeimgMw6W4Z7WMcMr
        aDkz2qR2Gan/+
X-Received: by 2002:a17:90a:7641:b0:262:ece1:5fd9 with SMTP id s1-20020a17090a764100b00262ece15fd9mr14738231pjl.10.1688513921229;
        Tue, 04 Jul 2023 16:38:41 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHfls3apKYfxtWv5bhdPy2UoDWu5/VjPgAeE1/ReT1Nw7wtyUQjKzd0aoDX/dDFJoegi2Jyew==
X-Received: by 2002:a17:90a:7641:b0:262:ece1:5fd9 with SMTP id s1-20020a17090a764100b00262ece15fd9mr14738208pjl.10.1688513920891;
        Tue, 04 Jul 2023 16:38:40 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id a6-20020a1709027d8600b001b392bf9192sm17621326plm.145.2023.07.04.16.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 16:38:40 -0700 (PDT)
Message-ID: <0bdc3105-fc3d-d0e1-60e7-d626171e1057@redhat.com>
Date:   Wed, 5 Jul 2023 09:38:29 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 02/11] KVM: arm64: Use
 kvm_arch_flush_remote_tlbs()
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
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Zenghui Yu <zenghui.yu@linux.dev>
References: <20230621175002.2832640-1-rananta@google.com>
 <20230621175002.2832640-3-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-3-rananta@google.com>
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

On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Use kvm_arch_flush_remote_tlbs() instead of
> CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL. The two mechanisms solve the same
> problem, allowing architecture-specific code to provide a non-IPI
> implementation of remote TLB flushing.
> 
> Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
> all architectures on kvm_arch_flush_remote_tlbs() instead of maintaining
> two mechanisms.
> 
> Opt to standardize on kvm_arch_flush_remote_tlbs() since it avoids
> duplicating the generic TLB stats across architectures that implement
> their own remote TLB flush.
> 
> This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
> path, but that is a small cost in comparison to flushing remote TLBs.
> 
> No functional change intended.
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It's not true and please refer to the below explanation.

> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
> Acked-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/Kconfig            | 1 -
>   arch/arm64/kvm/mmu.c              | 6 +++---
>   virt/kvm/Kconfig                  | 3 ---
>   virt/kvm/kvm_main.c               | 2 --
>   5 files changed, 6 insertions(+), 9 deletions(-)
> 

The changes make sense and look good to me. However, there is a functional change because
the generic kvm_arch_flush_remote_tlbs() isn't exactly same to ARM64's variant. Strictly
speaking, they're not interchangeable. In the generic function, both statistics (
remote_tlb_flush_requests and remote_tlb_flush) are increased. Only the former statistic
is increased in ARM64's variant.

It looks correct to increase both statistics, but the commit log may need tweak to reflect
it. With this resolved:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7e7e19ef6993e..81ab41b84f436 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1078,6 +1078,9 @@ int __init kvm_set_ipa_limit(void);
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
> index f531da6b362e9..6b730fcfee379 100644
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
> index 3b9d4d24c361a..d0a0d3dca9316 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -81,15 +81,15 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
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
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index b74916de5183a..484d0873061ca 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -62,9 +62,6 @@ config HAVE_KVM_CPU_RELAX_INTERCEPT
>   config KVM_VFIO
>          bool
>   
> -config HAVE_KVM_ARCH_TLB_FLUSH_ALL
> -       bool
> -
>   config HAVE_KVM_INVALID_WAKEUPS
>          bool
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a475ff9ef156d..600a985b86215 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -350,7 +350,6 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
>   }
>   EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
>   
> -#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
>   void kvm_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	++kvm->stat.generic.remote_tlb_flush_requests;
> @@ -371,7 +370,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>   		++kvm->stat.generic.remote_tlb_flush;
>   }
>   EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
> -#endif
>   
>   static void kvm_flush_shadow_all(struct kvm *kvm)
>   {

