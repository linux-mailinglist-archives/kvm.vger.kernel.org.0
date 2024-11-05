Return-Path: <kvm+bounces-30621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 313C29BC4D7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA5A8B21B46
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0351C07D9;
	Tue,  5 Nov 2024 05:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OPqBIXXQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DE03C38
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730785567; cv=none; b=pC8jQqq2p1jmCzkd5Zvkpy4rDCOdrslXq0Q4x2ev+pa7dfgDxEyQfoes6vtN61KvsjONnvjH/zvg1lau6UDm3dMUQQoPvpi/CO3vv+LcG4s0cSyOl4OZlI5YGPniFeUgqWqVKWcgw7EbSpJgfQtAU5kY+96zUcqCti9hRkwO38c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730785567; c=relaxed/simple;
	bh=n9HFrIuS0BnFwnxReDtoLbpLUxOCkv4ucFZ6Od1vwcg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZEGe2VXsQrVHikB/t8dnwlT9qVPn7beu1D6QaSVa6lm2qmcueR8pjYDA/Ux4wy8da+coe502soSjFrYViYLrfe1QxbEUh9B5mMH+4VRCfuVbcXGRlXF9ZSBmLAPXQeh24o1aS55xrNZqL2RuOviRWJFKnOxEwUnng9X/Q2FHtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OPqBIXXQ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730785565; x=1762321565;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n9HFrIuS0BnFwnxReDtoLbpLUxOCkv4ucFZ6Od1vwcg=;
  b=OPqBIXXQ5nQfwj3s/pMgkNoEhTAEIkBzOuBbZbuCQIQWW6Lake8537xG
   L7EtKqFlJwZZJXYeMuYzSPCDuqBmTXlfNxsMqs1GKNSNlbjbbnqeWt8HB
   pS7KW7CmfZ/UVxYtS2qhqjCvCvA4S9H3iav7637HAaUsvdawRnZot8mbR
   8tLiOWyEY/tcwh8JbxJkvJZNkY72DZMivGWAUx4pmbsykSu/bS8I2KyB6
   c9u7wkNG17bKK2z3EEHBKDCbB0MdaORK5jQ8V5ln0kZU1PBQv6btqRj4s
   aTyxJrIT0B5GhgGQMc0t5aBtBosG5vgc5OUQdajEIFeOmnlHFDz2pUVhs
   Q==;
X-CSE-ConnectionGUID: dNJPzdQITXqI9t3dxer2zA==
X-CSE-MsgGUID: 56CGXK2UTcStyUcFFX2UmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30738031"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="30738031"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:46:04 -0800
X-CSE-ConnectionGUID: VmEvy1OOS+eYBgNY3wXvAg==
X-CSE-MsgGUID: Ii6fkVZTTYmHS6ytPFj+Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="88635690"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:46:01 -0800
Message-ID: <1349c2c7-f3e8-4538-b23e-8c0b3d441a11@linux.intel.com>
Date: Tue, 5 Nov 2024 13:45:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] iommu/vt-d: Make the blocked domain support PASID
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-6-yi.l.liu@intel.com>
 <557b9c59-1ecb-485a-9e36-c926180a199b@linux.intel.com>
 <421c5022-eeef-42b4-b173-63e52d6f4361@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <421c5022-eeef-42b4-b173-63e52d6f4361@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/24 13:11, Yi Liu wrote:
> On 2024/11/5 11:46, Baolu Lu wrote:
>> On 11/4/24 21:20, Yi Liu wrote:
>>> @@ -4291,15 +4296,18 @@ void domain_remove_dev_pasid(struct 
>>> iommu_domain *domain,
>>>       kfree(dev_pasid);
>>>   }
>>> -static void intel_iommu_remove_dev_pasid(struct device *dev, 
>>> ioasid_t pasid,
>>> -                     struct iommu_domain *domain)
>>> +static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
>>> +                     struct device *dev, ioasid_t pasid,
>>> +                     struct iommu_domain *old)
>>>   {
>>>       struct device_domain_info *info = dev_iommu_priv_get(dev);
>>>       struct intel_iommu *iommu = info->iommu;
>>>       intel_pasid_tear_down_entry(iommu, dev, pasid, false);
>>>       intel_drain_pasid_prq(dev, pasid);
>>> -    domain_remove_dev_pasid(domain, dev, pasid);
>>> +    domain_remove_dev_pasid(old, dev, pasid);
>>> +
>>> +    return 0;
>>>   }
>>>   struct dev_pasid_info *
>>> @@ -4664,7 +4672,6 @@ const struct iommu_ops intel_iommu_ops = {
>>>       .dev_disable_feat    = intel_iommu_dev_disable_feat,
>>>       .is_attach_deferred    = intel_iommu_is_attach_deferred,
>>>       .def_domain_type    = device_def_domain_type,
>>> -    .remove_dev_pasid    = intel_iommu_remove_dev_pasid,
>>
>> This will cause iommu_attach_device_pasid() to fail due to the check and
>> failure condition introduced in patch 1/7.
> 
> the check introduced in patch 1 were enhanced in patch 3. So removing
> remove_dev_pasid op does not fail as intel iommu driver provides
> blocked domain which has the set_dev_pasid op.
> 

Okay, I see. Thanks!

