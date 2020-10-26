Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC2129994C
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 23:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391847AbgJZWD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 18:03:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42147 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391755AbgJZWDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 18:03:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id j7so14604667wrt.9
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 15:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UZph9YDFnVBWNl2CHJ6aq7G08GSTpJx8UQf0r3junRY=;
        b=mvAStn/oyjUEYW+b6PIKeMRmeTNDG4/g2YKjfqeS8P2sw4YJTrEEH/iJICctkEfVcA
         S7830e1OGQ/KB0cKxep27xCN8rQPZvEqw2gSHgUu4RAmQoQycMaH4q7S2BmxIqwYhmj1
         854vcVs79vnfgCroLgme3pNbYSfDdB8z5fQHs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UZph9YDFnVBWNl2CHJ6aq7G08GSTpJx8UQf0r3junRY=;
        b=g+EUoInMn2Bsq35iRzrGXyWctss4isFSnZUpMBuydL+gFWoTLmY5e+n8P4S7Ce3EyX
         QNlBvlkztvL9QYoD7vbvYDfQm3VscDBVO4XmtqFoWGmyd8lN/7bZSalZ/ypXPlIsKuuW
         cSY8EBWykrtbu/TVa7H3N2BgMjJ+rEmbhCb99KovlGqR384xOCYnKAdy2v6HECY0QMgs
         OnDXWoMDR4n+5p8ptRE/7E7PmQC44/55zXgZXMa+8WtDwvaZrYxt0k3mNQyZ+52WC2/4
         7d0F+ZNIWC1Mv0c81g82YmOhwGAryYN4AgFe96bXsKxgqqO+7UvdF/AjX+agWhXTYBZb
         7R6A==
X-Gm-Message-State: AOAM533qGWghAqtvt7yATbIezGUQti5/OxYzIrFzXKfLtq3gBFkg4mu2
        EtpFuC9roruPxtK5rVahtm7IFw==
X-Google-Smtp-Source: ABdhPJw3fIO8fPo3S3fy5/5o+MHabEL5DjrpxhmTPaczsGMSjqk0zojmmpJWZOoy06udaiv5c3dsbA==
X-Received: by 2002:adf:f247:: with SMTP id b7mr21635315wrp.56.1603749831961;
        Mon, 26 Oct 2020 15:03:51 -0700 (PDT)
Received: from chromium.org (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id n5sm24251098wrm.2.2020.10.26.15.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 15:03:51 -0700 (PDT)
Date:   Mon, 26 Oct 2020 22:03:50 +0000
From:   Tomasz Figa <tfiga@chromium.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 06/15] media: videobuf2: Move frame_vector into media
 subsystem
Message-ID: <20201026220350.GB2802004@chromium.org>
References: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
 <20201026105818.2585306-7-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201026105818.2585306-7-daniel.vetter@ffwll.ch>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 26, 2020 at 11:58:09AM +0100, Daniel Vetter wrote:
> It's the only user. This also garbage collects the CONFIG_FRAME_VECTOR
> symbol from all over the tree (well just one place, somehow omap media
> driver still had this in its Kconfig, despite not using it).
> 
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Acked-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Tomasz Figa <tfiga@chromium.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> --
> v3:
> - Create a new frame_vector.h header for this (Mauro)
> ---
>  drivers/media/common/videobuf2/Kconfig        |  1 -
>  drivers/media/common/videobuf2/Makefile       |  1 +
>  .../media/common/videobuf2}/frame_vector.c    |  2 +
>  drivers/media/platform/omap/Kconfig           |  1 -
>  include/linux/mm.h                            | 42 -----------------
>  include/media/frame_vector.h                  | 47 +++++++++++++++++++
>  include/media/videobuf2-core.h                |  1 +
>  mm/Kconfig                                    |  3 --
>  mm/Makefile                                   |  1 -
>  9 files changed, 51 insertions(+), 48 deletions(-)
>  rename {mm => drivers/media/common/videobuf2}/frame_vector.c (99%)
>  create mode 100644 include/media/frame_vector.h
> 

