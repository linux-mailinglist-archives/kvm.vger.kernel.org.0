Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C3D31240D
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 12:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhBGLsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 06:48:46 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11697 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhBGLsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 06:48:19 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DYS5t2549zlHFC;
        Sun,  7 Feb 2021 19:45:54 +0800 (CST)
Received: from [10.174.184.214] (10.174.184.214) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:47:29 +0800
Subject: Re: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
 <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
 <47bf7612-4fb0-c0bb-fa19-24c4e3d01d3f@huawei.com>
 <MWHPR11MB1886C71A751B48EF626CAC938CB39@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YB0f5Yno9frihQq4@myrica>
 <MWHPR11MB1886D07D927A77DCB2FF74D48CB09@MWHPR11MB1886.namprd11.prod.outlook.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <722bf67a-0f59-6335-77ab-095e971a6355@huawei.com>
Date:   Sun, 7 Feb 2021 19:47:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB1886D07D927A77DCB2FF74D48CB09@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.214]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/2/7 16:20, Tian, Kevin wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Sent: Friday, February 5, 2021 6:37 PM
>>
>> Hi,
>>
>> On Thu, Feb 04, 2021 at 06:52:10AM +0000, Tian, Kevin wrote:
>>>>>>> The static pinning and mapping problem in VFIO and possible
>> solutions
>>>>>>> have been discussed a lot [1, 2]. One of the solutions is to add I/O
>>>>>>> page fault support for VFIO devices. Different from those relatively
>>>>>>> complicated software approaches such as presenting a vIOMMU that
>>>>>> provides
>>>>>>> the DMA buffer information (might include para-virtualized
>>>> optimizations),
>>
>> I'm curious about the performance difference between this and the
>> map/unmap vIOMMU, as well as the coIOMMU. This is probably a lot faster
>> but those don't depend on IOPF which is a pretty rare feature at the
>> moment.

Yeah, I will give the performance data later.

>>
>> [...]
>>>>> In reality, many
>>>>> devices allow I/O faulting only in selective contexts. However, there
>>>>> is no standard way (e.g. PCISIG) for the device to report whether
>>>>> arbitrary I/O fault is allowed. Then we may have to maintain device
>>>>> specific knowledge in software, e.g. in an opt-in table to list devices
>>>>> which allows arbitrary faults. For devices which only support selective
>>>>> faulting, a mediator (either through vendor extensions on vfio-pci-core
>>>>> or a mdev wrapper) might be necessary to help lock down non-
>> faultable
>>>>> mappings and then enable faulting on the rest mappings.
>>>>
>>>> For devices which only support selective faulting, they could tell it to the
>>>> IOMMU driver and let it filter out non-faultable faults? Do I get it wrong?
>>>
>>> Not exactly to IOMMU driver. There is already a vfio_pin_pages() for
>>> selectively page-pinning. The matter is that 'they' imply some device
>>> specific logic to decide which pages must be pinned and such knowledge
>>> is outside of VFIO.
>>>
>>> From enabling p.o.v we could possibly do it in phased approach. First
>>> handles devices which tolerate arbitrary DMA faults, and then extends
>>> to devices with selective-faulting. The former is simpler, but with one
>>> main open whether we want to maintain such device IDs in a static
>>> table in VFIO or rely on some hints from other components (e.g. PF
>>> driver in VF assignment case). Let's see how Alex thinks about it.
>>
>> Do you think selective-faulting will be the norm, or only a problem for
>> initial IOPF implementations?  To me it's the selective-faulting kind of
>> device that will be the odd one out, but that's pure speculation. Either
>> way maintaining a device list seems like a pain.
> 
> I would think it's norm for quite some time (e.g. multiple years), as from
> what I learned turning a complex accelerator to an implementation 
> tolerating arbitrary DMA fault is way complex (in every critical path) and
> not cost effective (tracking in-fly requests). It might be OK for some 
> purposely-built devices in specific usage but for most it has to be an 
> evolving path toward the 100%-faultable goal...
> 
>>
>> [...]
>>> Yes, it's in plan but just not happened yet. We are still focusing on guest
>>> SVA part thus only the 1st-level page fault (+Yi/Jacob). It's always
>> welcomed
>>> to collaborate/help if you have time. 😊
>>
>> By the way the current fault report API is missing a way to invalidate
>> partial faults: when the IOMMU device's PRI queue overflows, it may
>> auto-respond to page request groups that were already partially reported
>> by the IOMMU driver. Upon detecting an overflow, the IOMMU driver needs
>> to
>> tell all fault consumers to discard their partial groups.
>> iopf_queue_discard_partial() [1] does this for the internal IOPF handler
>> but we have nothing for the lower-level fault handler at the moment. And
>> it gets more complicated when injecting IOPFs to guests, we'd need a
>> mechanism to recall partial groups all the way through kernel->userspace
>> and userspace->guest.
> 
> I didn't know how to recall partial groups through emulated vIOMMUs
> (at least for virtual VT-d). Possibly it could be supported by virtio-iommu.
> But in any case I consider it more like an optimization instead of a functional
> requirement (and could be avoided in below Shenming's suggestion).
> 
>>
>> Shenming suggests [2] to also use the IOPF handler for IOPFs managed by
>> device drivers. It's worth considering in my opinion because we could hold
>> partial groups within the kernel and only report full groups to device
>> drivers (and guests). In addition we'd consolidate tracking of IOPFs,
>> since they're done both by iommu_report_device_fault() and the IOPF
>> handler at the moment.
> 
> I also think it's the right thing to do. In concept w/ or w/o DEV_FEAT_IOPF
> just reflects how IOPFs are delivered to the system software. In the end 
> IOPFs are all about permission violations in the IOMMU page tables thus
> we should try to reuse/consolidate the IOMMU fault reporting stack as 
> much as possible.
> 
>>
>> Note that I plan to upstream the IOPF patch [1] as is because it was
>> already in good shape for 5.12, and consolidating the fault handler will
>> require some thinking.
> 
> This plan makes sense.

Yeah, maybe this problem could be left for the implementation of a device(VFIO)
specific fault handler... :-)

Thanks,
Shenming

> 
>>
>> Thanks,
>> Jean
>>
>>
>> [1] https://lore.kernel.org/linux-iommu/20210127154322.3959196-7-jean-
>> philippe@linaro.org/
>> [2] https://lore.kernel.org/linux-iommu/f79f06be-e46b-a65a-3951-
>> 3e7dbfa66b4a@huawei.com/
> 
> Thanks
> Kevin
> 
