Return-Path: <kvm+bounces-24563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57439957BDF
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 05:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C5251C23B16
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 03:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A3149626;
	Tue, 20 Aug 2024 03:21:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 194BA2837A;
	Tue, 20 Aug 2024 03:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724124109; cv=none; b=g3GblCLQefGstjBcuoMoGWtEYXTFeFLl/hDO1RMUIb7mizt0B9r885EYBQeYh8fzQmm6tZ+rZgNFUvdP4+6ONG9PVinjUuZQ46WtgSBU3iArJH0wRpmqY5B7dVn/Z9k1NWwkGjMV9aaJn3M5zRbjQVPXHyAh1/Od5PzrXk0jq0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724124109; c=relaxed/simple;
	bh=RK2E2B1bvfzSZk7oARo2aZUhuFKknoWjMv/zW2b0mvY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BjtPb3AFsoXHTFYBeJHseV+Ch1b0GC8BgGZ/f5qhaikqSTuC6k/XTmEu9UBYHQuzzuYZ4rbyTyn9Ua0+0ULSQkCWplothN5+osf0BhsoqR3iMg2qfXdCtpPxj8NK6xNN2ly1F+qncgpHwrTQumsEnWfReK/h+Fe/XSbA0oRiAs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bx7erGC8RmudEZAA--.56432S3;
	Tue, 20 Aug 2024 11:21:42 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMAxz2fDC8Rm2SgbAA--.44611S3;
	Tue, 20 Aug 2024 11:21:41 +0800 (CST)
Subject: Re: [PATCH v6 1/3] LoongArch: KVM: Enable paravirt feature control
 from VMM
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Thomas Gleixner <tglx@linutronix.de>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 x86@kernel.org, Song Gao <gaosong@loongson.cn>
References: <20240812030210.500240-1-maobibo@loongson.cn>
 <20240812030210.500240-2-maobibo@loongson.cn>
 <CAAhV-H4aqu=ZOOb3UAcQt4DQNMcpUd7O=ted+Zka3pV1fjyoMQ@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <522c84a8-f919-612c-3502-9d05db97fe91@loongson.cn>
Date: Tue, 20 Aug 2024 11:21:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4aqu=ZOOb3UAcQt4DQNMcpUd7O=ted+Zka3pV1fjyoMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxz2fDC8Rm2SgbAA--.44611S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3tw4xKF1xKrW8Kr4DGFWUZFc_yoW8XFy8uo
	W3JF1Igw4fWw45CF4DK3s0vayrA340kw4UA3y3A3s3WF17tayUKr1UGw4YqF4aqr1kGrZx
	Ca43W34UZa4xtwn8l-sFpf9Il3svdjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUY47kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zw
	Z7UUUUU==

Huacai,

Thanks for reviewing my patch.
I reply inline.

