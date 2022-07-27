Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0359D582633
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 14:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiG0MOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 08:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiG0MOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 08:14:53 -0400
Received: from out0-134.mail.aliyun.com (out0-134.mail.aliyun.com [140.205.0.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC84248C91
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 05:14:48 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047194;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.Of0ejI-_1658924085;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Of0ejI-_1658924085)
          by smtp.aliyun-inc.com;
          Wed, 27 Jul 2022 20:14:45 +0800
Date:   Wed, 27 Jul 2022 20:14:45 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix wrong gfn range of tlb flushing with range
Message-ID: <20220727121445.GA62296@k08j02272.eu95sqa>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
 <YuBxyPl9W9mWaBRS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuBxyPl9W9mWaBRS@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 27, 2022 at 06:59:20AM +0800, David Matlack wrote:
> On Fri, Jun 24, 2022 at 11:36:56AM +0800, Hou Wenlong wrote:
> > Commit c3134ce240eed
> > ("KVM: Replace old tlb flush function with new one to flush a specified range.")
> > replaces old tlb flush function with kvm_flush_remote_tlbs_with_address()
> > to do tlb flushing. However, the gfn range of tlb flushing is wrong in
> > some cases. E.g., when a spte is dropped, the start gfn of tlb flushing
> > should be the gfn of spte not the base gfn of SP which contains the spte.
> > So this patchset would fix them and do some cleanups.
> 
> One thing that would help prevent future buggy use of
> kvm_flush_remote_tlbs_with_address(), and clean up this series, would be to
> introduce some helper functions for common operations. In fact, even if
> there is only one caller, I still think it would be useful to have helper
> functions because it makes it clear the author's intent.
> 
> For example, I think the following helpers would be useful in this series:
> 
> /* Flush the given page (huge or not) of guest memory. */
> static void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
> {
>         u64 pages = KVM_PAGES_PER_HPAGE(level);
> 
>         kvm_flush_remote_tlbs_with_address(kvm, gfn, pages);
> }
> 
> /* Flush the range of guest memory mapped by the given SPTE. */
> static void kvm_flush_remote_tlbs_sptep(struct kvm *kvm, u64 *sptep)
> {
>         struct kvm_mmu_page *sp = sptep_to_sp(sptep);
>         gfn_t gfn = kvm_mmu_page_get_gfn(sp, spte_index(sptep));
> 
>         kvm_flush_remote_tlbs_gfn(kvm, gfn, sp->role.level);
> }
> 
> /* Flush all memory mapped by the given direct SP. */
> static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> {
>         WARN_ON_ONCE(!sp->role.direct);
>         kvm_flush_remote_tlbs_gfn(kvm, sp->gfn, sp->role.level + 1);
> }
>
Thanks for your good suggestions, I'll add those helpers in the next version.

> > 
> > Hou Wenlong (5):
> >   KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
> >     validate_direct_spte()
> >   KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
> >     kvm_set_pte_rmapp()
> >   KVM: x86/mmu: Reduce gfn range of tlb flushing in
> >     tdp_mmu_map_handle_target_level()
> >   KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
> >   KVM: x86/mmu: Use 1 as the size of gfn range for tlb flushing in
> >     FNAME(invlpg)()
> > 
> >  arch/x86/kvm/mmu/mmu.c         | 15 +++++++++------
> >  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
> >  arch/x86/kvm/mmu/tdp_mmu.c     |  4 ++--
> >  3 files changed, 12 insertions(+), 9 deletions(-)
> > 
> > --
> > 2.31.1
> > 
