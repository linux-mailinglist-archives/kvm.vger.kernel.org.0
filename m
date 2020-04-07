Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101F01A056D
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 05:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDGD6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 23:58:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:46542 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgDGD6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 23:58:04 -0400
IronPort-SDR: Ibw9LgxpPGZTmMQ/n6BMytGP1IS2/B24Lyt+nUaOl/lwLyocbsHeHo3Q5WlWIkQk4Qoxj1ubi8
 +WvYvrtXYrpA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 20:58:03 -0700
IronPort-SDR: xzh6ZBzOLl4Ys7XemoWLLys1AS2BYNn6WgHUhSxZ1Rw59t/5jO63OXcZ5V/CRgPvbfIAirFM0p
 aZyTY+bPEsdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,353,1580803200"; 
   d="scan'208";a="451076859"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga005.fm.intel.com with ESMTP; 06 Apr 2020 20:58:00 -0700
Date:   Mon, 6 Apr 2020 23:48:25 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        zhenyuw@linux.intel.com, pbonzini@redhat.com, kevin.tian@intel.com,
        peterx@redhat.com
Subject: Re: [PATCH v4 2/7] vfio: introduce vfio_dma_rw to read/write a range
 of IOVAs
Message-ID: <20200407034825.GC10586@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200313030548.7705-1-yan.y.zhao@intel.com>
 <20200313030901.7830-1-yan.y.zhao@intel.com>
 <202004050916.E52CA610@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202004050916.E52CA610@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 05, 2020 at 09:17:13AM -0700, Kees Cook wrote:
