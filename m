Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047F3762A37
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 06:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbjGZETA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 00:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbjGZESO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 00:18:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD5155B9
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 21:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690344619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jd3Ayh8DN133HPzYKMvS4hrOB9t+N5s98/iIQZ50pSY=;
        b=EE6nNQTZ55nqm+8F1DNR60Tf9dCZCD5j9eOlm1r+BoSfmLFJZ+7tWMSGdLhkmCqESt7KdS
        lMwTBL0xAdVq28xFl/iSgeRrzk7zzkzg9rbCDfhnYtyNYUo0REPpOCp/ugF5Jh4l7yK2+/
        08gYiCLESlgX0PcCTJpRW8le7U0uaqk=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-apOlIKimPjyqvOz4V-P2JQ-1; Wed, 26 Jul 2023 00:07:06 -0400
X-MC-Unique: apOlIKimPjyqvOz4V-P2JQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-67167ad515aso753770b3a.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 21:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690344425; x=1690949225;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jd3Ayh8DN133HPzYKMvS4hrOB9t+N5s98/iIQZ50pSY=;
        b=YW5ZcSr5IWMTWB1LG6T1l/tt36gV6j54yzTB4yI7SL8RU6tRJvr/sPa5dUFmQfUxBA
         +pnmgHonrv/RG78p0U6rP5IuDJds4HYxKD7TmdfPW8cmszlvVMXWW6EdPq4LRxk3mcGD
         f6Dtdc8W3OnbCdmXU288LaiGIy61vThECm6ZU3WpsMImh/MoC5+6NZenjXcdfUqR8HrY
         TzxTJsKBZuwhPPy8R3d5e+dmFXGmMBlPOUaat2nEUTHYMKt5cFS1tGG9oiHTkC041uC6
         +h0O7i73sc9mCffU5JGo2IZeSlSkvC269bPSurcHf/WO479twXLiNV1tCzV6ySwhGeE9
         tfNQ==
X-Gm-Message-State: ABy/qLYXp+6sJl4e+fk0TwPwh6nPjwCLsz+nqxVXRcZGjDJ//R4bxAqb
        zt+xAgnIcaIGki6f+YmPKPnFC7Bpk0KPFq3+E9xsJVXM3WRYVZA33pq6JFugIQ6or5X2F1odNnd
        mf2KfAqyMOEVd
X-Received: by 2002:a05:6a21:998e:b0:13a:3649:dc1a with SMTP id ve14-20020a056a21998e00b0013a3649dc1amr1214729pzb.0.1690344425272;
        Tue, 25 Jul 2023 21:07:05 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHleYbAwzuemeXRJ1zvnZsyP8kzTsFzjwsO8Pk5jpHvjhbkv06p3/Mm3PthC+5aKlT4RtEFvA==
X-Received: by 2002:a05:6a21:998e:b0:13a:3649:dc1a with SMTP id ve14-20020a056a21998e00b0013a3649dc1amr1214709pzb.0.1690344424918;
        Tue, 25 Jul 2023 21:07:04 -0700 (PDT)
Received: from [10.72.112.95] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a13-20020aa7864d000000b006862e7f4648sm10736311pfo.99.2023.07.25.21.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 21:07:04 -0700 (PDT)
Message-ID: <bd054dfa-915d-e231-b480-06401622ebde@redhat.com>
Date:   Wed, 26 Jul 2023 12:06:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 12/12] KVM: arm64: Use TLBI range-based intructions for
 unmap
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
 <7ea9e7a0-508d-0f00-09ae-ae468f111437@redhat.com>
 <CAJHc60xaygC8tX8yFnoFM9YqWg8iE6r5d+kugGwO5KZxDtG3rQ@mail.gmail.com>
Content-Language: en-US
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <CAJHc60xaygC8tX8yFnoFM9YqWg8iE6r5d+kugGwO5KZxDtG3rQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

Hi Raghavendra,

