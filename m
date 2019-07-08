Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1527062739
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 19:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390943AbfGHRcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 13:32:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:56221 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfGHRcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 13:32:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 10:32:40 -0700
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="155925896"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 10:32:39 -0700
Message-ID: <6091d916590ffbacb9a641c6009bb1782d8ae615.camel@linux.intel.com>
Subject: Re: [PATCH v1 4/6] mm: Introduce "aerated" pages
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com
Date:   Mon, 08 Jul 2019 10:32:40 -0700
In-Reply-To: <a147b569-9f1b-a1be-e019-0059c654892d@intel.com>
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
         <20190619223323.1231.86906.stgit@localhost.localdomain>
         <a147b569-9f1b-a1be-e019-0059c654892d@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-06-25 at 12:45 -0700, Dave Hansen wrote:
> > +static inline void set_page_aerated(struct page *page,
> > +				    struct zone *zone,
> > +				    unsigned int order,
> > +				    int migratetype)
> > +{
> > +#ifdef CONFIG_AERATION
> > +	/* update areated page accounting */
> > +	zone->free_area[order].nr_free_aerated++;
> > +
> > +	/* record migratetype and flag page as aerated */
> > +	set_pcppage_migratetype(page, migratetype);
> > +	__SetPageAerated(page);
> > +#endif
> > +}
> 
> Please don't refer to code before you introduce it, even if you #ifdef
> it.  I went looking back in the series for the PageAerated() definition,
> but didn't think to look forward.

Yeah, I had split this code out from patch 5, but I realized after I
submitted it I had a number of issues. The kconfig option also ended up in
patch 5 instead of showing up in patch 4.

I'll have to work on cleaning up patches 4 and 5 so that the split between
them is cleaner.

> Also, it doesn't make any sense to me that you would need to set the
> migratetype here.  Isn't it set earlier in the allocator?  Also, when
> can this function be called?  There's obviously some locking in place
> because of the __Set, but what are they?

Generally this function is only called from inside __free_one_page so yes,
the zone lock is expected to be held.

> > +static inline void clear_page_aerated(struct page *page,
> > +				      struct zone *zone,
> > +				      struct free_area *area)
> > +{
> > +#ifdef CONFIG_AERATION
> > +	if (likely(!PageAerated(page)))
> > +		return;
> 
> Logically, why would you ever clear_page_aerated() on a page that's not
> aerated?  Comments needed.
> 
> BTW, I already hate typing aerated. :)

Well I am always open to other suggestions. I could just default to
offline which is what is used by the balloon drivers. Suggestions for a
better name are always welcome.

> > +	__ClearPageAerated(page);
> > +	area->nr_free_aerated--;
> > +#endif
> > +}
> 
> More non-atomic flag clears.  Still no comments.

Yes. it is the same kind of deal as the function above. Basically we only
call this just before we clear the buddy flag in the allocator so once
again the zone lock is expected to be held at this point.

