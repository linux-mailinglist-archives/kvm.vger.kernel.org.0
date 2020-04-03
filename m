Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD61419DD29
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 19:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404428AbgDCRua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 13:50:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404156AbgDCRu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 13:50:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585936228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zCh+YreaF4Xn0s6javYDJpdlBsNH386gGCKb3InTVK4=;
        b=gGRCOwZOYiRwpBEcQ+sDVuHqS5bqo5ttKXN1TmRyTHE25iIyrBRG304pIxNxUHbB1KGkFc
        gTn1Im2WPDpF6FQW6mKIAzZgc5HCM0udw7dK9HAvCgkVTI+PrNngPgO50kN7idu3RrX8je
        WCgIkW2SfK5opKEe1BmSyajYNs8Xppg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-ezh53N9fO8yZIbe8uSdLEA-1; Fri, 03 Apr 2020 13:50:20 -0400
X-MC-Unique: ezh53N9fO8yZIbe8uSdLEA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C0D7107ACC9;
        Fri,  3 Apr 2020 17:50:18 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 535635E037;
        Fri,  3 Apr 2020 17:50:12 +0000 (UTC)
Date:   Fri, 3 Apr 2020 11:50:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: Re: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Message-ID: <20200403115011.4aba8ff3@w520.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A220B62@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
        <20200402115017.0a0f55e2@w520.home>
        <A2975661238FB949B60364EF0F2C25743A220B62@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 Apr 2020 13:12:50 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, April 3, 2020 1:50 AM
