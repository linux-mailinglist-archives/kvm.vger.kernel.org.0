Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792403E585B
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 12:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhHJKar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 06:30:47 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:36890 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231688AbhHJKar (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 06:30:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UiadueK_1628591422;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UiadueK_1628591422)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 Aug 2021 18:30:23 +0800
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
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <45fef019-8bd9-2acb-bd53-1243a8a07c4e@linux.alibaba.com>
Date:   Tue, 10 Aug 2021 18:30:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <68ed0f5c-40f1-c240-4ad1-b435568cf753@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/8/10 18:07, Paolo Bonzini wrote:
> On 09/08/21 19:43, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> Commit c77fb5fe6f03 ("KVM: x86: Allow the guest to run with dirty debug
>> registers") allows the guest accessing to DRs without exiting when
>> KVM_DEBUGREG_WONT_EXIT and we need to ensure that they are synchronized
>> on entry to the guest---including DR6 that was not synced before the commit.
>>
>> But the commit sets the hardware DR6 not only when KVM_DEBUGREG_WONT_EXIT,
>> but also when KVM_DEBUGREG_BP_ENABLED.  The second case is unnecessary
>> and just leads to a more case which leaks stale DR6 to the host which has
>> to be resolved by unconditionally reseting DR6 in kvm_arch_vcpu_put().
>>
>> We'd better to set the hardware DR6 only when KVM_DEBUGREG_WONT_EXIT,
>> so that we can fine-grain control the cases when we need to reset it
>> which is done in later patch.
>>
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/x86.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ad47a09ce307..d2aa49722064 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9598,7 +9598,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>           set_debugreg(vcpu->arch.eff_db[1], 1);
>>           set_debugreg(vcpu->arch.eff_db[2], 2);
>>           set_debugreg(vcpu->arch.eff_db[3], 3);
>> -        set_debugreg(vcpu->arch.dr6, 6);
>> +        /* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
>> +        if (vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
>> +            set_debugreg(vcpu->arch.dr6, 6);
>>       } else if (unlikely(hw_breakpoint_active())) {
>>           set_debugreg(0, 7);
>>       }
>>
> 
> Even better, this should be moved to vmx.c's vcpu_enter_guest.  This
> matches the handling in svm.c:
> 
>          /*
>           * Run with all-zero DR6 unless needed, so that we can get the exact cause
>           * of a #DB.
>           */
>          if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
>                  svm_set_dr6(svm, vcpu->arch.dr6);
>          else
>                  svm_set_dr6(svm, DR6_ACTIVE_LOW);
> 
> That is,
> 
>      KVM: X86: Set the hardware DR6 only when KVM_DEBUGREG_WONT_EXIT
>      Commit c77fb5fe6f03 ("KVM: x86: Allow the guest to run with dirty debug
>      registers") allows the guest accessing to DRs without exiting when
>      KVM_DEBUGREG_WONT_EXIT and we need to ensure that they are synchronized
>      on entry to the guest---including DR6 that was not synced before the commit.
>      But the commit sets the hardware DR6 not only when KVM_DEBUGREG_WONT_EXIT,
>      but also when KVM_DEBUGREG_BP_ENABLED.  The second case is unnecessary
>      and just leads to a more case which leaks stale DR6 to the host which has
>      to be resolved by unconditionally reseting DR6 in kvm_arch_vcpu_put().
>      Even if KVM_DEBUGREG_WONT_EXIT, however, setting the host DR6 only matters
>      on VMX because SVM always uses the DR6 value from the VMCB.  So move this
>      line to vmx.c and make it conditional on KVM_DEBUGREG_WONT_EXIT.
>      Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ae8e62df16dd..21a3ef3012cf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6625,6 +6625,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>           vmx->loaded_vmcs->host_state.cr4 = cr4;
>       }
> 
> +    /* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
> +    if (vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
> +        set_debugreg(vcpu->arch.dr6, 6);


I also noticed the related code in svm.c, but I refrained myself
to add a new branch in vmx_vcpu_run().  But after I see you put
the code of resetting dr6 in vmx_sync_dirty_debug_regs(), the whole
solution is much clean and better.

And if any chance you are also concern about the additional branch,
could you add a new callback to set dr6 and call the callback from
x86.c when KVM_DEBUGREG_WONT_EXIT.

The possible implementation of the callback:
for vmx: set_debugreg(vcpu->arch.dr6, 6);
for svm: svm_set_dr6(svm, vcpu->arch.dr6);
          and always do svm_set_dr6(svm, DR6_ACTIVE_LOW); at the end of the
          svm_handle_exit().

Thanks
Lai

> +
>       /* When single-stepping over STI and MOV SS, we must clear the
>        * corresponding interruptibility bits in the guest state. Otherwise
>        * vmentry fails as it then expects bit 14 (BS) in pending debug
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a111899ab2b4..fbc536b21585 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9597,7 +9597,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>           set_debugreg(vcpu->arch.eff_db[1], 1);
>           set_debugreg(vcpu->arch.eff_db[2], 2);
>           set_debugreg(vcpu->arch.eff_db[3], 3);
> -        set_debugreg(vcpu->arch.dr6, 6);
>       } else if (unlikely(hw_breakpoint_active())) {
>           set_debugreg(0, 7);
>       }
> 
> Paolo
