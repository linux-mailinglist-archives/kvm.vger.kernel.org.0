Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D1D587A21
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 11:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbiHBJyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 05:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbiHBJyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 05:54:44 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8C117049;
        Tue,  2 Aug 2022 02:54:40 -0700 (PDT)
Date:   Tue, 2 Aug 2022 11:54:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659434078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wa5eejjtGHxSUyoNdwZTsoUHFpSlVjk6Jt5se0ltnss=;
        b=QWGNOJiq16w0VexMaO+QC94HrmuAuandBis6QRXv+3Zs8Qd+GlBWTvUrf1u8U0iOAnDymI
        B/PSYL+4SGSK7By4ByLJUuBpru1gSblLk2ABxOxtev6nIH7G52keuz/oYI99MiScF/yq0Q
        ZkDAi2Ovz5JSjH8uKW5t5LlyckUYjQ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, seanjc@google.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, joro@8bytes.org, mizhang@google.com,
        pbonzini@redhat.com
Subject: Re: [V2 07/11] KVM: selftests: Consolidate boilerplate code in
 get_ucall()
Message-ID: <20220802095437.fbho3bwgs3yi3fur@kamzik>
References: <20220801201109.825284-1-pgonda@google.com>
 <20220801201109.825284-8-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801201109.825284-8-pgonda@google.com>
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

