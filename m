Return-Path: <kvm+bounces-29349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 391889A9E6C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCF0A1F23638
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 09:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715BB1991CC;
	Tue, 22 Oct 2024 09:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HyR1jLnQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CCF19882B
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 09:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729589018; cv=none; b=f3l7/RvmvYp093m7+XjMdJt3KOhM7kkjsq8uyHNWAZVeQTfkRiiTQpceU580MQDb/MYjfEtkr/Csll8wswl4/SHt0OyHS5GNK+yLHpO3G6c2YWhKMDjr+qfNClAxwklBvpZha9vj3qLQIL/npolP7zYH3nm3BlR9bNU1VHjnDHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729589018; c=relaxed/simple;
	bh=ZDt+qPw7wsKcrlPrUutVtr9aTxJWu9f+fNl+xeHpl9k=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tyt2DDfQnqnJDDie6HdOle35BPtMnhCJo9aNWOP6fE4OUWouycgHyabw/dp2jKl1hBzdYjh54HcnFXDJny0gEzCm0VAzkssE96B27kYovjBAzFOfOTu9Wm694xjqswpv/2sC8+Gxjzk/2MnSfpMbQ/i9uFl/8lOp35YkbKaIMzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HyR1jLnQ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729589015; x=1761125015;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZDt+qPw7wsKcrlPrUutVtr9aTxJWu9f+fNl+xeHpl9k=;
  b=HyR1jLnQvrlOXNC5MVlSKDI5akp5Mony7ssdjeg8CPFb2Pcy2xoqkr5b
   cGgxx2EUXQC5/Z85vU9ZXqAZDUi+6eDCZ4jOCljYpzXsIuw9wDKDxPjH5
   WDu7JB31GmIFcX2Zb5o9VPu2S25O3IxWtxf/tOvV+P3e7KMOSZ2iTaeaN
   HLRwSVdh02Vv30RULgxzPO2q/mywu4lHMk5vHUAvNyZaZoJJD/wTR9Ase
   0O1zFkhTbdwjFx2cXmf07BWIIgeobQu5g2qrLPBvaSi0viCc9PGG7Tfba
   k5BsQU6qbmMFwr1kDwKxwGzJFPlpxs2Me/vke3xzn6bWuURVBncPG/7Id
   w==;
X-CSE-ConnectionGUID: q1B8L54vQ5OKVpdfwIpDiA==
X-CSE-MsgGUID: 57AmqcXGQpqvDv+v9/ssfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11232"; a="39695603"
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="39695603"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 02:23:35 -0700
X-CSE-ConnectionGUID: cFC3aHDLR9+RN0CGI82V9Q==
X-CSE-MsgGUID: faHbF45wRp25wCfWq1Xjtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="110623539"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 02:23:31 -0700
Message-ID: <9d726285-730a-400d-8d45-f494b2c62205@linux.intel.com>
Date: Tue, 22 Oct 2024 17:23:29 +0800
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
 <ce78d006-53d8-4194-ae9d-249ab38c1d6d@linux.intel.com>
 <bab356e9-de34-41bb-9942-de639ee7d3de@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <bab356e9-de34-41bb-9942-de639ee7d3de@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/10/21 15:24, Yi Liu wrote:
> On 2024/10/21 14:59, Baolu Lu wrote:
>> On 2024/10/21 14:35, Yi Liu wrote:
>>> On 2024/10/21 14:13, Baolu Lu wrote:
>>>> On 2024/10/18 13:53, Yi Liu wrote:
>>>>> intel_pasid_tear_down_entry() finds the pasid entry and tears it down.
>>>>> There are paths that need to get the pasid entry, tear it down and
>>>>> re-configure it. Letting intel_pasid_tear_down_entry() return the 
>>>>> pasid
>>>>> entry can avoid duplicate codes to get the pasid entry. No functional
>>>>> change is intended.
>>>>>
>>>>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>>>>> ---
>>>>>   drivers/iommu/intel/pasid.c | 11 ++++++++---
>>>>>   drivers/iommu/intel/pasid.h |  5 +++--
>>>>>   2 files changed, 11 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>>>>> index 2898e7af2cf4..336f9425214c 100644
>>>>> --- a/drivers/iommu/intel/pasid.c
>>>>> +++ b/drivers/iommu/intel/pasid.c
>>>>> @@ -239,9 +239,12 @@ devtlb_invalidation_with_pasid(struct 
>>>>> intel_iommu *iommu,
>>>>>   /*
>>>>>    * Caller can request to drain PRQ in this helper if it hasn't 
>>>>> done so,
>>>>>    * e.g. in a path which doesn't follow remove_dev_pasid().
>>>>> + * Return the pasid entry pointer if the entry is found or NULL if no
>>>>> + * entry found.
>>>>>    */
>>>>> -void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct 
>>>>> device *dev,
>>>>> -                 u32 pasid, u32 flags)
>>>>> +struct pasid_entry *
>>>>> +intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct 
>>>>> device *dev,
>>>>> +                u32 pasid, u32 flags)
>>>>>   {
>>>>>       struct pasid_entry *pte;
>>>>>       u16 did, pgtt;
>>>>> @@ -250,7 +253,7 @@ void intel_pasid_tear_down_entry(struct 
>>>>> intel_iommu *iommu, struct device *dev,
>>>>>       pte = intel_pasid_get_entry(dev, pasid);
>>>>>       if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>>>>>           spin_unlock(&iommu->lock);
>>>>> -        return;
>>>>> +        goto out;
>>>>
>>>> The pasid table entry is protected by iommu->lock. It's  not reasonable
>>>> to return the pte pointer which is beyond the lock protected range.
>>>
>>> Per my understanding, the iommu->lock protects the content of the entry,
>>> so the modifications to the entry need to hold it. While, it looks not
>>> necessary to protect the pasid entry pointer itself. The pasid table 
>>> should
>>> exist during device probe and release. is it?
>>
>> The pattern of the code that modifies a pasid table entry is,
>>
>>      spin_lock(&iommu->lock);
>>      pte = intel_pasid_get_entry(dev, pasid);
>>      ... modify the pasid table entry ...
>>      spin_unlock(&iommu->lock);
>>
>> Returning the pte pointer to the caller introduces a potential race
>> condition. If the caller subsequently modifies the pte without re-
>> acquiring the spin lock, there's a risk of data corruption or
>> inconsistencies.
> 
> it appears that we are on the same page about if pte pointer needs to be
> protected or not. And I agree the modifications to the pte should be
> protected by iommu->lock. If so, will documenting that the caller must hold
> iommu->lock if is tries to modify the content of pte work? Also, it might
> be helpful to add lockdep to make sure all the modifications of pte entry
> are under protection.

People will soon forget about this lock and may modify the returned pte
pointer without locking, introducing a race condition silently.

> Or any suggestion from you given a path that needs to get pte first, check
> if it exists and then call intel_pasid_tear_down_entry(). For example the
> intel_pasid_setup_first_level() [1], in my series, I need to call the
> unlock iommu->lock and call intel_pasid_tear_down_entry() and then lock
> iommu->lock and do more modifications on the pasid entry. It would invoke
> the intel_pasid_get_entry() twice if no change to
> intel_pasid_tear_down_entry().

There is no need to check the present of a pte entry before calling into
intel_pasid_tear_down_entry(). The helper will return directly if the
pte is not present:

         spin_lock(&iommu->lock);
         pte = intel_pasid_get_entry(dev, pasid);
         if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
                 spin_unlock(&iommu->lock);
                 return;
         }

Does it work for you?

Thanks,
baolu