On 2024/8/19 下午9:32, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Mon, Aug 12, 2024 at 11:02 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Export kernel paravirt features to user space, so that VMM can control
>> the single paravirt feature. By default paravirt features will be the same
>> with kvm supported features if VMM does not set it.
>>
>> Also a new feature KVM_FEATURE_VIRT_EXTIOI is added which can be set from
>> user space. This feature indicates that the virt EXTIOI can route
>> interrupts to 256 vCPUs, rather than 4 vCPUs like with real HW.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_host.h      |  7 ++++
>>   arch/loongarch/include/asm/kvm_para.h      |  1 +
>>   arch/loongarch/include/asm/kvm_vcpu.h      |  4 ++
>>   arch/loongarch/include/asm/loongarch.h     | 13 ------
>>   arch/loongarch/include/uapi/asm/Kbuild     |  2 -
>>   arch/loongarch/include/uapi/asm/kvm.h      |  5 +++
>>   arch/loongarch/include/uapi/asm/kvm_para.h | 24 +++++++++++
>>   arch/loongarch/kernel/paravirt.c           |  8 ++--
>>   arch/loongarch/kvm/exit.c                  | 19 ++++-----
>>   arch/loongarch/kvm/vcpu.c                  | 47 ++++++++++++++++++----
>>   arch/loongarch/kvm/vm.c                    | 43 +++++++++++++++++++-
>>   11 files changed, 137 insertions(+), 36 deletions(-)
>>   create mode 100644 arch/loongarch/include/uapi/asm/kvm_para.h
>>
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> index 5f0677e03817..b73f6678e38a 100644
>> --- a/arch/loongarch/include/asm/kvm_host.h
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -107,6 +107,8 @@ struct kvm_arch {
>>          unsigned int  root_level;
>>          spinlock_t    phyid_map_lock;
>>          struct kvm_phyid_map  *phyid_map;
>> +       /* Enabled PV features */
>> +       unsigned long pv_features;
>>
>>          s64 time_offset;
>>          struct kvm_context __percpu *vmcs;
>> @@ -136,6 +138,11 @@ enum emulation_result {
>>   #define KVM_LARCH_SWCSR_LATEST (0x1 << 3)
>>   #define KVM_LARCH_HWCSR_USABLE (0x1 << 4)
>>
>> +#define LOONGARCH_PV_FEAT_UPDATED              BIT_ULL(63)
>> +#define LOONGARCH_PV_FEAT_MASK                                         \
>> +               (BIT(KVM_FEATURE_IPI) | BIT(KVM_FEATURE_STEAL_TIME) |   \
>> +                BIT(KVM_FEATURE_VIRT_EXTIOI))
>> +
>>   struct kvm_vcpu_arch {
>>          /*
>>           * Switch pointer-to-function type to unsigned long
>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>> index 43ec61589e6c..39d7483ab8fd 100644
>> --- a/arch/loongarch/include/asm/kvm_para.h
>> +++ b/arch/loongarch/include/asm/kvm_para.h
>> @@ -2,6 +2,7 @@
>>   #ifndef _ASM_LOONGARCH_KVM_PARA_H
>>   #define _ASM_LOONGARCH_KVM_PARA_H
>>
>> +#include <uapi/asm/kvm_para.h>
>>   /*
>>    * Hypercall code field
>>    */
>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
>> index c416cb7125c0..a1fc24a48fd1 100644
>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
>> @@ -125,4 +125,8 @@ static inline bool kvm_pvtime_supported(void)
>>          return !!sched_info_on();
>>   }
>>
>> +static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu, unsigned int feature)
>> +{
>> +       return vcpu->kvm->arch.pv_features & BIT(feature);
>> +}
> We have similar functions
> kvm_guest_has_fpu/kvm_guest_has_lsx/kvm_guest_has_lasx, so maybe it is
> better to rename it as kvm_guest_has_pv_feature().
Sure, will do. kvm_guest_has_pv_feature() is better than guest_pv_has().

> 
>>   #endif /* __ASM_LOONGARCH_KVM_VCPU_H__ */
>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
>> index 04a78010fc72..eb82230f52c3 100644
>> --- a/arch/loongarch/include/asm/loongarch.h
>> +++ b/arch/loongarch/include/asm/loongarch.h
>> @@ -158,19 +158,6 @@
>>   #define  CPUCFG48_VFPU_CG              BIT(2)
>>   #define  CPUCFG48_RAM_CG               BIT(3)
>>
>> -/*
>> - * CPUCFG index area: 0x40000000 -- 0x400000ff
>> - * SW emulation for KVM hypervirsor
>> - */
>> -#define CPUCFG_KVM_BASE                        0x40000000
>> -#define CPUCFG_KVM_SIZE                        0x100
>> -
>> -#define CPUCFG_KVM_SIG                 (CPUCFG_KVM_BASE + 0)
>> -#define  KVM_SIGNATURE                 "KVM\0"
>> -#define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
>> -#define  KVM_FEATURE_IPI               BIT(1)
>> -#define  KVM_FEATURE_STEAL_TIME                BIT(2)
> It is a little better to keep these definitions here (at least
> convenient for grep).
These macro definitions are moved and exported in uapi file 
uapi/asm/kvm_para.h, so that user mode VMM can use it and disable or 
enable specific PV feature. So we need move it to uapi file.

Regards
Bibo Mao
> 
> 
> 
> Huacai
> 
>> -
>>   #ifndef __ASSEMBLY__
>>
>>   /* CSR */
>> diff --git a/arch/loongarch/include/uapi/asm/Kbuild b/arch/loongarch/include/uapi/asm/Kbuild
>> index c6d141d7b7d7..517761419999 100644
>> --- a/arch/loongarch/include/uapi/asm/Kbuild
>> +++ b/arch/loongarch/include/uapi/asm/Kbuild
>> @@ -1,4 +1,2 @@
>>   # SPDX-License-Identifier: GPL-2.0
>>   syscall-y += unistd_64.h
>> -
>> -generic-y += kvm_para.h
>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>> index ddc5cab0ffd0..719490e64e1c 100644
>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>> @@ -82,6 +82,11 @@ struct kvm_fpu {
>>   #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
>>   #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
>>
>> +/* Device Control API on vm fd */
>> +#define KVM_LOONGARCH_VM_FEAT_CTRL             0
>> +#define  KVM_LOONGARCH_VM_FEAT_PV_IPI          5
>> +#define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME    6
>> +
>>   /* Device Control API on vcpu fd */
>>   #define KVM_LOONGARCH_VCPU_CPUCFG      0
>>   #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
>> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/include/uapi/asm/kvm_para.h
>> new file mode 100644
>> index 000000000000..5dfe675709ab
>> --- /dev/null
>> +++ b/arch/loongarch/include/
>> @@ -0,0 +1,24 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +#ifndef _UAPI_ASM_KVM_PARA_H
>> +#define _UAPI_ASM_KVM_PARA_H
>> +
>> +#include <linux/types.h>
>> +
>> +/*
>> + * CPUCFG index area: 0x40000000 -- 0x400000ff
>> + * SW emulation for KVM hypervirsor
>> + */
>> +#define CPUCFG_KVM_BASE                        0x40000000
>> +#define CPUCFG_KVM_SIZE                        0x100
>> +#define CPUCFG_KVM_SIG                 (CPUCFG_KVM_BASE + 0)
>> +#define  KVM_SIGNATURE                 "KVM\0"
>> +#define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
>> +#define  KVM_FEATURE_IPI               1
>> +#define  KVM_FEATURE_STEAL_TIME                2
>> +/*
>> + * BIT 24 - 31 is features configurable by user space vmm
>> + * With VIRT_EXTIOI feature, interrupt can route to 256 VCPUs
>> + */
>> +#define  KVM_FEATURE_VIRT_EXTIOI       24
>> +
>> +#endif /* _UAPI_ASM_KVM_PARA_H */
>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
>> index 9c9b75b76f62..cc6bf096cb88 100644
>> --- a/arch/loongarch/kernel/paravirt.c
>> +++ b/arch/loongarch/kernel/paravirt.c
>> @@ -175,7 +175,7 @@ int __init pv_ipi_init(void)
>>                  return 0;
>>
>>          feature = read_cpucfg(CPUCFG_KVM_FEATURE);
>> -       if (!(feature & KVM_FEATURE_IPI))
>> +       if (!(feature & BIT(KVM_FEATURE_IPI)))
>>                  return 0;
>>
>>   #ifdef CONFIG_SMP
>> @@ -206,7 +206,7 @@ static int pv_enable_steal_time(void)
>>          }
>>
>>          addr |= KVM_STEAL_PHYS_VALID;
>> -       kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_TIME, addr);
>> +       kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, BIT(KVM_FEATURE_STEAL_TIME), addr);
>>
>>          return 0;
>>   }
>> @@ -214,7 +214,7 @@ static int pv_enable_steal_time(void)
>>   static void pv_disable_steal_time(void)
>>   {
>>          if (has_steal_clock)
>> -               kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_TIME, 0);
>> +               kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, BIT(KVM_FEATURE_STEAL_TIME), 0);
>>   }
>>
>>   #ifdef CONFIG_SMP
>> @@ -266,7 +266,7 @@ int __init pv_time_init(void)
>>                  return 0;
>>
>>          feature = read_cpucfg(CPUCFG_KVM_FEATURE);
>> -       if (!(feature & KVM_FEATURE_STEAL_TIME))
>> +       if (!(feature & BIT(KVM_FEATURE_STEAL_TIME)))
>>                  return 0;
>>
>>          has_steal_clock = 1;
>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>> index ea73f9dc2cc6..54f78864a617 100644
>> --- a/arch/loongarch/kvm/exit.c
>> +++ b/arch/loongarch/kvm/exit.c
>> @@ -50,9 +50,7 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
>>                  vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
>>                  break;
>>          case CPUCFG_KVM_FEATURE:
>> -               ret = KVM_FEATURE_IPI;
>> -               if (kvm_pvtime_supported())
>> -                       ret |= KVM_FEATURE_STEAL_TIME;
>> +               ret = vcpu->kvm->arch.pv_features & LOONGARCH_PV_FEAT_MASK;
>>                  vcpu->arch.gprs[rd] = ret;
>>                  break;
>>          default:
>> @@ -697,8 +695,8 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
>>          id   = kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
>>          data = kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
>>          switch (id) {
>> -       case KVM_FEATURE_STEAL_TIME:
>> -               if (!kvm_pvtime_supported())
>> +       case BIT(KVM_FEATURE_STEAL_TIME):
>> +               if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
>>                          return KVM_HCALL_INVALID_CODE;
>>
>>                  if (data & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VALID))
>> @@ -712,10 +710,10 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
>>                  kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>>                  break;
>>          default:
>> -               break;
>> +               return KVM_HCALL_INVALID_CODE;
>>          };
>>
>> -       return 0;
>> +       return KVM_HCALL_INVALID_CODE;
>>   };
>>
>>   /*
>> @@ -786,8 +784,11 @@ static void kvm_handle_service(struct kvm_vcpu *vcpu)
>>
>>          switch (func) {
>>          case KVM_HCALL_FUNC_IPI:
>> -               kvm_send_pv_ipi(vcpu);
>> -               ret = KVM_HCALL_SUCCESS;
>> +               if (guest_pv_has(vcpu, KVM_FEATURE_IPI)) {
>> +                       kvm_send_pv_ipi(vcpu);
>> +                       ret = KVM_HCALL_SUCCESS;
>> +               } else
>> +                       ret = KVM_HCALL_INVALID_CODE;
>>                  break;
>>          case KVM_HCALL_FUNC_NOTIFY:
>>                  ret = kvm_save_notify(vcpu);
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 16756ffb55e8..2a7d7f91facd 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -730,6 +730,8 @@ static int kvm_loongarch_cpucfg_has_attr(struct kvm_vcpu *vcpu,
>>          switch (attr->attr) {
>>          case 2:
>>                  return 0;
>> +       case CPUCFG_KVM_FEATURE:
>> +               return 0;
>>          default:
>>                  return -ENXIO;
>>          }
>> @@ -740,7 +742,7 @@ static int kvm_loongarch_cpucfg_has_attr(struct kvm_vcpu *vcpu,
>>   static int kvm_loongarch_pvtime_has_attr(struct kvm_vcpu *vcpu,
>>                                           struct kvm_device_attr *attr)
>>   {
>> -       if (!kvm_pvtime_supported() ||
>> +       if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME) ||
>>                          attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
>>                  return -ENXIO;
>>
>> @@ -773,9 +775,18 @@ static int kvm_loongarch_cpucfg_get_attr(struct kvm_vcpu *vcpu,
>>          uint64_t val;
>>          uint64_t __user *uaddr = (uint64_t __user *)attr->addr;
>>
>> -       ret = _kvm_get_cpucfg_mask(attr->attr, &val);
>> -       if (ret)
>> -               return ret;
>> +       switch (attr->attr) {
>> +       case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
>> +               ret = _kvm_get_cpucfg_mask(attr->attr, &val);
>> +               if (ret)
>> +                       return ret;
>> +               break;
>> +       case CPUCFG_KVM_FEATURE:
>> +               val = vcpu->kvm->arch.pv_features & LOONGARCH_PV_FEAT_MASK;
>> +               break;
>> +       default:
>> +               return -ENXIO;
>> +       }
>>
>>          put_user(val, uaddr);
>>
>> @@ -788,7 +799,7 @@ static int kvm_loongarch_pvtime_get_attr(struct kvm_vcpu *vcpu,
>>          u64 gpa;
>>          u64 __user *user = (u64 __user *)attr->addr;
>>
>> -       if (!kvm_pvtime_supported() ||
>> +       if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME) ||
>>                          attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
>>                  return -ENXIO;
>>
>> @@ -821,7 +832,29 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
>>   static int kvm_loongarch_cpucfg_set_attr(struct kvm_vcpu *vcpu,
>>                                           struct kvm_device_attr *attr)
>>   {
>> -       return -ENXIO;
>> +       u64 __user *user = (u64 __user *)attr->addr;
>> +       u64 val, valid;
>> +       struct kvm *kvm = vcpu->kvm;
>> +
>> +       switch (attr->attr) {
>> +       case CPUCFG_KVM_FEATURE:
>> +               if (get_user(val, user))
>> +                       return -EFAULT;
>> +
>> +               valid = LOONGARCH_PV_FEAT_MASK;
>> +               if (val & ~valid)
>> +                       return -EINVAL;
>> +
>> +               /* All vCPUs need set the same pv features */
>> +               if ((kvm->arch.pv_features & LOONGARCH_PV_FEAT_UPDATED) &&
>> +                               ((kvm->arch.pv_features & valid) != val))
>> +                       return -EINVAL;
>> +               kvm->arch.pv_features = val | LOONGARCH_PV_FEAT_UPDATED;
>> +               return 0;
>> +
>> +       default:
>> +               return -ENXIO;
>> +       }
>>   }
>>
>>   static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
>> @@ -831,7 +864,7 @@ static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
>>          u64 gpa, __user *user = (u64 __user *)attr->addr;
>>          struct kvm *kvm = vcpu->kvm;
>>
>> -       if (!kvm_pvtime_supported() ||
>> +       if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME) ||
>>                          attr->attr != KVM_LOONGARCH_VCPU_PVTIME_GPA)
>>                  return -ENXIO;
>>
>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>> index 6b2e4f66ad26..3234f3e85dc0 100644
>> --- a/arch/loongarch/kvm/vm.c
>> +++ b/arch/loongarch/kvm/vm.c
>> @@ -5,6 +5,7 @@
>>
>>   #include <linux/kvm_host.h>
>>   #include <asm/kvm_mmu.h>
>> +#include <asm/kvm_vcpu.h>
>>
>>   const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>>          KVM_GENERIC_VM_STATS(),
>> @@ -39,6 +40,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>          spin_lock_init(&kvm->arch.phyid_map_lock);
>>
>>          kvm_init_vmcs(kvm);
>> +       /* Enable all pv features by default */
>> +       kvm->arch.pv_features = BIT(KVM_FEATURE_IPI);
>> +       if (kvm_pvtime_supported())
>> +               kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
>>          kvm->arch.gpa_size = BIT(cpu_vabits - 1);
>>          kvm->arch.root_level = CONFIG_PGTABLE_LEVELS - 1;
>>          kvm->arch.invalid_ptes[0] = 0;
>> @@ -99,7 +104,43 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>          return r;
>>   }
>>
>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +       switch (attr->attr) {
>> +       case KVM_LOONGARCH_VM_FEAT_PV_IPI:
>> +               return 0;
>> +       case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
>> +               if (kvm_pvtime_supported())
>> +                       return 0;
>> +               return -ENXIO;
>> +       default:
>> +               return -ENXIO;
>> +       }
>> +}
>> +
>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +       switch (attr->group) {
>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
>> +               return kvm_vm_feature_has_attr(kvm, attr);
>> +       default:
>> +               return -ENXIO;
>> +       }
>> +}
>> +
>>   int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>   {
>> -       return -ENOIOCTLCMD;
>> +       struct kvm *kvm = filp->private_data;
>> +       void __user *argp = (void __user *)arg;
>> +       struct kvm_device_attr attr;
>> +
>> +       switch (ioctl) {
>> +       case KVM_HAS_DEVICE_ATTR:
>> +               if (copy_from_user(&attr, argp, sizeof(attr)))
>> +                       return -EFAULT;
>> +
>> +               return kvm_vm_has_attr(kvm, &attr);
>> +       default:
>> +               return -EINVAL;
>> +       }
>>   }
>> --
>> 2.39.3
>>
>>


