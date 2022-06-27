Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2D055B5EE
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 06:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiF0EBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 00:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiF0EBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 00:01:06 -0400
Received: from out0-150.mail.aliyun.com (out0-150.mail.aliyun.com [140.205.0.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F40B389C
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 21:01:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047204;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.ODQddaH_1656302457;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ODQddaH_1656302457)
          by smtp.aliyun-inc.com;
          Mon, 27 Jun 2022 12:00:58 +0800
Date:   Mon, 27 Jun 2022 12:00:57 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
 kvm_set_pte_rmapp()
Message-ID: <20220627040057.GA56893@k08j02272.eu95sqa>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
 <a92b4b56116f0f71ffceab2b4ff3c03f47fd468f.1656039275.git.houwenlong.hwl@antgroup.com>
 <YrZAZXHJTsUp8yuP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrZAZXHJTsUp8yuP@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 25, 2022 at 06:53:25AM +0800, Sean Christopherson wrote:
> On Fri, Jun 24, 2022, Hou Wenlong wrote:
> > When the spte of hupe page is dropped in kvm_set_pte_rmapp(),
> > the whole gfn range covered by the spte should be flushed.
> > However, rmap_walk_init_level() doesn't align down the gfn
> > for new level like tdp iterator does, then the gfn used in
> > kvm_set_pte_rmapp() is not the base gfn of huge page. And
> > the size of gfn range is wrong too for huge page. Since
> > the base gfn of huge page is more meaningful during the
> > rmap walking, so align down the gfn for new level and use
> > the correct size of huge page for tlb flushing in
> > kvm_set_pte_rmapp().
> 
> It's also worth noting that kvm_set_pte_rmapp() is the other user of the rmap
> iterators that consumes @gfn, i.e. modifying iterator->gfn is safe-ish.
>
> > Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index b8a1f5b46b9d..37bfc88ea212 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1427,7 +1427,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> >  	}
> >  
> >  	if (need_flush && kvm_available_flush_tlb_with_range()) {
> > -		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
> > +		kvm_flush_remote_tlbs_with_address(kvm, gfn, KVM_PAGES_PER_HPAGE(level));
> >  		return false;
> >  	}
> >  
> > @@ -1455,7 +1455,7 @@ static void
> >  rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
> >  {
> >  	iterator->level = level;
> > -	iterator->gfn = iterator->start_gfn;
> > +	iterator->gfn = iterator->start_gfn & -KVM_PAGES_PER_HPAGE(level);
> 
> Hrm, arguably this be done on start_gfn in slot_rmap_walk_init().  Having iter->gfn
> be less than iter->start_gfn will be odd.
>
Hrm, iter->gfn may be bigger than iter->end_gfn in slot_rmap_walk_next(), which would
also be odd. I just think it may be better to pass the base gfn of huge page. However,
as you said, kvm_set_pte_rmapp() is the only user of the rmap iterator that consumes @gfn,
only modifying it in that function is enough.

> >  	iterator->rmap = gfn_to_rmap(iterator->gfn, level, iterator->slot);
> >  	iterator->end_rmap = gfn_to_rmap(iterator->end_gfn, level, iterator->slot);
> >  }
> > -- 
> > 2.31.1
> > 
