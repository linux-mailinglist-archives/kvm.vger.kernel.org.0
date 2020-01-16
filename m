Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 997D913D3D8
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 06:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgAPFlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 00:41:15 -0500
Received: from mga18.intel.com ([134.134.136.126]:57962 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgAPFlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 00:41:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2020 21:41:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,325,1574150400"; 
   d="scan'208";a="220260012"
Received: from unknown (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jan 2020 21:41:13 -0800
Date:   Thu, 16 Jan 2020 00:32:02 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>
Subject: Re: [PATCH v2 1/2] vfio: introduce vfio_dma_rw to read/write a range
 of IOVAs
Message-ID: <20200116053202.GA1759@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200115034132.2753-1-yan.y.zhao@intel.com>
 <20200115035303.12362-1-yan.y.zhao@intel.com>
 <20200115130638.6926dd08@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115130638.6926dd08@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 04:06:38AM +0800, Alex Williamson wrote:
> On Tue, 14 Jan 2020 22:53:03 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > vfio_dma_rw will read/write a range of user space memory pointed to by
> > IOVA into/from a kernel buffer without pinning the user space memory.
> > 
> > TODO: mark the IOVAs to user space memory dirty if they are written in
> > vfio_dma_rw().
> > 
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/vfio.c             | 45 +++++++++++++++++++
> >  drivers/vfio/vfio_iommu_type1.c | 76 +++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h            |  5 +++
> >  3 files changed, 126 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index c8482624ca34..8bd52bc841cf 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -1961,6 +1961,51 @@ int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
> >  }
> >  EXPORT_SYMBOL(vfio_unpin_pages);
> >  
> > +/*
> > + * Read/Write a range of IOVAs pointing to user space memory into/from a kernel
> > + * buffer without pinning the user space memory
> > + * @dev [in]  : device
> > + * @iova [in] : base IOVA of a user space buffer
> > + * @data [in] : pointer to kernel buffer
> > + * @len [in]  : kernel buffer length
> > + * @write     : indicate read or write
> > + * Return error code on failure or 0 on success.
> > + */
> > +int vfio_dma_rw(struct device *dev, dma_addr_t iova, void *data,
> > +		   size_t len, bool write)
> > +{
> > +	struct vfio_container *container;
> > +	struct vfio_group *group;
> > +	struct vfio_iommu_driver *driver;
> > +	int ret = 0;
> > +
> > +	if (!dev || !data || len <= 0)
> > +		return -EINVAL;
> > +
> > +	group = vfio_group_get_from_dev(dev);
> > +	if (!group)
> > +		return -ENODEV;
> > +
> > +	ret = vfio_group_add_container_user(group);
> > +	if (ret)
> > +		goto out;
> > +
> > +	container = group->container;
> > +	driver = container->iommu_driver;
> > +
> > +	if (likely(driver && driver->ops->dma_rw))
> > +		ret = driver->ops->dma_rw(container->iommu_data,
> > +					   iova, data, len, write);
> > +	else
> > +		ret = -ENOTTY;
> > +
> > +	vfio_group_try_dissolve_container(group);
> > +out:
> > +	vfio_group_put(group);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(vfio_dma_rw);
> > +
> >  static int vfio_register_iommu_notifier(struct vfio_group *group,
> >  					unsigned long *events,
> >  					struct notifier_block *nb)
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 2ada8e6cdb88..a2d850b97ae6 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/iommu.h>
> >  #include <linux/module.h>
> >  #include <linux/mm.h>
> > +#include <linux/mmu_context.h>
> >  #include <linux/rbtree.h>
> >  #include <linux/sched/signal.h>
> >  #include <linux/sched/mm.h>
> > @@ -2326,6 +2327,80 @@ static int vfio_iommu_type1_unregister_notifier(void *iommu_data,
> >  	return blocking_notifier_chain_unregister(&iommu->notifier, nb);
> >  }
> >  
> > +static size_t vfio_iommu_type1_rw_dma_nopin(struct vfio_iommu *iommu,
> > +					    dma_addr_t iova, void *data,
> > +					    size_t count, bool write)
> 
> "_nopin"?  It might be pinned, but that's irrelevant to this interface.
> Maybe "_chunk" as we're only trying to operate on the chunk of the whole
> that fits within the next vfio_dma?  Also swapping rw_dma vs dma_rw,
> pick one.
>
got it!

> > +{
> > +	struct mm_struct *mm;
> > +	unsigned long vaddr;
> > +	struct vfio_dma *dma;
> > +	bool kthread = current->mm == NULL;
> > +	size_t done = 0;
> > +	size_t offset;
> > +
> > +	dma = vfio_find_dma(iommu, iova, 1);
> > +	if (!dma)
> > +		return 0;
> > +
> > +	if (write && !(dma->prot & IOMMU_WRITE))
> > +		return 0;
> 
> Good catch, but users can also designate a mapping without read
> permissions, in which case this interface should not allow read either.
> Thanks,
>
yes, will add it too. thanks :)

Yan

> > +
> > +	mm = get_task_mm(dma->task);
> > +
> > +	if (!mm)
> > +		return 0;
> > +
> > +	if (kthread)
> > +		use_mm(mm);
> > +	else if (current->mm != mm)
> > +		goto out;
> > +
> > +	offset = iova - dma->iova;
> > +
> > +	if (count > dma->size - offset)
> > +		count = dma->size - offset;
> > +
> > +	vaddr = dma->vaddr + offset;
> > +
> > +	if (write)
> > +		done = __copy_to_user((void __user *)vaddr, data, count) ?
> > +				       0 : count;
> > +	else
> > +		done = __copy_from_user(data, (void __user *)vaddr, count) ?
> > +					0 : count;
> > +
> > +	if (kthread)
> > +		unuse_mm(mm);
> > +out:
> > +	mmput(mm);
> > +	return done;
> > +}
> > +
> > +static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t iova,
> > +				   void *data, size_t count, bool write)
> > +{
> > +	struct vfio_iommu *iommu = iommu_data;
> > +	int ret = 0;
> > +	size_t done = 0;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	while (count > 0) {
> > +		done = vfio_iommu_type1_rw_dma_nopin(iommu, iova, data,
> > +						   count, write);
> > +		if (!done) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +
> > +		count -= done;
> > +		data += done;
> > +		iova += done;
> > +	}
> > +
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> >  static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
> >  	.name			= "vfio-iommu-type1",
> >  	.owner			= THIS_MODULE,
> > @@ -2338,6 +2413,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
> >  	.unpin_pages		= vfio_iommu_type1_unpin_pages,
> >  	.register_notifier	= vfio_iommu_type1_register_notifier,
> >  	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
> > +	.dma_rw			= vfio_iommu_type1_dma_rw,
> >  };
> >  
> >  static int __init vfio_iommu_type1_init(void)
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index e42a711a2800..962f76a2d668 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -82,6 +82,8 @@ struct vfio_iommu_driver_ops {
> >  					     struct notifier_block *nb);
> >  	int		(*unregister_notifier)(void *iommu_data,
> >  					       struct notifier_block *nb);
> > +	int		(*dma_rw)(void *iommu_data, dma_addr_t iova,
> > +				   void *data, size_t count, bool write);
> >  };
> >  
> >  extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
> > @@ -107,6 +109,9 @@ extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
> >  extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
> >  			    int npage);
> >  
> > +extern int vfio_dma_rw(struct device *dev, dma_addr_t iova, void *data,
> > +		       size_t len, bool write);
> > +
> >  /* each type has independent events */
> >  enum vfio_notify_type {
> >  	VFIO_IOMMU_NOTIFY = 0,
> 
> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev
