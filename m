Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5082CC003
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 15:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgLBOp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 09:45:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727792AbgLBOp4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 09:45:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606920268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cim7xvgqF5UTQn1bxpHi0nuJHksE6wUzL5FkZQCG3gU=;
        b=d6rblwtQbuz59sueUr5idQVP0OYhhLWTirPy6f28Tygt20qECalpjufc7M/I/n/wiW558T
        tWRt49eQDdt7Ut/V+O5yTyy97Yo/O302Z2EEGu3BwI1y/oaiY52GO38X8l/CZnYWEHzevu
        5hup0ES1vPKgDGZsaRFCxE/H14TiqvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-uzmKYSsaO4uvZq2TVc3vQg-1; Wed, 02 Dec 2020 09:44:24 -0500
X-MC-Unique: uzmKYSsaO4uvZq2TVc3vQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99F4E107464B;
        Wed,  2 Dec 2020 14:44:21 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF98760636;
        Wed,  2 Dec 2020 14:44:15 +0000 (UTC)
Subject: Re: [RFC v2 1/1] vfio/platform: add support for msi
To:     Vikas Gupta <vikas.gupta@broadcom.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vikram.prakash@broadcom.com, srinath.mannam@broadcom.com,
        ashwin.kamath@broadcom.com, zachary.schroff@broadcom.com,
        manish.kurup@broadcom.com
References: <20201112175852.21572-1-vikas.gupta@broadcom.com>
 <20201124161646.41191-1-vikas.gupta@broadcom.com>
 <20201124161646.41191-2-vikas.gupta@broadcom.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <73830e85-035f-88ac-7aec-a818e83c2d5a@redhat.com>
