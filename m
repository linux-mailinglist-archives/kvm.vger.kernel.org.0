Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739B35A559
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 21:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfF1TtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 15:49:24 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45553 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfF1TtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 15:49:24 -0400
Received: by mail-io1-f66.google.com with SMTP id e3so14925245ioc.12;
        Fri, 28 Jun 2019 12:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yyGQbOICu865VAL3WfBuIMEgZs6PIT7zz9ZwKAw1Ius=;
        b=JkqT59IEWrKV78KBkgZo9Ndx7Bpm2aoAvA7F1k1pawzLor4/NffJdiQvDL6LLNzZ90
         k2UzqvD0AJRCD+kYbKZ4HJDLZUlBAyb1m0tK3hAX1p44IyAFiffeNv4X6yJPU6jOsKkK
         sMcRuvzuwAYEKPVz4AAP3j/blKztojOift+o8TsiqkQc8SNfNrnXmRwsoe/Q670W9guS
         q2a5QLhq8G1iBenVuQ9LQWqKxmQOBl1aJcjpbvFdGv77FSeALyYmhP6CoMiWEYW/O5w2
         TbeB7WUT8koFeZJQ66v3cRQHftPqAKP7CNLa9urFX86r81Q53pqSpa9P2Dhw4NtYC88S
         +YzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yyGQbOICu865VAL3WfBuIMEgZs6PIT7zz9ZwKAw1Ius=;
        b=kYo6WN+O+bQl0VUC7PzDpbn84y05UvUtTxNPoIaaiZsUSTB6NN5oW2TB4vENyBe1yy
         amlTXx3wd91SigKBsCVk++eiyR0jUtgFuEAcgseaVNEd3BUGge6fDvVh6CkpfoaXFXNm
         t9r4vgyMcYwEG7i8JucWC5TwUKkf4fOZkqjBdonACMpXKuoUxr2PuLGhYU3Ne/BnORQY
         eNxjlYiQ0L04mVRFPtp2umgnoLCDzd4aU1cyT6TjoAfes2J4JkLlO7YlBRTGZ408bFFs
         pzbtQbf0lIcdLuBz51ulYycTE6sYcFsDyw5f8p55vW4GTA92sDh+08hC5tEBshMFzafS
         8T0A==
X-Gm-Message-State: APjAAAWGBFF5/lIbvY575brxoRrIiO187Xr2NQVca69a+Vh+gtuNarI9
        yVJb/SHFJ8dVW/siveZuvxVPs2dVgv5RG9KbCMc=
X-Google-Smtp-Source: APXvYqwhrHo/W1nrbh50tbjbaM6e2639iaeQkYqCSOUx1E8YTlwQqRoMG/DwgwvY1AI1IgbPSbuDKpbNRcWF/HxwUO4=
X-Received: by 2002:a6b:b790:: with SMTP id h138mr12378906iof.64.1561751363440;
 Fri, 28 Jun 2019 12:49:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
 <20190619223302.1231.51136.stgit@localhost.localdomain> <7d959202-b2cd-fe24-5b3c-84e159eafe0a@redhat.com>
