Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B9B16B83A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 04:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgBYDxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 22:53:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:13814 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgBYDxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 22:53:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 19:53:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,482,1574150400"; 
   d="scan'208";a="316951958"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga001.jf.intel.com with ESMTP; 24 Feb 2020 19:53:51 -0800
Date:   Mon, 24 Feb 2020 22:44:28 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH v3 2/7] vfio: introduce vfio_dma_rw to read/write a range
 of IOVAs
Message-ID: <20200225034428.GF30338@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200224084350.31574-1-yan.y.zhao@intel.com>
 <20200224084715.31753-1-yan.y.zhao@intel.com>
 <20200224121442.297a9931@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224121442.297a9931@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 03:14:42AM +0800, Alex Williamson wrote:
> On Mon, 24 Feb 2020 03:47:15 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
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
> >  drivers/vfio/vfio_iommu_type1.c | 77 +++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h            |  5 +++
> >  3 files changed, 131 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 914bdf4b9d73..902867627cbf 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -1998,6 +1998,55 @@ int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
> >  }
> >  EXPORT_SYMBOL(vfio_unpin_pages);
> >  
> > +
> > +/*
> > + * This interface allows the CPUs to perform some sort of virtual DMA on
> > + * behalf of the device.
> > + *
> > + * CPUs read/write a range of IOVAs pointing to user space memory into/from
> > + * a kernel buffer.
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
> > + * @group [in]: vfio group of a device
> > + * @iova [in] : base IOVA of a user space buffer
> > + * @data [in] : pointer to kernel buffer
> > + * @len [in]  : kernel buffer length
> > + * @write     : indicate read or write
> > + * Return error code on failure or 0 on success.
> > + */
> > +int vfio_dma_rw(struct vfio_group *group, dma_addr_t iova,
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
> > +					  iova, data, len, write);
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
> > index 2ada8e6cdb88..74e1c425943c 100644
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
> > @@ -2326,6 +2327,81 @@ static int vfio_iommu_type1_unregister_notifier(void *iommu_data,
> >  	return blocking_notifier_chain_unregister(&iommu->notifier, nb);
> >  }
> >  
> > +static size_t vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
> > +					    dma_addr_t iova, void *data,
> > +					    size_t count, bool write)
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
> > +	if ((write && !(dma->prot & IOMMU_WRITE)) ||
> > +			!(dma->prot & IOMMU_READ))
> > +		return 0;
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
> > +		done = __copy_to_user((void __user *)vaddr,
> > +				       data, count) ? 0 : count;
> > +	else
> > +		done = __copy_from_user(data, (void __user *)vaddr,
> > +					count) ? 0 : count;
> > +
> > +	if (kthread)
> > +		unuse_mm(mm);
> > +out:
> > +	mmput(mm);
> > +	return done;
> 
> 
> Return 0 on error?  Why wouldn't this function decide the errno rather
> than masking them all as -EFAULT by the callee below?  Thanks,
 
ok. let me return negative errno on error. Thanks!
Yan
> 
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
> > +		done = vfio_iommu_type1_dma_rw_chunk(iommu, iova, data,
> > +						     count, write);
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
> > @@ -2338,6 +2414,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
> >  	.unpin_pages		= vfio_iommu_type1_unpin_pages,
> >  	.register_notifier	= vfio_iommu_type1_register_notifier,
> >  	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
> > +	.dma_rw			= vfio_iommu_type1_dma_rw,
> >  };
> >  
> >  static int __init vfio_iommu_type1_init(void)
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 2e1fa0c7396f..fea0cb1e61d2 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -82,6 +82,8 @@ struct vfio_iommu_driver_ops {
> >  					     struct notifier_block *nb);
> >  	int		(*unregister_notifier)(void *iommu_data,
> >  					       struct notifier_block *nb);
> > +	int		(*dma_rw)(void *iommu_data, dma_addr_t iova,
> > +				  void *data, size_t count, bool write);
> >  };
> >  
> >  extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
> > @@ -109,6 +111,9 @@ extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
> >  extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
> >  			    int npage);
> >  
> > +extern int vfio_dma_rw(struct vfio_group *group, dma_addr_t iova, void *data,
> > +		       size_t len, bool write);
> > +
> >  /* each type has independent events */
> >  enum vfio_notify_type {
> >  	VFIO_IOMMU_NOTIFY = 0,
> 
