Return-Path: <kvm+bounces-30700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D50299BC7A5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:04:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D54A1F22806
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 08:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939E91FEFCB;
	Tue,  5 Nov 2024 08:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YXDTSyLy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536C81D5CD1
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 08:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730793842; cv=none; b=O8Ys3bLOkfThxkSjM29K31vCPQUcljcW2o+tWP0DJ+1OoNkAO+X6LK2fLNojHNV1W7LUly1nOtjaRsGVhL2Quhm3pgsEuE7MZdmYh/ZNJp7EPFc/na0u9kuBZJlJf6LKLISRYQpHdAwkLedaruHIFq2YgFTA0SS2UmuvY8dn6b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730793842; c=relaxed/simple;
	bh=FGtUfSQSi1TL+oiVT5v/d6tiZjg1w/tNO3rsE5QG8lQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LTRzlr7oo0uLx3hU+UUreSR8x2gwrcUaKQMmMR4an1MG1WKSt+9q0RIsM50VzcEJ6IY7xqcTQfxvqo8swyUoOAEOZeKCWPHt3vaHYxU/8zTZWkTAtNp/0V6yEGQ358+1V5I8IfBZZ9IfXcRzF1FSzx7blpWJsF3/p1zvuXcaVgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YXDTSyLy; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730793841; x=1762329841;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FGtUfSQSi1TL+oiVT5v/d6tiZjg1w/tNO3rsE5QG8lQ=;
  b=YXDTSyLyFGhMMTQ/XU3JpWhoeHDtqOi482bOPWNxqx7ZVo8dCmp4SsZi
   sypgwtGRq7B6812NqjEOFJ5JAlyFEpErjZ0ld31/ZRQAEjMolG+NGIOKZ
   nYKE/D5hXmBp3r6V0x9jnKmelqttWP60EZc9r1fkRW7vpONKaPUwIRDsd
   6Ry+PpQl8Xs7DqhV+MVwFz7OHEwOTbhob6tOY4IoUFtHpvHFrNZMTDOGe
   3UX0ZpqrZ8pdf+d+urxkvVdkndxl/n7w20eJCh3PMnYBDoHNGraprcAr4
   TVYu/03oftyaVEZD0mOPHH19ighgV2GNTrT4/09WsPEC48tedgaJ8fh51
   Q==;
X-CSE-ConnectionGUID: fwYdACfvR1qDMccUJLAd5A==
X-CSE-MsgGUID: MTSmAi6QQWmooIFQmKKJHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41152971"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="41152971"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 00:04:00 -0800
X-CSE-ConnectionGUID: nOPsjoa5S1CfZiPy0EAhzA==
X-CSE-MsgGUID: 036ARBYDSGmtWkqKWYn7+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="88683606"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 00:03:58 -0800
Message-ID: <9ddc9d2f-b894-4c6b-ab34-4a3fbde9d18f@linux.intel.com>
Date: Tue, 5 Nov 2024 16:03:55 +0800
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
Subject: Re: [PATCH v5 02/12] iommufd: Refactor __fault_domain_replace_dev()
 to be a wrapper of iommu_replace_group_handle()
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-3-yi.l.liu@intel.com>
 <7c0367f7-634c-485f-8c87-879ddfa2d29d@linux.intel.com>
 <a7cf853d-be52-4a61-8e0b-3638d0559853@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <a7cf853d-be52-4a61-8e0b-3638d0559853@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/11/5 16:01, Yi Liu wrote:
> On 2024/11/5 13:06, Baolu Lu wrote:
>> On 11/4/24 21:25, Yi Liu wrote:
>>> There is a wrapper of iommu_attach_group_handle(), so making a 
>>> wrapper for
>>> iommu_replace_group_handle() for further code refactor. No functional 
>>> change
>>> intended.
>>
>> This patch is not a simple, non-functional refactoring. It allocates
>> attach_handle for all devices in domain attach/replace interfaces,
>> regardless of whether the domain is iopf-capable. Therefore, the commit
>> message should be rephrased to accurately reflect the patch's purpose
>> and rationale.
> 
> This patch splits the __fault_domain_replace_dev() a lot, the else 
> branch of the below code was lifted to the 
> iommufd_fault_domain_replace_dev().
> While the new __fault_domain_replace_dev() will only be called when the
> hwpt->fault is valid. So the iommu_attach_handle is still allocated only
> for the iopf-capable path. When the hwpt->fault is invalid, the
> iommufd_fault_domain_replace_dev() calls iommu_replace_group_handle() with
> a null iommu_attach_handle. What you described is done in the patch 04 of
> this series. 🙂
> 
> -    if (hwpt->fault) {
> -        handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> -        if (!handle)
> -            return -ENOMEM;
> -
> -        handle->idev = idev;
> -        ret = iommu_replace_group_handle(idev->igroup->group,
> -                         hwpt->domain, &handle->handle);
> -    } else {
> -        ret = iommu_replace_group_handle(idev->igroup->group,
> -                         hwpt->domain, NULL);
> -    }

Okay, I overlooked that part.

Below change caused me to think that attach handle is always allocated
in this patch no matter ...

-	if (hwpt->fault) {
-		handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-		if (!handle)
-			return -ENOMEM;
-
-		handle->idev = idev;
-		ret = iommu_replace_group_handle(idev->igroup->group,
-						 hwpt->domain, &handle->handle);
-	} else {
-		ret = iommu_replace_group_handle(idev->igroup->group,
-						 hwpt->domain, NULL);
-	}
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;

If no functional change, please just ignore this comment.

--
baolu

