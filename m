Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A090308FB3
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 22:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhA2V5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 16:57:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233293AbhA2V5v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 16:57:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611957376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8AyFkbSTLGWAv2O2vsKC2yNJPTd6DUd0UEAlpMOHk6o=;
        b=DONuemIcr2O3XbjlOF9/Wb06aJqri+sjSUp5HKx2F9NOpRdRqXE1xWsk/s4rEuP27UJlAg
        fKPQ9j9aeXriZHkqQrSBG2ebSjYPPT/MA7ojDXaks/MTl/vb+vySmY7oCP9EQVcyuJQcsS
        XFw8byFBEGrZHPuu02PyMg69MUG9Zlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-E8DLeY3NPMmL3BzG_mZWSg-1; Fri, 29 Jan 2021 16:56:13 -0500
X-MC-Unique: E8DLeY3NPMmL3BzG_mZWSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A343159;
        Fri, 29 Jan 2021 21:56:12 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E3A16F977;
        Fri, 29 Jan 2021 21:56:12 +0000 (UTC)
Date:   Fri, 29 Jan 2021 14:56:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 5/9] vfio/type1: massage unmap iteration
Message-ID: <20210129145612.0b507334@omen.home.shazbot.org>
In-Reply-To: <1611939252-7240-6-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-6-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:08 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Modify the iteration in vfio_dma_do_unmap so it does not depend on deletion
> of each dma entry.  Add a variant of vfio_find_dma that returns the entry
> with the lowest iova in the search range to initialize the iteration.  No
> externally visible change, but this behavior is needed in the subsequent
> update-vaddr patch.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 407f0f7..5823607 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -173,6 +173,31 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
>  	return NULL;
>  }
>  
> +static struct rb_node *vfio_find_dma_first(struct vfio_iommu *iommu,
> +					    dma_addr_t start, size_t size)

Nit, we return an rb_node rather than a vfio_dma now, but the naming is
still pretty similar to vfio_find_dma().  Can I change it to
vfio_find_dma_first_node() (yes, getting wordy)?  Thanks,

Alex

> +{
> +	struct rb_node *res = NULL;
> +	struct rb_node *node = iommu->dma_list.rb_node;
> +	struct vfio_dma *dma_res = NULL;
> +
> +	while (node) {
> +		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
> +
> +		if (start < dma->iova + dma->size) {
> +			res = node;
> +			dma_res = dma;
> +			if (start >= dma->iova)
> +				break;
> +			node = node->rb_left;
> +		} else {
> +			node = node->rb_right;
> +		}
> +	}
> +	if (res && size && dma_res->iova >= start + size)
> +		res = NULL;
> +	return res;
> +}
> +
>  static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
>  {
>  	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
> @@ -1078,6 +1103,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	dma_addr_t iova = unmap->iova;
>  	unsigned long size = unmap->size;
>  	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
> +	struct rb_node *n;
>  
>  	mutex_lock(&iommu->lock);
>  
> @@ -1148,7 +1174,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	}
>  
>  	ret = 0;
> -	while ((dma = vfio_find_dma(iommu, iova, size))) {
> +	n = vfio_find_dma_first(iommu, iova, size);
> +
> +	while (n) {
> +		dma = rb_entry(n, struct vfio_dma, node);
> +		if (dma->iova >= iova + size)
> +			break;
> +
>  		if (!iommu->v2 && iova > dma->iova)
>  			break;
>  		/*
> @@ -1193,6 +1225,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		}
>  
>  		unmapped += dma->size;
> +		n = rb_next(n);
>  		vfio_remove_dma(iommu, dma);
>  	}
>  

