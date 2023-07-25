Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362C9760532
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 04:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjGYCdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 22:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjGYCdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 22:33:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2C5137
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 19:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690252375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TLi69c4E4L5eZQg22PEMzi9DRqiDnwUXsa6MfQ9GlAI=;
        b=g1hclesLfqPxLdvTaT8gMkKqCYTrQOWTrW4U9H/YdJZ04FSJshX39gViNYzjQjjvNQXTrW
        KsQBvaqW7J2MF+xyxtvouZQezeuFEO2dGPliCZRXMXO1U9VMj5yRYnTOUwJPcdtvxbnbJg
        MtHDYPAudbfnWsPP5DWxMdWsGk3FL6c=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-2xLGZ7x1MxCClxOaTNdzqQ-1; Mon, 24 Jul 2023 22:32:53 -0400
X-MC-Unique: 2xLGZ7x1MxCClxOaTNdzqQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-66d7911409dso360327b3a.1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 19:32:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690252373; x=1690857173;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TLi69c4E4L5eZQg22PEMzi9DRqiDnwUXsa6MfQ9GlAI=;
        b=byYvwVlKH0DvKcrSbCeLuNL3DAhksGuxb1/pGcAc9FTI6U20YFJWCdPc8+pLwxocTV
         FkQfR3Oyuht9slgDK7f8GtKfjWl7QqIMdvni+p4D5QPaOKutex2g+W0uN26JvRRbLoFn
         krrVB8cLvyRb4WoHJfqiL0V+LmumTTtG6F4s0HXrJXyYKnN5BoTMAjHPm5HS+niYMeFy
         acX/R8qfYTBU7d1/2y+uyNTowWJYPpgd1hUsaNpa9MbICPaPhcS90hRgFVK64TTYRHjM
         LIA7Eb+K/3hEl8C5aBndS+Bcui4v8bfoME6i352yXvzxtUTbFt818r6/VnQ9s5i5nI/e
         nOwA==
X-Gm-Message-State: ABy/qLYLr/+pLQVIhbxZRds21cVcSHM79/NCWyDPfn1Aj4jM4HltUGyr
        U91l2JGzzPrQSeWLOVcDsvd1+aSNxrHtpvFUL0oYuHi3UFI56o2QD8hPv6S9OhtHO6APyCuMPbR
        CTaYBeZQWqorA
X-Received: by 2002:a05:6a20:6a04:b0:134:1671:6191 with SMTP id p4-20020a056a206a0400b0013416716191mr15770053pzk.0.1690252372793;
        Mon, 24 Jul 2023 19:32:52 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGjytb4S6qopsC3NLp/h8iyv5snZM1Dlt1GebDQMZ0uJY6y/Dhu0KlQgL9HrcCz12eAJGPfUw==
X-Received: by 2002:a05:6a20:6a04:b0:134:1671:6191 with SMTP id p4-20020a056a206a0400b0013416716191mr15770035pzk.0.1690252372422;
        Mon, 24 Jul 2023 19:32:52 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h16-20020aa786d0000000b00678cb336f3csm8655609pfo.142.2023.07.24.19.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 19:32:52 -0700 (PDT)
Message-ID: <7ea9e7a0-508d-0f00-09ae-ae468f111437@redhat.com>
Date:   Tue, 25 Jul 2023 10:32:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 12/12] KVM: arm64: Use TLBI range-based intructions for
 unmap
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
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230722022251.3446223-1-rananta@google.com>
 <20230722022251.3446223-13-rananta@google.com>
 <0841aca6-2824-6a1b-a568-119f8bd220de@redhat.com>
 <CAJHc60znT5ThqKE3TgTW-0Us3oNv8+KF=81TSK0PbG3tTyJLFQ@mail.gmail.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <CAJHc60znT5ThqKE3TgTW-0Us3oNv8+KF=81TSK0PbG3tTyJLFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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



