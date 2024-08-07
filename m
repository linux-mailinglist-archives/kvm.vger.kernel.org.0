Return-Path: <kvm+bounces-23573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3474394AF30
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 19:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 547F81C212A9
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C078513DDC0;
	Wed,  7 Aug 2024 17:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WuHwfqsL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6C278B60
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 17:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723053186; cv=none; b=UlVgDJxksa7x6nmhrMsdGfgBGGInHNkWbDezgpe1A9Gmh5Ea2Y3iiZSN5KMb+TVibNG0ffdLIBsZUSXUTi5O8WdJi5z3U2AmIZ8k8bkc3c2rVcQ0csZf8JBfOTDUy8bXEU66veNWXOxKeMuK3W7b+b6luJxAGWmfncCCJjp+fuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723053186; c=relaxed/simple;
	bh=t5wbH7clFvn0JIYCLCBxSG6G44woONTv4AuVyV8vFR4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqm+WcHhLH5tPb4qEv1MfxfXbbHMLmr3UOpYVmZbk4S2FTrMw8GdxDkPZeSt+w3jFdXb/FNVFyPZ9O7fXwEe/PCCDAYoM7M7sfpuV26uqQ1Abi45CziqiOkmPn9p2oht4cCOPMSVPETxoCL72okfBbB7HnGwZlkKrprMJiuIUx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WuHwfqsL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723053183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5OTU43BXems8BWwJog+i+i1DtbtsaJJ3jepqCq69baI=;
	b=WuHwfqsLxeyTl1FYpaLUlRyFO+UqHS8oNwLrmijfcyAb42iO7ZcDFn12qTlGLt9KaLCSCL
	/J33ceGJtc69lqt6Lgayn5GtS0FXVFoELJznV+aaRsRYFeCGmEmISEfR2aIsj11Hx6qq44
	srsUVAyuNEY+zojxJ0M+tDT/ccRv7zY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-eRuRK63KOBquVSFukgQe7A-1; Wed, 07 Aug 2024 13:53:02 -0400
X-MC-Unique: eRuRK63KOBquVSFukgQe7A-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-39b3d3c0dbfso1654855ab.1
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 10:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723053181; x=1723657981;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5OTU43BXems8BWwJog+i+i1DtbtsaJJ3jepqCq69baI=;
        b=Vd0iP6zGTj6YNdvUTAWb+ItoUnber92/Afvd+3uuDdCeodQ7WVZtS7V+QEftUOfP+6
         i1b7+A1FOwMYs1rdJWx1L4d3cB1wPi1b+PZjbYo4Wgp8ZRiUZXwxX2Szv9B+qNB2doaH
         lR92vTNpJoWdx0OKFuqcRgioCyjIHC0zAFCEZ4pjuVJ9T+bWanYJIkxh2eqmhZ72PXTi
         QRPglKJmeamgyKtj5YCzD5PHw7vIvw8/FOaBJodatmHYwuCH65xPl1sGTMsxdgtQ1ZPM
         DYjL2QmsvZHuh2hbeMKbp3QYXpeSWuYPasVMC/aX2V/Ams+pvKgEkttqwzzQzjJvkcR4
         5cuw==
X-Forwarded-Encrypted: i=1; AJvYcCWjBTfmG/8Xpp5yzteJhs/91ff3sOCS2Klg2rJNzzSec7/8HM5vHxlCJOUQ4b3d3dyY+YGwqhh10Gh1w4+SLhw6sfL4
X-Gm-Message-State: AOJu0Yz1CfLRgOweJ8pa/kmmCq8qRWAHAHLQeGYkiXKgX2+dt0eTlSP6
	Si099kvjxkpJ2zOykQHsfJG8gJgQZIn1Em5+m5ja1Ef5smvMEBClFEKOK0C1Meyr5lxhT6vCx9/
	9JzQ2UfVecxRVHuq23crbe3Oyzp9wSImiQ1dDcUBsGrY8C2zCsQ==
X-Received: by 2002:a92:d591:0:b0:39a:1d8d:fc9d with SMTP id e9e14a558f8ab-39b1fc2c25bmr204811585ab.22.1723053181254;
        Wed, 07 Aug 2024 10:53:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIWUkWSt8Mu7A05GM84emJ9GlYiu9iaBP7+3m58n7dLXedikXoz/vMsyWspToWqOki8Dz7Vg==
