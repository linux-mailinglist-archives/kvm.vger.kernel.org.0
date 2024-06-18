Return-Path: <kvm+bounces-19889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8609A90DD6F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 22:29:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EF281F22BE6
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 20:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DEBF1741DA;
	Tue, 18 Jun 2024 20:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eWO9seBw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E533739AEC
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 20:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718742585; cv=none; b=nyIyzPJTxQnxG85ZfiuTz01zBNe1E5OD7efQa0L/LUt2ZeL6XsRYgfYu2ToLXRR54q2iI/3l/Grbc3vUZROcdGMXbOFptRHxhUC/NCv/q82lKU9Sd1Bb2pjO/oBxQDz5XP9LR4h+UreMi2gMFM7dJcJvxxPMFQABrslPfRbzSdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718742585; c=relaxed/simple;
	bh=0EY5kqxsoldm7cuYsyNd9fah7kjTj3xoaitJlbVR78k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ne5csXLHvYzZqjoGSYwYk2if5lPJHpUgkqyX55C0p1E2qfGFaG2a7hV7KDZoTzSlVUGtAD3F5TE8ErxrldUS9tHnKpudfwr4/e1DIBgCEXqCAtNdwoxNfQ/VgLv4bXIONUucnMIEEQkA133EEma0bYIQGKvAgt8SATtXPrIhkA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eWO9seBw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718742582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SG1pahsNFyeWnRJMLnP/UTfWOjHeAffBOrHctLI/8J8=;
	b=eWO9seBwNGXIvvw0CqC0CYPQXhwuscz9mCiLMUE+IXQz9GqQwzbnMhXCKGhG3GPiMTDeLi
	/xy3eW4PU8nVZ03X1D8wqprMMW1Miga5iRA1/f1I9Mx+0gxm0hOCB9J7l3F9x6qc042fCZ
	0Mc9NtDu0PTz4Iw7pxICUPCVcaKPpAc=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-H9Ao9DSkOfaNu4IOZnhIOA-1; Tue, 18 Jun 2024 16:29:41 -0400
X-MC-Unique: H9Ao9DSkOfaNu4IOZnhIOA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-25443e5e1baso7325839fac.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 13:29:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718742581; x=1719347381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SG1pahsNFyeWnRJMLnP/UTfWOjHeAffBOrHctLI/8J8=;
        b=oo63vYvVIOrc/vvhG9YswoyWaSk1N2jxPygenvcklCYjknIx/yPLhNuTKCRg7yppz1
         3saQUUxvfHZEfP55Z2whVVDUD6Czmok+vBVACvBm2gUp2IEa8ao3uRYAnUu0LrTgXpSn
         3r7+T3not7zVh880yEg8Kd7YOVxriZAgJy8USCFoYYhGhQ43GTydkBwHnrIfFvtTUl+4
         L1z86Kaf5IVTxKxmdIrLTbUCmrraY/Nrp1DHznrb/m9DnPnRpBKUr6L6iA1ZxlSXOXIw
         NiCcsivSuv86hM4ojWsspTCnPdKwagh8n260SJ3ZEgFCsbanZkgH7jANCs/yDvlfbX2g
         BRzA==
X-Forwarded-Encrypted: i=1; AJvYcCVTkfPrMSRj5GfzrEGv6HrrkZ5r7Lay3EwaaLCEKqvNlIVaihwjtV0xO6KfYcH46fCK2SOFp10BRgg4Qw/OC3GnZqGS
X-Gm-Message-State: AOJu0YyTBCaVI9aENqXUQGOkj+IuqLZP3rvBRCyd1GvlGEapWm2pioCC
	a4HBQcXb4NrLkjifirvBRrYM7HU3eJuLTonCPvKjaIL7SY9yiwl9rDzg5SMXYtIGufgiteUR4LV
	0YfdCW5uR/H6Uh2d0XxP6HQVGmDcpt81tOFHyqzLz3h9kWbYF0Q==
