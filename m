Return-Path: <kvm+bounces-29227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ADE39A59F7
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:56:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CE4C2818B6
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 05:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5677D1CF7CB;
	Mon, 21 Oct 2024 05:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FkCmp3Pj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEC31CF291
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 05:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490159; cv=none; b=JpGFnGTEBZS9mZSCATTa8yX01W9MN8ngdAM+QAdMW74Yu6CnBiAZRfCom6nH9yYKdNshLD92P39Yu7iVbkfiZGzZ3yLqN9PG9R4vnUT4JPXKhxwzBotyC5RETGYD/iAW7Ti6pXwdobfRqdt0g+NpyFc70O0sqye36hymJCbuzSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490159; c=relaxed/simple;
	bh=0xIdgpc6Mle7xsuPWCeEdsQ8GrVxiDUUQGdaw2uVQJI=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h0QfUU0vlStZAt6zyapYb0xNQHFY7XTBUggxRJclYjt8ZeigwEUP66WcUD3qEeWQ52XMWFvS5BhmOFXrkdAUufqGs+2hi14Lu5Gwzl2Wm2AKGuhHs2zfpEAQY0/HRSz2VHtF0YfxM2sUN+Tdbhj4HntVlxojeLgUZ6jrO6eNwxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FkCmp3Pj; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729490156; x=1761026156;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0xIdgpc6Mle7xsuPWCeEdsQ8GrVxiDUUQGdaw2uVQJI=;
  b=FkCmp3Pjam5wOvqO3w1CeVyLutZ1Y9shCPWrPWvLQwNqsUqCR9tr4MCz
   /6NqczeWDfgKLNSvSzmf342mdy+WzobuhV/hXAISHtrOipC9pnS8moYBR
   0CPw6QeMELgrxql+qxmLc08TBiU1bHYhQXQ+6lgWaL6rLbBRZfOHDhkyf
   eL/S0Nd4ydWe3pCYiwsQ1f08XU7dwlomkJx4+xjLZSmXXgKBv+FMCPJjd
   CkkaDH0KaQieMwGWWz8Rw/+DbV3cz99PoaSkmuu0ZbPfl/+FHKRfqIkQy
   TVCyZGT1hUBojVX99PtRP28oVmkeuMHjgt+5EYfSqGgUqkezfIDpiAmox
   w==;
X-CSE-ConnectionGUID: vAzQU3DBRgiDebdBkSrNbw==
X-CSE-MsgGUID: xYHT2Gn5Rj2/xbdaK3fT8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40081454"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40081454"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 22:55:56 -0700
X-CSE-ConnectionGUID: mOPLqu6nTn2+KquNDp1tHg==
X-CSE-MsgGUID: vZ4wetlrR56zUyrxBUVPHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="84242046"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 22:55:53 -0700
Message-ID: <0ad9fbd3-c796-4e0d-bc0f-f7926575b634@linux.intel.com>
Date: Mon, 21 Oct 2024 13:55:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, alex.williamson@redhat.com,
 eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
 chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v3 1/9] iommu: Pass old domain to set_dev_pasid op
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, will@kernel.org
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-2-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241018055402.23277-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/10/18 13:53, Yi Liu wrote:
> To support domain replacement for pasid, the underlying iommu driver needs
> to know the old domain hence be able to clean up the existing attachment.
> It would be much convenient for iommu layer to pass down the old domain.
> Otherwise, iommu drivers would need to track domain for pasids by themselves,
> this would duplicate code among the iommu drivers. Or iommu drivers would
> rely group->pasid_array to get domain, which may not always the correct
> one.
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/amd/amd_iommu.h                   | 3 ++-
>   drivers/iommu/amd/pasid.c                       | 3 ++-
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 ++-
>   drivers/iommu/intel/iommu.c                     | 6 ++++--
>   drivers/iommu/intel/svm.c                       | 3 ++-
>   drivers/iommu/iommu.c                           | 3 ++-
>   include/linux/iommu.h                           | 2 +-
>   7 files changed, 15 insertions(+), 8 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Thanks,
baolu

