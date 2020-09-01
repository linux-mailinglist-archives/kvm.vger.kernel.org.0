Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CB9259FD0
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 22:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgIAUQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 16:16:13 -0400
Received: from foss.arm.com ([217.140.110.172]:49600 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgIAUQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 16:16:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62C201063;
        Tue,  1 Sep 2020 13:16:07 -0700 (PDT)
Received: from [10.57.40.122] (unknown [10.57.40.122])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBC083F66F;
        Tue,  1 Sep 2020 13:16:04 -0700 (PDT)
Subject: Re: [PATCH v9 30/32] samples: vfio-mdev/mbochs: fix common struct
 sg_table related issues
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux-foundation.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
References: <20200826063316.23486-1-m.szyprowski@samsung.com>
 <CGME20200826063546eucas1p268558dcd08ac9b43843f9f5e23da227d@eucas1p2.samsung.com>
 <20200826063316.23486-31-m.szyprowski@samsung.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <2cd26a4d-ca66-2ee8-145c-b928474fefe9@arm.com>
Date:   Tue, 1 Sep 2020 21:16:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200826063316.23486-31-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-26 07:33, Marek Szyprowski wrote:
> The Documentation/DMA-API-HOWTO.txt states that the dma_map_sg() function
> returns the number of the created entries in the DMA address space.
> However the subsequent calls to the dma_sync_sg_for_{device,cpu}() and
> dma_unmap_sg must be called with the original number of the entries
> passed to the dma_map_sg().
> 
> struct sg_table is a common structure used for describing a non-contiguous
> memory buffer, used commonly in the DRM and graphics subsystems. It
> consists of a scatterlist with memory pages and DMA addresses (sgl entry),
> as well as the number of scatterlist entries: CPU pages (orig_nents entry)
> and DMA mapped pages (nents entry).
> 
> It turned out that it was a common mistake to misuse nents and orig_nents
> entries, calling DMA-mapping functions with a wrong number of entries or
> ignoring the number of mapped entries returned by the dma_map_sg()
> function.
> 
> To avoid such issues, lets use a common dma-mapping wrappers operating
> directly on the struct sg_table objects and use scatterlist page
> iterators where possible. This, almost always, hides references to the
> nents and orig_nents entries, making the code robust, easier to follow
> and copy/paste safe.
> 
> While touching this code, also add missing call to dma_unmap_sgtable.

Reviewed-by: Robin Murphy <robin.murphy@arm.com>

> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   samples/vfio-mdev/mbochs.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 3cc5e5921682..e03068917273 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -846,7 +846,7 @@ static struct sg_table *mbochs_map_dmabuf(struct dma_buf_attachment *at,
>   	if (sg_alloc_table_from_pages(sg, dmabuf->pages, dmabuf->pagecount,
>   				      0, dmabuf->mode.size, GFP_KERNEL) < 0)
>   		goto err2;
> -	if (!dma_map_sg(at->dev, sg->sgl, sg->nents, direction))
> +	if (dma_map_sgtable(at->dev, sg, direction, 0))
>   		goto err3;
>   
>   	return sg;
> @@ -868,6 +868,7 @@ static void mbochs_unmap_dmabuf(struct dma_buf_attachment *at,
>   
>   	dev_dbg(dev, "%s: %d\n", __func__, dmabuf->id);
>   
> +	dma_unmap_sgtable(at->dev, sg, direction, 0);
>   	sg_free_table(sg);
>   	kfree(sg);
>   }
> 
