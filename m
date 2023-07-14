Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E51C752E71
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 03:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjGNBDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 21:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbjGNBD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 21:03:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADC92D61
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 18:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689296551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RCZyb3R24GuDipQIPDZ95wX4wOQwTE4wykLLz/wfDdA=;
        b=S+yhPLy7T8/KjEXzXxgPBGklx1X+EQzoRnJFfy0xE4Mq4UFxaIddospne+WBPkvSpEKzpp
        z+IYdUNLVxiKv1ReByIAyF/KDq2FcjVs1muKTnubTONsyeYA/jC0eWuQc8Tmh+GqNVOdf0
        DjBtSbxfGkJjezZMfMv529DIEFwSHtA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-WFyj1zHbMMmvB1NxxcfbAQ-1; Thu, 13 Jul 2023 21:02:27 -0400
X-MC-Unique: WFyj1zHbMMmvB1NxxcfbAQ-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-262cf62e9b4so947126a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 18:02:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689296546; x=1691888546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RCZyb3R24GuDipQIPDZ95wX4wOQwTE4wykLLz/wfDdA=;
        b=QSSRIGpzROsrKWM5GUCScq7JXKIPLKkor01TaQmtNjfhmX7P1zeRvhon2MD2Pdr1za
         XngVpUkrs5Q5LnpjtrsZdTbeFQ2IirjUI8tQIV8mLJ7hZ4igAWEZeYyF198pPqIHkI4R
         wAuUKbNJ5ILmO+Qi57wDakj04Vvaws39ntlqfVRlLyuM4KYUVHiBI1OcI1hAy7FTtdW7
         ysjY+Dpl9iAloRf26E8NJoBJaHBDkG4WxZBr+HhAH9lJfrdKz/snO/Hhxtfb5nyytXRm
         LTlFW0IDxp05Y4s4LiIkWSj2F7F/aLh0M46asE+/pWcjLLnnIBZzA33kwo4FtcOGFU0K
         d3ng==
X-Gm-Message-State: ABy/qLZ1emwaUIcR9zTzzx1lGDM2cXqeJJEZqZGbgTLs56AXXZKnTp+w
        EkcSkm4sMupTdXrdCvdfEpHu65uRpbo2RJxC9zZCjbfsN2yoIBxpK+kJhESwTXr6m2mef9Zc0Uk
        lAUH4cH0/C0tD
X-Received: by 2002:a17:90a:950b:b0:261:1141:b716 with SMTP id t11-20020a17090a950b00b002611141b716mr2709728pjo.33.1689296546061;
        Thu, 13 Jul 2023 18:02:26 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFSSCf8gGL9MdVrTrliVfiTlZBbSVuaYTkwu2FoRn5pnrMxd9r/+WlBrcYEXoTEJAZF8xXaVA==
X-Received: by 2002:a17:90a:950b:b0:261:1141:b716 with SMTP id t11-20020a17090a950b00b002611141b716mr2709710pjo.33.1689296545727;
        Thu, 13 Jul 2023 18:02:25 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id 12-20020a17090a1a0c00b00263dfe1f8d8sm140821pjk.23.2023.07.13.18.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 18:02:25 -0700 (PDT)
Message-ID: <874fdca6-e029-98fe-8e6f-b21dc1eaa467@redhat.com>
Date:   Fri, 14 Jul 2023 11:02:15 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 07/11] KVM: arm64: Define
 kvm_tlb_flush_vmid_range()
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
 <20230621175002.2832640-8-rananta@google.com>
 <1fe280a7-0f10-e124-00aa-b137df722c33@redhat.com>
 <CAJHc60xQtjvVsWRE=w-pAioNJW6uh-qKuZz2wp6bkT=X4oCm5A@mail.gmail.com>
 <60ba5bb4-6fad-0e51-2cd5-845610e6631d@redhat.com>
 <CAJHc60y6AaAUVy=V6GHTpVhHGO3Bjn1vpTnYpdFiFLjS-vR-uA@mail.gmail.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <CAJHc60y6AaAUVy=V6GHTpVhHGO3Bjn1vpTnYpdFiFLjS-vR-uA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

Hi Raghavendra,

On 7/14/23 04:47, Raghavendra Rao Ananta wrote:
> On Wed, Jul 5, 2023 at 5:04 PM Gavin Shan <gshan@redhat.com> wrote:
>>
>> On 7/6/23 04:28, Raghavendra Rao Ananta wrote:
>>> On Tue, Jul 4, 2023 at 5:31 PM Gavin Shan <gshan@redhat.com> wrote:
>>>> On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
>>>>> Implement the helper kvm_tlb_flush_vmid_range() that acts
>>>>> as a wrapper for range-based TLB invalidations. For the
>>>>> given VMID, use the range-based TLBI instructions to do
>>>>> the job or fallback to invalidating all the TLB entries.
>>>>>
>>>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>>>> ---
>>>>>     arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
>>>>>     arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
>>>>>     2 files changed, 30 insertions(+)
>>>>>
>>>>
>>>> It may be reasonable to fold this to PATCH[08/11] since kvm_tlb_flush_vmid_range() is
>>>> only called by ARM64's kvm_arch_flush_remote_tlbs_range(), which is added by PATCH[08/11].
>>>> In either way, the changes look good to me:
>>>>
>>> Ah, the patches 10 and 11 also call kvm_tlb_flush_vmid_range(), so
>>> probably it's better to keep the definition isolated?
>>>
>>
>> Thanks for your explanation. It's fine to have two separate patches in this
>> case. I still need to spend some time to look at PATCH[11/11] whose subject
>> includes typo (intructions -> instructions)
>>
> I'm planning to send v6 soon, but I'm happy to wait if you have any
> other comments on v5 patch-11.
> Appreciate your help with the reviews.
> 

I didn't get a chance to look at PATCH[11/11] yet. Please post v6 and I will
take a look on PATCH[v6 11/11]. Sorry for the delay.

Thanks,
Gavin

>>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>>>>> index 4cd6762bda805..1b12295a83595 100644
>>>>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>>>>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>>>>> @@ -682,4 +682,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
>>>>>      *     kvm_pgtable_prot format.
>>>>>      */
>>>>>     enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
>>>>> +
>>>>> +/**
>>>>> + * kvm_tlb_flush_vmid_range() - Invalidate/flush a range of TLB entries
>>>>> + *
>>>>> + * @mmu:     Stage-2 KVM MMU struct
>>>>> + * @addr:    The base Intermediate physical address from which to invalidate
>>>>> + * @size:    Size of the range from the base to invalidate
>>>>> + */
>>>>> +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>>>>> +                             phys_addr_t addr, size_t size);
>>>>>     #endif      /* __ARM64_KVM_PGTABLE_H__ */
>>>>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>>>>> index 3d61bd3e591d2..df8ac14d9d3d4 100644
>>>>> --- a/arch/arm64/kvm/hyp/pgtable.c
>>>>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>>>>> @@ -631,6 +631,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt)
>>>>>         return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
>>>>>     }
>>>>>
>>>>> +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>>>>> +                             phys_addr_t addr, size_t size)
>>>>> +{
>>>>> +     unsigned long pages, inval_pages;
>>>>> +
>>>>> +     if (!system_supports_tlb_range()) {
>>>>> +             kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
>>>>> +             return;
>>>>> +     }
>>>>> +
>>>>> +     pages = size >> PAGE_SHIFT;
>>>>> +     while (pages > 0) {
>>>>> +             inval_pages = min(pages, MAX_TLBI_RANGE_PAGES);
>>>>> +             kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, addr, inval_pages);
>>>>> +
>>>>> +             addr += inval_pages << PAGE_SHIFT;
>>>>> +             pages -= inval_pages;
>>>>> +     }
>>>>> +}
>>>>> +
>>>>>     #define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
>>>>>
>>>>>     static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
>>
> 

