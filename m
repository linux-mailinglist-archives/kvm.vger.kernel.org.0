Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 008FB188D91
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 20:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgCQTAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 15:00:53 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39268 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726294AbgCQTAx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 15:00:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584471651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5c8gNP249zCsZ3NbnsdxB8QCnpw1HKR3rbdtSJpVhA=;
        b=crif8t6Ig+Ldpx9rkUsO5Wcj4QlMFEcbqbfL1unTOiEmolTjlwB/pd0LiJwYFtMIWOZgnV
        N4kkjsM5PEJqi3OCDA22X2svsvARdStR3OZSL/v4gQkZ++ey3kxVh2VhL+In/6nk3L8ZWl
        PsIf4NwYxK4Y3zpbBvp+WMOKQ4XdwxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-3AzyVHZCOnWpICXOf7CcDw-1; Tue, 17 Mar 2020 15:00:47 -0400
X-MC-Unique: 3AzyVHZCOnWpICXOf7CcDw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0954E107BA99;
        Tue, 17 Mar 2020 19:00:44 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F99A1059107;
        Tue, 17 Mar 2020 19:00:37 +0000 (UTC)
Date:   Tue, 17 Mar 2020 13:00:36 -0600
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
Subject: Re: [PATCH v13 Kernel 7/7] vfio: Selective dirty page tracking if
 IOMMU backed device pins pages
Message-ID: <20200317130036.6f20003c@w520.home>
In-Reply-To: <48f3b2b2-c066-f366-e5ff-2f39763a9463@nvidia.com>
References: <1584035607-23166-1-git-send-email-kwankhede@nvidia.com>
        <1584035607-23166-8-git-send-email-kwankhede@nvidia.com>
        <20200313144911.72e727d4@x1.home>
        <48f3b2b2-c066-f366-e5ff-2f39763a9463@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Mar 2020 23:58:38 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 3/14/2020 2:19 AM, Alex Williamson wrote:
> > On Thu, 12 Mar 2020 23:23:27 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> Added a check such that only singleton IOMMU groups can pin pages.
> >>  From the point when vendor driver pins any pages, consider IOMMU group
> >> dirty page scope to be limited to pinned pages.
> >>
> >> To optimize to avoid walking list often, added flag
> >> pinned_page_dirty_scope to indicate if all of the vfio_groups for each
> >> vfio_domain in the domain_list dirty page scope is limited to pinned
> >> pages. This flag is updated on first pinned pages request for that IOMMU
> >> group and on attaching/detaching group.
> >>
> >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >> ---
> >>   drivers/vfio/vfio.c             |  9 +++++-
> >>   drivers/vfio/vfio_iommu_type1.c | 72 +++++++++++++++++++++++++++++++++++++++--
> >>   include/linux/vfio.h            |  4 ++-
> >>   3 files changed, 80 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> >> index c8482624ca34..79108c1245a5 100644
> >> --- a/drivers/vfio/vfio.c
> >> +++ b/drivers/vfio/vfio.c
> >> @@ -85,6 +85,7 @@ struct vfio_group {
> >>   	atomic_t			opened;
> >>   	wait_queue_head_t		container_q;
> >>   	bool				noiommu;
> >> +	unsigned int			dev_counter;
> >>   	struct kvm			*kvm;
> >>   	struct blocking_notifier_head	notifier;
> >>   };
> >> @@ -555,6 +556,7 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
> >>   
> >>   	mutex_lock(&group->device_lock);
> >>   	list_add(&device->group_next, &group->device_list);
> >> +	group->dev_counter++;
> >>   	mutex_unlock(&group->device_lock);
> >>   
> >>   	return device;
> >> @@ -567,6 +569,7 @@ static void vfio_device_release(struct kref *kref)
> >>   	struct vfio_group *group = device->group;
> >>   
> >>   	list_del(&device->group_next);
> >> +	group->dev_counter--;
> >>   	mutex_unlock(&group->device_lock);
> >>   
> >>   	dev_set_drvdata(device->dev, NULL);
> >> @@ -1895,6 +1898,9 @@ int vfio_pin_pages(struct device *dev, unsigned long *user_pfn, int npage,
> >>   	if (!group)
> >>   		return -ENODEV;
> >>   
> >> +	if (group->dev_counter > 1)
> >> +		return -EINVAL;
> >> +
> >>   	ret = vfio_group_add_container_user(group);
> >>   	if (ret)
> >>   		goto err_pin_pages;
> >> @@ -1902,7 +1908,8 @@ int vfio_pin_pages(struct device *dev, unsigned long *user_pfn, int npage,
> >>   	container = group->container;
> >>   	driver = container->iommu_driver;
> >>   	if (likely(driver && driver->ops->pin_pages))
> >> -		ret = driver->ops->pin_pages(container->iommu_data, user_pfn,
> >> +		ret = driver->ops->pin_pages(container->iommu_data,
> >> +					     group->iommu_group, user_pfn,
> >>   					     npage, prot, phys_pfn);
> >>   	else
> >>   		ret = -ENOTTY;
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 4f1f116feabc..18a284b230c0 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -71,6 +71,7 @@ struct vfio_iommu {
> >>   	bool			v2;
> >>   	bool			nesting;
> >>   	bool			dirty_page_tracking;
> >> +	bool			pinned_page_dirty_scope;
> >>   };
> >>   
> >>   struct vfio_domain {
> >> @@ -98,6 +99,7 @@ struct vfio_group {
> >>   	struct iommu_group	*iommu_group;
> >>   	struct list_head	next;
> >>   	bool			mdev_group;	/* An mdev group */
> >> +	bool			has_pinned_pages;  
> > 
> > I'm afraid over time this name will be confusing, should we simply
> > call it pinned_page_dirty_scope per vfio_group as well?   
> 
> Updating as you suggested, but I hope it doesn't look confusing.
> 
> >  We might have
> > to adapt this over time as we get new ways to dirty pages, but each
> > group voting towards the same value being set on the vfio_iommu object
> > seems like a good starting point.
> >   
> >>   };
> >>   
> >>   struct vfio_iova {
> >> @@ -129,6 +131,10 @@ struct vfio_regions {
> >>   static int put_pfn(unsigned long pfn, int prot);
> >>   static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
> >>   
> >> +static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> >> +					       struct iommu_group *iommu_group);
> >> +
> >> +static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
> >>   /*
> >>    * This code handles mapping and unmapping of user data buffers
> >>    * into DMA'ble space using the IOMMU
> >> @@ -579,11 +585,13 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
> >>   }
> >>   
> >>   static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >> +				      struct iommu_group *iommu_group,
> >>   				      unsigned long *user_pfn,
> >>   				      int npage, int prot,
> >>   				      unsigned long *phys_pfn)
> >>   {
> >>   	struct vfio_iommu *iommu = iommu_data;
> >> +	struct vfio_group *group;
> >>   	int i, j, ret;
> >>   	unsigned long remote_vaddr;
> >>   	struct vfio_dma *dma;
> >> @@ -662,8 +670,14 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   				   (vpfn->iova - dma->iova) >> pgshift, 1);
> >>   		}
> >>   	}
> >> -
> >>   	ret = i;
> >> +
> >> +	group = vfio_iommu_find_iommu_group(iommu, iommu_group);
> >> +	if (!group->has_pinned_pages) {
> >> +		group->has_pinned_pages = true;
> >> +		update_pinned_page_dirty_scope(iommu);
> >> +	}
> >> +
> >>   	goto pin_done;
> >>   
> >>   pin_unwind:
> >> @@ -946,8 +960,11 @@ static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> >>   	npages = dma->size >> pgshift;
> >>   	bitmap_size = dirty_bitmap_bytes(npages);
> >>   
> >> -	/* mark all pages dirty if all pages are pinned and mapped. */
> >> -	if (dma->iommu_mapped)
> >> +	/*
> >> +	 * mark all pages dirty if any IOMMU capable device is not able
> >> +	 * to report dirty pages and all pages are pinned and mapped.
> >> +	 */
> >> +	if (!iommu->pinned_page_dirty_scope && dma->iommu_mapped)
> >>   		bitmap_set(dma->bitmap, 0, npages);
> >>   
> >>   	if (dma->bitmap) {
> >> @@ -1430,6 +1447,51 @@ static struct vfio_group *find_iommu_group(struct vfio_domain *domain,
> >>   	return NULL;
> >>   }
> >>   
> >> +static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> >> +					       struct iommu_group *iommu_group)
> >> +{
> >> +	struct vfio_domain *domain;
> >> +	struct vfio_group *group = NULL;
> >> +
> >> +	list_for_each_entry(domain, &iommu->domain_list, next) {
> >> +		group = find_iommu_group(domain, iommu_group);
> >> +		if (group)
> >> +			return group;
> >> +	}
> >> +
> >> +	if (iommu->external_domain)
> >> +		group = find_iommu_group(iommu->external_domain, iommu_group);
> >> +
> >> +	return group;
> >> +}
> >> +
> >> +static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu)
> >> +{
> >> +	struct vfio_domain *domain;
> >> +	struct vfio_group *group;
> >> +
> >> +	list_for_each_entry(domain, &iommu->domain_list, next) {
> >> +		list_for_each_entry(group, &domain->group_list, next) {
> >> +			if (!group->has_pinned_pages) {
> >> +				iommu->pinned_page_dirty_scope = false;
> >> +				return;
> >> +			}
> >> +		}
> >> +	}
> >> +
> >> +	if (iommu->external_domain) {
> >> +		domain = iommu->external_domain;
> >> +		list_for_each_entry(group, &domain->group_list, next) {
> >> +			if (!group->has_pinned_pages) {
> >> +				iommu->pinned_page_dirty_scope = false;
> >> +				return;
> >> +			}
> >> +		}
> >> +	}
> >> +
> >> +	iommu->pinned_page_dirty_scope = true;
> >> +}
> >> +
> >>   static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
> >>   				  phys_addr_t *base)
> >>   {
> >> @@ -1836,6 +1898,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >>   
> >>   			list_add(&group->next,
> >>   				 &iommu->external_domain->group_list);
> >> +			update_pinned_page_dirty_scope(iommu);
> >>   			mutex_unlock(&iommu->lock);
> >>   
> >>   			return 0;
> >> @@ -1958,6 +2021,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >>   done:
> >>   	/* Delete the old one and insert new iova list */
> >>   	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
> >> +	update_pinned_page_dirty_scope(iommu);
> >>   	mutex_unlock(&iommu->lock);
> >>   	vfio_iommu_resv_free(&group_resv_regions);
> >>     
> > 
> > At this point we've added an iommu backed group that can't possibly
> > have pages pinned on behalf of this group yet, can't we just set
> > iommu->pinned_page_dirty_scope = false?
> >   
> 
> Right, changing.
> 
> > In the previous case, aren't we adding a non-iommu backed group, so
> > should we presume the scope is pinned pages even before we have any?  
> 
> Anyways we are updating it when pages are pinned, I think better not to 
> presume.

If there's no iommu backing then the device doesn't have access to
dirty the pages itself, how else will they get dirty?  Perhaps I was a
little use in using the word "presume", I think there's a proof that
the pages must have limited dirty-scope.

> > We could almost forego the iommu scope update, but it could be the
> > first group added if we're going to preemptively assume the scope of
> > the group.
> >   
> >> @@ -1972,6 +2036,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >>   out_free:
> >>   	kfree(domain);
> >>   	kfree(group);
> >> +	update_pinned_page_dirty_scope(iommu);  
> > 
> > This one looks like paranoia given how late we update when the group is
> > added.
> >   
> >>   	mutex_unlock(&iommu->lock);
> >>   	return ret;
> >>   }
> >> @@ -2176,6 +2241,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
> >>   		vfio_iommu_iova_free(&iova_copy);
> >>   
> >>   detach_group_done:
> >> +	update_pinned_page_dirty_scope(iommu);  
> > 
> > We only need to do this if the group we're removing does not have
> > pinned page dirty scope, right?  I think we have all the info here to
> > make that optimization.
> >   
> 
> There could be more than one group that doesn't have pinned page dirty 
> scope, better to run through update_pinned_page_dirty_scope() function.

Maybe I stated it wrong above, but I think we have this table:


iommu|group
-----+--------+---------+
XXXXX|   0    |    1    |
-----+--------+---------+
  0  |   A    |    B    |
-----+--------+---------+
  1  |   C    |    D    |
-----+--------+---------+

A: If we are NOT dirty-page-scope at the iommu and we remove a group
that is NOT dirty-page-scope, we need to check because that might have
been the group preventing the iommu from being dirty-page-scope.

B: If we are NOT dirty-page-scope at the iommu and we remove a group
that IS dirty-page-scope, we know that group wasn't limiting the scope
at the iommu.

C: If the iommu IS dirty-page-scope, we can't remove a group that is
NOT dirty page scope, this case is impossible.

D: If the iommu IS dirty-page-scope and we remove a group that IS dirty-
page-scope, nothing changes.

So I think we only need to update on A, or A+C since C cannot happen.
In B and D removing a group with dirt-page-scope cannot change the
iommu scope.  Thanks,

Alex

> >>   	mutex_unlock(&iommu->lock);
> >>   }
> >>   
> >> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> >> index e42a711a2800..da29802d6276 100644
> >> --- a/include/linux/vfio.h
> >> +++ b/include/linux/vfio.h
> >> @@ -72,7 +72,9 @@ struct vfio_iommu_driver_ops {
> >>   					struct iommu_group *group);
> >>   	void		(*detach_group)(void *iommu_data,
> >>   					struct iommu_group *group);
> >> -	int		(*pin_pages)(void *iommu_data, unsigned long *user_pfn,
> >> +	int		(*pin_pages)(void *iommu_data,
> >> +				     struct iommu_group *group,
> >> +				     unsigned long *user_pfn,
> >>   				     int npage, int prot,
> >>   				     unsigned long *phys_pfn);
> >>   	int		(*unpin_pages)(void *iommu_data,  
> >   
> 

