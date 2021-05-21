Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A9C38BFB9
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 08:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbhEUGnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 02:43:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4566 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbhEUGlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 02:41:08 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FmcLM2wSYzqVFH;
        Fri, 21 May 2021 14:35:39 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:38:26 +0800
Received: from [10.174.187.155] (10.174.187.155) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:38:25 +0800
Subject: Re: [RFC PATCH v3 5/8] vfio/type1: VFIO_IOMMU_ENABLE_IOPF
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Barry Song" <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
 <20210409034420.1799-6-lushenming@huawei.com>
 <20210518125821.590a23aa.alex.williamson@redhat.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <c74251ec-9536-7e9f-cc38-db730aeaed92@huawei.com>
Date:   Fri, 21 May 2021 14:38:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210518125821.590a23aa.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.155]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/19 2:58, Alex Williamson wrote:
> On Fri, 9 Apr 2021 11:44:17 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
> 
>> Since enabling IOPF for devices may lead to a slow ramp up of performance,
>> we add an ioctl VFIO_IOMMU_ENABLE_IOPF to make it configurable. And the
>> IOPF enabling of a VFIO device includes setting IOMMU_DEV_FEAT_IOPF and
>> registering the VFIO IOPF handler.
>>
>> Note that VFIO_IOMMU_DISABLE_IOPF is not supported since there may be
>> inflight page faults when disabling.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 223 +++++++++++++++++++++++++++++++-
>>  include/uapi/linux/vfio.h       |   6 +
>>  2 files changed, 226 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 01e296c6dc9e..7df5711e743a 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -71,6 +71,7 @@ struct vfio_iommu {
>>  	struct rb_root		dma_list;
>>  	struct blocking_notifier_head notifier;
>>  	struct mmu_notifier	mn;
>> +	struct mm_struct	*mm;
> 
> We currently have no requirement that a single mm is used for all
> container mappings.  Does enabling IOPF impose such a requirement?
> Shouldn't MAP/UNMAP enforce that?

Did you mean that there is a possibility that each vfio_dma in a
container has a different mm? If so, could we register one MMU
notifier for each vfio_dma in the MAP ioctl?

> 
>>  	unsigned int		dma_avail;
>>  	unsigned int		vaddr_invalid_count;
>>  	uint64_t		pgsize_bitmap;
>> @@ -81,6 +82,7 @@ struct vfio_iommu {
>>  	bool			dirty_page_tracking;
>>  	bool			pinned_page_dirty_scope;
>>  	bool			container_open;
>> +	bool			iopf_enabled;
>>  };
>>  
>>  struct vfio_domain {
>> @@ -461,6 +463,38 @@ vfio_find_iopf_group(struct iommu_group *iommu_group)
>>  	return node ? iopf_group : NULL;
>>  }
>>  
>> +static void vfio_link_iopf_group(struct vfio_iopf_group *new)
>> +{
>> +	struct rb_node **link, *parent = NULL;
>> +	struct vfio_iopf_group *iopf_group;
>> +
>> +	mutex_lock(&iopf_group_list_lock);
>> +
>> +	link = &iopf_group_list.rb_node;
>> +
>> +	while (*link) {
>> +		parent = *link;
>> +		iopf_group = rb_entry(parent, struct vfio_iopf_group, node);
>> +
>> +		if (new->iommu_group < iopf_group->iommu_group)
>> +			link = &(*link)->rb_left;
>> +		else
>> +			link = &(*link)->rb_right;
>> +	}
>> +
>> +	rb_link_node(&new->node, parent, link);
>> +	rb_insert_color(&new->node, &iopf_group_list);
>> +
>> +	mutex_unlock(&iopf_group_list_lock);
>> +}
>> +
>> +static void vfio_unlink_iopf_group(struct vfio_iopf_group *old)
>> +{
>> +	mutex_lock(&iopf_group_list_lock);
>> +	rb_erase(&old->node, &iopf_group_list);
>> +	mutex_unlock(&iopf_group_list_lock);
>> +}
>> +
>>  static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>>  {
>>  	struct mm_struct *mm;
>> @@ -2363,6 +2397,68 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
>>  	list_splice_tail(iova_copy, iova);
>>  }
>>  
>> +static int vfio_dev_domian_nested(struct device *dev, int *nested)
> 
> 
> s/domian/domain/
> 
> 
>> +{
>> +	struct iommu_domain *domain;
>> +
>> +	domain = iommu_get_domain_for_dev(dev);
>> +	if (!domain)
>> +		return -ENODEV;
>> +
>> +	return iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, nested);
> 
> 
> Wouldn't this be easier to use if it returned bool, false on -errno?

Make sense.

> 
> 
>> +}
>> +
>> +static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data);
>> +
>> +static int dev_enable_iopf(struct device *dev, void *data)
>> +{
>> +	int *enabled_dev_cnt = data;
>> +	int nested;
>> +	u32 flags;
>> +	int ret;
>> +
>> +	ret = iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_IOPF);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = vfio_dev_domian_nested(dev, &nested);
>> +	if (ret)
>> +		goto out_disable;
>> +
>> +	if (nested)
>> +		flags = FAULT_REPORT_NESTED_L2;
>> +	else
>> +		flags = FAULT_REPORT_FLAT;
>> +
>> +	ret = iommu_register_device_fault_handler(dev,
>> +				vfio_iommu_type1_dma_map_iopf, flags, dev);
>> +	if (ret)
>> +		goto out_disable;
>> +
>> +	(*enabled_dev_cnt)++;
>> +	return 0;
>> +
>> +out_disable:
>> +	iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_IOPF);
>> +	return ret;
>> +}
>> +
>> +static int dev_disable_iopf(struct device *dev, void *data)
>> +{
>> +	int *enabled_dev_cnt = data;
>> +
>> +	if (enabled_dev_cnt && *enabled_dev_cnt <= 0)
>> +		return -1;
> 
> 
> Use an errno.>
> 
>> +
>> +	WARN_ON(iommu_unregister_device_fault_handler(dev));
>> +	WARN_ON(iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_IOPF));
>> +
>> +	if (enabled_dev_cnt)
>> +		(*enabled_dev_cnt)--;
> 
> 
> Why do we need these counters?

