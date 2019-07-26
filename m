Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC1B76F83
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 19:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbfGZRJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 13:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387437AbfGZRJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 13:09:51 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B16F25AFD9;
        Fri, 26 Jul 2019 17:09:50 +0000 (UTC)
Received: from [10.36.116.102] (ovpn-116-102.ams2.redhat.com [10.36.116.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F2771711C;
        Fri, 26 Jul 2019 17:09:44 +0000 (UTC)
Subject: Re: [PATCH v8 2/6] vfio/type1: Check reserved region conflict and
 update iova list
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linuxarm@huawei.com,
        john.garry@huawei.com, xuwei5@hisilicon.com, kevin.tian@intel.com
References: <20190723160637.8384-1-shameerali.kolothum.thodi@huawei.com>
 <20190723160637.8384-3-shameerali.kolothum.thodi@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f8cf7545-2f8c-d1d9-dc51-e787c1a881fb@redhat.com>
Date:   Fri, 26 Jul 2019 19:09:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190723160637.8384-3-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 26 Jul 2019 17:09:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 7/23/19 6:06 PM, Shameer Kolothum wrote:
> This retrieves the reserved regions associated with dev group and
> checks for conflicts with any existing dma mappings. Also update
> the iova list excluding the reserved regions.
> 
> Reserved regions with type IOMMU_RESV_DIRECT_RELAXABLE are
> excluded from above checks as they are considered as directly
> mapped regions which are known to be relaxable.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
> v7-->v8
>  -Added check for iommu_get_group_resv_regions() error ret.
> 
> ---
>  drivers/vfio/vfio_iommu_type1.c | 98 +++++++++++++++++++++++++++++++++
>  1 file changed, 98 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 6a69652b406b..a3c9794ccf83 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1496,6 +1496,88 @@ static int vfio_iommu_aper_resize(struct list_head *iova,
>  	return 0;
>  }
>  
> +/*
> + * Check reserved region conflicts with existing dma mappings
> + */
> +static bool vfio_iommu_resv_conflict(struct vfio_iommu *iommu,
> +				     struct list_head *resv_regions)
> +{
> +	struct iommu_resv_region *region;
> +
> +	/* Check for conflict with existing dma mappings */
> +	list_for_each_entry(region, resv_regions, list) {
> +		if (region->type == IOMMU_RESV_DIRECT_RELAXABLE)
> +			continue;
> +
> +		if (vfio_find_dma(iommu, region->start, region->length))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Check iova region overlap with  reserved regions and
> + * exclude them from the iommu iova range
> + */
> +static int vfio_iommu_resv_exclude(struct list_head *iova,
> +				   struct list_head *resv_regions)
> +{
> +	struct iommu_resv_region *resv;
> +	struct vfio_iova *n, *next;
> +
> +	list_for_each_entry(resv, resv_regions, list) {
> +		phys_addr_t start, end;
> +
> +		if (resv->type == IOMMU_RESV_DIRECT_RELAXABLE)
> +			continue;
> +
> +		start = resv->start;
> +		end = resv->start + resv->length - 1;
> +
> +		list_for_each_entry_safe(n, next, iova, list) {
> +			int ret = 0;
> +
> +			/* No overlap */
> +			if (start > n->end || end < n->start)
> +				continue;
> +			/*
> +			 * Insert a new node if current node overlaps with the
> +			 * reserve region to exlude that from valid iova range.
> +			 * Note that, new node is inserted before the current
> +			 * node and finally the current node is deleted keeping
> +			 * the list updated and sorted.
> +			 */
> +			if (start > n->start)
> +				ret = vfio_iommu_iova_insert(&n->list, n->start,
> +							     start - 1);
> +			if (!ret && end < n->end)
> +				ret = vfio_iommu_iova_insert(&n->list, end + 1,
> +							     n->end);
> +			if (ret)
> +				return ret;
> +
> +			list_del(&n->list);
> +			kfree(n);
> +		}
> +	}
> +
> +	if (list_empty(iova))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static void vfio_iommu_resv_free(struct list_head *resv_regions)
> +{
> +	struct iommu_resv_region *n, *next;
> +
> +	list_for_each_entry_safe(n, next, resv_regions, list) {
> +		list_del(&n->list);
> +		kfree(n);
> +	}
> +}
> +
>  static void vfio_iommu_iova_free(struct list_head *iova)
>  {
>  	struct vfio_iova *n, *next;
> @@ -1547,6 +1629,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	phys_addr_t resv_msi_base;
>  	struct iommu_domain_geometry geo;
>  	LIST_HEAD(iova_copy);
> +	LIST_HEAD(group_resv_regions);
>  
>  	mutex_lock(&iommu->lock);
>  
> @@ -1632,6 +1715,15 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		goto out_detach;
>  	}
>  
> +	ret = iommu_get_group_resv_regions(iommu_group, &group_resv_regions);
> +	if (ret)
> +		goto out_detach;
> +
> +	if (vfio_iommu_resv_conflict(iommu, &group_resv_regions)) {
> +		ret = -EINVAL;
> +		goto out_detach;
> +	}
> +
>  	/*
>  	 * We don't want to work on the original iova list as the list
>  	 * gets modified and in case of failure we have to retain the
> @@ -1646,6 +1738,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	if (ret)
>  		goto out_detach;
>  
> +	ret = vfio_iommu_resv_exclude(&iova_copy, &group_resv_regions);
> +	if (ret)
> +		goto out_detach;
> +
>  	resv_msi = vfio_iommu_has_sw_msi(iommu_group, &resv_msi_base);
>  
>  	INIT_LIST_HEAD(&domain->group_list);
> @@ -1706,6 +1802,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	/* Delete the old one and insert new iova list */
>  	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
>  	mutex_unlock(&iommu->lock);
> +	vfio_iommu_resv_free(&group_resv_regions);
>  
>  	return 0;
>  
> @@ -1714,6 +1811,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  out_domain:
>  	iommu_domain_free(domain->domain);
>  	vfio_iommu_iova_free(&iova_copy);
> +	vfio_iommu_resv_free(&group_resv_regions);
>  out_free:
>  	kfree(domain);
>  	kfree(group);
> 
