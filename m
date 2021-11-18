Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396F5455DD1
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhKROU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:20:59 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:56597 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232956AbhKROU6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 09:20:58 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UxD7xV7_1637245074;
Received: from 192.168.2.97(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UxD7xV7_1637245074)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Nov 2021 22:17:55 +0800
Message-ID: <e2c646a1-7e02-5dc5-0f02-1b4247772a69@linux.alibaba.com>
Date:   Thu, 18 Nov 2021 22:17:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 02/15] KVM: VMX: Avoid to rdmsrl(MSR_IA32_SYSENTER_ESP)
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-3-jiangshanlai@gmail.com>
 <94d4b7d8-1e56-69e9-dd52-d154bee6c461@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <94d4b7d8-1e56-69e9-dd52-d154bee6c461@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/11/18 19:18, Paolo Bonzini wrote:
> On 11/18/21 12:08, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> The value of host MSR_IA32_SYSENTER_ESP is known to be constant for
>> each CPU: (cpu_entry_stack(cpu) + 1) when 32 bit syscall is enabled or
>> NULL is 32 bit syscall is not enabled.
>>
>> So rdmsrl() can be avoided for the first case and both rdmsrl() and
>> vmcs_writel() can be avoided for the second case.
>>
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Then it's not constant host state, isn't?  The hunk in vmx_set_constant_host_state seems wrong.
> 

The change in vmx_vcpu_load_vmcs() handles only the percpu constant case:
(cpu_entry_stack(cpu) + 1), it doesn't handle the case where
MSR_IA32_SYSENTER_ESP is NULL.

The change in vmx_set_constant_host_state() handles the case where
MSR_IA32_SYSENTER_ESP is NULL, it does be constant host state in this case.
If it is not the case, the added code in vmx_vcpu_load_vmcs() will override
it safely.

If an else branch with "vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);" is added to
vmx_vcpu_load_vmcs(), we will not need to change vmx_set_constant_host_state().

-		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
-		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
+		if (IS_ENABLED(CONFIG_IA32_EMULATION) || IS_ENABLED(CONFIG_X86_32)) {
+			/* 22.2.3 */
+			vmcs_writel(HOST_IA32_SYSENTER_ESP,
+				    (unsigned long)(cpu_entry_stack(cpu) + 1));
+		} else {
+			vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);
+		}


I'm paranoid about the case when vmcs.HOST_IA32_SYSENTER_ESP is not reset to be
NULL when the vcpu is reset.  So the hunk in vmx_set_constant_host_state() or
the else branch in vmx_vcpu_load_vmcs() is required. I just chose to change
the vmx_set_constant_host_state() so that we can reduce a vmcs_writel() in the
case where CONFIG_IA32_EMULATION is off in x86_64.

> Paolo
> 
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 48a34d1a2989..4e4a33226edb 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1271,7 +1271,6 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>>       if (!already_loaded) {
>>           void *gdt = get_current_gdt_ro();
>> -        unsigned long sysenter_esp;
>>           /*
>>            * Flush all EPTP/VPID contexts, the new pCPU may have stale
>> @@ -1287,8 +1286,11 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>>                   (unsigned long)&get_cpu_entry_area(cpu)->tss.x86_tss);
>>           vmcs_writel(HOST_GDTR_BASE, (unsigned long)gdt);   /* 22.2.4 */
>> -        rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
>> -        vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
>> +        if (IS_ENABLED(CONFIG_IA32_EMULATION) || IS_ENABLED(CONFIG_X86_32)) {
>> +            /* 22.2.3 */
>> +            vmcs_writel(HOST_IA32_SYSENTER_ESP,
>> +                    (unsigned long)(cpu_entry_stack(cpu) + 1));
>> +        }
>>           vmx->loaded_vmcs->cpu = cpu;
>>       }
>> @@ -4021,6 +4023,8 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
>>       rdmsr(MSR_IA32_SYSENTER_CS, low32, high32);
>>       vmcs_write32(HOST_IA32_SYSENTER_CS, low32);
>> +    rdmsrl(MSR_IA32_SYSENTER_ESP, tmpl);
>> +    vmcs_writel(HOST_IA32_SYSENTER_ESP, tmpl);
>>       rdmsrl(MSR_IA32_SYSENTER_EIP, tmpl);
>>       vmcs_writel(HOST_IA32_SYSENTER_EIP, tmpl);   /* 22.2.3 */
> 
