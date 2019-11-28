Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A3210C5E4
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 10:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfK1JWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 04:22:38 -0500
Received: from outbound-smtp10.blacknight.com ([46.22.139.15]:48836 "EHLO
        outbound-smtp10.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbfK1JWi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 04:22:38 -0500
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp10.blacknight.com (Postfix) with ESMTPS id 410F71C2AA8
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 09:22:35 +0000 (GMT)
Received: (qmail 19193 invoked from network); 28 Nov 2019 09:22:35 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.18.57])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 28 Nov 2019 09:22:34 -0000
Date:   Thu, 28 Nov 2019 09:22:32 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        vbabka@suse.cz, yang.zhang.wz@gmail.com, nitesh@redhat.com,
        konrad.wilk@oracle.com, david@redhat.com, pagupta@redhat.com,
        riel@surriel.com, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, osalvador@suse.de
Subject: Re: [PATCH v14 3/6] mm: Introduce Reported pages
Message-ID: <20191128092231.GH3016@techsingularity.net>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214633.24996.46821.stgit@localhost.localdomain>
 <20191127152422.GE3016@techsingularity.net>
 <0ec9b67cb45cd30f0ff0b2e9dcbc41602de1c178.camel@linux.intel.com>
 <20191127183524.GF3016@techsingularity.net>
 <6aae7be8a84e7f0622c1f7fd362e4f213aea383d.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <6aae7be8a84e7f0622c1f7fd362e4f213aea383d.camel@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 27, 2019 at 01:55:02PM -0800, Alexander Duyck wrote:
> > > > > +	/*
> > > > > +	 * Upper limit on the number of pages that the report function
> > > > > +	 * expects to be placed into the scatterlist to be processed.
> > > > > +	 */
> > > > > +	unsigned int capacity;
> > > > > +
> > > > 
> > > > Instead of requiring the driver to specify capacity, why did you not
> > > > simply make it PAGE_REPORTING_HWM and statically declare the array?
> > > 
> > > The problem is the device might not be able to support PAGE_REPORTING_HWM.
> > 
> > I don't see why given that a driver that cannot handle PAGE_REPORTING_HWM
> > could process subsets of the pages reported. It seems unnecessary.
> 
> I suppose it might be considered an optimization. Basically what I was
> wanting to avoid is pulling out more pages then the device can process in
> a single call. That is what the capacity represents. Basically the virtio
> device can have a limited ring size which limits how many pages we can
> have outstanding at a time. So I wanted to avoid pulling pages that I
> couldn't immediately report.
> 

Given that the first user of this is part of the same series, I think
it's reasonable to only consider its limitations and keep it relatively
simple. We don't know what additional users, if any, may exist. Even if
they do, notifiers will need to be chained and there will be additional
work necessary no matter what way we jump now.

> > > So I needed some way for it to communicate that. I could allocate the
> > > array statically if that is what you prefer.
> > > 
> > 
> > It would make sense if it's a fixed size and let drivers figure out whether
> > the full array can be processed at once or has to be split into parts.
> 
> In terms of allocation the fixed size makes sense to me. I still think it
> would be good to communicate how many the device can process in a single
> request so we don't have pages having to wait as the device has to segment
> the scatterlist to process pieces of it.
> 

If that limitation should arise in the future, it can be considered
then.

> > > > > +	/* The number of zones requesting reporting */
> > > > > +	atomic_t refcnt;
> > > > > +
> > > > 
> > > > The refcnt is overkill. Simply loop over all zones until there is a
> > > > clear pass. Despite being atomic, it actually requires the zone lock to
> > > > avoid races in places like this
> > > > 
> > > > 		if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
> > > > 			refcnt = page_reporting_process_zone(prdev, zone);
> > > > 
> > > > The optimisation is small and it's relatively subtle.
> > > 
> > > I disagree. Without that we can easily get into states where a zone
> > > requests reporting and we never get around to servicing it.
> > 
> > Why would that happen if all zones were iterated during a single pass?
> 
> It is because I am not rescheduling the work while it is ongoing. My
> notifier is using the reference count to only schedule on the first
> request and not stop processing until we reach 0. Without that I have to
> schedule the worker ever time a zone requests processing.
> 

Which in itself is simpler than trying to maintain a coherent refcount
with separate locking. When it gets down to it, a reschedule is not that
bad and it's a lot less subtle.

> > > I am using the
> > > refcount to track that so that we don't shutdown the worker thread when
> > > there is at least one zone requesting service.
> > > 
> > 
> > Then either single pass or loop through all zones until a loop completes
> > with no zones to be processed. It's far simplier than a refcount.
> 
> I could do that if we only had one zone to process. However the problem is
> that we could be processing multiple zones.
> 

Again, not necessarily a problem. There is no data on how much of a
problem, if any, there is with delays in zone processing.

