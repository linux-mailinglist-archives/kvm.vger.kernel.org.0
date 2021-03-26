Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D3134A763
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 13:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCZMiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 08:38:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229589AbhCZMhz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 08:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616762274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WOE7NrOe/lUFcec/VQExNlNZgIrXD9vAFV4hGyOnZ04=;
        b=f9/lSWSoFY6P833Yo6fNgKpDhq5eJCdEzRMB1i5px8PLPYb2Dg3eM9u94+HRMMWqJi2+4k
        N8aDaN+bf3fPDvrGpUlYvGdoFdly9+YjU8vxbmX1LnqWz6Vipp8/L9omNmXkLGfHAKKXmo
        7btV1QltsNSLRqcaW1Na2NNrMLHlrJI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-RuHbRkWgP8-gnfCQZk0YXw-1; Fri, 26 Mar 2021 08:37:52 -0400
X-MC-Unique: RuHbRkWgP8-gnfCQZk0YXw-1
Received: by mail-ed1-f69.google.com with SMTP id r19so4339947edv.3
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 05:37:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WOE7NrOe/lUFcec/VQExNlNZgIrXD9vAFV4hGyOnZ04=;
        b=aGh3GZ7+P/OiO7hDFi0QF1O6+wyxgprFsx9ca/Pf9yKzKnkauifMZgLMzg/U3j8KlX
         VVfoPH1LjlNE/nKIxMRCTv8/AL5gDbYAIT4ML3bFekloZWIzb7onapRMe2CuU91KlSmM
         cTlmI8A5NQaJCjUmvzbvbJM8PhltESY6J6lto+L7f9bIticubZ0hbibT7s/Aq0nujTjN
         eQ19xuT1vxocX+mxayRAs0eHY8usK4Fov8SsYcmtw7ThPUOxSS5kmiXOxcIXGubxhQCH
         rpuhU0MMm+WahuqqGCKULmpRSMevRAsMLBrxJokDvInrIr6/z6HQrhsiz7HmEKgwBPQn
         i0wg==
X-Gm-Message-State: AOAM533fJPK4wLt9syYFYOvuBRWbNXeBqiaHfQAjkXSMTkd37vcpHbGH
        YX9BXF85qA77csjQsp4g3W/1hWvsyeHqnrZb1JnrPB4wsCabVuaugNK8vyUYeANRzQJEMOG7lNy
        WVfru67zR7HIl
X-Received: by 2002:a17:906:4ada:: with SMTP id u26mr15073607ejt.129.1616762271764;
        Fri, 26 Mar 2021 05:37:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypsOeknHcD+xj3rdwv3OhzijkyYJHBHKiF5pdspfP2ypCyr60QMepV3hOPO7R6h8PIEleZ+Q==
X-Received: by 2002:a17:906:4ada:: with SMTP id u26mr15073579ejt.129.1616762271517;
        Fri, 26 Mar 2021 05:37:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g1sm827471edv.6.2021.03.26.05.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 05:37:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Lenny Szubowicz <lszubowi@redhat.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/kvmclock: Stop kvmclocks for hibernate restore
In-Reply-To: <87mtuqchdu.fsf@vitty.brq.redhat.com>
References: <20210311132847.224406-1-lszubowi@redhat.com>
 <87sg4t7vqy.fsf@vitty.brq.redhat.com>
 <5048babd-a40b-5a95-9dee-ab13367de6cb@redhat.com>
 <87mtuqchdu.fsf@vitty.brq.redhat.com>
