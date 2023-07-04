Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703A1747A55
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 01:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjGDXYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 19:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjGDXYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 19:24:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59FEE7A
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 16:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688512999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4PCpsOElklGvTmmWH0OQRonwleLOQrzWZC/RGYQTYPQ=;
        b=Vk17hLkYP+wOQPkcJOBZCYcxM/zpqLXnZtwEu/Ecx0hG/BqHefzFbo4JCQPZp0YVyJciBa
        bq+qQOMUYoj/4VirRnbR7zCIK/XADcmsJl1/mn/bosmgrSQuDLD7leihWO80znhUa6b6Ov
        pzRWYIR1riBHnAWEEFPvB1VYUcMbqLc=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-R__n823nMVCIha4H3a7Adg-1; Tue, 04 Jul 2023 19:23:17 -0400
X-MC-Unique: R__n823nMVCIha4H3a7Adg-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-66a634b2cf5so165635b3a.0
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 16:23:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688512997; x=1691104997;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4PCpsOElklGvTmmWH0OQRonwleLOQrzWZC/RGYQTYPQ=;
        b=LpioWAVOr4efwLDF8z24H4nlD9Gr/TVOCTbne4APii6u4YLvweaH5ivnRgIMw0IM7P
         wbZ8iYzD6PgVB/oKX3Xpjfntx1NPgMZV1Ku/Hyv9yFRffcBnsQ4kAN/Ttzx4K6CpEwgI
         MDarJe5b5rEjnvGv60wiS7sAVjPysfSzls5l/DDBzt3vSPh6cbOsCCRp4k0OWrt18e/1
         R2dmHpc3KHE5EV/TwUrNqVB4udZZXQvI+iQzegh+4U5TAlkk7XEXKygnKkXN7Znll+vJ
         EX6viLRdVpmWVeH1oPN7wWXoWw5ZsIfrd4VAO4qa9cP/UHuqIup5nQfimCzo+TmkQ5XD
         pcSA==
X-Gm-Message-State: ABy/qLbTp8+cyAO7OwGt2cr6zmmrD+c8W+y6BUDp93U747V/2HCAvVPk
        MfVtwFdcyGtSKBVuFtKK+NgRCCebqpwgxH0d9Pj7Ztjf0OtmsRhyzLTux+1+GISbU4KC8j0DFvY
        +o8yA93IuBWCK
X-Received: by 2002:a05:6a00:1ca9:b0:682:5e8f:d8ba with SMTP id y41-20020a056a001ca900b006825e8fd8bamr724734pfw.11.1688512996827;
        Tue, 04 Jul 2023 16:23:16 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG0UBpOEK5SPsF31xr5f/9Wg1BBxO8IhEOWDLX7lSVKCKwsJxsntJWPkQLzTCSx4pQPuvCDfA==
X-Received: by 2002:a05:6a00:1ca9:b0:682:5e8f:d8ba with SMTP id y41-20020a056a001ca900b006825e8fd8bamr724711pfw.11.1688512996441;
        Tue, 04 Jul 2023 16:23:16 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id bn10-20020a056a00324a00b0065980654baasm16109591pfb.130.2023.07.04.16.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 16:23:15 -0700 (PDT)
Message-ID: <b977abe4-71b9-daa1-da1b-b111f0afbe51@redhat.com>
Date:   Wed, 5 Jul 2023 09:23:05 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 01/11] KVM: Rename kvm_arch_flush_remote_tlb()
 to kvm_arch_flush_remote_tlbs()
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
        kvm@vger.kernel.org
References: <20230621175002.2832640-1-rananta@google.com>
 <20230621175002.2832640-2-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-2-rananta@google.com>
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

On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Rename kvm_arch_flush_remote_tlb() and the associated macro
> __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB to kvm_arch_flush_remote_tlbs() and
> __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS respectively.
> 
> Making the name plural matches kvm_flush_remote_tlbs() and makes it more
> clear that this function can affect more than one remote TLB.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/mips/include/asm/kvm_host.h | 4 ++--
>   arch/mips/kvm/mips.c             | 2 +-
>   arch/x86/include/asm/kvm_host.h  | 4 ++--
>   include/linux/kvm_host.h         | 4 ++--
>   virt/kvm/kvm_main.c              | 2 +-
>   5 files changed, 8 insertions(+), 8 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 957121a495f0b..1473cf923ee37 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -896,7 +896,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   
> -#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> -int kvm_arch_flush_remote_tlb(struct kvm *kvm);
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>   
>   #endif /* __MIPS_KVM_HOST_H__ */
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 884be4ef99dc1..6e34bbe244462 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -981,7 +981,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>   
>   }
>   
> -int kvm_arch_flush_remote_tlb(struct kvm *kvm)
> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	kvm_mips_callbacks->prepare_flush_shadow(kvm);
>   	return 1;
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fb9d1f2d6136c..f6e3aa617d8b8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1794,8 +1794,8 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
>   #define __KVM_HAVE_ARCH_VM_FREE
>   void kvm_arch_free_vm(struct kvm *kvm);
>   
> -#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> -static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> +static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	if (kvm_x86_ops.flush_remote_tlbs &&
>   	    !static_call(kvm_x86_flush_remote_tlbs)(kvm))
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0e571e973bc28..95c3e364f24b4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1477,8 +1477,8 @@ static inline void kvm_arch_free_vm(struct kvm *kvm)
>   }
>   #endif
>   
> -#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> -static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
> +#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> +static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	return -ENOTSUPP;
>   }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cb5c13eee1936..a475ff9ef156d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -366,7 +366,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>   	 * kvm_make_all_cpus_request() reads vcpu->mode. We reuse that
>   	 * barrier here.
>   	 */
> -	if (!kvm_arch_flush_remote_tlb(kvm)
> +	if (!kvm_arch_flush_remote_tlbs(kvm)
>   	    || kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
>   		++kvm->stat.generic.remote_tlb_flush;
>   }

