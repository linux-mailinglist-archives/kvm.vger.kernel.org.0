Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7895019CAAF
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 21:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388502AbgDBT5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 15:57:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51178 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733205AbgDBT5Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 15:57:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585857434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RxyoZsi9Tn8jWziDAMFiYcGYLKriOIyoSHN1gbJsJzs=;
        b=UidUd81qqJ+6OufmiNf5Z8NHVxIUeOyWlBtTnU/mOxdNqGRFqh1JRgV2WN1MW9UMzHGnBT
        ZNbTtLOBQMuoq5lu0Ys2NvMB2v+VK+xnvOpH1n6+TlFA/sU6rngIl/SJu0hNP/r7We1+BH
        pMeT8SjuDoViCaO4ropItH1CTqE+JTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-ZZW0JrYzMsWT_D_Z6zHGUA-1; Thu, 02 Apr 2020 15:57:09 -0400
X-MC-Unique: ZZW0JrYzMsWT_D_Z6zHGUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5F32107ACCA;
        Thu,  2 Apr 2020 19:57:07 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 321BE1001B09;
        Thu,  2 Apr 2020 19:57:01 +0000 (UTC)
Date:   Thu, 2 Apr 2020 13:57:00 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, joro@8bytes.org,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hao.wu@intel.com
Subject: Re: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
Message-ID: <20200402135700.0da30021@w520.home>
In-Reply-To: <1584880325-10561-7-git-send-email-yi.l.liu@intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-7-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 Mar 2020 05:32:03 -0700
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> From: Liu Yi L <yi.l.liu@intel.com>
> 
> VFIO_TYPE1_NESTING_IOMMU is an IOMMU type which is backed by hardware
> IOMMUs that have nesting DMA translation (a.k.a dual stage address
> translation). For such hardware IOMMUs, there are two stages/levels of
> address translation, and software may let userspace/VM to own the first-
> level/stage-1 translation structures. Example of such usage is vSVA (
> virtual Shared Virtual Addressing). VM owns the first-level/stage-1
> translation structures and bind the structures to host, then hardware
> IOMMU would utilize nesting translation when doing DMA translation fo
> the devices behind such hardware IOMMU.
> 
> This patch adds vfio support for binding guest translation (a.k.a stage 1)
> structure to host iommu. And for VFIO_TYPE1_NESTING_IOMMU, not only bind
> guest page table is needed, it also requires to expose interface to guest
> for iommu cache invalidation when guest modified the first-level/stage-1
> translation structures since hardware needs to be notified to flush stale
> iotlbs. This would be introduced in next patch.
> 
> In this patch, guest page table bind and unbind are done by using flags
> VFIO_IOMMU_BIND_GUEST_PGTBL and VFIO_IOMMU_UNBIND_GUEST_PGTBL under IOCTL
> VFIO_IOMMU_BIND, the bind/unbind data are conveyed by
> struct iommu_gpasid_bind_data. Before binding guest page table to host,
> VM should have got a PASID allocated by host via VFIO_IOMMU_PASID_REQUEST.
> 
> Bind guest translation structures (here is guest page table) to host
> are the first step to setup vSVA (Virtual Shared Virtual Addressing).
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 158 ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  46 ++++++++++++
>  2 files changed, 204 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 82a9e0b..a877747 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -130,6 +130,33 @@ struct vfio_regions {
>  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
>  					(!list_empty(&iommu->domain_list))
>  
> +struct domain_capsule {
> +	struct iommu_domain *domain;
> +	void *data;
> +};
> +
> +/* iommu->lock must be held */
> +static int vfio_iommu_for_each_dev(struct vfio_iommu *iommu,
> +		      int (*fn)(struct device *dev, void *data),
> +		      void *data)
> +{
> +	struct domain_capsule dc = {.data = data};
> +	struct vfio_domain *d;
> +	struct vfio_group *g;
> +	int ret = 0;
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		dc.domain = d->domain;
> +		list_for_each_entry(g, &d->group_list, next) {
> +			ret = iommu_group_for_each_dev(g->iommu_group,
> +						       &dc, fn);
> +			if (ret)
> +				break;
> +		}
> +	}
> +	return ret;
> +}
> +
>  static int put_pfn(unsigned long pfn, int prot);
>  
>  /*
> @@ -2314,6 +2341,88 @@ static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
>  	return 0;
>  }
>  
> +static int vfio_bind_gpasid_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	struct iommu_gpasid_bind_data *gbind_data =
> +		(struct iommu_gpasid_bind_data *) dc->data;
> +
> +	return iommu_sva_bind_gpasid(dc->domain, dev, gbind_data);
> +}
> +
> +static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	struct iommu_gpasid_bind_data *gbind_data =
> +		(struct iommu_gpasid_bind_data *) dc->data;
> +
> +	return iommu_sva_unbind_gpasid(dc->domain, dev,
> +					gbind_data->hpasid);
> +}
> +
> +/**
> + * Unbind specific gpasid, caller of this function requires hold
> + * vfio_iommu->lock
> + */
> +static long vfio_iommu_type1_do_guest_unbind(struct vfio_iommu *iommu,
> +				struct iommu_gpasid_bind_data *gbind_data)
> +{
> +	return vfio_iommu_for_each_dev(iommu,
> +				vfio_unbind_gpasid_fn, gbind_data);
> +}
> +
> +static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
> +				struct iommu_gpasid_bind_data *gbind_data)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	ret = vfio_iommu_for_each_dev(iommu,
> +			vfio_bind_gpasid_fn, gbind_data);
> +	/*
> +	 * If bind failed, it may not be a total failure. Some devices
> +	 * within the iommu group may have bind successfully. Although
> +	 * we don't enable pasid capability for non-singletion iommu
> +	 * groups, a unbind operation would be helpful to ensure no
> +	 * partial binding for an iommu group.

Where was the non-singleton group restriction done, I missed that.

> +	 */
> +	if (ret)
> +		/*
> +		 * Undo all binds that already succeeded, no need to
> +		 * check the return value here since some device within
> +		 * the group has no successful bind when coming to this
> +		 * place switch.
> +		 */
> +		vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);

