Return-Path: <kvm+bounces-8292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD59484D795
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 02:32:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 655BF2843FB
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 01:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCBE18EA1;
	Thu,  8 Feb 2024 01:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JoJpx/nY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB4A1E892;
	Thu,  8 Feb 2024 01:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707355936; cv=none; b=kSUWKllYcQUefQr9hMVkjVW38MqFJotG6SGvbr1F8d1hqMLV6iIZ6hfEst3JV0as6d7MoQca8jYm8m0kQE9W+fYw38mnAQfqmfjBynsTIYmPDDiVPkHE31LfYyqfSDPdY49KXrgtGPp1lSSsqXrLYQB9nlR2wmN8CO5/T2w4OYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707355936; c=relaxed/simple;
	bh=3GYmPNV941sCNT9l4UOqAlQJiyzxjbIc9airZ677Slw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mSOPqGWcfrvkvK2LCdxIzxIOxjtbSbBWVbXaR9nRu7DbzdHZA1ah6VwKzrEJ+q5N2PqxhR/4EmxEKw3N3wwwlA51VpdLb7Rff5J25dTR4rFZ/quWFmtaf7LJIbGcCcOfFyKdsnfLP3I3TLBaTpePQwpqTn4OX6XmQCU8SJ535ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JoJpx/nY; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707355935; x=1738891935;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3GYmPNV941sCNT9l4UOqAlQJiyzxjbIc9airZ677Slw=;
  b=JoJpx/nY5UBYsK9nA3KmaGKII5IOHrIP3TAIGZoqcS6lkc7mWDfyvw7C
   3K4OL8WP4KMkv3sqbLuRsFLie2D02GolO71KxCUlTegVf8gt0YeVoBgEU
   nG7KWJxHhZS3F4AGFZYK67uiAdhioFhymvus8NNr6vUtq7Wa0brDkw5v6
   M7BltKfY7JuMUZOaVsgInjifS6mlsK18X/VcU+08tex57PGYKQIYtntj/
   Vhm7rD45UhM7jlnnNTewSV7g878aG98xK8MZAQjlcxooRFW/pEXxc1L8Q
   RrRxxnJ8WfEbsIsmOrwGNz1I4eHpWTD83LLDBu+wL1G6WPQWEnn+9AZP3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="4939035"
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="4939035"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 17:32:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="6159021"
Received: from kailinz1-mobl2.ccr.corp.intel.com (HELO [10.249.169.136]) ([10.249.169.136])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 17:32:08 -0800
Message-ID: <9577ec59-fa05-4eea-b0ae-312d9531ce61@linux.intel.com>
Date: Thu, 8 Feb 2024 09:32:05 +0800
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
To: Vasant Hegde <vasant.hegde@amd.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>
References: <20240207013325.95182-1-baolu.lu@linux.intel.com>
 <20240207013325.95182-14-baolu.lu@linux.intel.com>
 <BN9PR11MB527603AB5685FF3ED21647958C452@BN9PR11MB5276.namprd11.prod.outlook.com>
 <693ee23d-30c6-4824-9bb2-1cfbf2eccfef@linux.intel.com>
 <f856519f-419c-1901-b8bc-3e338873157f@amd.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <f856519f-419c-1901-b8bc-3e338873157f@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/2/8 1:59, Vasant Hegde wrote:
> Hi Baolu,
> 
> On 2/7/2024 5:59 PM, Baolu Lu wrote:
>> On 2024/2/7 10:50, Tian, Kevin wrote:
>>>> From: Lu Baolu<baolu.lu@linux.intel.com>
>>>> Sent: Wednesday, February 7, 2024 9:33 AM
>>>>
>>>> Convert iopf_queue_remove_device() to return void instead of an error code,
>>>> as the return value is never used. This removal helper is designed to be
>>>> never-failed, so there's no need for error handling.
>>>>
>>>> Ack all outstanding page requests from the device with the response code of
>>>> IOMMU_PAGE_RESP_INVALID, indicating device should not attempt any retry.
>>>>
>>>> Add comments to this helper explaining the steps involved in removing a
>>>> device from the iopf queue and disabling its PRI. The individual drivers
>>>> are expected to be adjusted accordingly. Here we just define the expected
>>>> behaviors of the individual iommu driver from the core's perspective.
>>>>
>>>> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
>>>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>>>> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
>>>> Tested-by: Yan Zhao<yan.y.zhao@intel.com>
>>> Reviewed-by: Kevin Tian<kevin.tian@intel.com>, with one nit:
>>>
>>>> + * Removing a device from an iopf_queue. It's recommended to follow
>>>> these
>>>> + * steps when removing a device:
>>>>     *
>>>> - * Return: 0 on success and <0 on error.
>>>> + * - Disable new PRI reception: Turn off PRI generation in the IOMMU
>>>> hardware
>>>> + *   and flush any hardware page request queues. This should be done
>>>> before
>>>> + *   calling into this helper.
>>>> + * - Acknowledge all outstanding PRQs to the device: Respond to all
>>>> outstanding
>>>> + *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device
>>>> should
>>>> + *   not retry. This helper function handles this.
>>> this implies calling iopf_queue_remove_device() here.
>>>
>>>> + * - Disable PRI on the device: After calling this helper, the caller could
>>>> + *   then disable PRI on the device.
>>>> + * - Call iopf_queue_remove_device(): Calling iopf_queue_remove_device()
>>>> + *   essentially disassociates the device. The fault_param might still exist,
>>>> + *   but iommu_page_response() will do nothing. The device fault parameter
>>>> + *   reference count has been properly passed from
>>>> iommu_report_device_fault()
>>>> + *   to the fault handling work, and will eventually be released after
>>>> + *   iommu_page_response().
>>>>     */
>>> but here it suggests calling iopf_queue_remove_device() again. If the comment
>>> is just about to detail the behavior with that invocation shouldn't it be merged
>>> with the previous one instead of pretending to be the final step for driver
>>> to call?
>>
>> Above just explains the behavior of calling iopf_queue_remove_device().
> 
> Can you please leave a line -OR- move this to previous para? Otherwise we will
> get confused.

Sure. I will make it look like below.

/**
  * iopf_queue_remove_device - Remove producer from fault queue
  * @queue: IOPF queue
  * @dev: device to remove
  *
  * Removing a device from an iopf_queue. It's recommended to follow these
  * steps when removing a device:
  *
  * - Disable new PRI reception: Turn off PRI generation in the IOMMU 
hardware
  *   and flush any hardware page request queues. This should be done before
  *   calling into this helper.
  * - Acknowledge all outstanding PRQs to the device: Respond to all 
outstanding
  *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device 
should
  *   not retry. This helper function handles this.
  * - Disable PRI on the device: After calling this helper, the caller could
  *   then disable PRI on the device.
  *
  * Calling iopf_queue_remove_device() essentially disassociates the device.
  * The fault_param might still exist, but iommu_page_response() will do
  * nothing. The device fault parameter reference count has been properly
  * passed from iommu_report_device_fault() to the fault handling work, and
  * will eventually be released after iommu_page_response().
  */

Best regards,
baolu


