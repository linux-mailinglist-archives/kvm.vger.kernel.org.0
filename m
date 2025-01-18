Return-Path: <kvm+bounces-35916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A58B7A15AEF
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 02:53:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF0733A8957
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BF12D7BF;
	Sat, 18 Jan 2025 01:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PbwkOaj5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D69136E
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 01:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737165176; cv=none; b=ry8VGdS24DEXPh7JniCBL4S7fFfCQ66vEe7NE3Raay5GXV0dTSMak2EReJ12f0XOATbN2iKWU5wE2RAJZULfP0+CM9KlKLXt+RXoMvNyZHlQqxXmZn4OqAaubNP0IcRl2HE9pB/3jBdjkr5QU1VFZX+7lwM7O8BUqKDSf3MXJ6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737165176; c=relaxed/simple;
	bh=YBderMozm5/emrrG8L0uPdZ7xhfGL5H/lgpCQB1QagA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YrTLoQh5xXsTRH528n5LM6diM88h37KDfO60N7Y1draPmebwqK1sGEyPIqe1ihrKIYECkg71c0OUYapvLq58YXQqA8XJYU6alwRZT3IGDFdUpf/lUX5LE6TZtkvNuWgtdCUNQehUsSs3xcR7SJ3Oanc7oJkhsebGYh6MNtqeV5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PbwkOaj5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737165173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j/93uggteFgHagU9Oe4XLtgJzAfFjNFMkXM/x7Ub+As=;
	b=PbwkOaj5+syNp4dQHHuLL2kD+3t9kXajazd1VinzAHSk75csfVdhMdD42rttrcRhBGKmuW
	rvquGS5D4OAOFyRxnyo/H9LIDUQ7pqt6Uur+6zQbZH9xuMN1RUq1aCmGuQiya7kVvMhBLA
	chFNdyMODxo5B9mCBD7kl0jfJW6+fw8=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-ipfXTHJnO3-CzLh2rWhruA-1; Fri, 17 Jan 2025 20:52:51 -0500
X-MC-Unique: ipfXTHJnO3-CzLh2rWhruA-1
X-Mimecast-MFC-AGG-ID: ipfXTHJnO3-CzLh2rWhruA
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ce8c06be57so784125ab.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 17:52:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737165170; x=1737769970;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j/93uggteFgHagU9Oe4XLtgJzAfFjNFMkXM/x7Ub+As=;
        b=kKVFbpTiVNriDGZx+aLkRyThRqfIlxxyvKUPjjEUi41KgxHJeoedK5ew1wzqg+pKWs
         uUkzIPGyO46yfQJDjHa+XvgQ2yrmAuMDA+KGWc4jp7YbqsOGk8hw69kNcgT/fSRbSGbm
         +Dgxl0tQOvqUMX4I94trc58fiwRM9oA2Nt0WQO8gbqFEIVyHuGaP5es544U4ZH3ucM0G
         YxpaHsQQGfIQZym0YOYEg8vEa2QLhkHowRNj15AiVE8ypmto5w6hSu0PA+mtWE+hdcKS
         ZHxup3mCoL4Az8TTyeiz5ISy8uFkjE1RiuiWr8Ca7hv09jWXejs3scxvHkO7SGqHblqe
         h8jQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkbkvCD6itNb3QSqVC2wJBTWhJnjTwsrjVZaMYQ4uDTkTdtXYDTxdvQ7B4rXTctJFTVwI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK1ZQskWYbO4IWPIWBj5uc754z4pI6DpDCK0DUfGbVy19C+MyS
	N8zkavJjgXNN174yHsoiivYqbMFXv24d+R4B34/L5Koj+i+xIafLOn6A2ctjXneOH+HHpSRnK7h
	Gi+VfGsIbj2HWmqPMEPNLU8pt8Pbc3KWohGzHJLiBieEOpKsJmg==
X-Gm-Gg: ASbGncviDZDfOZb1GLuYl2REJLIuNmjCQXpqW7WaL9PDGy6okdJHmvl+hvNHt4N+dET
	B7PwLpi06GHWU1KrDZlbYyYBWGxFQBDW4G2nbTrSipG6/DdJBuJJZd7FUWk+/Q03bLHTBQoZdmC
	dlzXAAYmI3Z7zfrY8oVyiIaplyp8ERzxjP4vAxF/WUkqM5aHmC6KtohLthoH9Sjulhki22ZCKeU
	M7YDBespRDwFcejtlzBS+3pk7qVkrgTmeKY2DvSMsPuwnoRgFVsqNCn1LrvcYMtPivae0TSvw==
X-Received: by 2002:a05:6e02:1d84:b0:3ce:7d23:362 with SMTP id e9e14a558f8ab-3cf74494bacmr11582985ab.3.1737165170416;
        Fri, 17 Jan 2025 17:52:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZWXSh2q0Q1mOhW30m1BC7zZkhINYitbqW/qlMUkl0ep3oW1Jaf7SMwTYbTJYiz9+S0lldzw==
X-Received: by 2002:a05:6e02:1d84:b0:3ce:7d23:362 with SMTP id e9e14a558f8ab-3cf74494bacmr11582875ab.3.1737165170040;
        Fri, 17 Jan 2025 17:52:50 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea7566e412sm922502173.126.2025.01.17.17.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 17:52:49 -0800 (PST)
