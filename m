Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3056D6F01
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 23:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbjDDVbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 17:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235349AbjDDVbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 17:31:12 -0400
Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [IPv6:2001:41d0:1004:224b::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A09E75
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 14:31:06 -0700 (PDT)
Date:   Tue, 4 Apr 2023 21:30:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680643863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SsgHNY8O06mzJkVvQbVL9Xa4GJi9yWNJ69sEdZ9emNU=;
        b=dmxKl2hk72kz1cKtjab9RSKfuc2VzxGavUeDQosNz4FjNZetsfNbYpNqmXKLPDrjr7I5Ut
        n8iKg7Zp4ngIGXHmwR8zgnFjOxAWmWb4ndj8bD5EkweMLsHXysjvbm8ylv0pc8WzyhK7Mf
        FxewgCQagjWqsDc78JElMvjvDzN8I1M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     h@linux.dev, Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 7/7] KVM: arm64: Create a fast stage-2 unmap path
Message-ID: <ZCyXEsm0RkvMQuns@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-8-rananta@google.com>
 <ZCTa5wfVtGScLQEa@linux.dev>
 <CAJHc60xvSFpUs+o84fR14Rghd6rruBJkCMBtroeCeLDtjJg=gw@mail.gmail.com>
 <ZCx4QCs+cjr4nYev@linux.dev>
 <CAJHc60xQ36vah9+eEOLqKdjamfoxijPTwXLrrhOy=NVvMW=VOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60xQ36vah9+eEOLqKdjamfoxijPTwXLrrhOy=NVvMW=VOw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 02:07:06PM -0700, Raghavendra Rao Ananta wrote:
> On Tue, Apr 4, 2023 at 12:19 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Tue, Apr 04, 2023 at 10:52:01AM -0700, Raghavendra Rao Ananta wrote:
> > > On Wed, Mar 29, 2023 at 5:42 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > >
> > > > On Mon, Feb 06, 2023 at 05:23:40PM +0000, Raghavendra Rao Ananta wrote:
> > > > > The current implementation of the stage-2 unmap walker
> > > > > traverses the entire page-table to clear and flush the TLBs
> > > > > for each entry. This could be very expensive, especially if
> > > > > the VM is not backed by hugepages. The unmap operation could be
> > > > > made efficient by disconnecting the table at the very
> > > > > top (level at which the largest block mapping can be hosted)
> > > > > and do the rest of the unmapping using free_removed_table().
> > > > > If the system supports FEAT_TLBIRANGE, flush the entire range
> > > > > that has been disconnected from the rest of the page-table.
> > > > >
> > > > > Suggested-by: Ricardo Koller <ricarkol@google.com>
> > > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > > ---
> > > > >  arch/arm64/kvm/hyp/pgtable.c | 44 ++++++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 44 insertions(+)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > > > index 0858d1fa85d6b..af3729d0971f2 100644
> > > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > > @@ -1017,6 +1017,49 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > > > >       return 0;
> > > > >  }
> > > > >
> > > > > +/*
> > > > > + * The fast walker executes only if the unmap size is exactly equal to the
> > > > > + * largest block mapping supported (i.e. at KVM_PGTABLE_MIN_BLOCK_LEVEL),
> > > > > + * such that the underneath hierarchy at KVM_PGTABLE_MIN_BLOCK_LEVEL can
> > > > > + * be disconnected from the rest of the page-table without the need to
> > > > > + * traverse all the PTEs, at all the levels, and unmap each and every one
> > > > > + * of them. The disconnected table is freed using free_removed_table().
> > > > > + */
> > > > > +static int fast_stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > > > > +                            enum kvm_pgtable_walk_flags visit)
> > > > > +{
> > > > > +     struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > > > > +     kvm_pte_t *childp = kvm_pte_follow(ctx->old, mm_ops);
> > > > > +     struct kvm_s2_mmu *mmu = ctx->arg;
> > > > > +
> > > > > +     if (!kvm_pte_valid(ctx->old) || ctx->level != KVM_PGTABLE_MIN_BLOCK_LEVEL)
> > > > > +             return 0;
> > > > > +
> > > > > +     if (!stage2_try_break_pte(ctx, mmu))
> > > > > +             return -EAGAIN;
> > > > > +
> > > > > +     /*
> > > > > +      * Gain back a reference for stage2_unmap_walker() to free
> > > > > +      * this table entry from KVM_PGTABLE_MIN_BLOCK_LEVEL - 1.
> > > > > +      */
> > > > > +     mm_ops->get_page(ctx->ptep);
> > > >
> > > > Doesn't this run the risk of a potential UAF if the refcount was 1 before
> > > > calling stage2_try_break_pte()? IOW, stage2_try_break_pte() will drop
> > > > the refcount to 0 on the page before this ever gets called.
> > > >
> > > > Also, AFAICT this misses the CMOs that are required on systems w/o
> > > > FEAT_FWB. Without them it is possible that the host will read something
> > > > other than what was most recently written by the guest if it is using
> > > > noncacheable memory attributes at stage-1.
> > > >
> > > > I imagine the actual bottleneck is the DSB required after every
> > > > CMO/TLBI. Theoretically, the unmap path could be updated to:
> > > >
> > > >  - Perform the appropriate CMOs for every valid leaf entry *without*
> > > >    issuing a DSB.
> > > >
> > > >  - Elide TLBIs entirely that take place in the middle of the walk
> > > >
> > > >  - After the walk completes, dsb(ish) to guarantee that the CMOs have
> > > >    completed and the invalid PTEs are made visible to the hardware
> > > >    walkers. This should be done implicitly by the TLBI implementation
> > > >
> > > >  - Invalidate the [addr, addr + size) range of IPAs
> > > >
> > > > This would also avoid over-invalidating stage-1 since we blast the
> > > > entire stage-1 context for every stage-2 invalidation. Thoughts?
> > > >
> > > Correct me if I'm wrong, but if we invalidate the TLB after the walk
> > > is complete, don't you think there's a risk of race if the guest can
> > > hit in the TLB even though the page was unmapped?
> >
> > Yeah, we'd need to do the CMOs _after_ making the translation invalid in
> > the page tables and completing the TLB invalidation. Apologies.
> >
> > Otherwise, the only requirement we need to uphold w/ either the MMU
> > notifiers or userspace is that the translation has been invalidated at
> > the time of return.
> >
> Actually, my concern about the race was against the hardware. If we
> follow the above approach, let's say we invalidated a certain set of
> PTEs, but the TLBs aren't yet invalidated. During this point if
> another vCPU accesses the range governed by the invalidated PTEs,
> wouldn't it still hit in the TLB? Have I misunderstood you or am I
> missing something?

Yep, that's exactly what would happen. There is no way to eliminate the
race you mention, there will always be a window of time where the page
tables no longer contain a particular translation but the TLBs may still
be holding a valid entry.

This race is benign so long as we guarantee that all translations for
the affected address (i.e. in the page tables, cached in a TLB) have
been invalidated before returning to the caller. For example, MM cannot
start swapping out guest memory until it is guaranteed that the guest is
no longer writing to it.

-- 
Thanks,
Oliver