On Mon, Aug 01, 2022 at 01:11:05PM -0700, Peter Gonda wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Consolidate the actual copying of a ucall struct from guest=>host into
> the common get_ucall().  Return a host virtual address instead of a guest
> virtual address even though the addr_gva2hva() part could be moved to
> get_ucall() too.  Conceptually, get_ucall() is invoked from the host and
> should return a host virtual address (and returning NULL for "nothing to
> see here" is far superior to returning 0).

The code does not match this description anymore, now that
ucall_arch_get_ucall() returns a gva (as a uint64_t), but the description
is good, the code is wrong. Please restore the spirit of Sean's patch
(particularly because it still says it's from Sean...)

Thanks,
drew

> 
> Use pointer shenanigans instead of an unnecessary bounce buffer when the
> caller of get_ucall() provides a valid pointer.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  .../selftests/kvm/include/ucall_common.h      |  8 ++------
>  .../testing/selftests/kvm/lib/aarch64/ucall.c | 13 +++----------
>  tools/testing/selftests/kvm/lib/riscv/ucall.c | 19 +++----------------
>  tools/testing/selftests/kvm/lib/s390x/ucall.c | 16 +++-------------
>  .../testing/selftests/kvm/lib/ucall_common.c  | 19 +++++++++++++++++++
>  .../testing/selftests/kvm/lib/x86_64/ucall.c  | 16 +++-------------
>  6 files changed, 33 insertions(+), 58 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 5a85f5318bbe..c1bc8e33ef3f 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -27,9 +27,10 @@ struct ucall {
>  void ucall_arch_init(struct kvm_vm *vm, void *arg);
>  void ucall_arch_uninit(struct kvm_vm *vm);
>  void ucall_arch_do_ucall(vm_vaddr_t uc);
> -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
>  
>  void ucall(uint64_t cmd, int nargs, ...);
> +uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>  
>  static inline void ucall_init(struct kvm_vm *vm, void *arg)
>  {
> @@ -41,11 +42,6 @@ static inline void ucall_uninit(struct kvm_vm *vm)
>  	ucall_arch_uninit(vm);
>  }
>  
> -static inline uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> -{
> -	return ucall_arch_get_ucall(vcpu, uc);
> -}
> -
>  #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
>  				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
>  #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> index 1c81a6a5c1f2..d2f099caa9ab 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> @@ -78,24 +78,17 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
>  uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>  {
>  	struct kvm_run *run = vcpu->run;
> -	struct ucall ucall = {};
> -
> -	if (uc)
> -		memset(uc, 0, sizeof(*uc));
>  
>  	if (run->exit_reason == KVM_EXIT_MMIO &&
>  	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
> -		vm_vaddr_t gva;
> +		uint64_t ucall_addr;
>  
>  		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
>  			    "Unexpected ucall exit mmio address access");
>  		memcpy(&gva, run->mmio.data, sizeof(gva));
> -		memcpy(&ucall, addr_gva2hva(vcpu->vm, gva), sizeof(ucall));
>  
> -		vcpu_run_complete_io(vcpu);
> -		if (uc)
> -			memcpy(uc, &ucall, sizeof(ucall));
> +		return ucall_addr;
>  	}
>  
> -	return ucall.cmd;
> +	return 0;
>  }
> diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> index b1598f418c1f..3f000d0b705f 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> @@ -51,27 +51,15 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
>  		  uc, 0, 0, 0, 0, 0);
>  }
>  
> -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_run *run = vcpu->run;
> -	struct ucall ucall = {};
> -
> -	if (uc)
> -		memset(uc, 0, sizeof(*uc));
>  
>  	if (run->exit_reason == KVM_EXIT_RISCV_SBI &&
>  	    run->riscv_sbi.extension_id == KVM_RISCV_SELFTESTS_SBI_EXT) {
>  		switch (run->riscv_sbi.function_id) {
>  		case KVM_RISCV_SELFTESTS_SBI_UCALL:
> -			memcpy(&ucall,
> -			       addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]),
> -			       sizeof(ucall));
> -
> -			vcpu_run_complete_io(vcpu);
> -			if (uc)
> -				memcpy(uc, &ucall, sizeof(ucall));
> -
> -			break;
> +			return vcpu->vm, run->riscv_sbi.args[0];
>  		case KVM_RISCV_SELFTESTS_SBI_UNEXP:
>  			vcpu_dump(stderr, vcpu, 2);
>  			TEST_ASSERT(0, "Unexpected trap taken by guest");
> @@ -80,6 +68,5 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>  			break;
>  		}
>  	}
> -
> -	return ucall.cmd;
> +	return 0;
>  }
> diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> index 114cb4af295f..f7a5a7eb4aa8 100644
> --- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> @@ -20,13 +20,9 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
>  	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
>  }
>  
> -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_run *run = vcpu->run;
> -	struct ucall ucall = {};
> -
> -	if (uc)
> -		memset(uc, 0, sizeof(*uc));
>  
>  	if (run->exit_reason == KVM_EXIT_S390_SIEIC &&
>  	    run->s390_sieic.icptcode == 4 &&
> @@ -34,13 +30,7 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>  	    (run->s390_sieic.ipb >> 16) == 0x501) {
>  		int reg = run->s390_sieic.ipa & 0xf;
>  
> -		memcpy(&ucall, addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]),
> -		       sizeof(ucall));
> -
> -		vcpu_run_complete_io(vcpu);
> -		if (uc)
> -			memcpy(uc, &ucall, sizeof(ucall));
> +		return run->s.regs.gprs[reg];
>  	}
> -
> -	return ucall.cmd;
> +	return 0;
>  }
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index 749ffdf23855..a060252bab40 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -18,3 +18,22 @@ void ucall(uint64_t cmd, int nargs, ...)
>  
>  	ucall_arch_do_ucall((vm_vaddr_t)&uc);
>  }
> +
> +uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +{
> +	struct ucall ucall;
> +	void *addr;
> +
> +	if (!uc)
> +		uc = &ucall;
> +
> +	addr = addr_gva2hva(vcpu->vm, ucall_arch_get_ucall(vcpu));
> +	if (addr) {
> +		memcpy(uc, addr, sizeof(*uc));
> +		vcpu_run_complete_io(vcpu);
> +	} else {
> +		memset(uc, 0, sizeof(*uc));
> +	}
> +
> +	return uc->cmd;
> +}
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> index 9f532dba1003..24746120a593 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> @@ -22,25 +22,15 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
>  		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory");
>  }
>  
> -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_run *run = vcpu->run;
> -	struct ucall ucall = {};
> -
> -	if (uc)
> -		memset(uc, 0, sizeof(*uc));
>  
>  	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
>  		struct kvm_regs regs;
>  
>  		vcpu_regs_get(vcpu, &regs);
> -		memcpy(&ucall, addr_gva2hva(vcpu->vm, (vm_vaddr_t)regs.rdi),
> -		       sizeof(ucall));
> -
> -		vcpu_run_complete_io(vcpu);
> -		if (uc)
> -			memcpy(uc, &ucall, sizeof(ucall));
> +		return regs.rdi;
>  	}
> -
> -	return ucall.cmd;
> +	return 0;
>  }
> -- 
> 2.37.1.455.g008518b4e5-goog
> 
