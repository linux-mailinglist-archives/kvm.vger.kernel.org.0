Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F812179F6
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 23:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgGGVET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 17:04:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36320 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728933AbgGGVES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 17:04:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594155855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cKsYa862UOba1pX41B7ZWFKEGALuvSNs0tQVCwNZJ5I=;
        b=FSUcVGtt5k0o2cfzgk6IvrH2iEZ3XdgTULjPtb11SVbo1foQlhE0+68lKImyXPKtr2gvC2
        4R5+VO81dgo2U7FxtXyZelwh4lBJX3AFd2ih5G/J0rV8CnK6LNtBd461Rx8cUz77a/+4sJ
        dkYOkcTqrA1gcAgHcqHSVT1R02SF2lw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-KxuCHQmVOCCzhyceZtkVOg-1; Tue, 07 Jul 2020 17:04:12 -0400
X-MC-Unique: KxuCHQmVOCCzhyceZtkVOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4463C800C64;
        Tue,  7 Jul 2020 21:04:10 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 497281A7CD;
        Tue,  7 Jul 2020 21:04:09 +0000 (UTC)
Date:   Tue, 7 Jul 2020 15:04:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] iommu: iommu_aux_at(de)tach_device() extension
Message-ID: <20200707150408.474d81f1@x1.home>
In-Reply-To: <20200707013957.23672-2-baolu.lu@linux.intel.com>
References: <20200707013957.23672-1-baolu.lu@linux.intel.com>
        <20200707013957.23672-2-baolu.lu@linux.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jul 2020 09:39:56 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> The hardware assistant vfio mediated device is a use case of iommu
> aux-domain. The interactions between vfio/mdev and iommu during mdev
> creation and passthr are:
> 
> - Create a group for mdev with iommu_group_alloc();
> - Add the device to the group with
>         group = iommu_group_alloc();
>         if (IS_ERR(group))
>                 return PTR_ERR(group);
> 
>         ret = iommu_group_add_device(group, &mdev->dev);
>         if (!ret)
>                 dev_info(&mdev->dev, "MDEV: group_id = %d\n",
>                          iommu_group_id(group));
> - Allocate an aux-domain
>         iommu_domain_alloc()
> - Attach the aux-domain to the physical device from which the mdev is
>   created.
>         iommu_aux_attach_device()
> 
> In the whole process, an iommu group was allocated for the mdev and an
> iommu domain was attached to the group, but the group->domain leaves
> NULL. As the result, iommu_get_domain_for_dev() doesn't work anymore.
> 
> The iommu_get_domain_for_dev() is a necessary interface for device
> drivers that want to support aux-domain. For example,
> 
>         struct iommu_domain *domain;
>         struct device *dev = mdev_dev(mdev);
>         unsigned long pasid;
> 
>         domain = iommu_get_domain_for_dev(dev);
>         if (!domain)
>                 return -ENODEV;
> 
>         pasid = iommu_aux_get_pasid(domain, dev->parent);

How did we know this was an aux domain? ie. How did we know we could
use it with iommu_aux_get_pasid()?

Why did we assume the parent device is the iommu device for the aux
domain?  Should that level of detail be already known by the aux domain?

Nits - The iomu device of an mdev device is found via
mdev_get_iommu_device(dev), it should not be assumed to be the parent.
The parent of an mdev device is found via mdev_parent_dev(mdev).

The leaps in logic here make me wonder if we should instead be exposing
more of an aux domain API rather than blurring the differences between
these domains.  Thanks,

Alex

>         if (pasid == IOASID_INVALID)
>                 return -EINVAL;
> 
>          /* Program the device context with the PASID value */
>          ....
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
>  drivers/iommu/iommu.c           | 86 +++++++++++++++++++++++++++++----
>  drivers/vfio/vfio_iommu_type1.c |  5 +-
>  include/linux/iommu.h           | 12 +++--
>  3 files changed, 87 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 1ed1e14a1f0c..435835058209 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2723,26 +2723,92 @@ EXPORT_SYMBOL_GPL(iommu_dev_feature_enabled);
>   * This should make us safe against a device being attached to a guest as a
>   * whole while there are still pasid users on it (aux and sva).
>   */
> -int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev)
> +int iommu_aux_attach_device(struct iommu_domain *domain,
> +			    struct device *phys_dev, struct device *dev)
>  {
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
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iommu_aux_attach_device);
>  
> -void iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev)
> +void iommu_aux_detach_device(struct iommu_domain *domain,
> +			     struct device *phys_dev, struct device *dev)
>  {
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
>  	}
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
>  }
>  EXPORT_SYMBOL_GPL(iommu_aux_detach_device);
>  
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5e556ac9102a..d3be45dfa58e 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1635,7 +1635,8 @@ static int vfio_mdev_attach_domain(struct device *dev, void *data)
>  	iommu_device = vfio_mdev_get_iommu_device(dev);
>  	if (iommu_device) {
>  		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
> -			return iommu_aux_attach_device(domain, iommu_device);
> +			return iommu_aux_attach_device(domain,
> +						       iommu_device, dev);
>  		else
>  			return iommu_attach_device(domain, iommu_device);
>  	}
> @@ -1651,7 +1652,7 @@ static int vfio_mdev_detach_domain(struct device *dev, void *data)
>  	iommu_device = vfio_mdev_get_iommu_device(dev);
>  	if (iommu_device) {
>  		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
> -			iommu_aux_detach_device(domain, iommu_device);
> +			iommu_aux_detach_device(domain, iommu_device, dev);
>  		else
>  			iommu_detach_device(domain, iommu_device);
>  	}
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 5657d4fef9f2..7da5e67bf7dc 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -632,8 +632,10 @@ bool iommu_dev_has_feature(struct device *dev, enum iommu_dev_features f);
>  int iommu_dev_enable_feature(struct device *dev, enum iommu_dev_features f);
>  int iommu_dev_disable_feature(struct device *dev, enum iommu_dev_features f);
>  bool iommu_dev_feature_enabled(struct device *dev, enum iommu_dev_features f);
> -int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev);
> -void iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev);
> +int iommu_aux_attach_device(struct iommu_domain *domain,
> +			    struct device *phys_dev, struct device *dev);
> +void iommu_aux_detach_device(struct iommu_domain *domain,
> +			     struct device *phys_dev, struct device *dev);
>  int iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev);
>  
>  struct iommu_sva *iommu_sva_bind_device(struct device *dev,
> @@ -1007,13 +1009,15 @@ iommu_dev_disable_feature(struct device *dev, enum iommu_dev_features feat)
>  }
>  
>  static inline int
> -iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev)
> +iommu_aux_attach_device(struct iommu_domain *domain,
> +			struct device *phys_dev, struct device *dev)
>  {
>  	return -ENODEV;
>  }
>  
>  static inline void
> -iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev)
> +iommu_aux_detach_device(struct iommu_domain *domain,
> +			struct device *phys_dev, struct device *dev)
>  {
>  }
>  

