Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082EA24C9A8
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 03:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgHUBt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 21:49:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726819AbgHUBt1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 21:49:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597974565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5z6SRAsT7pU3uSoDaMR5vd9Glaz6l21lljUrEhYY6E=;
        b=RwACoefwpXOaLufZZNDHWjtjq5NBaNKSuAszEH0iqLR6rMN4BiCgqc9+yipGWxqdqfBVyR
        kcGRV1q45V0oUv9wr0NvPFFGAjgHV8kFAUwW3utbFeZyDXRXLW2L9t0+97G7MRN0mn/qKX
        xtxAYXo0S1IiCCFhjqy8aewUtbLKl8k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-35KLWSOiPJ-8LtSR-zGl1A-1; Thu, 20 Aug 2020 21:49:20 -0400
X-MC-Unique: 35KLWSOiPJ-8LtSR-zGl1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A536B427C0;
        Fri, 21 Aug 2020 01:49:18 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DE96600DD;
        Fri, 21 Aug 2020 01:49:11 +0000 (UTC)
Date:   Thu, 20 Aug 2020 19:49:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 07/15] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Message-ID: <20200820194910.583a3809@x1.home>
In-Reply-To: <DM5PR11MB1435B790F169ACDFFEA03D68C35B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
        <1595917664-33276-8-git-send-email-yi.l.liu@intel.com>
        <20200820145127.61ed8727@x1.home>
        <DM5PR11MB1435B790F169ACDFFEA03D68C35B0@DM5PR11MB1435.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 00:37:19 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, August 21, 2020 4:51 AM
