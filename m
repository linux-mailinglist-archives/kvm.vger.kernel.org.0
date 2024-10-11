Return-Path: <kvm+bounces-28647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0835D99AC72
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 21:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83C101F26E78
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 19:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076351CB33E;
	Fri, 11 Oct 2024 19:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c9MFjG4B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5902F1C5782
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 19:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728673930; cv=none; b=mHRRXMkCySVXVhU/jQ3uovR3V/8pLiodSXUuqvbEr8bk5hhcG6VhcxQhhGaC2TFeRlFlAJT7P/l26WQyUps+cqDCrlo4vVTm1QHAw55nijQTFGxKUxZw9XB5OK+Macn/SDMF7sSJ4YASJVgAeyGm0NhLL18/Q4II+rlf7mSWPCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728673930; c=relaxed/simple;
	bh=RLCaiqYXdv9vLhUkI8qL2ZtBmD/O9wx9un22TR7hyu4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=icz2Qb/GoNMHU8IVhDn6iqyzAqw7XAIk5CRYikZ/2x2+D5zd4XrRUbcKiYfJC0C4Ar+CDdqOQ6tWFFidqOf56h29/L0C0piAZZEmab3IJTx+GmlSsZPJ7tiwN9567vNKKOje+T2xO4lihdpUg9JHLwd7sFUo8l2RUixE8TOSobE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c9MFjG4B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728673927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I+OX/8G3uytsdFoagf55NZyH1hjkUK5j7MSdcF6rs2U=;
	b=c9MFjG4BmmI+9SiZQLR5gl91i5qxT/kimps3hYbHqCPOjMpSS/2xDtP5ivBBTehVbwPkRH
	knYqfTUBq142uFUpM1WUyFUOd8W8kPguDf6Obcpd4kXA8MTZiepYUaO6+11yM2qQzA0PA9
	at89EL8gdT8imlPOhjx0FTzkrVl9AD4=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-NCONOy5oOlCbxunwbxKKzg-1; Fri, 11 Oct 2024 15:12:05 -0400
X-MC-Unique: NCONOy5oOlCbxunwbxKKzg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8353bd6481fso32911439f.1
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 12:12:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728673925; x=1729278725;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I+OX/8G3uytsdFoagf55NZyH1hjkUK5j7MSdcF6rs2U=;
        b=ZCVvamtBJOt6BJcx/T8SiTn/zGGZAIAiw1zTd3MjDClBA2D8ewz8QnjB6ClXyYV5gL
         BScx93EtnKjs+G0iCpLbFRzlTd4xXu87OikX5/5YP2GPh/eBszAQt2fxoYea518AhgEf
         BREZ0R6yiaDnWTk4hjgvOjjvb/oaJ6ZmNirIMwSdNmZ7t+JN72HzmYOwDwmfp1aGZ7X3
         l+Bxs+l5j05fMgSx75LGii6wHDUE+S3umpa5idxWoRBaYr5tIPeAwI1pz4jaSMX7k6rO
         0rnkXwgXesfcXpED8tVTgOiym+BHr+heB2zPE4kQ4driFO/b85CMhhQotOVMbagLPDVF
         mepQ==
X-Gm-Message-State: AOJu0YxzJ3pe+8mXwR0noUx/OxqnS087ttw0c5Z2JIzYiQRFcDNlTks7
	VCKkxtRoLLs7Kqg02LRq6nUAt4A18Wc/pVp2HlgsgZ9o2Lnb/eR4zbmbIt28VJOht7mdUkiE502
	VvmyHiMxtlTLHlkEvdL+M36hRAYWwFpW/c+/vv36fdo4PoUaa4g==
X-Received: by 2002:a05:6602:3284:b0:834:f667:217a with SMTP id ca18e2360f4ac-8379202f708mr83315739f.1.1728673924935;
        Fri, 11 Oct 2024 12:12:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMOjScxGW8WUwWIPwVN81fKV5ZAd5dudRciOYQaALugF8psCxv5LI7Tr8m8yh9l7uUa+kYEw==
X-Received: by 2002:a05:6602:3284:b0:834:f667:217a with SMTP id ca18e2360f4ac-8379202f708mr83314139f.1.1728673924485;
        Fri, 11 Oct 2024 12:12:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8354b8df7d1sm83056939f.2.2024.10.11.12.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 12:12:03 -0700 (PDT)
Date: Fri, 11 Oct 2024 13:12:02 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <alison.schofield@intel.com>,
 <dan.j.williams@intel.com>, <dave.jiang@intel.com>, <dave@stgolabs.net>,
 <jonathan.cameron@huawei.com>, <ira.weiny@intel.com>,
 <vishal.l.verma@intel.com>, <alucerop@amd.com>, <acurrid@nvidia.com>,
 <cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
 <aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
 <zhiwang@kernel.org>
