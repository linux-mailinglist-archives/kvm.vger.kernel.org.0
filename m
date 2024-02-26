Return-Path: <kvm+bounces-9611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C2286682A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 03:27:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6C631F214B7
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 02:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6ADFBEF;
	Mon, 26 Feb 2024 02:27:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AEBCDDDC;
	Mon, 26 Feb 2024 02:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708914469; cv=none; b=hxzlR97gCsyOf7VtGNSlZJUKnAXxNXpFT+HRXm+I4B86LTKGVYK9pe0gPi6JaUBXIMMVOH9fR0OeG80CPRTQ+m5g/WNmU8FKIdG1t0jSYDJusP1Mv5WsEVdAnEwOh4TpjsM6185OycbAI5cq0GQqfnVtfz0kr0r7x8tei6C32Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708914469; c=relaxed/simple;
	bh=3BPVpZmd3r2/6e9QRzJoUxZLCVM8tqHO5vRHJrJNW7c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cmVCzmSDDUvfSQlbRoMdTzk2CqtGO3G+wbcrytePcYZRFJGvdONFMsEvWjbS5V0QMqzyISDxwFT2jk7zUYv2nwkMM09Rx2mb61ry8ZkLbMDMUoHE5APH2Zn0fqach6onjRQ6VkvuUChGT2qUuon4ONiNTX7q3q9iAVk2FRtQO4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Dx6ugf99tlfWgRAA--.24810S3;
	Mon, 26 Feb 2024 10:27:43 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxRMwa99tlniVEAA--.39424S3;
	Mon, 26 Feb 2024 10:27:40 +0800 (CST)
Subject: Re: [PATCH v5 4/6] LoongArch: Add paravirt interface for guest kernel
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240222032803.2177856-1-maobibo@loongson.cn>
 <20240222032803.2177856-5-maobibo@loongson.cn>
 <CAAhV-H4FiP+msu4heG00Hw89Wy3oeJd5rJ7+twhwVqph_tO4Mw@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <6bf79c0f-daf3-9077-e83f-38bcfd7282e3@loongson.cn>
Date: Mon, 26 Feb 2024 10:27:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4FiP+msu4heG00Hw89Wy3oeJd5rJ7+twhwVqph_tO4Mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxRMwa99tlniVEAA--.39424S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKF15Gr13uF45Kr48Gw1kCrX_yoWxWr13pa
	4DAF4kGa18GryxAr9IqrZxurn8J397Gr129Fy2va4FyFZFvr1UJr1vgryq9Fykta1kJ3W0
	gFyrWw1a9a15tagCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0b6pPUUUU
	U==



