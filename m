Return-Path: <kvm+bounces-19334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E243903FE8
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 17:24:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E17AEB2579B
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52C123767;
	Tue, 11 Jun 2024 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EHWIUIPn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B66D2868D
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 15:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718119420; cv=none; b=F3+TF1YjNZgg/kvEnGaFI+aELOqUz47rg0qTqwWFD37+s0Qeh4zQliLnDNQg89qZv+ytbdT5efzGF62VHrhk0LpmT92AFtUbLaFLsW8Km7qA7X6NUOCGdzs7kCjttEfhQ7qeH5EZ0I0WZaNawbhgSmx2ZxUDgGZVGk8LX7Z6f6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718119420; c=relaxed/simple;
	bh=CLqayj/eoP55ht9EHGxDvGtiEOGO5GEyYgOJG3OyT64=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bRwe8nqum/pJyXOzJd1pbRuqMFMnwARkiKNCPkXbwFGEYOO0q2jyPLasRQukU5dfNvYkImxHYm7tutCoaki9K6Ih+rDYbsfbeAs7CPwZE5slEsEUYN810ulQEpir7cPWUsU2F6xKdEB7iwCXGaD9e9kRIrVxHZg2wQEvr0fEddA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EHWIUIPn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718119418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/rPwA5aUtzeOBHVbOLrnc2+mNR/AAUcToDFcJjdNUBQ=;
	b=EHWIUIPnwLs63+r9iUQmTX0poW0fndbgEXH9ksc3zqvnmKbsWGlp3/VteLQKNTku8f/cE9
	oxywD3g+vUmOBIrAG5w0QIpiCPi97RdsSXB6GwINb8MphXc82a5niWHLzZA+OtdLXML5Cn
	J2UFTJKEIrZup77mnhNOvLOo1vIp1fI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-1pUpYEd2ODCE8YSFM7dY7Q-1; Tue, 11 Jun 2024 11:23:37 -0400
X-MC-Unique: 1pUpYEd2ODCE8YSFM7dY7Q-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7eb50e42c6aso628151839f.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 08:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718119416; x=1718724216;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/rPwA5aUtzeOBHVbOLrnc2+mNR/AAUcToDFcJjdNUBQ=;
        b=OBO5iv7SWw2I9aiEUdRwMGODB4TgLmEHISES9iurV/RsrXwxDnbVMM+YecB1ccDRd8
         iDc90l0YXJuQY3quJGxa9rOPx92OO23Y+iAxiqH+3+f3qtqZcWF9l3s3o0CExcYCDxEn
         /A8rZazTLPm0TSHn+b4diMFfawcAebhUwpEhlVeM9ZN1O3if9YnBgK3w2kLCEZwpBjLR
         /0PfY5kiSJpAATPiqeMkR/z9/wMgYewzqo3zYCtnA09a7qweDHV0EYIdF8rNVLQLUTIQ
         TLh0SYeQbWlx4tR5fuNI5YORRKADnlnFzZJNmhTkRkwi3Zs4NTwABIvWvQhvQ3Hzthcw
         HPxw==
X-Gm-Message-State: AOJu0YzmlbryrYbp7lJPS1YwdoxR180qjB71qx/5tfj6J/YU3TBQn2LS
	DSUIoJ9gdPERkfmX3aEOdashZ3weZ6FLuiihU3jcetOVqtbRSgaFDFQvUnH/iDtcJlLgPzouIJT
	1o3Vsv8ibawRM1A0IbwLC+2SLvV2kWZBT0KZVBxNmXHLEiPsTlOCXDzW2DJdJgO0CdfKTU/cTa8
	uI2ff08s9LqNYjzYXWhiK2WFAl3GM76Tw2qI6HP766BrA=
