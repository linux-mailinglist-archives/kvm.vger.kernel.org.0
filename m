Return-Path: <kvm+bounces-35718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A53A147D7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 03:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9D4A1650E8
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 02:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A66151E2009;
	Fri, 17 Jan 2025 02:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BolhGzCO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C4B1E130F;
	Fri, 17 Jan 2025 02:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737079204; cv=none; b=ANoZd/H0tgrvgVad/+klH4r/VnczQFkJKpmAFResGCJaNhATUFHd+h7Xe1KixWZzeyc5O8L4zoz2tNgWt+cCQ9jFsZ1ILzyVA78FZISH9WmTYAz5Zo2rE029PJrij5PB0rL5gij9ucqec3JU5aT5ZWJ/5XE+8ppIQPB/aBsGWqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737079204; c=relaxed/simple;
	bh=5ZUz4QZLDlVa1hMJ47XHMGlOnKcryI3Cj9ggu76axOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C41z7nscuacDQZsDaYCgWcjYOVUdw2zxuCqOHyYZZimXA9vCfIJCnQ6jJgZe0fiDS8zcdDjc6Lpi9nKMer714fQKA7WOr1lwpKRTVU9k4ohDrs9u9uCq/Jo7IgDGB1BnJhvwxPxd4vS7MKPoJdk1hoaRcqH9lk07JjMTU9CSWvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BolhGzCO; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737079203; x=1768615203;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5ZUz4QZLDlVa1hMJ47XHMGlOnKcryI3Cj9ggu76axOY=;
  b=BolhGzCO5+emxeEY2bbCDWEFk2cPQFkmtwrS15gWqEtCopozwZ/Ptuc9
   Sr50lPxg9MwQfbG1EfqKEV1iTokGAPIdl8M/4gm7TbvY2ABeDC1cQGVcU
   CMYOS8LyYNx5diU/GjH5C3yYSCXBIVrhCZQvIjNdLGqDD6j/l3B0YbfVl
   qQsaAsGlqIVp5BIGlEV4GTGR+6AN9tMDRTFYCIH00DYLHi22aQgF5/BKy
   RYkB7njyvBJP1qDZt3aXgmSUUbFfrjTe2Ot4kpsmg4glRalQ3AdjfX+8a
   Kc96wBG8qF9CcGxhStoQwEJM4nxWnTMgArWabDdakjM41GCJhlXWJ5vcO
   g==;
X-CSE-ConnectionGUID: En+ACN3PQeifh9w+oqC97w==
X-CSE-MsgGUID: lG+WVuNlQLeLCFEk5+ZM5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11317"; a="37653490"
X-IronPort-AV: E=Sophos;i="6.13,210,1732608000"; 
   d="scan'208";a="37653490"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 18:00:02 -0800
X-CSE-ConnectionGUID: q+qN46kgS4eRnBfRJ9Qo0w==
X-CSE-MsgGUID: pIAKJmATQDajlK90Sjd0tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="106140512"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 17:59:57 -0800
Message-ID: <f1ac048f-64b1-4343-ab86-ad98c24a44f5@linux.intel.com>
Date: Fri, 17 Jan 2025 09:57:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 08/12] vfio/pci: Create host unaccessible dma-buf for
 private device
To: Jason Gunthorpe <jgg@nvidia.com>, Alexey Kardashevskiy <aik@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
 christian.koenig@amd.com, pbonzini@redhat.com, seanjc@google.com,
 alex.williamson@redhat.com, vivek.kasireddy@intel.com,
 dan.j.williams@intel.com, yilun.xu@intel.com, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
 daniel.vetter@ffwll.ch, leon@kernel.org, zhenzhong.duan@intel.com,
 tao1.su@intel.com
References: <20250108133026.GQ5556@nvidia.com>
 <Z36ulpCoJAllp4fP@yilunxu-OptiPlex-7050> <20250109144051.GX5556@nvidia.com>
 <Z3/7/PQCLi1GE5Ry@yilunxu-OptiPlex-7050> <20250110133116.GF5556@nvidia.com>
 <Z4Hp9jvJbhW0cqWY@yilunxu-OptiPlex-7050> <20250113164935.GP5556@nvidia.com>
 <ZnDGqww5SLbVD6ET@yilunxu-OptiPlex-7050> <20250114133553.GB5556@nvidia.com>
 <17cd9b77-4620-4883-9a6a-8d1cab822c88@amd.com>
 <20250115130102.GM5556@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250115130102.GM5556@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/25 21:01, Jason Gunthorpe wrote:
> On Wed, Jan 15, 2025 at 11:57:05PM +1100, Alexey Kardashevskiy wrote:
>> On 15/1/25 00:35, Jason Gunthorpe wrote:
>>> On Tue, Jun 18, 2024 at 07:28:43AM +0800, Xu Yilun wrote:
>>>
>>>>> is needed so the secure world can prepare anything it needs prior to
>>>>> starting the VM.
>>>> OK. From Dan's patchset there are some touch point for vendor tsm
>>>> drivers to do secure world preparation. e.g. pci_tsm_ops::probe().
>>>>
>>>> Maybe we could move to Dan's thread for discussion.
>>>>
>>>> https://lore.kernel.org/linux- 
>>>> coco/173343739517.1074769.13134786548545925484.stgit@dwillia2- 
>>>> xfh.jf.intel.com/
>>> I think Dan's series is different, any uapi from that series should
>>> not be used in the VMM case. We need proper vfio APIs for the VMM to
>>> use. I would expect VFIO to be calling some of that infrastructure.
>> Something like this experiment?
>>
>> https://github.com/aik/linux/commit/ 
>> ce052512fb8784e19745d4cb222e23cabc57792e
> Yeah, maybe, though I don't know which of vfio/iommufd/kvm should be
> hosting those APIs, the above does seem to be a reasonable direction.
> 
> When the various fds are closed I would expect the kernel to unbind
> and restore the device back.

I am curious about the value of tsm binding against an iomnufd_vdevice
instead of the physical iommufd_device.

It is likely that the kvm pointer should be passed to iommufd during the
creation of a viommu object. If my recollection is correct, the arm
smmu-v3 needs it to obtain the vmid to setup the userspace event queue:

struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
                                        struct iommu_domain *parent,
                                        struct iommufd_ctx *ictx,
                                        unsigned int viommu_type)
{

[...]

         /* FIXME Move VMID allocation from the S2 domain allocation to 
here */
         vsmmu->vmid = s2_parent->s2_cfg.vmid;

         return &vsmmu->core;
}

Intel TDX connect implementation also needs a reference to the kvm
pointer to obtain the secure EPT information. This is crucial because
the CPU's page table must be shared with the iommu. I am not sure
whether the amd architecture has a similar requirement.

---
baolu

