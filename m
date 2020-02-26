Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C20117044E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 17:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgBZQ1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 11:27:06 -0500
Received: from mga18.intel.com ([134.134.136.126]:56029 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgBZQ1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 11:27:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 08:27:05 -0800
X-IronPort-AV: E=Sophos;i="5.70,488,1574150400"; 
   d="scan'208";a="226774328"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 08:27:05 -0800
Message-ID: <85a8e60bb5fe139424ec6dcc9e827e37fbec3afe.camel@linux.intel.com>
Subject: Re: [PATCH RFC v4 06/13] mm: Allow to offline unmovable
 PageOffline() pages via MEM_GOING_OFFLINE
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Qian Cai <cai@lca.pw>, Pingfan Liu <kernelfans@gmail.com>
Date:   Wed, 26 Feb 2020 08:27:04 -0800
In-Reply-To: <e0892179-b14c-84c3-1284-fc789f16e1c7@redhat.com>
References: <20191212171137.13872-1-david@redhat.com>
         <20191212171137.13872-7-david@redhat.com>
         <6ec496580ddcb629d22589a1cba8cd61cbd53206.camel@linux.intel.com>
         <267ea186-aba8-1a93-bd55-ac641f78d07e@redhat.com>
         <3d719897039273a2bb8d0fe7d12563498ebd2897.camel@linux.intel.com>
         <e0892179-b14c-84c3-1284-fc789f16e1c7@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-02-25 at 23:19 +0100, David Hildenbrand wrote:
> On 25.02.20 22:46, Alexander Duyck wrote:
> > On Tue, 2020-02-25 at 19:49 +0100, David Hildenbrand wrote:
> > > > >  /*
> > > > >   * Scan pfn range [start,end) to find movable/migratable pages (LRU pages,
> > > > > - * non-lru movable pages and hugepages). We scan pfn because it's much
> > > > > - * easier than scanning over linked list. This function returns the pfn
> > > > > - * of the first found movable page if it's found, otherwise 0.
> > > > > + * non-lru movable pages and hugepages).
> > > > > + *
> > > > > + * Returns:
> > > > > + *	0 in case a movable page is found and movable_pfn was updated.
> > > > > + *	-ENOENT in case no movable page was found.
> > > > > + *	-EBUSY in case a definetly unmovable page was found.
> > > > >   */
> > > > > -static unsigned long scan_movable_pages(unsigned long start, unsigned long end)
> > > > > +static int scan_movable_pages(unsigned long start, unsigned long end,
> > > > > +			      unsigned long *movable_pfn)
> > > > >  {
> > > > >  	unsigned long pfn;
> > > > >  
> > > > > @@ -1247,18 +1251,29 @@ static unsigned long scan_movable_pages(unsigned long start, unsigned long end)
> > > > >  			continue;
> > > > >  		page = pfn_to_page(pfn);
> > > > >  		if (PageLRU(page))
> > > > > -			return pfn;
> > > > > +			goto found;
> > > > >  		if (__PageMovable(page))
> > > > > -			return pfn;
> > > > > +			goto found;
> > > > > +
> > > > > +		/*
> > > > > +		 * Unmovable PageOffline() pages where somebody still holds
> > > > > +		 * a reference count (after MEM_GOING_OFFLINE) can definetly
> > > > > +		 * not be offlined.
> > > > > +		 */
> > > > > +		if (PageOffline(page) && page_count(page))
> > > > > +			return -EBUSY;
> > > > 
> > > > So the comment confused me a bit because technically this function isn't
> > > > about offlining memory, it is about finding movable pages. I had to do a
> > > > bit of digging to find the only consumer is __offline_pages, but if we are
> > > > going to talk about "offlining" instead of "moving" in this function it
> > > > might make sense to rename it.
> > > 
> > > Well, it's contained in memory_hotplug.c, and the only user of moving
> > > pages around in there is offlining code :) And it's job is to locate
> > > movable pages, skip over some (temporary? unmovable ones) and (now)
> > > indicate definitely unmovable ones.
> > > 
> > > Any idea for a better name?
> > > scan_movable_pages_and_stop_on_definitely_unmovable() is not so nice :)
> > 
> > I dunno. What I was getting at is that the wording here would make it
> > clearer if you simply stated that these pages "can definately not be
> > moved". Saying you cannot offline a page that is PageOffline seems kind of
> > redundant, then again calling it an Unmovable and then saying it cannot be
> > moves is also redundant I suppose. In the end you don't move them, but
> 
> So, in summary, there are
> - PageOffline() pages that are movable (balloon compaction).
> - PageOffline() pages that cannot be moved and cannot be offlined (e.g.,
>   no balloon compaction enabled, XEN, HyperV, ...) . page_count(page) >=
>   0
> - PageOffline() pages that cannot be moved, but can be offlined.
>   page_count(page) == 0.
> 
> 
> > they can be switched to offline if the page count hits 0. When that
> > happens you simply end up skipping over them in the code for
> > __test_page_isolated_in_pageblock and __offline_isolated_pages.
> 
> Yes. The thing with the wording is that pages with (PageOffline(page) &&
> !page_count(page)) can also not really be moved, but they can be skipped
> when offlining. If we call that "moving them to /dev/null", then yes,
> they can be moved to some degree :)
> 
> I can certainly do here e.g.,
> 
> /*
>  * PageOffline() pages that are not marked __PageMovable() and have a
>  * reference count > 0 (after MEM_GOING_OFFLINE) are definitely
>  * unmovable. If their reference count would be 0, they could be skipped
>  * when offlining memory sections.
>  */
> 
> And maybe I'll add to the function doc, that unmovable pages that are
> skipped in this function can include pages that can be skipped when
> offlining (moving them to nirvana).
> 
> Other suggestions?

