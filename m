Return-Path: <kvm+bounces-29456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6530C9ABAD6
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 03:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE40AB221D8
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 01:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7026E200CB;
	Wed, 23 Oct 2024 01:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oGCBtc9z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A60912B73
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 01:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729645836; cv=none; b=E0gt+dnhW5ufJLdD3Qn3Ck7a0fMsGxO16n588nQaeAiCrmLDPrxgyS43mFBXzdAUQjssvy7h7v/vPjZ6vnStOAZZpRXaaWOxyR3GwPC8PbCBKjefZjKIKz3qtu0wMFMO+4CpGFrzldKxma80D6/wU6n6ycbjaEbeO6qA6uMX3c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729645836; c=relaxed/simple;
	bh=ag84I7dGOv3bQ8TTSJOqJgpoxA5sD+5ecTqpuh9qc9o=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=M4muk5swAXlRDIlqp2NNLjBUa95haAERjpH0tUj6jf4VekqMEB97hs3/5xmOdUOme8FJ85gz8FHqONjmy7e0SY8gzNcRGIkVrXiH6/ppDUhetFLdRqhSFhcseC8VdwwBJP2yi+RUGr5XbH8O4IEZm+8OHi9fMZxpfnR3NQmMvTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oGCBtc9z; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729645835; x=1761181835;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ag84I7dGOv3bQ8TTSJOqJgpoxA5sD+5ecTqpuh9qc9o=;
  b=oGCBtc9zUK56wyvzMHmf7Wp0VQcZBfXmTuoVNqUmd4bHq8p3DjQtHtDU
   O7x5LRJsVlDQh7Jzn87PkSetHv0s8YSbfbZLr42JFRAtPMMm75bCJJTdH
   nga5aDETW0UWbF8SvWZhn0y912Jpvtlf6HXqlFcP85Q7MP1jiwTuFvOkT
   fWyBoZQ6hqrqp+NgzOs7Z0ndqCkVQhdyQtt1Xz8km0q/g4DMTSy2dB4BC
   VkxqGxN4sWAXXdrWokpEebVcq/uixE254xy1aA6Jzy3Wzg+MP9Wn856xA
   CjLNwLgav0f3+iUrVk/TJimcCGZ2sgoMdxuigWxzbnLKNUUq/bJC5KCxt
   g==;
X-CSE-ConnectionGUID: 8mRJ0JQBTDKpUaOAYtRR6Q==
X-CSE-MsgGUID: MMbQPi5oSYCOJ9w2K1yfEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11233"; a="29315815"
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="29315815"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 18:10:34 -0700
X-CSE-ConnectionGUID: 1xc3ISuBSSmAX80S+HSpUw==
X-CSE-MsgGUID: oMRX30oNSQiEnH1nM22xgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="79615839"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 18:10:31 -0700
Message-ID: <ae7e0ce3-8e8a-4c8c-8107-8074692dd12a@linux.intel.com>
Date: Wed, 23 Oct 2024 09:10:28 +0800
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
 <965fe7e8-9a23-48a7-a84d-819f0c330cde@linux.intel.com>
 <2f83a298-8212-4d7b-8fa8-b03c939e054b@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <2f83a298-8212-4d7b-8fa8-b03c939e054b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/10/22 21:25, Yi Liu wrote:
>>>>> Or any suggestion from you given a path that needs to get pte 
>>>>> first, check
>>>>> if it exists and then call intel_pasid_tear_down_entry(). For 
>>>>> example the
>>>>> intel_pasid_setup_first_level() [1], in my series, I need to call the
>>>>> unlock iommu->lock and call intel_pasid_tear_down_entry() and then 
>>>>> lock
>>>>> iommu->lock and do more modifications on the pasid entry. It would 
>>>>> invoke
>>>>> the intel_pasid_get_entry() twice if no change to
>>>>> intel_pasid_tear_down_entry().
>>>>
>>>> There is no need to check the present of a pte entry before calling 
>>>> into
>>>> intel_pasid_tear_down_entry(). The helper will return directly if the
>>>> pte is not present:
>>>>
>>>>          spin_lock(&iommu->lock);
>>>>          pte = intel_pasid_get_entry(dev, pasid);
>>>>          if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>>>>                  spin_unlock(&iommu->lock);
>>>>                  return;
>>>>          }
>>>>
>>>> Does it work for you?
>>>
>>> This is not I'm talking about. My intention is to avoid duplicated
>>> intel_pasid_get_entry() call when calling 
>>> intel_pasid_tear_down_entry() in
>>> intel_pasid_setup_first_level(). Both the two functions call the
>>> intel_pasid_get_entry() to get pte pointer. So I think it might be 
>>> good to
>>> save one of them.
>>
>> Then, perhaps you can add a pasid_entry_tear_down() helper which asserts
>> iommu->lock and call it in both intel_pasid_tear_down_entry() and
>> intel_pasid_setup_first_level()?
> 
> hmmm. I still have a doubt. Only part of the intel_pasid_tear_down_entry()
> holds the iommu->lock. I'm afraid it's uneasy to split the
> intel_pasid_tear_down_entry() without letting the cache flush code under
> the iommu->lock. But it seems unnecessary to do cache flush under the
> iommu->lock. What about your thought? or am I getting you correctly?
> Also, I suppose this split allows the caller of the new
 > pasid_entry_tear_down() helper to pass in the pte pointer. is it?

Okay, so you want to implement a "replace" on a PASID. I think there are
two ways to achieve this. First, we can transition the PASID to the
blocking state and then replace it with a new translation. Second, we
can implement a native replacement by directly modifying the present
PASID entry.

For the first solution, we could do something like this:

	/* blocking the translation on the PASID */
	intel_pasid_tear_down_entry(dev, pasid);
	... ...
	/* setup the new domain on the PASID */
	ret = intel_pasid_setup_first_level(domain, dev, pasid);
	if (ret)
		intel_pasid_setup_first_level(old_domain, dev, pasid);

For the second solution, we need to implement a new helper function,
intel_pasid_replace_first_level(), and use it like this:

	ret = intel_pasid_replace_first_level(domain, dev, pasid);

The PASID entry remains unchanged if an error occurs.

I don't see a need of refactoring current PASID tear_down and setup
helpers.

Thanks,
baolu

