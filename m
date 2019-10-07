Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62EDACE929
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 18:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfJGQ10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 12:27:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:5505 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbfJGQ1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 12:27:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 09:27:24 -0700
X-IronPort-AV: E=Sophos;i="5.67,268,1566889200"; 
   d="scan'208";a="276845222"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 09:27:24 -0700
Message-ID: <5b6e0b6df46c03bfac906313071ac0362d43c432.camel@linux.intel.com>
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 07 Oct 2019 09:27:24 -0700
In-Reply-To: <7fc13837-546c-9c4a-1456-753df199e171@redhat.com>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
         <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com>
         <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
         <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com>
         <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
         <c06b68cb-5e94-ae3e-f84e-48087d675a8f@redhat.com>
         <CAKgT0Ud6TT=XxqFx6ePHzbUYqMp5FHVPozRvnNZK3tKV7j2xjg@mail.gmail.com>
         <0a16b11e-ec3b-7196-5b7f-e7395876cf28@redhat.com>
         <d96f744d2c48f5a96c6962c6a0a89d2429e5cab8.camel@linux.intel.com>
         <7fc13837-546c-9c4a-1456-753df199e171@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-10-07 at 12:19 -0400, Nitesh Narayan Lal wrote:
> On 10/7/19 11:33 AM, Alexander Duyck wrote:
> > On Mon, 2019-10-07 at 08:29 -0400, Nitesh Narayan Lal wrote:
> > > On 10/2/19 10:25 AM, Alexander Duyck wrote:
> > > 
> [...]
> > > You  don't have to, I can fix the issues in my patch-set. :)
> > > > Sounds good. Hopefully the stuff I pointed out above helps you to get
> > > > a reproduction and resolve the issues.
> > > So I did observe a significant drop in running my v12 path-set [1] with the
> > > suggested test setup. However, on making certain changes the performance
> > > improved significantly.
> > > 
> > > I used my v12 patch-set which I have posted earlier and made the following
> > > changes:
> > > 1. Started reporting only (MAX_ORDER - 1) pages and increased the number of
> > >     pages that can be reported at a time to 32 from 16. The intent of making
> > >     these changes was to bring my configuration closer to what Alexander is
> > >     using.
> > The increase from 16 to 32 is valid. No point in working in too small of
> > batches. However tightening the order to only test for MAX_ORDER - 1 seems
> > like a step in the wrong direction. The bitmap approach doesn't have much
> > value if it can only work with the highest order page. I realize it is
> > probably necessary in order to make the trick for checking on page_buddy
> > work, but it seems very limiting.
> 
> If using (pageblock_order - 1) is a better way to do this, then I can probably
> switch to that.
> I will agree with the fact that we have to make the reporting order
> configurable, atleast to an extent.

I think you mean pageblock_order, not pageblock_order - 1. The problem
with pageblock_order - 1 is that it will have a negative impact on
performance as it would disable THP.

> > > 2. I made an additional change in my bitmap scanning logic to prevent acquiring
> > >     spinlock if the page is already allocated.
> > Again, not a fan. It basically means you can only work with MAX_ORDER - 1
> > and there will be no ability to work with anything smaller.
> > 
> > > Setup:
> > > On a 16 vCPU 30 GB single NUMA guest affined to a single host NUMA, I ran the
> > > modified will-it-scale/page_fault number of times and calculated the average
> > > of the number of process and threads launched on the 16th core to compare the
> > > impact of my patch-set against an unmodified kernel.
> > > 
> > > 
> > > Conclusion:
> > > %Drop in number of processes launched on 16th vCPU =     1-2%
> > > %Drop in number of threads launched on 16th vCPU     =     5-6%
> > These numbers don't make that much sense to me. Are you talking about a
> > fully functioning setup that is madvsing away the memory in the
> > hypervisor?
> 
> Without making this change I was observing a significant amount of drop
> in the number of processes and specifically in the number of threads.
> I did a double-check of the configuration which I have shared.
> I was also observing the "AnonHugePages" via meminfo to check the THP usage.
> Any more suggestions about what else I can do to verify?
> I will be more than happy to try them out.

So what was the size of your guest? One thing that just occurred to me is
that you might be running a much smaller guest than I was.

> >  If so I would have expected a much higher difference versus
> > baseline as zeroing/faulting the pages in the host gets expensive fairly
> > quick. What is the host kernel you are running your test on? I'm just
> > wondering if there is some additional overhead currently limiting your
> > setup. My host kernel was just the same kernel I was running in the guest,
> > just built without the patches applied.
> 
> Right now I have a different host-kernel. I can install the same kernel to the
> host as well and see if that changes anything.

