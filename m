Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626D510BFEC
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 22:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfK0VzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 16:55:05 -0500
Received: from mga17.intel.com ([192.55.52.151]:57041 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbfK0VzD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 16:55:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 13:55:02 -0800
X-IronPort-AV: E=Sophos;i="5.69,251,1571727600"; 
   d="scan'208";a="359630410"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 13:55:02 -0800
Message-ID: <6aae7be8a84e7f0622c1f7fd362e4f213aea383d.camel@linux.intel.com>
Subject: Re: [PATCH v14 3/6] mm: Introduce Reported pages
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        vbabka@suse.cz, yang.zhang.wz@gmail.com, nitesh@redhat.com,
        konrad.wilk@oracle.com, david@redhat.com, pagupta@redhat.com,
        riel@surriel.com, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, osalvador@suse.de
Date:   Wed, 27 Nov 2019 13:55:02 -0800
In-Reply-To: <20191127183524.GF3016@techsingularity.net>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
         <20191119214633.24996.46821.stgit@localhost.localdomain>
         <20191127152422.GE3016@techsingularity.net>
         <0ec9b67cb45cd30f0ff0b2e9dcbc41602de1c178.camel@linux.intel.com>
         <20191127183524.GF3016@techsingularity.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2019-11-27 at 18:35 +0000, Mel Gorman wrote:
> On Wed, Nov 27, 2019 at 09:22:09AM -0800, Alexander Duyck wrote:
> > > Ok, I'm ok with how this hooks into the allocator as the overhead is
> > > minimal. However, the patch itself still includes a number of
> > > optimisations instead of being a bare-boned implementation of the
> > > feature with optimisations layered on top. I think some of the
> > > optimisations are also broken but it's harder to be sure because both
> > > the feature and the optimisations are lumped together.
> > 
> > Well I can work on splitting them out if need be. 
> > 
> 
> It would be preferred because some of the optimisations are fairly
> subtle and it distracts from having a basic implementation of the
> feature as a foundation to build upon.

Yeah, I will work on cleaning this up and then splitting out the
optimizations.

> > > > diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
> > > > new file mode 100644
> > > > index 000000000000..925a16b1d14b
> > > > --- /dev/null
> > > > +++ b/include/linux/page_reporting.h
> > > > @@ -0,0 +1,31 @@
> > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > +#ifndef _LINUX_PAGE_REPORTING_H
> > > > +#define _LINUX_PAGE_REPORTING_H
> > > > +
> > > > +#include <linux/mmzone.h>
> > > > +
> > > > +struct page_reporting_dev_info {
> > > > +	/* function that alters pages to make them "reported" */
> > > > +	void (*report)(struct page_reporting_dev_info *prdev,
> > > > +		       unsigned int nents);
> > > > +
> > > > +	/* pointer to scatterlist containing pages to be processed */
> > > > +	struct scatterlist *sg;
> > > > +
> > > 
> > > The choice of scatterlist is curious because it adds unnecessary complexity
> > > without needing the benefits scatterlist and sg_table provides. All you
> > > really need is an array of pages that is NULL terminated because you can
> > > get the order of the struct page when it's a buddy page.
> > 
> > The scatterlist is mostly about dealing with DMA mapping of the pages.
> > Most devices will need a way to push the pages out to the device doing the
> > reporting so I thought a scatterlist was the best way to gather the pages
> > together so that they could be mapped with one call.
> > 
> 
> Ok, might be worth adding a comment about that noting that it may appear
> excessive but it's to avoid a situation where drivers have to convert
> page arrays to scatterlists.

I'll probably do that. I might also be able to split this out of the
structure. I will still pass around the scatterlist but I can explain the
purpose.

> > > > +	/*
> > > > +	 * Upper limit on the number of pages that the report function
> > > > +	 * expects to be placed into the scatterlist to be processed.
> > > > +	 */
> > > > +	unsigned int capacity;
> > > > +
> > > 
> > > Instead of requiring the driver to specify capacity, why did you not
> > > simply make it PAGE_REPORTING_HWM and statically declare the array?
> > 
> > The problem is the device might not be able to support PAGE_REPORTING_HWM.
> 
> I don't see why given that a driver that cannot handle PAGE_REPORTING_HWM
> could process subsets of the pages reported. It seems unnecessary.

I suppose it might be considered an optimization. Basically what I was
wanting to avoid is pulling out more pages then the device can process in
a single call. That is what the capacity represents. Basically the virtio
device can have a limited ring size which limits how many pages we can
have outstanding at a time. So I wanted to avoid pulling pages that I
couldn't immediately report.

> > So I needed some way for it to communicate that. I could allocate the
> > array statically if that is what you prefer.
> > 
> 
> It would make sense if it's a fixed size and let drivers figure out whether
> the full array can be processed at once or has to be split into parts.

In terms of allocation the fixed size makes sense to me. I still think it
would be good to communicate how many the device can process in a single
request so we don't have pages having to wait as the device has to segment
the scatterlist to process pieces of it.

> > > > +	/* The number of zones requesting reporting */
> > > > +	atomic_t refcnt;
> > > > +
> > > 
> > > The refcnt is overkill. Simply loop over all zones until there is a
> > > clear pass. Despite being atomic, it actually requires the zone lock to
> > > avoid races in places like this
> > > 
> > > 		if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
> > > 			refcnt = page_reporting_process_zone(prdev, zone);
> > > 
> > > The optimisation is small and it's relatively subtle.
> > 
> > I disagree. Without that we can easily get into states where a zone
> > requests reporting and we never get around to servicing it.
> 
> Why would that happen if all zones were iterated during a single pass?

It is because I am not rescheduling the work while it is ongoing. My
notifier is using the reference count to only schedule on the first
request and not stop processing until we reach 0. Without that I have to
schedule the worker ever time a zone requests processing.

> > I am using the
> > refcount to track that so that we don't shutdown the worker thread when
> > there is at least one zone requesting service.
> > 
> 
> Then either single pass or loop through all zones until a loop completes
> with no zones to be processed. It's far simplier than a refcount.

I could do that if we only had one zone to process. However the problem is
that we could be processing multiple zones.

> > > >  static inline void __free_one_page(struct page *page,
> > > >  		unsigned long pfn,
> > > >  		struct zone *zone, unsigned int order,
> > > > -		int migratetype)
> > > > +		int migratetype, bool reported)
> > > >  {
> > > >  	struct capture_control *capc = task_capc(zone);
> > > >  	unsigned long uninitialized_var(buddy_pfn);
> > > > @@ -1048,7 +1053,9 @@ static inline void __free_one_page(struct page *page,
> > > >  done_merging:
> > > >  	set_page_order(page, order);
> > > >  
> > > > -	if (is_shuffle_order(order))
> > > > +	if (reported)
> > > > +		to_tail = true;
> > > > +	else if (is_shuffle_order(order))
> > > >  		to_tail = shuffle_pick_tail();
> > > >  	else
> > > >  		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
> > > > @@ -1057,6 +1064,14 @@ static inline void __free_one_page(struct page *page,
> > > >  		add_to_free_list_tail(page, zone, order, migratetype);
> > > >  	else
> > > >  		add_to_free_list(page, zone, order, migratetype);
> > > > +
> > > > +	/*
> > > > +	 * No need to notify on a reported page as the total count of
> > > > +	 * unreported pages will not have increased since we have essentially
> > > > +	 * merged the reported page with one or more unreported pages.
> > > > +	 */
> > > > +	if (!reported)
> > > > +		page_reporting_notify_free(zone, order);
> > > >  }
> > > >  
> > > >  /*
> > > 
> > > If a reported page is merged with a larger buddy then the counts for the
> > > lower order needs to be updated or the counter gets out of sync. Then the
> > > reported status of the page needs to be cleared as the larger block may
> > > only be partially reported and the count is wrong. I know why you want
> > > the reported pages but it really should be in its own patch. This patch
> > > really should be just the bare essentials to support reporting of free
> > > pages even if it's sub-optimal. I know you also use reported_pages as
> > > part of a stop condition but a basic stop condition is simply to do a
> > > single pass.
> > 
> > Okay so there are actually a few things here to unpack.
> > 
> > First the comment is a bit out of date. The reason I don't need to bother
> > with reporting is because I process the lower orders before the higher
> > orders.
> > As such we are still processing this zone if we are returning a
> > reported page and it is merged. We will reprocess the larger page in the
> > next pass.
> > 
> 
> I don't see what guarantees the lower order buddy was definitely
> reported. The lower order could have been in an isolated pageblock --
> bit insane but not impossible. It also could have failed to be isolated
> due to a watermark check. Either way, the accounting gets screwy.

So if we merge a page it is not considered reported. I think you might be
confusing this with the bits in page_reporting_drain which check to verify
that the page we freed became a buddy and that buddy is the same order as
what we originally released. If a reported page is merged it is no longer
considered to be reported.

Basically if we pull a reported page from the free list to merge it then
we clear the reported status and decrement the reported page count for
that order.

> > Second, at the point where we call this function with the reported flag
> > set we have not yet set the page as reported. There is logic that will
> > check for that later and set the bits and increment the count if the page
> > becomes a buddy page and the order is still the same as the order we
> > originally freed it under.
> > 
> 
> That is sufficiently complex that it really should be in its own patch
> because right now, any bug there would either revert the whole feature
> or do a partial revert if it couldn't be fixed properly. At least having
> the option of reverting the optimisation would be useful for testing.
> By not splitting it out, we're also prevented from being able to ack the
> basic infrastructure itself. Even if the optimisations could not be agreed
> upon, the feature would still exist -- just slower than is ideal.

The only optimization here is the use of the reported variable. That can
actually go away since I hadn't realized I had changed things in the page
reporting cycle so that we don't clear the REPORTING_REQUESTED flag until
after the last drain has completed.

I'll work on splitting out the reported_pages bit into a separate patch,
and I will see what I can do about refcount since that seems to be the
other pain point.

> > Lastly, if you are concerned about us merging a reported page already on
> > the list the count is updated and the flag is cleared from the page when
> > it is deleted from the free list to be merged with the new page.
> > 
> > > > @@ -3228,6 +3243,36 @@ int __isolate_free_page(struct page *page, unsigned int order)
> > > >  	return 1UL << order;
> > > >  }
> > > >  
> > > > +#ifdef CONFIG_PAGE_REPORTING
> > > > +/**
> > > > + * __free_isolated_page - Return a now-isolated page back where we got it
> > > > + * @page: Page that was isolated
> > > > + * @order: Order of the isolated page
> > > > + *
> > > > + * This function is meant to return a page pulled from the free lists via
> > > > + * __isolate_free_page back to the free lists they were pulled from.
> > > > + */
> > > 
> > > Isolated within mm has special meaning already. __putback_reported_page?
> > 
> > I wanted to get away from calling it a reported page because it isn't at
> > the point where we are calling this function. We don't set the reported
> > bit on the page until we have placed it back into the free list and
> > verified it wasn't merged.
> > 
> > I'm open to suggestions on how to name a function that is meant to be the
> > inverse of __isolate_free_page. All I did is swap the isolate and free
> > verb/adjective.
> > 
> 
> __putback_isolated_page would at least have a similar naming pattern to
> how LRU pages are isolated and putback.

I can work with that then.

> > > > +static void
> > > > +page_reporting_drain(struct page_reporting_dev_info *prdev, struct zone *zone)
> > > > +{
> > > > +	struct scatterlist *sg = prdev->sg;
> > > > +
> > > > +	/*
> > > > +	 * Drain the now reported pages back into their respective
> > > > +	 * free lists/areas. We assume at least one page is populated.
> > > > +	 */
> > > > +	do {
> > > > +		unsigned int order = get_order(sg->length);
> > > > +		struct page *page = sg_page(sg);
> > > > +
> > > > +		__free_isolated_page(page, order);
> > > > +
> > > > +		/*
> > > > +		 * If page was not comingled with another page we can
> > > > +		 * consider the result to be "reported" since the page
> > > > +		 * hasn't been modified, otherwise we will need to
> > > > +		 * report on the new larger page when we make our way
> > > > +		 * up to that higher order.
> > > > +		 */
> > > > +		if (PageBuddy(page) && page_order(page) == order)
> > > > +			mark_page_reported(page, zone, order);
> > > > +	} while (!sg_is_last(sg++));
> > > > +}
> > > > +
> > > > +/*
> > > > + * The page reporting cycle consists of 4 stages, fill, report, drain, and
> > > > + * idle. We will cycle through the first 3 stages until we cannot obtain a
> > > > + * full scatterlist of pages, in that case we will switch to idle.
> > > > + */
> > > 
> > > Document the return value because it's unclear why the number of populated
> > > elements in sg is not tracked in page_reporting_dev_info. It seems
> > > unnecessarily fragile.
> > 
> > Will do in terms of documenting the return value.
> > 
> > As far as tracking the number of elements it mostly just has to do with
> > how this code has evolved. Originally this was just going straight to the
> > report function. However that leads to partial requests and I wanted to
> > avoid those since the cost for each call into the hypervisor can be high.
> > 
> 
> It might be worth putting the count into the struct then as it's more
> straight-forward than tracking struct state outside of the struct.

Yeah, that is kind of what I was thinking. If nothing else I might look at
using something like an sg_table structure to pass the entries around.

> > > > +static int
> > > > +page_reporting_process_zone(struct page_reporting_dev_info *prdev,
> > > > +			    struct zone *zone)
> > > > +{
> > > > +	unsigned int order, mt, nents = 0;
> > > > +	unsigned long watermark;
> > > > +	int refcnt = -1;
> > > > +
> > > > +	page_reporting_populate_metadata(zone);
> > > > +
> > > > +	/* Generate minimum watermark to be able to guarantee progress */
> > > > +	watermark = low_wmark_pages(zone) +
> > > > +		    (prdev->capacity << PAGE_REPORTING_MIN_ORDER);
> > > > +
> > > > +	/*
> > > > +	 * Cancel request if insufficient free memory or if we failed
> > > > +	 * to allocate page reporting statistics for the zone.
> > > > +	 */
> > > > +	if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA) ||
> > > > +	    !zone->reported_pages) {
> > > > +		spin_lock_irq(&zone->lock);
> > > > +		goto zone_not_ready;
> > > > +	}
> > > 
> > > The zone lock is acquired just for the zone bit and the refcnt? That
> > > seems drastic overkill because the bit handling is already racy and the
> > > refcnt is overkill.
> > 
> > I'm not sure I follow.
> > 
> 
> The lock is acquired before branching to zone_not_ready for the purpose
> of clearing a zone bit and updating the ref count. That is hinting at
> the possibility that zone lock is protecting much more than it should.

I'm using it to protect the bit and the page counts. Basically I cannot
rely on the page counts being valid if I am not holding the lock. So in
order to avoid races between the bit and the page counts I hold the lock
when I clear the bit.

> > > > +
> > > > +	sg_init_table(prdev->sg, prdev->capacity);
> > > > +
> > > > +	/* Process each free list starting from lowest order/mt */
> > > > +	for_each_reporting_migratetype_order(order, mt)
> > > > +		nents = page_reporting_cycle(prdev, zone, order, mt, nents);
> > > > +
> > > > +	/* mark end of sg list and report the remainder */
> > > > +	if (nents) {
> > > > +		sg_mark_end(&prdev->sg[nents - 1]);
> > > > +		prdev->report(prdev, nents);
> > > > +	}
> > > > +
> > > > +	spin_lock_irq(&zone->lock);
> > > > +
> > > > +	/* flush any remaining pages out from the last report */
> > > > +	if (nents)
> > > > +		page_reporting_drain(prdev, zone);
> > > > +
> > > > +	/* check to see if values are low enough for us to stop for now */
> > > > +	for (order = PAGE_REPORTING_MIN_ORDER; order < MAX_ORDER; order++) {
> > > > +		if (pages_unreported(zone, order) < PAGE_REPORTING_HWM)
> > > > +			continue;
> > > > +#ifdef CONFIG_MEMORY_ISOLATION
> > > > +		/*
> > > > +		 * Do not allow a free_area with isolated pages to request
> > > > +		 * that we continue with page reporting. Keep the reporting
> > > > +		 * light until the isolated pages have been cleared.
> > > > +		 */
> > > > +		if (!free_area_empty(&zone->free_area[order], MIGRATE_ISOLATE))
> > > > +			continue;
> > > > +#endif
> > > > +		goto zone_not_complete;
> > > > +	}
> > > > +
> > > > +zone_not_ready:
> > > > +	/*
> > > > +	 * If there are no longer enough free pages to fully populate
> > > > +	 * the scatterlist, then we can just shut it down for this zone.
> > > > +	 */
> > > > +	__clear_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags);
> > > > +	refcnt = atomic_dec_return(&prdev->refcnt);
> > > 
> > > If a request comes in while processing is already happening then the
> > > subsequent request is lost.
> > 
> > How can a request come in when we are holding the zone lock?
>  
> page_reporting_cycle drops the lock so there is no obvious guarantee
> that requests are not lost.

Yes, but page_reporting_cycle will not clear the bit. It is only cleared
in this last bleock where we go through and verify the page counts are low
enough that we can justify clearing the bit.

This is what I am talking about in terms of the page counts and the bit
being synchronized via the lock. Both the notifier and this piece of code
will not set nor clear the bit without first having to check
pages_unreported and then either setting or clearing the bit depending on
if we are the notifier or the reporting process.

> > Basically the
> > notify call can only occur while holding the zone lock. That is one of the
> > reasons for holding the lock is to protect the flag and keep it consistent
> > with the page counts as we clear it.
> > 
> 
> Ok, you really should not be relying on the zone lock for protecting
> state like this. It's fragile and it abuses what zone lock is for. It's
> fragile because zone flags is not intended to protected by the zone
> lock. Historically there would have been more flags but even currently,
> the flag is tested and set outside of the zone lock. As you are using
> non-atomic ops, it gets even more fragile because flag updates are
> potentially lost.
> 
> The zone lock is primarily to protect the free lists and the watermarks
> which are strongly related to the free lists and expanding that scope to
> protect an atomic and a zone flag is very questionable. At some point,
> zone lock is going to have to be broken up somehow because it's a very
> heavy lock on the allocator side. If zone lock is protecting multiple
> things like this, that would get even harder.

So I am not necessarily using it to protect the atomic refcount. The
placement of the atomic refcount as more to do with the setting and
clearing of the flag bit.

What I am using the lock for is mostly to keep the farea[x].nr_free
coherent versus the reported_pages counts.

> If necessary, add a separate lock and use it to protect state related to
> the page reporting but as part of that, you almost certainly will have
> to move to atomic versions of bit operations for zone flags because it's
> not protected as such.
> 
> Again, it really should be the case that ZONE_PAGE_REPORTING_REQUESTED
> is split out into a separate patch and introduced standalone. It would
> probably be on the justification of avoiding unnecessary zone free list
> searches but still, the optimisation should be reviewed separately and
> the locking of state should be clear.

I can look into it. However between this, the removal of the
reported_pages counters, and the desire to remove the reference count it
sounds like what we have is essentially just a blind scanner that will
never really know when it is done and would likely be very lossy.

> > The only case where we are not checking the counts is for the case above
> > where we clear it due to us being too close to the watermark. In that case
> > we want to just ignore the request anyway.
> > 
> > > > +zone_not_complete:
> > > > +	spin_unlock_irq(&zone->lock);
> > > > +
> > > > +	return refcnt;
> > > > +}
> > > > +
> > > > +static void page_reporting_process(struct work_struct *work)
> > > > +{
> > > > +	struct delayed_work *d_work = to_delayed_work(work);
> > > > +	struct page_reporting_dev_info *prdev =
> > > > +		container_of(d_work, struct page_reporting_dev_info, work);
> > > > +	struct zone *zone = first_online_pgdat()->node_zones;
> > > > +	int refcnt = -1;
> > > > +
> > > > +	do {
> > > > +		if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
> > > > +			refcnt = page_reporting_process_zone(prdev, zone);
> > > > +
> > > > +		/* Move to next zone, if at end of list start over */
> > > > +		zone = next_zone(zone) ? : first_online_pgdat()->node_zones;
> > > > +
> > > > +		/*
> > > > +		 * As long as refcnt has not reached zero there are still
> > > > +		 * zones to be processed.
> > > > +		 */
> > > > +	} while (refcnt);
> > > > +}
> > > > +
> > > 
> > > This is being done from a workqueue context and potentially this runs
> > > forever if the refcnt remains elevated. It's dangerous and should be in
> > > it's own patch. In the basic implementation, just do a single pass of
> > > all zones.
> > 
> > So I already have a modification that I have for the next version of the
> > patch set where instead of doing a do/while I simply reschedule the
> > delayed work to run again in 200ms if we still have work outstanding.
> > 
> 
> That would be a bit more reasonable. It would probably remove the need
> for the refcount entirely but either way -- split out the optimisations.
> Otherwise the entirity of the feature has to be re-reviewed every time
> which is time consuming.

