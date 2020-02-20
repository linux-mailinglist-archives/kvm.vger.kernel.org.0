Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84A416667F
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 19:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgBTSoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 13:44:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:59791 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgBTSoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 13:44:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 10:44:21 -0800
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="236329771"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 10:44:21 -0800
Message-ID: <7d3c732d9ec7725dcb5a90c1dc8e9859fbe6ccc0.camel@linux.intel.com>
Subject: Re: [PATCH v17 4/9] mm: Introduce Reported pages
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Mel Gorman <mgorman@techsingularity.net>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, konrad.wilk@oracle.com, nitesh@redhat.com,
        riel@surriel.com, willy@infradead.org, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, mhocko@kernel.org,
        vbabka@suse.cz, osalvador@suse.de
Date:   Thu, 20 Feb 2020 10:44:21 -0800
In-Reply-To: <20200219145511.GS3466@techsingularity.net>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
         <20200211224635.29318.19750.stgit@localhost.localdomain>
         <20200219145511.GS3466@techsingularity.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-02-19 at 14:55 +0000, Mel Gorman wrote:
> On Tue, Feb 11, 2020 at 02:46:35PM -0800, Alexander Duyck wrote:
> > diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> > new file mode 100644
> > index 000000000000..1047c6872d4f
> > --- /dev/null
> > +++ b/mm/page_reporting.c
> > @@ -0,0 +1,319 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/mm.h>
> > +#include <linux/mmzone.h>
> > +#include <linux/page_reporting.h>
> > +#include <linux/gfp.h>
> > +#include <linux/export.h>
> > +#include <linux/delay.h>
> > +#include <linux/scatterlist.h>
> > +
> > +#include "page_reporting.h"
> > +#include "internal.h"
> > +
> > +#define PAGE_REPORTING_DELAY	(2 * HZ)
> 
> I assume there is nothing special about 2 seconds other than "do some
> progress every so often".

Yes, nothing special. I played around with a few different values. I just
settled on 2 seconds as I figured with that and 1/16 of the list per pass
it came out to about 30 seconds which I felt is about the right time for a
fully utilized system to settle back to the inactive state.


> > 
> > +static int
> > +page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
> > +		     unsigned int order, unsigned int mt,
> > +		     struct scatterlist *sgl, unsigned int *offset)
> > +{
> > +	struct free_area *area = &zone->free_area[order];
> > +	struct list_head *list = &area->free_list[mt];
> > +	unsigned int page_len = PAGE_SIZE << order;
> > +	struct page *page, *next;
> > +	int err = 0;
> > +
> > +	/*
> > +	 * Perform early check, if free area is empty there is
> > +	 * nothing to process so we can skip this free_list.
> > +	 */
> > +	if (list_empty(list))
> > +		return err;
> > +
> > +	spin_lock_irq(&zone->lock);
> > +
> > +	/* loop through free list adding unreported pages to sg list */
> > +	list_for_each_entry_safe(page, next, list, lru) {
> > +		/* We are going to skip over the reported pages. */
> > +		if (PageReported(page))
> > +			continue;
> > +
> > +		/* Attempt to pull page from list */
> > +		if (!__isolate_free_page(page, order))
> > +			break;
> > +
> 
> Might want to note that you are breaking because the only reason to fail
> the isolation is that watermarks are not met and we are likely under
> memory pressure. It's not a big issue.
> 
> However, while I think this is correct, it's hard to follow. This loop can
> be broken out of with pages still on the scatter gather list. The current
> flow guarantees that err will not be set at this point so the caller
> cleans it up so we always drain the list either here or in the caller.

I can probably submit a follow-up patch to update the comments. The reason
for not returning an error is because I didn't consider it an error that
we encountered the watermark and were not able to pull any more pages.
Instead I considered that the "stop" point for this pass and have it just
exit out of the loop and flush the data.

At the start of the next pass we will check against the low watermark
instead of the minimum watermark and if that check fails we will simply
stop reporting pages for the zone until additional pages are freed.

I can probably also update the description for page_reporting_cycle since
it may not be clear that the output for this is a partially filled in-
progress scatterlist so we always have to reporting any remaining entries
at the end of processing a given zone. It might make more sense if I move
the bits related to "leftover" in page_reporting_process_zone into their
own function.

> While I think it works, it's a bit fragile. I recommend putting a comment
> above this noting why it's safe and put a VM_WARN_ON_ONCE(err) before the
> break in case someone tries to change this in a years time and does not
> spot that the flow to reach page_reporting_drain *somewhere* is critical.

I assume this isn't about this section, but the section below?

> > +		/* Add page to scatter list */
> > +		--(*offset);
> > +		sg_set_page(&sgl[*offset], page, page_len, 0);
> > +
> > +		/* If scatterlist isn't full grab more pages */
> > +		if (*offset)
> > +			continue;
> > +
> > +		/* release lock before waiting on report processing */
> > +		spin_unlock_irq(&zone->lock);
> > +
> > +		/* begin processing pages in local list */
> > +		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
> > +

So one thing I can do is probably add a comment here as well to more
thoroughly explain the reason why we wait to call the break until we are
in the block below.

> > +		/* reset offset since the full list was reported */
> > +		*offset = PAGE_REPORTING_CAPACITY;
> > +
> > +		/* reacquire zone lock and resume processing */
> > +		spin_lock_irq(&zone->lock);
> > +
> > +		/* flush reported pages from the sg list */
> > +		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
> > +
> > +		/*
> > +		 * Reset next to first entry, the old next isn't valid
> > +		 * since we dropped the lock to report the pages
> > +		 */
> > +		next = list_first_entry(list, struct page, lru);
> > +
> > +		/* exit on error */
> > +		if (err)
> > +			break;

And I assume you meant to add the VM_WARN_ON_ONCE here? The statement
above wouldn't make much sense since err would always be 0.

> > +	}
> > +
> > +	spin_unlock_irq(&zone->lock);
> > +
> > +	return err;
> > +}
> 
> I complained about the use of zone lock before but in this version, I
> think I'm ok with it. The lock is held for the free list manipulations
> which is what it's for. The state management with atomics seems
> reasonable.
> 
> Otherwise I think this is ok and I think the implementation right. Of
> great importance to me was the allocator fast paths but they seem to be
> adequately protected by a static branch so
> 
> Acked-by: Mel Gorman <mgorman@techsingularity.net>
> 
> The ack applies regardless of whether you decide to document and
> defensively protect page_reporting_cycle against losing pages on the
> scatter/gather list but I do recommend it.

Thanks for reviewing this. I appreciate the feedback.

- Alex