The host kernel will have a fairly significant impact as I recall. For
example running a stock CentOS kernel lowered the performance compared to
running a linux-next kernel. As a result the numbers looked better since
the overall baseline was lower to begin with as the host OS was
introducing additional overhead.

> > > Other observations:
> > > - I also tried running Alexander's latest v11 page-reporting patch set and
> > >   observe a similar amount of average degradation in the number of processes
> > >   and threads.
> > > - I didn't include the linear component recorded by will-it-scale because for
> > >   some reason it was fluctuating too much even when I was using an unmodified
> > >   kernel. If required I can investigate this further.
> > > 
> > > Note: If there is a better way to analyze the will-it-scale/page_fault results
> > > then please do let me know.
> > Honestly I have mostly just focused on the processes performance.
> 
> In my observation processes seems to be most consistent in general.

Agreed.

> >  There is
> > usually a fair bit of variability but a pattern forms after a few runs so
> > you can generally tell if a configuration is an improvement or not.
> 
> Yeah, that's why I thought of taking the average of 5-6 runs.

Same here. I am usually running about 5 iterations.

> > > Other setup details:
> > > Following are the configurations which I enabled to run my tests:
> > > - Enabled: CONFIG_SLAB_FREELIST_RANDOM & CONFIG_SHUFFLE_PAGE_ALLOCATOR
> > > - Set host THP to always
> > > - Set guest THP to madvise
> > > - Added the suggested madvise call in page_fault source code.
> > > @Alexander please let me know if I missed something.
> > This seems about right.
> > 
> > > The current state of my v13:
> > > I still have to look into Michal's suggestion of using page-isolation API's
> > > instead of isolating the page. However, I believe at this moment our objective
> > > is to decide with which approach we can proceed and that's why I decided to
> > > post the numbers by making small required changes in v12 instead of posting a
> > > new series.
> > > 
> > > 
> > > Following are the changes which I have made on top of my v12:
> > > 
> > > page_reporting.h change:
> > > -#define PAGE_REPORTING_MIN_ORDER               (MAX_ORDER - 2)
> > > -#define PAGE_REPORTING_MAX_PAGES               16
> > > +#define PAGE_REPORTING_MIN_ORDER              (MAX_ORDER - 1)
> > > +#define PAGE_REPORTING_MAX_PAGES              32
> > > 
> > > page_reporting.c change:
> > > @@ -101,8 +101,12 @@ static void scan_zone_bitmap(struct page_reporting_config
> > > *phconf,
> > >                 /* Process only if the page is still online */
> > >                 page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
> > >                                           zone->base_pfn);
> > > -               if (!page)
> > > +               if (!page || !PageBuddy(page)) {
> > > +                       clear_bit(setbit, zone->bitmap);
> > > +                       atomic_dec(&zone->free_pages);
> > >                         continue;
> > > +               }
> > > 
> > I suspect the zone->free_pages is going to be expensive for you to deal
> > with. It is a global atomic value and is going to have the cacheline
> > bouncing that it is contained in. As a result thinks like setting the
> > bitmap with be more expensive as every tome a CPU increments free_pages it
> > will likely have to take the cache line containing the bitmap pointer as
> > well.
> 
> I see I will have to explore this more. I am wondering if there is a way to
> measure this If its effect is not visible in will-it-scale/page_fault1. If
> there is a noticeable amount of degradation, I will have to address this.

If nothing else you might look at seeing if you can split up the
structures so that the bitmap and nr_bits is in a different region
somewhere since those are read-mostly values.

Also you are now updating the bitmap and free_pages both inside and
outside of the zone lock so that will likely have some impact.

> > > @Alexander in case you decide to give it a try and find different results,
> > > please do let me know.
> > > 
> > > [1] https://lore.kernel.org/lkml/20190812131235.27244-1-nitesh@redhat.com/
> > > 
> > > 
> > If I have some free time I will take a look.
> 
> That would be great, thanks.
> 
> >  However one thing that
> > concerns me about this change is that it will limit things much further in
> > terms of how much memory can ultimately be freed since you are now only
> > working with the highest order page and that becomes a hard requirement
> > for your design.
> 
> I would assume that should be resolved with (pageblock_order - 1).

There is no need for the - 1. The pageblock_order value is the lowest you
can go before you start causing THP to be disabled. If you cross that
threshold the performance will drop significantly. 

