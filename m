Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8246F7AEF80
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 17:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbjIZPUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 11:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjIZPUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 11:20:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE31410A
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 08:20:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117E9C433C8;
        Tue, 26 Sep 2023 15:20:05 +0000 (UTC)
Date:   Tue, 26 Sep 2023 16:20:03 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        zhukeqian <zhukeqian1@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Message-ID: <ZRL2owYDvKF6gnlb@arm.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
 <ZQ2xmzZ0H5v5wDSw@arm.com>
 <ZQ3TjMcc0FhZCR0r@linux.dev>
 <c4e12638b4874dc4809d24ce131d7b07@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e12638b4874dc4809d24ce131d7b07@huawei.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 08:04:39AM +0000, Shameerali Kolothum Thodi wrote:
> From: Oliver Upton [mailto:oliver.upton@linux.dev]
> > On Fri, Sep 22, 2023 at 04:24:11PM +0100, Catalin Marinas wrote:
> > > I was wondering if this interferes with the OS dirty tracking (not the
> > > KVM one) but I think that's ok, at least at this point, since the PTE is
> > > already writeable and a fault would have marked the underlying page as
> > > dirty (user_mem_abort() -> kvm_set_pfn_dirty()).
> > >
> > > I'm not particularly fond of relying on this but I need to see how it
> > > fits with the rest of the series. IIRC KVM doesn't go around and make
> > > Stage 2 PTEs read-only but rather unmaps them when it changes the
> > > permission of the corresponding Stage 1 VMM mapping.
> > >
> > > My personal preference would be to track dirty/clean properly as we do
> > > for stage 1 (e.g. DBM means writeable PTE) but it has some downsides
> > > like the try_to_unmap() code having to retrieve the dirty state via
> > > notifiers.
> > 
> > KVM's usage of DBM is complicated by the fact that the dirty log
> > interface w/ userspace is at PTE granularity. We only want the page
> > table walker to relax PTEs, but take faults on hugepages so we can do
> > page splitting.

Thanks for the clarification.

> > > > @@ -952,6 +990,11 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> > > >  	    stage2_pte_executable(new))
> > > >  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
> > > >
> > > > +	/* Save the possible hardware dirty info */
> > > > +	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
> > > > +	    stage2_pte_writeable(ctx->old))
> > > > +		mark_page_dirty(kvm_s2_mmu_to_kvm(pgt->mmu), ctx->addr >> PAGE_SHIFT);
> > > > +
> > > >  	stage2_make_pte(ctx, new);
> > >
> > > Isn't this racy and potentially losing the dirty state? Or is the 'new'
> > > value guaranteed to have the S2AP[1] bit? For stage 1 we normally make
> > > the page genuinely read-only (clearing DBM) in a cmpxchg loop to
> > > preserve the dirty state (see ptep_set_wrprotect()).
> > 
> > stage2_try_break_pte() a few lines up does a cmpxchg() and full
> > break-before-make, so at this point there shouldn't be a race with
> > either software or hardware table walkers.

Ah, I missed this. Also it was unrelated to this patch (or rather not
introduced by this patch).

> > In both cases the 'old' translation should have DBM cleared. Even if the
> > PTE were dirty, this is wasted work since we need to do a final scan of
> > the stage-2 when userspace collects the dirty log.
> > 
> > Am I missing something?
> 
> I think we can get rid of the above mark_page_dirty(). I will test it to confirm
> we are not missing anything here.

Is this the case for the other places of mark_page_dirty() in your
patches? If stage2_pte_writeable() is true, it must have been made
writeable earlier by a fault and the underlying page marked as dirty.

-- 
Catalin
