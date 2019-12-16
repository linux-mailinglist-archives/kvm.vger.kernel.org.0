Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40040120F94
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 17:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfLPQeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 11:34:14 -0500
Received: from mga14.intel.com ([192.55.52.115]:56463 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfLPQeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 11:34:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 08:10:11 -0800
X-IronPort-AV: E=Sophos;i="5.69,322,1571727600"; 
   d="scan'208";a="389503026"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 08:10:11 -0800
Message-ID: <0a7a6e978960fd6d02a7ba2584d72e58fe1b3a05.camel@linux.intel.com>
Subject: Re: [PATCH v15 4/7] mm: Introduce Reported pages
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, konrad.wilk@oracle.com, david@redhat.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Mon, 16 Dec 2019 08:10:11 -0800
In-Reply-To: <34abf700-bdb0-e01b-c7c2-3eab8d058c22@redhat.com>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
         <20191205162238.19548.68238.stgit@localhost.localdomain>
         <34abf700-bdb0-e01b-c7c2-3eab8d058c22@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-12-16 at 06:44 -0500, Nitesh Narayan Lal wrote:
> On 12/5/19 11:22 AM, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > In order to pave the way for free page reporting in virtualized
> > environments we will need a way to get pages out of the free lists and
> > identify those pages after they have been returned. To accomplish this,
> > this patch adds the concept of a Reported Buddy, which is essentially
> > meant to just be the Uptodate flag used in conjunction with the Buddy
> > page type.
> > 
> > To prevent the reported pages from leaking outside of the buddy lists I
> > added a check to clear the PageReported bit in the del_page_from_free_list
> > function. As a result any reported page that is split, merged, or
> > allocated will have the flag cleared prior to the PageBuddy value being
> > cleared.
> > 
> > The process for reporting pages is fairly simple. Once we free a page that
> > meets the minimum order for page reporting we will schedule a worker thread
> > to start 2s or more in the future. That worker thread will begin working
> > from the lowest supported page reporting order up to MAX_ORDER - 1 pulling
> > unreported pages from the free list and storing them in the scatterlist.
> > 
> > When processing each individual free list it is necessary for the worker
> > thread to release the zone lock when it needs to stop and report the full
> > scatterlist of pages. To reduce the work of the next iteration the worker
> > thread will rotate the free list so that the first unreported page in the
> > free list becomes the first entry in the list.
> 
> [...]
> 
> > k);
> > +
> > +	return err;
> > +}
> > +
> > +static int
> > +page_reporting_process_zone(struct page_reporting_dev_info *prdev,
> > +			    struct scatterlist *sgl, struct zone *zone)
> > +{
> > +	unsigned int order, mt, leftover, offset = PAGE_REPORTING_CAPACITY;
> > +	unsigned long watermark;
> > +	int err = 0;
> > +
> > +	/* Generate minimum watermark to be able to guarantee progress */
> > +	watermark = low_wmark_pages(zone) +
> > +		    (PAGE_REPORTING_CAPACITY << PAGE_REPORTING_MIN_ORDER);
> > +
> > +	/*
> > +	 * Cancel request if insufficient free memory or if we failed
> > +	 * to allocate page reporting statistics for the zone.
> > +	 */
> > +	if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA))
> > +		return err;
> > +
> 
> Will it not make more sense to check the low watermark condition before every
> reporting request generated for a bunch of 32 isolated pages?
> or will that be too costly?

My thought is to wait until we are actually processing the request. That
way we are only performing this check once every 2 seconds instead of
every time we are thinking about requesting page reporting.

Keep in mind I removed the reported_pages tracking statistics so we now
are requesting as soon as we free any page. So if we moved the check tot
he request itself it would mean that a low memory condition would result
in us repeatedly checking the low water mark and failing the test.

