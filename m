Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD042FA7F4
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 18:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407300AbhARRvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 12:51:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436749AbhARRqs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:46:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610991921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IyFhFPk/KN9VKa5XFYhlbWk+/izchrcoDhuoerbJC6E=;
        b=DC1E9QuxAjl/QS9oUTbMmGSi10S5Kf10JomHFAz8QplRU5uWkibArQa4uN2woLr+fblKr1
        XuR2Uu2xhOqJ+fZsgoUG1e/Sy5XX1Sqbufg4sOOxH5vRia4OtpmP1b2fH3hpjTx2iMV6cW
        wO5W2JBkv0nqHpNlemdUDNWI0xEPpb4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-gO2ycDubOWmee6rCi0yCGA-1; Mon, 18 Jan 2021 12:45:19 -0500
X-MC-Unique: gO2ycDubOWmee6rCi0yCGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E01E1107ACE3;
        Mon, 18 Jan 2021 17:45:16 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-189.ams2.redhat.com [10.36.112.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 416C470464;
        Mon, 18 Jan 2021 17:45:13 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] x86: Add tests for PKS
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201105081805.5674-1-chenyi.qiang@intel.com>
 <20201105081805.5674-9-chenyi.qiang@intel.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6174185b-25e0-f2a2-3f71-d8bbe6ca889d@redhat.com>
