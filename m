Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08C648423B
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 14:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbiADNTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 08:19:52 -0500
Received: from gloria.sntech.de ([185.11.138.130]:38740 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbiADNTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 08:19:52 -0500
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1n4jj4-0004br-8W; Tue, 04 Jan 2022 14:19:42 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Cc:     Atish Patra <atish.patra@wdc.com>, Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Atish Patra <atishp@rivosinc.com>
Subject: Re: [PATCH v5 1/5] RISC-V: KVM: Mark the existing SBI implementation as v01
Date:   Tue, 04 Jan 2022 14:19:41 +0100
Message-ID: <6615284.qex3tTltCR@diego>
In-Reply-To: <20211118083912.981995-2-atishp@rivosinc.com>
References: <20211118083912.981995-1-atishp@rivosinc.com> <20211118083912.981995-2-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Atish,

Am Donnerstag, 18. November 2021, 09:39:08 CET schrieb Atish Patra:
> From: Atish Patra <atish.patra@wdc.com>
> 
> The existing SBI specification impelementation follows v0.1
> specification. The latest specification allows more
> scalability and performance improvements.
> 
> Rename the existing implementation as v01 and provide a way to allow
> future extensions.
> 
> Reviewed-by: Anup Patel <anup.patel@wdc.com>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---

> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index eb3c045edf11..32376906ff20 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -1,5 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0
> -/**
> +/*
>   * Copyright (c) 2019 Western Digital Corporation or its affiliates.
>   *
>   * Authors:

This got already fixed by [0]
commit 0e2e64192100 ("riscv: kvm: fix non-kernel-doc comment block")
so this patch doesn't apply cleanly anymore.

This looks like it is a prerequisite for the sparse-hart-id series,
so a respin might be in order.

Heiko

[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0e2e641921000ffc647b12918cdfcc504a9f6e3b

> @@ -12,9 +12,25 @@
>  #include <asm/csr.h>
>  #include <asm/sbi.h>
>  #include <asm/kvm_vcpu_timer.h>
> +#include <asm/kvm_vcpu_sbi.h>
>  
> -#define SBI_VERSION_MAJOR			0
> -#define SBI_VERSION_MINOR			1
> +static int kvm_linux_err_map_sbi(int err)
> +{
> +	switch (err) {
> +	case 0:
> +		return SBI_SUCCESS;
> +	case -EPERM:
> +		return SBI_ERR_DENIED;
> +	case -EINVAL:
> +		return SBI_ERR_INVALID_PARAM;
> +	case -EFAULT:
> +		return SBI_ERR_INVALID_ADDRESS;
> +	case -EOPNOTSUPP:
> +		return SBI_ERR_NOT_SUPPORTED;
> +	default:
> +		return SBI_ERR_FAILURE;
> +	};
> +}
>  
>  static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
>  				       struct kvm_run *run)
> @@ -72,21 +88,19 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
>  	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>  }
>  
> -int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +				      unsigned long *out_val,
> +				      struct kvm_cpu_trap *utrap,
> +				      bool *exit)
>  {
>  	ulong hmask;
> -	int i, ret = 1;
> +	int i, ret = 0;
>  	u64 next_cycle;
>  	struct kvm_vcpu *rvcpu;
> -	bool next_sepc = true;
>  	struct cpumask cm, hm;
>  	struct kvm *kvm = vcpu->kvm;
> -	struct kvm_cpu_trap utrap = { 0 };
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>  
> -	if (!cp)
> -		return -EINVAL;
> -
>  	switch (cp->a7) {
>  	case SBI_EXT_0_1_CONSOLE_GETCHAR:
>  	case SBI_EXT_0_1_CONSOLE_PUTCHAR:
> @@ -95,8 +109,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		 * handled in kernel so we forward these to user-space
>  		 */
>  		kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -		next_sepc = false;
> -		ret = 0;
> +		*exit = true;
>  		break;
>  	case SBI_EXT_0_1_SET_TIMER:
>  #if __riscv_xlen == 32
> @@ -104,47 +117,42 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  #else
>  		next_cycle = (u64)cp->a0;
>  #endif
> -		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> +		ret = kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
>  		break;
>  	case SBI_EXT_0_1_CLEAR_IPI:
> -		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
> +		ret = kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
>  		break;
>  	case SBI_EXT_0_1_SEND_IPI:
>  		if (cp->a0)
>  			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -							   &utrap);
> +							   utrap);
>  		else
>  			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> -		if (utrap.scause) {
> -			utrap.sepc = cp->sepc;
> -			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> -			next_sepc = false;
> +		if (utrap->scause)
>  			break;
> -		}
> +
>  		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
>  			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> -			kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
> +			ret = kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
> +			if (ret < 0)
> +				break;
>  		}
>  		break;
>  	case SBI_EXT_0_1_SHUTDOWN:
>  		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
> -		next_sepc = false;
> -		ret = 0;
> +		*exit = true;
>  		break;
>  	case SBI_EXT_0_1_REMOTE_FENCE_I:
>  	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
>  	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
>  		if (cp->a0)
>  			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -							   &utrap);
> +							   utrap);
>  		else
>  			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> -		if (utrap.scause) {
> -			utrap.sepc = cp->sepc;
> -			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> -			next_sepc = false;
> +		if (utrap->scause)
>  			break;
> -		}
> +
>  		cpumask_clear(&cm);
>  		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
>  			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> @@ -154,22 +162,97 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		}
>  		riscv_cpuid_to_hartid_mask(&cm, &hm);
>  		if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
> -			sbi_remote_fence_i(cpumask_bits(&hm));
> +			ret = sbi_remote_fence_i(cpumask_bits(&hm));
>  		else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
> -			sbi_remote_hfence_vvma(cpumask_bits(&hm),
> +			ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
>  						cp->a1, cp->a2);
>  		else
> -			sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
> +			ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
>  						cp->a1, cp->a2, cp->a3);
>  		break;
>  	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> +	.extid_start = SBI_EXT_0_1_SET_TIMER,
> +	.extid_end = SBI_EXT_0_1_SHUTDOWN,
> +	.handler = kvm_sbi_ext_v01_handler,
> +};
> +
> +static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> +	&vcpu_sbi_ext_v01,
> +};
> +
> +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid)
> +{
> +	int i = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +		if (sbi_ext[i]->extid_start <= extid &&
> +		    sbi_ext[i]->extid_end >= extid)
> +			return sbi_ext[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	int ret = 1;
> +	bool next_sepc = true;
> +	bool userspace_exit = false;
> +	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	const struct kvm_vcpu_sbi_extension *sbi_ext;
> +	struct kvm_cpu_trap utrap = { 0 };
> +	unsigned long out_val = 0;
> +	bool ext_is_v01 = false;
> +
> +	sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
> +	if (sbi_ext && sbi_ext->handler) {
> +		if (cp->a7 >= SBI_EXT_0_1_SET_TIMER &&
> +		    cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
> +			ext_is_v01 = true;
> +		ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
> +	} else {
>  		/* Return error for unsupported SBI calls */
>  		cp->a0 = SBI_ERR_NOT_SUPPORTED;
> -		break;
> +		goto ecall_done;
> +	}
> +
> +	/* Handle special error cases i.e trap, exit or userspace forward */
> +	if (utrap.scause) {
> +		/* No need to increment sepc or exit ioctl loop */
> +		ret = 1;
> +		utrap.sepc = cp->sepc;
> +		kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> +		next_sepc = false;
> +		goto ecall_done;
>  	}
>  
> +	/* Exit ioctl loop or Propagate the error code the guest */
> +	if (userspace_exit) {
> +		next_sepc = false;
> +		ret = 0;
> +	} else {
> +		/**
> +		 * SBI extension handler always returns an Linux error code. Convert
> +		 * it to the SBI specific error code that can be propagated the SBI
> +		 * caller.
> +		 */
> +		ret = kvm_linux_err_map_sbi(ret);
> +		cp->a0 = ret;
> +		ret = 1;
> +	}
> +ecall_done:
>  	if (next_sepc)
>  		cp->sepc += 4;
> +	if (!ext_is_v01)
> +		cp->a1 = out_val;
>  
>  	return ret;
>  }
> 




