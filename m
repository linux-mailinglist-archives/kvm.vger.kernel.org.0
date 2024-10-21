Return-Path: <kvm+bounces-29253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1C099A5BDE
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:59:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87AC01F21FF1
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659C91D0E1F;
	Mon, 21 Oct 2024 06:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EYwjmwS9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1308D1D04BB
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 06:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729493963; cv=none; b=mI9QwiFl9JVhk/VwL/3uOplYT0tB6FeRSltmRi5QSQgbxmlWWhusqXtb01UYfDyg/gFYG3F+5uvG4bLWZv1N6orY7HJXdRC+6pxx69vEbFEZ2xfNNsb2ZhaX25CarQVtL29DP+aheWzhGG1X3bVqf+sAarNL0vecoDIm7udb2Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729493963; c=relaxed/simple;
	bh=Vm1igIvX9C+8oPSZofGBuElI7aRld2YMhzcuRxpz+xM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bu42uwGqWSg77Gjk9tnCVruYkd/MlA4qytdPp7aWgSrI77ai4PXf7rxfKdHdRolLW3LEM0MHTnjrWn6skfhWG0kQCskX3tEFYjUuImsiGCRtvFpUjgg0538+cGbs1CmCdCg/QpokgKnTDXqj/0TCPVqa8g1MVYQAItwx75ls+mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EYwjmwS9; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729493961; x=1761029961;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Vm1igIvX9C+8oPSZofGBuElI7aRld2YMhzcuRxpz+xM=;
  b=EYwjmwS9H6p8DVmuhReijZxsFy6vzNHC/4Bjrzpyz2FvMjwVMjgvQOQm
   MfwGWPKD1hW5Iogul5kFO1avh379cDG73z2fVIe3j7mOV4O/RZXb5s+LZ
   rIcyc/yt52dz5IIuw4NRtZHGWO5HAqeJ5k2tGu1WJEld+fV795yB0fKcU
   bdK92l2qiWg4dePljGGg1a08aM8iDBmbHrlXy2VDsZQxz8mK0CMYv9/zd
   DTGDvW7uCUJ7Y8axH/QKWe1BpC90NRD7cry2zVhpJp90cDJzQhx2bj2BV
   a4ZjBqbD5ef3yMDv1SuyJOhc+Np8ZQ9FXy+p4e2U/VYUXFbN65hA25zFz
   Q==;
X-CSE-ConnectionGUID: pNdZq0pdS8GmJpsjCMfUuw==
X-CSE-MsgGUID: HEfLVIq3TrOKGxVpp+O+IQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11231"; a="28397067"
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="28397067"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:59:19 -0700
X-CSE-ConnectionGUID: gF9XuQjHS/+HePbhGTYdqA==
X-CSE-MsgGUID: H8AZrQHVTQOlU7MjtKqlsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="83431439"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:59:16 -0700
Message-ID: <ce78d006-53d8-4194-ae9d-249ab38c1d6d@linux.intel.com>
Date: Mon, 21 Oct 2024 14:59:14 +0800
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
Subject: Re: [PATCH v3 3/9] iommu/vt-d: Let intel_pasid_tear_down_entry()
 return pasid entry
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, will@kernel.org
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-4-yi.l.liu@intel.com>
 <e5cd1de4-37f7-4d55-aa28-f37d49d46ac6@linux.intel.com>
 <521b4f3e-1979-46f5-bfad-87951db2b6ed@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <521b4f3e-1979-46f5-bfad-87951db2b6ed@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/10/21 14:35, Yi Liu wrote:
> On 2024/10/21 14:13, Baolu Lu wrote:
>> On 2024/10/18 13:53, Yi Liu wrote:
>>> intel_pasid_tear_down_entry() finds the pasid entry and tears it down.
>>> There are paths that need to get the pasid entry, tear it down and
>>> re-configure it. Letting intel_pasid_tear_down_entry() return the pasid
>>> entry can avoid duplicate codes to get the pasid entry. No functional
>>> change is intended.
>>>
>>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>>> ---
>>>   drivers/iommu/intel/pasid.c | 11 ++++++++---
>>>   drivers/iommu/intel/pasid.h |  5 +++--
>>>   2 files changed, 11 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>>> index 2898e7af2cf4..336f9425214c 100644
>>> --- a/drivers/iommu/intel/pasid.c
>>> +++ b/drivers/iommu/intel/pasid.c
>>> @@ -239,9 +239,12 @@ devtlb_invalidation_with_pasid(struct 
>>> intel_iommu *iommu,
>>>   /*
>>>    * Caller can request to drain PRQ in this helper if it hasn't done 
>>> so,
>>>    * e.g. in a path which doesn't follow remove_dev_pasid().
>>> + * Return the pasid entry pointer if the entry is found or NULL if no
>>> + * entry found.
>>>    */
>>> -void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct 
>>> device *dev,
>>> -                 u32 pasid, u32 flags)
>>> +struct pasid_entry *
>>> +intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device 
>>> *dev,
>>> +                u32 pasid, u32 flags)
>>>   {
>>>       struct pasid_entry *pte;
>>>       u16 did, pgtt;
>>> @@ -250,7 +253,7 @@ void intel_pasid_tear_down_entry(struct 
>>> intel_iommu *iommu, struct device *dev,
>>>       pte = intel_pasid_get_entry(dev, pasid);
>>>       if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>>>           spin_unlock(&iommu->lock);
>>> -        return;
>>> +        goto out;
>>
>> The pasid table entry is protected by iommu->lock. It's  not reasonable
>> to return the pte pointer which is beyond the lock protected range.
> 
> Per my understanding, the iommu->lock protects the content of the entry,
> so the modifications to the entry need to hold it. While, it looks not
> necessary to protect the pasid entry pointer itself. The pasid table should
> exist during device probe and release. is it?

The pattern of the code that modifies a pasid table entry is,

	spin_lock(&iommu->lock);
	pte = intel_pasid_get_entry(dev, pasid);
	... modify the pasid table entry ...
	spin_unlock(&iommu->lock);

Returning the pte pointer to the caller introduces a potential race
condition. If the caller subsequently modifies the pte without re-
acquiring the spin lock, there's a risk of data corruption or
inconsistencies.

Thanks,
baolu

