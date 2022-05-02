Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A224D516A9C
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 08:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383382AbiEBGDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 02:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiEBGD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 02:03:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB343FBF0;
        Sun,  1 May 2022 23:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651471201; x=1683007201;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rhf9Y5lTA+NJj7q6473ZroJ+mCTDCnohi+5bLCeIjTM=;
  b=NQpvGDmXxmsUYFRqNER9b/ccLQO6tCPFndzNvpMO7Lo/y7Y4Be0za6Nj
   0ypb0rWM7gPNvSV23fRNkQyU1SmqVS5JdKAUvF7DzU4eD5DDj3kunNt/A
   WaInHCD+bb9KxjCZ8ZoUUexRCfY2Pkryn8jI+3mfTRx0OE8ssbzvFs53O
   Q1sVi/lXdh40j/vS+lwMHgGz4iQ+1+QJ9ZTw3ql51Ol5r3Ckqvj6r3sKd
   1LpAU7ixNciBx4V8odDSJzCZwbD8OzEPSBBmey40isx08V4x1WgugKPdy
   pFNXPHbPzWSXzPeFmW8Wm/OO93YGTdna0aJ6VRRPs1pD0IFEq40e14gyX
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="264718945"
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="264718945"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2022 23:00:01 -0700
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="535701165"
Received: from bwu50-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.2.219])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2022 22:59:57 -0700
Message-ID: <af603d66512ec5dca0c240cf81c83de7dfe730e7.camel@intel.com>
Subject: Re: [PATCH v3 13/21] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Mon, 02 May 2022 17:59:55 +1200
In-Reply-To: <5984b61f-6a4a-c12a-944d-f4a78bdefc3d@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <ffc2eefdd212a31278978e8bfccd571355db69b0.1649219184.git.kai.huang@intel.com>
         <c9b17e50-e665-3fc6-be8c-5bb16afa784e@intel.com>
         <3664ab2a8e0b0fcbb4b048b5c3aa5a6e85f9618a.camel@intel.com>
         <5984b61f-6a4a-c12a-944d-f4a78bdefc3d@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-29 at 07:20 -0700, Dave Hansen wrote:
> On 4/29/22 00:46, Kai Huang wrote:
> > On Thu, 2022-04-28 at 10:12 -0700, Dave Hansen wrote:
> > > This is also a good place to note the downsides of using
> > > alloc_contig_pages().
> > 
> > For instance:
> > 
> > 	The allocation may fail when memory usage is under pressure.
> 
> It's not really memory pressure, though.  The larger the allocation, the
> more likely it is to fail.  The more likely it is that the kernel can't
> free the memory or that if you need 1GB of contiguous memory that
> 999.996MB gets freed, but there is one stubborn page left.
> 
> alloc_contig_pages() can and will fail.  The only mitigation which is
> guaranteed to avoid this is doing the allocation at boot.  But, you're
> not doing that to avoid wasting memory on every TDX system that doesn't
> use TDX.
> 
> A *good* way (although not foolproof) is to launch a TDX VM early in
> boot before memory gets fragmented or consumed.  You might even want to
> recommend this in the documentation.

"launch a TDX VM early in boot" I suppose you mean having some boot-time service
which launches a TDX VM before we get the login interface.  I'll put this in the
documentation.

How about adding below in the changelog:

"
However using alloc_contig_pages() to allocate large physically contiguous
memory at runtime may fail.  The larger the allocation, the more likely it is to
fail.  Due to the fragmentation, the kernel may need to move pages out of the
to-be-allocated contiguous memory range but it may fail to move even the last
stubborn page.  A good way (although not foolproof) is to launch a TD VM early
in boot to get PAMTs allocated before memory gets fragmented or consumed.
"

> 
> > > > +/*
> > > > + * Locate the NUMA node containing the start of the given TDMR's first
> > > > + * RAM entry.  The given TDMR may also cover memory in other NUMA nodes.
> > > > + */
> > > 
> > > Please add a sentence or two on the implications here of what this means
> > > when it happens.  Also, the joining of e820 regions seems like it might
> > > span NUMA nodes.  What prevents that code from just creating one large
> > > e820 area that leads to one large TDMR and horrible NUMA affinity for
> > > these structures?
> > 
> > How about adding:
> > 
> > 	When TDMR is created, it stops spanning at NUAM boundary.
> 
> I actually don't know what that means at all.  I was thinking of
> something like this.
> 
> /*
>  * Pick a NUMA node on which to allocate this TDMR's metadata.
>  *
>  * This is imprecise since TDMRs are 1GB aligned and NUMA nodes might
>  * not be.  If the TDMR covers more than one node, just use the _first_
>  * one.  This can lead to small areas of off-node metadata for some
>  * memory.
>  */

Thanks.

> 
> > > > +static int tdmr_get_nid(struct tdmr_info *tdmr)
> > > > +{
> > > > +	u64 start, end;
> > > > +	int i;
> > > > +
> > > > +	/* Find the first RAM entry covered by the TDMR */
> 
> There's something else missing in here.  Why not just do:
> 
> 	return phys_to_target_node(TDMR_START(tdmr));
> 
> This would explain it:
> 
> 	/*
> 	 * The beginning of the TDMR might not point to RAM.
> 	 * Find its first RAM address which which its node can
> 	 * be found.
> 	 */

Will use this.  Thanks.

> 
> > > > +	e820_for_each_mem(i, start, end)
> > > > +		if (end > TDMR_START(tdmr))
> > > > +			break;
> > > 
> > > Brackets around the big loop, please.
> > 
> > OK.
> > 
> > > 
> > > > +	/*
> > > > +	 * One TDMR must cover at least one (or partial) RAM entry,
> > > > +	 * otherwise it is kernel bug.  WARN_ON() in this case.
> > > > +	 */
> > > > +	if (WARN_ON_ONCE((start >= end) || start >= TDMR_END(tdmr)))
> > > > +		return 0;
> 
> This really means "no RAM found for this TDMR", right?  Can we say that,
> please.

OK will add it.  How about:

	/*
	 * No RAM found for this TDMR.  WARN() in this case, as it
	 * cannot happen otherwise it is a kernel bug.
	 */

> 
> 
> > > > +	/*
> > > > +	 * Allocate one chunk of physically contiguous memory for all
> > > > +	 * PAMTs.  This helps minimize the PAMT's use of reserved areas
> > > > +	 * in overlapped TDMRs.
> > > > +	 */
> > > 
> > > Ahh, this explains it.  Considering that tdmr_get_pamt_sz() is really
> > > just two lines of code, I'd probably just the helper and open-code it
> > > here.  Then you only have one place to comment on it.
> > 
> > It has a loop and internally calls __tdmr_get_pamt_sz().  It looks doesn't fit
> > if we open-code it here.
> > 
> > How about move this comment to tdmr_get_pamt_sz()?
> 
> I thought about that.  But tdmr_get_pamt_sz() isn't itself doing any
> allocation so it doesn't make a whole lot of logical sense.  This is a
> place where a helper _can_ be removed.  Remove it, please.

OK.  Will remove the helper.  Thanks.

-- 
Thanks,
-Kai