X-Received: by 2002:a05:6870:6593:b0:254:ab8e:471b with SMTP id 586e51a60fabf-25c94e48921mr1087675fac.50.1718742580731;
        Tue, 18 Jun 2024 13:29:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDdgr3Spkd8lHoFHFSmzJEvst+OAsL3TJQBtRNfBw7S0f8ei8LxcslOnai254xYA7CMuWGVQ==
X-Received: by 2002:a05:6870:6593:b0:254:ab8e:471b with SMTP id 586e51a60fabf-25c94e48921mr1087658fac.50.1718742580376;
        Tue, 18 Jun 2024 13:29:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6fb5b75648asm1937270a34.72.2024.06.18.13.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 13:29:39 -0700 (PDT)
Date: Tue, 18 Jun 2024 14:29:37 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Fred Griffoul <fgriffo@amazon.co.uk>
Cc: <griffoul@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, Zefan Li
 <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Mark Brown
 <broonie@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Joey Gouly
 <joey.gouly@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, Jeremy Linton
 <jeremy.linton@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu
 <yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>, Eric Auger
 <eric.auger@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Christian
 Brauner" <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, "Reinette
 Chatre" <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH v6 2/2] vfio/pci: add interrupt affinity support
Message-ID: <20240618142937.553f8f1e.alex.williamson@redhat.com>
In-Reply-To: <20240611174430.90787-3-fgriffo@amazon.co.uk>
References: <20240611174430.90787-1-fgriffo@amazon.co.uk>
	<20240611174430.90787-3-fgriffo@amazon.co.uk>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 11 Jun 2024 17:44:25 +0000
Fred Griffoul <fgriffo@amazon.co.uk> wrote:

