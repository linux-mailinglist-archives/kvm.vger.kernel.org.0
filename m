Return-Path: <kvm+bounces-14920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D93AC8A7A97
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 04:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73D061F21FCB
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 02:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428078BFA;
	Wed, 17 Apr 2024 02:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hYbPpnd0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C496FA8
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 02:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713321115; cv=none; b=azoK+KwWUz/mdqva8/n2VcB1ygasI8fByHWEbfVSXKhi/Z6noNNy8rm/MX2JCl8UtRpkoevU6cl8YKz9zwsf6W64giPlo57NTqIknqPixPyneAjYsM6sDRtJITyO4dqnMx2mZj/ZvC02x+zqWWBeN3fIILbJi/aeOnC/Yw3zSqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713321115; c=relaxed/simple;
	bh=lfgRoJpHnPpBk8HQOm7R0ffOnvDHRrB135HSdBlp87w=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=izePPXhp88cCq3QdNmuBLpiqdkTWV7wS6+ztz/0Bqd3fVPwwYeUB0qNDccPGeG2HPaMq6aUwtS80GXza+JtYwyz87yzKtQFOEZ6S3nb1rLO19XSUsWOr+4y7ZWU5NlLoy6tEmP+K2lP72j6h7vyzS4Zd69VmdgydK74VuXYbCcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hYbPpnd0; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713321114; x=1744857114;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lfgRoJpHnPpBk8HQOm7R0ffOnvDHRrB135HSdBlp87w=;
  b=hYbPpnd0kZd9ql9saq9VpVz9zK+sgsVK01q5WFvNkH74S/Q0TorEqTbg
   RkP4Flk65Vl569fM17Z6stsC3VilauYLFF3FG/qe8jF3EQK886FNfqwOJ
   cMwTa1AkuP8AToZasNJeznRrUm5oX4RBY8l88PLEL2qbuCnrh7Dxt9JwY
   wV2w7jxcvbF930NeG+BfVniMItpqQYwmmDZFEBikTfAyt0G8zxXc8h9JW
   6ZMy7VbCDyq6rySB/BT88SkPvtVjH/v+2afRyPy2mNMZue+70o60diwsV
   V77EVQ5LBydbcGowmqt+DRWZz/Qs0Eq5Vm/uVwBj9KkwVH5CB7nTuBW26
   w==;
X-CSE-ConnectionGUID: ms10Mo/BTxSPLcGWXYRRaw==
X-CSE-MsgGUID: tO4kgbV7RDyScxPySCt8UQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8657398"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="8657398"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 19:31:53 -0700
X-CSE-ConnectionGUID: ixh1WPkDSUaD3plApszSvQ==
X-CSE-MsgGUID: rS+7Rz3DQz6sgNI/HEfOFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="27131122"
Received: from unknown (HELO [10.239.159.127]) ([10.239.159.127])
  by fmviesa004.fm.intel.com with ESMTP; 16 Apr 2024 19:31:49 -0700
Message-ID: <a0543205-18a8-4878-8b24-3d87bee24645@linux.intel.com>
Date: Wed, 17 Apr 2024 10:30:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, alex.williamson@redhat.com,
 robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 10/12] iommu/vt-d: Return if no dev_pasid is found in
 domain
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-11-yi.l.liu@intel.com>
 <ed73dfc1-a6a2-4a19-b716-7c1f245db75b@linux.intel.com>
 <373e52b4-e663-4b2d-9a6b-feaf3a93892b@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <373e52b4-e663-4b2d-9a6b-feaf3a93892b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/16/24 5:21 PM, Yi Liu wrote:
> 
> n 2024/4/15 14:04, Baolu Lu wrote:
>> On 4/12/24 4:15 PM, Yi Liu wrote:
>>> If no dev_pasid is found, it should be a problem of caller. So a WARN_ON
>>> is fine, but no need to go further as nothing to be cleanup and also it
>>> may hit unknown issue.
>>
>> If "... it should be a problem of caller ...", then the check and WARN()
>> should be added in the caller instead of individual drivers.
>>
>>>
>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>> ---
>>>   drivers/iommu/intel/iommu.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>>> index df49aed3df5e..fff7dea012a7 100644
>>> --- a/drivers/iommu/intel/iommu.c
>>> +++ b/drivers/iommu/intel/iommu.c
>>> @@ -4614,8 +4614,9 @@ static void intel_iommu_remove_dev_pasid(struct 
>>> device *dev, ioasid_t pasid,
>>>               break;
>>>           }
>>>       }
>>> -    WARN_ON_ONCE(!dev_pasid);
>>>       spin_unlock_irqrestore(&dmar_domain->lock, flags);
>>> +    if (WARN_ON_ONCE(!dev_pasid))
>>> +        return;
>>
>> The iommu core calls remove_dev_pasid op to tear down the translation on
>> a pasid and park it in a BLOCKED state. Since this is a must-be-
>> successful callback, it makes no sense to return before tearing down the
>> pasid table entry.
> 
> but if no dev_pasid is found, does it mean there is no pasid table entry
> to be destroyed? That's why I think it deserves a warn, but no need to
> continue.

The pasid table is allocated in the iommu probe path, hence the entry is
*always* there. Teardown a pasid translation just means zeroing out all
fields of the entry.

> 
>>
>>  From the Intel iommu driver's perspective, the pasid devices have
>> already been tracked in the core, hence the dev_pasid is a duplicate and
>> will be removed later, so don't use it for other purposes.
> 
> 
> good to know it. But for the current code, if we continue, it would hit
> call trace in the end in the intel_iommu_debugfs_remove_dev_pasid().

The debugfs interface should be designed to be self-contained. That
means, even if one passes a NULL pointer to
intel_iommu_debugfs_remove_dev_pasid(), it should handle it gracefully.

Best regards,
baolu

