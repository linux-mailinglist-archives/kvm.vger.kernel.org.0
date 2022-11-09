Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95180623739
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 00:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiKIXDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 18:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiKIXDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 18:03:43 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573D06415
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 15:03:42 -0800 (PST)
Date:   Wed, 9 Nov 2022 23:03:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668035016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cEYES5XxXZs+zunY6rrb9ofRyEyk1RW2nSk1EruIy3s=;
        b=jlZXDD9x+BAG+Jr7d0COcWMBnWDXvrMyjGdpxHyfb6MvSH6Dc6Ass51yOagLrPqR2unXvO
        6h75qxzYity7jNp27ZKfrpuiFVnRJKQu6S52E0IoT9g39sKlLrzyNag13dftducsU3F8O6
        hmlrdSayU6PLRAj1yDBw2tPv/+00okA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ben Gardon <bgardon@google.com>
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
Subject: Re: [PATCH v5 11/14] KVM: arm64: Make block->table PTE changes
 parallel-aware
Message-ID: <Y2wxxAHHZ0DQZ88S@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215855.1895367-1-oliver.upton@linux.dev>
 <CANgfPd9OSUfDGCQG8tHXTCYtrrCDnkgPZM6qPDaQF90bZsVCkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9OSUfDGCQG8tHXTCYtrrCDnkgPZM6qPDaQF90bZsVCkA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 02:26:36PM -0800, Ben Gardon wrote:
> On Mon, Nov 7, 2022 at 1:59 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > In order to service stage-2 faults in parallel, stage-2 table walkers
> > must take exclusive ownership of the PTE being worked on. An additional
> > requirement of the architecture is that software must perform a
> > 'break-before-make' operation when changing the block size used for
> > mapping memory.
> >
> > Roll these two concepts together into helpers for performing a
> > 'break-before-make' sequence. Use a special PTE value to indicate a PTE
> > has been locked by a software walker. Additionally, use an atomic
> > compare-exchange to 'break' the PTE when the stage-2 page tables are
> > possibly shared with another software walker. Elide the DSB + TLBI if
> > the evicted PTE was invalid (and thus not subject to break-before-make).
> >
> > All of the atomics do nothing for now, as the stage-2 walker isn't fully
> > ready to perform parallel walks.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 80 +++++++++++++++++++++++++++++++++---
> >  1 file changed, 75 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index f4dd77c6c97d..b9f0d792b8d9 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -49,6 +49,12 @@
> >  #define KVM_INVALID_PTE_OWNER_MASK     GENMASK(9, 2)
> >  #define KVM_MAX_OWNER_ID               1
> >
> > +/*
> > + * Used to indicate a pte for which a 'break-before-make' sequence is in
> > + * progress.
> > + */
> > +#define KVM_INVALID_PTE_LOCKED         BIT(10)
> > +
> >  struct kvm_pgtable_walk_data {
> >         struct kvm_pgtable_walker       *walker;
> >
> > @@ -674,6 +680,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
> >         return !!pte;
> >  }
> >
> > +static bool stage2_pte_is_locked(kvm_pte_t pte)
> > +{
> > +       return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> > +}
> > +
> >  static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
> >  {
> >         if (!kvm_pgtable_walk_shared(ctx)) {
> > @@ -684,6 +695,64 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
> >         return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
> >  }
> >
> > +/**
> > + * stage2_try_break_pte() - Invalidates a pte according to the
> > + *                         'break-before-make' requirements of the
> > + *                         architecture.
> > + *
> > + * @ctx: context of the visited pte.
> > + * @mmu: stage-2 mmu
> > + *
> > + * Returns: true if the pte was successfully broken.
> > + *
> > + * If the removed pte was valid, performs the necessary serialization and TLB
> > + * invalidation for the old value. For counted ptes, drops the reference count
> > + * on the containing table page.
> > + */
> > +static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> > +                                struct kvm_s2_mmu *mmu)
> > +{
> > +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > +
> > +       if (stage2_pte_is_locked(ctx->old)) {
> > +               /*
> > +                * Should never occur if this walker has exclusive access to the
> > +                * page tables.
> > +                */
> > +               WARN_ON(!kvm_pgtable_walk_shared(ctx));
> > +               return false;
> > +       }
> > +
> > +       if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
> > +               return false;
> > +
> > +       /*
> > +        * Perform the appropriate TLB invalidation based on the evicted pte
> > +        * value (if any).
> > +        */
> > +       if (kvm_pte_table(ctx->old, ctx->level))
> > +               kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > +       else if (kvm_pte_valid(ctx->old))
> > +               kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> > +
> > +       if (stage2_pte_is_counted(ctx->old))
> > +               mm_ops->put_page(ctx->ptep);
> > +
> > +       return true;
> > +}
> > +
> > +static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
> > +{
> > +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > +
> > +       WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> > +
> > +       if (stage2_pte_is_counted(new))
> > +               mm_ops->get_page(ctx->ptep);
> > +
> > +       smp_store_release(ctx->ptep, new);
> > +}
> > +
> >  static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
> >                            struct kvm_pgtable_mm_ops *mm_ops)
> >  {
> > @@ -812,17 +881,18 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >         if (!childp)
> >                 return -ENOMEM;
> >
> > +       if (!stage2_try_break_pte(ctx, data->mmu)) {
> > +               mm_ops->put_page(childp);
> > +               return -EAGAIN;
> > +       }
> > +
> >         /*
> >          * If we've run into an existing block mapping then replace it with
> >          * a table. Accesses beyond 'end' that fall within the new table
> >          * will be mapped lazily.
> >          */
> > -       if (stage2_pte_is_counted(ctx->old))
> > -               stage2_put_pte(ctx, data->mmu, mm_ops);
> > -
> >         new = kvm_init_table_pte(childp, mm_ops);
> 
> Does it make any sense to move this before the "break" to minimize the
> critical section in which the PTE is locked?

I had rationalized this before as doing less work in the threads that
would lose a race, but the critical section is very likely to be
performance sensitive as we're unmapping memory after all.

Thanks for the suggestion, I'll fold it in the next spin.

--
Best,
Oliver
