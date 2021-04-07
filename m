Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE513560D2
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 03:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343545AbhDGBcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 21:32:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15617 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243397AbhDGBcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 21:32:14 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FFRdr26qKz18HS3;
        Wed,  7 Apr 2021 09:29:52 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 09:31:59 +0800
Subject: Re: [PATCH] KVM: MMU: protect TDP MMU pages only down to required
 level
To:     Sean Christopherson <seanjc@google.com>
References: <20210402121704.3424115-1-pbonzini@redhat.com>
 <8d9b028b-1e3a-b4eb-5d44-604ddab6560e@huawei.com>
 <YGzw/77+zCNri22Z@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <ef75a78b-aa3a-e1b9-96b7-37425f3d9165@huawei.com>
Date:   Wed, 7 Apr 2021 09:31:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YGzw/77+zCNri22Z@google.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/7 7:38, Sean Christopherson wrote:
> On Tue, Apr 06, 2021, Keqian Zhu wrote:
>> Hi Paolo,
>>
>> I'm just going to fix this issue, and found that you have done this ;-)
> 
> Ha, and meanwhile I'm having a serious case of deja vu[1].  It even received a
> variant of the magic "Queued, thanks"[2].  Doesn't appear in either of the 5.12
> pull requests though, must have gotten lost along the way.
Good job. We should pick them up :)

> 
> [1] https://lkml.kernel.org/r/20210213005015.1651772-3-seanjc@google.com
> [2] https://lkml.kernel.org/r/b5ab72f2-970f-64bd-891c-48f1c303548d@redhat.com
> 
>> Please feel free to add:
>>
>> Reviewed-by: Keqian Zhu <zhukeqian1@huawei.com>
>>
>> Thanks,
>> Keqian
>>
>> On 2021/4/2 20:17, Paolo Bonzini wrote:
>>> When using manual protection of dirty pages, it is not necessary
>>> to protect nested page tables down to the 4K level; instead KVM
>>> can protect only hugepages in order to split them lazily, and
>>> delay write protection at 4K-granularity until KVM_CLEAR_DIRTY_LOG.
>>> This was overlooked in the TDP MMU, so do it there as well.
>>>
>>> Fixes: a6a0b05da9f37 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
>>> Cc: Ben Gardon <bgardon@google.com>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>  arch/x86/kvm/mmu/mmu.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index efb41f31e80a..0d92a269c5fa 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -5538,7 +5538,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>>>  	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
>>>  				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
>>>  	if (is_tdp_mmu_enabled(kvm))
>>> -		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
>>> +		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
>>>  	write_unlock(&kvm->mmu_lock);
>>>  
>>>  	/*
>>>
> .
> 
