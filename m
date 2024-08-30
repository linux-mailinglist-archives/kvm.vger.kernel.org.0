Return-Path: <kvm+bounces-25535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA63966546
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64DE01C20A3E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D17E41B3B37;
	Fri, 30 Aug 2024 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZKk4kt/Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AF11A7AC6
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725031431; cv=none; b=DNMpQoq5TZ+Xs3tRgjQxK/vfes+826ycvTlpul+ac8yiXLHzn5mi8ih0Wq0Pld9dxkv2hPUTCUOwh/H3aPChfY2oPSYyhalJ01Vut/SSJ/whjKuxI+hJoANSsSRVvcKesYX+p3ZkGDVT2oGmFlVZwwZcc8ewgLQ3+OnSB0PysEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725031431; c=relaxed/simple;
	bh=6vx2gq56ZM4qeqxj6ucMe1zrs+h9CSZFZQVXtBHV2qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iqJLifKuACPhgczkDggH+uGbwPGSkDqBAkUZfEgxKAiRC4pQVnLjnn+yj2OyyGdxTMZcm1/kBSUrQn1/Kt05SYMd+yLdvTZz5rWZa6Ih6zYeNEhf6s7rou1VGCK64SvH3tPnin2PgKwgVimsByCDgEyooYVOsXw3mdkZUWNxvIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZKk4kt/Z; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-429d1a9363aso53045e9.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 08:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725031426; x=1725636226; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WOU46aVnTgnZrtLuHoe3iJX7qiC4mddr2CSB3vbflRc=;
        b=ZKk4kt/ZzxgLF2s2yXQTcCLhQoHFwPu89OEkR/wGpo4k9QklLB3n/vyAi0L7aJ+8Li
         1h9z4nIdNQQuHwk0lAzJtcXoMOX4NssornIgoC7Il+V95dUMJAQqRoWW+DP9ZIlg/buw
         DQcz8tCl7wT70u1ibFLmyBY+Ybioev082cQ7/clkfGCzwcCkwPe/Q6cg3X7/iVBFijq6
         j5ptQYKCfXGr79yEZKbk9///9cpgC+4kAq6CI5AzQO2kIfo17YDiwFkDAJqADuZ363p5
         1NtbMh6UXoTCZuT9aPBufC0Yr3c73kE+VEq66IdzB9d8+FEmL+JdXPrlsLg6SK/XrIUo
         yrdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725031426; x=1725636226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOU46aVnTgnZrtLuHoe3iJX7qiC4mddr2CSB3vbflRc=;
        b=mNL4FxM+uu2gsWXqHtqOt5KwzJ1v/iHjgxLQofqQ2vt+585HcyvWfMqFZJkqMqsP4C
         KGCmrLqxrNTU0OmwlgWH+D5Zv9tsv/GJl3ZiOOt9KMQJESMyNpLC6PpYHqifwzX7Iebn
         769hK25HQsJgDfH7zYroEhwLsr+OR/df9jeTAXNZzh8NaX9FwPv2uJ8GKABon8vpBwTD
         7vmKJbHfarS39obTRPd8e3AQdXxGHMj701ht2KR5H6YY5xYunySMJK/LcEM/dnp4VluA
         XLxfUclOFAfMHX7d+E6L0AsgtCO18CPy+UVfLYutk8c3HvNv+I9NGI7fvqVWfnE8oXKd
         NQkw==
X-Forwarded-Encrypted: i=1; AJvYcCWG+6hVuDrBQiml8rW4lHJ/3VvoYcL2+YVjXIKfpiv9PJQS3JpR9cTQMwpqjx0TwNT0Hvg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG/s3EDDpoJ1k4FKYnzuDdLdpl2Yf2q9F36aEiICJmT2knyUfK
	2dGH1MY+acrdYglFpP5B6YIKxXAirrqeTmmBl3E/bSFtA24lTwQ8qi90w1rtSg==
X-Google-Smtp-Source: AGHT+IHDqRWS3lPGg0daxRyt2QBSUBhTzWgO4oFzGsmOgI5ybD+dtAarfBs2yjdiu5Fpbo6UhaT9Bw==
X-Received: by 2002:a05:600c:384f:b0:426:6edd:61a7 with SMTP id 5b1f17b1804b1-42bbb6a35c2mr1103455e9.7.1725031425900;
        Fri, 30 Aug 2024 08:23:45 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6e27364sm48924815e9.34.2024.08.30.08.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 08:23:45 -0700 (PDT)
Date: Fri, 30 Aug 2024 15:23:41 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <ZtHj_X6Gt91TlUZG@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>

Hi Jason,

