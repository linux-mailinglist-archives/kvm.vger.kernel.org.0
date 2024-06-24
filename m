Return-Path: <kvm+bounces-20350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C89914034
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 03:51:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA8791F22269
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 01:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E6E46BA;
	Mon, 24 Jun 2024 01:51:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF072F25;
	Mon, 24 Jun 2024 01:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719193906; cv=none; b=MWqgyVZPWLpTHHXGy8wTK3K7Eijr+GYwWi2sk6rDT8ZUoI9TdoyzOCNOCZhumb1ENHSJeb72/jUOQTS0P1nPnGthPOzp+vgOiTsgZCvVV1gnmXlHTl/Yx/+XqfVxoQKfdMxVpfsCjTTdQKiD99pESkKCbAw5HbP7wTfSZLZteJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719193906; c=relaxed/simple;
	bh=PQ2IbqwcqM3pMAq6Bs5okC9IkAguM7k3PjD+tCo2r9A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NcMPq9iBiP3lJFpm6aydNliCLZ2QtY3Iyrd2E0kd82sXUCsx0rD0y4ozemHUfbIFr6fUI7BNOxeBvaIu25lRgx4f7Om6Ut4l6DLZy04fNhzAEdZmp1bU11yBvO7lzzjHtco6gN0MjDpCCay/eSGnL1quJTA1DmaJLqY8o0CU6FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxyOks0XhmN2QJAA--.24908S3;
	Mon, 24 Jun 2024 09:51:40 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxJMUp0XhmGosuAA--.34956S3;
	Mon, 24 Jun 2024 09:51:39 +0800 (CST)
Subject: Re: [PATCH v3 1/4] LoongArch: KVM: Add HW Binary Translation
 extension support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240527074644.836699-1-maobibo@loongson.cn>
 <20240527074644.836699-2-maobibo@loongson.cn>
 <CAAhV-H6VpRzxAvVVifoXXHGK=46R4uO+Jp2aSbzsW-Gr0QPfHQ@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <fe5a1710-de61-79c0-5186-9717236207a8@loongson.cn>
Date: Mon, 24 Jun 2024 09:51:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6VpRzxAvVVifoXXHGK=46R4uO+Jp2aSbzsW-Gr0QPfHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxJMUp0XhmGosuAA--.34956S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3JF4xXr15ZF1fKFyfKF1fXwc_yoW3XF48pF
	97CFn5ua1rWFy7K3ZFqrn0grn0vrWkKr1IvFy7Kay5J3WqqryrJF4kKrZ8uFyUAw1FvF1S
	vFyftw13uF48t3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AK
	xVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jY38nU
	UUUU=



