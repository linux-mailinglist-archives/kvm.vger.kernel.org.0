Return-Path: <kvm+bounces-66562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C07CD7BD7
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 02:52:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3176A301CE4C
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 01:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9CD34E242;
	Tue, 23 Dec 2025 01:24:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAB034DCC2;
	Tue, 23 Dec 2025 01:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766453091; cv=none; b=PBLpcJekiqoyWBcLYQXKByAmssijNzTeh7jAV/9uwHp9iT8GZFQsTd77h4dLhQwBpKnmxsXIEb9A0wmlUs+VaTS/2KWAEjdAl7COdQKVWKiRKgLXZ9DuZUzo9cUXmxycb/UF2tAj0q2PLVlZsF4sBDPMVGQc4UXBh86KJVn6v+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766453091; c=relaxed/simple;
	bh=LEjfGnUBZRS1nxt2OUhGW+lL8SD1uVZGM9wlWb8VXjI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Y2YRy+WOTFNA/78kFaPWQ5Emu/+7+aBs6VQg3u6cdgj9XjpLNMdoPqONaphKueiw4kI5P89yOlCH88zgbWUZNcmfZ0aYLwxd1lWNrLAN3yZcvfUgd3b0v8jwuyJ4AZvKbHpXYo6XAK9zT46VnwJdfV2yZJLWFc4qgxIgQhRfkeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxOMJY70lp3zkCAA--.6926S3;
	Tue, 23 Dec 2025 09:24:40 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxTMJS70lpSKMDAA--.8321S3;
	Tue, 23 Dec 2025 09:24:36 +0800 (CST)
Subject: Re: [PATCH V2 1/2] LoongArch: KVM: Compile the switch.S file directly
 into the kernel
To: Xianglai Li <lixianglai@loongson.cn>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: stable@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20251222113409.2343711-1-lixianglai@loongson.cn>
 <20251222113409.2343711-2-lixianglai@loongson.cn>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <1dbb85b2-9b3b-a1b4-6fe2-b549099ab876@loongson.cn>
Date: Tue, 23 Dec 2025 09:22:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251222113409.2343711-2-lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxTMJS70lpSKMDAA--.8321S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3AFWfKw13tr43GryDGr4rZwc_yoWfuFyfpF
	9rurs5KF48Jrn5XryDJ3WDZrZ8Zw4vgr1I9F12yayrCrnFgr1UXr1ktrWDZFy0k3ykJFWF
	vFyrWrnavFyUX3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5xhLUUUUU=



