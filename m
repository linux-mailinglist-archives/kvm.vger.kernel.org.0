Return-Path: <kvm+bounces-5511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A381F822935
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 09:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BEA81F23A55
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF630182A1;
	Wed,  3 Jan 2024 08:00:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F26B7182A4;
	Wed,  3 Jan 2024 08:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8CxquotFJVlJXgBAA--.4973S3;
	Wed, 03 Jan 2024 16:00:45 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxyr0pFJVl7XAYAA--.44424S3;
	Wed, 03 Jan 2024 16:00:43 +0800 (CST)
Subject: Re: [PATCH 4/5] LoongArch: Add paravirt interface for guest kernel
To: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
 Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240103071615.3422264-1-maobibo@loongson.cn>
 <20240103071615.3422264-5-maobibo@loongson.cn>
 <66c15a1b-fb28-4653-982f-37494a01cd4f@suse.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <4240d67f-1e5d-f865-c16e-32b64aea8099@loongson.cn>
Date: Wed, 3 Jan 2024 16:00:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <66c15a1b-fb28-4653-982f-37494a01cd4f@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Bxyr0pFJVl7XAYAA--.44424S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Gw1xAr1DAF13tFy3Ar4UJrc_yoW3Xw1Dpa
	4kAF4kGay8Crn3ArsrKrW5ury5Jrn7Gw12qF12vFy0yrsFvr1jqr1vgryq9FyUJa1kJ3W0
	qFyrWrsIv3W5J3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C2
	67AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07j1WlkUUUUU=



On 2024/1/3 下午3:40, Jürgen Groß wrote:
> On 03.01.24 08:16, Bibo Mao wrote:
>> The patch add paravirt interface for guest kernel, it checks whether
>> system runs on VM mode. If it is, it will detect hypervisor type. And
>> returns true it is KVM hypervisor, else return false. Currently only
>> KVM hypervisor is supported, so there is only hypervisor detection
>> for KVM type.
> 
> I guess you are talking of pv_guest_init() here? Or do you mean
> kvm_para_available()?
yes, it is pv_guest_init. It will be better if all hypervisor detection
is called in function pv_guest_init. Currently there is only kvm 
hypervisor, kvm_para_available is hard-coded in pv_guest_init here.

I can split file paravirt.c into paravirt.c and kvm.c, paravirt.c is 
used for hypervisor detection, and move code relative with pv_ipi into kvm.c

