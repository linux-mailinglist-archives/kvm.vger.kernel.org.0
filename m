Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C048C30B7F5
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 07:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhBBGnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 01:43:01 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12402 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhBBGnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 01:43:00 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DVFZc5zmtzjGjx;
        Tue,  2 Feb 2021 14:41:12 +0800 (CST)
Received: from [10.174.184.214] (10.174.184.214) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 14:42:05 +0800
Subject: Re: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
 <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <47bf7612-4fb0-c0bb-fa19-24c4e3d01d3f@huawei.com>
Date:   Tue, 2 Feb 2021 14:41:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.214]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/2/1 15:56, Tian, Kevin wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Saturday, January 30, 2021 6:58 AM
>>
>> On Mon, 25 Jan 2021 17:03:58 +0800
>> Shenming Lu <lushenming@huawei.com> wrote:
>>
>>> Hi,
>>>
>>> The static pinning and mapping problem in VFIO and possible solutions
>>> have been discussed a lot [1, 2]. One of the solutions is to add I/O
>>> page fault support for VFIO devices. Different from those relatively
>>> complicated software approaches such as presenting a vIOMMU that
>> provides
>>> the DMA buffer information (might include para-virtualized optimizations),
>>> IOPF mainly depends on the hardware faulting capability, such as the PCIe
>>> PRI extension or Arm SMMU stall model. What's more, the IOPF support in
>>> the IOMMU driver is being implemented in SVA [3]. So do we consider to
>>> add IOPF support for VFIO passthrough based on the IOPF part of SVA at
>>> present?
>>>
>>> We have implemented a basic demo only for one stage of translation (GPA
>>> -> HPA in virtualization, note that it can be configured at either stage),
>>> and tested on Hisilicon Kunpeng920 board. The nested mode is more
>> complicated
>>> since VFIO only handles the second stage page faults (same as the non-
>> nested
>>> case), while the first stage page faults need to be further delivered to
>>> the guest, which is being implemented in [4] on ARM. My thought on this
>>> is to report the page faults to VFIO regardless of the occured stage (try
>>> to carry the stage information), and handle respectively according to the
>>> configured mode in VFIO. Or the IOMMU driver might evolve to support
>> more...
>>>
>>> Might TODO:
>>>  - Optimize the faulting path, and measure the performance (it might still
>>>    be a big issue).
>>>  - Add support for PRI.
>>>  - Add a MMU notifier to avoid pinning.
>>>  - Add support for the nested mode.
>>> ...
>>>
>>> Any comments and suggestions are very welcome. :-)
>>
>> I expect performance to be pretty bad here, the lookup involved per
>> fault is excessive.  There are cases where a user is not going to be
>> willing to have a slow ramp up of performance for their devices as they
>> fault in pages, so we might need to considering making this
>> configurable through the vfio interface.  Our page mapping also only
> 
> There is another factor to be considered. The presence of IOMMU_
> DEV_FEAT_IOPF just indicates the device capability of triggering I/O 
> page fault through the IOMMU, but not exactly means that the device 
> can tolerate I/O page fault for arbitrary DMA requests.

Yes, so I add a iopf_enabled field in VFIO to indicate the whole path faulting
capability and set it to true after registering a VFIO page fault handler.

> In reality, many 
> devices allow I/O faulting only in selective contexts. However, there
> is no standard way (e.g. PCISIG) for the device to report whether 
> arbitrary I/O fault is allowed. Then we may have to maintain device
> specific knowledge in software, e.g. in an opt-in table to list devices
> which allows arbitrary faults. For devices which only support selective 
> faulting, a mediator (either through vendor extensions on vfio-pci-core
> or a mdev wrapper) might be necessary to help lock down non-faultable 
> mappings and then enable faulting on the rest mappings.

For devices which only support selective faulting, they could tell it to the
IOMMU driver and let it filter out non-faultable faults? Do I get it wrong?

> 
>> grows here, should mappings expire or do we need a least recently
>> mapped tracker to avoid exceeding the user's locked memory limit?  How
>> does a user know what to set for a locked memory limit?  The behavior
>> here would lead to cases where an idle system might be ok, but as soon
>> as load increases with more inflight DMA, we start seeing
>> "unpredictable" I/O faults from the user perspective.  Seems like there
>> are lots of outstanding considerations and I'd also like to hear from
>> the SVA folks about how this meshes with their work.  Thanks,
>>
> 
> The main overlap between this feature and SVA is the IOPF reporting
> framework, which currently still has gap to support both in nested
> mode, as discussed here:
> 
> https://lore.kernel.org/linux-acpi/YAaxjmJW+ZMvrhac@myrica/
> 
> Once that gap is resolved in the future, the VFIO fault handler just 
> adopts different actions according to the fault-level: 1st level faults
> are forwarded to userspace thru the vSVA path while 2nd-level faults
> are fixed (or warned if not intended) by VFIO itself thru the IOMMU
> mapping interface.

I understand what you mean is:
From the perspective of VFIO, first, we need to set FEAT_IOPF, and then regster its
own handler with a flag to indicate FLAT or NESTED and which level is concerned,
thus the VFIO handler can handle the page faults directly according to the carried
level information.

Is there any plan for evolving(implementing) the IOMMU driver to support this? Or
could we help this?  :-)

Thanks,
Shenming

> 
> Thanks
> Kevin
> 
