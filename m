Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5DE16AA7F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 16:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgBXPvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 10:51:01 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21376 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727890AbgBXPvA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 10:51:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582559459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QBzUZ88HV/a/URXm6yEfvQuZQiaiabo38k1vUrUp5ms=;
        b=Ga8jHGpPcVkLbvL3t7f0/yvOxAN6ySAdDLAfcYL5MRD/6Iyn0iQwnjrF35SSszwcFgHEQN
        yp5ki0olIxuLh7OZrvklluUoSkflxcIzRyR0YMNFetjnUCsAQkONplctFAtfmO59lK7OLe
        olhGjMRgn63JilzejYKolbQEdYRGFsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-yfLDZ9uRPrC00asKZvOedg-1; Mon, 24 Feb 2020 10:50:54 -0500
X-MC-Unique: yfLDZ9uRPrC00asKZvOedg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EC25477;
        Mon, 24 Feb 2020 15:50:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D41C060BF7;
        Mon, 24 Feb 2020 15:50:45 +0000 (UTC)
Date:   Mon, 24 Feb 2020 16:50:43 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     John Andersen <john.s.andersen@intel.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com, hpa@zytor.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, liran.alon@oracle.com,
        luto@kernel.org, joro@8bytes.org, rick.p.edgecombe@intel.com,
        kristen@linux.intel.com, arjan@linux.intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v2 3/4] selftests: kvm: add test for CR pinning with SMM
Message-ID: <20200224155043.m5ajw63g3p7kyfey@kamzik.brq.redhat.com>
References: <20200218215902.5655-1-john.s.andersen@intel.com>
 <20200218215902.5655-4-john.s.andersen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218215902.5655-4-john.s.andersen@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 01:59:01PM -0800, John Andersen wrote:
> Check that paravirtualized control register pinning blocks modifications
> of pinned CR values stored in SMRAM on exit from SMM.
> 
> Signed-off-by: John Andersen <john.s.andersen@intel.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/processor.h  |   9 +
>  .../selftests/kvm/x86_64/smm_cr_pin_test.c    | 180 ++++++++++++++++++
>  4 files changed, 191 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/smm_cr_pin_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 30072c3f52fb..08e18ae1b80f 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -7,6 +7,7 @@
>  /x86_64/platform_info_test
>  /x86_64/set_sregs_test
>  /x86_64/smm_test
> +/x86_64/smm_cr_pin_test
>  /x86_64/state_test
>  /x86_64/sync_regs_test
>  /x86_64/vmx_close_while_nested_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index d91c53b726e6..f3fdac72fc74 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -19,6 +19,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
>  TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
>  TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> +TEST_GEN_PROGS_x86_64 += x86_64/smm_cr_pin_test
>  TEST_GEN_PROGS_x86_64 += x86_64/state_test
>  TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 7428513a4c68..70394d2ffa5d 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -197,6 +197,11 @@ static inline uint64_t get_cr0(void)
>  	return cr0;
>  }
>  
> +static inline void set_cr0(uint64_t val)
> +{
> +	__asm__ __volatile__("mov %0, %%cr0" : : "r" (val) : "memory");
> +}
> +
>  static inline uint64_t get_cr3(void)
>  {
>  	uint64_t cr3;
> @@ -380,4 +385,8 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
>  /* VMX_EPT_VPID_CAP bits */
>  #define VMX_EPT_VPID_CAP_AD_BITS       (1ULL << 21)
>  
> +/* KVM MSRs */
> +#define MSR_KVM_CR0_PINNED	0x4b564d08
> +#define MSR_KVM_CR4_PINNED	0x4b564d09
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/x86_64/smm_cr_pin_test.c b/tools/testing/selftests/kvm/x86_64/smm_cr_pin_test.c
> new file mode 100644
> index 000000000000..013983bb4ba4
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/smm_cr_pin_test.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Tests for control register pinning not being affected by SMRAM writes.
> + */
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +
> +#include "kvm_util.h"
> +
> +#include "processor.h"
> +
> +#define VCPU_ID	      1
> +
> +#define PAGE_SIZE  4096
> +
> +#define SMRAM_SIZE 65536
> +#define SMRAM_MEMSLOT ((1 << 16) | 1)
> +#define SMRAM_PAGES (SMRAM_SIZE / PAGE_SIZE)
> +#define SMRAM_GPA 0x1000000
> +#define SMRAM_STAGE 0xfe
> +
> +#define STR(x) #x
> +#define XSTR(s) STR(s)

linux/stringify.h is in tools/

> +
> +#define SYNC_PORT 0xe
> +#define DONE 0xff
> +
> +#define CR0_PINNED X86_CR0_WP
> +#define CR4_PINNED (X86_CR4_SMAP | X86_CR4_UMIP)
> +#define CR4_ALL (CR4_PINNED | X86_CR4_SMEP)
> +
> +/*
> + * This is compiled as normal 64-bit code, however, SMI handler is executed
> + * in real-address mode. To stay simple we're limiting ourselves to a mode
> + * independent subset of asm here.
> + * SMI handler always report back fixed stage SMRAM_STAGE.
> + */
> +uint8_t smi_handler[] = {
> +	0xb0, SMRAM_STAGE,    /* mov $SMRAM_STAGE, %al */
> +	0xe4, SYNC_PORT,      /* in $SYNC_PORT, %al */
> +	0x0f, 0xaa,           /* rsm */
> +};
> +
> +void sync_with_host(uint64_t phase)
> +{
> +	asm volatile("in $" XSTR(SYNC_PORT)", %%al \n"
> +		     : : "a" (phase));
> +}

Any reason not to use GUEST_SYNC() ?

> +
> +void self_smi(void)
> +{
> +	wrmsr(APIC_BASE_MSR + (APIC_ICR >> 4),
> +	      APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_SMI);
> +}
> +
> +void guest_code(void *unused)
> +{

Why not just define guest_code as 'void guest_code(void)' ?

> +	uint64_t apicbase = rdmsr(MSR_IA32_APICBASE);
> +
> +	(void)unused;
> +
> +	sync_with_host(1);
> +
> +	wrmsr(MSR_IA32_APICBASE, apicbase | X2APIC_ENABLE);
> +
> +	sync_with_host(2);
> +
> +	set_cr0(get_cr0() | CR0_PINNED);
> +
> +	wrmsr(MSR_KVM_CR0_PINNED, CR0_PINNED);
> +
> +	sync_with_host(3);
> +
> +	set_cr4(get_cr4() | CR4_PINNED);
> +
> +	sync_with_host(4);
> +
> +	/* Pin SMEP low */
> +	wrmsr(MSR_KVM_CR4_PINNED, CR4_PINNED);
> +
> +	sync_with_host(5);
> +
> +	self_smi();
> +
> +	sync_with_host(DONE);

GUEST_DONE() ?

> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_regs regs;
> +	struct kvm_sregs sregs;
> +	struct kvm_vm *vm;
> +	struct kvm_run *run;
> +	struct kvm_x86_state *state;
> +	int stage, stage_reported;
> +	u64 *cr;
> +
> +	/* Create VM */
> +	vm = vm_create_default(VCPU_ID, 0, guest_code);
> +
> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +
> +	run = vcpu_state(vm, VCPU_ID);
> +
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, SMRAM_GPA,
> +				    SMRAM_MEMSLOT, SMRAM_PAGES, 0);
> +	TEST_ASSERT(vm_phy_pages_alloc(vm, SMRAM_PAGES, SMRAM_GPA, SMRAM_MEMSLOT)
> +		    == SMRAM_GPA, "could not allocate guest physical addresses?");
> +
> +	memset(addr_gpa2hva(vm, SMRAM_GPA), 0x0, SMRAM_SIZE);
> +	memcpy(addr_gpa2hva(vm, SMRAM_GPA) + 0x8000, smi_handler,
> +	       sizeof(smi_handler));
> +
> +	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_SMBASE, SMRAM_GPA);
> +
> +	vcpu_args_set(vm, VCPU_ID, 1, 0);

