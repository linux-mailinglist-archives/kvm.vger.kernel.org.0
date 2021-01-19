Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EEF2FBA56
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 15:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405177AbhASOwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:52:19 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45107 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393094AbhASMck (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 07:32:40 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jan 2021 07:32:37 EST
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 1q3JlOl5LyutM1q3MlbVVy; Tue, 19 Jan 2021 13:24:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1611059053; bh=+fygwg8H7qkyKanjBFzInEqDikPrCtVia5ztmXeuT8o=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=esWbI+Lh9FRvuG9LpVYDuouJ84+y5SVFATzQP7ZpAkWlKhxpMQNv10g7tZk+Q+4GR
         P8w0iKSjARrqozBk9TMk4qupccz3HMw/pPa5j+Fl4C2W0pgaEOFIATNA5dfqmNbXpF
         WY3dgySHr2MM3+6svDtBqw3Cm53j9ZKlcznqjLsgYdpTtvUnDnYFt00lTZiImdL2fY
         qY1XJPsfQLCx3vnp/zkfosk3P0gx6P0mVbHxoub0/O3N+aYXqUBlwVZ01FyUjwj1I0
         OZ20uGwGN94AfvQR5wgjFi/ySkQn4HCvdPm/riMHsIyPvQ/Hw151NoHZMXG5h6/u3B
         ZllT5HuMu4+8A==
Subject: Re: [PATCH v7 14/17] media/videobuf1|2: Mark follow_pfn usage as
 unsafe
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Tomasz Figa <tfiga@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>
References: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
 <20201127164131.2244124-15-daniel.vetter@ffwll.ch>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f15ba4c6-211c-f93e-919e-e18adfe6c75e@xs4all.nl>
Date:   Tue, 19 Jan 2021 13:24:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201127164131.2244124-15-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfA1H6w7Z451hXz5uBfC+T4CILwukWC7IM/06HM55r5dwzXzD5s4d8wprZRF6kMCTJKToPwR+OFR57hUr5TUeAa3J/b4Bano5cXG5JJs7aDyySvyBQ7iT
 AF6NJi1hvvqh1FElksqvzLVa/QmOEEejZBgjFwsoa8P3BlX71aUZg55UgN1CoKfvJigaVMx8OmJVZTP1TBgBzYBEZA+0dH6f1b1DMDgA9kXqoDqQfIJqtbCX
 qHojNYKAiISwBmDYuSZMkSH7KYRNIIB59C3sKlux+Osh+dIvr5KeKL/UVyQNN5t4C8bA3xzI7WdxGoWOTrcrh6osz7j5RinbLE8qyeEUJUyvvWjXKkpd7dqS
 HMIEDbWiUVhRUKJ1yDeGKCpWevlCpEVMVzY1pNK0/aVSSfNEBvtodYg6CYCokOhjJHvuA+Ep4e+YV4DPrzHET+/xc+NX8AyQiHwb8/yP2YmEZJ49rfgQR9BP
 dr/7nk6Q/Zh1zkv3OibjwZY9c+4YhA+0B7uhgqimrkbKOf8Rigw2QOU+Ca/UadrwBpoSe8JeVoEhBEL9Z1DvGPDVJmztfvzZh/WKgR3U/UdzLA58H6XYG2Wi
 kRopGvfHjGH7BGq7rfl3p2JRUv4RPzrY67wfHIz7CJCMySBHEhQmO0DqCexzJwuN7qVDQQUew+dVW+zy8VfPtcLvnQ/ulL2+sYo0AsauVMOoEKmJsD13zo8F
 BwOGLGocDuv11A3T9etYvQWCfQotxHdMIivYlD9K45bjGngn5VQTZJEBfHREoydJ8pRl5Zubmv1dwvrtHzJ5cUaN75JDMp0+rY6t7CQSF6ElQBaS/BkwGvqT
 E/8oCoh/4PmJ0q6wWIfjNWnYVoGo3VhXp1URyLLFriMg9vsz5Zk8hKxx6nVgqUGGVM+9vX7XOQ6WrUu2nFalkCfyREoU2d7TZo3kbyVR1cFUVs4KSoSVdkYX
 9CdJyh8ZOIugxyoIdE14LTtUXncHFwG8YxkQ+bn6EZL1uWAR
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/11/2020 17:41, Daniel Vetter wrote:
> The media model assumes that buffers are all preallocated, so that
> when a media pipeline is running we never miss a deadline because the
> buffers aren't allocated or available.
> 
> This means we cannot fix the v4l follow_pfn usage through
> mmu_notifier, without breaking how this all works. The only real fix
> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
> tell everyone to cut over to dma-buf memory sharing for zerocopy.
> 
> userptr for normal memory will keep working as-is, this only affects
> the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
> videobuf2-dma-sg: Support io userptr operations on io memory").
> 
> Acked-by: Tomasz Figa <tfiga@chromium.org>

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Tomasz Figa <tfiga@chromium.org>
> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: Michel Lespinasse <walken@google.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> --
> v3:
> - Reference the commit that enabled the zerocopy userptr use case to
>   make it abundandtly clear that this patch only affects that, and not
>   normal memory userptr. The old commit message already explained that
>   normal memory userptr is unaffected, but I guess that was not clear
>   enough.
> ---
>  drivers/media/common/videobuf2/frame_vector.c | 2 +-
>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/media/common/videobuf2/frame_vector.c
> index a0e65481a201..1a82ec13ea00 100644
> --- a/drivers/media/common/videobuf2/frame_vector.c
> +++ b/drivers/media/common/videobuf2/frame_vector.c
> @@ -70,7 +70,7 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
>  			break;
>  
>  		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
> -			err = follow_pfn(vma, start, &nums[ret]);
> +			err = unsafe_follow_pfn(vma, start, &nums[ret]);
>  			if (err) {
>  				if (ret == 0)
>  					ret = err;
> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
> index 52312ce2ba05..821c4a76ab96 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> @@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
>  	user_address = untagged_baddr;
>  
>  	while (pages_done < (mem->size >> PAGE_SHIFT)) {
> -		ret = follow_pfn(vma, user_address, &this_pfn);
> +		ret = unsafe_follow_pfn(vma, user_address, &this_pfn);
>  		if (ret)
>  			break;
>  
> 