Date: Fri, 17 Jan 2025 20:52:32 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <zhiw@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Message-ID: <20250117205232.37dbabe3.alex.williamson@redhat.com>
In-Reply-To: <20250117233704.3374-4-ankita@nvidia.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
	<20250117233704.3374-4-ankita@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Jan 2025 23:37:04 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> In contrast to Grace Hopper systems, the HBM training has been moved
> out of the UEFI on the Grace Blackwell systems. This reduces the system
> bootup time significantly.
> 
> The onus of checking whether the HBM training has completed thus falls
> on the module.
> 
> The HBM training status can be determined from a BAR0 register.
> Similarly, another BAR0 register exposes the status of the CPU-GPU
> chip-to-chip (C2C) cache coherent interconnect.
> 
> Based on testing, 30s is determined to be sufficient to ensure
> initialization completion on all the Grace based systems. Thus poll
> these register and check for 30s. If the HBM training is not complete
> or if the C2C link is not ready, fail the probe.
> 
> While the time is not required on Grace Hopper systems, it is
> beneficial to make the check to ensure the device is in an
> expected state. Hence keeping it generalized to both the generations.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 64 +++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_core.c    |  2 +
>  2 files changed, 66 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index e6fe5bc8940f..d3529d2cc3b0 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -5,6 +5,10 @@
>  
>  #include <linux/sizes.h>
>  #include <linux/vfio_pci_core.h>
> +#include <linux/delay.h>
> +#include <linux/jiffies.h>
> +
> +#include "../vfio_pci_priv.h"
>  
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -25,6 +29,13 @@
>  
>  #define GPU_CAP_DVSEC_REGISTER 3
>  
> +#define C2C_LINK_BAR0_OFFSET 0x1498
> +#define HBM_TRAINING_BAR0_OFFSET 0x200BC
> +#define STATUS_READY 0xFF
> +
> +#define POLL_QUANTUM_MS 1000
> +#define POLL_TIMEOUT_MS (30 * 1000)
> +
>  /*
>   * The state of the two device memory region - resmem and usemem - is
>   * saved as struct mem_region.
> @@ -856,6 +867,55 @@ static bool nvgrace_gpu_has_mig_hw_bug_fix(struct pci_dev *pdev)
>  	return false;
>  }
>  
> +/*
> + * To reduce the system bootup time, the HBM training has
> + * been moved out of the UEFI on the Grace-Blackwell systems.
> + *
> + * The onus of checking whether the HBM training has completed
> + * thus falls on the module. The HBM training status can be
> + * determined from a BAR0 register.
> + *
> + * Similarly, another BAR0 register exposes the status of the
> + * CPU-GPU chip-to-chip (C2C) cache coherent interconnect.
> + *
> + * Poll these register and check for 30s. If the HBM training is
> + * not complete or if the C2C link is not ready, fail the probe.
> + *
> + * While the wait is not required on Grace Hopper systems, it
> + * is beneficial to make the check to ensure the device is in an
> + * expected state.
> + */
> +static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev,
> +					 struct vfio_pci_core_device *vdev)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
> +	void __iomem *io;
> +	int ret = -ETIME;
> +	u16 cmd;
> +
> +	cmd = vfio_pci_memory_lock_and_enable(vdev);
> +	io = pci_iomap(pdev, 0, 0);
> +	if (!io) {
> +		ret = -ENOMEM;
> +		goto iomap_exit;
> +	}
> +
> +	do {
> +		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
> +		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
> +			ret = 0;
> +			goto reg_check_exit;
> +		}
> +		msleep(POLL_QUANTUM_MS);
> +	} while (!time_after(jiffies, timeout));
> +
> +reg_check_exit:
> +	pci_iounmap(pdev, io);
> +iomap_exit:
> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
> +	return ret;
> +}
> +
>  static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  			     const struct pci_device_id *id)
>  {
> @@ -875,6 +935,10 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  
>  	dev_set_drvdata(&pdev->dev, &nvdev->core_device);
>  
> +	ret = nvgrace_gpu_wait_device_ready(pdev, &nvdev->core_device);
> +	if (ret)
> +		return ret;
> +
>  	if (ops == &nvgrace_gpu_pci_ops) {
>  		nvdev->has_mig_hw_bug_fix = nvgrace_gpu_has_mig_hw_bug_fix(pdev);
>  
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 90240c8d51aa..68f123d17c4b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1634,12 +1634,14 @@ u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev)
>  
>  	return cmd;
>  }
> +EXPORT_SYMBOL_GPL(vfio_pci_memory_lock_and_enable);
>  
>  void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev, u16 cmd)
>  {
>  	pci_write_config_word(vdev->pdev, PCI_COMMAND, cmd);
>  	up_write(&vdev->memory_lock);
>  }
> +EXPORT_SYMBOL_GPL(vfio_pci_memory_unlock_and_restore);
>  
>  static unsigned long vma_to_pfn(struct vm_area_struct *vma)
>  {

The access is happening before the device is exposed to the user, the
above are for handling conditions while there may be races with user
access, this is totally unnecessary.

Does this delay even need to happen in the probe function, or could it
happen in the open_device callback?  That would still be before user
access, but if we expect it to generally work, it would allow the
training to happen in the background up until the user tries to open
the device.  Thanks,

Alex


