Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B36047C432
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 17:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240017AbhLUQvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 11:51:09 -0500
Received: from foss.arm.com ([217.140.110.172]:56020 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236530AbhLUQvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 11:51:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3ABFED1;
        Tue, 21 Dec 2021 08:51:07 -0800 (PST)
Received: from [10.57.34.58] (unknown [10.57.34.58])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 442DA3F718;
        Tue, 21 Dec 2021 08:51:01 -0800 (PST)
Message-ID: <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
Date:   Tue, 21 Dec 2021 16:50:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 07/13] iommu: Add iommu_at[de]tach_device_shared() for
 multi-device groups
Content-Language: en-GB
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20211217063708.1740334-8-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-12-17 06:37, Lu Baolu wrote:
> The iommu_attach/detach_device() interfaces were exposed for the device
> drivers to attach/detach their own domains. The commit <426a273834eae>
> ("iommu: Limit iommu_attach/detach_device to device with their own group")
> restricted them to singleton groups to avoid different device in a group
> attaching different domain.
> 
> As we've introduced device DMA ownership into the iommu core. We can now
> introduce interfaces for muliple-device groups, and "all devices are in the
> same address space" is still guaranteed.
> 
> The iommu_attach/detach_device_shared() could be used when multiple drivers
> sharing the group claim the DMA_OWNER_PRIVATE_DOMAIN ownership. The first
> call of iommu_attach_device_shared() attaches the domain to the group.
> Other drivers could join it later. The domain will be detached from the
> group after all drivers unjoin it.

I don't see the point of this at all - if you really want to hide the 
concept of IOMMU groups away from drivers then just make 
iommu_{attach,detach}_device() do the right thing. At least the 
iommu_group_get_for_dev() plus iommu_{attach,detach}_group() API is 
clear - this proposal is the worst of both worlds, in that drivers still 
have to be just as aware of groups in order to know whether to call the 
_shared interface or not, except it's now entirely implicit and non-obvious.

Otherwise just add the housekeeping stuff to 
iommu_{attach,detach}_group() - there's no way we want *three* 
attach/detach interfaces all with different semantics.

It's worth taking a step back and realising that overall, this is really 
just a more generalised and finer-grained extension of what 426a273834ea 
already did for non-group-aware code, so it makes little sense *not* to 
integrate it into the existing interfaces.

Robin.

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Tested-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>   include/linux/iommu.h | 13 +++++++
>   drivers/iommu/iommu.c | 79 +++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 92 insertions(+)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 5ad4cf13370d..1bc03118dfb3 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -703,6 +703,8 @@ int iommu_group_set_dma_owner(struct iommu_group *group, enum iommu_dma_owner ow
>   			      void *owner_cookie);
>   void iommu_group_release_dma_owner(struct iommu_group *group, enum iommu_dma_owner owner);
>   bool iommu_group_dma_owner_unclaimed(struct iommu_group *group);
> +int iommu_attach_device_shared(struct iommu_domain *domain, struct device *dev);
> +void iommu_detach_device_shared(struct iommu_domain *domain, struct device *dev);
>   
>   #else /* CONFIG_IOMMU_API */
>   
> @@ -743,11 +745,22 @@ static inline int iommu_attach_device(struct iommu_domain *domain,
>   	return -ENODEV;
>   }
>   
> +static inline int iommu_attach_device_shared(struct iommu_domain *domain,
> +					     struct device *dev)
> +{
> +	return -ENODEV;
> +}
> +
>   static inline void iommu_detach_device(struct iommu_domain *domain,
>   				       struct device *dev)
>   {
>   }
>   
> +static inline void iommu_detach_device_shared(struct iommu_domain *domain,
> +					      struct device *dev)
> +{
> +}
> +
>   static inline struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
>   {
>   	return NULL;
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 8bec71b1cc18..3ad66cb9bedc 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -50,6 +50,7 @@ struct iommu_group {
>   	struct list_head entry;
>   	enum iommu_dma_owner dma_owner;
>   	unsigned int owner_cnt;
> +	unsigned int attach_cnt;
>   	void *owner_cookie;
>   };
>   
> @@ -3512,3 +3513,81 @@ void iommu_device_release_dma_owner(struct device *dev, enum iommu_dma_owner own
>   	iommu_group_put(group);
>   }
>   EXPORT_SYMBOL_GPL(iommu_device_release_dma_owner);
> +
> +/**
> + * iommu_attach_device_shared() - Attach shared domain to a device
> + * @domain: The shared domain.
> + * @dev: The device.
> + *
> + * Similar to iommu_attach_device(), but allowed for shared-group devices
> + * and guarantees that all devices in an iommu group could only be attached
> + * by a same iommu domain. The caller should explicitly set the dma ownership
> + * of DMA_OWNER_PRIVATE_DOMAIN or DMA_OWNER_PRIVATE_DOMAIN_USER type before
> + * calling it and use the paired helper iommu_detach_device_shared() for
> + * cleanup.
> + */
> +int iommu_attach_device_shared(struct iommu_domain *domain, struct device *dev)
> +{
> +	struct iommu_group *group;
> +	int ret = 0;
> +
> +	group = iommu_group_get(dev);
> +	if (!group)
> +		return -ENODEV;
> +
> +	mutex_lock(&group->mutex);
> +	if (group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN &&
> +	    group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN_USER) {
> +		ret = -EPERM;
> +		goto unlock_out;
> +	}
> +
> +	if (group->attach_cnt) {
> +		if (group->domain != domain) {
> +			ret = -EBUSY;
> +			goto unlock_out;
> +		}
> +	} else {
> +		ret = __iommu_attach_group(domain, group);
> +		if (ret)
> +			goto unlock_out;
> +	}
> +
> +	group->attach_cnt++;
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +	iommu_group_put(group);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_attach_device_shared);
> +
> +/**
> + * iommu_detach_device_shared() - Detach a domain from device
> + * @domain: The domain.
> + * @dev: The device.
> + *
> + * The detach helper paired with iommu_attach_device_shared().
> + */
> +void iommu_detach_device_shared(struct iommu_domain *domain, struct device *dev)
> +{
> +	struct iommu_group *group;
> +
> +	group = iommu_group_get(dev);
> +	if (!group)
> +		return;
> +
> +	mutex_lock(&group->mutex);
> +	if (WARN_ON(!group->attach_cnt || group->domain != domain ||
> +		    (group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN &&
> +		     group->dma_owner != DMA_OWNER_PRIVATE_DOMAIN_USER)))
> +		goto unlock_out;
> +
> +	if (--group->attach_cnt == 0)
> +		__iommu_detach_group(domain, group);
> +
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +	iommu_group_put(group);
> +}
> +EXPORT_SYMBOL_GPL(iommu_detach_device_shared);
