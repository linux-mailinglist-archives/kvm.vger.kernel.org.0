Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096D56155C
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2019 17:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfGGPDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 11:03:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfGGPDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 11:03:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0E4A7FDCA;
        Sun,  7 Jul 2019 15:03:52 +0000 (UTC)
Received: from [10.36.116.46] (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A0D5E98B1;
        Sun,  7 Jul 2019 15:03:48 +0000 (UTC)
Subject: Re: [PATCH v7 6/6] vfio/type1: remove duplicate retrieval of reserved
 regions
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        alex.williamson@redhat.com, pmorel@linux.vnet.ibm.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linuxarm@huawei.com,
        john.garry@huawei.com, xuwei5@hisilicon.com, kevin.tian@intel.com
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
 <20190626151248.11776-7-shameerali.kolothum.thodi@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <7e4fd6c4-ac01-1378-cf8d-35ef490fe7ca@redhat.com>
Date:   Sun, 7 Jul 2019 17:03:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190626151248.11776-7-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Sun, 07 Jul 2019 15:03:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,
On 6/26/19 5:12 PM, Shameer Kolothum wrote:
> As we now already have the reserved regions list, just pass that into
> vfio_iommu_has_sw_msi() fn.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  drivers/vfio/vfio_iommu_type1.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 450081802dcd..43b1e68ebce9 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1308,15 +1308,13 @@ static struct vfio_group *find_iommu_group(struct vfio_domain *domain,
>  	return NULL;
>  }
>  
> -static bool vfio_iommu_has_sw_msi(struct iommu_group *group, phys_addr_t *base)
> +static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
> +				  phys_addr_t *base)
>  {
> -	struct list_head group_resv_regions;
> -	struct iommu_resv_region *region, *next;
> +	struct iommu_resv_region *region;
>  	bool ret = false;
>  
> -	INIT_LIST_HEAD(&group_resv_regions);
> -	iommu_get_group_resv_regions(group, &group_resv_regions);
> -	list_for_each_entry(region, &group_resv_regions, list) {
> +	list_for_each_entry(region, group_resv_regions, list) {
>  		/*
>  		 * The presence of any 'real' MSI regions should take
>  		 * precedence over the software-managed one if the
> @@ -1332,8 +1330,7 @@ static bool vfio_iommu_has_sw_msi(struct iommu_group *group, phys_addr_t *base)
>  			ret = true;
>  		}
>  	}
> -	list_for_each_entry_safe(region, next, &group_resv_regions, list)
> -		kfree(region);
> +
>  	return ret;
>  }
>  
> @@ -1774,7 +1771,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	if (ret)
>  		goto out_detach;
>  
> -	resv_msi = vfio_iommu_has_sw_msi(iommu_group, &resv_msi_base);
> +	resv_msi = vfio_iommu_has_sw_msi(&group_resv_regions, &resv_msi_base);
>  
>  	INIT_LIST_HEAD(&domain->group_list);
>  	list_add(&group->next, &domain->group_list);
> 