On 2024/6/23 下午6:11, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Mon, May 27, 2024 at 3:46 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Loongson Binary Translation (LBT) is used to accelerate binary translation,
>> which contains 4 scratch registers (scr0 to scr3), x86/ARM eflags (eflags)
>> and x87 fpu stack pointer (ftop).
>>
>> Like FPU extension, here late enabling method is used for LBT. LBT context
>> is saved/restored on vcpu context switch path.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_host.h |  8 ++++
>>   arch/loongarch/include/asm/kvm_vcpu.h | 10 +++++
>>   arch/loongarch/kvm/exit.c             |  9 ++++
>>   arch/loongarch/kvm/vcpu.c             | 59 ++++++++++++++++++++++++++-
>>   4 files changed, 85 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> index 2eb2f7572023..88023ab59486 100644
>> --- a/arch/loongarch/include/asm/kvm_host.h
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -133,6 +133,7 @@ enum emulation_result {
>>   #define KVM_LARCH_LASX         (0x1 << 2)
>>   #define KVM_LARCH_SWCSR_LATEST (0x1 << 3)
>>   #define KVM_LARCH_HWCSR_USABLE (0x1 << 4)
>> +#define KVM_LARCH_LBT          (0x1 << 5)
>>
>>   struct kvm_vcpu_arch {
>>          /*
>> @@ -166,6 +167,7 @@ struct kvm_vcpu_arch {
>>
>>          /* FPU state */
>>          struct loongarch_fpu fpu FPU_ALIGN;
>> +       struct loongarch_lbt lbt;
>>
>>          /* CSR state */
>>          struct loongarch_csrs *csr;
>> @@ -235,6 +237,12 @@ static inline bool kvm_guest_has_lasx(struct kvm_vcpu_arch *arch)
>>          return arch->cpucfg[2] & CPUCFG2_LASX;
>>   }
>>
>> +static inline bool kvm_guest_has_lbt(struct kvm_vcpu_arch *arch)
>> +{
>> +       return arch->cpucfg[2] & (CPUCFG2_X86BT | CPUCFG2_ARMBT
>> +                                       | CPUCFG2_MIPSBT);
>> +}
>> +
>>   /* Debug: dump vcpu state */
>>   int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
>>
>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
>> index d7e51300a89f..ec46009be29b 100644
>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
>> @@ -75,6 +75,16 @@ static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
>>   static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
>>   #endif
>>
>> +#ifdef CONFIG_CPU_HAS_LBT
>> +int kvm_own_lbt(struct kvm_vcpu *vcpu);
>> +#else
>> +static inline int kvm_own_lbt(struct kvm_vcpu *vcpu) { return -EINVAL; }
>> +static inline void kvm_lose_lbt(struct kvm_vcpu *vcpu) { }
>> +static inline void kvm_enable_lbt_fpu(struct kvm_vcpu *vcpu,
>> +                                       unsigned long fcsr) { }
>> +static inline void kvm_check_fcsr(struct kvm_vcpu *vcpu) { }
>> +#endif
> It is better to keep symmetry here. That means also declare
> kvm_lose_lbt for CONFIG_CPU_HAS_LBT, and move the last two functions
> to .c because they are static.
Sure, will do in this way in next version.

Regards
Bibo Mao
> 
>> +
>>   void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
>>   void kvm_reset_timer(struct kvm_vcpu *vcpu);
>>   void kvm_save_timer(struct kvm_vcpu *vcpu);
>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>> index e2abd97fb13f..e1bd81d27fd8 100644
>> --- a/arch/loongarch/kvm/exit.c
>> +++ b/arch/loongarch/kvm/exit.c
>> @@ -835,6 +835,14 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
>>          return ret;
>>   }
>>
>> +static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu)
>> +{
>> +       if (kvm_own_lbt(vcpu))
>> +               kvm_queue_exception(vcpu, EXCCODE_INE, 0);
>> +
>> +       return RESUME_GUEST;
>> +}
>> +
>>   /*
>>    * LoongArch KVM callback handling for unimplemented guest exiting
>>    */
>> @@ -867,6 +875,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
>>          [EXCCODE_LASXDIS]               = kvm_handle_lasx_disabled,
>>          [EXCCODE_GSPR]                  = kvm_handle_gspr,
>>          [EXCCODE_HVC]                   = kvm_handle_hypercall,
>> +       [EXCCODE_BTDIS]                 = kvm_handle_lbt_disabled,
>>   };
>>
>>   int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 382796f1d3e6..8f80d1a2dcbb 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -6,6 +6,7 @@
>>   #include <linux/kvm_host.h>
>>   #include <linux/entry-kvm.h>
>>   #include <asm/fpu.h>
>> +#include <asm/lbt.h>
>>   #include <asm/loongarch.h>
>>   #include <asm/setup.h>
>>   #include <asm/time.h>
>> @@ -952,12 +953,64 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>>          return 0;
>>   }
>>
>> +#ifdef CONFIG_CPU_HAS_LBT
>> +int kvm_own_lbt(struct kvm_vcpu *vcpu)
>> +{
>> +       if (!kvm_guest_has_lbt(&vcpu->arch))
>> +               return -EINVAL;
>> +
>> +       preempt_disable();
>> +       set_csr_euen(CSR_EUEN_LBTEN);
>> +
>> +       _restore_lbt(&vcpu->arch.lbt);
>> +       vcpu->arch.aux_inuse |= KVM_LARCH_LBT;
>> +       preempt_enable();
>> +       return 0;
>> +}
>> +
>> +static void kvm_lose_lbt(struct kvm_vcpu *vcpu)
>> +{
>> +       preempt_disable();
>> +       if (vcpu->arch.aux_inuse & KVM_LARCH_LBT) {
>> +               _save_lbt(&vcpu->arch.lbt);
>> +               clear_csr_euen(CSR_EUEN_LBTEN);
>> +               vcpu->arch.aux_inuse &= ~KVM_LARCH_LBT;
>> +       }
>> +       preempt_enable();
>> +}
>> +
>> +static void kvm_enable_lbt_fpu(struct kvm_vcpu *vcpu, unsigned long fcsr)
> It is better to rename it to kvm_own_lbt_tm().
> 
>> +{
>> +       /*
>> +        * if TM is enabled, top register save/restore will
>> +        * cause lbt exception, here enable lbt in advance
>> +        */
>> +       if (fcsr & FPU_CSR_TM)
>> +               kvm_own_lbt(vcpu);
>> +}
>> +
>> +static void kvm_check_fcsr(struct kvm_vcpu *vcpu)
>> +{
>> +       unsigned long fcsr;
>> +
>> +       if (vcpu->arch.aux_inuse & KVM_LARCH_FPU)
>> +               if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
> The condition can be simplified " if (vcpu->arch.aux_inuse &
> (KVM_LARCH_FPU|KVM_LARCH_LBT) == KVM_LARCH_FPU)"
> 
>> +                       fcsr = read_fcsr(LOONGARCH_FCSR0);
>> +                       kvm_enable_lbt_fpu(vcpu, fcsr);
>> +               }
>> +}
>> +#endif
>> +
>>   /* Enable FPU and restore context */
>>   void kvm_own_fpu(struct kvm_vcpu *vcpu)
>>   {
>>          preempt_disable();
>>
>> -       /* Enable FPU */
>> +       /*
>> +        * Enable FPU for guest
>> +        * We set FR and FRE according to guest context
>> +        */
>> +       kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
>>          set_csr_euen(CSR_EUEN_FPEN);
>>
>>          kvm_restore_fpu(&vcpu->arch.fpu);
>> @@ -977,6 +1030,7 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
>>          preempt_disable();
>>
>>          /* Enable LSX for guest */
>> +       kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
>>          set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
>>          switch (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
>>          case KVM_LARCH_FPU:
>> @@ -1011,6 +1065,7 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
>>
>>          preempt_disable();
>>
>> +       kvm_enable_lbt_fpu(vcpu, vcpu->arch.fpu.fcsr);
>>          set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
>>          switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
>>          case KVM_LARCH_LSX:
>> @@ -1042,6 +1097,7 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
>>   {
>>          preempt_disable();
>>
>> +       kvm_check_fcsr(vcpu);
>>          if (vcpu->arch.aux_inuse & KVM_LARCH_LASX) {
>>                  kvm_save_lasx(&vcpu->arch.fpu);
>>                  vcpu->arch.aux_inuse &= ~(KVM_LARCH_LSX | KVM_LARCH_FPU | KVM_LARCH_LASX);
>> @@ -1064,6 +1120,7 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
>>                  /* Disable FPU */
>>                  clear_csr_euen(CSR_EUEN_FPEN);
>>          }
>> +       kvm_lose_lbt(vcpu);
>>
>>          preempt_enable();
>>   }
>> --
>> 2.39.3
>>


