Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9692654D2
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 00:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgIJWGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 18:06:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbgIJWGE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 18:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599775561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RnbUoGq7xwlkckcej6HmOURWq1SLDS1pk1FaTeyjhKo=;
        b=D3fgLNragIKoJhgUySfTj73gQtOvd7Gu1nVjSpz/88bRbCiYJ+0PWV+ryQzMiUoQkEtnjr
        au+GyioVAN6+G5u92k3shhYuuemJ4ii3bhjWnVZ2dGlHOLlXFGC1myZoQmuxDs1eHS+SsU
        P2ZDMSHPXqJ209EB9sWgVsv5WE0Q9kw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-xtVDWkvJNJqf0IYWvWalPg-1; Thu, 10 Sep 2020 18:05:57 -0400
X-MC-Unique: xtVDWkvJNJqf0IYWvWalPg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4123C1084CA2;
        Thu, 10 Sep 2020 22:05:49 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02B537512B;
        Thu, 10 Sep 2020 22:05:47 +0000 (UTC)
Date:   Thu, 10 Sep 2020 16:05:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 2/5] iommu: Add iommu_at(de)tach_subdev_group()
Message-ID: <20200910160547.0a8b9891@w520.home>
In-Reply-To: <20200901033422.22249-3-baolu.lu@linux.intel.com>
References: <20200901033422.22249-1-baolu.lu@linux.intel.com>
        <20200901033422.22249-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  1 Sep 2020 11:34:19 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> This adds two new APIs for the use cases like vfio/mdev where subdevices
