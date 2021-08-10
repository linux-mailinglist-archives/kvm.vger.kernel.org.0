Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40383E5888
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 12:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbhHJKqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 06:46:30 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:45108 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236505AbhHJKqa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 06:46:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Uiadwy5_1628592365;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Uiadwy5_1628592365)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 Aug 2021 18:46:06 +0800
Subject: Re: [PATCH V2 2/3] KVM: X86: Set the hardware DR6 only when
 KVM_DEBUGREG_WONT_EXIT
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <YRFdq8sNuXYpgemU@google.com>
 <20210809174307.145263-1-jiangshanlai@gmail.com>
 <20210809174307.145263-2-jiangshanlai@gmail.com>
 <68ed0f5c-40f1-c240-4ad1-b435568cf753@redhat.com>
 <45fef019-8bd9-2acb-bd53-1243a8a07c4e@linux.alibaba.com>
 <f5967e16-3910-5604-7890-9a1741045ce8@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <7f86316b-5010-5250-4223-5a4d62f942c8@linux.alibaba.com>
Date:   Tue, 10 Aug 2021 18:46:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f5967e16-3910-5604-7890-9a1741045ce8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/8/10 18:35, Paolo Bonzini wrote:
> On 10/08/21 12:30, Lai Jiangshan wrote:
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index ae8e62df16dd..21a3ef3012cf 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -6625,6 +6625,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>           vmx->loaded_vmcs->host_state.cr4 = cr4;
>>>       }
>>>
>>> +    /* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
>>> +    if (vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
>>> +        set_debugreg(vcpu->arch.dr6, 6);
>>
>>
>> I also noticed the related code in svm.c, but I refrained myself
>> to add a new branch in vmx_vcpu_run().  But after I see you put
>> the code of resetting dr6 in vmx_sync_dirty_debug_regs(), the whole
>> solution is much clean and better.
>>
>> And if any chance you are also concern about the additional branch,
>> could you add a new callback to set dr6 and call the callback from
>> x86.c when KVM_DEBUGREG_WONT_EXIT.
> 
> The extra branch should be well predicted, and the idea you sketched below would cause DR6 to be marked uselessly as 
> dirty in SVM, so I think this is cleaner.  Let's add an "unlikely" around it too.

I'm OK with it. But I don't think the sketched idea would cause DR6 to be marked uselessly as dirty in SVM. It doesn't 
mark it dirty if the value is unchanged, and the value is always DR6_ACTIVE_LOW except when it just clears 
KVM_DEBUGREG_WONT_EXIT.

> 
> Paolo
> 
>> The possible implementation of the callback:
>> for vmx: set_debugreg(vcpu->arch.dr6, 6);
>> for svm: svm_set_dr6(svm, vcpu->arch.dr6);
>>           and always do svm_set_dr6(svm, DR6_ACTIVE_LOW); at the end of the
>>           svm_handle_exit().
>>
>> Thanks
>> Lai
>>
>>> +
>>>       /* When single-stepping over STI and MOV SS, we must clear the
>>>        * corresponding interruptibility bits in the guest state. Otherwise
>>>        * vmentry fails as it then expects bit 14 (BS) in pending debug
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index a111899ab2b4..fbc536b21585 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -9597,7 +9597,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>>           set_debugreg(vcpu->arch.eff_db[1], 1);
>>>           set_debugreg(vcpu->arch.eff_db[2], 2);
>>>           set_debugreg(vcpu->arch.eff_db[3], 3);
>>> -        set_debugreg(vcpu->arch.dr6, 6);
>>>       } else if (unlikely(hw_breakpoint_active())) {
>>>           set_debugreg(0, 7);
>>>       }
>>>
>>> Paolo
>>