> > 
> > On Mon, 27 Jul 2020 23:27:36 -0700
> > Liu Yi L <yi.l.liu@intel.com> wrote:
> >   
> > > This patch allows userspace to request PASID allocation/free, e.g.
> > > when serving the request from the guest.
> > >
> > > PASIDs that are not freed by userspace are automatically freed when
> > > the IOASID set is destroyed when process exits.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > Cc: Joerg Roedel <joro@8bytes.org>
> > > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > ---
> > > v5 -> v6:
> > > *) address comments from Eric against v5. remove the alloc/free helper.
> > >
> > > v4 -> v5:
> > > *) address comments from Eric Auger.
> > > *) the comments for the PASID_FREE request is addressed in patch 5/15 of
> > >    this series.
> > >
> > > v3 -> v4:
> > > *) address comments from v3, except the below comment against the range
> > >    of PASID_FREE request. needs more help on it.  
> > >     "> +if (req.range.min > req.range.max)  
> > >
> > >      Is it exploitable that a user can spin the kernel for a long time in
> > >      the case of a free by calling this with [0, MAX_UINT] regardless of
> > >      their actual allocations?"
> > >
> > > https://lore.kernel.org/linux-iommu/20200702151832.048b44d1@x1.home/
> > >
> > > v1 -> v2:
> > > *) move the vfio_mm related code to be a seprate module
> > > *) use a single structure for alloc/free, could support a range of
> > > PASIDs
> > > *) fetch vfio_mm at group_attach time instead of at iommu driver open
> > > time
> > > ---
> > >  drivers/vfio/Kconfig            |  1 +
> > >  drivers/vfio/vfio_iommu_type1.c | 69  
> > +++++++++++++++++++++++++++++++++++++++++  
> > >  drivers/vfio/vfio_pasid.c       | 10 ++++++
> > >  include/linux/vfio.h            |  6 ++++
> > >  include/uapi/linux/vfio.h       | 37 ++++++++++++++++++++++
> > >  5 files changed, 123 insertions(+)
> > >
> > > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig index
> > > 3d8a108..95d90c6 100644
> > > --- a/drivers/vfio/Kconfig
> > > +++ b/drivers/vfio/Kconfig
> > > @@ -2,6 +2,7 @@
> > >  config VFIO_IOMMU_TYPE1
> > >  	tristate
> > >  	depends on VFIO
> > > +	select VFIO_PASID if (X86)
> > >  	default n
> > >
> > >  config VFIO_IOMMU_SPAPR_TCE
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > > b/drivers/vfio/vfio_iommu_type1.c index 18ff0c3..ea89c7c 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -76,6 +76,7 @@ struct vfio_iommu {
> > >  	bool				dirty_page_tracking;
> > >  	bool				pinned_page_dirty_scope;
> > >  	struct iommu_nesting_info	*nesting_info;
> > > +	struct vfio_mm			*vmm;
> > >  };
> > >
> > >  struct vfio_domain {
> > > @@ -1937,6 +1938,11 @@ static void vfio_iommu_iova_insert_copy(struct
> > > vfio_iommu *iommu,
> > >
> > >  static void vfio_iommu_release_nesting_info(struct vfio_iommu *iommu)
> > > {
> > > +	if (iommu->vmm) {
> > > +		vfio_mm_put(iommu->vmm);
> > > +		iommu->vmm = NULL;
> > > +	}
> > > +
> > >  	kfree(iommu->nesting_info);
> > >  	iommu->nesting_info = NULL;
> > >  }
> > > @@ -2071,6 +2077,26 @@ static int vfio_iommu_type1_attach_group(void  
> > *iommu_data,  
> > >  					    iommu->nesting_info);
> > >  		if (ret)
> > >  			goto out_detach;
> > > +
> > > +		if (iommu->nesting_info->features &
> > > +					IOMMU_NESTING_FEAT_SYSWIDE_PASID)  
> > {  
> > > +			struct vfio_mm *vmm;
> > > +			int sid;
> > > +
> > > +			vmm = vfio_mm_get_from_task(current);
> > > +			if (IS_ERR(vmm)) {
> > > +				ret = PTR_ERR(vmm);
> > > +				goto out_detach;
> > > +			}
> > > +			iommu->vmm = vmm;
> > > +
> > > +			sid = vfio_mm_ioasid_sid(vmm);
> > > +			ret = iommu_domain_set_attr(domain->domain,
> > > +						    DOMAIN_ATTR_IOASID_SID,
> > > +						    &sid);
> > > +			if (ret)
> > > +				goto out_detach;
> > > +		}
> > >  	}
> > >
> > >  	/* Get aperture info */
> > > @@ -2859,6 +2885,47 @@ static int vfio_iommu_type1_dirty_pages(struct  
> > vfio_iommu *iommu,  
> > >  	return -EINVAL;
> > >  }
> > >
> > > +static int vfio_iommu_type1_pasid_request(struct vfio_iommu *iommu,
> > > +					  unsigned long arg)
> > > +{
> > > +	struct vfio_iommu_type1_pasid_request req;
> > > +	unsigned long minsz;
> > > +	int ret;
> > > +
> > > +	minsz = offsetofend(struct vfio_iommu_type1_pasid_request, range);
> > > +
> > > +	if (copy_from_user(&req, (void __user *)arg, minsz))
> > > +		return -EFAULT;
> > > +
> > > +	if (req.argsz < minsz || (req.flags & ~VFIO_PASID_REQUEST_MASK))
> > > +		return -EINVAL;
> > > +
> > > +	if (req.range.min > req.range.max)
> > > +		return -EINVAL;
> > > +
> > > +	mutex_lock(&iommu->lock);
> > > +	if (!iommu->vmm) {
> > > +		mutex_unlock(&iommu->lock);
> > > +		return -EOPNOTSUPP;
> > > +	}
> > > +
> > > +	switch (req.flags & VFIO_PASID_REQUEST_MASK) {
> > > +	case VFIO_IOMMU_FLAG_ALLOC_PASID:
> > > +		ret = vfio_pasid_alloc(iommu->vmm, req.range.min,
> > > +				       req.range.max);
> > > +		break;
> > > +	case VFIO_IOMMU_FLAG_FREE_PASID:
> > > +		vfio_pasid_free_range(iommu->vmm, req.range.min,
> > > +				      req.range.max);
> > > +		ret = 0;
> > > +		break;
> > > +	default:
> > > +		ret = -EINVAL;
> > > +	}
> > > +	mutex_unlock(&iommu->lock);
> > > +	return ret;
> > > +}
> > > +
> > >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> > >  				   unsigned int cmd, unsigned long arg)  { @@ -  
> > 2875,6 +2942,8 @@  
> > > static long vfio_iommu_type1_ioctl(void *iommu_data,
> > >  		return vfio_iommu_type1_unmap_dma(iommu, arg);
> > >  	case VFIO_IOMMU_DIRTY_PAGES:
> > >  		return vfio_iommu_type1_dirty_pages(iommu, arg);
> > > +	case VFIO_IOMMU_PASID_REQUEST:
> > > +		return vfio_iommu_type1_pasid_request(iommu, arg);
> > >  	default:
> > >  		return -ENOTTY;
> > >  	}
> > > diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
> > > index befcf29..8d0317f 100644
> > > --- a/drivers/vfio/vfio_pasid.c
> > > +++ b/drivers/vfio/vfio_pasid.c
> > > @@ -61,6 +61,7 @@ void vfio_mm_put(struct vfio_mm *vmm)  {
> > >  	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_mm_lock);  }
> > > +EXPORT_SYMBOL_GPL(vfio_mm_put);
> > >
> > >  static void vfio_mm_get(struct vfio_mm *vmm)
> > >  {
> > > @@ -114,6 +115,13 @@ struct vfio_mm *vfio_mm_get_from_task(struct  
> > task_struct *task)  
> > >  	mmput(mm);
> > >  	return vmm;
> > >  }
> > > +EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
> > > +
> > > +int vfio_mm_ioasid_sid(struct vfio_mm *vmm)
> > > +{
> > > +	return vmm->ioasid_sid;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_mm_ioasid_sid);
> > >
> > >  /*
> > >   * Find PASID within @min and @max
> > > @@ -202,6 +210,7 @@ int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
> > >
> > >  	return pasid;
> > >  }
> > > +EXPORT_SYMBOL_GPL(vfio_pasid_alloc);
> > >
> > >  void vfio_pasid_free_range(struct vfio_mm *vmm,
> > >  			   ioasid_t min, ioasid_t max)
> > > @@ -218,6 +227,7 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
> > >  		vfio_remove_pasid(vmm, vid);
> > >  	mutex_unlock(&vmm->pasid_lock);
> > >  }
> > > +EXPORT_SYMBOL_GPL(vfio_pasid_free_range);
> > >
> > >  static int __init vfio_pasid_init(void)
> > >  {
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index 31472a9..a355d01 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -101,6 +101,7 @@ struct vfio_mm;
> > >  #if IS_ENABLED(CONFIG_VFIO_PASID)
> > >  extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
> > >  extern void vfio_mm_put(struct vfio_mm *vmm);
> > > +extern int vfio_mm_ioasid_sid(struct vfio_mm *vmm);
> > >  extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
> > >  extern void vfio_pasid_free_range(struct vfio_mm *vmm,
> > >  				  ioasid_t min, ioasid_t max);
> > > @@ -114,6 +115,11 @@ static inline void vfio_mm_put(struct vfio_mm *vmm)
> > >  {
> > >  }
> > >
> > > +static inline int vfio_mm_ioasid_sid(struct vfio_mm *vmm)
> > > +{
> > > +	return -ENOTTY;
> > > +}
> > > +
> > >  static inline int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
> > >  {
> > >  	return -ENOTTY;
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index 0cf3d6d..6d79557 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -1172,6 +1172,43 @@ struct vfio_iommu_type1_dirty_bitmap_get {
> > >
> > >  #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
> > >
> > > +/**
> > > + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
> > > + *				struct vfio_iommu_type1_pasid_request)
> > > + *
> > > + * PASID (Processor Address Space ID) is a PCIe concept for tagging
> > > + * address spaces in DMA requests. When system-wide PASID allocation
> > > + * is required by the underlying iommu driver (e.g. Intel VT-d), this
> > > + * provides an interface for userspace to request pasid alloc/free
> > > + * for its assigned devices. Userspace should check the availability
> > > + * of this API by checking VFIO_IOMMU_TYPE1_INFO_CAP_NESTING through
> > > + * VFIO_IOMMU_GET_INFO.
> > > + *
> > > + * @flags=VFIO_IOMMU_FLAG_ALLOC_PASID, allocate a single PASID within  
> > @range.  
> > > + * @flags=VFIO_IOMMU_FLAG_FREE_PASID, free the PASIDs within @range.
> > > + * @range is [min, max], which means both @min and @max are inclusive.
> > > + * ALLOC_PASID and FREE_PASID are mutually exclusive.
> > > + *
> > > + * returns: allocated PASID value on success, -errno on failure for
> > > + *	     ALLOC_PASID;
> > > + *	     0 for FREE_PASID operation;
> > > + */
> > > +struct vfio_iommu_type1_pasid_request {
> > > +	__u32	argsz;
> > > +#define VFIO_IOMMU_FLAG_ALLOC_PASID	(1 << 0)
> > > +#define VFIO_IOMMU_FLAG_FREE_PASID	(1 << 1)
> > > +	__u32	flags;
> > > +	struct {
> > > +		__u32	min;
> > > +		__u32	max;
> > > +	} range;
> > > +};  
> > 
> > 
> > IOCTL(2)                   Linux Programmer's Manual                  IOCTL(2)
> > 
> > NAME
> >        ioctl - control device
> > 
> > SYNOPSIS
> >        #include <sys/ioctl.h>
> > 
> >        int ioctl(int fd, unsigned long request, ...);
> > 
> > 
> > ioctl(2) returns a signed int, how can it support returning a __u32
> > pasid and -errno?  Thanks,  
> 
> yeah, pasid is 20 bits today per PCI spec, so a valid pasid won't use
> full 32 bits, so I used it. perhaps I need to add a field in the data
> struct to return allocated pasid. that may be safer. do you think it
> works?

AIUI, the pasid is defined as 20 bits, this isn't simply an
implementation issue, right?  So perhaps it's ok as is and just needs
some supplemental comments and checking to verify that the desired
pasid range is valid.  Thanks,

Alex

