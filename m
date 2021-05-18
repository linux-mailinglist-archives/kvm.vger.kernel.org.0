Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276BC388029
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 20:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351756AbhERTA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:00:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351722AbhERTAW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 15:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621364344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F39UpyUhj6TqM2emKcBOtwE8fh18IvXzJ+eZ2ac+ukY=;
        b=JyATTGtFLK40BDxQSh7pcdFBH1lolmNgJcZpfNWBTvd7Il7nrOeRpMT6DO83b8ajev4Mmg
        MBDgZ0hhZsdaaMdpWL4AhA357G9szboVxS8LI715UHVh9Vo2NFg9cGCw81nOd1ycNGk3Ns
        uTAnsNxLFItX8IHvMFSEzDQTi+fyoI4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-OTvTmDC-N2e0-bmwLs8OUA-1; Tue, 18 May 2021 14:59:00 -0400
X-MC-Unique: OTvTmDC-N2e0-bmwLs8OUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2BA98042AA;
        Tue, 18 May 2021 18:58:57 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A4261037E81;
        Tue, 18 May 2021 18:58:57 +0000 (UTC)
Date:   Tue, 18 May 2021 12:58:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH v3 8/8] vfio: Add nested IOPF support
Message-ID: <20210518125808.345b812c.alex.williamson@redhat.com>
In-Reply-To: <20210409034420.1799-9-lushenming@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
        <20210409034420.1799-9-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Apr 2021 11:44:20 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> To set up nested mode, drivers such as vfio_pci need to register a
> handler to receive stage/level 1 faults from the IOMMU, but since
> currently each device can only have one iommu dev fault handler,
> and if stage 2 IOPF is already enabled (VFIO_IOMMU_ENABLE_IOPF),
> we choose to update the registered handler (a consolidated one) via
> flags (set FAULT_REPORT_NESTED_L1), and further deliver the received
> stage 1 faults in the handler to the guest through a newly added
> vfio_device_ops callback.

Are there proposed in-kernel drivers that would use any of these
symbols?

> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  drivers/vfio/vfio.c             | 81 +++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c | 49 +++++++++++++++++++-
>  include/linux/vfio.h            | 12 +++++
>  3 files changed, 141 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 44c8dfabf7de..4245f15914bf 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -2356,6 +2356,87 @@ struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group)
>  }
>  EXPORT_SYMBOL_GPL(vfio_group_iommu_domain);
>  
> +/*
> + * Register/Update the VFIO IOPF handler to receive
> + * nested stage/level 1 faults.
> + */
> +int vfio_iommu_dev_fault_handler_register_nested(struct device *dev)
> +{
> +	struct vfio_container *container;
> +	struct vfio_group *group;
> +	struct vfio_iommu_driver *driver;
> +	int ret;
> +
> +	if (!dev)
> +		return -EINVAL;
> +
> +	group = vfio_group_get_from_dev(dev);
> +	if (!group)
> +		return -ENODEV;
> +
> +	ret = vfio_group_add_container_user(group);
> +	if (ret)
> +		goto out;
> +
> +	container = group->container;
> +	driver = container->iommu_driver;
> +	if (likely(driver && driver->ops->register_handler))
> +		ret = driver->ops->register_handler(container->iommu_data, dev);
> +	else
> +		ret = -ENOTTY;
> +
> +	vfio_group_try_dissolve_container(group);
> +
> +out:
> +	vfio_group_put(group);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommu_dev_fault_handler_register_nested);
> +
> +int vfio_iommu_dev_fault_handler_unregister_nested(struct device *dev)
> +{
> +	struct vfio_container *container;
> +	struct vfio_group *group;
> +	struct vfio_iommu_driver *driver;
> +	int ret;
> +
> +	if (!dev)
> +		return -EINVAL;
> +
> +	group = vfio_group_get_from_dev(dev);
> +	if (!group)
> +		return -ENODEV;
> +
> +	ret = vfio_group_add_container_user(group);
> +	if (ret)
> +		goto out;
> +
> +	container = group->container;
> +	driver = container->iommu_driver;
> +	if (likely(driver && driver->ops->unregister_handler))
> +		ret = driver->ops->unregister_handler(container->iommu_data, dev);
> +	else
> +		ret = -ENOTTY;
> +
> +	vfio_group_try_dissolve_container(group);
> +
> +out:
> +	vfio_group_put(group);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommu_dev_fault_handler_unregister_nested);
> +
> +int vfio_transfer_iommu_fault(struct device *dev, struct iommu_fault *fault)
> +{
> +	struct vfio_device *device = dev_get_drvdata(dev);
> +
> +	if (unlikely(!device->ops->transfer))
> +		return -EOPNOTSUPP;
> +
> +	return device->ops->transfer(device->device_data, fault);
> +}
> +EXPORT_SYMBOL_GPL(vfio_transfer_iommu_fault);
> +
>  /**
>   * Module/class support
>   */
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ba2b5a1cf6e9..9d1adeddb303 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -3821,13 +3821,32 @@ static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
>  	struct vfio_batch batch;
>  	struct vfio_range *range;
>  	dma_addr_t iova = ALIGN_DOWN(fault->prm.addr, PAGE_SIZE);
> -	int access_flags = 0;
> +	int access_flags = 0, nested;
>  	size_t premap_len, map_len, mapped_len = 0;
>  	unsigned long bit_offset, vaddr, pfn, i, npages;
>  	int ret;
>  	enum iommu_page_response_code status = IOMMU_PAGE_RESP_INVALID;
>  	struct iommu_page_response resp = {0};
>  
> +	if (vfio_dev_domian_nested(dev, &nested))
> +		return -ENODEV;
> +
> +	/*
> +	 * When configured in nested mode, further deliver the
> +	 * stage/level 1 faults to the guest.
> +	 */
> +	if (nested) {
> +		bool l2;
> +
> +		if (fault->type == IOMMU_FAULT_PAGE_REQ)
> +			l2 = fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_L2;
> +		if (fault->type == IOMMU_FAULT_DMA_UNRECOV)
> +			l2 = fault->event.flags & IOMMU_FAULT_UNRECOV_L2;
> +
> +		if (!l2)
> +			return vfio_transfer_iommu_fault(dev, fault);
> +	}
> +
>  	if (fault->type != IOMMU_FAULT_PAGE_REQ)
>  		return -EOPNOTSUPP;
>  
> @@ -4201,6 +4220,32 @@ static void vfio_iommu_type1_notify(void *iommu_data,
>  	wake_up_all(&iommu->vaddr_wait);
>  }
>  
> +static int vfio_iommu_type1_register_handler(void *iommu_data,
> +					     struct device *dev)
> +{
> +	struct vfio_iommu *iommu = iommu_data;
> +
> +	if (iommu->iopf_enabled)
> +		return iommu_update_device_fault_handler(dev, ~0,
> +						FAULT_REPORT_NESTED_L1);
> +	else
> +		return iommu_register_device_fault_handler(dev,
> +						vfio_iommu_type1_dma_map_iopf,
> +						FAULT_REPORT_NESTED_L1, dev);
> +}
> +
> +static int vfio_iommu_type1_unregister_handler(void *iommu_data,
> +					       struct device *dev)
> +{
> +	struct vfio_iommu *iommu = iommu_data;
> +
> +	if (iommu->iopf_enabled)
> +		return iommu_update_device_fault_handler(dev,
> +						~FAULT_REPORT_NESTED_L1, 0);
> +	else
> +		return iommu_unregister_device_fault_handler(dev);
> +}


