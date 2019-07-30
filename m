Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5E7A410
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 11:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbfG3J0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 05:26:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37273 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbfG3J0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 05:26:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so39867150wrr.4
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 02:26:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fDcXuaEqBcqFqyhatcYfAxE+0nZ8Uuvubs5vgvou1vo=;
        b=nsQ9P2zgxwh8UjBN6s8kqHDGmc/y8+beLdmF9rP3mZP8vIsW++RJoM1qn5zA5NPRXi
         R50rIIUe4qisr+uz500hzYSrrzSIZ9RAmfh+i9cWl/0SudiF7QrzPq79x5AA9iD1Y4Ty
         C3noryZAUqqSM2M8a3z1hoUV8Tf5y76xX+VHjqpPAlmU4oR2Z54oOSc7fgD/xk6SG5eW
         FVqIw8ycZelnSeu4x86ICJg9IMvR1t4JrmImK84K9qn9ruocbiZ596jBkm3DokVVuLBC
         aHVDv0pGni2xPPDA9/RQhDdSKQDdO17jO5vE6zyoigybj9L6FyRHQksmuOVzWe8feBHt
         yqpg==
X-Gm-Message-State: APjAAAUWdXEC953HZoqQF8RUyDWgi/2fSXIUvUJChLqUK+C7ZaQ/TkL3
        Tl+q9pLYC+NuBcseFmG5SAwg2A==
X-Google-Smtp-Source: APXvYqwtL1HZ1RWdht1fQjT9dvLgYd3QV82Ccznry2lpAS+f94IOzBKijj+MsaJZOX59J5rfMP7InA==
X-Received: by 2002:adf:ea4c:: with SMTP id j12mr131458738wrn.75.1564478775736;
        Tue, 30 Jul 2019 02:26:15 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id f1sm44093843wml.28.2019.07.30.02.26.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 02:26:15 -0700 (PDT)
