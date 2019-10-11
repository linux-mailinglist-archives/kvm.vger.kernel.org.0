Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DFFD3DE3
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 13:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfJKLDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 07:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbfJKLDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 07:03:23 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 063E5883856;
        Fri, 11 Oct 2019 11:03:22 +0000 (UTC)
Received: from [10.40.205.236] (unknown [10.40.205.236])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C7E35DAAE;
        Fri, 11 Oct 2019 11:03:01 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
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
Subject: Re: [RFC][Patch v12 1/2] mm: page_reporting: core infrastructure
References: <20190812131235.27244-1-nitesh@redhat.com>
 <20190812131235.27244-2-nitesh@redhat.com>
 <CAKgT0UeKxCYtg6+aCPyxJcAGrBgvCWziUpZM6Tmw-9PSChcGVA@mail.gmail.com>
Organization: Red Hat Inc,
Message-ID: <be33c1fe-ce15-aaef-3f15-617fc5b792f4@redhat.com>
Date:   Fri, 11 Oct 2019 07:02:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UeKxCYtg6+aCPyxJcAGrBgvCWziUpZM6Tmw-9PSChcGVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Fri, 11 Oct 2019 11:03:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/19 4:36 PM, Alexander Duyck wrote:
> On Mon, Aug 12, 2019 at 6:13 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> <snip>
>
>> +static int process_free_page(struct page *page,
>> +                            struct page_reporting_config *phconf, int count)
>> +{
>> +       int mt, order, ret = 0;
>> +
>> +       mt = get_pageblock_migratetype(page);
>> +       order = page_private(page);
>> +       ret = __isolate_free_page(page, order);
>> +
>> +       if (ret) {
>> +               /*
>> +                * Preserving order and migratetype for reuse while
>> +                * releasing the pages back to the buddy.
>> +                */
>> +               set_pageblock_migratetype(page, mt);
>> +               set_page_private(page, order);
>> +
>> +               sg_set_page(&phconf->sg[count++], page,
>> +                           PAGE_SIZE << order, 0);
>> +       }
>> +
>> +       return count;
>> +}
>> +
>> +/**
>> + * scan_zone_bitmap - scans the bitmap for the requested zone.
>> + * @phconf: page reporting configuration object initialized by the backend.
>> + * @zone: zone for which page reporting is requested.
>> + *
>> + * For every page marked in the bitmap it checks if it is still free if so it
>> + * isolates and adds them to a scatterlist. As soon as the number of isolated
>> + * pages reach the threshold set by the backend, they are reported to the
>> + * hypervisor by the backend. Once the hypervisor responds after processing
>> + * they are returned back to the buddy for reuse.
>> + */
>> +static void scan_zone_bitmap(struct page_reporting_config *phconf,
>> +                            struct zone *zone)
>> +{
>> +       unsigned long setbit;
>> +       struct page *page;
>> +       int count = 0;
>> +
>> +       sg_init_table(phconf->sg, phconf->max_pages);
>> +
>> +       for_each_set_bit(setbit, zone->bitmap, zone->nbits) {
>> +               /* Process only if the page is still online */
>> +               page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
>> +                                         zone->base_pfn);
>> +               if (!page)
>> +                       continue;
>> +
>> +               spin_lock(&zone->lock);
>> +
>> +               /* Ensure page is still free and can be processed */
>> +               if (PageBuddy(page) && page_private(page) >=
>> +                   PAGE_REPORTING_MIN_ORDER)
>> +                       count = process_free_page(page, phconf, count);
>> +
>> +               spin_unlock(&zone->lock);
>> +               /* Page has been processed, adjust its bit and zone counter */
>> +               clear_bit(setbit, zone->bitmap);
>> +               atomic_dec(&zone->free_pages);
>> +
>> +               if (count == phconf->max_pages) {
>> +                       /* Report isolated pages to the hypervisor */
>> +                       phconf->report(phconf, count);
>> +
>> +                       /* Return processed pages back to the buddy */
>> +                       return_isolated_page(zone, phconf);
>> +
>> +                       /* Reset for next reporting */
>> +                       sg_init_table(phconf->sg, phconf->max_pages);
>> +                       count = 0;
>> +               }
>> +       }
>> +       /*
>> +        * If the number of isolated pages does not meet the max_pages
>> +        * threshold, we would still prefer to report them as we have already
>> +        * isolated them.
>> +        */
>> +       if (count) {
>> +               sg_mark_end(&phconf->sg[count - 1]);
>> +               phconf->report(phconf, count);
>> +
>> +               return_isolated_page(zone, phconf);
>> +       }
>> +}
>> +
> So one thing that occurred to me is that this code is missing checks
> so that it doesn't try to hint isolated pages. With the bitmap
> approach you need an additional check so that you aren't pulling
> isolated pages out and reporting them.

I think you mean that we should not report pages of type MIGRATE_ISOLATE.

The current code on which I am working, I have added the
is_migrate_isolate_page() check
to ensure that I am not processing these pages.

-- 
Thanks
Nitesh
