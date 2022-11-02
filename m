Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22ED617164
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiKBXDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKBXDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:03:36 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDBAF57
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:03:34 -0700 (PDT)
Date:   Wed, 2 Nov 2022 23:03:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667430212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8fItX3vRxpcg1fIXQ7MC8RTpVUphAL0Q9POdM3EENmg=;
        b=v641THQDw6XI9nwIPdNT7rOvfbMaJ7JxR2WafFzpT2bm3X17BdA8VtYOWgpWrrBsFrM5ye
        WiULMqikaTV+/hGMhItUBi3gzmxzQQXg8k+D9U2J5ldxuVn+ZaTccXAPtCMsezjgtYavPf
        EjiM1ZpvZ/OoUOquC2pj986t8H7Lr+A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 12/15] KVM: arm64: Make block->table PTE changes
 parallel-aware
Message-ID: <Y2L3Pwz6HsQ8mq17@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027222247.1685023-1-oliver.upton@linux.dev>
 <Y2HUebPnIgzLim0w@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2HUebPnIgzLim0w@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022 at 07:22:49PM -0700, Ricardo Koller wrote:
> On Thu, Oct 27, 2022 at 10:22:47PM +0000, Oliver Upton wrote:
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
> >  arch/arm64/kvm/hyp/pgtable.c | 82 +++++++++++++++++++++++++++++++++---
> >  1 file changed, 76 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 4c579b3beabf..1df858c21b2e 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -49,6 +49,12 @@
> >  #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
> >  #define KVM_MAX_OWNER_ID		1
> >  
> > +/*
> > + * Used to indicate a pte for which a 'break-before-make' sequence is in
> > + * progress.
> > + */
> > +#define KVM_INVALID_PTE_LOCKED		BIT(10)
> > +
> >  struct kvm_pgtable_walk_data {
> >  	struct kvm_pgtable_walker	*walker;
> >  
> > @@ -674,6 +680,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
> >  	return !!pte;
> >  }
> >  
> > +static bool stage2_pte_is_locked(kvm_pte_t pte)
> > +{
> > +	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> > +}
> > +
> >  static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
> >  {
> >  	if (!kvm_pgtable_walk_shared(ctx)) {
> > @@ -684,6 +695,64 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
> >  	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
> >  }
> >  
> > +/**
> > + * stage2_try_break_pte() - Invalidates a pte according to the
> > + *			    'break-before-make' requirements of the
> > + *			    architecture.
> > + *
> > + * @ctx: context of the visited pte.
> > + * @data: stage-2 map data
> > + *
> > + * Returns: true if the pte was successfully broken.
> > + *
> > + * If the removed pte was valid, performs the necessary serialization and TLB
> > + * invalidation for the old value. For counted ptes, drops the reference count
> > + * on the containing table page.
> > + */
> > +static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> > +				 struct stage2_map_data *data)
> 
> Would it be possible to pass "kvm_s2_mmu *mmu" directly (instead of
> "stage2_map_data *data")? so this function can be reused by other
> walkers.

Sure, and I presume the ask is coming because you're layering eager page
splitting on top of this right? :-)

> Another option would be to stash "struct kvm_s2_mmu" in
> "struct kvm_pgtable_visit_ctx".

I don't think we'd want to do that. kvm_pgtable_visit_ctx is shared
amongst all walkers, including the hypervisor stage-1.

--
Thanks,
Oliver
