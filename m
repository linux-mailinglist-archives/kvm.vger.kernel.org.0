Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097E3619105
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 07:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiKDGYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 02:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbiKDGYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 02:24:34 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E2527DFB
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 23:24:16 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso4764423wme.5
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 23:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bLZS4btyoBNJpvI4lDx3+/Q0QYaM9RdRgTuU5oqZXiw=;
        b=KpqOlJnpCBs9Fig3APpNHUOW+wgMUZPgu6tIMt4v79SYt0yKxG/vmAGuaT7XkQlc87
         cG3/vqkkXM/T/mNWMp5bbB6RujjWKiLJ+R+u7BIl0mIkv19DwSBzHJXgV6WYu+x+6w9a
         5dKfCdwE9gDEcSVdRp7XrilbshhalAJpmIxH7w5BIlj5sjeEa6/kgfJfv8ZhAIXIsoAZ
         o8vNIWujZ6bWMQXjxDnZM1683oc0PeZrK8fGHhlbqvpxGzXRkTu5yzGUkEhGuHXBDsoc
         lH99C17SkvFlvHDKH43ZNSV2gUwYmwLodUfhSq3XPMbr7M+aSePyhJKAU0IbeWl3vg86
         KLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bLZS4btyoBNJpvI4lDx3+/Q0QYaM9RdRgTuU5oqZXiw=;
        b=ITSZLjRn8mzgcdVwzmJvC0cwUt1mfbES7YASNvSeVs7O5udjF07eZhQ3vD/AHgZpWh
         wIQ3hBmICCPkXeEDL5S8AQbahnQRIt8wmm3HT7OHaVOB0oO0qwSO2IjgTBv1tJgC3eXl
         Zcj0xNAAbUa3OOFYVT5qar8tnVoJtE2QYEGuM0DELoT5xu7Hrnz+e1ZF1SzV2HsqzqZc
         G7bpKEip+w2S0fvBghSjTSzcqIQhqa5Et86ptWznf10sX0/Aez1TEKBv1Z8f/NCshXx3
         0EbRdU1OjcD4ewx3syIPLQ+k+Awe1O9zHaX+3W/K1ViBKfauNXKvYINxye+/MUXTjYAp
         IS2w==
X-Gm-Message-State: ACrzQf2N8jRtMJBQoVccvt2c7wrvmvcDKX787mTWRnYXDI+f1Mpa8/6C
        lycv7veSLGR1dVM/YRi0RZ7rlA==
X-Google-Smtp-Source: AMsMyM5sPnjGMPF4hka3QeEWAs4A5/8vs19eoSmP9UDP8V2dxCbMF0Y5Ap0/e+T4dvK9BW1eLMVDdw==
X-Received: by 2002:a7b:c455:0:b0:3cf:6817:297d with SMTP id l21-20020a7bc455000000b003cf6817297dmr21329910wmi.152.1667543054623;
        Thu, 03 Nov 2022 23:24:14 -0700 (PDT)
Received: from ?IPV6:2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6? ([2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6])
        by smtp.gmail.com with ESMTPSA id h4-20020adff184000000b00236e9755c02sm2494568wro.111.2022.11.03.23.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 23:24:13 -0700 (PDT)
Message-ID: <1b404477-8bff-0d33-477f-514e12ba8546@bytedance.com>
Date:   Fri, 4 Nov 2022 06:24:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [External] Re: [RFC 5/6] KVM: arm64: Support the VCPU preemption
 check
Content-Language: en-US
To:     Steven Price <steven.price@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, mark.rutland@arm.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
References: <20221102161340.2982090-1-usama.arif@bytedance.com>
 <20221102161340.2982090-6-usama.arif@bytedance.com>
 <76f59579-b701-a243-2a50-72a1401d3a65@arm.com>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <76f59579-b701-a243-2a50-72a1401d3a65@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03/11/2022 13:25, Steven Price wrote:
> On 02/11/2022 16:13, Usama Arif wrote:
>> Support the vcpu_is_preempted() functionality under KVM/arm64. This will
>> enhance lock performance on overcommitted hosts (more runnable VCPUs
>> than physical CPUs in the system) as doing busy waits for preempted
>> VCPUs will hurt system performance far worse than early yielding.
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
>> ---
>>   arch/arm64/include/asm/paravirt.h |   2 +
>>   arch/arm64/include/asm/spinlock.h |  16 +++-
>>   arch/arm64/kernel/paravirt.c      | 126 ++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/setup.c         |   3 +
>>   include/linux/cpuhotplug.h        |   1 +
>>   5 files changed, 147 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
>> index 9aa193e0e8f2..4ccb4356c56b 100644
>> --- a/arch/arm64/include/asm/paravirt.h
>> +++ b/arch/arm64/include/asm/paravirt.h
>> @@ -19,10 +19,12 @@ static inline u64 paravirt_steal_clock(int cpu)
>>   }
>>   
>>   int __init pv_time_init(void);
>> +int __init pv_lock_init(void);
>>   
>>   #else
>>   
>>   #define pv_time_init() do {} while (0)
>> +#define pv_lock_init() do {} while (0)
>>   
>>   #endif // CONFIG_PARAVIRT
>>   
>> diff --git a/arch/arm64/include/asm/spinlock.h b/arch/arm64/include/asm/spinlock.h
>> index 0525c0b089ed..7023efa4de96 100644
>> --- a/arch/arm64/include/asm/spinlock.h
>> +++ b/arch/arm64/include/asm/spinlock.h
>> @@ -10,7 +10,20 @@
>>   
>>   /* See include/linux/spinlock.h */
>>   #define smp_mb__after_spinlock()	smp_mb()
>> +#define vcpu_is_preempted vcpu_is_preempted
>> +
>> +#ifdef CONFIG_PARAVIRT
>> +#include <linux/static_call_types.h>
>> +
>> +bool dummy_vcpu_is_preempted(int cpu);
>>   
>> +DECLARE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
>> +static inline bool vcpu_is_preempted(int cpu)
>> +{
>> +	return static_call(pv_vcpu_is_preempted)(cpu);
>> +}
>> +
>> +#else
>>   /*
>>    * Changing this will break osq_lock() thanks to the call inside
>>    * smp_cond_load_relaxed().
>> @@ -18,10 +31,11 @@
>>    * See:
>>    * https://lore.kernel.org/lkml/20200110100612.GC2827@hirez.programming.kicks-ass.net
>>    */
>> -#define vcpu_is_preempted vcpu_is_preempted
>>   static inline bool vcpu_is_preempted(int cpu)
>>   {
>>   	return false;
>>   }
>>   
>> +#endif /* CONFIG_PARAVIRT */
>> +
>>   #endif /* __ASM_SPINLOCK_H */
>> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
>> index 57c7c211f8c7..45bcca87bed7 100644
>> --- a/arch/arm64/kernel/paravirt.c
>> +++ b/arch/arm64/kernel/paravirt.c
>> @@ -22,6 +22,7 @@
>>   
>>   #include <asm/paravirt.h>
>>   #include <asm/pvclock-abi.h>
>> +#include <asm/pvlock-abi.h>
>>   #include <asm/smp_plat.h>
>>   
>>   struct static_key paravirt_steal_enabled;
>> @@ -38,7 +39,12 @@ struct pv_time_stolen_time_region {
>>   	struct pvclock_vcpu_stolen_time __rcu *kaddr;
>>   };
>>   
>> +struct pv_lock_state_region {
>> +	struct pvlock_vcpu_state __rcu *kaddr;
>> +};
>> +
>>   static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
>> +static DEFINE_PER_CPU(struct pv_lock_state_region, lock_state_region);
>>   
>>   static bool steal_acc = true;
>>   static int __init parse_no_stealacc(char *arg)
>> @@ -178,3 +184,123 @@ int __init pv_time_init(void)
>>   
>>   	return 0;
>>   }
>> +
>> +static bool native_vcpu_is_preempted(int cpu)
>> +{
>> +	return false;
>> +}
>> +
>> +DEFINE_STATIC_CALL(pv_vcpu_is_preempted, native_vcpu_is_preempted);
>> +
>> +static bool para_vcpu_is_preempted(int cpu)
>> +{
>> +	struct pv_lock_state_region *reg;
>> +	__le64 preempted_le;
>> +
>> +	reg = per_cpu_ptr(&lock_state_region, cpu);
>> +	if (!reg->kaddr) {
>> +		pr_warn_once("PV lock enabled but not configured for cpu %d\n",
>> +			     cpu);
>> +		return false;
>> +	}
>> +
>> +	preempted_le = le64_to_cpu(READ_ONCE(reg->kaddr->preempted));
>> +
>> +	return !!(preempted_le);
>> +}
>> +
>> +static int pvlock_vcpu_state_dying_cpu(unsigned int cpu)
>> +{
>> +	struct pv_lock_state_region *reg;
>> +
>> +	reg = this_cpu_ptr(&lock_state_region);
>> +	if (!reg->kaddr)
>> +		return 0;
>> +
>> +	memunmap(reg->kaddr);
>> +	memset(reg, 0, sizeof(*reg));
>> +
>> +	return 0;
>> +}
>> +
>> +static int init_pvlock_vcpu_state(unsigned int cpu)
>> +{
>> +	struct pv_lock_state_region *reg;
>> +	struct arm_smccc_res res;
>> +
>> +	reg = this_cpu_ptr(&lock_state_region);
>> +
>> +	arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_LOCK_PREEMPTED, &res);
>> +
>> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED) {
>> +		pr_warn("Failed to init PV lock data structure\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	reg->kaddr = memremap(res.a0,
>> +			      sizeof(struct pvlock_vcpu_state),
>> +			      MEMREMAP_WB);
>> +
>> +	if (!reg->kaddr) {
>> +		pr_warn("Failed to map PV lock data structure\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int kvm_arm_init_pvlock(void)
>> +{
>> +	int ret;
>> +
>> +	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
>> +				"hypervisor/arm/pvlock:starting",
>> +				init_pvlock_vcpu_state,
>> +				pvlock_vcpu_state_dying_cpu);
>> +	if (ret < 0) {
>> +		pr_warn("PV-lock init failed\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static bool has_kvm_pvlock(void)
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	/* To detect the presence of PV lock support we require SMCCC 1.1+ */
>> +	if (arm_smccc_1_1_get_conduit() == SMCCC_CONDUIT_NONE)
>> +		return false;
> 
> This is unnecessary as arm_smccc_1_1_invoke() will return failure if
> there's no conduit (or pre-SMCCC 1.1). I suspect this was a copy/paste
> from has_pv_steal_clock() which also has the unnecessary check (patch
> welcome ;) ).


Thanks for the review!

I have sent a seperate patch to remove it from pv_steal_clock: 
https://lore.kernel.org/all/20221104061659.4116508-1-usama.arif@bytedance.com/. 


I have removed it from pv_lock as well in the v2 patchset: 
https://lore.kernel.org/all/20221104062105.4119003-1-usama.arif@bytedance.com/.
> 
>> +
>> +	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>> +			     ARM_SMCCC_HV_PV_LOCK_FEATURES, &res);
> 
> Since this is a 'OWNER_VENDOR_HYP' call this should really be preceded
> by a check that we're running under the expected hypervisor. See e.g.
> kvm_init_hyp_services().
> 
> Of course for KVM we already have a (different) discovery mechanism and
> this could be included as a ARM_SMCCC_KVM_FUNC_xxx feature. This
> has_kvm_pvlock() function would then simply be:
> 
> static bool has_kvm_pvlock(void)
> {
> 	return kvm_arm_hyp_service_available(ARM_SMCC_KVM_FUNC_PVLOCK);
> }

Thanks, I have simplified has_kvm_pvlock to above. I also changed the 
code in the v2 revision, so that its just 1 hypercall, 
ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID. This is similar to how it is 
done in ptp_kvm vendor call.

Usama

> 
> Steve
> 
>> +
>> +	if (res.a0 != SMCCC_RET_SUCCESS)
>> +		return false;
>> +
>> +	arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_LOCK_FEATURES,
>> +			     ARM_SMCCC_HV_PV_LOCK_PREEMPTED, &res);
>> +
>> +	return (res.a0 == SMCCC_RET_SUCCESS);
>> +}
>> +
>> +int __init pv_lock_init(void)
>> +{
>> +	int ret;
>> +
>> +	if (is_hyp_mode_available())
>> +		return 0;
>> +
>> +	if (!has_kvm_pvlock())
>> +		return 0;
>> +
>> +	ret = kvm_arm_init_pvlock();
>> +	if (ret)
>> +		return ret;
>> +
>> +	static_call_update(pv_vcpu_is_preempted, para_vcpu_is_preempted);
>> +	pr_info("using PV-lock preempted\n");
>> +
>> +	return 0;
>> +}
>> \ No newline at end of file
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index fea3223704b6..05ca07ac5800 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -42,6 +42,7 @@
>>   #include <asm/cpu_ops.h>
>>   #include <asm/kasan.h>
>>   #include <asm/numa.h>
>> +#include <asm/paravirt.h>
>>   #include <asm/sections.h>
>>   #include <asm/setup.h>
>>   #include <asm/smp_plat.h>
>> @@ -360,6 +361,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>>   	smp_init_cpus();
>>   	smp_build_mpidr_hash();
>>   
>> +	pv_lock_init();
>> +
>>   	/* Init percpu seeds for random tags after cpus are set up. */
>>   	kasan_init_sw_tags();
>>   
>> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
>> index f61447913db9..c0ee11855c73 100644
>> --- a/include/linux/cpuhotplug.h
>> +++ b/include/linux/cpuhotplug.h
>> @@ -192,6 +192,7 @@ enum cpuhp_state {
>>   	/* Must be the last timer callback */
>>   	CPUHP_AP_DUMMY_TIMER_STARTING,
>>   	CPUHP_AP_ARM_XEN_STARTING,
>> +	CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
>>   	CPUHP_AP_ARM_CORESIGHT_STARTING,
>>   	CPUHP_AP_ARM_CORESIGHT_CTI_STARTING,
>>   	CPUHP_AP_ARM64_ISNDEP_STARTING,
> 
