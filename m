Return-Path: <kvm+bounces-64410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6D1C81DB1
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:16:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CE09E3484B9
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 17:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B0A26ED30;
	Mon, 24 Nov 2025 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Lq8u1Lad"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1091F09AD
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 17:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004591; cv=none; b=oOYmGJCWS1j6+tepKunLbZBijUPkbg0BfnTDG4yhW8cg6AzRnuHMEjzpabeQUODVi/M04vz9XXxHTlWcnTBFt3qkFzK23ge1u5YXrQxEHOYXnR3P20SthZHo89yM9FQ9PM2lnNZv5a+T28tCvHX9VsRtm3dAlkeViqrC0eXDX+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004591; c=relaxed/simple;
	bh=RctiqtbBhJKCZPpjrEWY0jlZQ1roaQG+fNYMpQLPRdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+f08/UIm1jdoVzKLIE2pWs3/63b1/S7LXmBp1qWKgmh/kz0tSf1bC/W82i2R3XsXiFefOV/yFPEUwPTlu2HnQ+AOWmebc23nOpse307Wipqz05Yd0NPFQhDFV2yYS5eVMKBP85Np/YdTMUG2hfj1P7V6SInKuhy2iJaQ3SMsAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Lq8u1Lad; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-93a9f700a8cso1017452241.2
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 09:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1764004588; x=1764609388; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GwLrnesgHc6rGCdpAVzRVv61WyvYVDndIchiuSFKzFs=;
        b=Lq8u1Ladva4ci4DFr0Q5IeNeG4fWaMsXVTdYRCV4rXDwyodB+m3B2M8NbQi6ki0dm/
         mEZkSxLmJeUymK8VjNzzRYFG/tR79ebdefanEFXwlOJ8xBV/IxDtuadm/yxQsE/dzNCR
         8s4LuH/hVTm9u7pEABNftrJ/VU+agSV3wIXg5chZSVC8sqXyWnI50NDZ8cXKICLGXJpN
         5icASkKV8StNB3Dg70u2h7LLEbMauAz95w/Sad7h9eE5Y2gS1KYtghKIvdQP9TledvxJ
         onDoALb0V6pZA/7/VYvL7Lj+zSckHu4D8XWqY7CLaLd+HXXqV7bM/IhDKHb0r8BrRtyZ
         niAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764004588; x=1764609388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GwLrnesgHc6rGCdpAVzRVv61WyvYVDndIchiuSFKzFs=;
        b=YLV19KbXbRrKFhE0qtQ1zGTi1Z1ZMjYwHHEKiUGrIe8HlXmjER3jI2ddtaVUz6uoEV
         NYO9W85MaBDG3oPw6idsQKdRNfPvW7WSNI+GutQL86iQRB0XH69uhajmkZILgLXiGiKv
         wA3VM0E7U+r0+eGQC+Zw9gvGIE4Fawj3rBg8r+cpXMBQnn08144xPuP1tjl0TPArtfIZ
         OrvB/jmAJ96z5LIH1B25djobzFpxrJnjod8bkLIVjpd3YNWtbASkraILLQ9VnPH7ZZ0Z
         HjeR1SOW7r5GXcyeO0V1IGPdbt0AqX9kIcs7PbG0bP+dshqRbwTVwVBSP0ejKHue/JCs
         EHbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXA8dtX97lmoELuFW9kseg0dh9g4eT7HyRa0gQKKM8FI38R9KQ+uKc4keVfKl/mFx4jxeo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPEfvvXJCail1saS7uiZAvWKau+W+97k8U+j0mYdQeuxhTT/Gt
	llowcxvnT7mjNmomDFZAKAqxeXAL0UDwsw1yvZSP/mgPY4kzy2a3hvoA0Mm4BSdJWDo=
