Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E248316EDF5
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 19:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731466AbgBYS0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 13:26:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:63069 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726699AbgBYS0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 13:26:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 10:26:40 -0800
X-IronPort-AV: E=Sophos;i="5.70,485,1574150400"; 
   d="scan'208";a="231111987"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 10:26:39 -0800
Message-ID: <6ec496580ddcb629d22589a1cba8cd61cbd53206.camel@linux.intel.com>
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
Date:   Tue, 25 Feb 2020 10:26:39 -0800
In-Reply-To: <20191212171137.13872-7-david@redhat.com>
References: <20191212171137.13872-1-david@redhat.com>
         <20191212171137.13872-7-david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-12-12 at 18:11 +0100, David Hildenbrand wrote:
> virtio-mem wants to allow to offline memory blocks of which some parts
> were unplugged (allocated via alloc_contig_range()), especially, to later
> offline and remove completely unplugged memory blocks. The important part
> is that PageOffline() has to remain set until the section is offline, so
> these pages will never get accessed (e.g., when dumping). The pages should
> not be handed back to the buddy (which would require clearing PageOffline()
> and result in issues if offlining fails and the pages are suddenly in the
> buddy).
> 
> Let's allow to do that by allowing to isolate any PageOffline() page
> when offlining. This way, we can reach the memory hotplug notifier
> MEM_GOING_OFFLINE, where the driver can signal that he is fine with
> offlining this page by dropping its reference count. PageOffline() pages
> with a reference count of 0 can then be skipped when offlining the
> pages (like if they were free, however they are not in the buddy).
> 
> Anybody who uses PageOffline() pages and does not agree to offline them
> (e.g., Hyper-V balloon, XEN balloon, VMWare balloon for 2MB pages) will not
> decrement the reference count and make offlining fail when trying to
> migrate such an unmovable page. So there should be no observerable change.
> Same applies to balloon compaction users (movable PageOffline() pages), the
> pages will simply be migrated.
> 
> Note 1: If offlining fails, a driver has to increment the reference
> 	count again in MEM_CANCEL_OFFLINE.
> 
> Note 2: A driver that makes use of this has to be aware that re-onlining
> 	the memory block has to be handled by hooking into onlining code
> 	(online_page_callback_t), resetting the page PageOffline() and
> 	not giving them to the buddy.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
> Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Pingfan Liu <kernelfans@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/page-flags.h | 10 ++++++++++
>  mm/memory_hotplug.c        | 41 ++++++++++++++++++++++++++++----------
>  mm/page_alloc.c            | 24 ++++++++++++++++++++++
>  mm/page_isolation.c        |  9 +++++++++
>  4 files changed, 74 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 1bf83c8fcaa7..ac1775082343 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -761,6 +761,16 @@ PAGE_TYPE_OPS(Buddy, buddy)
>   * not onlined when onlining the section).
>   * The content of these pages is effectively stale. Such pages should not
>   * be touched (read/write/dump/save) except by their owner.
> + *
> + * If a driver wants to allow to offline unmovable PageOffline() pages without
> + * putting them back to the buddy, it can do so via the memory notifier by
> + * decrementing the reference count in MEM_GOING_OFFLINE and incrementing the
> + * reference count in MEM_CANCEL_OFFLINE. When offlining, the PageOffline()
> + * pages (now with a reference count of zero) are treated like free pages,
> + * allowing the containing memory block to get offlined. A driver that
> + * relies on this feature is aware that re-onlining the memory block will
> + * require to re-set the pages PageOffline() and not giving them to the
> + * buddy via online_page_callback_t.
>   */
>  PAGE_TYPE_OPS(Offline, offline)
>  
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index fc617ad6f035..da01453a04e6 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1231,11 +1231,15 @@ int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn,
>  
>  /*
>   * Scan pfn range [start,end) to find movable/migratable pages (LRU pages,
> - * non-lru movable pages and hugepages). We scan pfn because it's much
> - * easier than scanning over linked list. This function returns the pfn
> - * of the first found movable page if it's found, otherwise 0.
> + * non-lru movable pages and hugepages).
> + *
> + * Returns:
> + *	0 in case a movable page is found and movable_pfn was updated.
> + *	-ENOENT in case no movable page was found.
> + *	-EBUSY in case a definetly unmovable page was found.
>   */
> -static unsigned long scan_movable_pages(unsigned long start, unsigned long end)
> +static int scan_movable_pages(unsigned long start, unsigned long end,
> +			      unsigned long *movable_pfn)
>  {
>  	unsigned long pfn;
>  
> @@ -1247,18 +1251,29 @@ static unsigned long scan_movable_pages(unsigned long start, unsigned long end)
>  			continue;
>  		page = pfn_to_page(pfn);
>  		if (PageLRU(page))
> -			return pfn;
> +			goto found;
>  		if (__PageMovable(page))
> -			return pfn;
> +			goto found;
> +
> +		/*
> +		 * Unmovable PageOffline() pages where somebody still holds
> +		 * a reference count (after MEM_GOING_OFFLINE) can definetly
> +		 * not be offlined.
> +		 */
> +		if (PageOffline(page) && page_count(page))
> +			return -EBUSY;

So the comment confused me a bit because technically this function isn't
about offlining memory, it is about finding movable pages. I had to do a
bit of digging to find the only consumer is __offline_pages, but if we are
going to talk about "offlining" instead of "moving" in this function it
might make sense to rename it.

>  
>  		if (!PageHuge(page))
>  			continue;
>  		head = compound_head(page);
>  		if (page_huge_active(head))
> -			return pfn;
> +			goto found;
>  		skip = compound_nr(head) - (page - head);
>  		pfn += skip - 1;
>  	}
> +	return -ENOENT;
> +found:
> +	*movable_pfn = pfn;
>  	return 0;
>  }

