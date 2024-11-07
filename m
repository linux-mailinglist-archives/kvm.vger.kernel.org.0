Return-Path: <kvm+bounces-31070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A149C003F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:42:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D709628394D
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 08:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDF01DC74A;
	Thu,  7 Nov 2024 08:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m8rsiAg3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6E11DC18F
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 08:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730968909; cv=none; b=k9u4njeRrmMavrqRRLfc6hgKq2gJ+NZTFmzSiRJj8blB0n/5SaFNcHm+dIJGBunqBSfqvAbhrlmY8dmwodEqB68HJWfbsJ3ATacoikyNR0YNoNguBSp9kkeySWjY1sQYs7+muNX9DzFqbsYSexvVsSlaeYZmaNlUhRVVOe7KRPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730968909; c=relaxed/simple;
	bh=pJ1VmzI/3WMEvExcYr9JjYKy52pmsKPnASWJVzWEgz4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OslZW0Aq8qbxSEqFyqCCD8BOm0496k0mK9qkOmfdH6D2Wv+UJJBUHG20m7+/Y2n6nzYsjWZ8smBVTJZUkgxf4e500fb6ObP4R0KxVS7GJfRCUz9rJfEdMA5afWwEKV+QvtrOWi4DbLLP6Wf4jV0FTfc594B4RBXsPQ9fXPyN5rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m8rsiAg3; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730968908; x=1762504908;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pJ1VmzI/3WMEvExcYr9JjYKy52pmsKPnASWJVzWEgz4=;
  b=m8rsiAg3FwMEqrlPBaaU3ZFBcRyD4+mrUNiveqh5cK2rbBskKJHEmrf4
   X5nZ8BBH8wNVwyTnSkNUcNEAfKsnsdwMX8NgaWE24ipod4Cg+2iZJDp2g
   ep2TSx8b1PtrvLF32fW/0Rdu6uNzBp3ANvIEGNEPju0gFSNCBaMqo7Kf4
   7o/yEnUT8PRUvKKQF85uTPyqdYCQ8op/AaezbvONvh9DUdA4i5w9UwEk5
   BFQktndgl32nXgfb8OiU+YSc227NUXQqoX/g9CiB7q4cFQwjgOOexE7OD
   twETCP2u/BRxAbkTB9G9B5hOm3qZ5IOml1NK1w1NMk0tKTuo68vNFPO5D
   Q==;
X-CSE-ConnectionGUID: BKZLENd8Su6U1VK7z27IbA==
X-CSE-MsgGUID: ObXMfhV0T/CtSKegkIZeEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="33641109"
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="33641109"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 00:41:47 -0800
X-CSE-ConnectionGUID: gpa/wdoGRjy/DlvYpthQhQ==
X-CSE-MsgGUID: hASZHu38R9Smlg9Gy6T2Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="85405887"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 00:41:43 -0800
Message-ID: <d7d1d655-2ddd-4867-a5c6-af50e280ec57@linux.intel.com>
Date: Thu, 7 Nov 2024 16:41:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
 "willy@infradead.org" <willy@infradead.org>
Subject: Re: [PATCH v5 04/13] iommu/vt-d: Add pasid replace helpers
To: Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
References: <20241106154606.9564-1-yi.l.liu@intel.com>
 <20241106154606.9564-5-yi.l.liu@intel.com>
 <268b3ac1-2ccf-4489-9358-889f01216b59@linux.intel.com>
 <8de3aafe-af94-493f-ab62-ef3e086c54da@intel.com>
 <BN9PR11MB5276EEA35FBEB68E4172F1958C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7d4cfaef-0b3e-449b-bda3-31e3eb8ab300@intel.com>
 <8d015a7d-fa64-4034-8bdb-fffb957c0025@linux.intel.com>
 <9cc98d30-6257-4d9c-8735-f1147bd1d966@intel.com>
 <27c2acfb-a428-486a-bd10-7d34a8cae4ed@linux.intel.com>
 <f73869de-38b1-41cf-bd20-d91523e4fd08@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <f73869de-38b1-41cf-bd20-d91523e4fd08@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/11/7 16:39, Yi Liu wrote:
