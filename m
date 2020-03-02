Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D877175D01
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 15:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbgCBO1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 09:27:41 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35685 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgCBO1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 09:27:41 -0500
Received: by mail-wm1-f65.google.com with SMTP id m3so10859557wmi.0;
        Mon, 02 Mar 2020 06:27:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wTQwmZBRvHVWlOUwzt39lRwPZP1PXvP9AI5qWhdX6Ho=;
        b=lLViyt6ws2rVSQMulUT7Rfa1FZFjt8+5nMdc+4CsyhJ/OXLPhJNd5E83cUo2hLJSzv
         cbKXLUjn8TfFQdKwX8z2Vs9sX4oit7HUVugFY/CnCYboMZvzRR64F+V0Jucd9SUCotNb
         SiX16geHmZQe1NgY+x+xGdiWwO7dcTMzdGiHGJxLKaAOKKn165ai7cZxCq09PNuoI+YJ
         QUEqNT04CV9wCGEbgoI+LHQYMFYYfPacXCJy8nB1XhGZRRU9qlWpdECwZtgOaH0m6jNN
         QnaU252nqM1tRusiWizMVYXZp4E3Vu9WpQqr2Q06aleEu1NRbZxLjHe0uX/pOFOCO8lz
         r1QQ==
X-Gm-Message-State: APjAAAW+ri+Nvb558E+IGOYbajfs79kNDhAezDThccJSXi7bdDZkLUZP
        BDFYytGzrxqo+Ttd9IfXWdw=
X-Google-Smtp-Source: APXvYqwd+CHYryhKK2gAxaRfzTEgpelHGrh9Fbdww7O5/Nv7QJcXytR5reYcK2kbmxXWpKlqYuNkmw==
X-Received: by 2002:a1c:6884:: with SMTP id d126mr19396061wmc.38.1583159259142;
        Mon, 02 Mar 2020 06:27:39 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id v16sm10493929wrp.84.2020.03.02.06.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 06:27:38 -0800 (PST)
Date:   Mon, 2 Mar 2020 15:27:37 +0100
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
Subject: Re: [PATCH v1 08/11] mm/memory_hotplug: Introduce
 offline_and_remove_memory()
Message-ID: <20200302142737.GP4380@dhcp22.suse.cz>
References: <20200302134941.315212-1-david@redhat.com>
 <20200302134941.315212-9-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302134941.315212-9-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon 02-03-20 14:49:38, David Hildenbrand wrote:
> virtio-mem wants to offline and remove a memory block once it unplugged
> all subblocks (e.g., using alloc_contig_range()). Let's provide
> an interface to do that from a driver. virtio-mem already supports to
> offline partially unplugged memory blocks. Offlining a fully unplugged
> memory block will not require to migrate any pages. All unplugged
> subblocks are PageOffline() and have a reference count of 0 - so
> offlining code will simply skip them.
> 
> All we need is an interface to offline and remove the memory from kernel
> module context, where we don't have access to the memory block devices
> (esp. find_memory_block() and device_offline()) and the device hotplug
> lock.
> 
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

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/memory_hotplug.h |  1 +
>  mm/memory_hotplug.c            | 37 ++++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index f4d59155f3d4..a98aa16dbfa1 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -311,6 +311,7 @@ extern void try_offline_node(int nid);
>  extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
>  extern int remove_memory(int nid, u64 start, u64 size);
>  extern void __remove_memory(int nid, u64 start, u64 size);
> +extern int offline_and_remove_memory(int nid, u64 start, u64 size);
>  
>  #else
>  static inline bool is_mem_section_removable(unsigned long pfn,
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index ab1c31e67fd1..d0d337918a15 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1818,4 +1818,41 @@ int remove_memory(int nid, u64 start, u64 size)
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
> +	if (!rc) {
> +		rc = try_remove_memory(nid, start, size);
> +		WARN_ON_ONCE(rc);
> +	}
> +	unlock_device_hotplug();
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(offline_and_remove_memory);
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
> -- 
> 2.24.1
> 

-- 
Michal Hocko
SUSE Labs