> > > Second, at the point where we call this function with the reported flag
> > > set we have not yet set the page as reported. There is logic that will
> > > check for that later and set the bits and increment the count if the page
> > > becomes a buddy page and the order is still the same as the order we
> > > originally freed it under.
> > > 
> > 
> > That is sufficiently complex that it really should be in its own patch
> > because right now, any bug there would either revert the whole feature
> > or do a partial revert if it couldn't be fixed properly. At least having
> > the option of reverting the optimisation would be useful for testing.
> > By not splitting it out, we're also prevented from being able to ack the
> > basic infrastructure itself. Even if the optimisations could not be agreed
> > upon, the feature would still exist -- just slower than is ideal.
> 
> The only optimization here is the use of the reported variable. That can
> actually go away since I hadn't realized I had changed things in the page
> reporting cycle so that we don't clear the REPORTING_REQUESTED flag until
> after the last drain has completed.
> 
> I'll work on splitting out the reported_pages bit into a separate patch,
> and I will see what I can do about refcount since that seems to be the
> other pain point.
> 

Thanks

> > > > > +static int
> > > > > +page_reporting_process_zone(struct page_reporting_dev_info *prdev,
> > > > > +			    struct zone *zone)
> > > > > +{
> > > > > +	unsigned int order, mt, nents = 0;
> > > > > +	unsigned long watermark;
> > > > > +	int refcnt = -1;
> > > > > +
> > > > > +	page_reporting_populate_metadata(zone);
> > > > > +
> > > > > +	/* Generate minimum watermark to be able to guarantee progress */
> > > > > +	watermark = low_wmark_pages(zone) +
> > > > > +		    (prdev->capacity << PAGE_REPORTING_MIN_ORDER);
> > > > > +
> > > > > +	/*
> > > > > +	 * Cancel request if insufficient free memory or if we failed
> > > > > +	 * to allocate page reporting statistics for the zone.
> > > > > +	 */
> > > > > +	if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA) ||
> > > > > +	    !zone->reported_pages) {
> > > > > +		spin_lock_irq(&zone->lock);
> > > > > +		goto zone_not_ready;
> > > > > +	}
> > > > 
> > > > The zone lock is acquired just for the zone bit and the refcnt? That
> > > > seems drastic overkill because the bit handling is already racy and the
> > > > refcnt is overkill.
> > > 
> > > I'm not sure I follow.
> > > 
> > 
> > The lock is acquired before branching to zone_not_ready for the purpose
> > of clearing a zone bit and updating the ref count. That is hinting at
> > the possibility that zone lock is protecting much more than it should.
> 
> I'm using it to protect the bit and the page counts. Basically I cannot
> rely on the page counts being valid if I am not holding the lock. So in
> order to avoid races between the bit and the page counts I hold the lock
> when I clear the bit.
> 

In the initial step, avoid the page counts and take the hit. I might be
willing to give ground on the zone lock protecting the reported counts
as it is tightly related to the free page count. The zone lock should
definitely not protect the zone flags or refcount because it would make
the zone lock difficult, if not impossible, to split in the future. For
example, the most obvious approach to splitting the zone lock would be
to split it by PFN range within the zone or hash it based on some low
bits in the PFN number. That would be relatively trivial to implement
but impossible if the lock is also protecting zone-wide state such as a
refcount or zone flag. Sure, someone dealing with the zone lock could
try to fix page reporting at the same time but it'll be harder for them
to test and puts an unfortunate obstacle in their way.

> > > > If a request comes in while processing is already happening then the
> > > > subsequent request is lost.
> > > 
> > > How can a request come in when we are holding the zone lock?
> >  
> > page_reporting_cycle drops the lock so there is no obvious guarantee
> > that requests are not lost.
> 
> Yes, but page_reporting_cycle will not clear the bit. It is only cleared
> in this last bleock where we go through and verify the page counts are low
> enough that we can justify clearing the bit.
> 

Ok, that makes some sense although it could do with comments on the
lifecycle of the bit.

> This is what I am talking about in terms of the page counts and the bit
> being synchronized via the lock. Both the notifier and this piece of code
> will not set nor clear the bit without first having to check
> pages_unreported and then either setting or clearing the bit depending on
> if we are the notifier or the reporting process.
> 

But using the zone lock to protect that bit is a hard no because that zone
lock is way too heavy as it is, particularly as zone sizes are growing
ever larger and we now have machine where multiple L3 caches share the
same zone lock which is very expensive to bounce around.

Someone else reviewing might override me on this one as being an
obstacle based on patches that don't exist but I think they would find
it very hard to argue that the zone lock is fine as it is.