On Tue, Aug 27, 2024 at 12:51:36PM -0300, Jason Gunthorpe wrote:
> From: Nicolin Chen <nicolinc@nvidia.com>
> 
> For virtualization cases the IDR/IIDR/AIDR values of the actual SMMU
> instance need to be available to the VMM so it can construct an
> appropriate vSMMUv3 that reflects the correct HW capabilities.
> 
> For userspace page tables these values are required to constrain the valid
> values within the CD table and the IOPTEs.
> 
> The kernel does not sanitize these values. If building a VMM then
> userspace is required to only forward bits into a VM that it knows it can
> implement. Some bits will also require a VMM to detect if appropriate
> kernel support is available such as for ATS and BTM.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 ++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 ++
>  include/uapi/linux/iommufd.h                | 35 +++++++++++++++++++++
>  3 files changed, 61 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index c2021e821e5cb6..ec2fcdd4523a26 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2288,6 +2288,29 @@ static bool arm_smmu_enforce_cache_coherency(struct iommu_domain *domain)
>  	return ret;
>  }
>  
> +static void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
> +{
> +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +	struct iommu_hw_info_arm_smmuv3 *info;
> +	u32 __iomem *base_idr;
> +	unsigned int i;
> +
> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		return ERR_PTR(-ENOMEM);
> +
> +	base_idr = master->smmu->base + ARM_SMMU_IDR0;
> +	for (i = 0; i <= 5; i++)
> +		info->idr[i] = readl_relaxed(base_idr + i);
> +	info->iidr = readl_relaxed(master->smmu->base + ARM_SMMU_IIDR);
> +	info->aidr = readl_relaxed(master->smmu->base + ARM_SMMU_AIDR);
> +
> +	*length = sizeof(*info);
> +	*type = IOMMU_HW_INFO_TYPE_ARM_SMMUV3;
> +
> +	return info;
> +}
> +
>  struct arm_smmu_domain *arm_smmu_domain_alloc(void)
>  {
>  	struct arm_smmu_domain *smmu_domain;
> @@ -3467,6 +3490,7 @@ static struct iommu_ops arm_smmu_ops = {
>  	.identity_domain	= &arm_smmu_identity_domain,
>  	.blocked_domain		= &arm_smmu_blocked_domain,
>  	.capable		= arm_smmu_capable,
> +	.hw_info		= arm_smmu_hw_info,
>  	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
>  	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
>  	.domain_alloc_user	= arm_smmu_domain_alloc_user,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 45882f65bfcad0..4b05c81b181a82 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -80,6 +80,8 @@
>  #define IIDR_REVISION			GENMASK(15, 12)
>  #define IIDR_IMPLEMENTER		GENMASK(11, 0)
>  
> +#define ARM_SMMU_AIDR			0x1C
> +
>  #define ARM_SMMU_CR0			0x20
>  #define CR0_ATSCHK			(1 << 4)
>  #define CR0_CMDQEN			(1 << 3)
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 4dde745cfb7e29..83b6e1cd338d8f 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -484,15 +484,50 @@ struct iommu_hw_info_vtd {
>  	__aligned_u64 ecap_reg;
>  };
>  
> +/**
> + * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
> + *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
> + *
> + * @flags: Must be set to 0
> + * @__reserved: Must be 0
> + * @idr: Implemented features for ARM SMMU Non-secure programming interface
> + * @iidr: Information about the implementation and implementer of ARM SMMU,
> + *        and architecture version supported
> + * @aidr: ARM SMMU architecture version
> + *
> + * For the details of @idr, @iidr and @aidr, please refer to the chapters
> + * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
> + *
> + * User space should read the underlying ARM SMMUv3 hardware information for
> + * the list of supported features.
> + *
> + * Note that these values reflect the raw HW capability, without any insight if
> + * any required kernel driver support is present. Bits may be set indicating the
> + * HW has functionality that is lacking kernel software support, such as BTM. If
> + * a VMM is using this information to construct emulated copies of these
> + * registers it should only forward bits that it knows it can support.
> + *
> + * In future, presence of required kernel support will be indicated in flags.
> + */
> +struct iommu_hw_info_arm_smmuv3 {
> +	__u32 flags;
> +	__u32 __reserved;
> +	__u32 idr[6];
> +	__u32 iidr;
> +	__u32 aidr;
> +};
There is a ton of information here, I think we might need to santitze the
values for what user space needs to know (that's why I was asking about qemu)
also SMMU_IDR4 is implementation define, not sure if we can unconditionally
expose it to userspace.

Thanks,
Mostafa
> +
>  /**
>   * enum iommu_hw_info_type - IOMMU Hardware Info Types
>   * @IOMMU_HW_INFO_TYPE_NONE: Used by the drivers that do not report hardware
>   *                           info
>   * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
> + * @IOMMU_HW_INFO_TYPE_ARM_SMMUV3: ARM SMMUv3 iommu info type
>   */
>  enum iommu_hw_info_type {
>  	IOMMU_HW_INFO_TYPE_NONE = 0,
>  	IOMMU_HW_INFO_TYPE_INTEL_VTD = 1,
> +	IOMMU_HW_INFO_TYPE_ARM_SMMUV3 = 2,
>  };
>  
>  /**
> -- 
> 2.46.0
> 

