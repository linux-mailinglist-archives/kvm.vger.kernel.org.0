Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508BE164784
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 15:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgBSOzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 09:55:17 -0500
Received: from outbound-smtp35.blacknight.com ([46.22.139.218]:50745 "EHLO
        outbound-smtp35.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726652AbgBSOzR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 09:55:17 -0500
Received: from mail.blacknight.com (unknown [81.17.254.26])
        by outbound-smtp35.blacknight.com (Postfix) with ESMTPS id E0C9DAD0
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 14:55:13 +0000 (GMT)
Received: (qmail 5516 invoked from network); 19 Feb 2020 14:55:13 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.18.57])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 19 Feb 2020 14:55:13 -0000
Date:   Wed, 19 Feb 2020 14:55:11 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, konrad.wilk@oracle.com, nitesh@redhat.com,
        riel@surriel.com, willy@infradead.org, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, vbabka@suse.cz,
        osalvador@suse.de
Subject: Re: [PATCH v17 4/9] mm: Introduce Reported pages
Message-ID: <20200219145511.GS3466@techsingularity.net>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
 <20200211224635.29318.19750.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20200211224635.29318.19750.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:46:35PM -0800, Alexander Duyck wrote:
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> new file mode 100644
> index 000000000000..1047c6872d4f
> --- /dev/null
> +++ b/mm/page_reporting.c
> @@ -0,0 +1,319 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/mm.h>
> +#include <linux/mmzone.h>
> +#include <linux/page_reporting.h>
> +#include <linux/gfp.h>
> +#include <linux/export.h>
> +#include <linux/delay.h>
> +#include <linux/scatterlist.h>
> +
> +#include "page_reporting.h"
> +#include "internal.h"
> +
> +#define PAGE_REPORTING_DELAY	(2 * HZ)

I assume there is nothing special about 2 seconds other than "do some
progress every so often".

> +static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
> +
> +enum {
> +	PAGE_REPORTING_IDLE = 0,
> +	PAGE_REPORTING_REQUESTED,
> +	PAGE_REPORTING_ACTIVE
> +};
> +
> +/* request page reporting */
> +static void
> +__page_reporting_request(struct page_reporting_dev_info *prdev)
> +{
> +	unsigned int state;
> +
> +	/* Check to see if we are in desired state */
> +	state = atomic_read(&prdev->state);
> +	if (state == PAGE_REPORTING_REQUESTED)
> +		return;
> +
> +	/*
> +	 *  If reporting is already active there is nothing we need to do.
> +	 *  Test against 0 as that represents PAGE_REPORTING_IDLE.
> +	 */
> +	state = atomic_xchg(&prdev->state, PAGE_REPORTING_REQUESTED);
> +	if (state != PAGE_REPORTING_IDLE)
> +		return;
> +
> +	/*
> +	 * Delay the start of work to allow a sizable queue to build. For
> +	 * now we are limiting this to running no more than once every
> +	 * couple of seconds.
> +	 */
> +	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> +}

Seems a fair use of atomics.

> +static int
> +page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
> +		     unsigned int order, unsigned int mt,
> +		     struct scatterlist *sgl, unsigned int *offset)
> +{
> +	struct free_area *area = &zone->free_area[order];
> +	struct list_head *list = &area->free_list[mt];
> +	unsigned int page_len = PAGE_SIZE << order;
> +	struct page *page, *next;
> +	int err = 0;
> +
> +	/*
> +	 * Perform early check, if free area is empty there is
> +	 * nothing to process so we can skip this free_list.
> +	 */
> +	if (list_empty(list))
> +		return err;
> +
> +	spin_lock_irq(&zone->lock);
> +
> +	/* loop through free list adding unreported pages to sg list */
> +	list_for_each_entry_safe(page, next, list, lru) {
> +		/* We are going to skip over the reported pages. */
> +		if (PageReported(page))
> +			continue;
> +
> +		/* Attempt to pull page from list */
> +		if (!__isolate_free_page(page, order))
> +			break;
> +

Might want to note that you are breaking because the only reason to fail
the isolation is that watermarks are not met and we are likely under
memory pressure. It's not a big issue.

However, while I think this is correct, it's hard to follow. This loop can
be broken out of with pages still on the scatter gather list. The current
flow guarantees that err will not be set at this point so the caller
cleans it up so we always drain the list either here or in the caller.

While I think it works, it's a bit fragile. I recommend putting a comment
above this noting why it's safe and put a VM_WARN_ON_ONCE(err) before the
break in case someone tries to change this in a years time and does not
spot that the flow to reach page_reporting_drain *somewhere* is critical.

> +		/* Add page to scatter list */
> +		--(*offset);
> +		sg_set_page(&sgl[*offset], page, page_len, 0);
> +
> +		/* If scatterlist isn't full grab more pages */
> +		if (*offset)
> +			continue;
> +
> +		/* release lock before waiting on report processing */
> +		spin_unlock_irq(&zone->lock);
> +
> +		/* begin processing pages in local list */
> +		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
> +
> +		/* reset offset since the full list was reported */
> +		*offset = PAGE_REPORTING_CAPACITY;
> +
> +		/* reacquire zone lock and resume processing */
> +		spin_lock_irq(&zone->lock);
> +
> +		/* flush reported pages from the sg list */
> +		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
> +
> +		/*
> +		 * Reset next to first entry, the old next isn't valid
> +		 * since we dropped the lock to report the pages
> +		 */
> +		next = list_first_entry(list, struct page, lru);
> +
> +		/* exit on error */
> +		if (err)
> +			break;
> +	}
> +
> +	spin_unlock_irq(&zone->lock);
> +
> +	return err;
> +}

I complained about the use of zone lock before but in this version, I
think I'm ok with it. The lock is held for the free list manipulations
which is what it's for. The state management with atomics seems
reasonable.

Otherwise I think this is ok and I think the implementation right. Of
great importance to me was the allocator fast paths but they seem to be
adequately protected by a static branch so

Acked-by: Mel Gorman <mgorman@techsingularity.net>

The ack applies regardless of whether you decide to document and
defensively protect page_reporting_cycle against losing pages on the
scatter/gather list but I do recommend it.

-- 
Mel Gorman
SUSE Labs
