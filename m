Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9BE2BA470
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 09:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKTIOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 03:14:43 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:43327 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbgKTIOn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 03:14:43 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2020 03:14:17 EST
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud7.xs4all.net with ESMTPA
        id g1S4k0XKzlmd2g1S8kPQLw; Fri, 20 Nov 2020 09:07:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1605859653; bh=sm2yac8EMSo+qEG7x6Ni8ez+gEHPgPEvTzqTbbMVkxo=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=KtcUpTiZckuGNhgOl9IAlwjyI0wSHcJdDhZ002o2cLvsOuaUU7Ut5MkTmBs7uNYtO
         ndlPeg3XEzAmr4Hy1VRcTvJKwMpO3fMcu2KgK8S2LcE9qa7jdjBvvrwY0/9MLAD8TQ
         A+uPjXeJqfVS94EyazdO+OxclcERhJImWrZzJAtqKgtEqH2Z40K8T7VP6QOvdxxT1a
         gKU+1jva8gNtMuOytUPpKEqaiiN/ML42edbyG29aoDanwFHqhx4/TxiP/Xey0Mugs1
         ENdXthnSIl+l2q7fKiywHwv+WAlaffjRIpjQDn5ppYZhHKaQdhXvgxK0kKxCNDgJ7G
         YNvrckMh3Jr+g==
Subject: Re: [PATCH v6 06/17] media: videobuf2: Move frame_vector into media
 subsystem
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
 <20201119144146.1045202-7-daniel.vetter@ffwll.ch>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <401a7c80-ddf5-9708-eb05-6fa200d72d6d@xs4all.nl>
Date:   Fri, 20 Nov 2020 09:07:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201119144146.1045202-7-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfP1TEY4u8guXWW6VfE6qhLH+FTvcpK4/wi1k5vIyvADxC4I6VzWK+rw0zZ7w0xLbbdGkJpZfbWr2WgJ8jlg16kwXqabMNXUJxzKv2Kzh070vFHfjEBLu
 wDc2DyTHZ7/ZbSUpZx1WvKu9DZb+E9PaEnoavm1rmj4y6C1nPZ8RNhAfaISe8DBYUsbrYLJ3HK5klsykMSPJPnvnKxB1pHr+8lph32/plIPWPnvZf6nrBDGH
 CuCZnmoQ5xtO7ecY8aJBXj56HbAbzZh9N2H5M11gmgcrZznw60rS3b9+paWGWrrlkoFALaou89RDVHvaeDQ2iyc323y3e1cqfbcx9hUwgx8Yfnk+xrXrVXs+
 yqv+2tIjqRZEdDwpBQr0ubYtjHVD+jmrS0hFzCoE/Bwsm3TiZKDqseRsBGoNd04KnKyRtvp/CivbcKMUvijDgdqKK0xxSbotj5H7gwzBtHDsxphKTlU1+q6r
 m2ZjUgXIvfFcXlFIuQAQtvhnTe+KIw45k++EpG50///9wS+U/aVFgdd0jU/+APm8tRTb0xq81iSJnC5Qe7V4yg+c/143DSyzK/OJniiUF2qVYc8WS7fjLtOe
 ugSTbMEm4nuVvSUjCY+HigbAbyGpded14FtWsx85nlByeI5+AmQFRdtuxUqzLIBo7PSKfrPrdfkZBQIIieqZuIaJ38r4ekYrvaWRPdFD+BJhEA9oaFWiC8A9
 Fw+q/LrDSQSvKdct+G8WjuAZbf2T38/YOI0iz8m1ELD4IQpAY6z/A2aq1J55S67Km7Paj3ynp953ITFvuFFT5pzlmCctbxlVqJNHHgisFhlpml7J7iRng0Z2
 LKIhF1+3UYQOAa44wa+Ol0vcDbAqk7XTnokBbqLPqlTHsEWXpchPo2iVXeVmuQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/2020 15:41, Daniel Vetter wrote:
> It's the only user. This also garbage collects the CONFIG_FRAME_VECTOR
> symbol from all over the tree (well just one place, somehow omap media
> driver still had this in its Kconfig, despite not using it).
> 
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Acked-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Acked-by: Tomasz Figa <tfiga@chromium.org>

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks!

	Hans

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
> v5:
> - Rebase over changes in frame-vector.c from Tomasz review.
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
> index f8c34b895c76..a0e65481a201 100644
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
> index efb8c39bc933..b1a4a140863d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1751,48 +1751,6 @@ int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
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
> -		     struct frame_vector *vec);
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
> index 000000000000..bfed1710dc24
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
> +		     struct frame_vector *vec);
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
> index d42423f884a7..0dcff24cba53 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -819,9 +819,6 @@ config DEVICE_PRIVATE
>  config VMAP_PFN
>  	bool
>  
> -config FRAME_VECTOR
> -	bool
> -
>  config ARCH_USES_HIGH_VMA_FLAGS
>  	bool
>  config ARCH_HAS_PKEYS
> diff --git a/mm/Makefile b/mm/Makefile
> index d73aed0fc99c..db41fff05038 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -110,7 +110,6 @@ obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
>  obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
>  obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
>  obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
> -obj-$(CONFIG_FRAME_VECTOR) += frame_vector.o
>  obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
>  obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
>  obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
> 

