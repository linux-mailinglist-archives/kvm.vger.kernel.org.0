Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE07588ACA
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 12:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiHCKxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 06:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbiHCKxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 06:53:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FE91B79C;
        Wed,  3 Aug 2022 03:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659524015; x=1691060015;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=ZtUDkmwirNLQ46D5tuQfA6pBKwbfXQX66S6JLq+xUBs=;
  b=HsPiI0IWXJXKHYrYqOzzZw9dTJo4vtSEawYlwgrMlMKeKXZQhqTNxLfb
   j1RUjy3q2ALBX7nhGh9A9ypslomEO9u2ziR8J/kPUcc39Agl+KH/dqC3S
   PV0WBlBEn+ix3VukiZDs64W/VVcZ27D6iaxjV6f6QtE3EGGe9MApmrr2g
   9AxZEOknCIjT4aG5JCprTEoxggr+whuA+Kk8Kuq0WsXVOPAzm0EI+Z93H
   bmjvM/jhW5rbj/EhnXklGGH4a/HEh1ZLuHkH+ejxcWGh1wZN1TnIcNm+a
   YjsQwZHgvHOzpVx6ad5Q2G4NxDIWBYUCkyJzRK+tbfsaK+dwElGTViefW
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="269412971"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="269412971"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 03:53:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="631104752"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.193.75])
  by orsmga008.jf.intel.com with ESMTP; 03 Aug 2022 03:53:32 -0700
Date:   Wed, 3 Aug 2022 18:48:45 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Message-ID: <20220803104845.GF607465@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <Ys9rcnyIZlUc76iG@google.com>
 <20220720145927.GA124133@chaop.bj.intel.com>
 <d0e82407-91fa-cfa4-ff86-262075d23761@amd.com>
 <20220726143259.GA323308@chaop.bj.intel.com>
 <e234d307-0b05-6548-5882-c24fc32c8e77@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e234d307-0b05-6548-5882-c24fc32c8e77@amd.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 27, 2022 at 02:56:40PM +0530, Nikunj A. Dadhania wrote:
> On 7/26/2022 8:02 PM, Chao Peng wrote:
> > On Mon, Jul 25, 2022 at 07:16:24PM +0530, Nikunj A. Dadhania wrote:
> >> On 7/20/2022 8:29 PM, Chao Peng wrote:
> >>> On Thu, Jul 14, 2022 at 01:03:46AM +0000, Sean Christopherson wrote:
> >>> ...
> >>>>
> >>>> Option D). track shared regions in an Xarray, update kvm_arch_memory_slot.lpage_info
> >>>> on insertion/removal to (dis)allow hugepages as needed.
> >>>>
> >>>>   + efficient on KVM page fault (no new lookups)
> >>>>   + zero memory overhead (assuming KVM has to eat the cost of the Xarray anyways)
> >>>>   + straightforward to implement
> >>>>   + can (and should) be merged as part of the UPM series
> >>>>
> >>>> I believe xa_for_each_range() can be used to see if a given 2mb/1gb range is
> >>>> completely covered (fully shared) or not covered at all (fully private), but I'm
> >>>> not 100% certain that xa_for_each_range() works the way I think it does.
> >>>
> >>> Hi Sean,
> >>>
> >>> Below is the implementation to support 2M as you mentioned as option D.
> >>> It's based on UPM v7 xarray code: https://lkml.org/lkml/2022/7/6/259
> >>>
> >>> Everything sounds good, the only trick bit is inc/dec disallow_lpage. If
> >>> we still treat it as a count, it will be a challenge to make the inc/dec
> >>> balanced. So in this patch I stole a bit for the purpose, looks ugly.
> >>>
> >>> Any feedback is welcome.
> >>>
> >>> Thanks,
> >>> Chao
> >>>
> >>> -----------------------------------------------------------------------
> >>> From: Chao Peng <chao.p.peng@linux.intel.com>
> >>> Date: Wed, 20 Jul 2022 11:37:18 +0800
> >>> Subject: [PATCH] KVM: Add large page support for private memory
> >>>
> >>> Update lpage_info when handling KVM_MEMORY_ENCRYPT_{UN,}REG_REGION.
> >>>
> >>> Reserve a bit in disallow_lpage to indicate a large page has
> >>> private/share pages mixed.
> >>>
> >>> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> >>> ---
> >>
> >>
> >>> +static void update_mem_lpage_info(struct kvm *kvm,
> >>> +				  struct kvm_memory_slot *slot,
> >>> +				  unsigned int attr,
> >>> +				  gfn_t start, gfn_t end)
> >>> +{
> >>> +	unsigned long lpage_start, lpage_end;
> >>> +	unsigned long gfn, pages, mask;
> >>> +	int level;
> >>> +
> >>> +	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> >>> +		pages = KVM_PAGES_PER_HPAGE(level);
> >>> +		mask = ~(pages - 1);
> >>> +		lpage_start = start & mask;
> >>> +		lpage_end = end & mask;
> >>> +
> >>> +		/*
> >>> +		 * We only need to scan the head and tail page, for middle pages
> >>> +		 * we know they are not mixed.
> >>> +		 */
> >>> +		update_mixed(lpage_info_slot(lpage_start, slot, level),
> >>> +			     mem_attr_is_mixed(kvm, attr, lpage_start,
> >>> +							  lpage_start + pages));
> >>> +
> >>> +		if (lpage_start == lpage_end)
> >>> +			return;
> >>> +
> >>> +		for (gfn = lpage_start + pages; gfn < lpage_end; gfn += pages) {
> >>> +			update_mixed(lpage_info_slot(gfn, slot, level), false);
> >>> +		}
> >>
> >> Boundary check missing here for the case when gfn reaches lpage_end.
> >>
> >> 		if (gfn == lpage_end)
> >> 			return;
> > 
> > In this case, it's actually the tail page that I want to scan for with
> > below code.
> 
> What if you do not have the tail lpage?
> 
> For example: memslot base_gfn = 0x1000 and npages is 0x800, so memslot range
> is 0x1000 to 0x17ff.
> 
> Assume a case when this function is called with start = 1000 and end = 1800.
> For 2M, page mask is 0x1ff. start and end both are 2M aligned.
> 
> First update_mixed takes care of 0x1000-0x1200
> Loop update_mixed: goes over from 0x1200 - 0x1800, there are no pages left
> for last update_mixed to process.

Oops, good catch. I would fix it differently by playing with lpage_end:
	lpage_end = (end - 1) & mask;

Thanks,
Chao

> 
> > 
> > It's also possible I misunderstand something here.
> > 
> > Chao
> >>
> >>> +
> >>> +		update_mixed(lpage_info_slot(lpage_end, slot, level),
> >>> +			     mem_attr_is_mixed(kvm, attr, lpage_end,
> >>> +							  lpage_end + pages));
> 
> lpage_info_slot some times causes a crash, as I noticed that
> lpage_info_slot() returns out-of-bound index.
> 
> Regards
> Nikunj
> 