On 7/26/23 01:23, Raghavendra Rao Ananta wrote:
> Hi Shaoqin,
> 
> On Mon, Jul 24, 2023 at 7:32 PM Shaoqin Huang <shahuang@redhat.com> wrote:
>>
>>
>>
>> On 7/25/23 00:47, Raghavendra Rao Ananta wrote:
>>> On Mon, Jul 24, 2023 at 2:35 AM Shaoqin Huang <shahuang@redhat.com> wrote:
>>>>
>>>> Hi Raghavendra,
>>>>
>>>> On 7/22/23 10:22, Raghavendra Rao Ananta wrote:
>>>>> The current implementation of the stage-2 unmap walker traverses
>>>>> the given range and, as a part of break-before-make, performs
>>>>> TLB invalidations with a DSB for every PTE. A multitude of this
>>>>> combination could cause a performance bottleneck on some systems.
>>>>>
>>>>> Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
>>>>> invalidations until the entire walk is finished, and then
>>>>> use range-based instructions to invalidate the TLBs in one go.
>>>>> Condition deferred TLB invalidation on the system supporting FWB,
>>>>> as the optimization is entirely pointless when the unmap walker
>>>>> needs to perform CMOs.
>>>>>
>>>>> Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
>>>>> now serves the stage-2 unmap walker specifically, rather than
>>>>> acting generic.
>>>>>
>>>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>>>> ---
>>>>>     arch/arm64/kvm/hyp/pgtable.c | 67 +++++++++++++++++++++++++++++++-----
>>>>>     1 file changed, 58 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>>>>> index 5ef098af1736..cf88933a2ea0 100644
>>>>> --- a/arch/arm64/kvm/hyp/pgtable.c
>>>>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>>>>> @@ -831,16 +831,54 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
>>>>>         smp_store_release(ctx->ptep, new);
>>>>>     }
>>>>>
>>>>> -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
>>>>> -                        struct kvm_pgtable_mm_ops *mm_ops)
>>>>> +struct stage2_unmap_data {
>>>>> +     struct kvm_pgtable *pgt;
>>>>> +     bool defer_tlb_flush_init;
>>>>> +};
>>>>> +
>>>>> +static bool __stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
>>>>> +{
>>>>> +     /*
>>>>> +      * If FEAT_TLBIRANGE is implemented, defer the individual
>>>>> +      * TLB invalidations until the entire walk is finished, and
>>>>> +      * then use the range-based TLBI instructions to do the
>>>>> +      * invalidations. Condition deferred TLB invalidation on the
>>>>> +      * system supporting FWB, as the optimization is entirely
>>>>> +      * pointless when the unmap walker needs to perform CMOs.
>>>>> +      */
>>>>> +     return system_supports_tlb_range() && stage2_has_fwb(pgt);
>>>>> +}
>>>>> +
>>>>> +static bool stage2_unmap_defer_tlb_flush(struct stage2_unmap_data *unmap_data)
>>>>> +{
>>>>> +     bool defer_tlb_flush = __stage2_unmap_defer_tlb_flush(unmap_data->pgt);
>>>>> +
>>>>> +     /*
>>>>> +      * Since __stage2_unmap_defer_tlb_flush() is based on alternative
>>>>> +      * patching and the TLBIs' operations behavior depend on this,
>>>>> +      * track if there's any change in the state during the unmap sequence.
>>>>> +      */
>>>>> +     WARN_ON(unmap_data->defer_tlb_flush_init != defer_tlb_flush);
>>>>> +     return defer_tlb_flush;
>>>>> +}
>>>>> +
>>>>> +static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
>>>>> +                             struct kvm_s2_mmu *mmu,
>>>>> +                             struct kvm_pgtable_mm_ops *mm_ops)
>>>>>     {
>>>>> +     struct stage2_unmap_data *unmap_data = ctx->arg;
>>>>> +
>>>>>         /*
>>>>> -      * Clear the existing PTE, and perform break-before-make with
>>>>> -      * TLB maintenance if it was valid.
>>>>> +      * Clear the existing PTE, and perform break-before-make if it was
>>>>> +      * valid. Depending on the system support, the TLB maintenance for
>>>>> +      * the same can be deferred until the entire unmap is completed.
>>>>>          */
>>>>>         if (kvm_pte_valid(ctx->old)) {
>>>>>                 kvm_clear_pte(ctx->ptep);
>>>>> -             kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
>>>>> +
>>>>> +             if (!stage2_unmap_defer_tlb_flush(unmap_data))
>>>> Why not directly check (unmap_data->defer_tlb_flush_init) here?
>>>>
>>> (Re-sending the reply as the previous one was formatted as HTML and
>>> was blocked by many lists)
>>>
>>> No particular reason per say, but I was just going with the logic of
>>> determining if we need to defer the flush and the WARN_ON() parts
>>> separate.
>>> Any advantage if we directly check in stage2_unmap_put_pte() that I
>>> missed or is this purely for readability?
>>
>> Hi Raghavendra,
>>
>> I just wondering if before the stage2 walk, we want to defer the tlb
>> flush, but if when walk the stage2, the stage2_unmap_defer_tlb_flush()
>> trigger the WARN_ON() and return don't defer the tlb flush, it will
>> flush the ctx->addr's tlb. But before the WARN_ON() triggered, these tlb
>> will not be flushed, since when walk stage2 done in the
>> kvm_pgtable_stage2_unmap(), the stage2_unmap_defer_tlb_flush() still
>> trigger the WARN_ON() and don't use the tlb range-based flush. Thus some
>> of the tlb are not flushed.
>>
> Excellent point!
>> If we directly check the (unmap_data->defer_tlb_flush_init), this isn't
>> change during walking the stage2, so the WARN_ON() should only trigger
>> in kvm_pgtable_stage2_unmap()->stage2_unmap_defer_tlb_flush().
>>
>> I'm not sure if it's right since I just think once we set up use the
>> TLBI range-based flush, the result of the
>> __stage2_unmap_defer_tlb_flush() shouldn't change. Otherwise there must
>> have some stale TLB entry.
>>
> One solution that I can think of is, if the code triggers the
> WARN_ON(), we flush the entire VM's TLB using
> kvm_call_hyp(__kvm_tlb_flush_vmid) after the entire walk is finished.
> In this special/rare situation, it'll be a little expensive, but we
> will at least be correct, leaving no stale TLBs behind. WDYT?
> 

I think it will be good to have this handling.

Thanks,
Shaoqin

> Thank you.
> Raghavendra
>> Thanks,
>> Shaoqin
>>
>>>
>>>>> +                     kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
>>>>> +                                     ctx->addr, ctx->level);
>>>> Small indent hint. The ctx->addr can align with __kvm_tlb_flush_vmid_ipa.
>>>>
>>> Ah, yes. I'll adjust this if I send out a v8.
>>>
>>> Thank you.
>>> Raghavendra
>>>> Thanks,
>>>> Shaoqin
>>>>>         }
>>>>>
>>>>>         mm_ops->put_page(ctx->ptep);
>>>>> @@ -1070,7 +1108,8 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>>>>>     static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>>>>                                enum kvm_pgtable_walk_flags visit)
>>>>>     {
>>>>> -     struct kvm_pgtable *pgt = ctx->arg;
>>>>> +     struct stage2_unmap_data *unmap_data = ctx->arg;
>>>>> +     struct kvm_pgtable *pgt = unmap_data->pgt;
>>>>>         struct kvm_s2_mmu *mmu = pgt->mmu;
>>>>>         struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>>>>>         kvm_pte_t *childp = NULL;
>>>>> @@ -1098,7 +1137,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>>>>          * block entry and rely on the remaining portions being faulted
>>>>>          * back lazily.
>>>>>          */
>>>>> -     stage2_put_pte(ctx, mmu, mm_ops);
>>>>> +     stage2_unmap_put_pte(ctx, mmu, mm_ops);
>>>>>
>>>>>         if (need_flush && mm_ops->dcache_clean_inval_poc)
>>>>>                 mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
>>>>> @@ -1112,13 +1151,23 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>>>>
>>>>>     int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>>>>>     {
>>>>> +     int ret;
>>>>> +     struct stage2_unmap_data unmap_data = {
>>>>> +             .pgt = pgt,
>>>>> +             .defer_tlb_flush_init = __stage2_unmap_defer_tlb_flush(pgt),
>>>>> +     };
>>>>>         struct kvm_pgtable_walker walker = {
>>>>>                 .cb     = stage2_unmap_walker,
>>>>> -             .arg    = pgt,
>>>>> +             .arg    = &unmap_data,
>>>>>                 .flags  = KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>>>>>         };
>>>>>
>>>>> -     return kvm_pgtable_walk(pgt, addr, size, &walker);
>>>>> +     ret = kvm_pgtable_walk(pgt, addr, size, &walker);
>>>>> +     if (stage2_unmap_defer_tlb_flush(&unmap_data))
>>>>> +             /* Perform the deferred TLB invalidations */
>>>>> +             kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
>>>>> +
>>>>> +     return ret;
>>>>>     }
>>>>>
>>>>>     struct stage2_attr_data {
>>>>
>>>> --
>>>> Shaoqin
>>>>
>>>
>>
>> --
>> Shaoqin
>>
> 

-- 
Shaoqin

