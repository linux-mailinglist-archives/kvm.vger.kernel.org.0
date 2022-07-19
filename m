Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F6057A362
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 17:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238203AbiGSPnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 11:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238137AbiGSPnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 11:43:35 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F81952E55;
        Tue, 19 Jul 2022 08:43:33 -0700 (PDT)
Date:   Tue, 19 Jul 2022 17:43:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658245411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aixhlxYT3orn2MXTU63iHe8x+ZHM9wRNDwoFa6FYs14=;
        b=KJuQbkNFQs6fA8WXciImuAT3bBIUGSSpcsvizHKU/L6bIgOdBeDMTv3cj6ZCU9NB8rP35O
        jbBuKI83Kx816oQys5NGeq3mRA66/hlKEx3KVMu9XCOcBz9/gg0C2Yt4NIIEGFdazqVE3/
        X9wtseP1mbxgmuWeKz6OKgpPKSfaZ24=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, seanjc@google.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, joro@8bytes.org, mizhang@google.com,
        pbonzini@redhat.com
Subject: Re: [RFC V1 08/10] KVM: selftests: Make ucall work with encrypted
 guests
Message-ID: <20220719154330.wnwnu23gagcya3o7@kamzik>
References: <20220715192956.1873315-1-pgonda@google.com>
 <20220715192956.1873315-10-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715192956.1873315-10-pgonda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022 at 12:29:54PM -0700, Peter Gonda wrote:
> Add support for encrypted, SEV, guests in the ucall framework. If
> encryption is enabled set up a pool of ucall structs in the guests'
> shared memory region. This was suggested in the thread on "[RFC PATCH
> 00/10] KVM: selftests: Add support for test-selectable ucall
> implementations". Using a listed as suggested there doesn't work well

list

> because the list is setup using HVAs not GVAs so use a bitmap + array
> solution instead to get the same pool result.
> 
> Suggested-by:Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/kvm_util_base.h     |  30 +++--
>  .../selftests/kvm/include/ucall_common.h      |  14 +--
>  .../testing/selftests/kvm/lib/ucall_common.c  | 115 ++++++++++++++++--
>  .../testing/selftests/kvm/lib/x86_64/ucall.c  |   2 +-
>  5 files changed, 134 insertions(+), 28 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 61e85892dd9b..3d9f2a017389 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -47,6 +47,7 @@ LIBKVM += lib/rbtree.c
>  LIBKVM += lib/sparsebit.c
>  LIBKVM += lib/test_util.c
>  LIBKVM += lib/ucall_common.c
> +LIBKVM += $(top_srcdir)/tools/lib/find_bit.c

Why is this file being added?

