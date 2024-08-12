Return-Path: <kvm+bounces-23819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F23094E4CE
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 04:24:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECC9528186A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 02:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE93482481;
	Mon, 12 Aug 2024 02:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NavN4KGD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1504690;
	Mon, 12 Aug 2024 02:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723429445; cv=none; b=ClOy47kg1ZgznmyZLLGDmWtRj/z7GrKpjPBuAykvR66iyvRmrneyLUFTGGrsk73Qx66xK9pJN5HxUsPrtsNCyUc0dSqDKGgWoziOt5LgUVj1UOzp7c20xvbiAPZv5q7JXf2DcJN2M3XYZVgb4ZSGT8zjwKg3PccuGglxhE0mO2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723429445; c=relaxed/simple;
	bh=FqGg5DIw49XQ7Uc49eBDwirJ08MyI6X0CPTIL7COrkM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aR+Aeq/Z2Ir1US1owS6C6HMWwo31VKjroszuVFjzP8jVq9M1J+yj0tDSClbUAq6mAS10QXiaFTFcDbkaB+F3dC8EqLYX3XucXusWcsNkQSAK895Yk+n0DZjc/M+Okglpfq59eHbBkrDyZyLImTqi1SB3eVAWYJgQw6YCsO0eTJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NavN4KGD; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723429444; x=1754965444;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FqGg5DIw49XQ7Uc49eBDwirJ08MyI6X0CPTIL7COrkM=;
  b=NavN4KGDtPDTn+HJcbhlA45OXBHWkLWpe52EeBm7YJ1EcT5fbTvH2aVf
   wecgEsbrsTRATRIh/hXgXlq5gI0XHjQ/GrkK5sG0tGYYN5QQd1IwuuS/M
   BBcVrWCDdtiGX8sKL9Ig+bHoyMWT7eVv99uL3YjOouq0zey3xEll2m1ip
   8F1wBDhmWoh28gHu83A61qdPPgiKlSM+veOYUzehkE7MPBS2dVJdVm5Pr
   QLbdTOOhfpfj9pViUqWlzLF03+/uzgBguyfxiwLx6KALImgCNb7GlBtGE
   IvgJaHnL+drd58wSvnzH5JC/qarRO/bFRpY833SoRWTBmmwXE9QrECZFo
   g==;
X-CSE-ConnectionGUID: QA0Lb5R6RJiYHChKXZByXw==
X-CSE-MsgGUID: 4dVvdAJ0QuyQkl0WjbGhBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="32197516"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="32197516"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2024 19:24:03 -0700
X-CSE-ConnectionGUID: GYcgJn7UReyXGjarYyDrkA==
X-CSE-MsgGUID: 7I8pB5x5QceZjJsh9TtACw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="58020573"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orviesa009.jf.intel.com with ESMTP; 11 Aug 2024 19:24:00 -0700
Message-ID: <ac2ef4ae-ef1d-47b0-bd60-f203baaf124e@linux.intel.com>
Date: Mon, 12 Aug 2024 10:20:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, patches@lists.linux.dev
Subject: Re: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/8/24 2:19 AM, Jason Gunthorpe wrote:
> PCI ATS has a global Smallest Translation Unit field that is located in
> the PF but shared by all of the VFs.
> 
> The expectation is that the STU will be set to the root port's global STU
> capability which is driven by the IO page table configuration of the iommu
> HW. Today it becomes set when the iommu driver first enables ATS.
> 
> Thus, to enable ATS on the VF, the PF must have already had the correct
> STU programmed, even if ATS is off on the PF.
> 
> Unfortunately the PF only programs the STU when the PF enables ATS. The
> iommu drivers tend to leave ATS disabled when IDENTITY translation is
> being used.
> 
> Thus we can get into a state where the PF is setup to use IDENTITY with
> the DMA API while the VF would like to use VFIO with a PAGING domain and
> have ATS turned on. This fails because the PF never loaded a PAGING domain
> and so it never setup the STU, and the VF can't do it.
> 
> The simplest solution is to have the iommu driver set the ATS STU when it
> probes the device. This way the ATS STU is loaded immediately at boot time
> to all PFs and there is no issue when a VF comes to use it.
> 
> Add a new call pci_prepare_ats() which should be called by iommu drivers
> in their probe_device() op for every PCI device if the iommu driver
> supports ATS. This will setup the STU based on whatever page size
> capability the iommu HW has.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/amd/iommu.c                   |  3 ++
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  6 ++++
>   drivers/iommu/intel/iommu.c                 |  1 +
>   drivers/pci/ats.c                           | 33 +++++++++++++++++++++
>   include/linux/pci-ats.h                     |  1 +
>   5 files changed, 44 insertions(+)

For Intel VT-d,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Thanks,
baolu

