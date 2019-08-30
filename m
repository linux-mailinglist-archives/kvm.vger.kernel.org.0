Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E739A3A61
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 17:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfH3Pbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 11:31:51 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35418 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbfH3Pbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 11:31:51 -0400
Received: by mail-io1-f66.google.com with SMTP id b10so14883280ioj.2;
        Fri, 30 Aug 2019 08:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=THCArD2ULmPuj5QcIigwJss+eQryCDYx05ZAa455hr0=;
        b=QjmOueDSY9WLliOZMMAHB0fDBqWfU6V3IJtVE7RffkU6PaY9cNvMH/RwwajIyHploo
         GLVXcXkfYk5QmB3kgoULdqr9mePnbgwtEa78r+GduWjNms79dNF91rrCC2Cr0y8TzMWh
         sydHYrVQ5oxL5P1pySl8JkR+KqnyE4HXmYdpCTtvom59g3NPZKXEr99VrWRZeWn1U0zX
         RuZhQnoR3yX3jbIz2lFkqJgs/wVD4XJ0zf4CfLpL+ube2PMTOGmZvNbEJ2aJx1HnzMNE
         O28lQprjbGBHFTf2SFLIJjUduGK9isdAugfVDHZuwNBvwWirxWE7vrPO1bmFi54BVK73
         sXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=THCArD2ULmPuj5QcIigwJss+eQryCDYx05ZAa455hr0=;
        b=DFfQkQnIL1D6USxPnGbJ8+Y6uMH9Rzlynk3R8xzVC2sLGoQ7KiUKnX8MTnlC8TWPbS
         EjApBcgK1WAkqtZYvlARH5uRTy6uizLNYJKPNhEkfu1XkFswKoBtuBKuwohp8htNzCjP
         zz01Ogmx/hx2bu897mR8mgrXkZGjCpiJ67T0PB7MKlKZzl4Fhw/WR9t31Zsem7VpsLo2
         AOjBU60oLxJejliMMXqVOJplLdcbThvGYVS1QazUUvf6JpNbdFD45NGvXEEw9uVm/tbM
         wAt9HzFeKsK4HGwZrq6lcneBMrBG4CfKOOv5CDiBsVFilKmTQCmEw8sX7u3DiH7xoKdS
         Qgmg==
X-Gm-Message-State: APjAAAVTi8dDPrIwV2KqCfWX/yoAirBDuwyjzXbgAMmrvhb8I5HD3bZX
        JQOLZ37hdf+MRV3YIKTatbYb18a0OWATOYYwQ2M=
X-Google-Smtp-Source: APXvYqyY3L0jvSK597WWk0YMjyVG3pjCsfGwJ0Lib4smaB/iEuiSlgT0Vz9Ha8BL6n2yWDcUPd/WIjG+iob2z6VyRS8=
X-Received: by 2002:a02:7a52:: with SMTP id z18mr12285314jad.121.1567179110074;
 Fri, 30 Aug 2019 08:31:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190812131235.27244-1-nitesh@redhat.com> <20190812131235.27244-2-nitesh@redhat.com>
 <CAKgT0UcSabyrO=jUwq10KpJKLSuzorHDnKAGrtWVigKVgvD-6Q@mail.gmail.com> <df82bc99-a212-4f5c-dc2e-28665060acb2@redhat.com>
