Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A091B9A999
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 10:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387906AbfHWIEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 04:04:53 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:10803 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729922AbfHWIEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 04:04:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566547492; x=1598083492;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=QH2Lv/LpUhd8u3hbB6A5tS3kD8z+tWSKTxDXj667gvQ=;
  b=NOXREWx4E9h3aWOsKgcVqZ6BM9gVVmAC2sEN/r7PFDYLfqiVFKggWr20
   /N8K9/lmkQWXcT8dxuVHRyEA6/rYX850PxeRnNyr6vxlJK2NXzbxoRX7s
   NU2StXI3L5bSLcFukM7HYssRF19pASm3P6k3ZIKslW/+pyGhwXo5r3Oko
   A=;
X-IronPort-AV: E=Sophos;i="5.64,420,1559520000"; 
   d="scan'208";a="696735630"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 23 Aug 2019 08:04:47 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 65D64C08F7;
        Fri, 23 Aug 2019 08:04:42 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 08:04:41 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.244) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 08:04:37 +0000
Subject: Re: [PATCH v5 18/20] RISC-V: KVM: Add SBI v0.1 support
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Atish Patra" <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <20190822084131.114764-19-anup.patel@wdc.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <40911e08-e0ce-a2b8-24d4-9cf357432850@amazon.com>
Date:   Fri, 23 Aug 2019 10:04:34 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822084131.114764-19-anup.patel@wdc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D04UWA001.ant.amazon.com (10.43.160.47) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.08.19 10:46, Anup Patel wrote:
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
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/riscv/include/asm/kvm_host.h |   2 +
>   arch/riscv/kvm/Makefile           |   2 +-
>   arch/riscv/kvm/vcpu_exit.c        |   3 +
>   arch/riscv/kvm/vcpu_sbi.c         | 119 ++++++++++++++++++++++++++++++
>   4 files changed, 125 insertions(+), 1 deletion(-)
>   create mode 100644 arch/riscv/kvm/vcpu_sbi.c
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 2af3a179c08e..0b1eceaef59f 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -241,4 +241,6 @@ bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu);
>   void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
>   void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
>   
> +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu);
> +
>   #endif /* __RISCV_KVM_HOST_H__ */
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 3e0c7558320d..b56dc1650d2c 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -9,6 +9,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
>   kvm-objs := $(common-objs-y)
>   
>   kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
> -kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
> +kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi.o
>   
>   obj-$(CONFIG_KVM)	+= kvm.o
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index fbc04fe335ad..87b83fcf9a14 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -534,6 +534,9 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>   		    (vcpu->arch.guest_context.hstatus & HSTATUS_STL))
>   			ret = stage2_page_fault(vcpu, run, scause, stval);
>   		break;
> +	case EXC_SUPERVISOR_SYSCALL:
> +		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> +			ret = kvm_riscv_vcpu_sbi_ecall(vcpu);
>   	default:
>   		break;
>   	};
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> new file mode 100644
> index 000000000000..5793202eb514
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -0,0 +1,119 @@
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
> +/* TODO: Handle traps due to unpriv load and redirect it back to VS-mode */

Ugh, another one of those? Can't you just figure out a way to recover 
from the page fault? Also, you want to combine this with the instruction 
load logic, so that we have a single place that guest address space 
reads go through.

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

Ah, this is where the timer set happens. I still don't understand how 
this takes the frequency bit into account?

> +		break;
> +	case SBI_CONSOLE_PUTCHAR:
> +		/* Not implemented */
> +		cp->a0 = -ENOTSUPP;
> +		break;
> +	case SBI_CONSOLE_GETCHAR:
> +		/* Not implemented */
> +		cp->a0 = -ENOTSUPP;
> +		break;

These two should be covered by the default case.

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
> +	/*
> +	 * TODO: There should be a way to call remote hfence.bvma.
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

Please just send unsupported SBI events into user space.

Alex

> +	};
> +
> +	if (ret >= 0)
> +		cp->sepc += 4;
> +
> +	return ret;
> +}
> 

