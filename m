Return-Path: <kvm+bounces-10667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E9986E791
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F159628806A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0BE313AC0;
	Fri,  1 Mar 2024 17:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AUjwQg6/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A424CC8D2
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 17:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315130; cv=none; b=hKLil9Z3cYj9xKsXR73GU8WFMdR2ZIgWCA88OPsMFiHnEptUuKl4HicHWkSsr4S6b1DfdHFzhMqPP1wRKNjCGOBpC+wPRWutAqFkJ7yuDtpL2Js4zEZwix+BpfIIw/4eTmXCfvkLtKoZPIM1N/sYCu0+eVa0qVi69THnsyhLpPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315130; c=relaxed/simple;
	bh=k9hs5LzfsgzidzjXzFsK4sQJTVPTZSv6+igzRYXhxec=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SozJ3RJpy23ew+Wq/QaRChponCsEG0yNVYILa8tzAkCImQZnieF+KjJKPdZ6g5dIKx/A6LquA6pIeWO+Zxeqvy1fxZgJFrXKqMELdOEdLL8N0FgyKTNugjIhezO2R+YBLaLYQTnIFKvn1arPgC7jwaekhffPyLIu69E0Usjd6pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AUjwQg6/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709315127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Y0jh8tHnXksX4G/7DMqlfcFRiyiSCKKtZ4aOoc9Q5Q=;
	b=AUjwQg6/Xyb7sueNZA6z4p597fVxESeUhsPxOJ66DKG3No50XC8qyucWI5VpjlvnLmUQRO
	23wSEgk/rBSGGfgM+3EqCi/EWZpPMluBGyk+hmvR2d2i5saUJJ0kuszEtEXL9e52ro3P1T
	DQclE4epU+4gEumpRbWsaYn0SdONdko=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-azdWEL04PQST4ZnzJJjTLg-1; Fri, 01 Mar 2024 12:45:26 -0500
X-MC-Unique: azdWEL04PQST4ZnzJJjTLg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-365c517132bso23029595ab.0
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 09:45:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709315125; x=1709919925;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Y0jh8tHnXksX4G/7DMqlfcFRiyiSCKKtZ4aOoc9Q5Q=;
        b=bzI6Tt9tNd08E41nZFhtcgppTlvFwTCSEhZrje6MX0pGBgANaaKkmS4BZ9KuwdX52z
         mby8Ahqc/INaeQU8186BJs5yRSoal79eRikDapOgqxO0bS1EVPMdqWrNpkOUh1lPGfbc
         niz4IQMnK79SdphjCv2N+6BdYoVys/PoOSYTF86u/S0buFVL4IKOHBlOZwHZPt830iBU
         MOx88V06D/xxzehXJTdSwLvh2vBvPYd1JhKosjZcZtxMquUlTsonVdOvudHeTiF1Yiqd
         gvTDeczTYZM0j9sA2CaC8A06IsKK/soKoqc8yyn9VvNipQOat5Uw0GU29bqWuxsvoqBt
         LmAg==
X-Forwarded-Encrypted: i=1; AJvYcCVLIXK+6dRp0LsITOGSsV9G7LXoR9cmH3SBO7vDDgsI1MyleP3JMDXzj/QLIyhGFvSCrJV6y2QuXPLNjlXjdGdPikND
X-Gm-Message-State: AOJu0YzgALlLaweRAQTW0Hrz+zvoHcrWtYjqQPCeK0YSHVzZ5UXdPget
	wSCHIIuf9gqfkwVZopAWHD6dMlPpKJ8jTVL5QT3NYRDn25el+GHO4IDLiN0/dmp1AytqK8VHQFW
	7e0Be8qA8RXxWSFpxvH21MdspVag5bdycdfnEtH/V9vtTuogrkg==
