Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8A96236D1
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiKIWyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiKIWyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:54:53 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AD61DA67
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 14:54:52 -0800 (PST)
Date:   Wed, 9 Nov 2022 22:54:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668034486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4eBpAl0Bh9NbuP8Ymsao9EXIdBXAUBLyzei2R+zKTK8=;
        b=uhfXgpyEfhg4Ga1kHg1dG1UjMBRbTcsJYPhEvleu3pIn5o6JkiV3G0MJUARNHQWtBwdZfO
        Q3JulEggtEgv8DaRX5dfmSTgDs8ICLIy8tc2l7+wgxjTKy0UC+TxffojFH2TbMkz65+BlC
        A8ewu8EoWavvaOt+sYbKUsKJa2UEAl0=
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
Subject: Re: [PATCH v5 05/14] KVM: arm64: Add a helper to tear down unlinked
 stage-2 subtrees
Message-ID: <Y2wvsR6DvyM5YzqN@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-6-oliver.upton@linux.dev>
 <CANgfPd_vAmVR0BTLTFAXuQhS-bP7+B_+2s6cDmTeM5=mf440Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_vAmVR0BTLTFAXuQhS-bP7+B_+2s6cDmTeM5=mf440Gg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 02:23:33PM -0800, Ben Gardon wrote:
> On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > A subsequent change to KVM will move the tear down of an unlinked
> > stage-2 subtree out of the critical path of the break-before-make
> > sequence.
> >
> > Introduce a new helper for tearing down unlinked stage-2 subtrees.
> > Leverage the existing stage-2 free walkers to do so, with a deep call
> > into __kvm_pgtable_walk() as the subtree is no longer reachable from the
> > root.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 23 +++++++++++++++++++++++
> >  2 files changed, 34 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index a752793482cb..93b1feeaebab 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -333,6 +333,17 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >   */
> >  void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >
> > +/**
> > + * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
> > + * @mm_ops:    Memory management callbacks.
> > + * @pgtable:   Unlinked stage-2 paging structure to be freed.
> > + * @level:     Level of the stage-2 paging structure to be freed.
> > + *
> > + * The page-table is assumed to be unreachable by any hardware walkers prior to
> > + * freeing and therefore no TLB invalidation is performed.
> > + */
> > +void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> > +
> >  /**
> >   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> >   * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 93989b750a26..363a5cce7e1a 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1203,3 +1203,26 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
> >         pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
> >         pgt->pgd = NULL;
> >  }
> > +
> > +void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
> > +{
> > +       kvm_pte_t *ptep = (kvm_pte_t *)pgtable;
> > +       struct kvm_pgtable_walker walker = {
> > +               .cb     = stage2_free_walker,
> > +               .flags  = KVM_PGTABLE_WALK_LEAF |
> > +                         KVM_PGTABLE_WALK_TABLE_POST,
> > +       };
> > +       struct kvm_pgtable_walk_data data = {
> > +               .walker = &walker,
> > +
> > +               /*
> > +                * At this point the IPA really doesn't matter, as the page
> > +                * table being traversed has already been removed from the stage
> > +                * 2. Set an appropriate range to cover the entire page table.
> > +                */
> > +               .addr   = 0,
> > +               .end    = kvm_granule_size(level),
> > +       };
> > +
> > +       WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level));
> > +}
> 
> Will this callback be able to yield? In my experience, if processing a
> large teardown (i.e. level >=3 / maps 512G region) it's possible to
> hit scheduler tick warnings.

No, but this is a pretty obvious problem with all of our table walkers,
which led to commit 5994bc9e05c2 ("KVM: arm64: Limit
stage2_apply_range() batch size to largest block").

We're lucky in that the largest supported granule across all page table
sizes is 1GB (no true 5-level paging yet), so it may not be too
horrendous.

But yeah, it is on the list of things to fix :)

--
Thanks,
Oliver
