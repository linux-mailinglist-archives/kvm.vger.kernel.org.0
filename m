Return-Path: <kvm+bounces-19258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42993902955
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 21:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95981284AB2
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 19:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0156014E2E3;
	Mon, 10 Jun 2024 19:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L5OhnsNl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880193611B
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 19:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718047941; cv=none; b=F2d6dJ/1+vyRQGSUZNlTyfoy4lAYt0Hs0LuSvUB+4vLs9V3PopI+rDcq7i3ZjACJozIyAa959+gtjr5VZCNViUZcwlLOEOGUtlLU87wkb94ki0rtpporRSb/TJ7fEa/4evSDMiREElbreE1Ydwo2qGGVzxhqLF5hSVATrIqfvIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718047941; c=relaxed/simple;
	bh=InOa6heL5Z0zQtrtZXM1t8E5jy7Fl6gS5IxHmczhyvc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/A6Ea7H62Wvtuu6dWaPg3i5cByokzSmQg0jJznMqhNc+NEAVzr0YYbXRNQHXZ7+GjpYivPxBAozpK7ml/szYf+ULHuMHwgG1c3Kcy11y5BR44FHDYMaPUw5+eMnEmp29mpezhRB0G+ualcM3fB44lZeaEU/JG19naBthyZPeBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L5OhnsNl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718047938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5RyIS9264RlqB1OG3rOf8l6Ym1+Q4KsvmigQA6LMdr0=;
	b=L5OhnsNldxAGfxfKdTWSJ96GH956qFe7lO+SQORq8PlvsKuHO/2gi+Z2ITQrnLKzdBced8
	SqU9orty5oAgKU6LLFQWAUM7GX9g5tb+DsFl1YDmGk1twovz5bPniOUZjCcyn76EOnXFNc
	5vaC1bS7Y5csJoqorMhY3V3LyOrhtH4=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695--yL872eXPtaQOUiMR7LYnA-1; Mon, 10 Jun 2024 15:32:17 -0400
X-MC-Unique: -yL872eXPtaQOUiMR7LYnA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-254b9d5a4b9so204776fac.1
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 12:32:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718047933; x=1718652733;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5RyIS9264RlqB1OG3rOf8l6Ym1+Q4KsvmigQA6LMdr0=;
        b=iDsRkXV6qQUXmzxJI2Uco1PUf738lqnkFDEchlIfDxEr0IzvjPR8lrZc2yceGZCWus
         kSBrs55UNrmwgWE8JNbPl/siW2GeguO7OnLHWqnvUF9ujr2cF7ZjR4DLVUw44zzUsHMl
         +zK7y4oTmkEpTbZyaiqNAj8dsiwJl7EOhaGqOsfCE4xfQylrKdHILOx5WVEGW7UhZ/RA
         j1B0GsQRGVYEjZ3ia2NF5s/wwiyvvjpXJN7+b5nnybdtCGMaAE7yT5Ij0F3xBfwC4v0Q
         2EfZEoccG3yG7amxe9VRx50jeCsYFxc087qQgkfJ66kLGGcTo8nAcSfCnN+kdfcHzBQV
         RjcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx/vs3ERVQshCvLUCYsDOluhzYmL9n1sb265mAYtTse510PZqrvMmbsSEkAKBq+VGPsA0aKXOsavBU17OPcuXQ1tX4
X-Gm-Message-State: AOJu0YxnSETUC8AMWpM4JVWBjkIgOUgUoYFA8hihLIRPenXxzLwNrT9o
	Do8Ucx4NhIan0TpWma09cn1y4fNZgP1q1t8GbImzt9WJvwf9UFnl/BlZ9QkKTPq7p4gfmF1OgVe
	eY2NDsl+ixnxbuQQFpf4jfTChBbchANGe11kg7pZQf7F6vbULFw==
X-Received: by 2002:a05:6870:219e:b0:24c:b878:b4fc with SMTP id 586e51a60fabf-2546441a494mr11034226fac.17.1718047932675;
        Mon, 10 Jun 2024 12:32:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUC+H8CCbkKnPy4YHOOMwLvQ1eUEEF00M667jcLIaKCuzEWFE3yNACWxBxGCtaKevuJqcN3g==
X-Received: by 2002:a05:6870:219e:b0:24c:b878:b4fc with SMTP id 586e51a60fabf-2546441a494mr11034175fac.17.1718047932132;
        Mon, 10 Jun 2024 12:32:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-25447e0171dsm2438233fac.13.2024.06.10.12.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 12:32:11 -0700 (PDT)
Date: Mon, 10 Jun 2024 13:32:07 -0600
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
Subject: Re: [PATCH v5 2/2] vfio/pci: add msi interrupt affinity support
Message-ID: <20240610133207.7d039dab.alex.williamson@redhat.com>
In-Reply-To: <20240610125713.86750-3-fgriffo@amazon.co.uk>
References: <20240610125713.86750-1-fgriffo@amazon.co.uk>
	<20240610125713.86750-3-fgriffo@amazon.co.uk>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Jun 2024 12:57:08 +0000
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
> - the 'flags' field have the new flag VFIO_IRQ_SET_DATA_AFFINITY set
> as well as VFIO_IRQ_SET_ACTION_TRIGGER.
> 
> - the variable-length 'data' field is a cpu_set_t structure, as
> for the sched_setaffinity() syscall, the size of which is derived
> from 'argsz'.
> 
> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> ---
>  drivers/vfio/pci/vfio_pci_core.c  | 27 +++++++++++++++++----
>  drivers/vfio/pci/vfio_pci_intrs.c | 39 +++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_main.c          | 13 +++++++----
>  include/uapi/linux/vfio.h         | 10 +++++++-
>  4 files changed, 80 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 80cae87fff36..2e3419560480 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1192,6 +1192,7 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
>  {
>  	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
>  	struct vfio_irq_set hdr;
> +	cpumask_var_t mask;
>  	u8 *data = NULL;
>  	int max, ret = 0;
>  	size_t data_size = 0;
> @@ -1207,9 +1208,22 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
>  		return ret;
>  
>  	if (data_size) {
> -		data = memdup_user(&arg->data, data_size);
> -		if (IS_ERR(data))
> -			return PTR_ERR(data);
> +		if (hdr.flags & VFIO_IRQ_SET_DATA_AFFINITY) {
> +			if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
> +				return -ENOMEM;
> +
> +			if (copy_from_user(mask, &arg->data, data_size)) {
> +				ret = -EFAULT;
> +				goto out;
> +			}
> +
> +			data = (u8 *)mask;

Seems like this could just use the memdup_user() path, why do we care
to copy it into a cpumask_var_t here?  If we do care, wouldn't we
implement something like get_user_cpu_mask() used by
sched_setaffinity(2)?

> +
> +		} else {
> +			data = memdup_user(&arg->data, data_size);
> +			if (IS_ERR(data))
> +				return PTR_ERR(data);
> +		}
>  	}
>  
>  	mutex_lock(&vdev->igate);
> @@ -1218,7 +1232,12 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
>  				      hdr.count, data);
>  
>  	mutex_unlock(&vdev->igate);
> -	kfree(data);
> +
> +out:
> +	if (hdr.flags & VFIO_IRQ_SET_DATA_AFFINITY && data_size)
> +		free_cpumask_var(mask);
> +	else
> +		kfree(data);
>  
>  	return ret;
>  }
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 8382c5834335..fe01303cf94e 100644
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
> @@ -675,6 +676,41 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>  	return 0;
>  }
>  
> +static int vfio_pci_set_msi_affinity(struct vfio_pci_core_device *vdev,
> +				     unsigned int start, unsigned int count,
> +				     struct cpumask *irq_mask)

Aside from the name, what makes this unique to MSI vectors?

> +{
> +	struct vfio_pci_irq_ctx *ctx;
> +	cpumask_var_t allowed_mask;
> +	unsigned int i;
> +	int err = 0;
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
> +		ctx = vfio_irq_ctx_get(vdev, i);
> +		if (!ctx) {
> +			err = -EINVAL;
> +			break;
> +		}
> +
> +		err = irq_set_affinity(ctx->producer.irq, irq_mask);
> +		if (err)
> +			break;
> +	}

Is this typical/userful behavior to set a series of vectors to the same
cpu_set_t?  It's unusual behavior for this ioctl to apply the same data
across multiple vectors.  Should the DATA_AFFINITY case support an
array of cpu_set_t?

