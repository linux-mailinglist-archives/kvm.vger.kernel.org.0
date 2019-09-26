Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9F3BEAB4
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 04:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391648AbfIZChe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 22:37:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfIZCh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 22:37:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EC0613A82;
        Thu, 26 Sep 2019 02:37:25 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A19A5D9C3;
        Thu, 26 Sep 2019 02:37:24 +0000 (UTC)
Date:   Wed, 25 Sep 2019 20:37:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, yi.y.sun@intel.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yan.y.zhao@intel.com, shaopeng.he@intel.com, chenbo.xia@intel.com,
        jun.j.tian@intel.com
Subject: Re: [PATCH v2 13/13] vfio/type1: track iommu backed group attach
Message-ID: <20190925203723.044d3bf0@x1.home>
In-Reply-To: <1567670923-4599-1-git-send-email-yi.l.liu@intel.com>
References: <1567670923-4599-1-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 26 Sep 2019 02:37:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 Sep 2019 16:08:43 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> With the introduction of iommu aware mdev group, user may wrap a PF/VF
> as a mdev. Such mdevs will be called as wrapped PF/VF mdevs in following
> statements. If it's applied on a non-singleton iommu group, there would
> be multiple domain attach on an iommu_device group (equal to iommu backed
> group). Reason is that mdev group attaches is finally an iommu_device
> group attach in the end. And existing vfio_domain.gorup_list has no idea
> about it. Thus multiple attach would happen.
> 
> What's more, under default domain policy, group attach is allowed only
> when its in-use domain is equal to its default domain as the code below:
> 
> static int __iommu_attach_group(struct iommu_domain *domain, ..)
> {
> 	..
> 	if (group->default_domain && group->domain != group->default_domain)
> 		return -EBUSY;
> 	...
> }
> 
> So for the above scenario, only the first group attach on the
> non-singleton iommu group will be successful. Subsequent group
> attaches will be failed. However, this is a fairly valid usage case
> if the wrapped PF/VF mdevs and other devices are assigned to a single
> VM. We may want to prevent it. In other words, the subsequent group
> attaches should return success before going to __iommu_attach_group().
> 
> However, if user tries to assign the wrapped PF/VF mdevs and other
> devices to different VMs, the subsequent group attaches on a single
> iommu_device group should be failed. This means the subsequent group
> attach should finally calls into __iommu_attach_group() and be failed.
> 
> To meet the above requirements, this patch introduces vfio_group_object
> structure to track the group attach of an iommu_device group (a.ka.
> iommu backed group). Each vfio_domain will have a group_obj_list to
> record the vfio_group_objects. The search of the group_obj_list should
> use iommu_device group if a group is mdev group.
> 
> 	struct vfio_group_object {
> 		atomic_t		count;
> 		struct iommu_group	*iommu_group;
> 		struct vfio_domain	*domain;
> 		struct list_head	next;
> 	};
> 
> Each time, a successful group attach should either have a new
> vfio_group_object created or count increasing of an existing
> vfio_group_object instance. Details can be found in
> vfio_domain_attach_group_object().
> 
> For group detach, should have count decreasing. Please check
> vfio_domain_detach_group_object().
> 
> As the vfio_domain.group_obj_list is within vfio container(vfio_iommu)
> scope, if user wants to passthru a non-singleton to multiple VMs, it
> will be failed as VMs will have separate vfio containers. Also, if
> vIOMMU is exposed, it will also fail the attempts of assigning multiple
> devices (via vfio-pci or PF/VF wrapped mdev) to a single VM. This is
> aligned with current vfio passthru rules.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 167 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 154 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 317430d..6a67bd6 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -75,6 +75,7 @@ struct vfio_domain {
>  	struct iommu_domain	*domain;
>  	struct list_head	next;
>  	struct list_head	group_list;
> +	struct list_head	group_obj_list;
>  	int			prot;		/* IOMMU_CACHE */
>  	bool			fgsp;		/* Fine-grained super pages */
>  };
> @@ -97,6 +98,13 @@ struct vfio_group {
>  	bool			mdev_group;	/* An mdev group */
>  };
>  
> +struct vfio_group_object {
> +	atomic_t		count;
> +	struct iommu_group	*iommu_group;
> +	struct vfio_domain	*domain;
> +	struct list_head	next;
> +};
> +

So vfio_domain already has a group_list for all the groups attached to
that iommu domain.  We add a vfio_group_object list, which is also
effectively a list of groups attached to the domain, but we're tracking
something different with it.  All groups seem to get added as a
vfio_group_object, so why do we need both lists?  As I suspected when
we discussed this last, this adds complexity for something that's
currently being proposed as a sample driver.