Okay.

> > What I can do is split that out so that it is in the second patch with
> > optimizations.
> > 
> 
> One patch per optimisation please with data backing it up because it should
> be possible to show that pages are reported faster or that overhead is
> much lower. It would give a hint on whether the complexity is justified,
> particularly if the locking is subtle.

Okay, got it.

> > > > +/* request page reporting on this zone */
> > > > +void __page_reporting_request(struct zone *zone)
> > > > +{
> > > > +	struct page_reporting_dev_info *prdev;
> > > > +
> > > > +	rcu_read_lock();
> > > > +
> > > > +	/*
> > > > +	 * We use RCU to protect the pr_dev_info pointer. In almost all
> > > > +	 * cases this should be present, however in the unlikely case of
> > > > +	 * a shutdown this will be NULL and we should exit.
> > > > +	 */
> > > > +	prdev = rcu_dereference(pr_dev_info);
> > > > +	if (unlikely(!prdev))
> > > > +		goto out;
> > > > +
> > > > +	/*
> > > > +	 * We can use separate test and set operations here as there
> > > > +	 * is nothing else that can set or clear this bit while we are
> > > > +	 * holding the zone lock. The advantage to doing it this way is
> > > > +	 * that we don't have to dirty the cacheline unless we are
> > > > +	 * changing the value.
> > > > +	 */
> > > > +	__set_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags);
> > > > +
> > > 
> > > The comment implies that the bit should have been tested first.
> > 
> > It was in the page_reporting_notify_free() call. I can update the comment.
> > 
> 
> But not the registration path (which probably doesn't matter). What is
> much more critical is that again you are relying on the zone lock for
> protection and correctness of a tiny micro-optimisation. Page reporting
> really must not rely on the zone lock for anything outside of the free
> list. We've already had a massive headache with mmap_sem protecting way
> too much unnecessarily, we don't need a new one with zone that might
> make it very difficult to break up that lock in the future.

So the main use of the zone lock is for the nr_free values,
reported_pages, and the REPORTING_REQUESTED flag. I had lumped them
together under the zone lock as they were already all being used together
anyway.

Adding another lock would likely just add more complexity since then we
have to worry about lock inversions and such. That was one motivation for
not taking that approach.

> > > > +	/*
> > > > +	 * Delay the start of work to allow a sizable queue to
> > > > +	 * build. For now we are limiting this to running no more
> > > > +	 * than 5 times per second.
> > > > +	 */
> > > > +	if (!atomic_fetch_inc(&prdev->refcnt))
> > > > +		schedule_delayed_work(&prdev->work, HZ / 5);
> > > 
> > > The refcnt is incremented whether this zone has already been requested or
> > > not but only decremented when the bit is cleared so the refcnt potentially
> > > remains elevated forever.
> > 
> > So this is one of the reasons why all accesses to the flag are protected
> > by the zone lock.  Basically page_reporting_notify_free() and this function
> > are both called with the zone lock held.
> > 
> 
> This is extremely subtle and again, it's really not what zone lock is
> for. It's too fragile but maybe refcnt is going away anyway. If not,
> make a separate lock and document what it's protecting in the patch
> introducing the optimisation.

Again the problem is I have 3 elements that I have to keep in sync. In the
case of the page_reporting_notify_free I wouldn't be able to drop the zone
lock without either adding additional complexity to the page freeing path.

> > The only other caller of this function is page_reporting_register which
> > calls it for each populated zone. I suppose I could make it for every zone
> > since it is possible that someone unloaded the driver, unpopulated a zone,
> > and then reloaded the driver, but anyway the idea is that the zone lock is
> > keeping the flag and refcount consistent.
> > 
> 
> I think you can guess at this point what I'll say about zone lock.

I get that you don't like the use of the zone lock but the problem is I am
not sure there is a good way for the reported_pages and flag to stay in
sync without it. I could do away with the flag if that is what we really
want but then I am still stuck using the zone lock as I have to either
walk the lists or read the nr_free from the free area to determine if a
zone has to be processed.

> > > > +#define PAGE_REPORTING_MIN_ORDER	pageblock_order
> > > 
> > > This is potentially the same as MAX_ORDER-1. Not sure if it matters or
> > > not.
> > 
> > It doesn't. Basically what I am going for is the largest order that it is
> > safe to report on that will not break THP. If THP is not enabled then this
> > value should be MAX_ORDER - 1 if I am not mistaken.
> > 
> 
> Well, it's more about huge pages but yes, if you're ok with the
> possibility that reporting only happens for the largest possible page
> then that's fine.
> 
> > > > +	/* Limit notifications only to higher order pages */
> > > > +	report_order = order - PAGE_REPORTING_MIN_ORDER;
> > > > +	if (report_order < 0)
> > > > +		return 0;
> > > > +
> > > > +	nr_free = zone->free_area[order].nr_free;
> > > > +
> > > > +	/* Only subtract reported_pages count if it is present */
> > > > +	if (!zone->reported_pages)
> > > > +		return nr_free;
> > > > +
> > > > +	return nr_free - zone->reported_pages[report_order];
> > > > +}
> > > 
> > > Initially, this should be a full list traversal because I'm not
> > > convinced the reported_pages count is kept perfectly in sync. The
> > > optimisation confuses the review of the basic feature itself.
> > 
> > This is called per freed page in page_reporting_notify_free below. Are you
> > saying I have to traverse the entire free list per freed page?
> > 
> 
> In a basic unoptimised version -- yes. Put optimisations in separate
> patches because then the basic feature itself can be reviewed and
> commented upon. It'll also make it easier to understand any special
> locking requirements for state.
> 
> > If that is what you are wanting I would still probably want to limit it
> > such that we only walk the first PAGE_REPORTING_HWM worth of pages and if
> > those are not reported then just report that many.
> > 
> 
> Which in itself could be an optimisation patch. Maybe it'll be enough that
> keeping track of the count is not worthwhile. Either way, the separate
> patch could have supporting data on how much it improves the speed of
> reporting pages so it can be compared to any other optimisation that
> may be proposed. Supporting data would also help make the case that any
> complexity introduced by the optimisation is worthwhile.

I'll see what I can do to break this apart. I'm just not a fan of redoing
the work multiple times so that I can have a non-optimized version versus
an optimized one.

I'll also go take a look over the work scheduler. It is possible that
maybe I can get away from some of the refcount stuff if the scheduling of
delayed work takes care of it for me.

