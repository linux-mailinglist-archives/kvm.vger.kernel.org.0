Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368F6168768
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 20:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgBUTZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 14:25:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:31811 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgBUTZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 14:25:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 11:25:50 -0800
X-IronPort-AV: E=Sophos;i="5.70,469,1574150400"; 
   d="scan'208";a="316143032"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 11:25:50 -0800
Message-ID: <2e4ff237de090dd4760995d948b9a1788c2f351d.camel@linux.intel.com>
Subject: Re: [PATCH v17 4/9] mm: Introduce Reported pages
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        david@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org, vbabka@suse.cz,
        osalvador@suse.de
Date:   Fri, 21 Feb 2020 11:25:49 -0800
In-Reply-To: <20200220223508.GX3466@techsingularity.net>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
         <20200211224635.29318.19750.stgit@localhost.localdomain>
         <20200219145511.GS3466@techsingularity.net>
         <7d3c732d9ec7725dcb5a90c1dc8e9859fbe6ccc0.camel@linux.intel.com>
         <20200220223508.GX3466@techsingularity.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-02-20 at 22:35 +0000, Mel Gorman wrote:
> On Thu, Feb 20, 2020 at 10:44:21AM -0800, Alexander Duyck wrote:
> > > > +static int
> > > > +page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
> > > > +		     unsigned int order, unsigned int mt,
> > > > +		     struct scatterlist *sgl, unsigned int *offset)
> > > > +{
> > > > +	struct free_area *area = &zone->free_area[order];
> > > > +	struct list_head *list = &area->free_list[mt];
> > > > +	unsigned int page_len = PAGE_SIZE << order;
> > > > +	struct page *page, *next;
> > > > +	int err = 0;
> > > > +
> > > > +	/*
> > > > +	 * Perform early check, if free area is empty there is
> > > > +	 * nothing to process so we can skip this free_list.
> > > > +	 */
> > > > +	if (list_empty(list))
> > > > +		return err;
> > > > +
> > > > +	spin_lock_irq(&zone->lock);
> > > > +
> > > > +	/* loop through free list adding unreported pages to sg list */
> > > > +	list_for_each_entry_safe(page, next, list, lru) {
> > > > +		/* We are going to skip over the reported pages. */
> > > > +		if (PageReported(page))
> > > > +			continue;
> > > > +
> > > > +		/* Attempt to pull page from list */
> > > > +		if (!__isolate_free_page(page, order))
> > > > +			break;
> > > > +
> > > 
> > > Might want to note that you are breaking because the only reason to fail
> > > the isolation is that watermarks are not met and we are likely under
> > > memory pressure. It's not a big issue.
> > > 
> > > However, while I think this is correct, it's hard to follow. This loop can
> > > be broken out of with pages still on the scatter gather list. The current
> > > flow guarantees that err will not be set at this point so the caller
> > > cleans it up so we always drain the list either here or in the caller.
> > 
> > I can probably submit a follow-up patch to update the comments. The reason
> > for not returning an error is because I didn't consider it an error that
> > we encountered the watermark and were not able to pull any more pages.
> > Instead I considered that the "stop" point for this pass and have it just
> > exit out of the loop and flush the data.
> > 
> 
> I don't consider it an error and I don't think you should return an
> error. The comment just needs to explain that the draining happens in
> the caller in this case. That should be enough of a warning to a future
> developer to double check the flow after any changes to make sure the
> drain is reached.

The comment I can do, that shouldn't be an issue. The point I was getting
at is that a separate drain call is expected for this any time the
function is not returning an error, and the only way it can return an
error is if there was a reporting issue.

> > > While I think it works, it's a bit fragile. I recommend putting a comment
> > > above this noting why it's safe and put a VM_WARN_ON_ONCE(err) before the
> > > break in case someone tries to change this in a years time and does not
> > > spot that the flow to reach page_reporting_drain *somewhere* is critical.
> > 
> > I assume this isn't about this section, but the section below?
> > 
> 
> I meant something like
> 
> if (!__isolate_free_page(page, order)) {
> 	VM_WARN_ON_ONCE(err);
> 	break;
> }
> 
> Because at this point it's possible there are entries that should go
> through page_reporting_drain() but the caller will not call
> page_reporting_drain() in the event of an error.

I would think adding that would confuse things even more. There is a break
statement at the end of the loop that will break out if err is set. So we
should never hit the VM_WARN_ON_ONCE because err should always be 0 before
we even attempt to isolate the page. I think something like the following
would probably make more sense:

        err = page_reporting_cycle(prdev, zone, order, mt,
                                   sgl, &offset);
        if (err) {
                /*
                 * We should have drained the scatterlist
                 * prior to exiting page_reporting_cycle if
                 * we encountered an error. If we did not
                 * then this could result in a memory leak.
                 * Verify that the end of the scatterlist
                 * was cleared prior to us getting here.
                 */
                sgl = &sgl[PAGE_REPORTING_CAPACITY - 1];
                VM_WARN_ON_ONCE(sg_page(sgl));
                return err;
        }

With that we are more-or-less making certain that they called
page_reporting_drain which will zero the scatterlist.

