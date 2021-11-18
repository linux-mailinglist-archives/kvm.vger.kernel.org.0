Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67426456071
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 17:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhKRQbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 11:31:49 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:32953 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233086AbhKRQbs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 11:31:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Uv6jhz._1637252923;
Received: from 30.30.94.206(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Uv6jhz._1637252923)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Nov 2021 00:28:45 +0800
Message-ID: <55654594-9967-37d2-335b-5035f99212fe@linux.alibaba.com>
Date:   Fri, 19 Nov 2021 00:28:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 13/15] KVM: SVM: Add and use svm_register_cache_reset()
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211108124407.12187-14-jiangshanlai@gmail.com>
 <937c373e-80f4-38d9-b45a-a655dcb66569@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <937c373e-80f4-38d9-b45a-a655dcb66569@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/11/18 23:37, Paolo Bonzini wrote:
> On 11/8/21 13:44, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> It resets all the appropriate bits like vmx.
>>
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/svm/svm.c |  3 +--
>>   arch/x86/kvm/svm/svm.h | 26 ++++++++++++++++++++++++++
>>   2 files changed, 27 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index b7da66935e72..ba9cfddd2875 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3969,8 +3969,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>       svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
>>       vmcb_mark_all_clean(svm->vmcb);
>> -
>> -    kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
>> +    svm_register_cache_reset(vcpu);
>>       /*
>>        * We need to handle MC intercepts here before the vcpu has a chance to
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 0d7bbe548ac3..1cf5d5e2d0cd 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -274,6 +274,32 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
>>           return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
>>   }
>> +static inline void svm_register_cache_reset(struct kvm_vcpu *vcpu)
>> +{
>> +/*
>> + * SVM_REGS_AVAIL_SET - The set of registers that will be updated in cache on
>> + *            demand.  Other registers not listed here are synced to
>> + *            the cache immediately after VM-Exit.
>> + *
>> + * SVM_REGS_DIRTY_SET - The set of registers that might be outdated in
>> + *            architecture. Other registers not listed here are synced
>> + *            to the architecture immediately when modifying.
>> + *
>> + *            Special case: VCPU_EXREG_CR3 should be in this set due
>> + *            to the fact.  But KVM_REQ_LOAD_MMU_PGD is always
>> + *            requested when the cache vcpu->arch.cr3 is changed and
>> + *            svm_load_mmu_pgd() always syncs the new CR3 value into
>> + *            the architecture.  So the dirty information of
>> + *            VCPU_EXREG_CR3 is not used which means VCPU_EXREG_CR3
>> + *            isn't required to be put in this set.
>> + */
>> +#define SVM_REGS_AVAIL_SET    (1 << VCPU_EXREG_PDPTR)
>> +#define SVM_REGS_DIRTY_SET    (0)
>> +
>> +    vcpu->arch.regs_avail &= ~SVM_REGS_AVAIL_SET;
>> +    vcpu->arch.regs_dirty &= ~SVM_REGS_DIRTY_SET;
>> +}
> 
> I think touching regs_dirty is confusing here, so I'd go with this:

It makes the code the same as vmx by clearing all the SVM_REGS_DIRTY_SET
bits.  And the compiler will remove this line of code since
SVM_REGS_DIRTY_SET is (0), and regs_dirty is not touched.

Using VMX_REGS_DIRTY_SET and SVM_REGS_DIRTY_SET and making the code
similar is my intent for patch12,13.  If it causes confusing, I would
like to make a second thought.  SVM_REGS_DIRTY_SET does be special
in svm where VCPU_EXREG_CR3 is in it by definition, but it is not
added into SVM_REGS_DIRTY_SET in the patch just for optimization to allow
the compiler optimizes the line of code out.

I'm Ok to not queue patch12,13,14.

> 
>          vcpu->arch.regs_avail &= ~SVM_REGS_LAZY_LOAD_SET;
> 
>          /*
>           * SVM does not use vcpu->arch.regs_dirty.  The only register that
>           * might be out of date in the VMCB is CR3, but KVM_REQ_LOAD_MMU_PGD
>           * is always requested when the cache vcpu->arch.cr3 is changed and
>           * svm_load_mmu_pgd() always syncs the new CR3 value into the VMCB.
>           */
> 
> (VMX instead needs VCPU_EXREG_CR3 mostly because it does not want to
> update it unconditionally on exit).
> 
> Paolo
