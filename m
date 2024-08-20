Return-Path: <kvm+bounces-24584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83CE09580DA
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFDBB1C239DA
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 08:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D50918A6C5;
	Tue, 20 Aug 2024 08:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lQUdVOxV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB09286AFA
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 08:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142225; cv=none; b=Na6faVVyQ5pZmR6nQiUqfkRr3dOabubLY53L8c4EIRmN6vaVHBsJHOprFwbO0AjoviYyPM9A7Y/Ax3mqW1G42Vk43VYGF4KozKIP7UG5bdeyJTWv+bEFhiGFKappTS/ozLwGOlB31qdoBQ+jHmX1Uz29NFrQKYOxRRaDI582FpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142225; c=relaxed/simple;
	bh=FPPHCemr0uCUKSLHjdH88rKTw4GJg240+VSGlRjeztA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bgW8ig3gqyAbSEpECaOlpZg9MuVcNHuA3XaNRewbvnJK5COVdH3EvWNb6TdXp4HM7MT/kTWroLek/0IoZUWoJam8kfKURAlEXoZj/NCbXTYcenZcOWlAiMoImRPx/HkH0OWEF8VfGSNJebnUbaME2FdwsZAH+Le+p8SY/U/SH7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lQUdVOxV; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5bec507f4ddso5739a12.0
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 01:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724142221; x=1724747021; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7yYZms4nWMftjc2pVrYEdJNFCZkagzW9V2Bs0FQm0o0=;
        b=lQUdVOxVWweB1mGg/6OYiIt+XQebf4pi4jTRCQZGNdg8qd3xzeRfP+xBQH2XV7HJLN
         o2t5lBDEMOltQNOuzEHHKcBiqgJt59AGTVjz7aHcTInfbB89ZpVIRGyrUncTTLb63kl2
         o0Ap/kglYuy4NgFHlAHx7AdxQe3OQO0DzS7ds858bso//rv6BggW8knY2N7hAS/iUveT
         uLkqY5gpYYmOuDGiJ6fyqmyUTRQ4ei7rJuoPJYzmhaLhcTtiquYfqzvczAmXPMt+ZL3s
         ghK/8Xx02D6x7BD60Mdr6p1HsIpXBNxtufAKbrmM+vBR4NlJh93mfiGQb21871tPZjjl
         lu9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724142221; x=1724747021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7yYZms4nWMftjc2pVrYEdJNFCZkagzW9V2Bs0FQm0o0=;
        b=h3+GD2ijqkXmevKtnOnKNFcplgQavYUKTkXFIg9p9DVc5yawvACfNkcU8vNeJpBHct
         8ry4sq9T5AVlF+8Kr7uX974A0CcwNRxdNlbs045JvGuDN3QkfvkVAsvbME7w8RSjyQth
         aVwQ0O5wXNleU7ovgNqKUom4rq3ZiUZsCm3yr7Z14RiewBo3U07rcfKuSIG+J0cPb4Yx
         6+RBT+x5BKu8cpOMzo9R+D3Sc6Tc4oJ1zhmYBDpsyTEYzy78YAGxWoIeHvJy+VlNKdks
         kjUNbRPJvg/XyxbbLG8eJjtMJmwUCI72Pgmu2eZ/LTp8B1bOLWukxtfKqczpws3hY90M
         XpBw==
X-Forwarded-Encrypted: i=1; AJvYcCVfsG/JoCwLGspmtE55dnIA9JgFz5gSrZ6vicvLGxZi4zpqrPBxRufZbz671U/EdudIGb0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRqvnJbzX1oQupjA/yYkQeCh/YDZ5GiR0PgZoZ0LthjKHLMsh4
	HcrxU4i+GToaisQvQuipt1NDocHMPHejTjggsjAoldMnlPKtcdvSZxWoAJhocw==
X-Google-Smtp-Source: AGHT+IH+M+BUx+hTERAp4I+MQSYeLfG9vweVXeC0ahwt6XpthChPmh+nBlyadH02xTIypPgNh7wLHw==
X-Received: by 2002:a05:6402:27d2:b0:57d:32ff:73ef with SMTP id 4fb4d7f45d1cf-5bf0c26364cmr68223a12.6.1724142220462;
        Tue, 20 Aug 2024 01:23:40 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded36051sm187002145e9.24.2024.08.20.01.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 01:23:40 -0700 (PDT)
Date: Tue, 20 Aug 2024 08:23:35 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 1/8] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Message-ID: <ZsRSh-Kgfzevv8jv@google.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <1-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>

Hi Jason,

On Tue, Aug 06, 2024 at 08:41:14PM -0300, Jason Gunthorpe wrote:
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
Reviewed-by: Mostafa Saleh <smostafa@google.com>

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ----------------
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       | 16 ----------------
>  drivers/iommu/iommu.c                       | 10 ----------
>  drivers/iommu/iommufd/vfio_compat.c         |  7 +------
>  drivers/vfio/vfio_iommu_type1.c             | 12 +-----------
>  include/linux/iommu.h                       |  3 ---
>  include/uapi/linux/vfio.h                   |  2 +-
>  7 files changed, 3 insertions(+), 63 deletions(-)
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
> -- 
> 2.46.0
> 

