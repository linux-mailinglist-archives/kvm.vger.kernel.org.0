Return-Path: <kvm+bounces-8221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7085684CAB9
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 13:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2ACE1C24F9F
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 12:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96EA5A119;
	Wed,  7 Feb 2024 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q3vJ7KWR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6580F5A108;
	Wed,  7 Feb 2024 12:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707308994; cv=none; b=gLJwaN/5PNxKopRmWutbEHCRzO5O8kmtBOrnsgLrkzQXLReQm3LMONiOVoWa5K3qKapsXvRlTulvifMszs5lmaiv1YIBwAl+qBLRHgoqHxwvxaumT4RHq5jiL4PzJa5WQj+75fepM6K1MKijGK36+WLKwpUqoP/au8Nsm22LGlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707308994; c=relaxed/simple;
	bh=khJSx+sRKXLZUupDrn2ywNGOHTSvykattMG1rSkvEOk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=El2WA0+0AkS+hTu48N7ZzUVMDxUUDqdGPDwk6td/1mynMFfC1XXiyOyazcaWQ6IrJjy3MfKhkYwEMkv+0eygs/joXKNvBYJjyOgq/iSFIvje9z3Y90NZSXfuMeka8jnbH3oNkG0vVdEixRQlMQcOQLkOQTW2DkayjRh1W9ulMUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q3vJ7KWR; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707308992; x=1738844992;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=khJSx+sRKXLZUupDrn2ywNGOHTSvykattMG1rSkvEOk=;
  b=Q3vJ7KWRQytrL0y9+0K7Ii2yCrE7EAb7ozLHmjddU3zKm4iXnM2jFMLD
   UmT3xCeAZOz9aLPY3FhcG+qQfkUi1iSnkeY+T3aSpuD7QQVGrJunU5iLH
   Oicewx5Fxla0rH37GzNUMhzZpoy++uPTiubYzK4Gfy1XOuuKvUPmo0Uim
   T5yaVxsYsCLuLk6Mq48vCow5wn5yVegYcIEazlZ9fUiYb+9iffFQUNHmk
   BR3TPnO5qYmsHrLsUIsnH6DIzR+QaYPkS1yvX0krDYlCNghja7ctrNtU3
   yxFupu+FYXSXXg+JWGTCktC6HpVlz6aOdWk3WFDSF3kZU+1R+/FgXsu0Y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="1254978"
X-IronPort-AV: E=Sophos;i="6.05,250,1701158400"; 
   d="scan'208";a="1254978"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 04:29:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,250,1701158400"; 
   d="scan'208";a="1319731"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.215.224]) ([10.254.215.224])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 04:29:47 -0800
Message-ID: <693ee23d-30c6-4824-9bb2-1cfbf2eccfef@linux.intel.com>
Date: Wed, 7 Feb 2024 20:29:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 Joel Granados <j.granados@samsung.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v12 13/16] iommu: Improve iopf_queue_remove_device()
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>
References: <20240207013325.95182-1-baolu.lu@linux.intel.com>
 <20240207013325.95182-14-baolu.lu@linux.intel.com>
 <BN9PR11MB527603AB5685FF3ED21647958C452@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB527603AB5685FF3ED21647958C452@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/2/7 10:50, Tian, Kevin wrote:
>> From: Lu Baolu<baolu.lu@linux.intel.com>
>> Sent: Wednesday, February 7, 2024 9:33 AM
>>
>> Convert iopf_queue_remove_device() to return void instead of an error code,
>> as the return value is never used. This removal helper is designed to be
>> never-failed, so there's no need for error handling.
>>
>> Ack all outstanding page requests from the device with the response code of
>> IOMMU_PAGE_RESP_INVALID, indicating device should not attempt any retry.
>>
>> Add comments to this helper explaining the steps involved in removing a
>> device from the iopf queue and disabling its PRI. The individual drivers
>> are expected to be adjusted accordingly. Here we just define the expected
>> behaviors of the individual iommu driver from the core's perspective.
>>
>> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
>> Tested-by: Yan Zhao<yan.y.zhao@intel.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>, with one nit:
> 
>> + * Removing a device from an iopf_queue. It's recommended to follow
>> these
>> + * steps when removing a device:
>>    *
>> - * Return: 0 on success and <0 on error.
>> + * - Disable new PRI reception: Turn off PRI generation in the IOMMU
>> hardware
>> + *   and flush any hardware page request queues. This should be done
>> before
>> + *   calling into this helper.
>> + * - Acknowledge all outstanding PRQs to the device: Respond to all
>> outstanding
>> + *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device
>> should
>> + *   not retry. This helper function handles this.
> this implies calling iopf_queue_remove_device() here.
> 
>> + * - Disable PRI on the device: After calling this helper, the caller could
>> + *   then disable PRI on the device.
>> + * - Call iopf_queue_remove_device(): Calling iopf_queue_remove_device()
>> + *   essentially disassociates the device. The fault_param might still exist,
>> + *   but iommu_page_response() will do nothing. The device fault parameter
>> + *   reference count has been properly passed from
>> iommu_report_device_fault()
>> + *   to the fault handling work, and will eventually be released after
>> + *   iommu_page_response().
>>    */
> but here it suggests calling iopf_queue_remove_device() again. If the comment
> is just about to detail the behavior with that invocation shouldn't it be merged
> with the previous one instead of pretending to be the final step for driver
> to call?

Above just explains the behavior of calling iopf_queue_remove_device().

Best regards,
baolu

