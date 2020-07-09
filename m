Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764402198E8
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 08:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgGIGxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 02:53:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:23716 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgGIGw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 02:52:57 -0400
IronPort-SDR: cXpnQQuiwSljON5zbjLofKyll1BE2kQl3yhAQ9JiMIu6x07D2NQVFUHcYfanrQ3PRarqpPYEUK
 KK4jOttWgYYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="147941554"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="147941554"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 23:52:48 -0700
IronPort-SDR: DQx8SsSANSNSyEiyLe5IMsuP+TDx7d+iTxwqPOIOKZvClH8We/a8xuwx3zl+ajjzt5s+FlPszM
 Zzc4/sso1dSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="484166202"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.255.31.114]) ([10.255.31.114])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jul 2020 23:52:45 -0700
Cc:     baolu.lu@linux.intel.com, Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] iommu: iommu_aux_at(de)tach_device() extension
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <20200707013957.23672-1-baolu.lu@linux.intel.com>
 <20200707013957.23672-2-baolu.lu@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <508d92a1-a13a-2082-53c0-ea23094533c1@linux.intel.com>
Date:   Thu, 9 Jul 2020 14:52:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707013957.23672-2-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/7/7 9:39, Lu Baolu wrote:
> The hardware assistant vfio mediated device is a use case of iommu
> aux-domain. The interactions between vfio/mdev and iommu during mdev
> creation and passthr are:
> 
> - Create a group for mdev with iommu_group_alloc();
> - Add the device to the group with
>          group = iommu_group_alloc();
>          if (IS_ERR(group))
>                  return PTR_ERR(group);
> 
>          ret = iommu_group_add_device(group, &mdev->dev);
>          if (!ret)
>                  dev_info(&mdev->dev, "MDEV: group_id = %d\n",
>                           iommu_group_id(group));
> - Allocate an aux-domain
>          iommu_domain_alloc()
> - Attach the aux-domain to the physical device from which the mdev is
>    created.
>          iommu_aux_attach_device()
> 
> In the whole process, an iommu group was allocated for the mdev and an
> iommu domain was attached to the group, but the group->domain leaves
> NULL. As the result, iommu_get_domain_for_dev() doesn't work anymore.
> 
> The iommu_get_domain_for_dev() is a necessary interface for device
> drivers that want to support aux-domain. For example,
> 
>          struct iommu_domain *domain;
>          struct device *dev = mdev_dev(mdev);
>          unsigned long pasid;
> 
>          domain = iommu_get_domain_for_dev(dev);
>          if (!domain)
>                  return -ENODEV;
> 
>          pasid = iommu_aux_get_pasid(domain, dev->parent);
>          if (pasid == IOASID_INVALID)
>                  return -EINVAL;
> 
>           /* Program the device context with the PASID value */
>           ....
> 
> This extends iommu_aux_at(de)tach_device() so that the users could pass
> in an optional device pointer (struct device for vfio/mdev for example),
> and the necessary check and data link could be done.
> 
> Fixes: a3a195929d40b ("iommu: Add APIs for multiple domains per device")
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>   drivers/iommu/iommu.c           | 86 +++++++++++++++++++++++++++++----
>   drivers/vfio/vfio_iommu_type1.c |  5 +-
>   include/linux/iommu.h           | 12 +++--
>   3 files changed, 87 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 1ed1e14a1f0c..435835058209 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2723,26 +2723,92 @@ EXPORT_SYMBOL_GPL(iommu_dev_feature_enabled);
>    * This should make us safe against a device being attached to a guest as a
>    * whole while there are still pasid users on it (aux and sva).
>    */
> -int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev)
> +int iommu_aux_attach_device(struct iommu_domain *domain,
> +			    struct device *phys_dev, struct device *dev)

I hit a lock issue during internal test. Will fix it in the next
version.

Best regards,
baolu

