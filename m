Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8312F18AB40
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 04:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgCSDpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 23:45:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:20551 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726847AbgCSDpb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 23:45:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584589529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBu2gTYsV/OxbOApp+diN/WQ5jcPJ9oT2fm0EfkE6m4=;
        b=b6n7Xw+JeiHrqtXQ526Xd1cWQ2Nq4rvC5GCFYYqHCmaD/0LEni4KkoQHrFy1JLzbGmKiBm
        ZWY9lCc7gYoiBKirgG3tXotOwbl8JZ+o/J8EGGG45kPKBIMB/hGnmSYOQ8deg47ezVpQhs
        GWgs3p3VCXFCyNxg8reMyZYXPJTwvKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-rHt6uWn_OHGe6obUfuDVbA-1; Wed, 18 Mar 2020 23:45:27 -0400
X-MC-Unique: rHt6uWn_OHGe6obUfuDVbA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00632100550D;
        Thu, 19 Mar 2020 03:45:25 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A090D5D9E2;
        Thu, 19 Mar 2020 03:45:23 +0000 (UTC)
Date:   Wed, 18 Mar 2020 21:45:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v14 Kernel 7/7] vfio: Selective dirty page tracking if
 IOMMU backed device pins pages
Message-ID: <20200318214523.5cc7d066@w520.home>
In-Reply-To: <1584560474-19946-8-git-send-email-kwankhede@nvidia.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
        <1584560474-19946-8-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020 01:11:14 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> Added a check such that only singleton IOMMU groups can pin pages.
