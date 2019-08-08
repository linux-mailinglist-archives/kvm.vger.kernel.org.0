Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE0486540
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 17:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732938AbfHHPLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 11:11:30 -0400
Received: from mga06.intel.com ([134.134.136.31]:2940 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732446AbfHHPLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 11:11:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 08:11:27 -0700
X-IronPort-AV: E=Sophos;i="5.64,361,1559545200"; 
   d="scan'208";a="350202217"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 08:11:27 -0700
Message-ID: <f721f0642c3eff7bf2d07110e16cc4ce199ab23a.camel@linux.intel.com>
Subject: Re: [PATCH v4 4/6] mm: Introduce Reported pages
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Date:   Thu, 08 Aug 2019 08:11:27 -0700
In-Reply-To: <ad008459-5618-0859-82cb-6cc7c8e5dcc4@redhat.com>
References: <20190807224037.6891.53512.stgit@localhost.localdomain>
         <20190807224206.6891.81215.stgit@localhost.localdomain>
         <ad008459-5618-0859-82cb-6cc7c8e5dcc4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-08-08 at 09:45 -0400, Nitesh Narayan Lal wrote:
> On 8/7/19 6:42 PM, Alexander Duyck wrote:
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
> >  mm/page_alloc.c                |  136 +++++++++++++++++
> >  mm/page_reporting.c            |  313 ++++++++++++++++++++++++++++++++++++++++
> >  8 files changed, 637 insertions(+), 8 deletions(-)
> >  create mode 100644 include/linux/page_reporting.h
> >  create mode 100644 mm/page_reporting.c
> > 
> > 

<snip>

> > diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> > new file mode 100644
> > index 000000000000..ae26dd77bce9
> > --- /dev/null
> > +++ b/mm/page_reporting.c
> > @@ -0,0 +1,313 @@

<snip>

> > +/*
> > + * The page reporting cycle consists of 4 stages, fill, report, drain, and idle.
> > + * We will cycle through the first 3 stages until we fail to obtain any
> > + * pages, in that case we will switch to idle.
> > + */
> > +static void page_reporting_cycle(struct zone *zone,
> > +				 struct page_reporting_dev_info *phdev)
> > +{
> > +	/*
> > +	 * Guarantee boundaries and stats are populated before we
> > +	 * start placing reported pages in the zone.
> > +	 */
> > +	if (page_reporting_populate_metadata(zone))
> > +		return;
> > +
> > +	spin_lock(&zone->lock);
> > +
> > +	/* set bit indicating boundaries are present */
> > +	__set_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags);
> > +
> > +	do {
> > +		/* Pull pages out of allocator into a scaterlist */
> > +		unsigned int nents = page_reporting_fill(zone, phdev);
> > +
> > +		/* no pages were acquired, give up */
> > +		if (!nents)
> > +			break;
> > +
> > +		spin_unlock(&zone->lock);
> > +
> > +		/* begin processing pages in local list */
> > +		phdev->report(phdev, nents);
> > +
> > +		spin_lock(&zone->lock);
> > +
> > +		/*
> > +		 * We should have a scatterlist of pages that have been
> > +		 * processed. Return them to their original free lists.
> > +		 */
> > +		page_reporting_drain(zone, phdev);
> > +
> > +		/* keep pulling pages till there are none to pull */
> > +	} while (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags));
> > +
> > +	/* processing of the zone is complete, we can disable boundaries */
> > +	__clear_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags);
> > +
> > +	spin_unlock(&zone->lock);
> > +}
> > +
> > +static void page_reporting_process(struct work_struct *work)
> > +{
> > +	struct delayed_work *d_work = to_delayed_work(work);
> > +	struct page_reporting_dev_info *phdev =
> > +		container_of(d_work, struct page_reporting_dev_info, work);
> > +	struct zone *zone = first_online_pgdat()->node_zones;
> > +
> > +	do {
> > +		if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
> > +			page_reporting_cycle(zone, phdev);
> > +
> > +		/*
> > +		 * Move to next zone, if at the end of the list
> > +		 * test to see if we can just go into idle.
> > +		 */
> > +		zone = next_zone(zone);
> > +		if (zone)
> > +			continue;
> > +		zone = first_online_pgdat()->node_zones;
> > +
> > +		/*
> > +		 * As long as refcnt has not reached zero there are still
> > +		 * zones to be processed.
> > +		 */
> 
> can you please explain the reason why you are not using
> for_each_populated_zone() here?
> 
> 
> > +	} while (atomic_read(&phdev->refcnt));
> > +}
> > +

It mostly has to do with the way this code evolved. Originally I had this
starting at the last zone that was processed and resuming there with the
assumption that a noisy zone was going to trigger frequent events so why
walk the zones each time. However we aren't starting the loop that often
so I just decided to start at the beginning and walk the zones until I
found the one that had requested the reporting.

Also I probably wouldn't bother with the "populated" version of the call
since we already have a field to search for so it would just be a matter
of creating my own macro that would only give us zones that are requesting
reporting.

The last bit is that really the exit condition isn't that we hit the end
of the zone list. The exit condition for this loop is that phdev->refcnt
is zero. The problem with using for_each_zone is that you would keep
walking the zone list anyway until you hit the end of it even if we have
already processed the zones that requested reporting.

