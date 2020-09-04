Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9392725D32C
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 10:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgIDIDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 04:03:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728118AbgIDIDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 04:03:00 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-6gr_ztSQNMmT-4IQ5EY8PA-1; Fri, 04 Sep 2020 04:02:55 -0400
X-MC-Unique: 6gr_ztSQNMmT-4IQ5EY8PA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44E5F18B9ED1;
        Fri,  4 Sep 2020 08:02:54 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B00F51001B2B;
        Fri,  4 Sep 2020 08:02:49 +0000 (UTC)
Subject: Re: [PATCH v4 08/10] vfio/fsl-mc: trigger an interrupt via eventfd
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-9-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f313b0ed-2cb7-cbb0-18f6-943098ecef9a@redhat.com>
Date:   Fri, 4 Sep 2020 10:02:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200826093315.5279-9-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 8/26/20 11:33 AM, Diana Craciun wrote:
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
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         |  18 ++-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 160 +++++++++++++++++++++-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  10 ++
>  3 files changed, 186 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 42014297b484..73834f488a94 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -147,12 +147,28 @@ static int vfio_fsl_mc_open(void *device_data)
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
shouldn't you test ret?
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
> index 058aa97aa54a..409f3507fcf3 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> @@ -29,12 +29,149 @@ static int vfio_fsl_mc_irq_unmask(struct vfio_fsl_mc_device *vdev,
>  	return -EINVAL;
>  }
>  
> +int vfio_fsl_mc_irqs_allocate(struct vfio_fsl_mc_device *vdev)
> +{
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	struct vfio_fsl_mc_irq *mc_irq;
> +	int irq_count;
> +	int ret, i;
> +
> +    /* Device does not support any interrupt */
indent needs to be fixed
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
any reason the init is done in the set_irq() and not in the open() if
!vdev->refcnt?
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
>  }
>  
>  int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
> @@ -61,3 +198,24 @@ int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>  
>  	return ret;
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
> index d5b6fe891a48..bbfca8b55f8a 100644
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
> @@ -35,6 +42,7 @@ struct vfio_fsl_mc_device {
>  	struct vfio_fsl_mc_region	*regions;
>  	struct vfio_fsl_mc_reflck   *reflck;
>  	struct mutex         igate;
> +	struct vfio_fsl_mc_irq      *mc_irqs;
>  };
>  
>  extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
> @@ -42,4 +50,6 @@ extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
>  			       unsigned int start, unsigned int count,
>  			       void *data);
>  
> +void vfio_fsl_mc_irqs_cleanup(struct vfio_fsl_mc_device *vdev);
> +
>  #endif /* VFIO_FSL_MC_PRIVATE_H */
> 
Thanks

Eric

