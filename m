Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCD33E586D
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 12:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239826AbhHJKfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 06:35:20 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:48209 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238459AbhHJKfS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 06:35:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Uiayl.7_1628591694;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Uiayl.7_1628591694)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 Aug 2021 18:34:55 +0800
Subject: Re: [PATCH V2 3/3] KVM: X86: Reset DR6 only when
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
 <20210809174307.145263-3-jiangshanlai@gmail.com>
 <f07b99f1-5a25-a246-9ef9-2b875d960675@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <7a1ca89f-7b4e-7df2-e47a-ac5207137a05@linux.alibaba.com>
Date:   Tue, 10 Aug 2021 18:34:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f07b99f1-5a25-a246-9ef9-2b875d960675@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/8/10 18:14, Paolo Bonzini wrote:
> On 09/08/21 19:43, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> The commit efdab992813fb ("KVM: x86: fix escape of guest dr6 to the host")
>> fixed a bug by reseting DR6 unconditionally when the vcpu being scheduled out.
>>
>> But writing to debug registers is slow, and it can be shown in perf results
>> sometimes even neither the host nor the guest activate breakpoints.
>>
>> It'd be better to reset it conditionally and this patch moves the code of
>> reseting DR6 to the path of VM-exit and only reset it when
>> KVM_DEBUGREG_WONT_EXIT which is the only case that DR6 is guest value.
>>
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/x86.c | 8 ++------
>>   1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index d2aa49722064..f40cdd7687d8 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4309,12 +4309,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>       static_call(kvm_x86_vcpu_put)(vcpu);
>>       vcpu->arch.last_host_tsc = rdtsc();
>> -    /*
>> -     * If userspace has set any breakpoints or watchpoints, dr6 is restored
>> -     * on every vmexit, but if not, we might have a stale dr6 from the
>> -     * guest. do_debug expects dr6 to be cleared after it runs, do the same.
>> -     */
>> -    set_debugreg(0, 6);
>>   }
>>   static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
>> @@ -9630,6 +9624,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>           static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
>>           kvm_update_dr0123(vcpu);
>>           kvm_update_dr7(vcpu);
>> +        /* Reset Dr6 which is guest value. */
>> +        set_debugreg(DR6_RESERVED, 6);
>>       }
>>       /*
>>
> 
> ... and this should also be done exclusively for VMX, in vmx_sync_dirty_debug_regs:
> 
>      KVM: VMX: Reset DR6 only when KVM_DEBUGREG_WONT_EXIT
>      The commit efdab992813fb ("KVM: x86: fix escape of guest dr6 to the host")
>      fixed a bug by resetting DR6 unconditionally when the vcpu being scheduled out.
>      But writing to debug registers is slow, and it can be visible in perf results
>      sometimes, even if neither the host nor the guest activate breakpoints.
>      Since KVM_DEBUGREG_WONT_EXIT on Intel processors is the only case
>      where DR6 gets the guest value, and it never happens at all on SVM,
>      the register can be cleared in vmx.c right after reading it.
>      Reported-by: Lai Jiangshan <laijs@linux.alibaba.com>
>      Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 21a3ef3012cf..3a91302d05c0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5110,6 +5110,12 @@ static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
> 
>       vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
>       exec_controls_setbit(to_vmx(vcpu), CPU_BASED_MOV_DR_EXITING);
> +
> +    /*
> +     * do_debug expects dr6 to be cleared after it runs, avoid that it sees
> +     * a stale dr6 from the guest.
> +     */


do_debug() is renamed. Maybe you can use "The host kernel #DB handler".


> +    set_debugreg(DR6_RESERVED, 6);
>   }
> 
>   static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fbc536b21585..04c393551fb0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4313,12 +4313,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> 
>       static_call(kvm_x86_vcpu_put)(vcpu);
>       vcpu->arch.last_host_tsc = rdtsc();
> -    /*
> -     * If userspace has set any breakpoints or watchpoints, dr6 is restored
> -     * on every vmexit, but if not, we might have a stale dr6 from the
> -     * guest. do_debug expects dr6 to be cleared after it runs, do the same.
> -     */
> -    set_debugreg(0, 6);
>   }
> 
>   static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
> 
> 
> Paolo