> 
> > @@ -787,10 +790,10 @@ static inline void add_to_free_area(struct page *page, struct zone *zone,
> >  static inline void add_to_free_area_tail(struct page *page, struct zone *zone,
> >  					 unsigned int order, int migratetype)
> >  {
> > -	struct free_area *area = &zone->free_area[order];
> > +	struct list_head *tail = aerator_get_tail(zone, order, migratetype);
> 
> There is no logical change in this patch from this line.  That's
> unfortunate because I can't see the change in logic that's presumably
> coming.  You'll presumably change aerator_get_tail(), but then I'll have
> to remember that this line is here and come back to it from a later patch.
> 
> If it *doesn't* change behavior, it has no business being calle
> aerator_...().
> 
> This series seems rather suboptimal for reviewing.

I can move that into patch 5. That would make more sense anyway since that
is where I introduce the change that adds the boundaries.

> > -	list_add_tail(&page->lru, &area->free_list[migratetype]);
> > -	area->nr_free++;
> > +	list_add_tail(&page->lru, tail);
> > +	zone->free_area[order].nr_free++;
> >  }
> >  
> >  /* Used for pages which are on another list */
> > @@ -799,6 +802,8 @@ static inline void move_to_free_area(struct page *page, struct zone *zone,
> >  {
> >  	struct free_area *area = &zone->free_area[order];
> >  
> > +	clear_page_aerated(page, zone, area);
> > +
> >  	list_move(&page->lru, &area->free_list[migratetype]);
> >  }
> 
> It's not immediately clear to me why moving a page should clear
> aeration.  A comment would help make it clear.

I will do that. The main reason for having to do that is because when we
move the page there is no guarantee that the boundaries will still be in
place. As such we are pulling the page and placing it on the head of the
free_list we are moving it to. As such in order to avoid creating an
island of unprocessed pages we need to clear the flag and just reprocess
it later.

> > @@ -868,10 +869,11 @@ static inline struct capture_control *task_capc(struct zone *zone)
> >  static inline void __free_one_page(struct page *page,
> >  		unsigned long pfn,
> >  		struct zone *zone, unsigned int order,
> > -		int migratetype)
> > +		int migratetype, bool aerated)
> >  {
> >  	struct capture_control *capc = task_capc(zone);
> >  	unsigned long uninitialized_var(buddy_pfn);
> > +	bool fully_aerated = aerated;
> >  	unsigned long combined_pfn;
> >  	unsigned int max_order;
> >  	struct page *buddy;
> > @@ -902,6 +904,11 @@ static inline void __free_one_page(struct page *page,
> >  			goto done_merging;
> >  		if (!page_is_buddy(page, buddy, order))
> >  			goto done_merging;
> > +
> > +		/* assume buddy is not aerated */
> > +		if (aerated)
> > +			fully_aerated = false;
> 
> So, "full" vs. "partial" is with respect to high-order pages?  Why not
> just check the page flag on the buddy?

The buddy will never have the aerated flag set. If we are hinting on a
given page then the assumption is it was the highest order version of the
page available when we processed the pages in the previous pass. So if the
buddy is available when we are returning the processed page then the buddy
is non-aerated and will invalidate the aeration when merged with the
aerated page. What we will then do is hint on the higher-order page that
is created as a result of merging the two pages.

I'll make the comment more robust on that.

> >  		/*
> >  		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
> >  		 * merge with it and move up one order.
> > @@ -943,11 +950,17 @@ static inline void __free_one_page(struct page *page,
> >  done_merging:
> >  	set_page_order(page, order);
> >  
> > -	if (buddy_merge_likely(pfn, buddy_pfn, page, order) ||
> > +	if (aerated ||
> > +	    buddy_merge_likely(pfn, buddy_pfn, page, order) ||
> >  	    is_shuffle_tail_page(order))
> >  		add_to_free_area_tail(page, zone, order, migratetype);
> >  	else
> >  		add_to_free_area(page, zone, order, migratetype);
> 
> Aerated pages always go to the tail?  Ahh, so they don't get consumed
> quickly and have to be undone?  Comments, please.

Will do.

> > +	if (fully_aerated)
> > +		set_page_aerated(page, zone, order, migratetype);
> > +	else
> > +		aerator_notify_free(zone, order);
> >  }
> 
> What is this notifying for?  It's not like this is some opaque
> registration interface.  What does this *do*?

This is updating the count of non-treated pages and comparing that to the
high water mark. If it crosses a certain threshold it will then set the
bits requesting the zone be processed and wake up the thread if it is not
active.

> > @@ -2127,6 +2140,77 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
> >  	return NULL;
> >  }
> >  
> > +#ifdef CONFIG_AERATION
> > +/**
> > + * get_aeration_page - Provide a "raw" page for aeration by the aerator
> > + * @zone: Zone to draw pages from
> > + * @order: Order to draw pages from
> > + * @migratetype: Migratetype to draw pages from
> 
> FWIW, kerneldoc is a waste of bytes here.  Please use it sparingly.
> 
> > + * This function will obtain a page from above the boundary. As a result
> > + * we can guarantee the page has not been aerated.
> 
> This is the first mention of a boundary.  That's not good since I have
> no idea at this point what the boundary is for or between.

Boundary doesn't get added until the next patch so this is another foul up
with the splitting of the patches.

> 
> > + * The page will have the migrate type and order stored in the page
> > + * metadata.
> > + *
> > + * Return: page pointer if raw page found, otherwise NULL
> > + */
> > +struct page *get_aeration_page(struct zone *zone, unsigned int order,
> > +			       int migratetype)
> > +{
> > +	struct free_area *area = &(zone->free_area[order]);
> > +	struct list_head *list = &area->free_list[migratetype];
> > +	struct page *page;
> > +
> > +	/* Find a page of the appropriate size in the preferred list */
> 
> I don't get the size comment.  Hasn't this already been given an order?

That is a hold over from a previous version of this patch. Originally this
code was getting anything order or greater. Now it only grabs pages of a
certain order as I had pulled some logic out of here and moved it into the
aeration logic.

> > +	page = list_last_entry(aerator_get_tail(zone, order, migratetype),
> > +			       struct page, lru);
> > +	list_for_each_entry_from_reverse(page, list, lru) {
> > +		if (PageAerated(page)) {
> > +			page = list_first_entry(list, struct page, lru);
> > +			if (PageAerated(page))
> > +				break;
> > +		}
> 
> This confuses me.  It looks for a page, then goes to the next page and
> checks again?  Why check twice?  Why is a function looking for an
> aerated page that finds *two* pages returning NULL?
> 
> I'm stumped.

So the logic here gets confusing because the boundary hasn't been defined
yet. Specifically boundary ends up being a secondary tail that applies
only to the non-processed pages. What we are doing is getting the last
non-processed page, and then using the "from" version of the list iterator
to make certain that the list isn't actually empty.

From there we do a check to see if the page we are currently looking at is
empty. If it is we return NULL. If the list is not empty we check and see
if the page was processed, if it was we try grapping the page from the
head of the list as we hit the bottom of the last batch we processed. If
that is also processed then we just exit.

I will try to do a better job of documenting all this. Basically I used a
bunch of list manipulation that is hiding things too well.

> > +		del_page_from_free_area(page, zone, order);
> > +
> > +		/* record migratetype and order within page */
> > +		set_pcppage_migratetype(page, migratetype);
> > +		set_page_private(page, order);
> > +		__mod_zone_freepage_state(zone, -(1 << order), migratetype);
> > +
> > +		return page;
> > +	}
> > +
> > +	return NULL;
> > +}
> 
> Oh, so this is trying to find a page _for_ aerating.
> "get_aeration_page()" does not convey that.  Can that improved?
> get_page_for_aeration()?
> 
> Rather than talk about boundaries, wouldn't a better description have been:
> 
> 	Similar to allocation, this function removes a page from the
> 	free lists.  However, it only removes unaerated pages.

I will update the kerneldoc and comments.

> > +/**
> > + * put_aeration_page - Return a now-aerated "raw" page back where we got it
> > + * @zone: Zone to return pages to
> > + * @page: Previously "raw" page that can now be returned after aeration
> > + *
> > + * This function will pull the migratetype and order information out
> > + * of the page and attempt to return it where it found it.
> > + */
> > +void put_aeration_page(struct zone *zone, struct page *page)
> > +{
> > +	unsigned int order, mt;
> > +	unsigned long pfn;
> > +
> > +	mt = get_pcppage_migratetype(page);
> > +	pfn = page_to_pfn(page);
> > +
> > +	if (unlikely(has_isolate_pageblock(zone) || is_migrate_isolate(mt)))
> > +		mt = get_pfnblock_migratetype(page, pfn);
> > +
> > +	order = page_private(page);
> > +	set_page_private(page, 0);
> > +
> > +	__free_one_page(page, pfn, zone, order, mt, true);
> > +}
> > +#endif /* CONFIG_AERATION */
> 
> Yikes.  This seems to have glossed over some pretty big aspects here.
> Pages which are being aerated are not free.  Pages which are freed are
> diverted to be aerated before becoming free.  Right?  That sounds like
> two really important things to add to a changelog.

Right. The aerated pages are not free. The go into the free_list and once
enough pages are in there the aerator will start pulling some out and
processing them. The idea is that any pages not being actively aerated
will stay in the free_list so it isn't as if we are shunting them off to a
side-queue. They are just sitting in the free_list either to be reused or
aerated.

I'll make some updates to the changelog to clarify that.

> >  /*
> >   * This array describes the order lists are fallen back to when
> >   * the free lists for the desirable migrate type are depleted
> > @@ -5929,9 +6013,12 @@ void __ref memmap_init_zone_device(struct zone *zone,
> >  static void __meminit zone_init_free_lists(struct zone *zone)
> >  {
> >  	unsigned int order, t;
> > -	for_each_migratetype_order(order, t) {
> > +	for_each_migratetype_order(order, t)
> >  		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
> > +
> > +	for (order = MAX_ORDER; order--; ) {
> >  		zone->free_area[order].nr_free = 0;
> > +		zone->free_area[order].nr_free_aerated = 0;
> >  	}
> >  }
> >  
> > 