>   {
> -	int ret = -ENODEV;
> +	struct iommu_group *group;
> +	int ret;
>   
> -	if (domain->ops->aux_attach_dev)
> -		ret = domain->ops->aux_attach_dev(domain, dev);
> +	if (!domain->ops->aux_attach_dev ||
> +	    !iommu_dev_feature_enabled(phys_dev, IOMMU_DEV_FEAT_AUX))
> +		return -ENODEV;
>   
> -	if (!ret)
> -		trace_attach_device_to_domain(dev);
> +	/* Bare use only. */
> +	if (!dev) {
> +		ret = domain->ops->aux_attach_dev(domain, phys_dev);
> +		if (!ret)
> +			trace_attach_device_to_domain(phys_dev);
> +
> +		return ret;
> +	}
> +
> +	/*
> +	 * The caller has created a made-up device (for example, vfio/mdev)
> +	 * and allocated an iommu_group for user level direct assignment.
> +	 * Make sure that the group has only single device and hasn't been
> +	 * attached by any other domain.
> +	 */
> +	group = iommu_group_get(dev);
> +	if (!group)
> +		return -ENODEV;
> +
> +	/*
> +	 * Lock the group to make sure the device-count doesn't change while
> +	 * we are attaching.
> +	 */
> +	mutex_lock(&group->mutex);
> +	ret = -EINVAL;
> +	if ((iommu_group_device_count(group) != 1) || group->domain)
> +		goto out_unlock;
> +
> +	ret = -EBUSY;
> +	if (group->default_domain && group->domain != group->default_domain)
> +		goto out_unlock;
> +
> +	ret = domain->ops->aux_attach_dev(domain, phys_dev);
> +	if (!ret) {
> +		trace_attach_device_to_domain(phys_dev);
> +		group->domain = domain;
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&group->mutex);
> +	iommu_group_put(group);
>   
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(iommu_aux_attach_device);
>   
> -void iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev)
> +void iommu_aux_detach_device(struct iommu_domain *domain,
> +			     struct device *phys_dev, struct device *dev)
>   {
> -	if (domain->ops->aux_detach_dev) {
> -		domain->ops->aux_detach_dev(domain, dev);
> -		trace_detach_device_from_domain(dev);
> +	struct iommu_group *group;
> +
> +	if (WARN_ON_ONCE(!domain->ops->aux_detach_dev))
> +		return;
> +
> +	if (!dev) {
> +		domain->ops->aux_detach_dev(domain, phys_dev);
> +		trace_detach_device_from_domain(phys_dev);
> +
> +		return;
>   	}
> +
> +	group = iommu_group_get(dev);
> +	if (!group)
> +		return;
> +
> +	mutex_lock(&group->mutex);
> +	if (WARN_ON(iommu_group_device_count(group) != 1))
> +		goto out_unlock;
> +
> +	domain->ops->aux_detach_dev(domain, phys_dev);
> +	group->domain = NULL;
> +	trace_detach_device_from_domain(phys_dev);
> +
> +out_unlock:
> +	mutex_unlock(&group->mutex);
> +	iommu_group_put(group);
>   }
>   EXPORT_SYMBOL_GPL(iommu_aux_detach_device);
>   
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5e556ac9102a..d3be45dfa58e 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1635,7 +1635,8 @@ static int vfio_mdev_attach_domain(struct device *dev, void *data)
>   	iommu_device = vfio_mdev_get_iommu_device(dev);
>   	if (iommu_device) {
>   		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
> -			return iommu_aux_attach_device(domain, iommu_device);
> +			return iommu_aux_attach_device(domain,
> +						       iommu_device, dev);
>   		else
>   			return iommu_attach_device(domain, iommu_device);
>   	}
> @@ -1651,7 +1652,7 @@ static int vfio_mdev_detach_domain(struct device *dev, void *data)
>   	iommu_device = vfio_mdev_get_iommu_device(dev);
>   	if (iommu_device) {
>   		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
> -			iommu_aux_detach_device(domain, iommu_device);
> +			iommu_aux_detach_device(domain, iommu_device, dev);
>   		else
>   			iommu_detach_device(domain, iommu_device);
>   	}
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 5657d4fef9f2..7da5e67bf7dc 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -632,8 +632,10 @@ bool iommu_dev_has_feature(struct device *dev, enum iommu_dev_features f);
>   int iommu_dev_enable_feature(struct device *dev, enum iommu_dev_features f);
>   int iommu_dev_disable_feature(struct device *dev, enum iommu_dev_features f);
>   bool iommu_dev_feature_enabled(struct device *dev, enum iommu_dev_features f);
> -int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev);
> -void iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev);
> +int iommu_aux_attach_device(struct iommu_domain *domain,
> +			    struct device *phys_dev, struct device *dev);
> +void iommu_aux_detach_device(struct iommu_domain *domain,
> +			     struct device *phys_dev, struct device *dev);
>   int iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev);
>   
>   struct iommu_sva *iommu_sva_bind_device(struct device *dev,
> @@ -1007,13 +1009,15 @@ iommu_dev_disable_feature(struct device *dev, enum iommu_dev_features feat)
>   }
>   
>   static inline int
> -iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev)
> +iommu_aux_attach_device(struct iommu_domain *domain,
> +			struct device *phys_dev, struct device *dev)
>   {
>   	return -ENODEV;
>   }
>   
>   static inline void
> -iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev)
> +iommu_aux_detach_device(struct iommu_domain *domain,
> +			struct device *phys_dev, struct device *dev)
>   {
>   }
>   
> 
