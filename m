Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E7E120F49
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 17:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfLPQWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 11:22:53 -0500
Received: from mga05.intel.com ([192.55.52.43]:38295 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfLPQWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 11:22:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 08:22:53 -0800
X-IronPort-AV: E=Sophos;i="5.69,322,1571727600"; 
   d="scan'208";a="217212376"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 08:22:52 -0800
Message-ID: <9eb9173278370dd604c4cefd30ed10be36600854.camel@linux.intel.com>
Subject: Re: [PATCH v15 3/7] mm: Add function __putback_isolated_page
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Mon, 16 Dec 2019 08:22:52 -0800
In-Reply-To: <cb49bbc7-b0c0-65cc-1d9d-a3aaef075650@redhat.com>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
         <20191205162230.19548.70198.stgit@localhost.localdomain>
         <cb49bbc7-b0c0-65cc-1d9d-a3aaef075650@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-12-16 at 12:36 +0100, David Hildenbrand wrote:
> [...]
> > +/**
> > + * __putback_isolated_page - Return a now-isolated page back where we got it
> > + * @page: Page that was isolated
> > + * @order: Order of the isolated page
> > + *
> > + * This function is meant to return a page pulled from the free lists via
> > + * __isolate_free_page back to the free lists they were pulled from.
> > + */
> > +void __putback_isolated_page(struct page *page, unsigned int order)
> > +{
> > +	struct zone *zone = page_zone(page);
> > +	unsigned long pfn;
> > +	unsigned int mt;
> > +
> > +	/* zone lock should be held when this function is called */
> > +	lockdep_assert_held(&zone->lock);
> > +
> > +	pfn = page_to_pfn(page);
> > +	mt = get_pfnblock_migratetype(page, pfn);
> 
> IMHO get_pageblock_migratetype() would be nicer - I guess the compiler
> will optimize out the double page_to_pfn().

The thing is I need the page_to_pfn call already in order to pass the
value to __free_one_page. With that being the case why not juse use
get_pfnblock_migratetype?

Also there are some scenarios where __page_to_pfn is not that simple a
call with us having to get the node ID so we can find the pgdat structure
to perform the calculation. I'm not sure the compiler would be ble to
figure out that the result is the same for both calls, so it is better to
make it explicit.

> > +
> > +	/* Return isolated page to tail of freelist. */
> > +	__free_one_page(page, pfn, zone, order, mt);
> > +}
> > +
> >  /*
> >   * Update NUMA hit/miss statistics
> >   *
> > diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> > index 04ee1663cdbe..d93d2be0070f 100644
> > --- a/mm/page_isolation.c
> > +++ b/mm/page_isolation.c
> > @@ -134,13 +134,11 @@ static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
> >  		__mod_zone_freepage_state(zone, nr_pages, migratetype);
> >  	}
> >  	set_pageblock_migratetype(page, migratetype);
> > +	if (isolated_page)
> > +		__putback_isolated_page(page, order);
> >  	zone->nr_isolate_pageblock--;
> >  out:
> >  	spin_unlock_irqrestore(&zone->lock, flags);
> > -	if (isolated_page) {
> > -		post_alloc_hook(page, order, __GFP_MOVABLE);
> > -		__free_pages(page, order);
> > -	}
> 
> So If I get it right:
> 
> post_alloc_hook() does quite some stuff like
> - arch_alloc_page(page, order);
> - kernel_map_pages(page, 1 << order, 1)
> - kasan_alloc_pages()
> - kernel_poison_pages(1)
> - set_page_owner()
> 
> Which free_pages_prepare() will undo, like
> - reset_page_owner()
> - kernel_poison_pages(0)
> - arch_free_page()
> - kernel_map_pages()
> - kasan_free_nondeferred_pages()
> 
> Both would be skipped now - which sounds like the right thing to do IMHO
> (and smells like quite a performance improvement). I haven't verified if
> actually everything we skip in free_pages_prepare() is safe (I think it
> is, it seems to be mostly relevant for actually used/allocated pages).

That was kind of my thought on this. Basically the logic I was following
was that the code path will call move_freepages_block that bypasses all of
the above mentioned calls if the pages it is moving will not be merged. If
it is safe in that case my assumption is that it should be safe to just
call __putback_isolated_page in such a case as it also bypasses the block
above, but it supports merging the page with other pages that are already
on the freelist.

