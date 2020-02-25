Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA9216F15D
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 22:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgBYVqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 16:46:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:14112 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgBYVqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 16:46:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 13:46:19 -0800
X-IronPort-AV: E=Sophos;i="5.70,485,1574150400"; 
   d="scan'208";a="231166812"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 13:46:19 -0800
Message-ID: <3d719897039273a2bb8d0fe7d12563498ebd2897.camel@linux.intel.com>
Subject: Re: [PATCH RFC v4 06/13] mm: Allow to offline unmovable
 PageOffline() pages via MEM_GOING_OFFLINE
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Qian Cai <cai@lca.pw>, Pingfan Liu <kernelfans@gmail.com>
Date:   Tue, 25 Feb 2020 13:46:18 -0800
In-Reply-To: <267ea186-aba8-1a93-bd55-ac641f78d07e@redhat.com>
References: <20191212171137.13872-1-david@redhat.com>
         <20191212171137.13872-7-david@redhat.com>
         <6ec496580ddcb629d22589a1cba8cd61cbd53206.camel@linux.intel.com>
         <267ea186-aba8-1a93-bd55-ac641f78d07e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-02-25 at 19:49 +0100, David Hildenbrand wrote:
> > >  /*
> > >   * Scan pfn range [start,end) to find movable/migratable pages (LRU pages,
> > > - * non-lru movable pages and hugepages). We scan pfn because it's much
> > > - * easier than scanning over linked list. This function returns the pfn
> > > - * of the first found movable page if it's found, otherwise 0.
> > > + * non-lru movable pages and hugepages).
> > > + *
> > > + * Returns:
> > > + *	0 in case a movable page is found and movable_pfn was updated.
> > > + *	-ENOENT in case no movable page was found.
> > > + *	-EBUSY in case a definetly unmovable page was found.
> > >   */
> > > -static unsigned long scan_movable_pages(unsigned long start, unsigned long end)
> > > +static int scan_movable_pages(unsigned long start, unsigned long end,
> > > +			      unsigned long *movable_pfn)
> > >  {
> > >  	unsigned long pfn;
> > >  
> > > @@ -1247,18 +1251,29 @@ static unsigned long scan_movable_pages(unsigned long start, unsigned long end)
> > >  			continue;
> > >  		page = pfn_to_page(pfn);
> > >  		if (PageLRU(page))
> > > -			return pfn;
> > > +			goto found;
> > >  		if (__PageMovable(page))
> > > -			return pfn;
> > > +			goto found;
> > > +
> > > +		/*
> > > +		 * Unmovable PageOffline() pages where somebody still holds
> > > +		 * a reference count (after MEM_GOING_OFFLINE) can definetly
> > > +		 * not be offlined.
> > > +		 */
> > > +		if (PageOffline(page) && page_count(page))
> > > +			return -EBUSY;
> > 
> > So the comment confused me a bit because technically this function isn't
> > about offlining memory, it is about finding movable pages. I had to do a
> > bit of digging to find the only consumer is __offline_pages, but if we are
> > going to talk about "offlining" instead of "moving" in this function it
> > might make sense to rename it.
> 
> Well, it's contained in memory_hotplug.c, and the only user of moving
> pages around in there is offlining code :) And it's job is to locate
> movable pages, skip over some (temporary? unmovable ones) and (now)
> indicate definitely unmovable ones.
> 
> Any idea for a better name?
> scan_movable_pages_and_stop_on_definitely_unmovable() is not so nice :)

I dunno. What I was getting at is that the wording here would make it
clearer if you simply stated that these pages "can definately not be
moved". Saying you cannot offline a page that is PageOffline seems kind of
redundant, then again calling it an Unmovable and then saying it cannot be
moves is also redundant I suppose. In the end you don't move them, but
they can be switched to offline if the page count hits 0. When that
happens you simply end up skipping over them in the code for
__test_page_isolated_in_pageblock and __offline_isolated_pages.

