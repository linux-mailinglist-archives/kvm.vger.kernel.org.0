Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913DE281CEC
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgJBU3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:29:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgJBU3P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:29:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601670552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ChISgzMVjHM/phUkpmC2n2EoXtFo/13m2xsh0l9TWM8=;
        b=DpJxoXc5EALO9BDW2Z3aKgz250rHWPw8X6VNvDJI5ayCZInPoVu7tYGH2fTq2iFFm4kd+9
        lpYvTS4K+WR648OT6ADKEiYMDq3TUdeHAdkaV8sxoT4YKjIC3uhakfUGCV29ms0JCcMUIy
        J2jdJq71NTksXC+eXA24DQyU11ndMlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-ky6rYsRuMhutC5jhijYc7Q-1; Fri, 02 Oct 2020 16:29:08 -0400
X-MC-Unique: ky6rYsRuMhutC5jhijYc7Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AFD78030DB;
        Fri,  2 Oct 2020 20:29:07 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4A055577E;
        Fri,  2 Oct 2020 20:29:02 +0000 (UTC)
Date:   Fri, 2 Oct 2020 14:29:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     kvm@vger.kernel.org, bharatb.linux@gmail.com,
        linux-kernel@vger.kernel.org, eric.auger@redhat.com,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: Re: [PATCH v5 08/10] vfio/fsl-mc: trigger an interrupt via eventfd
Message-ID: <20201002142902.16cfc5da@x1.home>
In-Reply-To: <20200929090339.17659-9-diana.craciun@oss.nxp.com>
References: <20200929090339.17659-1-diana.craciun@oss.nxp.com>
        <20200929090339.17659-9-diana.craciun@oss.nxp.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Sep 2020 12:03:37 +0300
Diana Craciun <diana.craciun@oss.nxp.com> wrote:

> This patch allows to set an eventfd for fsl-mc device interrupts
> and also to trigger the interrupt eventfd from userspace for testing.
> 
> All fsl-mc device interrupts are MSIs. The MSIs are allocated from
> the MSI domain only once per DPRC and used by all the DPAA2 objects.
> The interrupts are managed by the DPRC in a pool of interrupts. Each
> device requests interrupts from this pool. The pool is allocated
> when the first virtual device is setting the interrupts.
> The pool of interrupts is protected by a lock.
> 
> The DPRC has an interrupt of its own which indicates if the DPRC
> contents have changed. However, currently, the contents of a DPRC
> assigned to the guest cannot be changed at runtime, so this interrupt
> is not configured.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         |  24 +++-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 161 +++++++++++++++++++++-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  10 ++
>  3 files changed, 193 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 2919e2d0041b..82157837f37a 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -155,12 +155,34 @@ static int vfio_fsl_mc_open(void *device_data)
>  static void vfio_fsl_mc_release(void *device_data)
>  {
>  	struct vfio_fsl_mc_device *vdev = device_data;
> +	int ret;
>  
>  	mutex_lock(&vdev->reflck->lock);
>  
> -	if (!(--vdev->refcnt))
> +	if (!(--vdev->refcnt)) {
> +		struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +		struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
> +		struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
> +
>  		vfio_fsl_mc_regions_cleanup(vdev);
>  
> +		/* reset the device before cleaning up the interrupts */
> +		ret = dprc_reset_container(mc_cont->mc_io, 0,
> +		      mc_cont->mc_handle,
> +			  mc_cont->obj_desc.id,
> +			  DPRC_RESET_OPTION_NON_RECURSIVE);
> +
> +		if (ret) {
> +			dev_warn(&mc_cont->dev, "VFIO_FLS_MC: reset device has failed (%d)\n",
> +				 ret);
> +			WARN_ON(1);
> +		}
> +
> +		vfio_fsl_mc_irqs_cleanup(vdev);
> +
> +		fsl_mc_cleanup_irq_pool(mc_cont);
> +	}
> +
>  	mutex_unlock(&vdev->reflck->lock);
>  
>  	module_put(THIS_MODULE);
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> index 5232f208e361..992ee18f1f6f 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> @@ -13,12 +13,150 @@
>  #include "linux/fsl/mc.h"
>  #include "vfio_fsl_mc_private.h"
>  
> +int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)
> +{
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	struct vfio_fsl_mc_irq *mc_irq;
> +	int irq_count;
> +	int ret, i;
> +
> +	/* Device does not support any interrupt */
> +	if (mc_dev->obj_desc.irq_count == 0)
> +		return 0;
> +
> +	/* interrupts were already allocated for this device */
> +	if (vdev->mc_irqs)
> +		return 0;
> +
> +	irq_count = mc_dev->obj_desc.irq_count;
> +
> +	mc_irq = kcalloc(irq_count, sizeof(*mc_irq), GFP_KERNEL);
> +	if (!mc_irq)
> +		return -ENOMEM;
> +
> +	/* Allocate IRQs */
> +	ret = fsl_mc_allocate_irqs(mc_dev);
> +	if (ret) {
> +		kfree(mc_irq);
> +		return ret;
> +	}
> +
> +	for (i = 0; i < irq_count; i++) {
> +		mc_irq[i].count = 1;
> +		mc_irq[i].flags = VFIO_IRQ_INFO_EVENTFD;
> +	}
> +
> +	vdev->mc_irqs = mc_irq;
> +
> +	return 0;
> +}
> +
> +static irqreturn_t vfio_fsl_mc_irq_handler(int irq_num, void *arg)
> +{
> +	struct vfio_fsl_mc_irq *mc_irq = (struct vfio_fsl_mc_irq *)arg;
> +
> +	eventfd_signal(mc_irq->trigger, 1);
> +	return IRQ_HANDLED;
> +}
> +
> +static int vfio_set_trigger(struct vfio_fsl_mc_device *vdev,
> +						   int index, int fd)
> +{
> +	struct vfio_fsl_mc_irq *irq = &vdev->mc_irqs[index];
> +	struct eventfd_ctx *trigger;
> +	int hwirq;
> +	int ret;
> +
> +	hwirq = vdev->mc_dev->irqs[index]->msi_desc->irq;
> +	if (irq->trigger) {
> +		free_irq(hwirq, irq);
> +		kfree(irq->name);
> +		eventfd_ctx_put(irq->trigger);
> +		irq->trigger = NULL;
> +	}
> +
> +	if (fd < 0) /* Disable only */
> +		return 0;
> +
> +	irq->name = kasprintf(GFP_KERNEL, "vfio-irq[%d](%s)",
> +			    hwirq, dev_name(&vdev->mc_dev->dev));
> +	if (!irq->name)
> +		return -ENOMEM;
> +
> +	trigger = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(trigger)) {
> +		kfree(irq->name);
> +		return PTR_ERR(trigger);
> +	}
> +
> +	irq->trigger = trigger;
> +
> +	ret = request_irq(hwirq, vfio_fsl_mc_irq_handler, 0,
> +		  irq->name, irq);
> +	if (ret) {
> +		kfree(irq->name);
> +		eventfd_ctx_put(trigger);
> +		irq->trigger = NULL;
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
>  				       unsigned int index, unsigned int start,
>  				       unsigned int count, u32 flags,
>  				       void *data)
>  {
> -	return -EINVAL;
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	int ret, hwirq;
> +	struct vfio_fsl_mc_irq *irq;
> +	struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
> +	struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
> +
> +	if (start != 0 || count != 1)
> +		return -EINVAL;
> +
> +	mutex_lock(&vdev->reflck->lock);
> +	ret = fsl_mc_populate_irq_pool(mc_cont,
> +			FSL_MC_IRQ_POOL_MAX_TOTAL_IRQS);
> +	if (ret)
> +		goto unlock;
> +
> +	ret = vfio_fsl_mc_irqs_allocate(vdev);
> +	if (ret)
> +		goto unlock;
> +	mutex_unlock(&vdev->reflck->lock);
> +
> +	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
> +		return vfio_set_trigger(vdev, index, -1);
> +
> +	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> +		s32 fd = *(s32 *)data;
> +
> +		return vfio_set_trigger(vdev, index, fd);
> +	}
> +
> +	hwirq = vdev->mc_dev->irqs[index]->msi_desc->irq;
> +
> +	irq = &vdev->mc_irqs[index];
> +
> +	if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +		vfio_fsl_mc_irq_handler(hwirq, irq);
> +
> +	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> +		u8 trigger = *(u8 *)data;
> +
> +		if (trigger)
> +			vfio_fsl_mc_irq_handler(hwirq, irq);
> +	}
> +
> +	return 0;
> +
> +unlock:
> +	mutex_unlock(&vdev->reflck->lock);
> +	return ret;
> +
>  }
>  
>  int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
> @@ -32,3 +170,24 @@ int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>  	else
>  		return -EINVAL;
>  }
> +
> +/* Free All IRQs for the given MC object */
> +void vfio_fsl_mc_irqs_cleanup(struct vfio_fsl_mc_device *vdev)
> +{
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	int irq_count = mc_dev->obj_desc.irq_count;
> +	int i;
> +
> +	/* Device does not support any interrupt or the interrupts
> +	 * were not configured
> +	 */
> +	if (mc_dev->obj_desc.irq_count == 0 || !vdev->mc_irqs)

Nit, the former test seems unnecessary, the latter test covers both
cases.  Comment style also switched here.  Thanks,

Alex

> +		return;
> +
> +	for (i = 0; i < irq_count; i++)
> +		vfio_set_trigger(vdev, i, -1);
> +
> +	fsl_mc_free_irqs(mc_dev);
> +	kfree(vdev->mc_irqs);
> +	vdev->mc_irqs = NULL;
> +}
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> index 2c3f625a3240..7aa49b9ba60d 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> @@ -15,6 +15,13 @@
>  #define VFIO_FSL_MC_INDEX_TO_OFFSET(index)	\
>  	((u64)(index) << VFIO_FSL_MC_OFFSET_SHIFT)
>  
> +struct vfio_fsl_mc_irq {
> +	u32         flags;
> +	u32         count;
> +	struct eventfd_ctx  *trigger;
> +	char            *name;
> +};
> +
>  struct vfio_fsl_mc_reflck {
>  	struct kref		kref;
>  	struct mutex		lock;
> @@ -34,6 +41,7 @@ struct vfio_fsl_mc_device {
>  	struct vfio_fsl_mc_region	*regions;
>  	struct vfio_fsl_mc_reflck   *reflck;
>  	struct mutex         igate;
> +	struct vfio_fsl_mc_irq      *mc_irqs;
>  };
>  
>  extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
> @@ -41,4 +49,6 @@ extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>  			       unsigned int start, unsigned int count,
>  			       void *data);
>  
> +void vfio_fsl_mc_irqs_cleanup(struct vfio_fsl_mc_device *vdev);
> +
>  #endif /* VFIO_FSL_MC_PRIVATE_H */

