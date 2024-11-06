Return-Path: <kvm+bounces-30872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB9D9BE12B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:39:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF999B227B9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE667FBAC;
	Wed,  6 Nov 2024 08:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dINt2q7A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117AD199243
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882357; cv=none; b=k/A5fAow3f72p/YEsK8fxNnejnOUzVC8pk0JRiBIvE0g9Pj8hmcQ7Siz8/RkFpdmTWo98QZ7qgWd0TbwriOmuxtKuAxbg11JF6BQOexlO5a5vrhLSWBldSc02c2he/5emjOb00kS9y+w8aieWNh87dTMcNYPa0tO/vVPGF3+qRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882357; c=relaxed/simple;
	bh=o1eaAKP0q0OP2r3SIEN4yXE0MkgX6WCPxtaq68fETkU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pM+Xs4UbOQbPfGEX0024yjiwnzFx2mBaJ/BkvUj74qESecrtrEHISMPQ6KIwn4/soPuIrUV2bJvcd0L95nYofduGreiB8bhiKgwQjD2q5ZQdCI37FVTAXG2Iz0XXlDehp2jJ6Yi2LGvUQqP0mznyg19hJ37vq7ZeMNhEByXjAc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dINt2q7A; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730882356; x=1762418356;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o1eaAKP0q0OP2r3SIEN4yXE0MkgX6WCPxtaq68fETkU=;
  b=dINt2q7AuKCoxWd3RWHChgqCX4yetbrB4qbbHerRcFiEj9xGGjFyUUpA
   2Ub8JX8KpVo8OnELAhT7zcbjYXw1PmVg9ixli659LmnTzAdDZxj0pibJw
   PDoVjk0ylG1D4rSbdG8H0p8ZDQ3GoibZEm9QEZkyq5ZV3Y6Mc9W26YiOX
   exW6k6un9EtJtUZLo+aihwkbPZrzWDbOCGblb056PgiNxj8XI91p4tQdV
   opErZWj7/TAsQxSW6qItt/wE8The2c0kAbFY3uOO0vvljZUvevVKwSKVx
   t6nd/PE42kr+01db/OtHUsJ+8Xm2IRMnMR6G87kg5F4PPNV29fcemmwuW
   A==;
X-CSE-ConnectionGUID: oJCLInd4T4qHxPkzgdjYYQ==
X-CSE-MsgGUID: FdO/yBh/QqqKwUoGc1nrlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30552695"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30552695"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:39:15 -0800
X-CSE-ConnectionGUID: 8AOAmdFaS2mKhTbQPB2A3Q==
X-CSE-MsgGUID: TcQlq8rqQu2b37SjD1BVfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84536789"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:39:12 -0800
Message-ID: <c47a9f3a-cb36-499a-a788-c84a14cb4f48@linux.intel.com>
Date: Wed, 6 Nov 2024 16:39:10 +0800
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
 "will@kernel.org" <will@kernel.org>
Subject: Re: [PATCH v4 05/13] iommu/vt-d: Prepare intel_iommu_set_dev_pasid()
 handle replacement
To: Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-6-yi.l.liu@intel.com>
 <BN9PR11MB52769400A082C0CE51B48EA98C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <9e00e062-6a05-4658-84fb-1ac5f2502bd9@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <9e00e062-6a05-4658-84fb-1ac5f2502bd9@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/11/6 16:02, Yi Liu wrote:
>>> @@ -4329,24 +4368,17 @@ static int intel_iommu_set_dev_pasid(struct
>>> iommu_domain *domain,
>>>           ret = intel_pasid_setup_second_level(iommu, dmar_domain,
>>>                                dev, pasid);
>>>       if (ret)
>>> -        goto out_unassign_tag;
>>> +        goto out_remove_dev_pasid;
>>>
>>> -    dev_pasid->dev = dev;
>>> -    dev_pasid->pasid = pasid;
>>> -    spin_lock_irqsave(&dmar_domain->lock, flags);
>>> -    list_add(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
>>> -    spin_unlock_irqrestore(&dmar_domain->lock, flags);
>>> +    domain_remove_dev_pasid(old, dev, pasid);
>>
>> My preference is moving the check of non-NULL old out here.
> 
> @Baolu, how about your thought?

If we move the check out of this helper, there will be boilerplate code
in multiple places. Something like,

	if (old)
		domain_remove_dev_pasid(old, dev, pasid);

--
baolu

