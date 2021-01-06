Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775D72EB6A9
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 01:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbhAFAEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 19:04:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbhAFAD7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 19:03:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609891353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rqhr6scVf/TnXzwQhEOyu7WWWB5S6EJyia+/dIzLf8M=;
        b=KRLye7m4UP2K1sl8+xHjVjXyHGLhdNQ3/VG7/MmmksqouGENbbYlHEjSRDMALSsOoefcVT
        eY5zJzCRQ/6UtllwovAu48MIVeTKyIjsMcOMIHTu0i4a4D2aZIHNGAzDte9EkJnfAQTiPE
        8hxB9Bdahk30/wAlZf4sbRxDtygtOfw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-mzZhezLlNdm14GO6z2K7UQ-1; Tue, 05 Jan 2021 19:02:31 -0500
X-MC-Unique: mzZhezLlNdm14GO6z2K7UQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50A90800D55;
        Wed,  6 Jan 2021 00:02:30 +0000 (UTC)
Received: from omen.home (ovpn-112-183.phx2.redhat.com [10.3.112.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 093345D9CD;
        Wed,  6 Jan 2021 00:02:29 +0000 (UTC)
Date:   Tue, 5 Jan 2021 17:02:29 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V1 1/5] vfio: maintain dma_list order
Message-ID: <20210105170229.73799d97@omen.home>
In-Reply-To: <1609861013-129801-2-git-send-email-steven.sistare@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
        <1609861013-129801-2-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steven,

On Tue,  5 Jan 2021 07:36:49 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Keep entries properly sorted in the dma_list rb_tree

Nothing here changes the order of entries in the tree, they're already
sorted.  The second chunk is the only thing that touches the tree
construction, but that appears to be just a micro optimization that
we've already used vfio_find_dma() to verify that a new entry doesn't
overlap any existing entries, therefore if the start of the new entry
is less than the test entry, the end must also be less.  The tree is
not changed afaict.

> so that iterating
> over multiple entries across a range with gaps works, without requiring
> one to delete each visited entry as in vfio_dma_do_unmap.

As above, I don't see that the tree is changed, so this is just a
manipulation of our search function, changing it from a "find any
vfio_dma within this range" to a "find the vfio_dma with the lowest
iova with this range".  But find-any and find-first are computationally
different, so I don't think we should blindly replace one with the
other.  Wouldn't it make more sense to add a vfio_find_first_dma()
function in patch 4/ to handle this case?  Thanks,

Alex

> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5fbf0c1..02228d0 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -157,20 +157,24 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
>  				      dma_addr_t start, size_t size)
>  {
> +	struct vfio_dma *res = 0;
>  	struct rb_node *node = iommu->dma_list.rb_node;
>  
>  	while (node) {
>  		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
>  
> -		if (start + size <= dma->iova)
> +		if (start < dma->iova + dma->size) {
> +			res = dma;
> +			if (start >= dma->iova)
> +				break;
>  			node = node->rb_left;
> -		else if (start >= dma->iova + dma->size)
> +		} else {
>  			node = node->rb_right;
> -		else
> -			return dma;
> +		}
>  	}
> -
> -	return NULL;
> +	if (res && size && res->iova >= start + size)
> +		res = 0;
> +	return res;
>  }
>  
>  static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
> @@ -182,7 +186,7 @@ static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
>  		parent = *link;
>  		dma = rb_entry(parent, struct vfio_dma, node);
>  
> -		if (new->iova + new->size <= dma->iova)
> +		if (new->iova < dma->iova)
>  			link = &(*link)->rb_left;
>  		else
>  			link = &(*link)->rb_right;

