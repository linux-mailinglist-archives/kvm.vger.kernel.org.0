Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B6C757A3F
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 13:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjGRLQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 07:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjGRLQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 07:16:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A0E10FE
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 04:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689678942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BqFBTcreB9uM7bVA+oKgdwOheFXwxzAShQOYP1vaHLs=;
        b=UoJkDCTCW3UbiMxhNVm7orufGMKqQxto60k8XmQ6T3l3WIMdcoid0v25kanO0d9DeMIlR6
        P/3NaRf6S0R59TyKYGHGnpdMI+o4AABukG080M3tH08A8oh6uiJX7mhaOmMblCSIVwClRB
        Chl+DOesqjiQ8nnB5d6vsPNhmdT89Ss=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-Kodlk8LRNV61WJajvAnzSQ-1; Tue, 18 Jul 2023 07:15:40 -0400
X-MC-Unique: Kodlk8LRNV61WJajvAnzSQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-67f1947c0easo425930b3a.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 04:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689678940; x=1690283740;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BqFBTcreB9uM7bVA+oKgdwOheFXwxzAShQOYP1vaHLs=;
        b=EeLGgT/tPV/OXxig9astkvR97j5twM2TBygmkNoSScjPfiGu7G7nRaI+CWWaU2hVwB
         t/nSTafohfzqpahLE2hIEwtP+QyhaGPlzgOhf1+l5qUG+iWsiD0HF001E5Em2Q45Oa5Z
         RwFaYBzLiqhOPL9iUeL6bb9IMPxis2/vGlyVqFY9yWlkwmNlQawfx2sDzA7fB/MJ+98d
         0TSuPhD0+omAfWo58LUIkfVr9nVON/eniwe1K2Kp3ZDLHadGWjSSfNGOOjqgpjBI2Ss7
         825Yirc8T2dl5nmjndmqscjxcRX80jPXcfdacfhqyMWXAtHuplzSgAJOdf9wLKYHlDjT
         z5Jw==
X-Gm-Message-State: ABy/qLbLJUPuPlo8zOCeMmGRr4J7ZsF0K8TIuAF2IElAYP96DSVJZ1mR
        4xIR/5sRPpb3YTkOxYiiO+FRlSfqSfpe1jyTbeDWYUrZkWL09SJq52cQKg12/71Cg+WfQeYistP
        0+lL0DgS3Jlzc
X-Received: by 2002:a05:6a00:2d06:b0:679:a1f1:a5f8 with SMTP id fa6-20020a056a002d0600b00679a1f1a5f8mr11345524pfb.3.1689678939735;
        Tue, 18 Jul 2023 04:15:39 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEpw9FbepMwI4i8WQLrfFCcRWK4bQzZOcI8bUuVzeTHVwddSiiqvjUkmkgPmHYZSjCF3HQUxg==
X-Received: by 2002:a05:6a00:2d06:b0:679:a1f1:a5f8 with SMTP id fa6-20020a056a002d0600b00679a1f1a5f8mr11345498pfb.3.1689678939458;
        Tue, 18 Jul 2023 04:15:39 -0700 (PDT)
Received: from [10.72.112.40] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s1-20020a63af41000000b00528db73ed70sm1476638pgo.3.2023.07.18.04.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 04:15:39 -0700 (PDT)
Message-ID: <5b2c03a5-5887-d951-6c3d-f71b49e683fc@redhat.com>
Date:   Tue, 18 Jul 2023 19:15:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 08/11] KVM: arm64: Implement
 kvm_arch_flush_remote_tlbs_range()
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
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-9-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-9-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/23 08:54, Raghavendra Rao Ananta wrote:
> Implement kvm_arch_flush_remote_tlbs_range() for arm64
> to invalidate the given range in the TLB.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/mmu.c              | 7 +++++++
>   2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7281222f24ef..52d3ed918893 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1114,6 +1114,9 @@ struct kvm *kvm_arch_alloc_vm(void);
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>   int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
> +
>   static inline bool kvm_vm_is_protected(struct kvm *kvm)
>   {
>   	return false;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0ac721fa27f1..387f2215fde7 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -172,6 +172,13 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   	return 0;
>   }
>   
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
> +{
> +	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
> +				start_gfn << PAGE_SHIFT, pages << PAGE_SHIFT);
> +	return 0;
> +}
> +
>   static bool kvm_is_device_pfn(unsigned long pfn)
>   {
>   	return !pfn_is_map_memory(pfn);

-- 
Shaoqin

