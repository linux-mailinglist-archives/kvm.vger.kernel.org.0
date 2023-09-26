Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F91B7AEFFE
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 17:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbjIZPwf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 26 Sep 2023 11:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjIZPwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 11:52:34 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1CEEB
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 08:52:22 -0700 (PDT)
Received: from lhrpeml500006.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Rw3yx0L2lz6J7Xw;
        Tue, 26 Sep 2023 23:47:21 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 26 Sep 2023 16:52:19 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Tue, 26 Sep 2023 16:52:19 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
CC:     Oliver Upton <oliver.upton@linux.dev>,
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
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Thread-Topic: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Thread-Index: AQHZ1zeo1TAqj48yIUy5dQTN13GTvLAnEnmAgAAodgCABBhqIIACB0yAgAAW0pA=
Date:   Tue, 26 Sep 2023 15:52:19 +0000
Message-ID: <eeaa28549e22499cae2e23021832a28b@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
        <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
        <ZQ2xmzZ0H5v5wDSw@arm.com> <ZQ3TjMcc0FhZCR0r@linux.dev>
        <c4e12638b4874dc4809d24ce131d7b07@huawei.com> <ZRL2owYDvKF6gnlb@arm.com>
In-Reply-To: <ZRL2owYDvKF6gnlb@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.195.247.239]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Catalin Marinas [mailto:catalin.marinas@arm.com]
> Sent: 26 September 2023 16:20
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>; kvmarm@lists.linux.dev;
> kvm@vger.kernel.org; linux-arm-kernel@lists.infradead.org; maz@kernel.org;
> will@kernel.org; james.morse@arm.com; suzuki.poulose@arm.com;
> yuzenghui <yuzenghui@huawei.com>; zhukeqian
> <zhukeqian1@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related
> pgtable interfaces
> 
> On Mon, Sep 25, 2023 at 08:04:39AM +0000, Shameerali Kolothum Thodi
> wrote:
> > From: Oliver Upton [mailto:oliver.upton@linux.dev]
> > > On Fri, Sep 22, 2023 at 04:24:11PM +0100, Catalin Marinas wrote:
> > > > I was wondering if this interferes with the OS dirty tracking (not the
> > > > KVM one) but I think that's ok, at least at this point, since the PTE is
> > > > already writeable and a fault would have marked the underlying page
> as
> > > > dirty (user_mem_abort() -> kvm_set_pfn_dirty()).
> > > >
> > > > I'm not particularly fond of relying on this but I need to see how it
> > > > fits with the rest of the series. IIRC KVM doesn't go around and make
> > > > Stage 2 PTEs read-only but rather unmaps them when it changes the
> > > > permission of the corresponding Stage 1 VMM mapping.
> > > >
> > > > My personal preference would be to track dirty/clean properly as we do
> > > > for stage 1 (e.g. DBM means writeable PTE) but it has some downsides
> > > > like the try_to_unmap() code having to retrieve the dirty state via
> > > > notifiers.
> > >
> > > KVM's usage of DBM is complicated by the fact that the dirty log
> > > interface w/ userspace is at PTE granularity. We only want the page
> > > table walker to relax PTEs, but take faults on hugepages so we can do
> > > page splitting.
> 
> Thanks for the clarification.
> 
> > > > > @@ -952,6 +990,11 @@ static int stage2_map_walker_try_leaf(const
> struct kvm_pgtable_visit_ctx *ctx,
> > > > >  	    stage2_pte_executable(new))
> > > > >  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops),
> granule);
> > > > >
> > > > > +	/* Save the possible hardware dirty info */
> > > > > +	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
> > > > > +	    stage2_pte_writeable(ctx->old))
> > > > > +		mark_page_dirty(kvm_s2_mmu_to_kvm(pgt->mmu),
> ctx->addr >> PAGE_SHIFT);
> > > > > +
> > > > >  	stage2_make_pte(ctx, new);
> > > >
> > > > Isn't this racy and potentially losing the dirty state? Or is the 'new'
> > > > value guaranteed to have the S2AP[1] bit? For stage 1 we normally
> make
> > > > the page genuinely read-only (clearing DBM) in a cmpxchg loop to
> > > > preserve the dirty state (see ptep_set_wrprotect()).
> > >
> > > stage2_try_break_pte() a few lines up does a cmpxchg() and full
> > > break-before-make, so at this point there shouldn't be a race with
> > > either software or hardware table walkers.
> 
> Ah, I missed this. Also it was unrelated to this patch (or rather not
> introduced by this patch).
> 
> > > In both cases the 'old' translation should have DBM cleared. Even if the
> > > PTE were dirty, this is wasted work since we need to do a final scan of
> > > the stage-2 when userspace collects the dirty log.
> > >
> > > Am I missing something?
> >
> > I think we can get rid of the above mark_page_dirty(). I will test it to
> confirm
> > we are not missing anything here.
> 
> Is this the case for the other places of mark_page_dirty() in your
> patches? If stage2_pte_writeable() is true, it must have been made
> writeable earlier by a fault and the underlying page marked as dirty.
> 

One of the other place we have mark_page_dirty() is in the stage2_unmap_walker().
And during the testing of this series, I have tried to remove that and
found out that it actually causes memory corruption during VM migration.

From my old debug logs:

[  399.288076]  stage2_unmap_walker+0x270/0x284
[  399.288078]  __kvm_pgtable_walk+0x1ec/0x2cc
[  399.288081]  __kvm_pgtable_walk+0xec/0x2cc
[  399.288084]  __kvm_pgtable_walk+0xec/0x2cc
[  399.288086]  kvm_pgtable_walk+0xcc/0x160
[  399.288088]  kvm_pgtable_stage2_unmap+0x4c/0xbc
[  399.288091]  stage2_apply_range+0xd0/0xec
[  399.288094]  __unmap_stage2_range+0x2c/0x60
[  399.288096]  kvm_unmap_gfn_range+0x30/0x48
[  399.288099]  kvm_mmu_notifier_invalidate_range_start+0xe0/0x264
[  399.288103]  __mmu_notifier_invalidate_range_start+0xa4/0x23c
[  399.288106]  change_protection+0x638/0x900
[  399.288109]  change_prot_numa+0x64/0xfc
[  399.288113]  task_numa_work+0x2ac/0x450
[  399.288117]  task_work_run+0x78/0xd0

It looks like that the unmap path gets triggered from Numa page migration code
path, so we may need it there.

Thanks,
Shameer
