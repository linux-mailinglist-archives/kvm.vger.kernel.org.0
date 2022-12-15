Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A49364D66F
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 07:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLOG0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 01:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLOG0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 01:26:10 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC932C104;
        Wed, 14 Dec 2022 22:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671085569; x=1702621569;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Eco1RLtbCOxx3QDx1kOhuiN0DzkDLaFtMaS1sHina/g=;
  b=JG+ov88RBk7tQHBiT3nT4NNUlrR2tZIm4AQdv6ieoUtlASlr1ansiHba
   oUs+FyUEyGi75J1A0SVAtDdX2qUusp9T6gg6/YoH89bDlZQy8DAUEsuZ6
   mBGpB4+FF/bV/66T5AAI7OoWL7ccrpU64qMCZLyU2VFEnVLS8wh6ZAVv0
   Q+s/aND6aME6za/rkumq4n6vayeInwnUhLHAyKZcbwkVScYT6FmXJcEj/
   81NtB3UT1faARdcCJ1GWl4wfJWXrrRwxqFMw4ZNZgEL8zSpog1/Xwhbj3
   OaWni0hoN2VXGIxPys8/i9rnV050piTzn6OYM48Vo7vnM/NkmAVVnOUkr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="298942405"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="298942405"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 22:26:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="627066034"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="627066034"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 14 Dec 2022 22:26:06 -0800
Message-ID: <2a0ac8520c527392ce32a598990cf29db7026845.camel@linux.intel.com>
Subject: Re: [PATCH 3/5] KVM: x86/mmu: Re-check under lock that TDP MMU SP
 hugepage is disallowed
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Date:   Thu, 15 Dec 2022 14:26:05 +0800
In-Reply-To: <Y5pmI6xwJhvrWXJ8@google.com>
References: <20221213033030.83345-1-seanjc@google.com>
         <20221213033030.83345-4-seanjc@google.com>
         <247fcfc6de8ec08d0667de125e707046dce903fc.camel@linux.intel.com>
         <Y5pmI6xwJhvrWXJ8@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-12-15 at 00:11 +0000, Sean Christopherson wrote:
> On Wed, Dec 14, 2022, Robert Hoo wrote:
> > On Tue, 2022-12-13 at 03:30 +0000, Sean Christopherson wrote:
> > > ---
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c
> > > b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index e2e197d41780..fd4ae99790d7 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -1203,7 +1203,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu,
> > > struct kvm_page_fault *fault)
> > >  		if (fault->huge_page_disallowed &&
> > >  		    fault->req_level >= iter.level) {
> > >  			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > > -			track_possible_nx_huge_page(kvm, sp);
> > > +			if (sp->nx_huge_page_disallowed)
> > > +				track_possible_nx_huge_page(kvm, sp);
> > >  			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > >  		}
> > >  	}
> > 
> > Is this possible?
> > The aforementioned situation happened, i.e. before above hunk
> > track_possible_nx_huge_page(), the sp is zapped by some other task,
> > tdp_mmu_unlink_sp() --> untrack_possible_nx_huge_page(kvm, sp):
> 
> It's possible for untrack_possible_nx_huge_page() to be called before
> the above
> snippet, but the stat won't be decremented in that case since the
> page won't be on
> the list of possible NX huge pages, i.e. list_empty() will be true.

Right, I was fooled by the name of list_empty(), it's actually
list_node_empty(). Thanks for explaining.
> 
>   void untrack_possible_nx_huge_page(struct kvm *kvm, struct
> kvm_mmu_page *sp)
>   {
> 	if (list_empty(&sp->possible_nx_huge_page_link))
> 		return;
> 
> 	--kvm->stat.nx_lpage_splits;
> 
> And by not calling track_possible_nx_huge_page() (this bug fix),
> nx_lpage_splits
> won't be incorrectly incremented.
> 
> > 
> > --kvm->stat.nx_lpage_splits;
> > 
> > But looks like the stat for this sp hasn't been increased yet.
> > 

