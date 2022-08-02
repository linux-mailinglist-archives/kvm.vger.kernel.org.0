Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6869587A59
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 12:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbiHBKJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 06:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiHBKJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 06:09:17 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E84C2DA8C;
        Tue,  2 Aug 2022 03:09:15 -0700 (PDT)
Date:   Tue, 2 Aug 2022 12:09:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659434953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V7NYuUcWnJkrPfTbvdD6RiompurpoY0WN1swUqz0070=;
        b=cxYHHuwzEUFgW5zeedn/Jjz3FJd01+uuOwcEU1smPxBqubkaHA3aDZGGmteOtZFikWE6CB
        SGUF0xd0ufSrPEq6bWYvaVL7BZcwMR4A1IzW1WaGuvEKbHoVfjW5rKXyeFp0NGiRDEWzfK
        hvz8K2HNCqO5ly7TRMG8XchW3iiEbYQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, seanjc@google.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, joro@8bytes.org, mizhang@google.com,
        pbonzini@redhat.com, Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [V2 06/11] KVM: selftests: Consolidate common code for
 popuplating
Message-ID: <20220802100911.5kyfhxdavqtpddma@kamzik>
References: <20220801201109.825284-1-pgonda@google.com>
 <20220801201109.825284-7-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801201109.825284-7-pgonda@google.com>
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

On Mon, Aug 01, 2022 at 01:11:04PM -0700, Peter Gonda wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Make ucall() a common helper that populates struct ucall, and only calls
> into arch code to make the actually call out to userspace.
> 
> Rename all arch-specific helpers to make it clear they're arch-specific,
> and to avoid collisions with common helpers (one more on its way...)
> 
> No functional change intended.

But there is...

