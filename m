Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE6E595FE8
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 18:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiHPQN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 12:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiHPQNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 12:13:55 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E38266F;
        Tue, 16 Aug 2022 09:13:53 -0700 (PDT)
Date:   Tue, 16 Aug 2022 18:13:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660666431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c44hSdTbwLK3ivSGIQsUqegZa6QypIYnbAeGw7ck58I=;
        b=WyjLtm+gBudSl4+l1M/7ltOdixtgesnxbySVszLQNHkulu69xA/lY/KFRA82osQPWDOHBs
        4UAC0cm19+/qRdzQdy06QcwX226jKpwEJ932+nO3z+SkuypQoEnWC7Hx/phjwcaBiRGe27
        wfjs6EKYqLcyYAFuhWTHOlgaK6wgf18=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, seanjc@google.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, joro@8bytes.org, mizhang@google.com,
        pbonzini@redhat.com, vannapurve@google.com
Subject: Re: [V3 10/11] KVM: selftests: Add ucall pool based implementation
Message-ID: <20220816161350.b7x5brnyz5pyi7te@kamzik>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-11-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810152033.946942-11-pgonda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 08:20:32AM -0700, Peter Gonda wrote:
> To add support for encrypted, SEV, guests in the ucall framework
> introduce a new "ucall pool" implementation. This was suggested in
> the thread on "[RFC PATCH 00/10] KVM: selftests: Add support for
> test-selectable ucall implementations". Using a listed as suggested

s/listed/list/

> there doesn't work well because the list is setup using HVAs not GVAs
> so use a bitmap + array solution instead to get the same pool of ucall
> structs result.
> 
> This allows for guests with encryption enabled set up a pool of ucall

to set up

> structs in the guest's shared memory region.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |   2 +
>  .../selftests/kvm/include/ucall_common.h      |  13 +--
>  .../testing/selftests/kvm/lib/aarch64/ucall.c |  10 +-
>  tools/testing/selftests/kvm/lib/riscv/ucall.c |   5 +-
>  tools/testing/selftests/kvm/lib/s390x/ucall.c |   5 +-
>  .../testing/selftests/kvm/lib/ucall_common.c  | 108 +++++++++++++++++-
>  .../testing/selftests/kvm/lib/x86_64/ucall.c  |   6 +-
>  7 files changed, 131 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 1a84d2d1d85b..baede0d118c5 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -103,6 +103,8 @@ struct kvm_vm {
>  	int stats_fd;
>  	struct kvm_stats_header stats_header;
>  	struct kvm_stats_desc *stats_desc;
> +
> +	bool use_ucall_pool;
>  };
>  
>  
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 63bfc60be995..002a22e1cd1d 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -22,6 +22,9 @@ enum {
>  struct ucall {
>  	uint64_t cmd;
>  	uint64_t args[UCALL_MAX_ARGS];
> +
> +	/* For ucall pool usage. */
> +	struct ucall *hva;
>  };
>  
>  void ucall_arch_init(struct kvm_vm *vm, void *arg);
> @@ -32,15 +35,9 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
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
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> index 132c0e98bf49..ee70531e8e51 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> @@ -81,12 +81,16 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>  
>  	if (run->exit_reason == KVM_EXIT_MMIO &&
>  	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
> -		vm_vaddr_t gva;
> +		uint64_t ucall_addr;

Why change this vm_vaddr_t to a uint64_t? We shouldn't, because...

>  
>  		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
>  			    "Unexpected ucall exit mmio address access");
> -		memcpy(&gva, run->mmio.data, sizeof(gva));
> -		return addr_gva2hva(vcpu->vm, gva);
> +		memcpy(&ucall_addr, run->mmio.data, sizeof(ucall_addr));

...here we assume it's a vm_vaddr_t and only...

> +
> +		if (vcpu->vm->use_ucall_pool)
> +			return (void *)ucall_addr;

...here do we know otherwise. So only here should be any casting.

Also, I think here and in all the ucall_arch_get_ucall() functions we
should add a comment explaining a host-shared address is used, which
is why we don't need addr_gva2hva()

> +		else
> +			return addr_gva2hva(vcpu->vm, ucall_addr);
>  	}
>  
>  	return NULL;
> diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> index 37e091d4366e..4bb5616df29f 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> @@ -59,7 +59,10 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>  	    run->riscv_sbi.extension_id == KVM_RISCV_SELFTESTS_SBI_EXT) {
>  		switch (run->riscv_sbi.function_id) {
>  		case KVM_RISCV_SELFTESTS_SBI_UCALL:
> -			return addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]);
> +			if (vcpu->vm->use_ucall_pool)
> +				return (void *)run->riscv_sbi.args[0];
> +			else
> +				return addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]);

Using vm_vaddr_t gva variable for run->riscv_sbi.args[0] like aarch64 does
for it's address would look a bit nicer.

>  		case KVM_RISCV_SELFTESTS_SBI_UNEXP:
>  			vcpu_dump(stderr, vcpu, 2);
>  			TEST_ASSERT(0, "Unexpected trap taken by guest");
> diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> index 0f695a031d35..b24c6649877a 100644
> --- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> @@ -30,7 +30,10 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>  	    (run->s390_sieic.ipb >> 16) == 0x501) {
>  		int reg = run->s390_sieic.ipa & 0xf;
>  
> -		return addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]);
> +		if (vcpu->vm->use_ucall_pool)
> +			return (void *)run->s.regs.gprs[reg];
> +		else
> +			return addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]);

