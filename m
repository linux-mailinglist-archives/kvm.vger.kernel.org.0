Return-Path: <kvm+bounces-36550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D96A2A1BA4A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABAB71890661
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6541AAA09;
	Fri, 24 Jan 2025 16:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0ZZgklg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FBC18A6AC
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737735910; cv=none; b=BIfoUJlW+9bsDROVU++aOP0j/5d3+g+Y3p5RZojHhdIWGb3udNjChsIyVDHnJoU+6VNhQI6NoWjVCdZFPpl8cqkKW14Te56mUycwxwIc2y7AvaZQjto7eJbB2EJTZrDmCZw2qd3ccvNjdlhR2k50DokQC5ZkFcrPwh4Z3bQJnkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737735910; c=relaxed/simple;
	bh=VDQFl1repqiWF/Ov6VTuFQ1FSwlF8Xm5hpKCHUIMZvI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7EgieN+ZcxvR/ze/DjlcNjHfz1toiIpSs/qvYOzG2PHPQFWBX0hSZt5664MVdi5V989jqFSuEQ0Ie/rMlltPDOxKKkFnGphgVnO4RaeQoZGaQyt6q6sGho/+UINb3gYY2ucDsm9Utw9yU8a23AO74IV1IJAJLq1IWe7ygM80uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0ZZgklg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737735907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DrRSFcsacFJ/k9XlAWLKwG8eCWs0uFHWTK4U25NGRMI=;
	b=N0ZZgklgb+8KaYlOrHQnWsrcvy/a9dcfgoJKif/YLuFqEAZvrzxOomDpyCD5lRYi1t5LfU
	dXQqYmnwGkZsrMfb1vUD0eoFPTevZ1oEzhcero6PDwT437Ag3Vn5v8ZKt7zHQenajJNzLx
	Yk7nGUrk0yJg6ktgykHPJq5VJSofrSc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-72PIJXbFO1uS7T9eoQYT8Q-1; Fri, 24 Jan 2025 11:25:05 -0500
X-MC-Unique: 72PIJXbFO1uS7T9eoQYT8Q-1
X-Mimecast-MFC-AGG-ID: 72PIJXbFO1uS7T9eoQYT8Q
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a7ea122d0bso2194095ab.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 08:25:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737735903; x=1738340703;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DrRSFcsacFJ/k9XlAWLKwG8eCWs0uFHWTK4U25NGRMI=;
        b=s58EeJ3YXYcMfsmtZFnOS42vst/X+coZ5aHnvbhyw1OVFxuqCTm4LZXv97rb/Q0+7N
         +wyFTl6UElj4pqNr8dN1kh6BGVd1u+7UAluV3LRU2yp5g1rWtRh7izqCujsU9MHluu6n
         zdOx76N9Ai/W1EnNOgaU9clA84Ocq2wt3kCuI/Dm1d106HRTSqAu92++b4/O5EYXWQZM
         xS36QBQT37zBOYHFWtWEbS2ktUQ2bKxL7jCrxf2FpOkbPzdyOOSj94VJG/4G+303kTbM
         +/23af+yI7hd+1wMdkcM1kUJFldutGT+AVAWFwCMCB/wqdr0Fg+IIR3tHYpE+vj71dzM
         85VA==
X-Forwarded-Encrypted: i=1; AJvYcCV6LRasei9FDlpDp5ZlDow350gHo1hM4L+sbHUaHd1g4AvvMvkEZqKPA3ET1+p5Gy1tYO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNoiCghl/QS7zisrW+rWdkby6xC3nDaFTqVdABL44WpSA3bv/d
	pc9UXc4Zgu3LHzS1GGMVxwFIAWcPKUlD7Jabv8tJkmgH+VtxTKElFxksrNoGHoPKVLaSw+/O7uO
	NpzLpShbAGRCYgFB9Y3wJHHcUSoNcD36bmfeovnMjJvynfgZT+g==
X-Gm-Gg: ASbGncvzmYCFrgC4bb1E/2n75K1DBtJx1Ho/XEc0czPnYJtHj0vKwoePgpf/TC+VAYt
	vIbptyI5CdCJeN1WcBa0nNm37oNgMCqM7ZR/d6sAlP1WUA4ycjYLSSt7w7oKafy2y6D+nHm6xse
	G7hKOtBaslwO7aOc8zapteSBz41u9HH397e81vcgfhUYfNTaW6TAX0qRkj/CeDtfWwLvnv88UJU
	ymB0whjlw7QqxQ9kn4hO/5Fqgd9BfuJrCZ9i6eIWLWlefS6CooG8AW04ChpNL5S6aMBkPoNqw==
X-Received: by 2002:a05:6602:38b:b0:83a:acc8:5faf with SMTP id ca18e2360f4ac-851b65131b5mr507357839f.5.1737735903486;
        Fri, 24 Jan 2025 08:25:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGh3ytWQxsJLcodYd61d3OWmKmFRhVzVBZ9ZHnOb1GBCimGoFMeb/TW6olWX+KNH80KnU0yKw==
X-Received: by 2002:a05:6602:38b:b0:83a:acc8:5faf with SMTP id ca18e2360f4ac-851b65131b5mr507355039f.5.1737735902374;
        Fri, 24 Jan 2025 08:25:02 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8521e04391esm72801339f.47.2025.01.24.08.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 08:25:01 -0800 (PST)
Date: Fri, 24 Jan 2025 09:24:59 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <zhiw@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <kjaju@nvidia.com>, <anuaggarwal@nvidia.com>,
 <mochs@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Message-ID: <20250124092459.7ef4df51.alex.williamson@redhat.com>
In-Reply-To: <20250123174854.3338-4-ankita@nvidia.com>
References: <20250123174854.3338-1-ankita@nvidia.com>
	<20250123174854.3338-4-ankita@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jan 2025 17:48:54 +0000
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
> Ensure that the BAR0 is enabled before accessing the registers.
> 
> CC: Alex Williamson <alex.williamson@redhat.com>
> CC: Kevin Tian <kevin.tian@intel.com>
> CC: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 72 +++++++++++++++++++++++++++++
>  1 file changed, 72 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index f4f23c0c95c7..fc480ea32c11 100644
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
> @@ -861,6 +870,65 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
>  	return true;
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
> + *
> + * Ensure that the BAR0 region is enabled before accessing the
> + * registers.
> + */
> +static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
> +	void __iomem *io;
> +	int ret = -ETIME;
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret)
> +		return ret;
> +
> +	ret = pci_request_selected_regions(pdev, 1 << 0, "vfio-pci");

All the overhead of enabling the device and requesting the region, only
to undo it around this simple test is unfortunate, but I think correct.
Even though this is only briefly taken, I'd suggest using KBUILD_MODNAME
there rather than "vfio-pci" to differentiate from the core code.
Thanks,

Alex

> +	if (ret)
> +		goto request_region_exit;
> +
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
> +	pci_release_selected_regions(pdev, 1 << 0);
> +request_region_exit:
> +	pci_disable_device(pdev);
> +	return ret;
> +}
> +
>  static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  			     const struct pci_device_id *id)
>  {
> @@ -869,6 +937,10 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
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


