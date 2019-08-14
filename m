Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09508D7C1
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 18:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfHNQLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 12:11:21 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44058 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfHNQLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 12:11:21 -0400
Received: by mail-ot1-f65.google.com with SMTP id w4so8579205ote.11;
        Wed, 14 Aug 2019 09:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gLha39uJ7xSzH6EOKx6Ty45U3smvnaB95vYD2OPwAv8=;
        b=byL31XZQDEfx7oi+zOLIDiTsyFeUHaMeu+ncxQyapCaGZvYbr006KzVYB6bfvaGxtY
         14JDd4pFeftCGu++zoD7t9rhlzWimuyB+Un3z1eGCjptTWmfKEfIagSw4aGTMiWfDaQA
         ood1Vf7jS4K0lyc9/xycww4HTvlSLUWS9tOJf85iE7ecIAISWm3oDqaTWKU4kY0fCgNK
         dBgjrFBVSOTyUq8fy84e89vE2X0VDMX2FOMe6aohy6IYuD7Q3iBMwXqu7mMeVyrTv8vE
         KTJll45feN+Gu7n4UAxj5gkcfJ5xogLiXPCNiFqHKziuZV6q6wW1auGQPzvLBGnKHPvv
         0qWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gLha39uJ7xSzH6EOKx6Ty45U3smvnaB95vYD2OPwAv8=;
        b=of+4ZmaBf7XpaIEDI9iVJ5S/LH4s9NPt6uWt/RXP6lAD7mfdqEQbAPV5OKjh7NTC1E
         KIjzDcX3t9anr+VKjD8a+UOicE5DBz5d+R03+JezjAwL38esQ3h0ufUIfVZCgrcsNnfJ
         NLGXBmFknxfns3O+ZduRtf3Iwe66TbQGz6CsLfZkJRzJng9fzSO5pTYtnmxdfjNs4k+x
         Noz8dirQcqxJQzZvrIi4R39eqdnonUUZB32Dzld07le/OCueXfN8n9+ZODuP1sIhm2Ol
         XjFp3dMyK2LoQNJvW34+7Wk4zJ0IpQpKwG+K2AdviT0dQH/wNO3ViwXABqR0v3I5sDNp
         7pKQ==
X-Gm-Message-State: APjAAAUN0jK+BqKDYGZxRz68/AHtNbQP+oKcdb7H0m2F2VwPj43lxBMw
        129qxI6Vdk/vfux/eTCDTOBtKp50ZKSBia68xEw=
X-Google-Smtp-Source: APXvYqyiDotBG1l/GFFiRKLB71XyCU0ZOkfcEXG3qMRU+qXeXI1Sp4sGV9nfXTPpRf1fa2Ba9MU/DBEB8o2LAjLYwYY=
X-Received: by 2002:a5e:8c11:: with SMTP id n17mr706399ioj.64.1565799080429;
 Wed, 14 Aug 2019 09:11:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190812131235.27244-1-nitesh@redhat.com> <20190812131235.27244-2-nitesh@redhat.com>
 <CAKgT0UcSabyrO=jUwq10KpJKLSuzorHDnKAGrtWVigKVgvD-6Q@mail.gmail.com> <6d5b57ca-41ff-5c54-ab20-2b1631a6ce29@redhat.com>
In-Reply-To: <6d5b57ca-41ff-5c54-ab20-2b1631a6ce29@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 14 Aug 2019 09:11:09 -0700
Message-ID: <CAKgT0UfavuUT4ZvfxVdm3h25qc86ksxPO=GFpFkf8zbGAjHPvg@mail.gmail.com>
Subject: Re: [RFC][Patch v12 1/2] mm: page_reporting: core infrastructure
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, virtio-dev@lists.oasis-open.org,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        Pankaj Gupta <pagupta@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
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

On Wed, Aug 14, 2019 at 8:49 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
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
> >
> [...]
> >> +}
> >> +
> >> +/**
> >> + * __page_reporting_enqueue - tracks the freed page in the respective zone's
> >> + * bitmap and enqueues a new page reporting job to the workqueue if possible.
> >> + */
> >> +void __page_reporting_enqueue(struct page *page)
> >> +{
> >> +       struct page_reporting_config *phconf;
> >> +       struct zone *zone;
> >> +
> >> +       rcu_read_lock();
> >> +       /*
> >> +        * We should not process this page if either page reporting is not
> >> +        * yet completely enabled or it has been disabled by the backend.
> >> +        */
> >> +       phconf = rcu_dereference(page_reporting_conf);
> >> +       if (!phconf)
> >> +               return;
> >> +
> >> +       zone = page_zone(page);
> >> +       bitmap_set_bit(page, zone);
> >> +
> >> +       /*
> >> +        * We should not enqueue a job if a previously enqueued reporting work
> >> +        * is in progress or we don't have enough free pages in the zone.
> >> +        */
> >> +       if (atomic_read(&zone->free_pages) >= phconf->max_pages &&
> >> +           !atomic_cmpxchg(&phconf->refcnt, 0, 1))
> > This doesn't make any sense to me. Why are you only incrementing the
> > refcount if it is zero? Combining this with the assignment above, this
> > isn't really a refcnt. It is just an oversized bitflag.
>
>
> The intent for having an extra variable was to ensure that at a time only one
> reporting job is enqueued. I do agree that for that purpose I really don't need
> a reference counter and I should have used something like bool
> 'page_hinting_active'. But with bool, I think there could be a possible chance
> of race. Maybe I should rename this variable and keep it as atomic.
> Any thoughts?

You could just use a bitflag to achieve what you are doing here. That
is the primary use case for many of the test_and_set_bit type
operations. However one issue with doing it as a bitflag is that you
have no way of telling that you took care of all requesters. That is
where having an actual reference count comes in handy as you know
exactly how many zones are requesting to be reported on.

> >
> > Also I am pretty sure this results in the opportunity to miss pages
> > because there is nothing to prevent you from possibly missing a ton of
> > pages you could hint on if a large number of pages are pushed out all
> > at once and then the system goes idle in terms of memory allocation
> > and freeing.
>
>
> I was looking at how you are enqueuing/processing reporting jobs for each zone.
> I am wondering if I should also consider something on similar lines as having
> that I might be able to address the concern which you have raised above. But it
> would also mean that I have to add an additional flag in the zone_flags. :)

You could do it either in the zone or outside the zone as yet another
bitmap. I decided to put the flags inside the zone because there was a
number of free bits there and it should be faster since we were
already using the zone structure.
