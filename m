Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F989A92E
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 09:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391193AbfHWHxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 03:53:05 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:39525 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732838AbfHWHxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 03:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566546782; x=1598082782;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=09Znot9poc8XaBH1wWZcsG68wcVBqQsZ/zN0uPdHxv8=;
  b=BNvD/jLUIT27bQTwudzyXAzKrgRK4p61mUBDSWUmz7v3zuNdtXRkWmdZ
   8oMoHLB49dMFQb+J9r4jsRDrvgBeUWN3clOEWfMspBWh7DqDmU7C/UPB+
   rEXPgOn6kKNx36rVuNElVyssjQbdsgmnHbwYorTBLDXwJTLv0z8Z+77zB
   s=;
X-IronPort-AV: E=Sophos;i="5.64,420,1559520000"; 
   d="scan'208";a="411287387"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 23 Aug 2019 07:52:50 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id B5A6FA1DEB;
        Fri, 23 Aug 2019 07:52:49 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 07:52:49 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.191) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 07:52:45 +0000
Subject: Re: [PATCH v5 15/20] RISC-V: KVM: Add timer functionality
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <20190822084131.114764-16-anup.patel@wdc.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <09d74212-4fa3-d64c-5a63-d556e955b88c@amazon.com>
Date:   Fri, 23 Aug 2019 09:52:42 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822084131.114764-16-anup.patel@wdc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.191]
X-ClientProxiedBy: EX13D13UWB004.ant.amazon.com (10.43.161.218) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.08.19 10:46, Anup Patel wrote:
> From: Atish Patra <atish.patra@wdc.com>
> 
> The RISC-V hypervisor specification doesn't have any virtual timer
> feature.
> 
> Due to this, the guest VCPU timer will be programmed via SBI calls.
> The host will use a separate hrtimer event for each guest VCPU to
> provide timer functionality. We inject a virtual timer interrupt to
> the guest VCPU whenever the guest VCPU hrtimer event expires.
> 
> The following features are not supported yet and will be added in
> future:
> 1. A time offset to adjust guest time from host time
> 2. A saved next event in guest vcpu for vm migration

Implementing these 2 bits right now should be trivial. Why wait?

> 
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/riscv/include/asm/kvm_host.h       |   4 +
>   arch/riscv/include/asm/kvm_vcpu_timer.h |  32 +++++++
>   arch/riscv/kvm/Makefile                 |   2 +-
>   arch/riscv/kvm/vcpu.c                   |   6 ++
>   arch/riscv/kvm/vcpu_timer.c             | 106 ++++++++++++++++++++++++
>   drivers/clocksource/timer-riscv.c       |   8 ++
>   include/clocksource/timer-riscv.h       |  16 ++++
>   7 files changed, 173 insertions(+), 1 deletion(-)
>   create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
>   create mode 100644 arch/riscv/kvm/vcpu_timer.c
>   create mode 100644 include/clocksource/timer-riscv.h
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index ab33e59a3d88..d2a2e45eefc0 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -12,6 +12,7 @@
>   #include <linux/types.h>
>   #include <linux/kvm.h>
>   #include <linux/kvm_types.h>
> +#include <asm/kvm_vcpu_timer.h>
>   
>   #ifdef CONFIG_64BIT
>   #define KVM_MAX_VCPUS			(1U << 16)
> @@ -167,6 +168,9 @@ struct kvm_vcpu_arch {
>   	unsigned long irqs_pending;
>   	unsigned long irqs_pending_mask;
>   
> +	/* VCPU Timer */
> +	struct kvm_vcpu_timer timer;
> +
>   	/* MMIO instruction details */
>   	struct kvm_mmio_decode mmio_decode;
>   
> diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
> new file mode 100644
> index 000000000000..df67ea86988e
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2019 Western Digital Corporation or its affiliates.
> + *
> + * Authors:
> + *	Atish Patra <atish.patra@wdc.com>
> + */
> +
> +#ifndef __KVM_VCPU_RISCV_TIMER_H
> +#define __KVM_VCPU_RISCV_TIMER_H
> +
> +#include <linux/hrtimer.h>
> +
> +#define VCPU_TIMER_PROGRAM_THRESHOLD_NS		1000
> +
> +struct kvm_vcpu_timer {
> +	bool init_done;
> +	/* Check if the timer is programmed */
> +	bool is_set;
> +	struct hrtimer hrt;
> +	/* Mult & Shift values to get nanosec from cycles */
> +	u32 mult;
> +	u32 shift;
> +};
> +
> +int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu);
> +int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
> +int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
> +int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu,
> +				    unsigned long ncycles);

