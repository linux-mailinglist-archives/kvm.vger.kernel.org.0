Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133D0338DA
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 21:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfFCTEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 15:04:55 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:40474 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfFCTEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 15:04:51 -0400
Received: by mail-it1-f194.google.com with SMTP id h11so28343904itf.5;
        Mon, 03 Jun 2019 12:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GKcLW3FcmT/bBXVAPf8bT91wpCH4FZy8Ldt25atr400=;
        b=UKJEp7TQNM+BNrYR9hzcOxPkYXXkpGCnqe/cA904bAshnC6Zm417ojU5A6pZ42yvyd
         N6sZmOUPJ8kkwcpJH3jpKGFJYGjAfAB9AuNILO6VloqPyHSyhva3zeDy5K4mqcQUlGlo
         rjzoKmD27qdPk5VGOsmqTZCLAEY92RS4KpQ24dkFpPCctKUvkf6uN48xXEFAxvHOZDIf
         /wO7a0jMoY7IH+JBkvQjgrIo8ZvVNoMwXNO79XLLyD6Kpcvh4ozI9KKoRQF/Ar1kPly0
         D6Xpxa+PLTkoI0mLv0CVgi6ATWTYE0iUdjwUWqnwpEN9SzHM6vpKf6G6bx1mGO9Qs2h/
         7vcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GKcLW3FcmT/bBXVAPf8bT91wpCH4FZy8Ldt25atr400=;
        b=e5NEBYN/fEEKIq5rcnbigBliYtwyr6Sk86OD9iVoNIG3t/Cp8T+H942OvFps/Xb2fv
         3Oz7ukXHVoDGUPA4bg7avMA5qRjlhKoRosMD6aSfFTJi2GGvLx8WQPr8LbGg4ZJ/tHNF
         23zKHR7iOn8DkkS3Pn2cpoCEMMo0EREDT1N0F+XtuKXg0FJ09m6PkU9LkTfI+gTAGf2r
         1ayF+D/iFoV4HUI6G+emLQ3OaHwlpKCsm1u8EuXvgQ58ZZbPu1632E9jPZ8DMHMFt7UY
         ruMpjKBjJoYSGHzjGJdXaW00dgsOi6X0bz97fwe3bscYWnZVPaJb8+ruhS8qndpAbuHq
         J9Gg==
X-Gm-Message-State: APjAAAX4mTJtUyhg2gwx7cVlIwYL03YEmjKrE4unmEQ9L7hGXYq9WfAk
        /6rfpz3E5kXOteEMUriSdm8W/rGxXAIslZdaR38=
X-Google-Smtp-Source: APXvYqxQW+k4sYRvqYPa0XmW0+y6D+/JaS2dkvgSKNF8gXX1WkthwMFdAL+YQBXjBpcuE8IkOYMyE/5s+yVvRQ5kBGM=
X-Received: by 2002:a24:2b58:: with SMTP id h85mr17648448ita.33.1559588690300;
 Mon, 03 Jun 2019 12:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190603170306.49099-1-nitesh@redhat.com> <20190603170306.49099-2-nitesh@redhat.com>
In-Reply-To: <20190603170306.49099-2-nitesh@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 3 Jun 2019 12:04:38 -0700
Message-ID: <CAKgT0Udnc_cmgBLFEZ5udexsc1cfjX1rJR3qQFOW-7bfuFh6gQ@mail.gmail.com>
Subject: Re: [RFC][Patch v10 1/2] mm: page_hinting: core infrastructure
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> This patch introduces the core infrastructure for free page hinting in
> virtual environments. It enables the kernel to track the free pages which
> can be reported to its hypervisor so that the hypervisor could
> free and reuse that memory as per its requirement.
>
> While the pages are getting processed in the hypervisor (e.g.,
> via MADV_FREE), the guest must not use them, otherwise, data loss
> would be possible. To avoid such a situation, these pages are
> temporarily removed from the buddy. The amount of pages removed
> temporarily from the buddy is governed by the backend(virtio-balloon
> in our case).
>
> To efficiently identify free pages that can to be hinted to the
> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
> chunks are reported to the hypervisor - especially, to not break up THP
> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bits
> in the bitmap are an indication whether a page *might* be free, not a
> guarantee. A new hook after buddy merging sets the bits.
>
> Bitmaps are stored per zone, protected by the zone lock. A workqueue
> asynchronously processes the bitmaps, trying to isolate and report pages
> that are still free. The backend (virtio-balloon) is responsible for
> reporting these batched pages to the host synchronously. Once reporting/
> freeing is complete, isolated pages are returned back to the buddy.
>
> There are still various things to look into (e.g., memory hotplug, more
> efficient locking, possible races when disabling).
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>

