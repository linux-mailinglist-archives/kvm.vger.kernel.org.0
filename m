Return-Path: <kvm+bounces-41886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C77CA6E845
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 03:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 238BF1892C84
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 02:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD124171E49;
	Tue, 25 Mar 2025 02:14:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BECFD2AF07;
	Tue, 25 Mar 2025 02:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742868879; cv=none; b=goaPMJUEkMWcSM0qYtuoUFBSHSoyV8JbBB6cKsuf6Nz+bzm9N62BM/z5maqEfzCuJqifOC5JsEW2nCwOSQdFcwAa/U4s+kZMhlASGS1TxowSp4LAF7qzzpChdbqlKpK/DCjgVc7+Oaor4D/HFAqIbwYp9GOoxvZ/xfFRRY7YtO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742868879; c=relaxed/simple;
	bh=jqUSCzJ3m/V47PgBm4XDMGM6+4BqyAaqVaAF0z8nO50=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PuDnLmYXcSiISMZJZkasn2g3nUtDhEO5zcQDNh/sP2ZxsokkmDRHsOQoC1pdR60nkiphT3J349Zkb+rbiVNZZMPm0wOJHZXUl1TnRgG0krp6d5haQLHoLUJn690TXYL07TADzqydUG5ivQdPxDfuWtkM9W8JkL/mBdJzwyjp+O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxjXKCEeJn9gWlAA--.14796S3;
	Tue, 25 Mar 2025 10:14:26 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxbsV9EeJnzKJeAA--.19172S3;
	Tue, 25 Mar 2025 10:14:25 +0800 (CST)
Subject: Re: [RFC V2] LoongArch: KVM: Handle interrupt early before enabling
 irq
From: bibo mao <maobibo@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250311074737.3160546-1-maobibo@loongson.cn>
Message-ID: <c220d043-2314-85bb-e99d-dc2c609aa739@loongson.cn>
Date: Tue, 25 Mar 2025 10:13:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250311074737.3160546-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxbsV9EeJnzKJeAA--.19172S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxur4kGrW5Jry5ZF18ZF4kKrX_yoWrZr18pF
	W7CanYkrs5JFyxXwnrtw4v9r13WrZ3Kry3Z3s7J3ySyw4ayFy8tr4kK39IqF1rK3ykJ3WI
	qFyFkw1qk3Z8twcCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6F4UJVW0owAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_
	JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
	xVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU2MKZDUUUU

Hi Paolo, Sean

This idea comes from x86, do you have any guidance or suggestion about it?

Also I notice that there is such irq_enable()/irq_disable() pair on x86, 
I do not know why it is so.
     local_irq_enable();
     ++vcpu->stat.exits;
     local_irq_disable();
     guest_timing_exit_irqoff();
     local_irq_enable();

Regards
Bibo Mao

On 2025/3/11 下午3:47, Bibo Mao wrote:
> If interrupt arrive when vCPU is running, vCPU will exit because of
> interrupt exception. Currently interrupt exception is handled after
> local_irq_enable() is called, and it is handled by host kernel rather
> than KVM hypervisor. It will introduce extra another interrupt
> exception and then host will handle irq.
> 
> If KVM hypervisor detect that it is interrupt exception, interrupt
> can be handle early in KVM hypervisor before local_irq_enable() is
> called.
> 
> On 3C5000 dual-way machine, there will be 10% -- 15% performance
> improvement with netperf UDP_RR option with 10G ethernet card.
>                     original     with patch    improvement
>    netperf UDP_RR     7200          8100           +12%
> 
> The total performance is low because irqchip is emulated in qemu VMM,
> however from the same testbed, there is performance improvement
> actually.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
> v1 ... v2:
>    1. Move guest_timing_exit_irqoff() after host interrupt handling like
>       other architectures.
>    2. Construct interrupt context pt_regs from guest entering context
>    3. Add cond_resched() after irq enabling
> ---
>   arch/loongarch/kernel/traps.c |  1 +
>   arch/loongarch/kvm/vcpu.c     | 36 ++++++++++++++++++++++++++++++++++-
>   2 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/loongarch/kernel/traps.c b/arch/loongarch/kernel/traps.c
> index 2ec3106c0da3..eed0d8b02ee3 100644
> --- a/arch/loongarch/kernel/traps.c
> +++ b/arch/loongarch/kernel/traps.c
> @@ -1114,6 +1114,7 @@ asmlinkage void noinstr do_vint(struct pt_regs *regs, unsigned long sp)
>   
>   	irqentry_exit(regs, state);
>   }
> +EXPORT_SYMBOL(do_vint);
>   
>   unsigned long eentry;
>   unsigned long tlbrentry;
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 9e1a9b4aa4c6..bab7a71eb965 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -5,6 +5,7 @@
>   
>   #include <linux/kvm_host.h>
>   #include <linux/entry-kvm.h>
> +#include <asm/exception.h>
>   #include <asm/fpu.h>
>   #include <asm/lbt.h>
>   #include <asm/loongarch.h>
> @@ -304,6 +305,23 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
>   	return ret;
>   }
>   
> +static void kvm_handle_irq(struct kvm_vcpu *vcpu)
> +{
> +	struct pt_regs regs, *old;
> +
> +	/*
> +	 * Construct pseudo pt_regs, only necessary registers is added
> +	 * Interrupt context coming from guest enter context
> +	 */
> +	old = (struct pt_regs *)(vcpu->arch.host_sp - sizeof(struct pt_regs));
> +	/* Disable preemption in irq exit function irqentry_exit() */
> +	regs.csr_prmd = 0;
> +	regs.regs[LOONGARCH_GPR_SP] = vcpu->arch.host_sp;
> +	regs.regs[LOONGARCH_GPR_FP] = old->regs[LOONGARCH_GPR_FP];
> +	regs.csr_era = old->regs[LOONGARCH_GPR_RA];
> +	do_vint(&regs, (unsigned long)&regs);
> +}
> +
>   /*
>    * Return 1 for resume guest and "<= 0" for resume host.
>    */
> @@ -321,8 +339,23 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
>   
>   	kvm_lose_pmu(vcpu);
>   
> -	guest_timing_exit_irqoff();
>   	guest_state_exit_irqoff();
> +
> +	/*
> +	 * VM exit because of host interrupts
> +	 * Handle irq directly before enabling irq
> +	 */
> +	if (!ecode && intr)
> +		kvm_handle_irq(vcpu);
> +
> +	/*
> +	 * Wait until after servicing IRQs to account guest time so that any
> +	 * ticks that occurred while running the guest are properly accounted
> +	 * to the guest. Waiting until IRQs are enabled degrades the accuracy
> +	 * of accounting via context tracking, but the loss of accuracy is
> +	 * acceptable for all known use cases.
> +	 */
> +	guest_timing_exit_irqoff();
>   	local_irq_enable();
>   
>   	trace_kvm_exit(vcpu, ecode);
> @@ -331,6 +364,7 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
>   	} else {
>   		WARN(!intr, "vm exiting with suspicious irq\n");
>   		++vcpu->stat.int_exits;
> +		cond_resched();
>   	}
>   
>   	if (ret == RESUME_GUEST)
> 
> base-commit: 80e54e84911a923c40d7bee33a34c1b4be148d7a
> 