In-Reply-To: <7d959202-b2cd-fe24-5b3c-84e159eafe0a@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 28 Jun 2019 12:49:11 -0700
Message-ID: <CAKgT0UfNFbAs=1o_DMHRQScDKP8qLnmOGtgfUhjk3_Jupbwf6w@mail.gmail.com>
Subject: Re: [PATCH v1 1/6] mm: Adjust shuffle code to allow for future coalescing
To:     David Hildenbrand <david@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 25, 2019 at 12:56 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 20.06.19 00:33, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > This patch is meant to move the head/tail adding logic out of the shuffle
> > code and into the __free_one_page function since ultimately that is where
> > it is really needed anyway. By doing this we should be able to reduce the
> > overhead and can consolidate all of the list addition bits in one spot.
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  include/linux/mmzone.h |   12 --------
> >  mm/page_alloc.c        |   70 +++++++++++++++++++++++++++---------------------
> >  mm/shuffle.c           |   24 ----------------
> >  mm/shuffle.h           |   35 ++++++++++++++++++++++++
> >  4 files changed, 74 insertions(+), 67 deletions(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 427b79c39b3c..4c07af2cfc2f 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -116,18 +116,6 @@ static inline void add_to_free_area_tail(struct page *page, struct free_area *ar
> >       area->nr_free++;
> >  }
> >
> > -#ifdef CONFIG_SHUFFLE_PAGE_ALLOCATOR
> > -/* Used to preserve page allocation order entropy */
> > -void add_to_free_area_random(struct page *page, struct free_area *area,
> > -             int migratetype);
> > -#else
> > -static inline void add_to_free_area_random(struct page *page,
> > -             struct free_area *area, int migratetype)
> > -{
> > -     add_to_free_area(page, area, migratetype);
> > -}
> > -#endif
> > -
> >  /* Used for pages which are on another list */
> >  static inline void move_to_free_area(struct page *page, struct free_area *area,
> >                            int migratetype)
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index f4651a09948c..ec344ce46587 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -830,6 +830,36 @@ static inline struct capture_control *task_capc(struct zone *zone)
> >  #endif /* CONFIG_COMPACTION */
> >
> >  /*
> > + * If this is not the largest possible page, check if the buddy
> > + * of the next-highest order is free. If it is, it's possible
> > + * that pages are being freed that will coalesce soon. In case,
> > + * that is happening, add the free page to the tail of the list
> > + * so it's less likely to be used soon and more likely to be merged
> > + * as a higher order page
> > + */
> > +static inline bool
> > +buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
> > +                struct page *page, unsigned int order)
> > +{
> > +     struct page *higher_page, *higher_buddy;
> > +     unsigned long combined_pfn;
> > +
> > +     if (is_shuffle_order(order) || order >= (MAX_ORDER - 2))
>
> My intuition tells me you can drop the () around "MAX_ORDER - 2"

I dunno, I always kind of prefer to use the parenthesis in these cases
for readability. I suppose I can drop it though.

> > +             return false;
>
> Guess the "is_shuffle_order(order)" check should rather be performed by
> the caller, before calling this function.

I could do that, however I am not sure it adds much. I am pretty sure
the resultant code would be the same. Where things would be a bit more
complicated is that I would then have to probably look at adding a
variable to trap the output of is_shuffle_tail_page or
buddy_merge_likely.

> > +
> > +     if (!pfn_valid_within(buddy_pfn))
> > +             return false;
> > +
> > +     combined_pfn = buddy_pfn & pfn;
> > +     higher_page = page + (combined_pfn - pfn);
> > +     buddy_pfn = __find_buddy_pfn(combined_pfn, order + 1);
> > +     higher_buddy = higher_page + (buddy_pfn - combined_pfn);
> > +
> > +     return pfn_valid_within(buddy_pfn) &&
> > +            page_is_buddy(higher_page, higher_buddy, order + 1);
> > +}
> > +
> > +/*
> >   * Freeing function for a buddy system allocator.
> >   *
> >   * The concept of a buddy system is to maintain direct-mapped table
> > @@ -858,11 +888,12 @@ static inline void __free_one_page(struct page *page,
> >               struct zone *zone, unsigned int order,
> >               int migratetype)
> >  {
> > -     unsigned long combined_pfn;
> > +     struct capture_control *capc = task_capc(zone);
> >       unsigned long uninitialized_var(buddy_pfn);
> > -     struct page *buddy;
> > +     unsigned long combined_pfn;
> > +     struct free_area *area;
> >       unsigned int max_order;
> > -     struct capture_control *capc = task_capc(zone);
> > +     struct page *buddy;
> >
> >       max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
> >
> > @@ -931,35 +962,12 @@ static inline void __free_one_page(struct page *page,
> >  done_merging:
> >       set_page_order(page, order);
> >
> > -     /*
> > -      * If this is not the largest possible page, check if the buddy
> > -      * of the next-highest order is free. If it is, it's possible
> > -      * that pages are being freed that will coalesce soon. In case,
> > -      * that is happening, add the free page to the tail of the list
> > -      * so it's less likely to be used soon and more likely to be merged
> > -      * as a higher order page
> > -      */
> > -     if ((order < MAX_ORDER-2) && pfn_valid_within(buddy_pfn)
> > -                     && !is_shuffle_order(order)) {
> > -             struct page *higher_page, *higher_buddy;
> > -             combined_pfn = buddy_pfn & pfn;
> > -             higher_page = page + (combined_pfn - pfn);
> > -             buddy_pfn = __find_buddy_pfn(combined_pfn, order + 1);
> > -             higher_buddy = higher_page + (buddy_pfn - combined_pfn);
> > -             if (pfn_valid_within(buddy_pfn) &&
> > -                 page_is_buddy(higher_page, higher_buddy, order + 1)) {
> > -                     add_to_free_area_tail(page, &zone->free_area[order],
> > -                                           migratetype);
> > -                     return;
> > -             }
> > -     }
> > -
> > -     if (is_shuffle_order(order))
> > -             add_to_free_area_random(page, &zone->free_area[order],
> > -                             migratetype);
> > +     area = &zone->free_area[order];
> > +     if (buddy_merge_likely(pfn, buddy_pfn, page, order) ||
> > +         is_shuffle_tail_page(order))
> > +             add_to_free_area_tail(page, area, migratetype);
>
> I would prefer here something like
>
> if (is_shuffle_order(order)) {
>         if (add_shuffle_order_to_tail(order))
>                 add_to_free_area_tail(page, area, migratetype);
>         else
>                 add_to_free_area(page, area, migratetype);
> } else if (buddy_merge_likely(pfn, buddy_pfn, page, order)) {
>         add_to_free_area_tail(page, area, migratetype);
> } else {
>         add_to_free_area(page, area, migratetype);
> }
>
> dropping "is_shuffle_order()" from buddy_merge_likely()
>
> Especially, the name "is_shuffle_tail_page(order)" suggests that you are
> passing a page.