Regards
Bibo Mao
> 
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/Kconfig                        |  8 ++++
>>   arch/loongarch/include/asm/kvm_para.h         |  7 ++++
>>   arch/loongarch/include/asm/paravirt.h         | 27 ++++++++++++
>>   .../include/asm/paravirt_api_clock.h          |  1 +
>>   arch/loongarch/kernel/Makefile                |  1 +
>>   arch/loongarch/kernel/paravirt.c              | 41 +++++++++++++++++++
>>   arch/loongarch/kernel/setup.c                 |  2 +
>>   7 files changed, 87 insertions(+)
>>   create mode 100644 arch/loongarch/include/asm/paravirt.h
>>   create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
>>   create mode 100644 arch/loongarch/kernel/paravirt.c
>>
>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
>> index ee123820a476..940e5960d297 100644
>> --- a/arch/loongarch/Kconfig
>> +++ b/arch/loongarch/Kconfig
>> @@ -564,6 +564,14 @@ config CPU_HAS_PREFETCH
>>       bool
>>       default y
>> +config PARAVIRT
>> +    bool "Enable paravirtualization code"
>> +    help
>> +          This changes the kernel so it can modify itself when it is run
>> +      under a hypervisor, potentially improving performance 
>> significantly
>> +      over full virtualization.  However, when run without a hypervisor
>> +      the kernel is theoretically slower and slightly larger.
>> +
>>   config ARCH_SUPPORTS_KEXEC
>>       def_bool y
>> diff --git a/arch/loongarch/include/asm/kvm_para.h 
>> b/arch/loongarch/include/asm/kvm_para.h
>> index 9425d3b7e486..41200e922a82 100644
>> --- a/arch/loongarch/include/asm/kvm_para.h
>> +++ b/arch/loongarch/include/asm/kvm_para.h
>> @@ -2,6 +2,13 @@
>>   #ifndef _ASM_LOONGARCH_KVM_PARA_H
>>   #define _ASM_LOONGARCH_KVM_PARA_H
>> +/*
>> + * Hypcall code field
>> + */
>> +#define HYPERVISOR_KVM            1
>> +#define HYPERVISOR_VENDOR_SHIFT        8
>> +#define HYPERCALL_CODE(vendor, code)    ((vendor << 
>> HYPERVISOR_VENDOR_SHIFT) + code)
>> +
>>   /*
>>    * LoongArch hypcall return code
>>    */
>> diff --git a/arch/loongarch/include/asm/paravirt.h 
>> b/arch/loongarch/include/asm/paravirt.h
>> new file mode 100644
>> index 000000000000..b64813592ba0
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
>> +    return static_call(pv_steal_clock)(cpu);
>> +}
>> +
>> +int pv_guest_init(void);
>> +#else
>> +static inline int pv_guest_init(void)
>> +{
>> +    return 0;
>> +}
>> +
>> +#endif // CONFIG_PARAVIRT
>> +#endif
>> diff --git a/arch/loongarch/include/asm/paravirt_api_clock.h 
>> b/arch/loongarch/include/asm/paravirt_api_clock.h
>> new file mode 100644
>> index 000000000000..65ac7cee0dad
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/paravirt_api_clock.h
>> @@ -0,0 +1 @@
>> +#include <asm/paravirt.h>
>> diff --git a/arch/loongarch/kernel/Makefile 
>> b/arch/loongarch/kernel/Makefile
>> index 3c808c680370..662e6e9de12d 100644
>> --- a/arch/loongarch/kernel/Makefile
>> +++ b/arch/loongarch/kernel/Makefile
>> @@ -48,6 +48,7 @@ obj-$(CONFIG_MODULES)        += module.o 
>> module-sections.o
>>   obj-$(CONFIG_STACKTRACE)    += stacktrace.o
>>   obj-$(CONFIG_PROC_FS)        += proc.o
>> +obj-$(CONFIG_PARAVIRT)        += paravirt.o
>>   obj-$(CONFIG_SMP)        += smp.o
>> diff --git a/arch/loongarch/kernel/paravirt.c 
>> b/arch/loongarch/kernel/paravirt.c
>> new file mode 100644
>> index 000000000000..21d01d05791a
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
>> +    return 0;
>> +}
>> +
>> +DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
> 
> This is the 4th arch with the same definition of native_steal_clock() and
> pv_steal_clock. I think we should add a common file kernel/paravirt.c and
> move the related functions from the archs into the new file.
> 
> If you don't want to do that I can prepare a series.
> 
>> +
>> +static bool kvm_para_available(void)
>> +{
>> +    static int hypervisor_type;
>> +    int config;
>> +
>> +    if (!hypervisor_type) {
>> +        config = read_cpucfg(CPUCFG_KVM_SIG);
>> +        if (!memcmp(&config, KVM_SIGNATURE, 4))
>> +            hypervisor_type = HYPERVISOR_KVM;
>> +    }
>> +
>> +    return hypervisor_type == HYPERVISOR_KVM;
>> +}
>> +
>> +int __init pv_guest_init(void)
>> +{
>> +    if (!cpu_has_hypervisor)
>> +        return 0;
>> +    if (!kvm_para_available())
>> +        return 0;
>> +
>> +    return 1;
>> +}
>> diff --git a/arch/loongarch/kernel/setup.c 
>> b/arch/loongarch/kernel/setup.c
>> index d183a745fb85..fa680bdd0bd1 100644
>> --- a/arch/loongarch/kernel/setup.c
>> +++ b/arch/loongarch/kernel/setup.c
>> @@ -43,6 +43,7 @@
>>   #include <asm/efi.h>
>>   #include <asm/loongson.h>
>>   #include <asm/numa.h>
>> +#include <asm/paravirt.h>
>>   #include <asm/pgalloc.h>
>>   #include <asm/sections.h>
>>   #include <asm/setup.h>
>> @@ -376,6 +377,7 @@ void __init platform_init(void)
>>       pr_info("The BIOS Version: %s\n", b_info.bios_version);
>>       efi_runtime_init();
>> +    pv_guest_init();
> 
> Any reason pv_guest_init() needs to return a value at all, seeing that 
> you don't
> use the returned value?
> 
> 
> Juergen


