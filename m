Return-Path: <kvm+bounces-38507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB4EA3ABFE
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 23:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BDE0171101
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4417F1D6DB1;
	Tue, 18 Feb 2025 22:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wy4SffLT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42D72862B7
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 22:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739918874; cv=none; b=FdTnoqV4HHtZeObz5Vvp5m7Jd1rtBWwmAvaEat4kHfXfN8zXbpsQ3AqbU/ZrCQD7wSVCMIVD0oV1ndTrzi8PeBiSPilPYKb3exFVqYT4UEmKK7Dg/NDq2UsaZCKS55ZvTlQmv7GpAq7/0hd1968RsqzzQpeBQYjXpG3bQFqfOWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739918874; c=relaxed/simple;
	bh=h24HuYwNLSnt3tdVXGlp3ZLTwLBuyPAwn3ahyR1sqRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LYNUglSZ5bEvmrTC+ltk930V3xGDdqVeVNbQikY/MDPWTCg6pssMxIC4LF9mqVvDZqaodaCDYCKcf9SPQJlZkeqx+yPX4AIL0iooSTmL6ubpPrK+G7kBwNwJsjceZi+E7CWWT2uguZE5VDdpe5P3AUBN7EDrzz9Y51TbGZ3oE20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wy4SffLT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739918872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nh9W0RmqBnUONSTMPcR74JdQUkTIr6YF89vCK3+sVCc=;
	b=Wy4SffLTy7Cf/P74fbrPiLvfaaWsnl3P2dLfbahs/hhXbJVcNz99CFm6Xv3S4qE0oZOz5l
	tnx+Li3yR56iEKHdG9KSVn/wD3ToVXixjr8cu+pVwkN3PlRjfhOsIk/4c7pUZz5PMMNvUJ
	i4YDGTKiLGbwLiwCBLVREy4fdmRGVes=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-AnyS4ZvOPsmh5g36kgBHbw-1; Tue, 18 Feb 2025 17:47:50 -0500
X-MC-Unique: AnyS4ZvOPsmh5g36kgBHbw-1
X-Mimecast-MFC-AGG-ID: AnyS4ZvOPsmh5g36kgBHbw_1739918870
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c0b0cf53f3so126743085a.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 14:47:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739918870; x=1740523670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nh9W0RmqBnUONSTMPcR74JdQUkTIr6YF89vCK3+sVCc=;
        b=EM9um9+M1X64SkmB8yq4dc73ElKh5IvpPKJGCHDRPJstxglkX1oAHAbK6FMA0ySmnr
         1t7F2Evqcus92/J5NqC8o6QN5q7vPK3pUpF1kNWH3/DLxGSjiDCZ9vrVCjpawOu2sZjn
         id641VLS+4d0eygBiHJYRs8HHPtW/yRQIp5xHwLHDQiM7TKteXL+YA6wDDWFDqzc0jlj
         ZXxSEOm27OsaDgSmQp3VivmKetmeYRXi5vGDgIa0VFlCCbXlZO+YJ5xEQbplatYWa7U6
         VRbY7fCPvf5hAI0EgYp+ZqFPC0N1rHn0Kud1wxw4npIZWQdp4DqYk7oRmNdceQqezJdI
         0gTQ==
X-Gm-Message-State: AOJu0Yw1LleGEeal4ckbR4xw/TYpZym7EW47V7kJM0hBby3x6W58IQew
	RXmKVO+Hk4XZXICjlWKIdLffLgSDj19jrmVbWvF/olRyhGP+t65hXd+U8/Y6m08gLUtHHRJ60Br
	mmajJhwyCnu8tLMWtem/63vhdvIr1FrVQyNyQ09R00rdKvUG4vg==
X-Gm-Gg: ASbGncvIhp6EEMNv50GsTVMf5lBnQQexgEXjTGsUpK284frsuqWqMmensTG6xBmKbGs
	YZ+KYR2zhxGJ0dGvd2440VtuojdlOeLEOuL/zmUkuiL0W5rtZGpXY4qtg2B7O73JjYx1hMs6H98
	xguTKgpPDLxnikIe9BSAV8yzJKibVJnBIa7OxO3mlQd4A9eip8g+uGJoUAYi6hCSnvOiUUo6IF/
	+/ZkmaGVLr4I7o3KdiFInZEtc0HRkJ20vo4T2DVvOCpdhoIpfMkTKh2QUw=
