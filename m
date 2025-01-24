Return-Path: <kvm+bounces-36549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59340A1BA48
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 332E618906AE
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FEC01953A9;
	Fri, 24 Jan 2025 16:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LdeUSw1M"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08E818A6B2
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737735902; cv=none; b=tLRge4J3B31dBVCT91GOFEsQ5uYAW+EVP9a91IcCz69XJapUBAD6qvKBOQChMTpxxFWCNCPKSSGySvHFK/1CP5YPXD6rSteB52d/tSgxshAMPJdRfD2i2N3Uq/WP8zinNEdMnSa8CSfyaennKYejd0I/XohO7FpE55tnX2oaWN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737735902; c=relaxed/simple;
	bh=CWfK3tPR2GmT2twHa8FOPccArDnfK3LdlDUjKo2vxxk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iH3dF+ZzB9DbZuYyECbY4pbNHEFNOwOjQa58HsW2LhlcGJH6NOO0Fa9SjkryA/mTIFLE1hffDPP+/qazLFu4pQ5K4gsJY2iF5LgdPLPnmwT0n4eKAdXy/RnFrqpqc1IkCJ2rc5h+2slTFh5XbfdY4CfTvcRJgZehqxArekEANM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LdeUSw1M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737735899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cn0+KzXyVl0N+dq6Z+l3EIZmrDN/yiykev2yHytr19o=;
	b=LdeUSw1MN4d1iLQLv6VNTrnqHXm13bjUpbnWkaP5XSAgwENV5/5XfELmJwf6j5PAbx9pLV
	ADBYX29o7sEhabVl6m3sSl/dVlZzka/eTU0VrVBs2qI2fw8XimD5L/svFx8zln5/FbV/Bu
	mcz0xQnoDN/IZwq+DJ3HtgyrNF0gJ6E=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-wDa4PUm2PDm_FeoIXEVGgQ-1; Fri, 24 Jan 2025 11:24:57 -0500
X-MC-Unique: wDa4PUm2PDm_FeoIXEVGgQ-1
X-Mimecast-MFC-AGG-ID: wDa4PUm2PDm_FeoIXEVGgQ
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3cfb22f7a60so980295ab.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 08:24:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737735897; x=1738340697;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cn0+KzXyVl0N+dq6Z+l3EIZmrDN/yiykev2yHytr19o=;
        b=t6wVUwek2r4iNFUOfLcBXUx5l1hWHtHI/Cekpkmm9bJF67LcHUdT0szQc3tat0sz8h
         qZC0NPAmDGN+m6owPXFqP7vPcDTttS22L8i4WEFujTFcVc0xOIQ/ngkyLPL9LgSam4fb
         //Iv1i/FYcQUIWCX13wh8MkSDluetEibksL2bu4IVCkRpZ3GGzZSHqh/pR9hLD9OZhJy
         GRIv7fbMRs1PTY4XOBKN7jpf9YcE1Q2dSknySgGdfgyO0P1B0zaV3Y5GdYo/nMU0c0hN
         cndWjdrFXDpUxkUj5P77K5wyy0k0+MCTaOwbz9w0smlml5pRMOO9yNjFH8VAGRfR1lGc
         xfHw==
X-Forwarded-Encrypted: i=1; AJvYcCWRYQbHzOU5nTD4YLR/75DFz8vK/zRjW4XhzCORteAh/GDA7k3arhyzbxkxUk+xcFdrPpI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJO5IpE2yHM0K6Cdp/d1f71MWzMVo2UTHTlhq7F6nd+WzhzPCA
	KbHeQ/g/ZBHh4qqVxtSaa+S2X6GqCVysBLW1ZZ1fFR0BgjGWQ4G32eW2sbzoxhpYgV1r0kwt8u2
	8eIKajm/flCgdirrbZl+K4T7ZqM6pFMCvKDWkASEqFYMt65OlurTrKdfDPA==
X-Gm-Gg: ASbGncu9eLPlmn1zBec4lmaYf+fBqBd5JMW7SZVlEvANWnuYWK2z16E0SgztI9eTdnO
	BaIi9v6FeclGubc96u5ZjzZB9kIZf39Vg7hOEd4Dh1EvN37b66KCk3RQpJVu8TzjUHwCwk5HNMv
	qEpYsQcfX3GWL4BnKSWK9PkIcuC9erlXsUlQqjnJIdE4ZijglRgM5C7s9+aQLFYuiH0ows5pHHD
	ZMtCBWqiOFJ++Zfq0maw2jX3qu4iEmqAxtmw0p6l/XP4hYXy6fmDOpa61o1ESFI11oUi8Lycw==
