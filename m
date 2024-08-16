Return-Path: <kvm+bounces-24337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05182953FD5
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 04:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A48231F24865
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 02:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C594F20E;
	Fri, 16 Aug 2024 02:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e4zm0KHb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262332C1BA
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 02:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723776792; cv=none; b=QT9rejJNWIOIsn8OQOMD5y4QtJj6ZowrAqG/YWLFsEkeHkk3BSCUDeBC4qI0QBiFAo+YDR/yQpuDK/76kSgZPe6B6km/x2KiscHJSTLAO/LRrM6FvJF3sLxjafRZ6v0Bqbuig4Ipbixhh5DLSL/Un3RUcuTvbCqKagDWhRvVHr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723776792; c=relaxed/simple;
	bh=i84QddIjngCTFCPwR/mFBzMs3YXGyH7E24SK8Jeqt84=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aln5QiucUZGoy2zOLWlEeEJ+qpIFiXRvgY+NcZOdXDb3oA6YdsaPfn+29NWk8IkwaZofKAZaXDaTzogT2PqlzkmO8m1ZDZWX+X4pPyNSTZeGQoS5qgV949T8F/i8bf+Ojm9kZGnGnR6eVVilGSIV4JMh38rSlz+t/7ThcDkhZ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e4zm0KHb; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723776790; x=1755312790;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i84QddIjngCTFCPwR/mFBzMs3YXGyH7E24SK8Jeqt84=;
  b=e4zm0KHbPADMpo5IZWGIBjJvnWc43VeTlanwSGvUA5LAkDqEVhwvYJvq
   zzFrCIqDfD/U0HFr+V6yNDIbHn0icXpb/HIKwXSdjhRyDFaqbsL5WZmGD
   Z2dp8HnUDOyoTmvvqls3rYRPWRNjExuCmmvAx+IiFP1ywabLWKBeLu1DT
   yD2ccvUQi3tNgvGKZ9QefvnpiKpLEigH4n92d92mkXJnp4NA/ucl13tHr
   N1cAJf75JxM2nYQlH63vy2QiG8uYu22MK6FdRRLz006EKn3zAn4pSDU5B
   qLMi/IO83pQJdrwAcaD6rvsjA+/+CrcDXOyoEYLw7Ul/kVACLZiNtsaJI
   Q==;
X-CSE-ConnectionGUID: SiUIYr98RgSaMFlUxFhFLA==
X-CSE-MsgGUID: 9OpfZk5OSDCFrl3fJJkgbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="22205813"
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="22205813"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 19:53:10 -0700
X-CSE-ConnectionGUID: FWgAFBgaR9O/TPuefS+8vw==
X-CSE-MsgGUID: H+pdqzH+QRysxSM5bWqXjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="59554224"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmviesa008.fm.intel.com with ESMTP; 15 Aug 2024 19:53:07 -0700
Message-ID: <e15b1162-dcdc-4bcf-ab61-79400dba87c3@linux.intel.com>
Date: Fri, 16 Aug 2024 10:49:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, alex.williamson@redhat.com,
 robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
To: Yi Liu <yi.l.liu@intel.com>, Vasant Hegde <vasant.hegde@amd.com>,
 joro@8bytes.org, jgg@nvidia.com, kevin.tian@intel.com
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <99f66c8d-57cf-4f0d-8545-b019dcf78a94@amd.com>
 <06f5fc87-b414-4266-a17a-cb2b86111e7a@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <06f5fc87-b414-4266-a17a-cb2b86111e7a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/24 9:19 AM, Yi Liu wrote:
> On 2024/8/16 01:49, Vasant Hegde wrote:
>> Hi All,
>>
>> On 6/28/2024 2:25 PM, Yi Liu wrote:
>>> This splits the preparation works of the iommu and the Intel iommu 
>>> driver
>>> out from the iommufd pasid attach/replace series. [1]
>>>
>>> To support domain replacement, the definition of the set_dev_pasid op
>>> needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
>>> should be extended as well to suit the new definition.
>>
>> IIUC this will remove PASID from old SVA domain and attaches to new 
>> SVA domain.
>> (basically attaching same dev/PASID to different process). Is that the 
>> correct?
> 
> In brief, yes. But it's not only for SVA domain. Remember that SIOVr1
> extends the usage of PASID. At least on Intel side, a PASID may be
> attached to paging domains.

You are correct.

The idxd driver attaches a paging domain to a non-zero PASID for kernel
DMA with PASID. From an architectural perspective, other architectures,
like ARM, AMD, and RISC-V, also support this. Therefore, attaching a
paging domain to a PASID is not Intel-specific but a generic feature.

Thanks,
baolu