>  /*
>   * Guest RAM pinning working set or DMA target
>   */
> @@ -1263,6 +1271,85 @@ static struct vfio_group *find_iommu_group(struct vfio_domain *domain,
>  	return NULL;
>  }
>  
> +static struct vfio_group_object *find_iommu_group_object(
> +		struct vfio_domain *domain, struct iommu_group *iommu_group)
> +{
> +	struct vfio_group_object *g;
> +
> +	list_for_each_entry(g, &domain->group_obj_list, next) {
> +		if (g->iommu_group == iommu_group)
> +			return g;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void vfio_init_iommu_group_object(struct vfio_group_object *group_obj,
> +		struct vfio_domain *domain, struct iommu_group *iommu_group)
> +{
> +	if (!group_obj || !domain || !iommu_group) {
> +		WARN_ON(1);
> +		return;
> +	}

This is poor error handling, either this should never happen or we
should have an error path for it.

> +	atomic_set(&group_obj->count, 1);
> +	group_obj->iommu_group = iommu_group;
> +	group_obj->domain = domain;
> +	list_add(&group_obj->next, &domain->group_obj_list);
> +}
> +
> +static int vfio_domain_attach_group_object(
> +		struct vfio_domain *domain, struct iommu_group *iommu_group)
> +{
> +	struct vfio_group_object *group_obj;
> +
> +	group_obj = find_iommu_group_object(domain, iommu_group);
> +	if (group_obj) {
> +		atomic_inc(&group_obj->count);
> +		return 0;
> +	}
> +	group_obj = kzalloc(sizeof(*group_obj), GFP_KERNEL);

The group_obj test should be here, where we can return an error.

> +	vfio_init_iommu_group_object(group_obj, domain, iommu_group);
> +	return iommu_attach_group(domain->domain, iommu_group);
> +}
> +
> +static int vfio_domain_detach_group_object(
> +		struct vfio_domain *domain, struct iommu_group *iommu_group)

A detach should generally return void, it cannot fail.

> +{
> +	struct vfio_group_object *group_obj;
> +
> +	group_obj = find_iommu_group_object(domain, iommu_group);
> +	if (!group_obj) {
> +		WARN_ON(1);
> +		return -EINVAL;

The WARN is probably appropriate here since this is an internal
consistency failure.

> +	}
> +	if (atomic_dec_if_positive(&group_obj->count) == 0) {
> +		list_del(&group_obj->next);
> +		kfree(group_obj);
> +	}

Like in the previous patch, I don't think this atomic is doing
everything you're intending it to do, the iommu->lock seems more like
it might be the one protecting us here.  If that's true, then we don't
need this to be an atomic.

> +	iommu_detach_group(domain->domain, iommu_group);

How do we get away with detaching the group regardless of the reference
count?!

> +	return 0;
> +}
> +
> +/*
> + * Check if an iommu backed group has been attached to a domain within
> + * a specific container (vfio_iommu). If yes, return the vfio_group_object
> + * which tracks the previous domain attach for this group. Caller of this
> + * function should hold vfio_iommu->lock.
> + */
> +static struct vfio_group_object *vfio_iommu_group_object_check(
> +		struct vfio_iommu *iommu, struct iommu_group *iommu_group)

So vfio_iommu_group_object_check() finds a vfio_group_object anywhere
in the vfio_iommu while find_iommu_group_object() only finds it within
a vfio_domain.  Maybe find_iommu_group_obj_in_domain() vs
find_iommu_group_obj_in_iommu()?

> +{
> +	struct vfio_domain *d;
> +	struct vfio_group_object *group_obj;
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		group_obj = find_iommu_group_object(d, iommu_group);
> +		if (group_obj)
> +			return group_obj;
> +	}
> +	return NULL;
> +}
> +
>  static bool vfio_iommu_has_sw_msi(struct iommu_group *group, phys_addr_t *base)
>  {
>  	struct list_head group_resv_regions;
> @@ -1310,21 +1397,23 @@ static struct device *vfio_mdev_get_iommu_device(struct device *dev)
>  
>  static int vfio_mdev_attach_domain(struct device *dev, void *data)
>  {
> -	struct iommu_domain *domain = data;
> +	struct vfio_domain *domain = data;
>  	struct device *iommu_device;
>  	struct iommu_group *group;
>  
>  	iommu_device = vfio_mdev_get_iommu_device(dev);
>  	if (iommu_device) {
>  		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
> -			return iommu_aux_attach_device(domain, iommu_device);
> +			return iommu_aux_attach_device(domain->domain,
> +							iommu_device);
>  		else {
>  			group = iommu_group_get(iommu_device);
>  			if (!group) {
>  				WARN_ON(1);
>  				return -EINVAL;
>  			}
> -			return iommu_attach_group(domain, group);
> +			return vfio_domain_attach_group_object(
> +							domain, group);
>  		}
>  	}
>  
> @@ -1333,21 +1422,22 @@ static int vfio_mdev_attach_domain(struct device *dev, void *data)
>  
>  static int vfio_mdev_detach_domain(struct device *dev, void *data)
>  {
> -	struct iommu_domain *domain = data;
> +	struct vfio_domain *domain = data;
>  	struct device *iommu_device;
>  	struct iommu_group *group;
>  
>  	iommu_device = vfio_mdev_get_iommu_device(dev);
>  	if (iommu_device) {
>  		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
> -			iommu_aux_detach_device(domain, iommu_device);
> +			iommu_aux_detach_device(domain->domain, iommu_device);
>  		else {
>  			group = iommu_group_get(iommu_device);
>  			if (!group) {
>  				WARN_ON(1);
>  				return -EINVAL;
>  			}
> -			iommu_detach_group(domain, group);
> +			return vfio_domain_detach_group_object(
> +							domain, group);
>  		}
>  	}
>  
> @@ -1359,20 +1449,27 @@ static int vfio_iommu_attach_group(struct vfio_domain *domain,
>  {
>  	if (group->mdev_group)
>  		return iommu_group_for_each_dev(group->iommu_group,
> -						domain->domain,
> +						domain,
>  						vfio_mdev_attach_domain);
>  	else
> -		return iommu_attach_group(domain->domain, group->iommu_group);
> +		return vfio_domain_attach_group_object(domain,
> +							group->iommu_group);
>  }
>  
>  static void vfio_iommu_detach_group(struct vfio_domain *domain,
>  				    struct vfio_group *group)
>  {
> +	int ret;
> +
>  	if (group->mdev_group)
> -		iommu_group_for_each_dev(group->iommu_group, domain->domain,
> +		iommu_group_for_each_dev(group->iommu_group, domain,
>  					 vfio_mdev_detach_domain);
> -	else
> -		iommu_detach_group(domain->domain, group->iommu_group);
> +	else {
> +		ret = vfio_domain_detach_group_object(
> +						domain, group->iommu_group);
> +		if (ret)
> +			pr_warn("%s, deatch failed!! ret: %d", __func__, ret);

Detach cannot fail.

> +	}
>  }
>  
>  static bool vfio_bus_is_mdev(struct bus_type *bus)
> @@ -1412,6 +1509,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	int ret;
>  	bool resv_msi, msi_remap;
>  	phys_addr_t resv_msi_base;
> +	struct vfio_group_object *group_obj = NULL;
> +	struct device *iommu_device = NULL;
> +	struct iommu_group *iommu_device_group;
> +
>  
>  	mutex_lock(&iommu->lock);
>  
> @@ -1438,14 +1539,20 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  
>  	group->iommu_group = iommu_group;
>  
> +	group_obj = vfio_iommu_group_object_check(iommu, group->iommu_group);
> +	if (group_obj) {
> +		atomic_inc(&group_obj->count);
> +		list_add(&group->next, &group_obj->domain->group_list);
> +		mutex_unlock(&iommu->lock);
> +		return 0;

domain is leaked.

> +	}
> +
>  	/* Determine bus_type in order to allocate a domain */
>  	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
>  	if (ret)
>  		goto out_free;
>  
>  	if (vfio_bus_is_mdev(bus)) {
> -		struct device *iommu_device = NULL;
> -
>  		group->mdev_group = true;
>  
>  		/* Determine the isolation type */
> @@ -1469,6 +1576,39 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		bus = iommu_device->bus;
>  	}
>  
> +	/*
> +	 * Check if iommu backed group attached to a domain within current
> +	 * container. If yes, increase the count; If no, go ahead with a
> +	 * new domain attach process.
> +	 */
> +	group_obj = NULL;

How could it be otherwise?

> +	if (iommu_device) {
> +		iommu_device_group = iommu_group_get(iommu_device);
> +		if (!iommu_device_group) {
> +			WARN_ON(1);

No WARN please.

group is leaked.

> +			kfree(domain);
> +			mutex_unlock(&iommu->lock);
> +			return -EINVAL;
> +		}
> +		group_obj = vfio_iommu_group_object_check(iommu,
> +							iommu_device_group);

iommu_device_group reference is elevated.  Thanks,

Alex

> +	} else
> +		group_obj = vfio_iommu_group_object_check(iommu,
> +							group->iommu_group);
> +
> +	if (group_obj) {
> +		atomic_inc(&group_obj->count);
> +		list_add(&group->next, &group_obj->domain->group_list);
> +		kfree(domain);
> +		mutex_unlock(&iommu->lock);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Now we are sure we want to initialize a new vfio_domain.
> +	 * First step is to alloc an iommu_domain from iommu abstract
> +	 * layer.
> +	 */
>  	domain->domain = iommu_domain_alloc(bus);
>  	if (!domain->domain) {
>  		ret = -EIO;
> @@ -1484,6 +1624,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  			goto out_domain;
>  	}
>  
> +	INIT_LIST_HEAD(&domain->group_obj_list);
>  	ret = vfio_iommu_attach_group(domain, group);
>  	if (ret)
>  		goto out_domain;

