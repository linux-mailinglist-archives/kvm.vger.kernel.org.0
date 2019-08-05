Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B92681FE1
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 17:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfHEPLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 11:11:54 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35304 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfHEPLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 11:11:53 -0400
Received: by mail-io1-f66.google.com with SMTP id m24so168071465ioo.2;
        Mon, 05 Aug 2019 08:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G7ddj6LIyL0pOD3pLu54SyGD3A7IFE1ywu9xd+91w0Y=;
        b=BPDf9k+qxPakawu1vT1R69dDQsxucrWdioDI+4+XYL88408K2zImWqHnoTD+qL3wZi
         Uyiex89pDj2N3Rvs7ECFrA/rgJpqUwTF9Hs0hiIR3H1g3IjoyQCpID/+SDJfLykjtHPx
         h4aznDE+1bXIG2grm+YvaLS7VlpsH+x+nnGAfKj7mEcMef3seArirSpMf/Vunn4Y9vby
         bE8k5M8bN4/99kLH1HMy6SV5dGsK9B5/BsQgG41fw0NqQnm8IwVod+Z4Smty2bsMusAf
         X/uu+jzFKeQ//x2qirISoK4lXcZ0Xl67161C5bo95li2qJ1e5LhD8tBCJjVUkDhHMWwP
         5vqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G7ddj6LIyL0pOD3pLu54SyGD3A7IFE1ywu9xd+91w0Y=;
        b=Vw42yH7SwaOjg8hAQkmu07VpXMDIIpXTJOXjsCU5ZItqMl9Hc+msOa+w82pNmnXrKa
         eeT6H/k1hVJaZJZteKhFET6Hhnni1MgoIH0buCOMoGvCgKiBzbEa1w9q8vdjrYAqZadv
         gj4gl3ywbiiWpQLsB+WwbeYkQJvLPNiULuwVrF6BsipcT1h33PcBNCeiG62zcDfRGl85
         gukDLAv6TAZ9Nl3D096rnnYPjtOKrXqitnXWuR2YsdRUpdYxAo9IWopqE3mM7UZueywz
         anONkOXj/OeL1qA2/6lntReo8aAhDlpT1GEeRe8nE6+cZetOcupM4qPMsom7cQWd+/Ux
         kv1g==
X-Gm-Message-State: APjAAAUJT9FXjRdHswFm9pFG0V7qFD7wudICBpdV/wzjY7EH+uUYfIaJ
        XiG+tJkQtIv0tElNjrvFJ2KLGbuBfz1gs2QsYpM=
X-Google-Smtp-Source: APXvYqzTiE29aPZ9QNlJQTarYm5el65SL1zstnLdfsyTV/s/aNHwwUmw+rKDeJDsZzIoLwWsXVjanrTxdQoUR4/ugNI=
X-Received: by 2002:a6b:5106:: with SMTP id f6mr36070175iob.15.1565017912129;
 Mon, 05 Aug 2019 08:11:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190801222158.22190.96964.stgit@localhost.localdomain>
 <20190801223359.22190.2212.stgit@localhost.localdomain> <42683cc1-3235-5894-2610-bc7b9d443eb0@redhat.com>
In-Reply-To: <42683cc1-3235-5894-2610-bc7b9d443eb0@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 5 Aug 2019 08:11:41 -0700
Message-ID: <CAKgT0UfB+ZU7K7YpOczEH+3SfcJGpZjKt0HZc1KGDixbJKYNOg@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] mm: Introduce Reported pages
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, lcapitulino@redhat.com,
        wei.w.wang@intel.com, Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 5, 2019 at 7:05 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 8/1/19 6:33 PM, Alexander Duyck wrote:
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
> >  mm/page_alloc.c                |  136 ++++++++++++++++++
> >  mm/page_reporting.c            |  299 ++++++++++++++++++++++++++++++++++++++++
> >  8 files changed, 623 insertions(+), 8 deletions(-)
> >  create mode 100644 include/linux/page_reporting.h
> >  create mode 100644 mm/page_reporting.c
> >

<snip>

> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 71aadc7d5ff6..69b848e5b83f 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -68,6 +68,7 @@
> >  #include <linux/lockdep.h>
> >  #include <linux/nmi.h>
> >  #include <linux/psi.h>
> > +#include <linux/page_reporting.h>
> >
> >  #include <asm/sections.h>
> >  #include <asm/tlbflush.h>
> > @@ -915,7 +916,7 @@ static inline struct capture_control *task_capc(struct zone *zone)
> >  static inline void __free_one_page(struct page *page,
> >               unsigned long pfn,
> >               struct zone *zone, unsigned int order,
> > -             int migratetype)
> > +             int migratetype, bool reported)
> >  {
> >       struct capture_control *capc = task_capc(zone);
> >       unsigned long uninitialized_var(buddy_pfn);
> > @@ -990,11 +991,20 @@ static inline void __free_one_page(struct page *page,
> >  done_merging:
> >       set_page_order(page, order);
> >
> > -     if (is_shuffle_order(order) ? shuffle_add_to_tail() :
> > -         buddy_merge_likely(pfn, buddy_pfn, page, order))
> > +     if (reported ||
> > +         (is_shuffle_order(order) ? shuffle_add_to_tail() :
> > +          buddy_merge_likely(pfn, buddy_pfn, page, order)))
> >               add_to_free_list_tail(page, zone, order, migratetype);
> >       else
> >               add_to_free_list(page, zone, order, migratetype);
> > +
> > +     /*
> > +      * No need to notify on a reported page as the total count of
> > +      * unreported pages will not have increased since we have essentially
> > +      * merged the reported page with one or more unreported pages.
> > +      */
> > +     if (!reported)
> > +             page_reporting_notify_free(zone, order);
> >  }
> >
> >  /*
> > @@ -1305,7 +1315,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> >               if (unlikely(isolated_pageblocks))
> >                       mt = get_pageblock_migratetype(page);
> >
> > -             __free_one_page(page, page_to_pfn(page), zone, 0, mt);
> > +             __free_one_page(page, page_to_pfn(page), zone, 0, mt, false);
> >               trace_mm_page_pcpu_drain(page, 0, mt);
> >       }
> >       spin_unlock(&zone->lock);
> > @@ -1321,7 +1331,7 @@ static void free_one_page(struct zone *zone,
> >               is_migrate_isolate(migratetype))) {
> >               migratetype = get_pfnblock_migratetype(page, pfn);
> >       }
> > -     __free_one_page(page, pfn, zone, order, migratetype);
> > +     __free_one_page(page, pfn, zone, order, migratetype, false);
> >       spin_unlock(&zone->lock);
> >  }
> >
> > @@ -2183,6 +2193,122 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
> >       return NULL;
> >  }
> >
> > +#ifdef CONFIG_PAGE_REPORTING
> > +/**
> > + * get_unreported_page - Pull an unreported page from the free_list
> > + * @zone: Zone to draw pages from
> > + * @order: Order to draw pages from
> > + * @mt: Migratetype to draw pages from
> > + *
> > + * This function will obtain a page from the free list. It will start by
> > + * attempting to pull from the tail of the free list and if that is already
> > + * reported on it will instead pull the head if that is unreported.
> > + *
> > + * The page will have the migrate type and order stored in the page
> > + * metadata. While being processed the page will not be avaialble for
> > + * allocation.
> > + *
> > + * Return: page pointer if raw page found, otherwise NULL
> > + */
> > +struct page *get_unreported_page(struct zone *zone, unsigned int order, int mt)
> > +{
> > +     struct list_head *tail = get_unreported_tail(zone, order, mt);
> > +     struct free_area *area = &(zone->free_area[order]);
> > +     struct list_head *list = &area->free_list[mt];
> > +     struct page *page;
> > +
> > +     /* zone lock should be held when this function is called */
> > +     lockdep_assert_held(&zone->lock);
> > +
> > +     /* Find a page of the appropriate size in the preferred list */
> > +     page = list_last_entry(tail, struct page, lru);
> > +     list_for_each_entry_from_reverse(page, list, lru) {
> > +             /* If we entered this loop then the "raw" list isn't empty */
> > +
> > +             /* If the page is reported try the head of the list */
> > +             if (PageReported(page)) {
> > +                     page = list_first_entry(list, struct page, lru);
> > +
> > +                     /*
> > +                      * If both the head and tail are reported then reset
> > +                      * the boundary so that we read as an empty list
> > +                      * next time and bail out.
> > +                      */
> > +                     if (PageReported(page)) {
> > +                             page_reporting_add_to_boundary(page, zone, mt);
> > +                             break;
> > +                     }
> > +             }
> > +
> > +             del_page_from_free_list(page, zone, order);
> > +
> > +             /* record migratetype and order within page */
> > +             set_pcppage_migratetype(page, mt);
> > +             set_page_private(page, order);
> > +
> > +             /*
> > +              * Page will not be available for allocation while we are
> > +              * processing it so update the freepage state.
> > +              */
> > +             __mod_zone_freepage_state(zone, -(1 << order), mt);
> > +
> > +             return page;
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +/**
> > + * put_reported_page - Return a now-reported page back where we got it
> > + * @zone: Zone to return pages to
> > + * @page: Page that was reported
> > + *
> > + * This function will pull the migratetype and order information out
> > + * of the page and attempt to return it where it found it. If the page
> > + * is added to the free list without changes we will mark it as being
> > + * reported.
> > + */
> > +void put_reported_page(struct zone *zone, struct page *page)
> > +{
> > +     unsigned int order, mt;
> > +     unsigned long pfn;
> > +
> > +     /* zone lock should be held when this function is called */
> > +     lockdep_assert_held(&zone->lock);
> > +
> > +     mt = get_pcppage_migratetype(page);
> > +     pfn = page_to_pfn(page);
> > +
> > +     if (unlikely(has_isolate_pageblock(zone) || is_migrate_isolate(mt))) {
> > +             mt = get_pfnblock_migratetype(page, pfn);
> > +             set_pcppage_migratetype(page, mt);
> > +     }
> > +
> > +     order = page_private(page);
> > +     set_page_private(page, 0);
> > +
> > +     __free_one_page(page, pfn, zone, order, mt, true);
>
> I don't think we need to hold the zone lock for fetching migratetype and other
> information.
> We can save some lock held time by acquiring and releasing zone lock before and
> after __free_one_page() respectively. Isn't?

We could, but acquiring and releasing the lock also takes time. I
thought it better to simply hold the lock while I dump the scatterlist
back into the free_list, and until I have completed pulling the
non-reported pages back out. Otherwise we take the overhead for
acquiring/releasing the spinlock itself which isn't necessarily cheap
since it will be frequently bounced between CPUs.

> > +
> > +     /*
> > +      * If page was comingled with another page we cannot consider
> > +      * the result to be "reported" since part of the page hasn't been.
> > +      * In this case we will simply exit and not update the "reported"
> > +      * state. Instead just treat the result as a unreported page.
> > +      */
> > +     if (!PageBuddy(page) || page_order(page) != order)
> > +             return;
> > +
> > +     /* update areated page accounting */
> > +     zone->reported_pages[order - PAGE_REPORTING_MIN_ORDER]++;
> > +
> > +     /* update boundary of new migratetype and record it */
> > +     page_reporting_add_to_boundary(page, zone, mt);
> > +
> > +     /* flag page as reported */
> > +     __SetPageReported(page);
> > +}
> > +#endif /* CONFIG_PAGE_REPORTING */
> > +
> >  /*
> >   * This array describes the order lists are fallen back to when
> >   * the free lists for the desirable migrate type are depleted
> > diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> > new file mode 100644
> > index 000000000000..971138205ae5
> > --- /dev/null
> > +++ b/mm/page_reporting.c
> > @@ -0,0 +1,299 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/mm.h>
> > +#include <linux/mmzone.h>
> > +#include <linux/page-isolation.h>
> > +#include <linux/gfp.h>
> > +#include <linux/export.h>

<snip>

> > +int page_reporting_startup(struct page_reporting_dev_info *phdev)
> > +{
> > +     struct zone *zone;
> > +
> > +     /* nothing to do if already in use */
> > +     if (rcu_access_pointer(ph_dev_info))
> > +             return -EBUSY;
> > +
> > +     /* allocate scatterlist to store pages being reported on */
> > +     phdev->sg = kcalloc(phdev->capacity, sizeof(*phdev->sg), GFP_KERNEL);
> > +     if (!phdev->sg)
> > +             return -ENOMEM;
> > +
> > +     /* initialize refcnt and work structures */
> > +     atomic_set(&phdev->refcnt, 0);
> > +     INIT_DELAYED_WORK(&phdev->work, &page_reporting_process);
> > +
> > +     /* assign device, and begin initial flush of populated zones */
> > +     rcu_assign_pointer(ph_dev_info, phdev);
>
>
> Will, it not make sense to do this at the top after rcu_access_pointer check()?
> Otherwise, there could be a race between two enablers. Am I missing something here?

Placement wouldn't matter as a race would still be possible. Right now
this is safe since there is really only one consumer for this. However
I suppose I should look at adding a mutex so that we cannot have
multiple threads doing the initialization at the same time.

> > +     for_each_populated_zone(zone) {
> > +             spin_lock(&zone->lock);
> > +             __page_reporting_request(zone);
> > +             spin_unlock(&zone->lock);
> > +     }
> > +
> > +     /* enable page reporting notification */
> > +     static_key_slow_inc(&page_reporting_notify_enabled);
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(page_reporting_startup);
> > +
> >
> --
> Thanks
> Nitesh
>
