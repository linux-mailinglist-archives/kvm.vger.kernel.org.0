Return-Path: <kvm+bounces-53516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5AFB13128
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 20:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E64C189782D
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 18:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A50224892;
	Sun, 27 Jul 2025 18:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4tp2nzVi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875E32165EC
	for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 18:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753640730; cv=none; b=MXzc8+0Z8zoA2yQilVVi3jJ6CQFS0bZo3885ViwcDVTO+FmNVwAewC7bP+RYKaw4L7GzwJ11O1ZxlVQ/ogZTsv5cOxlijmIqVkMYDdbpXzZV0PmCbC27l3LPxjLlIPeKqZXr+egOtFyaQW3EG1rsRUjoxYGSNzjc/jp8FBG3GrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753640730; c=relaxed/simple;
	bh=R4DKw26tZHbX0X8YO83XwqOCAF3SMRH/p0nbiQAB9Hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uiid+b56MA2sI4/qN3eFpT834M+yslRMzgl2Xc+i15cn45K7o2D/lKDqsi1hyBSO5vL+nbCD0oudI2mzLeZLErW7/zRkSAgbVdY1UFyF3aLBrY4b83w26wGboPIFg4nj/HcVkTjtJkWBwZiGTPYJlaJFul8K6tgly6QHYf8pADc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4tp2nzVi; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4562b2d98bcso42865e9.1
        for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 11:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753640727; x=1754245527; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SMY+YelF4GmutLVvu+ZlwG8U8DxYRHUFkNft15MGlsE=;
        b=4tp2nzVidw4dSU8RcP8r4SGYVrHbn+RWGtiLbLKQ/SqlIhIIVPa8IhNEVCIFyPCq5E
         l9KBDjY8U+Yn6fndbsCn8mzvd7KFtXlCke4XoWV+d8skhvRbPrpaBZNs3dtEblTGlis2
         BAW2hjG4j2LRlZvEvEh34i9UDy7pW0yrXwDvVngKzgIAm5qgDk8HjYreMc/D5YVNmLXD
         TB2OfXPqzlCzZDSu2dfS+66Twh4FCNrlTiMZbutDCbQ/4RhPeMtFrxscxi83bcn3YUws
         bW3bMPtXJGUEch/cu0TEaSfHi8qi1lKTeVr6OjErCsNxplX4cYuqdWv9Gg5LONUNIRyN
         U/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753640727; x=1754245527;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SMY+YelF4GmutLVvu+ZlwG8U8DxYRHUFkNft15MGlsE=;
        b=O1a3XFAOkUDMYkgH2WMrqDKb9+sLEB4wLhCC4GGtGPlZei1wLUr/Zbu9wcegq0ifJ8
         BL7SosKmp8zpGmKaxTRKeZjigEledqdvOd+VsbDtBgO0DJdh0cwoFAoZQnDlbe1znMtG
         pMURls/bEDCJD97psY9dv8950qMCTyEepb2SdcTnOzq4bje2vSsl5aScf5vSiIZHgqls
         diSiptn62ZMPzId3uIQvkDwH+IyefqoI4Zp9vjq/PyGBj13LRw97r+V9esbbYo6Vkcz8
         va+80cuUHWk9UTL7YO71+Mcwn9Q4x6mIgAFljU2v9nZDB8mnZMEHLiqzzwPRsVB0VnDl
         a6RQ==
X-Gm-Message-State: AOJu0YyqdZ02O1GqhxDHMhR8zgCscYev/aycOgupNr7ty6qQNTGLZU5z
	RhdFILaCOsbXVIpNyvnfqPoO1ub0/QdS2y134Hc8iVAwKK3iU9AtLdofkFYTdYOM8zrtuHpuOqp
	EviOAAA==
X-Gm-Gg: ASbGncs6IUgHHasoaBVmt/QtyvQhLVHUnEKxDa0wShCaYp6uVu7MEBwJBRD2Q4sj9su
	NDKppOvHZXSpOHn/Mxoooa2+VM5QagWvGKlt3mDKkKpbi9JvifaXLBC2BdtxacJVtLYfQrtlHSs
	QtNmPQTZfvK1gcBjfAcKyfrTkcvGnIummZV8gN127LMrEXVe5pVnzFzR7+GlOTFpvvew7KPd0pn
	YVWEPl4Kf8o1zZRQxBj3TZyu/aQbvFW0nwOyMTrTWirTB1lNkQmeOZcL4kBYkkrmEJd8+tb0cSQ
	ffBY0djj39ZaWWtDIExJW9qe/U6NWwv2HYboy193dgXeL2/v8bmXEui/FgtJrRkrcrnwbmkUzmr
	vmCpej2JRrPfP6N8Jfd0ekhtxTVqw9uCnoXWJAUB0pu+seciJmjHVt4A4ug==
