Return-Path: <kvm+bounces-3565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F208053E7
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F84A281769
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915F55B1F2;
	Tue,  5 Dec 2023 12:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDzI3Y7+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBF2C3;
	Tue,  5 Dec 2023 04:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701778423; x=1733314423;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MYqOhIpAjG+tcFzzzvBDM/zAZxf8GMMLxtt+rsWwboM=;
  b=mDzI3Y7+SHNcFAaOAh9VsrFA3QixVH53hJ0F4PjAEktSYOCK8Y4dTM4c
   yk8fv2NF3FRjGqa1qN0XgYfPWg4x5O3nTGl6t240YfTzLLkgX994VqZnH
   kf8kWU6Vozc6AT2ihbggsuex5BJkeZUMimuh6w+zyEu4zii2M6o3XQmid
   3OVWxBU0OmRg4k4n5zxdJf9Sk4AVvIh9Cwv7Eq+rsiEYhWjh9qtHintY7
   lwHZr/pvVq1WMDh6u2rmyETjw29uJNQ0Qtl1NFuvx/9FlGM7OpcEJ57PV
   XCnrLG1eZ4vG1C6ZSk9QlLIIYH9DPWnvlVAsXEL+naaP76buw7a/KE5u7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="378910566"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="378910566"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 04:13:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="12315536"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.255.31.68]) ([10.255.31.68])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 04:13:40 -0800
Message-ID: <dfb350c8-b3e3-48ad-86b3-201205521153@linux.intel.com>
Date: Tue, 5 Dec 2023 20:13:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 09/12] iommu: Make iommu_queue_iopf() more generic
Content-Language: en-US
To: Yi Liu <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-10-baolu.lu@linux.intel.com>
 <e18c7c93-7184-4bbc-97cd-61fc0bc0aa3d@intel.com>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <e18c7c93-7184-4bbc-97cd-61fc0bc0aa3d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2023/12/5 15:13, Yi Liu wrote:
>> @@ -157,8 +173,8 @@ int iommu_queue_iopf(struct iommu_fault *fault, 
>> struct device *dev)
>>       group->dev = dev;
>>       group->last_fault.fault = *fault;
>>       INIT_LIST_HEAD(&group->faults);
>> +    group->domain = domain;
>>       list_add(&group->last_fault.list, &group->faults);
>> -    INIT_WORK(&group->work, iopf_handler);
>>       /* See if we have partial faults for this group */
>>       list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
>> @@ -167,9 +183,13 @@ int iommu_queue_iopf(struct iommu_fault *fault, 
>> struct device *dev)
>>               list_move(&iopf->list, &group->faults);
>>       }
>> -    queue_work(iopf_param->queue->wq, &group->work);
>> -    return 0;
>> +    mutex_unlock(&iopf_param->lock);
>> +    ret = domain->iopf_handler(group);
>> +    mutex_lock(&iopf_param->lock);
> 
> After this change, this function (iommu_queue_iopf) does not queue
> anything. Should this function be renamed? Except this, I didn't see
> other problem.

It's renamed in the next patch.

> 
> Reviewed-by:Yi Liu <yi.l.liu@intel.com>

Thank you!

Best regards,
baolu

