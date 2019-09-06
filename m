Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5925AB567
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 12:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390594AbfIFKI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 06:08:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390102AbfIFKI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 06:08:27 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 339673082137;
        Fri,  6 Sep 2019 10:08:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1ACD1600C4;
        Fri,  6 Sep 2019 10:08:26 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id D4D10180085A;
        Fri,  6 Sep 2019 10:08:25 +0000 (UTC)
Date:   Fri, 6 Sep 2019 06:08:25 -0400 (EDT)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de,
        yang zhang wz <yang.zhang.wz@gmail.com>, riel@surriel.com,
        konrad wilk <konrad.wilk@oracle.com>, lcapitulino@redhat.com,
        wei w wang <wei.w.wang@intel.com>, aarcange@redhat.com,
        pbonzini@redhat.com, dan j williams <dan.j.williams@intel.com>,
        alexander h duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <176802096.13025056.1567764505728.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190904151043.13848.23471.stgit@localhost.localdomain>
References: <20190904150920.13848.32271.stgit@localhost.localdomain> <20190904151043.13848.23471.stgit@localhost.localdomain>
Subject: Re: [PATCH v7 3/6] mm: Use zone and order instead of free area in
 free_list manipulators
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.116.154, 10.4.195.26]
Thread-Topic: Use zone and order instead of free area in free_list manipulators
Thread-Index: Ifoqo6WER9W4vKJ4aodTxvDJIDrFow==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 06 Sep 2019 10:08:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> 
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> In order to enable the use of the zone from the list manipulator functions
> I will need access to the zone pointer. As it turns out most of the
> accessors were always just being directly passed &zone->free_area[order]
> anyway so it would make sense to just fold that into the function itself
> and pass the zone and order as arguments instead of the free area.
> 
> In order to be able to reference the zone we need to move the declaration
> of the functions down so that we have the zone defined before we define the
> list manipulation functions.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  include/linux/mmzone.h |   70
>  ++++++++++++++++++++++++++----------------------
>  mm/page_alloc.c        |   30 ++++++++-------------
>  2 files changed, 49 insertions(+), 51 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 125f300981c6..2ddf1f1971c0 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -100,29 +100,6 @@ struct free_area {
>  	unsigned long		nr_free;
>  };
>  
> -/* Used for pages not on another list */
> -static inline void add_to_free_area(struct page *page, struct free_area
> *area,
> -			     int migratetype)
> -{
> -	list_add(&page->lru, &area->free_list[migratetype]);
> -	area->nr_free++;
> -}
> -
> -/* Used for pages not on another list */
> -static inline void add_to_free_area_tail(struct page *page, struct free_area
> *area,
> -				  int migratetype)
> -{
> -	list_add_tail(&page->lru, &area->free_list[migratetype]);
> -	area->nr_free++;
> -}
> -
> -/* Used for pages which are on another list */
> -static inline void move_to_free_area(struct page *page, struct free_area
> *area,
> -			     int migratetype)
> -{
> -	list_move(&page->lru, &area->free_list[migratetype]);
> -}
> -
>  static inline struct page *get_page_from_free_area(struct free_area *area,
>  					    int migratetype)
>  {
> @@ -130,15 +107,6 @@ static inline struct page
> *get_page_from_free_area(struct free_area *area,
>  					struct page, lru);
>  }
>  
> -static inline void del_page_from_free_area(struct page *page,
> -		struct free_area *area)
> -{
> -	list_del(&page->lru);
> -	__ClearPageBuddy(page);
> -	set_page_private(page, 0);
> -	area->nr_free--;
> -}
> -
>  static inline bool free_area_empty(struct free_area *area, int migratetype)
>  {
>  	return list_empty(&area->free_list[migratetype]);
> @@ -796,6 +764,44 @@ static inline bool pgdat_is_empty(pg_data_t *pgdat)
>  	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
>  }
>  
> +/* Used for pages not on another list */
> +static inline void add_to_free_list(struct page *page, struct zone *zone,
> +				    unsigned int order, int migratetype)
> +{
> +	struct free_area *area = &zone->free_area[order];
> +
> +	list_add(&page->lru, &area->free_list[migratetype]);
> +	area->nr_free++;
> +}
> +
> +/* Used for pages not on another list */
> +static inline void add_to_free_list_tail(struct page *page, struct zone
> *zone,
> +					 unsigned int order, int migratetype)
> +{
> +	struct free_area *area = &zone->free_area[order];
> +
> +	list_add_tail(&page->lru, &area->free_list[migratetype]);
> +	area->nr_free++;
> +}
> +
> +/* Used for pages which are on another list */
> +static inline void move_to_free_list(struct page *page, struct zone *zone,
> +				     unsigned int order, int migratetype)
> +{
> +	struct free_area *area = &zone->free_area[order];
> +
> +	list_move(&page->lru, &area->free_list[migratetype]);
> +}
> +
> +static inline void del_page_from_free_list(struct page *page, struct zone
> *zone,
> +					   unsigned int order)
> +{
> +	list_del(&page->lru);
> +	__ClearPageBuddy(page);
> +	set_page_private(page, 0);
> +	zone->free_area[order].nr_free--;
> +}
> +
>  #include <linux/memory_hotplug.h>
>  
>  void build_all_zonelists(pg_data_t *pgdat);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a791f2baeeeb..f85dc1561b85 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -921,7 +921,6 @@ static inline void __free_one_page(struct page *page,
>  	struct capture_control *capc = task_capc(zone);
>  	unsigned long uninitialized_var(buddy_pfn);
>  	unsigned long combined_pfn;
> -	struct free_area *area;
>  	unsigned int max_order;
>  	struct page *buddy;
>  
> @@ -958,7 +957,7 @@ static inline void __free_one_page(struct page *page,
>  		if (page_is_guard(buddy))
>  			clear_page_guard(zone, buddy, order, migratetype);
>  		else
> -			del_page_from_free_area(buddy, &zone->free_area[order]);
> +			del_page_from_free_list(buddy, zone, order);
>  		combined_pfn = buddy_pfn & pfn;
>  		page = page + (combined_pfn - pfn);
>  		pfn = combined_pfn;
> @@ -992,12 +991,11 @@ static inline void __free_one_page(struct page *page,
>  done_merging:
>  	set_page_order(page, order);
>  
> -	area = &zone->free_area[order];
>  	if (is_shuffle_order(order) ? shuffle_pick_tail() :
>  	    buddy_merge_likely(pfn, buddy_pfn, page, order))
> -		add_to_free_area_tail(page, area, migratetype);
> +		add_to_free_list_tail(page, zone, order, migratetype);
>  	else
> -		add_to_free_area(page, area, migratetype);
> +		add_to_free_list(page, zone, order, migratetype);
>  }
>  
>  /*
> @@ -2001,13 +1999,11 @@ void __init init_cma_reserved_pageblock(struct page
> *page)
>   * -- nyc
>   */
>  static inline void expand(struct zone *zone, struct page *page,
> -	int low, int high, struct free_area *area,
> -	int migratetype)
> +	int low, int high, int migratetype)
>  {
>  	unsigned long size = 1 << high;
>  
>  	while (high > low) {
> -		area--;
>  		high--;
>  		size >>= 1;
>  		VM_BUG_ON_PAGE(bad_range(zone, &page[size]), &page[size]);
> @@ -2021,7 +2017,7 @@ static inline void expand(struct zone *zone, struct
> page *page,
>  		if (set_page_guard(zone, &page[size], high, migratetype))
>  			continue;
>  
> -		add_to_free_area(&page[size], area, migratetype);
> +		add_to_free_list(&page[size], zone, high, migratetype);
>  		set_page_order(&page[size], high);
>  	}
>  }
> @@ -2179,8 +2175,8 @@ struct page *__rmqueue_smallest(struct zone *zone,
> unsigned int order,
>  		page = get_page_from_free_area(area, migratetype);
>  		if (!page)
>  			continue;
> -		del_page_from_free_area(page, area);
> -		expand(zone, page, order, current_order, area, migratetype);
> +		del_page_from_free_list(page, zone, current_order);
> +		expand(zone, page, order, current_order, migratetype);
>  		set_pcppage_migratetype(page, migratetype);
>  		return page;
>  	}
> @@ -2188,7 +2184,6 @@ struct page *__rmqueue_smallest(struct zone *zone,
> unsigned int order,
>  	return NULL;
>  }
>  
> -
>  /*
>   * This array describes the order lists are fallen back to when
>   * the free lists for the desirable migrate type are depleted
> @@ -2254,7 +2249,7 @@ static int move_freepages(struct zone *zone,
>  		VM_BUG_ON_PAGE(page_zone(page) != zone, page);
>  
>  		order = page_order(page);
> -		move_to_free_area(page, &zone->free_area[order], migratetype);
> +		move_to_free_list(page, zone, order, migratetype);
>  		page += 1 << order;
>  		pages_moved += 1 << order;
>  	}
> @@ -2370,7 +2365,6 @@ static void steal_suitable_fallback(struct zone *zone,
> struct page *page,
>  		unsigned int alloc_flags, int start_type, bool whole_block)
>  {
>  	unsigned int current_order = page_order(page);
> -	struct free_area *area;
>  	int free_pages, movable_pages, alike_pages;
>  	int old_block_type;
>  
> @@ -2441,8 +2435,7 @@ static void steal_suitable_fallback(struct zone *zone,
> struct page *page,
>  	return;
>  
>  single_page:
> -	area = &zone->free_area[current_order];
> -	move_to_free_area(page, area, start_type);
> +	move_to_free_list(page, zone, current_order, start_type);
>  }
>  
>  /*
> @@ -3113,7 +3106,6 @@ void split_page(struct page *page, unsigned int order)
>  
>  int __isolate_free_page(struct page *page, unsigned int order)
>  {
> -	struct free_area *area = &page_zone(page)->free_area[order];
>  	unsigned long watermark;
>  	struct zone *zone;
>  	int mt;
> @@ -3139,7 +3131,7 @@ int __isolate_free_page(struct page *page, unsigned int
> order)
>  
>  	/* Remove page from free list */
>  
> -	del_page_from_free_area(page, area);
> +	del_page_from_free_list(page, zone, order);
>  
>  	/*
>  	 * Set the pageblock if the isolated page is at least half of a
> @@ -8560,7 +8552,7 @@ void zone_pcp_reset(struct zone *zone)
>  		pr_info("remove from free list %lx %d %lx\n",
>  			pfn, 1 << order, end_pfn);
>  #endif
> -		del_page_from_free_area(page, &zone->free_area[order]);
> +		del_page_from_free_list(page, zone, order);
>  		for (i = 0; i < (1 << order); i++)
>  			SetPageReserved((page+i));
>  		pfn += (1 << order);
> 
> 

Reviewed-by: Pankaj Gupta <pagupta@redhat.com>

> 
