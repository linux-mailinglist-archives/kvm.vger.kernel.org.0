Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43DC89991A
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 18:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389893AbfHVQYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 12:24:50 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41353 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389867AbfHVQYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 12:24:50 -0400
Received: by mail-io1-f67.google.com with SMTP id j5so13015858ioj.8;
        Thu, 22 Aug 2019 09:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O/Rn5qcoy7BQBKOAN8lQSNVqcodC1sml/1HztLPmPY8=;
        b=Ej6/01HUyOove1llDfiVALHzwkEJs2MC17YrBQtF58o9MWpuPRVLfgv2ovJcPGpzk5
         +EVLsiGinkPtC/1jan6MHfnvOxef1kQkVho8kCP9rKHWn/1yJxJtn1/QjcUAgOK/yYae
         4aPn97HI3+G0OJGh9eV3qzmnNewkLku5to/FRSj2mdayX0uU3CDScXgZqys7F3P1GxEx
         oDBve+y3N9OTUVeEBqCpq1PeptowFI//nGCyWZLaGzrN1aWDkKS18wsb2HBm6sy8UlQf
         8tUOsCMr2lwbupWe9lwdwgZ5B3HamP/0/EGRGvARkRR5Zv0IKwtuNHQrIq3e+qP/kKKT
         EZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O/Rn5qcoy7BQBKOAN8lQSNVqcodC1sml/1HztLPmPY8=;
        b=QVEr+hASvP+DyMUAkE9nG8fg6eDBAu2moPqFZK4iTKbCoViruBGMHObn/oW1RppI6H
         OLz0atvHOid4YQV8NDXkil8kVPOIyqZLPbd0xxx/zQkyOQy80Y5A60nrc3OUPleZPEd3
         p2C7mc/WNuq6UZL2HYLyGJVRkqzbdtMrnCo0iIBVg81h2SBr/lndbPLZvd+9+S9Mm/mr
         xALm/Mp7rYu2kXfEN1Q54s6I/9vimedPcyG7abCMSzipP7oA6yNb3vQQpd3hKU5Prex7
         gVh5P7vz5KUEbPTQWXx06jiP8WI7UOmUk3JisGGkRkiwBLK92NxFedtOnB2fURJKt8RT
         xGNQ==
X-Gm-Message-State: APjAAAUlG1DQ1DzCEt0fkNLtQt9XLstcbUp2UJ58YvAX+TZzPrqNnj3S
        E+yCFJoIejIzztwYZwHvJiBE9c1Mn0OluXUS1aE=
X-Google-Smtp-Source: APXvYqyxn9px69p1obzCaGficBATfeUEzqjvnLugjNBV7+KMpVmv/zqC7jztjI0xxXxeLkWOC1qslt97HyHsKgXPSjw=
X-Received: by 2002:a5e:8c11:: with SMTP id n17mr676146ioj.64.1566491088983;
 Thu, 22 Aug 2019 09:24:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190821145806.20926.22448.stgit@localhost.localdomain>
 <20190821145950.20926.83684.stgit@localhost.localdomain> <91355107-ed73-fce5-7051-3a746b526163@redhat.com>
In-Reply-To: <91355107-ed73-fce5-7051-3a746b526163@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 22 Aug 2019 09:24:37 -0700
Message-ID: <CAKgT0UeFyxH9pEsQ+CcZo3c4-GZdqsw6ucPG2KOkefvDvFF94g@mail.gmail.com>
Subject: Re: [virtio-dev] [PATCH v6 4/6] mm: Introduce Reported pages
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtio-dev@lists.oasis-open.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 9:19 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 8/21/19 10:59 AM, Alexander Duyck wrote:
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
> [...]
> > +
> > +/* request page reporting on this zone */
> > +void __page_reporting_request(struct zone *zone)
> > +{
> > +     struct page_reporting_dev_info *phdev;
> > +
> > +     rcu_read_lock();
> > +
> > +     /*
> > +      * We use RCU to protect the ph_dev_info pointer. In almost all
> > +      * cases this should be present, however in the unlikely case of
> > +      * a shutdown this will be NULL and we should exit.
> > +      */
> > +     phdev = rcu_dereference(ph_dev_info);
> > +     if (unlikely(!phdev))
> > +             return;
> > +
>
> Just a minor comment here.
> Although this is unlikely to trigger still I think you should release the
> rcu_read_lock before returning.

Thanks for catching that. I will have that fixed for next version.

- Alex
