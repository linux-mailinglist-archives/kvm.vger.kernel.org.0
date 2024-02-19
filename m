Return-Path: <kvm+bounces-9065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BFA859F8D
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:21:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C03B284721
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4EA022F1E;
	Mon, 19 Feb 2024 09:21:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C28E22F00;
	Mon, 19 Feb 2024 09:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334480; cv=none; b=l8mrdujFZ82BMfAHLMsyhmEZ8ugWQ7uQWe+Y/xwqB/FQvKZZzqqHJ5PgK9bfXeyrW3T/jkl5otiWu6SFjuEX1ahg2UW5Ky96lzkb+3wuBGYDUdfv+zFiNid/fLG8q5egmS6i0WfqqSvFGPpV7j91xwNgVH4b+MgsEFmj1xLWH4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334480; c=relaxed/simple;
	bh=1x9WusD5W5xRgz8XHGTSX8YHleR1EtqPX6p44zrthwY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fU2RAH8SMH6vaIWHm6I18XuV6qtyf5OTtP+0jEeXmC16lJA8JfZ9pmg1KZ8h4fDNKerM7A3Ik9WTgBZ7f5hCp37ffL3dbV8H5dEz+VA3gSO78q6emfk1bbqLd6jGYoWFXRJeU0+1X3ojv2eirCJQHOLCXzkqfzZ51hmCecFGXhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8AxeeiJHdNlREsOAA--.18770S3;
	Mon, 19 Feb 2024 17:21:13 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxX8+FHdNlquY7AA--.22027S3;
	Mon, 19 Feb 2024 17:21:11 +0800 (CST)
Subject: Re: [PATCH v4 4/6] LoongArch: Add paravirt interface for guest kernel
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240201031950.3225626-1-maobibo@loongson.cn>
 <20240201031950.3225626-5-maobibo@loongson.cn>
 <CAAhV-H7dXsU+WM172PWi_m8TYpYmzG_SW-vVQcdnOdETUxQ9+w@mail.gmail.com>
 <63f8bd29-c0da-167b-187d-61c56eb081a6@loongson.cn>
 <CAAhV-H6HQHyu=0zyv6FVLRJTkOcmnkLk5h361yGd2igYnuMMng@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <4dcbd5b2-ba69-e254-b3bb-75a75e5f9215@loongson.cn>
Date: Mon, 19 Feb 2024 17:21:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6HQHyu=0zyv6FVLRJTkOcmnkLk5h361yGd2igYnuMMng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxX8+FHdNlquY7AA--.22027S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3XFW7XF1DZw1xZF1DtF43Jwc_yoWfWFy5pa
	4DAF4kGa18Gr1fArsFg398WFnxt3s7GF12gF12ga40yrZFvF17Jr18tryj9FykAa1kG3W0
	qFyrGw4a9F15t3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUxYiiDU
	UUU



