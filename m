Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F355CB0B50
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 11:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbfILJ0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 05:26:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:57734 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730558AbfILJ0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 05:26:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD20AAED6;
        Thu, 12 Sep 2019 09:26:12 +0000 (UTC)
Date:   Thu, 12 Sep 2019 11:26:11 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
Message-ID: <20190912092611.GN4023@dhcp22.suse.cz>
References: <20190911121941.GU4023@dhcp22.suse.cz>
 <20190911122526.GV4023@dhcp22.suse.cz>
 <4748a572-57b3-31da-0dde-30138e550c3a@redhat.com>
 <20190911125413.GY4023@dhcp22.suse.cz>
 <736594d6-b9ae-ddb9-2b96-85648728ef33@redhat.com>
 <20190911132002.GA4023@dhcp22.suse.cz>
 <20190911135100.GC4023@dhcp22.suse.cz>
 <abea20a0-463c-68c0-e810-2e341d971b30@redhat.com>
 <20190912071633.GL4023@dhcp22.suse.cz>
 <ef460202-cebd-c6d2-19f3-e8a82a3d3cbd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef460202-cebd-c6d2-19f3-e8a82a3d3cbd@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu 12-09-19 09:47:30, David Hildenbrand wrote:
> On 12.09.19 09:16, Michal Hocko wrote:
> > On Wed 11-09-19 18:09:18, David Hildenbrand wrote:
> >> On 11.09.19 15:51, Michal Hocko wrote:
> >>> On Wed 11-09-19 15:20:02, Michal Hocko wrote:
> >>> [...]
> >>>>> 4. Continuously report, not the "one time report everything" approach.
> >>>>
> >>>> So you mean the allocator reporting this rather than an external code to
> >>>> poll right? I do not know, how much this is nice to have than must have?
> >>>
> >>> Another idea that I haven't really thought through so it might turned
> >>> out to be completely bogus but let's try anyway. Your "report everything"
> >>> just made me look and realize that free_pages_prepare already performs
> >>> stuff that actually does something similar yet unrelated.
> >>>
> >>> We do report to special page poisoning, zeroying or
> >>> CONFIG_DEBUG_PAGEALLOC to unmap the address from the kernel address
> >>> space. This sounds like something fitting your model no?
> >>>
> >>
> >> AFAIKS, the poisoning/unmapping is done whenever a page is freed. I
> >> don't quite see yet how that would help to remember if a page was
> >> already reported.
> > 
> > Do you still have to differ that state when each page is reported?
> 
> Ah, very good point. I can see that the reason for this was not
> discussed in this thread so far. (Alexander, Nitesh, please correct me
> if I am wrong). It's buried in the long history of free page
> hinting/reporting.

It would really be preferable to summarize such a previous discussion
ideally with some references.

> Some early patch sets tried to report during every free synchronously.
> Free a page, report them to the hypervisor. This resulted in some issues
> (especially, locking-related and the virtio + the hypervisor being
> involved, resulting in unpredictable delays, quite some overhead ...).
> It was no good.
> 
> One design decision then was to not report single pages, but a bunch of
> pages at once. This made it necessary to "remember" the pages to be
> reported and to temporarily block them from getting allocated while
> reporting.
> 
> Nitesh implemented (at least) two "capture PFNs of free pages in an
> array when freeing" approaches. One being synchronous from the freeing
> CPU once the list was full (having similar issues as plain synchronous
> reporting) and one being asynchronous by a separate thread (which solved
> many locking issues).
> 
> Turned out the a simple array can quickly lead to us having to drop
> "reports" to the hypervisor because the array is full and the reporting
> thread was not able to keep up. Not good as well. Especially, if some
> process frees a lot of memory this can happen quickly and Nitesh wa
> sable to trigger this scenario frequently.
> 
> Finally, Nitesh decided to use the bitmap instead to keep track of pages
> to report. I'd like to note that this approach could still be combined
> with an "array of potentially free PFNs". Only when the array/circular
> buffer runs out of entries ("reporting thread cannot keep up"), we would
> have to go back to scanning the bitmap.
> 
> That was also the point where Alexander decided to look into integrating
> tracking/handling reported/unreported pages directly in the buddy.

OK, this gives at least some background which is really appreciated.
Explaining _why_ you need something in the core MM is essential to move
forward.
 
> >> After reporting the page we would have to switch some
> >> state (Nitesh: bitmap bit, Alexander: page flag) to identify that.
> > 
> > Yes, you can either store the state somewhere.
> > 
> >> Of course, we could map the page and treat that as "the state" when we
> >> reported it, but I am not sure that's such a good idea :)
> >>
> >> As always, I might be very wrong ...
> > 
> > I still do not fully understand the usecase so I might be equally wrong.
> > My thinking is along these lines. Why should you scan free pages when
> > you can effectively capture each freed page? If you go one step further
> > then post_alloc_hook would be the counterpart to know that your page has
> > been allocated.
> 
> I'd like to note that Nitesh's patch set contains the following hunk,
> which is roughly what you were thinking :)
> 
> 
> -static inline void __free_one_page(struct page *page,
> +inline void __free_one_page(struct page *page,
>  		unsigned long pfn,
>  		struct zone *zone, unsigned int order,
> -		int migratetype)
> +		int migratetype, bool hint)
>  {
>  	unsigned long combined_pfn;
>  	unsigned long uninitialized_var(buddy_pfn);
> @@ -980,7 +981,8 @@ static inline void __free_one_page(struct page *page,
>  				migratetype);
>  	else
>  		add_to_free_area(page, &zone->free_area[order], migratetype);
> -
> +	if (hint)
> +		page_hinting_enqueue(page, order);
>  }
> 
> 
> (ignore the hint parameter, when he would switch to a isolate vs.
> alloc/free, that can go away and all we left is the enqueue part)
> 
> 
> Inside that callback we can remember the pages any way we want. Right
> now in a bitmap. Maybe later in a array + bitmap (as discussed above).
> Another idea I had was to simply go over all pages and report them when
> running into this "array full" condition. But I am not yet sure about
> the performance implications on rather large machines. So the bitmap
> idea might have some other limitations but seems to do its job.
> 
> Hoe that makes things clearer and am not missing something.

It certainly helped me to get a better idea. I have commented on my
reservations regarding the approach in this thread elsewhere but at
least I _think_ I am getting a point of what you guys try to achieve.

Thanks!
-- 
Michal Hocko
SUSE Labs
