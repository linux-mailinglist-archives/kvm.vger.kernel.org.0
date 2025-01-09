Return-Path: <kvm+bounces-34952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 33525A08152
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 21:21:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0387188C603
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336EF1FE463;
	Thu,  9 Jan 2025 20:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EE+dUcTK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78531B0403
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 20:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736454060; cv=none; b=fUqWYcfovpUwGZLIsy4twhkx3JP6iLH9ItOAuknhywJwfWD/hkGEmqli8FdOEQLlCCrO8o6iZiJ7ZpQ6YbghNsVV2vw/jIV66H7T59SsKwLQNZToHC9IpFhUNZcmo/CsBIqD+eTSKubPJsxC2J+bQWWIYtdBRnidg3qHtgqj6FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736454060; c=relaxed/simple;
	bh=jOU2+qNfLK5N54oxV2InJipacITF6Ouu8iFFYRzr4KY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suTZNuGZxdZvlj2ZH8TAK3wKZyW+y7I+TRq1XCD+PVj4LwsPDLfFY1k/WEcY/lGkikm4z8PempQ7/xiNC+FgGbcMyZcr72nie79oocs+zsZVGeYAzuFXD5HrxCpVkNLZP73r9YukE2JLl+DT3SIyCWrguyTADvVUP62lHqQTS+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EE+dUcTK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736454056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1bSoiF2v0QH8Ftn2ENuHbcOCo74EEBcxwTRuzvg2tS0=;
	b=EE+dUcTKiV3PUlboDZeTpvL2KocujqKOe+33hT6+fIPPyp0YAgwBMBr5K/ng9jmJGtAwo7
	9AiOn1p2RGSROnxHXc7/Cu5zbTyKjDJyiNrBP7kAQE40rRdDEl9032DRBJG4rMYQoSGHaQ
	HkdwRoK19K437OiXRuuEprHxULyIrgs=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-srvG00m9N9OeIA6Zxy5_0A-1; Thu, 09 Jan 2025 15:20:55 -0500
X-MC-Unique: srvG00m9N9OeIA6Zxy5_0A-1
X-Mimecast-MFC-AGG-ID: srvG00m9N9OeIA6Zxy5_0A
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a81667a816so960415ab.2
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 12:20:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736454055; x=1737058855;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1bSoiF2v0QH8Ftn2ENuHbcOCo74EEBcxwTRuzvg2tS0=;
        b=r27RIO5EVlvc8rqks11Re0yut5IieW3pJErf39bkQ0+01ob0iQAm0bl0l5TLQytDrR
         vaTZWECla/SqP10rKbsIY2YXNSAe8RX+3lWuS0nBUojjgTZxSCH0Mb9nCYuw4nA5+TZx
         y4qLAKv3CiR0wZq4dClcUG2ffdHavckC0S/7tGJrU/XEDB9U0dCIsRNe7Sal2xb/NKS/
         C7S1iXG4QrlUniRchzsiJdqnzJ7K3T32M6RK+oxN2KXDsx/OMctvHKM3VvyTU0CHXMmy
         330xv+oNy4IL1AbnQCWOspFJ0UJs3NtMB1z/TWyPYplrd7PCfWPJIB0kuDsybemawOLi
         KKWA==
X-Forwarded-Encrypted: i=1; AJvYcCXUsVVIgaubsu04Tme8QPuq54e3NjrGtc69SxR6/v8PBaaE485Ft5T0KmKTyU9ygoYaJ6M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpx654NhjRAF6qYHfvLJZzlicVy+djqDK8j0ssKb4W2siBm4V3
	HXa2e0+/I+zqTaiqcGeEqzY5spy2KLfEfIRtnNOQxgmfSYp4eeYXdOI0yMNX7puIZ+S2M8bsrXL
	iI3g29eOUP8OMYGYFqcEChC1s66Igeh9wgfnurc5d3Use/xPzpw==
X-Gm-Gg: ASbGncu10FqOi64tzw/tvmi3kYrV+SJ/KHfda8ISEgcraTEvLYzMTHEFPvGumuUsg1F
	ygObf9WBSIfe6dAZY2he3Cs7B521LOXdtcc8055Hhldx3hCiXpItu/BZVPprmjwsgS2z7p7ZZLg
	OZebrA7bSoVE9hFIBE38fhxgjDhHiZZKGSI9ppMHA63pr1bLqqwpVIurPwoTB9O8mMmlSwVOojM
	wnR3hPlLG+/kCFKk8Xxm8/3wLdS4/s5iuVPb4trV/3W6Y1NcvkobL6FoXGx
X-Received: by 2002:a05:6602:2b8a:b0:849:8a81:ab73 with SMTP id ca18e2360f4ac-84ce01a6153mr203182639f.3.1736454054736;
        Thu, 09 Jan 2025 12:20:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGRDY30x2M4AiRY87SBbgDKSt7J84b1+GJTQwtC9t/9LwbPlnb20A4QMzmisNLhrC+vUQWRww==
X-Received: by 2002:a05:6602:2b8a:b0:849:8a81:ab73 with SMTP id ca18e2360f4ac-84ce01a6153mr203181839f.3.1736454054394;
        Thu, 09 Jan 2025 12:20:54 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84d4fb1b633sm50701739f.14.2025.01.09.12.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 12:20:53 -0800 (PST)
Date: Thu, 9 Jan 2025 15:20:45 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <zhiw@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Message-ID: <20250109152045.6d782850.alex.williamson@redhat.com>
In-Reply-To: <20250105173615.28481-4-ankita@nvidia.com>
References: <20250105173615.28481-1-ankita@nvidia.com>
	<20250105173615.28481-4-ankita@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 5 Jan 2025 17:36:15 +0000
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
>  drivers/vfio/pci/nvgrace-gpu/main.c | 53 +++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 44a276c886e1..cf020496743e 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -5,6 +5,7 @@
>  
>  #include <linux/sizes.h>
>  #include <linux/vfio_pci_core.h>
> +#include <linux/delay.h>
>  
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -28,6 +29,13 @@
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
> @@ -848,6 +856,47 @@ static bool nvgrace_gpu_has_mig_hw_bug_fix(struct pci_dev *pdev)
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
> +static int nvgrace_gpu_check_device_status(struct pci_dev *pdev)

"nvgrace_gpu_wait_device_ready()"?

> +{
> +	void __iomem *io;
> +	int time_elasped;
> +
> +	io = pci_iomap(pdev, 0, ~0UL);

The documentation is unclear here, but existing code suggests passing 0
here rather than -1 to map the full BAR.  It ends up being equivalent
since the code doesn't error attempting to map longer than the BAR, but
there's no reason to add a bad example.

> +	if (!io)
> +		return -ENOMEM;
> +
> +	for (time_elasped = 0; time_elasped < POLL_TIMEOUT_MS;
> +	     time_elasped += POLL_QUANTUM_MS) {
> +		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
> +		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
> +			pci_iounmap(pdev, io);
> +			return 0;
> +		}
> +		msleep(POLL_QUANTUM_MS);
> +	}

time_after() would simplify things here.  I'd also suggest a common
exit path.

> +
> +	pci_iounmap(pdev, io);
> +	return -ENODEV;

ETIME could work for the error code too.  Thanks,

Alex

> +}
> +
>  static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  			     const struct pci_device_id *id)
>  {
> @@ -856,6 +905,10 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  	u64 memphys, memlength;
>  	int ret;
>  
> +	ret = nvgrace_gpu_check_device_status(pdev);
> +	if (ret)
> +		return ret;
> +
>  	ret = nvgrace_gpu_fetch_memory_property(pdev, &memphys, &memlength);
>  	if (!ret)
>  		ops = &nvgrace_gpu_pci_ops;


