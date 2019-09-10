Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E87EAEA40
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 14:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391238AbfIJMXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 08:23:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:50384 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727265AbfIJMXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 08:23:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9A3ACB68B;
        Tue, 10 Sep 2019 12:23:14 +0000 (UTC)
Date:   Tue, 10 Sep 2019 14:23:13 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        osalvador@suse.de, yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        alexander.h.duyck@linux.intel.com, kirill.shutemov@linux.intel.com
Subject: Re: [PATCH v9 3/8] mm: Move set/get_pcppage_migratetype to mmzone.h
Message-ID: <20190910122313.GW2063@dhcp22.suse.cz>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190907172528.10910.37051.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907172528.10910.37051.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat 07-09-19 10:25:28, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> In order to support page reporting it will be necessary to store and
> retrieve the migratetype of a page. To enable that I am moving the set and
> get operations for pcppage_migratetype into the mm/internal.h header so
> that they can be used outside of the page_alloc.c file.

Please describe who is the user and why does it needs this interface.
This is really important because migratetype is an MM internal thing and
external users shouldn't really care about it at all. We really do not
want a random code to call those, especially the set_pcppage_migratetype.

> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  mm/internal.h   |   18 ++++++++++++++++++
>  mm/page_alloc.c |   18 ------------------
>  2 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 0d5f720c75ab..e4a1a57bbd40 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -549,6 +549,24 @@ static inline bool is_migrate_highatomic_page(struct page *page)
>  	return get_pageblock_migratetype(page) == MIGRATE_HIGHATOMIC;
>  }
>  
> +/*
> + * A cached value of the page's pageblock's migratetype, used when the page is
> + * put on a pcplist. Used to avoid the pageblock migratetype lookup when
> + * freeing from pcplists in most cases, at the cost of possibly becoming stale.
> + * Also the migratetype set in the page does not necessarily match the pcplist
> + * index, e.g. page might have MIGRATE_CMA set but be on a pcplist with any
> + * other index - this ensures that it will be put on the correct CMA freelist.
> + */
> +static inline int get_pcppage_migratetype(struct page *page)
> +{
> +	return page->index;
> +}
> +
> +static inline void set_pcppage_migratetype(struct page *page, int migratetype)
> +{
> +	page->index = migratetype;
> +}
> +
>  void setup_zone_pageset(struct zone *zone);
>  extern struct page *alloc_new_node_page(struct page *page, unsigned long node);
>  #endif	/* __MM_INTERNAL_H */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4e4356ba66c7..a791f2baeeeb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -185,24 +185,6 @@ static int __init early_init_on_free(char *buf)
>  }
>  early_param("init_on_free", early_init_on_free);
>  
> -/*
> - * A cached value of the page's pageblock's migratetype, used when the page is
> - * put on a pcplist. Used to avoid the pageblock migratetype lookup when
> - * freeing from pcplists in most cases, at the cost of possibly becoming stale.
> - * Also the migratetype set in the page does not necessarily match the pcplist
> - * index, e.g. page might have MIGRATE_CMA set but be on a pcplist with any
> - * other index - this ensures that it will be put on the correct CMA freelist.
> - */
> -static inline int get_pcppage_migratetype(struct page *page)
> -{
> -	return page->index;
> -}
> -
> -static inline void set_pcppage_migratetype(struct page *page, int migratetype)
> -{
> -	page->index = migratetype;
> -}
> -
>  #ifdef CONFIG_PM_SLEEP
>  /*
>   * The following functions are used by the suspend/hibernate code to temporarily

-- 
Michal Hocko
SUSE Labs