> 
> Cc: Colton Lewis <coltonlewis@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/include/ucall_common.h      | 23 ++++++++++++++++---
>  .../testing/selftests/kvm/lib/aarch64/ucall.c | 20 ++++------------
>  tools/testing/selftests/kvm/lib/riscv/ucall.c | 23 ++++---------------
>  tools/testing/selftests/kvm/lib/s390x/ucall.c | 23 ++++---------------
>  .../testing/selftests/kvm/lib/ucall_common.c  | 20 ++++++++++++++++
>  .../testing/selftests/kvm/lib/x86_64/ucall.c  | 23 ++++---------------
>  7 files changed, 60 insertions(+), 73 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 690b499c3471..39fc5e8e5594 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -46,6 +46,7 @@ LIBKVM += lib/perf_test_util.c
>  LIBKVM += lib/rbtree.c
>  LIBKVM += lib/sparsebit.c
>  LIBKVM += lib/test_util.c
> +LIBKVM += lib/ucall_common.c
>  
>  LIBKVM_x86_64 += lib/x86_64/apic.c
>  LIBKVM_x86_64 += lib/x86_64/handlers.S
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index ee79d180e07e..5a85f5318bbe 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -24,10 +24,27 @@ struct ucall {
>  	uint64_t args[UCALL_MAX_ARGS];
>  };
>  
> -void ucall_init(struct kvm_vm *vm, void *arg);
> -void ucall_uninit(struct kvm_vm *vm);
> +void ucall_arch_init(struct kvm_vm *vm, void *arg);
> +void ucall_arch_uninit(struct kvm_vm *vm);
> +void ucall_arch_do_ucall(vm_vaddr_t uc);
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> +
>  void ucall(uint64_t cmd, int nargs, ...);
> -uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> +
> +static inline void ucall_init(struct kvm_vm *vm, void *arg)
> +{
> +	ucall_arch_init(vm, arg);
> +}
> +
> +static inline void ucall_uninit(struct kvm_vm *vm)
> +{
> +	ucall_arch_uninit(vm);
> +}
> +
> +static inline uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +{
> +	return ucall_arch_get_ucall(vcpu, uc);
> +}
>  
>  #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
>  				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> index ed237b744690..1c81a6a5c1f2 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> @@ -21,7 +21,7 @@ static bool ucall_mmio_init(struct kvm_vm *vm, vm_paddr_t gpa)
>  	return true;
>  }
>  
> -void ucall_init(struct kvm_vm *vm, void *arg)
> +void ucall_arch_init(struct kvm_vm *vm, void *arg)
>  {
>  	vm_paddr_t gpa, start, end, step, offset;
>  	unsigned int bits;
> @@ -64,30 +64,18 @@ void ucall_init(struct kvm_vm *vm, void *arg)
>  	TEST_FAIL("Can't find a ucall mmio address");
>  }
>  
> -void ucall_uninit(struct kvm_vm *vm)
> +void ucall_arch_uninit(struct kvm_vm *vm)
>  {
>  	ucall_exit_mmio_addr = 0;
>  	sync_global_to_guest(vm, ucall_exit_mmio_addr);
>  }
>  
> -void ucall(uint64_t cmd, int nargs, ...)
> +void ucall_arch_do_ucall(vm_vaddr_t uc)
>  {
> -	struct ucall uc = {};
> -	va_list va;
> -	int i;
> -
> -	WRITE_ONCE(uc.cmd, cmd);
> -	nargs = min(nargs, UCALL_MAX_ARGS);
> -
> -	va_start(va, nargs);
> -	for (i = 0; i < nargs; ++i)
> -		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
> -	va_end(va);
> -

There are WRITE_ONCE's being used here...

>  	WRITE_ONCE(*ucall_exit_mmio_addr, (vm_vaddr_t)&uc);
>  }
>  
> -uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>  {
>  	struct kvm_run *run = vcpu->run;
>  	struct ucall ucall = {};
> diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> index 087b9740bc8f..b1598f418c1f 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> @@ -10,11 +10,11 @@
>  #include "kvm_util.h"
>  #include "processor.h"
>  
> -void ucall_init(struct kvm_vm *vm, void *arg)
> +void ucall_arch_init(struct kvm_vm *vm, void *arg)
>  {
>  }
>  
> -void ucall_uninit(struct kvm_vm *vm)
> +void ucall_arch_uninit(struct kvm_vm *vm)
>  {
>  }
>  
> @@ -44,27 +44,14 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  	return ret;
>  }
>  
> -void ucall(uint64_t cmd, int nargs, ...)
> +void ucall_arch_do_ucall(vm_vaddr_t uc)
>  {
> -	struct ucall uc = {
> -		.cmd = cmd,
> -	};
> -	va_list va;
> -	int i;
> -
> -	nargs = min(nargs, UCALL_MAX_ARGS);
> -
> -	va_start(va, nargs);
> -	for (i = 0; i < nargs; ++i)
> -		uc.args[i] = va_arg(va, uint64_t);
> -	va_end(va);
> -
>  	sbi_ecall(KVM_RISCV_SELFTESTS_SBI_EXT,
>  		  KVM_RISCV_SELFTESTS_SBI_UCALL,
> -		  (vm_vaddr_t)&uc, 0, 0, 0, 0, 0);
> +		  uc, 0, 0, 0, 0, 0);
>  }
>  
> -uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>  {
>  	struct kvm_run *run = vcpu->run;
>  	struct ucall ucall = {};
> diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> index 73dc4e21190f..114cb4af295f 100644
> --- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> @@ -6,34 +6,21 @@
>   */
>  #include "kvm_util.h"
>  
> -void ucall_init(struct kvm_vm *vm, void *arg)
> +void ucall_arch_init(struct kvm_vm *vm, void *arg)
>  {
>  }
>  
> -void ucall_uninit(struct kvm_vm *vm)
> +void ucall_arch_uninit(struct kvm_vm *vm)
>  {
>  }
>  
> -void ucall(uint64_t cmd, int nargs, ...)
> +void ucall_arch_do_ucall(vm_vaddr_t uc)
>  {
> -	struct ucall uc = {
> -		.cmd = cmd,
> -	};
> -	va_list va;
> -	int i;
> -
> -	nargs = min(nargs, UCALL_MAX_ARGS);
> -
> -	va_start(va, nargs);
> -	for (i = 0; i < nargs; ++i)
> -		uc.args[i] = va_arg(va, uint64_t);
> -	va_end(va);
> -
>  	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
> -	asm volatile ("diag 0,%0,0x501" : : "a"(&uc) : "memory");
> +	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
>  }
>  
> -uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>  {
>  	struct kvm_run *run = vcpu->run;
>  	struct ucall ucall = {};
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> new file mode 100644
> index 000000000000..749ffdf23855
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -0,0 +1,20 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include "kvm_util.h"
> +
> +void ucall(uint64_t cmd, int nargs, ...)
> +{
> +	struct ucall uc = {
> +		.cmd = cmd,
> +	};
> +	va_list va;
> +	int i;
> +
> +	nargs = min(nargs, UCALL_MAX_ARGS);
> +
> +	va_start(va, nargs);
> +	for (i = 0; i < nargs; ++i)
> +		uc.args[i] = va_arg(va, uint64_t);
> +	va_end(va);

...but not here. At least AArch64 needs them, see commit 9e2f6498efbb
("selftests: KVM: Handle compiler optimizations in ucall")

> +
> +	ucall_arch_do_ucall((vm_vaddr_t)&uc);
> +}
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> index e5f0f9e0d3ee..9f532dba1003 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> @@ -8,34 +8,21 @@
>  
>  #define UCALL_PIO_PORT ((uint16_t)0x1000)
>  
> -void ucall_init(struct kvm_vm *vm, void *arg)
> +void ucall_arch_init(struct kvm_vm *vm, void *arg)
>  {
>  }
>  
> -void ucall_uninit(struct kvm_vm *vm)
> +void ucall_arch_uninit(struct kvm_vm *vm)
>  {
>  }
>  
> -void ucall(uint64_t cmd, int nargs, ...)
> +void ucall_arch_do_ucall(vm_vaddr_t uc)
>  {
> -	struct ucall uc = {
> -		.cmd = cmd,
> -	};
> -	va_list va;
> -	int i;
> -
> -	nargs = min(nargs, UCALL_MAX_ARGS);
> -
> -	va_start(va, nargs);
> -	for (i = 0; i < nargs; ++i)
> -		uc.args[i] = va_arg(va, uint64_t);
> -	va_end(va);
> -
>  	asm volatile("in %[port], %%al"
> -		: : [port] "d" (UCALL_PIO_PORT), "D" (&uc) : "rax", "memory");
> +		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory");
>  }
>  
> -uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>  {
>  	struct kvm_run *run = vcpu->run;
>  	struct ucall ucall = {};
> -- 
> 2.37.1.455.g008518b4e5-goog
>

Thanks,
drew