X-Received: by 2002:a05:620a:4506:b0:7c0:602c:e689 with SMTP id af79cd13be357-7c08a99c55cmr1632597485a.16.1739918869955;
        Tue, 18 Feb 2025 14:47:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGw3KGF4/VClTCVZ8SCaSR6gJ/c+MMRvvSXFAJ8E8v3FwIBWyA1S7XmW3ZiNnzr4iowAvPviw==
X-Received: by 2002:a05:620a:4506:b0:7c0:602c:e689 with SMTP id af79cd13be357-7c08a99c55cmr1632595385a.16.1739918869659;
        Tue, 18 Feb 2025 14:47:49 -0800 (PST)
Received: from x1.local ([2604:7a40:2041:2b00::1000])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c0a3dcda55sm229402985a.58.2025.02.18.14.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 14:47:48 -0800 (PST)
Date: Tue, 18 Feb 2025 17:47:46 -0500
From: Peter Xu <peterx@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	mitchell.augustin@canonical.com, clg@redhat.com, jgg@nvidia.com,
	willy@infradead.org
Subject: Re: [PATCH v2 6/6] vfio/type1: Use mapping page mask for pfnmaps
Message-ID: <Z7UOEpgH5pdTBcJP@x1.local>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
 <20250218222209.1382449-7-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250218222209.1382449-7-alex.williamson@redhat.com>

On Tue, Feb 18, 2025 at 03:22:06PM -0700, Alex Williamson wrote:
> vfio-pci supports huge_fault for PCI MMIO BARs and will insert pud and
> pmd mappings for well aligned mappings.  follow_pfnmap_start() walks the
> page table and therefore knows the page mask of the level where the
> address is found and returns this through follow_pfnmap_args.pgmask.
> Subsequent pfns from this address until the end of the mapping page are
> necessarily consecutive.  Use this information to retrieve a range of
> pfnmap pfns in a single pass.
> 
> With optimal mappings and alignment on systems with 1GB pud and 4KB
> page size, this reduces iterations for DMA mapping PCI BARs by a
> factor of 256K.  In real world testing, the overhead of iterating
> pfns for a VM DMA mapping a 32GB PCI BAR is reduced from ~1s to
> sub-millisecond overhead.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ce661f03f139..0ac56072af9f 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -520,7 +520,7 @@ static void vfio_batch_fini(struct vfio_batch *batch)
>  
>  static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
>  			    unsigned long vaddr, unsigned long *pfn,
> -			    bool write_fault)
> +			    unsigned long *addr_mask, bool write_fault)
>  {
>  	struct follow_pfnmap_args args = { .vma = vma, .address = vaddr };
>  	int ret;
> @@ -544,10 +544,12 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
>  			return ret;
>  	}
>  
> -	if (write_fault && !args.writable)
> +	if (write_fault && !args.writable) {
>  		ret = -EFAULT;
> -	else
> +	} else {
>  		*pfn = args.pfn;
> +		*addr_mask = args.addr_mask;
> +	}
>  
>  	follow_pfnmap_end(&args);
>  	return ret;
> @@ -590,15 +592,22 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>  	vma = vma_lookup(mm, vaddr);
>  
>  	if (vma && vma->vm_flags & VM_PFNMAP) {
> -		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
> +		unsigned long addr_mask;
> +
> +		ret = follow_fault_pfn(vma, mm, vaddr, pfn, &addr_mask,
> +				       prot & IOMMU_WRITE);
>  		if (ret == -EAGAIN)
>  			goto retry;
>  
>  		if (!ret) {
> -			if (is_invalid_reserved_pfn(*pfn))
> -				ret = 1;
> -			else
> +			if (is_invalid_reserved_pfn(*pfn)) {
> +				unsigned long epfn;
> +
> +				epfn = (*pfn | (~addr_mask >> PAGE_SHIFT)) + 1;
> +				ret = min_t(long, npages, epfn - *pfn);

s/long/unsigned long/?

Reviewed-by: Peter Xu <peterx@redhat.com>

> +			} else {
>  				ret = -EFAULT;
> +			}
>  		}
>  	}
>  done:
> -- 
> 2.48.1
> 

-- 
Peter Xu