So one thing I had thought about, that I don't believe that has been
addressed in your solution, is to determine a means to guarantee
forward progress. If you have a noisy thread that is allocating and
freeing some block of memory repeatedly you will be stuck processing
that and cannot get to the other work. Specifically if you have a zone
where somebody is just cycling the number of pages needed to fill your
hinting queue how do you get around it and get to the data that is
actually code instead of getting stuck processing the noise?

Do you have any idea what the hit rate would be on a system that is on
the more active side? From what I can tell you still are effectively
just doing a linear search of memory, but you have the bitmap hints to
tell what as not been freed recently, however you still don't know
that the pages you have bitmap hints for are actually free until you
check them.

> ---
>  drivers/virtio/Kconfig       |   1 +
>  include/linux/page_hinting.h |  46 +++++++
>  mm/Kconfig                   |   6 +
>  mm/Makefile                  |   2 +
>  mm/page_alloc.c              |  17 +--
>  mm/page_hinting.c            | 236 +++++++++++++++++++++++++++++++++++
>  6 files changed, 301 insertions(+), 7 deletions(-)
>  create mode 100644 include/linux/page_hinting.h
>  create mode 100644 mm/page_hinting.c
>
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 35897649c24f..5a96b7a2ed1e 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -46,6 +46,7 @@ config VIRTIO_BALLOON
>         tristate "Virtio balloon driver"
>         depends on VIRTIO
>         select MEMORY_BALLOON
> +       select PAGE_HINTING
>         ---help---
>          This driver supports increasing and decreasing the amount
>          of memory within a KVM guest.
> diff --git a/include/linux/page_hinting.h b/include/linux/page_hinting.h
> new file mode 100644
> index 000000000000..e65188fe1e6b
> --- /dev/null
> +++ b/include/linux/page_hinting.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_PAGE_HINTING_H
> +#define _LINUX_PAGE_HINTING_H
> +
> +/*
> + * Minimum page order required for a page to be hinted to the host.
> + */
> +#define PAGE_HINTING_MIN_ORDER         (MAX_ORDER - 2)
> +
> +/*
> + * struct page_hinting_cb: holds the callbacks to store, report and cleanup
> + * isolated pages.
> + * @prepare:           Callback responsible for allocating an array to hold
> + *                     the isolated pages.
> + * @hint_pages:                Callback which reports the isolated pages synchornously
> + *                     to the host.
> + * @cleanup:           Callback to free the the array used for reporting the
> + *                     isolated pages.
> + * @max_pages:         Maxmimum pages that are going to be hinted to the host
> + *                     at a time of granularity >= PAGE_HINTING_MIN_ORDER.
> + */
> +struct page_hinting_cb {
> +       int (*prepare)(void);
> +       void (*hint_pages)(struct list_head *list);
> +       void (*cleanup)(void);
> +       int max_pages;
> +};
> +
> +#ifdef CONFIG_PAGE_HINTING
> +void page_hinting_enqueue(struct page *page, int order);
> +void page_hinting_enable(const struct page_hinting_cb *cb);
> +void page_hinting_disable(void);
> +#else
> +static inline void page_hinting_enqueue(struct page *page, int order)
> +{
> +}
> +
> +static inline void page_hinting_enable(struct page_hinting_cb *cb)
> +{
> +}
> +
> +static inline void page_hinting_disable(void)
> +{
> +}
> +#endif
> +#endif /* _LINUX_PAGE_HINTING_H */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ee8d1f311858..177d858de758 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -764,4 +764,10 @@ config GUP_BENCHMARK
>  config ARCH_HAS_PTE_SPECIAL
>         bool
>
> +# PAGE_HINTING will allow the guest to report the free pages to the
> +# host in regular interval of time.
> +config PAGE_HINTING
> +       bool
> +       def_bool n
> +       depends on X86_64
>  endmenu
> diff --git a/mm/Makefile b/mm/Makefile
> index ac5e5ba78874..bec456dfee34 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -41,6 +41,7 @@ obj-y                 := filemap.o mempool.o oom_kill.o fadvise.o \
>                            interval_tree.o list_lru.o workingset.o \
>                            debug.o $(mmu-y)
>
> +
>  # Give 'page_alloc' its own module-parameter namespace
>  page-alloc-y := page_alloc.o
>  page-alloc-$(CONFIG_SHUFFLE_PAGE_ALLOCATOR) += shuffle.o
> @@ -94,6 +95,7 @@ obj-$(CONFIG_Z3FOLD)  += z3fold.o
>  obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
>  obj-$(CONFIG_CMA)      += cma.o
>  obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
> +obj-$(CONFIG_PAGE_HINTING) += page_hinting.o
>  obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
>  obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
>  obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3b13d3914176..d12f69e0e402 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -68,6 +68,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/nmi.h>
>  #include <linux/psi.h>
> +#include <linux/page_hinting.h>
>
>  #include <asm/sections.h>
>  #include <asm/tlbflush.h>
> @@ -873,10 +874,10 @@ compaction_capture(struct capture_control *capc, struct page *page,
>   * -- nyc
>   */
>
> -static inline void __free_one_page(struct page *page,
> +inline void __free_one_page(struct page *page,
>                 unsigned long pfn,
>                 struct zone *zone, unsigned int order,
> -               int migratetype)
> +               int migratetype, bool hint)
>  {
>         unsigned long combined_pfn;
>         unsigned long uninitialized_var(buddy_pfn);
> @@ -951,6 +952,8 @@ static inline void __free_one_page(struct page *page,
>  done_merging:
>         set_page_order(page, order);
>
> +       if (hint)
> +               page_hinting_enqueue(page, order);

This is a bit early to probably be dealing with the hint. You should
probably look at moving this down to a spot somewhere after the page
has been added to the free list. It may not cause any issues with the
current order setup, but moving after the addition to the free list
will make it so that you know it is in there when you call this
function.

>         /*
>          * If this is not the largest possible page, check if the buddy
>          * of the next-highest order is free. If it is, it's possible
> @@ -1262,7 +1265,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>                 if (unlikely(isolated_pageblocks))
>                         mt = get_pageblock_migratetype(page);
>
> -               __free_one_page(page, page_to_pfn(page), zone, 0, mt);
> +               __free_one_page(page, page_to_pfn(page), zone, 0, mt, true);
>                 trace_mm_page_pcpu_drain(page, 0, mt);
>         }
>         spin_unlock(&zone->lock);
> @@ -1271,14 +1274,14 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  static void free_one_page(struct zone *zone,
>                                 struct page *page, unsigned long pfn,
>                                 unsigned int order,
> -                               int migratetype)
> +                               int migratetype, bool hint)
>  {
>         spin_lock(&zone->lock);
>         if (unlikely(has_isolate_pageblock(zone) ||
>                 is_migrate_isolate(migratetype))) {
>                 migratetype = get_pfnblock_migratetype(page, pfn);
>         }
> -       __free_one_page(page, pfn, zone, order, migratetype);
> +       __free_one_page(page, pfn, zone, order, migratetype, hint);
>         spin_unlock(&zone->lock);
>  }
>
> @@ -1368,7 +1371,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>         migratetype = get_pfnblock_migratetype(page, pfn);
>         local_irq_save(flags);
>         __count_vm_events(PGFREE, 1 << order);
> -       free_one_page(page_zone(page), page, pfn, order, migratetype);
> +       free_one_page(page_zone(page), page, pfn, order, migratetype, true);
>         local_irq_restore(flags);
>  }
>
> @@ -2968,7 +2971,7 @@ static void free_unref_page_commit(struct page *page, unsigned long pfn)
>          */
>         if (migratetype >= MIGRATE_PCPTYPES) {
>                 if (unlikely(is_migrate_isolate(migratetype))) {
> -                       free_one_page(zone, page, pfn, 0, migratetype);
> +                       free_one_page(zone, page, pfn, 0, migratetype, true);
>                         return;
>                 }
>                 migratetype = MIGRATE_MOVABLE;

So it looks like you are using a parameter to identify if the page is
a hinted page or not. I guess this works but it seems like it is a bit
intrusive as you are adding an argument to specify that this is a
specific page type.

> diff --git a/mm/page_hinting.c b/mm/page_hinting.c
> new file mode 100644
> index 000000000000..7341c6462de2
> --- /dev/null
> +++ b/mm/page_hinting.c
> @@ -0,0 +1,236 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Page hinting support to enable a VM to report the freed pages back
> + * to the host.
> + *
> + * Copyright Red Hat, Inc. 2019
> + *
> + * Author(s): Nitesh Narayan Lal <nitesh@redhat.com>
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/page_hinting.h>
> +#include <linux/kvm_host.h>
> +
> +/*
> + * struct hinting_bitmap: holds the bitmap pointer which tracks the freed PFNs
> + * and other required parameters which could help in retrieving the original
> + * PFN value using the bitmap.
> + * @bitmap:            Pointer to the bitmap of free PFN.
> + * @base_pfn:          Starting PFN value for the zone whose bitmap is stored.
> + * @free_pages:                Tracks the number of free pages of granularity
> + *                     PAGE_HINTING_MIN_ORDER.
> + * @nbits:             Indicates the total size of the bitmap in bits allocated
> + *                     at the time of initialization.
> + */
> +struct hinting_bitmap {
> +       unsigned long *bitmap;
> +       unsigned long base_pfn;
> +       atomic_t free_pages;
> +       unsigned long nbits;
> +} bm_zone[MAX_NR_ZONES];
> +

This ignores NUMA doesn't it? Shouldn't you have support for other NUMA nodes?

> +static void init_hinting_wq(struct work_struct *work);
> +extern int __isolate_free_page(struct page *page, unsigned int order);
> +extern void __free_one_page(struct page *page, unsigned long pfn,
> +                           struct zone *zone, unsigned int order,
> +                           int migratetype, bool hint);
> +const struct page_hinting_cb *hcb;
> +struct work_struct hinting_work;
> +
> +static unsigned long find_bitmap_size(struct zone *zone)
> +{
> +       unsigned long nbits = ALIGN(zone->spanned_pages,
> +                           PAGE_HINTING_MIN_ORDER);
> +
> +       nbits = nbits >> PAGE_HINTING_MIN_ORDER;
> +       return nbits;
> +}
> +

This doesn't look right to me. You are trying to do something like a
DIV_ROUND_UP here, right? If so shouldn't you be aligning to 1 <<
PAGE_HINTING_MIN_ORDER, instead of just PAGE_HINTING_MIN_ORDER?
Another option would be to just do DIV_ROUND_UP with the 1 <<
PAGE_HINTING_MIN_ORDER value.

> +void page_hinting_enable(const struct page_hinting_cb *callback)
> +{
> +       struct zone *zone;
> +       int idx = 0;
> +       unsigned long bitmap_size = 0;
> +
> +       for_each_populated_zone(zone) {

The index for this doesn't match up to the index you used to define
bm_zone. for_each_populated_zone will go through each zone in each
pgdat. Right now you can only handle one pgdat.

> +               spin_lock(&zone->lock);
> +               bitmap_size = find_bitmap_size(zone);
> +               bm_zone[idx].bitmap = bitmap_zalloc(bitmap_size, GFP_KERNEL);
> +               if (!bm_zone[idx].bitmap)
> +                       return;
> +               bm_zone[idx].nbits = bitmap_size;
> +               bm_zone[idx].base_pfn = zone->zone_start_pfn;
> +               spin_unlock(&zone->lock);
> +               idx++;
> +       }
> +       hcb = callback;
> +       INIT_WORK(&hinting_work, init_hinting_wq);
> +}
> +EXPORT_SYMBOL_GPL(page_hinting_enable);
> +
> +void page_hinting_disable(void)
> +{
> +       struct zone *zone;
> +       int idx = 0;
> +
> +       cancel_work_sync(&hinting_work);
> +       hcb = NULL;
> +       for_each_populated_zone(zone) {
> +               spin_lock(&zone->lock);
> +               bitmap_free(bm_zone[idx].bitmap);
> +               bm_zone[idx].base_pfn = 0;
> +               bm_zone[idx].nbits = 0;
> +               atomic_set(&bm_zone[idx].free_pages, 0);
> +               spin_unlock(&zone->lock);
> +               idx++;
> +       }
> +}
> +EXPORT_SYMBOL_GPL(page_hinting_disable);
> +
> +static unsigned long pfn_to_bit(struct page *page, int zonenum)
> +{
> +       unsigned long bitnr;
> +
> +       bitnr = (page_to_pfn(page) - bm_zone[zonenum].base_pfn)
> +                        >> PAGE_HINTING_MIN_ORDER;
> +       return bitnr;
> +}
> +
> +static void release_buddy_pages(struct list_head *pages)
> +{
> +       int mt = 0, zonenum, order;
> +       struct page *page, *next;
> +       struct zone *zone;
> +       unsigned long bitnr;
> +
> +       list_for_each_entry_safe(page, next, pages, lru) {
> +               zonenum = page_zonenum(page);
> +               zone = page_zone(page);
> +               bitnr = pfn_to_bit(page, zonenum);
> +               spin_lock(&zone->lock);
> +               list_del(&page->lru);
> +               order = page_private(page);
> +               set_page_private(page, 0);
> +               mt = get_pageblock_migratetype(page);
> +               __free_one_page(page, page_to_pfn(page), zone,
> +                               order, mt, false);
> +               spin_unlock(&zone->lock);
> +       }
> +}
> +
> +static void bm_set_pfn(struct page *page)
> +{
> +       unsigned long bitnr = 0;
> +       int zonenum = page_zonenum(page);
> +       struct zone *zone = page_zone(page);
> +
> +       lockdep_assert_held(&zone->lock);
> +       bitnr = pfn_to_bit(page, zonenum);
> +       if (bm_zone[zonenum].bitmap &&
> +           bitnr < bm_zone[zonenum].nbits &&
> +           !test_and_set_bit(bitnr, bm_zone[zonenum].bitmap))
> +               atomic_inc(&bm_zone[zonenum].free_pages);
> +}
> +
> +static void scan_hinting_bitmap(int zonenum, int free_pages)
> +{
> +       unsigned long set_bit, start = 0;
> +       struct page *page;
> +       struct zone *zone;
> +       int scanned_pages = 0, ret = 0, order, isolated_cnt = 0;
> +       LIST_HEAD(isolated_pages);
> +
> +       ret = hcb->prepare();
> +       if (ret < 0)
> +               return;
> +       for (;;) {
> +               ret = 0;
> +               set_bit = find_next_bit(bm_zone[zonenum].bitmap,
> +                                       bm_zone[zonenum].nbits, start);
> +               if (set_bit >= bm_zone[zonenum].nbits)
> +                       break;
> +               page = pfn_to_online_page((set_bit << PAGE_HINTING_MIN_ORDER) +
> +                               bm_zone[zonenum].base_pfn);
> +               if (!page)
> +                       continue;
> +               zone = page_zone(page);
> +               spin_lock(&zone->lock);
> +
> +               if (PageBuddy(page) && page_private(page) >=
> +                   PAGE_HINTING_MIN_ORDER) {
> +                       order = page_private(page);
> +                       ret = __isolate_free_page(page, order);
> +               }
> +               clear_bit(set_bit, bm_zone[zonenum].bitmap);
> +               spin_unlock(&zone->lock);
> +               if (ret) {
> +                       /*
> +                        * restoring page order to use it while releasing
> +                        * the pages back to the buddy.
> +                        */
> +                       set_page_private(page, order);
> +                       list_add_tail(&page->lru, &isolated_pages);
> +                       isolated_cnt++;
> +                       if (isolated_cnt == hcb->max_pages) {
> +                               hcb->hint_pages(&isolated_pages);
> +                               release_buddy_pages(&isolated_pages);
> +                               isolated_cnt = 0;
> +                       }
> +               }
> +               start = set_bit + 1;
> +               scanned_pages++;
> +       }
> +       if (isolated_cnt) {
> +               hcb->hint_pages(&isolated_pages);
> +               release_buddy_pages(&isolated_pages);
> +       }
> +       hcb->cleanup();
> +       if (scanned_pages > free_pages)
> +               atomic_sub((scanned_pages - free_pages),
> +                          &bm_zone[zonenum].free_pages);
> +}
> +
> +static bool check_hinting_threshold(void)
> +{
> +       int zonenum = 0;
> +
> +       for (; zonenum < MAX_NR_ZONES; zonenum++) {
> +               if (atomic_read(&bm_zone[zonenum].free_pages) >=
> +                               hcb->max_pages)
> +                       return true;
> +       }
> +       return false;
> +}
> +
> +static void init_hinting_wq(struct work_struct *work)
> +{
> +       int zonenum = 0, free_pages = 0;
> +
> +       for (; zonenum < MAX_NR_ZONES; zonenum++) {
> +               free_pages = atomic_read(&bm_zone[zonenum].free_pages);
> +               if (free_pages >= hcb->max_pages) {
> +                       /* Find a better way to synchronize per zone
> +                        * free_pages.
> +                        */
> +                       atomic_sub(free_pages,
> +                                  &bm_zone[zonenum].free_pages);
> +                       scan_hinting_bitmap(zonenum, free_pages);
> +               }
> +       }
> +}
> +
> +void page_hinting_enqueue(struct page *page, int order)
> +{
> +       if (hcb && order >= PAGE_HINTING_MIN_ORDER)
> +               bm_set_pfn(page);
> +       else
> +               return;

You could probably flip the logic and save yourself an "else" by just
doing something like:
if (!hcb || order < PAGE_HINTING_MIN_ORDER)
        return;

I think it would also make this more readable.

> +
> +       if (check_hinting_threshold()) {
> +               int cpu = smp_processor_id();
> +
> +               queue_work_on(cpu, system_wq, &hinting_work);
> +       }
> +}
> --
> 2.21.0
>