On 2024/2/24 下午5:15, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Thu, Feb 22, 2024 at 11:28 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Paravirt interface pv_ipi_init() is added here for guest kernel, it
>> firstly checks whether system runs on VM mode. If kernel runs on VM mode,
>> it will call function kvm_para_available() to detect current VMM type.
>> Now only KVM VMM type is detected,the paravirt function can work only if
>> current VMM is KVM hypervisor, since there is only KVM hypervisor
>> supported on LoongArch now.
>>
>> There is not effective with pv_ipi_init() now, it is dummy function.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/Kconfig                        |  9 ++++
>>   arch/loongarch/include/asm/kvm_para.h         |  7 ++++
>>   arch/loongarch/include/asm/paravirt.h         | 27 ++++++++++++
>>   .../include/asm/paravirt_api_clock.h          |  1 +
>>   arch/loongarch/kernel/Makefile                |  1 +
>>   arch/loongarch/kernel/paravirt.c              | 41 +++++++++++++++++++
>>   arch/loongarch/kernel/setup.c                 |  1 +
>>   7 files changed, 87 insertions(+)
>>   create mode 100644 arch/loongarch/include/asm/paravirt.h
>>   create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
>>   create mode 100644 arch/loongarch/kernel/paravirt.c
>>
>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
>> index 929f68926b34..fdaae9a0435c 100644
>> --- a/arch/loongarch/Kconfig
>> +++ b/arch/loongarch/Kconfig
>> @@ -587,6 +587,15 @@ config CPU_HAS_PREFETCH
>>          bool
>>          default y
>>
>> +config PARAVIRT
>> +       bool "Enable paravirtualization code"
>> +       depends on AS_HAS_LVZ_EXTENSION
>> +       help
>> +          This changes the kernel so it can modify itself when it is run
>> +         under a hypervisor, potentially improving performance significantly
>> +         over full virtualization.  However, when run without a hypervisor
>> +         the kernel is theoretically slower and slightly larger.
>> +
>>   config ARCH_SUPPORTS_KEXEC
>>          def_bool y
>>
>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>> index d48f993ae206..af5d677a9052 100644
>> --- a/arch/loongarch/include/asm/kvm_para.h
>> +++ b/arch/loongarch/include/asm/kvm_para.h
>> @@ -2,6 +2,13 @@
>>   #ifndef _ASM_LOONGARCH_KVM_PARA_H
>>   #define _ASM_LOONGARCH_KVM_PARA_H
>>
>> +/*
>> + * Hypercall code field
>> + */
>> +#define HYPERVISOR_KVM                 1
>> +#define HYPERVISOR_VENDOR_SHIFT                8
>> +#define HYPERCALL_CODE(vendor, code)   ((vendor << HYPERVISOR_VENDOR_SHIFT) + code)
>> +
>>   /*
>>    * LoongArch hypercall return code
>>    */
>> diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/include/asm/paravirt.h
>> new file mode 100644
>> index 000000000000..58f7b7b89f2c
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/paravirt.h
>> @@ -0,0 +1,27 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _ASM_LOONGARCH_PARAVIRT_H
>> +#define _ASM_LOONGARCH_PARAVIRT_H
>> +
>> +#ifdef CONFIG_PARAVIRT
>> +#include <linux/static_call_types.h>
>> +struct static_key;
>> +extern struct static_key paravirt_steal_enabled;
>> +extern struct static_key paravirt_steal_rq_enabled;
>> +
>> +u64 dummy_steal_clock(int cpu);
>> +DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
>> +
>> +static inline u64 paravirt_steal_clock(int cpu)
>> +{
>> +       return static_call(pv_steal_clock)(cpu);
>> +}
>> +
>> +int pv_ipi_init(void);
>> +#else
>> +static inline int pv_ipi_init(void)
>> +{
>> +       return 0;
>> +}
>> +
>> +#endif // CONFIG_PARAVIRT
>> +#endif
>> diff --git a/arch/loongarch/include/asm/paravirt_api_clock.h b/arch/loongarch/include/asm/paravirt_api_clock.h
>> new file mode 100644
>> index 000000000000..65ac7cee0dad
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/paravirt_api_clock.h
>> @@ -0,0 +1 @@
>> +#include <asm/paravirt.h>
>> diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/Makefile
>> index 3c808c680370..662e6e9de12d 100644
>> --- a/arch/loongarch/kernel/Makefile
>> +++ b/arch/loongarch/kernel/Makefile
>> @@ -48,6 +48,7 @@ obj-$(CONFIG_MODULES)         += module.o module-sections.o
>>   obj-$(CONFIG_STACKTRACE)       += stacktrace.o
>>
>>   obj-$(CONFIG_PROC_FS)          += proc.o
>> +obj-$(CONFIG_PARAVIRT)         += paravirt.o
>>
>>   obj-$(CONFIG_SMP)              += smp.o
>>
>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
>> new file mode 100644
>> index 000000000000..5cf794e8490f
>> --- /dev/null
>> +++ b/arch/loongarch/kernel/paravirt.c
>> @@ -0,0 +1,41 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <linux/export.h>
>> +#include <linux/types.h>
>> +#include <linux/jump_label.h>
>> +#include <linux/kvm_para.h>
>> +#include <asm/paravirt.h>
>> +#include <linux/static_call.h>
>> +
>> +struct static_key paravirt_steal_enabled;
>> +struct static_key paravirt_steal_rq_enabled;
>> +
>> +static u64 native_steal_clock(int cpu)
>> +{
>> +       return 0;
>> +}
>> +
>> +DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
>> +
>> +static bool kvm_para_available(void)
>> +{
>> +       static int hypervisor_type;
>> +       int config;
>> +
>> +       if (!hypervisor_type) {
>> +               config = read_cpucfg(CPUCFG_KVM_SIG);
>> +               if (!memcmp(&config, KVM_SIGNATURE, 4))
>> +                       hypervisor_type = HYPERVISOR_KVM;
>> +       }
>> +
>> +       return hypervisor_type == HYPERVISOR_KVM;
>> +}
>> +
>> +int __init pv_ipi_init(void)
>> +{
>> +       if (!cpu_has_hypervisor)
>> +               return 0;
>> +       if (!kvm_para_available())
>> +               return 0;
>> +
>> +       return 1;
>> +}
> pv_ipi_init() and its declaration should also be moved to the last
> patch. And if you think this patch is too small, you can squash the
> whole patch to the last one.
I can move the whole patch to the last one. I do not think that is is 
reasonable to move function pv_ipi_init() to the last patch.

Regards
Bibo Mao

> 
> Huacai
> 
>> diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
>> index edf2bba80130..b79a1244b56f 100644
>> --- a/arch/loongarch/kernel/setup.c
>> +++ b/arch/loongarch/kernel/setup.c
>> @@ -43,6 +43,7 @@
>>   #include <asm/efi.h>
>>   #include <asm/loongson.h>
>>   #include <asm/numa.h>
>> +#include <asm/paravirt.h>
>>   #include <asm/pgalloc.h>
>>   #include <asm/sections.h>
>>   #include <asm/setup.h>
>> --
>> 2.39.3
>>


