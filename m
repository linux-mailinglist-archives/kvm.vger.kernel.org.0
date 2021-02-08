Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252B431335B
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 14:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhBHNcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 08:32:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhBHNcj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 08:32:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612791071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ids7edbl8LAJtIHFoMkGTWHKBQV1/L2YZ/nq3obrQTE=;
        b=KrKZfxQBk9Ql3BBrWKekSxdYdd14fft3Q1E+Y2F9n09IfKd2+quKjy1HWdm/twfgYbemNq
        1Ae9KCTHNkflXnxQhoLlnhOsMmQUNJFHE3TbxsmVbdn4MQNbfxec+5W2gR/UvOpROJcoUP
        DHoZ01+eUqhjxTx8EzzzLdTpduTQMrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-1ziTRe0kOh2U54lNGExg8A-1; Mon, 08 Feb 2021 08:31:08 -0500
X-MC-Unique: 1ziTRe0kOh2U54lNGExg8A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C24B1966325;
        Mon,  8 Feb 2021 13:31:06 +0000 (UTC)
Received: from [10.36.112.10] (ovpn-112-10.ams2.redhat.com [10.36.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 219F91975E;
        Mon,  8 Feb 2021 13:30:57 +0000 (UTC)
Subject: Re: [RFC v4 1/3] vfio/platform: add support for msi
To:     Vikas Gupta <vikas.gupta@broadcom.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vikram.prakash@broadcom.com, srinath.mannam@broadcom.com,
        ashwin.kamath@broadcom.com, zachary.schroff@broadcom.com,
        manish.kurup@broadcom.com
References: <20201214174514.22006-1-vikas.gupta@broadcom.com>
 <20210129172421.43299-1-vikas.gupta@broadcom.com>
 <20210129172421.43299-2-vikas.gupta@broadcom.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <017faa61-930a-338e-3d60-08599eaaabcb@redhat.com>
Date:   Mon, 8 Feb 2021 14:30:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210129172421.43299-2-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 1/29/21 6:24 PM, Vikas Gupta wrote:
> MSI support for platform devices. MSI is added
s/MSI support/ Add MSI support
> as a single 'index' with 'count' as the number of
> MSI(s) supported by the devices.
as a single 'index' following the last wired irq index index, with count.

It allows to associate eventfds to MSIs.

If MSI is supported, specialization callbacks need to be implemented in
the reset module (of_get_msi and of_msi_write).
> 
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> ---
>  drivers/vfio/platform/Kconfig                 |   1 +
>  drivers/vfio/platform/vfio_platform_common.c  |  95 ++++++-
>  drivers/vfio/platform/vfio_platform_irq.c     | 253 ++++++++++++++++--
>  drivers/vfio/platform/vfio_platform_private.h |  29 ++
>  include/uapi/linux/vfio.h                     |  24 ++
>  5 files changed, 373 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index dc1a3c44f2c6..d4bbc9f27763 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -3,6 +3,7 @@ config VFIO_PLATFORM
>  	tristate "VFIO support for platform devices"
>  	depends on VFIO && EVENTFD && (ARM || ARM64)
>  	select VFIO_VIRQFD
> +	select GENERIC_MSI_IRQ_DOMAIN
>  	help
>  	  Support for platform devices with VFIO. This is required to make
>  	  use of platform devices present on the system using the VFIO
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index fb4b385191f2..f2b1f0c3bfcc 100644
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
> @@ -28,23 +29,22 @@
>  static LIST_HEAD(reset_list);
>  static DEFINE_MUTEX(driver_lock);
>  
> -static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const char *compat,
> -					struct module **module)
> +static void vfio_platform_lookup_reset(const char *compat,
> +				       struct module **module,
> +				       struct vfio_platform_reset_node **node)
nit: I would prefer this function directly returns a
struct vfio_platform_reset_node *
>  {
>  	struct vfio_platform_reset_node *iter;
> -	vfio_platform_reset_fn_t reset_fn = NULL;
>  
>  	mutex_lock(&driver_lock);
>  	list_for_each_entry(iter, &reset_list, link) {
>  		if (!strcmp(iter->compat, compat) &&
>  			try_module_get(iter->owner)) {
>  			*module = iter->owner;
> -			reset_fn = iter->of_reset;
> +			*node = iter;
>  			break;
>  		}
>  	}
>  	mutex_unlock(&driver_lock);
> -	return reset_fn;
>  }
>  
>  static int vfio_platform_acpi_probe(struct vfio_platform_device *vdev,> @@ -112,15 +112,23 @@ static bool vfio_platform_has_reset(struct
vfio_platform_device *vdev)
> 
>  static int vfio_platform_get_reset(struct vfio_platform_device *vdev)
>  {
> +	struct vfio_platform_reset_node *node = NULL;
> +
>  	if (VFIO_PLATFORM_IS_ACPI(vdev))
>  		return vfio_platform_acpi_has_reset(vdev) ? 0 : -ENOENT;
>  
> -	vdev->of_reset = vfio_platform_lookup_reset(vdev->compat,
> -						    &vdev->reset_module);
> -	if (!vdev->of_reset) {
> +	vfio_platform_lookup_reset(vdev->compat, &vdev->reset_module,
> +				   &node);
> +	if (!node) {
>  		request_module("vfio-reset:%s", vdev->compat);
> -		vdev->of_reset = vfio_platform_lookup_reset(vdev->compat,
> -							&vdev->reset_module);
> +		vfio_platform_lookup_reset(vdev->compat, &vdev->reset_module,
> +					   &node);
> +	}
> +
> +	if (node) {
> +		vdev->of_reset = node->of_reset;
> +		vdev->of_get_msi = node->of_get_msi;
> +		vdev->of_msi_write = node->of_msi_write;>  	}
>  
>  	return vdev->of_reset ? 0 : -ENOENT;
> @@ -343,9 +351,16 @@ static long vfio_platform_ioctl(void *device_data,
>  
>  	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
>  		struct vfio_irq_info info;
> +		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +		int ext_irq_index = vdev->num_irqs - vdev->num_ext_irqs;
> +		unsigned long capsz;
> +		u32 index;
>  
>  		minsz = offsetofend(struct vfio_irq_info, count);
>  
> +		/* For backward compatibility, cannot require this */
> +		capsz = offsetofend(struct vfio_irq_info, cap_offset);
> +
>  		if (copy_from_user(&info, (void __user *)arg, minsz))
>  			return -EFAULT;
>  
> @@ -355,8 +370,53 @@ static long vfio_platform_ioctl(void *device_data,
>  		if (info.index >= vdev->num_irqs)
>  			return -EINVAL;
>  
> -		info.flags = vdev->irqs[info.index].flags;
> -		info.count = vdev->irqs[info.index].count;
> +		if (info.argsz >= capsz)
> +			minsz = capsz;
> +
> +		index = info.index;
> +
> +		info.flags = vdev->irqs[index].flags;
> +		info.count = vdev->irqs[index].count;
> +
> +		if (ext_irq_index - index == VFIO_EXT_IRQ_MSI) {
> +			struct vfio_irq_info_cap_type cap_type = {
> +				.header.id = VFIO_IRQ_INFO_CAP_TYPE,
> +				.header.version = 1 };
> +			struct vfio_platform_irq *irq;
> +			int ret;
> +
> +			index = array_index_nospec(index,
> +						   vdev->num_irqs);
> +			irq = &vdev->irqs[index];
> +
> +			cap_type.type = irq->type;
> +			cap_type.subtype = irq->subtype;
> +
> +			ret = vfio_info_add_capability(&caps,
> +						       &cap_type.header,
> +						       sizeof(cap_type));
> +			if (ret)
> +				return ret;
> +		}
> +
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
> +					kfree(caps.buf);
> +					return -EFAULT;
> +				}
> +				info.cap_offset = sizeof(info);
> +			}
> +
> +			kfree(caps.buf);
> +		}
>  
>  		return copy_to_user((void __user *)arg, &info, minsz) ?
>  			-EFAULT : 0;
> @@ -365,6 +425,7 @@ static long vfio_platform_ioctl(void *device_data,
>  		struct vfio_irq_set hdr;
>  		u8 *data = NULL;
>  		int ret = 0;
> +		int max;
>  		size_t data_size = 0;
>  
>  		minsz = offsetofend(struct vfio_irq_set, count);
> @@ -372,8 +433,14 @@ static long vfio_platform_ioctl(void *device_data,
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
> index c5b09ec0a3c9..db60240d27ca 100644
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
> @@ -253,6 +255,186 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
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
> +	struct device *dev = msi_desc_to_dev(desc);
> +	struct vfio_device *device = dev_get_drvdata(dev);
> +	struct vfio_platform_device *vdev = (struct vfio_platform_device *)
> +						vfio_device_data(device);
> +
> +	vdev->of_msi_write(vdev, desc, msg);
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
looks a bit weird to me that in case of failure we do not do the same as
below (ie. vfio_msi_disable). The pci code does the same but I fail to
understand the logic.
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
> @@ -261,16 +443,29 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
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
> @@ -281,12 +476,23 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>  
>  int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  {
> -	int cnt = 0, i;
> +	int i;
> +	int cnt = 0;
> +	int num_irqs = 0;
> +	int msi_cnt = 0;
>  
>  	while (vdev->get_irq(vdev, cnt) >= 0)
>  		cnt++;
>  
> -	vdev->irqs = kcalloc(cnt, sizeof(struct vfio_platform_irq), GFP_KERNEL);
> +	num_irqs = cnt;
> +
> +	if (vdev->of_get_msi) {
I think you also need to test that of_msi_write also is non null?
> +		msi_cnt = vdev->of_get_msi(vdev);
> +		num_irqs++;
> +	}
> +
> +	vdev->irqs = kcalloc(num_irqs, sizeof(struct vfio_platform_irq),
> +			     GFP_KERNEL);
>  	if (!vdev->irqs)
>  		return -ENOMEM;
>  
> @@ -309,7 +515,19 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  		vdev->irqs[i].masked = false;
>  	}
>  
> -	vdev->num_irqs = cnt;
> +	/*
> +	 * MSI block is added at last index and it is an ext irq
> +	 */
> +	if (msi_cnt > 0) {
> +		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
> +		vdev->irqs[i].count = msi_cnt;
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
> @@ -321,8 +539,13 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
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
> index 289089910643..b8dd892aec53 100644
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
> @@ -19,9 +20,21 @@
>  #define VFIO_PLATFORM_INDEX_TO_OFFSET(index)	\
>  	((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
>  
> +/* IRQ index for MSI in ext IRQs */
> +#define VFIO_EXT_IRQ_MSI	0
> +
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
> @@ -29,6 +42,11 @@ struct vfio_platform_irq {
>  	spinlock_t		lock;
>  	struct virqfd		*unmask;
>  	struct virqfd		*mask;
> +
> +	/* for extended irqs */
> +	u32			type;
> +	u32			subtype;
> +	int			config_msi;
bool?
>  };
>  
>  struct vfio_platform_region {
> @@ -46,6 +64,7 @@ struct vfio_platform_device {
>  	u32				num_regions;
>  	struct vfio_platform_irq	*irqs;
>  	u32				num_irqs;
> +	int				num_ext_irqs;
>  	int				refcnt;
>  	struct mutex			igate;
>  	struct module			*parent_module;
> @@ -65,17 +84,27 @@ struct vfio_platform_device {
>  		(*get_resource)(struct vfio_platform_device *vdev, int i);
>  	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
>  	int	(*of_reset)(struct vfio_platform_device *vdev);
> +	u32	(*of_get_msi)(struct vfio_platform_device *vdev);
> +	void	(*of_msi_write)(struct vfio_platform_device *vdev,
> +				struct msi_desc *desc,
> +				struct msi_msg *msg);
>  
>  	bool				reset_required;
>  };
>  
>  typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);
> +typedef u32 (*vfio_platform_get_msi_fn_t)(struct vfio_platform_device *vdev);
> +typedef void (*vfio_platform_msi_write_fn_t)(struct vfio_platform_device *vdev,
> +					     struct msi_desc *desc,
> +					     struct msi_msg *msg);
>  
>  struct vfio_platform_reset_node {
>  	struct list_head link;
>  	char *compat;
>  	struct module *owner;
>  	vfio_platform_reset_fn_t of_reset;
> +	vfio_platform_get_msi_fn_t of_get_msi;
> +	vfio_platform_msi_write_fn_t of_msi_write;
>  };
>  
>  extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index d1812777139f..8e2c0131781d 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -697,11 +697,35 @@ struct vfio_irq_info {
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
>  /**
>   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
>   *
> 
Besides looks good to me.

Thanks

Eric

