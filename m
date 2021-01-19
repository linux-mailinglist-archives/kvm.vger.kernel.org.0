Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E252FB3BE
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 09:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbhASII0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 03:08:26 -0500
Received: from mga03.intel.com ([134.134.136.65]:32420 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbhASHmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 02:42:23 -0500
IronPort-SDR: FkAC0hu5drjun0LnJNkJgpYQIlixtK72hetvPXETKKo+Y18+N4yte6f4pAOgxVGa5qKVw3Kraa
 MUYcwUxWibvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="178977520"
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="178977520"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 23:41:22 -0800
IronPort-SDR: i/YlalNHDIxoeQPHAJGW+QdWZ4Se1tdYlC32zujte0nE3cTrzqcCJq8Zbome37Zi0sdThEyGc3
 eobWMvhkjTQg==
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="426375711"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.1.32]) ([10.238.1.32])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 23:41:19 -0800
Subject: Re: [kvm-unit-tests PATCH] x86: Add tests for PKS
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201105081805.5674-1-chenyi.qiang@intel.com>
 <20201105081805.5674-9-chenyi.qiang@intel.com>
 <6174185b-25e0-f2a2-3f71-d8bbe6ca889d@redhat.com>
 <7aa67008-a72f-f6e3-2de4-4b9b9e62cd86@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <e1ba2803-877c-e7d5-0a16-f356d5c2b571@intel.com>
