Return-Path: <kvm+bounces-16682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 176838BC87F
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:42:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 487521C20ACB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0E913F44F;
	Mon,  6 May 2024 07:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mJDdjNUv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AEA1EB36
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 07:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714981350; cv=none; b=RqTuttLsz47jpEQ6OjNO9YqYMB9GLuwh77nxjlkll30H5PXZgVWpBxZUtX/L7fGbdS1qqhxyXjuwaFrrFaCAJ6X0/gL09B4JYmFqdVo9D+AVadOoY1uYnZTgiQJS5wmEG84deiD2s2e4GWR1BDHbpfVVPjGlOD6sLmXSdlmlamU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714981350; c=relaxed/simple;
	bh=iHKO1qzhns2fF3u7KQYzVcb8QhFm4i6HTrDF0c5MQPk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nETQVl6vNmcf5pr1RHNge9DXf+PQkdYsn2cNG7AqC/J8Xk+hOQ0EOZhSzEfLqQCSOTPegjrZzVwNDQ/qx0XxmQLCK9YMPL5H9zSoZVrfTi0JfEGZdEmb56kyUgK1gHElpFcm0VtQ+bTtLlG/PbiMRUIZrA4o3jDWFowGo11GsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mJDdjNUv; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714981348; x=1746517348;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iHKO1qzhns2fF3u7KQYzVcb8QhFm4i6HTrDF0c5MQPk=;
  b=mJDdjNUv3Ls3KbQ2742tMc8BrCsaU5RVE7XmuRs380Zd+4xBr23DOXea
   Kc44Ba2Kb2RK5Cnidxs/Zx4+gdZGsSfF3adqbwi4Qqt6o3RK5wfxciXDp
   t/DsSQ3rd8VYwIgDMBaiN4+qxc5SFvYmpOqWYKHwBcJmDb36mrCyNI4oO
   +oRX6qiN/MYwj73ajzIdrp2VV4WlRK518891Ee2SiWmxxqRiX6ozxmWdz
   7H88NDmKVx4crq3lDDrdw+GWVFrW6/nvWpQbUuEAuLOy5OG6b6HahP2Fg
   D7XlbNXaxOBZmTB7n8oxUkTEXk+Ir9sLXeLnyJcyis/YkEhi+/q0F+Brt
   w==;
X-CSE-ConnectionGUID: F0vZjmFPRjG8M6VskU2XgQ==
X-CSE-MsgGUID: Q96almGKQpGTnmUq05DUuA==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="11249419"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="11249419"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 00:42:27 -0700
X-CSE-ConnectionGUID: pPqXQTQxT0iQdRXrEE8LaQ==
X-CSE-MsgGUID: FU75hEBKQSKFvFqwFPit3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="32889587"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.125.244.72]) ([10.125.244.72])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 00:42:24 -0700
Message-ID: <b4fe7b7c-d988-4c71-a34c-6e3806327b27@linux.intel.com>
Date: Mon, 6 May 2024 15:42:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
To: Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-13-yi.l.liu@intel.com>
 <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/4/30 17:19, Yi Liu wrote:
> On 2024/4/17 17:25, Tian, Kevin wrote:
>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>> Sent: Friday, April 12, 2024 4:15 PM
>>>
>>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>>
>>> This allows the upper layers to set a nested type domain to a PASID of a
>>> device if the PASID feature is supported by the IOMMU hardware.
>>>
>>> The set_dev_pasid callback for non-nested domain has already be 
>>> there, so
>>> this only needs to add it for nested domains. Note that the S2 domain 
>>> with
>>> dirty tracking capability is not supported yet as no user for now.
>>
>> S2 domain does support dirty tracking. Do you mean the specific
>> check in intel_iommu_set_dev_pasid() i.e. pasid-granular dirty
>> tracking is not supported yet?
> 
> yes. We may remove this check when real usage comes. e.g. SIOV.
> 
>>> +static int intel_nested_set_dev_pasid(struct iommu_domain *domain,
>>> +                      struct device *dev, ioasid_t pasid,
>>> +                      struct iommu_domain *old)
>>> +{
>>> +    struct device_domain_info *info = dev_iommu_priv_get(dev);
>>> +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>>> +    struct intel_iommu *iommu = info->iommu;
>>> +
>>> +    if (iommu->agaw < dmar_domain->s2_domain->agaw)
>>> +        return -EINVAL;
>>> +
>>
>> this check is covered by prepare_domain_attach_device() already.
> 
> This was added to avoid modifying the s2_domain's agaw. I'm fine to remove
> it personally as the existing attach path also needs to update domain's
> agaw per device attachment. @Baolu, how about your opinion?

We still need something to do before we can safely remove this check.
All the domain allocation interfaces should eventually have the device
pointer as the input, and all domain attributions could be initialized
during domain allocation. In the attach paths, it should return -EINVAL
directly if the domain is not compatible with the iommu for the device.

Best regards,
baolu

