Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F8A62368D
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbiKIW1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbiKIW0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:26:48 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA42820F72
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 14:26:47 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id cg5so29227qtb.12
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 14:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ys/jQ8RbuqT3YumCTMbd+2452VktWwQQOObS7LSk5p4=;
        b=mk9lRpuokDL/uAOGOKs/+T+PEfPR48B5jrdBCU4h3IJuESuNqf45ir8gw9bRIeOeS2
         5boDsxOTz8DpWvHPjQhCVVSwOM6ovQKP64R6KI0RCxiP7tMx1y1DV02kaqZQLWfTIIIK
         TbjJqgkN+FpzGJDz9nIIK8l9JHwSamFn0UQVHIRm3S8ypg8qo2oRFMAbGNEOyPMoHgVs
         guGP5sgv0zVSjtqTSdAgYZhxbtjyozc30kfsiDsPFZZvSEgusnttdCQYnX0wMsBIhRsK
         PS2Rwu4d/kFG+09LQxPgUcg1wT8Uk5LZsZZvFYYJUXzlidk4zjrNqzmeBbQj7G25Mb/i
         N6DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ys/jQ8RbuqT3YumCTMbd+2452VktWwQQOObS7LSk5p4=;
        b=X4NA9zkLbMhqF5MOKpmxa1tuZvz7Xq4wfCOPv+srTmmg1nhB7RwnEmIyQciZZsw19m
         6H4humzwGukS6MAc5Rihmmr3M3vMHHmwIx4Th0nwTdElb4YMRjm/7IlD6Ma1Z/C3B81Z
         V5Qy2e+MqoP//HyYdQ2KXOTf4RENnfCSdFxsb8dBkUVlRRN20aU9ORKbJkXKkS1UExBO
         MHNyUhoiXFHwM/rU2PfzvQnKr3BL9sTeb3Njgf+zf0xpf8gtk4KSLa2ybbui7W8XI1c6
         8Tj3Y90NgeXuXWIfHsUn6cdsbCTQnfbXLOXtfq/X6nJHGgjrPIiP16JVsuZdV33WpIZl
         JiMw==
X-Gm-Message-State: ANoB5pkym1Zc+twJvF0ZDOsnvhlRtoj3qH3xh3FwR4M6600v9o++Xo6/
        Jz1vOhtyhUF73v5yJihP8rQZNpitQJvu1qn7ZVvlUA==
X-Google-Smtp-Source: AA0mqf78NDQ8xLt/Zae6fTGp38dnPf5BMr45qBFnT7kZ5Z23obSQYwTbVOjufSO4/KwQlp/1DoVnG+QFF53vnN4/bwY=
X-Received: by 2002:ac8:5ac2:0:b0:3a5:afca:2322 with SMTP id
 d2-20020ac85ac2000000b003a5afca2322mr4284025qtd.500.1668032807310; Wed, 09
 Nov 2022 14:26:47 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215855.1895367-1-oliver.upton@linux.dev>