Date:   Tue, 19 Jan 2021 15:41:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <7aa67008-a72f-f6e3-2de4-4b9b9e62cd86@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/19/2021 2:27 AM, Paolo Bonzini wrote:
> On 18/01/21 18:45, Thomas Huth wrote:
>> On 05/11/2020 09.18, Chenyi Qiang wrote:
>>> This unit-test is intended to test the KVM support for Protection Keys
>>> for Supervisor Pages (PKS). If CR4.PKS is set in long mode, supervisor
>>> pkeys are checked in addition to normal paging protections and Access or
>>> Write can be disabled via a MSR update without TLB flushes when
>>> permissions change.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>>   lib/x86/msr.h       |   1 +
>>>   lib/x86/processor.h |   2 +
>>>   x86/Makefile.x86_64 |   1 +
>>>   x86/pks.c           | 146 ++++++++++++++++++++++++++++++++++++++++++++
>>>   x86/unittests.cfg   |   5 ++
>>>   5 files changed, 155 insertions(+)
>>>   create mode 100644 x86/pks.c
>>>
>>> diff --git a/lib/x86/msr.h b/lib/x86/msr.h
>>> index 6ef5502..e36934b 100644
>>> --- a/lib/x86/msr.h
>>> +++ b/lib/x86/msr.h
>>> @@ -209,6 +209,7 @@
>>>   #define MSR_IA32_EBL_CR_POWERON        0x0000002a
>>>   #define MSR_IA32_FEATURE_CONTROL        0x0000003a
>>>   #define MSR_IA32_TSC_ADJUST        0x0000003b
>>> +#define MSR_IA32_PKRS            0x000006e1
>>>   #define FEATURE_CONTROL_LOCKED                (1<<0)
>>>   #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX    (1<<1)
>>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>>> index 74a2498..985fdd0 100644
>>> --- a/lib/x86/processor.h
>>> +++ b/lib/x86/processor.h
>>> @@ -50,6 +50,7 @@
>>>   #define X86_CR4_SMEP   0x00100000
>>>   #define X86_CR4_SMAP   0x00200000
>>>   #define X86_CR4_PKE    0x00400000
>>> +#define X86_CR4_PKS    0x01000000
>>>   #define X86_EFLAGS_CF    0x00000001
>>>   #define X86_EFLAGS_FIXED 0x00000002
>>> @@ -157,6 +158,7 @@ static inline u8 cpuid_maxphyaddr(void)
>>>   #define    X86_FEATURE_RDPID        (CPUID(0x7, 0, ECX, 22))
>>>   #define    X86_FEATURE_SPEC_CTRL        (CPUID(0x7, 0, EDX, 26))
>>>   #define    X86_FEATURE_ARCH_CAPABILITIES    (CPUID(0x7, 0, EDX, 29))
>>> +#define    X86_FEATURE_PKS            (CPUID(0x7, 0, ECX, 31))
>>>   #define    X86_FEATURE_NX            (CPUID(0x80000001, 0, EDX, 20))
>>>   #define    X86_FEATURE_RDPRU        (CPUID(0x80000008, 0, EBX, 4))
>>> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
>>> index af61d85..3a353df 100644
>>> --- a/x86/Makefile.x86_64
>>> +++ b/x86/Makefile.x86_64
>>> @@ -20,6 +20,7 @@ tests += $(TEST_DIR)/tscdeadline_latency.flat
>>>   tests += $(TEST_DIR)/intel-iommu.flat
>>>   tests += $(TEST_DIR)/vmware_backdoors.flat
>>>   tests += $(TEST_DIR)/rdpru.flat
>>> +tests += $(TEST_DIR)/pks.flat
>>>   include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>>> diff --git a/x86/pks.c b/x86/pks.c
>>> new file mode 100644
>>> index 0000000..a3044cf
>>> --- /dev/null
>>> +++ b/x86/pks.c
>>> @@ -0,0 +1,146 @@
>>> +#include "libcflat.h"
>>> +#include "x86/desc.h"
>>> +#include "x86/processor.h"
>>> +#include "x86/vm.h"
>>> +#include "x86/msr.h"
>>> +
>>> +#define CR0_WP_MASK      (1UL << 16)
>>> +#define PTE_PKEY_BIT     59
>>> +#define SUPER_BASE        (1 << 24)
>>> +#define SUPER_VAR(v)      (*((__typeof__(&(v))) (((unsigned long)&v) 
>>> + SUPER_BASE)))
>>> +
>>> +volatile int pf_count = 0;
>>> +volatile unsigned save;
>>> +volatile unsigned test;
>>> +
>>> +static void set_cr0_wp(int wp)
>>> +{
>>> +    unsigned long cr0 = read_cr0();
>>> +
>>> +    cr0 &= ~CR0_WP_MASK;
>>> +    if (wp)
>>> +        cr0 |= CR0_WP_MASK;
>>> +    write_cr0(cr0);
>>> +}
>>> +
>>> +void do_pf_tss(unsigned long error_code);
>>> +void do_pf_tss(unsigned long error_code)
>>> +{
>>> +    printf("#PF handler, error code: 0x%lx\n", error_code);
>>> +    pf_count++;
>>> +    save = test;
>>> +    wrmsr(MSR_IA32_PKRS, 0);
>>> +}
>>> +
>>> +extern void pf_tss(void);
>>> +
>>> +asm ("pf_tss: \n\t"
>>> +#ifdef __x86_64__
>>> +    // no task on x86_64, save/restore caller-save regs
>>> +    "push %rax; push %rcx; push %rdx; push %rsi; push %rdi\n"
>>> +    "push %r8; push %r9; push %r10; push %r11\n"
>>> +    "mov 9*8(%rsp), %rdi\n"
>>> +#endif
>>> +    "call do_pf_tss \n\t"
>>> +#ifdef __x86_64__
>>> +    "pop %r11; pop %r10; pop %r9; pop %r8\n"
>>> +    "pop %rdi; pop %rsi; pop %rdx; pop %rcx; pop %rax\n"
>>> +#endif
>>> +    "add $"S", %"R "sp\n\t" // discard error code
>>> +    "iret"W" \n\t"
>>> +    "jmp pf_tss\n\t"
>>> +    );
>>> +
>>> +static void init_test(void)
>>> +{
>>> +    pf_count = 0;
>>> +
>>> +    invlpg(&test);
>>> +    invlpg(&SUPER_VAR(test));
>>> +    wrmsr(MSR_IA32_PKRS, 0);
>>> +    set_cr0_wp(0);
>>> +}
>>> +
>>> +int main(int ac, char **av)
>>> +{
>>> +    unsigned long i;
>>> +    unsigned int pkey = 0x2;
>>> +    unsigned int pkrs_ad = 0x10;
>>> +    unsigned int pkrs_wd = 0x20;
>>> +
>>> +    if (!this_cpu_has(X86_FEATURE_PKS)) {
>>> +        printf("PKS not enabled\n");
>>> +        return report_summary();
>>> +    }
>>> +
>>> +    setup_vm();
>>> +    setup_alt_stack();
>>> +    set_intr_alt_stack(14, pf_tss);
>>> +    wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_LMA);
>>> +
>>> +    // First 16MB are user pages
>>> +    for (i = 0; i < SUPER_BASE; i += PAGE_SIZE) {
>>> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) |= 
>>> ((unsigned long)pkey << PTE_PKEY_BIT);
>>> +        invlpg((void *)i);
>>> +    }
>>> +
>>> +    // Present the same 16MB as supervisor pages in the 16MB-32MB range
>>> +    for (i = SUPER_BASE; i < 2 * SUPER_BASE; i += PAGE_SIZE) {
>>> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= 
>>> ~SUPER_BASE;
>>> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= 
>>> ~PT_USER_MASK;
>>> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) |= 
>>> ((unsigned long)pkey << PTE_PKEY_BIT);
>>> +        invlpg((void *)i);
>>> +    }
>>> +
>>> +    write_cr4(read_cr4() | X86_CR4_PKS);
>>> +    write_cr3(read_cr3());
>>> +
>>> +    init_test();
>>> +    set_cr0_wp(1);
>>> +    wrmsr(MSR_IA32_PKRS, pkrs_ad);
>>> +    SUPER_VAR(test) = 21;
>>> +    report(pf_count == 1 && test == 21 && save == 0,
>>> +           "write to supervisor page when pkrs is ad and wp == 1");
>>> +
>>> +    init_test();
>>> +    set_cr0_wp(0);
>>> +    wrmsr(MSR_IA32_PKRS, pkrs_ad);
>>> +    SUPER_VAR(test) = 22;
>>> +    report(pf_count == 1 && test == 22 && save == 21,
>>> +           "write to supervisor page when pkrs is ad and wp == 0");
>>> +
>>> +    init_test();
>>> +    set_cr0_wp(1);
>>> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
>>> +    SUPER_VAR(test) = 23;
>>> +    report(pf_count == 1 && test == 23 && save == 22,
>>> +           "write to supervisor page when pkrs is wd and wp == 1");
>>> +
>>> +    init_test();
>>> +    set_cr0_wp(0);
>>> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
>>> +    SUPER_VAR(test) = 24;
>>> +    report(pf_count == 0 && test == 24,
>>> +           "write to supervisor page when pkrs is wd and wp == 0");
>>> +
>>> +    init_test();
>>> +    set_cr0_wp(0);
>>> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
>>> +    test = 25;
>>> +    report(pf_count == 0 && test == 25,
>>> +           "write to user page when pkrs is wd and wp == 0");
>>> +
>>> +    init_test();
>>> +    set_cr0_wp(1);
>>> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
>>> +    test = 26;
>>> +    report(pf_count == 0 && test == 26,
>>> +           "write to user page when pkrs is wd and wp == 1");
>>> +
>>> +    init_test();
>>> +    wrmsr(MSR_IA32_PKRS, pkrs_ad);
>>> +    (void)((__typeof__(&(test))) (((unsigned long)&test)));
>>> +    report(pf_count == 0, "read from user page when pkrs is ad");
>>> +
>>> +    return report_summary();
>>> +}
>>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>>> index 3a79151..b75419e 100644
>>> --- a/x86/unittests.cfg
>>> +++ b/x86/unittests.cfg
>>> @@ -127,6 +127,11 @@ file = pku.flat
>>>   arch = x86_64
>>>   extra_params = -cpu host
>>> +[pks]
>>> +file = pks.flat
>>> +arch = x86_64
>>> +extra_params = -cpu host
>>> +
>>>   [asyncpf]
>>>   file = asyncpf.flat
>>>   extra_params = -m 2048
>>>
>>
>> Ping? ... Paolo, I think this one fell through the cracks?
>>
>>   Thomas
>>
> 
> No, it's just that the KVM patches haven't been merged yet (and there's 
> no QEMU implementation yet).  But I'm getting to it.
> 
> Paolo
> 

Hi Paolo,

Thank you for your time. I was just thinking about resending this patch 
series to ping you although no changes will be added. I really hope to 
get the comments from you.

Do you want me to resend a new non-RFC version as well as the QEMU 
implementation? or you review this RFC series first?

Thanks
Chenyi
