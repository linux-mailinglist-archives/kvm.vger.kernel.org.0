Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DE258157C
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 16:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239172AbiGZOhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 10:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiGZOhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 10:37:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975A21166;
        Tue, 26 Jul 2022 07:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658846270; x=1690382270;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=R3oRo4zkn7MbH8aoe6XdFaSA5NI0RZoxoAoMOkLwIII=;
  b=FYZNBJ9CLI1zOgxwxAuG0P99TGus0+Uh7H+41+TN9KTX+tEk8KOkbE9f
   4IYXt2lrRXSQzPNY87y16pIMqo1FKmQb0fRcBSPhXF6YdgDEWWe1Qb8CS
   w4oLc/PVT4cEWUWLOCHQIm2+B+hJkZyHsntADPY0Mqpl7Af60FK2pep/D
   lZ2p/yQraYpOjpQa7e6n5wkzzM96ZFZq+2LTT0itvl90xFez60kpKolX/
   fwkahmSncKa1r4v324rSozS+fdEskvBBFXHSBiddgVWJWqYtaWPCG3tB6
   5gdRPcQ3rs1aWNn0RN/bCDGJZtpICoiDtyfog4AKSOPPeQT2duIkY1f5q
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="313735726"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="313735726"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 07:37:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="597044850"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.193.75])
  by orsmga007.jf.intel.com with ESMTP; 26 Jul 2022 07:37:47 -0700
Date:   Tue, 26 Jul 2022 22:32:59 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Message-ID: <20220726143259.GA323308@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <Ys9rcnyIZlUc76iG@google.com>
 <20220720145927.GA124133@chaop.bj.intel.com>
 <d0e82407-91fa-cfa4-ff86-262075d23761@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0e82407-91fa-cfa4-ff86-262075d23761@amd.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022 at 07:16:24PM +0530, Nikunj A. Dadhania wrote:
> On 7/20/2022 8:29 PM, Chao Peng wrote:
> > On Thu, Jul 14, 2022 at 01:03:46AM +0000, Sean Christopherson wrote:
> > ...
> >>
> >> Option D). track shared regions in an Xarray, update kvm_arch_memory_slot.lpage_info
> >> on insertion/removal to (dis)allow hugepages as needed.
> >>
> >>   + efficient on KVM page fault (no new lookups)
> >>   + zero memory overhead (assuming KVM has to eat the cost of the Xarray anyways)
> >>   + straightforward to implement
> >>   + can (and should) be merged as part of the UPM series
> >>
> >> I believe xa_for_each_range() can be used to see if a given 2mb/1gb range is
> >> completely covered (fully shared) or not covered at all (fully private), but I'm
> >> not 100% certain that xa_for_each_range() works the way I think it does.
> > 
> > Hi Sean,
> > 
> > Below is the implementation to support 2M as you mentioned as option D.
> > It's based on UPM v7 xarray code: https://lkml.org/lkml/2022/7/6/259
> > 
> > Everything sounds good, the only trick bit is inc/dec disallow_lpage. If
> > we still treat it as a count, it will be a challenge to make the inc/dec
> > balanced. So in this patch I stole a bit for the purpose, looks ugly.
> > 
> > Any feedback is welcome.
> > 
> > Thanks,
> > Chao
> > 
> > -----------------------------------------------------------------------
> > From: Chao Peng <chao.p.peng@linux.intel.com>
> > Date: Wed, 20 Jul 2022 11:37:18 +0800
> > Subject: [PATCH] KVM: Add large page support for private memory
> > 
> > Update lpage_info when handling KVM_MEMORY_ENCRYPT_{UN,}REG_REGION.
> > 
> > Reserve a bit in disallow_lpage to indicate a large page has
> > private/share pages mixed.
> > 
> > Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> > ---
> 
> 
> > +static void update_mem_lpage_info(struct kvm *kvm,
> > +				  struct kvm_memory_slot *slot,
> > +				  unsigned int attr,
> > +				  gfn_t start, gfn_t end)
> > +{
> > +	unsigned long lpage_start, lpage_end;
> > +	unsigned long gfn, pages, mask;
> > +	int level;
> > +
> > +	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> > +		pages = KVM_PAGES_PER_HPAGE(level);
> > +		mask = ~(pages - 1);
> > +		lpage_start = start & mask;
> > +		lpage_end = end & mask;
> > +
> > +		/*
> > +		 * We only need to scan the head and tail page, for middle pages
> > +		 * we know they are not mixed.
> > +		 */
> > +		update_mixed(lpage_info_slot(lpage_start, slot, level),
> > +			     mem_attr_is_mixed(kvm, attr, lpage_start,
> > +							  lpage_start + pages));
> > +
> > +		if (lpage_start == lpage_end)
> > +			return;
> > +
> > +		for (gfn = lpage_start + pages; gfn < lpage_end; gfn += pages) {
> > +			update_mixed(lpage_info_slot(gfn, slot, level), false);
> > +		}
> 
> Boundary check missing here for the case when gfn reaches lpage_end.
> 
> 		if (gfn == lpage_end)
> 			return;

In this case, it's actually the tail page that I want to scan for with
below code.

It's also possible I misunderstand something here.

Chao
> 
> > +
> > +		update_mixed(lpage_info_slot(lpage_end, slot, level),
> > +			     mem_attr_is_mixed(kvm, attr, lpage_end,
> > +							  lpage_end + pages));
> > +	}
> > +}
> 
> Regards
> Nikunj