Acked-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz

> diff --git a/drivers/media/common/videobuf2/Kconfig b/drivers/media/common/videobuf2/Kconfig
> index edbc99ebba87..d2223a12c95f 100644
> --- a/drivers/media/common/videobuf2/Kconfig
> +++ b/drivers/media/common/videobuf2/Kconfig
> @@ -9,7 +9,6 @@ config VIDEOBUF2_V4L2
>  
>  config VIDEOBUF2_MEMOPS
>  	tristate
> -	select FRAME_VECTOR
>  
>  config VIDEOBUF2_DMA_CONTIG
>  	tristate
> diff --git a/drivers/media/common/videobuf2/Makefile b/drivers/media/common/videobuf2/Makefile
> index 77bebe8b202f..54306f8d096c 100644
> --- a/drivers/media/common/videobuf2/Makefile
> +++ b/drivers/media/common/videobuf2/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  videobuf2-common-objs := videobuf2-core.o
> +videobuf2-common-objs += frame_vector.o
>  
>  ifeq ($(CONFIG_TRACEPOINTS),y)
>    videobuf2-common-objs += vb2-trace.o
> diff --git a/mm/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
> similarity index 99%
> rename from mm/frame_vector.c
> rename to drivers/media/common/videobuf2/frame_vector.c
> index d44779e56313..6590987c14bd 100644
> --- a/mm/frame_vector.c
> +++ b/drivers/media/common/videobuf2/frame_vector.c
> @@ -8,6 +8,8 @@
>  #include <linux/pagemap.h>
>  #include <linux/sched.h>
>  
> +#include <media/frame_vector.h>
> +
>  /**
>   * get_vaddr_frames() - map virtual addresses to pfns
>   * @start:	starting user address
> diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
> index f73b5893220d..de16de46c0f4 100644
> --- a/drivers/media/platform/omap/Kconfig
> +++ b/drivers/media/platform/omap/Kconfig
> @@ -12,6 +12,5 @@ config VIDEO_OMAP2_VOUT
>  	depends on VIDEO_V4L2
>  	select VIDEOBUF2_DMA_CONTIG
>  	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
> -	select FRAME_VECTOR
>  	help
>  	  V4L2 Display driver support for OMAP2/3 based boards.
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 16b799a0522c..acd60fbf1a5a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1743,48 +1743,6 @@ int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
>  int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
>  			struct task_struct *task, bool bypass_rlim);
>  
> -/* Container for pinned pfns / pages */
> -struct frame_vector {
> -	unsigned int nr_allocated;	/* Number of frames we have space for */
> -	unsigned int nr_frames;	/* Number of frames stored in ptrs array */
> -	bool got_ref;		/* Did we pin pages by getting page ref? */
> -	bool is_pfns;		/* Does array contain pages or pfns? */
> -	void *ptrs[];		/* Array of pinned pfns / pages. Use
> -				 * pfns_vector_pages() or pfns_vector_pfns()
> -				 * for access */
> -};
> -
> -struct frame_vector *frame_vector_create(unsigned int nr_frames);
> -void frame_vector_destroy(struct frame_vector *vec);
> -int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
> -		     unsigned int gup_flags, struct frame_vector *vec);
> -void put_vaddr_frames(struct frame_vector *vec);
> -int frame_vector_to_pages(struct frame_vector *vec);
> -void frame_vector_to_pfns(struct frame_vector *vec);
> -
> -static inline unsigned int frame_vector_count(struct frame_vector *vec)
> -{
> -	return vec->nr_frames;
> -}
> -
> -static inline struct page **frame_vector_pages(struct frame_vector *vec)
> -{
> -	if (vec->is_pfns) {
> -		int err = frame_vector_to_pages(vec);
> -
> -		if (err)
> -			return ERR_PTR(err);
> -	}
> -	return (struct page **)(vec->ptrs);
> -}
> -
> -static inline unsigned long *frame_vector_pfns(struct frame_vector *vec)
> -{
> -	if (!vec->is_pfns)
> -		frame_vector_to_pfns(vec);
> -	return (unsigned long *)(vec->ptrs);
> -}
> -
>  struct kvec;
>  int get_kernel_pages(const struct kvec *iov, int nr_pages, int write,
>  			struct page **pages);
> diff --git a/include/media/frame_vector.h b/include/media/frame_vector.h
> new file mode 100644
> index 000000000000..1ed0cd64510d
> --- /dev/null
> +++ b/include/media/frame_vector.h
> @@ -0,0 +1,47 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#ifndef _MEDIA_FRAME_VECTOR_H
> +#define _MEDIA_FRAME_VECTOR_H
> +
> +/* Container for pinned pfns / pages in frame_vector.c */
> +struct frame_vector {
> +	unsigned int nr_allocated;	/* Number of frames we have space for */
> +	unsigned int nr_frames;	/* Number of frames stored in ptrs array */
> +	bool got_ref;		/* Did we pin pages by getting page ref? */
> +	bool is_pfns;		/* Does array contain pages or pfns? */
> +	void *ptrs[];		/* Array of pinned pfns / pages. Use
> +				 * pfns_vector_pages() or pfns_vector_pfns()
> +				 * for access */
> +};
> +
> +struct frame_vector *frame_vector_create(unsigned int nr_frames);
> +void frame_vector_destroy(struct frame_vector *vec);
> +int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
> +		     unsigned int gup_flags, struct frame_vector *vec);
> +void put_vaddr_frames(struct frame_vector *vec);
> +int frame_vector_to_pages(struct frame_vector *vec);
> +void frame_vector_to_pfns(struct frame_vector *vec);
> +
> +static inline unsigned int frame_vector_count(struct frame_vector *vec)
> +{
> +	return vec->nr_frames;
> +}
> +
> +static inline struct page **frame_vector_pages(struct frame_vector *vec)
> +{
> +	if (vec->is_pfns) {
> +		int err = frame_vector_to_pages(vec);
> +
> +		if (err)
> +			return ERR_PTR(err);
> +	}
> +	return (struct page **)(vec->ptrs);
> +}
> +
> +static inline unsigned long *frame_vector_pfns(struct frame_vector *vec)
> +{
> +	if (!vec->is_pfns)
> +		frame_vector_to_pfns(vec);
> +	return (unsigned long *)(vec->ptrs);
> +}
> +
> +#endif /* _MEDIA_FRAME_VECTOR_H */
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index bbb3f26fbde9..d045e3a5a1d8 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -18,6 +18,7 @@
>  #include <linux/dma-buf.h>
>  #include <linux/bitops.h>
>  #include <media/media-request.h>
> +#include <media/frame_vector.h>
>  
>  #define VB2_MAX_FRAME	(32)
>  #define VB2_MAX_PLANES	(8)
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 6c974888f86f..da6c943fe9f1 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -815,9 +815,6 @@ config DEVICE_PRIVATE
>  	  memory; i.e., memory that is only accessible from the device (or
>  	  group of devices). You likely also want to select HMM_MIRROR.
>  
> -config FRAME_VECTOR
> -	bool
> -
>  config ARCH_USES_HIGH_VMA_FLAGS
>  	bool
>  config ARCH_HAS_PKEYS
> diff --git a/mm/Makefile b/mm/Makefile
> index d5649f1c12c0..a025fd6c6afd 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -111,7 +111,6 @@ obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
>  obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
>  obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
>  obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
> -obj-$(CONFIG_FRAME_VECTOR) += frame_vector.o
>  obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
>  obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
>  obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
> -- 
> 2.28.0
> 