No, this sounds good and makes it much clearer.

> [...]
> 
> > > [1] we detect a definite offlining blocker and
> > > 
> > > > > +		} while (!ret);
> > > > > +
> > > > > +		if (ret != -ENOENT) {
> > > > > +			reason = "unmovable page";
> > > 
> > > [2] we abort offlining
> > > 
> > > > > +			goto failed_removal_isolated;
> > > > >  		}
> > > > >  
> > > > >  		/*
> > 
> > Yeah, this is the piece I misread.  I knew the loop this was in previously
> > was looping when returning -ENOENT so for some reason I had it in my head
> > that you were still looping on -EBUSY.
> 
> Ah okay, I see. Yeah, that wouldn't make sense for the use case I have :)
> 
> > So the one question I would have is if at this point are we guaranteed
> > that the balloon drivers have already taken care of the page count for all
> > the pages they set to PageOffline? Based on the patch description I was
> > thinking that this was going to be looping for a while waiting for the
> > driver to clear the pages and then walking through them at the end of the
> > loop via check_pages_isolated_cb.
> 
> So, e.g., the patch description states
> 
> "Let's allow to do that by allowing to isolate any PageOffline() page
> when offlining. This way, we can reach the memory hotplug notifier
> MEM_GOING_OFFLINE, where the driver can signal that he is fine with
> offlining this page by dropping its reference count."
> 
> Any balloon driver that does not allow offlining (e.g., XEN, HyperV,
> virtio-balloon), will always have a refcount of (at least) 1. Drivers
> that want to make use of that (esp. virtio-mem, but eventually also
> HyperV), will drop their refcount via the MEM_GOING_OFFLINE call.
> 
> So yes, at this point, all applicable users were notified via
> MEM_GOING_OFFLINE and had their chance to decrement the refcount. If
> they didn't, offlining will be aborted.
> 
> Thanks again!

Thank you as well. I'm still getting up to speed on the inner workings of
much of this and so discussions such as this usually prove to be quite
beneficial for me.