> > If necessary, add a separate lock and use it to protect state related to
> > the page reporting but as part of that, you almost certainly will have
> > to move to atomic versions of bit operations for zone flags because it's
> > not protected as such.
> > 
> > Again, it really should be the case that ZONE_PAGE_REPORTING_REQUESTED
> > is split out into a separate patch and introduced standalone. It would
> > probably be on the justification of avoiding unnecessary zone free list
> > searches but still, the optimisation should be reviewed separately and
> > the locking of state should be clear.
> 
> I can look into it. However between this, the removal of the
> reported_pages counters, and the desire to remove the reference count it
> sounds like what we have is essentially just a blind scanner that will
> never really know when it is done and would likely be very lossy.
> 

Well yes, initially that's exactly what it would be. Free page reporting
is not a critical path and the initial implementation should be simple.
That allows it to be determined how much complexity and maintenance
burden is needed to make it a bit faster. Prematurely expanding the
scope of the zone lock is such a maintenance burden.

> > But not the registration path (which probably doesn't matter). What is
> > much more critical is that again you are relying on the zone lock for
> > protection and correctness of a tiny micro-optimisation. Page reporting
> > really must not rely on the zone lock for anything outside of the free
> > list. We've already had a massive headache with mmap_sem protecting way
> > too much unnecessarily, we don't need a new one with zone that might
> > make it very difficult to break up that lock in the future.
> 
> So the main use of the zone lock is for the nr_free values,
> reported_pages, and the REPORTING_REQUESTED flag. I had lumped them
> together under the zone lock as they were already all being used together
> anyway.
> 

reported_pages may not be too bad because it's tightly related to the
free page count and would be updated at the same time that list operations
take place but not other zone-wide state.

> Adding another lock would likely just add more complexity since then we
> have to worry about lock inversions and such. That was one motivation for
> not taking that approach.
> 

Which is a fair reason but it gets hung up on the fact that it makes
splitting the zone lock and free list handling much harder.

> > > > > +	/*
> > > > > +	 * Delay the start of work to allow a sizable queue to
> > > > > +	 * build. For now we are limiting this to running no more
> > > > > +	 * than 5 times per second.
> > > > > +	 */
> > > > > +	if (!atomic_fetch_inc(&prdev->refcnt))
> > > > > +		schedule_delayed_work(&prdev->work, HZ / 5);
> > > > 
> > > > The refcnt is incremented whether this zone has already been requested or
> > > > not but only decremented when the bit is cleared so the refcnt potentially
> > > > remains elevated forever.
> > > 
> > > So this is one of the reasons why all accesses to the flag are protected
> > > by the zone lock.  Basically page_reporting_notify_free() and this function
> > > are both called with the zone lock held.
> > > 
> > 
> > This is extremely subtle and again, it's really not what zone lock is
> > for. It's too fragile but maybe refcnt is going away anyway. If not,
> > make a separate lock and document what it's protecting in the patch
> > introducing the optimisation.
> 
> Again the problem is I have 3 elements that I have to keep in sync. In the
> case of the page_reporting_notify_free I wouldn't be able to drop the zone
> lock without either adding additional complexity to the page freeing path.
> 

It leaks an unnecessary amount of maintenance burden into page_alloc,
which is performance critical, to optimise page reporting which is not
performance critical. Minimally, if zone lock is protecting an entire page
reporting cycle, it's blocking other allocations taking place at the same
time as reporting for an unnecessary length of time and incurring stalls.

> > > The only other caller of this function is page_reporting_register which
> > > calls it for each populated zone. I suppose I could make it for every zone
> > > since it is possible that someone unloaded the driver, unpopulated a zone,
> > > and then reloaded the driver, but anyway the idea is that the zone lock is
> > > keeping the flag and refcount consistent.
> > > 
> > 
> > I think you can guess at this point what I'll say about zone lock.
> 
> I get that you don't like the use of the zone lock but the problem is I am
> not sure there is a good way for the reported_pages and flag to stay in
> sync without it. I could do away with the flag if that is what we really
> want but then I am still stuck using the zone lock as I have to either
> walk the lists or read the nr_free from the free area to determine if a
> zone has to be processed.
> 

I'm not saying the flag needs to go away entirely, just that it should
not share the same lock as the page allocators free list unnecessarily.
Free page reporting can afford to stall or even go to sleep if protected
by a mutex when it's not manipulating free lists even if that means some
duplicate processing may be necessary.

> > 
> > Which in itself could be an optimisation patch. Maybe it'll be enough that
> > keeping track of the count is not worthwhile. Either way, the separate
> > patch could have supporting data on how much it improves the speed of
> > reporting pages so it can be compared to any other optimisation that
> > may be proposed. Supporting data would also help make the case that any
> > complexity introduced by the optimisation is worthwhile.
> 
> I'll see what I can do to break this apart. I'm just not a fan of redoing
> the work multiple times so that I can have a non-optimized version versus
> an optimized one.
> 

While I understand that, right now the optimisations are blocking the
feature itself which is also not a situation you want to be in.

-- 
Mel Gorman
SUSE Labs