Date:   Wed, 2 Dec 2020 15:44:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201124161646.41191-2-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 11/24/20 5:16 PM, Vikas Gupta wrote:
> MSI support for platform devices.
> 
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> ---
>  drivers/vfio/platform/vfio_platform_common.c  |  99 ++++++-
>  drivers/vfio/platform/vfio_platform_irq.c     | 260 +++++++++++++++++-
>  drivers/vfio/platform/vfio_platform_private.h |  16 ++
>  include/uapi/linux/vfio.h                     |  43 +++
>  4 files changed, 401 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index c0771a9567fb..b0bfc0f4ee1f 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -16,6 +16,7 @@
>  #include <linux/types.h>
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
> +#include <linux/nospec.h>
>  
>  #include "vfio_platform_private.h"
>  
> @@ -344,9 +345,16 @@ static long vfio_platform_ioctl(void *device_data,
>  
>  	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
>  		struct vfio_irq_info info;
> +		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +		struct vfio_irq_info_cap_msi *msi_info = NULL;
> +		unsigned long capsz;
> +		int ext_irq_index = vdev->num_irqs - vdev->num_ext_irqs;
>  
>  		minsz = offsetofend(struct vfio_irq_info, count);
>  
> +		/* For backward compatibility, cannot require this */
> +		capsz = offsetofend(struct vfio_irq_info, cap_offset);
> +
>  		if (copy_from_user(&info, (void __user *)arg, minsz))
>  			return -EFAULT;
>  
> @@ -356,9 +364,89 @@ static long vfio_platform_ioctl(void *device_data,
>  		if (info.index >= vdev->num_irqs)
>  			return -EINVAL;
>  
> +		if (info.argsz >= capsz)
> +			minsz = capsz;
> +
> +		if (info.index == ext_irq_index) {
nit: n case we add new ext indices afterwards, I would check info.index
-  ext_irq_index against an VFIO_EXT_IRQ_MSI define.
> +			struct vfio_irq_info_cap_type cap_type = {
> +				.header.id = VFIO_IRQ_INFO_CAP_TYPE,
> +				.header.version = 1 };
> +			int i;
> +			int ret;
> +			int num_msgs;
> +			size_t msi_info_size;
> +			struct vfio_platform_irq *irq;
nit: I think generally the opposite order (length) is chosen. This also
would better match the existing style in this file
> +
> +			info.index = array_index_nospec(info.index,
> +							vdev->num_irqs);
> +
> +			irq = &vdev->irqs[info.index];
> +
> +			info.flags = irq->flags;
I think this can be removed given [*]
> +			cap_type.type = irq->type;
> +			cap_type.subtype = irq->subtype;
> +
> +			ret = vfio_info_add_capability(&caps,
> +						       &cap_type.header,
> +						       sizeof(cap_type));
> +			if (ret)
> +				return ret;
> +
> +			num_msgs = irq->num_ctx;
do would want to return the cap even if !num_ctx?
> +
> +			msi_info_size = struct_size(msi_info, msgs, num_msgs);
> +
> +			msi_info = kzalloc(msi_info_size, GFP_KERNEL);
> +			if (!msi_info) {
> +				kfree(caps.buf);
> +				return -ENOMEM;
> +			}
> +
> +			msi_info->header.id = VFIO_IRQ_INFO_CAP_MSI_DESCS;
> +			msi_info->header.version = 1;
> +			msi_info->nr_msgs = num_msgs;
> +
> +			for (i = 0; i < num_msgs; i++) {
> +				struct vfio_irq_ctx *ctx = &irq->ctx[i];
> +
> +				msi_info->msgs[i].addr_lo = ctx->msg.address_lo;
> +				msi_info->msgs[i].addr_hi = ctx->msg.address_hi;
> +				msi_info->msgs[i].data = ctx->msg.data;
> +			}
> +
> +			ret = vfio_info_add_capability(&caps, &msi_info->header,
> +						       msi_info_size);
> +			if (ret) {
> +				kfree(msi_info);
> +				kfree(caps.buf);
> +				return ret;
> +			}
> +		}
> +
>  		info.flags = vdev->irqs[info.index].flags;
[*]
>  		info.count = vdev->irqs[info.index].count;
>  
> +		if (caps.size) {
> +			info.flags |= VFIO_IRQ_INFO_FLAG_CAPS;
> +			if (info.argsz < sizeof(info) + caps.size) {
> +				info.argsz = sizeof(info) + caps.size;
> +				info.cap_offset = 0;
> +			} else {
> +				vfio_info_cap_shift(&caps, sizeof(info));
> +				if (copy_to_user((void __user *)arg +
> +						  sizeof(info), caps.buf,
> +						  caps.size)) {
> +					kfree(msi_info);
> +					kfree(caps.buf);
> +					return -EFAULT;
> +				}
> +				info.cap_offset = sizeof(info);
> +			}
> +
> +			kfree(msi_info);
> +			kfree(caps.buf);
> +		}
> +
>  		return copy_to_user((void __user *)arg, &info, minsz) ?
>  			-EFAULT : 0;
>  
> @@ -366,6 +454,7 @@ static long vfio_platform_ioctl(void *device_data,
>  		struct vfio_irq_set hdr;
>  		u8 *data = NULL;
>  		int ret = 0;
> +		int max;
>  		size_t data_size = 0;
>  
>  		minsz = offsetofend(struct vfio_irq_set, count);
> @@ -373,8 +462,14 @@ static long vfio_platform_ioctl(void *device_data,
>  		if (copy_from_user(&hdr, (void __user *)arg, minsz))
>  			return -EFAULT;
>  
> -		ret = vfio_set_irqs_validate_and_prepare(&hdr, vdev->num_irqs,
> -						 vdev->num_irqs, &data_size);
> +		if (hdr.index >= vdev->num_irqs)
> +			return -EINVAL;
> +
> +		max = vdev->irqs[hdr.index].count;
> +
> +		ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
> +							 vdev->num_irqs,
> +							 &data_size);
>  		if (ret)
>  			return ret;
>  
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index c5b09ec0a3c9..4066223e5b2e 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -8,10 +8,12 @@
>  
>  #include <linux/eventfd.h>
>  #include <linux/interrupt.h>
> +#include <linux/eventfd.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/vfio.h>
>  #include <linux/irq.h>
> +#include <linux/msi.h>
>  
>  #include "vfio_platform_private.h"
>  
> @@ -253,6 +255,195 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
>  	return 0;
>  }
>  
> +/* MSI/MSIX */
> +static irqreturn_t vfio_msihandler(int irq, void *arg)
> +{
> +	struct eventfd_ctx *trigger = arg;
> +
> +	eventfd_signal(trigger, 1);
> +	return IRQ_HANDLED;
> +}
> +
> +static void msi_write(struct msi_desc *desc, struct msi_msg *msg)
> +{
> +	int i;
> +	struct vfio_platform_irq *irq;
> +	u16 index = desc->platform.msi_index;
> +	struct device *dev = msi_desc_to_dev(desc);
> +	struct vfio_device *device = dev_get_drvdata(dev);
> +	struct vfio_platform_device *vdev = (struct vfio_platform_device *)
> +						vfio_device_data(device);
> +
> +	for (i = 0; i < vdev->num_irqs; i++)
> +		if (vdev->irqs[i].type == VFIO_IRQ_TYPE_MSI)
> +			irq = &vdev->irqs[i];
> +
> +	irq->ctx[index].msg.address_lo = msg->address_lo;
> +	irq->ctx[index].msg.address_hi = msg->address_hi;
> +	irq->ctx[index].msg.data = msg->data;
> +}
> +
> +static int vfio_msi_enable(struct vfio_platform_device *vdev,
> +			   struct vfio_platform_irq *irq, int nvec)
> +{
> +	int ret;
> +	int msi_idx = 0;
> +	struct msi_desc *desc;
> +	struct device *dev = vdev->device;
> +
> +	irq->ctx = kcalloc(nvec, sizeof(struct vfio_irq_ctx), GFP_KERNEL);
> +	if (!irq->ctx)
> +		return -ENOMEM;
> +
> +	/* Allocate platform MSIs */
> +	ret = platform_msi_domain_alloc_irqs(dev, nvec, msi_write);
> +	if (ret < 0) {
> +		kfree(irq->ctx);
> +		return ret;
> +	}
> +
> +	for_each_msi_entry(desc, dev) {
> +		irq->ctx[msi_idx].hwirq = desc->irq;
> +		msi_idx++;
> +	}
> +
> +	irq->num_ctx = nvec;
> +	irq->config_msi = 1;
> +
> +	return 0;
> +}
> +
> +static int vfio_msi_set_vector_signal(struct vfio_platform_irq *irq,
> +				      int vector, int fd)
> +{
> +	struct eventfd_ctx *trigger;
> +	int irq_num, ret;
> +
> +	if (vector < 0 || vector >= irq->num_ctx)
> +		return -EINVAL;
> +
> +	irq_num = irq->ctx[vector].hwirq;
> +
> +	if (irq->ctx[vector].trigger) {
> +		free_irq(irq_num, irq->ctx[vector].trigger);
> +		kfree(irq->ctx[vector].name);
> +		eventfd_ctx_put(irq->ctx[vector].trigger);
> +		irq->ctx[vector].trigger = NULL;
> +	}
> +
> +	if (fd < 0)
> +		return 0;
> +
> +	irq->ctx[vector].name = kasprintf(GFP_KERNEL,
> +					  "vfio-msi[%d]", vector);
> +	if (!irq->ctx[vector].name)
> +		return -ENOMEM;
> +
> +	trigger = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(trigger)) {
> +		kfree(irq->ctx[vector].name);
> +		return PTR_ERR(trigger);
> +	}
> +
> +	ret = request_irq(irq_num, vfio_msihandler, 0,
> +			  irq->ctx[vector].name, trigger);
> +	if (ret) {
> +		kfree(irq->ctx[vector].name);
> +		eventfd_ctx_put(trigger);
> +		return ret;
> +	}
> +
> +	irq->ctx[vector].trigger = trigger;
> +
> +	return 0;
> +}
> +
> +static int vfio_msi_set_block(struct vfio_platform_irq *irq, unsigned int start,
> +			      unsigned int count, int32_t *fds)
> +{
> +	int i, j, ret = 0;
> +
> +	if (start >= irq->num_ctx || start + count > irq->num_ctx)
> +		return -EINVAL;
> +
> +	for (i = 0, j = start; i < count && !ret; i++, j++) {
> +		int fd = fds ? fds[i] : -1;
> +
> +		ret = vfio_msi_set_vector_signal(irq, j, fd);
> +	}
> +
> +	if (ret) {
> +		for (--j; j >= (int)start; j--)
> +			vfio_msi_set_vector_signal(irq, j, -1);
> +	}
> +
> +	return ret;
> +}
> +
> +static void vfio_msi_disable(struct vfio_platform_device *vdev,
> +			     struct vfio_platform_irq *irq)
> +{
> +	struct device *dev = vdev->device;
> +
> +	vfio_msi_set_block(irq, 0, irq->num_ctx, NULL);
> +
> +	platform_msi_domain_free_irqs(dev);
> +
> +	irq->config_msi = 0;
> +	irq->num_ctx = 0;
> +
> +	kfree(irq->ctx);
> +}
> +
> +static int vfio_set_msi_trigger(struct vfio_platform_device *vdev,
> +				unsigned int index, unsigned int start,
> +				unsigned int count, uint32_t flags, void *data)
> +{
> +	int i;
> +	struct vfio_platform_irq *irq = &vdev->irqs[index];
> +
> +	if (start + count > irq->count)
> +		return -EINVAL;
> +
> +	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> +		vfio_msi_disable(vdev, irq);
> +		return 0;
> +	}
> +
> +	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> +		s32 *fds = data;
> +		int ret;
> +
> +		if (irq->config_msi)
> +			return vfio_msi_set_block(irq, start, count,
> +						  fds);
> +		ret = vfio_msi_enable(vdev, irq, start + count);
> +		if (ret)
> +			return ret;
> +
> +		ret = vfio_msi_set_block(irq, start, count, fds);
> +		if (ret)
> +			vfio_msi_disable(vdev, irq);
> +
> +		return ret;
> +	}
> +
> +	for (i = start; i < start + count; i++) {
> +		if (!irq->ctx[i].trigger)
> +			continue;
> +		if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +			eventfd_signal(irq->ctx[i].trigger, 1);
> +		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> +			u8 *bools = data;
> +
> +			if (bools[i - start])
> +				eventfd_signal(irq->ctx[i].trigger, 1);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>  				 uint32_t flags, unsigned index, unsigned start,
>  				 unsigned count, void *data)
> @@ -261,16 +452,29 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>  		    unsigned start, unsigned count, uint32_t flags,
>  		    void *data) = NULL;
>  
> -	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> -	case VFIO_IRQ_SET_ACTION_MASK:
> -		func = vfio_platform_set_irq_mask;
> -		break;
> -	case VFIO_IRQ_SET_ACTION_UNMASK:
> -		func = vfio_platform_set_irq_unmask;
> -		break;
> -	case VFIO_IRQ_SET_ACTION_TRIGGER:
> -		func = vfio_platform_set_irq_trigger;
> -		break;
> +	struct vfio_platform_irq *irq = &vdev->irqs[index];
> +
> +	if (irq->type == VFIO_IRQ_TYPE_MSI) {
> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +		case VFIO_IRQ_SET_ACTION_MASK:
> +		case VFIO_IRQ_SET_ACTION_UNMASK:
> +			break;
> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
> +			func = vfio_set_msi_trigger;
> +			break;
> +		}
> +	} else {
> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +		case VFIO_IRQ_SET_ACTION_MASK:
> +			func = vfio_platform_set_irq_mask;
> +			break;
> +		case VFIO_IRQ_SET_ACTION_UNMASK:
> +			func = vfio_platform_set_irq_unmask;
> +			break;
> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
> +			func = vfio_platform_set_irq_trigger;
> +			break;
> +		}
>  	}
>  
>  	if (!func)
> @@ -281,12 +485,21 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>  
>  int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  {
> -	int cnt = 0, i;
> +	int i;
> +	int cnt = 0;
> +	int num_irqs;
> +	struct device *dev = vdev->device;
>  
>  	while (vdev->get_irq(vdev, cnt) >= 0)
>  		cnt++;
>  
> -	vdev->irqs = kcalloc(cnt, sizeof(struct vfio_platform_irq), GFP_KERNEL);
> +	num_irqs = cnt;
> +
> +	if (dev->msi_domain)
> +		num_irqs++;
> +
> +	vdev->irqs = kcalloc(num_irqs, sizeof(struct vfio_platform_irq),
> +			     GFP_KERNEL);
>  	if (!vdev->irqs)
>  		return -ENOMEM;
>  
> @@ -309,7 +522,19 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  		vdev->irqs[i].masked = false;
>  	}
>  
> -	vdev->num_irqs = cnt;
> +	/*
> +	 * MSI block is added at last index and its an ext irq
it is
> +	 */
> +	if (dev->msi_domain) {
> +		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
> +		vdev->irqs[i].count = NR_IRQS;
why NR_IRQS?
> +		vdev->irqs[i].hwirq = 0;
> +		vdev->irqs[i].masked = false;
> +		vdev->irqs[i].type = VFIO_IRQ_TYPE_MSI;
> +		vdev->num_ext_irqs = 1;
> +	}
> +
> +	vdev->num_irqs = num_irqs;
>  
>  	return 0;
>  err:
> @@ -321,8 +546,13 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>  {
>  	int i;
>  
> -	for (i = 0; i < vdev->num_irqs; i++)
> -		vfio_set_trigger(vdev, i, -1, NULL);
> +	for (i = 0; i < vdev->num_irqs; i++) {
> +		if (vdev->irqs[i].type == VFIO_IRQ_TYPE_MSI)
> +			vfio_set_msi_trigger(vdev, i, 0, 0,
> +					     VFIO_IRQ_SET_DATA_NONE, NULL);
> +		else
> +			vfio_set_trigger(vdev, i, -1, NULL);
> +	}
>  
>  	vdev->num_irqs = 0;
>  	kfree(vdev->irqs);
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index 289089910643..7bbb05988705 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -9,6 +9,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/interrupt.h>
> +#include <linux/msi.h>
>  
>  #define VFIO_PLATFORM_OFFSET_SHIFT   40
>  #define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
> @@ -19,9 +20,18 @@
>  #define VFIO_PLATFORM_INDEX_TO_OFFSET(index)	\
>  	((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
>  
> +struct vfio_irq_ctx {
> +	int			hwirq;
> +	char			*name;
> +	struct msi_msg		msg;
> +	struct eventfd_ctx	*trigger;
> +};
> +
>  struct vfio_platform_irq {
>  	u32			flags;
>  	u32			count;
> +	int			num_ctx;
> +	struct vfio_irq_ctx	*ctx;
>  	int			hwirq;
>  	char			*name;
>  	struct eventfd_ctx	*trigger;
> @@ -29,6 +39,11 @@ struct vfio_platform_irq {
>  	spinlock_t		lock;
>  	struct virqfd		*unmask;
>  	struct virqfd		*mask;
> +
> +	/* for extended irqs */
> +	u32			type;
> +	u32			subtype;
> +	int			config_msi;
>  };
>  
>  struct vfio_platform_region {
> @@ -46,6 +61,7 @@ struct vfio_platform_device {
>  	u32				num_regions;
>  	struct vfio_platform_irq	*irqs;
>  	u32				num_irqs;
> +	int				num_ext_irqs;
>  	int				refcnt;
>  	struct mutex			igate;
>  	struct module			*parent_module;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 2f313a238a8f..598d1c944283 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -697,11 +697,54 @@ struct vfio_irq_info {
>  #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
>  #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
>  #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
> +#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info supports caps */
>  	__u32	index;		/* IRQ index */
>  	__u32	count;		/* Number of IRQs within this index */
> +	__u32	cap_offset;	/* Offset within info struct of first cap */
>  };
>  #define VFIO_DEVICE_GET_IRQ_INFO	_IO(VFIO_TYPE, VFIO_BASE + 9)
>  
> +/*
> + * The irq type capability allows IRQs unique to a specific device or
> + * class of devices to be exposed.
> + *
> + * The structures below define version 1 of this capability.
> + */
> +#define VFIO_IRQ_INFO_CAP_TYPE		3
> +
> +struct vfio_irq_info_cap_type {
> +	struct vfio_info_cap_header header;
> +	__u32 type;     /* global per bus driver */
> +	__u32 subtype;  /* type specific */
> +};
> +
> +/*
> + * List of IRQ types, global per bus driver.
> + * If you introduce a new type, please add it here.
> + */
> +
> +/* Non PCI devices having MSI(s) support */
> +#define VFIO_IRQ_TYPE_MSI		(1)
> +
> +/*
> + * The msi capability allows the user to use the msi msg to
> + * configure the iova for the msi configuration.
> + * The structures below define version 1 of this capability.
> + */
> +#define VFIO_IRQ_INFO_CAP_MSI_DESCS	4
> +
> +struct vfio_irq_msi_msg {
> +	__u32	addr_lo;
> +	__u32	addr_hi;
> +	__u32	data;
> +};
> +
> +struct vfio_irq_info_cap_msi {
> +	struct vfio_info_cap_header header;
> +	__u32 nr_msgs;
I think you should align a __u32   reserved field to have a 64b alignment
> +	struct vfio_irq_msi_msg msgs[];
Please can you clarify why this cap is needed versus your prior approach.
> +};
> +
>  /**
>   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
>   *
> 
Thanks

Eric

