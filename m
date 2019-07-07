Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBAF561558
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2019 17:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfGGPDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 11:03:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfGGPDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 11:03:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B36A9308339B;
        Sun,  7 Jul 2019 15:03:35 +0000 (UTC)
Received: from [10.36.116.46] (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2462019C79;
        Sun,  7 Jul 2019 15:03:29 +0000 (UTC)
Subject: Re: [PATCH v7 4/6] vfio/type1: check dma map request is within a
 valid iova range
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        alex.williamson@redhat.com, pmorel@linux.vnet.ibm.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linuxarm@huawei.com,
        john.garry@huawei.com, xuwei5@hisilicon.com, kevin.tian@intel.com
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
 <20190626151248.11776-5-shameerali.kolothum.thodi@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d44d9c7a-9333-616e-21fd-999bfa7aafe4@redhat.com>
Date:   Sun, 7 Jul 2019 17:03:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190626151248.11776-5-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Sun, 07 Jul 2019 15:03:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 6/26/19 5:12 PM, Shameer Kolothum wrote:
> This checks and rejects any dma map request outside valid iova
> range.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
> v6 --> v7
> 
> Addressed the case where a container with only an mdev device will
> have an empty list(Suggested by Alex).
> ---
>  drivers/vfio/vfio_iommu_type1.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index e872fb3a0f39..89ad0da7152c 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1050,6 +1050,27 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  	return ret;
>  }
>  
> +/*
> + * Check dma map request is within a valid iova range
> + */
> +static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
> +				      dma_addr_t start, dma_addr_t end)
> +{
> +	struct list_head *iova = &iommu->iova_list;
> +	struct vfio_iova *node;
> +
> +	list_for_each_entry(node, iova, list) {
> +		if (start >= node->start && end <= node->end)
> +			return true;
> +	}
> +
> +	/*
> +	 * Check for list_empty() as well since a container with
> +	 * only an mdev device will have an empty list.
> +	 */
> +	return list_empty(&iommu->iova_list);
iova

Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric


> +}
> +
>  static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  			   struct vfio_iommu_type1_dma_map *map)
>  {
> @@ -1093,6 +1114,11 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  		goto out_unlock;
>  	}
>  
> +	if (!vfio_iommu_iova_dma_valid(iommu, iova, iova + size - 1)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
>  	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
>  	if (!dma) {
>  		ret = -ENOMEM;
> 