On 2024/2/19 下午4:48, Huacai Chen wrote:
> On Mon, Feb 19, 2024 at 12:11 PM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/2/19 上午10:42, Huacai Chen wrote:
>>> Hi, Bibo,
>>>
>>> On Thu, Feb 1, 2024 at 11:19 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>> The patch adds paravirt interface for guest kernel, function
>>>> pv_guest_initi() firstly checks whether system runs on VM mode. If kernel
>>>> runs on VM mode, it will call function kvm_para_available() to detect
>>>> whether current VMM is KVM hypervisor. And the paravirt function can work
>>>> only if current VMM is KVM hypervisor, since there is only KVM hypervisor
>>>> supported on LoongArch now.
>>>>
>>>> This patch only adds paravirt interface for guest kernel, however there
>>>> is not effective pv functions added here.
>>>>
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>>    arch/loongarch/Kconfig                        |  9 ++++
>>>>    arch/loongarch/include/asm/kvm_para.h         |  7 ++++
>>>>    arch/loongarch/include/asm/paravirt.h         | 27 ++++++++++++
>>>>    .../include/asm/paravirt_api_clock.h          |  1 +
>>>>    arch/loongarch/kernel/Makefile                |  1 +
>>>>    arch/loongarch/kernel/paravirt.c              | 41 +++++++++++++++++++
>>>>    arch/loongarch/kernel/setup.c                 |  2 +
>>>>    7 files changed, 88 insertions(+)
>>>>    create mode 100644 arch/loongarch/include/asm/paravirt.h
>>>>    create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
>>>>    create mode 100644 arch/loongarch/kernel/paravirt.c
>>>>
>>>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
>>>> index 10959e6c3583..817a56dff80f 100644
>>>> --- a/arch/loongarch/Kconfig
>>>> +++ b/arch/loongarch/Kconfig
>>>> @@ -585,6 +585,15 @@ config CPU_HAS_PREFETCH
>>>>           bool
>>>>           default y
>>>>
>>>> +config PARAVIRT
>>>> +       bool "Enable paravirtualization code"
>>>> +       depends on AS_HAS_LVZ_EXTENSION
>>>> +       help
>>>> +          This changes the kernel so it can modify itself when it is run
>>>> +         under a hypervisor, potentially improving performance significantly
>>>> +         over full virtualization.  However, when run without a hypervisor
>>>> +         the kernel is theoretically slower and slightly larger.
>>>> +
>>>>    config ARCH_SUPPORTS_KEXEC
>>>>           def_bool y
>>>>
>>>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>>>> index 9425d3b7e486..41200e922a82 100644
>>>> --- a/arch/loongarch/include/asm/kvm_para.h
>>>> +++ b/arch/loongarch/include/asm/kvm_para.h
>>>> @@ -2,6 +2,13 @@
>>>>    #ifndef _ASM_LOONGARCH_KVM_PARA_H
>>>>    #define _ASM_LOONGARCH_KVM_PARA_H
>>>>
>>>> +/*
>>>> + * Hypcall code field
>>>> + */
>>>> +#define HYPERVISOR_KVM                 1
>>>> +#define HYPERVISOR_VENDOR_SHIFT                8
>>>> +#define HYPERCALL_CODE(vendor, code)   ((vendor << HYPERVISOR_VENDOR_SHIFT) + code)
>>>> +
>>>>    /*
>>>>     * LoongArch hypcall return code
>>>>     */
>>>> diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/include/asm/paravirt.h
>>>> new file mode 100644
>>>> index 000000000000..b64813592ba0
>>>> --- /dev/null
>>>> +++ b/arch/loongarch/include/asm/paravirt.h
>>>> @@ -0,0 +1,27 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +#ifndef _ASM_LOONGARCH_PARAVIRT_H
>>>> +#define _ASM_LOONGARCH_PARAVIRT_H
>>>> +
>>>> +#ifdef CONFIG_PARAVIRT
>>>> +#include <linux/static_call_types.h>
>>>> +struct static_key;
>>>> +extern struct static_key paravirt_steal_enabled;
>>>> +extern struct static_key paravirt_steal_rq_enabled;
>>>> +
>>>> +u64 dummy_steal_clock(int cpu);
>>>> +DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
>>>> +
>>>> +static inline u64 paravirt_steal_clock(int cpu)
>>>> +{
>>>> +       return static_call(pv_steal_clock)(cpu);
>>>> +}
>>> The steal time code can be removed in this patch, I think.
>>>
>> Originally I want to remove this piece of code, but it fails to compile
>> if CONFIG_PARAVIRT is selected. Here is reference code, function
>> paravirt_steal_clock() must be defined if CONFIG_PARAVIRT is selected.
>>
>> static __always_inline u64 steal_account_process_time(u64 maxtime)
>> {
>> #ifdef CONFIG_PARAVIRT
>>           if (static_key_false(&paravirt_steal_enabled)) {
>>                   u64 steal;
>>
>>                   steal = paravirt_steal_clock(smp_processor_id());
>>                   steal -= this_rq()->prev_steal_time;
>>                   steal = min(steal, maxtime);
>>                   account_steal_time(steal);
>>                   this_rq()->prev_steal_time += steal;
>>
>>                   return steal;
>>           }
>> #endif
>>           return 0;
>> }
> OK, then keep it.
> 
>>
>>>> +
>>>> +int pv_guest_init(void);
>>>> +#else
>>>> +static inline int pv_guest_init(void)
>>>> +{
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +#endif // CONFIG_PARAVIRT
>>>> +#endif
>>>> diff --git a/arch/loongarch/include/asm/paravirt_api_clock.h b/arch/loongarch/include/asm/paravirt_api_clock.h
>>>> new file mode 100644
>>>> index 000000000000..65ac7cee0dad
>>>> --- /dev/null
>>>> +++ b/arch/loongarch/include/asm/paravirt_api_clock.h
>>>> @@ -0,0 +1 @@
>>>> +#include <asm/paravirt.h>
>>>> diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/Makefile
>>>> index 3c808c680370..662e6e9de12d 100644
>>>> --- a/arch/loongarch/kernel/Makefile
>>>> +++ b/arch/loongarch/kernel/Makefile
>>>> @@ -48,6 +48,7 @@ obj-$(CONFIG_MODULES)         += module.o module-sections.o
>>>>    obj-$(CONFIG_STACKTRACE)       += stacktrace.o
>>>>
>>>>    obj-$(CONFIG_PROC_FS)          += proc.o
>>>> +obj-$(CONFIG_PARAVIRT)         += paravirt.o
>>>>
>>>>    obj-$(CONFIG_SMP)              += smp.o
>>>>
>>>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
>>>> new file mode 100644
>>>> index 000000000000..21d01d05791a
>>>> --- /dev/null
>>>> +++ b/arch/loongarch/kernel/paravirt.c
>>>> @@ -0,0 +1,41 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +#include <linux/export.h>
>>>> +#include <linux/types.h>
>>>> +#include <linux/jump_label.h>
>>>> +#include <linux/kvm_para.h>
>>>> +#include <asm/paravirt.h>
>>>> +#include <linux/static_call.h>
>>>> +
>>>> +struct static_key paravirt_steal_enabled;
>>>> +struct static_key paravirt_steal_rq_enabled;
>>>> +
>>>> +static u64 native_steal_clock(int cpu)
>>>> +{
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
>>> The steal time code can be removed in this patch, I think.
>> Ditto, the same reason with above.
>>>
>>>> +
>>>> +static bool kvm_para_available(void)
>>>> +{
>>>> +       static int hypervisor_type;
>>>> +       int config;
>>>> +
>>>> +       if (!hypervisor_type) {
>>>> +               config = read_cpucfg(CPUCFG_KVM_SIG);
>>>> +               if (!memcmp(&config, KVM_SIGNATURE, 4))
>>>> +                       hypervisor_type = HYPERVISOR_KVM;
>>>> +       }
>>>> +
>>>> +       return hypervisor_type == HYPERVISOR_KVM;
>>>> +}
>>>> +
>>>> +int __init pv_guest_init(void)
>>>> +{
>>>> +       if (!cpu_has_hypervisor)
>>>> +               return 0;
>>>> +       if (!kvm_para_available())
>>>> +               return 0;
>>>> +
>>>> +       return 1;
>>>> +}
>>>> diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
>>>> index edf2bba80130..de5c36dccc49 100644
>>>> --- a/arch/loongarch/kernel/setup.c
>>>> +++ b/arch/loongarch/kernel/setup.c
>>>> @@ -43,6 +43,7 @@
>>>>    #include <asm/efi.h>
>>>>    #include <asm/loongson.h>
>>>>    #include <asm/numa.h>
>>>> +#include <asm/paravirt.h>
>>>>    #include <asm/pgalloc.h>
>>>>    #include <asm/sections.h>
>>>>    #include <asm/setup.h>
>>>> @@ -367,6 +368,7 @@ void __init platform_init(void)
>>>>           pr_info("The BIOS Version: %s\n", b_info.bios_version);
>>>>
>>>>           efi_runtime_init();
>>>> +       pv_guest_init();
>>> I prefer use CONFIG_PARAVIRT here, though you have a dummy version for
>>> !CONFIG_PARAVIRT, I think it is better to let others clearly know that
>>> PARAVIRT is an optional feature.
>> I remember that there is rule that CONFIG_xxx had better be used in
>> header files rather than c code, so that the code looks neat. Am I wrong?
> That depends on what we want, sometimes we want to hide the details,
> but sometimes we want to give others a notice.
I want to keep code clean here :)

> 
> And there is another problem: if you want to centralize all pv init
> functions, it is better to use pv_features_init() rather than
> pv_guest_init(); if you want to give each feature an init function,
> then we don't need pv_guest_init here, and we can then add a
> pv_ipi_init() in the last patch.
Currently I have no idea how to add other pv features like pv 
stealtimer, I will consider this when adding other pv features. 
pv_ipi_init/pv_guest_init is both ok for me, pv_ipi_init is better for now.

Regards
Bibo Mao

> 
> Huacai
> 
>>
>> Regards
>> Bibo Mao
>>>
>>> Huacai
>>>
>>>
>>> Huacai
>>>>    }
>>>>
>>>>    static void __init check_kernel_sections_mem(void)
>>>> --
>>>> 2.39.3
>>>>
>>>>
>>