On 7/25/23 00:47, Raghavendra Rao Ananta wrote:
> On Mon, Jul 24, 2023 at 2:35 AM Shaoqin Huang <shahuang@redhat.com> wrote:
>>
>> Hi Raghavendra,
>>
>> On 7/22/23 10:22, Raghavendra Rao Ananta wrote:
>>> The current implementation of the stage-2 unmap walker traverses
>>> the given range and, as a part of break-before-make, performs
>>> TLB invalidations with a DSB for every PTE. A multitude of this
>>> combination could cause a performance bottleneck on some systems.
>>>
>>> Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
>>> invalidations until the entire walk is finished, and then
>>> use range-based instructions to invalidate the TLBs in one go.
>>> Condition deferred TLB invalidation on the system supporting FWB,
>>> as the optimization is entirely pointless when the unmap walker
>>> needs to perform CMOs.
>>>
>>> Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
>>> now serves the stage-2 unmap walker specifically, rather than
>>> acting generic.
>>>
>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>> ---
>>>    arch/arm64/kvm/hyp/pgtable.c | 67 +++++++++++++++++++++++++++++++-----
>>>    1 file changed, 58 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>>> index 5ef098af1736..cf88933a2ea0 100644
>>> --- a/arch/arm64/kvm/hyp/pgtable.c
>>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>>> @@ -831,16 +831,54 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
>>>        smp_store_release(ctx->ptep, new);
>>>    }
>>>
>>> -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
>>> -                        struct kvm_pgtable_mm_ops *mm_ops)
>>> +struct stage2_unmap_data {
>>> +     struct kvm_pgtable *pgt;
>>> +     bool defer_tlb_flush_init;
>>> +};
>>> +
>>> +static bool __stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
>>> +{
>>> +     /*
>>> +      * If FEAT_TLBIRANGE is implemented, defer the individual
>>> +      * TLB invalidations until the entire walk is finished, and
>>> +      * then use the range-based TLBI instructions to do the
>>> +      * invalidations. Condition deferred TLB invalidation on the
>>> +      * system supporting FWB, as the optimization is entirely
>>> +      * pointless when the unmap walker needs to perform CMOs.
>>> +      */
>>> +     return system_supports_tlb_range() && stage2_has_fwb(pgt);
>>> +}
>>> +
>>> +static bool stage2_unmap_defer_tlb_flush(struct stage2_unmap_data *unmap_data)
>>> +{
>>> +     bool defer_tlb_flush = __stage2_unmap_defer_tlb_flush(unmap_data->pgt);
>>> +
>>> +     /*
>>> +      * Since __stage2_unmap_defer_tlb_flush() is based on alternative
>>> +      * patching and the TLBIs' operations behavior depend on this,
>>> +      * track if there's any change in the state during the unmap sequence.
>>> +      */
>>> +     WARN_ON(unmap_data->defer_tlb_flush_init != defer_tlb_flush);
>>> +     return defer_tlb_flush;
>>> +}
>>> +
>>> +static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
>>> +                             struct kvm_s2_mmu *mmu,
>>> +                             struct kvm_pgtable_mm_ops *mm_ops)
>>>    {
>>> +     struct stage2_unmap_data *unmap_data = ctx->arg;
>>> +
>>>        /*
>>> -      * Clear the existing PTE, and perform break-before-make with
>>> -      * TLB maintenance if it was valid.
>>> +      * Clear the existing PTE, and perform break-before-make if it was
>>> +      * valid. Depending on the system support, the TLB maintenance for
>>> +      * the same can be deferred until the entire unmap is completed.
>>>         */
>>>        if (kvm_pte_valid(ctx->old)) {
>>>                kvm_clear_pte(ctx->ptep);
>>> -             kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
>>> +
>>> +             if (!stage2_unmap_defer_tlb_flush(unmap_data))
>> Why not directly check (unmap_data->defer_tlb_flush_init) here?
>>
> (Re-sending the reply as the previous one was formatted as HTML and
> was blocked by many lists)
> 
> No particular reason per say, but I was just going with the logic of
> determining if we need to defer the flush and the WARN_ON() parts
> separate.
> Any advantage if we directly check in stage2_unmap_put_pte() that I
> missed or is this purely for readability?

Hi Raghavendra,

I just wondering if before the stage2 walk, we want to defer the tlb 
flush, but if when walk the stage2, the stage2_unmap_defer_tlb_flush() 
trigger the WARN_ON() and return don't defer the tlb flush, it will 
flush the ctx->addr's tlb. But before the WARN_ON() triggered, these tlb 
will not be flushed, since when walk stage2 done in the 
kvm_pgtable_stage2_unmap(), the stage2_unmap_defer_tlb_flush() still 
trigger the WARN_ON() and don't use the tlb range-based flush. Thus some 
of the tlb are not flushed.

If we directly check the (unmap_data->defer_tlb_flush_init), this isn't 
change during walking the stage2, so the WARN_ON() should only trigger 
in kvm_pgtable_stage2_unmap()->stage2_unmap_defer_tlb_flush().

I'm not sure if it's right since I just think once we set up use the 
TLBI range-based flush, the result of the 
__stage2_unmap_defer_tlb_flush() shouldn't change. Otherwise there must 
have some stale TLB entry.

Thanks,
Shaoqin

> 
>>> +                     kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
>>> +                                     ctx->addr, ctx->level);
>> Small indent hint. The ctx->addr can align with __kvm_tlb_flush_vmid_ipa.
>>
> Ah, yes. I'll adjust this if I send out a v8.
> 
> Thank you.
> Raghavendra
>> Thanks,
>> Shaoqin
>>>        }
>>>
>>>        mm_ops->put_page(ctx->ptep);
>>> @@ -1070,7 +1108,8 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>>>    static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>>                               enum kvm_pgtable_walk_flags visit)
>>>    {
>>> -     struct kvm_pgtable *pgt = ctx->arg;
>>> +     struct stage2_unmap_data *unmap_data = ctx->arg;
>>> +     struct kvm_pgtable *pgt = unmap_data->pgt;
>>>        struct kvm_s2_mmu *mmu = pgt->mmu;
>>>        struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>>>        kvm_pte_t *childp = NULL;
>>> @@ -1098,7 +1137,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>>         * block entry and rely on the remaining portions being faulted
>>>         * back lazily.
>>>         */
>>> -     stage2_put_pte(ctx, mmu, mm_ops);
>>> +     stage2_unmap_put_pte(ctx, mmu, mm_ops);
>>>
>>>        if (need_flush && mm_ops->dcache_clean_inval_poc)
>>>                mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
>>> @@ -1112,13 +1151,23 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>>
>>>    int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>>>    {
>>> +     int ret;
>>> +     struct stage2_unmap_data unmap_data = {
>>> +             .pgt = pgt,
>>> +             .defer_tlb_flush_init = __stage2_unmap_defer_tlb_flush(pgt),
>>> +     };
>>>        struct kvm_pgtable_walker walker = {
>>>                .cb     = stage2_unmap_walker,
>>> -             .arg    = pgt,
>>> +             .arg    = &unmap_data,
>>>                .flags  = KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>>>        };
>>>
>>> -     return kvm_pgtable_walk(pgt, addr, size, &walker);
>>> +     ret = kvm_pgtable_walk(pgt, addr, size, &walker);
>>> +     if (stage2_unmap_defer_tlb_flush(&unmap_data))
>>> +             /* Perform the deferred TLB invalidations */
>>> +             kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
>>> +
>>> +     return ret;
>>>    }
>>>
>>>    struct stage2_attr_data {
>>
>> --
>> Shaoqin
>>
> 

-- 
Shaoqin

