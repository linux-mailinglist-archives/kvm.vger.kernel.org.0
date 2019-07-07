Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B66661554
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2019 17:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfGGPDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 11:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40584 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfGGPDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 11:03:08 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E035308792F;
        Sun,  7 Jul 2019 15:02:59 +0000 (UTC)
Received: from [10.36.116.46] (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4AE519C79;
        Sun,  7 Jul 2019 15:02:49 +0000 (UTC)
Subject: Re: [PATCH v7 1/6] vfio/type1: Introduce iova list and add iommu
 aperture validity check
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        alex.williamson@redhat.com, pmorel@linux.vnet.ibm.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linuxarm@huawei.com,
        john.garry@huawei.com, xuwei5@hisilicon.com, kevin.tian@intel.com
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
 <20190626151248.11776-2-shameerali.kolothum.thodi@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <9ae8755a-9a2a-da76-e0c1-0f36f75ec2b3@redhat.com>
Date:   Sun, 7 Jul 2019 17:02:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190626151248.11776-2-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Sun, 07 Jul 2019 15:03:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 6/26/19 5:12 PM, Shameer Kolothum wrote:
> This introduces an iova list that is valid for dma mappings. Make
> sure the new iommu aperture window doesn't conflict with the current
> one or with any existing dma mappings during attach.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 181 +++++++++++++++++++++++++++++++-
>  1 file changed, 177 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index add34adfadc7..970d1ec06aed 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1,4 +1,3 @@
> -// SPDX-License-Identifier: GPL-2.0-only
>  /*
>   * VFIO: IOMMU DMA mapping support for Type1 IOMMU
>   *
> @@ -62,6 +61,7 @@ MODULE_PARM_DESC(dma_entry_limit,
>  
>  struct vfio_iommu {
>  	struct list_head	domain_list;
> +	struct list_head	iova_list;
>  	struct vfio_domain	*external_domain; /* domain for external user */
>  	struct mutex		lock;
>  	struct rb_root		dma_list;
> @@ -97,6 +97,12 @@ struct vfio_group {
>  	bool			mdev_group;	/* An mdev group */
>  };
>  
> +struct vfio_iova {
> +	struct list_head	list;
> +	dma_addr_t		start;
> +	dma_addr_t		end;
> +};
> +
>  /*
>   * Guest RAM pinning working set or DMA target
>   */
> @@ -1401,6 +1407,146 @@ static int vfio_mdev_iommu_device(struct device *dev, void *data)
>  	return 0;
>  }
>  
> +/*
> + * This is a helper function to insert an address range to iova list.
> + * The list starts with a single entry corresponding to the IOMMU
The list is initially created with a single entry ../..
> + * domain geometry to which the device group is attached. The list
> + * aperture gets modified when a new domain is added to the container
> + * if the new aperture doesn't conflict with the current one or with
> + * any existing dma mappings. The list is also modified to exclude
> + * any reserved regions associated with the device group.
> + */
> +static int vfio_iommu_iova_insert(struct list_head *head,
> +				  dma_addr_t start, dma_addr_t end)
> +{
> +	struct vfio_iova *region;
> +
> +	region = kmalloc(sizeof(*region), GFP_KERNEL);
> +	if (!region)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&region->list);
> +	region->start = start;
> +	region->end = end;
> +
> +	list_add_tail(&region->list, head);
> +	return 0;
> +}
> +
> +/*
> + * Check the new iommu aperture conflicts with existing aper or with any
> + * existing dma mappings.
> + */
> +static bool vfio_iommu_aper_conflict(struct vfio_iommu *iommu,
> +				     dma_addr_t start, dma_addr_t end)
> +{
> +	struct vfio_iova *first, *last;
> +	struct list_head *iova = &iommu->iova_list;
> +
> +	if (list_empty(iova))
> +		return false;
> +
> +	/* Disjoint sets, return conflict */
> +	first = list_first_entry(iova, struct vfio_iova, list);
> +	last = list_last_entry(iova, struct vfio_iova, list);
> +	if (start > last->end || end < first->start)
> +		return true;
> +
> +	/* Check for any existing dma mappings outside the new start */
s/outside/below
> +	if (start > first->start) {
> +		if (vfio_find_dma(iommu, first->start, start - first->start))
> +			return true;
> +	}
> +
> +	/* Check for any existing dma mappings outside the new end */
s/outside/beyond
> +	if (end < last->end) {
> +		if (vfio_find_dma(iommu, end + 1, last->end - end))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Resize iommu iova aperture window. This is called only if the new
> + * aperture has no conflict with existing aperture and dma mappings.
> + */
> +static int vfio_iommu_aper_resize(struct list_head *iova,
> +				  dma_addr_t start, dma_addr_t end)
> +{
> +	struct vfio_iova *node, *next;
> +
> +	if (list_empty(iova))
> +		return vfio_iommu_iova_insert(iova, start, end);
> +
> +	/* Adjust iova list start */
> +	list_for_each_entry_safe(node, next, iova, list) {
> +		if (start < node->start)
> +			break;
> +		if (start >= node->start && start < node->end) {
> +			node->start = start;
> +			break;
> +		}
> +		/* Delete nodes before new start */
> +		list_del(&node->list);
> +		kfree(node);
> +	}
> +
> +	/* Adjust iova list end */
> +	list_for_each_entry_safe(node, next, iova, list) {
> +		if (end > node->end)
> +			continue;
> +		if (end > node->start && end <= node->end) {
> +			node->end = end;
> +			continue;
> +		}
> +		/* Delete nodes after new end */
> +		list_del(&node->list);
> +		kfree(node);
> +	}
> +
> +	return 0;
> +}
> +
> +static void vfio_iommu_iova_free(struct list_head *iova)
> +{
> +	struct vfio_iova *n, *next;
> +
> +	list_for_each_entry_safe(n, next, iova, list) {
> +		list_del(&n->list);
> +		kfree(n);
> +	}
> +}
> +
> +static int vfio_iommu_iova_get_copy(struct vfio_iommu *iommu,
> +				    struct list_head *iova_copy)
> +{
> +	struct list_head *iova = &iommu->iova_list;
> +	struct vfio_iova *n;
> +	int ret;
> +
> +	list_for_each_entry(n, iova, list) {
> +		ret = vfio_iommu_iova_insert(iova_copy, n->start, n->end);
> +		if (ret)
> +			goto out_free;
> +	}
> +
> +	return 0;
> +
> +out_free:
> +	vfio_iommu_iova_free(iova_copy);
> +	return ret;
> +}
> +
> +static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
> +					struct list_head *iova_copy)
> +{
> +	struct list_head *iova = &iommu->iova_list;
> +
> +	vfio_iommu_iova_free(iova);
> +
> +	list_splice_tail(iova_copy, iova);
> +}
>  static int vfio_iommu_type1_attach_group(void *iommu_data,
>  					 struct iommu_group *iommu_group)
>  {
> @@ -1411,6 +1557,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	int ret;
>  	bool resv_msi, msi_remap;
>  	phys_addr_t resv_msi_base;
> +	struct iommu_domain_geometry geo;
> +	LIST_HEAD(iova_copy);
>  
>  	mutex_lock(&iommu->lock);
>  
> @@ -1487,6 +1635,25 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	if (ret)
>  		goto out_domain;
>  
> +	/* Get aperture info */
> +	iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY, &geo);
> +
> +	if (vfio_iommu_aper_conflict(iommu, geo.aperture_start,
> +				     geo.aperture_end)) {
> +		ret = -EINVAL;
> +		goto out_detach;
> +	}
> +
> +	/* Get a copy of the current iova list and work on it */
At this stage of the reading it is not obvious why you need a copy of
the list. rationale can be found when reading further or in the series
history ("Use of iova list copy so that original is not altered in case
of failure").

Adding a comment in the code would be useful I think.

Thanks

Eric

> +	ret = vfio_iommu_iova_get_copy(iommu, &iova_copy);
> +	if (ret)
> +		goto out_detach;
> +
> +	ret = vfio_iommu_aper_resize(&iova_copy, geo.aperture_start,
> +				     geo.aperture_end);
> +	if (ret)
> +		goto out_detach;
> +
>  	resv_msi = vfio_iommu_has_sw_msi(iommu_group, &resv_msi_base);
>  
>  	INIT_LIST_HEAD(&domain->group_list);
> @@ -1520,8 +1687,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  				list_add(&group->next, &d->group_list);
>  				iommu_domain_free(domain->domain);
>  				kfree(domain);
> -				mutex_unlock(&iommu->lock);
> -				return 0;
> +				goto done;
>  			}
>  
>  			ret = vfio_iommu_attach_group(domain, group);
> @@ -1544,7 +1710,9 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	}
>  
>  	list_add(&domain->next, &iommu->domain_list);
> -
> +done:
> +	/* Delete the old one and insert new iova list */
> +	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
>  	mutex_unlock(&iommu->lock);
>  
>  	return 0;
> @@ -1553,6 +1721,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	vfio_iommu_detach_group(domain, group);
>  out_domain:
>  	iommu_domain_free(domain->domain);
> +	vfio_iommu_iova_free(&iova_copy);
>  out_free:
>  	kfree(domain);
>  	kfree(group);
> @@ -1692,6 +1861,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	}
>  
>  	INIT_LIST_HEAD(&iommu->domain_list);
> +	INIT_LIST_HEAD(&iommu->iova_list);
>  	iommu->dma_list = RB_ROOT;
>  	iommu->dma_avail = dma_entry_limit;
>  	mutex_init(&iommu->lock);
> @@ -1735,6 +1905,9 @@ static void vfio_iommu_type1_release(void *iommu_data)
>  		list_del(&domain->next);
>  		kfree(domain);
>  	}
> +
> +	vfio_iommu_iova_free(&iommu->iova_list);
> +
>  	kfree(iommu);
>  }
>  
> 
