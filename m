Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F396116B01D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 20:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgBXTOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 14:14:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24296 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727308AbgBXTOx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 14:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582571691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQHousaSxXNRBINVRLMfh+jTIaPMnkH22X4N3Qvicww=;
        b=CEnRUAjd2vqCH5Mb6HuCRtEd8xBa8DeTsUZua4nEEtgYMCdseIQYU4lopaeR2dunb3iJqd
        +LaytRNw3scqOgw66K5Q7olL8+wSD071hhJdFPf9rLVm41BMzIxcipNBI6t4nrWlr/qlLp
        vE/WohbOTlKtoYxxChFJhxNfqUNp1Rk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-OiPO4XAvNey-nmhr_mjeFg-1; Mon, 24 Feb 2020 14:14:47 -0500
X-MC-Unique: OiPO4XAvNey-nmhr_mjeFg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA05118B5F6A;
        Mon, 24 Feb 2020 19:14:45 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F31D5D9CD;
        Mon, 24 Feb 2020 19:14:42 +0000 (UTC)
Date:   Mon, 24 Feb 2020 12:14:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     zhenyuw@linux.intel.com, intel-gvt-dev@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, peterx@redhat.com
Subject: Re: [PATCH v3 2/7] vfio: introduce vfio_dma_rw to read/write a
 range of IOVAs
Message-ID: <20200224121442.297a9931@w520.home>
In-Reply-To: <20200224084715.31753-1-yan.y.zhao@intel.com>
References: <20200224084350.31574-1-yan.y.zhao@intel.com>
        <20200224084715.31753-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 03:47:15 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> vfio_dma_rw will read/write a range of user space memory pointed to by