This function never gets called?

> +
> +#endif
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index c0f57f26c13d..3e0c7558320d 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -9,6 +9,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
>   kvm-objs := $(common-objs-y)
>   
>   kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
> -kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o
> +kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
>   
>   obj-$(CONFIG_KVM)	+= kvm.o
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 6124077d154f..018fca436776 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -54,6 +54,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>   
>   	memcpy(cntx, reset_cntx, sizeof(*cntx));
>   
> +	kvm_riscv_vcpu_timer_reset(vcpu);
> +
>   	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
>   	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
>   }
> @@ -108,6 +110,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>   	cntx->hstatus |= HSTATUS_SP2P;
>   	cntx->hstatus |= HSTATUS_SPV;
>   
> +	/* Setup VCPU timer */
> +	kvm_riscv_vcpu_timer_init(vcpu);
> +
>   	/* Reset VCPU */
>   	kvm_riscv_reset_vcpu(vcpu);
>   
> @@ -116,6 +121,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>   
>   void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>   {
> +	kvm_riscv_vcpu_timer_deinit(vcpu);
>   	kvm_riscv_stage2_flush_cache(vcpu);
>   	kmem_cache_free(kvm_vcpu_cache, vcpu);
>   }
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> new file mode 100644
> index 000000000000..a45ca06e1aa6
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -0,0 +1,106 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Western Digital Corporation or its affiliates.
> + *
> + * Authors:
> + *     Atish Patra <atish.patra@wdc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <clocksource/timer-riscv.h>
> +#include <asm/csr.h>
> +#include <asm/kvm_vcpu_timer.h>
> +
> +static enum hrtimer_restart kvm_riscv_vcpu_hrtimer_expired(struct hrtimer *h)
> +{
> +	struct kvm_vcpu_timer *t = container_of(h, struct kvm_vcpu_timer, hrt);
> +	struct kvm_vcpu *vcpu = container_of(t, struct kvm_vcpu, arch.timer);
> +
> +	t->is_set = false;
> +	kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_S_TIMER);
> +
> +	return HRTIMER_NORESTART;
> +}
> +
> +static u64 kvm_riscv_delta_cycles2ns(u64 cycles, struct kvm_vcpu_timer *t)
> +{
> +	unsigned long flags;
> +	u64 cycles_now, cycles_delta, delta_ns;
> +
> +	local_irq_save(flags);
> +	cycles_now = get_cycles64();
> +	if (cycles_now < cycles)
> +		cycles_delta = cycles - cycles_now;
> +	else
> +		cycles_delta = 0;
> +	delta_ns = (cycles_delta * t->mult) >> t->shift;
> +	local_irq_restore(flags);
> +
> +	return delta_ns;
> +}
> +
> +static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
> +{
> +	if (!t->init_done || !t->is_set)
> +		return -EINVAL;
> +
> +	hrtimer_cancel(&t->hrt);
> +	t->is_set = false;
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu,
> +				    unsigned long ncycles)
> +{
> +	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
> +	u64 delta_ns = kvm_riscv_delta_cycles2ns(ncycles, t);

... in fact, I feel like I'm missing something obvious here. How does 
the guest trigger the timer event? What is the argument it uses for that 
and how does that play with the tbfreq in the earlier patch?


Alex

