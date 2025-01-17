Return-Path: <kvm+bounces-35847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BEF4A15686
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:28:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B676166FE9
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F651A7253;
	Fri, 17 Jan 2025 18:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MI1/PlqC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39F4185B72
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 18:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737138482; cv=none; b=tljdN8T5s+rvMu1p7ffqyLutc5uWX1QZCBDNpM94q7EQj1WXnKKTkz92lJL/lQee0CuRV1Yd3tudrjXVl1U6A2RR40cBj4p6x6BAsXtGdVc/onLr/2Xkdq9HnrB+isA15LMp66dD/BwnPKrjKzrENgaKRLe3HwEmrYYSaj9cuRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737138482; c=relaxed/simple;
	bh=W2Hegohm4VymXTTP8cg88ToPh1c4SV09p4bZbsV2YXo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FSWehZOnw4i6jC7UE7Nq0Ax7w/tvzuBNc4gq/DlviNxTKE1MRRqoThrFvRta2Rl+MVqrUPJQ30/1Wk1qfn55lDGteHnmp6ZLhr/4jbavm4dsd5JaTbz5/06hmN3dtlxdaMntLlCfAxoYGwCtnq5Y1KDz5uBYv549dOz4BOuyeoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MI1/PlqC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737138479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WpjdRvgVOToLqKIeA9/YQhrMl5I+OiQd2jnnQassonw=;
	b=MI1/PlqCfNp4IlzqN2DFgFjYrBQ1+jTt3fm4bTGr0dvfLhk6PPf0oytNrtIVktSZ7EV7iJ
	zjaRlgiGMxEPoOJ5vk/EeAppNiEiebbgGn/c05PSAto+At6JhaQ9/BoVK0InZgfmhO8eIH
	lttfcSbZtDpFkdfiQu3pDvv+EbqZFSg=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-3qZq9uSzMDaEVWaF_voyug-1; Fri, 17 Jan 2025 13:27:55 -0500
X-MC-Unique: 3qZq9uSzMDaEVWaF_voyug-1
X-Mimecast-MFC-AGG-ID: 3qZq9uSzMDaEVWaF_voyug
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a81764054aso2283435ab.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 10:27:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737138474; x=1737743274;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WpjdRvgVOToLqKIeA9/YQhrMl5I+OiQd2jnnQassonw=;
        b=s2ADPiz76r1ghAf8UUOCw65W+sPqQJegWd/9Ypgmny9RzDw7fJZbfgqXg7xP5mxW03
         58ZA5CpINsyz4mHpgqcyvlgzgJbLJh41I4kFkL8ebrQcDn0XfYQ2h+4t3F7Q1Bpq6h0i
         NgDptaMuOsdWtex6qscavtTLlKv0cI5O3fFn0XGK9VFf0IXkoNw8q3Cfua+GARqF4j2F
         HiJeX4cQpwWeIGj63QyQbCs682OVHkVBaZIs91UPTvIXR80804iJeciOV4a6FlF06/LL
         ksCmAcgWwMK8o8HjnOWaNE6Oga9mkf5FVQojB+NXH0oqgTX5D15BVbHjyZ8Dk6SsdbXO
         ovgw==
X-Forwarded-Encrypted: i=1; AJvYcCXi7dQNe9ELz1RPUh33L7quRpVEaaynIGGkCFt6s6brT5n4TEOw1IiM8Z3vCqevlKhpFac=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCucpXJC3YB4u5YZrW9lfAhjqD6sfbvDQUoT0Iyw+lKAg2YGXX
	mpAF3WW5EWPy9eSDGy1UZAKC2+PH3zgF6y3v4wwCpDU5h/fxSYI79gMkP++f9J6iDyNLzDmf0Ia
	3J4NdJ7DtcgEpI+4p/IAp/f1obHmxUlowBKfbg0bPWwigdbB7MA==
X-Gm-Gg: ASbGncvFiafKgqNHQe7TVU4tn+jXsC/L0+NY8j1/828zFEIVYszjYec2BQ68hwwD5T2
	F4+KpVVmjDuo7MqksT+26lLB3cP8fodkZS7Q0BV7cBLRuWjwfsBU5f/8qyHslsDzo7KNbpPnne6
	tUX4CkOVcE067gjJ0ri6AIwBtDXMoel/9hg5a4RgCWlSd/RhkT9lZD3cBXzcfzidFnl2gEbKozh
	ni3n92kwUVw4nYmknClrG/KtnlRUsaX2LB+BsFpfOoDv5+RSquO/CzH7//p
X-Received: by 2002:a05:6602:81c:b0:83a:abd1:6af2 with SMTP id ca18e2360f4ac-851b62a8c7dmr65977239f.3.1737138474315;
        Fri, 17 Jan 2025 10:27:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwhnQIjfi1UjL2DLtvyebagAuwHm+XwHli4G3WUGNC5GCfGJ68AWSAHcvzyWG7Y/c2Uc3W1g==
X-Received: by 2002:a05:6602:81c:b0:83a:abd1:6af2 with SMTP id ca18e2360f4ac-851b62a8c7dmr65976039f.3.1737138473961;
        Fri, 17 Jan 2025 10:27:53 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea756493a7sm748724173.75.2025.01.17.10.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 10:27:53 -0800 (PST)
Date: Fri, 17 Jan 2025 13:27:36 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <zhiw@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Message-ID: <20250117132736.408954ac.alex.williamson@redhat.com>
In-Reply-To: <20250117152334.2786-4-ankita@nvidia.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
	<20250117152334.2786-4-ankita@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Jan 2025 15:23:34 +0000
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
>  drivers/vfio/pci/nvgrace-gpu/main.c | 55 +++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 89d38e3c0261..6298e7f0fe1a 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -5,6 +5,8 @@
>  
>  #include <linux/sizes.h>
>  #include <linux/vfio_pci_core.h>
> +#include <linux/delay.h>
> +#include <linux/jiffies.h>
>  
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -25,6 +27,13 @@
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
> @@ -855,6 +864,48 @@ static bool nvgrace_gpu_has_mig_hw_bug_fix(struct pci_dev *pdev)
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
> +static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
> +	void __iomem *io;
> +	int ret = -ETIME;
> +
> +	io = pci_iomap(pdev, 0, 0);
> +	if (!io)
> +		return -ENOMEM;
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
> +	return ret;

We're accessing device memory here but afaict the memory enable bit of
the command register is in an indeterminate state.  What happens if you
use setpci to clear the memory enable bit or 'echo 0 > enable' before
binding the driver?  Thanks,

Alex

> +}
> +
>  static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  			     const struct pci_device_id *id)
>  {
> @@ -863,6 +914,10 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  	u64 memphys, memlength;
>  	int ret;
>  
> +	ret = nvgrace_gpu_wait_device_ready(pdev);
> +	if (ret)
> +		return ret;
> +
>  	ret = nvgrace_gpu_fetch_memory_property(pdev, &memphys, &memlength);
>  	if (!ret)
>  		ops = &nvgrace_gpu_pci_ops;


