Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0450A30518C
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 05:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbhA0E0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:26:06 -0500
Received: from mga05.intel.com ([192.55.52.43]:24395 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbhA0Bt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 20:49:29 -0500
IronPort-SDR: J0RjPeR94lEuMxR607VON9VktjuiEZlEldtLEcbc4XtZTwSu7ReZB6zF3c9tKHIXEL1iEeEd1N
 yYPzTCtCDNWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="264824538"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="264824538"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:48:43 -0800
IronPort-SDR: 9tuN3Fp+CybG/N9oZJtI7xtW4bd61dwTVO1z/ptvFtbasiC0wFjdNoWyUFpmWca0QmEbIwpvec
 aJYfOOt6AUnQ==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="388095597"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.1.32]) ([10.238.1.32])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:48:41 -0800
Subject: Re: [RESEND PATCH 1/2] KVM: X86: Add support for the emulation of
 DR6_BUS_LOCK bit
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210108064924.1677-1-chenyi.qiang@intel.com>
 <20210108064924.1677-2-chenyi.qiang@intel.com>
 <fc29c63f-7820-078a-7d92-4a7adf828067@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <5e81257e-df94-271e-3aef-cab54682174e@intel.com>
Date:   Wed, 27 Jan 2021 09:48:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <fc29c63f-7820-078a-7d92-4a7adf828067@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/27/2021 12:31 AM, Paolo Bonzini wrote:
> On 08/01/21 07:49, Chenyi Qiang wrote:
>> To avoid breaking the CPUs without bus lock detection, activate the
>> DR6_BUS_LOCK bit (bit 11) conditionally in DR6_FIXED_1 bits.
>>
>> The set/clear of DR6_BUS_LOCK is similar to the DR6_RTM in DR6
>> register. The processor clears DR6_BUS_LOCK when bus lock debug
>> exception is generated. (For all other #DB the processor sets this bit
>> to 1.) Software #DB handler should set this bit before returning to the
>> interrupted task.
>>
>> For VM exit caused by debug exception, bit 11 of the exit qualification
>> is set to indicate that a bus lock debug exception condition was
>> detected. The VMM should emulate the exception by clearing bit 11 of the
>> guest DR6.
> 
> Please rename DR6_INIT to DR6_ACTIVE_LOW, and then a lot of changes 
> become simpler:
> 
>> -        dr6 |= DR6_BD | DR6_RTM;
>> +        dr6 |= DR6_BD | DR6_RTM | DR6_BUS_LOCK;
> 
> dr6 |= DR6_BD | DR6_ACTIVE_LOW;
> 
>>           ctxt->ops->set_dr(ctxt, 6, dr6);
>>           return emulate_db(ctxt);
>>       }
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index cce0143a6f80..3d8a0e30314f 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1860,7 +1860,7 @@ static void svm_sync_dirty_debug_regs(struct 
>> kvm_vcpu *vcpu)
>>       get_debugreg(vcpu->arch.db[2], 2);
>>       get_debugreg(vcpu->arch.db[3], 3);
>>       /*
>> -     * We cannot reset svm->vmcb->save.dr6 to DR6_FIXED_1|DR6_RTM here,
>> +     * We cannot reset svm->vmcb->save.dr6 to 
>> DR6_FIXED_1|DR6_RTM|DR6_BUS_LOCK here,
> 
> We cannot reset svm->vmcb->save.dr6 to DR6_ACTIVE_LOW
> 
>>        * because db_interception might need it.  We can do it before 
>> vmentry.
>>        */
>>       vcpu->arch.dr6 = svm->vmcb->save.dr6;
>> @@ -1911,7 +1911,7 @@ static int db_interception(struct vcpu_svm *svm)
>>       if (!(svm->vcpu.guest_debug &
>>             (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
>>           !svm->nmi_singlestep) {
>> -        u32 payload = (svm->vmcb->save.dr6 ^ DR6_RTM) & ~DR6_FIXED_1;
>> +        u32 payload = (svm->vmcb->save.dr6 ^ (DR6_RTM|DR6_BUS_LOCK)) 
>> & ~DR6_FIXED_1;
> 
> u32 payload = svm->vmcb->save.dr6 ^ DR6_ACTIVE_LOW;
> 
>>           kvm_queue_exception_p(&svm->vcpu, DB_VECTOR, payload);
>>           return 1;
>>       }
>> @@ -3778,7 +3778,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct 
>> kvm_vcpu *vcpu)
>>       if (unlikely(svm->vcpu.arch.switch_db_regs & 
>> KVM_DEBUGREG_WONT_EXIT))
>>           svm_set_dr6(svm, vcpu->arch.dr6);
>>       else
>> -        svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM);
>> +        svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM | DR6_BUS_LOCK);
> 
> svm_set_dr6(svm, DR6_ACTIVE_LOW);
> 
>>       clgi();
>>       kvm_load_guest_xsave_state(vcpu);
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index e2f26564a12d..c5d71a9b3729 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -412,7 +412,7 @@ static int nested_vmx_check_exception(struct 
>> kvm_vcpu *vcpu, unsigned long *exit
>>               if (!has_payload) {
>>                   payload = vcpu->arch.dr6;
>>                   payload &= ~(DR6_FIXED_1 | DR6_BT);
>> -                payload ^= DR6_RTM;
>> +                payload ^= DR6_RTM | DR6_BUS_LOCK;
> 
> payload &= ~DR6_BT;
> payload ^= DR6_ACTIVE_LOW;
> 
>>               }
>>               *exit_qual = payload;
>>           } else
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3f7c1fc7a3ce..06de2b9e57f3 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -483,19 +483,20 @@ void kvm_deliver_exception_payload(struct 
>> kvm_vcpu *vcpu)
>>            */
>>           vcpu->arch.dr6 &= ~DR_TRAP_BITS;
>>           /*
>> -         * DR6.RTM is set by all #DB exceptions that don't clear it.
>> +         * DR6.RTM and DR6.BUS_LOCK are set by all #DB exceptions
>> +         * that don't clear it.
>>            */
>> -        vcpu->arch.dr6 |= DR6_RTM;
>> +        vcpu->arch.dr6 |= DR6_RTM | DR6_BUS_LOCK;
>>           vcpu->arch.dr6 |= payload;
>>           /*
>> -         * Bit 16 should be set in the payload whenever the #DB
>> -         * exception should clear DR6.RTM. This makes the payload
>> -         * compatible with the pending debug exceptions under VMX.
>> -         * Though not currently documented in the SDM, this also
>> -         * makes the payload compatible with the exit qualification
>> -         * for #DB exceptions under VMX.
>> +         * Bit 16/Bit 11 should be set in the payload whenever
>> +         * the #DB exception should clear DR6.RTM/DR6.BUS_LOCK.
>> +         * This makes the payload compatible with the pending debug
>> +         * exceptions under VMX. Though not currently documented in
>> +         * the SDM, this also makes the payload compatible with the
>> +         * exit qualification for #DB exceptions under VMX.
>>            */
>> -        vcpu->arch.dr6 ^= payload & DR6_RTM;
>> +        vcpu->arch.dr6 ^= payload & (DR6_RTM | DR6_BUS_LOCK);
> 
> vcpu->arch.dr6 &= ~DR_TRAP_BITS;
> vcpu->arch.dr6 |= DR6_ACTIVE_LOW;
> vcpu->arch.dr6 |= payload;
> vcpu->arch.dr6 ^= payload & DR6_ACTIVE_LOW;
> 
> (with comments :))
> 
> and so on.
> 
> Thanks!
> 
> Paolo
> 

