Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3647751D0
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 06:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjHIELQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 00:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjHIELP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 00:11:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4081BD9
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 21:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691554228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tiZt5qkV373iiZscCJbcFROPFCou/fOb43yGS5e3+0c=;
        b=OkBpJ4hjb4XeaPhRFCc9NGg1ldWTUzHvjxvWCDdKLNaRinp2X73RgxzCBcGpAtUOl5HLh7
        cEsQDo9nZ271hbPwuSkPUgAqEHTVHgn5UjZepE4mTHaZcrYVG/jTINy9RKu8pI8Evb2j+v
        xQw+/fnr7bIOCatNhho+6EGg7/nMNvY=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-OZPhGWR4O26V5R6MtAUYxw-1; Wed, 09 Aug 2023 00:10:27 -0400
X-MC-Unique: OZPhGWR4O26V5R6MtAUYxw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-686bc3f11feso479321b3a.0
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 21:10:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691554223; x=1692159023;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tiZt5qkV373iiZscCJbcFROPFCou/fOb43yGS5e3+0c=;
        b=bE0kmsxLRce1TAHsmIS/60XPuD3kSs9i9HPOwLFcl87/0iZTVuzxAMOdEXIOlkefH0
         L3lMYEaLMMOw1gAm8VJOzKHfz2chKJFjCDZHdn9EnucF/ZZHS6ayq/7JtElPGNzDM26n
         gz6CpPFQ9AR/uzIOYtarpI8FUv/hmHIrdR+mJPCeBDVYnR9iBjm96VcO+sr91Ai1UkHs
         JHWmSj51Bz3kE9sy2w50geDTeT2EYH1phF1RGesYfBWJasohylocmeSb/1ehE4CjUuQC
         arJ3XSfGt8I+WtApFhxUtfsAA9BY0/q7nr1hQfQaJ9bqpEafNW5fjzAwLuHF/n+WO/3s
         1R3Q==
X-Gm-Message-State: AOJu0YyjcqAs6wc4RrL4z9z3wpuQqjWSN/I76tXPGADz1u8JklA7fU2B
        UJdLC1zC9mbwewtiYn6DeDnqVMbmuh11CvMlEYElAJefhxwl6sds5yXC9ddDqHSowuX35+TSuwj
        BLg2GUJQXVakv
X-Received: by 2002:a05:6a00:1487:b0:666:eaaf:a2af with SMTP id v7-20020a056a00148700b00666eaafa2afmr2263667pfu.14.1691554222957;
        Tue, 08 Aug 2023 21:10:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4mKNqTgX+EsfCEP/MYW99W9JIOB5kHuLZbEs18DPRnq1dfDRhMLd6YmPemv3TlybaLWWmcQ==
X-Received: by 2002:a05:6a00:1487:b0:666:eaaf:a2af with SMTP id v7-20020a056a00148700b00666eaafa2afmr2263648pfu.14.1691554222702;
        Tue, 08 Aug 2023 21:10:22 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id p26-20020a62ab1a000000b006871fdde2c7sm8840727pff.110.2023.08.08.21.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 21:10:22 -0700 (PDT)
Message-ID: <b91d1869-3a1d-d9eb-27b0-0aac94cca8e0@redhat.com>
Date:   Wed, 9 Aug 2023 14:10:12 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v8 03/14] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
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
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-4-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230808231330.3855936-4-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
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
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 2 ++
>   arch/arm64/kvm/Kconfig            | 1 -
>   arch/arm64/kvm/mmu.c              | 6 +++---
>   3 files changed, 5 insertions(+), 4 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8b6096753740c..20f2ba149c70c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1111,6 +1111,8 @@ int __init kvm_set_ipa_limit(void);
>   #define __KVM_HAVE_ARCH_VM_ALLOC
>   struct kvm *kvm_arch_alloc_vm(void);
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
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
> index 6db9ef288ec38..0ac721fa27f18 100644
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