Subject: Re: [RFC 05/13] vfio/cxl: expose CXL region to the usersapce via a
 new VFIO device region
Message-ID: <20241011131202.1b6edc8d.alex.williamson@redhat.com>
In-Reply-To: <20240920223446.1908673-6-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
	<20240920223446.1908673-6-zhiw@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Sep 2024 15:34:38 -0700
Zhi Wang <zhiw@nvidia.com> wrote:

> To directly access the device memory, a CXL region is required. Creating
> a CXL region requires to configure HDM decoders on the path to map the
> access of HPA level by level and evetually hit the DPA in the CXL
> topology.
> 
> For the usersapce, e.g. QEMU, to access the CXL region, the region is
> required to be exposed via VFIO interfaces.
> 
> Introduce a new VFIO device region and region ops to expose the created
> CXL region when initailize the device in the vfio-cxl-core. Introduce a
> new sub region type for the userspace to identify a CXL region.
> 
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_cxl_core.c   | 140 ++++++++++++++++++++++++++++-
>  drivers/vfio/pci/vfio_pci_config.c |   1 +
>  include/linux/vfio_pci_core.h      |   1 +
>  include/uapi/linux/vfio.h          |   3 +
>  4 files changed, 144 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
> index 6a7859333f67..ffc15fd94b22 100644
> --- a/drivers/vfio/pci/vfio_cxl_core.c
> +++ b/drivers/vfio/pci/vfio_cxl_core.c
> @@ -102,6 +102,13 @@ static int create_cxl_region(struct vfio_pci_core_device *core_dev)
>  	cxl_accel_get_region_params(cxl->region.region, &start, &end);
>  
>  	cxl->region.addr = start;
> +	cxl->region.vaddr = ioremap(start, end - start);
> +	if (!cxl->region.addr) {

This is testing addr, not the newly added vaddr.

> +		pci_err(pdev, "Fail to map CXL region\n");
> +		cxl_region_detach(cxl->cxled);
> +		cxl_dpa_free(cxl->cxled);
> +		goto out;
> +	}
>  out:
>  	cxl_release_endpoint(cxl->cxlmd, cxl->endpoint);
>  	return ret;
> @@ -152,17 +159,135 @@ static void disable_cxl(struct vfio_pci_core_device *core_dev)
>  {
>  	struct vfio_cxl *cxl = &core_dev->cxl;
>  
> -	if (cxl->region.region)
> +	if (cxl->region.region) {
> +		iounmap(cxl->region.vaddr);
>  		cxl_region_detach(cxl->cxled);
> +	}
>  
>  	if (cxl->cxled)
>  		cxl_dpa_free(cxl->cxled);
>  }
>  
> +static unsigned long vma_to_pfn(struct vm_area_struct *vma)
> +{
> +	struct vfio_pci_core_device *vdev = vma->vm_private_data;
> +	struct vfio_cxl *cxl = &vdev->cxl;
> +	u64 pgoff;
> +
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +
> +	return (cxl->region.addr >> PAGE_SHIFT) + pgoff;
> +}
> +
> +static vm_fault_t vfio_cxl_mmap_fault(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct vfio_pci_core_device *vdev = vma->vm_private_data;
> +	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
> +	unsigned long addr = vma->vm_start;
> +	vm_fault_t ret = VM_FAULT_SIGBUS;
> +
> +	pfn = vma_to_pfn(vma);
> +
> +	down_read(&vdev->memory_lock);
> +
> +	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
> +		goto out_unlock;
> +
> +	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
> +	if (ret & VM_FAULT_ERROR)
> +		goto out_unlock;
> +
> +	for (; addr < vma->vm_end; addr += PAGE_SIZE, pfn++) {
> +		if (addr == vmf->address)
> +			continue;
> +
> +		if (vmf_insert_pfn(vma, addr, pfn) & VM_FAULT_ERROR)
> +			break;
> +	}
> +
> +out_unlock:
> +	up_read(&vdev->memory_lock);
> +
> +	return ret;
> +}

This is identical to vfio_pci_mmap_fault(), we should figure out how to
reuse it rather than duplicate it.

> +
> +static const struct vm_operations_struct vfio_cxl_mmap_ops = {
> +	.fault = vfio_cxl_mmap_fault,
> +};

This should make use of the huge_fault support similar to what we added
in vfio-pci too, right?

