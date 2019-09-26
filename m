Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D785BEAAD
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 04:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391563AbfIZChS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 22:37:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391553AbfIZChR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 22:37:17 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BFE9D3082A49;
        Thu, 26 Sep 2019 02:37:17 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0347419D7A;
        Thu, 26 Sep 2019 02:37:16 +0000 (UTC)
Date:   Wed, 25 Sep 2019 20:37:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, yi.y.sun@intel.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yan.y.zhao@intel.com, shaopeng.he@intel.com, chenbo.xia@intel.com,
        jun.j.tian@intel.com
Subject: Re: [PATCH v2 12/13] vfio/type1: use iommu_attach_group() for
 wrapping PF/VF as mdev
Message-ID: <20190925203716.3f4630a2@x1.home>
In-Reply-To: <1567670370-4484-13-git-send-email-yi.l.liu@intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
        <1567670370-4484-13-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 26 Sep 2019 02:37:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 Sep 2019 15:59:29 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch uses iommu_attach_group() to do group attach when it is
> for the case of wrapping a PF/VF as a mdev. iommu_attach_device()
> doesn't support non-singleton iommu group attach. With this change,
> wrapping PF/VF as mdev can work on non-singleton iommu groups.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 054391f..317430d 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1312,13 +1312,20 @@ static int vfio_mdev_attach_domain(struct device *dev, void *data)
>  {
>  	struct iommu_domain *domain = data;
>  	struct device *iommu_device;
> +	struct iommu_group *group;
>  
>  	iommu_device = vfio_mdev_get_iommu_device(dev);
>  	if (iommu_device) {
>  		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
>  			return iommu_aux_attach_device(domain, iommu_device);
> -		else
> -			return iommu_attach_device(domain, iommu_device);
> +		else {
> +			group = iommu_group_get(iommu_device);
> +			if (!group) {
> +				WARN_ON(1);

What's the value of the WARN_ON here and below?

iommu_group_get() increments the kobject reference, looks like it's
leaked.  Thanks,

Alex

> +				return -EINVAL;
> +			}
> +			return iommu_attach_group(domain, group);
> +		}
>  	}
>  
>  	return -EINVAL;
> @@ -1328,13 +1335,20 @@ static int vfio_mdev_detach_domain(struct device *dev, void *data)
>  {
>  	struct iommu_domain *domain = data;
>  	struct device *iommu_device;
> +	struct iommu_group *group;
>  
>  	iommu_device = vfio_mdev_get_iommu_device(dev);
>  	if (iommu_device) {
>  		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
>  			iommu_aux_detach_device(domain, iommu_device);
> -		else
> -			iommu_detach_device(domain, iommu_device);
> +		else {
> +			group = iommu_group_get(iommu_device);
> +			if (!group) {
> +				WARN_ON(1);
> +				return -EINVAL;
> +			}
> +			iommu_detach_group(domain, group);
> +		}
>  	}
>  
>  	return 0;

