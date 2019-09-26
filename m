Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A11BF2D5
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 14:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfIZMWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 08:22:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:55872 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbfIZMWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 08:22:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DA408B11E;
        Thu, 26 Sep 2019 12:22:10 +0000 (UTC)
Date:   Thu, 26 Sep 2019 14:22:08 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
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
Subject: Re: [PATCH v10 0/6] mm / virtio: Provide support for unused page
 reporting
Message-ID: <20190926122208.GI20255@dhcp22.suse.cz>
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
 <20190924142342.GX23050@dhcp22.suse.cz>
 <CAKgT0UcYdA+LysVVO+8Beabsd-YBH+tNUKnQgaFmrZBW1xkFxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcYdA+LysVVO+8Beabsd-YBH+tNUKnQgaFmrZBW1xkFxA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue 24-09-19 08:20:22, Alexander Duyck wrote:
> On Tue, Sep 24, 2019 at 7:23 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Wed 18-09-19 10:52:25, Alexander Duyck wrote:
> > [...]
> > > In order to try and keep the time needed to find a non-reported page to
> > > a minimum we maintain a "reported_boundary" pointer. This pointer is used
> > > by the get_unreported_pages iterator to determine at what point it should
> > > resume searching for non-reported pages. In order to guarantee pages do
> > > not get past the scan I have modified add_to_free_list_tail so that it
> > > will not insert pages behind the reported_boundary.
> > >
> > > If another process needs to perform a massive manipulation of the free
> > > list, such as compaction, it can either reset a given individual boundary
> > > which will push the boundary back to the list_head, or it can clear the
> > > bit indicating the zone is actively processing which will result in the
> > > reporting process resetting all of the boundaries for a given zone.
> >
> > Is this any different from the previous version? The last review
> > feedback (both from me and Mel) was that we are not happy to have an
> > externally imposed constrains on how the page allocator is supposed to
> > maintain its free lists.
> 
> The main change for v10 versus v9 is that I allow the page reporting
> boundary to be overridden. Specifically there are two approaches that
> can be taken.
> 
> The first is to simply reset the iterator for whatever list is
> updated. What this will do is reset the iterator back to list_head and
> then you can do whatever you want with that specific list.

OK, this is slightly better than pushing the allocator to the corner.
The allocator really has to be under control of its data structures.
I would still be happier if the allocator wouldn't really have to bother
about somebody snooping its internal state to do its own thing. So
please make sure to describe why and how much this really matters.
 
> The other option is to simply clear the ZONE_PAGE_REPORTING_ACTIVE
> bit. That will essentially notify the page reporting code that any/all
> hints that were recorded have been discarded and that it needs to
> start over.
> 
> All I am trying to do with this approach is reduce the work. Without
> doing this the code has to walk the entire free page list for the
> higher orders every iteration and that will not be cheap.

How expensive this will be?

> Admittedly
> it is a bit more invasive than the cut/splice logic used in compaction
> which is taking the pages it has already processed and moving them to
> the other end of the list. However, I have reduced things so that we
> only really are limiting where add_to_free_list_tail can place pages,
> and we are having to check/push back the boundaries if a reported page
> is removed from a free_list.
> 
> > If this is really the only way to go forward then I would like to hear
> > very convincing arguments about other approaches not being feasible.
> > There are none in this cover letter unfortunately. This will be really a
> > hard sell without them.
> 
> So I had considered several different approaches.

Thanks this is certainly useful and it would have been even more so if
you gave some rough numbers to quantify how much overhead for different
solutions we are talking about here.
-- 
Michal Hocko
SUSE Labs
