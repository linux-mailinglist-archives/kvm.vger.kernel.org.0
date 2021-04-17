Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4AC362C92
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 03:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhDQBFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 21:05:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16132 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhDQBFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 21:05:40 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FMZYP6ZQxzpZ7j;
        Sat, 17 Apr 2021 09:02:17 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 09:05:05 +0800
Subject: Re: [PATCH v4 2/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To:     Marc Zyngier <maz@kernel.org>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-3-zhukeqian1@huawei.com>
 <8f55b64f-b4dd-700e-c997-8de9c5ea282f@huawei.com>
 <87a6py2ss9.wl-maz@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <d8af7360-ee96-2344-336d-bfaf8828fc8e@huawei.com>
Date:   Sat, 17 Apr 2021 09:05:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <87a6py2ss9.wl-maz@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2021/4/16 22:44, Marc Zyngier wrote:
> On Thu, 15 Apr 2021 15:08:09 +0100,
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>
>> Hi Marc,
>>
>> On 2021/4/15 22:03, Keqian Zhu wrote:
>>> The MMIO region of a device maybe huge (GB level), try to use
>>> block mapping in stage2 to speedup both map and unmap.
>>>
>>> Compared to normal memory mapping, we should consider two more
>>> points when try block mapping for MMIO region:
>>>
>>> 1. For normal memory mapping, the PA(host physical address) and
>>> HVA have same alignment within PUD_SIZE or PMD_SIZE when we use
>>> the HVA to request hugepage, so we don't need to consider PA
>>> alignment when verifing block mapping. But for device memory
>>> mapping, the PA and HVA may have different alignment.
>>>
>>> 2. For normal memory mapping, we are sure hugepage size properly
>>> fit into vma, so we don't check whether the mapping size exceeds
>>> the boundary of vma. But for device memory mapping, we should pay
>>> attention to this.
>>>
>>> This adds get_vma_page_shift() to get page shift for both normal
>>> memory and device MMIO region, and check these two points when
>>> selecting block mapping size for MMIO region.
>>>
>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>> ---
>>>  arch/arm64/kvm/mmu.c | 61 ++++++++++++++++++++++++++++++++++++--------
>>>  1 file changed, 51 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index c59af5ca01b0..5a1cc7751e6d 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -738,6 +738,35 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>>>  	return PAGE_SIZE;
>>>  }
>>>  
[...]

>>> +	/*
>>> +	 * logging_active is guaranteed to never be true for VM_PFNMAP
>>> +	 * memslots.
>>> +	 */
>>> +	if (logging_active) {
>>>  		force_pte = true;
>>>  		vma_shift = PAGE_SHIFT;
>>> +	} else {
>>> +		vma_shift = get_vma_page_shift(vma, hva);
>>>  	}
>> I use a if/else manner in v4, please check that. Thanks very much!
> 
> That's fine. However, it is getting a bit late for 5.13, and we don't
> have much time to left it simmer in -next. I'll probably wait until
> after the merge window to pick it up.
OK, no problem. Thanks! :)

BRs,
Keqian