We use this counter to record the number of IOPF enabled devices, and if
any device fails to be enabled, we will exit the loop (three nested loop)
and go to the unwind process, which will disable the first @enabled_dev_cnt
devices.

> 
>> +
>> +	return 0;
>> +}
>> +
>>  static int vfio_iommu_type1_attach_group(void *iommu_data,
>>  					 struct iommu_group *iommu_group)
>>  {
>> @@ -2376,6 +2472,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>  	struct iommu_domain_geometry geo;
>>  	LIST_HEAD(iova_copy);
>>  	LIST_HEAD(group_resv_regions);
>> +	int iopf_enabled_dev_cnt = 0;
>> +	struct vfio_iopf_group *iopf_group = NULL;
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> @@ -2453,6 +2551,24 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>  	if (ret)
>>  		goto out_domain;
>>  
>> +	if (iommu->iopf_enabled) {
>> +		ret = iommu_group_for_each_dev(iommu_group, &iopf_enabled_dev_cnt,
>> +					       dev_enable_iopf);
>> +		if (ret)
>> +			goto out_detach;
>> +
>> +		iopf_group = kzalloc(sizeof(*iopf_group), GFP_KERNEL);
>> +		if (!iopf_group) {
>> +			ret = -ENOMEM;
>> +			goto out_detach;
>> +		}
>> +
>> +		iopf_group->iommu_group = iommu_group;
>> +		iopf_group->iommu = iommu;
>> +
>> +		vfio_link_iopf_group(iopf_group);
> 
> This seems backwards, once we enable iopf we can take a fault, so the
> structure to lookup the data for the device should be setup first.  I'm
> still not convinced this iopf_group rb tree is a good solution to get
> from the device to the iommu either.  vfio-core could traverse dev ->
> iommu_group -> vfio_group -> container -> iommu_data.

Make sense.

> 
> 
>> +	}
>> +
>>  	/* Get aperture info */
>>  	iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY, &geo);
>>  
>> @@ -2534,9 +2650,11 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>  	vfio_test_domain_fgsp(domain);
>>  
>>  	/* replay mappings on new domains */
>> -	ret = vfio_iommu_replay(iommu, domain);
>> -	if (ret)
>> -		goto out_detach;
>> +	if (!iommu->iopf_enabled) {
>> +		ret = vfio_iommu_replay(iommu, domain);
>> +		if (ret)
>> +			goto out_detach;
>> +	}
> 
> Test in vfio_iommu_replay()?

