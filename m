Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46128D3F9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 14:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfHNM5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 08:57:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfHNM53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 08:57:29 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C4F022A09A0;
        Wed, 14 Aug 2019 12:57:28 +0000 (UTC)
Received: from [10.36.117.167] (ovpn-117-167.ams2.redhat.com [10.36.117.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D56A28175D;
        Wed, 14 Aug 2019 12:57:14 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
Subject: [PATCH v5 4/6] mm: Introduce Reported pages
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com
References: <20190812213158.22097.30576.stgit@localhost.localdomain>
 <20190812213344.22097.86213.stgit@localhost.localdomain>
 <222cbe8f-90c5-5437-4a77-9926cacc398f@redhat.com>
 <712cc03ea69fcd59080291b5832adddf39d20cd3.camel@linux.intel.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <d607508d-5b04-cef8-1ab7-7e4bed7fa54f@redhat.com>
Date:   Wed, 14 Aug 2019 14:57:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <712cc03ea69fcd59080291b5832adddf39d20cd3.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 14 Aug 2019 12:57:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> +struct page *get_unreported_page(struct zone *zone, unsigned int order, int mt)
>>> +{
>>> +	struct list_head *tail = get_unreported_tail(zone, order, mt);
>>> +	struct free_area *area = &(zone->free_area[order]);
>>> +	struct list_head *list = &area->free_list[mt];
>>> +	struct page *page;
>>> +
>>> +	/* zone lock should be held when this function is called */
>>> +	lockdep_assert_held(&zone->lock);
>>> +
>>> +	/* Find a page of the appropriate size in the preferred list */
>>> +	page = list_last_entry(tail, struct page, lru);
>>> +	list_for_each_entry_from_reverse(page, list, lru) {
>>> +		/* If we entered this loop then the "raw" list isn't empty */
>>> +
>>> +		/* If the page is reported try the head of the list */
>>> +		if (PageReported(page)) {
>>> +			page = list_first_entry(list, struct page, lru);
>>> +
>>> +			/*
>>> +			 * If both the head and tail are reported then reset
>>> +			 * the boundary so that we read as an empty list
>>> +			 * next time and bail out.
>>> +			 */
>>> +			if (PageReported(page)) {
>>> +				page_reporting_add_to_boundary(page, zone, mt);
>>> +				break;
>>> +			}
>>> +		}
>>> +
>>> +		del_page_from_free_list(page, zone, order);
>>> +
>>> +		/* record migratetype and order within page */
>>> +		set_pcppage_migratetype(page, mt);
>>> +		set_page_private(page, order);
>>
>> Can you elaborate why you (similar to Nitesh) have to save/restore the
>> migratetype? I can't yet follow why that is necessary. You could simply
>> set it to MOVABLE (like e.g., undo_isolate_page_range() would do via
>> alloc_contig_range()). If a pageblock is completely free, it might even
>> make sense to set it to MOVABLE.
>>
>> (mainly wondering if this is required here and what the rational is)
> 
> It was mostly a "put it back where I found it" type of logic. I suppose I
> could probably just come back and read the migratetype out of the pfnblock
> and return it there. Is that what you are thinking? If so I can probably
> look at doing that instead, assuming there are no issues with that.

"read the migratetype out of the pfnblock" - that's what I would have
done. Who could change it in the meanwhile (besides isolation)? (besides
the buddy converting migratetypes on demand). I haven't yet understood
if this saving/restring is really needed or beneficial.


> 
>> Now a theoretical issue:
>>
>> You are allocating pages from all zones, including the MOVABLE zone. The
>> pages are currently unmovable (however, only temporarily allocated).
> 
> In my mind they aren't in too different of a state from pages that have
> had their reference count dropped to 0 by something like __free_pages, but
> haven't yet reached the function __free_pages_ok.

Good point, however that code sequence is fairly small. If you have a
hypervisor call in between (+ taking the BQL, + mmap_sem in the
hypervisor), things might look different (-> more latency). However, the
hypervisor might also reschedule while in that critical section.

But I am not sure yet it there is a subtle difference between

1. Some page just got freed (and maybe we are lucky that this happened)
and we run into this corner case.

2. We are actively pulling out pages and putting them back, making this
trigger more frequently.

I guess I could try to test how alloc_contig_range() play together with
free page reporting to see if there is now a notable difference.

> 
> The general idea is that they should be in this state for a very short-
> lived period of time. They are essentially free pages that just haven't
> made it back into the buddy allocator.
> 
>> del_page_from_free_area() will clear PG_buddy, and leave the refcount of
>> the page set to zero (!). has_unmovable_pages() will skip any pages
>> either on the MOVABLE zone or with a refcount of zero. So all pages that
>> are being reported are detected as movable. The isolation of allocated
>> pages will work - which is not bad, but I wonder what the implications are.
> 
> So as per my comment above I am fairly certain this isn't a new state that
> my code has introduced. In fact isolate_movable_page() calls out the case
> in the comments at the start of the function. Specifically it states:
>         /*
>          * Avoid burning cycles with pages that are yet under __free_pages(),
>          * or just got freed under us.
>          *
>          * In case we 'win' a race for a movable page being freed under us and
>          * raise its refcount preventing __free_pages() from doing its job
>          * the put_page() at the end of this block will take care of
>          * release this page, thus avoiding a nasty leakage.
>          */
>         if (unlikely(!get_page_unless_zero(page)))
>                 goto out;
> 

Please note that this is only valid for movable pages, but not for
random pages with a refcount of zero (e.g., isolate_movable_page() is
only called when __PageMovable()).

> So it would seem like this case is already handled. I am assuming the fact
> that the migrate type for the pfnblock was set to isolate before we got
> here would mean that when I call put_reported_page the final result will
> be that the page is placed into the freelist for the isolate migratetype.
> 
>> As far as I can follow, alloc_contig_range() ->
>> __alloc_contig_migrate_range() -> isolate_migratepages_range() ->
>> isolate_migratepages_block() will choke on these pages ((!PageLRU(page)
>> -> !__PageMovable(page) -> fail), essentially making
>> alloc_contig_range() range fail. Same could apply to offline_pages().
>>
>> I would have thought that there has to be something like a
>> reported_pages_drain_all(), that waits until all reports are over (or
>> even signals to the hypervisor to abort reporting). As the pages are
>> isolated, they won't be allocated for reporting again.
> 
> The thing is I only have 16 pages at most sitting in the scatterlist. In
> most cases the response should be quick enough that by the time I could
> make a request to abort reporting it would have likely already completed.

The "in most cases" is what's bugging me. It's not deterministic. E.g.,
try to allocate a gigantic page -> fails. Try again -> works. And that
would happen even on MOVABLE memory that is supposed to be somewhat
reliable.

Yes, it's not a lot of pages, but if it can happen it will happen :)

> 
> Also, unless there is already a ton of memory churn then we probably
> wouldn't need to worry about page reporting really causing too much of an
> issue. Specifically the way I structured the logic was that we only pull
> out up to 16 pages at a time. What should happen is that we will continue
> to build a list of "reported" pages in the free_list until we start
> bumping up against the allocator, in that case the allocator should start
> pulling reported pages and we will stop reporting with hopefully enough
> "reported" pages built up that it can allocate out of those until the last
> 16 or fewer reported pages are returned to the free_list.
> 
>> I have not yet understood completely the way all the details work. I am
>> currently looking into using alloc_contig_range() in a different
>> context, which would co-exist with free-page-reporting.
> 
> I am pretty sure the two can "play well" together, even in their current
> form. One thing I could look at doing would be to skip a page if the
> migratetype of the pfnblock indicates that it is an isolate block. I would
> essentially have to pull it out of the free_list I am working with and
> drop it into the MIGRATE_ISOLATE freelist.

Yeah, there could just be more some false negatives (meaning,
alloc_contig_range() would fail more frequently).

Complicated stuff :)

-- 

Thanks,

David / dhildenb