X-Received: by 2002:a05:6e02:218d:b0:365:259b:711e with SMTP id j13-20020a056e02218d00b00365259b711emr2924503ila.5.1709315125025;
        Fri, 01 Mar 2024 09:45:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExM6BOqgt0RLu5dLB3GaLhIwc69rByZopmV1GxwgG5A+artDK6XOiQsN3K9gksUeRP3jUKPg==
X-Received: by 2002:a05:6e02:218d:b0:365:259b:711e with SMTP id j13-20020a056e02218d00b00365259b711emr2924485ila.5.1709315124687;
        Fri, 01 Mar 2024 09:45:24 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id j26-20020a056e02219a00b0036431524782sm1005937ila.43.2024.03.01.09.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 09:45:24 -0800 (PST)
Date: Fri, 1 Mar 2024 10:45:21 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Nipun Gupta <nipun.gupta@amd.com>
Cc: <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <maz@kernel.org>,
 <git@amd.com>, <harpreet.anand@amd.com>,
 <pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
 <michal.simek@amd.com>, <abhijit.gangurde@amd.com>,
 <srivatsa@csail.mit.edu>
Subject: Re: [PATCH v3 2/2] vfio/cdx: add interrupt support
Message-ID: <20240301104521.228f8e84.alex.williamson@redhat.com>
In-Reply-To: <20240226084813.101432-2-nipun.gupta@amd.com>
References: <20240226084813.101432-1-nipun.gupta@amd.com>
	<20240226084813.101432-2-nipun.gupta@amd.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 Feb 2024 14:18:13 +0530
Nipun Gupta <nipun.gupta@amd.com> wrote:

