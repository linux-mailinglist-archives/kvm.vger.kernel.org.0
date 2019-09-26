Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD60BF59E
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 17:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfIZPOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 11:14:10 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37239 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfIZPOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 11:14:10 -0400
Received: by mail-io1-f66.google.com with SMTP id b19so7516191iob.4;
        Thu, 26 Sep 2019 08:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MssJfGqFwiZbEoM1zlZJzw7b6l9jnzMrISJtN812IMw=;
        b=miZFOhlNiZj9wBYrvD3inMkDNqgv/03t4AcXjQj2vy58QKPAeiC7S1h7B68x16WNV/
         i1lezg04d6pVR4IRz8WyVw830gMROKU4UdL8wnoPCJuO6SnMUhwcs+nvve74gUyjCC+0
         dEWOkaPClAf6T8s1PrbVlqv+mrCmj1k0Ah4qiy+kKDtgraf6/yaCSbKHbomFlke8r1wx
         fBnyEFXRYlDog9LZtpdNVsigxIT+1NWnosgPw4fAH55SaUB/r/e6KHgMdTsvgZ+I87A/
         3Q5UKNkb2fC5kBNIfAvwY+GoXGo78FhllVAulEEddtC23K3lN2LecL07/5+68vic0P64
         wvHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MssJfGqFwiZbEoM1zlZJzw7b6l9jnzMrISJtN812IMw=;
        b=WU76sRNLRM6gN4Gjm1cRNkeoIBTpRsjfY4AlGzh+zzddRFrw+xLS3L64rcaJQQFEOp
         7KoP6M3I662uCPxL8lvTGaBxMvoXWsrpOCYToqQnvcYtMvJlM/MkkszTxKzlJGG3lh4M
         8BnuoYkyk7SPZm7+gbqJoSf9O3CBTlktZXBTR2SDFYtsbmgr7Yn8583tmNd5Vuj1phkF
         1UBnBR2MrJ+3n2t/RrtTOJ10nXUSjaefQU0Ch0U2ZFdePuFQ43zlVhkmBdQ1IKKHNnxD
         z5WBm2BbbBg4jbHdvo9s9jDABGwCp7TGT2g+A7LLTc3ZibNWOtHzng6XY3e3gRWeRrMz
         +6Fg==
X-Gm-Message-State: APjAAAWIo/0L4qwic7HsNChUIAQRBvF4FZ/0HfimJRy3Z4xBrX6TjTl8
        zer2o6j1SIaflasNJ8PRUElpTxrBTiEPa1B3m5s=
X-Google-Smtp-Source: APXvYqzRpIn19KqBaKYU04aPj4mWJSsaF+aQ0+QWmOe3Z7+FA5esKkyUVbPU8f6HkvgdwnC6oeShzAoasKK/SjnjON0=
X-Received: by 2002:a92:b743:: with SMTP id c3mr2993184ilm.237.1569510849064;
 Thu, 26 Sep 2019 08:14:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
 <20190924142342.GX23050@dhcp22.suse.cz> <CAKgT0UcYdA+LysVVO+8Beabsd-YBH+tNUKnQgaFmrZBW1xkFxA@mail.gmail.com>
 <20190926122208.GI20255@dhcp22.suse.cz>
In-Reply-To: <20190926122208.GI20255@dhcp22.suse.cz>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 26 Sep 2019 08:13:58 -0700
Message-ID: <CAKgT0UfMooLJ9bWAhAyyznwxcUyibJr28AaSKfYbdJkguOLcvw@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm / virtio: Provide support for unused page reporting
To:     Michal Hocko <mhocko@kernel.org>
Cc:     virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
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

On Thu, Sep 26, 2019 at 5:22 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 24-09-19 08:20:22, Alexander Duyck wrote:
> > On Tue, Sep 24, 2019 at 7:23 AM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Wed 18-09-19 10:52:25, Alexander Duyck wrote:
> > > [...]
> > > > In order to try and keep the time needed to find a non-reported page to
> > > > a minimum we maintain a "reported_boundary" pointer. This pointer is used
> > > > by the get_unreported_pages iterator to determine at what point it should
> > > > resume searching for non-reported pages. In order to guarantee pages do
> > > > not get past the scan I have modified add_to_free_list_tail so that it
> > > > will not insert pages behind the reported_boundary.
> > > >
> > > > If another process needs to perform a massive manipulation of the free
> > > > list, such as compaction, it can either reset a given individual boundary
> > > > which will push the boundary back to the list_head, or it can clear the
> > > > bit indicating the zone is actively processing which will result in the
> > > > reporting process resetting all of the boundaries for a given zone.
> > >
> > > Is this any different from the previous version? The last review
> > > feedback (both from me and Mel) was that we are not happy to have an
> > > externally imposed constrains on how the page allocator is supposed to
> > > maintain its free lists.
> >
> > The main change for v10 versus v9 is that I allow the page reporting
> > boundary to be overridden. Specifically there are two approaches that
> > can be taken.
> >
> > The first is to simply reset the iterator for whatever list is
> > updated. What this will do is reset the iterator back to list_head and
> > then you can do whatever you want with that specific list.
>
> OK, this is slightly better than pushing the allocator to the corner.
> The allocator really has to be under control of its data structures.
> I would still be happier if the allocator wouldn't really have to bother
> about somebody snooping its internal state to do its own thing. So
> please make sure to describe why and how much this really matters.

Okay I can try to do that. I suppose if nothing else I can put
together a test patch that reverts these bits and can add
documentation on the amount of regression seen without those bits. I
should be able to get that taken care of and a v11 out in the next few
days.

> > The other option is to simply clear the ZONE_PAGE_REPORTING_ACTIVE
> > bit. That will essentially notify the page reporting code that any/all
> > hints that were recorded have been discarded and that it needs to
> > start over.
> >
> > All I am trying to do with this approach is reduce the work. Without
> > doing this the code has to walk the entire free page list for the
> > higher orders every iteration and that will not be cheap.
>
> How expensive this will be?

Well without this I believe the work goes from being O(n) to O(n^2) as
we would have to walk the list every time we pull the batch of pages,
so without the iterator we end up having walk the page list
repeatedly. I suspect it becomes more expensive the more memory we
have. I'll be able to verify it later today once I can generate some
numbers.

> > Admittedly
> > it is a bit more invasive than the cut/splice logic used in compaction
> > which is taking the pages it has already processed and moving them to
> > the other end of the list. However, I have reduced things so that we
> > only really are limiting where add_to_free_list_tail can place pages,
> > and we are having to check/push back the boundaries if a reported page
> > is removed from a free_list.
> >
> > > If this is really the only way to go forward then I would like to hear
> > > very convincing arguments about other approaches not being feasible.
> > > There are none in this cover letter unfortunately. This will be really a
> > > hard sell without them.
> >
> > So I had considered several different approaches.
>
> Thanks this is certainly useful and it would have been even more so if
> you gave some rough numbers to quantify how much overhead for different
> solutions we are talking about here.

I'll see what I can do. As far as the bitmap solution I think Nitesh
has numbers for what he has been able to get out of it. At this point
I would assume his solution for the virtio/QEMU bits is probably
identical to mine so it should be easier to get an apples to apples
comparison.

Thanks.

- Alex
