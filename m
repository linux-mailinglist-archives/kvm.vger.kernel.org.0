Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9090B7AD2A6
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 10:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbjIYIEv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 25 Sep 2023 04:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjIYIEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 04:04:49 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894B4B3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 01:04:42 -0700 (PDT)
Received: from lhrpeml100003.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RvFdq0Dq7z6J7ty;
        Mon, 25 Sep 2023 15:59:43 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100003.china.huawei.com (7.191.160.210) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 25 Sep 2023 09:04:39 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Mon, 25 Sep 2023 09:04:39 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        zhukeqian <zhukeqian1@huawei.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Thread-Topic: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Thread-Index: AQHZ1zeo1TAqj48yIUy5dQTN13GTvLAnEnmAgAAodgCABBhqIA==
Date:   Mon, 25 Sep 2023 08:04:39 +0000
Message-ID: <c4e12638b4874dc4809d24ce131d7b07@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
 <ZQ2xmzZ0H5v5wDSw@arm.com> <ZQ3TjMcc0FhZCR0r@linux.dev>
In-Reply-To: <ZQ3TjMcc0FhZCR0r@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.145.190]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Oliver Upton [mailto:oliver.upton@linux.dev]
> Sent: 22 September 2023 18:49
> To: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kvmarm@lists.linux.dev; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; maz@kernel.org; will@kernel.org;
> james.morse@arm.com; suzuki.poulose@arm.com; yuzenghui
> <yuzenghui@huawei.com>; zhukeqian <zhukeqian1@huawei.com>; Jonathan
> Cameron <jonathan.cameron@huawei.com>; Linuxarm
> <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related
> pgtable interfaces
> 
> On Fri, Sep 22, 2023 at 04:24:11PM +0100, Catalin Marinas wrote:
> > On Fri, Aug 25, 2023 at 10:35:23AM +0100, Shameer Kolothum wrote:
> > > +static bool stage2_pte_writeable(kvm_pte_t pte)
> > > +{
> > > +	return pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > > +}
> > > +
> > > +static void kvm_update_hw_dbm(const struct kvm_pgtable_visit_ctx
> *ctx,
> > > +			      kvm_pte_t new)
> > > +{
> > > +	kvm_pte_t old_pte, pte = ctx->old;
> > > +
> > > +	/* Only set DBM if page is writeable */
> > > +	if ((new & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> && !stage2_pte_writeable(pte))
> > > +		return;
> > > +
> > > +	/* Clear DBM walk is not shared, update */
> > > +	if (!kvm_pgtable_walk_shared(ctx)) {
> > > +		WRITE_ONCE(*ctx->ptep, new);
> > > +		return;
> > > +	}
> >
> > I was wondering if this interferes with the OS dirty tracking (not the
> > KVM one) but I think that's ok, at least at this point, since the PTE is
> > already writeable and a fault would have marked the underlying page as
> > dirty (user_mem_abort() -> kvm_set_pfn_dirty()).
> >
> > I'm not particularly fond of relying on this but I need to see how it
> > fits with the rest of the series. IIRC KVM doesn't go around and make
> > Stage 2 PTEs read-only but rather unmaps them when it changes the
> > permission of the corresponding Stage 1 VMM mapping.
> >
> > My personal preference would be to track dirty/clean properly as we do
> > for stage 1 (e.g. DBM means writeable PTE) but it has some downsides
> > like the try_to_unmap() code having to retrieve the dirty state via
> > notifiers.
> 
> KVM's usage of DBM is complicated by the fact that the dirty log
> interface w/ userspace is at PTE granularity. We only want the page
> table walker to relax PTEs, but take faults on hugepages so we can do
> page splitting.
> 
> > Anyway, assuming this works correctly, it means that live migration via
> > DBM is only tracked for PTEs already made dirty/writeable by some guest
> > write.
> 
> I'm hoping that we move away from this combined write-protection and
> DBM
> scheme and only use a single dirty tracking strategy at a time.

Yes. As mentioned in the cover letter this is a combined approach where we only set
DBM for near-by pages(64) on page fault when migration is started.

> 
> > > @@ -952,6 +990,11 @@ static int stage2_map_walker_try_leaf(const
> struct kvm_pgtable_visit_ctx *ctx,
> > >  	    stage2_pte_executable(new))
> > >  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops),
> granule);
> > >
> > > +	/* Save the possible hardware dirty info */
> > > +	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
> > > +	    stage2_pte_writeable(ctx->old))
> > > +		mark_page_dirty(kvm_s2_mmu_to_kvm(pgt->mmu),
> ctx->addr >> PAGE_SHIFT);
> > > +
> > >  	stage2_make_pte(ctx, new);
> >
> > Isn't this racy and potentially losing the dirty state? Or is the 'new'
> > value guaranteed to have the S2AP[1] bit? For stage 1 we normally make
> > the page genuinely read-only (clearing DBM) in a cmpxchg loop to
> > preserve the dirty state (see ptep_set_wrprotect()).
> 
> stage2_try_break_pte() a few lines up does a cmpxchg() and full
> break-before-make, so at this point there shouldn't be a race with
> either software or hardware table walkers.
> 
> But I'm still confused by this one. KVM only goes down the map
> walker path (in the context of dirty tracking) if:
> 
>  - We took a translation fault
> 
>  - We took a write permission fault on a hugepage and need to split

Agree.

> In both cases the 'old' translation should have DBM cleared. Even if the
> PTE were dirty, this is wasted work since we need to do a final scan of
> the stage-2 when userspace collects the dirty log.
> 
> Am I missing something?

I think we can get rid of the above mark_page_dirty(). I will test it to confirm
we are not missing anything here.
 
Thanks,
Shameer
