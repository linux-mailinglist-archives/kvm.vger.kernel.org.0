Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A01ADC37
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 17:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbfIIPhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 11:37:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:10639 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbfIIPhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 11:37:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 08:37:46 -0700
X-IronPort-AV: E=Sophos;i="5.64,486,1559545200"; 
   d="scan'208";a="186547593"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 08:37:46 -0700
Message-ID: <64167c3a7b482d9cbeeabd3f5001cf7d357476c5.camel@linux.intel.com>
Subject: Re: [PATCH v9 2/8] mm: Adjust shuffle code to allow for future
 coalescing
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        kirill.shutemov@linux.intel.com
Date:   Mon, 09 Sep 2019 08:37:46 -0700
In-Reply-To: <20190909153529.3crs74uraos27ffh@box>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
         <20190907172520.10910.83100.stgit@localhost.localdomain>
         <20190909094700.bbslsxpuwvxmodal@box>
         <22a896255cba877cf820f552667e1bc14268fa20.camel@linux.intel.com>
         <20190909153529.3crs74uraos27ffh@box>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-09-09 at 18:35 +0300, Kirill A. Shutemov wrote:
> On Mon, Sep 09, 2019 at 08:22:11AM -0700, Alexander Duyck wrote:
> > > > +	area = &zone->free_area[order];
> > > > +	if (is_shuffle_order(order) ? shuffle_pick_tail() :
> > > > +	    buddy_merge_likely(pfn, buddy_pfn, page, order))
> > > 
> > > Too loaded condition to my taste. Maybe
> > > 
> > > 	bool to_tail;
> > > 	...
> > > 	if (is_shuffle_order(order))
> > > 		to_tail = shuffle_pick_tail();
> > > 	else if (buddy_merge_likely(pfn, buddy_pfn, page, order))
> > > 		to_tail = true;
> > > 	else
> > > 		to_tail = false;
> > 
> > I can do that, although I would tweak this slightly and do something more
> > like:
> >         if (is_shuffle_order(order))
> >                 to_tail = shuffle_pick_tail();
> >         else
> >                 to_tail = buddy+_merge_likely(pfn, buddy_pfn, page, order);
> 
> Okay. Looks fine.
> 
> > > 	if (to_tail)
> > > 		add_to_free_area_tail(page, area, migratetype);
> > > 	else
> > > 		add_to_free_area(page, area, migratetype);
> > > 
> > > > +		add_to_free_area_tail(page, area, migratetype);
> > > >  	else
> > > > -		add_to_free_area(page, &zone->free_area[order], migratetype);
> > > > -
> > > > +		add_to_free_area(page, area, migratetype);
> > > >  }
> > > >  
> > > >  /*
> > > > diff --git a/mm/shuffle.c b/mm/shuffle.c
> > > > index 9ba542ecf335..345cb4347455 100644
> > > > --- a/mm/shuffle.c
> > > > +++ b/mm/shuffle.c
> > > > @@ -4,7 +4,6 @@
> > > >  #include <linux/mm.h>
> > > >  #include <linux/init.h>
> > > >  #include <linux/mmzone.h>
> > > > -#include <linux/random.h>
> > > >  #include <linux/moduleparam.h>
> > > >  #include "internal.h"
> > > >  #include "shuffle.h"
> > > 
> > > Why do you move #include <linux/random.h> from .c to .h?
> > > It's not obvious to me.
> > 
> > Because I had originally put the shuffle logic in an inline function. I
> > can undo that now as I when back to doing the randomness in the .c
> > sometime v5 I believe.
> 
> Yes, please. It's needless change now.
> 
> > > > @@ -190,8 +189,7 @@ struct batched_bit_entropy {
> > > >  
> > > >  static DEFINE_PER_CPU(struct batched_bit_entropy, batched_entropy_bool);
> > > >  
> > > > -void add_to_free_area_random(struct page *page, struct free_area *area,
> > > > -		int migratetype)
> > > > +bool __shuffle_pick_tail(void)
> > > >  {
> > > >  	struct batched_bit_entropy *batch;
> > > >  	unsigned long entropy;
> > > > @@ -213,8 +211,5 @@ void add_to_free_area_random(struct page *page, struct free_area *area,
> > > >  	batch->position = position;
> > > >  	entropy = batch->entropy_bool;
> > > >  
> > > > -	if (1ul & (entropy >> position))
> > > > -		add_to_free_area(page, area, migratetype);
> > > > -	else
> > > > -		add_to_free_area_tail(page, area, migratetype);
> > > > +	return 1ul & (entropy >> position);
> > > >  }
> > > > diff --git a/mm/shuffle.h b/mm/shuffle.h
> > > > index 777a257a0d2f..0723eb97f22f 100644
> > > > --- a/mm/shuffle.h
> > > > +++ b/mm/shuffle.h
> > > > @@ -3,6 +3,7 @@
> > > >  #ifndef _MM_SHUFFLE_H
> > > >  #define _MM_SHUFFLE_H
> > > >  #include <linux/jump_label.h>
> > > > +#include <linux/random.h>
> > > >  
> > > >  /*
> > > >   * SHUFFLE_ENABLE is called from the command line enabling path, or by
> > > > @@ -22,6 +23,7 @@ enum mm_shuffle_ctl {
> > > >  DECLARE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
> > > >  extern void page_alloc_shuffle(enum mm_shuffle_ctl ctl);
> > > >  extern void __shuffle_free_memory(pg_data_t *pgdat);
> > > > +extern bool __shuffle_pick_tail(void);
> > > >  static inline void shuffle_free_memory(pg_data_t *pgdat)
> > > >  {
> > > >  	if (!static_branch_unlikely(&page_alloc_shuffle_key))
> > > > @@ -43,6 +45,11 @@ static inline bool is_shuffle_order(int order)
> > > >  		return false;
> > > >  	return order >= SHUFFLE_ORDER;
> > > >  }
> > > > +
> > > > +static inline bool shuffle_pick_tail(void)
> > > > +{
> > > > +	return __shuffle_pick_tail();
> > > > +}
> > > 
> > > I don't see a reason in __shuffle_pick_tail() existing if you call it
> > > unconditionally.
> > 
> > That is for compilation purposes. The function is not used in the
> > shuffle_pick_tail below that always returns false.
> 
> Wouldn't it be the same if you rename __shuffle_pick_tail() to
> shuffle_pick_tail() and put its declaration under the same #ifdef?
> 

Yeah I guess I can do that. I'll update that for v10.

Thanks.

- Alex