X-Received: by 2002:a05:6602:3fd1:b0:7eb:7bc9:7fc7 with SMTP id ca18e2360f4ac-7eb7bc98248mr841158139f.14.1718119415921;
        Tue, 11 Jun 2024 08:23:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGA12wKH+v+OUoBx2hrv3993oYUfPx6zM9SWmPIIcpHt/wXBT8bwzCM/mOywERWrMbfvG2rjQ==
X-Received: by 2002:a05:6602:3fd1:b0:7eb:7bc9:7fc7 with SMTP id ca18e2360f4ac-7eb7bc98248mr841153739f.14.1718119415338;
        Tue, 11 Jun 2024 08:23:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7eb7c6c4994sm150917839f.19.2024.06.11.08.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 08:23:34 -0700 (PDT)
Date: Tue, 11 Jun 2024 09:23:33 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: kvm@vger.kernel.org
Cc: ajones@ventanamicro.com, yan.y.zhao@intel.com, kevin.tian@intel.com,
 jgg@nvidia.com, peterx@redhat.com
Subject: Re: [PATCH] vfio/pci: Insert full vma on mmap'd MMIO fault
Message-ID: <20240611092333.6bb17d60.alex.williamson@redhat.com>
In-Reply-To: <20240607035213.2054226-1-alex.williamson@redhat.com>
References: <20240607035213.2054226-1-alex.williamson@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Any support for this or should we just go with the v2 series[1] by
itself for v6.10?  Thanks,

Alex

[1]https://lore.kernel.org/all/20240530045236.1005864-1-alex.williamson@redhat.com/

On Thu,  6 Jun 2024 21:52:07 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> In order to improve performance of typical scenarios we can try to insert
> the entire vma on fault.  This accelerates typical cases, such as when
> the MMIO region is DMA mapped by QEMU.  The vfio_iommu_type1 driver will
> fault in the entire DMA mapped range through fixup_user_fault().
> 
> In synthetic testing, this improves the time required to walk a PCI BAR
> mapping from userspace by roughly 1/3rd.
> 
> This is likely an interim solution until vmf_insert_pfn_{pmd,pud}() gain
> support for pfnmaps.
> 
> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> Link: https://lore.kernel.org/all/Zl6XdUkt%2FzMMGOLF@yzhao56-desk.sh.intel.com/
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> I'm sending this as a follow-on patch to the v2 series[1] because this
> is largely a performance optimization, and one that we may want to
> revert when we can introduce huge_fault support.  In the meantime, I
> can't argue with the 1/3rd performance improvement this provides to
> reduce the overall impact of the series below.  Without objection I'd
> therefore target this for v6.10 as well.  Thanks,
> 
> Alex
> 
> [1]https://lore.kernel.org/all/20240530045236.1005864-1-alex.williamson@redhat.com/
> 
>  drivers/vfio/pci/vfio_pci_core.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index db31c27bf78b..987c7921affa 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1662,6 +1662,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct vfio_pci_core_device *vdev = vma->vm_private_data;
>  	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
> +	unsigned long addr = vma->vm_start;
>  	vm_fault_t ret = VM_FAULT_SIGBUS;
>  
>  	pfn = vma_to_pfn(vma);
> @@ -1669,11 +1670,25 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  	down_read(&vdev->memory_lock);
>  
>  	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
> -		goto out_disabled;
> +		goto out_unlock;
>  
>  	ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
> +	if (ret & VM_FAULT_ERROR)
> +		goto out_unlock;
>  
> -out_disabled:
> +	/*
> +	 * Pre-fault the remainder of the vma, abort further insertions and
> +	 * supress error if fault is encountered during pre-fault.
> +	 */
> +	for (; addr < vma->vm_end; addr += PAGE_SIZE, pfn++) {
> +		if (addr == vmf->address)
> +			continue;
> +
> +		if (vmf_insert_pfn(vma, addr, pfn) & VM_FAULT_ERROR)
> +			break;
> +	}
> +
> +out_unlock:
>  	up_read(&vdev->memory_lock);
>  
>  	return ret;


