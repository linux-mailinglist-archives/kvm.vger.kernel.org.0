Return-Path: <kvm+bounces-30059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5441F9B6919
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 17:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCEC91F221EC
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 16:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7792144A4;
	Wed, 30 Oct 2024 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PPDF618W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986AC2141BC
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730305586; cv=none; b=mmI9aIS/TIzeHTWZzVTUP0spDUIj7DYwTsrvqb2Yc32LbQY7TMzObl/OVurw6sigtGzKFr9OLPl570Nrvf2Qpe75GK5X4q8JH5NcL1p5OXW8D+iEw1K1w14daM6v3jEVmQCL+Sc1hRvSegm8vfL5rBl1jrfv3YXf9LE28lY47IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730305586; c=relaxed/simple;
	bh=wzGL5UpvG0bdwTiYnT824JUIRPqrqwRpm/7xcQNirR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lr4VSgms3LQy5h/476J0O8LeE70Pb1y4/9HsIAhFLlXTTMkCw/EBOxYtMhFts3bJl2moKM/HM/xyrR7S1z9JKcH5QnH0lJPybUj4nkAS+ATuRbk9v+mqhBPKig6YNGj5zZMaWY2Kd1BwcDOEHi7KpPnhw3K73WzZlJREfAkNUzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PPDF618W; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43150ea2db6so262225e9.0
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 09:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730305583; x=1730910383; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7UYLjFAMj81rJ/LVUvePRD+K/hBtRYfZ9cIPVkpzOQ4=;
        b=PPDF618W1eFTLYEf3PAHxca+hmoaMvU+HoML1FCAs2kh1sVzkF52wKTSlpa3GWb31+
         QtGeKw9NqMitsyEMf8lCAGQ/alJQhHoHtxnNqvUd8gLXMhTsfE2+ag0/+Kf0Kq5hoHrW
         bk8w7dNosMgKPmX1YDbmeoZl5bVK6BnSioFMZL8CQxmNeyD1JqwqVLzaTLYuw+SJ/ocO
         Jba2Q313dTixKsp6nziu6XzSW7HqaclzSsawhByNSh2XFCox84JQwF9rutdb29xhV9da
         GZimvamS9unkTsUyVav3lmG80SNwkTvszVsJhT78oSQDnhAlSBsbq2aktZDVP5rlQl2J
         e5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730305583; x=1730910383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7UYLjFAMj81rJ/LVUvePRD+K/hBtRYfZ9cIPVkpzOQ4=;
        b=BVUICJaxOW/K4IJyGQ13Vok8BKOickHEQjXpu+URAXj0PwzbiOQEfgP+vVFFRFXioF
         xXNw38sDf3/mnhDxpcm5Xn4vNx0sGNk5+8Gs3dtNOtvyEYDBTd3X4M8N+TBTC56Jb70s
         XVlV/oGVbhu437co3yB+xbmKkb+Psrdc/3n38QNSaXSAE6i4+gnV09jHSLlXz6BxtbtB
         TKLsQ1i4pAzYBR2S4J9BECBOC402gRiAPAJRAFzBkdJ56A+6HnQV9hxX4uc3KvuKhwpF
         86zgR2NhFXyIaEYW1KS+MxFtGgeMxubWhL1du15+WcOKIAEofEYqFDb29Gel3zh9uU0W
         VM0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWUqPNcuTuNGeGDlsf1PHDzF23kZQODEjXcJ3AKYlN71cI8NWi3fp415SQLU/C1sK9HqOA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzix1oaX0xjvHlQ3qhSBTy0Ww9sInimz289SCMEQ9Gq7TGD7Cge
	/YQsupNdV4BTN38hdq/lqPwpPNGvd034//IkTWitkjJTw69Gg1kYSPMfWzRPLg==
X-Gm-Gg: ASbGncuf/shQD9maZLjjxL1FG5iQnNf73GIGpuid4eak0yjfhKXL0HzeEIqJ4+ePmsR
	WDs445zg6zKHqfSsRUjZ9IF/FxTVz0sPJAeCUR7P/GUF9U6oXNmMyCUuyGtFvOkcuuV/c77n1I0
	8olyYtgRuTRM+0nxdHnOf85b0lZYEWBypp2UpAv7grg0jEBKfJgsAYXJQVx/5dy42tidV1dVVFT
	MyUOZHnIH+flG2o8+R6ZW1ijmTcO+nOPzXLplF7p3tdAD+JWoFZYbdrKYDVy1kVyDMC1f1bLfMO
	E6XkIuai1A==
X-Google-Smtp-Source: AGHT+IF5k+xhEFV5HljKvzF9cSpzzYGRlJbocUjKE5hnuGSngP/vDOPF5xH9U8BJE4SMib7JrVlCvw==
X-Received: by 2002:a05:600c:1e04:b0:431:43a1:4cac with SMTP id 5b1f17b1804b1-431b4a21ba1mr10153235e9.3.1730305582787;
        Wed, 30 Oct 2024 09:26:22 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058bb4287sm15691567f8f.114.2024.10.30.09.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 09:26:21 -0700 (PDT)
Date: Wed, 30 Oct 2024 16:26:16 +0000
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
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 6/9] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Message-ID: <ZyJeKPvMRBaKpMeJ@google.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <6-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>

On Wed, Oct 09, 2024 at 01:23:12PM -0300, Jason Gunthorpe wrote:
> For SMMUv3 the parent must be a S2 domain, which can be composed
> into a IOMMU_DOMAIN_NESTED.
> 
> In future the S2 parent will also need a VMID linked to the VIOMMU and
> even to KVM.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 996774d461aea2..80847fa386fcd2 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3114,7 +3114,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>  			   const struct iommu_user_data *user_data)
>  {
>  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> -	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> +	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> +				 IOMMU_HWPT_ALLOC_NEST_PARENT;
>  	struct arm_smmu_domain *smmu_domain;
>  	int ret;
>  
> @@ -3127,6 +3128,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>  	if (IS_ERR(smmu_domain))
>  		return ERR_CAST(smmu_domain);
>  
> +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
> +		if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING)) {
> +			ret = -EOPNOTSUPP;
> +			goto err_free;
> +		}
> +		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
> +	}
> +
>  	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
>  	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
>  	ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, flags);
> -- 
> 2.46.2
> 

