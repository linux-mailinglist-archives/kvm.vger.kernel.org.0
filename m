Return-Path: <kvm+bounces-26610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C368D975FFD
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 06:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1612CB23F21
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 04:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8983518661F;
	Thu, 12 Sep 2024 04:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bw0XmD3f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F6120DF4;
	Thu, 12 Sep 2024 04:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726115377; cv=none; b=tuj6YOE2qLaLiyR2oxp7OsLHXZg5TrYSjylxkK09sO/MXj1RuR/FlI8giBJrKLGzc1dIO3tQejewuVe+Nosc57rXtPUIT8/Zk4VZDAJvbXpCZqorv9PGo0inU8lhsOrdUKIILiVk3r0q+acq7FLASyhWSPKdcCt2wY/cIlNQKWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726115377; c=relaxed/simple;
	bh=2htbrfTbDoYOyrx6HE0Z48NeXXb8ZCZ77dDRQxdrY68=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WOeZU4MOZtQ8hm/H54f/i0Wsy6+XaYPSG5+FP0zhbqHRlYgMsMQ8bOZkSLA+Btukk8ZCwwmZODRJj2WmGxhxRA1HYDzI4HIEew8ZekfhHixNczuWllm7SHKORvC9vXDBZL33TeMOqEvQ3BAWHt30ihVg8IPH5tLJ1PTWgjZXFp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bw0XmD3f; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726115376; x=1757651376;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2htbrfTbDoYOyrx6HE0Z48NeXXb8ZCZ77dDRQxdrY68=;
  b=Bw0XmD3f5LjEGkDbU56wDA87KerY9tZw+6JRISgMOJbVtYJbWkn6Wux8
   sntvuDWsagAdjlbuW4KqZ+NEespBBH0O2V5RdSeeVnuLuDyw0PTM+7MAT
   OsPV49KUug7n0D67XKoYENohbb8xcmbmsNxESPwBHGOVUWtzzR3gghYlG
   hgVsGI/W3RFKfm0Xn657Q4XqKKWF7xO6NkjnUKODyMDJKqV1O4ep2qdQj
   EHy9er4SCTWYFihFuCRFuJaWCwhmzxzQ6Pa0N8In0b+G0erSMumVEBivr
   Eahfx9DRrsU+5f1PZ2Ek9fu+wt6noVeaVecJKN5tQEtMgIBhca1MJn98N
   g==;
X-CSE-ConnectionGUID: XoJHy1YKSie8le+9R6vN8g==
X-CSE-MsgGUID: 6CdQafZtTlmwjpMfX7l2lA==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="25050156"
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="25050156"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 21:29:35 -0700
X-CSE-ConnectionGUID: wBTofcTnRmibyrXMjsPvvA==
X-CSE-MsgGUID: sgRejlZ+S2qkKv9CuIlBYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="67202475"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmviesa006.fm.intel.com with ESMTP; 11 Sep 2024 21:29:29 -0700
Message-ID: <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com>
Date: Thu, 12 Sep 2024 12:25:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
 acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Eric Auger <eric.auger@redhat.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
 patches@lists.linux.dev,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
To: Zhangfei Gao <zhangfei.gao@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 11:42 AM, Zhangfei Gao wrote:
> On Wed, 28 Aug 2024 at 05:32, Nicolin Chen<nicolinc@nvidia.com>  wrote:
>> On Tue, Aug 27, 2024 at 12:51:30PM -0300, Jason Gunthorpe wrote:
>>> This brings support for the IOMMFD ioctls:
>>>
>>>   - IOMMU_GET_HW_INFO
>>>   - IOMMU_HWPT_ALLOC_NEST_PARENT
>>>   - IOMMU_DOMAIN_NESTED
>>>   - ops->enforce_cache_coherency()
>>>
>>> This is quite straightforward as the nested STE can just be built in the
>>> special NESTED domain op and fed through the generic update machinery.
>>>
>>> The design allows the user provided STE fragment to control several
>>> aspects of the translation, including putting the STE into a "virtual
>>> bypass" or a aborting state. This duplicates functionality available by
>>> other means, but it allows trivially preserving the VMID in the STE as we
>>> eventually move towards the VIOMMU owning the VMID.
>>>
>>> Nesting support requires the system to either support S2FWB or the
>>> stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
>>> cache and view incoherent data, currently VFIO lacks any cache flushing
>>> that would make this safe.
>>>
>>> Yan has a series to add some of the needed infrastructure for VFIO cache
>>> flushing here:
>>>
>>>   https://lore.kernel.org/linux-iommu/20240507061802.20184-1-yan.y.zhao@intel.com/
>>>
>>> Which may someday allow relaxing this further.
>>>
>>> Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
>>> this.
>>>
>>> This is the first series in what will be several to complete nesting
>>> support. At least:
>>>   - IOMMU_RESV_SW_MSI related fixups
>>>      https://lore.kernel.org/linux-iommu/cover.1722644866.git.nicolinc@nvidia.com/
>>>   - VIOMMU object support to allow ATS and CD invalidations
>>>      https://lore.kernel.org/linux-iommu/cover.1723061377.git.nicolinc@nvidia.com/
>>>   - vCMDQ hypervisor support for direct invalidation queue assignment
>>>      https://lore.kernel.org/linux-iommu/cover.1712978212.git.nicolinc@nvidia.com/
>>>   - KVM pinned VMID using VIOMMU for vBTM
>>>      https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
>>>   - Cross instance S2 sharing
>>>   - Virtual Machine Structure using VIOMMU (for vMPAM?)
>>>   - Fault forwarding support through IOMMUFD's fault fd for vSVA
>>>
>>> The VIOMMU series is essential to allow the invalidations to be processed
>>> for the CD as well.
>>>
>>> It is enough to allow qemu work to progress.
>>>
>>> This is on github:https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
>>>
>>> v2:
>> As mentioned above, the VIOMMU series would be required to test
>> the entire nesting feature, which now has a v2 rebasing on this
>> series. I tested it with a paring QEMU branch. Please refer to:
>> https://lore.kernel.org/linux-iommu/cover.1724776335.git.nicolinc@nvidia.com/
>> Also, there is another new VIRQ series on top of the VIOMMU one
>> and this nesting series. And I tested it too. Please refer to:
>> https://lore.kernel.org/linux-iommu/cover.1724777091.git.nicolinc@nvidia.com/
>>
>> With that,
>>
>> Tested-by: Nicolin Chen<nicolinc@nvidia.com>
>>
> Have you tested the user page fault?
> 
> I got an issue, when a user page fault happens,
>   group->attach_handle = iommu_attach_handle_get(pasid)
> return NULL.
> 
> A bit confused here, only find IOMMU_NO_PASID is used when attaching
> 
>   __fault_domain_replace_dev
> ret = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
> &handle->handle);
> curr = xa_store(&group->pasid_array, IOMMU_NO_PASID, handle, GFP_KERNEL);
> 
> not find where the code attach user pasid with the attach_handle.

Have you set iommu_ops::user_pasid_table for SMMUv3 driver?

Thanks,
baolu