> IOVA into/from a kernel buffer without enforcing pinning the user space
> memory.
> 
> TODO: mark the IOVAs to user space memory dirty if they are written in
> vfio_dma_rw().
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/vfio.c             | 49 +++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c | 77 +++++++++++++++++++++++++++++++++
>  include/linux/vfio.h            |  5 +++
>  3 files changed, 131 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 914bdf4b9d73..902867627cbf 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1998,6 +1998,55 @@ int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
>  }
>  EXPORT_SYMBOL(vfio_unpin_pages);
>  
> +
> +/*
> + * This interface allows the CPUs to perform some sort of virtual DMA on
> + * behalf of the device.
> + *
> + * CPUs read/write a range of IOVAs pointing to user space memory into/from
> + * a kernel buffer.
> + *
> + * As the read/write of user space memory is conducted via the CPUs and is
> + * not a real device DMA, it is not necessary to pin the user space memory.
> + *
> + * The caller needs to call vfio_group_get_external_user() or
> + * vfio_group_get_external_user_from_dev() prior to calling this interface,
> + * so as to prevent the VFIO group from disposal in the middle of the call.
> + * But it can keep the reference to the VFIO group for several calls into
> + * this interface.
> + * After finishing using of the VFIO group, the caller needs to release the
> + * VFIO group by calling vfio_group_put_external_user().
> + *
> + * @group [in]: vfio group of a device
> + * @iova [in] : base IOVA of a user space buffer
> + * @data [in] : pointer to kernel buffer
> + * @len [in]  : kernel buffer length
> + * @write     : indicate read or write
> + * Return error code on failure or 0 on success.
> + */
> +int vfio_dma_rw(struct vfio_group *group, dma_addr_t iova,
> +		void *data, size_t len, bool write)
> +{
> +	struct vfio_container *container;
> +	struct vfio_iommu_driver *driver;
> +	int ret = 0;
> +
> +	if (!group || !data || len <= 0)
> +		return -EINVAL;
> +
> +	container = group->container;
> +	driver = container->iommu_driver;
> +
> +	if (likely(driver && driver->ops->dma_rw))
> +		ret = driver->ops->dma_rw(container->iommu_data,
> +					  iova, data, len, write);
> +	else
> +		ret = -ENOTTY;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(vfio_dma_rw);
> +
>  static int vfio_register_iommu_notifier(struct vfio_group *group,
>  					unsigned long *events,
>  					struct notifier_block *nb)
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 2ada8e6cdb88..74e1c425943c 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -27,6 +27,7 @@
>  #include <linux/iommu.h>
>  #include <linux/module.h>
>  #include <linux/mm.h>
> +#include <linux/mmu_context.h>
>  #include <linux/rbtree.h>
>  #include <linux/sched/signal.h>
>  #include <linux/sched/mm.h>
> @@ -2326,6 +2327,81 @@ static int vfio_iommu_type1_unregister_notifier(void *iommu_data,
>  	return blocking_notifier_chain_unregister(&iommu->notifier, nb);
>  }
>  
> +static size_t vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
> +					    dma_addr_t iova, void *data,
> +					    size_t count, bool write)
> +{
> +	struct mm_struct *mm;
> +	unsigned long vaddr;
> +	struct vfio_dma *dma;
> +	bool kthread = current->mm == NULL;
> +	size_t done = 0;
> +	size_t offset;
> +
> +	dma = vfio_find_dma(iommu, iova, 1);
> +	if (!dma)
> +		return 0;
> +
> +	if ((write && !(dma->prot & IOMMU_WRITE)) ||
> +			!(dma->prot & IOMMU_READ))
> +		return 0;
> +
> +	mm = get_task_mm(dma->task);
> +
> +	if (!mm)
> +		return 0;
> +
> +	if (kthread)
> +		use_mm(mm);
> +	else if (current->mm != mm)
> +		goto out;
> +
> +	offset = iova - dma->iova;
> +
> +	if (count > dma->size - offset)
> +		count = dma->size - offset;
> +
> +	vaddr = dma->vaddr + offset;
> +
> +	if (write)
> +		done = __copy_to_user((void __user *)vaddr,
> +				       data, count) ? 0 : count;
> +	else
> +		done = __copy_from_user(data, (void __user *)vaddr,
> +					count) ? 0 : count;
> +
> +	if (kthread)
> +		unuse_mm(mm);
> +out:
> +	mmput(mm);
> +	return done;


Return 0 on error?  Why wouldn't this function decide the errno rather
than masking them all as -EFAULT by the callee below?  Thanks,

Alex

> +}
> +
> +static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t iova,
> +				   void *data, size_t count, bool write)
> +{
> +	struct vfio_iommu *iommu = iommu_data;
> +	int ret = 0;
> +	size_t done = 0;
> +
> +	mutex_lock(&iommu->lock);
> +	while (count > 0) {
> +		done = vfio_iommu_type1_dma_rw_chunk(iommu, iova, data,
> +						     count, write);
> +		if (!done) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		count -= done;
> +		data += done;
> +		iova += done;
> +	}
> +
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
>  	.name			= "vfio-iommu-type1",
>  	.owner			= THIS_MODULE,
> @@ -2338,6 +2414,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
>  	.unpin_pages		= vfio_iommu_type1_unpin_pages,
>  	.register_notifier	= vfio_iommu_type1_register_notifier,
>  	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
> +	.dma_rw			= vfio_iommu_type1_dma_rw,
>  };
>  
>  static int __init vfio_iommu_type1_init(void)
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 2e1fa0c7396f..fea0cb1e61d2 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -82,6 +82,8 @@ struct vfio_iommu_driver_ops {
>  					     struct notifier_block *nb);
>  	int		(*unregister_notifier)(void *iommu_data,
>  					       struct notifier_block *nb);
> +	int		(*dma_rw)(void *iommu_data, dma_addr_t iova,
> +				  void *data, size_t count, bool write);
>  };
>  
>  extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
> @@ -109,6 +111,9 @@ extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
>  extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
>  			    int npage);
>  
> +extern int vfio_dma_rw(struct vfio_group *group, dma_addr_t iova, void *data,
> +		       size_t len, bool write);
> +
>  /* each type has independent events */
>  enum vfio_notify_type {
>  	VFIO_IOMMU_NOTIFY = 0,

