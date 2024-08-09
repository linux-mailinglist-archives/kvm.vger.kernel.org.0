Return-Path: <kvm+bounces-23747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0048094D64E
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B51502826BF
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AB85158D92;
	Fri,  9 Aug 2024 18:34:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD2D154C15;
	Fri,  9 Aug 2024 18:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723228468; cv=none; b=kYsmBtcB7bExPXSXnrDhUl4kzjtSGMMSxTpuX523rKGq+/cKjIwcBmrs8VVWtpSuGEkU1xWRevP91VH7TOVMD0fHiCIz/lyV1qonrS7HkDHZKrc2wc3dYOtE/KlBFxEkvOC84qcjKpizBQL1piEIXgjnAD9RNI2UukxoNOp88rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723228468; c=relaxed/simple;
	bh=s283aAlR8u7pOsf4PNNBWtmiyFix+BA7VAZzacmMZqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SkxCKM9Hi8cOPR4RtVQM+kwDDIkTwFsRWOK874DEDpgnfN7qm+3zIbgzDzn2MgppMJKzK7I+/niEiAl4sj8Fy/SLcHU/XcUtOjBU+n5Kke875mV9EHJCi5CDeE/xTec1Jt6Nu/5GLSmk54KhW5w3SlhSptJ2rj3qmIUh+sY0ruA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35B5013D5;
	Fri,  9 Aug 2024 11:34:51 -0700 (PDT)
Received: from [10.57.46.232] (unknown [10.57.46.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB8D03F6A8;
	Fri,  9 Aug 2024 11:34:21 -0700 (PDT)
Message-ID: <e4116985-f8af-4a2b-af32-d9793e94ead7@arm.com>
Date: Fri, 9 Aug 2024 19:34:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Alex Williamson
 <alex.williamson@redhat.com>, Hanjun Guo <guohanjun@huawei.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
 Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
References: <6-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <cd79f790-1281-4280-bc02-6ca9a9d0d26b@arm.com>
 <20240809160959.GJ8378@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20240809160959.GJ8378@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-08-09 5:09 pm, Jason Gunthorpe wrote:
> On Fri, Aug 09, 2024 at 04:06:22PM +0100, Robin Murphy wrote:
>> On 2024-08-07 12:41 am, Jason Gunthorpe wrote:
>>> For SMMUv3 the parent must be a S2 domain, which can be composed
>>> into a IOMMU_DOMAIN_NESTED.
>>>
>>> In future the S2 parent will also need a VMID linked to the VIOMMU and
>>> even to KVM.
>>>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> ---
>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
>>>    1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>> index 6bbe4aa7b9511c..5faaccef707ef1 100644
>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>> @@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>>>    			   const struct iommu_user_data *user_data)
>>>    {
>>>    	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
>>> -	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
>>> +	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
>>> +				 IOMMU_HWPT_ALLOC_NEST_PARENT;
>>>    	struct arm_smmu_domain *smmu_domain;
>>>    	int ret;
>>> @@ -3116,6 +3117,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
>>>    	if (!smmu_domain)
>>>    		return ERR_PTR(-ENOMEM);
>>> +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
>>> +		if (!(master->smmu->features & ARM_SMMU_FEAT_TRANS_S2)) {
>>
>> Nope, nesting needs to rely on FEAT_NESTING, that's why it exists. S2 alone
>> isn't sufficient - without S1 there's nothing to expose to userspace, so
>> zero point in having a "nested" domain with nothing to nest into it - but
>> furthermore we need S2 *without* unsafe broken TLBs.
> 
> I do tend to agree we should fail earlier if IOMMU_DOMAIN_NESTED is
> not possible so let's narrow it.
> 
> However, the above was matching how the driver already worked (ie the
> old arm_smmu_enable_nesting()) where just asking for a normal S2 was
> gated only by FEAT_S2.

Ohhhh, I see, so actually the same old subtlety is still there - 
ALLOC_NEST_PARENT isn't a definite "allocate the parent domain for my 
nested setup", it's "allocate a domain which will be capable of being 
upgraded to nesting later *if* I choose to do so". Is the intent that 
someone could still use this if they had no intention of nesting but 
just wanted to ensure S2 format for their single stage of translation 
for some reason? It remains somewhat confusing since S2 domains on 
S2-only SMMUs are still fundamentally incapable of ever becoming a 
nested parent, but admittedly I'm struggling to think of a name which 
would be more accurate while still generic, so maybe it's OK...

> This does add a CMDQ_OP_TLBI_NH_ALL, but I didn't think that hit an
> errata?

Indeed, all the really nasty errata depend on both stages being active 
(such that S1 translation requests interact with concurrent S2 
invalidations)

Thanks,
Robin.

> The nesting specific stuff that touches things that FEAT_NESTING
> covers in the driver is checked here:
> 
> static struct iommu_domain *
> arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
> 			      struct iommu_domain *parent,
> 			      const struct iommu_user_data *user_data)
> {
> 	if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING))
> 		return ERR_PTR(-EOPNOTSUPP);
> 
> Which prevents creating a IOMMU_DOMAIN_NESTED, meaning you can't get a
> CD table on top of the S2 or issue any S1 invalidations.
> 
> Thanks,
> Jason

