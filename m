Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE37300F3E
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 22:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbhAVVvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 16:51:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730329AbhAVVui (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 16:50:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611352140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U2cYcKEJIVrNJgdSIPG4EM8I7vzp2tQ6t1WZ/IEJapI=;
        b=HinpE0uQK87Vy2nVT8fkoeY8pQrK4D+DK9587QukcNRE5zmQxeCdrcfEvfbl/Xh0z/KqMn
        7Cs4i1ZCMCejn8ySECAl4KXvwVLpp36FzgeDEQ1yoELKLy/m/x2bzelntiOI1ZeVlXX7Vw
        m1r6uruxYtDRaG3CbaIgM8yw+3SP/OU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-zl1_kNpsNFSusqqyVt--uQ-1; Fri, 22 Jan 2021 16:48:53 -0500
X-MC-Unique: zl1_kNpsNFSusqqyVt--uQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 700AF800D55;
        Fri, 22 Jan 2021 21:48:52 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F1F010013BD;
        Fri, 22 Jan 2021 21:48:52 +0000 (UTC)
Date:   Fri, 22 Jan 2021 14:48:51 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V2 6/9] vfio/type1: implement interfaces to update vaddr
Message-ID: <20210122144851.4d930db3@omen.home.shazbot.org>
In-Reply-To: <1611078509-181959-7-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
        <1611078509-181959-7-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jan 2021 09:48:26 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Implement VFIO_DMA_UNMAP_FLAG_VADDR, VFIO_DMA_MAP_FLAG_VADDR, and
> VFIO_UPDATE_VADDR.  This is a partial implementation.  Blocking is
> added in the next patch.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 54 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ef83018..c307f62 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -92,6 +92,7 @@ struct vfio_dma {
>  	int			prot;		/* IOMMU_READ/WRITE */
>  	bool			iommu_mapped;
>  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
> +	bool			vaddr_valid;
>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>  	unsigned long		*bitmap;
> @@ -1101,6 +1102,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	dma_addr_t iova = unmap->iova;
>  	unsigned long size = unmap->size;
>  	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
> +	bool invalidate = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR);
>  
>  	mutex_lock(&iommu->lock);
>  
> @@ -1181,6 +1183,18 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		if (dma->task->mm != current->mm)
>  			break;
>  
> +		if (invalidate) {
> +			if (!dma->vaddr_valid)
> +				goto unwind;
> +			dma->vaddr_valid = false;
> +			unmapped += dma->size;
> +			size -= dma->iova + dma->size - iova;
> +			iova = dma->iova + dma->size;
> +			if (iova == 0)
> +				break;
> +			continue;
> +		}

Clearly this is where the change to find-first semantics should have
been introduced, the previous patch didn't require it.  Would it really
be that unsightly to do:

while (1) {
	if (unlikely(invalidate))
		dma = vfio_find_dma_first(...
	else
		dma = vfio_find_dma(...

	if (!dma)
		break;

Find-first followed by a tree walk might be more efficient, but of
course requires a full loop redesign.

> +
>  		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
>  			struct vfio_iommu_type1_dma_unmap nb_unmap;
>  
> @@ -1218,6 +1232,20 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		unmapped += dma->size;
>  		vfio_remove_dma(iommu, dma);
>  	}
> +	goto unlock;
> +
> +unwind:
> +	iova = unmap->iova;
> +	size = unmap_all ? SIZE_MAX : unmap->size;
> +	dma_last = dma;
> +	while ((dma = vfio_find_dma_first(iommu, iova, size)) &&
> +	       dma != dma_last) {
> +		dma->vaddr_valid = true;
> +		size -= dma->iova + dma->size - iova;
> +		iova = dma->iova + dma->size;
> +	}
> +	ret = -EINVAL;
> +	unmapped = 0;
>  
>  unlock:
>  	mutex_unlock(&iommu->lock);
> @@ -1319,6 +1347,7 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
>  static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  			   struct vfio_iommu_type1_dma_map *map)
>  {
> +	bool update = map->flags & VFIO_DMA_MAP_FLAG_VADDR;

Please pick a slightly more specific variable name, update_vaddr maybe.
Perhaps even clear_vaddr rather than invalidate above for consistency.

>  	dma_addr_t iova = map->iova;
>  	unsigned long vaddr = map->vaddr;
>  	size_t size = map->size;
> @@ -1336,13 +1365,16 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
>  		prot |= IOMMU_READ;
>  
> +	if ((prot && update) || (!prot && !update))
> +		return -EINVAL;
> +
>  	mutex_lock(&iommu->lock);
>  
>  	pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
>  
>  	WARN_ON((pgsize - 1) & PAGE_MASK);
>  
> -	if (!prot || !size || (size | iova | vaddr) & (pgsize - 1)) {
> +	if (!size || (size | iova | vaddr) & (pgsize - 1)) {
>  		ret = -EINVAL;
>  		goto out_unlock;
>  	}
> @@ -1353,7 +1385,19 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  		goto out_unlock;
>  	}
>  
> -	if (vfio_find_dma(iommu, iova, size)) {
> +	dma = vfio_find_dma(iommu, iova, size);
> +	if (update) {
> +		if (!dma) {
> +			ret = -ENOENT;
> +		} else if (dma->vaddr_valid || dma->iova != iova ||
> +			   dma->size != size) {
> +			ret = -EINVAL;
> +		} else {
> +			dma->vaddr = vaddr;
> +			dma->vaddr_valid = true;
> +		}
> +		goto out_unlock;
> +	} else if (dma) {
>  		ret = -EEXIST;
>  		goto out_unlock;
>  	}
> @@ -1377,6 +1421,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	iommu->dma_avail--;
>  	dma->iova = iova;
>  	dma->vaddr = vaddr;
> +	dma->vaddr_valid = true;
>  	dma->prot = prot;
>  
>  	/*
> @@ -2545,6 +2590,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  	case VFIO_TYPE1v2_IOMMU:
>  	case VFIO_TYPE1_NESTING_IOMMU:
>  	case VFIO_UNMAP_ALL:
> +	case VFIO_UPDATE_VADDR:
>  		return 1;
>  	case VFIO_DMA_CC_IOMMU:
>  		if (!iommu)
> @@ -2699,7 +2745,8 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
>  {
>  	struct vfio_iommu_type1_dma_map map;
>  	unsigned long minsz;
> -	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
> +	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
> +			VFIO_DMA_MAP_FLAG_VADDR;
>  
>  	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
>  
> @@ -2718,6 +2765,7 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>  	struct vfio_iommu_type1_dma_unmap unmap;
>  	struct vfio_bitmap bitmap = { 0 };
>  	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
> +			VFIO_DMA_UNMAP_FLAG_VADDR |
>  			VFIO_DMA_UNMAP_FLAG_ALL;

dirty + vaddr would need a separate test per my previous patch comment.
Thanks,

Alex

>  	unsigned long minsz;
>  	int ret;

