Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D6F300EDB
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 22:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbhAVVYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 16:24:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728519AbhAVVYW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 16:24:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611350576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G0nEPV9kkwwR+flJI6GcZGT4fXMDLoADDCJie+ovohM=;
        b=WL0zmR05EoCHwbW8TW4aF3TP1d0OsCZ6d24BGdnj1J2rx9n3YLphp1fYqAU3cxPqQbPsf+
        4/p2SG7+s0mpuhQk99NuXO9qTx7dkKrL9SS9dGrvlI2tDYOQS00/yCigJ3BGifCFonJw9h
        +o9SmuxnNiJD0zozERSrj+caJnREeO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-9iXKb6hWNbODuRSRlzDw5Q-1; Fri, 22 Jan 2021 16:22:54 -0500
X-MC-Unique: 9iXKb6hWNbODuRSRlzDw5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 009B364156;
        Fri, 22 Jan 2021 21:22:48 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF51836FA;
        Fri, 22 Jan 2021 21:22:47 +0000 (UTC)
Date:   Fri, 22 Jan 2021 14:22:47 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V2 4/9] vfio/type1: implement unmap all
Message-ID: <20210122142247.0046a862@omen.home.shazbot.org>
In-Reply-To: <1611078509-181959-5-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
        <1611078509-181959-5-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jan 2021 09:48:24 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Implement VFIO_DMA_UNMAP_FLAG_ALL.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c687174..ef83018 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1100,6 +1100,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	unsigned long pgshift;
>  	dma_addr_t iova = unmap->iova;
>  	unsigned long size = unmap->size;
> +	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
>  
>  	mutex_lock(&iommu->lock);
>  
> @@ -1109,8 +1110,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	if (iova & (pgsize - 1))
>  		goto unlock;
>  
> -	if (!size || size & (pgsize - 1))
> +	if (unmap_all) {
> +		if (iova || size)
> +			goto unlock;
> +		size = SIZE_MAX;
> +	} else if (!size || size & (pgsize - 1)) {
>  		goto unlock;
> +	}
>  
>  	if (iova + size - 1 < iova || size > SIZE_MAX)
>  		goto unlock;
> @@ -1154,7 +1160,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	 * will only return success and a size of zero if there were no
>  	 * mappings within the range.
>  	 */
> -	if (iommu->v2) {
> +	if (iommu->v2 && !unmap_all) {
>  		dma = vfio_find_dma(iommu, iova, 1);
>  		if (dma && dma->iova != iova)
>  			goto unlock;
> @@ -1165,7 +1171,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	}
>  
>  	ret = 0;
> -	while ((dma = vfio_find_dma(iommu, iova, size))) {
> +	while ((dma = vfio_find_dma_first(iommu, iova, size))) {


Why is this necessary?  Isn't vfio_find_dma_first() O(logN) for this
operation while vfio_find_dma() is O(1)?

>  		if (!iommu->v2 && iova > dma->iova)
>  			break;
>  		/*
> @@ -2538,6 +2544,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  	case VFIO_TYPE1_IOMMU:
>  	case VFIO_TYPE1v2_IOMMU:
>  	case VFIO_TYPE1_NESTING_IOMMU:
> +	case VFIO_UNMAP_ALL:
>  		return 1;
>  	case VFIO_DMA_CC_IOMMU:
>  		if (!iommu)
> @@ -2710,6 +2717,8 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>  {
>  	struct vfio_iommu_type1_dma_unmap unmap;
>  	struct vfio_bitmap bitmap = { 0 };
> +	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
> +			VFIO_DMA_UNMAP_FLAG_ALL;
>  	unsigned long minsz;
>  	int ret;
>  
> @@ -2718,8 +2727,11 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>  	if (copy_from_user(&unmap, (void __user *)arg, minsz))
>  		return -EFAULT;
>  
> -	if (unmap.argsz < minsz ||
> -	    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
> +	if (unmap.argsz < minsz || unmap.flags & ~mask)
> +		return -EINVAL;
> +
> +	if ((unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> +	    (unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP))

Somehow we're jumping from unmap-all and dirty-bitmap being mutually
exclusive to dirty-bitmap is absolutely exclusive, which seems like a
future bug or maintenance issue.  Let's just test specifically what
we're deciding is unsupported.  Thanks,

Alex

>  		return -EINVAL;
>  
>  	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {

