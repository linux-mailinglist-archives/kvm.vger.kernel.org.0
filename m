Return-Path: <kvm+bounces-34938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E3DA08089
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:21:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4EEA188AAAE
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D411F75B3;
	Thu,  9 Jan 2025 19:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hACrHxoH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE97418DF64
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736450497; cv=none; b=qhMQSdsZZ83LN/Z0M1KfIVPIJk+cP9GQ863EsMjslPJk4GWlNZJvjGQAzJNNQPBMMZFAB9IMU+6fGSm7v9uJoySOCWA6EF3+o0vEukySpTH+Bxhy5JRL18sU4dN9/CE6qUxCLX4ppHGlSNCtT+81Sh+M5UmANBoh1OmjYmEzNg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736450497; c=relaxed/simple;
	bh=1VXcu8J4zDHhTrL5/OvuJJqPYBknxtMOtfvGWdeV7/I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RB8WlcINnlb0HdMMuOUQI6fqtElwCHaHUvN0L0fODtD5h38XCXlt6c6uAXF8c5da+DhufUif1GH2IiFc7HC0zrxRFbiZwRCE9ZxN9LgNx3HHPD0/VvgYDBAWg1ehxFJpP0F5N0jY8d3kOrgr/BSPXp67+JwUotvNvT+wcJIbdJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hACrHxoH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736450493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iAyjAb7PBWRyAuz+1PdB6LhTCq5OIkw/AzaQ/w/A76E=;
	b=hACrHxoHV+/BlSgQP90oMv4y4q3g544fuSp8VNoS8KdqonH+YQtnLQ33zj3F2Y2ewpO47p
	nP7MChDocSF5YSbk9ceNtnVijqcbPG0pCAJrz4f3IQ9CTHs3enHj5jGOLFUDHh3GgDJ0U+
	1+wt+swA2o0IHcehMGfu+4sJLldTEbg=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-hr0XY-5NOQqgBHcCA-7QzQ-1; Thu, 09 Jan 2025 14:21:32 -0500
X-MC-Unique: hr0XY-5NOQqgBHcCA-7QzQ-1
X-Mimecast-MFC-AGG-ID: hr0XY-5NOQqgBHcCA-7QzQ
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-844e5d2d07dso20010939f.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:21:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736450492; x=1737055292;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iAyjAb7PBWRyAuz+1PdB6LhTCq5OIkw/AzaQ/w/A76E=;
        b=YCl2eC3iMXWN2J2u0noz5Xo/YzxnbOUVzvscbJamiA0RvxjLQ4Xh3VtZIqq9GbrMo1
         I/D0WfZBtXOsoh5hf0E5m07iq4LA/pOWfaOg1BchyKGEXOJeC/Es7dqUMTUpXmuQUFuL
         Sr6Vl4G4dZYCgKNlHpyND8GNjlgi9LvSEyN6OPAESlTm8ri1GsA/sLt/H+AVif2AmJhK
         k7HaYaG6INumh/U92RjM3wQRMqWLw+gve+BX+uNkgSkfQEREDOF/xePaqkl2amsQpkg5
         8QAzi9dNGG1KUxb+dK37J5dBSjjk2l01ZqW0AWsYhKfHYqW+bu+/HuPnorO6BuhcBPsP
         TwJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW3vPVklnjoGoyiB9e0H8A4W6oyWmITOqbL/HIT7+0CH9sbf7RdEHrmyz26YjCfF32IFo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrCHwzRy5R+f1j6n5fln9oIB0m8D3Ed138Igbuk3ian4zavmBm
	4NFcJR9FQV8dYvITinhtXsxzdU+pRjh6gONtSywbj5N0caf0c743s2IkcwHXwlXkn3U69/Hb7Uj
	gKTcpVMKT283/r4ETkRYeSCqKTCOMovnKoFqfYTKZrOD0tFq48A==
X-Gm-Gg: ASbGncu4tzGj0vMmu6yG9p6n0WJ2yLTV3d8yV1FSisu+DPduCuq8VtH6P47u7XS7wse
	ylGqMyc4L1HCSxZQKCei/u9SfSw09yGaz+r33Gny0QTrUR1aKj6F2Bvo+dkqulaAW8thb3I8qap
	c+WNiXXPLf7wG4HEfGpu1PztmWZ4GqdDZhH14SGNjZzVwQ7NH1LkUcwIEl43SfpSvZlDHnCT3xl
	wE2J1Kub+4r6/LuK9AB3bK0bF3Fn0RNU/Tb2DeYeCD5MXC/7PJbCCFebIvC
X-Received: by 2002:a05:6e02:16c7:b0:3a7:bfc6:be with SMTP id e9e14a558f8ab-3ce3a8f134dmr17530775ab.5.1736450491733;
        Thu, 09 Jan 2025 11:21:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEndpSc5anNrpCccoAV3Ich4D4eit45O/0ZYPOo019ot95MvdlNfVAdN2PfeTL0Ef9iJsbseA==
X-Received: by 2002:a05:6e02:16c7:b0:3a7:bfc6:be with SMTP id e9e14a558f8ab-3ce3a8f134dmr17530555ab.5.1736450491344;
        Thu, 09 Jan 2025 11:21:31 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce4afc329dsm5221535ab.65.2025.01.09.11.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 11:21:30 -0800 (PST)
Date: Thu, 9 Jan 2025 14:21:23 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <zhiw@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF
 BAR1 to the VM
Message-ID: <20250109142123.3537519a.alex.williamson@redhat.com>
In-Reply-To: <20250105173615.28481-3-ankita@nvidia.com>
References: <20250105173615.28481-1-ankita@nvidia.com>
	<20250105173615.28481-3-ankita@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 5 Jan 2025 17:36:14 +0000
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
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 32 +++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 85eacafaffdf..44a276c886e1 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -72,7 +72,7 @@ nvgrace_gpu_memregion(int index,
>  	if (index == USEMEM_REGION_INDEX)
>  		return &nvdev->usemem;
>  
> -	if (index == RESMEM_REGION_INDEX)
> +	if (!nvdev->has_mig_hw_bug_fix && index == RESMEM_REGION_INDEX)
>  		return &nvdev->resmem;
>  
>  	return NULL;
> @@ -715,6 +715,16 @@ static const struct vfio_device_ops nvgrace_gpu_pci_core_ops = {
>  	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
>  };
>  
> +static void
> +nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
> +			      struct nvgrace_gpu_pci_core_device *nvdev,
> +			      u64 memphys, u64 memlength)
> +{
> +	nvdev->usemem.memphys = memphys;
> +	nvdev->usemem.memlength = memlength;
> +	nvdev->usemem.bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
> +}
> +
>  static int
>  nvgrace_gpu_fetch_memory_property(struct pci_dev *pdev,
>  				  u64 *pmemphys, u64 *pmemlength)
> @@ -752,9 +762,9 @@ nvgrace_gpu_fetch_memory_property(struct pci_dev *pdev,
>  }
>  
>  static int
> -nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
> -			      struct nvgrace_gpu_pci_core_device *nvdev,
> -			      u64 memphys, u64 memlength)
> +nvgrace_gpu_nvdev_struct_workaround(struct pci_dev *pdev,
> +				    struct nvgrace_gpu_pci_core_device *nvdev,
> +				    u64 memphys, u64 memlength)
>  {
>  	int ret = 0;
>  
> @@ -864,10 +874,16 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  		 * Device memory properties are identified in the host ACPI
>  		 * table. Set the nvgrace_gpu_pci_core_device structure.
>  		 */
> -		ret = nvgrace_gpu_init_nvdev_struct(pdev, nvdev,
> -						    memphys, memlength);
> -		if (ret)
> -			goto out_put_vdev;
> +		if (nvdev->has_mig_hw_bug_fix) {
> +			nvgrace_gpu_init_nvdev_struct(pdev, nvdev,
> +						      memphys, memlength);
> +		} else {
> +			ret = nvgrace_gpu_nvdev_struct_workaround(pdev, nvdev,
> +								  memphys,
> +								  memlength);
> +			if (ret)
> +				goto out_put_vdev;
> +		}

Doesn't this work out much more naturally if we just do something like:

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c
b/drivers/vfio/pci/nvgrace-gpu/main.c index 85eacafaffdf..43a9457442ff
100644 --- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -17,9 +17,6 @@
 #define RESMEM_REGION_INDEX VFIO_PCI_BAR2_REGION_INDEX
 #define USEMEM_REGION_INDEX VFIO_PCI_BAR4_REGION_INDEX
 
-/* Memory size expected as non cached and reserved by the VM driver */
-#define RESMEM_SIZE SZ_1G
-
 /* A hardwired and constant ABI value between the GPU FW and VFIO
driver. */ #define MEMBLK_SIZE SZ_512M
 
@@ -72,7 +69,7 @@ nvgrace_gpu_memregion(int index,
 	if (index == USEMEM_REGION_INDEX)
 		return &nvdev->usemem;
 
-	if (index == RESMEM_REGION_INDEX)
+	if (nvdev->resmem.memlength && index == RESMEM_REGION_INDEX)
 		return &nvdev->resmem;
 
 	return NULL;
@@ -757,6 +754,13 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 			      u64 memphys, u64 memlength)
 {
 	int ret = 0;
+	u64 resmem_size = 0;
+
+	/*
+	 * Comment about the GH bug that requires this and fix in GB
+	 */
+	if (!nvdev->has_mig_hw_bug_fix)
+		resmem_size = SZ_1G;
 
 	/*
 	 * The VM GPU device driver needs a non-cacheable region to
support @@ -780,7 +784,7 @@ nvgrace_gpu_init_nvdev_struct(struct
pci_dev *pdev,
 	 * memory (usemem) is added to the kernel for usage by the VM
 	 * workloads. Make the usable memory size memblock aligned.
 	 */
-	if (check_sub_overflow(memlength, RESMEM_SIZE,
+	if (check_sub_overflow(memlength, resmem_size,
 			       &nvdev->usemem.memlength)) {
 		ret = -EOVERFLOW;
 		goto done;
@@ -813,7 +817,9 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 	 * the BAR size for them.
 	 */
 	nvdev->usemem.bar_size =
roundup_pow_of_two(nvdev->usemem.memlength);
-	nvdev->resmem.bar_size =
roundup_pow_of_two(nvdev->resmem.memlength);
+	if (nvdev->resmem.memlength)
+		nvdev->resmem.bar_size =
+			roundup_pow_of_two(nvdev->resmem.memlength);
 done:
 	return ret;
 }

Thanks,
Alex