So I am looking at this function and it seems like your change completely
changes the behavior. The code before would walk the entire range and if
at least 1 page was available to move you would return the PFN of that
page. Now what seems to happen is that you will return -EBUSY as soon as
you encounter an offline page with a page count. I would think that would
slow down the offlining process since you have made the Unmovable
PageOffline() page a head of line blocker that you have to wait to get
around.

Would it perhaps make more sense to add a return value initialized to
ENOENT, and if you encounter one of these offline pages you change the
return value to EBUSY, and then if you walk through the entire list
without finding a movable page you just return the value?

Otherwise you might want to add a comment explaining why the function
should stall instead of skipping over the unmovable section that will
hopefully become movable later.

> @@ -1528,7 +1543,8 @@ static int __ref __offline_pages(unsigned long start_pfn,
>  	}
>  
>  	do {
> -		for (pfn = start_pfn; pfn;) {
> +		pfn = start_pfn;
> +		do {
>  			if (signal_pending(current)) {
>  				ret = -EINTR;
>  				reason = "signal backoff";
> @@ -1538,14 +1554,19 @@ static int __ref __offline_pages(unsigned long start_pfn,
>  			cond_resched();
>  			lru_add_drain_all();
>  
> -			pfn = scan_movable_pages(pfn, end_pfn);
> -			if (pfn) {
> +			ret = scan_movable_pages(pfn, end_pfn, &pfn);
> +			if (!ret) {
>  				/*
>  				 * TODO: fatal migration failures should bail
>  				 * out
>  				 */
>  				do_migrate_range(pfn, end_pfn);
>  			}
> +		} while (!ret);
> +
> +		if (ret != -ENOENT) {
> +			reason = "unmovable page";
> +			goto failed_removal_isolated;
>  		}
>  
>  		/*
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5334decc9e06..840c0bbe2d9f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -8256,6 +8256,19 @@ bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
>  		if ((flags & MEMORY_OFFLINE) && PageHWPoison(page))
>  			continue;
>  
> +		/*
> +		 * We treat all PageOffline() pages as movable when offlining
> +		 * to give drivers a chance to decrement their reference count
> +		 * in MEM_GOING_OFFLINE in order to signalize that these pages

You can probably just use "signal" or "indicate" instead of "signalize".

> +		 * can be offlined as there are no direct references anymore.
> +		 * For actually unmovable PageOffline() where the driver does
> +		 * not support this, we will fail later when trying to actually
> +		 * move these pages that still have a reference count > 0.
> +		 * (false negatives in this function only)
> +		 */
> +		if ((flags & MEMORY_OFFLINE) && PageOffline(page))
> +			continue;
> +
>  		if (__PageMovable(page))
>  			continue;
>  
> @@ -8683,6 +8696,17 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>  			offlined_pages++;
>  			continue;
>  		}
> +		/*
> +		 * At this point all remaining PageOffline() pages have a
> +		 * reference count of 0 and can simply be skipped.
> +		 */
> +		if (PageOffline(page)) {
> +			BUG_ON(page_count(page));
> +			BUG_ON(PageBuddy(page));
> +			pfn++;
> +			offlined_pages++;
> +			continue;
> +		}
>  
>  		BUG_ON(page_count(page));
>  		BUG_ON(!PageBuddy(page));
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 04ee1663cdbe..43b4dabfedc8 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -170,6 +170,7 @@ __first_valid_page(unsigned long pfn, unsigned long nr_pages)
>   *			a bit mask)
>   *			MEMORY_OFFLINE - isolate to offline (!allocate) memory
>   *					 e.g., skip over PageHWPoison() pages
> + *					 and PageOffline() pages.
>   *			REPORT_FAILURE - report details about the failure to
>   *			isolate the range
>   *
> @@ -278,6 +279,14 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
>  		else if ((flags & MEMORY_OFFLINE) && PageHWPoison(page))
>  			/* A HWPoisoned page cannot be also PageBuddy */
>  			pfn++;
> +		else if ((flags & MEMORY_OFFLINE) && PageOffline(page) &&
> +			 !page_count(page))
> +			/*
> +			 * The responsible driver agreed to offline
> +			 * PageOffline() pages by dropping its reference in
> +			 * MEM_GOING_OFFLINE.
> +			 */
> +			pfn++;
>  		else
>  			break;
>  	}


