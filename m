Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E0D2865E3
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 19:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgJGR1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 13:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgJGR1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 13:27:49 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CE2C061755
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 10:27:49 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id q26so2604466qtb.5
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 10:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=XbSoU+/at8nS4vwGrWdy12hS6b+RYvRwUOTYRSNB06Q=;
        b=mSF3jlLKHl2GcWOtjisnFuOxmsafdLuRV7HNQszKRHTbX7yrWh+1uuimlnTVBDf88S
         7CDIDMQGVG9iRv64l0dGVTOGsF3HhoVCmCeCFmDoV09KS3pUl6DC8vC3fTvvt2cweotS
         YfhKySivQyKZUy5Qq80V3s1ZqG50WhxQuoVnwHYZe7OK1Xk2CZbcO9rDgpzCxYLE695p
         iM3zaabJqTXzIZDyKFOBFSJJu8gE182ca6m7suRvcG0u6/EkdQ4bhJV4U+DEo5V7zW7u
         S96CIynxOtOJjWv1pdwcNaqEUxAlUPVqbissjAJxdOugEaGgQF1dKaRPG7Vtfa/bgluo
         JjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XbSoU+/at8nS4vwGrWdy12hS6b+RYvRwUOTYRSNB06Q=;
        b=RMV0LQhr0Bl+TqisUVVy4daB+GYjvA9xvP13QRqYY+Rprwe7bPY6rWkfCppKmG0DEd
         wwVLht+uLRN/KEWdgexChIQlHAbC8Vli9m+umoYNCO+sBsmDK8eoatj3clmGfRD/a20c
         0iDlnWTqoUWZTtqUcCyvNBEXvzc7UHsepXreOduyp/gQlUXGrdrscPiYyOfogw4HLLqy
         GWTk26wd2BWN0ygdF1gHHdFMOIS6NJe2ANLjpqDrym/Z/M+iZ7b0IWH1cQTrYnkb6THA
         C9OWz8MXXzQlp/FidtDV1AFhHqUxKRlVKh5YBGDTbFedZ24JgWkG5shNnovOWQC++PqN
         ErEw==
X-Gm-Message-State: AOAM530js1e4qdH0/QniYlim1UUFtBnJ5WDxAmIc7YRhM1mTwBwlNUNA
        It+NquTPL2FATWGhonmjoljEAw==
X-Google-Smtp-Source: ABdhPJzBzIEuFCTfuv3ULvENiYmE1q5S6ZKvaoPSvLERT9h4HN4R+RXmtJoeCi0hQLY2ayjG0AcA6w==
X-Received: by 2002:ac8:37ef:: with SMTP id e44mr4247866qtc.342.1602091668463;
        Wed, 07 Oct 2020 10:27:48 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id t10sm1904322qkt.55.2020.10.07.10.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 10:27:47 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kQDEA-0010sP-Uz; Wed, 07 Oct 2020 14:27:46 -0300
Date:   Wed, 7 Oct 2020 14:27:46 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Rik van Riel <riel@redhat.com>,
        Benjamin Herrensmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@linux.ie>,
        Hugh Dickins <hugh@veritas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 07/13] mm: close race in generic_access_phys
Message-ID: <20201007172746.GU5177@ziepe.ca>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-8-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201007164426.1812530-8-daniel.vetter@ffwll.ch>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07, 2020 at 06:44:20PM +0200, Daniel Vetter wrote:
> Way back it was a reasonable assumptions that iomem mappings never
> change the pfn range they point at. But this has changed:
> 
> - gpu drivers dynamically manage their memory nowadays, invalidating
>   ptes with unmap_mapping_range when buffers get moved
> 
> - contiguous dma allocations have moved from dedicated carvetouts to
>   cma regions. This means if we miss the unmap the pfn might contain
>   pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> 
> - even /dev/mem now invalidates mappings when the kernel requests that
>   iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
>   ("/dev/mem: Revoke mappings when a driver claims the region")
> 
> Accessing pfns obtained from ptes without holding all the locks is
> therefore no longer a good idea. Fix this.
> 
> Since ioremap might need to manipulate pagetables too we need to drop
> the pt lock and have a retry loop if we raced.
> 
> While at it, also add kerneldoc and improve the comment for the
> vma_ops->access function. It's for accessing, not for moving the
> memory from iomem to system memory, as the old comment seemed to
> suggest.
> 
> References: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Benjamin Herrensmidt <benh@kernel.crashing.org>
> Cc: Dave Airlie <airlied@linux.ie>
> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  include/linux/mm.h |  3 ++-
>  mm/memory.c        | 44 ++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 44 insertions(+), 3 deletions(-)

This does seem to solve the race with revoke_devmem(), but it is really ugly.

It would be much nicer to wrap a rwsem around this access and the unmap.

Any place using it has a nice linear translation from vm_off to pfn,
so I don't think there is a such a good reason to use follow_pte in
the first place.

ie why not the helper be this:

 int generic_access_phys(unsigned long pfn, unsigned long pgprot,
      void *buf, size_t len, bool write)

Then something like dev/mem would compute pfn and obtain the lock:

dev_access(struct vm_area_struct *vma, unsigned long addr, void *buf, int len, int write)
{
     cpu_addr = vma->vm_pgoff*PAGE_SIZE + (addr - vma->vm_start));

     /* FIXME: Has to be over each page of len */
     if (!devmem_is_allowed_access(PHYS_PFN(cpu_addr/4096)))
           return -EPERM;

     down_read(&mem_sem);
     generic_access_phys(cpu_addr/4096, pgprot_val(vma->vm_page_prot),
                         buf, len, write);
     up_read(&mem_sem);
}

The other cases looked simpler because they don't revoke, here the
mmap_sem alone should be enough protection, they would just need to
provide the linear translation to pfn.

What do you think?

Jason
