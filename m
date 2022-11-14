Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE58628882
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 19:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbiKNSoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 13:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbiKNSoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 13:44:20 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F0C12AEB
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 10:44:18 -0800 (PST)
Date:   Mon, 14 Nov 2022 18:42:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668451368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X+U+NJNCu/c8YMS1IS3cNEP5WXAs5yXLq4otDmEC+Mo=;
        b=dk40lOcyHXzcVC3i95Xna883cfotKgSWyiRtvWC6evDFfwVPNAFBDv9AA+y1Pq06w1EGdR
        Ty9O0T9QfCKo0KVkhpCMHiQQ/YGjd7XJnUk2VBf3BMEG3rdzn6qDAJ2sQJXP34DolZL/gs
        nTTlkMDV0XzfXD7RxOyOnQRslvOW/Xk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, kvmarm@lists.linux.dev,
        ricarkol@gmail.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] KVM: arm64: Eager huge-page splitting for
 dirty-logging
Message-ID: <Y3KMHGvIEuwhU1wS@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Sat, Nov 12, 2022 at 08:17:02AM +0000, Ricardo Koller wrote:
> Hi,
> 
> I'm sending this RFC mainly to get some early feedback on the approach used
> for implementing "Eager Page Splitting" on ARM.  "Eager Page Splitting"
> improves the performance of dirty-logging (used in live migrations) when
> guest memory is backed by huge-pages.  It's an optimization used in Google
> Cloud since 2016 on x86, and for the last couple of months on ARM.
> 
> I tried multiple ways of implementing this optimization on ARM: from
> completely reusing the stage2 mapper, to implementing a new walker from
> scratch, and some versions in between. This RFC is one of those in
> between. They all have similar performance benefits, based on some light
> performance testing (mainly dirty_log_perf_test).
> 
> Background and motivation
> =========================
> Dirty logging is typically used for live-migration iterative copying.  KVM
> implements dirty-logging at the PAGE_SIZE granularity (will refer to 4K
> pages from now on).  It does it by faulting on write-protected 4K pages.
> Therefore, enabling dirty-logging on a huge-page requires breaking it into
> 4K pages in the first place.  KVM does this breaking on fault, and because
> it's in the critical path it only maps the 4K page that faulted; every
> other 4K page is left unmapped.  This is not great for performance on ARM
> for a couple of reasons:
> 
> - Splitting on fault can halt vcpus for milliseconds in some
>   implementations. Splitting a block PTE requires using a broadcasted TLB
>   invalidation (TLBI) for every huge-page (due to the break-before-make
>   requirement). Note that x86 doesn't need this. We observed some
>   implementations that take millliseconds to complete broadcasted TLBIs
>   when done in parallel from multiple vcpus.  And that's exactly what
>   happens when doing it on fault: multiple vcpus fault at the same time
>   triggering TLBIs in parallel.
> 
> - Read intensive guest workloads end up paying for dirty-logging.  Only
>   mapping the faulting 4K page means that all the other pages that were
>   part of the huge-page will now be unmapped. The effect is that any
>   access, including reads, now has to fault.
> 
> Eager Page Splitting (on ARM)
> =============================
> Eager Page Splitting fixes the above two issues by eagerly splitting
> huge-pages when enabling dirty logging. The goal is to avoid doing it while
> faulting on write-protected pages. This is what the TDP MMU does for x86
> [0], except that x86 does it for different reasons: to avoid grabbing the
> MMU lock on fault. Note that taking care of write-protection faults still
> requires grabbing the MMU lock on ARM, but not on x86 (with the
> fast_page_fault path).
> 
> An additional benefit of eagerly splitting huge-pages is that it can be
> done in a controlled way (e.g., via an IOCTL). This series provides two
> knobs for doing it, just like its x86 counterpart: when enabling dirty
> logging, and when using the KVM_CLEAR_DIRTY_LOG ioctl. The benefit of doing
> it on KVM_CLEAR_DIRTY_LOG is that this ioctl takes ranges, and not complete
> memslots like when enabling dirty logging. This means that the cost of
> splitting (mainly broadcasted TLBIs) can be throttled: split a range, wait
> for a bit, split another range, etc. The benefits of this approach were
> presented by Oliver Upton at KVM Forum 2022 [1].
> 
> Implementation
> ==============
> Patches 1-4 add a pgtable utility function for splitting huge block PTEs:
> kvm_pgtable_stage2_split(). Patches 5-6 add support for not doing
> break-before-make on huge-page breaking when FEAT_BBM level 2 is supported.

I would suggest you split up FEAT_BBM=2 and eager page splitting into
two separate series, if possible. IMO, the eager page split is easier to
reason about if it follows the existing pattern of break-before-make.

--
Thanks,
Oliver
