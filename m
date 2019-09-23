Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7013BB9C3
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 18:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389642AbfIWQjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 12:39:16 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46883 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389238AbfIWQjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 12:39:16 -0400
Received: by mail-io1-f66.google.com with SMTP id c6so21840943ioo.13;
        Mon, 23 Sep 2019 09:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RFFieyhD7JzCXe5ifm6amcb6+lfbnrSI8cAPQ36MW7I=;
        b=R858SkgO5YchV55UFuoykyOJ1d6HANKAKcyNyXSnFjlDxWsun6RWo/szs6mFJe3Gl7
         SpP8oCIxZAzjM/+mZzbvhek60QM+vQZHmgd6exOWOQ1rxiMl1xshylLYEEfBAIaAMWij
         x17aBb18cOyd7Gg7jK7CY1adHHq+3GNeBb3vmLGvWhmMy13uO5l0VWhyyBV6WJQv0V4B
         oHsBuvX5GMOyTZdaE6GRZMK00UfWpjPcuIlrVD0sbAPdGTfcZrfg/SegWSPVy3b6T3s9
         rAjNxT2QY7bGNbKEXSyko1pUSYiwD2IyNLRIo+29fcBqwwXyf2UpdDm4+eCsUdBcDf0M
         NGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RFFieyhD7JzCXe5ifm6amcb6+lfbnrSI8cAPQ36MW7I=;
        b=fOQdZrzm1Zuysos+GKJEdiFCAIyeP/DBo1G0ydNqg2//kqv6bT3qFMavr5hEuFJ/Zz
         mdOA+2v/dxg5dxDPYLu8Mz+KGSkpjzNjTEkliZOhEe6KdQ2YgDu0pEG7VMrsK79TlsCz
         c74JlDanSy/JY1xTJXyGqCLKiLkjsz/VB3eQd3I4yB9b9RCxjuxHEayjyVGb/F1YLMHG
         Rde1g3itBXsf63UFUV1HIppSPHyMSo6Hs1xUzYxvdhD4DGDM6F3xndHzYA3+zUQgRuON
         4APKwMr4mkuvqrJrJsnFSc1m8dQyIPkp7JFlf4slzLzwthlOQs85H5XquAZ1Q2GJF8Bz
         yz/w==
X-Gm-Message-State: APjAAAUdcmZ2iSZSgNMuNV74MRQGjQBCKKpzkS1J8al7Yvwn4xYkR2UO
        wauVgpna7CiEZafCB+pSk/ql7VjS4+UAcRTIJjo6wQ==
X-Google-Smtp-Source: APXvYqy3q7z0+B3zJnmH5mJA6m7Vv33JAsSr6VocMaurzTxah7VBiRqRJR2aBGpPsIduojTBLoR7xf0CVw90j+76/ro=
X-Received: by 2002:a02:246:: with SMTP id 67mr278140jau.121.1569256755054;
 Mon, 23 Sep 2019 09:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
 <20190918175249.23474.51171.stgit@localhost.localdomain> <20190923041330-mutt-send-email-mst@kernel.org>
 <CAKgT0UfFBO9h3heGSo+AaZgUNpy5uuOm3yh62bYwYJ5dq+t1gQ@mail.gmail.com>
 <20190923105746-mutt-send-email-mst@kernel.org> <CAKgT0Ufp0bdz3YkbAoKWd5DALFjAkHaSUn_UywW1+3hk4tjPSQ@mail.gmail.com>
 <20190923113722-mutt-send-email-mst@kernel.org> <baf3dd5c-9368-d621-a83a-114bb5ae8291@redhat.com>
In-Reply-To: <baf3dd5c-9368-d621-a83a-114bb5ae8291@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 23 Sep 2019 09:39:03 -0700
Message-ID: <CAKgT0UePDMnXRUxwWnkwb-WZTD+M02bZk+PbuHJ3i9ATzkM0WA@mail.gmail.com>
Subject: Re: [PATCH v10 3/6] mm: Introduce Reported pages
To:     David Hildenbrand <david@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 8:46 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 23.09.19 17:37, Michael S. Tsirkin wrote:
> > On Mon, Sep 23, 2019 at 08:28:00AM -0700, Alexander Duyck wrote:
> >> On Mon, Sep 23, 2019 at 8:00 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >>>
> >>> On Mon, Sep 23, 2019 at 07:50:15AM -0700, Alexander Duyck wrote:
> >>>>>> +static inline void
> >>>>>> +page_reporting_reset_boundary(struct zone *zone, unsigned int order, int mt)
> >>>>>> +{
> >>>>>> +     int index;
> >>>>>> +
> >>>>>> +     if (order < PAGE_REPORTING_MIN_ORDER)
> >>>>>> +             return;
> >>>>>> +     if (!test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
> >>>>>> +             return;
> >>>>>> +
> >>>>>> +     index = get_reporting_index(order, mt);
> >>>>>> +     reported_boundary[index] = &zone->free_area[order].free_list[mt];
> >>>>>> +}
> >>>>>
> >>>>> So this seems to be costly.
> >>>>> I'm guessing it's the access to flags:
> >>>>>
> >>>>>
> >>>>>         /* zone flags, see below */
> >>>>>         unsigned long           flags;
> >>>>>
> >>>>>         /* Primarily protects free_area */
> >>>>>         spinlock_t              lock;
> >>>>>
> >>>>>
> >>>>>
> >>>>> which is in the same cache line as the lock.
> >>>>
> >>>> I'm not sure what you mean by this being costly?
> >>>
> >>> I've just been wondering why does will it scale report a 1.5% regression
> >>> with this patch.
> >>
> >> Are you talking about data you have collected from a test you have
> >> run, or the data I have run?
> >
> > About the kernel test robot auto report that was sent recently.
>
> https://lkml.org/lkml/2019/9/21/112
>
> And if I'm correct, that regression is observable in case reporting is
> not enabled. (so with this patch applied only, e.g., on a bare-metal system)

Thanks. For whatever reason it looks like my gmail decided to pop it
out of the thread so I hadn't seen it yet this morning.

I'll have to look into it. It doesn't make much sense to me why this
would have this much impact since especially in the disabled case the
changes should be quite small.

- Alex
