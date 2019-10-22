Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF98FE0E71
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 01:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389639AbfJVXDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 19:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730034AbfJVXDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 19:03:51 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D8FB20700;
        Tue, 22 Oct 2019 23:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571785428;
        bh=Z8grtEEaolIb1K+UzMkw9svXn05TDmTssg3D2D6nVI8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u7tinkc7e5tfqSeK7gEC+Xt+ioj3vbEFbunbHpdL6DTLh/SCGbeuQvz5YhnLEmv6n
         bF4cges/YihUP+smCoeBx4I9ZYE+NaH6I1UD0J/oSr9l8oFOUNPUQaaHTmgMIdklxh
         su1EG2X18BfgWg8PEanAzlgEzezUPxDqV+opQx98=
Date:   Tue, 22 Oct 2019 16:03:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, vbabka@suse.cz,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Subject: Re: [PATCH v12 3/6] mm: Introduce Reported pages
Message-Id: <20191022160347.3559936a0a0a4389cfec455e@linux-foundation.org>
In-Reply-To: <20191022222812.17338.49450.stgit@localhost.localdomain>
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
        <20191022222812.17338.49450.stgit@localhost.localdomain>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Oct 2019 15:28:12 -0700 Alexander Duyck <alexander.duyck@gmail.com> wrote:

> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> In order to pave the way for free page reporting in virtualized
> environments we will need a way to get pages out of the free lists and
> identify those pages after they have been returned. To accomplish this,
> this patch adds the concept of a Reported Buddy, which is essentially
> meant to just be the Uptodate flag used in conjunction with the Buddy
> page type.
> 
> It adds a set of pointers we shall call "reported_boundary" which
> represent the upper boundary between the unreported and reported pages.
> The general idea is that in order for a page to cross from one side of the
> boundary to the other it will need to verify that it went through the
> reporting process. Ultimately a free list has been fully processed when
> the boundary has been moved from the tail all they way up to occupying the
> first entry in the list. Without this we would have to manually walk the
> entire page list until we have find a page that hasn't been reported. In my
> testing this adds as much as 18% additional overhead which would make this
> unattractive as a solution.
> 
> One limitation to this approach is that it is essentially a linear search
> and in the case of the free lists we can have pages added to either the
> head or the tail of the list. In order to place limits on this we only
> allow pages to be added before the reported_boundary instead of adding
> to the tail itself. An added advantage to this approach is that we should
> be reducing the overall memory footprint of the guest as it will be more
> likely to recycle warm pages versus trying to allocate the reported pages
> that were likely evicted from the guest memory.
> 
> Since we will only be reporting one zone at a time we keep the boundary
> limited to being defined for just the zone we are currently reporting pages
> from. Doing this we can keep the number of additional pointers needed quite
> small. To flag that the boundaries are in place we use a single bit
> in the zone to indicate that reporting and the boundaries are active.
> 
> We store the index of the boundary pointer used to track the reported page
> in the page->index value. Doing this we can avoid unnecessary computation
> to determine the index value again. There should be no issues with this as
> the value is unused when the page is in the buddy allocator, and is reset
> as soon as the page is removed from the free list.

This looks like quite a lot of new code in code MM.  Hence previous
"how valuable is this patchset" question!

Some silly trivia which I noticed while perusing:

>
> ...
>
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -470,6 +470,14 @@ struct zone {
>  	seqlock_t		span_seqlock;
>  #endif
>  
> +#ifdef CONFIG_PAGE_REPORTING
> +	/*
> +	 * Pointer to reported page tracking statistics array. The size of
> +	 * the array is MAX_ORDER - PAGE_REPORTING_MIN_ORDER. NULL when
> +	 * unused page reporting is not present.
> +	 */
> +	unsigned long		*reported_pages;

Dumb question.  Why not

	unsigned long reported_pages[MAX_ORDER - PAGE_REPORTING_MIN_ORDER];

> +#endif
>  	int initialized;
>  
>  	/* Write-intensive fields used from the page allocator */
>
> ...
>
> +#define page_is_reported(_page)	unlikely(PageReported(_page))

page_reported() would be more consistent.

>
> ...
>
> +static inline void
> +add_page_to_reported_list(struct page *page, struct zone *zone,
> +			  unsigned int order, unsigned int mt)
> +{
> +	/*
> +	 * Default to using index 0, this will be updated later if the zone
> +	 * is still being processed.
> +	 */
> +	page->index = 0;
> +
> +	/* flag page as reported */
> +	__SetPageReported(page);
> +
> +	/* update areated page accounting */
> +	zone->reported_pages[order - PAGE_REPORTING_MIN_ORDER]++;

nit.  This is an array, not a list.  The function name is a bit screwy.

> +}
> +
>
> ...
>