Okay, I can look at renaming that. I will probably look at just using
a variable instead of nesting the if statements like that. Otherwise
that is going to get pretty messy fairly quickly.

> >       else
> > -             add_to_free_area(page, &zone->free_area[order], migratetype);
> > -
> > +             add_to_free_area(page, area, migratetype);
> >  }
> >
> >  /*
> > diff --git a/mm/shuffle.c b/mm/shuffle.c
> > index 3ce12481b1dc..55d592e62526 100644
> > --- a/mm/shuffle.c
> > +++ b/mm/shuffle.c
> > @@ -4,7 +4,6 @@
> >  #include <linux/mm.h>
> >  #include <linux/init.h>
> >  #include <linux/mmzone.h>
> > -#include <linux/random.h>
> >  #include <linux/moduleparam.h>
> >  #include "internal.h"
> >  #include "shuffle.h"
> > @@ -182,26 +181,3 @@ void __meminit __shuffle_free_memory(pg_data_t *pgdat)
> >       for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
> >               shuffle_zone(z);
> >  }
> > -
> > -void add_to_free_area_random(struct page *page, struct free_area *area,
> > -             int migratetype)
> > -{
> > -     static u64 rand;
> > -     static u8 rand_bits;
> > -
> > -     /*
> > -      * The lack of locking is deliberate. If 2 threads race to
> > -      * update the rand state it just adds to the entropy.
> > -      */
> > -     if (rand_bits == 0) {
> > -             rand_bits = 64;
> > -             rand = get_random_u64();
> > -     }
> > -
> > -     if (rand & 1)
> > -             add_to_free_area(page, area, migratetype);
> > -     else
> > -             add_to_free_area_tail(page, area, migratetype);
> > -     rand_bits--;
> > -     rand >>= 1;
> > -}
> > diff --git a/mm/shuffle.h b/mm/shuffle.h
> > index 777a257a0d2f..3f4edb60a453 100644
> > --- a/mm/shuffle.h
> > +++ b/mm/shuffle.h
> > @@ -3,6 +3,7 @@
> >  #ifndef _MM_SHUFFLE_H
> >  #define _MM_SHUFFLE_H
> >  #include <linux/jump_label.h>
> > +#include <linux/random.h>
> >
> >  /*
> >   * SHUFFLE_ENABLE is called from the command line enabling path, or by
> > @@ -43,6 +44,35 @@ static inline bool is_shuffle_order(int order)
> >               return false;
> >       return order >= SHUFFLE_ORDER;
> >  }
> > +
> > +static inline bool is_shuffle_tail_page(int order)
> > +{
> > +     static u64 rand;
> > +     static u8 rand_bits;
> > +     u64 rand_old;
> > +
> > +     if (!is_shuffle_order(order))
> > +             return false;
> > +
> > +     /*
> > +      * The lack of locking is deliberate. If 2 threads race to
> > +      * update the rand state it just adds to the entropy.
> > +      */
> > +     if (rand_bits-- == 0) {
> > +             rand_bits = 64;
> > +             rand = get_random_u64();
> > +     }
> > +
> > +     /*
> > +      * Test highest order bit while shifting our random value. This
> > +      * should result in us testing for the carry flag following the
> > +      * shift.
> > +      */
> > +     rand_old = rand;
> > +     rand <<= 1;
> > +
> > +     return rand < rand_old;
> > +}
> >  #else
> >  static inline void shuffle_free_memory(pg_data_t *pgdat)
> >  {
> > @@ -60,5 +90,10 @@ static inline bool is_shuffle_order(int order)
> >  {
> >       return false;
> >  }
> > +
> > +static inline bool is_shuffle_tail_page(int order)
> > +{
> > +     return false;
> > +}
> >  #endif
> >  #endif /* _MM_SHUFFLE_H */
> >
>
>
> --
>
> Thanks,
>
> David / dhildenb