> > Subject: Re: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
> > 
> > On Sun, 22 Mar 2020 05:31:58 -0700
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > From: Liu Yi L <yi.l.liu@intel.com>
> > >
> > > For a long time, devices have only one DMA address space from platform
> > > IOMMU's point of view. This is true for both bare metal and directed-
> > > access in virtualization environment. Reason is the source ID of DMA in
> > > PCIe are BDF (bus/dev/fnc ID), which results in only device granularity
> > > DMA isolation. However, this is changing with the latest advancement in
> > > I/O technology area. More and more platform vendors are utilizing the PCIe
> > > PASID TLP prefix in DMA requests, thus to give devices with multiple DMA
> > > address spaces as identified by their individual PASIDs. For example,
> > > Shared Virtual Addressing (SVA, a.k.a Shared Virtual Memory) is able to
> > > let device access multiple process virtual address space by binding the
> > > virtual address space with a PASID. Wherein the PASID is allocated in
> > > software and programmed to device per device specific manner. Devices
> > > which support PASID capability are called PASID-capable devices. If such
> > > devices are passed through to VMs, guest software are also able to bind
> > > guest process virtual address space on such devices. Therefore, the guest
> > > software could reuse the bare metal software programming model, which
> > > means guest software will also allocate PASID and program it to device
> > > directly. This is a dangerous situation since it has potential PASID
> > > conflicts and unauthorized address space access. It would be safer to
> > > let host intercept in the guest software's PASID allocation. Thus PASID
> > > are managed system-wide.  
> > 
> > Providing an allocation interface only allows for collaborative usage
> > of PASIDs though.  Do we have any ability to enforce PASID usage or can
> > a user spoof other PASIDs on the same BDF?
> >   
> > > This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims to passdown
> > > PASID allocation/free request from the virtual IOMMU. Additionally, such
> > > requests are intended to be invoked by QEMU or other applications which
> > > are running in userspace, it is necessary to have a mechanism to prevent
> > > single application from abusing available PASIDs in system. With such
> > > consideration, this patch tracks the VFIO PASID allocation per-VM. There
> > > was a discussion to make quota to be per assigned devices. e.g. if a VM
> > > has many assigned devices, then it should have more quota. However, it
> > > is not sure how many PASIDs an assigned devices will use. e.g. it is
> > > possible that a VM with multiples assigned devices but requests less
> > > PASIDs. Therefore per-VM quota would be better.
> > >
> > > This patch uses struct mm pointer as a per-VM token. We also considered
> > > using task structure pointer and vfio_iommu structure pointer. However,
> > > task structure is per-thread, which means it cannot achieve per-VM PASID
> > > alloc tracking purpose. While for vfio_iommu structure, it is visible
> > > only within vfio. Therefore, structure mm pointer is selected. This patch
> > > adds a structure vfio_mm. A vfio_mm is created when the first vfio
> > > container is opened by a VM. On the reverse order, vfio_mm is free when
> > > the last vfio container is released. Each VM is assigned with a PASID
> > > quota, so that it is not able to request PASID beyond its quota. This
> > > patch adds a default quota of 1000. This quota could be tuned by
> > > administrator. Making PASID quota tunable will be added in another patch
> > > in this series.
> > >
> > > Previous discussions:
> > > https://patchwork.kernel.org/patch/11209429/
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > ---
> > >  drivers/vfio/vfio.c             | 130 ++++++++++++++++++++++++++++++++++++++++
> > >  drivers/vfio/vfio_iommu_type1.c | 104 ++++++++++++++++++++++++++++++++
> > >  include/linux/vfio.h            |  20 +++++++
> > >  include/uapi/linux/vfio.h       |  41 +++++++++++++
> > >  4 files changed, 295 insertions(+)
> > >
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index c848262..d13b483 100644
> > > --- a/drivers/vfio/vfio.c
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -32,6 +32,7 @@
> > >  #include <linux/vfio.h>
> > >  #include <linux/wait.h>
> > >  #include <linux/sched/signal.h>
> > > +#include <linux/sched/mm.h>
> > >
> > >  #define DRIVER_VERSION	"0.3"
> > >  #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
> > > @@ -46,6 +47,8 @@ static struct vfio {
> > >  	struct mutex			group_lock;
> > >  	struct cdev			group_cdev;
> > >  	dev_t				group_devt;
> > > +	struct list_head		vfio_mm_list;
> > > +	struct mutex			vfio_mm_lock;
> > >  	wait_queue_head_t		release_q;
> > >  } vfio;
> > >
> > > @@ -2129,6 +2132,131 @@ int vfio_unregister_notifier(struct device *dev, enum  
> > vfio_notify_type type,  
> > >  EXPORT_SYMBOL(vfio_unregister_notifier);
> > >
> > >  /**
> > > + * VFIO_MM objects - create, release, get, put, search
> > > + * Caller of the function should have held vfio.vfio_mm_lock.
> > > + */
> > > +static struct vfio_mm *vfio_create_mm(struct mm_struct *mm)
> > > +{
> > > +	struct vfio_mm *vmm;
> > > +	struct vfio_mm_token *token;
> > > +	int ret = 0;
> > > +
> > > +	vmm = kzalloc(sizeof(*vmm), GFP_KERNEL);
> > > +	if (!vmm)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	/* Per mm IOASID set used for quota control and group operations */
> > > +	ret = ioasid_alloc_set((struct ioasid_set *) mm,
> > > +			       VFIO_DEFAULT_PASID_QUOTA, &vmm->ioasid_sid);
> > > +	if (ret) {
> > > +		kfree(vmm);
> > > +		return ERR_PTR(ret);
> > > +	}
> > > +
> > > +	kref_init(&vmm->kref);
> > > +	token = &vmm->token;
> > > +	token->val = mm;
> > > +	vmm->pasid_quota = VFIO_DEFAULT_PASID_QUOTA;
> > > +	mutex_init(&vmm->pasid_lock);
> > > +
> > > +	list_add(&vmm->vfio_next, &vfio.vfio_mm_list);
> > > +
> > > +	return vmm;
> > > +}
> > > +
> > > +static void vfio_mm_unlock_and_free(struct vfio_mm *vmm)
> > > +{
> > > +	/* destroy the ioasid set */
> > > +	ioasid_free_set(vmm->ioasid_sid, true);
> > > +	mutex_unlock(&vfio.vfio_mm_lock);
> > > +	kfree(vmm);
> > > +}
> > > +
> > > +/* called with vfio.vfio_mm_lock held */
> > > +static void vfio_mm_release(struct kref *kref)
> > > +{
> > > +	struct vfio_mm *vmm = container_of(kref, struct vfio_mm, kref);
> > > +
> > > +	list_del(&vmm->vfio_next);
> > > +	vfio_mm_unlock_and_free(vmm);
> > > +}
> > > +
> > > +void vfio_mm_put(struct vfio_mm *vmm)
> > > +{
> > > +	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio.vfio_mm_lock);
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_mm_put);
> > > +
> > > +/* Assume vfio_mm_lock or vfio_mm reference is held */
> > > +static void vfio_mm_get(struct vfio_mm *vmm)
> > > +{
> > > +	kref_get(&vmm->kref);
> > > +}
> > > +
> > > +struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
> > > +{
> > > +	struct mm_struct *mm = get_task_mm(task);
> > > +	struct vfio_mm *vmm;
> > > +	unsigned long long val = (unsigned long long) mm;
> > > +
> > > +	mutex_lock(&vfio.vfio_mm_lock);
> > > +	list_for_each_entry(vmm, &vfio.vfio_mm_list, vfio_next) {
> > > +		if (vmm->token.val == val) {
> > > +			vfio_mm_get(vmm);
> > > +			goto out;
> > > +		}
> > > +	}
> > > +
> > > +	vmm = vfio_create_mm(mm);
> > > +	if (IS_ERR(vmm))
> > > +		vmm = NULL;
> > > +out:
> > > +	mutex_unlock(&vfio.vfio_mm_lock);
> > > +	mmput(mm);
> > > +	return vmm;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
> > > +
> > > +int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max)
> > > +{
> > > +	ioasid_t pasid;
> > > +	int ret = -ENOSPC;
> > > +
> > > +	mutex_lock(&vmm->pasid_lock);
> > > +
> > > +	pasid = ioasid_alloc(vmm->ioasid_sid, min, max, NULL);
> > > +	if (pasid == INVALID_IOASID) {
> > > +		ret = -ENOSPC;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	ret = pasid;
> > > +out_unlock:
> > > +	mutex_unlock(&vmm->pasid_lock);
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_mm_pasid_alloc);
> > > +
> > > +int vfio_mm_pasid_free(struct vfio_mm *vmm, ioasid_t pasid)
> > > +{
> > > +	void *pdata;
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&vmm->pasid_lock);
> > > +	pdata = ioasid_find(vmm->ioasid_sid, pasid, NULL);
> > > +	if (IS_ERR(pdata)) {
> > > +		ret = PTR_ERR(pdata);
> > > +		goto out_unlock;
> > > +	}
> > > +	ioasid_free(pasid);
> > > +
> > > +out_unlock:
> > > +	mutex_unlock(&vmm->pasid_lock);
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_mm_pasid_free);
> > > +
> > > +/**
> > >   * Module/class support
> > >   */
> > >  static char *vfio_devnode(struct device *dev, umode_t *mode)
> > > @@ -2151,8 +2279,10 @@ static int __init vfio_init(void)
> > >  	idr_init(&vfio.group_idr);
> > >  	mutex_init(&vfio.group_lock);
> > >  	mutex_init(&vfio.iommu_drivers_lock);
> > > +	mutex_init(&vfio.vfio_mm_lock);
> > >  	INIT_LIST_HEAD(&vfio.group_list);
> > >  	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
> > > +	INIT_LIST_HEAD(&vfio.vfio_mm_list);
> > >  	init_waitqueue_head(&vfio.release_q);
> > >
> > >  	ret = misc_register(&vfio_dev);  
> > 
> > Is vfio.c the right place for any of the above?  It seems like it could
> > all be in a separate vfio_pasid module, similar to our virqfd module.  
> 
> I think it could be a separate vfio_pasid module. let me make it in next
> version if it's your preference. :-)
> 
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > index a177bf2..331ceee 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -70,6 +70,7 @@ struct vfio_iommu {
> > >  	unsigned int		dma_avail;
> > >  	bool			v2;
> > >  	bool			nesting;
> > > +	struct vfio_mm		*vmm;
> > >  };
> > >
> > >  struct vfio_domain {
> > > @@ -2018,6 +2019,7 @@ static void vfio_iommu_type1_detach_group(void  
> > *iommu_data,  
> > >  static void *vfio_iommu_type1_open(unsigned long arg)
> > >  {
> > >  	struct vfio_iommu *iommu;
> > > +	struct vfio_mm *vmm = NULL;
> > >
> > >  	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
> > >  	if (!iommu)
> > > @@ -2043,6 +2045,10 @@ static void *vfio_iommu_type1_open(unsigned long  
> > arg)  
> > >  	iommu->dma_avail = dma_entry_limit;
> > >  	mutex_init(&iommu->lock);
> > >  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
> > > +	vmm = vfio_mm_get_from_task(current);
> > > +	if (!vmm)
> > > +		pr_err("Failed to get vfio_mm track\n");  
> > 
> > Doesn't this presume everyone is instantly running PASID capable hosts?
> > Looks like a noisy support regression to me.  
> 
> right, it is. Kevin also questioned this part, I'll refine it and avoid
> regression noisy.
> 
> > > +	iommu->vmm = vmm;
> > >
> > >  	return iommu;
> > >  }
> > > @@ -2084,6 +2090,8 @@ static void vfio_iommu_type1_release(void  
> > *iommu_data)  
> > >  	}
> > >
> > >  	vfio_iommu_iova_free(&iommu->iova_list);
> > > +	if (iommu->vmm)
> > > +		vfio_mm_put(iommu->vmm);
> > >
> > >  	kfree(iommu);
> > >  }
> > > @@ -2172,6 +2180,55 @@ static int vfio_iommu_iova_build_caps(struct  
> > vfio_iommu *iommu,  
> > >  	return ret;
> > >  }
> > >
> > > +static bool vfio_iommu_type1_pasid_req_valid(u32 flags)
> > > +{
> > > +	return !((flags & ~VFIO_PASID_REQUEST_MASK) ||
> > > +		 (flags & VFIO_IOMMU_PASID_ALLOC &&
> > > +		  flags & VFIO_IOMMU_PASID_FREE));
> > > +}
> > > +
> > > +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
> > > +					 int min,
> > > +					 int max)
> > > +{
> > > +	struct vfio_mm *vmm = iommu->vmm;
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&iommu->lock);
> > > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > +		ret = -EFAULT;
> > > +		goto out_unlock;
> > > +	}  
> > 
> > Non-iommu backed mdevs are excluded from this?  Is this a matter of
> > wiring the call out through the mdev parent device, or is this just
> > possible?  
> 
> At the beginning, non-iommu backed mdevs are excluded. However,
> Combined with your succeeded comment. I think this check should be
> removed as the PASID alloc/free capability should be available as
> long as the container is backed by a pasid-capable iommu backend.
> So should remove it, and it is the same with the free path.
> 
> >   
> > > +	if (vmm)
> > > +		ret = vfio_mm_pasid_alloc(vmm, min, max);
> > > +	else
> > > +		ret = -EINVAL;
> > > +out_unlock:
> > > +	mutex_unlock(&iommu->lock);
> > > +	return ret;
> > > +}
> > > +
> > > +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
> > > +				       unsigned int pasid)
> > > +{
> > > +	struct vfio_mm *vmm = iommu->vmm;
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&iommu->lock);
> > > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > +		ret = -EFAULT;
> > > +		goto out_unlock;
> > > +	}  
> > 
> > So if a container had an iommu backed device when the pasid was
> > allocated, but it was removed, now they can't free it?  Why do we need
> > the check above?  
> 
> should be removed. thanks for spotting it.
> 
> > > +
> > > +	if (vmm)
> > > +		ret = vfio_mm_pasid_free(vmm, pasid);
> > > +	else
> > > +		ret = -EINVAL;
> > > +out_unlock:
> > > +	mutex_unlock(&iommu->lock);
> > > +	return ret;
> > > +}
> > > +
> > >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> > >  				   unsigned int cmd, unsigned long arg)
> > >  {
> > > @@ -2276,6 +2333,53 @@ static long vfio_iommu_type1_ioctl(void  
> > *iommu_data,  
> > >
> > >  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> > >  			-EFAULT : 0;
> > > +
> > > +	} else if (cmd == VFIO_IOMMU_PASID_REQUEST) {
> > > +		struct vfio_iommu_type1_pasid_request req;
> > > +		unsigned long offset;
> > > +
> > > +		minsz = offsetofend(struct vfio_iommu_type1_pasid_request,
> > > +				    flags);
> > > +
> > > +		if (copy_from_user(&req, (void __user *)arg, minsz))
> > > +			return -EFAULT;
> > > +
> > > +		if (req.argsz < minsz ||
> > > +		    !vfio_iommu_type1_pasid_req_valid(req.flags))
> > > +			return -EINVAL;
> > > +
> > > +		if (copy_from_user((void *)&req + minsz,
> > > +				   (void __user *)arg + minsz,
> > > +				   sizeof(req) - minsz))
> > > +			return -EFAULT;  
> > 
> > Huh?  Why do we have argsz if we're going to assume this is here?  
> 
> do you mean replacing sizeof(req) with argsz? if yes, I can do that.

No, I mean the user tells us how much data they've provided via argsz.
We create minsz the the end of flags and verify argsz includes flags.
Then we proceed to ignore argsz to see if the user has provided the
remainder of the structure.
 
> > > +
> > > +		switch (req.flags & VFIO_PASID_REQUEST_MASK) {
> > > +		case VFIO_IOMMU_PASID_ALLOC:
> > > +		{
> > > +			int ret = 0, result;
> > > +
> > > +			result = vfio_iommu_type1_pasid_alloc(iommu,
> > > +							req.alloc_pasid.min,
> > > +							req.alloc_pasid.max);
> > > +			if (result > 0) {
> > > +				offset = offsetof(
> > > +					struct vfio_iommu_type1_pasid_request,
> > > +					alloc_pasid.result);
> > > +				ret = copy_to_user(
> > > +					      (void __user *) (arg + offset),
> > > +					      &result, sizeof(result));  
> > 
> > Again assuming argsz supports this.  
> 
> same as above.
> 
> >   
> > > +			} else {
> > > +				pr_debug("%s: PASID alloc failed\n", __func__);  
> > 
> > rate limit?  
> 
> not quite get. could you give more hints?

A user can spam the host logs simply by allocating their quota of
PASIDs and then trying to allocate more, or by specifying min/max such
that they cannot allocate the requested PASID.  If this logging is
necessary for debugging, it should be ratelimited to avoid a DoS on the
host.

> > > +				ret = -EFAULT;
> > > +			}
> > > +			return ret;
> > > +		}
> > > +		case VFIO_IOMMU_PASID_FREE:
> > > +			return vfio_iommu_type1_pasid_free(iommu,
> > > +							   req.free_pasid);
> > > +		default:
> > > +			return -EINVAL;
> > > +		}
> > >  	}
> > >
> > >  	return -ENOTTY;
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index e42a711..75f9f7f1 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -89,6 +89,26 @@ extern int vfio_register_iommu_driver(const struct  
> > vfio_iommu_driver_ops *ops);  
> > >  extern void vfio_unregister_iommu_driver(
> > >  				const struct vfio_iommu_driver_ops *ops);
> > >
> > > +#define VFIO_DEFAULT_PASID_QUOTA	1000
> > > +struct vfio_mm_token {
> > > +	unsigned long long val;
> > > +};
> > > +
> > > +struct vfio_mm {
> > > +	struct kref			kref;
> > > +	struct vfio_mm_token		token;
> > > +	int				ioasid_sid;
> > > +	/* protect @pasid_quota field and pasid allocation/free */
> > > +	struct mutex			pasid_lock;
> > > +	int				pasid_quota;
> > > +	struct list_head		vfio_next;
> > > +};
> > > +
> > > +extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
> > > +extern void vfio_mm_put(struct vfio_mm *vmm);
> > > +extern int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max);
> > > +extern int vfio_mm_pasid_free(struct vfio_mm *vmm, ioasid_t pasid);
> > > +
> > >  /*
> > >   * External user API
> > >   */
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index 9e843a1..298ac80 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -794,6 +794,47 @@ struct vfio_iommu_type1_dma_unmap {
> > >  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
> > >  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
> > >
> > > +/*
> > > + * PASID (Process Address Space ID) is a PCIe concept which
> > > + * has been extended to support DMA isolation in fine-grain.
> > > + * With device assigned to user space (e.g. VMs), PASID alloc
> > > + * and free need to be system wide. This structure defines
> > > + * the info for pasid alloc/free between user space and kernel
> > > + * space.
> > > + *
> > > + * @flag=VFIO_IOMMU_PASID_ALLOC, refer to the @alloc_pasid
> > > + * @flag=VFIO_IOMMU_PASID_FREE, refer to @free_pasid
> > > + */
> > > +struct vfio_iommu_type1_pasid_request {
> > > +	__u32	argsz;
> > > +#define VFIO_IOMMU_PASID_ALLOC	(1 << 0)
> > > +#define VFIO_IOMMU_PASID_FREE	(1 << 1)
> > > +	__u32	flags;
> > > +	union {
> > > +		struct {
> > > +			__u32 min;
> > > +			__u32 max;
> > > +			__u32 result;
> > > +		} alloc_pasid;
> > > +		__u32 free_pasid;
> > > +	};  
> > 
> > We seem to be using __u8 data[] lately where the struct at data is
> > defined by the flags.  should we do that here?  
> 
> yeah, I can do that. BTW. Do you want to let the structure in the
> lately patch share the same structure with this one? As I can foresee,
> the two structures would look like similar as both of them include
> argsz, flags and data[] fields. The difference is the definition of
> flags. what about your opinion?
> 
> struct vfio_iommu_type1_pasid_request {
> 	__u32	argsz;
> #define VFIO_IOMMU_PASID_ALLOC	(1 << 0)
> #define VFIO_IOMMU_PASID_FREE	(1 << 1)
> 	__u32	flags;
> 	__u8	data[];
> };
> 
> struct vfio_iommu_type1_bind {
>         __u32           argsz;
>         __u32           flags;
> #define VFIO_IOMMU_BIND_GUEST_PGTBL     (1 << 0)
> #define VFIO_IOMMU_UNBIND_GUEST_PGTBL   (1 << 1)
>         __u8            data[];
> };


Yes, I was even wondering the same for the cache invalidate ioctl, or
whether this is going too far for a general purpose "everything related
to PASIDs" ioctl.  We need to factor usability into the equation too.
I'd be interested in opinions from others here too.  Clearly I don't
like single use, throw-away ioctls, but I can find myself on either
side of the argument that allocation, binding, and invalidating are all
within the domain of PASIDs and could fall within a single ioctl or
they each represent different facets of managing PASIDs and should have
separate ioctls.  Thanks,

Alex


> > > +};
> > > +
> > > +#define VFIO_PASID_REQUEST_MASK	(VFIO_IOMMU_PASID_ALLOC | \
> > > +					 VFIO_IOMMU_PASID_FREE)
> > > +
> > > +/**
> > > + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 22,
> > > + *				struct vfio_iommu_type1_pasid_request)
> > > + *
> > > + * Availability of this feature depends on PASID support in the device,
> > > + * its bus, the underlying IOMMU and the CPU architecture. In VFIO, it
> > > + * is available after VFIO_SET_IOMMU.
> > > + *
> > > + * returns: 0 on success, -errno on failure.
> > > + */
> > > +#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 22)  
> > 
> > So a user needs to try to allocate a PASID in order to test for the
> > support?  Should we have a PROBE flag?  
> 
> answered in in later patch. :-)
> 
> Regards,
> Yi Liu
> 