> +
> +static int vfio_cxl_region_mmap(struct vfio_pci_core_device *core_dev,
> +				struct vfio_pci_region *region,
> +				struct vm_area_struct *vma)
> +{
> +	struct vfio_cxl *cxl = &core_dev->cxl;
> +	u64 phys_len, req_len, pgoff, req_start;
> +
> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_MMAP))
> +		return -EINVAL;
> +
> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_READ) &&
> +	    (vma->vm_flags & VM_READ))
> +		return -EPERM;
> +
> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_WRITE) &&
> +	    (vma->vm_flags & VM_WRITE))
> +		return -EPERM;
> +
> +	phys_len = cxl->region.size;
> +	req_len = vma->vm_end - vma->vm_start;
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	req_start = pgoff << PAGE_SHIFT;
> +
> +	if (req_start + req_len > phys_len)
> +		return -EINVAL;
> +
> +	vma->vm_private_data = core_dev;
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

I thought a large part of CXL was that the memory is coherent, maybe I
don't understand what we're providing access to here.

> +	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
> +
> +	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
> +			VM_DONTEXPAND | VM_DONTDUMP);
> +	vma->vm_ops = &vfio_cxl_mmap_ops;
> +
> +	return 0;
> +}
> +
> +static ssize_t vfio_cxl_region_rw(struct vfio_pci_core_device *core_dev,
> +				  char __user *buf, size_t count, loff_t *ppos,
> +				  bool iswrite)
> +{
> +	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
> +	struct vfio_cxl_region *cxl_region = core_dev->region[i].data;
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +
> +	if (!count)
> +		return 0;
> +
> +	return vfio_pci_core_do_io_rw(core_dev, false,
> +				      cxl_region->vaddr,
> +				      (char __user *)buf, pos, count,
> +				      0, 0, iswrite);
> +}
> +
> +static void vfio_cxl_region_release(struct vfio_pci_core_device *vdev,
> +				    struct vfio_pci_region *region)
> +{
> +}
> +
> +static const struct vfio_pci_regops vfio_cxl_regops = {
> +	.rw		= vfio_cxl_region_rw,
> +	.mmap		= vfio_cxl_region_mmap,
> +	.release	= vfio_cxl_region_release,
> +};
> +
>  int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
>  {
>  	struct vfio_cxl *cxl = &core_dev->cxl;
>  	struct pci_dev *pdev = core_dev->pdev;
> +	u32 flags;
>  	u16 dvsec;
>  	int ret;
>  
> @@ -182,8 +307,21 @@ int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
>  	if (ret)
>  		goto err_enable_cxl_device;
>  
> +	flags = VFIO_REGION_INFO_FLAG_READ |
> +		VFIO_REGION_INFO_FLAG_WRITE |
> +		VFIO_REGION_INFO_FLAG_MMAP;
> +
> +	ret = vfio_pci_core_register_dev_region(core_dev,
> +		PCI_VENDOR_ID_CXL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
> +		VFIO_REGION_SUBTYPE_CXL, &vfio_cxl_regops,
> +		cxl->region.size, flags, &cxl->region);
> +	if (ret)
> +		goto err_register_cxl_region;
> +
>  	return 0;
>  
> +err_register_cxl_region:
> +	disable_cxl(core_dev);
>  err_enable_cxl_device:
>  	vfio_pci_core_disable(core_dev);
>  	return ret;
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 97422aafaa7b..98f3ac2d305c 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -412,6 +412,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
>  	return pdev->current_state < PCI_D3hot &&
>  	       (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY));
>  }
> +EXPORT_SYMBOL(__vfio_pci_memory_enabled);

_GPL

There should also be a lockdep assert added if this is exported.  With
that it could also drop the underscore prefix.

>  
>  /*
>   * Restore the *real* BARs after we detect a FLR or backdoor reset.
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 7762d4a3e825..6523d9d1bffe 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -54,6 +54,7 @@ struct vfio_pci_region {
>  struct vfio_cxl_region {
>  	u64 size;
>  	u64 addr;
> +	void *vaddr;
>  	struct cxl_region *region;
>  };
>  
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 2b68e6cdf190..71f766c29060 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -372,6 +372,9 @@ struct vfio_region_info_cap_type {
>  /* sub-types for VFIO_REGION_TYPE_GFX */
>  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
>  
> +/* sub-types for VFIO CXL region */
> +#define VFIO_REGION_SUBTYPE_CXL                 (1)

This is a PCI vendor sub-type with vendor ID 0x1e98.  The comment
should reflect that.  Thanks,

Alex

> +
>  /**
>   * struct vfio_region_gfx_edid - EDID region layout.
>   *