Date:   Mon, 18 Jan 2021 18:45:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201105081805.5674-9-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/2020 09.18, Chenyi Qiang wrote:
> This unit-test is intended to test the KVM support for Protection Keys
> for Supervisor Pages (PKS). If CR4.PKS is set in long mode, supervisor
> pkeys are checked in addition to normal paging protections and Access or
> Write can be disabled via a MSR update without TLB flushes when
> permissions change.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   lib/x86/msr.h       |   1 +
>   lib/x86/processor.h |   2 +
>   x86/Makefile.x86_64 |   1 +
>   x86/pks.c           | 146 ++++++++++++++++++++++++++++++++++++++++++++
>   x86/unittests.cfg   |   5 ++
>   5 files changed, 155 insertions(+)
>   create mode 100644 x86/pks.c
> 
> diff --git a/lib/x86/msr.h b/lib/x86/msr.h
> index 6ef5502..e36934b 100644
> --- a/lib/x86/msr.h
> +++ b/lib/x86/msr.h
> @@ -209,6 +209,7 @@
>   #define MSR_IA32_EBL_CR_POWERON		0x0000002a
>   #define MSR_IA32_FEATURE_CONTROL        0x0000003a
>   #define MSR_IA32_TSC_ADJUST		0x0000003b
> +#define MSR_IA32_PKRS			0x000006e1
>   
>   #define FEATURE_CONTROL_LOCKED				(1<<0)
>   #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 74a2498..985fdd0 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -50,6 +50,7 @@
>   #define X86_CR4_SMEP   0x00100000
>   #define X86_CR4_SMAP   0x00200000
>   #define X86_CR4_PKE    0x00400000
> +#define X86_CR4_PKS    0x01000000
>   
>   #define X86_EFLAGS_CF    0x00000001
>   #define X86_EFLAGS_FIXED 0x00000002
> @@ -157,6 +158,7 @@ static inline u8 cpuid_maxphyaddr(void)
>   #define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
>   #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
>   #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
> +#define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
>   #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
>   #define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
>   
> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> index af61d85..3a353df 100644
> --- a/x86/Makefile.x86_64
> +++ b/x86/Makefile.x86_64
> @@ -20,6 +20,7 @@ tests += $(TEST_DIR)/tscdeadline_latency.flat
>   tests += $(TEST_DIR)/intel-iommu.flat
>   tests += $(TEST_DIR)/vmware_backdoors.flat
>   tests += $(TEST_DIR)/rdpru.flat
> +tests += $(TEST_DIR)/pks.flat
>   
>   include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>   
> diff --git a/x86/pks.c b/x86/pks.c
> new file mode 100644
> index 0000000..a3044cf
> --- /dev/null
> +++ b/x86/pks.c
> @@ -0,0 +1,146 @@
> +#include "libcflat.h"
> +#include "x86/desc.h"
> +#include "x86/processor.h"
> +#include "x86/vm.h"
> +#include "x86/msr.h"
> +
> +#define CR0_WP_MASK      (1UL << 16)
> +#define PTE_PKEY_BIT     59
> +#define SUPER_BASE        (1 << 24)
> +#define SUPER_VAR(v)      (*((__typeof__(&(v))) (((unsigned long)&v) + SUPER_BASE)))
> +
> +volatile int pf_count = 0;
> +volatile unsigned save;
> +volatile unsigned test;
> +
> +static void set_cr0_wp(int wp)
> +{
> +    unsigned long cr0 = read_cr0();
> +
> +    cr0 &= ~CR0_WP_MASK;
> +    if (wp)
> +        cr0 |= CR0_WP_MASK;
> +    write_cr0(cr0);
> +}
> +
> +void do_pf_tss(unsigned long error_code);
> +void do_pf_tss(unsigned long error_code)
> +{
> +    printf("#PF handler, error code: 0x%lx\n", error_code);
> +    pf_count++;
> +    save = test;
> +    wrmsr(MSR_IA32_PKRS, 0);
> +}
> +
> +extern void pf_tss(void);
> +
> +asm ("pf_tss: \n\t"
> +#ifdef __x86_64__
> +    // no task on x86_64, save/restore caller-save regs
> +    "push %rax; push %rcx; push %rdx; push %rsi; push %rdi\n"
> +    "push %r8; push %r9; push %r10; push %r11\n"
> +    "mov 9*8(%rsp), %rdi\n"
> +#endif
> +    "call do_pf_tss \n\t"
> +#ifdef __x86_64__
> +    "pop %r11; pop %r10; pop %r9; pop %r8\n"
> +    "pop %rdi; pop %rsi; pop %rdx; pop %rcx; pop %rax\n"
> +#endif
> +    "add $"S", %"R "sp\n\t" // discard error code
> +    "iret"W" \n\t"
> +    "jmp pf_tss\n\t"
> +    );
> +
> +static void init_test(void)
> +{
> +    pf_count = 0;
> +
> +    invlpg(&test);
> +    invlpg(&SUPER_VAR(test));
> +    wrmsr(MSR_IA32_PKRS, 0);
> +    set_cr0_wp(0);
> +}
> +
> +int main(int ac, char **av)
> +{
> +    unsigned long i;
> +    unsigned int pkey = 0x2;
> +    unsigned int pkrs_ad = 0x10;
> +    unsigned int pkrs_wd = 0x20;
> +
> +    if (!this_cpu_has(X86_FEATURE_PKS)) {
> +        printf("PKS not enabled\n");
> +        return report_summary();
> +    }
> +
> +    setup_vm();
> +    setup_alt_stack();
> +    set_intr_alt_stack(14, pf_tss);
> +    wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_LMA);
> +
> +    // First 16MB are user pages
> +    for (i = 0; i < SUPER_BASE; i += PAGE_SIZE) {
> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) |= ((unsigned long)pkey << PTE_PKEY_BIT);
> +        invlpg((void *)i);
> +    }
> +
> +    // Present the same 16MB as supervisor pages in the 16MB-32MB range
> +    for (i = SUPER_BASE; i < 2 * SUPER_BASE; i += PAGE_SIZE) {
> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~SUPER_BASE;
> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~PT_USER_MASK;
> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) |= ((unsigned long)pkey << PTE_PKEY_BIT);
> +        invlpg((void *)i);
> +    }
> +
> +    write_cr4(read_cr4() | X86_CR4_PKS);
> +    write_cr3(read_cr3());
> +
> +    init_test();
> +    set_cr0_wp(1);
> +    wrmsr(MSR_IA32_PKRS, pkrs_ad);
> +    SUPER_VAR(test) = 21;
> +    report(pf_count == 1 && test == 21 && save == 0,
> +           "write to supervisor page when pkrs is ad and wp == 1");
> +
> +    init_test();
> +    set_cr0_wp(0);
> +    wrmsr(MSR_IA32_PKRS, pkrs_ad);
> +    SUPER_VAR(test) = 22;
> +    report(pf_count == 1 && test == 22 && save == 21,
> +           "write to supervisor page when pkrs is ad and wp == 0");
> +
> +    init_test();
> +    set_cr0_wp(1);
> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
> +    SUPER_VAR(test) = 23;
> +    report(pf_count == 1 && test == 23 && save == 22,
> +           "write to supervisor page when pkrs is wd and wp == 1");
> +
> +    init_test();
> +    set_cr0_wp(0);
> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
> +    SUPER_VAR(test) = 24;
> +    report(pf_count == 0 && test == 24,
> +           "write to supervisor page when pkrs is wd and wp == 0");
> +
> +    init_test();
> +    set_cr0_wp(0);
> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
> +    test = 25;
> +    report(pf_count == 0 && test == 25,
> +           "write to user page when pkrs is wd and wp == 0");
> +
> +    init_test();
> +    set_cr0_wp(1);
> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
> +    test = 26;
> +    report(pf_count == 0 && test == 26,
> +           "write to user page when pkrs is wd and wp == 1");
> +
> +    init_test();
> +    wrmsr(MSR_IA32_PKRS, pkrs_ad);
> +    (void)((__typeof__(&(test))) (((unsigned long)&test)));
> +    report(pf_count == 0, "read from user page when pkrs is ad");
> +
> +    return report_summary();
> +}
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 3a79151..b75419e 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -127,6 +127,11 @@ file = pku.flat
>   arch = x86_64
>   extra_params = -cpu host
>   
> +[pks]
> +file = pks.flat
> +arch = x86_64
> +extra_params = -cpu host
> +
>   [asyncpf]
>   file = asyncpf.flat
>   extra_params = -m 2048
> 

Ping? ... Paolo, I think this one fell through the cracks?

  Thomas

