Return-Path: <kvm+bounces-23700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70FB194D2EB
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30D102814D3
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E34197A9E;
	Fri,  9 Aug 2024 15:06:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C388196D9E;
	Fri,  9 Aug 2024 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723215992; cv=none; b=bbinpRwtVHUL9EZSUKsWCmFbxhFBXvVhcEdX+OG42cM1uyDbbRH9G5fz88WGrlYarMDe6iTZQIKgYlyqzk7LSneZJI/ywAK4peOzjKjBh4ALhHUkZ4h5y1aSGOlHgbuqwFQ4cEGbjSGGaHUi4i2l1onKAdX01QCR7D4Fi/tb1Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723215992; c=relaxed/simple;
	bh=qJLpcmJL5MiVhs4WhWQq98pLwY/iHNAfWKPrXRL/4HE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=roZ86YzYDUJJF7AnbmW8LmUcJrVzE73bNjPDs0bFxhTwqapz3BNHdhPJyJJQbMgK1aARjICg+zQO7im6+N7opQMKVzjbFgtN6P2DM9xG2eyhylas0n9qy/wbO5gY5Qy0iw8dGVd3aAg6RikK0iijzU25JOxznCRqfq7SaFhPUSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A36B013D5;
	Fri,  9 Aug 2024 08:06:53 -0700 (PDT)
Received: from [10.57.46.232] (unknown [10.57.46.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BAB073F71E;
	Fri,  9 Aug 2024 08:06:23 -0700 (PDT)
Message-ID: <cd79f790-1281-4280-bc02-6ca9a9d0d26b@arm.com>
Date: Fri, 9 Aug 2024 16:06:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
To: Jason Gunthorpe <jgg@nvidia.com>, acpica-devel@lists.linux.dev,
 Alex Williamson <alex.williamson@redhat.com>,
 Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
 Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
References: <6-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <6-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-08-07 12:41 am, Jason Gunthorpe wrote:
> For SMMUv3 the parent must be a S2 domain, which can be composed
> into a IOMMU_DOMAIN_NESTED.
> 
> In future the S2 parent will also need a VMID linked to the VIOMMU and
> even to KVM.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 6bbe4aa7b9511c..5faaccef707ef1 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>   			   const struct iommu_user_data *user_data)
>   {
>   	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> -	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> +	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> +				 IOMMU_HWPT_ALLOC_NEST_PARENT;
>   	struct arm_smmu_domain *smmu_domain;
>   	int ret;
>   
> @@ -3116,6 +3117,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>   	if (!smmu_domain)
>   		return ERR_PTR(-ENOMEM);
>   
> +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
> +		if (!(master->smmu->features & ARM_SMMU_FEAT_TRANS_S2)) {

Nope, nesting needs to rely on FEAT_NESTING, that's why it exists. S2 
alone isn't sufficient - without S1 there's nothing to expose to 
userspace, so zero point in having a "nested" domain with nothing to 
nest into it - but furthermore we need S2 *without* unsafe broken TLBs.

Thanks,
Robin.

> +			ret = -EOPNOTSUPP;
> +			goto err_free;
> +		}
> +		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
> +	}
> +
>   	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
>   	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
>   	ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, flags);

