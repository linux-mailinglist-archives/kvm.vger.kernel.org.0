Return-Path: <kvm+bounces-3300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A239C802D83
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5791F280EAC
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 08:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7597FBE4;
	Mon,  4 Dec 2023 08:46:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 279B085;
	Mon,  4 Dec 2023 00:46:40 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.183])
	by gateway (Coremail) with SMTP id _____8Dx_7vtkW1l0bM+AA--.538S3;
	Mon, 04 Dec 2023 16:46:37 +0800 (CST)
Received: from [10.20.42.183] (unknown [10.20.42.183])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx7y_skW1lpxhUAA--.54473S3;
	Mon, 04 Dec 2023 16:46:36 +0800 (CST)
Subject: Re: [PATCH v4 3/3] LoongArch: KVM: Remove kvm_acquire_timer before
 entering guest
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20231116023036.2324371-1-maobibo@loongson.cn>
 <20231116023036.2324371-4-maobibo@loongson.cn>
From: zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <408e06fe-6c98-129c-d369-ba4e91b07ea6@loongson.cn>
Date: Mon, 4 Dec 2023 16:48:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231116023036.2324371-4-maobibo@loongson.cn>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:AQAAf8Cx7y_skW1lpxhUAA--.54473S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Jw43GFyruF4Utw4xXr15WrX_yoW7Ww48pF
	WxuwnFqw4rJr4UWw17t3Wq9rW5X3ykKr1fJFykJayFyrsIyrn0qF4kGFZ5XFW3J3yIyF4S
	vr1rtwnxAF4DA3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jO
	db8UUUUU=

Reviewed-by: Tianrui Zhao <zhaotianrui@loongson.cn>

ÔÚ 2023/11/16 ÉÏÎç10:30, Bibo Mao Ð´µÀ:
> Timer emulation method in VM is switch to SW timer, there are two
> places where timer emulation is needed. One is during vcpu thread
> context switch, the other is halt-polling with idle instruction
> emulation. SW timer switching is remove during halt-polling mode,
> so it is not necessary to disable SW timer before entering to guest.
>
> This patch removes SW timer handling before entering guest mode, and
> put it in HW timer restoring flow when vcpu thread is sched-in. With
> this patch, vm timer emulation is simpler, there is SW/HW timer
> switch only in vcpu thread context switch scenario.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   arch/loongarch/include/asm/kvm_vcpu.h |  1 -
>   arch/loongarch/kvm/timer.c            | 22 ++++++--------------
>   arch/loongarch/kvm/vcpu.c             | 29 ---------------------------
>   3 files changed, 6 insertions(+), 46 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
> index 553cfa2b2b1c..0e87652f780a 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -55,7 +55,6 @@ void kvm_save_fpu(struct loongarch_fpu *fpu);
>   void kvm_restore_fpu(struct loongarch_fpu *fpu);
>   void kvm_restore_fcsr(struct loongarch_fpu *fpu);
>   
> -void kvm_acquire_timer(struct kvm_vcpu *vcpu);
>   void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
>   void kvm_reset_timer(struct kvm_vcpu *vcpu);
>   void kvm_save_timer(struct kvm_vcpu *vcpu);
> diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
> index e37c0ebffabd..711982f9eeb5 100644
> --- a/arch/loongarch/kvm/timer.c
> +++ b/arch/loongarch/kvm/timer.c
> @@ -64,19 +64,6 @@ void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long timer_hz)
>   	kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_TVAL, 0);
>   }
>   
> -/*
> - * Restore hard timer state and enable guest to access timer registers
> - * without trap, should be called with irq disabled
> - */
> -void kvm_acquire_timer(struct kvm_vcpu *vcpu)
> -{
> -	/*
> -	 * Freeze the soft-timer and sync the guest stable timer with it. We do
> -	 * this with interrupts disabled to avoid latency.
> -	 */
> -	hrtimer_cancel(&vcpu->arch.swtimer);
> -}
> -
>   /*
>    * Restore soft timer state from saved context.
>    */
> @@ -98,6 +85,11 @@ void kvm_restore_timer(struct kvm_vcpu *vcpu)
>   		return;
>   	}
>   
> +	/*
> +	 * Freeze the soft-timer and sync the guest stable timer with it.
> +	 */
> +	hrtimer_cancel(&vcpu->arch.swtimer);
> +
>   	/*
>   	 * Set remainder tick value if not expired
>   	 */
> @@ -115,7 +107,7 @@ void kvm_restore_timer(struct kvm_vcpu *vcpu)
>   		/*
>   		 * Inject timer here though sw timer should inject timer
>   		 * interrupt async already, since sw timer may be cancelled
> -		 * during injecting intr async in function kvm_acquire_timer
> +		 * during injecting intr async
>   		 */
>   		kvm_queue_irq(vcpu, INT_TI);
>   	}
> @@ -140,11 +132,9 @@ static void _kvm_save_timer(struct kvm_vcpu *vcpu)
>   	vcpu->arch.expire = expire;
>   	if (ticks) {
>   		/*
> -		 * Update hrtimer to use new timeout
>   		 * HRTIMER_MODE_PINNED is suggested since vcpu may run in
>   		 * the same physical cpu in next time
>   		 */
> -		hrtimer_cancel(&vcpu->arch.swtimer);
>   		hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED);
>   	} else if (vcpu->stat.generic.blocking) {
>   		/*
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 42663a345bd1..cf1c4d64c1b7 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -95,7 +95,6 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
>   		 * check vmid before vcpu enter guest
>   		 */
>   		local_irq_disable();
> -		kvm_acquire_timer(vcpu);
>   		kvm_deliver_intr(vcpu);
>   		kvm_deliver_exception(vcpu);
>   		/* Make sure the vcpu mode has been written */
> @@ -251,23 +250,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>   	return -EINVAL;
>   }
>   
> -/**
> - * kvm_migrate_count() - Migrate timer.
> - * @vcpu:       Virtual CPU.
> - *
> - * Migrate hrtimer to the current CPU by cancelling and restarting it
> - * if the hrtimer is active.
> - *
> - * Must be called when the vCPU is migrated to a different CPU, so that
> - * the timer can interrupt the guest at the new CPU, and the timer irq can
> - * be delivered to the vCPU.
> - */
> -static void kvm_migrate_count(struct kvm_vcpu *vcpu)
> -{
> -	if (hrtimer_cancel(&vcpu->arch.swtimer))
> -		hrtimer_restart(&vcpu->arch.swtimer);
> -}
> -
>   static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *val)
>   {
>   	unsigned long gintc;
> @@ -796,17 +778,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	unsigned long flags;
>   
>   	local_irq_save(flags);
> -	if (vcpu->arch.last_sched_cpu != cpu) {
> -		kvm_debug("[%d->%d]KVM vCPU[%d] switch\n",
> -				vcpu->arch.last_sched_cpu, cpu, vcpu->vcpu_id);
> -		/*
> -		 * Migrate the timer interrupt to the current CPU so that it
> -		 * always interrupts the guest and synchronously triggers a
> -		 * guest timer interrupt.
> -		 */
> -		kvm_migrate_count(vcpu);
> -	}
> -
>   	/* Restore guest state to registers */
>   	_kvm_vcpu_load(vcpu, cpu);
>   	local_irq_restore(flags);