In-Reply-To: <df82bc99-a212-4f5c-dc2e-28665060acb2@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 30 Aug 2019 08:31:38 -0700
Message-ID: <CAKgT0Ueqok+bxANVtB1DdYorcEHN7+Grzb8MAxTzSk8uS81pRA@mail.gmail.com>
Subject: Re: [RFC][Patch v12 1/2] mm: page_reporting: core infrastructure
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, virtio-dev@lists.oasis-open.org,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        Pankaj Gupta <pagupta@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        john.starks@microsoft.com, Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@suse.com>, cohuck@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 8:15 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 8/12/19 2:47 PM, Alexander Duyck wrote:
> > On Mon, Aug 12, 2019 at 6:13 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >> This patch introduces the core infrastructure for free page reporting in
> >> virtual environments. It enables the kernel to track the free pages which
> >> can be reported to its hypervisor so that the hypervisor could
> >> free and reuse that memory as per its requirement.
> >>
> >> While the pages are getting processed in the hypervisor (e.g.,
> >> via MADV_DONTNEED), the guest must not use them, otherwise, data loss
> >> would be possible. To avoid such a situation, these pages are
> >> temporarily removed from the buddy. The amount of pages removed
> >> temporarily from the buddy is governed by the backend(virtio-balloon
> >> in our case).
> >>
> >> To efficiently identify free pages that can to be reported to the
> >> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
> >> chunks are reported to the hypervisor - especially, to not break up THP
> >> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bits
> >> in the bitmap are an indication whether a page *might* be free, not a
> >> guarantee. A new hook after buddy merging sets the bits.
> >>
> >> Bitmaps are stored per zone, protected by the zone lock. A workqueue
> >> asynchronously processes the bitmaps, trying to isolate and report pages
> >> that are still free. The backend (virtio-balloon) is responsible for
> >> reporting these batched pages to the host synchronously. Once reporting/
> >> freeing is complete, isolated pages are returned back to the buddy.
> >>
> >> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> [...]
> >> +static void scan_zone_bitmap(struct page_reporting_config *phconf,
> >> +                            struct zone *zone)
> >> +{
> >> +       unsigned long setbit;
> >> +       struct page *page;
> >> +       int count = 0;
> >> +
> >> +       sg_init_table(phconf->sg, phconf->max_pages);
> >> +
> >> +       for_each_set_bit(setbit, zone->bitmap, zone->nbits) {
> >> +               /* Process only if the page is still online */
> >> +               page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
> >> +                                         zone->base_pfn);
> >> +               if (!page)
> >> +                       continue;
> >> +
> > Shouldn't you be clearing the bit and dropping the reference to
> > free_pages before you move on to the next bit? Otherwise you are going
> > to be stuck with those aren't you?
> >
> >> +               spin_lock(&zone->lock);
> >> +
> >> +               /* Ensure page is still free and can be processed */
> >> +               if (PageBuddy(page) && page_private(page) >=
> >> +                   PAGE_REPORTING_MIN_ORDER)
> >> +                       count = process_free_page(page, phconf, count);
> >> +
> >> +               spin_unlock(&zone->lock);
> > So I kind of wonder just how much overhead you are taking for bouncing
> > the zone lock once per page here. Especially since it can result in
> > you not actually making any progress since the page may have already
> > been reallocated.
> >
>
> I am wondering if there is a way to measure this overhead?
> After thinking about this, I do understand your point.
> One possible way which I can think of to address this is by having a
> page_reporting_dequeue() hook somewhere in the allocation path.

Really in order to stress this you probably need to have a lot of
CPUs, a lot of memory, and something that forces a lot of pages to get
hit such as the memory shuffling feature.

> For some reason, I am not seeing this work as I would have expected
> but I don't have solid reasoning to share yet. It could be simply
> because I am putting my hook at the wrong place. I will continue
> investigating this.
>
> In any case, I may be over complicating things here, so please let me
> if there is a better way to do this.

I have already been demonstrating the "better way" I think there is to
do this. I will push v7 of it early next week unless there is some
other feedback. By putting the bit in the page and controlling what
comes into and out of the lists it makes most of this quite a bit
easier. The only limitation is you have to modify where things get
placed in the lists so you don't create a "vapor lock" that would
stall the feed of pages into the reporting engine.

> If this overhead is not significant we can probably live with it.

You have bigger issues you still have to overcome as I recall. Didn't
you still need to sort out hotplug and a sparse map with a wide span
in a zone? Without those resolved the bitmap approach is still a no-go
regardless of performance.

- Alex
