Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80158215A83
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 17:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgGFPRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 11:17:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54273 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729238AbgGFPRv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jul 2020 11:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594048669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IjTRpm8OTIpo8sgVRs7OTJFyRE/KzQIUSuhUdJa3V5I=;
        b=YjkP7yYYJiU2E/4VXbkfhbWDqoACiht9V5Qnxfc/Z4xuJBykyA6RBRyeR/oCd0fDRzUsBd
        izPpiZJBk2ePds2WPA8Rz9t9zkkOqLpYb2IYq/cdbzfvH+KN1qVnU6DNzDHF388v5R6O7t
        0mMjgXUNFclEV6B3f3JEoF4S2YzLiFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-OpQYv1H5PASqjyI2csu1Lg-1; Mon, 06 Jul 2020 11:17:47 -0400
X-MC-Unique: OpQYv1H5PASqjyI2csu1Lg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D84B10059A5;
        Mon,  6 Jul 2020 15:17:45 +0000 (UTC)
Received: from [10.36.113.241] (ovpn-113-241.ams2.redhat.com [10.36.113.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D409E512FE;
        Mon,  6 Jul 2020 15:17:35 +0000 (UTC)
Subject: Re: [PATCH v4 07/15] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
 <1593861989-35920-8-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f78eac88-eb8e-a6f5-d701-146587660f5f@redhat.com>
Date:   Mon, 6 Jul 2020 17:17:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1593861989-35920-8-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 7/4/20 1:26 PM, Liu Yi L wrote:
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
> v3 -> v4:
> *) address comments from v3, except the below comment against the range
>    of PASID_FREE request. needs more help on it.
>     "> +if (req.range.min > req.range.max)
> 
>     Is it exploitable that a user can spin the kernel for a long time in
>     the case of a free by calling this with [0, MAX_UINT] regardless of
>     their actual allocations?"
> 
> v1 -> v2:
> *) move the vfio_mm related code to be a seprate module
> *) use a single structure for alloc/free, could support a range of PASIDs
> *) fetch vfio_mm at group_attach time instead of at iommu driver open time
> ---
>  drivers/vfio/Kconfig            |  1 +
>  drivers/vfio/vfio_iommu_type1.c | 84 +++++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_pasid.c       | 10 +++++
>  include/linux/vfio.h            |  6 +++
>  include/uapi/linux/vfio.h       | 36 ++++++++++++++++++
>  5 files changed, 137 insertions(+)
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
> index 80623b8..29726ca 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -76,6 +76,7 @@ struct vfio_iommu {
>  	bool				dirty_page_tracking;
>  	bool				pinned_page_dirty_scope;
>  	struct iommu_nesting_info	*nesting_info;
> +	struct vfio_mm			*vmm;
>  };
>  
>  struct vfio_domain {
> @@ -1937,6 +1938,11 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
>  
>  static void vfio_iommu_release_nesting_info(struct vfio_iommu *iommu)
>  {
> +	if (iommu->vmm) {
> +		vfio_mm_put(iommu->vmm);
> +		iommu->vmm = NULL;
> +	}
> +
>  	kfree(iommu->nesting_info);
>  	iommu->nesting_info = NULL;
>  }
> @@ -2075,6 +2081,25 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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
> +			if (ret)
> +				goto out_detach;
> +		}
>  	}
>  
>  	/* Get aperture info */
> @@ -2860,6 +2885,63 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  	return -EINVAL;
>  }
>  
> +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
> +					unsigned int min,
> +					unsigned int max)
> +{
> +	int ret = -EOPNOTSUPP;
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
> +	int ret = -EOPNOTSUPP;
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
> +		return -EINVAL;
> +
> +	switch (req.flags & VFIO_PASID_REQUEST_MASK) {
> +	case VFIO_IOMMU_FLAG_ALLOC_PASID:
> +		return vfio_iommu_type1_pasid_alloc(iommu,
> +					req.range.min, req.range.max);
> +	case VFIO_IOMMU_FLAG_FREE_PASID:
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
> @@ -2876,6 +2958,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		return vfio_iommu_type1_unmap_dma(iommu, arg);
>  	case VFIO_IOMMU_DIRTY_PAGES:
>  		return vfio_iommu_type1_dirty_pages(iommu, arg);
> +	case VFIO_IOMMU_PASID_REQUEST:
> +		return vfio_iommu_type1_pasid_request(iommu, arg);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
> index c46b870..6f907db 100644
> --- a/drivers/vfio/vfio_pasid.c
> +++ b/drivers/vfio/vfio_pasid.c
> @@ -53,6 +53,7 @@ void vfio_mm_put(struct vfio_mm *vmm)
>  {
>  	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_pasid.vfio_mm_lock);
>  }
> +EXPORT_SYMBOL_GPL(vfio_mm_put);
I think this should be belong to [5/15]
>  
>  static void vfio_mm_get(struct vfio_mm *vmm)
>  {
> @@ -104,6 +105,13 @@ struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
>  	mmput(mm);
>  	return vmm;
>  }
> +EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
same
> +
> +int vfio_mm_ioasid_sid(struct vfio_mm *vmm)
extern?
same
> +{
> +	return vmm->ioasid_sid;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_ioasid_sid);
>  
>  int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
>  {
> @@ -113,6 +121,7 @@ int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
>  
>  	return (pasid == INVALID_IOASID) ? -ENOSPC : pasid;
>  }
> +EXPORT_SYMBOL_GPL(vfio_pasid_alloc);
same
>  
>  void vfio_pasid_free_range(struct vfio_mm *vmm,
>  			    ioasid_t min, ioasid_t max)
> @@ -130,6 +139,7 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
>  	for (; pasid <= max; pasid++)
>  		ioasid_free(pasid);
>  }
> +EXPORT_SYMBOL_GPL(vfio_pasid_free_range);
same
>  
>  static int __init vfio_pasid_init(void)
>  {
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 9da6468..35c922a 100644
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
> index 3e3de9c..fe267b8e 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1169,6 +1169,42 @@ struct vfio_iommu_type1_dirty_bitmap_get {
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
name the capability?
> + *
> + * @flags=VFIO_IOMMU_FLAG_ALLOC_PASID, allocate a single PASID within @range.
> + * @flags=VFIO_IOMMU_FLAG_FREE_PASID, free the PASIDs within @range.
> + * @range is [min, max], which means both @min and @max are inclusive.
> + * ALLOC_PASID and FREE_PASID are mutually exclusive.
> + *
> + * returns: allocated PASID value on success, -errno on failure for
> + *	     ALLOC_PASID;
> + *	     0 for FREE_PASID operation;
> + */
> +struct vfio_iommu_type1_pasid_request {
> +	__u32	argsz;
> +#define VFIO_IOMMU_FLAG_ALLOC_PASID	(1 << 0)
> +#define VFIO_IOMMU_FLAG_FREE_PASID	(1 << 1)
> +	__u32	flags;> +	struct {
> +		__u32	min;
> +		__u32	max;
> +	} range;
> +};
> +
> +#define VFIO_PASID_REQUEST_MASK	(VFIO_IOMMU_FLAG_ALLOC_PASID | \
> +					 VFIO_IOMMU_FLAG_FREE_PASID)
> +
> +#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 18)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*
> 

Thanks

Eric

