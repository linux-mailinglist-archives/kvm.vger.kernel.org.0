Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4376976F34
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 18:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfGZQlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 12:41:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:37330 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbfGZQlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 12:41:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 09:38:08 -0700
X-IronPort-AV: E=Sophos;i="5.64,311,1559545200"; 
   d="scan'208";a="175655606"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 09:38:08 -0700
Message-ID: <c59c6c9a5bb77d517336e3fc3b17eebd0f294276.camel@linux.intel.com>
Subject: Re: [PATCH v2 4/5] mm: Introduce Hinted pages
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com
Date:   Fri, 26 Jul 2019 09:38:08 -0700
In-Reply-To: <49a49a38-b1f4-d5c0-f5f1-a6bed57a03d2@redhat.com>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
         <20190724170259.6685.18028.stgit@localhost.localdomain>
         <49a49a38-b1f4-d5c0-f5f1-a6bed57a03d2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-07-26 at 08:24 -0400, Nitesh Narayan Lal wrote:
> On 7/24/19 1:03 PM, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > 

<snip>

> > +/*
> > + * The page hinting cycle consists of 4 stages, fill, react, drain, and idle.
> > + * We will cycle through the first 3 stages until we fail to obtain any
> > + * pages, in that case we will switch to idle.
> > + */
> > +static void page_hinting_cycle(struct zone *zone,
> > +			       struct page_hinting_dev_info *phdev)
> > +{
> > +	/*
> > +	 * Guarantee boundaries and stats are populated before we
> > +	 * start placing hinted pages in the zone.
> > +	 */
> > +	if (page_hinting_populate_metadata(zone))
> > +		return;
> > +
> > +	spin_lock(&zone->lock);
> > +
> > +	/* set bit indicating boundaries are present */
> > +	set_bit(ZONE_PAGE_HINTING_ACTIVE, &zone->flags);
> > +
> > +	do {
> > +		/* Pull pages out of allocator into a scaterlist */
> > +		unsigned int num_hints = page_hinting_fill(zone, phdev);
> > +
> > +		/* no pages were acquired, give up */
> > +		if (!num_hints)
> > +			break;
> > +
> > +		spin_unlock(&zone->lock);
> 
> Is there any recommendation in general about how/where we should lock and unlock
> zones in the code? For instance, over here you have a zone lock outside the loop
> and you are unlocking it inside the loop and then re-acquiring it.
> My guess is we should be fine as long as:
> 1. We are not holding the lock for a very long time.
> 2. We are making sure that if we have a zone lock we are releasing it before
> returning from the function.

So as a general rule the first two you mention work. Basically what you
want to do is work with some sort of bounded limit when you are holding
the lock so you know it will be released in a timely fashion.

The reason for dropping the lock inside of the loop s because we will end
up sleeping while we wait for the virtio-balloon device to process the
pages. So it makes sense to release the lock, process the pages, and then
reacquire the lock so that we can return the pages and grab another 16
pages.

