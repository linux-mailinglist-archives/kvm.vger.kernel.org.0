Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A76D16C380
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbgBYOLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:11:37 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39109 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgBYOLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 09:11:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so3292419wme.4;
        Tue, 25 Feb 2020 06:11:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9llSiqn9QmX37KJecnbve+X+EjpLa4SazqSQQgp9aV4=;
        b=fHTaa6z5Tr/NBfx/fWZBN7VlcFm1bZgRK+nmwhlPW5F65Fosx+Tu9r3xAnzaIqU3zo
         8KNv75T+PbR7l82fJcARNRGxPVb7h5RdRPXtQiv6qz/Jc9b39VAEbfEv4lBlUytnJ7LZ
         NnqN6RvVM+Q2DSgzz6eMpUclpSxNy26JRG4jw3Os5/rXtSGd04u1c71rh/dDtRvYKLzL
         0eXzYJS1L+lyfFs73LlHDwk+s4oAEbbfNpGHopvtlWaauQwW7DrxU3BfSci/GPAHXug1
         BdlVvz93BxB51lSQJFCysGSIjAcgLxiAMLJpArYuwt9NXL7MNAXa1OTvkEOMqwVnAydP
         G7QQ==
X-Gm-Message-State: APjAAAWK4m2IphX3/J3VEAHXg8/0HlXdly+/a3PT3BgXIwb5wsQ5Yq6t
        0W3ezuKxZRvdI8pKqDm+kek=
X-Google-Smtp-Source: APXvYqzdNFz2/BYLFi72FFgE4SqlwoTvOVPcNUzf0X8k2HDo5fL4XJlZxrMCNKLRmzvrYSwv3huM/w==
X-Received: by 2002:a7b:c8c5:: with SMTP id f5mr5368076wml.44.1582639895661;
        Tue, 25 Feb 2020 06:11:35 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id v17sm23338678wrt.91.2020.02.25.06.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 06:11:34 -0800 (PST)
Date:   Tue, 25 Feb 2020 15:11:34 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Oscar Salvador <osalvador@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH RFC v4 08/13] mm/memory_hotplug: Introduce
 offline_and_remove_memory()
Message-ID: <20200225141134.GU22443@dhcp22.suse.cz>
References: <20191212171137.13872-1-david@redhat.com>
 <20191212171137.13872-9-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212171137.13872-9-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu 12-12-19 18:11:32, David Hildenbrand wrote:
> virtio-mem wants to offline and remove a memory block once it unplugged
> all subblocks (e.g., using alloc_contig_range()). Let's provide
> an interface to do that from a driver. virtio-mem already supports to
> offline partially unplugged memory blocks. Offlining a fully unplugged
> memory block will not require to migrate any pages. All unplugged
> subblocks are PageOffline() and have a reference count of 0 - so
> offlining code will simply skip them.
> 
> All we need an interface to trigger the "offlining" and the removing in a
> single operation - to make sure the memory block cannot get onlined by
> user space again before it gets removed.

Why does that matter? Is it really likely that the userspace would
interfere? What would be the scenario?

Or is still mostly about not requiring callers to open code this general
patter?

> To keep things simple, allow to only work on a single memory block.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Oscar Salvador <osalvador@suse.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Qian Cai <cai@lca.pw>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/memory_hotplug.h |  1 +
>  mm/memory_hotplug.c            | 35 ++++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index ba0dca6aac6e..586f5c59c291 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -310,6 +310,7 @@ extern void try_offline_node(int nid);
>  extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
>  extern int remove_memory(int nid, u64 start, u64 size);
>  extern void __remove_memory(int nid, u64 start, u64 size);
> +extern int offline_and_remove_memory(int nid, u64 start, u64 size);
>  
>  #else
>  static inline bool is_mem_section_removable(unsigned long pfn,
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index da01453a04e6..d04369e6d3cc 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1825,4 +1825,39 @@ int remove_memory(int nid, u64 start, u64 size)
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(remove_memory);
> +
> +/*
> + * Try to offline and remove a memory block. Might take a long time to
> + * finish in case memory is still in use. Primarily useful for memory devices
> + * that logically unplugged all memory (so it's no longer in use) and want to
> + * offline + remove the memory block.
> + */
> +int offline_and_remove_memory(int nid, u64 start, u64 size)
> +{
> +	struct memory_block *mem;
> +	int rc = -EINVAL;
> +
> +	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> +	    size != memory_block_size_bytes())
> +		return rc;
> +
> +	lock_device_hotplug();
> +	mem = find_memory_block(__pfn_to_section(PFN_DOWN(start)));
> +	if (mem)
> +		rc = device_offline(&mem->dev);
> +	/* Ignore if the device is already offline. */
> +	if (rc > 0)
> +		rc = 0;
> +
> +	/*
> +	 * In case we succeeded to offline the memory block, remove it.
> +	 * This cannot fail as it cannot get onlined in the meantime.
> +	 */
> +	if (!rc && try_remove_memory(nid, start, size))
> +		BUG();
> +	unlock_device_hotplug();
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(offline_and_remove_memory);
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
> -- 
> 2.23.0

-- 
Michal Hocko
SUSE Labs
