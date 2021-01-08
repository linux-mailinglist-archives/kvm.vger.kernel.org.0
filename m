Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF5B2EFAA9
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 22:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbhAHVeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 16:34:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbhAHVeA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Jan 2021 16:34:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610141553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0IoRIj3w9/bF/WdiGWmX9Z0XQT5SH+j37hHNuETsw20=;
        b=b8EzOVQ2yHLNorKulHkaYBuAn/nIfWreSa3ftsg6lFVwYGRwQRWK+6exGKXDqImTb0LfyY
        R34lAROuKEeHZF4OHdfPq27WoPdw7YYsFA9NAak5H9FxeeTyd/sluFfAEy1Y046lbagXwf
        q4gaCsb7yJEGsc2p2LpaJAqCIRouVac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-SgZ1j2WfMSWVcYDWOXs6WQ-1; Fri, 08 Jan 2021 16:32:31 -0500
X-MC-Unique: SgZ1j2WfMSWVcYDWOXs6WQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0088910054FF;
        Fri,  8 Jan 2021 21:32:30 +0000 (UTC)
Received: from omen.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C4925E1A7;
        Fri,  8 Jan 2021 21:32:29 +0000 (UTC)
Date:   Fri, 8 Jan 2021 14:32:29 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V1 5/5] vfio: block during VA suspend
Message-ID: <20210108143229.0543ccce@omen.home>
In-Reply-To: <1609861013-129801-6-git-send-email-steven.sistare@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
        <1609861013-129801-6-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Jan 2021 07:36:53 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Block translation of host virtual address while an iova range is suspended.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 48 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 2c164a6..8035b9a 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -31,6 +31,8 @@
>  #include <linux/rbtree.h>
>  #include <linux/sched/signal.h>
>  #include <linux/sched/mm.h>
> +#include <linux/delay.h>
> +#include <linux/kthread.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
> @@ -484,6 +486,34 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  	return ret;
>  }
>  
> +static bool vfio_iommu_contained(struct vfio_iommu *iommu)
> +{
> +	struct vfio_domain *domain = iommu->external_domain;
> +	struct vfio_group *group;
> +
> +	if (!domain)
> +		domain = list_first_entry(&iommu->domain_list,
> +					  struct vfio_domain, next);
> +
> +	group = list_first_entry(&domain->group_list, struct vfio_group, next);
> +	return vfio_iommu_group_contained(group->iommu_group);
> +}

This seems really backwards for a vfio iommu backend to ask vfio-core
whether its internal object is active.

> +
> +
> +bool vfio_vaddr_valid(struct vfio_iommu *iommu, struct vfio_dma *dma)
> +{
> +	while (dma->suspended) {
> +		mutex_unlock(&iommu->lock);
> +		msleep_interruptible(10);
> +		mutex_lock(&iommu->lock);
> +		if (kthread_should_stop() || !vfio_iommu_contained(iommu) ||
> +		    fatal_signal_pending(current)) {
> +			return false;
> +		}
> +	}
> +	return true;
> +}
> +
>  /*
>   * Attempt to pin pages.  We really don't want to track all the pfns and
>   * the iommu can only map chunks of consecutive pfns anyway, so get the
> @@ -690,6 +720,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  			continue;
>  		}
>  
> +		if (!vfio_vaddr_valid(iommu, dma)) {
> +			ret = -EFAULT;
> +			goto pin_unwind;
> +		}

This could have dropped iommu->lock, we have no basis to believe our
vfio_dma object is still valid.  Also this is called with an elevated
reference to the container, so we theoretically should not need to test
whether the iommu is still contained.

> +
>  		remote_vaddr = dma->vaddr + (iova - dma->iova);
>  		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
>  					     do_accounting);
> @@ -1514,12 +1549,16 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  					i += PAGE_SIZE;
>  				}
>  			} else {
> -				unsigned long pfn;
> -				unsigned long vaddr = dma->vaddr +
> -						     (iova - dma->iova);
> +				unsigned long pfn, vaddr;
>  				size_t n = dma->iova + dma->size - iova;
>  				long npage;
>  
> +				if (!vfio_vaddr_valid(iommu, dma)) {
> +					ret = -EFAULT;
> +					goto unwind;
> +				}

This one is even scarier, do we have any basis to assume either object
is still valid after iommu->lock is released?  We can only get here if
we're attaching a group to the iommu with suspended vfio_dmas.  Do we
need to allow that?  It seems we could -EAGAIN and let the user figure
out that they can't attach a group while mappings have invalid vaddrs.

> +				vaddr = dma->vaddr + (iova - dma->iova);
> +
>  				npage = vfio_pin_pages_remote(dma, vaddr,
>  							      n >> PAGE_SHIFT,
>  							      &pfn, limit);
> @@ -2965,6 +3004,9 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>  	if (count > dma->size - offset)
>  		count = dma->size - offset;
>  
> +	if (!vfio_vaddr_valid(iommu, dma))

Same as the pinning path, this should hold a container user reference
but we cannot assume our vfio_dma object is valid if we've released the
lock.  Thanks,

Alex

> +		goto out;
> +
>  	vaddr = dma->vaddr + offset;
>  
>  	if (write) {

