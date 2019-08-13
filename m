Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654668BFB1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 19:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfHMRfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 13:35:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:45845 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbfHMRfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 13:35:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 10:35:32 -0700
X-IronPort-AV: E=Sophos;i="5.64,382,1559545200"; 
   d="scan'208";a="170466575"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 10:35:32 -0700
Message-ID: <712cc03ea69fcd59080291b5832adddf39d20cd3.camel@linux.intel.com>
Subject: Re: [PATCH v5 4/6] mm: Introduce Reported pages
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com
Date:   Tue, 13 Aug 2019 10:35:32 -0700
In-Reply-To: <222cbe8f-90c5-5437-4a77-9926cacc398f@redhat.com>
References: <20190812213158.22097.30576.stgit@localhost.localdomain>
         <20190812213344.22097.86213.stgit@localhost.localdomain>
         <222cbe8f-90c5-5437-4a77-9926cacc398f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-08-13 at 10:07 +0200, David Hildenbrand wrote:
> On 12.08.19 23:33, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > In order to pave the way for free page reporting in virtualized
> > environments we will need a way to get pages out of the free lists and
> > identify those pages after they have been returned. To accomplish this,
> > this patch adds the concept of a Reported Buddy, which is essentially
> > meant to just be the Uptodate flag used in conjunction with the Buddy
> > page type.
> > 
> > It adds a set of pointers we shall call "boundary" which represents the
> > upper boundary between the unreported and reported pages. The general idea
> > is that in order for a page to cross from one side of the boundary to the
> > other it will need to go through the reporting process. Ultimately a
> > free_list has been fully processed when the boundary has been moved from
> > the tail all they way up to occupying the first entry in the list.
> > 
> > Doing this we should be able to make certain that we keep the reported
> > pages as one contiguous block in each free list. This will allow us to
> > efficiently manipulate the free lists whenever we need to go in and start
> > sending reports to the hypervisor that there are new pages that have been
> > freed and are no longer in use.
> > 
> > An added advantage to this approach is that we should be reducing the
> > overall memory footprint of the guest as it will be more likely to recycle
> > warm pages versus trying to allocate the reported pages that were likely
> > evicted from the guest memory.
> > 
> > Since we will only be reporting one zone at a time we keep the boundary
> > limited to being defined for just the zone we are currently reporting pages
> > from. Doing this we can keep the number of additional pointers needed quite
> > small. To flag that the boundaries are in place we use a single bit
> > in the zone to indicate that reporting and the boundaries are active.
> > 
> > The determination of when to start reporting is based on the tracking of
> > the number of free pages in a given area versus the number of reported
> > pages in that area. We keep track of the number of reported pages per
> > free_area in a separate zone specific area. We do this to avoid modifying
> > the free_area structure as this can lead to false sharing for the highest
> > order with the zone lock which leads to a noticeable performance
> > degradation.
> > 
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  include/linux/mmzone.h         |   40 +++++
> >  include/linux/page-flags.h     |   11 +
> >  include/linux/page_reporting.h |  138 ++++++++++++++++++
> >  mm/Kconfig                     |    5 +
> >  mm/Makefile                    |    1 
> >  mm/memory_hotplug.c            |    1 
> >  mm/page_alloc.c                |  136 +++++++++++++++++-
> >  mm/page_reporting.c            |  308 ++++++++++++++++++++++++++++++++++++++++
> >  8 files changed, 632 insertions(+), 8 deletions(-)
> >  create mode 100644 include/linux/page_reporting.h
> >  create mode 100644 mm/page_reporting.c
> > 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 2f2b6f968ed3..b8ed926552b1 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -462,6 +462,14 @@ struct zone {
> >  	seqlock_t		span_seqlock;
> >  #endif
> >  
> > +#ifdef CONFIG_PAGE_REPORTING
> > +	/*
> > +	 * Pointer to reported page tracking statistics array. The size of
> > +	 * the array is MAX_ORDER - PAGE_REPORTING_MIN_ORDER. NULL when
> > +	 * unused page reporting is not present.
> > +	 */
> > +	unsigned long		*reported_pages;
> > +#endif
> >  	int initialized;
> >  
> >  	/* Write-intensive fields used from the page allocator */
> > @@ -537,6 +545,14 @@ enum zone_flags {
> >  	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
> >  					 * Cleared when kswapd is woken.
> >  					 */
> > +	ZONE_PAGE_REPORTING_REQUESTED,	/* zone enabled page reporting and has
> > +					 * requested flushing the data out of
> > +					 * higher order pages.
> > +					 */
> > +	ZONE_PAGE_REPORTING_ACTIVE,	/* zone enabled page reporting and is
> > +					 * activly flushing the data out of
> > +					 * higher order pages.
> > +					 */
> >  };
> >  
> >  static inline unsigned long zone_managed_pages(struct zone *zone)
> > @@ -757,6 +773,8 @@ static inline bool pgdat_is_empty(pg_data_t *pgdat)
> >  	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
> >  }
> >  
> > +#include <linux/page_reporting.h>
> > +
> >  /* Used for pages not on another list */
> >  static inline void add_to_free_list(struct page *page, struct zone *zone,
> >  				    unsigned int order, int migratetype)
> > @@ -771,10 +789,16 @@ static inline void add_to_free_list(struct page *page, struct zone *zone,
> >  static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
> >  					 unsigned int order, int migratetype)
> >  {
> > -	struct free_area *area = &zone->free_area[order];
> > +	struct list_head *tail = get_unreported_tail(zone, order, migratetype);
> >  
> > -	list_add_tail(&page->lru, &area->free_list[migratetype]);
> > -	area->nr_free++;
> > +	/*
> > +	 * To prevent the unreported pages from being interleaved with the
> > +	 * reported ones while we are actively processing pages we will use
> > +	 * the head of the reported pages to determine the tail of the free
> > +	 * list.
> > +	 */
> > +	list_add_tail(&page->lru, tail);
> > +	zone->free_area[order].nr_free++;
> >  }
> >  
> >  /* Used for pages which are on another list */
> > @@ -783,12 +807,22 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
> >  {
> >  	struct free_area *area = &zone->free_area[order];
> >  
> > +	/*
> > +	 * Clear Hinted flag, if present, to avoid placing reported pages
> > +	 * at the top of the free_list. It is cheaper to just process this
> > +	 * page again than to walk around a page that is already reported.
> > +	 */
> > +	clear_page_reported(page, zone);
> > +
> >  	list_move(&page->lru, &area->free_list[migratetype]);
> >  }
> >  
> >  static inline void del_page_from_free_list(struct page *page, struct zone *zone,
> >  					   unsigned int order)
> >  {
> > +	/* Clear Reported flag, if present, before resetting page type */
> > +	clear_page_reported(page, zone);
> > +
> >  	list_del(&page->lru);
> >  	__ClearPageBuddy(page);
> >  	set_page_private(page, 0);
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index f91cb8898ff0..759a3b3956f2 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -163,6 +163,9 @@ enum pageflags {
> >  
> >  	/* non-lru isolated movable page */
> >  	PG_isolated = PG_reclaim,
> > +
> > +	/* Buddy pages. Used to track which pages have been reported */
> > +	PG_reported = PG_uptodate,
> >  };
> >  
> >  #ifndef __GENERATING_BOUNDS_H
> > @@ -432,6 +435,14 @@ static inline bool set_hwpoison_free_buddy_page(struct page *page)
> >  #endif
> >  
> >  /*
> > + * PageReported() is used to track reported free pages within the Buddy
> > + * allocator. We can use the non-atomic version of the test and set
> > + * operations as both should be shielded with the zone lock to prevent
> > + * any possible races on the setting or clearing of the bit.
> > + */
> > +__PAGEFLAG(Reported, reported, PF_NO_COMPOUND)
> > +
> > +/*
> >   * On an anonymous page mapped into a user virtual memory area,
> >   * page->mapping points to its anon_vma, not to a struct address_space;
> >   * with the PAGE_MAPPING_ANON bit set to distinguish it.  See rmap.h.
> > diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
> > new file mode 100644
> > index 000000000000..498bde6ea764
> > --- /dev/null
> > +++ b/include/linux/page_reporting.h
> > @@ -0,0 +1,138 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _LINUX_PAGE_REPORTING_H
> > +#define _LINUX_PAGE_REPORTING_H
> > +
> > +#include <linux/mmzone.h>
> > +#include <linux/jump_label.h>
> > +#include <linux/pageblock-flags.h>
> > +#include <asm/pgtable_types.h>
> > +
> > +#define PAGE_REPORTING_MIN_ORDER	pageblock_order
> > +#define PAGE_REPORTING_HWM		32
> > +
> > +#ifdef CONFIG_PAGE_REPORTING
> > +struct page_reporting_dev_info {
> > +	/* function that alters pages to make them "reported" */
> > +	void (*report)(struct page_reporting_dev_info *phdev,
> > +		       unsigned int nents);
> > +
> > +	/* scatterlist containing pages to be processed */
> > +	struct scatterlist *sg;
> > +
> > +	/*
> > +	 * Upper limit on the number of pages that the react function
> > +	 * expects to be placed into the batch list to be processed.
> > +	 */
> > +	unsigned long capacity;
> > +
> > +	/* work struct for processing reports */
> > +	struct delayed_work work;
> > +
> > +	/*
> > +	 * The number of zones requesting reporting, plus one additional if
> > +	 * processing thread is active.
> > +	 */
> > +	atomic_t refcnt;
> > +};
> > +
> > +extern struct static_key page_reporting_notify_enabled;
> > +
> > +/* Boundary functions */
> > +struct list_head *__page_reporting_get_boundary(unsigned int order,
> > +						int migratetype);
> > +void page_reporting_del_from_boundary(struct page *page, struct zone *zone);
> > +void page_reporting_add_to_boundary(struct page *page, struct zone *zone,
> > +				    int migratetype);
> > +
> > +/* Hinted page accessors, defined in page_alloc.c */
> > +struct page *get_unreported_page(struct zone *zone, unsigned int order,
> > +				 int migratetype);
> > +void put_reported_page(struct zone *zone, struct page *page);
> > +
> > +void __page_reporting_request(struct zone *zone);
> > +void __page_reporting_free_stats(struct zone *zone);
> > +
> > +/* Tear-down and bring-up for page reporting devices */
> > +void page_reporting_shutdown(struct page_reporting_dev_info *phdev);
> > +int page_reporting_startup(struct page_reporting_dev_info *phdev);
> > +#endif /* CONFIG_PAGE_REPORTING */
> > +
> > +static inline struct list_head *
> > +get_unreported_tail(struct zone *zone, unsigned int order, int migratetype)
> > +{
> > +#ifdef CONFIG_PAGE_REPORTING
> > +	if (order >= PAGE_REPORTING_MIN_ORDER &&
> > +	    test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
> > +		return __page_reporting_get_boundary(order, migratetype);
> > +#endif
> > +	return &zone->free_area[order].free_list[migratetype];
> > +}
> > +
> > +static inline void clear_page_reported(struct page *page,
> > +				     struct zone *zone)
> > +{
> > +#ifdef CONFIG_PAGE_REPORTING
> > +	if (likely(!PageReported(page)))
> > +		return;
> > +
> > +	/* push boundary back if we removed the upper boundary */
> > +	if (test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
> > +		page_reporting_del_from_boundary(page, zone);
> > +
> > +	__ClearPageReported(page);
> > +
> > +	/* page_private will contain the page order, so just use it directly */
> > +	zone->reported_pages[page_private(page) - PAGE_REPORTING_MIN_ORDER]--;
> > +#endif
> > +}
> > +
> > +/* Free reported_pages and reset reported page tracking count to 0 */
> > +static inline void page_reporting_reset(struct zone *zone)
> > +{
> > +#ifdef CONFIG_PAGE_REPORTING
> > +	if (zone->reported_pages)
> > +		__page_reporting_free_stats(zone);
> > +#endif
> > +}
> > +
> > +/**
> > + * page_reporting_notify_free - Free page notification to start page processing
> > + * @zone: Pointer to current zone of last page processed
> > + * @order: Order of last page added to zone
> > + *
> > + * This function is meant to act as a screener for __page_reporting_request
> > + * which will determine if a give zone has crossed over the high-water mark
> > + * that will justify us beginning page treatment. If we have crossed that
> > + * threshold then it will start the process of pulling some pages and
> > + * placing them in the batch list for treatment.
> > + */
> > +static inline void page_reporting_notify_free(struct zone *zone, int order)
> > +{
> > +#ifdef CONFIG_PAGE_REPORTING
> > +	unsigned long nr_reported;
> > +
> > +	/* Called from hot path in __free_one_page() */
> > +	if (!static_key_false(&page_reporting_notify_enabled))
> > +		return;
> > +
> > +	/* Limit notifications only to higher order pages */
> > +	if (order < PAGE_REPORTING_MIN_ORDER)
> > +		return;
> > +
> > +	/* Do not bother with tests if we have already requested reporting */
> > +	if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
> > +		return;
> > +
> > +	/* If reported_pages is not populated, assume 0 */
> > +	nr_reported = zone->reported_pages ?
> > +		    zone->reported_pages[order - PAGE_REPORTING_MIN_ORDER] : 0;
> > +
> > +	/* Only request it if we have enough to begin the page reporting */
> > +	if (zone->free_area[order].nr_free < nr_reported + PAGE_REPORTING_HWM)
> > +		return;
> > +
> > +	/* This is slow, but should be called very rarely */
> > +	__page_reporting_request(zone);
> > +#endif
> > +}
> > +#endif /*_LINUX_PAGE_REPORTING_H */
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 1c9698509273..daa8c45e2af4 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -237,6 +237,11 @@ config COMPACTION
> >            linux-mm@kvack.org.
> >  
> >  #
> > +# support for unused page reporting
> > +config PAGE_REPORTING
> > +	bool
> > +
> > +#
> >  # support for page migration
> >  #
> >  config MIGRATION
> > diff --git a/mm/Makefile b/mm/Makefile
> > index d0b295c3b764..1e17ba0ed2f0 100644
> > --- a/mm/Makefile
> > +++ b/mm/Makefile
> > @@ -105,3 +105,4 @@ obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
> >  obj-$(CONFIG_ZONE_DEVICE) += memremap.o
> >  obj-$(CONFIG_HMM_MIRROR) += hmm.o
> >  obj-$(CONFIG_MEMFD_CREATE) += memfd.o
> > +obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index 5b8811945bbb..bd40beac293b 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -1612,6 +1612,7 @@ static int __ref __offline_pages(unsigned long start_pfn,
> >  	if (!populated_zone(zone)) {
> >  		zone_pcp_reset(zone);
> >  		build_all_zonelists(NULL);
> > +		page_reporting_reset(zone);
> >  	} else
> >  		zone_pcp_update(zone);
> >  
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 4b5812c3800e..d0d3fb12ba54 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -68,6 +68,7 @@
> >  #include <linux/lockdep.h>
> >  #include <linux/nmi.h>
> >  #include <linux/psi.h>
> > +#include <linux/page_reporting.h>
> >  
> >  #include <asm/sections.h>
> >  #include <asm/tlbflush.h>
> > @@ -915,7 +916,7 @@ static inline struct capture_control *task_capc(struct zone *zone)
> >  static inline void __free_one_page(struct page *page,
> >  		unsigned long pfn,
> >  		struct zone *zone, unsigned int order,
> > -		int migratetype)
> > +		int migratetype, bool reported)
> >  {
> >  	struct capture_control *capc = task_capc(zone);
> >  	unsigned long uninitialized_var(buddy_pfn);
> > @@ -990,11 +991,20 @@ static inline void __free_one_page(struct page *page,
> >  done_merging:
> >  	set_page_order(page, order);
> >  
> > -	if (is_shuffle_order(order) ? shuffle_add_to_tail() :
> > -	    buddy_merge_likely(pfn, buddy_pfn, page, order))
> > +	if (reported ||
> > +	    (is_shuffle_order(order) ? shuffle_add_to_tail() :
> > +	     buddy_merge_likely(pfn, buddy_pfn, page, order)))
> >  		add_to_free_list_tail(page, zone, order, migratetype);
> >  	else
> >  		add_to_free_list(page, zone, order, migratetype);
> > +
> > +	/*
> > +	 * No need to notify on a reported page as the total count of
> > +	 * unreported pages will not have increased since we have essentially
> > +	 * merged the reported page with one or more unreported pages.
> > +	 */
> > +	if (!reported)
> > +		page_reporting_notify_free(zone, order);
> >  }
> >  
> >  /*
> > @@ -1305,7 +1315,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> >  		if (unlikely(isolated_pageblocks))
> >  			mt = get_pageblock_migratetype(page);
> >  
> > -		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
> > +		__free_one_page(page, page_to_pfn(page), zone, 0, mt, false);
> >  		trace_mm_page_pcpu_drain(page, 0, mt);
> >  	}
> >  	spin_unlock(&zone->lock);
> > @@ -1321,7 +1331,7 @@ static void free_one_page(struct zone *zone,
> >  		is_migrate_isolate(migratetype))) {
> >  		migratetype = get_pfnblock_migratetype(page, pfn);
> >  	}
> > -	__free_one_page(page, pfn, zone, order, migratetype);
> > +	__free_one_page(page, pfn, zone, order, migratetype, false);
> >  	spin_unlock(&zone->lock);
> >  }
> >  
> > @@ -2183,6 +2193,122 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
> >  	return NULL;
> >  }
> >  
> > +#ifdef CONFIG_PAGE_REPORTING
> > +/**
> > + * get_unreported_page - Pull an unreported page from the free_list
> > + * @zone: Zone to draw pages from
> > + * @order: Order to draw pages from
> > + * @mt: Migratetype to draw pages from
> > + *
> > + * This function will obtain a page from the free list. It will start by
> > + * attempting to pull from the tail of the free list and if that is already
> > + * reported on it will instead pull the head if that is unreported.
> > + *
> > + * The page will have the migrate type and order stored in the page
> > + * metadata. While being processed the page will not be avaialble for
> > + * allocation.
> > + *
> > + * Return: page pointer if raw page found, otherwise NULL
> > + */
> > +struct page *get_unreported_page(struct zone *zone, unsigned int order, int mt)
> > +{
> > +	struct list_head *tail = get_unreported_tail(zone, order, mt);
> > +	struct free_area *area = &(zone->free_area[order]);
> > +	struct list_head *list = &area->free_list[mt];
> > +	struct page *page;
> > +
> > +	/* zone lock should be held when this function is called */
> > +	lockdep_assert_held(&zone->lock);
> > +
> > +	/* Find a page of the appropriate size in the preferred list */
> > +	page = list_last_entry(tail, struct page, lru);
> > +	list_for_each_entry_from_reverse(page, list, lru) {
> > +		/* If we entered this loop then the "raw" list isn't empty */
> > +
> > +		/* If the page is reported try the head of the list */
> > +		if (PageReported(page)) {
> > +			page = list_first_entry(list, struct page, lru);
> > +
> > +			/*
> > +			 * If both the head and tail are reported then reset
> > +			 * the boundary so that we read as an empty list
> > +			 * next time and bail out.
> > +			 */
> > +			if (PageReported(page)) {
> > +				page_reporting_add_to_boundary(page, zone, mt);
> > +				break;
> > +			}
> > +		}
> > +
> > +		del_page_from_free_list(page, zone, order);
> > +
> > +		/* record migratetype and order within page */
> > +		set_pcppage_migratetype(page, mt);
> > +		set_page_private(page, order);
> 
> Can you elaborate why you (similar to Nitesh) have to save/restore the
> migratetype? I can't yet follow why that is necessary. You could simply
> set it to MOVABLE (like e.g., undo_isolate_page_range() would do via
> alloc_contig_range()). If a pageblock is completely free, it might even
> make sense to set it to MOVABLE.
> 
> (mainly wondering if this is required here and what the rational is)

It was mostly a "put it back where I found it" type of logic. I suppose I
could probably just come back and read the migratetype out of the pfnblock
and return it there. Is that what you are thinking? If so I can probably
look at doing that instead, assuming there are no issues with that.

> Now a theoretical issue:
> 
> You are allocating pages from all zones, including the MOVABLE zone. The
> pages are currently unmovable (however, only temporarily allocated).

In my mind they aren't in too different of a state from pages that have
had their reference count dropped to 0 by something like __free_pages, but
haven't yet reached the function __free_pages_ok.

The general idea is that they should be in this state for a very short-
lived period of time. They are essentially free pages that just haven't
made it back into the buddy allocator.

> del_page_from_free_area() will clear PG_buddy, and leave the refcount of
> the page set to zero (!). has_unmovable_pages() will skip any pages
> either on the MOVABLE zone or with a refcount of zero. So all pages that
> are being reported are detected as movable. The isolation of allocated
> pages will work - which is not bad, but I wonder what the implications are.

So as per my comment above I am fairly certain this isn't a new state that
my code has introduced. In fact isolate_movable_page() calls out the case
in the comments at the start of the function. Specifically it states:
        /*
         * Avoid burning cycles with pages that are yet under __free_pages(),
         * or just got freed under us.
         *
         * In case we 'win' a race for a movable page being freed under us and
         * raise its refcount preventing __free_pages() from doing its job
         * the put_page() at the end of this block will take care of
         * release this page, thus avoiding a nasty leakage.
         */
        if (unlikely(!get_page_unless_zero(page)))
                goto out;

So it would seem like this case is already handled. I am assuming the fact
that the migrate type for the pfnblock was set to isolate before we got
here would mean that when I call put_reported_page the final result will
be that the page is placed into the freelist for the isolate migratetype.

> As far as I can follow, alloc_contig_range() ->
> __alloc_contig_migrate_range() -> isolate_migratepages_range() ->
> isolate_migratepages_block() will choke on these pages ((!PageLRU(page)
> -> !__PageMovable(page) -> fail), essentially making
> alloc_contig_range() range fail. Same could apply to offline_pages().
> 
> I would have thought that there has to be something like a
> reported_pages_drain_all(), that waits until all reports are over (or
> even signals to the hypervisor to abort reporting). As the pages are
> isolated, they won't be allocated for reporting again.

The thing is I only have 16 pages at most sitting in the scatterlist. In
most cases the response should be quick enough that by the time I could
make a request to abort reporting it would have likely already completed.

Also, unless there is already a ton of memory churn then we probably
wouldn't need to worry about page reporting really causing too much of an
issue. Specifically the way I structured the logic was that we only pull
out up to 16 pages at a time. What should happen is that we will continue
to build a list of "reported" pages in the free_list until we start
bumping up against the allocator, in that case the allocator should start
pulling reported pages and we will stop reporting with hopefully enough
"reported" pages built up that it can allocate out of those until the last
16 or fewer reported pages are returned to the free_list.

> I have not yet understood completely the way all the details work. I am
> currently looking into using alloc_contig_range() in a different
> context, which would co-exist with free-page-reporting.

I am pretty sure the two can "play well" together, even in their current
form. One thing I could look at doing would be to skip a page if the
migratetype of the pfnblock indicates that it is an isolate block. I would
essentially have to pull it out of the free_list I am working with and
drop it into the MIGRATE_ISOLATE freelist.

