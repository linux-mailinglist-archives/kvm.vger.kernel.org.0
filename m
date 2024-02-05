Return-Path: <kvm+bounces-7988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DEBC849946
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:55:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E055C1F22B12
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 11:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D7719477;
	Mon,  5 Feb 2024 11:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VcuUk5o5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D268199BC;
	Mon,  5 Feb 2024 11:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707134133; cv=none; b=H9b2sOTa4WfVjJeLETC4aa2bLZQgg1inoWqeQNFWTYbVmBimEsOfwn+RUYcNJU77ohgqJed3gxYvP48KC9sFPM9DbLFE2opeEV/ts5B0pbzjAJxLxJoZqFn+6ZQB0qLzv4Uuj4/cnCBHqbqBjKvVKvomA8jwJOUVW5xcxc9fPqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707134133; c=relaxed/simple;
	bh=0OuYU2PvqAucFifuB0MnY2hFRDJRhjMbT+oPpt/BoeA=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oLsYshdHD8PuLKxjQ9DtLY+/Hm/B/WL8dBaB8SZs4/4NuMdmvpPKnNh9AkycyAiO0OKMrqrUo1mL/Yig+cyDPVzPK8CeKyWy0Y5Ehb+VJBfwjcUunhz3QgtPHycF1nvhteAEPDKcSmgQXy8n820S2fLomJHdrriL0QoZmFin4PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VcuUk5o5; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707134131; x=1738670131;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0OuYU2PvqAucFifuB0MnY2hFRDJRhjMbT+oPpt/BoeA=;
  b=VcuUk5o5LUI0apkMLQklZ3v6IIvYWzIIGW7OEOd6ZRSkirTS2qEZlcDP
   YxWJDYb2vE+/bLKM2r5ygVDWkMYApkcGQPTFdN1b3TrcRVHya9xhNK2Zq
   AEtz9aNafM8b96hlDNklfsWSlib7cTpoOMz1LeCCd/S5t0woZqNDxgB5l
   Bf7LxS4msleTwJWmpeyaCyZ9mCtuW2E5BmY2ljdRu7PZ264jtZBOzie4F
   00P61cyTSiGTKacag6TOzsSO6FNxwjoFFlrx1qv0svQAkgsdRP6S4/viC
   fECtpsgFkiOXQBne1eyvkJbm6IDSfruxHpVpGvpQKK/KhK/pvVscpnYBB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="413513"
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="413513"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 03:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="706125"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.215.64]) ([10.254.215.64])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 03:55:27 -0800
Message-ID: <416b19fa-bc7a-4ffd-a4c4-9440483fc039@linux.intel.com>
Date: Mon, 5 Feb 2024 19:55:23 +0800
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
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
 <20240130080835.58921-14-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E70CAB272B212977F0C98C472@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276E70CAB272B212977F0C98C472@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/2/5 17:00, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Tuesday, January 30, 2024 4:09 PM
>>    *
>> - * Caller makes sure that no more faults are reported for this device.
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
> 
> this 1st step is already not followed by intel-iommu driver. The Page
> Request Enable (PRE) bit is set in the context entry when a device
> is attached to the default domain and cleared only in
> intel_iommu_release_device().
> 
> but iopf_queue_remove_device() is called when IOMMU_DEV_FEAT_IOPF
> is disabled e.g. when idxd driver is unbound from the device.
> 
> so the order is already violated.
> 
>> + * - Acknowledge all outstanding PRQs to the device: Respond to all
>> outstanding
>> + *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device
>> should
>> + *   not retry. This helper function handles this.
>> + * - Disable PRI on the device: After calling this helper, the caller could
>> + *   then disable PRI on the device.
> 
> intel_iommu_disable_iopf() disables PRI cap before calling this helper.

You are right. The individual drivers should be adjusted accordingly in
separated patches. Here we just define the expected behaviors of the
individual iommu driver from the core's perspective.

> 
>> + * - Tear down the iopf infrastructure: Calling iopf_queue_remove_device()
>> + *   essentially disassociates the device. The fault_param might still exist,
>> + *   but iommu_page_response() will do nothing. The device fault parameter
>> + *   reference count has been properly passed from
>> iommu_report_device_fault()
>> + *   to the fault handling work, and will eventually be released after
>> + *   iommu_page_response().
> 
> it's unclear what 'tear down' means here.

It's the same as calling iopf_queue_remove_device(). Perhaps I could
remove the confusing "tear down the iopf infrastructure"?

Best regards,
baolu

