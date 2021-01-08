Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6E02EF844
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 20:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbhAHThU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 14:37:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728647AbhAHThT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Jan 2021 14:37:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610134553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gY2dF0DxPc55+4vkjVa9lmc3q09QMCSNLK3uz6G9NaQ=;
        b=gKHBRZJterlKAsoL1/3yoqJi7RHTuc9dF9EcmPe4St2pCVjQqYMLVbX/q0sgmP82EiV3I2
        eeAgn42Y4ABbBhNcdQoO55RahzOWlpU9x1w2OPZVNF7+lx9YqAMc22yR4IB33uU65zFN/z
        v50OCF9NsUjqu94am8sgVzIc7nJZL88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-NTI5Oe6XPriGBlcBg6LMaw-1; Fri, 08 Jan 2021 14:35:51 -0500
X-MC-Unique: NTI5Oe6XPriGBlcBg6LMaw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 081B0800D55;
        Fri,  8 Jan 2021 19:35:50 +0000 (UTC)
Received: from omen.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6A7260BF3;
        Fri,  8 Jan 2021 19:35:49 +0000 (UTC)
Date:   Fri, 8 Jan 2021 12:35:48 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V1 2/5] vfio: option to unmap all
Message-ID: <20210108123548.033377e7@omen.home>
In-Reply-To: <1609861013-129801-3-git-send-email-steven.sistare@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
        <1609861013-129801-3-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steve,

On Tue,  5 Jan 2021 07:36:50 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> For VFIO_IOMMU_UNMAP_DMA, delete all mappings if iova=0 and size=0.

Only the latter is invalid, iova=0 is not special, so does it make
sense to use this combination to invoke something special?  It seems
like it opens the door that any size less than the minimum mapping
granularity means something special.

Why not use a flag to trigger an unmap-all?

Does userspace have any means to know this is supported other than to
test it before creating any mappings?

What's the intended interaction with retrieving the dirty bitmap during
an unmap-all?

> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 11 ++++++++---
>  include/uapi/linux/vfio.h       |  3 ++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 02228d0..3dc501d 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1079,6 +1079,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	size_t unmapped = 0, pgsize;
>  	int ret = 0, retries = 0;
>  	unsigned long pgshift;
> +	dma_addr_t iova;
> +	unsigned long size;
>  
>  	mutex_lock(&iommu->lock);
>  
> @@ -1090,7 +1092,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		goto unlock;
>  	}
>  
> -	if (!unmap->size || unmap->size & (pgsize - 1)) {
> +	if ((!unmap->size && unmap->iova) || unmap->size & (pgsize - 1)) {
>  		ret = -EINVAL;
>  		goto unlock;
>  	}
> @@ -1154,8 +1156,11 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,

It looks like the code just above this would have an issue if there are
dma mappings at iova=0.

>  		}
>  	}
>  
> -	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size))) {
> -		if (!iommu->v2 && unmap->iova > dma->iova)
> +	iova = unmap->iova;
> +	size = unmap->size ? unmap->size : SIZE_MAX;

AFAICT the only difference of this versus the user calling the unmap
with iova=0 size=SIZE_MAX is that SIZE_MAX will throw an -EINVAL due to
page size alignment.  If we assume there are no IOMMUs with 1 byte page
size, the special combination could instead be {0, SIZE_MAX}.  Or the
caller could just track a high water mark for their mappings and use
the interface that exists.  Thanks,

Alex

> +
> +	while ((dma = vfio_find_dma(iommu, iova, size))) {
> +		if (!iommu->v2 && iova > dma->iova)
>  			break;
>  		/*
>  		 * Task with same address space who mapped this iova range is
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9204705..896e527 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1073,7 +1073,8 @@ struct vfio_bitmap {
>   * Caller sets argsz.  The actual unmapped size is returned in the size
>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
>   * or size different from those used in the original mapping call will
> - * succeed.
> + * succeed.  If iova=0 and size=0, all addresses are unmapped.
> + *
>   * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
>   * before unmapping IO virtual addresses. When this flag is set, the user must
>   * provide a struct vfio_bitmap in data[]. User must provide zero-allocated