> From the point when vendor driver pins any pages, consider IOMMU group
> dirty page scope to be limited to pinned pages.
> 
> To optimize to avoid walking list often, added flag
> pinned_page_dirty_scope to indicate if all of the vfio_groups for each
> vfio_domain in the domain_list dirty page scope is limited to pinned
> pages. This flag is updated on first pinned pages request for that IOMMU
> group and on attaching/detaching group.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio.c             | 13 +++++--
>  drivers/vfio/vfio_iommu_type1.c | 77 +++++++++++++++++++++++++++++++++++++++--
>  include/linux/vfio.h            |  4 ++-
>  3 files changed, 87 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 210fcf426643..311b5e4e111e 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -85,6 +85,7 @@ struct vfio_group {
>  	atomic_t			opened;
>  	wait_queue_head_t		container_q;
>  	bool				noiommu;
> +	unsigned int			dev_counter;
>  	struct kvm			*kvm;
>  	struct blocking_notifier_head	notifier;
>  };
> @@ -555,6 +556,7 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
>  
>  	mutex_lock(&group->device_lock);
>  	list_add(&device->group_next, &group->device_list);
> +	group->dev_counter++;
>  	mutex_unlock(&group->device_lock);
>  
>  	return device;
> @@ -567,6 +569,7 @@ static void vfio_device_release(struct kref *kref)
>  	struct vfio_group *group = device->group;
>  
>  	list_del(&device->group_next);
> +	group->dev_counter--;
>  	mutex_unlock(&group->device_lock);
>  
>  	dev_set_drvdata(device->dev, NULL);
> @@ -1933,6 +1936,9 @@ int vfio_pin_pages(struct device *dev, unsigned long *user_pfn, int npage,
>  	if (!group)
>  		return -ENODEV;
>  
> +	if (group->dev_counter > 1)
> +		return -EINVAL;
> +
>  	ret = vfio_group_add_container_user(group);
>  	if (ret)
>  		goto err_pin_pages;
> @@ -1940,7 +1946,8 @@ int vfio_pin_pages(struct device *dev, unsigned long *user_pfn, int npage,
>  	container = group->container;
>  	driver = container->iommu_driver;
>  	if (likely(driver && driver->ops->pin_pages))
> -		ret = driver->ops->pin_pages(container->iommu_data, user_pfn,
> +		ret = driver->ops->pin_pages(container->iommu_data,
> +					     group->iommu_group, user_pfn,
>  					     npage, prot, phys_pfn);
>  	else
>  		ret = -ENOTTY;
> @@ -2038,8 +2045,8 @@ int vfio_group_pin_pages(struct vfio_group *group,
>  	driver = container->iommu_driver;
>  	if (likely(driver && driver->ops->pin_pages))
>  		ret = driver->ops->pin_pages(container->iommu_data,
> -					     user_iova_pfn, npage,
> -					     prot, phys_pfn);
> +					     group->iommu_group, user_iova_pfn,
> +					     npage, prot, phys_pfn);
>  	else
>  		ret = -ENOTTY;
>  
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 912629320719..deec09f4b0f6 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -72,6 +72,7 @@ struct vfio_iommu {
>  	bool			v2;
>  	bool			nesting;
>  	bool			dirty_page_tracking;
> +	bool			pinned_page_dirty_scope;
>  };
>  
>  struct vfio_domain {
> @@ -99,6 +100,7 @@ struct vfio_group {
>  	struct iommu_group	*iommu_group;
>  	struct list_head	next;
>  	bool			mdev_group;	/* An mdev group */
> +	bool			pinned_page_dirty_scope;
>  };
>  
>  struct vfio_iova {
> @@ -132,6 +134,10 @@ struct vfio_regions {
>  static int put_pfn(unsigned long pfn, int prot);
>  static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
>  
> +static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> +					       struct iommu_group *iommu_group);
> +
> +static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
>  /*
>   * This code handles mapping and unmapping of user data buffers
>   * into DMA'ble space using the IOMMU
> @@ -556,11 +562,13 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
>  }
>  
>  static int vfio_iommu_type1_pin_pages(void *iommu_data,
> +				      struct iommu_group *iommu_group,
>  				      unsigned long *user_pfn,
>  				      int npage, int prot,
>  				      unsigned long *phys_pfn)
>  {
>  	struct vfio_iommu *iommu = iommu_data;
> +	struct vfio_group *group;
>  	int i, j, ret;
>  	unsigned long remote_vaddr;
>  	struct vfio_dma *dma;
> @@ -630,8 +638,14 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  				   (vpfn->iova - dma->iova) >> pgshift, 1);
>  		}
>  	}
> -
>  	ret = i;
> +
> +	group = vfio_iommu_find_iommu_group(iommu, iommu_group);
> +	if (!group->pinned_page_dirty_scope) {
> +		group->pinned_page_dirty_scope = true;
> +		update_pinned_page_dirty_scope(iommu);
> +	}
> +
>  	goto pin_done;
>  
>  pin_unwind:
> @@ -913,8 +927,11 @@ static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
>  	npages = dma->size >> pgshift;
>  	bitmap_size = DIRTY_BITMAP_BYTES(npages);
>  
> -	/* mark all pages dirty if all pages are pinned and mapped. */
> -	if (dma->iommu_mapped)
> +	/*
> +	 * mark all pages dirty if any IOMMU capable device is not able
> +	 * to report dirty pages and all pages are pinned and mapped.
> +	 */
> +	if (!iommu->pinned_page_dirty_scope && dma->iommu_mapped)
>  		bitmap_set(dma->bitmap, 0, npages);
>  
>  	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
> @@ -1393,6 +1410,51 @@ static struct vfio_group *find_iommu_group(struct vfio_domain *domain,
>  	return NULL;
>  }
>  
> +static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> +					       struct iommu_group *iommu_group)
> +{
> +	struct vfio_domain *domain;
> +	struct vfio_group *group = NULL;
> +
> +	list_for_each_entry(domain, &iommu->domain_list, next) {
> +		group = find_iommu_group(domain, iommu_group);
> +		if (group)
> +			return group;
> +	}
> +
> +	if (iommu->external_domain)
> +		group = find_iommu_group(iommu->external_domain, iommu_group);
> +
> +	return group;
> +}
> +
> +static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu)
> +{
> +	struct vfio_domain *domain;
> +	struct vfio_group *group;
> +
> +	list_for_each_entry(domain, &iommu->domain_list, next) {
> +		list_for_each_entry(group, &domain->group_list, next) {
> +			if (!group->pinned_page_dirty_scope) {
> +				iommu->pinned_page_dirty_scope = false;
> +				return;
> +			}
> +		}
> +	}
> +
> +	if (iommu->external_domain) {
> +		domain = iommu->external_domain;
> +		list_for_each_entry(group, &domain->group_list, next) {
> +			if (!group->pinned_page_dirty_scope) {
> +				iommu->pinned_page_dirty_scope = false;
> +				return;
> +			}
> +		}
> +	}
> +
> +	iommu->pinned_page_dirty_scope = true;
> +}
> +
>  static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
>  				  phys_addr_t *base)
>  {
> @@ -1799,6 +1861,9 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  
>  			list_add(&group->next,
>  				 &iommu->external_domain->group_list);
> +			group->pinned_page_dirty_scope = true;
> +			if (!iommu->pinned_page_dirty_scope)
> +				update_pinned_page_dirty_scope(iommu);

A comment above this would be good since this wasn't entirely obvious,
maybe:

/*
 * Non-iommu backed group cannot dirty memory directly,
 * it can only use interfaces that provide dirty tracking.
 * The iommu scope can only be promoted with the addition
 * of a dirty tracking group.
 */

>  			mutex_unlock(&iommu->lock);
>  
>  			return 0;
> @@ -1921,6 +1986,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  done:
>  	/* Delete the old one and insert new iova list */
>  	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
> +	iommu->pinned_page_dirty_scope = false;

Likewise here:

/*
 * An iommu backed group can dirty memory directly and therefore
 * demotes the iommu scope until it declares itself dirty tracking
 * capable via the page pinning interface.
 */

>  	mutex_unlock(&iommu->lock);
>  	vfio_iommu_resv_free(&group_resv_regions);
>  
> @@ -2073,6 +2139,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	struct vfio_iommu *iommu = iommu_data;
>  	struct vfio_domain *domain;
>  	struct vfio_group *group;
> +	bool update_dirty_scope = false;
>  	LIST_HEAD(iova_copy);
>  
>  	mutex_lock(&iommu->lock);
> @@ -2080,6 +2147,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	if (iommu->external_domain) {
>  		group = find_iommu_group(iommu->external_domain, iommu_group);
>  		if (group) {
> +			update_dirty_scope = !group->pinned_page_dirty_scope;
>  			list_del(&group->next);
>  			kfree(group);
>  
> @@ -2109,6 +2177,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  			continue;
>  
>  		vfio_iommu_detach_group(domain, group);
> +		update_dirty_scope = !group->pinned_page_dirty_scope;
>  		list_del(&group->next);
>  		kfree(group);
>  		/*
> @@ -2139,6 +2208,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  		vfio_iommu_iova_free(&iova_copy);
>  
>  detach_group_done:
> +	if (update_dirty_scope)
> +		update_pinned_page_dirty_scope(iommu);

And one more

/*
 * Removal of a group without dirty tracking may
 * allow the iommu scope to be promoted.
 */

>  	mutex_unlock(&iommu->lock);
>  }
>  
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index be2bd358b952..702e1d7b6e8b 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -72,7 +72,9 @@ struct vfio_iommu_driver_ops {
>  					struct iommu_group *group);
>  	void		(*detach_group)(void *iommu_data,
>  					struct iommu_group *group);
> -	int		(*pin_pages)(void *iommu_data, unsigned long *user_pfn,
> +	int		(*pin_pages)(void *iommu_data,
> +				     struct iommu_group *group,
> +				     unsigned long *user_pfn,
>  				     int npage, int prot,
>  				     unsigned long *phys_pfn);
>  	int		(*unpin_pages)(void *iommu_data,