X-Gm-Gg: ASbGncseq15pgFNOq2i3x4FIWr8vSPGM4EnZKr1q3+N1gK4ttfZEh9eJT8Uh4FiKjzh
	JAyPFp4No/2MiliGbcQ4KAD2oRFpYuYWZG4OOJeztHUajqEbuhAmtc8C9lJ2g7hZbfCJC8XGv55
	0rwPxXPsSrvXA2C87YY/KNxpX+9DW90TfeJZWHh3aZfRPJ4Yvk3kueBeu/IHGQrGFYgTQGuKx8c
	ng11HBF9WJ4AVYxkV4Fm/zlKTeO0nTRnAejM3GxVpdHnY6N3CKGn+nqOCR2qt0puDCo1vdOkuYG
	VOOerCJJEPIEQ0JICROqPGWv7TlXsHa+z/Mp/Tk+WySVvKJzQiqLAbLKaJUsJ6ILnqDpPyAk6qq
	FEOpDZTv7qhhDMgKV9f+sNZZuHDKNnm9hoGfRg9vMiNi57nKqdI5Ib2O7I1TSZaQvByStxKPui4
	CqvABFDRQF5FhP4Xi0zNnBMugfNpwa+gT3w81oXgjrGDuu7eDbLQYXCbV2
X-Google-Smtp-Source: AGHT+IFLCUBw0RbOGAohRjIeR7OHrHm19xDCHizs3J9XIV+2ha4CeOBE28rmRpdPudW5lqxk0d76CQ==
X-Received: by 2002:a05:6102:419f:b0:535:2f14:ea5e with SMTP id ada2fe7eead31-5e1de00dfb5mr3230731137.8.1764004580518;
        Mon, 24 Nov 2025 09:16:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48e909b6sm94289501cf.32.2025.11.24.09.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 09:16:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vNaAl-00000001wXD-1Ugh;
	Mon, 24 Nov 2025 13:16:19 -0400
Date: Mon, 24 Nov 2025 13:16:19 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: ankita@nvidia.com
Cc: yishaih@nvidia.com, skolothumtho@nvidia.com, kevin.tian@intel.com,
	alex@shazbot.org, aniketa@nvidia.com, vsethi@nvidia.com,
	mochs@nvidia.com, Yunxiang.Li@amd.com, yi.l.liu@intel.com,
	zhangdongdong@eswincomputing.com, avihaih@nvidia.com,
	bhelgaas@google.com, peterx@redhat.com, pstanner@redhat.com,
	apopple@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiw@nvidia.com, danw@nvidia.com,
	dnigam@nvidia.com, kjaju@nvidia.com
Subject: Re: [PATCH v5 1/7] vfio/nvgrace-gpu: Use faults to map device memory
Message-ID: <20251124171619.GT233636@ziepe.ca>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124115926.119027-2-ankita@nvidia.com>

On Mon, Nov 24, 2025 at 11:59:20AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> To make use of the huge pfnmap support and to support zap/remap
> sequence, fault/huge_fault ops based mapping mechanism needs to
> be implemented.
> 
> Currently nvgrace-gpu module relies on remap_pfn_range to do
> the mapping during VM bootup. Replace it to instead rely on fault
> and use vmf_insert_pfn to setup the mapping.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 50 +++++++++++++++++------------
>  1 file changed, 30 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index e346392b72f6..f74f3d8e1ebe 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -130,6 +130,32 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> +static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct nvgrace_gpu_pci_core_device *nvdev = vma->vm_private_data;
> +	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);

This should not be a signed value. I think the right type is unsigned long.

> +	vm_fault_t ret = VM_FAULT_SIGBUS;
> +	struct mem_region *memregion;
> +	unsigned long pgoff, pfn;
> +
> +	memregion = nvgrace_gpu_memregion(index, nvdev);
> +	if (!memregion)
> +		return ret;
> +
> +	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
> +	pfn = PHYS_PFN(memregion->memphys) + pgoff;
> +
> +	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock)
> +		ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);

This needs to check for this:

        if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
                goto out_unlock;

So I think your series is out of order.

Move patch 2 before this one, add the above lines to
vfio_pci_vmf_insert_pfn() as well as a lockdep to check the
memory_lock

Then just call vfio_pci_vmf_insert_pfn() here and consider squashing
patch 3.

Jason