Same comment as for riscv.

>  	}
>  	return NULL;
>  }
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index ced480860746..b6502a9420c4 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -1,22 +1,122 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  #include "kvm_util.h"
> +#include "linux/types.h"
> +#include "linux/bitmap.h"
> +#include "linux/atomic.h"
> +
> +struct ucall_header {
> +	DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
> +	struct ucall ucalls[KVM_MAX_VCPUS];
> +};
> +
> +static bool use_ucall_pool;

I don't think we need this boolean. It will always be true when ucall_pool
is non-null and always false with ucall_pool is null. So we can just test
ucall_pool.

> +static struct ucall_header *ucall_pool;
> +
> +void ucall_init(struct kvm_vm *vm, void *arg)
> +{
> +	struct ucall *uc;
> +	struct ucall_header *hdr;
> +	vm_vaddr_t vaddr;
> +	int i;
> +
> +	use_ucall_pool = vm->use_ucall_pool;
> +	sync_global_to_guest(vm, use_ucall_pool);
> +	if (!use_ucall_pool)
> +		goto out;
> +
> +	TEST_ASSERT(!ucall_pool, "Only a single encrypted guest at a time for ucalls.");

"Only a single VM may use a ucall pool at a time"

> +	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), vm->page_size);
> +	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
> +	memset(hdr, 0, sizeof(*hdr));
> +
> +	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> +		uc = &hdr->ucalls[i];
> +		uc->hva = uc;
> +	}
> +
> +	ucall_pool = (struct ucall_header *)vaddr;
> +	sync_global_to_guest(vm, ucall_pool);
> +
> +out:
> +	ucall_arch_init(vm, arg);
> +}
> +
> +void ucall_uninit(struct kvm_vm *vm)
> +{
> +	use_ucall_pool = false;
> +	ucall_pool = NULL;
> +
> +	if (!vm->memcrypt.encrypted) {

Why is this condition here?

> +		sync_global_to_guest(vm, use_ucall_pool);
> +		sync_global_to_guest(vm, ucall_pool);
> +	}
> +
> +	ucall_arch_uninit(vm);
> +}
> +
> +static struct ucall *ucall_alloc(void)
> +{
> +	struct ucall *uc = NULL;
> +	int i;
> +
> +	if (!use_ucall_pool)
> +		goto out;
> +
> +	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> +		if (!atomic_test_and_set_bit(i, ucall_pool->in_use)) {
> +			uc = &ucall_pool->ucalls[i];
> +			memset(uc->args, 0, sizeof(uc->args));

Do we need to zero uc? If so, what about uc->cmd?

> +			break;
> +		}
> +	}

Need a blank line here

> +out:
> +	return uc;
> +}
> +
> +static inline size_t uc_pool_idx(struct ucall *uc)
> +{
> +	return uc->hva - ucall_pool->ucalls;
> +}
> +
> +static void ucall_free(struct ucall *uc)
> +{
> +	if (!use_ucall_pool)
> +		return;
> +
> +	clear_bit(uc_pool_idx(uc), ucall_pool->in_use);
> +}
>  
>  void ucall(uint64_t cmd, int nargs, ...)
>  {
> -	struct ucall uc = {};
> +	struct ucall *uc;
> +	struct ucall tmp = {};
>  	va_list va;
>  	int i;
>  
> -	WRITE_ONCE(uc.cmd, cmd);
> +	uc = ucall_alloc();
> +	if (!uc)
> +		uc = &tmp;
> +
> +	WRITE_ONCE(uc->cmd, cmd);
>  
>  	nargs = min(nargs, UCALL_MAX_ARGS);
>  
>  	va_start(va, nargs);
>  	for (i = 0; i < nargs; ++i)
> -		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
> +		WRITE_ONCE(uc->args[i], va_arg(va, uint64_t));
>  	va_end(va);
>  
> -	ucall_arch_do_ucall((vm_vaddr_t)&uc);
> +	/*
> +	 * When using the ucall pool implementation the @hva member of the ucall
> +	 * structs in the pool has been initialized to the hva of the ucall
> +	 * object.
> +	 */
> +	if (use_ucall_pool)
> +		ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
> +	else
> +		ucall_arch_do_ucall((vm_vaddr_t)uc);
> +
> +	ucall_free(uc);
>  }
>  
>  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> index ead9946399ab..07c1bc41fa5c 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> @@ -30,7 +30,11 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>  		struct kvm_regs regs;
>  
>  		vcpu_regs_get(vcpu, &regs);
> -		return addr_gva2hva(vcpu->vm, regs.rdi);
> +
> +		if (vcpu->vm->use_ucall_pool)
> +			return (void *)regs.rdi;
> +		else
> +			return addr_gva2hva(vcpu->vm, regs.rdi);
>  	}
>  	return NULL;
>  }
> -- 
> 2.37.1.559.g78731f0fdb-goog
>

Thanks,
drew