X-Received: by 2002:a05:6e02:1707:b0:3cf:bc24:2336 with SMTP id e9e14a558f8ab-3cfbc2423f8mr20614685ab.5.1737735896510;
        Fri, 24 Jan 2025 08:24:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGs8kE7HGWUswtGXw81IR02XMeOqo9fhlNsHZw+bYVVSIj6GrGv/AhGfHW9ODHGR+Ewrm8cLA==
X-Received: by 2002:a05:6e02:1707:b0:3cf:bc24:2336 with SMTP id e9e14a558f8ab-3cfbc2423f8mr20614535ab.5.1737735896110;
        Fri, 24 Jan 2025 08:24:56 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1dbaf035sm694919173.134.2025.01.24.08.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 08:24:55 -0800 (PST)
Date: Fri, 24 Jan 2025 09:24:53 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <zhiw@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <kjaju@nvidia.com>, <anuaggarwal@nvidia.com>,
 <mochs@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] vfio/nvgrace-gpu: Read dvsec register to
 determine need for uncached resmem
Message-ID: <20250124092453.7d3df3d6.alex.williamson@redhat.com>
In-Reply-To: <20250123174854.3338-2-ankita@nvidia.com>
References: <20250123174854.3338-1-ankita@nvidia.com>
	<20250123174854.3338-2-ankita@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jan 2025 17:48:52 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's recently introduced Grace Blackwell (GB) Superchip is a
> continuation with the Grace Hopper (GH) superchip that provides a
> cache coherent access to CPU and GPU to each other's memory with
> an internal proprietary chip-to-chip cache coherent interconnect.
> 
> There is a HW defect on GH systems to support the Multi-Instance
> GPU (MIG) feature [1] that necessiated the presence of a 1G region
> with uncached mapping carved out from the device memory. The 1G
> region is shown as a fake BAR (comprising region 2 and 3) to
> workaround the issue. This is fixed on the GB systems.
> 
> The presence of the fix for the HW defect is communicated by the
> device firmware through the DVSEC PCI config register with ID 3.
> The module reads this to take a different codepath on GB vs GH.
> 
> Scan through the DVSEC registers to identify the correct one and use
> it to determine the presence of the fix. Save the value in the device's
> nvgrace_gpu_pci_core_device structure.
> 
> Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]
> 
> CC: Jason Gunthorpe <jgg@nvidia.com>
> CC: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 30 +++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index a467085038f0..dde2daa597f8 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -23,6 +23,11 @@
>  /* A hardwired and constant ABI value between the GPU FW and VFIO driver. */
>  #define MEMBLK_SIZE SZ_512M
>  
> +#define DVSEC_BITMAP_OFFSET 0xA
> +#define MIG_SUPPORTED_WITH_CACHED_RESMEM BIT(0)
> +
> +#define GPU_CAP_DVSEC_REGISTER 3
> +
>  /*
>   * The state of the two device memory region - resmem and usemem - is
>   * saved as struct mem_region.
> @@ -46,6 +51,7 @@ struct nvgrace_gpu_pci_core_device {
>  	struct mem_region resmem;
>  	/* Lock to control device memory kernel mapping */
>  	struct mutex remap_lock;
> +	bool has_mig_hw_bug;
>  };
>  
>  static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
> @@ -812,6 +818,26 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
>  	return ret;
>  }
>  
> +static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
> +{
> +	int pcie_dvsec;
> +	u16 dvsec_ctrl16;
> +
> +	pcie_dvsec = pci_find_dvsec_capability(pdev, PCI_VENDOR_ID_NVIDIA,
> +					       GPU_CAP_DVSEC_REGISTER);
> +
> +	if (pcie_dvsec) {
> +		pci_read_config_word(pdev,
> +				     pcie_dvsec + DVSEC_BITMAP_OFFSET,
> +				     &dvsec_ctrl16);
> +
> +		if (dvsec_ctrl16 & MIG_SUPPORTED_WITH_CACHED_RESMEM)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  			     const struct pci_device_id *id)
>  {
> @@ -832,6 +858,8 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
>  	dev_set_drvdata(&pdev->dev, &nvdev->core_device);
>  
>  	if (ops == &nvgrace_gpu_pci_ops) {
> +		nvdev->has_mig_hw_bug = nvgrace_gpu_has_mig_hw_bug(pdev);
> +
>  		/*
>  		 * Device memory properties are identified in the host ACPI
>  		 * table. Set the nvgrace_gpu_pci_core_device structure.
> @@ -868,6 +896,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
>  	/* GH200 SKU */
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2348) },
> +	/* GB200 SKU */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2941) },
>  	{}
>  };
>  

GB support isn't really complete until patch 3, so shouldn't we hold
off on adding the ID to the table until a trivial patch 4, adding only
the chunk above?  Thanks,

Alex