> On Thu, Mar 12, 2020 at 11:09:01PM -0400, Yan Zhao wrote:
> > vfio_dma_rw will read/write a range of user space memory pointed to by
> > IOVA into/from a kernel buffer without enforcing pinning the user space
> > memory.
> > 
> > TODO: mark the IOVAs to user space memory dirty if they are written in
> > vfio_dma_rw().
> > 
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/vfio.c             | 49 +++++++++++++++++++++
> >  drivers/vfio/vfio_iommu_type1.c | 76 +++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h            |  5 +++
> >  3 files changed, 130 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 97b972bfb735..6997f711b925 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -1999,6 +1999,55 @@ int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
> >  }
> >  EXPORT_SYMBOL(vfio_unpin_pages);
> >  
> > +
> > +/*
> > + * This interface allows the CPUs to perform some sort of virtual DMA on
> > + * behalf of the device.
> > + *
> > + * CPUs read/write from/into a range of IOVAs pointing to user space memory
> > + * into/from a kernel buffer.
> > + *
> > + * As the read/write of user space memory is conducted via the CPUs and is
> > + * not a real device DMA, it is not necessary to pin the user space memory.
> > + *
> > + * The caller needs to call vfio_group_get_external_user() or
> > + * vfio_group_get_external_user_from_dev() prior to calling this interface,
> > + * so as to prevent the VFIO group from disposal in the middle of the call.
> > + * But it can keep the reference to the VFIO group for several calls into
> > + * this interface.
> > + * After finishing using of the VFIO group, the caller needs to release the
> > + * VFIO group by calling vfio_group_put_external_user().
> > + *
> > + * @group [in]		: VFIO group
> > + * @user_iova [in]	: base IOVA of a user space buffer
> > + * @data [in]		: pointer to kernel buffer
> > + * @len [in]		: kernel buffer length
> > + * @write		: indicate read or write
> > + * Return error code on failure or 0 on success.
> > + */
> > +int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
> > +		void *data, size_t len, bool write)
> > +{
> > +	struct vfio_container *container;
> > +	struct vfio_iommu_driver *driver;
> > +	int ret = 0;
> > +
> > +	if (!group || !data || len <= 0)
> > +		return -EINVAL;
> > +
> > +	container = group->container;
> > +	driver = container->iommu_driver;
> > +
> > +	if (likely(driver && driver->ops->dma_rw))
> > +		ret = driver->ops->dma_rw(container->iommu_data,
> > +					  user_iova, data, len, write);
> > +	else
> > +		ret = -ENOTTY;
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(vfio_dma_rw);
> > +
> >  static int vfio_register_iommu_notifier(struct vfio_group *group,
> >  					unsigned long *events,
> >  					struct notifier_block *nb)
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index a177bf2c6683..9fdfae1cb17a 100644
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
> > @@ -2305,6 +2306,80 @@ static int vfio_iommu_type1_unregister_notifier(void *iommu_data,
> >  	return blocking_notifier_chain_unregister(&iommu->notifier, nb);
> >  }
> >  
> > +static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
> > +					 dma_addr_t user_iova, void *data,
> > +					 size_t count, bool write,
> > +					 size_t *copied)
> > +{
> > +	struct mm_struct *mm;
> > +	unsigned long vaddr;
> > +	struct vfio_dma *dma;
> > +	bool kthread = current->mm == NULL;
> > +	size_t offset;
> > +
> > +	*copied = 0;
> > +
> > +	dma = vfio_find_dma(iommu, user_iova, 1);
> > +	if (!dma)
> > +		return -EINVAL;
> > +
> > +	if ((write && !(dma->prot & IOMMU_WRITE)) ||
> > +			!(dma->prot & IOMMU_READ))
> > +		return -EPERM;
> > +
> > +	mm = get_task_mm(dma->task);
> > +
> > +	if (!mm)
> > +		return -EPERM;
> > +
> > +	if (kthread)
> > +		use_mm(mm);
> > +	else if (current->mm != mm)
> > +		goto out;
> > +
> > +	offset = user_iova - dma->iova;
> > +
> > +	if (count > dma->size - offset)
> > +		count = dma->size - offset;
> > +
> > +	vaddr = dma->vaddr + offset;
> > +
> > +	if (write)
> > +		*copied = __copy_to_user((void __user *)vaddr, data,
> > +					 count) ? 0 : count;
> > +	else
> > +		*copied = __copy_from_user(data, (void __user *)vaddr,
> > +					   count) ? 0 : count;
> 
> Why are these using __copy_*_user()? Where are the access_ok() checks?
> 
sorry, my fault. I thought there was a access_ok() for vaddr when adding it
to vfio_dma tree.
will send a fix to use copy_to/from_user instead.

Thanks
Yan

> 
> > +	if (kthread)
> > +		unuse_mm(mm);
> > +out:
> > +	mmput(mm);
> > +	return *copied ? 0 : -EFAULT;
> > +}
> > +
> > +static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
> > +				   void *data, size_t count, bool write)
> > +{
> > +	struct vfio_iommu *iommu = iommu_data;
> > +	int ret = 0;
> > +	size_t done;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	while (count > 0) {
> > +		ret = vfio_iommu_type1_dma_rw_chunk(iommu, user_iova, data,
> > +						    count, write, &done);
> > +		if (ret)
> > +			break;
> > +
> > +		count -= done;
> > +		data += done;
> > +		user_iova += done;
> > +	}
> > +
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> >  static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
> >  	.name			= "vfio-iommu-type1",
> >  	.owner			= THIS_MODULE,
> > @@ -2317,6 +2392,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
> >  	.unpin_pages		= vfio_iommu_type1_unpin_pages,
> >  	.register_notifier	= vfio_iommu_type1_register_notifier,
> >  	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
> > +	.dma_rw			= vfio_iommu_type1_dma_rw,
> >  };
> >  
> >  static int __init vfio_iommu_type1_init(void)
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index fb71e0ac0e76..34b2fdf4de6e 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -82,6 +82,8 @@ struct vfio_iommu_driver_ops {
> >  					     struct notifier_block *nb);
> >  	int		(*unregister_notifier)(void *iommu_data,
> >  					       struct notifier_block *nb);
> > +	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
> > +				  void *data, size_t count, bool write);
> >  };
> >  
> >  extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
> > @@ -109,6 +111,9 @@ extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
> >  extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
> >  			    int npage);
> >  
> > +extern int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
> > +		       void *data, size_t len, bool write);
> > +
> >  /* each type has independent events */
> >  enum vfio_notify_type {
> >  	VFIO_IOMMU_NOTIFY = 0,
> > -- 
> > 2.17.1
> > 
> 
> -- 
> Kees Cook
