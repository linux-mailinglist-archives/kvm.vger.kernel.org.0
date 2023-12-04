Return-Path: <kvm+bounces-3281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B2EC8029EF
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 02:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0D90280C8A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 01:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185E410F0;
	Mon,  4 Dec 2023 01:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sm16VVSj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8E5E4;
	Sun,  3 Dec 2023 17:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701653834; x=1733189834;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RdAwYv1tCW3Sr0N3YOoYWWOcHVLJnlNtS3tq6G2IyzQ=;
  b=Sm16VVSjvq3ODjQDSDhKyOLR7eSL2ejpKK4es6jMgZC4sjOJ4wOd7dIM
   um9D7Ez/MtXFTPyHiDA49k80d8/yjDplyxQOj3OIqDNu3OnuTzqUydNap
   iU49pBJSv64qhzDBjC4D11QwP0nNpDqfNhqqoy7jiNXAlS959IoxycuBe
   mn/Av/DsOZ9r6Cus8qphwRmnEMCJGGKj9LVQo6d+/bABhcs+srUd+rKse
   0ku+USbC5svJ2zT3P4fIyZO1OPhwL61llyODgKeBwuoNCi0W89gXQUVhC
   2x1qlmWeWc5VvfFGH2TcFTQ5XmyfsMwxwpE9qJenTbIYq3jeudtesbCLa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="730460"
X-IronPort-AV: E=Sophos;i="6.04,248,1695711600"; 
   d="scan'208";a="730460"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 17:37:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="943727892"
X-IronPort-AV: E=Sophos;i="6.04,248,1695711600"; 
   d="scan'208";a="943727892"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga005.jf.intel.com with ESMTP; 03 Dec 2023 17:37:09 -0800
Message-ID: <2354dd69-0179-4689-bc35-f4bf4ea5a886@linux.intel.com>
Date: Mon, 4 Dec 2023 09:32:37 +0800
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
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
 <a0ef3a4f-88fc-40fe-9891-495d1b6b365b@linux.intel.com>
 <20231203141414.GJ1489931@ziepe.ca>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231203141414.GJ1489931@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/23 10:14 PM, Jason Gunthorpe wrote:
> On Sun, Dec 03, 2023 at 04:53:08PM +0800, Baolu Lu wrote:
>> On 12/2/23 4:35 AM, Jason Gunthorpe wrote:
>>> On Wed, Nov 15, 2023 at 11:02:26AM +0800, Lu Baolu wrote:
>>>> The iopf_queue_flush_dev() is called by the iommu driver before releasing
>>>> a PASID. It ensures that all pending faults for this PASID have been
>>>> handled or cancelled, and won't hit the address space that reuses this
>>>> PASID. The driver must make sure that no new fault is added to the queue.
>>> This needs more explanation, why should anyone care?
>>>
>>> More importantly, why is*discarding*  the right thing to do?
>>> Especially why would we discard a partial page request group?
>>>
>>> After we change a translation we may have PRI requests in a
>>> queue. They need to be acknowledged, not discarded. The DMA in the
>>> device should be restarted and the device should observe the new
>>> translation - if it is blocking then it should take a DMA error.
>>>
>>> More broadly, we should just let things run their normal course. The
>>> domain to deliver the fault to should be determined very early. If we
>>> get a fault and there is no fault domain currently assigned then just
>>> restart it.
>>>
>>> The main reason to fence would be to allow the domain to become freed
>>> as the faults should be holding pointers to it. But I feel there are
>>> simpler options for that then this..
>>
>> In the iommu_detach_device_pasid() path, the domain is about to be
>> removed from the pasid of device. The IOMMU driver performs the
>> following steps sequentially:
> 
> I know that is why it does, but it doesn't explain at all why.
> 
>> 1. Clears the pasid translation entry. Thus, all subsequent DMA
>>     transactions (translation requests, translated requests or page
>>     requests) targeting the iommu domain will be blocked.
>>
>> 2. Waits until all pending page requests for the device's PASID have
>>     been reported to upper layers via the iommu_report_device_fault().
>>     However, this does not guarantee that all page requests have been
>>     responded.
>>
>> 3. Free all partial page requests for this pasid since the page request
>>     response is only needed for a complete request group. There's no
>>     action required for the page requests which are not last of a request
>>     group.
> 
> But we expect the last to come eventually since everything should be
> grouped properly, so why bother doing this?
> 
> Indeed if 2 worked, how is this even possible to have partials?

Step 1 clears the pasid table entry, hence all subsequent page requests
are blocked (hardware auto-respond the request but not put it in the
queue).

It is possible that a portion of a page fault group may have been queued
for processing, but the last request is being blocked by hardware due
to the pasid entry being in the blocking state.

In reality, this may be a no-op as I haven't seen any real-world
implementations of multiple-requests fault groups on Intel platforms.

>   
>> 5. Follow the IOMMU hardware requirements (for example, VT-d sepc,
>>     section 7.10, Software Steps to Drain Page Requests & Responses) to
>>     drain in-flight page requests and page group responses between the
>>     remapping hardware queues and the endpoint device.
>>
>> With above steps done in iommu_detach_device_pasid(), the pasid could be
>> re-used for any other address space.
> 
> As I said, that isn't even required. There is no issue with leaking
> PRI's across attachments.
> 
> 
>>> I suppose the driver is expected to stop calling
>>> iommu_report_device_fault() before calling this function, but that
>>> doesn't seem like it is going to be possible. Drivers should be
>>> implementing atomic replace for the PASID updates and in that case
>>> there is no momement when it can say the HW will stop generating PRI.
>>
>> Atomic domain replacement for a PASID is not currently implemented in
>> the core or driver.
> 
> It is, the driver should implement set_dev_pasid in such a way that
> repeated calls do replacements, ideally atomically. This is what ARM
> SMMUv3 does after my changes.
> 
>> Even if atomic replacement were to be implemented,
>> it would be necessary to ensure that all translation requests,
>> translated requests, page requests and responses for the old domain are
>> drained before switching to the new domain.
> 
> Again, no it isn't required.
> 
> Requests simply have to continue to be acked, it doesn't matter if
> they are acked against the wrong domain because the device will simply
> re-issue them..

Ah! I start to get your point now.

Even a page fault response is postponed to a new address space, which
possibly be another address space or hardware blocking state, the
hardware just retries.

As long as we flushes all caches (IOTLB and device TLB) during 
switching, the mappings of the old domain won't leak. So it's safe to 
keep page requests there.

Do I get you correctly?

Best regards,
baolu

