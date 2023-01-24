Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE867A594
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 23:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbjAXWU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 17:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbjAXWUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 17:20:22 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F51E4FCF2
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 14:20:09 -0800 (PST)
Date:   Tue, 24 Jan 2023 14:19:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674598806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OCBfEODFKSWyFeydGUGZ0cHcrxRDh9Y42D13cNqLF3I=;
        b=o1bDdDnULIjx6lxzCDdwdLZ5d8nAricJW94EasG8LIbNXdaC5bRZHNyqLlYzloocUsM2YX
        sKcfAnhLo+u9yICx8suxzizTBHW45BFYmGTDGVpo5QyPijKrYU4BRnijE3EMyw76ztUFJH
        nwFsmP2REJfmV2zhToPyugEuA//7amU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ben Gardon <bgardon@google.com>
Cc:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is
 enabled
Message-ID: <Y9BZj7i+R7E9Vhy+@thinky-boi>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-7-ricarkol@google.com>
 <CANgfPd9B0GcDST6-GHgPTv3j=EBqUYjkNUuAuiB2Ei3nLYaSEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9B0GcDST6-GHgPTv3j=EBqUYjkNUuAuiB2Ei3nLYaSEQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 09:52:49AM -0800, Ben Gardon wrote:
> On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Split huge pages eagerly when enabling dirty logging. The goal is to
> > avoid doing it while faulting on write-protected pages, which
> > negatively impacts guest performance.
> >
> > A memslot marked for dirty logging is split in 1GB pieces at a time.
> > This is in order to release the mmu_lock and give other kernel threads
> > the opportunity to run, and also in order to allocate enough pages to
> > split a 1GB range worth of huge pages (or a single 1GB huge page).
> > Note that these page allocations can fail, so eager page splitting is
> > best-effort.  This is not a correctness issue though, as huge pages
> > can still be split on write-faults.
> >
> > The benefits of eager page splitting are the same as in x86, added
> > with commit a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by
> > the TDP MMU when dirty logging is enabled"). For example, when running
> > dirty_log_perf_test with 64 virtual CPUs (Ampere Altra), 1GB per vCPU,
> > 50% reads, and 2MB HugeTLB memory, the time it takes vCPUs to access
> > all of their memory after dirty logging is enabled decreased by 44%
> > from 2.58s to 1.42s.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  30 ++++++++
> >  arch/arm64/kvm/mmu.c              | 110 +++++++++++++++++++++++++++++-
> >  2 files changed, 138 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 35a159d131b5..6ab37209b1d1 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -153,6 +153,36 @@ struct kvm_s2_mmu {
> >         /* The last vcpu id that ran on each physical CPU */
> >         int __percpu *last_vcpu_ran;
> >
> > +       /*
> > +        * Memory cache used to split EAGER_PAGE_SPLIT_CHUNK_SIZE worth of huge
> > +        * pages. It is used to allocate stage2 page tables while splitting
> > +        * huge pages. Its capacity should be EAGER_PAGE_SPLIT_CACHE_CAPACITY.
> > +        * Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE influences both
> > +        * the capacity of the split page cache (CACHE_CAPACITY), and how often
> > +        * KVM reschedules. Be wary of raising CHUNK_SIZE too high.
> > +        *
> > +        * A good heuristic to pick CHUNK_SIZE is that it should be larger than
> > +        * all the available huge-page sizes, and be a multiple of all the
> > +        * other ones; for example, 1GB when all the available huge-page sizes
> > +        * are (1GB, 2MB, 32MB, 512MB).
> 
> This feels a little fragile to link scheduling decisions into the
> batch size.

Completely agree.

> (I'm not saying we don't do the same thing on x86, but
> it's a mistake in either case.) I'd prefer if we could yield more
> granularly in a way that's not tied to splitting a whole
> EAGER_PAGE_SPLIT_CHUNK_SIZE worth of pages.
> Tuning the chunk size to balance memory overhead with batch
> performance makes sense, but it becomes more difficult to also balance
> with the needs of the scheduler. Could we add some yield point in
> kvm_pgtable_stage2_split or give it an early return path or something?

We definitely need to move in the direction of early returns, but I'd
rather not build it purely for the sake of eager page spliting. A better
approach would likely be to add it to the core page table walker code
such that all walkers that operate on a swath of memory can use it.

In the interest of keeping this series manageable, I'd prefer yielding
walkers be done in a separate series.

--
Thanks,
Oliver