X-Received: by 2002:a92:d591:0:b0:39a:1d8d:fc9d with SMTP id e9e14a558f8ab-39b1fc2c25bmr204811385ab.22.1723053180771;
        Wed, 07 Aug 2024 10:53:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39b20aaaff3sm46514795ab.27.2024.08.07.10.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 10:53:00 -0700 (PDT)
Date: Wed, 7 Aug 2024 11:52:59 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Lorenzo
 Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Eric
 Auger <eric.auger@redhat.com>, Jean-Philippe Brucker
 <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, Michael Shavit
 <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
 patches@lists.linux.dev, Shameerali Kolothum Thodi
 <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 1/8] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Message-ID: <20240807115259.5b286a8d.alex.williamson@redhat.com>
In-Reply-To: <1-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
	<1-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 Aug 2024 20:41:14 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This control causes the ARM SMMU drivers to choose a stage 2
> implementation for the IO pagetable (vs the stage 1 usual default),
> however this choice has no significant visible impact to the VFIO
> user. Further qemu never implemented this and no other userspace user is
> known.
> 
> The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
> new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
> SMMU translation services to the guest operating system" however the rest
> of the API to set the guest table pointer for the stage 1 and manage
> invalidation was never completed, or at least never upstreamed, rendering
> this part useless dead code.
> 
> Upstream has now settled on iommufd as the uAPI for controlling nested
> translation. Choosing the stage 2 implementation should be done by through
> the IOMMU_HWPT_ALLOC_NEST_PARENT flag during domain allocation.
> 
> Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
> enable_nesting iommu_domain_op.
> 
> Just in-case there is some userspace using this continue to treat
> requesting it as a NOP, but do not advertise support any more.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ----------------
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       | 16 ----------------
>  drivers/iommu/iommu.c                       | 10 ----------
>  drivers/iommu/iommufd/vfio_compat.c         |  7 +------
>  drivers/vfio/vfio_iommu_type1.c             | 12 +-----------
>  include/linux/iommu.h                       |  3 ---
>  include/uapi/linux/vfio.h                   |  2 +-
>  7 files changed, 3 insertions(+), 63 deletions(-)

I think we should also wait for Eric's ack on this when he's back in
the office, but

Acked-by: Alex Williamson <alex.williamson@redhat.com>

> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index e5db5325f7eaed..531125f231b662 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3331,21 +3331,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>  	return group;
>  }
>  
> -static int arm_smmu_enable_nesting(struct iommu_domain *domain)
> -{
> -	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> -	int ret = 0;
> -
> -	mutex_lock(&smmu_domain->init_mutex);
> -	if (smmu_domain->smmu)
> -		ret = -EPERM;
> -	else
> -		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
> -	mutex_unlock(&smmu_domain->init_mutex);
> -
> -	return ret;
> -}
> -
>  static int arm_smmu_of_xlate(struct device *dev,
>  			     const struct of_phandle_args *args)
>  {
> @@ -3467,7 +3452,6 @@ static struct iommu_ops arm_smmu_ops = {
>  		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
>  		.iotlb_sync		= arm_smmu_iotlb_sync,
>  		.iova_to_phys		= arm_smmu_iova_to_phys,
> -		.enable_nesting		= arm_smmu_enable_nesting,
>  		.free			= arm_smmu_domain_free_paging,
>  	}
>  };
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> index 723273440c2118..38dad1fd53b80a 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> @@ -1558,21 +1558,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>  	return group;
>  }
>  
> -static int arm_smmu_enable_nesting(struct iommu_domain *domain)
> -{
> -	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> -	int ret = 0;
> -
> -	mutex_lock(&smmu_domain->init_mutex);
> -	if (smmu_domain->smmu)
> -		ret = -EPERM;
> -	else
> -		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
> -	mutex_unlock(&smmu_domain->init_mutex);
> -
> -	return ret;
> -}
> -
>  static int arm_smmu_set_pgtable_quirks(struct iommu_domain *domain,
>  		unsigned long quirks)
>  {
> @@ -1656,7 +1641,6 @@ static struct iommu_ops arm_smmu_ops = {
>  		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
>  		.iotlb_sync		= arm_smmu_iotlb_sync,
>  		.iova_to_phys		= arm_smmu_iova_to_phys,
> -		.enable_nesting		= arm_smmu_enable_nesting,
>  		.set_pgtable_quirks	= arm_smmu_set_pgtable_quirks,
>  		.free			= arm_smmu_domain_free,
>  	}
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index ed6c5cb60c5aee..9da63d57a53cd7 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2723,16 +2723,6 @@ static int __init iommu_init(void)
>  }
>  core_initcall(iommu_init);
>  
> -int iommu_enable_nesting(struct iommu_domain *domain)
> -{
> -	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
> -		return -EINVAL;
> -	if (!domain->ops->enable_nesting)
> -		return -EINVAL;
> -	return domain->ops->enable_nesting(domain);
> -}
> -EXPORT_SYMBOL_GPL(iommu_enable_nesting);
> -
>  int iommu_set_pgtable_quirks(struct iommu_domain *domain,
>  		unsigned long quirk)
>  {
> diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
> index a3ad5f0b6c59dd..514aacd6400949 100644
> --- a/drivers/iommu/iommufd/vfio_compat.c
> +++ b/drivers/iommu/iommufd/vfio_compat.c
> @@ -291,12 +291,7 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
>  	case VFIO_DMA_CC_IOMMU:
>  		return iommufd_vfio_cc_iommu(ictx);
>  
> -	/*
> -	 * This is obsolete, and to be removed from VFIO. It was an incomplete
> -	 * idea that got merged.
> -	 * https://lore.kernel.org/kvm/0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com/
> -	 */
> -	case VFIO_TYPE1_NESTING_IOMMU:
> +	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
>  		return 0;
>  
>  	/*
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0960699e75543e..13cf6851cc2718 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -72,7 +72,6 @@ struct vfio_iommu {
>  	uint64_t		pgsize_bitmap;
>  	uint64_t		num_non_pinned_groups;
>  	bool			v2;
> -	bool			nesting;
>  	bool			dirty_page_tracking;
>  	struct list_head	emulated_iommu_groups;
>  };
> @@ -2199,12 +2198,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		goto out_free_domain;
>  	}
>  
> -	if (iommu->nesting) {
> -		ret = iommu_enable_nesting(domain->domain);
> -		if (ret)
> -			goto out_domain;
> -	}
> -
>  	ret = iommu_attach_group(domain->domain, group->iommu_group);
>  	if (ret)
>  		goto out_domain;
> @@ -2545,9 +2538,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	switch (arg) {
>  	case VFIO_TYPE1_IOMMU:
>  		break;
> -	case VFIO_TYPE1_NESTING_IOMMU:
> -		iommu->nesting = true;
> -		fallthrough;
> +	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
>  	case VFIO_TYPE1v2_IOMMU:
>  		iommu->v2 = true;
>  		break;
> @@ -2642,7 +2633,6 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  	switch (arg) {
>  	case VFIO_TYPE1_IOMMU:
>  	case VFIO_TYPE1v2_IOMMU:
> -	case VFIO_TYPE1_NESTING_IOMMU:
>  	case VFIO_UNMAP_ALL:
>  		return 1;
>  	case VFIO_UPDATE_VADDR:
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 4d47f2c3331185..15d7657509f662 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -635,7 +635,6 @@ struct iommu_ops {
>   * @enforce_cache_coherency: Prevent any kind of DMA from bypassing IOMMU_CACHE,
>   *                           including no-snoop TLPs on PCIe or other platform
>   *                           specific mechanisms.
> - * @enable_nesting: Enable nesting
>   * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
>   * @free: Release the domain after use.
>   */
> @@ -663,7 +662,6 @@ struct iommu_domain_ops {
>  				    dma_addr_t iova);
>  
>  	bool (*enforce_cache_coherency)(struct iommu_domain *domain);
> -	int (*enable_nesting)(struct iommu_domain *domain);
>  	int (*set_pgtable_quirks)(struct iommu_domain *domain,
>  				  unsigned long quirks);
>  
> @@ -846,7 +844,6 @@ extern void iommu_group_put(struct iommu_group *group);
>  extern int iommu_group_id(struct iommu_group *group);
>  extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
>  
> -int iommu_enable_nesting(struct iommu_domain *domain);
>  int iommu_set_pgtable_quirks(struct iommu_domain *domain,
>  		unsigned long quirks);
>  
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 2b68e6cdf1902f..c8dbf8219c4fcb 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -35,7 +35,7 @@
>  #define VFIO_EEH			5
>  
>  /* Two-stage IOMMU */
> -#define VFIO_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
> +#define __VFIO_RESERVED_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
>  
>  #define VFIO_SPAPR_TCE_v2_IOMMU		7
>  


