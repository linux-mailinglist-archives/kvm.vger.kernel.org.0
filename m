Return-Path: <kvm+bounces-3560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F109805394
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A829B20D5F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645FE59E4A;
	Tue,  5 Dec 2023 11:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MDAr5BS1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D0198;
	Tue,  5 Dec 2023 03:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701777349; x=1733313349;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=e3cGY29NO2TW5wcDKR/uxU5ISJOcURe7TpDGtZtP95Q=;
  b=MDAr5BS1LPykCRcsIlmHFRzoII+yWmkZXlJBlSM6cY2+hnTpZ/gTsKL/
   HXZlsNaUnrreZOW3BIGqJlm9CN0zo4xDbkmauIidS9+NWiOfKp25UVYxw
   lcs/SVl/pGKONKUWqmL2KuMSsZ2GLbzgp1n/ueWONHaw0H/WiPjKQU3He
   3sB/2lGX08vaZlwW/EgcpBNmRFPzhl30sUVo5BsGi3ko111uBL3F7eOEn
   OkppWhKUp3cM8Y/3NNUJdIsvWZXaZjcyynIx0uSSRJEqkM7WJ5FPcxT69
   4k1qmI4JPPFjedWAmuJrdMsqpreoG5Ovs4304Jx7E98BuxLybAXjNq7B7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="7180384"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="7180384"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 03:55:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="861717965"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="861717965"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.255.31.68]) ([10.255.31.68])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 03:55:42 -0800
Message-ID: <fb4b2617-4b8e-4f83-84c6-c5523591803f@linux.intel.com>
Date: Tue, 5 Dec 2023 19:55:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v7 03/12] iommu: Remove unrecoverable fault data
Content-Language: en-US
To: Yi Liu <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-4-baolu.lu@linux.intel.com>
 <50b9684c-e018-4e1c-9aac-67e0ffd9bc27@intel.com>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <50b9684c-e018-4e1c-9aac-67e0ffd9bc27@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2023/12/4 18:58, Yi Liu wrote:
> On 2023/11/15 11:02, Lu Baolu wrote:
>> The unrecoverable fault data is not used anywhere. Remove it to avoid
>> dead code.
>>
>> Suggested-by: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> ---
>>   include/linux/iommu.h | 70 +------------------------------------------
>>   1 file changed, 1 insertion(+), 69 deletions(-)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index c2e2225184cf..81eee1afec72 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -50,69 +50,9 @@ struct iommu_dma_cookie;
>>   /* Generic fault types, can be expanded IRQ remapping fault */
>>   enum iommu_fault_type {
>> -    IOMMU_FAULT_DMA_UNRECOV = 1,    /* unrecoverable fault */
>>       IOMMU_FAULT_PAGE_REQ,        /* page request fault */
> 
> a nit, do you kno why this enum was starting from 1? Should it still
> start from 1 after deleting UNRECOV?

As Jason suggested in another thread, we will address this issue in
another thread. I am not sure for now whether we will remove the fault
type field or re-use the previous scheme.

Best regards,
baolu

