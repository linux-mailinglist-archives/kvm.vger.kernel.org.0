Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23306A151E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 11:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfH2JpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 05:45:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfH2JpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 05:45:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 973AA106E28E;
        Thu, 29 Aug 2019 09:45:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EFA5A19C4F;
        Thu, 29 Aug 2019 09:45:18 +0000 (UTC)
Date:   Thu, 29 Aug 2019 11:45:16 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 3/4] KVM: selftests: Introduce VM_MODE_PXXV48_4K
Message-ID: <20190829094516.fyfhgz7ma2nfazoq@kamzik.brq.redhat.com>
References: <20190829022117.10191-1-peterx@redhat.com>
 <20190829022117.10191-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829022117.10191-4-peterx@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Thu, 29 Aug 2019 09:45:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 10:21:16AM +0800, Peter Xu wrote:
> The naming VM_MODE_P52V48_4K is explicit but unclear when used on
> x86_64 machines, because x86_64 machines are having various physical
> address width rather than some static values.  Here's some examples:
> 
>   - Intel Xeon E3-1220:  36 bits
>   - Intel Core i7-8650:  39 bits
>   - AMD   EPYC 7251:     48 bits
> 
> All of them are using 48 bits linear address width but with totally
> different physical address width (and most of the old machines should
> be less than 52 bits).
> 
> Let's create a new guest mode called VM_MODE_PXXV48_4K for current
> x86_64 tests and make it as the default to replace the old naming of
> VM_MODE_P52V48_4K because it shows more clearly that the PA width is
> not really a constant.  Meanwhile we also stop assuming all the x86
> machines are having 52 bits PA width but instead we fetch the real
> vm->pa_bits from CPUID 0x80000008 during runtime.
> 
> We currently make this exclusively used by x86_64 but no other arch.
> 
> As a slight touch up, moving DEBUG macro from dirty_log_test.c to
> kvm_util.h so lib can use it too.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c  |  5 ++--
>  .../testing/selftests/kvm/include/kvm_util.h  |  9 +++++-
>  .../selftests/kvm/include/x86_64/processor.h  |  3 ++
>  .../selftests/kvm/lib/aarch64/processor.c     |  3 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 ++++++++++++++----
>  .../selftests/kvm/lib/x86_64/processor.c      | 30 ++++++++++++++++---
>  6 files changed, 65 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index efb7746a7e99..c86f83cb33e5 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -19,8 +19,6 @@
>  #include "kvm_util.h"
>  #include "processor.h"
>  
> -#define DEBUG printf
> -
>  #define VCPU_ID				1
>  
>  /* The memory slot index to track dirty pages */
> @@ -256,6 +254,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  
>  	switch (mode) {
>  	case VM_MODE_P52V48_4K:
> +	case VM_MODE_PXXV48_4K:
>  		guest_pa_bits = 52;
>  		guest_page_shift = 12;
>  		break;
> @@ -446,7 +445,7 @@ int main(int argc, char *argv[])
>  #endif
>  
>  #ifdef __x86_64__
> -	vm_guest_mode_params_init(VM_MODE_P52V48_4K, true, true);
> +	vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
>  #endif
>  #ifdef __aarch64__
>  	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index c78faa2ff7f3..430edbacb9b2 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -24,6 +24,10 @@ struct kvm_vm;
>  typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
>  typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
>  
> +#ifndef DEBUG
> +#define DEBUG printf
> +#endif

There's no way to turn this off without modifying code. I suggested

#ifndef NDEBUG
#define dprintf printf
#endif

which allows the dprintf(...) statements to be removed by compiling with
-DNDEBUG added to CFLAGS. And that would also disable all the asserts().
That's probably not all that useful, but then again, defining printf() as
DEBUG() isn't useful either if the intention is to always print.

> +
>  /* Minimum allocated guest virtual and physical addresses */
>  #define KVM_UTIL_MIN_VADDR		0x2000
>  
> @@ -38,11 +42,14 @@ enum vm_guest_mode {
>  	VM_MODE_P48V48_64K,
>  	VM_MODE_P40V48_4K,
>  	VM_MODE_P40V48_64K,
> +	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
>  	NUM_VM_MODES,
>  };
>  
> -#ifdef __aarch64__
> +#if defined(__aarch64__)
>  #define VM_MODE_DEFAULT VM_MODE_P40V48_4K
> +#elif defined(__x86_64__)
> +#define VM_MODE_DEFAULT VM_MODE_PXXV48_4K
>  #else
>  #define VM_MODE_DEFAULT VM_MODE_P52V48_4K
>  #endif
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 80d19740d2dc..0c17f2ee685e 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -325,6 +325,9 @@ uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index);
>  void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
>  	  	  uint64_t msr_value);
>  
> +uint32_t kvm_get_cpuid_max(void);
> +void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
> +
>  /*
>   * Basic CPU control in CR0
>   */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 486400a97374..86036a59a668 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -264,6 +264,9 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  	case VM_MODE_P52V48_4K:
>  		TEST_ASSERT(false, "AArch64 does not support 4K sized pages "
>  				   "with 52-bit physical address ranges");
> +	case VM_MODE_PXXV48_4K:
> +		TEST_ASSERT(false, "AArch64 does not support 4K sized pages "
> +				   "with ANY-bit physical address ranges");
>  	case VM_MODE_P52V48_64K:
>  		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
>  		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 34a8a6572c7c..bb8f993b25fb 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -8,6 +8,7 @@
>  #include "test_util.h"
>  #include "kvm_util.h"
>  #include "kvm_util_internal.h"
> +#include "processor.h"
>  
>  #include <assert.h>
>  #include <sys/mman.h>
> @@ -101,12 +102,13 @@ static void vm_open(struct kvm_vm *vm, int perm)
>  }
>  
>  const char * const vm_guest_mode_string[] = {
> -	"PA-bits:52, VA-bits:48, 4K pages",
> -	"PA-bits:52, VA-bits:48, 64K pages",
> -	"PA-bits:48, VA-bits:48, 4K pages",
> -	"PA-bits:48, VA-bits:48, 64K pages",
> -	"PA-bits:40, VA-bits:48, 4K pages",
> -	"PA-bits:40, VA-bits:48, 64K pages",
> +	"PA-bits:52,  VA-bits:48,  4K pages",
> +	"PA-bits:52,  VA-bits:48, 64K pages",
> +	"PA-bits:48,  VA-bits:48,  4K pages",
> +	"PA-bits:48,  VA-bits:48, 64K pages",
> +	"PA-bits:40,  VA-bits:48,  4K pages",
> +	"PA-bits:40,  VA-bits:48, 64K pages",
> +	"PA-bits:ANY, VA-bits:48,  4K pages",
>  };
>  _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
>  	       "Missing new mode strings?");
> @@ -184,6 +186,21 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  		vm->page_size = 0x10000;
>  		vm->page_shift = 16;
>  		break;
> +	case VM_MODE_PXXV48_4K:
> +#ifdef __x86_64__
> +		kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
> +		TEST_ASSERT(vm->va_bits == 48, "Linear address width "
> +			    "(%d bits) not supported", vm->va_bits);
> +		vm->pgtable_levels = 4;
> +		vm->page_size = 0x1000;
> +		vm->page_shift = 12;
> +		DEBUG("Guest physical address width detected: %d\n",
> +		      vm->pa_bits);
> +#else
> +		TEST_ASSERT(false, "VM_MODE_PXXV48_4K not supported on "
> +			    "non-x86 platforms");
> +#endif
> +		break;
>  	default:
>  		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
>  	}
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 6cb34a0fa200..48467210ccfc 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -228,7 +228,7 @@ void sregs_dump(FILE *stream, struct kvm_sregs *sregs,
>  
>  void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot)
>  {
> -	TEST_ASSERT(vm->mode == VM_MODE_P52V48_4K, "Attempt to use "
> +	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
>  		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
>  
>  	/* If needed, create page map l4 table. */
> @@ -261,7 +261,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>  	uint16_t index[4];
>  	struct pageMapL4Entry *pml4e;
>  
> -	TEST_ASSERT(vm->mode == VM_MODE_P52V48_4K, "Attempt to use "
> +	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
>  		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
>  
>  	TEST_ASSERT((vaddr % vm->page_size) == 0,
> @@ -547,7 +547,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  	struct pageDirectoryEntry *pde;
>  	struct pageTableEntry *pte;
>  
> -	TEST_ASSERT(vm->mode == VM_MODE_P52V48_4K, "Attempt to use "
> +	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
>  		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
>  
>  	index[0] = (gva >> 12) & 0x1ffu;
> @@ -621,7 +621,7 @@ static void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_m
>  	kvm_setup_gdt(vm, &sregs.gdt, gdt_memslot, pgd_memslot);
>  
>  	switch (vm->mode) {
> -	case VM_MODE_P52V48_4K:
> +	case VM_MODE_PXXV48_4K:
>  		sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
>  		sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
>  		sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
> @@ -1153,3 +1153,25 @@ bool is_intel_cpu(void)
>  	chunk = (const uint32_t *)("GenuineIntel");
>  	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
>  }
> +
> +uint32_t kvm_get_cpuid_max(void)
> +{
> +	return kvm_get_supported_cpuid_entry(0x80000000)->eax;
> +}
> +
> +void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	bool pae;
> +
> +	/* SDM 4.1.4 */
> +	if (kvm_get_cpuid_max() < 0x80000008) {
> +		pae = kvm_get_supported_cpuid_entry(1)->edx & (1 << 6);
> +		*pa_bits = pae ? 36 : 32;
> +		*va_bits = 32;
> +	} else {
> +		entry = kvm_get_supported_cpuid_entry(0x80000008);
> +		*pa_bits = entry->eax & 0xff;
> +		*va_bits = (entry->eax >> 8) & 0xff;
> +	}
> +}
> -- 
> 2.21.0
>

Thanks,
drew 