> > >  
> > >  		if (!PageHuge(page))
> > >  			continue;
> > >  		head = compound_head(page);
> > >  		if (page_huge_active(head))
> > > -			return pfn;
> > > +			goto found;
> > >  		skip = compound_nr(head) - (page - head);
> > >  		pfn += skip - 1;
> > >  	}
> > > +	return -ENOENT;
> > > +found:
> > > +	*movable_pfn = pfn;
> > >  	return 0;
> > >  }
> > 
> > So I am looking at this function and it seems like your change completely
> > changes the behavior. The code before would walk the entire range and if
> > at least 1 page was available to move you would return the PFN of that
> > page. Now what seems to happen is that you will return -EBUSY as soon as
> > you encounter an offline page with a page count. I would think that would
> > slow down the offlining process since you have made the Unmovable
> > PageOffline() page a head of line blocker that you have to wait to get
> > around.
> 
> So, the comment says "Unmovable PageOffline() pages where somebody still
> holds a reference count (after MEM_GOING_OFFLINE) can definitely not be
> offlined". And the doc "-EBUSY in case a definitely unmovable page was
> found."
> 
> So why would this make offlining slow? Offlining will be aborted,
> because offlining is not possible.

Okay, my reading of the code was a bit off. In my mind I was thinking you
were effectively treating it almost like an EAGAIN and continuing the
loop. I didn't catch the part where you had rewritten the for loop as a
do-while in __offline_pages.

> Please note that this is the exact old behavior, where isolating the
> page range would have failed directly and offlining would have been
> aborted early. The old offlining failure in the case in the offlining
> path would have been "failure to isolate range".
> 
> Also, note that the users of PageOffline() with unmovable pages are very
> rare (only balloon drivers for now).
> 
> > Would it perhaps make more sense to add a return value initialized to
> > ENOENT, and if you encounter one of these offline pages you change the
> > return value to EBUSY, and then if you walk through the entire list
> > without finding a movable page you just return the value?
> 
> Did you have a look in  which context this function is used, especially
> [1] and [2]?
> 
> > Otherwise you might want to add a comment explaining why the function
> > should stall instead of skipping over the unmovable section that will
> > hopefully become movable later.
> 
> So we have "-EBUSY in case a definitely unmovable page was found.". Do
> you have a better suggestion?
> 
> > > @@ -1528,7 +1543,8 @@ static int __ref __offline_pages(unsigned long start_pfn,
> > >  	}
> > >  
> > >  	do {
> > > -		for (pfn = start_pfn; pfn;) {
> > > +		pfn = start_pfn;
> > > +		do {
> > >  			if (signal_pending(current)) {
> > >  				ret = -EINTR;
> > >  				reason = "signal backoff";
> > > @@ -1538,14 +1554,19 @@ static int __ref __offline_pages(unsigned long start_pfn,
> > >  			cond_resched();
> > >  			lru_add_drain_all();
> > >  
> > > -			pfn = scan_movable_pages(pfn, end_pfn);
> > > -			if (pfn) {
> > > +			ret = scan_movable_pages(pfn, end_pfn, &pfn);
> > > +			if (!ret) {
> > >  				/*
> > >  				 * TODO: fatal migration failures should bail
> > >  				 * out
> > >  				 */
> > >  				do_migrate_range(pfn, end_pfn);
> > >  			}
> 
> [1] we detect a definite offlining blocker and
> 
> > > +		} while (!ret);
> > > +
> > > +		if (ret != -ENOENT) {
> > > +			reason = "unmovable page";
> 
> [2] we abort offlining
> 
> > > +			goto failed_removal_isolated;
> > >  		}
> > >  
> > >  		/*

Yeah, this is the piece I misread.  I knew the loop this was in previously
was looping when returning -ENOENT so for some reason I had it in my head
that you were still looping on -EBUSY.

So the one question I would have is if at this point are we guaranteed
that the balloon drivers have already taken care of the page count for all
the pages they set to PageOffline? Based on the patch description I was
thinking that this was going to be looping for a while waiting for the
driver to clear the pages and then walking through them at the end of the
loop via check_pages_isolated_cb.

> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 5334decc9e06..840c0bbe2d9f 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -8256,6 +8256,19 @@ bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
> > >  		if ((flags & MEMORY_OFFLINE) && PageHWPoison(page))
> > >  			continue;
> > >  
> > > +		/*
> > > +		 * We treat all PageOffline() pages as movable when offlining
> > > +		 * to give drivers a chance to decrement their reference count
> > > +		 * in MEM_GOING_OFFLINE in order to signalize that these pages
> > 
> > You can probably just use "signal" or "indicate" instead of "signalize".
> 
> Makes sense, "indicate" it is!
> 
> Thanks!
> 

No problem.

