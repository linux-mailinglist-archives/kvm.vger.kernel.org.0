Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C445E368A70
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 03:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbhDWBgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 21:36:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17393 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbhDWBgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 21:36:46 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FRGzR4CGGzlZ8N;
        Fri, 23 Apr 2021 09:34:11 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Fri, 23 Apr 2021 09:36:05 +0800
Subject: Re: [PATCH v4 1/2] kvm/arm64: Remove the creation time's mapping of
 MMIO regions
To:     Gavin Shan <gshan@redhat.com>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-2-zhukeqian1@huawei.com>
 <ad39c796-2778-df26-b0c6-231e7626a747@redhat.com>
 <bd4d2cfc-37b9-f20a-5a5c-ed352d1a46dc@huawei.com>
 <f13bfc39-bee6-4562-fefc-76051bbf9735@redhat.com>
 <9eb47a6c-3c5c-cb4a-d1de-1a3ce1b60a87@huawei.com>
 <d185bbe1-4bb3-6a38-7a94-b0c52126e583@redhat.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
        Santosh Shukla <sashukla@nvidia.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <f521c845-610f-3efc-1713-9a01fb26f22f@huawei.com>
Date:   Fri, 23 Apr 2021 09:36:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <d185bbe1-4bb3-6a38-7a94-b0c52126e583@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On 2021/4/23 9:35, Gavin Shan wrote:
> Hi Keqian,
> 
> On 4/22/21 5:41 PM, Keqian Zhu wrote:
>> On 2021/4/22 10:12, Gavin Shan wrote:
>>> On 4/21/21 4:28 PM, Keqian Zhu wrote:
>>>> On 2021/4/21 14:38, Gavin Shan wrote:
>>>>> On 4/16/21 12:03 AM, Keqian Zhu wrote:
> 
> [...]
> 
>>>
>>> Yeah, Sorry that I missed that part. Something associated with Santosh's
>>> patch. The flag can be not existing until the page fault happened on
>>> the vma. In this case, the check could be not working properly.
>>>
>>>    [PATCH] KVM: arm64: Correctly handle the mmio faulting
>> Yeah, you are right.
>>
>> If that happens, we won't try to use block mapping for memslot with VM_PFNMAP.
>> But it keeps a same logic with old code.
>>
>> 1. When without dirty-logging, we won't try block mapping for it, and we'll
>> finally know that it's device, so won't try to do adjust THP (Transparent Huge Page)
>> for it.
>> 2. If userspace wrongly enables dirty logging for this memslot, we'll force_pte for it.
>>
> 
> It's not about the patch itself and just want more discussion to get more details.
> The patch itself looks good to me. I got two questions as below:
> 
> (1) The memslot fails to be added if it's backed by MMIO region and dirty logging is
> enabled in kvm_arch_prepare_memory_region(). As Santosh reported, the corresponding
> vma could be associated with MMIO region and VM_PFNMAP is missed. In this case,
> kvm_arch_prepare_memory_region() isn't returning error, meaning the memslot can be
> added successfully and block mapping isn't used, as you mentioned. The question is
> the memslot is added, but the expected result would be failure.
Sure. I think we could try to populate the final flag of vma in kvm_arch_prepare_memory_region().
Maybe through GUP or any better method? It's nice if you can try to solve this. :)

> 
> (2) If dirty logging is enabled on the MMIO memslot, everything should be fine. If
> the dirty logging isn't enabled and VM_PFNMAP isn't set yet in user_mem_abort(),
> block mapping won't be used and PAGE_SIZE is picked, but the failing IPA might
> be good candidate for block mapping. It means we miss something for blocking
> mapping?
Right. This issue also can be solved by populating the final flag of vma in kvm_arch_prepare_memory_region().


> 
> By the way, do you have idea why dirty logging can't be enabled on MMIO memslot?
IIUC, MMIO region is of device memory type, it's associated with device state and action.
For normal memory type, we can write it out-of-order and repeatedly, but for device memory
type, we can't do that. The write to MMIO will trigger device action based on current device
state, also what we can read from MMIO based on current device state. Thus the policy of
dirty logging for normal memory can't be applied to MMIO.



> I guess Marc might know the history. For example, QEMU is taking "/dev/mem" or
> "/dev/kmem" to back guest's memory, the vma is marked as MMIO, but dirty logging
> and migration isn't supported?
The MMIO region is a part of device state. We need extra kernel driver to support migration
of pass-through device, as how to save and restore the device state is closely related to
a specific type of device. You can refer VFIO migration for more detail.

Thanks,
Keqian
