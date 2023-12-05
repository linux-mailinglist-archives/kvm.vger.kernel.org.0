Return-Path: <kvm+bounces-3564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D5AEB8053D6
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56865B20C69
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58305B1E9;
	Tue,  5 Dec 2023 12:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n24yWAoH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4694EA7;
	Tue,  5 Dec 2023 04:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701778168; x=1733314168;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Dn/M9F9sxfkXiA0xOpEAl/WusJJHZZTNof4eq56gqNg=;
  b=n24yWAoH+XNbaawjMjJE41FBpdYfDhTw8xa2uNIqm7yaBegSfxlVAy2S
   WQRiAUiFk2UnE77pxi5xena60a0K/NmdWSBUz01ekzkdQLwCnZXz7mJz3
   HLa5H1bpkBS7FM5Bq21sGhyH+peLtFZbb4e+lgTlPWG4tDrlu/o+mvTlD
   Abw7bpT3wwzTPo5f5nCAP+YWwaM6B+QxL6nG/0u0JbSoezAH91F8RExDI
   MR0g15GTFP0hPhx5xuBbIv69BGJ+GXpoFN7m762OT7CK4omKfpC1hUeJd
   pRNowJeTLsrwvUDVa7nhPa7wRzr+E6RrQzUBYV65HW/7aGCaneqA7UPz/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="7229869"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="7229869"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 04:09:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="17349497"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.255.31.68]) ([10.255.31.68])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 04:09:23 -0800
Message-ID: <f61dca1b-3de6-4767-96ac-0c20fd730bec@linux.intel.com>
Date: Tue, 5 Dec 2023 20:09:20 +0800
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
Subject: Re: [PATCH v7 06/12] iommu: Remove
 iommu_[un]register_device_fault_handler()
Content-Language: en-US
To: Yi Liu <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-7-baolu.lu@linux.intel.com>
 <2516df8c-6d2a-49f7-bbea-123d0763bc00@intel.com>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <2516df8c-6d2a-49f7-bbea-123d0763bc00@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2023/12/4 20:36, Yi Liu wrote:
>>   /**
>>    * iommu_report_device_fault() - Report fault event to device driver
>>    * @dev: the device
>> @@ -1395,10 +1325,6 @@ int iommu_report_device_fault(struct device 
>> *dev, struct iommu_fault_event *evt)
>>       /* we only report device fault if there is a handler registered */
>>       mutex_lock(&param->lock);
>>       fparam = param->fault_param;
>> -    if (!fparam || !fparam->handler) {
> 
> should it still check the fparam?

Yes.

Best regards,
baolu