In-Reply-To: <20221107215855.1895367-1-oliver.upton@linux.dev>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 9 Nov 2022 14:26:36 -0800
Message-ID: <CANgfPd9OSUfDGCQG8tHXTCYtrrCDnkgPZM6qPDaQF90bZsVCkA@mail.gmail.com>
Subject: Re: [PATCH v5 11/14] KVM: arm64: Make block->table PTE changes parallel-aware
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 7, 2022 at 1:59 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> In order to service stage-2 faults in parallel, stage-2 table walkers
> must take exclusive ownership of the PTE being worked on. An additional
> requirement of the architecture is that software must perform a
> 'break-before-make' operation when changing the block size used for
> mapping memory.
>
> Roll these two concepts together into helpers for performing a
> 'break-before-make' sequence. Use a special PTE value to indicate a PTE
> has been locked by a software walker. Additionally, use an atomic
> compare-exchange to 'break' the PTE when the stage-2 page tables are
> possibly shared with another software walker. Elide the DSB + TLBI if
> the evicted PTE was invalid (and thus not subject to break-before-make).
>
> All of the atomics do nothing for now, as the stage-2 walker isn't fully
> ready to perform parallel walks.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 80 +++++++++++++++++++++++++++++++++---
>  1 file changed, 75 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index f4dd77c6c97d..b9f0d792b8d9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -49,6 +49,12 @@
>  #define KVM_INVALID_PTE_OWNER_MASK     GENMASK(9, 2)
>  #define KVM_MAX_OWNER_ID               1
>
> +/*
> + * Used to indicate a pte for which a 'break-before-make' sequence is in
> + * progress.
> + */
> +#define KVM_INVALID_PTE_LOCKED         BIT(10)
> +
>  struct kvm_pgtable_walk_data {
>         struct kvm_pgtable_walker       *walker;
>
> @@ -674,6 +680,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
>         return !!pte;
>  }
>
> +static bool stage2_pte_is_locked(kvm_pte_t pte)
> +{
> +       return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> +}
> +
>  static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
>  {
>         if (!kvm_pgtable_walk_shared(ctx)) {
> @@ -684,6 +695,64 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
>         return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
>  }
>
> +/**
> + * stage2_try_break_pte() - Invalidates a pte according to the
> + *                         'break-before-make' requirements of the
> + *                         architecture.
> + *
> + * @ctx: context of the visited pte.
> + * @mmu: stage-2 mmu
> + *
> + * Returns: true if the pte was successfully broken.
> + *
> + * If the removed pte was valid, performs the necessary serialization and TLB
> + * invalidation for the old value. For counted ptes, drops the reference count
> + * on the containing table page.
> + */
> +static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> +                                struct kvm_s2_mmu *mmu)
> +{
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +
> +       if (stage2_pte_is_locked(ctx->old)) {
> +               /*
> +                * Should never occur if this walker has exclusive access to the
> +                * page tables.
> +                */
> +               WARN_ON(!kvm_pgtable_walk_shared(ctx));
> +               return false;
> +       }
> +
> +       if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
> +               return false;
> +
> +       /*
> +        * Perform the appropriate TLB invalidation based on the evicted pte
> +        * value (if any).
> +        */
> +       if (kvm_pte_table(ctx->old, ctx->level))
> +               kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +       else if (kvm_pte_valid(ctx->old))
> +               kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> +
> +       if (stage2_pte_is_counted(ctx->old))
> +               mm_ops->put_page(ctx->ptep);
> +
> +       return true;
> +}
> +
> +static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
> +{
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +
> +       WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> +
> +       if (stage2_pte_is_counted(new))
> +               mm_ops->get_page(ctx->ptep);
> +
> +       smp_store_release(ctx->ptep, new);
> +}
> +
>  static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
>                            struct kvm_pgtable_mm_ops *mm_ops)
>  {
> @@ -812,17 +881,18 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         if (!childp)
>                 return -ENOMEM;
>
> +       if (!stage2_try_break_pte(ctx, data->mmu)) {
> +               mm_ops->put_page(childp);
> +               return -EAGAIN;
> +       }
> +
>         /*
>          * If we've run into an existing block mapping then replace it with
>          * a table. Accesses beyond 'end' that fall within the new table
>          * will be mapped lazily.
>          */
> -       if (stage2_pte_is_counted(ctx->old))
> -               stage2_put_pte(ctx, data->mmu, mm_ops);
> -
>         new = kvm_init_table_pte(childp, mm_ops);

Does it make any sense to move this before the "break" to minimize the
critical section in which the PTE is locked?


> -       mm_ops->get_page(ctx->ptep);
> -       smp_store_release(ctx->ptep, new);
> +       stage2_make_pte(ctx, new);
>
>         return 0;
>  }
> --
> 2.38.1.431.g37b22c650d-goog
>
