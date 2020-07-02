Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA82212EAA
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 23:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgGBVSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 17:18:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53352 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725954AbgGBVSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 17:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593724723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NOOEVG8oMXwoAzoP5nGjWD3KW8ptoT68CY6diDWD2bc=;
        b=VxpGT60pc27S7KrV9zgoyDT2cNBIXwEqO1+lwYCit8abV8RtTRgcTWIAsHooSlpJYQhyGe
        1rRRX2EpOIdGI6nz0aNsVy559Tl15I0p0MRzVEVdIx0SCoBtWmidPfgaDPPAcCddhICGkV
        b4u0pCt/X3fKQcMccc/NslrsTNOsMbM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-ovRhBTUfMo6fWiUchCydrw-1; Thu, 02 Jul 2020 17:18:41 -0400
X-MC-Unique: ovRhBTUfMo6fWiUchCydrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ECC4107ACCA;
        Thu,  2 Jul 2020 21:18:39 +0000 (UTC)
Received: from x1.home (ovpn-112-156.phx2.redhat.com [10.3.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAFEA60CD3;
        Thu,  2 Jul 2020 21:18:32 +0000 (UTC)
Date:   Thu, 2 Jul 2020 15:18:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/14] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Message-ID: <20200702151832.048b44d1@x1.home>
In-Reply-To: <1592988927-48009-7-git-send-email-yi.l.liu@intel.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-7-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Jun 2020 01:55:19 -0700
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch allows user space to request PASID allocation/free, e.g. when
> serving the request from the guest.
> 
> PASIDs that are not freed by userspace are automatically freed when the
> IOASID set is destroyed when process exits.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> v1 -> v2:
> *) move the vfio_mm related code to be a seprate module
> *) use a single structure for alloc/free, could support a range of PASIDs
> *) fetch vfio_mm at group_attach time instead of at iommu driver open time
> ---
>  drivers/vfio/Kconfig            |  1 +
>  drivers/vfio/vfio_iommu_type1.c | 96 ++++++++++++++++++++++++++++++++++++++++-
>  drivers/vfio/vfio_pasid.c       | 10 +++++
>  include/linux/vfio.h            |  6 +++
>  include/uapi/linux/vfio.h       | 36 ++++++++++++++++
>  5 files changed, 147 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 3d8a108..95d90c6 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -2,6 +2,7 @@
>  config VFIO_IOMMU_TYPE1
>  	tristate
>  	depends on VFIO
> +	select VFIO_PASID if (X86)
>  	default n
>  
>  config VFIO_IOMMU_SPAPR_TCE
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 8c143d5..d0891c5 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -73,6 +73,7 @@ struct vfio_iommu {
>  	bool			v2;
>  	bool			nesting;
>  	struct iommu_nesting_info *nesting_info;
> +	struct vfio_mm		*vmm;

Structure alignment again.

>  	bool			dirty_page_tracking;
>  	bool			pinned_page_dirty_scope;
>  };
> @@ -1933,6 +1934,17 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
>  
>  	list_splice_tail(iova_copy, iova);
>  }
> +
> +static void vfio_iommu_release_nesting_info(struct vfio_iommu *iommu)
> +{
> +	if (iommu->vmm) {
> +		vfio_mm_put(iommu->vmm);
> +		iommu->vmm = NULL;
> +	}
> +
> +	kfree(iommu->nesting_info);

iommu->nesting_info = NULL;

> +}
> +
>  static int vfio_iommu_type1_attach_group(void *iommu_data,
>  					 struct iommu_group *iommu_group)
>  {
> @@ -2067,6 +2079,25 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  			goto out_detach;
>  		}
>  		iommu->nesting_info = info;
> +
> +		if (info->features & IOMMU_NESTING_FEAT_SYSWIDE_PASID) {
> +			struct vfio_mm *vmm;
> +			int sid;
> +
> +			vmm = vfio_mm_get_from_task(current);
> +			if (IS_ERR(vmm)) {
> +				ret = PTR_ERR(vmm);
> +				goto out_detach;
> +			}
> +			iommu->vmm = vmm;
> +
> +			sid = vfio_mm_ioasid_sid(vmm);
> +			ret = iommu_domain_set_attr(domain->domain,
> +						    DOMAIN_ATTR_IOASID_SID,
> +						    &sid);

This looks pretty dicey in the case of !CONFIG_VFIO_PASID, can we get
here in that case?  If so it looks like we're doing bad things with
setting the domain->ioasid_sid.

> +			if (ret)
> +				goto out_detach;
> +		}
>  	}
>  
>  	/* Get aperture info */
> @@ -2178,7 +2209,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	return 0;
>  
>  out_detach:
> -	kfree(iommu->nesting_info);
> +	if (iommu->nesting_info)
> +		vfio_iommu_release_nesting_info(iommu);