>  
>  LIBKVM_x86_64 += lib/x86_64/apic.c
>  LIBKVM_x86_64 += lib/x86_64/handlers.S
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 60b604ac9fa9..77aff2356d64 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -65,6 +65,7 @@ struct userspace_mem_regions {
>  /* Memory encryption policy/configuration. */
>  struct vm_memcrypt {
>  	bool enabled;
> +	bool encrypted;
>  	int8_t enc_by_default;
>  	bool has_enc_bit;
>  	int8_t enc_bit;
> @@ -99,6 +100,8 @@ struct kvm_vm {
>  	int stats_fd;
>  	struct kvm_stats_header stats_header;
>  	struct kvm_stats_desc *stats_desc;
> +
> +	struct list_head ucall_list;
>  };
>  
>  
> @@ -141,21 +144,21 @@ enum vm_guest_mode {
>  
>  extern enum vm_guest_mode vm_mode_default;
>  
> -#define VM_MODE_DEFAULT			vm_mode_default
> -#define MIN_PAGE_SHIFT			12U
> -#define ptes_per_page(page_size)	((page_size) / 8)
> +#define VM_MODE_DEFAULT            vm_mode_default
> +#define MIN_PAGE_SHIFT            12U
> +#define ptes_per_page(page_size)    ((page_size) / 8)
>  
>  #elif defined(__x86_64__)
>  
> -#define VM_MODE_DEFAULT			VM_MODE_PXXV48_4K
> -#define MIN_PAGE_SHIFT			12U
> -#define ptes_per_page(page_size)	((page_size) / 8)
> +#define VM_MODE_DEFAULT            VM_MODE_PXXV48_4K
> +#define MIN_PAGE_SHIFT            12U
> +#define ptes_per_page(page_size)    ((page_size) / 8)
>  
>  #elif defined(__s390x__)
>  
> -#define VM_MODE_DEFAULT			VM_MODE_P44V64_4K
> -#define MIN_PAGE_SHIFT			12U
> -#define ptes_per_page(page_size)	((page_size) / 16)
> +#define VM_MODE_DEFAULT            VM_MODE_P44V64_4K
> +#define MIN_PAGE_SHIFT            12U
> +#define ptes_per_page(page_size)    ((page_size) / 16)
>  
>  #elif defined(__riscv)
>  
> @@ -163,9 +166,9 @@ extern enum vm_guest_mode vm_mode_default;
>  #error "RISC-V 32-bit kvm selftests not supported"
>  #endif
>  
> -#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
> -#define MIN_PAGE_SHIFT			12U
> -#define ptes_per_page(page_size)	((page_size) / 8)
> +#define VM_MODE_DEFAULT            VM_MODE_P40V48_4K
> +#define MIN_PAGE_SHIFT            12U
> +#define ptes_per_page(page_size)    ((page_size) / 8)

Looks like your editor decided to change all the above defines to use
spaces instead of tabs. You might want to double check the other
patches as well to ensure lines added use tabs vs. spaces and that
there are no other random whitespace changes.

>  
>  #endif
>  
> @@ -802,6 +805,9 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
>  
>  static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  {
> +	TEST_ASSERT(
> +		!vm->memcrypt.encrypted,
> +		"Encrypted guests have their page tables encrypted so gva2* conversions are not possible.");
>  	return addr_arch_gva2gpa(vm, gva);
>  }
>  
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index cb9b37282701..d8ac16a68c0a 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -21,6 +21,10 @@ enum {
>  struct ucall {
>  	uint64_t cmd;
>  	uint64_t args[UCALL_MAX_ARGS];
> +
> +	/* For encrypted guests. */
> +	uint64_t idx;
> +	struct ucall *hva;
>  };
>  
>  void ucall_arch_init(struct kvm_vm *vm, void *arg);
> @@ -31,15 +35,9 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
>  void ucall(uint64_t cmd, int nargs, ...);
>  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>  
> -static inline void ucall_init(struct kvm_vm *vm, void *arg)
> -{
> -	ucall_arch_init(vm, arg);
> -}
> +void ucall_init(struct kvm_vm *vm, void *arg);
>  
> -static inline void ucall_uninit(struct kvm_vm *vm)
> -{
> -	ucall_arch_uninit(vm);
> -}
> +void ucall_uninit(struct kvm_vm *vm);
>  
>  #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
>  				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index c488ed23d0dd..8e660b10f9b2 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -1,22 +1,123 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  #include "kvm_util.h"
> +#include "linux/types.h"
> +#include "linux/bitmap.h"
> +#include "linux/bitops.h"
> +#include "linux/atomic.h"

Do we really need bitmap.h, bitops.h, and atomic.h? I see we use
clear_bit(), which I think is from atomic.h, and
atomic_test_and_set_bit(), which I have no idea where it comes from...

> +
> +struct ucall_header {
> +	DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
> +	struct ucall ucalls[KVM_MAX_VCPUS];
> +};
> +
> +static bool encrypted_guest;
> +static struct ucall_header *ucall_hdr;
> +
> +void ucall_init(struct kvm_vm *vm, void *arg)
> +{
> +	struct ucall *uc;
> +	struct ucall_header *hdr;
> +	vm_vaddr_t vaddr;
> +	int i;
> +
> +	encrypted_guest = vm->memcrypt.enabled;
> +	sync_global_to_guest(vm, encrypted_guest);
> +	if (!encrypted_guest)
> +		goto out;
> +
> +	TEST_ASSERT(!ucall_hdr,
> +		    "Only a single encrypted guest at a time for ucalls.");
> +	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), vm->page_size);
> +	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
> +	memset(hdr, 0, sizeof(*hdr));
> +
> +	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> +		uc = &hdr->ucalls[i];
> +		uc->hva = uc;
> +		uc->idx = i;
> +	}
> +
> +	ucall_hdr = (struct ucall_header *)vaddr;
> +	sync_global_to_guest(vm, ucall_hdr);
> +
> +out:
> +	ucall_arch_init(vm, arg);
> +}
> +
> +void ucall_uninit(struct kvm_vm *vm)
> +{
> +	encrypted_guest = false;
> +	ucall_hdr = NULL;
> +
> +	ucall_arch_uninit(vm);
> +}
> +
> +static struct ucall *ucall_alloc(void)
> +{
> +	struct ucall *uc = NULL;
> +	int i;
> +
> +	if (!encrypted_guest)
> +		goto out;
> +
> +	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> +		if (atomic_test_and_set_bit(i, ucall_hdr->in_use))
> +			continue;
> +
> +		uc = &ucall_hdr->ucalls[i];

Doesn't this just mark all buffers as in-use and return the last one?
I think we want

	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
		if (!atomic_test_and_set_bit(i, ucall_hdr->in_use)) {
			uc = &ucall_hdr->ucalls[i];
			break;
		}
	}

> +	}
> +
> +out:
> +	return uc;
> +}
> +
> +static void ucall_free(struct ucall *uc)
> +{
> +	if (!encrypted_guest)
> +		return;
> +
> +	clear_bit(uc->idx, ucall_hdr->in_use);
> +}
> +
> +static vm_vaddr_t get_ucall_addr(struct ucall *uc)
> +{
> +	if (encrypted_guest)
> +		return (vm_vaddr_t)uc->hva;
> +
> +	return (vm_vaddr_t)uc;
> +}
>  
>  void ucall(uint64_t cmd, int nargs, ...)
>  {
> -	struct ucall uc = {
> -		.cmd = cmd,
> -	};
> +	struct ucall *uc;
> +	struct ucall tmp;
>  	va_list va;
>  	int i;
>  
> +	uc = ucall_alloc();
> +	if (!uc)
> +		uc = &tmp;
> +
> +	uc->cmd = cmd;
> +
>  	nargs = min(nargs, UCALL_MAX_ARGS);
>  
>  	va_start(va, nargs);
>  	for (i = 0; i < nargs; ++i)
> -		uc.args[i] = va_arg(va, uint64_t);
> +		uc->args[i] = va_arg(va, uint64_t);
>  	va_end(va);
>  
> -	ucall_arch_do_ucall((vm_vaddr_t)&uc);
> +	ucall_arch_do_ucall(get_ucall_addr(uc));
> +
> +	ucall_free(uc);
> +}
> +
> +void *get_ucall_hva(struct kvm_vm *vm, void *uc)
> +{
> +	if (encrypted_guest)
> +		return uc;
> +
> +	return addr_gva2hva(vm, (vm_vaddr_t)uc);
>  }
>  
>  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> @@ -27,9 +128,9 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>  	if (!uc)
>  		uc = &ucall;
>  
> -	addr = ucall_arch_get_ucall(vcpu);
> +	addr = get_ucall_hva(vcpu->vm, ucall_arch_get_ucall(vcpu));

