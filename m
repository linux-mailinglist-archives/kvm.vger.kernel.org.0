Return-Path: <kvm+bounces-7007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2847E83C101
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 12:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC2671F230BB
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 11:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA754502E;
	Thu, 25 Jan 2024 11:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nhJuwrJd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF2741744;
	Thu, 25 Jan 2024 11:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706182433; cv=none; b=m+DSsTj2DVsjYZpp439MrkG8N5VUykw77cVpZTHsYR81c+u8ZHarDPGEl8CBfVCX9+cJvszReh7Zus2oP6LduRt4goSep6CUlI8lOUC1CS9maC03iLurSS/4Dy9tCGo/O450LMQqAQJr85GE4tHTTgv3GBEZZVgA62k3D2RMQj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706182433; c=relaxed/simple;
	bh=79Mq1ZnJKV7PdAzDq1uAOf2d4SKGw7H6Dm+xZXHOOqE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Pc43VlgjyeVpoKOSJfcrgkLD+PmwjZPGoj4gibI4vSKByLVtPzrXBx+RF3HoDVLXIi7Csq9NK/Bn46jQKzi9/zwbgkYCLlRUq1xjzy36op0ndwEKkc2z7WQ8EeyEZ5gwdoi1IEkHE7k2JAe2v26MZ14dg1NYxhL8g68OIMPwp7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nhJuwrJd; arc=none smtp.client-ip=134.134.136.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706182431; x=1737718431;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=79Mq1ZnJKV7PdAzDq1uAOf2d4SKGw7H6Dm+xZXHOOqE=;
  b=nhJuwrJdsU713Jl1UIncjJN3HsklP8Y9fDia76D/AWQeQkE/JTU8CQZh
   DLsaqg6ZwDijf2LkWeUT2C0gmGYOMEliz1379ZF+lQrKUIFs9hAQJXlJx
   F22qULgIpOUbBi7kUJRDuLMNG9a0k1ZwfmLpGDsmOUe5ngbuO9PXI6FDX
   dH/2DfsGRWrpLV+YtbyIkGmfxcL2v8MkAWVpL2T+ZcV9MidjsPbBcEQdp
   2RNEQzqgimw8PHVoJEJuBVU9CT5uxMhbpfpguttCagrPUdW5K7vj/vx3v
   PEbo6yuJg0YM6dTh+uqyO/cUpL1zW4LgU2nR6E35+7XGI6/mgZq5r/XzN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="466417296"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="466417296"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 03:33:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2385166"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.209.226]) ([10.254.209.226])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 03:33:47 -0800
Message-ID: <cf1319f7-b91b-4161-8b62-2b0c03f53c16@linux.intel.com>
Date: Thu, 25 Jan 2024 19:33:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v10 04/16] iommu: Cleanup iopf data structure definitions
Content-Language: en-US
To: Joel Granados <j.granados@samsung.com>
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
 <20240122054308.23901-5-baolu.lu@linux.intel.com>
 <CGME20240125102328eucas1p288a2c65df13b1f60d60f363447bb8e5c@eucas1p2.samsung.com>
 <20240125102326.rgos2wizh273rteq@localhost>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240125102326.rgos2wizh273rteq@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/1/25 18:23, Joel Granados wrote:
>> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
>> index e5b8b9110c13..24b5545352ae 100644
>> --- a/drivers/iommu/io-pgfault.c
>> +++ b/drivers/iommu/io-pgfault.c
>> @@ -56,7 +56,6 @@ static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
>>   			       enum iommu_page_response_code status)
>>   {
>>   	struct iommu_page_response resp = {
>> -		.version		= IOMMU_PAGE_RESP_VERSION_1,
>>   		.pasid			= iopf->fault.prm.pasid,
>>   		.grpid			= iopf->fault.prm.grpid,
>>   		.code			= status,
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 68e648b55767..b88dc3e0595c 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -1494,10 +1494,6 @@ int iommu_page_response(struct device *dev,
>>   	if (!param || !param->fault_param)
>>   		return -EINVAL;
>>   
>> -	if (msg->version != IOMMU_PAGE_RESP_VERSION_1 ||
>> -	    msg->flags & ~IOMMU_PAGE_RESP_PASID_VALID)
>> -		return -EINVAL;
>> -
> I see that this function `iommu_page_response` eventually lands in
> drivers/iommu/io-pgfault.c as `iopf_group_response`. But it seems that
> the check for IOMMU_PAGE_RESP_PASID_VALID is dropped.
> 
> I see that after applying [1] and [2] there are only three places where
> IOMMU_PAGE_RESP_PASID_VALID appears in the code: One is the definition
> and the other two are just setting the value. We effectively dropped the

Yes, really. Thanks for pointing this out.

$ git grep IOMMU_PAGE_RESP_PASID_VALID
drivers/iommu/io-pgfault.c:             resp.flags = 
IOMMU_PAGE_RESP_PASID_VALID;
drivers/iommu/io-pgfault.c:                     resp.flags = 
IOMMU_PAGE_RESP_PASID_VALID;
include/linux/iommu.h:#define IOMMU_PAGE_RESP_PASID_VALID       (1 << 0)

> check. Is the drop intended? and if so, should we just get rid of
> IOMMU_PAGE_RESP_PASID_VALID?

In my opinion, we should keep this hardware detail in the individual
driver. When the page fault handling framework in IOMMU and IOMMUFD
subsystems includes a valid PASID in the fault message, the response
message should also contain the *same* PASID value. Individual drivers
should be responsible for deciding whether to include the PASID in the
messages they provide for the hardware.

> 
> Best
> 
> [1]https://lore.kernel.org/all/20240122054308.23901-1-baolu.lu@linux.intel.com
> [2]https://lore.kernel.org/all/20240122073903.24406-1-baolu.lu@linux.intel.com

Best regards,
baolu

