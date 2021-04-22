Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E57367B45
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 09:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbhDVHmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 03:42:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17389 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhDVHmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 03:42:18 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FQq7g5J1TzjbVK;
        Thu, 22 Apr 2021 15:39:43 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 22 Apr 2021 15:41:34 +0800
Subject: Re: [PATCH v4 1/2] kvm/arm64: Remove the creation time's mapping of
 MMIO regions
To:     Gavin Shan <gshan@redhat.com>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-2-zhukeqian1@huawei.com>
 <ad39c796-2778-df26-b0c6-231e7626a747@redhat.com>
 <bd4d2cfc-37b9-f20a-5a5c-ed352d1a46dc@huawei.com>
 <f13bfc39-bee6-4562-fefc-76051bbf9735@redhat.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
        Santosh Shukla <sashukla@nvidia.com>
Message-ID: <9eb47a6c-3c5c-cb4a-d1de-1a3ce1b60a87@huawei.com>
Date:   Thu, 22 Apr 2021 15:41:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <f13bfc39-bee6-4562-fefc-76051bbf9735@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On 2021/4/22 10:12, Gavin Shan wrote:
> Hi Keqian,
> 
> On 4/21/21 4:28 PM, Keqian Zhu wrote:
>> On 2021/4/21 14:38, Gavin Shan wrote:
>>> On 4/16/21 12:03 AM, Keqian Zhu wrote:
>>>> The MMIO regions may be unmapped for many reasons and can be remapped
>>>> by stage2 fault path. Map MMIO regions at creation time becomes a
>>>> minor optimization and makes these two mapping path hard to sync.
>>>>
>>>> Remove the mapping code while keep the useful sanity check.
>>>>
>>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>>> ---
>>>>    arch/arm64/kvm/mmu.c | 38 +++-----------------------------------
>>>>    1 file changed, 3 insertions(+), 35 deletions(-)
>>>>
>>>
>>> After removing the logic to create stage2 mapping for VM_PFNMAP region,
>>> I think the "do { } while" loop becomes unnecessary and can be dropped
>>> completely. It means the only sanity check is to see if the memory slot
>>> overflows IPA space or not. In that case, KVM_MR_FLAGS_ONLY can be
>>> ignored because the memory slot's base address and length aren't changed
>>> when we have KVM_MR_FLAGS_ONLY.
>> Maybe not exactly. Here we do an important sanity check that we shouldn't
>> log dirty for memslots with VM_PFNMAP.
>>
> 
> Yeah, Sorry that I missed that part. Something associated with Santosh's
> patch. The flag can be not existing until the page fault happened on
> the vma. In this case, the check could be not working properly.
> 
>   [PATCH] KVM: arm64: Correctly handle the mmio faulting
Yeah, you are right.

If that happens, we won't try to use block mapping for memslot with VM_PFNMAP.
But it keeps a same logic with old code.

1. When without dirty-logging, we won't try block mapping for it, and we'll
finally know that it's device, so won't try to do adjust THP (Transparent Huge Page)
for it.
2. If userspace wrongly enables dirty logging for this memslot, we'll force_pte for it.

Thanks,
Keqian