X-Google-Smtp-Source: AGHT+IF1g2gWJBOimuWRUqK6D3Z75LOw3hRP5oLMdPhQ1F+iZMnYw97VEFhaG99JQehvnK2vAt3d3g==
X-Received: by 2002:a05:600c:1389:b0:450:ceac:62cf with SMTP id 5b1f17b1804b1-4587c9987bbmr2277865e9.5.1753640726533;
        Sun, 27 Jul 2025 11:25:26 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4f40sm125876885e9.27.2025.07.27.11.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 11:25:26 -0700 (PDT)
Date: Sun, 27 Jul 2025 18:25:22 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 05/10] vfio: Add dma map/unmap handlers
Message-ID: <aIZvElv03XftC2gw@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-5-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250525074917.150332-5-aneesh.kumar@kernel.org>

On Sun, May 25, 2025 at 01:19:11PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  include/kvm/vfio.h | 4 ++--
>  vfio/core.c        | 7 +++++--
>  vfio/legacy.c      | 7 +++++--
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
> index 67a528f18d33..fed692b0f265 100644
> --- a/include/kvm/vfio.h
> +++ b/include/kvm/vfio.h
> @@ -126,8 +126,8 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region);
>  int vfio_pci_setup_device(struct kvm *kvm, struct vfio_device *device);
>  void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev);
>  
> -int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size);
> -int vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size);
> +extern int (*dma_map_mem_range)(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size);
> +extern int (*dma_unmap_mem_range)(struct kvm *kvm, __u64 iova, __u64 size);
>  
>  struct kvm_mem_bank;
>  int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data);
> diff --git a/vfio/core.c b/vfio/core.c
> index 2af30df3b2b9..32a8e0fe67c0 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -10,6 +10,9 @@ int kvm_vfio_device;
>  LIST_HEAD(vfio_groups);
>  struct vfio_device *vfio_devices;
>  
> +int (*dma_map_mem_range)(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size);
> +int (*dma_unmap_mem_range)(struct kvm *kvm, __u64 iova, __u64 size);

I think it's better to  wrap those in an ops struct, this can be set once and
in the next patches this can be used for init/exit instead of having such checks:
“if (kvm->cfg.iommufd || kvm->cfg.iommufd_vdevice)”

Thanks,
Mostafa

> +
>  static int vfio_device_pci_parser(const struct option *opt, char *arg,
>  				  struct vfio_device_params *dev)
>  {
> @@ -281,12 +284,12 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
>  
>  int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
>  {
> -	return vfio_map_mem_range(kvm, (u64)bank->host_addr, bank->guest_phys_addr, bank->size);
> +	return dma_map_mem_range(kvm, (u64)bank->host_addr, bank->guest_phys_addr, bank->size);
>  }
>  
>  int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void *data)
>  {
> -	return vfio_unmap_mem_range(kvm, bank->guest_phys_addr, bank->size);
> +	return dma_unmap_mem_range(kvm, bank->guest_phys_addr, bank->size);
>  }
>  
>  int vfio_configure_reserved_regions(struct kvm *kvm, struct vfio_group *group)
> diff --git a/vfio/legacy.c b/vfio/legacy.c
> index 92d6d0bd5c80..5b35d6ebff69 100644
> --- a/vfio/legacy.c
> +++ b/vfio/legacy.c
> @@ -89,7 +89,7 @@ static int vfio_get_iommu_type(void)
>  	return -ENODEV;
>  }
>  
> -int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size)
> +static int legacy_vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size)
>  {
>  	int ret = 0;
>  	struct vfio_iommu_type1_dma_map dma_map = {
> @@ -110,7 +110,7 @@ int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __u64 size)
>  	return ret;
>  }
>  
> -int vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size)
> +static int legacy_vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size)
>  {
>  	struct vfio_iommu_type1_dma_unmap dma_unmap = {
>  		.argsz = sizeof(dma_unmap),
> @@ -325,6 +325,9 @@ int legacy_vfio__init(struct kvm *kvm)
>  {
>  	int ret;
>  
> +	dma_map_mem_range = legacy_vfio_map_mem_range;
> +	dma_unmap_mem_range = legacy_vfio_unmap_mem_range;
> +
>  	ret = legacy_vfio_container_init(kvm);
>  	if (ret)
>  		return ret;
> -- 
> 2.43.0
> 

