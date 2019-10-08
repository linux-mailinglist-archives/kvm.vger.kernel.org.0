Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132F3CFCCC
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 16:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfJHOvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 10:51:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfJHOvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 10:51:18 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E7A2110F2E81;
        Tue,  8 Oct 2019 14:51:16 +0000 (UTC)
Received: from [10.36.118.36] (unknown [10.36.118.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5626B19C69;
        Tue,  8 Oct 2019 14:51:04 +0000 (UTC)
Subject: Re: [RFC PATCH] mm: set memory section offline when all its pages are
 offline.
To:     lantianyu1986@gmail.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        akpm@linux-foundation.org, rppt@linux.ibm.com, jgross@suse.com,
        mhocko@suse.com, paul.burton@mips.com, m.mizuma@jp.fujitsu.com,
        huang.zijiang@zte.com.cn, karahmed@amazon.de,
        dan.j.williams@intel.com, bhelgaas@google.com, osalvador@suse.de,
        rdunlap@infradead.org, richardw.yang@linux.intel.com,
        pavel.tatashin@microsoft.com, cai@lca.pw, arunks@codeaurora.org,
        vbabka@suse.cz, mgorman@techsingularity.net,
        alexander.h.duyck@linux.intel.com, glider@google.com,
        logang@deltatee.com, bsingharora@gmail.com, bhe@redhat.com,
        Tianyu.Lan@microsoft.com, michael.h.kelley@microsoft.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-mm@kvack.org,
        vkuznets@redhat.com
References: <20191008143648.11882-1-Tianyu.Lan@microsoft.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <ca6b21a3-efdc-5f7f-7b62-22a07a33c424@redhat.com>
Date:   Tue, 8 Oct 2019 16:51:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191008143648.11882-1-Tianyu.Lan@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 08 Oct 2019 14:51:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.10.19 16:36, lantianyu1986@gmail.com wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> If size of offline memory region passed to offline_pages() is
> not aligned with PAGES_PER_SECTION, memory section will be set
> to offline in the offline_mem_sections() with some pages of
> memory section online. Fix it, Update memory section status after
> marking offline pages as "reserved" in __offline_isolated_pages()
> and check all pages in memory are reserved or not before setting
> memory section offline.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> This patch is to prepare for hot remove memory function in Hyper-V
> balloon driver. It requests to offline memory with random size.

I proposed roughly the same a while ago. See

https://lkml.org/lkml/2018/4/30/207

Memory onlining/offlining works in memory block granularity only.
Sub-sections, you have to emulate it on top, similar to how hyper-v
balloon handles it already. E.g., have a look how virtio-mem handles it
using alloc_contig_range/free_contig_range and PG_offline extensions.

https://lkml.org/lkml/2018/4/30/207

So a clear NACK from my side.


> ---
>  mm/page_alloc.c |  3 ++-
>  mm/sparse.c     | 10 ++++++++++
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dbd0d5cbbcbb..cc02866924ae 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -8540,7 +8540,6 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>  	if (pfn == end_pfn)
>  		return offlined_pages;
>  
> -	offline_mem_sections(pfn, end_pfn);
>  	zone = page_zone(pfn_to_page(pfn));
>  	spin_lock_irqsave(&zone->lock, flags);
>  	pfn = start_pfn;
> @@ -8576,6 +8575,8 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>  	}
>  	spin_unlock_irqrestore(&zone->lock, flags);
>  
> +	offline_mem_sections(pfn, end_pfn);
> +
>  	return offlined_pages;
>  }
>  #endif
> diff --git a/mm/sparse.c b/mm/sparse.c
> index fd13166949b5..eb5860487b84 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -571,6 +571,7 @@ void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  {
>  	unsigned long pfn;
> +	int i;
>  
>  	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
>  		unsigned long section_nr = pfn_to_section_nr(pfn);
> @@ -583,6 +584,15 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  		if (WARN_ON(!valid_section_nr(section_nr)))
>  			continue;
>  
> +		/*
> +		 * Check whether all pages in the section are reserverd before
> +		 * setting setction offline.
> +		 */
> +		for (i = 0; i < PAGES_PER_SECTION; i++)
> +			if (!PageReserved(pfn_to_page(
> +			    SECTION_ALIGN_DOWN(pfn + i))))
> +				continue;
> +
>  		ms = __nr_to_section(section_nr);
>  		ms->section_mem_map &= ~SECTION_IS_ONLINE;
>  	}
> 


-- 

Thanks,

David / dhildenb
