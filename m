Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A505A17F6A4
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 12:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgCJLru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 07:47:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34690 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgCJLrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 07:47:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id z15so15482446wrl.1;
        Tue, 10 Mar 2020 04:47:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QsahTkmAei7BQYWUfchRwbDRzj8XQfWoBkhiU+rk5sQ=;
        b=DzXzJiGrQERpfIOsmcvL/06BhViaGuVwU0uG777RrL0GrAKwsolX4ZYu+tT6VyZmmk
         rINAIxc3VmdcsW6HEU0IhKmnItHVqUDoJTGb51II68uAzz06I3RyxngC13VC6/4aZ8P7
         4f7anAEYSBigIoQcpFjs+wpv7zA4uzmzF0KMj3k2BVR8GVBOLXVBOv/wt8VKse6fhVJR
         yMY3fYFev9TZaBTONCqqvDHNfU9LTOVq1wQkWxw0152Ir2aIuPwkGNaFg3WaV5T0d1fP
         hz/Mo1R9Yk1b4hzi7ONJQLlu/WBomqw1s9UrS+MVT1Q3fkoDsc4J9JaQVTAVn55MA77o
         pujQ==
X-Gm-Message-State: ANhLgQ0VnJRsvjDbKzmcC16x3XwPtSiqkSvIN5j8da6f6laf65b3t3te
        25wj2zZ/e7axvPi5Gse+qWc=
X-Google-Smtp-Source: ADFU+vuQrXGaCCnWnlGXuGqTlA7qmmi8Mc9fVfAomzOqlu8SsO0tgL4QpYiyxVdgaoLNsMG/R97puQ==
X-Received: by 2002:a5d:6544:: with SMTP id z4mr8475212wrv.298.1583840866726;
        Tue, 10 Mar 2020 04:47:46 -0700 (PDT)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id q16sm51415687wrj.73.2020.03.10.04.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 04:47:46 -0700 (PDT)
Date:   Tue, 10 Mar 2020 12:47:45 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Qian Cai <cai@lca.pw>, Pingfan Liu <kernelfans@gmail.com>
Subject: Re: [PATCH v1 06/11] mm: Allow to offline unmovable PageOffline()
 pages via MEM_GOING_OFFLINE
Message-ID: <20200310114745.GH8447@dhcp22.suse.cz>
References: <20200302134941.315212-1-david@redhat.com>
 <20200302134941.315212-7-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302134941.315212-7-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon 02-03-20 14:49:36, David Hildenbrand wrote:
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
> migrate such an unmovable page. So there should be no observable change.
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

Looks good to me. Thanks for dropping __put_page hooks!
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/page-flags.h | 10 +++++++++
>  mm/memory_hotplug.c        | 44 +++++++++++++++++++++++++++++---------
>  mm/page_alloc.c            | 24 +++++++++++++++++++++
>  mm/page_isolation.c        |  9 ++++++++
>  4 files changed, 77 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 49c2697046b9..fd6d4670ccc3 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -772,6 +772,16 @@ PAGE_TYPE_OPS(Buddy, buddy)
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
> index 1a00b5a37ef6..ab1c31e67fd1 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1221,11 +1221,17 @@ struct zone *test_pages_in_a_zone(unsigned long start_pfn,
>  
>  /*
>   * Scan pfn range [start,end) to find movable/migratable pages (LRU pages,
> - * non-lru movable pages and hugepages). We scan pfn because it's much
> - * easier than scanning over linked list. This function returns the pfn
> - * of the first found movable page if it's found, otherwise 0.
> + * non-lru movable pages and hugepages). Will skip over most unmovable
> + * pages (esp., pages that can be skipped when offlining), but bail out on
> + * definitely unmovable pages.
> + *
> + * Returns:
> + *	0 in case a movable page is found and movable_pfn was updated.
> + *	-ENOENT in case no movable page was found.
> + *	-EBUSY in case a definitely unmovable page was found.
>   */
> -static unsigned long scan_movable_pages(unsigned long start, unsigned long end)
> +static int scan_movable_pages(unsigned long start, unsigned long end,
> +			      unsigned long *movable_pfn)
>  {
>  	unsigned long pfn;
>  
> @@ -1237,18 +1243,30 @@ static unsigned long scan_movable_pages(unsigned long start, unsigned long end)
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
> +		 * PageOffline() pages that are not marked __PageMovable() and
> +		 * have a reference count > 0 (after MEM_GOING_OFFLINE) are
> +		 * definitely unmovable. If their reference count would be 0,
> +		 * they could at least be skipped when offlining memory.
> +		 */
> +		if (PageOffline(page) && page_count(page))
> +			return -EBUSY;
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
>  
> @@ -1515,7 +1533,8 @@ static int __ref __offline_pages(unsigned long start_pfn,
>  	}
>  
>  	do {
> -		for (pfn = start_pfn; pfn;) {
> +		pfn = start_pfn;
> +		do {
>  			if (signal_pending(current)) {
>  				ret = -EINTR;
>  				reason = "signal backoff";
> @@ -1525,14 +1544,19 @@ static int __ref __offline_pages(unsigned long start_pfn,
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
> index 8d7be3f33e26..baa60222215f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -8366,6 +8366,19 @@ struct page *has_unmovable_pages(struct zone *zone, struct page *page,
>  		if ((flags & MEMORY_OFFLINE) && PageHWPoison(page))
>  			continue;
>  
> +		/*
> +		 * We treat all PageOffline() pages as movable when offlining
> +		 * to give drivers a chance to decrement their reference count
> +		 * in MEM_GOING_OFFLINE in order to indicate that these pages
> +		 * can be offlined as there are no direct references anymore.
> +		 * For actually unmovable PageOffline() where the driver does
> +		 * not support this, we will fail later when trying to actually
> +		 * move these pages that still have a reference count > 0.
> +		 * (false negatives in this function only)
> +		 */
> +		if ((flags & MEMORY_OFFLINE) && PageOffline(page))
> +			continue;
> +
>  		if (__PageMovable(page) || PageLRU(page))
>  			continue;
>  
> @@ -8786,6 +8799,17 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
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
> index 2c11a38d6e87..f6d07c5f0d34 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -151,6 +151,7 @@ __first_valid_page(unsigned long pfn, unsigned long nr_pages)
>   *			a bit mask)
>   *			MEMORY_OFFLINE - isolate to offline (!allocate) memory
>   *					 e.g., skip over PageHWPoison() pages
> + *					 and PageOffline() pages.
>   *			REPORT_FAILURE - report details about the failure to
>   *			isolate the range
>   *
> @@ -259,6 +260,14 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
>  		else if ((flags & MEMORY_OFFLINE) && PageHWPoison(page))
>  			/* A HWPoisoned page cannot be also PageBuddy */
>  			pfn++;
> +		else if ((flags & MEMORY_OFFLINE) && PageOffline(page) &&
> +			 !page_count(page))
> +			/*
> +			 * The responsible driver agreed to skip PageOffline()
> +			 * pages when offlining memory by dropping its
> +			 * reference in MEM_GOING_OFFLINE.
> +			 */
> +			pfn++;
>  		else
>  			break;
>  	}
> -- 
> 2.24.1

-- 
Michal Hocko
SUSE Labs
