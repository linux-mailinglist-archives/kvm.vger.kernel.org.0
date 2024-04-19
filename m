Return-Path: <kvm+bounces-15377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19EE88AB743
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 00:32:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F5B4B21655
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 22:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B35BE13D63F;
	Fri, 19 Apr 2024 22:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SC35dHzY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF1F364AA
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 22:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713565907; cv=none; b=A8BNN1bJHOv0b9aXZx6AAV0fBQTz28iZL3W8xem3L7sKEtSxroFE0iwqj1FP4jKqCxPRMePs0RNal5JPEijgRAmzy1NvMcd9tVl4XUg7PF6RcgJ5nr/5t9NEJJBsm8LY5E3TU118s3qEWEhOUlfxGt9R0riJnmUnJkB++BJvKyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713565907; c=relaxed/simple;
	bh=SWKHTW+vE5rSSCHXnG6zMVIBLHsIlMjeTFlX+GQyLHo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qI9ruVsHcbkaI/mNUsjdZl+Q84pC0TdeURPbWqJPIYP/hYxNuyMtRfOW7pYPK19ohbKYe9DZo4y5qM1rJqDKR13mSS22sHBVqlsDD0qcBO0fvWkbGh/MUOMDl/XsehPqEZOTHtJ1yjtbctFzBju310Jq8sPaYbmyCzGxmN4PaZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SC35dHzY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713565903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nDkya6NrGCatOuhbr/l4H7bBwW5UTVJla+xUZpevMYM=;
	b=SC35dHzYK7QyLVa3rBofgAKgcdvxOILxmBdD6tReuBfmnjEOckWaSsHTUdUIN8kQfJzgPp
	GSS510ISEqiT0VN8l4WVmXJEMXgLH5BbqWL08b6VMFz3lV4YUjJy/6JGboG4fC5nG/fWD+
	MV4bt5xRBNPkrthltrbQNsZ5mXO2HO0=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-qtCQBM2WPIioZXnYW5q-gA-1; Fri, 19 Apr 2024 18:31:42 -0400
X-MC-Unique: qtCQBM2WPIioZXnYW5q-gA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3699565f54fso33289385ab.0
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 15:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713565901; x=1714170701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nDkya6NrGCatOuhbr/l4H7bBwW5UTVJla+xUZpevMYM=;
        b=Dq6iyS9HMxEl6mfCVo5D27c59jFvd9hXKVEzkW2KwZUFW98Xuw1XZ65+Cv+6GshfvL
         pWPWKpUL9UxdQYWe6nyaw0A6wHlbbegQbCsaCxCAJygtvPbPpkYAoRjGLoeF9iL6IMqr
         bcLOSWEoQJm5E7lHgsiR7fPsZjCRUxdVWBt55T7T6XrpN1B5oGZu3HL3IuSk6evM3cSO
         wJdpBDlr1V8mbzZrruzCwQlCEKNy41XXqI/atOibmNrDM4dLuUITuNfyB10XeZTAXv7p
         CpJ4HxsRw4HPVfE6Wlx9tvT2a9y//UzED4Q+6f7eYAc3xlgTEcrxws1emUFzA6ixDlRK
         ZWXw==
X-Forwarded-Encrypted: i=1; AJvYcCVWML+9OeYR2OTK7PjIshTegzEy3R/EAdwDLdOZ7vsBCsxfcIqBY0tU4QZISVbu0Zt2HnRqOWtPRPrnTsqdPpIBqgmO
X-Gm-Message-State: AOJu0YxB6/PMpGjtEWocIAc+Ub8kJ2/ChNlruz5EjjN6D1i4ld/laOTv
	ymjjgU1GazJUQLYoDuOORAcj2/k4d5YMfMP9JP9XhGohK38IGR6yAXhF99cA6ipP2FeKTgHUAyY
	pl09X0SghMKqHSJx32FuPWNrS84Ao9eXvDjwWrNb9sx38TB9cOA==
X-Received: by 2002:a05:6e02:1848:b0:36a:36d9:36eb with SMTP id b8-20020a056e02184800b0036a36d936ebmr4011214ilv.27.1713565901455;
        Fri, 19 Apr 2024 15:31:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGC/+2XvrhYwanlAfa/P8hsIMDQ/4111LNib+QAD4IuJPFzTRdB68CQVwX3pWt6wnOLDbUs/Q==
X-Received: by 2002:a05:6e02:1848:b0:36a:36d9:36eb with SMTP id b8-20020a056e02184800b0036a36d936ebmr4011183ilv.27.1713565901091;
        Fri, 19 Apr 2024 15:31:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id bt13-20020a056638430d00b0047ef9448e27sm1340576jab.145.2024.04.19.15.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 15:31:40 -0700 (PDT)
Date: Fri, 19 Apr 2024 16:31:38 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Nipun Gupta <nipun.gupta@amd.com>
Cc: <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <maz@kernel.org>,
 <git@amd.com>, <harpreet.anand@amd.com>,
 <pieter.jansen-van-vuuren@amd.com>, <nikhil.agarwal@amd.com>,
 <michal.simek@amd.com>, <abhijit.gangurde@amd.com>,
 <srivatsa@csail.mit.edu>
Subject: Re: [PATCH v5 2/2] vfio/cdx: add interrupt support
Message-ID: <20240419163138.5284fc57.alex.williamson@redhat.com>
In-Reply-To: <20240326040804.640860-2-nipun.gupta@amd.com>
References: <20240326040804.640860-1-nipun.gupta@amd.com>
	<20240326040804.640860-2-nipun.gupta@amd.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 Mar 2024 09:38:04 +0530
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
> Changes v4->v5:
> - Rebased on 6.9-rc1
> 
> Changes v3->v4:
> - Added VFIO_IRQ_INFO_NORESIZE flag
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

Typically DATA_BOOL support is also added here.

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

@index is passed as 1 here.  AFAICT only index zero is supported.  The
SET_IRQS ioctl path catches this in
vfio_set_irqs_validate_and_prepare() but it might cause some strange
behavior here if another index were ever added.

> +}
> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> index 9cff8d75789e..f0861a38ae10 100644
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
> +	info.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_NORESIZE;
> +	info.count = cdx_dev->num_msi;

This should return -EINVAL if cdx_dev->num_msi is zero.

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

You might want to reorder these to avoid holes in the data structures.
vfio_cdx_irq will have a 4byte hole in the middle, vfio_cdx_device will
have a 4byte hole after flags.  config_msi is used as a bool, I'm not
sure why it's defined as a u32.  irq_count also holds a value up to 1,
so a u32 might be oversized.

There's clearly latent support here for devices with multiple MSI
vectors, is this just copying vfio-pci-core or will CDX devices have
multiple MSIs?  Thanks,

Alex

>  
> +int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
> +			    u32 flags, unsigned int index,
> +			    unsigned int start, unsigned int count,
> +			    void *data);
> +
> +void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev);
> +
>  #endif /* VFIO_CDX_PRIVATE_H */


