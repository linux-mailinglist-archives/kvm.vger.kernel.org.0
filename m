Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0594E1C8731
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 12:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgEGKq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 06:46:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29904 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725923AbgEGKq4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 06:46:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588848414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jwFSP1qKPzAiDWVK6ecZi/lZRSGtCCdB3pW0dxf0VHw=;
        b=D0pXP0IUIMyXohYPb51/MwOqKX3cwc8P3CtBT1BmWOlAcovCp183l3rbTn1Px4Btyw5R//
        gNbfNHE5PRtqKcHOKz3qDV2dfoh6wXYpAbT2gtuddFNAXOUazg5TNJzXN041miT2NcPORQ
        dtQTNv7YqmwPF3o9p+o4GAb5jQ97E2Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-zwcxIzJvNU2ynEwlGlubdg-1; Thu, 07 May 2020 06:46:53 -0400
X-MC-Unique: zwcxIzJvNU2ynEwlGlubdg-1
Received: by mail-wm1-f70.google.com with SMTP id u11so2311985wmc.7
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 03:46:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jwFSP1qKPzAiDWVK6ecZi/lZRSGtCCdB3pW0dxf0VHw=;
        b=He6eymBOBlgdeijXUZ/TlpWeB+ujG4xuGCioUdoBMy1lPea0pCpL6jQXJapxpTL/03
         FdhMAkaKHPktf7ZNjg/oC4AdCto/vFU2ha5vy6vLMzfn5yPFOWztZzXSO3RsEUY9VOJy
         SLGr56Kx+UXqeI+ZzDrwl0GSMzj2b+E1bqRX7vh1y1Nko3VFOBFxt/CKHqVj76QROWKt
         7Qmsywlk6PlAdHr2JG1Cu2DMK3F1++uP9bfOKL8SWubkiiSRAn7MjcFPNQ7JriBfD0Pg
         KJ6oJATVdXl3seKqW0quaUf5ASV00TbkOpncwMGJhMpqFHTsjy0qPI7KJX4RlG1U8Iqk
         oQ1Q==
X-Gm-Message-State: AGi0PuZLTUiOcUEoql8m9TAp5BDOABNgVD1CXMhH6Ibb4++u4splkViu
        xg8JaEcbaTK9rQQ+8dRpdtrfSB0vAHuO6LbpevRQzRELoeBISnVVBbrjqYGcGfCcs6EgjLUiulx
        OXqC7md8mltML
X-Received: by 2002:a1c:4b16:: with SMTP id y22mr9704522wma.170.1588848411508;
        Thu, 07 May 2020 03:46:51 -0700 (PDT)
X-Google-Smtp-Source: APiQypJwkpcsvMDTihRmO/58UI/oBdWetzX3zNTW+RN5tQqtGOSRJ/Ox4DqJrFYHImjL7fq9CHlvYA==
X-Received: by 2002:a1c:4b16:: with SMTP id y22mr9704494wma.170.1588848411214;
        Thu, 07 May 2020 03:46:51 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id v11sm7638062wrv.53.2020.05.07.03.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:46:50 -0700 (PDT)
Date:   Thu, 7 May 2020 06:46:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Oscar Salvador <osalvador@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH v3 07/15] mm/memory_hotplug: Introduce
 offline_and_remove_memory()
Message-ID: <20200507064558-mutt-send-email-mst@kernel.org>
References: <20200507103119.11219-1-david@redhat.com>
 <20200507103119.11219-8-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507103119.11219-8-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 12:31:11PM +0200, David Hildenbrand wrote:
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
> Acked-by: Michal Hocko <mhocko@suse.com>
> Tested-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Oscar Salvador <osalvador@suse.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Qian Cai <cai@lca.pw>
> Signed-off-by: David Hildenbrand <david@redhat.com>


didn't you lose Andrew Morton's ack here?

> ---
>  include/linux/memory_hotplug.h |  1 +
>  mm/memory_hotplug.c            | 37 ++++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)

I get:

error: sha1 information is lacking or useless (mm/memory_hotplug.c).
error: could not build fake ancestor

which version is this against? Pls post patches on top of some tag
in Linus' tree if possible.


> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 7dca9cd6076b..d641828e5596 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -318,6 +318,7 @@ extern void try_offline_node(int nid);
>  extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
>  extern int remove_memory(int nid, u64 start, u64 size);
>  extern void __remove_memory(int nid, u64 start, u64 size);
> +extern int offline_and_remove_memory(int nid, u64 start, u64 size);
>  
>  #else
>  static inline void try_offline_node(int nid) {}
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 936bfe208a6e..bf1941f02a60 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1748,4 +1748,41 @@ int remove_memory(int nid, u64 start, u64 size)
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
> 2.25.3

