Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281D614D423
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgA2Xz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:55:57 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43083 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbgA2Xz5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jan 2020 18:55:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580342156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qV89/l8G+V4GYBMe3l4zOrnn5knbqGRbWPPV4pEneSU=;
        b=gVXH1P3LEgV/Cj5XiTIfE4/OFCrXWJ4zKEPSKOpJcJtWTGlSehaEdi9AhrN4Hxvv8lW48a
        cJ0n4rg4WX1X+wwvDKGO06WDqTf6RbEERrvFPvGq3SiKo9ZN22rrEFWT4SHgOfTxg99Nft
        sYi8Kgpd7YDD+/f+B49LV1FgAyJoUVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-g5xtSjklM6ur6pFwGRST8A-1; Wed, 29 Jan 2020 18:55:50 -0500
X-MC-Unique: g5xtSjklM6ur6pFwGRST8A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2A618005B8;
        Wed, 29 Jan 2020 23:55:48 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6871F77935;
        Wed, 29 Jan 2020 23:55:42 +0000 (UTC)
Date:   Wed, 29 Jan 2020 16:55:40 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, joro@8bytes.org,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Message-ID: <20200129165540.335774d5@w520.home>
In-Reply-To: <1580299912-86084-2-git-send-email-yi.l.liu@intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
        <1580299912-86084-2-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jan 2020 04:11:45 -0800
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> From: Liu Yi L <yi.l.liu@intel.com>
> 
> For a long time, devices have only one DMA address space from platform
> IOMMU's point of view. This is true for both bare metal and directed-
> access in virtualization environment. Reason is the source ID of DMA in
> PCIe are BDF (bus/dev/fnc ID), which results in only device granularity
> DMA isolation. However, this is changing with the latest advancement of
> I/O technology. More and more platform vendors are utilizing the PCIe
> PASID TLP prefix in DMA requests, thus to give devices with multiple DMA
> address spaces as identified by their individual PASIDs. For example,
> Shared Virtual Addressing (SVA, a.k.a Shared Virtual Memory) is able to
> let device access multiple process virtual address space by binding the
> virtual address space with a PASID. Wherein the PASID is allocated in
> software and programmed to device per device specific manner. Devices
> which support PASID capability are called PASID-capable devices. If such
> devices are passed through to VMs, guest software are also able to bind
> guest process virtual address space on such devices. Therefore, the guest
> software could reuse the bare metal software programming model, which
> means guest software will also allocate PASID and program it to device
> directly. This is a dangerous situation since it has potential PASID
> conflicts and unauthorized address space access. It would be safer to
> let host intercept in the guest software's PASID allocation. Thus PASID
> are managed system-wide.
> 
> This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims to passdown
> PASID allocation/free request from the virtual IOMMU. Additionally, such
> requests are intended to be invoked by QEMU or other applications which
> are running in userspace, it is necessary to have a mechanism to prevent
> single application from abusing available PASIDs in system. With such
> consideration, this patch tracks the VFIO PASID allocation per-VM. There
> was a discussion to make quota to be per assigned devices. e.g. if a VM
> has many assigned devices, then it should have more quota. However, it
> is not sure how many PASIDs an assigned devices will use. e.g. it is
> possible that a VM with multiples assigned devices but requests less
> PASIDs. Therefore per-VM quota would be better.
> 
> This patch uses struct mm pointer as a per-VM token. We also considered
> using task structure pointer and vfio_iommu structure pointer. However,
> task structure is per-thread, which means it cannot achieve per-VM PASID
> alloc tracking purpose. While for vfio_iommu structure, it is visible
> only within vfio. Therefore, structure mm pointer is selected. This patch
> adds a structure vfio_mm. A vfio_mm is created when the first vfio
> container is opened by a VM. On the reverse order, vfio_mm is free when
> the last vfio container is released. Each VM is assigned with a PASID
> quota, so that it is not able to request PASID beyond its quota. This
> patch adds a default quota of 1000. This quota could be tuned by
> administrator. Making PASID quota tunable will be added in another patch
> in this series.
> 
> Previous discussions:
> https://patchwork.kernel.org/patch/11209429/
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/vfio/vfio.c             | 125 ++++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c |  92 +++++++++++++++++++++++++++++
>  include/linux/vfio.h            |  15 +++++
>  include/uapi/linux/vfio.h       |  41 +++++++++++++
>  4 files changed, 273 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index c848262..c43c757 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -32,6 +32,7 @@
>  #include <linux/vfio.h>
>  #include <linux/wait.h>
>  #include <linux/sched/signal.h>
> +#include <linux/sched/mm.h>
>  
>  #define DRIVER_VERSION	"0.3"
>  #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
> @@ -46,6 +47,8 @@ static struct vfio {
>  	struct mutex			group_lock;
>  	struct cdev			group_cdev;
>  	dev_t				group_devt;
> +	struct list_head		vfio_mm_list;
> +	struct mutex			vfio_mm_lock;
>  	wait_queue_head_t		release_q;
>  } vfio;
>  
> @@ -2129,6 +2132,126 @@ int vfio_unregister_notifier(struct device *dev, enum vfio_notify_type type,
>  EXPORT_SYMBOL(vfio_unregister_notifier);
>  
>  /**
> + * VFIO_MM objects - create, release, get, put, search
> + * Caller of the function should have held vfio.vfio_mm_lock.
> + */
> +static struct vfio_mm *vfio_create_mm(struct mm_struct *mm)
> +{
> +	struct vfio_mm *vmm;
> +
> +	vmm = kzalloc(sizeof(*vmm), GFP_KERNEL);
> +	if (!vmm)
> +		return ERR_PTR(-ENOMEM);
> +
> +	kref_init(&vmm->kref);
> +	vmm->mm = mm;
> +	vmm->pasid_quota = VFIO_DEFAULT_PASID_QUOTA;
> +	vmm->pasid_count = 0;
> +	mutex_init(&vmm->pasid_lock);
> +
> +	list_add(&vmm->vfio_next, &vfio.vfio_mm_list);
> +
> +	return vmm;
> +}
> +
> +static void vfio_mm_unlock_and_free(struct vfio_mm *vmm)
> +{
> +	mutex_unlock(&vfio.vfio_mm_lock);
> +	kfree(vmm);
> +}
> +
> +/* called with vfio.vfio_mm_lock held */
> +static void vfio_mm_release(struct kref *kref)
> +{
> +	struct vfio_mm *vmm = container_of(kref, struct vfio_mm, kref);
> +
> +	list_del(&vmm->vfio_next);
> +	vfio_mm_unlock_and_free(vmm);
> +}
> +
> +void vfio_mm_put(struct vfio_mm *vmm)
> +{
> +	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio.vfio_mm_lock);
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_put);
> +
> +/* Assume vfio_mm_lock or vfio_mm reference is held */
> +static void vfio_mm_get(struct vfio_mm *vmm)
> +{
> +	kref_get(&vmm->kref);
> +}
> +
> +struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
> +{
> +	struct mm_struct *mm = get_task_mm(task);
> +	struct vfio_mm *vmm;
> +
> +	mutex_lock(&vfio.vfio_mm_lock);
> +	list_for_each_entry(vmm, &vfio.vfio_mm_list, vfio_next) {
> +		if (vmm->mm == mm) {
> +			vfio_mm_get(vmm);
> +			goto out;
> +		}
> +	}
> +
> +	vmm = vfio_create_mm(mm);
> +	if (IS_ERR(vmm))
> +		vmm = NULL;
> +out:
> +	mutex_unlock(&vfio.vfio_mm_lock);
> +	mmput(mm);
> +	return vmm;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
> +
> +int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max)
> +{
> +	ioasid_t pasid;
> +	int ret = -ENOSPC;
> +
> +	mutex_lock(&vmm->pasid_lock);
> +	if (vmm->pasid_count >= vmm->pasid_quota) {
> +		ret = -ENOSPC;
> +		goto out_unlock;
> +	}
> +	/* Track ioasid allocation owner by mm */
> +	pasid = ioasid_alloc((struct ioasid_set *)vmm->mm, min,
> +				max, NULL);

Is mm effectively only a token for this?  Maybe we should have a struct
vfio_mm_token since gets and puts are not creating a reference to an
mm, but to an "mm token".

> +	if (pasid == INVALID_IOASID) {
> +		ret = -ENOSPC;
> +		goto out_unlock;
> +	}
> +	vmm->pasid_count++;
> +
> +	ret = pasid;
> +out_unlock:
> +	mutex_unlock(&vmm->pasid_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_pasid_alloc);
> +
> +int vfio_mm_pasid_free(struct vfio_mm *vmm, ioasid_t pasid)
> +{
> +	void *pdata;
> +	int ret = 0;
> +
> +	mutex_lock(&vmm->pasid_lock);
> +	pdata = ioasid_find((struct ioasid_set *)vmm->mm,
> +				pasid, NULL);
> +	if (IS_ERR(pdata)) {
> +		ret = PTR_ERR(pdata);
> +		goto out_unlock;
> +	}
> +	ioasid_free(pasid);
> +
> +	vmm->pasid_count--;
> +out_unlock:
> +	mutex_unlock(&vmm->pasid_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_pasid_free);
> +
> +/**
>   * Module/class support
>   */
>  static char *vfio_devnode(struct device *dev, umode_t *mode)
> @@ -2151,8 +2274,10 @@ static int __init vfio_init(void)
>  	idr_init(&vfio.group_idr);
>  	mutex_init(&vfio.group_lock);
>  	mutex_init(&vfio.iommu_drivers_lock);
> +	mutex_init(&vfio.vfio_mm_lock);
>  	INIT_LIST_HEAD(&vfio.group_list);
>  	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
> +	INIT_LIST_HEAD(&vfio.vfio_mm_list);
>  	init_waitqueue_head(&vfio.release_q);
>  
>  	ret = misc_register(&vfio_dev);
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 2ada8e6..e836d04 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -70,6 +70,7 @@ struct vfio_iommu {
>  	unsigned int		dma_avail;
>  	bool			v2;
>  	bool			nesting;
> +	struct vfio_mm		*vmm;
>  };
>  
>  struct vfio_domain {
> @@ -2039,6 +2040,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  static void *vfio_iommu_type1_open(unsigned long arg)
>  {
>  	struct vfio_iommu *iommu;
> +	struct vfio_mm *vmm = NULL;
>  
>  	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
>  	if (!iommu)
> @@ -2064,6 +2066,10 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	iommu->dma_avail = dma_entry_limit;
>  	mutex_init(&iommu->lock);
>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
> +	vmm = vfio_mm_get_from_task(current);

So the token (if I'm right about the usage above) is the mm of the
process that calls VFIO_SET_IOMMU on the container.

> +	if (!vmm)
> +		pr_err("Failed to get vfio_mm track\n");
> +	iommu->vmm = vmm;
>  
>  	return iommu;
>  }
> @@ -2105,6 +2111,8 @@ static void vfio_iommu_type1_release(void *iommu_data)
>  	}
>  
>  	vfio_iommu_iova_free(&iommu->iova_list);
> +	if (iommu->vmm)
> +		vfio_mm_put(iommu->vmm);
>  
>  	kfree(iommu);
>  }
> @@ -2193,6 +2201,48 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
> +					 int min,
> +					 int max)
> +{
> +	struct vfio_mm *vmm = iommu->vmm;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +	if (vmm)
> +		ret = vfio_mm_pasid_alloc(vmm, min, max);
> +	else
> +		ret = -ENOSPC;

vfio_mm_pasid_alloc() can return -ENOSPC though, so it'd be nice to
differentiate the errors.  We could use EFAULT for the no IOMMU case
and EINVAL here?

> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
> +				       unsigned int pasid)
> +{
> +	struct vfio_mm *vmm = iommu->vmm;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {

But we could have been IOMMU backed when the pasid was allocated, did
we just leak something?  In fact, I didn't spot anything in this series
that handles a container with pasids allocated losing iommu backing.
I'd think we want to release all pasids when that happens since
permission for the user to hold pasids goes along with having an iommu
backed device.  Also, do we want _free() paths that can fail?

> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	if (vmm)
> +		ret = vfio_mm_pasid_free(vmm, pasid);
> +	else
> +		ret = -ENOSPC;
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2297,6 +2347,48 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  
>  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>  			-EFAULT : 0;
> +
> +	} else if (cmd == VFIO_IOMMU_PASID_REQUEST) {
> +		struct vfio_iommu_type1_pasid_request req;
> +		u32 min, max, pasid;
> +		int ret, result;
> +		unsigned long offset;
> +
> +		offset = offsetof(struct vfio_iommu_type1_pasid_request,
> +				  alloc_pasid.result);
> +		minsz = offsetofend(struct vfio_iommu_type1_pasid_request,
> +				    flags);
> +
> +		if (copy_from_user(&req, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (req.argsz < minsz)
> +			return -EINVAL;

req.flags needs to be sanitized, if a user provides flags we don't
understand or combinations of flags that aren't supported, we should
return an error (ex. ALLOC | FREE should not do alloc w/o free or free
w/o alloc, it should just error).

> +
> +		switch (req.flags & VFIO_PASID_REQUEST_MASK) {
> +		case VFIO_IOMMU_PASID_ALLOC:
> +			if (copy_from_user(&min,
> +				(void __user *)arg + minsz, sizeof(min)))
> +				return -EFAULT;
> +			if (copy_from_user(&max,
> +				(void __user *)arg + minsz + sizeof(min),
> +				sizeof(max)))
> +				return -EFAULT;

Why not just copy the fields into req in one go?

> +			ret = 0;
> +			result = vfio_iommu_type1_pasid_alloc(iommu, min, max);
> +			if (result > 0)
> +				ret = copy_to_user(
> +					      (void __user *) (arg + offset),
> +					      &result, sizeof(result));

The result is an int, ioctl(2) returns an int... why do we need to
return the result in the structure?

> +			return ret;
> +		case VFIO_IOMMU_PASID_FREE:
> +			if (copy_from_user(&pasid,
> +				(void __user *)arg + minsz, sizeof(pasid)))
> +				return -EFAULT;

Same here, we don't need a separate pasid variable, use the one in req.

> +			return vfio_iommu_type1_pasid_free(iommu, pasid);
> +		default:
> +			return -EINVAL;
> +		}
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e42a711..b6c9c8c 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -89,6 +89,21 @@ extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
>  extern void vfio_unregister_iommu_driver(
>  				const struct vfio_iommu_driver_ops *ops);
>  
> +#define VFIO_DEFAULT_PASID_QUOTA	1000
> +struct vfio_mm {
> +	struct kref			kref;
> +	struct mutex			pasid_lock;
> +	int				pasid_quota;
> +	int				pasid_count;
> +	struct mm_struct		*mm;
> +	struct list_head		vfio_next;
> +};
> +
> +extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
> +extern void vfio_mm_put(struct vfio_mm *vmm);
> +extern int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max);
> +extern int vfio_mm_pasid_free(struct vfio_mm *vmm, ioasid_t pasid);
> +
>  /*
>   * External user API
>   */
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9e843a1..298ac80 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -794,6 +794,47 @@ struct vfio_iommu_type1_dma_unmap {
>  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
>  
> +/*
> + * PASID (Process Address Space ID) is a PCIe concept which
> + * has been extended to support DMA isolation in fine-grain.
> + * With device assigned to user space (e.g. VMs), PASID alloc
> + * and free need to be system wide. This structure defines
> + * the info for pasid alloc/free between user space and kernel
> + * space.
> + *
> + * @flag=VFIO_IOMMU_PASID_ALLOC, refer to the @alloc_pasid
> + * @flag=VFIO_IOMMU_PASID_FREE, refer to @free_pasid
> + */
> +struct vfio_iommu_type1_pasid_request {
> +	__u32	argsz;
> +#define VFIO_IOMMU_PASID_ALLOC	(1 << 0)
> +#define VFIO_IOMMU_PASID_FREE	(1 << 1)
> +	__u32	flags;
> +	union {
> +		struct {
> +			__u32 min;
> +			__u32 max;
> +			__u32 result;
> +		} alloc_pasid;
> +		__u32 free_pasid;
> +	};
> +};
> +
> +#define VFIO_PASID_REQUEST_MASK	(VFIO_IOMMU_PASID_ALLOC | \
> +					 VFIO_IOMMU_PASID_FREE)
> +
> +/**
> + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 22,
> + *				struct vfio_iommu_type1_pasid_request)
> + *
> + * Availability of this feature depends on PASID support in the device,
> + * its bus, the underlying IOMMU and the CPU architecture. In VFIO, it
> + * is available after VFIO_SET_IOMMU.

Assuming the IOMMU backend supports it.  How does a user determine
that?  Allocating a PASID just to see if they can doesn't seem like a
good approach.  We have a VFIO_IOMMU_GET_INFO ioctl.  Thanks,

Alex

> + *
> + * returns: 0 on success, -errno on failure.
> + */
> +#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 22)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