> derived from physical devices are created and put in an iommu_group. The
> new IOMMU API interfaces mimic the vfio_mdev_at(de)tach_domain() directly,
> testing whether the resulting device supports IOMMU_DEV_FEAT_AUX and using
> an aux vs non-aux at(de)tach.
> 
> By doing this we could
> 
> - Set the iommu_group.domain. The iommu_group.domain is private to iommu
>   core (therefore vfio code cannot set it), but we need it set in order
>   for iommu_get_domain_for_dev() to work with a group attached to an aux
>   domain.
> 
> - Prefer to use the _attach_group() interfaces while the _attach_device()
>   interfaces are relegated to special cases.
> 
> Link: https://lore.kernel.org/linux-iommu/20200730134658.44c57a67@x1.home/
> Link: https://lore.kernel.org/linux-iommu/20200730151703.5daf8ad4@x1.home/
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu.c | 136 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/iommu.h |  20 +++++++
>  2 files changed, 156 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 38cdfeb887e1..fb21c2ff4861 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2757,6 +2757,142 @@ int iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(iommu_aux_get_pasid);
>  
> +static int __iommu_aux_attach_device(struct iommu_domain *domain,
> +				     struct device *phys_dev,
> +				     struct device *sub_dev)
> +{
> +	int ret;
> +
> +	if (unlikely(!domain->ops->aux_attach_dev))
> +		return -ENODEV;
> +
> +	ret = domain->ops->aux_attach_dev(domain, phys_dev, sub_dev);
> +	if (!ret)
> +		trace_attach_device_to_domain(sub_dev);
> +
> +	return ret;
> +}
> +
> +static void __iommu_aux_detach_device(struct iommu_domain *domain,
> +				      struct device *phys_dev,
> +				      struct device *sub_dev)
> +{
> +	if (unlikely(!domain->ops->aux_detach_dev))
> +		return;
> +
> +	domain->ops->aux_detach_dev(domain, phys_dev, sub_dev);
> +	trace_detach_device_from_domain(sub_dev);
> +}
> +
> +static int __iommu_attach_subdev_group(struct iommu_domain *domain,
> +				       struct iommu_group *group,
> +				       iommu_device_lookup_t fn)
> +{
> +	struct group_device *device;
> +	struct device *phys_dev;
> +	int ret = -ENODEV;
> +
> +	list_for_each_entry(device, &group->devices, list) {
> +		phys_dev = fn(device->dev);
> +		if (!phys_dev) {
> +			ret = -ENODEV;
> +			break;
> +		}
> +
> +		if (iommu_dev_feature_enabled(phys_dev, IOMMU_DEV_FEAT_AUX))
> +			ret = __iommu_aux_attach_device(domain, phys_dev,
> +							device->dev);
> +		else
> +			ret = __iommu_attach_device(domain, phys_dev);
> +
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +static void __iommu_detach_subdev_group(struct iommu_domain *domain,
> +					struct iommu_group *group,
> +					iommu_device_lookup_t fn)
> +{
> +	struct group_device *device;
> +	struct device *phys_dev;
> +
> +	list_for_each_entry(device, &group->devices, list) {
> +		phys_dev = fn(device->dev);
> +		if (!phys_dev)
> +			break;


Seems like this should be a continue rather than a break.  On the
unwind path maybe we're relying on holding the group mutex and
deterministic behavior from the fn() callback to unwind to the same
point, but we still have an entirely separate detach interface and I'm
not sure we couldn't end up with an inconsistent state if we don't
iterate each group device here.  Thanks,

Alex

> +
> +		if (iommu_dev_feature_enabled(phys_dev, IOMMU_DEV_FEAT_AUX))
> +			__iommu_aux_detach_device(domain, phys_dev, device->dev);
> +		else
> +			__iommu_detach_device(domain, phys_dev);
> +	}
> +}
> +
> +/**
> + * iommu_attach_subdev_group - attach domain to an iommu_group which
> + *			       contains subdevices.
> + *
> + * @domain: domain
> + * @group:  iommu_group which contains subdevices
> + * @fn:     callback for each subdevice in the @iommu_group to retrieve the
> + *          physical device where the subdevice was created from.
> + *
> + * Returns 0 on success, or an error value.
> + */
> +int iommu_attach_subdev_group(struct iommu_domain *domain,
> +			      struct iommu_group *group,
> +			      iommu_device_lookup_t fn)
> +{
> +	int ret = -ENODEV;
> +
> +	mutex_lock(&group->mutex);
> +	if (group->domain) {
> +		ret = -EBUSY;
> +		goto unlock_out;
> +	}
> +
> +	ret = __iommu_attach_subdev_group(domain, group, fn);
> +	if (ret)
> +		__iommu_detach_subdev_group(domain, group, fn);
> +	else
> +		group->domain = domain;
> +
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_attach_subdev_group);
> +
> +/**
> + * iommu_detach_subdev_group - detach domain from an iommu_group which
> + *			       contains subdevices
> + *
> + * @domain: domain
> + * @group:  iommu_group which contains subdevices
> + * @fn:     callback for each subdevice in the @iommu_group to retrieve the
> + *          physical device where the subdevice was created from.
> + *
> + * The domain must have been attached to @group via iommu_attach_subdev_group().
> + */
> +void iommu_detach_subdev_group(struct iommu_domain *domain,
> +			       struct iommu_group *group,
> +			       iommu_device_lookup_t fn)
> +{
> +	mutex_lock(&group->mutex);
> +	if (!group->domain)
> +		goto unlock_out;
> +
> +	__iommu_detach_subdev_group(domain, group, fn);
> +	group->domain = NULL;
> +
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +}
> +EXPORT_SYMBOL_GPL(iommu_detach_subdev_group);
> +
>  /**
>   * iommu_sva_bind_device() - Bind a process address space to a device
>   * @dev: the device
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 871267104915..b9df8b510d4f 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -48,6 +48,7 @@ struct iommu_fault_event;
>  typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
>  			struct device *, unsigned long, int, void *);
>  typedef int (*iommu_dev_fault_handler_t)(struct iommu_fault *, void *);
> +typedef struct device *(*iommu_device_lookup_t)(struct device *);
>  
>  struct iommu_domain_geometry {
>  	dma_addr_t aperture_start; /* First address that can be mapped    */
> @@ -631,6 +632,12 @@ bool iommu_dev_feature_enabled(struct device *dev, enum iommu_dev_features f);
>  int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev);
>  void iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev);
>  int iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev);
> +int iommu_attach_subdev_group(struct iommu_domain *domain,
> +			      struct iommu_group *group,
> +			      iommu_device_lookup_t fn);
> +void iommu_detach_subdev_group(struct iommu_domain *domain,
> +			       struct iommu_group *group,
> +			       iommu_device_lookup_t fn);
>  
>  struct iommu_sva *iommu_sva_bind_device(struct device *dev,
>  					struct mm_struct *mm,
> @@ -1019,6 +1026,19 @@ iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
>  	return -ENODEV;
>  }
>  
> +static inline int
> +iommu_attach_subdev_group(struct iommu_domain *domain, struct iommu_group *group,
> +			  iommu_device_lookup_t fn)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline void
> +iommu_detach_subdev_group(struct iommu_domain *domain, struct iommu_group *group,
> +			  iommu_device_lookup_t fn)
> +{
> +}
> +
>  static inline struct iommu_sva *
>  iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void *drvdata)
>  {

