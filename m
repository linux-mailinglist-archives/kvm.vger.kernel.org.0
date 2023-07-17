Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6898275618F
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 13:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjGQL2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 07:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjGQL2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 07:28:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46246E4C
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 04:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689593276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cifHTSGxLePrnNdALZCim8wNk8dyI3fwSptrejN9W0Y=;
        b=hH8aywB18HR0fUMtL7sAtCuiqIdayGaVMYt9aO/J3HCGREN6XDvMQZVw+2j6PoJEqo+rxD
        cjVYbnYMdwTrjxVnEdeXUKtNxy/phKRDhwo6CdNX60+XiFxdqCtQOokmwA7r4mclM1V8zS
        tKt0AjkMrB1S5VHP0TFwog4QkyinKBs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169--cWiY7XwMAO5WoNn_mvrSw-1; Mon, 17 Jul 2023 07:27:55 -0400
X-MC-Unique: -cWiY7XwMAO5WoNn_mvrSw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-765ad67e690so108145185a.1
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 04:27:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689593273; x=1690198073;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cifHTSGxLePrnNdALZCim8wNk8dyI3fwSptrejN9W0Y=;
        b=hY2RmK3oW5GJYdx+YqCYdUBkQkVb36eNlt6es/ltJzpab+LHqq7GGWosX343EbUmGa
         xTeTnTnxjnTy2zNFpXIgiFF8r8EiPBDaRBkkX7wPZqpK4maUoHCX6FTEtZ6AhpXCmgG8
         ee9OxVQ0F9JkOKS8xCmormeSQFDNlVjlk3bmj6xQG/iqtFbB5qIaoN1u+/Lj/J9UeIMu
         iUP3/MeMbQ9jWDHEzHvLCl3tCCIHNNUx25c0f1y5VjQAQovB8RrVJDy2yboNLAAqaDmx
         KvLSJhuAhLUpl+/r3tDwrbeMxmuHPEEK+bbHjBF11W8It2xmseXLjPxwA3j5f16Q2d1P
         mVMQ==
X-Gm-Message-State: ABy/qLY8bf3JrVCe4LcIkUOeYWaJFUsWONgIYj0TvQpuRLDoOwa5XlzF
        uztQIo5P1/hAtXegzTacL0wJJEFeYK2rWgPuuUN0hTQpYxpM6tt/JP/u/puwqdFSrToVPHGPy3M
        kokNJgOnDCA8T
X-Received: by 2002:a05:620a:454a:b0:763:c764:577c with SMTP id u10-20020a05620a454a00b00763c764577cmr16480743qkp.5.1689593273639;
        Mon, 17 Jul 2023 04:27:53 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEfp5t2DQS/GjyIoS478X8u5KzsdIEDs8/rcKlb51fLewoRgNMtmXWnZggE+f74jG6LdYamWQ==
X-Received: by 2002:a05:620a:454a:b0:763:c764:577c with SMTP id u10-20020a05620a454a00b00763c764577cmr16480723qkp.5.1689593273369;
        Mon, 17 Jul 2023 04:27:53 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z1-20020a05620a100100b0075b2af4a076sm6028544qkj.16.2023.07.17.04.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 04:27:53 -0700 (PDT)
Message-ID: <0e5dd611-b047-5565-cf09-ad8844386b81@redhat.com>
Date:   Mon, 17 Jul 2023 19:27:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 02/11] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
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
        kvm@vger.kernel.org, Zenghui Yu <zenghui.yu@linux.dev>,
        Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-3-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-3-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/23 08:53, Raghavendra Rao Ananta wrote:
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
> In addition, instead of just incrementing remote_tlb_flush_requests
> stat, the generic interface would also increment the
> remote_tlb_flush stat.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
> Acked-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/Kconfig            | 1 -
>   arch/arm64/kvm/mmu.c              | 6 +++---
>   virt/kvm/Kconfig                  | 3 ---
>   virt/kvm/kvm_main.c               | 2 --
>   5 files changed, 6 insertions(+), 9 deletions(-)
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
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index b74916de5183..484d0873061c 100644
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
> index 70e5479797ac..d6b050786155 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -345,7 +345,6 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
>   }
>   EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
>   
> -#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
>   void kvm_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	++kvm->stat.generic.remote_tlb_flush_requests;
> @@ -366,7 +365,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>   		++kvm->stat.generic.remote_tlb_flush;
>   }
>   EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
> -#endif
>   
>   static void kvm_flush_shadow_all(struct kvm *kvm)
>   {

-- 
Shaoqin

