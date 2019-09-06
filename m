Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2466AB51F
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 11:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388119AbfIFJv6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 05:51:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbfIFJv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 05:51:57 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1162C30917AF;
        Fri,  6 Sep 2019 09:51:57 +0000 (UTC)
Received: from [10.36.117.162] (ovpn-117-162.ams2.redhat.com [10.36.117.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54E2E5D9CA;
        Fri,  6 Sep 2019 09:51:43 +0000 (UTC)
Subject: Re: [PATCH v7 3/6] mm: Use zone and order instead of free area in
 free_list manipulators
To:     Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
References: <20190904150920.13848.32271.stgit@localhost.localdomain>
 <20190904151043.13848.23471.stgit@localhost.localdomain>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <ce85c93e-f655-2255-8f1d-07825f3fb0dd@redhat.com>
Date:   Fri, 6 Sep 2019 11:51:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904151043.13848.23471.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 06 Sep 2019 09:51:57 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.09.19 17:10, Alexander Duyck wrote:
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
>  include/linux/mmzone.h |   70 ++++++++++++++++++++++++++----------------------
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
> -static inline void add_to_free_area(struct page *page, struct free_area *area,
> -			     int migratetype)
> -{
> -	list_add(&page->lru, &area->free_list[migratetype]);
> -	area->nr_free++;
> -}
> -
> -/* Used for pages not on another list */
> -static inline void add_to_free_area_tail(struct page *page, struct free_area *area,
> -				  int migratetype)
> -{
> -	list_add_tail(&page->lru, &area->free_list[migratetype]);
> -	area->nr_free++;
> -}
> -
> -/* Used for pages which are on another list */
> -static inline void move_to_free_area(struct page *page, struct free_area *area,
> -			     int migratetype)
> -{
> -	list_move(&page->lru, &area->free_list[migratetype]);
> -}
> -
>  static inline struct page *get_page_from_free_area(struct free_area *area,
>  					    int migratetype)
>  {
> @@ -130,15 +107,6 @@ static inline struct page *get_page_from_free_area(struct free_area *area,
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
> +static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
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
> +static inline void del_page_from_free_list(struct page *page, struct zone *zone,
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
> @@ -2001,13 +1999,11 @@ void __init init_cma_reserved_pageblock(struct page *page)
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
> @@ -2021,7 +2017,7 @@ static inline void expand(struct zone *zone, struct page *page,
>  		if (set_page_guard(zone, &page[size], high, migratetype))
>  			continue;
>  
> -		add_to_free_area(&page[size], area, migratetype);
> +		add_to_free_list(&page[size], zone, high, migratetype);
>  		set_page_order(&page[size], high);
>  	}
>  }
> @@ -2179,8 +2175,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
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
> @@ -2188,7 +2184,6 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
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
> @@ -2370,7 +2365,6 @@ static void steal_suitable_fallback(struct zone *zone, struct page *page,
>  		unsigned int alloc_flags, int start_type, bool whole_block)
>  {
>  	unsigned int current_order = page_order(page);
> -	struct free_area *area;
>  	int free_pages, movable_pages, alike_pages;
>  	int old_block_type;
>  
> @@ -2441,8 +2435,7 @@ static void steal_suitable_fallback(struct zone *zone, struct page *page,
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
> @@ -3139,7 +3131,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
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

Looks like a nice cleanup to me.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 

Thanks,

David / dhildenb
