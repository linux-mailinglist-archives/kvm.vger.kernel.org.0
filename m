Return-Path: <kvm+bounces-30919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1245C9BE538
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:08:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD03E1F23FE2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8813A1DE4C7;
	Wed,  6 Nov 2024 11:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wx86QA4e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3107018C00E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 11:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730891293; cv=none; b=HHkPEND9DnNoGCsq4qIU3T8LWuQk71DUUwOdlSkeeem+Gxf2T82vX/28y1i0ml7aHhRmdi1l9nBgLcGAWjOcSWH6wiFVEHjE6dJfVt2g7QsJhNZyvvWCgXlURkUtM09FZ0Ay1h8KH48wTuzvPYcW3vReAA6oqCDHFwV56joMv8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730891293; c=relaxed/simple;
	bh=VOcBw+3dHsIAseOara37nydQhrD0Hei+YAPZTmBJqHk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=s8bmIwki4xN+/WbH0mCHs82PIrG5F0Pw6vdJlzAeq2PE1bIQhT+VmZV6Q5dg58sy6SQgzSELiLZ3PjGIE8KR/L+AjZPHauIL2gHPv+0vZARYy+snH3TSLEgyjls7FVeVtWXljwEWOK4iamcMVC1KWtmA8aO1OR1+SAnFNjXA6+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wx86QA4e; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730891292; x=1762427292;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VOcBw+3dHsIAseOara37nydQhrD0Hei+YAPZTmBJqHk=;
  b=Wx86QA4eSB0CpiWzHGLi7EMGk5RA0IS+cShBFWjjaKKluZDnuRZa6cjX
   51+A+ndt7fiX8iNyeWrmVCQlz2jtl7FNd1MuGPuzhu87o+AgtRru5wd5d
   h+Fr9OyVWTmf9TnhoyeEZ1t54cD2DeBwzqxzcy7cdLDg9BYtCygLA5KtT
   Uz9D0Rpcz1a1yJyLMk1qdtcQpHa+ltu/SZKVJjo94/GHxLfYnvCvXaP+H
   c9cKICQl2wG92C5z5xPoZDbOCiozRNIGjprvRttMr6GtMB6qXo69d7+VE
   jSBIP4LKaY7dETlUryKVYqp8TuQeMP5XftEZtb6QhG+w8hMcq1/N0mfo9
   A==;
X-CSE-ConnectionGUID: a+pdv4mSQFSIcPnskL55rA==
X-CSE-MsgGUID: i1nO8ZexT1y5xEjKX3IXEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41230236"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41230236"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 03:08:12 -0800
X-CSE-ConnectionGUID: SFZtp3WITWGSlN2HGXqtwQ==
X-CSE-MsgGUID: C4aoCO7RS6CUg1ol5MbrAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="115306148"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 03:08:09 -0800
Message-ID: <b25df119-5bd9-4e72-8c5a-75bb073f1b8a@linux.intel.com>
Date: Wed, 6 Nov 2024 19:08:06 +0800
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
Subject: Re: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
To: Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-12-yi.l.liu@intel.com>
 <BN9PR11MB5276F52B50577B8963A20BEB8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <778d4e7b-cb4f-48d6-9b5d-de5e18c1a367@linux.intel.com>
 <982f10e2-5fc7-4b13-9877-77042ce20a11@intel.com>
 <ae559732-1586-4099-a753-092fc7a698cf@linux.intel.com>
 <348f3139-1ca7-4893-b93a-90c7834ce30b@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <348f3139-1ca7-4893-b93a-90c7834ce30b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/11/6 19:00, Yi Liu wrote:
> On 2024/11/6 18:45, Baolu Lu wrote:
>> On 2024/11/6 17:14, Yi Liu wrote:
>>> On 2024/11/6 16:41, Baolu Lu wrote:
>>>> On 2024/11/6 16:17, Tian, Kevin wrote:
>>>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>>>> Sent: Monday, November 4, 2024 9:19 PM
>>>>>>
>>>>>> +
>>>>>> +    dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
>>>>>> +    if (IS_ERR(dev_pasid))
>>>>>> +        return PTR_ERR(dev_pasid);
>>>>>> +
>>>>>> +    ret = domain_setup_nested(iommu, dmar_domain, dev, pasid, old);
>>>>>> +    if (ret)
>>>>>> +        goto out_remove_dev_pasid;
>>>>>> +
>>>>>> +    domain_remove_dev_pasid(old, dev, pasid);
>>>>>> +
>>>>>
>>>>> forgot one thing. Why not required to create a debugfs entry for
>>>>> nested dev_pasid?
>>>>
>>>> This debugfs node is only created for paging domain.
>>>
>>> I think Kevin got one point. The debugfs is added when paging domain
>>> is attached. How about the paging domains that is only used as nested
>>> parent domain. We seem to lack a debugfs node for such paging domains.
>>
>> Are you talking about the nested parent domain? It's also a paging
>> domain, hence a debugfs node will be created.
> 
> yes, nested parent domains. But as I mentioned, the debugfs node is created
> only in the attach point so far. While the nested attach does not attach
> the nested parent, it is subjected to the paging_domain_compatible()
> check and contributes its pgd to act as SS page table in the pasid entry.
> So it's missed though it should be in another patch to add it.

I see. Thanks!