guest_code() doesn't use inputs, so why set rdi to zero?

> +
> +	for (stage = 1;; stage++) {
> +		_vcpu_run(vm, VCPU_ID);
> +
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "Stage %d: unexpected exit reason: %u (%s),\n",
> +			    stage, run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		memset(&regs, 0, sizeof(regs));
> +		vcpu_regs_get(vm, VCPU_ID, &regs);
> +
> +		memset(&sregs, 0, sizeof(sregs));
> +		vcpu_sregs_get(vm, VCPU_ID, &sregs);
> +
> +		stage_reported = regs.rax & 0xff;

If you use GUEST_ASSERT() and get_ucall() then stage_reported is uc.args[1].
Why mask it with 0xff? Shouldn't the test assert if the stage is an
unexpected value?

> +
> +		if (stage_reported == DONE) {

uc.cmd == UCALL_DONE

> +			TEST_ASSERT((sregs.cr0 & CR0_PINNED) == CR0_PINNED,
> +				    "Unexpected cr0. Bits missing: %llx",
> +				    sregs.cr0 ^ (CR0_PINNED | sregs.cr0));
> +			TEST_ASSERT((sregs.cr4 & CR4_ALL) == CR4_PINNED,
> +				    "Unexpected cr4. Bits missing: %llx, cr4: %llx",
> +				    sregs.cr4 ^ (CR4_ALL | sregs.cr4),
> +				    sregs.cr4);
> +			goto done;
> +		}
> +
> +		TEST_ASSERT(stage_reported == stage ||
> +			    stage_reported == SMRAM_STAGE,
> +			    "Unexpected stage: #%x, got %x",
> +			    stage, stage_reported);
> +
> +		/* Within SMM modify CR0/4 to not contain pinned bits. */
> +		if (stage_reported == SMRAM_STAGE) {
> +			cr = (u64 *)(addr_gpa2hva(vm, SMRAM_GPA + 0x8000 + 0x7f58));
> +			*cr &= ~CR0_PINNED;
> +
> +			cr = (u64 *)(addr_gpa2hva(vm, SMRAM_GPA + 0x8000 + 0x7f48));
> +			/* Unset pinned, set one that was pinned low */
> +			*cr &= ~CR4_PINNED;
> +			*cr |= X86_CR4_SMEP;
> +		}
> +
> +		state = vcpu_save_state(vm, VCPU_ID);
> +		kvm_vm_release(vm);
> +		kvm_vm_restart(vm, O_RDWR);
> +		vm_vcpu_add(vm, VCPU_ID);
> +		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +		vcpu_load_state(vm, VCPU_ID, state);
> +		run = vcpu_state(vm, VCPU_ID);
> +		free(state);
> +	}
> +
> +done:
> +	kvm_vm_free(vm);
> +}
> -- 
> 2.21.0
>

Thanks,
drew 