> +
> +finish:
> +	free_cpumask_var(allowed_mask);
> +	return err;
> +}
> +
>  static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  				    unsigned index, unsigned start,
>  				    unsigned count, uint32_t flags, void *data)
> @@ -713,6 +749,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  	if (!irq_is(vdev, index))
>  		return -EINVAL;
>  
> +	if (flags & VFIO_IRQ_SET_DATA_AFFINITY)
> +		return vfio_pci_set_msi_affinity(vdev, start, count, data);
> +
>  	for (i = start; i < start + count; i++) {
>  		ctx = vfio_irq_ctx_get(vdev, i);
>  		if (!ctx)
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index e97d796a54fb..e75c5d66681c 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1505,23 +1505,28 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
>  		size = 0;
>  		break;
>  	case VFIO_IRQ_SET_DATA_BOOL:
> -		size = sizeof(uint8_t);
> +		size = hdr->count * sizeof(uint8_t);
>  		break;
>  	case VFIO_IRQ_SET_DATA_EVENTFD:
> -		size = sizeof(int32_t);
> +		size = size_mul(hdr->count, sizeof(int32_t));

Why use size_mul() in one place and not the other? 

> +		break;
> +	case VFIO_IRQ_SET_DATA_AFFINITY:
> +		size = hdr->argsz - minsz;
> +		if (size > cpumask_size())
> +			size = cpumask_size();

Or just set size = (hdr->argsz - minsz) / count?

Generate an error if (hdr->argsz - minsz) % count?

It seems like all the cpumask'items can be contained to the set affinity
function.

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
> index 2b68e6cdf190..5ba2ca223550 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -580,6 +580,12 @@ struct vfio_irq_info {
>   *
>   * Note that ACTION_[UN]MASK specify user->kernel signaling (irqfds) while
>   * ACTION_TRIGGER specifies kernel->user signaling.
> + *
> + * DATA_AFFINITY specifies the affinity for the range of interrupt vectors.
> + * It must be set with ACTION_TRIGGER in 'flags'. The variable-length 'data'
> + * array is a CPU affinity mask 'cpu_set_t' structure, as for the
> + * sched_setaffinity() syscall argument: the 'argsz' field is used to check
> + * the actual cpu_set_t size.
>   */

DATA_CPUSET?

The IRQ_INFO ioctl should probably also report support for this
feature.

Is there any proposed userspace code that takes advantage of this
interface?  Thanks,

Alex

>  struct vfio_irq_set {
>  	__u32	argsz;
> @@ -587,6 +593,7 @@ struct vfio_irq_set {
>  #define VFIO_IRQ_SET_DATA_NONE		(1 << 0) /* Data not present */
>  #define VFIO_IRQ_SET_DATA_BOOL		(1 << 1) /* Data is bool (u8) */
>  #define VFIO_IRQ_SET_DATA_EVENTFD	(1 << 2) /* Data is eventfd (s32) */
> +#define VFIO_IRQ_SET_DATA_AFFINITY	(1 << 6) /* Data is cpu_set_t */
>  #define VFIO_IRQ_SET_ACTION_MASK	(1 << 3) /* Mask interrupt */
>  #define VFIO_IRQ_SET_ACTION_UNMASK	(1 << 4) /* Unmask interrupt */
>  #define VFIO_IRQ_SET_ACTION_TRIGGER	(1 << 5) /* Trigger interrupt */
> @@ -599,7 +606,8 @@ struct vfio_irq_set {
>  
>  #define VFIO_IRQ_SET_DATA_TYPE_MASK	(VFIO_IRQ_SET_DATA_NONE | \
>  					 VFIO_IRQ_SET_DATA_BOOL | \
> -					 VFIO_IRQ_SET_DATA_EVENTFD)
> +					 VFIO_IRQ_SET_DATA_EVENTFD | \
> +					 VFIO_IRQ_SET_DATA_AFFINITY)
>  #define VFIO_IRQ_SET_ACTION_TYPE_MASK	(VFIO_IRQ_SET_ACTION_MASK | \
>  					 VFIO_IRQ_SET_ACTION_UNMASK | \
>  					 VFIO_IRQ_SET_ACTION_TRIGGER)


