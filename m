Return-Path: <kvm+bounces-3266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 246DD802212
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 09:57:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3D731F210B4
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 08:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727B67484;
	Sun,  3 Dec 2023 08:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NNUgbv1m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B15FE8;
	Sun,  3 Dec 2023 00:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701593863; x=1733129863;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fIgYj/pz0YnU67OHlSdQgp575vg0zeIleAakheq2FcQ=;
  b=NNUgbv1m7ZUfK/wCJbtcTbqOaRyetYLyJBsM1mKdaj9vrSw0KRgLHwFP
   l081F5ZIJgZMdC/8XWkdiV13rEthI5XrVerabzjY5yFPHQPCFt2w1dY7j
   OWz0yxu4mUxmsriouYFM3lKkbU3fyiJNRXPjyd80DHZMx/hlKG5WPYkID
   qCCvJzfiltZG7td2wmyWIWPkVE9vM897TS4VHPcAxuXQX3GhieqwcUrHt
   EAvubm4H+prvCDkd4a+XgVhPGykCMrCEwQLCIp5psUL5Eriw/73RelHf/
   dBFq0wcV9ZZ5WPnW2Rj8NDqte1aanyjnWu32xJj1LcvL0QO5Bs4xtPM1o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10912"; a="373827076"
X-IronPort-AV: E=Sophos;i="6.04,247,1695711600"; 
   d="scan'208";a="373827076"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 00:57:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10912"; a="1101771107"
X-IronPort-AV: E=Sophos;i="6.04,247,1695711600"; 
   d="scan'208";a="1101771107"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmsmga005.fm.intel.com with ESMTP; 03 Dec 2023 00:57:39 -0800
Message-ID: <a0ef3a4f-88fc-40fe-9891-495d1b6b365b@linux.intel.com>
Date: Sun, 3 Dec 2023 16:53:08 +0800
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
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231201203536.GG1489931@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/23 4:35 AM, Jason Gunthorpe wrote:
> On Wed, Nov 15, 2023 at 11:02:26AM +0800, Lu Baolu wrote:
>> The iopf_queue_flush_dev() is called by the iommu driver before releasing
>> a PASID. It ensures that all pending faults for this PASID have been
>> handled or cancelled, and won't hit the address space that reuses this
>> PASID. The driver must make sure that no new fault is added to the queue.
> This needs more explanation, why should anyone care?
> 
> More importantly, why is*discarding*  the right thing to do?
> Especially why would we discard a partial page request group?
> 
> After we change a translation we may have PRI requests in a
> queue. They need to be acknowledged, not discarded. The DMA in the
> device should be restarted and the device should observe the new
> translation - if it is blocking then it should take a DMA error.
> 
> More broadly, we should just let things run their normal course. The
> domain to deliver the fault to should be determined very early. If we
> get a fault and there is no fault domain currently assigned then just
> restart it.
> 
> The main reason to fence would be to allow the domain to become freed
> as the faults should be holding pointers to it. But I feel there are
> simpler options for that then this..

In the iommu_detach_device_pasid() path, the domain is about to be
removed from the pasid of device. The IOMMU driver performs the
following steps sequentially:

1. Clears the pasid translation entry. Thus, all subsequent DMA
    transactions (translation requests, translated requests or page
    requests) targeting the iommu domain will be blocked.

2. Waits until all pending page requests for the device's PASID have
    been reported to upper layers via the iommu_report_device_fault().
    However, this does not guarantee that all page requests have been
    responded.

3. Free all partial page requests for this pasid since the page request
    response is only needed for a complete request group. There's no
    action required for the page requests which are not last of a request
    group.

4. Iterate through the list of pending page requests and identifies
    those originating from the device's PASID. For each identified
    request, the driver responds to the hardware with the
    IOMMU_PAGE_RESP_INVALID code, indicating that the request cannot be
    handled and retries should not be attempted. This response code
    corresponds to the "Invalid Request" status defined in the PCI PRI
    specification.

5. Follow the IOMMU hardware requirements (for example, VT-d sepc,
    section 7.10, Software Steps to Drain Page Requests & Responses) to
    drain in-flight page requests and page group responses between the
    remapping hardware queues and the endpoint device.

With above steps done in iommu_detach_device_pasid(), the pasid could be
re-used for any other address space.

The iopf_queue_discard_dev_pasid() helper does step 3 and 4.

> 
>> The SMMUv3 driver doesn't use it because it only implements the
>> Arm-specific stall fault model where DMA transactions are held in the SMMU
>> while waiting for the OS to handle iopf's. Since a device driver must
>> complete all DMA transactions before detaching domain, there are no
>> pending iopf's with the stall model. PRI support requires adding a call to
>> iopf_queue_flush_dev() after flushing the hardware page fault queue.
> This explanation doesn't make much sense, from a device driver
> perspective both PRI and stall cause the device to not complete DMAs.
> 
> The difference between stall and PRI is fairly small, stall causes an
> internal bus to lock up while PRI does not.
> 
>> -int iopf_queue_flush_dev(struct device *dev)
>> +int iopf_queue_discard_dev_pasid(struct device *dev, ioasid_t pasid)
>>   {
>>   	struct iommu_fault_param *iopf_param = iopf_get_dev_fault_param(dev);
>> +	const struct iommu_ops *ops = dev_iommu_ops(dev);
>> +	struct iommu_page_response resp;
>> +	struct iopf_fault *iopf, *next;
>> +	int ret = 0;
>>   
>>   	if (!iopf_param)
>>   		return -ENODEV;
>>   
>>   	flush_workqueue(iopf_param->queue->wq);
>> +
> A naked flush_workqueue like this is really suspicious, it needs a
> comment explaining why the queue can't get more work queued at this
> point.
> 
> I suppose the driver is expected to stop calling
> iommu_report_device_fault() before calling this function, but that
> doesn't seem like it is going to be possible. Drivers should be
> implementing atomic replace for the PASID updates and in that case
> there is no momement when it can say the HW will stop generating PRI.

Atomic domain replacement for a PASID is not currently implemented in
the core or driver. Even if atomic replacement were to be implemented,
it would be necessary to ensure that all translation requests,
translated requests, page requests and responses for the old domain are
drained before switching to the new domain. I am not sure whether the
existing iommu hardware architecture supports this functionality.

Best regards,
baolu

