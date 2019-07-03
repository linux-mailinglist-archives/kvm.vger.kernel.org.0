Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6217E5EDA7
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 22:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfGCUem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 16:34:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfGCUek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 16:34:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 918BC3091851;
        Wed,  3 Jul 2019 20:34:30 +0000 (UTC)
Received: from x1.home (ovpn-116-83.phx2.redhat.com [10.3.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E772E17F33;
        Wed,  3 Jul 2019 20:34:27 +0000 (UTC)
Date:   Wed, 3 Jul 2019 14:34:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <eric.auger@redhat.com>, <pmorel@linux.vnet.ibm.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, <xuwei5@hisilicon.com>,
        <kevin.tian@intel.com>
Subject: Re: [PATCH v7 2/6] vfio/type1: Check reserve region conflict and
 update iova list
Message-ID: <20190703143427.2d63c15f@x1.home>
In-Reply-To: <20190626151248.11776-3-shameerali.kolothum.thodi@huawei.com>
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
        <20190626151248.11776-3-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 03 Jul 2019 20:34:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Jun 2019 16:12:44 +0100
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> This retrieves the reserved regions associated with dev group and
> checks for conflicts with any existing dma mappings. Also update
> the iova list excluding the reserved regions.
> 
> Reserved regions with type IOMMU_RESV_DIRECT_RELAXABLE are
> excluded from above checks as they are considered as directly
> mapped regions which are known to be relaxable.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 96 +++++++++++++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 970d1ec06aed..b6bfdfa16c33 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1559,6 +1641,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	phys_addr_t resv_msi_base;
>  	struct iommu_domain_geometry geo;
>  	LIST_HEAD(iova_copy);
> +	LIST_HEAD(group_resv_regions);
>  
>  	mutex_lock(&iommu->lock);
>  
> @@ -1644,6 +1727,13 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		goto out_detach;
>  	}
>  
> +	iommu_get_group_resv_regions(iommu_group, &group_resv_regions);

This can fail and should have an error case.  I assume we'd fail the
group attach on failure.  Thanks,

Alex