Not yet, I will do more tests later.

> 
>>  
>>  	if (resv_msi) {
>>  		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
>> @@ -2567,6 +2685,15 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>  	iommu_domain_free(domain->domain);
>>  	vfio_iommu_iova_free(&iova_copy);
>>  	vfio_iommu_resv_free(&group_resv_regions);
>> +	if (iommu->iopf_enabled) {
>> +		if (iopf_group) {
>> +			vfio_unlink_iopf_group(iopf_group);
>> +			kfree(iopf_group);
>> +		}
>> +
>> +		iommu_group_for_each_dev(iommu_group, &iopf_enabled_dev_cnt,
>> +					 dev_disable_iopf);
> 
> Backwards, disable fault reporting before unlinking lookup.

Make sense.

> 
>> +	}
>>  out_free:
>>  	kfree(domain);
>>  	kfree(group);
>> @@ -2728,6 +2855,19 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  		if (!group)
>>  			continue;
>>  
>> +		if (iommu->iopf_enabled) {
>> +			struct vfio_iopf_group *iopf_group;
>> +
>> +			iopf_group = vfio_find_iopf_group(iommu_group);
>> +			if (!WARN_ON(!iopf_group)) {
>> +				vfio_unlink_iopf_group(iopf_group);
>> +				kfree(iopf_group);
>> +			}
>> +
>> +			iommu_group_for_each_dev(iommu_group, NULL,
>> +						 dev_disable_iopf);
> 
> 
> Backwards.  Also unregistering the fault handler can fail if there are
> pending faults.  It appears the fault handler and iopf lookup could also
> race with this function, ex. fault handler gets an iopf object before
> it's removed from the rb-tree, blocks trying to acquire iommu->lock,
> disable_iopf fails, detach proceeds, fault handler has use after free
> error.

We have WARN_ON for the failure of the unregistering.

Yeah, it seems that using vfio_iopf_group is not a good choice...

> 
> 
>> +		}
>> +
>>  		vfio_iommu_detach_group(domain, group);
>>  		update_dirty_scope = !group->pinned_page_dirty_scope;
>>  		list_del(&group->next);
>> @@ -2846,6 +2986,11 @@ static void vfio_iommu_type1_release(void *iommu_data)
>>  
>>  	vfio_iommu_iova_free(&iommu->iova_list);
>>  
>> +	if (iommu->iopf_enabled) {
>> +		mmu_notifier_unregister(&iommu->mn, iommu->mm);
>> +		mmdrop(iommu->mm);
>> +	}
>> +
>>  	kfree(iommu);
>>  }
>>  
>> @@ -3441,6 +3586,76 @@ static const struct mmu_notifier_ops vfio_iommu_type1_mn_ops = {
>>  	.invalidate_range	= mn_invalidate_range,
>>  };
>>  
>> +static int vfio_iommu_type1_enable_iopf(struct vfio_iommu *iommu)
>> +{
>> +	struct vfio_domain *d;
>> +	struct vfio_group *g;
>> +	struct vfio_iopf_group *iopf_group;
>> +	int enabled_dev_cnt = 0;
>> +	int ret;
>> +
>> +	if (!current->mm)
>> +		return -ENODEV;
>> +
>> +	mutex_lock(&iommu->lock);
>> +
>> +	mmgrab(current->mm);
> 
> 
> As above, this is a new and undocumented requirement.
> 
> 
>> +	iommu->mm = current->mm;
>> +	iommu->mn.ops = &vfio_iommu_type1_mn_ops;
>> +	ret = mmu_notifier_register(&iommu->mn, current->mm);
>> +	if (ret)
>> +		goto out_drop;
>> +
>> +	list_for_each_entry(d, &iommu->domain_list, next) {
>> +		list_for_each_entry(g, &d->group_list, next) {
>> +			ret = iommu_group_for_each_dev(g->iommu_group,
>> +					&enabled_dev_cnt, dev_enable_iopf);
>> +			if (ret)
>> +				goto out_unwind;
>> +
>> +			iopf_group = kzalloc(sizeof(*iopf_group), GFP_KERNEL);
>> +			if (!iopf_group) {
>> +				ret = -ENOMEM;
>> +				goto out_unwind;
>> +			}
>> +
>> +			iopf_group->iommu_group = g->iommu_group;
>> +			iopf_group->iommu = iommu;
>> +
>> +			vfio_link_iopf_group(iopf_group);
>> +		}
>> +	}
>> +
>> +	iommu->iopf_enabled = true;
>> +	goto out_unlock;
>> +
>> +out_unwind:
>> +	list_for_each_entry(d, &iommu->domain_list, next) {
>> +		list_for_each_entry(g, &d->group_list, next) {
>> +			iopf_group = vfio_find_iopf_group(g->iommu_group);
>> +			if (iopf_group) {
>> +				vfio_unlink_iopf_group(iopf_group);
>> +				kfree(iopf_group);
>> +			}
>> +
>> +			if (iommu_group_for_each_dev(g->iommu_group,
>> +					&enabled_dev_cnt, dev_disable_iopf))
>> +				goto out_unregister;
> 
> 
> This seems broken, we break out of the unwind if any group_for_each
> fails??

The iommu_group_for_each_dev function will return a negative value if
we have disabled all previously enabled devices (@enabled_dev_cnt).

> 
>> +		}
>> +	}
>> +
>> +out_unregister:
>> +	mmu_notifier_unregister(&iommu->mn, current->mm);
>> +
>> +out_drop:
>> +	iommu->mm = NULL;
>> +	mmdrop(current->mm);
>> +
>> +out_unlock:
>> +	mutex_unlock(&iommu->lock);
>> +	return ret;
>> +}
> 
> 
> Is there an assumption that the user does this before performing any
> mapping?  I don't see where current mappings would be converted which
> means we'll have pinned pages leaked and vfio_dma objects without a
> pinned page bitmap.

