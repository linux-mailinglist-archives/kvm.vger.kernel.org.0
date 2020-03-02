Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0B1175C89
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 15:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCBOF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 09:05:27 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44495 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgCBOF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 09:05:27 -0500
Received: by mail-wr1-f67.google.com with SMTP id n7so4836831wrt.11;
        Mon, 02 Mar 2020 06:05:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c0cAfvYrVEVBx2ds1ZgWYcF17eBb1NlP7kXSkGclbIo=;
        b=bWbAUaIsJ6Jw/9ZYdnK+x2LEq7mtL1GYOJthJMdigAqeppYlW1aktWI8TP4e9vfT13
         UF7mj22xg1MR6rtXXBSokfaeAhBszLrk2TLJg8RHqLZ97DOjvlrSehTjK8i4Smp/hHwP
         4257FHkSh+49nfDab8Zmgw4uNIRHfJb89Q7L6SMogKteE6QK7ZrD4lkfec0+vGB2W2aT
         etzBpiZjoSR6ceMVHLA+j2fwLMIHX4TB3bL3e4RGwnywLYV+CEN6C1mtDedfO2JCGFRc
         pnGbWoESc6z88aWWl940pQyQqBFHhu20pVXUZAcUmjOWCZanaSMTgnFUBT68geRYCGDJ
         PoaA==
X-Gm-Message-State: APjAAAVRCSYtiuE+35YTyrCibDppl40KS2TBY7G1cQFsWwk/PGmRf617
        ioEJhRPVXSNEGDiub9vgBtt+JFjo
X-Google-Smtp-Source: APXvYqx0+M3slxS1twXYHQLKyE1HWK32dT4Uy4lzZdKaDxvmor7yMe0SVC8biQ097XaClUCOR5acbg==
X-Received: by 2002:adf:e808:: with SMTP id o8mr17538359wrm.8.1583157923708;
        Mon, 02 Mar 2020 06:05:23 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id q3sm15291876wmj.38.2020.03.02.06.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 06:05:22 -0800 (PST)
Date:   Mon, 2 Mar 2020 15:05:19 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH v1 04/11] mm: Export alloc_contig_range() /
 free_contig_range()
Message-ID: <20200302140519.GN4380@dhcp22.suse.cz>
References: <20200302134941.315212-1-david@redhat.com>
 <20200302134941.315212-5-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302134941.315212-5-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon 02-03-20 14:49:34, David Hildenbrand wrote:
> A virtio-mem device wants to allocate memory from the memory region it
> manages in order to unplug it in the hypervisor - similar to
> a balloon driver. Also, it might want to plug previously unplugged
> (allocated) memory and give it back to Linux. alloc_contig_range() /
> free_contig_range() seem to be the perfect interface for this task.
> 
> In contrast to existing balloon devices, a virtio-mem device operates
> on bigger chunks (e.g., 4MB) and only on physical memory it manages. It
> tracks which chunks (subblocks) are still plugged, so it can go ahead
> and try to alloc_contig_range()+unplug them on unplug request, or
> plug+free_contig_range() unplugged chunks on plug requests.
> 
> A virtio-mem device will use alloc_contig_range() / free_contig_range()
> only on ranges that belong to the same node/zone in at least
> MAX(MAX_ORDER - 1, pageblock_order) order granularity - e.g., 4MB on
> x86-64. The virtio-mem device added that memory, so the memory
> exists and does not contain any holes. virtio-mem will only try to allocate
> on ZONE_NORMAL, never on ZONE_MOVABLE, just like when allocating
> gigantic pages (we don't put unmovable data into the movable zone).

Same feedback as in pxm_to_node export. No objections to exporting the
symbol but it would be better to squash this function into the patch
which uses it. The changelog is highly virtio-mem specific anyway.
Maybe it is just a dejavu but I feel I have already said that but I do
not remember any details.

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
> Cc: Alexander Potapenko <glider@google.com>
> Acked-by: Michal Hocko <mhocko@suse.com> # to export contig range allocator API
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/page_alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 79e950d76ffc..8d7be3f33e26 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -8597,6 +8597,7 @@ int alloc_contig_range(unsigned long start, unsigned long end,
>  				pfn_max_align_up(end), migratetype);
>  	return ret;
>  }
> +EXPORT_SYMBOL(alloc_contig_range);
>  
>  static int __alloc_contig_pages(unsigned long start_pfn,
>  				unsigned long nr_pages, gfp_t gfp_mask)
> @@ -8712,6 +8713,7 @@ void free_contig_range(unsigned long pfn, unsigned int nr_pages)
>  	}
>  	WARN(count != 0, "%d pages are still in use!\n", count);
>  }
> +EXPORT_SYMBOL(free_contig_range);
>  
>  /*
>   * The zone indicated has a new number of managed_pages; batch sizes and percpu
> -- 
> 2.24.1

-- 
Michal Hocko
SUSE Labs