The path through vfio to register this is pretty ugly, but I don't see
any reason for the the update interfaces here, the previously
registered handler just changes its behavior.


> +
>  static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
>  	.name			= "vfio-iommu-type1",
>  	.owner			= THIS_MODULE,
> @@ -4216,6 +4261,8 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
>  	.dma_rw			= vfio_iommu_type1_dma_rw,
>  	.group_iommu_domain	= vfio_iommu_type1_group_iommu_domain,
>  	.notify			= vfio_iommu_type1_notify,
> +	.register_handler	= vfio_iommu_type1_register_handler,
> +	.unregister_handler	= vfio_iommu_type1_unregister_handler,
>  };
>  
>  static int __init vfio_iommu_type1_init(void)
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index a7b426d579df..4621d8f0395d 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -29,6 +29,8 @@
>   * @match: Optional device name match callback (return: 0 for no-match, >0 for
>   *         match, -errno for abort (ex. match with insufficient or incorrect
>   *         additional args)
> + * @transfer: Optional. Transfer the received stage/level 1 faults to the guest
> + *            for nested mode.
>   */
>  struct vfio_device_ops {
>  	char	*name;
> @@ -43,6 +45,7 @@ struct vfio_device_ops {
>  	int	(*mmap)(void *device_data, struct vm_area_struct *vma);
>  	void	(*request)(void *device_data, unsigned int count);
>  	int	(*match)(void *device_data, char *buf);
> +	int	(*transfer)(void *device_data, struct iommu_fault *fault);
>  };
>  
>  extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
> @@ -100,6 +103,10 @@ struct vfio_iommu_driver_ops {
>  						   struct iommu_group *group);
>  	void		(*notify)(void *iommu_data,
>  				  enum vfio_iommu_notify_type event);
> +	int		(*register_handler)(void *iommu_data,
> +					    struct device *dev);
> +	int		(*unregister_handler)(void *iommu_data,
> +					      struct device *dev);
>  };
>  
>  extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
> @@ -161,6 +168,11 @@ extern int vfio_unregister_notifier(struct device *dev,
>  struct kvm;
>  extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
>  
> +extern int vfio_iommu_dev_fault_handler_register_nested(struct device *dev);
> +extern int vfio_iommu_dev_fault_handler_unregister_nested(struct device *dev);
> +extern int vfio_transfer_iommu_fault(struct device *dev,
> +				     struct iommu_fault *fault);
> +
>  /*
>   * Sub-module helpers
>   */