Yeah, we have an assumption that this ioctl (ENABLE_IOPF) must be called
before any MAP/UNMAP ioctl...

I will document these later. :-)

> 
>> +
>>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>>  				   unsigned int cmd, unsigned long arg)
>>  {
>> @@ -3457,6 +3672,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>  		return vfio_iommu_type1_unmap_dma(iommu, arg);
>>  	case VFIO_IOMMU_DIRTY_PAGES:
>>  		return vfio_iommu_type1_dirty_pages(iommu, arg);
>> +	case VFIO_IOMMU_ENABLE_IOPF:
>> +		return vfio_iommu_type1_enable_iopf(iommu);
>>  	default:
>>  		return -ENOTTY;
>>  	}
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 8ce36c1d53ca..5497036bebdc 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1208,6 +1208,12 @@ struct vfio_iommu_type1_dirty_bitmap_get {
>>  
>>  #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
>>  
>> +/*
>> + * IOCTL to enable IOPF for the container.
>> + * Called right after VFIO_SET_IOMMU.
>> + */
>> +#define VFIO_IOMMU_ENABLE_IOPF             _IO(VFIO_TYPE, VFIO_BASE + 18)
> 
> 
> We have extensions and flags and capabilities, and nothing tells the
> user whether this feature is available to them without trying it?

Yeah, we can have a capability for IOPF.
It is rough now... I will try to extend it later. :-)

Thanks,
Shenming

> 
> 
>> +
>>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>>  
>>  /*
> 
> .
> 
