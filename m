Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3099309375
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 10:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhA3JfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 04:35:19 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11647 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhA3Jbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 04:31:52 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DSTSd1FX9z161dV;
        Sat, 30 Jan 2021 17:29:53 +0800 (CST)
Received: from [10.174.184.214] (10.174.184.214) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Sat, 30 Jan 2021 17:30:58 +0800
Subject: Re: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <44a8b643-6920-b2b5-a593-2942b5ea4ee7@huawei.com>
Date:   Sat, 30 Jan 2021 17:30:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210129155730.3a1d49c5@omen.home.shazbot.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.214]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/30 6:57, Alex Williamson wrote:
> On Mon, 25 Jan 2021 17:03:58 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
> 
>> Hi,
>>
>> The static pinning and mapping problem in VFIO and possible solutions
>> have been discussed a lot [1, 2]. One of the solutions is to add I/O
>> page fault support for VFIO devices. Different from those relatively
>> complicated software approaches such as presenting a vIOMMU that provides
>> the DMA buffer information (might include para-virtualized optimizations),
>> IOPF mainly depends on the hardware faulting capability, such as the PCIe
>> PRI extension or Arm SMMU stall model. What's more, the IOPF support in
>> the IOMMU driver is being implemented in SVA [3]. So do we consider to
>> add IOPF support for VFIO passthrough based on the IOPF part of SVA at
>> present?
>>
>> We have implemented a basic demo only for one stage of translation (GPA
>> -> HPA in virtualization, note that it can be configured at either stage),  
>> and tested on Hisilicon Kunpeng920 board. The nested mode is more complicated
>> since VFIO only handles the second stage page faults (same as the non-nested
>> case), while the first stage page faults need to be further delivered to
>> the guest, which is being implemented in [4] on ARM. My thought on this
>> is to report the page faults to VFIO regardless of the occured stage (try
>> to carry the stage information), and handle respectively according to the
>> configured mode in VFIO. Or the IOMMU driver might evolve to support more...
>>
>> Might TODO:
>>  - Optimize the faulting path, and measure the performance (it might still
>>    be a big issue).
>>  - Add support for PRI.
>>  - Add a MMU notifier to avoid pinning.
>>  - Add support for the nested mode.
>> ...
>>
>> Any comments and suggestions are very welcome. :-)
> 
> I expect performance to be pretty bad here, the lookup involved per
> fault is excessive.

We might consider to prepin more pages as a further optimization.

> There are cases where a user is not going to be
> willing to have a slow ramp up of performance for their devices as they
> fault in pages, so we might need to considering making this
> configurable through the vfio interface.

Yeah, makes sense, I will try to implement this: maybe add a ioctl called
VFIO_IOMMU_ENABLE_IOPF for Type1 VFIO IOMMU...

> Our page mapping also only
> grows here, should mappings expire or do we need a least recently
> mapped tracker to avoid exceeding the user's locked memory limit?  How
> does a user know what to set for a locked memory limit?

Yeah, we can add a LRU(mapped) tracker to release the pages when exceeding
a memory limit, maybe have a thread to periodically check this.
And as for the memory limit, maybe we could give the user some levels
(10%(default)/30%/50%/70%/unlimited of the total user memory (mapping size))
to choose from via the VFIO_IOMMU_ENABLE_IOPF ioctl...

> The behavior
> here would lead to cases where an idle system might be ok, but as soon
> as load increases with more inflight DMA, we start seeing
> "unpredictable" I/O faults from the user perspective.

"unpredictable" I/O faults? We might see more problems after more testing...

Thanks,
Shenming

> Seems like there
> are lots of outstanding considerations and I'd also like to hear from
> the SVA folks about how this meshes with their work.  Thanks,
> 
> Alex
> 
> .
>
