Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892C3266A27
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 23:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgIKViV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 17:38:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33465 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725846AbgIKViU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 17:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599860298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a3Rgi5X/bHgs8RcPhxJzeqnxBSrzQidkBS6mbDd86SM=;
        b=XKqzFVr+sDXf9VrboH4syilzydJOFYD8VlysdBdq/yu6jGK9yRx3jW98F5vSXBeae1moIu
        QrPrxcMen+umIw97qC0HthdfJTj1SlbIVuLPG1SQPambn5npVGszvzwHxOUDuo5ucM9RVd
        EyKuiB5a7Cycbm0VdN5GQwamMvFclQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-_5ci5bAaNHekE8ZcMAGKEQ-1; Fri, 11 Sep 2020 17:38:16 -0400
X-MC-Unique: _5ci5bAaNHekE8ZcMAGKEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E59F57053;
        Fri, 11 Sep 2020 21:38:14 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A6AE5C22B;
        Fri, 11 Sep 2020 21:38:06 +0000 (UTC)
Date:   Fri, 11 Sep 2020 15:38:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, jasowang@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 07/16] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Message-ID: <20200911153806.6dda06b9@w520.home>
In-Reply-To: <1599734733-6431-8-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
        <1599734733-6431-8-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Sep 2020 03:45:24 -0700
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch allows userspace to request PASID allocation/free, e.g. when
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
> v6 -> v7:
> *) current VFIO returns allocated pasid via signed int, thus VFIO UAPI
>    can only support 31 bits pasid. If user space gives min,max which is
>    wider than 31 bits, should fail the allocation or free request.
> 
> v5 -> v6:
> *) address comments from Eric against v5. remove the alloc/free helper.
> 
> v4 -> v5:
> *) address comments from Eric Auger.
> *) the comments for the PASID_FREE request is addressed in patch 5/15 of
>    this series.
> 
> v3 -> v4:
> *) address comments from v3, except the below comment against the range
>    of PASID_FREE request. needs more help on it.
>     "> +if (req.range.min > req.range.max)  
> 
>      Is it exploitable that a user can spin the kernel for a long time in
>      the case of a free by calling this with [0, MAX_UINT] regardless of
>      their actual allocations?"
>     https://lore.kernel.org/linux-iommu/20200702151832.048b44d1@x1.home/
> 
> v1 -> v2:
> *) move the vfio_mm related code to be a seprate module
> *) use a single structure for alloc/free, could support a range of PASIDs
> *) fetch vfio_mm at group_attach time instead of at iommu driver open time
> ---
>  drivers/vfio/Kconfig            |  1 +
>  drivers/vfio/vfio_iommu_type1.c | 76 +++++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_pasid.c       | 10 ++++++
>  include/linux/vfio.h            |  6 ++++
>  include/uapi/linux/vfio.h       | 43 +++++++++++++++++++++++
>  5 files changed, 136 insertions(+)
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
> index 3c0048b..bd4b668 100644
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
> @@ -2000,6 +2001,11 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
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
> @@ -2127,6 +2133,26 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  					    iommu->nesting_info);
>  		if (ret)
>  			goto out_detach;
> +
> +		if (iommu->nesting_info->features &
> +					IOMMU_NESTING_FEAT_SYSWIDE_PASID) {
> +			struct vfio_mm *vmm;
> +			struct ioasid_set *set;
> +
> +			vmm = vfio_mm_get_from_task(current);
> +			if (IS_ERR(vmm)) {
> +				ret = PTR_ERR(vmm);
> +				goto out_detach;
> +			}
> +			iommu->vmm = vmm;
> +
> +			set = vfio_mm_ioasid_set(vmm);
> +			ret = iommu_domain_set_attr(domain->domain,
> +						    DOMAIN_ATTR_IOASID_SET,
> +						    set);
> +			if (ret)
> +				goto out_detach;
> +		}
>  	}
>  
>  	/* Get aperture info */
> @@ -2908,6 +2934,54 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  	return -EINVAL;
>  }
>  
> +static int vfio_iommu_type1_pasid_request(struct vfio_iommu *iommu,
> +					  unsigned long arg)
> +{
> +	struct vfio_iommu_type1_pasid_request req;
> +	unsigned long minsz;
> +	int ret;
> +
> +	minsz = offsetofend(struct vfio_iommu_type1_pasid_request, range);
> +
> +	if (copy_from_user(&req, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (req.argsz < minsz || (req.flags & ~VFIO_PASID_REQUEST_MASK))
> +		return -EINVAL;
> +
> +	/*
> +	 * Current VFIO_IOMMU_PASID_REQUEST only supports at most
> +	 * 31 bits PASID. The min,max value from userspace should
> +	 * not exceed 31 bits.

Please describe the source of this restriction.  I think it's due to
using the ioctl return value to return the PASID, thus excluding the
negative values, but aren't we actually restricted to pasid_bits
exposed in the nesting_info?  If this is just a sanity test for the API
then why are we defining VFIO_IOMMU_PASID_BITS in the uapi header,
which causes conflicting information to the user... which do they
honor?  Should we instead verify that pasid_bits matches our API scheme
when configuring the nested domain and then let the ioasid allocator
reject requests outside of the range?

> +	 */
> +	if (req.range.min > req.range.max ||
> +	    req.range.min > (1 << VFIO_IOMMU_PASID_BITS) ||
> +	    req.range.max > (1 << VFIO_IOMMU_PASID_BITS))

Off by one, >= for the bit test.

> +		return -EINVAL;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!iommu->vmm) {
> +		mutex_unlock(&iommu->lock);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	switch (req.flags & VFIO_PASID_REQUEST_MASK) {
> +	case VFIO_IOMMU_FLAG_ALLOC_PASID:
> +		ret = vfio_pasid_alloc(iommu->vmm, req.range.min,
> +				       req.range.max);
> +		break;
> +	case VFIO_IOMMU_FLAG_FREE_PASID:
> +		vfio_pasid_free_range(iommu->vmm, req.range.min,
> +				      req.range.max);
> +		ret = 0;

Set the initial value when it's declared?

> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2924,6 +2998,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		return vfio_iommu_type1_unmap_dma(iommu, arg);
>  	case VFIO_IOMMU_DIRTY_PAGES:
>  		return vfio_iommu_type1_dirty_pages(iommu, arg);
> +	case VFIO_IOMMU_PASID_REQUEST:
> +		return vfio_iommu_type1_pasid_request(iommu, arg);
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
> index 44ecdd5..0ec4660 100644
> --- a/drivers/vfio/vfio_pasid.c
> +++ b/drivers/vfio/vfio_pasid.c
> @@ -60,6 +60,7 @@ void vfio_mm_put(struct vfio_mm *vmm)
>  {
>  	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_mm_lock);
>  }
> +EXPORT_SYMBOL_GPL(vfio_mm_put);
>  
>  static void vfio_mm_get(struct vfio_mm *vmm)
>  {
> @@ -113,6 +114,13 @@ struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
>  	mmput(mm);
>  	return vmm;
>  }
> +EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
> +
> +struct ioasid_set *vfio_mm_ioasid_set(struct vfio_mm *vmm)
> +{
> +	return vmm->ioasid_set;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mm_ioasid_set);
>  
>  /*
>   * Find PASID within @min and @max
> @@ -201,6 +209,7 @@ int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
>  
>  	return pasid;
>  }
> +EXPORT_SYMBOL_GPL(vfio_pasid_alloc);
>  
>  void vfio_pasid_free_range(struct vfio_mm *vmm,
>  			   ioasid_t min, ioasid_t max)
> @@ -217,6 +226,7 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
>  		vfio_remove_pasid(vmm, vid);
>  	mutex_unlock(&vmm->pasid_lock);
>  }
> +EXPORT_SYMBOL_GPL(vfio_pasid_free_range);
>  
>  static int __init vfio_pasid_init(void)
>  {
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 31472a9..5c3d7a8 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -101,6 +101,7 @@ struct vfio_mm;
>  #if IS_ENABLED(CONFIG_VFIO_PASID)
>  extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
>  extern void vfio_mm_put(struct vfio_mm *vmm);
> +extern struct ioasid_set *vfio_mm_ioasid_set(struct vfio_mm *vmm);
>  extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
>  extern void vfio_pasid_free_range(struct vfio_mm *vmm,
>  				  ioasid_t min, ioasid_t max);
> @@ -114,6 +115,11 @@ static inline void vfio_mm_put(struct vfio_mm *vmm)
>  {
>  }
>  
> +static inline struct ioasid_set *vfio_mm_ioasid_set(struct vfio_mm *vmm)
> +{
> +	return -ENOTTY;
> +}
> +
>  static inline int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
>  {
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ff40f9e..a4bc42e 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1172,6 +1172,49 @@ struct vfio_iommu_type1_dirty_bitmap_get {
>  
>  #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
>  
> +/**
> + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
> + *				struct vfio_iommu_type1_pasid_request)
> + *
> + * PASID (Processor Address Space ID) is a PCIe concept for tagging
> + * address spaces in DMA requests. When system-wide PASID allocation
> + * is required by the underlying iommu driver (e.g. Intel VT-d), this
> + * provides an interface for userspace to request pasid alloc/free
> + * for its assigned devices. Userspace should check the availability
> + * of this API by checking VFIO_IOMMU_TYPE1_INFO_CAP_NESTING through
> + * VFIO_IOMMU_GET_INFO.
> + *
> + * @flags=VFIO_IOMMU_FLAG_ALLOC_PASID, allocate a single PASID within @range.
> + * @flags=VFIO_IOMMU_FLAG_FREE_PASID, free the PASIDs within @range.
> + * @range is [min, max], which means both @min and @max are inclusive.
> + * ALLOC_PASID and FREE_PASID are mutually exclusive.
> + *
> + * Current interface supports at most 31 bits PASID bits as returning
> + * PASID allocation result via signed int. PCIe spec defines 20 bits
> + * for PASID width, so 31 bits is enough. As a result user space should
> + * provide min, max no more than 31 bits.

Perhaps this is the description I was looking for, but this still
conflicts with what I think the user is supposed to do, which is to
provide a range within nesting_info.pasid_bits.  These seem like
implementation details, not uapi.  Thanks,

Alex

> + * returns: allocated PASID value on success, -errno on failure for
> + *	    ALLOC_PASID;
> + *	    0 for FREE_PASID operation;
> + */
> +struct vfio_iommu_type1_pasid_request {
> +	__u32	argsz;
> +#define VFIO_IOMMU_FLAG_ALLOC_PASID	(1 << 0)
> +#define VFIO_IOMMU_FLAG_FREE_PASID	(1 << 1)
> +	__u32	flags;
> +	struct {
> +		__u32	min;
> +		__u32	max;
> +	} range;
> +};
> +
> +#define VFIO_PASID_REQUEST_MASK	(VFIO_IOMMU_FLAG_ALLOC_PASID | \
> +					 VFIO_IOMMU_FLAG_FREE_PASID)
> +
> +#define VFIO_IOMMU_PASID_BITS		31
> +
> +#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 18)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