> Support the following ioctls for CDX devices:
> - VFIO_DEVICE_GET_IRQ_INFO
> - VFIO_DEVICE_SET_IRQS
> 
> This allows user to set an eventfd for cdx device interrupts and
> trigger this interrupt eventfd from userspace.
> All CDX device interrupts are MSIs. The MSIs are allocated from the
> CDX-MSI domain.
> 
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> ---
> 
> This patch depends on CDX MSI support patch:
> https://lore.kernel.org/lkml/20240226082816.100872-1-nipun.gupta@amd.com/
> 
> Changes v2->v3:
> - Use generic MSI alloc/free APIs instead of CDX MSI APIs
> - Rebased on Linux 6.8-rc6
> 
> Changes v1->v2:
> - Rebased on Linux 6.7-rc1
> 
>  drivers/vfio/cdx/Makefile  |   2 +-
>  drivers/vfio/cdx/intr.c    | 211 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/cdx/main.c    |  60 ++++++++++-
>  drivers/vfio/cdx/private.h |  18 ++++
>  4 files changed, 289 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/cdx/intr.c
> 
> diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
> index cd4a2e6fe609..df92b320122a 100644
> --- a/drivers/vfio/cdx/Makefile
> +++ b/drivers/vfio/cdx/Makefile
> @@ -5,4 +5,4 @@
>  
>  obj-$(CONFIG_VFIO_CDX) += vfio-cdx.o
>  
> -vfio-cdx-objs := main.o
> +vfio-cdx-objs := main.o intr.o
> diff --git a/drivers/vfio/cdx/intr.c b/drivers/vfio/cdx/intr.c
> new file mode 100644
> index 000000000000..4637b57d0242
> --- /dev/null
> +++ b/drivers/vfio/cdx/intr.c
> @@ -0,0 +1,211 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> + */
> +
> +#include <linux/vfio.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/eventfd.h>
> +#include <linux/msi.h>
> +#include <linux/interrupt.h>
> +
> +#include "linux/cdx/cdx_bus.h"
> +#include "private.h"
> +
> +static irqreturn_t vfio_cdx_msihandler(int irq_no, void *arg)
> +{
> +	struct eventfd_ctx *trigger = arg;
> +
> +	eventfd_signal(trigger);
> +	return IRQ_HANDLED;
> +}
> +
> +static int vfio_cdx_msi_enable(struct vfio_cdx_device *vdev, int nvec)
> +{
> +	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
> +	struct device *dev = vdev->vdev.dev;
> +	int msi_idx, ret;
> +
> +	vdev->cdx_irqs = kcalloc(nvec, sizeof(struct vfio_cdx_irq), GFP_KERNEL);
> +	if (!vdev->cdx_irqs)
> +		return -ENOMEM;
> +
> +	ret = cdx_enable_msi(cdx_dev);
> +	if (ret) {
> +		kfree(vdev->cdx_irqs);
> +		return ret;
> +	}
> +
> +	/* Allocate cdx MSIs */
> +	ret = msi_domain_alloc_irqs(dev, MSI_DEFAULT_DOMAIN, nvec);
> +	if (ret) {
> +		cdx_disable_msi(cdx_dev);
> +		kfree(vdev->cdx_irqs);
> +		return ret;
> +	}
> +
> +	for (msi_idx = 0; msi_idx < nvec; msi_idx++)
> +		vdev->cdx_irqs[msi_idx].irq_no = msi_get_virq(dev, msi_idx);
> +
> +	vdev->irq_count = nvec;
> +	vdev->config_msi = 1;
> +
> +	return 0;
> +}
> +
> +static int vfio_cdx_msi_set_vector_signal(struct vfio_cdx_device *vdev,
> +					  int vector, int fd)
> +{
> +	struct eventfd_ctx *trigger;
> +	int irq_no, ret;
> +
> +	if (vector < 0 || vector >= vdev->irq_count)
> +		return -EINVAL;
> +
> +	irq_no = vdev->cdx_irqs[vector].irq_no;
> +
> +	if (vdev->cdx_irqs[vector].trigger) {
> +		free_irq(irq_no, vdev->cdx_irqs[vector].trigger);
> +		kfree(vdev->cdx_irqs[vector].name);
> +		eventfd_ctx_put(vdev->cdx_irqs[vector].trigger);
> +		vdev->cdx_irqs[vector].trigger = NULL;
> +	}
> +
> +	if (fd < 0)
> +		return 0;
> +
> +	vdev->cdx_irqs[vector].name = kasprintf(GFP_KERNEL, "vfio-msi[%d](%s)",
> +						vector, dev_name(vdev->vdev.dev));
> +	if (!vdev->cdx_irqs[vector].name)
> +		return -ENOMEM;
> +
> +	trigger = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(trigger)) {
> +		kfree(vdev->cdx_irqs[vector].name);
> +		return PTR_ERR(trigger);
> +	}
> +
> +	ret = request_irq(irq_no, vfio_cdx_msihandler, 0,
> +			  vdev->cdx_irqs[vector].name, trigger);
> +	if (ret) {
> +		kfree(vdev->cdx_irqs[vector].name);
> +		eventfd_ctx_put(trigger);
> +		return ret;
> +	}
> +
> +	vdev->cdx_irqs[vector].trigger = trigger;
> +
> +	return 0;
> +}
> +
> +static int vfio_cdx_msi_set_block(struct vfio_cdx_device *vdev,
> +				  unsigned int start, unsigned int count,
> +				  int32_t *fds)
> +{
> +	int i, j, ret = 0;
> +
> +	if (start >= vdev->irq_count || start + count > vdev->irq_count)
> +		return -EINVAL;
> +
> +	for (i = 0, j = start; i < count && !ret; i++, j++) {
> +		int fd = fds ? fds[i] : -1;
> +
> +		ret = vfio_cdx_msi_set_vector_signal(vdev, j, fd);
> +	}
> +
> +	if (ret) {
> +		for (--j; j >= (int)start; j--)
> +			vfio_cdx_msi_set_vector_signal(vdev, j, -1);
> +	}
> +
> +	return ret;
> +}
> +
> +static void vfio_cdx_msi_disable(struct vfio_cdx_device *vdev)
> +{
> +	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
> +	struct device *dev = vdev->vdev.dev;
> +
> +	vfio_cdx_msi_set_block(vdev, 0, vdev->irq_count, NULL);
> +
> +	if (!vdev->config_msi)
> +		return;
> +
> +	msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN);
> +	cdx_disable_msi(cdx_dev);
> +	kfree(vdev->cdx_irqs);
> +
> +	vdev->cdx_irqs = NULL;
> +	vdev->irq_count = 0;
> +	vdev->config_msi = 0;
> +}
> +
> +static int vfio_cdx_set_msi_trigger(struct vfio_cdx_device *vdev,
> +				    unsigned int index, unsigned int start,
> +				    unsigned int count, u32 flags,
> +				    void *data)
> +{
> +	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
> +	int i;
> +
> +	if (start + count > cdx_dev->num_msi)
> +		return -EINVAL;
> +
> +	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> +		vfio_cdx_msi_disable(vdev);
> +		return 0;
> +	}
> +
> +	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> +		s32 *fds = data;
> +		int ret;
> +
> +		if (vdev->config_msi)
> +			return vfio_cdx_msi_set_block(vdev, start, count,
> +						  fds);
> +		ret = vfio_cdx_msi_enable(vdev, cdx_dev->num_msi);
> +		if (ret)
> +			return ret;
> +
> +		ret = vfio_cdx_msi_set_block(vdev, start, count, fds);
> +		if (ret)
> +			vfio_cdx_msi_disable(vdev);
> +
> +		return ret;
> +	}
> +
> +	for (i = start; i < start + count; i++) {
> +		if (!vdev->cdx_irqs[i].trigger)
> +			continue;
> +		if (flags & VFIO_IRQ_SET_DATA_NONE)
> +			eventfd_signal(vdev->cdx_irqs[i].trigger);
> +	}
> +
> +	return 0;
> +}
> +
> +int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
> +			    u32 flags, unsigned int index,
> +			    unsigned int start, unsigned int count,
> +			    void *data)
> +{
> +	if (flags & VFIO_IRQ_SET_ACTION_TRIGGER)
> +		return vfio_cdx_set_msi_trigger(vdev, index, start,
> +			  count, flags, data);
> +	else
> +		return -EINVAL;
> +}
> +
> +/* Free All IRQs for the given device */
> +void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev)
> +{
> +	/*
> +	 * Device does not support any interrupt or the interrupts
> +	 * were not configured
> +	 */
> +	if (!vdev->cdx_irqs)
> +		return;
> +
> +	vfio_cdx_set_msi_trigger(vdev, 1, 0, 0, VFIO_IRQ_SET_DATA_NONE, NULL);
> +}
> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> index 9cff8d75789e..eb1c5879150b 100644
> --- a/drivers/vfio/cdx/main.c
> +++ b/drivers/vfio/cdx/main.c
> @@ -61,6 +61,7 @@ static void vfio_cdx_close_device(struct vfio_device *core_vdev)
>  
>  	kfree(vdev->regions);
>  	cdx_dev_reset(core_vdev->dev);
> +	vfio_cdx_irqs_cleanup(vdev);
>  }
>  
>  static int vfio_cdx_bm_ctrl(struct vfio_device *core_vdev, u32 flags,
> @@ -123,7 +124,7 @@ static int vfio_cdx_ioctl_get_info(struct vfio_cdx_device *vdev,
>  	info.flags |= VFIO_DEVICE_FLAGS_RESET;
>  
>  	info.num_regions = cdx_dev->res_count;
> -	info.num_irqs = 0;
> +	info.num_irqs = cdx_dev->num_msi ? 1 : 0;
>  
>  	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
>  }
> @@ -152,6 +153,59 @@ static int vfio_cdx_ioctl_get_region_info(struct vfio_cdx_device *vdev,
>  	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
>  }
>  
> +static int vfio_cdx_ioctl_get_irq_info(struct vfio_cdx_device *vdev,
> +				       struct vfio_irq_info __user *arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_irq_info, count);
> +	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
> +	struct vfio_irq_info info;
> +
> +	if (copy_from_user(&info, arg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	if (info.index >= 1)
> +		return -EINVAL;
> +
> +	info.flags = VFIO_IRQ_INFO_EVENTFD;


I think the way you're using this you'd also need the
VFIO_IRQ_INFO_NORESIZE to indicate the MSI range cannot be expanded
from the initial setting.  Thanks,

Alex

> +	info.count = cdx_dev->num_msi;
> +
> +	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
> +}
> +
> +static int vfio_cdx_ioctl_set_irqs(struct vfio_cdx_device *vdev,
> +				   struct vfio_irq_set __user *arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
> +	struct cdx_device *cdx_dev = to_cdx_device(vdev->vdev.dev);
> +	struct vfio_irq_set hdr;
> +	size_t data_size = 0;
> +	u8 *data = NULL;
> +	int ret = 0;
> +
> +	if (copy_from_user(&hdr, arg, minsz))
> +		return -EFAULT;
> +
> +	ret = vfio_set_irqs_validate_and_prepare(&hdr, cdx_dev->num_msi,
> +						 1, &data_size);
> +	if (ret)
> +		return ret;
> +
> +	if (data_size) {
> +		data = memdup_user(arg->data, data_size);
> +		if (IS_ERR(data))
> +			return PTR_ERR(data);
> +	}
> +
> +	ret = vfio_cdx_set_irqs_ioctl(vdev, hdr.flags, hdr.index,
> +				      hdr.start, hdr.count, data);
> +	kfree(data);
> +
> +	return ret;
> +}
> +
>  static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
>  			   unsigned int cmd, unsigned long arg)
>  {
> @@ -164,6 +218,10 @@ static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
>  		return vfio_cdx_ioctl_get_info(vdev, uarg);
>  	case VFIO_DEVICE_GET_REGION_INFO:
>  		return vfio_cdx_ioctl_get_region_info(vdev, uarg);
> +	case VFIO_DEVICE_GET_IRQ_INFO:
> +		return vfio_cdx_ioctl_get_irq_info(vdev, uarg);
> +	case VFIO_DEVICE_SET_IRQS:
> +		return vfio_cdx_ioctl_set_irqs(vdev, uarg);
>  	case VFIO_DEVICE_RESET:
>  		return cdx_dev_reset(core_vdev->dev);
>  	default:
> diff --git a/drivers/vfio/cdx/private.h b/drivers/vfio/cdx/private.h
> index 8e9d25913728..7a8477ae4652 100644
> --- a/drivers/vfio/cdx/private.h
> +++ b/drivers/vfio/cdx/private.h
> @@ -13,6 +13,14 @@ static inline u64 vfio_cdx_index_to_offset(u32 index)
>  	return ((u64)(index) << VFIO_CDX_OFFSET_SHIFT);
>  }
>  
> +struct vfio_cdx_irq {
> +	u32			flags;
> +	u32			count;
> +	int			irq_no;
> +	struct eventfd_ctx	*trigger;
> +	char			*name;
> +};
> +
>  struct vfio_cdx_region {
>  	u32			flags;
>  	u32			type;
> @@ -25,6 +33,16 @@ struct vfio_cdx_device {
>  	struct vfio_cdx_region	*regions;
>  	u32			flags;
>  #define BME_SUPPORT BIT(0)
> +	struct vfio_cdx_irq	*cdx_irqs;
> +	u32			irq_count;
> +	u32			config_msi;
>  };
>  
> +int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
> +			    u32 flags, unsigned int index,
> +			    unsigned int start, unsigned int count,
> +			    void *data);
> +
> +void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev);
> +
>  #endif /* VFIO_CDX_PRIVATE_H */