Hmm... so now it's expected that ucall_arch_get_ucall() returns a gva...

>  	if (addr) {
> -		memcpy(uc, addr, sizeof(*uc));
> +		memcpy(uc, addr, sizeof(struct ucall));

Why make this change?

>  		vcpu_run_complete_io(vcpu);
>  	} else {
>  		memset(uc, 0, sizeof(*uc));
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> index ec53a406f689..ea6b2e3a8e39 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> @@ -30,7 +30,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>  		struct kvm_regs regs;
>  
>  		vcpu_regs_get(vcpu, &regs);
> -		return addr_gva2hva(vcpu->vm, (vm_vaddr_t)regs.rdi);
> +		return (void *)regs.rdi;

...we're only updating x86's ucall_arch_get_ucall() to return gvas.
What about the other architectures? Anyway, I'd rather we don't
change ucall_arch_get_ucall() to return gvas. They should continue
returning hvas and any trickery needed to translate a pool uc to
an hva should be put inside ucall_arch_get_ucall().

>  	}
>  	return NULL;
>  }
> -- 
> 2.37.0.170.g444d1eabd0-goog
> 

I'm not a big fan of mixing the concept of encrypted guests into ucalls. I
think we should have two types of ucalls, those have a uc pool in memory
shared with the host and those that don't. Encrypted guests pick the pool
version.

Thanks,
drew