Subject: Re: [RFC PATCH 15/16] RISC-V: KVM: Add SBI v0.1 support
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-16-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41bcc34d-7752-04e7-077b-9a3851f66189@redhat.com>
Date:   Tue, 30 Jul 2019 11:26:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-16-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:57, Anup Patel wrote:
> From: Atish Patra <atish.patra@wdc.com>
> 
> The KVM host kernel running in HS-mode needs to handle SBI calls coming
> from guest kernel running in VS-mode.
> 
> This patch adds SBI v0.1 support in KVM RISC-V. All the SBI calls are
> implemented correctly except remote tlb flushes. For remote TLB flushes,
> we are doing full TLB flush and this will be optimized in future.
> 
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |   2 +
>  arch/riscv/kvm/Makefile           |   2 +-
>  arch/riscv/kvm/vcpu_exit.c        |   3 +
>  arch/riscv/kvm/vcpu_sbi.c         | 118 ++++++++++++++++++++++++++++++
>  4 files changed, 124 insertions(+), 1 deletion(-)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi.c
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 1bb4befa89da..22a62ffc09f5 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -227,4 +227,6 @@ void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
>  void kvm_riscv_halt_guest(struct kvm *kvm);
>  void kvm_riscv_resume_guest(struct kvm *kvm);
>  
> +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu);
> +
>  #endif /* __RISCV_KVM_HOST_H__ */
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 3e0c7558320d..b56dc1650d2c 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -9,6 +9,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
>  kvm-objs := $(common-objs-y)
>  
>  kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
> -kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
> +kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi.o
>  
>  obj-$(CONFIG_KVM)	+= kvm.o
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 2d09640c98b2..003e43facdfc 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -531,6 +531,9 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		    (vcpu->arch.guest_context.hstatus & HSTATUS_STL))
>  			ret = stage2_page_fault(vcpu, run, scause, stval);
>  		break;
> +	case EXC_SUPERVISOR_SYSCALL:
> +		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> +			ret = kvm_riscv_vcpu_sbi_ecall(vcpu);
>  	default:
>  		break;
>  	};
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> new file mode 100644
> index 000000000000..8dfdbf744378
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -0,0 +1,118 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/**
> + * Copyright (c) 2019 Western Digital Corporation or its affiliates.
> + *
> + * Authors:
> + *     Atish Patra <atish.patra@wdc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <asm/csr.h>
> +#include <asm/kvm_vcpu_timer.h>
> +
> +#define SBI_VERSION_MAJOR			0
> +#define SBI_VERSION_MINOR			1
> +
> +static unsigned long kvm_sbi_unpriv_load(const unsigned long *addr,
> +					 struct kvm_vcpu *vcpu)
> +{
> +	unsigned long flags, val;
> +	unsigned long __hstatus, __sstatus;
> +
> +	local_irq_save(flags);
> +	__hstatus = csr_read(CSR_HSTATUS);
> +	__sstatus = csr_read(CSR_SSTATUS);
> +	csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTATUS_SPRV);
> +	csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus);
> +	val = *addr;
> +	csr_write(CSR_HSTATUS, __hstatus);
> +	csr_write(CSR_SSTATUS, __sstatus);
> +	local_irq_restore(flags);
> +
> +	return val;
> +}
> +
> +static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu, u32 type)
> +{
> +	int i;
> +	struct kvm_vcpu *tmp;
> +
> +	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> +		tmp->arch.power_off = true;
> +	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> +
> +	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> +	vcpu->run->system_event.type = type;
> +	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +}
> +
> +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu)
> +{
> +	int ret = 1;
> +	u64 next_cycle;
> +	int vcpuid;
> +	struct kvm_vcpu *remote_vcpu;
> +	ulong dhart_mask;
> +	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +
> +	if (!cp)
> +		return -EINVAL;
> +	switch (cp->a7) {
> +	case SBI_SET_TIMER:
> +#if __riscv_xlen == 32
> +		next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> +#else
> +		next_cycle = (u64)cp->a0;
> +#endif
> +		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> +		break;
> +	case SBI_CONSOLE_PUTCHAR:
> +		/* Not implemented */
> +		cp->a0 = -ENOTSUPP;
> +		break;
> +	case SBI_CONSOLE_GETCHAR:
> +		/* Not implemented */
> +		cp->a0 = -ENOTSUPP;
> +		break;

Would it make sense to send these two down to userspace?

Paolo

> +	case SBI_CLEAR_IPI:
> +		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_SOFT);
> +		break;
> +	case SBI_SEND_IPI:
> +		dhart_mask = kvm_sbi_unpriv_load((unsigned long *)cp->a0, vcpu);
> +		for_each_set_bit(vcpuid, &dhart_mask, BITS_PER_LONG) {
> +			remote_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, vcpuid);
> +			kvm_riscv_vcpu_set_interrupt(remote_vcpu, IRQ_S_SOFT);
> +		}
> +		break;
> +	case SBI_SHUTDOWN:
> +		kvm_sbi_system_shutdown(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN);
> +		ret = 0;
> +		break;
> +	case SBI_REMOTE_FENCE_I:
> +		sbi_remote_fence_i(NULL);
> +		break;
> +
> +	/*TODO:There should be a way to call remote hfence.bvma.
> +	 * Preferred method is now a SBI call. Until then, just flush
> +	 * all tlbs.
> +	 */
> +	case SBI_REMOTE_SFENCE_VMA:
> +		/*TODO: Parse vma range.*/
> +		sbi_remote_sfence_vma(NULL, 0, 0);
> +		break;
> +	case SBI_REMOTE_SFENCE_VMA_ASID:
> +		/*TODO: Parse vma range for given ASID */
> +		sbi_remote_sfence_vma(NULL, 0, 0);
> +		break;
> +	default:
> +		cp->a0 = ENOTSUPP;
> +		break;
> +	};
> +
> +	if (ret >= 0)
> +		cp->sepc += 4;
> +
> +	return ret;
> +}
> 