On 2025/12/22 下午7:34, Xianglai Li wrote:
> If we directly compile the switch.S file into the kernel, the address of
> the kvm_exc_entry function will definitely be within the DMW memory area.
> Therefore, we will no longer need to perform a copy relocation of
> kvm_exc_entry.
> 
> Based on the above description, compile switch.S directly into the kernel,
> and then remove the copy relocation execution logic for the kvm_exc_entry
> function.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Charlie Jenkins <charlie@rivosinc.com>
> Cc: Xianglai Li <lixianglai@loongson.cn>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> 
>   arch/loongarch/Kbuild                       |  2 +-
>   arch/loongarch/include/asm/asm-prototypes.h | 21 +++++++++++++
>   arch/loongarch/include/asm/kvm_host.h       |  3 --
>   arch/loongarch/kvm/Makefile                 |  2 +-
>   arch/loongarch/kvm/main.c                   | 35 ++-------------------
>   arch/loongarch/kvm/switch.S                 | 22 ++++++++++---
>   6 files changed, 43 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
> index beb8499dd8ed..1c7a0dbe5e72 100644
> --- a/arch/loongarch/Kbuild
> +++ b/arch/loongarch/Kbuild
> @@ -3,7 +3,7 @@ obj-y += mm/
>   obj-y += net/
>   obj-y += vdso/
>   
> -obj-$(CONFIG_KVM) += kvm/
> +obj-$(subst m,y,$(CONFIG_KVM)) += kvm/
>   
>   # for cleaning
>   subdir- += boot
> diff --git a/arch/loongarch/include/asm/asm-prototypes.h b/arch/loongarch/include/asm/asm-prototypes.h
> index 704066b4f736..e8ce153691e5 100644
> --- a/arch/loongarch/include/asm/asm-prototypes.h
> +++ b/arch/loongarch/include/asm/asm-prototypes.h
> @@ -20,3 +20,24 @@ asmlinkage void noinstr __no_stack_protector ret_from_kernel_thread(struct task_
>   								    struct pt_regs *regs,
>   								    int (*fn)(void *),
>   								    void *fn_arg);
> +
> +struct kvm_run;
> +struct kvm_vcpu;
> +
> +void kvm_exc_entry(void);
> +int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
> +
> +struct loongarch_fpu;
> +
> +#ifdef CONFIG_CPU_HAS_LSX
> +void kvm_save_lsx(struct loongarch_fpu *fpu);
> +void kvm_restore_lsx(struct loongarch_fpu *fpu);
> +#endif
> +
> +#ifdef CONFIG_CPU_HAS_LASX
> +void kvm_save_lasx(struct loongarch_fpu *fpu);
> +void kvm_restore_lasx(struct loongarch_fpu *fpu);
> +#endif
> +
> +void kvm_save_fpu(struct loongarch_fpu *fpu);
> +void kvm_restore_fpu(struct loongarch_fpu *fpu);
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index e4fe5b8e8149..1a1be10e3803 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -85,7 +85,6 @@ struct kvm_context {
>   struct kvm_world_switch {
>   	int (*exc_entry)(void);
>   	int (*enter_guest)(struct kvm_run *run, struct kvm_vcpu *vcpu);
> -	unsigned long page_order;
>   };
>   
>   #define MAX_PGTABLE_LEVELS	4
> @@ -347,8 +346,6 @@ void kvm_exc_entry(void);
>   int  kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu);
>   
>   extern unsigned long vpid_mask;
> -extern const unsigned long kvm_exception_size;
> -extern const unsigned long kvm_enter_guest_size;
>   extern struct kvm_world_switch *kvm_loongarch_ops;
>   
>   #define SW_GCSR		(1 << 0)
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index cb41d9265662..fe665054f824 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -11,7 +11,7 @@ kvm-y += exit.o
>   kvm-y += interrupt.o
>   kvm-y += main.o
>   kvm-y += mmu.o
> -kvm-y += switch.o
> +obj-y += switch.o
>   kvm-y += timer.o
>   kvm-y += tlb.o
>   kvm-y += vcpu.o
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 80ea63d465b8..67d234540ed4 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -340,8 +340,7 @@ void kvm_arch_disable_virtualization_cpu(void)
>   
>   static int kvm_loongarch_env_init(void)
>   {
> -	int cpu, order, ret;
> -	void *addr;
> +	int cpu, ret;
>   	struct kvm_context *context;
>   
>   	vmcs = alloc_percpu(struct kvm_context);
> @@ -357,30 +356,8 @@ static int kvm_loongarch_env_init(void)
>   		return -ENOMEM;
>   	}
>   
> -	/*
> -	 * PGD register is shared between root kernel and kvm hypervisor.
> -	 * So world switch entry should be in DMW area rather than TLB area
> -	 * to avoid page fault reenter.
> -	 *
> -	 * In future if hardware pagetable walking is supported, we won't
> -	 * need to copy world switch code to DMW area.
> -	 */
> -	order = get_order(kvm_exception_size + kvm_enter_guest_size);
> -	addr = (void *)__get_free_pages(GFP_KERNEL, order);
> -	if (!addr) {
> -		free_percpu(vmcs);
> -		vmcs = NULL;
> -		kfree(kvm_loongarch_ops);
> -		kvm_loongarch_ops = NULL;
> -		return -ENOMEM;
> -	}
> -
> -	memcpy(addr, kvm_exc_entry, kvm_exception_size);
> -	memcpy(addr + kvm_exception_size, kvm_enter_guest, kvm_enter_guest_size);
> -	flush_icache_range((unsigned long)addr, (unsigned long)addr + kvm_exception_size + kvm_enter_guest_size);
> -	kvm_loongarch_ops->exc_entry = addr;
> -	kvm_loongarch_ops->enter_guest = addr + kvm_exception_size;
> -	kvm_loongarch_ops->page_order = order;
> +	kvm_loongarch_ops->exc_entry = (void *)kvm_exc_entry;
> +	kvm_loongarch_ops->enter_guest = (void *)kvm_enter_guest;
>   
>   	vpid_mask = read_csr_gstat();
>   	vpid_mask = (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GIDBIT_SHIFT;
> @@ -414,16 +391,10 @@ static int kvm_loongarch_env_init(void)
>   
>   static void kvm_loongarch_env_exit(void)
>   {
> -	unsigned long addr;
> -
>   	if (vmcs)
>   		free_percpu(vmcs);
>   
>   	if (kvm_loongarch_ops) {
> -		if (kvm_loongarch_ops->exc_entry) {
> -			addr = (unsigned long)kvm_loongarch_ops->exc_entry;
> -			free_pages(addr, kvm_loongarch_ops->page_order);
> -		}
>   		kfree(kvm_loongarch_ops);
>   	}
>   
> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> index f1768b7a6194..93845ce53651 100644
> --- a/arch/loongarch/kvm/switch.S
> +++ b/arch/loongarch/kvm/switch.S
> @@ -5,6 +5,7 @@
>   
>   #include <linux/linkage.h>
>   #include <asm/asm.h>
> +#include <asm/page.h>
>   #include <asm/asmmacro.h>
>   #include <asm/loongarch.h>
>   #include <asm/regdef.h>
> @@ -100,10 +101,18 @@
>   	 *  -        is still in guest mode, such as pgd table/vmid registers etc,
>   	 *  -        will fix with hw page walk enabled in future
>   	 * load kvm_vcpu from reserved CSR KVM_VCPU_KS, and save a2 to KVM_TEMP_KS
> +	 *
> +	 * PGD register is shared between root kernel and kvm hypervisor.
> +	 * So world switch entry should be in DMW area rather than TLB area
> +	 * to avoid page fault reenter.
> +	 *
> +	 * In future if hardware pagetable walking is supported, we won't
> +	 * need to copy world switch code to DMW area.
>   	 */
>   	.text
>   	.cfi_sections	.debug_frame
>   SYM_CODE_START(kvm_exc_entry)
> +	.p2align PAGE_SHIFT
>   	UNWIND_HINT_UNDEFINED
>   	csrwr	a2,   KVM_TEMP_KS
>   	csrrd	a2,   KVM_VCPU_KS
> @@ -190,8 +199,8 @@ ret_to_host:
>   	kvm_restore_host_gpr    a2
>   	jr      ra
>   
> -SYM_INNER_LABEL(kvm_exc_entry_end, SYM_L_LOCAL)
>   SYM_CODE_END(kvm_exc_entry)
> +EXPORT_SYMBOL(kvm_exc_entry)
>   
>   /*
>    * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
> @@ -215,8 +224,8 @@ SYM_FUNC_START(kvm_enter_guest)
>   	/* Save kvm_vcpu to kscratch */
>   	csrwr	a1, KVM_VCPU_KS
>   	kvm_switch_to_guest
> -SYM_INNER_LABEL(kvm_enter_guest_end, SYM_L_LOCAL)
>   SYM_FUNC_END(kvm_enter_guest)
> +EXPORT_SYMBOL(kvm_enter_guest)
>   
>   SYM_FUNC_START(kvm_save_fpu)
>   	fpu_save_csr	a0 t1
> @@ -224,6 +233,7 @@ SYM_FUNC_START(kvm_save_fpu)
>   	fpu_save_cc	a0 t1 t2
>   	jr              ra
>   SYM_FUNC_END(kvm_save_fpu)
> +EXPORT_SYMBOL(kvm_save_fpu)
one small nit, could EXPORT_SYMBOL_FOR_KVM() be used here compared with 
EXPORT_SYMBOL()?

Regards
Bibo Mao
>   
>   SYM_FUNC_START(kvm_restore_fpu)
>   	fpu_restore_double a0 t1
> @@ -231,6 +241,7 @@ SYM_FUNC_START(kvm_restore_fpu)
>   	fpu_restore_cc	   a0 t1 t2
>   	jr                 ra
>   SYM_FUNC_END(kvm_restore_fpu)
> +EXPORT_SYMBOL(kvm_restore_fpu)
>   
>   #ifdef CONFIG_CPU_HAS_LSX
>   SYM_FUNC_START(kvm_save_lsx)
> @@ -239,6 +250,7 @@ SYM_FUNC_START(kvm_save_lsx)
>   	lsx_save_data   a0 t1
>   	jr              ra
>   SYM_FUNC_END(kvm_save_lsx)
> +EXPORT_SYMBOL(kvm_save_lsx)
>   
>   SYM_FUNC_START(kvm_restore_lsx)
>   	lsx_restore_data a0 t1
> @@ -246,6 +258,7 @@ SYM_FUNC_START(kvm_restore_lsx)
>   	fpu_restore_csr  a0 t1 t2
>   	jr               ra
>   SYM_FUNC_END(kvm_restore_lsx)
> +EXPORT_SYMBOL(kvm_restore_lsx)
>   #endif
>   
>   #ifdef CONFIG_CPU_HAS_LASX
> @@ -255,6 +268,7 @@ SYM_FUNC_START(kvm_save_lasx)
>   	lasx_save_data  a0 t1
>   	jr              ra
>   SYM_FUNC_END(kvm_save_lasx)
> +EXPORT_SYMBOL(kvm_save_lasx)
>   
>   SYM_FUNC_START(kvm_restore_lasx)
>   	lasx_restore_data a0 t1
> @@ -262,10 +276,8 @@ SYM_FUNC_START(kvm_restore_lasx)
>   	fpu_restore_csr   a0 t1 t2
>   	jr                ra
>   SYM_FUNC_END(kvm_restore_lasx)
> +EXPORT_SYMBOL(kvm_restore_lasx)
>   #endif
> -	.section ".rodata"
> -SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
> -SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_guest)
>   
>   #ifdef CONFIG_CPU_HAS_LBT
>   STACK_FRAME_NON_STANDARD kvm_restore_fpu
> 


