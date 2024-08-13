Return-Path: <kvm+bounces-23922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB7FF94FAE0
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 02:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB502282DDC
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BDB6AAD;
	Tue, 13 Aug 2024 00:54:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D52EDB;
	Tue, 13 Aug 2024 00:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723510482; cv=none; b=lSYRHZkYaJfcgAtxR/EyNTW+/CY6yZloaDR/zmutGGr1vfkjywl/5IWYGcY+zYeVDl5UDZD0JVOAC+VBAu66NRZrhmEaRaG9u6OM9b3+qcVttJHgXEWCRi/TQ/UaZbjhE0HY672nQoyms8+lUtU3gPjysMCBgOUOmXWgkXR12Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723510482; c=relaxed/simple;
	bh=kszBfYAB2LdjoX7Jt9b2oDEl1R/LmBzHAs+fM+a/r9A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=f49tAEpCZ9YrJhEm6h6YP6W6FmnCwnUcxNuRko5CnW8hsE7mobk5JuvpcB0LMKzy8pRIrrP777ac3PRVfTWmOBDo6oAra8NUblz2KEEMXHloENnOox9vOTNvJjOvbTJ5IjYNBJpUkFmWoRnup6s91rzlZyb8yE1wM2uuZ7a6jVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxjpvMrrpmI6cRAA--.17783S3;
	Tue, 13 Aug 2024 08:54:36 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMAxz2fKrrpmjWARAA--.6186S3;
	Tue, 13 Aug 2024 08:54:35 +0800 (CST)
Subject: Re: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
 vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
 peterz@infradead.org, arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
 harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
 cl@gentwo.org, misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-7-ankur.a.arora@oracle.com>
 <f1a5d666-d236-572b-f9fc-5adeb30be44b@loongson.cn>
 <87plqdqrvr.fsf@oracle.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <718b57a9-a605-ce3a-2425-eeed83fa02ef@loongson.cn>
Date: Tue, 13 Aug 2024 08:54:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <87plqdqrvr.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxz2fKrrpmjWARAA--.6186S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZF15Xr4rKryxZw1kCFyfuFX_yoWrtF17pF
	Wqk3ZxKF4DWFy2yaySqwsFqF13ArZ3WF13Wr43J3yxGrn0vry7KF45tF15uF97Xr48Wr40
	vr10q3W3WF45JFgCm3ZEXasCq-sJn29KB7ZKAUJUUUU_529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
	XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUShiSDUUUU



On 2024/8/13 上午6:48, Ankur Arora wrote:
> 
> maobibo <maobibo@loongson.cn> writes:
> 
>> On 2024/7/27 上午4:21, Ankur Arora wrote:
>>> Add architectural support for cpuidle-haltpoll driver by defining
>>> arch_haltpoll_*().
>>> Also define ARCH_CPUIDLE_HALTPOLL to allow cpuidle-haltpoll to be
>>> selected, and given that we have an optimized polling mechanism
>>> in smp_cond_load*(), select ARCH_HAS_OPTIMIZED_POLL.
>>> smp_cond_load*() are implemented via LDXR, WFE, with LDXR loading
>>> a memory region in exclusive state and the WFE waiting for any
>>> stores to it.
>>> In the edge case -- no CPU stores to the waited region and there's no
>>> interrupt -- the event-stream will provide the terminating condition
>>> ensuring we don't wait forever, but because the event-stream runs at
>>> a fixed frequency (configured at 10kHz) we might spend more time in
>>> the polling stage than specified by cpuidle_poll_time().
>>> This would only happen in the last iteration, since overshooting the
>>> poll_limit means the governor moves out of the polling stage.
>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>> ---
>>>    arch/arm64/Kconfig                        | 10 ++++++++++
>>>    arch/arm64/include/asm/cpuidle_haltpoll.h |  9 +++++++++
>>>    arch/arm64/kernel/cpuidle.c               | 23 +++++++++++++++++++++++
>>>    3 files changed, 42 insertions(+)
>>>    create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>> index 5d91259ee7b5..cf1c6681eb0a 100644
>>> --- a/arch/arm64/Kconfig
>>> +++ b/arch/arm64/Kconfig
>>> @@ -35,6 +35,7 @@ config ARM64
>>>    	select ARCH_HAS_MEMBARRIER_SYNC_CORE
>>>    	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
>>>    	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>>> +	select ARCH_HAS_OPTIMIZED_POLL
>>>    	select ARCH_HAS_PTE_DEVMAP
>>>    	select ARCH_HAS_PTE_SPECIAL
>>>    	select ARCH_HAS_HW_PTE_YOUNG
>>> @@ -2376,6 +2377,15 @@ config ARCH_HIBERNATION_HEADER
>>>    config ARCH_SUSPEND_POSSIBLE
>>>    	def_bool y
>>>    +config ARCH_CPUIDLE_HALTPOLL
>>> +	bool "Enable selection of the cpuidle-haltpoll driver"
>>> +	default n
>>> +	help
>>> +	  cpuidle-haltpoll allows for adaptive polling based on
>>> +	  current load before entering the idle state.
>>> +
>>> +	  Some virtualized workloads benefit from using it.
>>> +
>>>    endmenu # "Power management options"
>>>      menu "CPU Power Management"
>>> diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
>>> new file mode 100644
>>> index 000000000000..65f289407a6c
>>> --- /dev/null
>>> +++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
>>> @@ -0,0 +1,9 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +#ifndef _ARCH_HALTPOLL_H
>>> +#define _ARCH_HALTPOLL_H
>>> +
>>> +static inline void arch_haltpoll_enable(unsigned int cpu) { }
>>> +static inline void arch_haltpoll_disable(unsigned int cpu) { }
>> It is better that guest supports halt poll on more architectures, LoongArch
>> wants this if result is good.
>>
>> Do we need disable halt polling on host hypervisor if guest also uses halt
>> polling idle method?
> 
> Yes. The intent is to work on that separately from this series. As the comment
> below states, until that is available we only allow force loading.
Thanks for your explanation. By internal test, it is useful for 
LoongArch virtmachine on some scenarios. And in late we want to add 
haltpoll support on LoongArch VM based your series.

Regards
Bibo Mao
> 
>>> +
>>> +bool arch_haltpoll_want(bool force);
>>> +#endif
>>> diff --git a/arch/arm64/kernel/cpuidle.c b/arch/arm64/kernel/cpuidle.c
>>> index f372295207fb..334df82a0eac 100644
>>> --- a/arch/arm64/kernel/cpuidle.c
>>> +++ b/arch/arm64/kernel/cpuidle.c
>>> @@ -72,3 +72,26 @@ __cpuidle int acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
>>>    					     lpi->index, state);
>>>    }
>>>    #endif
>>> +
>>> +#if IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE)
>>> +
>>> +#include <asm/cpuidle_haltpoll.h>
>>> +
>>> +bool arch_haltpoll_want(bool force)
>>> +{
>>> +	/*
>>> +	 * Enabling haltpoll requires two things:
>>> +	 *
>>> +	 * - Event stream support to provide a terminating condition to the
>>> +	 *   WFE in the poll loop.
>>> +	 *
>>> +	 * - KVM support for arch_haltpoll_enable(), arch_haltpoll_enable().
>>> +	 *
>>> +	 * Given that the second is missing, allow haltpoll to only be force
>>> +	 * loaded.
>>> +	 */
>>> +	return (arch_timer_evtstrm_available() && false) || force;
>>> +}
>>> +
>>> +EXPORT_SYMBOL_GPL(arch_haltpoll_want);
>>> +#endif
>>>
> 
> 
> --
> ankur
> 