> On 2024/11/7 16:04, Baolu Lu wrote:
>> On 2024/11/7 15:57, Yi Liu wrote:
>>> On 2024/11/7 14:53, Baolu Lu wrote:
>>>> On 2024/11/7 14:46, Yi Liu wrote:
>>>>> On 2024/11/7 13:46, Tian, Kevin wrote:
>>>>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>>>>> Sent: Thursday, November 7, 2024 12:21 PM
>>>>>>>
>>>>>>> On 2024/11/7 10:52, Baolu Lu wrote:
>>>>>>>> On 11/6/24 23:45, Yi Liu wrote:
>>>>>>>>> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
>>>>>>>>> +                    struct device *dev, pgd_t *pgd,
>>>>>>>>> +                    u32 pasid, u16 did, u16 old_did,
>>>>>>>>> +                    int flags)
>>>>>>>>> +{
>>>>>>>>> +    struct pasid_entry *pte;
>>>>>>>>> +
>>>>>>>>> +    if (!ecap_flts(iommu->ecap)) {
>>>>>>>>> +        pr_err("No first level translation support on %s\n",
>>>>>>>>> +               iommu->name);
>>>>>>>>> +        return -EINVAL;
>>>>>>>>> +    }
>>>>>>>>> +
>>>>>>>>> +    if ((flags & PASID_FLAG_FL5LP) && ! 
>>>>>>>>> cap_fl5lp_support(iommu- >cap)) {
>>>>>>>>> +        pr_err("No 5-level paging support for first-level on 
>>>>>>>>> %s\n",
>>>>>>>>> +               iommu->name);
>>>>>>>>> +        return -EINVAL;
>>>>>>>>> +    }
>>>>>>>>> +
>>>>>>>>> +    spin_lock(&iommu->lock);
>>>>>>>>> +    pte = intel_pasid_get_entry(dev, pasid);
>>>>>>>>> +    if (!pte) {
>>>>>>>>> +        spin_unlock(&iommu->lock);
>>>>>>>>> +        return -ENODEV;
>>>>>>>>> +    }
>>>>>>>>> +
>>>>>>>>> +    if (!pasid_pte_is_present(pte)) {
>>>>>>>>> +        spin_unlock(&iommu->lock);
>>>>>>>>> +        return -EINVAL;
>>>>>>>>> +    }
>>>>>>>>> +
>>>>>>>>> +    WARN_ON(old_did != pasid_get_domain_id(pte));
>>>>>>>>> +
>>>>>>>>> +    pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
>>>>>>>>> +    spin_unlock(&iommu->lock);
>>>>>>>>> +
>>>>>>>>> +    intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
>>>>>>>>> +    intel_iommu_drain_pasid_prq(dev, pasid);
>>>>>>>>> +
>>>>>>>>> +    return 0;
>>>>>>>>> +}
>>>>>>>>
>>>>>>>> pasid_pte_config_first_level() causes the pasid entry to 
>>>>>>>> transition from
>>>>>>>> present to non-present and then to present. In this case, calling
>>>>>>>> intel_pasid_flush_present() is not accurate, as it is only 
>>>>>>>> intended for
>>>>>>>> pasid entries transitioning from present to present, according 
>>>>>>>> to the
>>>>>>>> specification.
>>>>>>>>
>>>>>>>> It's recommended to move pasid_clear_entry(pte) and
>>>>>>>> pasid_set_present(pte) out to the caller, so ...
>>>>>>>>
>>>>>>>> For setup case (pasid from non-present to present):
>>>>>>>>
>>>>>>>> - pasid_clear_entry(pte)
>>>>>>>> - pasid_pte_config_first_level(pte)
>>>>>>>> - pasid_set_present(pte)
>>>>>>>> - cache invalidations
>>>>>>>>
>>>>>>>> For replace case (pasid from present to present)
>>>>>>>>
>>>>>>>> - pasid_pte_config_first_level(pte)
>>>>>>>> - cache invalidations
>>>>>>>>
>>>>>>>> The same applies to other types of setup and replace.
>>>>>>>
>>>>>>> hmmm. Here is the reason I did it in the way of this patch:
>>>>>>> 1) pasid_clear_entry() can clear all the fields that are not 
>>>>>>> supposed to
>>>>>>>      be used by the new domain. For example, converting a nested 
>>>>>>> domain to
>>>>>>> SS
>>>>>>>      only domain, if no pasid_clear_entry() then the FSPTR would 
>>>>>>> be there.
>>>>>>>      Although spec seems not enforce it, it might be good to 
>>>>>>> clear it.
>>>>>>> 2) We don't support atomic replace yet, so the whole pasid entry 
>>>>>>> transition
>>>>>>>      is not done in one shot, so it looks to be ok to do this 
>>>>>>> stepping
>>>>>>>      transition.
>>>>>>> 3) It seems to be even worse if keep the Present bit during the 
>>>>>>> transition.
>>>>>>>      The pasid entry might be broken while the Present bit 
>>>>>>> indicates this is
>>>>>>>      a valid pasid entry. Say if there is in-flight DMA, the 
>>>>>>> result may be
>>>>>>>      unpredictable.
>>>>>>>
>>>>>>> Based on the above, I chose the current way. But I admit if we 
>>>>>>> are going to
>>>>>>> support atomic replace, then we should refactor a bit. I believe 
>>>>>>> at that
>>>>>>> time we need to construct the new pasid entry first and try to 
>>>>>>> exchange it
>>>>>>> to the pasid table. I can see some transition can be done in that 
>>>>>>> way as we
>>>>>>> can do atomic exchange with 128bits. thoughts? 🙂
>>>>>>>
>>>>>>
>>>>>> yes 128bit cmpxchg is necessary to support atomic replacement.
>>>>>>
>>>>>> Actually vt-d spec clearly says so e.g. SSPTPTR/DID must be updated
>>>>>> together in a present entry to not break in-flight DMA.
>>>>>>
>>>>>> but... your current way (clear entry then update it) also break 
>>>>>> in- flight
>>>>>> DMA. So let's admit that as the 1st step it's not aimed to support
>>>>>> atomic replacement. With that Baolu's suggestion makes more sense
>>>>>> toward future extension with less refactoring required (otherwise
>>>>>> you should not use intel_pasid_flush_present() then the earlier
>>>>>> refactoring for that helper is also meaningless).
>>>>>
>>>>> I see. The pasid entry might have some filed that is not supposed 
>>>>> to be
>>>>> used after replacement. Should we have a comment about it?
>>>>
>>>> I guess all fields except SSADE and P of a pasid table entry should be
>>>> cleared in pasid_pte_config_first_level()?
>>>
>>> perhaps we can take one more step forward. We can construct the new 
>>> pte in a local variable first and then push it to the pte in the 
>>> pasid table. 🙂
>>>
>>
>> That sounds better! The entry is composed on the stack and then copied
>> over to the pasid table as a whole.
> 
> that's it. Like the below.

Looks good to me now.

