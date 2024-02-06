Return-Path: <kvm+bounces-8090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0269B84AFFC
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:33:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7EEBB22351
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEB012B174;
	Tue,  6 Feb 2024 08:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZUKYXYPC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B32F2E827;
	Tue,  6 Feb 2024 08:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707208405; cv=none; b=TmD4v9OnMv+vIn+iyA858MH29Iz+qIPrYVhyESTMGp2+Css8kvhOwi6W9lpS7A0Mhck5qxKaLd9cz62wkm2GWfLLzDIUqNRt4j3a+H+B75pqQrVk3kwUaU346Cj4F8ZdE6bjAelkWmMcEnFRjRAF9eLo3YtoaA2QZZf7FvPXwN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707208405; c=relaxed/simple;
	bh=6yODWNZCfMXW+EgCmuq0idUZ9dez1MwoLXDzY8mde3I=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=G1LcpUv747IhW+Qte+yymOqv1Jo9NmtWZ8f7oQjOIbjuGUJNESyqK/I98PbSZR9R+Qdb0CcEHrfsTZL3mmyn3Xykz48TpNt3nwB2F9eqm3dUvM61AEtwjD0t9BWPtjJy5UMy/McOYMsIiO+w2rOY0hTX63qDMhpvx6/Aa5CD7oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZUKYXYPC; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707208404; x=1738744404;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6yODWNZCfMXW+EgCmuq0idUZ9dez1MwoLXDzY8mde3I=;
  b=ZUKYXYPCP4SUytzM15te4Yq7KqhTrpAG5cOhh3Rn2kr7O7+gYzxWAWft
   kvMT46WuhGKxlpbuBA/ys00GJauUBlYgwdoehHwqPKClsRuHX0GY4LPRz
   LBnEH7iceGwZtiX8ZpbayrHmuBKs7DQ4RU0ZIeLTMNI7RyC1sq5A6fDkC
   AOUJ+XvohrDMF08mp2VTUFrUv+t4vqg6kVAF30IjGo5uKAtv52ShvCROY
   CEoOH2vCrHfQghlL8Mhw86vhEil0K11vHPYEqaeepgIlbW8fEGWH5SIXu
   CaCWDHHjXX+yovsPQlMBXzr8GmPq1WetXzcCOqzrw2Vcd2Iu9C0A7h7cB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="596010"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="596010"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 00:33:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="32024689"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.249.169.103]) ([10.249.169.103])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 00:33:17 -0800
Message-ID: <ddea821e-3cf1-499c-a1f2-55e2a7fdded2@linux.intel.com>
Date: Tue, 6 Feb 2024 16:33:14 +0800
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
Subject: Re: [PATCH v11 13/16] iommu: Improve iopf_queue_remove_device()
To: "Tian, Kevin" <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
 <20240130080835.58921-14-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E70CAB272B212977F0C98C472@BN9PR11MB5276.namprd11.prod.outlook.com>
 <416b19fa-bc7a-4ffd-a4c4-9440483fc039@linux.intel.com>
 <BN9PR11MB52766E912B0FD784C5937D078C462@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52766E912B0FD784C5937D078C462@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/2/6 16:09, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Monday, February 5, 2024 7:55 PM
>>
>> On 2024/2/5 17:00, Tian, Kevin wrote:
>>>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>>> Sent: Tuesday, January 30, 2024 4:09 PM
>>>>     *
>>>> - * Caller makes sure that no more faults are reported for this device.
>>>> + * Removing a device from an iopf_queue. It's recommended to follow
>>>> these
>>>> + * steps when removing a device:
>>>>     *
>>>> - * Return: 0 on success and <0 on error.
>>>> + * - Disable new PRI reception: Turn off PRI generation in the IOMMU
>>>> hardware
>>>> + *   and flush any hardware page request queues. This should be done
>>>> before
>>>> + *   calling into this helper.
>>>
>>> this 1st step is already not followed by intel-iommu driver. The Page
>>> Request Enable (PRE) bit is set in the context entry when a device
>>> is attached to the default domain and cleared only in
>>> intel_iommu_release_device().
>>>
>>> but iopf_queue_remove_device() is called when IOMMU_DEV_FEAT_IOPF
>>> is disabled e.g. when idxd driver is unbound from the device.
>>>
>>> so the order is already violated.
>>>
>>>> + * - Acknowledge all outstanding PRQs to the device: Respond to all
>>>> outstanding
>>>> + *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the
>> device
>>>> should
>>>> + *   not retry. This helper function handles this.
>>>> + * - Disable PRI on the device: After calling this helper, the caller could
>>>> + *   then disable PRI on the device.
>>>
>>> intel_iommu_disable_iopf() disables PRI cap before calling this helper.
>>
>> You are right. The individual drivers should be adjusted accordingly in
>> separated patches. Here we just define the expected behaviors of the
>> individual iommu driver from the core's perspective.
> 
> can you add a note in commit msg about it?
> 
>>
>>>
>>>> + * - Tear down the iopf infrastructure: Calling
>> iopf_queue_remove_device()
>>>> + *   essentially disassociates the device. The fault_param might still exist,
>>>> + *   but iommu_page_response() will do nothing. The device fault
>> parameter
>>>> + *   reference count has been properly passed from
>>>> iommu_report_device_fault()
>>>> + *   to the fault handling work, and will eventually be released after
>>>> + *   iommu_page_response().
>>>
>>> it's unclear what 'tear down' means here.
>>
>> It's the same as calling iopf_queue_remove_device(). Perhaps I could
>> remove the confusing "tear down the iopf infrastructure"?
>>
> 
> I thought it is the last step then must have something real to do.
> 
> if not then removing it is clearer.

Both done. Thanks!

Best regards,
baolu

