Return-Path: <kvm+bounces-31362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44C259C30DF
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 05:22:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 744A51C206A8
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 04:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740A11482F6;
	Sun, 10 Nov 2024 04:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EbUfpwke"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4A41422B8
	for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 04:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731212529; cv=none; b=tWHi9+Gnwb7QijZuGb36B77uv1UYOP/fZZsaXHdrI3DnMK8UxumBjvkeAN8Z6+cycfSfcpt/DcjRryY7jcToAz6/fhz+fwqbFQaCzIjSkKvY3zsIMy7aomFfQCG6RbooNch5BdHGkuM6t/6VXVzhIoqwZw7Yvx9av826JIeLzwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731212529; c=relaxed/simple;
	bh=Cm5TVd6VQlBobuAKhNtEy2l/TI5QJc4INMnPDvdTiPg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=U+RrwRH8HCsSpU83LGukLqqpbEXb9LiZXrADsBB3RZQRiHEghzMQCR8YUbNDoisx8UvDtRo0y1AG9KE0utR+HGW5YiBH5R4rmvYGa6E8O1eNrOUkLeHGIfV8hY0bVNB5aT2DJD9soGBUNEeTv0Hf4Am/LNFTbE4K9QcoXHJawm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EbUfpwke; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731212528; x=1762748528;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=Cm5TVd6VQlBobuAKhNtEy2l/TI5QJc4INMnPDvdTiPg=;
  b=EbUfpwkecWFnMPG9mHq9LXCp8UEY6Yo0xZVDYbPakeGK2bZPfPLLVkmZ
   PbA8mmV/Lotf/cR4Hd0kCJf8ajzygTGjm5rTu8s0uz0aOlj0dYgPS8IQY
   g4YcRfAooLd/LjScBnXgkkgDBxAjXB/+fATjQn6ZMxH0k0cwYzl7DfgI/
   ufoO+tZ/N7jNRMmgMlw2KnXCKzF+9w6zkWJ+rX2wDGSQs6KYClJplb479
   YdDQ7iKGnWQvruSfRxOaC6/zXvekuVWl4jK0QdtIAr5LXBzuU7tMW6UGc
   0ZJZLTwp7g8n8ezw9QCbNV56rSLNemggFw/Hram9AJykPz0f+h7wvBFT0
   g==;
X-CSE-ConnectionGUID: HfbXB335Rw2FBDr7b0LQhA==
X-CSE-MsgGUID: rk/hybSzSLmkMm/T6ZniJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11251"; a="41676410"
X-IronPort-AV: E=Sophos;i="6.12,142,1728975600"; 
   d="scan'208";a="41676410"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2024 20:22:08 -0800
X-CSE-ConnectionGUID: S5zd6FXvTUO3vNBje+mWcA==
X-CSE-MsgGUID: lrNp4/ztRVWOkP2hGUgg6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,142,1728975600"; 
   d="scan'208";a="90208364"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2024 20:22:05 -0800
Message-ID: <0df1d7b2-5fa4-4635-a210-cd7c54270ef0@linux.intel.com>
Date: Sun, 10 Nov 2024 12:21:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] iommu: Detaching pasid by attaching to the
 blocked_domain
From: Baolu Lu <baolu.lu@linux.intel.com>
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, willy@infradead.org
References: <20241108120427.13562-1-yi.l.liu@intel.com>
 <20241108120427.13562-4-yi.l.liu@intel.com>
 <64e190bd-6d4a-4d43-b908-222e0bc766c5@linux.intel.com>
Content-Language: en-US
In-Reply-To: <64e190bd-6d4a-4d43-b908-222e0bc766c5@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/10/24 12:15, Baolu Lu wrote:
> On 11/8/24 20:04, Yi Liu wrote:
>> The iommu drivers are on the way to detach pasid by attaching to the 
>> blocked
>> domain. However, this cannot be done in one shot. During the 
>> transition, iommu
>> core would select between the remove_dev_pasid op and the blocked domain.
>>
>> Suggested-by: Kevin Tian<kevin.tian@intel.com>
>> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
>> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
>> Reviewed-by: Vasant Hegde<vasant.hegde@amd.com>
>> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/iommu.c | 16 ++++++++++++++--
>>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> 
> with a minor comment below
> 
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 819c6e0188d5..6fd4b904f270 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -3302,8 +3302,18 @@ static void iommu_remove_dev_pasid(struct 
>> device *dev, ioasid_t pasid,
>>                      struct iommu_domain *domain)
>>   {
>>       const struct iommu_ops *ops = dev_iommu_ops(dev);
>> +    struct iommu_domain *blocked_domain = ops->blocked_domain;
>> +    int ret = 1;
>> -    ops->remove_dev_pasid(dev, pasid, domain);
>> +    if (blocked_domain && blocked_domain->ops->set_dev_pasid) {
>> +        ret = blocked_domain->ops->set_dev_pasid(blocked_domain,
>> +                             dev, pasid, domain);
> 
> How about removing "ret" and just add a WARN_ON around the return of
> setting blocking domain?
> 
>      /* Driver should never fail to set a blocking domain. */
>      WARN_ON(blocked_domain->ops->set_dev_pasid(...));

I saw this in patch 7/7. So never mind about this.

--
baolu