However, the for_each_dev function stops when the callback function
returns error, are we just assuming we stop at the same device as we
faulted on the first time and that we traverse the same set of devices
the second time?  It seems strange to me that unbind should be able to
fail.

> +
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
> +				struct iommu_gpasid_bind_data *gbind_data)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	ret = vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);

How is a user supposed to respond to their unbind failing?

> +
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2471,6 +2580,55 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		default:
>  			return -EINVAL;
>  		}
> +
> +	} else if (cmd == VFIO_IOMMU_BIND) {
> +		struct vfio_iommu_type1_bind bind;
> +		u32 version;
> +		int data_size;
> +		void *gbind_data;
> +		int ret;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_bind, flags);
> +
> +		if (copy_from_user(&bind, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (bind.argsz < minsz)
> +			return -EINVAL;
> +
> +		/* Get the version of struct iommu_gpasid_bind_data */
> +		if (copy_from_user(&version,
> +			(void __user *) (arg + minsz),
> +					sizeof(version)))
> +			return -EFAULT;

Why are we coping things from beyond the size we've validated that the
user has provided again?

> +
> +		data_size = iommu_uapi_get_data_size(
> +				IOMMU_UAPI_BIND_GPASID, version);
> +		gbind_data = kzalloc(data_size, GFP_KERNEL);
> +		if (!gbind_data)
> +			return -ENOMEM;
> +
> +		if (copy_from_user(gbind_data,
> +			 (void __user *) (arg + minsz), data_size)) {
> +			kfree(gbind_data);
> +			return -EFAULT;
> +		}

And again.  argsz isn't just for minsz.

> +
> +		switch (bind.flags & VFIO_IOMMU_BIND_MASK) {
> +		case VFIO_IOMMU_BIND_GUEST_PGTBL:
> +			ret = vfio_iommu_type1_bind_gpasid(iommu,
> +							   gbind_data);
> +			break;
> +		case VFIO_IOMMU_UNBIND_GUEST_PGTBL:
> +			ret = vfio_iommu_type1_unbind_gpasid(iommu,
> +							     gbind_data);
> +			break;
> +		default:
> +			ret = -EINVAL;
> +			break;
> +		}
> +		kfree(gbind_data);
> +		return ret;
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ebeaf3e..2235bc6 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -14,6 +14,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
> +#include <linux/iommu.h>
>  
>  #define VFIO_API_VERSION	0
>  
> @@ -853,6 +854,51 @@ struct vfio_iommu_type1_pasid_request {
>   */
>  #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 22)
>  
> +/**
> + * Supported flags:
> + *	- VFIO_IOMMU_BIND_GUEST_PGTBL: bind guest page tables to host for
> + *			nesting type IOMMUs. In @data field It takes struct
> + *			iommu_gpasid_bind_data.
> + *	- VFIO_IOMMU_UNBIND_GUEST_PGTBL: undo a bind guest page table operation
> + *			invoked by VFIO_IOMMU_BIND_GUEST_PGTBL.

This must require iommu_gpasid_bind_data in the data field as well,
right?

> + *
> + */
> +struct vfio_iommu_type1_bind {
> +	__u32		argsz;
> +	__u32		flags;
> +#define VFIO_IOMMU_BIND_GUEST_PGTBL	(1 << 0)
> +#define VFIO_IOMMU_UNBIND_GUEST_PGTBL	(1 << 1)
> +	__u8		data[];
> +};
> +
> +#define VFIO_IOMMU_BIND_MASK	(VFIO_IOMMU_BIND_GUEST_PGTBL | \
> +					VFIO_IOMMU_UNBIND_GUEST_PGTBL)
> +
> +/**
> + * VFIO_IOMMU_BIND - _IOW(VFIO_TYPE, VFIO_BASE + 23,
> + *				struct vfio_iommu_type1_bind)
> + *
> + * Manage address spaces of devices in this container. Initially a TYPE1
> + * container can only have one address space, managed with
> + * VFIO_IOMMU_MAP/UNMAP_DMA.
> + *
> + * An IOMMU of type VFIO_TYPE1_NESTING_IOMMU can be managed by both MAP/UNMAP
> + * and BIND ioctls at the same time. MAP/UNMAP acts on the stage-2 (host) page
> + * tables, and BIND manages the stage-1 (guest) page tables. Other types of
> + * IOMMU may allow MAP/UNMAP and BIND to coexist, where MAP/UNMAP controls
> + * the traffics only require single stage translation while BIND controls the
> + * traffics require nesting translation. But this depends on the underlying
> + * IOMMU architecture and isn't guaranteed. Example of this is the guest SVA
> + * traffics, such traffics need nesting translation to gain gVA->gPA and then
> + * gPA->hPA translation.
> + *
> + * Availability of this feature depends on the device, its bus, the underlying
> + * IOMMU and the CPU architecture.
> + *
> + * returns: 0 on success, -errno on failure.
> + */
> +#define VFIO_IOMMU_BIND		_IO(VFIO_TYPE, VFIO_BASE + 23)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