Date:   Fri, 26 Mar 2021 13:37:49 +0100
Message-ID: <87h7kyccpu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Lenny Szubowicz <lszubowi@redhat.com> writes:
>
>> On 3/17/21 9:30 AM, Vitaly Kuznetsov wrote:
>>> Lenny Szubowicz <lszubowi@redhat.com> writes:
>>> 
>>>> Turn off host updates to the registered kvmclock memory
>>>> locations when transitioning to a hibernated kernel in
>>>> resume_target_kernel().
>>>>
>>>> This is accomplished for secondary vcpus by disabling host
>>>> clock updates for that vcpu when it is put offline. For the
>>>> primary vcpu, it's accomplished by using the existing call back
>>>> from save_processor_state() to kvm_save_sched_clock_state().
>>>>
>>>> The registered kvmclock memory locations may differ between
>>>> the currently running kernel and the hibernated kernel, which
>>>> is being restored and resumed. Kernel memory corruption is thus
>>>> possible if the host clock updates are allowed to run while the
>>>> hibernated kernel is relocated to its original physical memory
>>>> locations.
>>>>
>>>> This is similar to the problem solved for kexec by
>>>> commit 1e977aa12dd4 ("x86: KVM guest: disable clock before rebooting.")
>>>>
>>>> Commit 95a3d4454bb1 ("x86/kvmclock: Switch kvmclock data to a
>>>> PER_CPU variable") innocently increased the exposure for this
>>>> problem by dynamically allocating the physical pages that are
>>>> used for host clock updates when the vcpu count exceeds 64.
>>>> This increases the likelihood that the registered kvmclock
>>>> locations will differ for vcpus above 64.
>>>>
>>>> Reported-by: Xiaoyi Chen <cxiaoyi@amazon.com>
>>>> Tested-by: Mohamed Aboubakr <mabouba@amazon.com>
>>>> Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
>>>> ---
>>>>   arch/x86/kernel/kvmclock.c | 34 ++++++++++++++++++++++++++++++++--
>>>>   1 file changed, 32 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>>>> index aa593743acf6..291ffca41afb 100644
>>>> --- a/arch/x86/kernel/kvmclock.c
>>>> +++ b/arch/x86/kernel/kvmclock.c
>>>> @@ -187,8 +187,18 @@ static void kvm_register_clock(char *txt)
>>>>   	pr_info("kvm-clock: cpu %d, msr %llx, %s", smp_processor_id(), pa, txt);
>>>>   }
>>>>   
>>>> +/*
>>>> + * Turn off host clock updates to the registered memory location when the
>>>> + * cpu clock context is saved via save_processor_state(). Enables correct
>>>> + * handling of the primary cpu clock when transitioning to a hibernated
>>>> + * kernel in resume_target_kernel(), where the old and new registered
>>>> + * memory locations may differ.
>>>> + */
>>>>   static void kvm_save_sched_clock_state(void)
>>>>   {
>>>> +	native_write_msr(msr_kvm_system_time, 0, 0);
>>>> +	kvm_disable_steal_time();
>>>> +	pr_info("kvm-clock: cpu %d, clock stopped", smp_processor_id());
>>>>   }
>>> 
>>> Nitpick: should we rename kvm_save_sched_clock_state() to something more
>>> generic, like kvm_disable_host_clock_updates() to indicate, that what it
>>> does is not only sched clock related?
>>
>> I see your rationale. But if I rename kvm_save_sched_clock_state()
>> then shouldn't I also rename kvm_restore_sched_clock_state().
>> The names appear to reflect the callback that invokes them,
>> from save_processor_state()/restore_state(), rather than what these
>> functions need to do.
>>
>>          x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
>>          x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
>>   
>> For V2 of my patch, I kept these names as they were. But if you have a strong
>> desire for a different name, then I think both routines should be renamed
>> similarly, since they are meant to be a complimentary pair.
>>
>>> 
>>>>   
>>>>   static void kvm_restore_sched_clock_state(void)
>>>> @@ -311,9 +321,23 @@ static int kvmclock_setup_percpu(unsigned int cpu)
>>>>   	return p ? 0 : -ENOMEM;
>>>>   }
>>>>   
>>>> +/*
>>>> + * Turn off host clock updates to the registered memory location when a
>>>> + * cpu is placed offline. Enables correct handling of secondary cpu clocks
>>>> + * when transitioning to a hibernated kernel in resume_target_kernel(),
>>>> + * where the old and new registered memory locations may differ.
>>>> + */
>>>> +static int kvmclock_cpu_offline(unsigned int cpu)
>>>> +{
>>>> +	native_write_msr(msr_kvm_system_time, 0, 0);
>>>> +	pr_info("kvm-clock: cpu %d, clock stopped", cpu);
>>> 
>>> I'd say this pr_info() is superfluous: on a system with hundereds of
>>> vCPUs users will get flooded with 'clock stopped' messages which don't
>>> actually mean much: in case native_write_msr() fails the error gets
>>> reported in dmesg anyway. I'd suggest we drop this and pr_info() in
>>> kvm_save_sched_clock_state().
>>> 
>>
>> Agreed. I was essentially using it as a pr_debug(). Gone in V2.
>>
>>>> +	return 0;
>>> 
>>> Why don't we disable steal time accounting here? MSR_KVM_STEAL_TIME is
>>> also per-cpu. Can we merge kvm_save_sched_clock_state() with
>>> kvmclock_cpu_offline() maybe?
>>> 
>>
>> kvm_cpu_down_prepare() in arch/x86/kernel/kvm.c already calls
>> kvm_disable_steal_time() when a vcpu is placed offline.
>> So there is no need to do that in kvmclock_cpu_offline().
>>
>> In the case of the hibernation resume code path, resume_target_kernel()
>> in kernel/power/hibernate.c, the secondary cpus are placed offline,
>> but the primary is not. Instead, we are going to be switching contexts
>> of the primary cpu from the boot kernel to the kernel that was restored
>> from the hibernation image.
>>
>> This is where save_processor_state()/restore_processor_state() and kvm_save_sched_clock_state()/restore_sched_clock_state() come into play
>> to stop the kvmclock of the boot kernel's primary cpu and restart
>> the kvmclock of restored hibernated kernel's primary cpu.
>>
>> And in this case, no one is calling kvm_disable_steal_time(),
>> so kvm_save_sched_clock_state() is doing it. (This is very similar
>> to the reason why kvm_crash_shutdown() in kvmclock.c needs to call
>> kvm_disable_steal_time())
>>
>> However, I'm now wondering if kvm_restore_sched_clock_state()
>> needs to add a call to the equivalent of kvm_register_steal_time(),
>> because otherwise no one will do that for the primary vcpu
>> on resume from hibernation.
>
> In case this is true, steal time accounting is not our only
> problem. kvm_guest_cpu_init(), which is called from
> smp_prepare_boot_cpu() hook also sets up Async PF an PV EOI and both
> these features establish a shared guest-host memory region, in this
> doesn't happen upon resume from hibernation we're in trouble.
>
> smp_prepare_boot_cpu() hook is called very early from start_kernel() but
> what happens when we switch to the context of the hibernated kernel?
>
> I'm going to set up an environement and check what's going on.

According to the log we have a problem indeed:

[   15.844263] ACPI: Preparing to enter system sleep state S4
[   15.844309] PM: Saving platform NVS memory
[   15.844311] Disabling non-boot CPUs ...
[   15.844625] kvm-guest: Unregister pv shared memory for cpu 1
[   15.846272] smpboot: CPU 1 is now offline
[   15.847124] kvm-guest: Unregister pv shared memory for cpu 2
[   15.848720] smpboot: CPU 2 is now offline
[   15.849637] kvm-guest: Unregister pv shared memory for cpu 3
[   15.851452] smpboot: CPU 3 is now offline
[   15.853295] PM: hibernation: Creating image:
[   15.865126] PM: hibernation: Need to copy 82214 pages
[18446743485.711482] kvm-clock: cpu 0, msr 8201001, primary cpu clock, resume
[18446743485.711610] PM: Restoring platform NVS memory
[18446743485.713922] Enabling non-boot CPUs ...
[18446743485.713997] x86: Booting SMP configuration:
[18446743485.713998] smpboot: Booting Node 0 Processor 1 APIC 0x1
[18446743485.714127] kvm-clock: cpu 1, msr 8201041, secondary cpu clock
[18446743485.714484] kvm-guest: KVM setup async PF for cpu 1
[18446743485.714489] kvm-guest: stealtime: cpu 1, msr 3ecac080
[18446743485.714816] CPU1 is up
[18446743485.714846] smpboot: Booting Node 0 Processor 2 APIC 0x2
[18446743485.714954] kvm-clock: cpu 2, msr 8201081, secondary cpu clock
[18446743485.715359] kvm-guest: KVM setup async PF for cpu 2
[18446743485.715364] kvm-guest: stealtime: cpu 2, msr 3ed2c080
[18446743485.715640] CPU2 is up
[18446743485.715672] smpboot: Booting Node 0 Processor 3 APIC 0x3
[18446743485.715867] kvm-clock: cpu 3, msr 82010c1, secondary cpu clock
[18446743485.716288] kvm-guest: KVM setup async PF for cpu 3
[18446743485.716293] kvm-guest: stealtime: cpu 3, msr 3edac080
[18446743485.716564] CPU3 is up
[18446743485.716732] ACPI: Waking up from system sleep state S4
[18446743485.728139] sd 0:0:0:0: [sda] Starting disk
[18446743485.750373] OOM killer enabled.
[18446743485.750909] Restarting tasks ... done.
[18446743485.754465] PM: hibernation: hibernation exit

(this is with your v2 included). There's nothing about CPU0 for
e.g. async PF + timestamps are really interesting. Seems we have issues
to fix) I'm playing with it right now.

-- 
Vitaly

