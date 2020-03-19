Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E780718ACCC
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCSGeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:34:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:6942 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbgCSGeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:34:08 -0400
IronPort-SDR: ErGLKwXaCkgP+7E1ykJpurlByly8KdnR3wQ/d1YXY4L4T27lgKcV9a890AnalkIpf7khMjCola
 SXLh3g7jFeVg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 23:34:07 -0700
IronPort-SDR: aPr2BkxQ7S4zlufyEPryEPzQAsH6l2PP75BaxeIoK0J91IQY1MaxU0gnJwArfxe/o7or6UX1e8
 BnyRNkVxNAbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="238402928"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga008.fm.intel.com with ESMTP; 18 Mar 2020 23:34:02 -0700
Date:   Thu, 19 Mar 2020 02:24:33 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v14 Kernel 7/7] vfio: Selective dirty page tracking if
 IOMMU backed device pins pages
Message-ID: <20200319062433.GH4641@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
 <1584560474-19946-8-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584560474-19946-8-git-send-email-kwankhede@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 03:41:14AM +0800, Kirti Wankhede wrote:
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

Could you provide an interface lightweight than vfio_pin_pages for pass-through
devices? e.g. vfio_mark_iova_dirty()

Or at least allowing phys_pfn to be empty for pass-through devices.

This is really inefficient:
bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1));
i.e.
in order to mark an iova dirty, it has to go through iova ---> pfn --> iova
while acquiring pfn is not necessary for pass-through devices.


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
>  			mutex_unlock(&iommu->lock);
>  
>  			return 0;
> @@ -1921,6 +1986,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  done:
>  	/* Delete the old one and insert new iova list */
>  	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
> +	iommu->pinned_page_dirty_scope = false;
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
> -- 
> 2.7.0
> 