Will do the changes.

Thanks!
Chenyi

>>           /*
>>            * The #DB payload is defined as compatible with the 'pending
>> @@ -1126,6 +1127,9 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
>>       if (!guest_cpuid_has(vcpu, X86_FEATURE_RTM))
>>           fixed |= DR6_RTM;
>> +
>> +    if (!guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
>> +        fixed |= DR6_BUS_LOCK;
>>       return fixed;
>>   }
>> @@ -7197,7 +7201,8 @@ static int kvm_vcpu_do_singlestep(struct 
>> kvm_vcpu *vcpu)
>>       struct kvm_run *kvm_run = vcpu->run;
>>       if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
>> -        kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM;
>> +        kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM |
>> +                      DR6_BUS_LOCK;
>>           kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
>>           kvm_run->debug.arch.exception = DB_VECTOR;
>>           kvm_run->exit_reason = KVM_EXIT_DEBUG;
>> @@ -7241,7 +7246,8 @@ static bool kvm_vcpu_check_breakpoint(struct 
>> kvm_vcpu *vcpu, int *r)
>>                          vcpu->arch.eff_db);
>>           if (dr6 != 0) {
>> -            kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
>> +            kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM |
>> +                          DR6_BUS_LOCK;
>>               kvm_run->debug.arch.pc = eip;
>>               kvm_run->debug.arch.exception = DB_VECTOR;
>>               kvm_run->exit_reason = KVM_EXIT_DEBUG;
>>
> 
