Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA1612325F
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 17:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfLQQ0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 11:26:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:60305 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728179AbfLQQ0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 11:26:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 08:26:09 -0800
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="389882638"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 08:26:09 -0800
Message-ID: <753e2991e3e632b9c179c45197bfb05669625e9a.camel@linux.intel.com>
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
Date:   Tue, 17 Dec 2019 08:26:09 -0800
In-Reply-To: <8a4b0337-0bad-2978-32e8-6f90c7365f00@redhat.com>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
         <20191205162230.19548.70198.stgit@localhost.localdomain>
         <cb49bbc7-b0c0-65cc-1d9d-a3aaef075650@redhat.com>
         <9eb9173278370dd604c4cefd30ed10be36600854.camel@linux.intel.com>
         <8a4b0337-0bad-2978-32e8-6f90c7365f00@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-12-17 at 11:58 +0100, David Hildenbrand wrote:
> On 16.12.19 17:22, Alexander Duyck wrote:
> > On Mon, 2019-12-16 at 12:36 +0100, David Hildenbrand wrote:
> > > [...]
> > > > +/**
> > > > + * __putback_isolated_page - Return a now-isolated page back where we got it
> > > > + * @page: Page that was isolated
> > > > + * @order: Order of the isolated page
> > > > + *
> > > > + * This function is meant to return a page pulled from the free lists via
> > > > + * __isolate_free_page back to the free lists they were pulled from.
> > > > + */
> > > > +void __putback_isolated_page(struct page *page, unsigned int order)
> > > > +{
> > > > +	struct zone *zone = page_zone(page);
> > > > +	unsigned long pfn;
> > > > +	unsigned int mt;
> > > > +
> > > > +	/* zone lock should be held when this function is called */
> > > > +	lockdep_assert_held(&zone->lock);
> > > > +
> > > > +	pfn = page_to_pfn(page);
> > > > +	mt = get_pfnblock_migratetype(page, pfn);
> > > 
> > > IMHO get_pageblock_migratetype() would be nicer - I guess the compiler
> > > will optimize out the double page_to_pfn().
> > 
> > The thing is I need the page_to_pfn call already in order to pass the
> > value to __free_one_page. With that being the case why not juse use
> > get_pfnblock_migratetype?
> 
> I was reading
> 	set_pageblock_migratetype(page, migratetype);
> And wondered why we don't use straight forward
> 	get_pageblock_migratetype()
> but instead something that looks like a micro-optimization

So there ends up being a some other optimizations you may not have
noticed.

For instance, the fact that get_pfnblock_migratetype is an inline
function, whereas get_pageblock_migratetype calls get_pfnblock_flags_mask
which is not an inline function. So you end up having to take the overhead
for a call/return.

I hadn't noticed that myself until taking a look at the code.

> > Also there are some scenarios where __page_to_pfn is not that simple a
> > call with us having to get the node ID so we can find the pgdat structure
> > to perform the calculation. I'm not sure the compiler would be ble to
> > figure out that the result is the same for both calls, so it is better to
> > make it explicit.
> 
> Only in case of CONFIG_SPARSEMEM we have to go via the section - but I
> doubt this is really worth optimizing here.
> 
> But yeah, I'm fine with this change, only "IMHO
> get_pageblock_migratetype() would be nicer" :)

Aren't most distros running with CONFIG_SPARSEMEM enabled? If that is the
case why not optimize for it?

As I stated earlier, in my case I already have to pull out the PFN as a
part of freeing the page anyway, so why not reuse the value instead of
having it be computed twice? It is in keeping with how the other handlers
are dealing with this such as free_one_page, __free_pages_ok, and
free_unref_page_prepare. I suspect it has to do with the fact that it is
an inline like I pointed out above.

> > > > +
> > > > +	/* Return isolated page to tail of freelist. */
> > > > +	__free_one_page(page, pfn, zone, order, mt);
> > > > +}
> > > > +
> > > >  /*
> > > >   * Update NUMA hit/miss statistics
> > > >   *
> > > > diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> > > > index 04ee1663cdbe..d93d2be0070f 100644
> > > > --- a/mm/page_isolation.c
> > > > +++ b/mm/page_isolation.c
> > > > @@ -134,13 +134,11 @@ static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
> > > >  		__mod_zone_freepage_state(zone, nr_pages, migratetype);
> > > >  	}
> > > >  	set_pageblock_migratetype(page, migratetype);
> > > > +	if (isolated_page)
> > > > +		__putback_isolated_page(page, order);
> > > >  	zone->nr_isolate_pageblock--;
> > > >  out:
> > > >  	spin_unlock_irqrestore(&zone->lock, flags);
> > > > -	if (isolated_page) {
> > > > -		post_alloc_hook(page, order, __GFP_MOVABLE);
> > > > -		__free_pages(page, order);
> > > > -	}
> > > 
> > > So If I get it right:
> > > 
> > > post_alloc_hook() does quite some stuff like
> > > - arch_alloc_page(page, order);
> > > - kernel_map_pages(page, 1 << order, 1)
> > > - kasan_alloc_pages()
> > > - kernel_poison_pages(1)
> > > - set_page_owner()
> > > 
> > > Which free_pages_prepare() will undo, like
> > > - reset_page_owner()
> > > - kernel_poison_pages(0)
> > > - arch_free_page()
> > > - kernel_map_pages()
> > > - kasan_free_nondeferred_pages()
> > > 
> > > Both would be skipped now - which sounds like the right thing to do IMHO
> > > (and smells like quite a performance improvement). I haven't verified if
> > > actually everything we skip in free_pages_prepare() is safe (I think it
> > > is, it seems to be mostly relevant for actually used/allocated pages).
> > 
> > That was kind of my thought on this. Basically the logic I was following
> > was that the code path will call move_freepages_block that bypasses all of
> > the above mentioned calls if the pages it is moving will not be merged. If
> > it is safe in that case my assumption is that it should be safe to just
> > call __putback_isolated_page in such a case as it also bypasses the block
> > above, but it supports merging the page with other pages that are already
> > on the freelist.
> 
> Makes sense to me
> 
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks. I will add the Ack to the patch for v16.