> The usual way to configure a device interrupt from userland is to write
> the /proc/irq/<irq>/smp_affinity or smp_affinity_list files. When using
> vfio to implement a device driver or a virtual machine monitor, this may
> not be ideal: the process managing the vfio device interrupts may not be
> granted root privilege, for security reasons. Thus it cannot directly
> control the interrupt affinity and has to rely on an external command.
> 
> This patch extends the VFIO_DEVICE_SET_IRQS ioctl() with a new data flag
> to specify the affinity of interrupts of a vfio pci device.
> 
> The CPU affinity mask argument must be a subset of the process cpuset,
> otherwise an error -EPERM is returned.
> 
> The vfio_irq_set argument shall be set-up in the following way:
> 
> - the 'flags' field have the new flag VFIO_IRQ_SET_DATA_CPUSET set
> as well as VFIO_IRQ_SET_ACTION_TRIGGER.
> 
> - the variable-length 'data' field is a cpu_set_t structure, as
> for the sched_setaffinity() syscall, the size of which is derived
> from 'argsz'.
> 
> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> ---
>  drivers/vfio/pci/vfio_pci_core.c  |  2 +-
>  drivers/vfio/pci/vfio_pci_intrs.c | 41 +++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_main.c          | 15 ++++++++---
>  include/uapi/linux/vfio.h         | 15 ++++++++++-
>  4 files changed, 67 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 80cae87fff36..fbc490703031 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1174,7 +1174,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
>  		return -EINVAL;
>  	}
>  
> -	info.flags = VFIO_IRQ_INFO_EVENTFD;
> +	info.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_CPUSET;
>  
>  	info.count = vfio_pci_get_irq_count(vdev, info.index);
>  
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 8382c5834335..b339c42cb1c0 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -19,6 +19,7 @@
>  #include <linux/vfio.h>
>  #include <linux/wait.h>
>  #include <linux/slab.h>
> +#include <linux/cpuset.h>
>  
>  #include "vfio_pci_priv.h"
>  
> @@ -82,6 +83,40 @@ vfio_irq_ctx_alloc(struct vfio_pci_core_device *vdev, unsigned long index)
>  	return ctx;
>  }
>  
> +static int vfio_pci_set_affinity(struct vfio_pci_core_device *vdev,
> +				 unsigned int start, unsigned int count,
> +				 struct cpumask *irq_mask)
> +{
> +	cpumask_var_t allowed_mask;
> +	int irq, err = 0;
> +	unsigned int i;
> +
> +	if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	cpuset_cpus_allowed(current, allowed_mask);
> +	if (!cpumask_subset(irq_mask, allowed_mask)) {
> +		err = -EPERM;
> +		goto finish;
> +	}
> +
> +	for (i = start; i < start + count; i++) {
> +		irq = pci_irq_vector(vdev->pdev, i);
> +		if (irq < 0) {
> +			err = -EINVAL;
> +			break;
> +		}
> +
> +		err = irq_set_affinity(irq, irq_mask);
> +		if (err)
> +			break;
> +	}

Sorry I didn't have an opportunity to reply to your previous comments,
but you stated:

On Tue, 11 Jun 2024 09:58:48 +0100
Frederic Griffoul <griffoul@gmail.com> wrote:
> My main use case is to configure NVMe queues in a virtual machine monitor
> to interrupt only the physical CPUs assigned to that vmm. Then we can
> set the same cpu_set_t to all the admin and I/O queues with a single ioctl().

So if I interpolate a little, the vmm's cpuset is likely set elsewhere
by some management tool, but that management tool isn't monitoring
registration of interrupts so you want the vmm to make some default
choice about interrupt affinity as they're enabled.  If that's all we
want, couldn't we just add a flag that directs the existing SET_IRQS
ioctl to call irq_set_affinity() based on the cpuset_cpus_allowed()
when called with DATA_EVENTFD|ACTION_TRIGGER?

What you're proposing here has a lot more versatility, but it's also
not clear how the vmm would really make an optimal choice at this
granularity.  Whether it's better to target an interrupt to the pCPU
running the vCPU where the guest has configured affinity isn't even
necessarily the right choice.  It could be for posted interrupts, but
could also induce a vmexit otherwise.  Is the vCPU necessarily even
within the allowed cpuset of the vmm itself when this ioctl is called?

I also wonder if there might be something through the irqbypass
framework where the interrupt consumer could direct the affinity of the
interrupt producer.

It'd really be preferable to see a viable userspace application of this
to prove it's worthwhile.

> +
> +finish:
> +	free_cpumask_var(allowed_mask);
> +	return err;
> +}
> +
>  /*
>   * INTx
>   */
> @@ -665,6 +700,9 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>  	if (!is_intx(vdev))
>  		return -EINVAL;
>  
> +	if (flags & VFIO_IRQ_SET_DATA_CPUSET)
> +		return vfio_pci_set_affinity(vdev, start, count, data);
> +
>  	if (flags & VFIO_IRQ_SET_DATA_NONE) {
>  		vfio_send_intx_eventfd(vdev, vfio_irq_ctx_get(vdev, 0));
>  	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> @@ -713,6 +751,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  	if (!irq_is(vdev, index))
>  		return -EINVAL;
>  
> +	if (flags & VFIO_IRQ_SET_DATA_CPUSET)
> +		return vfio_pci_set_affinity(vdev, start, count, data);
> +
>  	for (i = start; i < start + count; i++) {
>  		ctx = vfio_irq_ctx_get(vdev, i);
>  		if (!ctx)
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index e97d796a54fb..2e4f4e37cf89 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1505,23 +1505,30 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
>  		size = 0;
>  		break;
>  	case VFIO_IRQ_SET_DATA_BOOL:
> -		size = sizeof(uint8_t);
> +		size = size_mul(hdr->count, sizeof(uint8_t));
>  		break;
>  	case VFIO_IRQ_SET_DATA_EVENTFD:
> -		size = sizeof(int32_t);
> +		size = size_mul(hdr->count, sizeof(int32_t));
> +		break;
> +	case VFIO_IRQ_SET_DATA_CPUSET:
> +		size = hdr->argsz - minsz;
> +		if (size < cpumask_size())
> +			return -EINVAL;
> +		if (size > cpumask_size())
> +			size = cpumask_size();

You previously stated that a valid cpu_set_t could be smaller than a
cpumask_var_t, but it looks like we're handling that as an error here?
Truncating user data that's too large seems no more correct than
masking in user data that's too small.  Thanks,

Alex

>  		break;
>  	default:
>  		return -EINVAL;
>  	}
>  
>  	if (size) {
> -		if (hdr->argsz - minsz < hdr->count * size)
> +		if (hdr->argsz - minsz < size)
>  			return -EINVAL;
>  
>  		if (!data_size)
>  			return -EINVAL;
>  
> -		*data_size = hdr->count * size;
> +		*data_size = size;
>  	}
>  
>  	return 0;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 2b68e6cdf190..d2edf6b725f8 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -530,6 +530,10 @@ struct vfio_region_info_cap_nvlink2_lnkspd {
>   * Absence of the NORESIZE flag indicates that vectors can be enabled
>   * and disabled dynamically without impacting other vectors within the
>   * index.
> + *
> + * The CPUSET flag indicates the interrupt index supports setting
> + * its affinity with a cpu_set_t configured with the SET_IRQ
> + * ioctl().
>   */
>  struct vfio_irq_info {
>  	__u32	argsz;
> @@ -538,6 +542,7 @@ struct vfio_irq_info {
>  #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
>  #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
>  #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
> +#define VFIO_IRQ_INFO_CPUSET		(1 << 4)
>  	__u32	index;		/* IRQ index */
>  	__u32	count;		/* Number of IRQs within this index */
>  };
> @@ -580,6 +585,12 @@ struct vfio_irq_info {
>   *
>   * Note that ACTION_[UN]MASK specify user->kernel signaling (irqfds) while
>   * ACTION_TRIGGER specifies kernel->user signaling.
> + *
> + * DATA_CPUSET specifies the affinity for the range of interrupt vectors.
> + * It must be set with ACTION_TRIGGER in 'flags'. The variable-length 'data'
> + * array is the CPU affinity mask represented as a 'cpu_set_t' structure, as
> + * for the sched_setaffinity() syscall argument: the 'argsz' field is used
> + * to check the actual cpu_set_t size.
>   */
>  struct vfio_irq_set {
>  	__u32	argsz;
> @@ -587,6 +598,7 @@ struct vfio_irq_set {
>  #define VFIO_IRQ_SET_DATA_NONE		(1 << 0) /* Data not present */
>  #define VFIO_IRQ_SET_DATA_BOOL		(1 << 1) /* Data is bool (u8) */
>  #define VFIO_IRQ_SET_DATA_EVENTFD	(1 << 2) /* Data is eventfd (s32) */
> +#define VFIO_IRQ_SET_DATA_CPUSET	(1 << 6) /* Data is cpu_set_t */
>  #define VFIO_IRQ_SET_ACTION_MASK	(1 << 3) /* Mask interrupt */
>  #define VFIO_IRQ_SET_ACTION_UNMASK	(1 << 4) /* Unmask interrupt */
>  #define VFIO_IRQ_SET_ACTION_TRIGGER	(1 << 5) /* Trigger interrupt */
> @@ -599,7 +611,8 @@ struct vfio_irq_set {
>  
>  #define VFIO_IRQ_SET_DATA_TYPE_MASK	(VFIO_IRQ_SET_DATA_NONE | \
>  					 VFIO_IRQ_SET_DATA_BOOL | \
> -					 VFIO_IRQ_SET_DATA_EVENTFD)
> +					 VFIO_IRQ_SET_DATA_EVENTFD | \
> +					 VFIO_IRQ_SET_DATA_CPUSET)
>  #define VFIO_IRQ_SET_ACTION_TYPE_MASK	(VFIO_IRQ_SET_ACTION_MASK | \
>  					 VFIO_IRQ_SET_ACTION_UNMASK | \
>  					 VFIO_IRQ_SET_ACTION_TRIGGER)


