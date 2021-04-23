Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62AE368A31
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 03:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbhDWBHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 21:07:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17392 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhDWBHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 21:07:09 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FRGKF14mpzlZ7r;
        Fri, 23 Apr 2021 09:04:33 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 23 Apr 2021 09:06:21 +0800
Subject: Re: [PATCH] KVM: arm64: Correctly handle the mmio faulting
To:     Santosh Shukla <santosh.shukla1982@gmail.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>
References: <1603297010-18787-1-git-send-email-sashukla@nvidia.com>
 <8b20dfc0-3b5e-c658-c47d-ebc50d20568d@huawei.com>
 <2e23aaa7-0c8d-13ba-2eae-9e6ab2adc587@redhat.com>
 <ed8a8b90-8b96-4967-01f5-cd0f536c38d2@huawei.com>
 <871rb3rgpl.wl-maz@kernel.org>
 <b97415a2-7970-a741-9690-3e4514b4aa7d@redhat.com>
 <87v98eq0dh.wl-maz@kernel.org>
 <bf782ec1-71da-5a8e-f250-20ed88677b8c@nvidia.com>
 <CACpj22xhXHMgsZHrL_2AbEzy=zzz=jXz0s6pRb0=zpJUai1ufg@mail.gmail.com>
CC:     Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-kernel@vger.kernel.org>, <cjia@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <c8b479d0-0766-ecb7-49fb-d94b715b0922@huawei.com>
Date:   Fri, 23 Apr 2021 09:06:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CACpj22xhXHMgsZHrL_2AbEzy=zzz=jXz0s6pRb0=zpJUai1ufg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/22 16:00, Santosh Shukla wrote:
> On Thu, Apr 22, 2021 at 1:07 PM Tarun Gupta (SW-GPU)
> <targupta@nvidia.com> wrote:
>>
>>
>>
>> On 4/22/2021 12:20 PM, Marc Zyngier wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> On Thu, 22 Apr 2021 03:02:00 +0100,
>>> Gavin Shan <gshan@redhat.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On 4/21/21 9:59 PM, Marc Zyngier wrote:
>>>>> On Wed, 21 Apr 2021 07:17:44 +0100,
>>>>> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>>>>> On 2021/4/21 14:20, Gavin Shan wrote:
>>>>>>> On 4/21/21 12:59 PM, Keqian Zhu wrote:
>>>>>>>> On 2020/10/22 0:16, Santosh Shukla wrote:
>>>>>>>>> The Commit:6d674e28 introduces a notion to detect and handle the
>>>>>>>>> device mapping. The commit checks for the VM_PFNMAP flag is set
>>>>>>>>> in vma->flags and if set then marks force_pte to true such that
>>>>>>>>> if force_pte is true then ignore the THP function check
>>>>>>>>> (/transparent_hugepage_adjust()).
>>>>>>>>>
>>>>>>>>> There could be an issue with the VM_PFNMAP flag setting and checking.
>>>>>>>>> For example consider a case where the mdev vendor driver register's
>>>>>>>>> the vma_fault handler named vma_mmio_fault(), which maps the
>>>>>>>>> host MMIO region in-turn calls remap_pfn_range() and maps
>>>>>>>>> the MMIO's vma space. Where, remap_pfn_range implicitly sets
>>>>>>>>> the VM_PFNMAP flag into vma->flags.
>>>>>>>> Could you give the name of the mdev vendor driver that triggers this issue?
>>>>>>>> I failed to find one according to your description. Thanks.
>>>>>>>>
>>>>>>>
>>>>>>> I think it would be fixed in driver side to set VM_PFNMAP in
>>>>>>> its mmap() callback (call_mmap()), like vfio PCI driver does.
>>>>>>> It means it won't be delayed until page fault is issued and
>>>>>>> remap_pfn_range() is called. It's determined from the beginning
>>>>>>> that the vma associated the mdev vendor driver is serving as
>>>>>>> PFN remapping purpose. So the vma should be populated completely,
>>>>>>> including the VM_PFNMAP flag before it becomes visible to user
>>>>>>> space.
>>>>>
>>>>> Why should that be a requirement? Lazy populating of the VMA should be
>>>>> perfectly acceptable if the fault can only happen on the CPU side.
>>>>>
> 
> Right.
> Hi keqian,
> You can refer to case
> http://lkml.iu.edu/hypermail/linux/kernel/2010.3/00952.html
Hi Santosh,

Yeah, thanks for that.

BRs,
Keqian
