Return-Path: <kvm+bounces-35845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BBD2A1564C
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96EB23A9650
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700471A2642;
	Fri, 17 Jan 2025 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B8TLSD3v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91668A95C
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 18:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737137211; cv=none; b=IF2amoUgCmpBU/TgentlUOAlZVWra0xAaRm8F6b8WktPJw/Q/SK3U6Cu6UREOPxNish3BKVfzcEX+45p+D8qalgiDLrdp4UC0G4EAHvipSNUhipFyTc8LojNS703VQyhSQuhSwOVVY5rF4brJ1a6reWhk6Ve008TfqnCRXPl/SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737137211; c=relaxed/simple;
	bh=k8F+Py09ow5xNxpLo2lKsypfIEO5iGKvDE0OfOKSmpE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rpjXBRGuI6ossMZlU+SdLBCHFu3yOzbdeXGX9cIk/VigRJLxf0ife4DtOMf43YblwupQlwGs7kMn1JViariCqL2lifKA2JB0GKGGIIIW3QlMxvM/jZGfNhIidN2CdJcNblEW61aiXGcEYNVQuIz9csp+4XTz2usJCq8LHu6t3oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B8TLSD3v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737137208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8mjFkUumJwJiAKwRbpAuQ4KVkrv1oWc374O0VRxVMSY=;
	b=B8TLSD3vIr6gSEMgTwwaW/q9Y2O/RdXYgkOOl36A1Zn+/bz8Bkzlx1qf1FPMEwIlg8GgG2
	yq8SqSINK36o0Ohg6JScGT05LjspMFY51i/EtWVCJwHjNu2T/e/yVaocPz4i8d6YNm6vR4
	v0vRhHr5rFoJV4rIAKUfL7+ff1OgV6Q=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-ef13TQmFMq2EjoY5JLAH2Q-1; Fri, 17 Jan 2025 13:06:47 -0500
X-MC-Unique: ef13TQmFMq2EjoY5JLAH2Q-1
X-Mimecast-MFC-AGG-ID: ef13TQmFMq2EjoY5JLAH2Q
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3cf788751a3so875425ab.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 10:06:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737137206; x=1737742006;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8mjFkUumJwJiAKwRbpAuQ4KVkrv1oWc374O0VRxVMSY=;
        b=kHelh8vaIx9Lb0WpkFlVbzVGwhvA2ZqFdOOVcdQyFmJEfw6sdazxmwUmUaNrlSmCqh
         pEUyztltYQcfmEU2f0FD6eERTTeHeG3jdw0dA7+wXysITgMwr0O09At6qkXk184YpXRK
         OY2Ia5VdLle7faAMKrxmQW9IMoD/HGTuSZ2ngxr/pfEsmsp/InTolJPduT08CedHqUxU
         0dl0qfDaxomkJWQRPUCx8W3puCLPvMAh7NauOr2IqvOrHqF+E/XIepuA3u0nljDQb4Tb
         S2nyXXXBeXeGc4nTmXc3blaPcrAsbqCNTebBg1BpX7xorgpvFOa4qnlEBm0iUJfKADK1
         T4aQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6dIKKGaBXD/AlmuEIMDUt9o5uJ6bLfQ1PXRXoipbXd7q99hxALibpvb176a7Rumu2PZA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz67QoXmuSLJqfFWNtDhzQDOSJXHv/juP32HY71p4FkXgRvKkC3
	VWrHoEk+sJ9H/JLkPj+QzcO4FvaPCTiWcawoGY1dSDbKmP7OqSnDjE7/6gi/KWqhcMM603svOwq
	oiEj22qnaKwUAZ2AIQ0Co4WR8j7BR7NAvfmaaKf0kIZSdRqJG1A==
X-Gm-Gg: ASbGncvKdYOPW3LL3k+0LRGMBxZCCwbi806cAxJGEnLdMRV9JJD+whbxLkhU5WM0+Dz
	4WTweLxJiDpZ+X6aMs644/dUX/ulFNedhCsqsn6jNKpQ2Jv6VgjQJ59o2VJoT7bgTwjNBrEaDgy
	CuGyIDlT+8+3AJ9h+Ft5v2CH6vJvPQFgLGjAtnlmrtfcajX1AKS7gi1biqQnsAPw45ucF4iqVQQ
	eP8tbfr3urCxA65T46nNCbvzn4cxScUpXXQ9KotMfZd5pWIFvDmivADJ1xp
X-Received: by 2002:a05:6602:81c:b0:83a:abd1:6af2 with SMTP id ca18e2360f4ac-851b62a8c7dmr64611639f.3.1737137206556;
        Fri, 17 Jan 2025 10:06:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0c9dKPF5thmIZVKOyk8ONBTOuSbhlRXF42EpWjIgTSp0o1bHg+IeKA9vmUbbBJczAakOb9g==
X-Received: by 2002:a05:6602:81c:b0:83a:abd1:6af2 with SMTP id ca18e2360f4ac-851b62a8c7dmr64610239f.3.1737137206154;
        Fri, 17 Jan 2025 10:06:46 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-851b01f2e4asm72864339f.17.2025.01.17.10.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 10:06:45 -0800 (PST)
Date: Fri, 17 Jan 2025 13:06:29 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <zhiw@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF
 BAR1 to the VM
Message-ID: <20250117130629.03648fa9.alex.williamson@redhat.com>
In-Reply-To: <20250117152334.2786-3-ankita@nvidia.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
	<20250117152334.2786-3-ankita@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Jan 2025 15:23:33 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> There is a HW defect on Grace Hopper (GH) to support the
> Multi-Instance GPU (MIG) feature [1] that necessiated the presence
> of a 1G region carved out from the device memory and mapped as
> uncached. The 1G region is shown as a fake BAR (comprising region 2 and 3)
> to workaround the issue.
> 
> The Grace Blackwell systems (GB) differ from GH systems in the following
> aspects:
> 1. The aforementioned HW defect is fixed on GB systems.
> 2. There is a usable BAR1 (region 2 and 3) on GB systems for the
> GPUdirect RDMA feature [2].
> 
> This patch accommodate those GB changes by showing the 64b physical
> device BAR1 (region2 and 3) to the VM instead of the fake one. This
> takes care of both the differences.
> 
> Moreover, the entire device memory is exposed on GB as cacheable to
> the VM as there is no carveout required.
> 
> Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]
> Link: https://docs.nvidia.com/cuda/gpudirect-rdma/ [2]
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 65 ++++++++++++++++++-----------
>  1 file changed, 41 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 85eacafaffdf..89d38e3c0261 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -17,9 +17,6 @@
>  #define RESMEM_REGION_INDEX VFIO_PCI_BAR2_REGION_INDEX
>  #define USEMEM_REGION_INDEX VFIO_PCI_BAR4_REGION_INDEX
>  
> -/* Memory size expected as non cached and reserved by the VM driver */
> -#define RESMEM_SIZE SZ_1G
> -
>  /* A hardwired and constant ABI value between the GPU FW and VFIO driver. */
>  #define MEMBLK_SIZE SZ_512M
>  
> @@ -72,7 +69,7 @@ nvgrace_gpu_memregion(int index,
>  	if (index == USEMEM_REGION_INDEX)
>  		return &nvdev->usemem;
>  
> -	if (index == RESMEM_REGION_INDEX)
> +	if (nvdev->resmem.memlength && index == RESMEM_REGION_INDEX)
>  		return &nvdev->resmem;
>  
>  	return NULL;
> @@ -757,21 +754,31 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
>  			      u64 memphys, u64 memlength)
>  {
>  	int ret = 0;
> +	u64 resmem_size = 0;
>  
>  	/*
> -	 * The VM GPU device driver needs a non-cacheable region to support
> -	 * the MIG feature. Since the device memory is mapped as NORMAL cached,
> -	 * carve out a region from the end with a different NORMAL_NC
> -	 * property (called as reserved memory and represented as resmem). This
> -	 * region then is exposed as a 64b BAR (region 2 and 3) to the VM, while
> -	 * exposing the rest (termed as usable memory and represented using usemem)
> -	 * as cacheable 64b BAR (region 4 and 5).
> +	 * On Grace Hopper systems, the VM GPU device driver needs a non-cacheable
> +	 * region to support the MIG feature owing to a hardware bug. Since the
> +	 * device memory is mapped as NORMAL cached, carve out a region from the end
> +	 * with a different NORMAL_NC property (called as reserved memory and
> +	 * represented as resmem). This region then is exposed as a 64b BAR
> +	 * (region 2 and 3) to the VM, while exposing the rest (termed as usable
> +	 * memory and represented using usemem) as cacheable 64b BAR (region 4 and 5).
>  	 *
>  	 *               devmem (memlength)
>  	 * |-------------------------------------------------|
>  	 * |                                           |
>  	 * usemem.memphys                              resmem.memphys
> +	 *
> +	 * This hardware bug is fixed on the Grace Blackwell platforms and the
> +	 * presence of fix can be determined through nvdev->has_mig_hw_bug_fix.
> +	 * Thus on systems with the hardware fix, there is no need to partition
> +	 * the GPU device memory and the entire memory is usable and mapped as
> +	 * NORMAL cached.
>  	 */
> +	if (!nvdev->has_mig_hw_bug_fix)
> +		resmem_size = SZ_1G;
> +
>  	nvdev->usemem.memphys = memphys;
>  
>  	/*
> @@ -780,23 +787,30 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
>  	 * memory (usemem) is added to the kernel for usage by the VM
>  	 * workloads. Make the usable memory size memblock aligned.
>  	 */
> -	if (check_sub_overflow(memlength, RESMEM_SIZE,
> +	if (check_sub_overflow(memlength, resmem_size,
>  			       &nvdev->usemem.memlength)) {
>  		ret = -EOVERFLOW;
>  		goto done;
>  	}
>  
> -	/*
> -	 * The USEMEM part of the device memory has to be MEMBLK_SIZE
> -	 * aligned. This is a hardwired ABI value between the GPU FW and
> -	 * VFIO driver. The VM device driver is also aware of it and make
> -	 * use of the value for its calculation to determine USEMEM size.
> -	 */
> -	nvdev->usemem.memlength = round_down(nvdev->usemem.memlength,
> -					     MEMBLK_SIZE);
> -	if (nvdev->usemem.memlength == 0) {
> -		ret = -EINVAL;
> -		goto done;
> +	if (!nvdev->has_mig_hw_bug_fix) {
> +		/*
> +		 * If the device memory is split to workaround the MIG bug,
> +		 * the USEMEM part of the device memory has to be MEMBLK_SIZE
> +		 * aligned. This is a hardwired ABI value between the GPU FW and
> +		 * VFIO driver. The VM device driver is also aware of it and make
> +		 * use of the value for its calculation to determine USEMEM size.
> +		 *
> +		 * If the hardware has the fix for MIG, there is no requirement
> +		 * for splitting the device memory to create RESMEM. The entire
> +		 * device memory is usable and will be USEMEM.
> +		 */
> +		nvdev->usemem.memlength = round_down(nvdev->usemem.memlength,
> +						     MEMBLK_SIZE);
> +		if (nvdev->usemem.memlength == 0) {
> +			ret = -EINVAL;
> +			goto done;
> +		}

Why does this operation need to be predicated on the buggy device?
Does GB have memory that's not a multiple of 512MB?  I was expecting
this would be a no-op on GB and therefore wouldn't need to be
conditional.  Thanks,

Alex

>  	}
>  
>  	if ((check_add_overflow(nvdev->usemem.memphys,
> @@ -813,7 +827,10 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
>  	 * the BAR size for them.
>  	 */
>  	nvdev->usemem.bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
> -	nvdev->resmem.bar_size = roundup_pow_of_two(nvdev->resmem.memlength);
> +
> +	if (nvdev->resmem.memlength)
> +		nvdev->resmem.bar_size =
> +			roundup_pow_of_two(nvdev->resmem.memlength);
>  done:
>  	return ret;
>  }


