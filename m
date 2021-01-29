Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC84309061
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 00:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhA2W7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 17:59:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231367AbhA2W7q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 17:59:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611961100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=js3WqeMssgVvObPx3rZpffH/XM/Kj1h1Hr6xcv9t5aw=;
        b=c6ixEacLz8QRKsx/fZKEynlSGnAHRHyCbl6/KpjdVd8qIs2k4xmvGI282OckOGXNg7E6sJ
        BtjBUs28HVHvr5qrhBSJKArjBfT09FtN8rYBChvAyT8+H8465YUDcAIsbDwW8NKv5zmDLi
        V6WBJfzClqWw7ZF2V5I3CfyOEjEwi1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-n93dbMiPMMm9gTxMUYLRrQ-1; Fri, 29 Jan 2021 17:58:17 -0500
X-MC-Unique: n93dbMiPMMm9gTxMUYLRrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FE4C1005504;
        Fri, 29 Jan 2021 22:58:16 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92FEE5D71B;
        Fri, 29 Jan 2021 22:58:12 +0000 (UTC)
Date:   Fri, 29 Jan 2021 15:58:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH v1 1/4] vfio/type1: Add a bitmap to track IOPF
 mapped pages
Message-ID: <20210129155812.384cc56e@omen.home.shazbot.org>
In-Reply-To: <20210125090402.1429-2-lushenming@huawei.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
        <20210125090402.1429-2-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jan 2021 17:03:59 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> When IOPF enabled, the pages are pinned and mapped on demand, we add
> a bitmap to track them.
> 
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0b4dedaa9128..f1d4de5ab094 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -95,6 +95,7 @@ struct vfio_dma {
>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>  	unsigned long		*bitmap;
> +	unsigned long		*iommu_mapped_bitmap;	/* IOPF mapped bitmap */
>  };
>  
>  struct vfio_group {
> @@ -143,6 +144,8 @@ struct vfio_regions {
>  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
>  #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>  
> +#define IOMMU_MAPPED_BITMAP_BYTES(n) DIRTY_BITMAP_BYTES(n)
> +
>  static int put_pfn(unsigned long pfn, int prot);
>  
>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> @@ -949,6 +952,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  	vfio_unlink_dma(iommu, dma);
>  	put_task_struct(dma->task);
>  	vfio_dma_bitmap_free(dma);
> +	kfree(dma->iommu_mapped_bitmap);
>  	kfree(dma);
>  	iommu->dma_avail++;
>  }
> @@ -1354,6 +1358,14 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  		goto out_unlock;
>  	}
>  
> +	dma->iommu_mapped_bitmap = kvzalloc(IOMMU_MAPPED_BITMAP_BYTES(size / PAGE_SIZE),
> +					    GFP_KERNEL);

This is a lot of bloat for all the platforms that don't support this
feature.  Thanks,

Alex

> +	if (!dma->iommu_mapped_bitmap) {
> +		ret = -ENOMEM;
> +		kfree(dma);
> +		goto out_unlock;
> +	}
> +
>  	iommu->dma_avail--;
>  	dma->iova = iova;
>  	dma->vaddr = vaddr;

