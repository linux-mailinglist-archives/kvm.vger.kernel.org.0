Return-Path: <kvm+bounces-5868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB1E827E95
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 07:01:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A343A1C235EA
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 06:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0AC63CF;
	Tue,  9 Jan 2024 06:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MG/nb9DQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA9D15A7;
	Tue,  9 Jan 2024 06:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704780078; x=1736316078;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Cezvo80lqsWNNBHgcaX+gkBDbwknIaH/Y08nlDDml3o=;
  b=MG/nb9DQJ7W2/crb+0tqdmA0zzMF0G6eBEFvgLt/MXKkAhGJrujP8EE/
   nKNxd1cZEzyQ7L1n5EXVsr+PCCGF+etUodhNgYNSKYOYAXV2Qhei12Ewb
   RKvDUz8OxJZLb4oDIa3UvsKDRABIpoTqYraG3xPIAl23llX9Yfzd1Pdcg
   +itiCnyJKjUrpl1Dy+MaNkE+XgSpoWy8GCTkbTGRMyvoXuTM7Z3knFEgA
   2FgNwzSnnk3BkOsXUfPJCYFhel5QVv87CKTYLzp9DHo+G1Gp/CRq3OHCe
   QY4QhOe17KLA4KHKvK5BNbLFmvHclXpBFWnqVLX3P1iz1A0PE4b0i68Rq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="5459892"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="5459892"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 22:01:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="905037339"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="905037339"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga004.jf.intel.com with ESMTP; 08 Jan 2024 22:01:12 -0800
Message-ID: <ca74243f-d1d1-4b01-95a6-58b4c85842d9@linux.intel.com>
Date: Tue, 9 Jan 2024 13:55:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 14/14] iommu: Track iopf group instead of last fault
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231220012332.168188-1-baolu.lu@linux.intel.com>
 <20231220012332.168188-15-baolu.lu@linux.intel.com>
 <20240105175339.GI50608@ziepe.ca>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240105175339.GI50608@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/24 1:53 AM, Jason Gunthorpe wrote:
> On Wed, Dec 20, 2023 at 09:23:32AM +0800, Lu Baolu wrote:
>>   /**
>> - * iommu_handle_iopf - IO Page Fault handler
>> - * @fault: fault event
>> - * @iopf_param: the fault parameter of the device.
>> + * iommu_report_device_fault() - Report fault event to device driver
>> + * @dev: the device
>> + * @evt: fault event data
>>    *
>> - * Add a fault to the device workqueue, to be handled by mm.
>> + * Called by IOMMU drivers when a fault is detected, typically in a threaded IRQ
>> + * handler. When this function fails and the fault is recoverable, it is the
>> + * caller's responsibility to complete the fault.
> This patch seems OK for what it does so:
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> 
> However, this seems like a strange design, surely this function should
> just call ops->page_response() when it can't enqueue the fault?
> 
> It is much cleaner that way, so maybe you can take this into a
> following patch (along with the driver fixes to accomodate. (and
> perhaps iommu_report_device_fault() should return void too)
> 
> Also iopf_group_response() should return void (another patch!),
> nothing can do anything with the failure. This implies that
> ops->page_response() must also return void - which is consistent with
> what the drivers do, the failure paths are all integrity validations
> of the fault and should be WARN_ON'd not return codes.

Make sense. I will integrate the code in the next version and convert
iommu_report_device_fault() to return void.

Best regards,
baolu