Make vfio_iommu_release_nesting_info() check iommu->nesting_info, then
call it unconditionally?

>  	vfio_iommu_detach_group(domain, group);
>  out_domain:
>  	iommu_domain_free(domain->domain);
> @@ -2380,7 +2412,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  				else
>  					vfio_iommu_unmap_unpin_reaccount(iommu);
>  
> -				kfree(iommu->nesting_info);
> +				if (iommu->nesting_info)
> +					vfio_iommu_release_nesting_info(iommu);
>  			}
>  			iommu_domain_free(domain->domain);
>  			list_del(&domain->next);
> @@ -2852,6 +2885,63 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  	return -EINVAL;
>  }
>  
> +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
> +					unsigned int min,
> +					unsigned int max)
> +{
> +	int ret = -ENOTSUPP;
> +
> +	mutex_lock(&iommu->lock);
> +	if (iommu->vmm)
> +		ret = vfio_pasid_alloc(iommu->vmm, min, max);
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
> +					unsigned int min,
> +					unsigned int max)
> +{
> +	int ret = -ENOTSUPP;
> +
> +	mutex_lock(&iommu->lock);
> +	if (iommu->vmm) {
> +		vfio_pasid_free_range(iommu->vmm, min, max);
> +		ret = 0;
> +	}
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +static int vfio_iommu_type1_pasid_request(struct vfio_iommu *iommu,
> +					  unsigned long arg)
> +{
> +	struct vfio_iommu_type1_pasid_request req;
> +	unsigned long minsz;
> +
> +	minsz = offsetofend(struct vfio_iommu_type1_pasid_request, range);
> +
> +	if (copy_from_user(&req, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (req.argsz < minsz || (req.flags & ~VFIO_PASID_REQUEST_MASK))
> +		return -EINVAL;
> +
> +	if (req.range.min > req.range.max)

Is it exploitable that a user can spin the kernel for a long time in
the case of a free by calling this with [0, MAX_UINT] regardless of
their actual allocations?

> +		return -EINVAL;
> +
> +	switch (req.flags & VFIO_PASID_REQUEST_MASK) {
> +	case VFIO_IOMMU_ALLOC_PASID:
> +		return vfio_iommu_type1_pasid_alloc(iommu,
> +					req.range.min, req.range.max);
> +	case VFIO_IOMMU_FREE_PASID:
> +		return vfio_iommu_type1_pasid_free(iommu,
> +					req.range.min, req.range.max);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2868,6 +2958,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		return vfio_iommu_type1_unmap_dma(iommu, arg);
>  	case VFIO_IOMMU_DIRTY_PAGES:
>  		return vfio_iommu_type1_dirty_pages(iommu, arg);
> +	case VFIO_IOMMU_PASID_REQUEST:
> +		return vfio_iommu_type1_pasid_request(iommu, arg);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
> index dd5b6d1..2ea9f1a 100644
> --- a/drivers/vfio/vfio_pasid.c
> +++ b/drivers/vfio/vfio_pasid.c
> @@ -54,6 +54,7 @@ void vfio_mm_put(struct vfio_mm *vmm)
>  {
>  	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_pasid.vfio_mm_lock);
>  }
> +EXPORT_SYMBOL_GPL(vfio_mm_put);
>  
>  static void vfio_mm_get(struct vfio_mm *vmm)
>  {
> @@ -103,6 +104,13 @@ struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
>  	mmput(mm);
>  	return vmm;
>  }
> +EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
> +
> +int vfio_mm_ioasid_sid(struct vfio_mm *vmm)
> +{
> +	return vmm->ioasid_sid;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_ioasid_sid);
>  
>  int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
>  {
> @@ -112,6 +120,7 @@ int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
>  
>  	return (pasid == INVALID_IOASID) ? -ENOSPC : pasid;
>  }
> +EXPORT_SYMBOL_GPL(vfio_pasid_alloc);
>  
>  void vfio_pasid_free_range(struct vfio_mm *vmm,
>  			    ioasid_t min, ioasid_t max)
> @@ -129,6 +138,7 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
>  	for (; pasid <= max; pasid++)
>  		ioasid_free(pasid);
>  }
> +EXPORT_SYMBOL_GPL(vfio_pasid_free_range);
>  
>  static int __init vfio_pasid_init(void)
>  {
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 74e077d..8e60a32 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -101,6 +101,7 @@ struct vfio_mm;
>  #if IS_ENABLED(CONFIG_VFIO_PASID)
>  extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
>  extern void vfio_mm_put(struct vfio_mm *vmm);
> +int vfio_mm_ioasid_sid(struct vfio_mm *vmm);
>  extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
>  extern void vfio_pasid_free_range(struct vfio_mm *vmm,
>  					ioasid_t min, ioasid_t max);
> @@ -114,6 +115,11 @@ static inline void vfio_mm_put(struct vfio_mm *vmm)
>  {
>  }
>  
> +static inline int vfio_mm_ioasid_sid(struct vfio_mm *vmm)
> +{
> +	return -ENOTTY;
> +}
> +
>  static inline int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
>  {
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index f1f39e1..657b2db 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1162,6 +1162,42 @@ struct vfio_iommu_type1_dirty_bitmap_get {
>  
>  #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
>  
> +/**
> + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
> + *				struct vfio_iommu_type1_pasid_request)
> + *
> + * PASID (Processor Address Space ID) is a PCIe concept for tagging
> + * address spaces in DMA requests. When system-wide PASID allocation
> + * is required by underlying iommu driver (e.g. Intel VT-d), this
> + * provides an interface for userspace to request pasid alloc/free
> + * for its assigned devices. Userspace should check the availability
> + * of this API through VFIO_IOMMU_GET_INFO.
> + *
> + * @flags=VFIO_IOMMU_ALLOC_PASID, allocate a single PASID within @range.
> + * @flags=VFIO_IOMMU_FREE_PASID, free the PASIDs within @range.
> + * @range is [min, max], which means both @min and @max are inclusive.
> + * ALLOC_PASID and FREE_PASID are mutually exclusive.
> + *
> + * returns: allocated PASID value on success, -errno on failure for
> + *	     ALLOC_PASID;
> + *	     0 for FREE_PASID operation;
> + */
> +struct vfio_iommu_type1_pasid_request {
> +	__u32	argsz;
> +#define VFIO_IOMMU_ALLOC_PASID	(1 << 0)
> +#define VFIO_IOMMU_FREE_PASID	(1 << 1)

VFIO_IOMMU_PASID_FLAG_{ALLOC,FREE} would be more similar to other VFIO
UAPI conventions.  Thanks,

Alex

> +	__u32	flags;
> +	struct {
> +		__u32	min;
> +		__u32	max;
> +	} range;
> +};
> +
> +#define VFIO_PASID_REQUEST_MASK	(VFIO_IOMMU_ALLOC_PASID | \
> +					 VFIO_IOMMU_FREE_PASID)
> +
> +#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 18)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

