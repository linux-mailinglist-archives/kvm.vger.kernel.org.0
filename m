Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281F23983E9
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 10:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhFBIOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 04:14:48 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:37530 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229583AbhFBIOp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 04:14:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0Ub1gYK1_1622621580;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Ub1gYK1_1622621580)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Jun 2021 16:13:01 +0800
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
 <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
 <YK/FGYejaIu6EzSn@google.com>
 <d96f8c11-19e6-2c2d-91ff-6a7a51fa1b9c@linux.alibaba.com>
 <YLA4peMjgeVvKlEn@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <dda200b3-5037-1c38-5780-7b154a5aebcc@linux.alibaba.com>
Date:   Wed, 2 Jun 2021 16:13:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YLA4peMjgeVvKlEn@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/5/28 08:26, Sean Christopherson wrote:
> On Fri, May 28, 2021, Lai Jiangshan wrote:
>>
>> On 2021/5/28 00:13, Sean Christopherson wrote:
>>> And making a request won't work without revamping the order of request handling
>>> in vcpu_enter_guest(), e.g. KVM_REQ_MMU_RELOAD and KVM_REQ_MMU_SYNC are both
>>> serviced before KVM_REQ_STEAL_UPDATE.
>>
>> Yes, it just fixes the said problem in the simplest way.
>> I copied KVM_REQ_MMU_RELOAD from kvm_handle_invpcid(INVPCID_TYPE_ALL_INCL_GLOBAL).
>> (If the guest is not preempted, it will call invpcid_flush_all() and will be handled
>> by this way)
> 
> The problem is that record_steal_time() is called after KVM_REQ_MMU_RELOAD
> in vcpu_enter_guest() and so the reload request won't be recognized until the
> next VM-Exit.  It works for kvm_handle_invpcid() because vcpu_enter_guest() is
> guaranteed to run between the invcpid code and VM-Enter.
> 
>> The improvement code will go later, and will not be backported.
> 
> I would argue that introducing a potential performance regression is in itself a
> bug.  IMO, going straight to kvm_mmu_sync_roots() is not high risk.

Hello, Sean

Patch V2 address all these concerns. And it uses the minimal fix as you
suggested in your previous reply (fix it directly in kvm_vcpu_flush_tlb_guest())

Could you have a review again please?

Thanks
Lai.

> 
>> The proper way to flush guest is to use code in
>>
>> https://lore.kernel.org/lkml/20210525213920.3340-1-jiangshanlai@gmail.com/
>> as:
>> +		kvm_mmu_sync_roots(vcpu);
>> +		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu); //or just call flush_current directly
>> +		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>> +			vcpu->arch.mmu->prev_roots[i].need_sync = true;
>>
>> If need_sync patch is not accepted, we can just use kvm_mmu_sync_roots(vcpu)
>> to keep the current pagetable and use kvm_mmu_free_roots() to free all the other
>> roots in prev_roots.
> 
> I like the idea, I just haven't gotten around to reviewing that patch yet.
> 
>>> Cleaning up and documenting the MMU related requests is on my todo list, but the
>>> immediate fix should be tiny and I can do my cleanups on top.
>>>
>>> I believe the minimal fix is:
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 81ab3b8f22e5..b0072063f9bf 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -3072,6 +3072,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>>>    static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>>>    {
>>>           ++vcpu->stat.tlb_flush;
>>> +
>>> +       if (!tdp_enabled)
>>> +               kvm_mmu_sync_roots(vcpu);
>>
>> it doesn't handle prev_roots which are also needed as
>> shown in kvm_handle_invpcid(INVPCID_TYPE_ALL_INCL_GLOBAL).
> 
> Ya, I belated realized this :-)
> 
>>>           static_call(kvm_x86_tlb_flush_guest)(vcpu);
>>
>> For tdp_enabled, I think it is better to use kvm_x86_tlb_flush_current()
>> to make it consistent with other shadowpage code.
>>
>>>    }
>>>
