Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC426D327E
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 22:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfJJUgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 16:36:39 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:34089 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfJJUgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 16:36:39 -0400
Received: by mail-io1-f53.google.com with SMTP id q1so16816560ion.1;
        Thu, 10 Oct 2019 13:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j6sP383Qyl95I8Z25iYfBokkV8+qGYi/AFX1IOAtUrQ=;
        b=Q34QMYZdc+pG/I0r+KiZJAKEidQQcZ2vbxo8k9oDD4D6VIPmYiq55Vl8FsfktvflZ1
         geL58/bUA0mtFR47tlZu2j4y5nyoh6nr3nbLTNHkg1ELYWX+/603QIlIc6C9qGTvJEVH
         /OV01/zQ0gJm86BrSxhYKIRGDmGIZ/QFs10Q63SPCEM7VSvHNWPiuruDhU0z8hBKWlr0
         ut+GGyVUAUwLhs0eDZ8tDj8rMnUgzUkpLsCtWwDLAVPG2wXubGVbOU4TaIDXm+L9JdEg
         aKivN5ksqTd7qzsgKDhbNZ1zxa9gBHJr8qTDucMKj/bW+/2NV5zDDIbA5y2vAKGmTK0f
         MzWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j6sP383Qyl95I8Z25iYfBokkV8+qGYi/AFX1IOAtUrQ=;
        b=J/8jAk8g+MmC6g3jNTBu/YP/HvAOj2luS8HRMbqlbRXVVH2CXloMKmo6MEsf2cB5HX
         giNbesO9qTHG8VT/TGIORXwVyFLFpVs5lRxGvMwTVk520r4Xdkh3x8B1U4msCo9sM9eD
         bJzIHcbH0kuQMAheEKCdPHZGGu5TuJAmP0wFIVBrEpHNy0fOVMRuQ0liamHOvCHSEpX8
         h0WeGepC3qRmCoR5mcpYqQgKmZjqc2YohK47LWQi6TsW8JD2VnoB4jSX0NjzKkCzYMa/
         1IPMNvCGa0Z0EWCF+xvyRco2MmMRPesPOwTHSV0M2STFU1M3NJIsHd/zyi0YLdttpmkj
         xm2Q==
X-Gm-Message-State: APjAAAVXe8uagK0/pzxRGsVJ4gV5OPZ3goanxykdmyiRwnvu6W752sLF
        nsove5nTO+to6JUB7ZXLXXWOxyQl+WoXs6pJ15DHQ6f5
X-Google-Smtp-Source: APXvYqzkmsXfTfl7HoZDw6+IGIW9qLazyM4wbybRpN2KG5iGlsQrQr34VW4QNZUtyUVWWSac/24naMiXdyfmk6TwusI=
X-Received: by 2002:a6b:6605:: with SMTP id a5mr13224254ioc.237.1570739797276;
 Thu, 10 Oct 2019 13:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190812131235.27244-1-nitesh@redhat.com> <20190812131235.27244-2-nitesh@redhat.com>
In-Reply-To: <20190812131235.27244-2-nitesh@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 10 Oct 2019 13:36:26 -0700
Message-ID: <CAKgT0UeKxCYtg6+aCPyxJcAGrBgvCWziUpZM6Tmw-9PSChcGVA@mail.gmail.com>
Subject: Re: [RFC][Patch v12 1/2] mm: page_reporting: core infrastructure
To:     Nitesh Narayan Lal <nitesh@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 6:13 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>

<snip>

> +static int process_free_page(struct page *page,
> +                            struct page_reporting_config *phconf, int count)
> +{
> +       int mt, order, ret = 0;
> +
> +       mt = get_pageblock_migratetype(page);
> +       order = page_private(page);
> +       ret = __isolate_free_page(page, order);
> +
> +       if (ret) {
> +               /*
> +                * Preserving order and migratetype for reuse while
> +                * releasing the pages back to the buddy.
> +                */
> +               set_pageblock_migratetype(page, mt);
> +               set_page_private(page, order);
> +
> +               sg_set_page(&phconf->sg[count++], page,
> +                           PAGE_SIZE << order, 0);
> +       }
> +
> +       return count;
> +}
> +
> +/**
> + * scan_zone_bitmap - scans the bitmap for the requested zone.
> + * @phconf: page reporting configuration object initialized by the backend.
> + * @zone: zone for which page reporting is requested.
> + *
> + * For every page marked in the bitmap it checks if it is still free if so it
> + * isolates and adds them to a scatterlist. As soon as the number of isolated
> + * pages reach the threshold set by the backend, they are reported to the
> + * hypervisor by the backend. Once the hypervisor responds after processing
> + * they are returned back to the buddy for reuse.
> + */
> +static void scan_zone_bitmap(struct page_reporting_config *phconf,
> +                            struct zone *zone)
> +{
> +       unsigned long setbit;
> +       struct page *page;
> +       int count = 0;
> +
> +       sg_init_table(phconf->sg, phconf->max_pages);
> +
> +       for_each_set_bit(setbit, zone->bitmap, zone->nbits) {
> +               /* Process only if the page is still online */
> +               page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
> +                                         zone->base_pfn);
> +               if (!page)
> +                       continue;
> +
> +               spin_lock(&zone->lock);
> +
> +               /* Ensure page is still free and can be processed */
> +               if (PageBuddy(page) && page_private(page) >=
> +                   PAGE_REPORTING_MIN_ORDER)
> +                       count = process_free_page(page, phconf, count);
> +
> +               spin_unlock(&zone->lock);
> +               /* Page has been processed, adjust its bit and zone counter */
> +               clear_bit(setbit, zone->bitmap);
> +               atomic_dec(&zone->free_pages);
> +
> +               if (count == phconf->max_pages) {
> +                       /* Report isolated pages to the hypervisor */
> +                       phconf->report(phconf, count);
> +
> +                       /* Return processed pages back to the buddy */
> +                       return_isolated_page(zone, phconf);
> +
> +                       /* Reset for next reporting */
> +                       sg_init_table(phconf->sg, phconf->max_pages);
> +                       count = 0;
> +               }
> +       }
> +       /*
> +        * If the number of isolated pages does not meet the max_pages
> +        * threshold, we would still prefer to report them as we have already
> +        * isolated them.
> +        */
> +       if (count) {
> +               sg_mark_end(&phconf->sg[count - 1]);
> +               phconf->report(phconf, count);
> +
> +               return_isolated_page(zone, phconf);
> +       }
> +}
> +

So one thing that occurred to me is that this code is missing checks
so that it doesn't try to hint isolated pages. With the bitmap
approach you need an additional check so that you aren't pulling
isolated pages out and reporting them.
