Return-Path: <kvm+bounces-29385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E729AA114
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E33B285FC2
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C558619C54F;
	Tue, 22 Oct 2024 11:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BPWLdONR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A02319B5AC
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 11:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729596243; cv=none; b=Z0M4J6t6JwBEZ0OR7pwf0mOCvMxMWyT4JjUUxKGX9HISg9MfkYMfyJWTBUTqrtpCIPNCjAozDFn57So37AHYQEXziuiIcbmevtcMg8pTr5sSA/PIfoMScPdH0WOdmlLXDFjtQAAJ4W7M8hoAA1/t3dbZd56ZBkEYA+K+TjiWNuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729596243; c=relaxed/simple;
	bh=aZ1FjAA3zutn9kIQtZLnBI173lME+dbSz5uR/w+7e34=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dPhAJJpW7EPbhelx5f7Jc5WRoqkQgpVFaR5LX+xK+GV/diX4yMOWNPCJLArwCr95/5A83nxgGumZ0pJzxpSPMi7exSnA/9GgjG1ZIPepI96MK5ISod+WijssE7lD3rv6KvPBkdi4FHylx/fDmInr5mGWoMktdEhqVuURJiBX394=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BPWLdONR; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729596241; x=1761132241;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aZ1FjAA3zutn9kIQtZLnBI173lME+dbSz5uR/w+7e34=;
  b=BPWLdONRU0Ubo8Ri76oJbM5aPDLG7c4Aujzeck9WzLKd8HxIYFUlpi1T
   up0RgBX83m19BxeEpCRNu3rL3jiYSt8+J++ISIRcue7taGVnuu0jjRkiR
   Z+yXjsNI0sHhcH+v4KKkYp6omucmGWbMRt/otAzMgKRcak5H8U/RP2xdS
   Y5N5gDkB+8ov1TK672cxmcFwFJFayGzQiPCO3hBgNzBlIyJwqkn8Z27F9
   Ev/7oAUQYSHiQ7cbTmxukIdpDTHaFaOsMh6IqxA0s/+IC6DOpLRfwpQHo
   g1JMd8NaKYSawjPem7iQkAeWayyNY9Jz/dVhieWX4ZCZRrKgxkpq1vJU+
   Q==;
X-CSE-ConnectionGUID: AcOpIGKlSo+G0Kj3l7OD5g==
X-CSE-MsgGUID: jh4yvXoXQeWyZjDZMLSCzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11232"; a="16753541"
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="16753541"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 04:24:01 -0700
X-CSE-ConnectionGUID: p+bxeUHtSgukwmWPvI0pVw==
X-CSE-MsgGUID: p7Kgxz3GRPavMGnAG9V2Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="79754928"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 04:23:57 -0700
Message-ID: <965fe7e8-9a23-48a7-a84d-819f0c330cde@linux.intel.com>
Date: Tue, 22 Oct 2024 19:23:54 +0800
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
 <9d726285-730a-400d-8d45-f494b2c62205@linux.intel.com>
 <fe88f071-0d06-4838-9ce6-a5bcccf10163@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <fe88f071-0d06-4838-9ce6-a5bcccf10163@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/10/22 17:38, Yi Liu wrote:
> On 2024/10/22 17:23, Baolu Lu wrote:
>> On 2024/10/21 15:24, Yi Liu wrote:
>>> On 2024/10/21 14:59, Baolu Lu wrote:
>>>> On 2024/10/21 14:35, Yi Liu wrote:
>>>>> On 2024/10/21 14:13, Baolu Lu wrote:
>>>>>> On 2024/10/18 13:53, Yi Liu wrote:
>>>>>>> intel_pasid_tear_down_entry() finds the pasid entry and tears it 
>>>>>>> down.
>>>>>>> There are paths that need to get the pasid entry, tear it down and
>>>>>>> re-configure it. Letting intel_pasid_tear_down_entry() return the 
>>>>>>> pasid
>>>>>>> entry can avoid duplicate codes to get the pasid entry. No 
>>>>>>> functional
>>>>>>> change is intended.
>>>>>>>
>>>>>>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>>>>>>> ---
>>>>>>>   drivers/iommu/intel/pasid.c | 11 ++++++++---
>>>>>>>   drivers/iommu/intel/pasid.h |  5 +++--
>>>>>>>   2 files changed, 11 insertions(+), 5 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/ 
>>>>>>> pasid.c
>>>>>>> index 2898e7af2cf4..336f9425214c 100644
>>>>>>> --- a/drivers/iommu/intel/pasid.c
>>>>>>> +++ b/drivers/iommu/intel/pasid.c
>>>>>>> @@ -239,9 +239,12 @@ devtlb_invalidation_with_pasid(struct 
>>>>>>> intel_iommu *iommu,
>>>>>>>   /*
>>>>>>>    * Caller can request to drain PRQ in this helper if it hasn't 
>>>>>>> done so,
>>>>>>>    * e.g. in a path which doesn't follow remove_dev_pasid().
>>>>>>> + * Return the pasid entry pointer if the entry is found or NULL 
>>>>>>> if no
>>>>>>> + * entry found.
>>>>>>>    */
>>>>>>> -void intel_pasid_tear_down_entry(struct intel_iommu *iommu, 
>>>>>>> struct device *dev,
>>>>>>> -                 u32 pasid, u32 flags)
>>>>>>> +struct pasid_entry *
>>>>>>> +intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct 
>>>>>>> device *dev,
>>>>>>> +                u32 pasid, u32 flags)
>>>>>>>   {
>>>>>>>       struct pasid_entry *pte;
>>>>>>>       u16 did, pgtt;
>>>>>>> @@ -250,7 +253,7 @@ void intel_pasid_tear_down_entry(struct 
>>>>>>> intel_iommu *iommu, struct device *dev,
>>>>>>>       pte = intel_pasid_get_entry(dev, pasid);
>>>>>>>       if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>>>>>>>           spin_unlock(&iommu->lock);
>>>>>>> -        return;
>>>>>>> +        goto out;
>>>>>>
>>>>>> The pasid table entry is protected by iommu->lock. It's  not 
>>>>>> reasonable
>>>>>> to return the pte pointer which is beyond the lock protected range.
>>>>>
>>>>> Per my understanding, the iommu->lock protects the content of the 
>>>>> entry,
>>>>> so the modifications to the entry need to hold it. While, it looks not
>>>>> necessary to protect the pasid entry pointer itself. The pasid 
>>>>> table should
>>>>> exist during device probe and release. is it?
>>>>
>>>> The pattern of the code that modifies a pasid table entry is,
>>>>
>>>>      spin_lock(&iommu->lock);
>>>>      pte = intel_pasid_get_entry(dev, pasid);
>>>>      ... modify the pasid table entry ...
>>>>      spin_unlock(&iommu->lock);
>>>>
>>>> Returning the pte pointer to the caller introduces a potential race
>>>> condition. If the caller subsequently modifies the pte without re-
>>>> acquiring the spin lock, there's a risk of data corruption or
>>>> inconsistencies.
>>>
>>> it appears that we are on the same page about if pte pointer needs to be
>>> protected or not. And I agree the modifications to the pte should be
>>> protected by iommu->lock. If so, will documenting that the caller 
>>> must hold
>>> iommu->lock if is tries to modify the content of pte work? Also, it 
>>> might
>>> be helpful to add lockdep to make sure all the modifications of pte 
>>> entry
>>> are under protection.
>>
>> People will soon forget about this lock and may modify the returned pte
>> pointer without locking, introducing a race condition silently.
>>
>>> Or any suggestion from you given a path that needs to get pte first, 
>>> check
>>> if it exists and then call intel_pasid_tear_down_entry(). For example 
>>> the
>>> intel_pasid_setup_first_level() [1], in my series, I need to call the
>>> unlock iommu->lock and call intel_pasid_tear_down_entry() and then lock
>>> iommu->lock and do more modifications on the pasid entry. It would 
>>> invoke
>>> the intel_pasid_get_entry() twice if no change to
>>> intel_pasid_tear_down_entry().
>>
>> There is no need to check the present of a pte entry before calling into
>> intel_pasid_tear_down_entry(). The helper will return directly if the
>> pte is not present:
>>
>>          spin_lock(&iommu->lock);
>>          pte = intel_pasid_get_entry(dev, pasid);
>>          if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>>                  spin_unlock(&iommu->lock);
>>                  return;
>>          }
>>
>> Does it work for you?
> 
> This is not I'm talking about. My intention is to avoid duplicated
> intel_pasid_get_entry() call when calling intel_pasid_tear_down_entry() in
> intel_pasid_setup_first_level(). Both the two functions call the
> intel_pasid_get_entry() to get pte pointer. So I think it might be good to
> save one of them.

Then, perhaps you can add a pasid_entry_tear_down() helper which asserts
iommu->lock and call it in both intel_pasid_tear_down_entry() and
intel_pasid_setup_first_level()?

Thanks,
baolu

