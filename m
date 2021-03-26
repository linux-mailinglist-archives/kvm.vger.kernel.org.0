Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955B934A5F4
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 11:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhCZK5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 06:57:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230046AbhCZK5G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 06:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616756226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ybgJAU+E9X4MewO2iZMuUGolW/fCwKow8qeXjGXj+WQ=;
        b=fuPDhS6NDT0GWz2pCdbdjavaUGokFiukE7VlNwqUi0OjE6DRtCL4Sl6jWU18ykGh8aE9st
        oQNhlbNkpsICrk4rjh3kkx3BTdF0dpFqrJIMQxerxoNB88/jUGVPXcl29L3CfesYZdKq9V
        NTHobcglS8JK4xaX6H+h5KXTawTEEgs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-pwSFBPWfOBektfL2HvhtjQ-1; Fri, 26 Mar 2021 06:57:04 -0400
X-MC-Unique: pwSFBPWfOBektfL2HvhtjQ-1
Received: by mail-ed1-f72.google.com with SMTP id p6so4175866edq.21
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 03:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ybgJAU+E9X4MewO2iZMuUGolW/fCwKow8qeXjGXj+WQ=;
        b=jlbjGtktHOXNK1BZZ+v1MV8rh63w2a8LopCMCKw93epG7hdQwY7jFCbbzB/1fxFsPj
         3IAn0X4Cgko1v+Ou96XAkurbHyqE8arZ3zyZ7yqnzTAPTN05PQ91XQyTIdrISnXYQETS
         eV+dgbmj+3/KyzgylLx6on+50foV/LFr1i17jhSMg923aPehQMAGx/UjR5bM1sEf9HSI
         I8OcJvyse/5yCvo1MKjXRl6qL0Pycz0Xr6fB+zpk2fcaK3OtJA/x5//ZmVp3RSXfbcAm
         XvO6QrfYnZEuJYqoXXitdeQ1b8z6cgVGED048JEz99aipnoBVsnMysTDqEYRVxy6YFEq
         aYWA==
X-Gm-Message-State: AOAM5329/waHsrllUBn8+VH7E/cy4K+tVedT4hMtU2JSRaryx7/TLakQ
        PowdnJza8OkS31rucWBRqGUewJG6WFMOBdS+e74X7dRITapnMpJ+G5vFOS0XPyO/51+usWGdh2y
        08xjCU6KZ+3+W
X-Received: by 2002:a17:906:2314:: with SMTP id l20mr14775308eja.178.1616756222775;
        Fri, 26 Mar 2021 03:57:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCY/ftGgArG8rMqGeFgWHC7rzPfRxqnn1LJxvMr65neZ1dzHdTRf0m0kz4VcZoFCZlIWcKdQ==
X-Received: by 2002:a17:906:2314:: with SMTP id l20mr14775291eja.178.1616756222518;
        Fri, 26 Mar 2021 03:57:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q26sm3699419eja.45.2021.03.26.03.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 03:57:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Lenny Szubowicz <lszubowi@redhat.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/kvmclock: Stop kvmclocks for hibernate restore
In-Reply-To: <5048babd-a40b-5a95-9dee-ab13367de6cb@redhat.com>
References: <20210311132847.224406-1-lszubowi@redhat.com>
 <87sg4t7vqy.fsf@vitty.brq.redhat.com>
 <5048babd-a40b-5a95-9dee-ab13367de6cb@redhat.com>
Date:   Fri, 26 Mar 2021 11:57:01 +0100
Message-ID: <87mtuqchdu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lenny Szubowicz <lszubowi@redhat.com> writes:

> On 3/17/21 9:30 AM, Vitaly Kuznetsov wrote:
>> Lenny Szubowicz <lszubowi@redhat.com> writes:
>> 
>>> Turn off host updates to the registered kvmclock memory
>>> locations when transitioning to a hibernated kernel in
>>> resume_target_kernel().
>>>
>>> This is accomplished for secondary vcpus by disabling host
>>> clock updates for that vcpu when it is put offline. For the
>>> primary vcpu, it's accomplished by using the existing call back
>>> from save_processor_state() to kvm_save_sched_clock_state().
>>>
>>> The registered kvmclock memory locations may differ between
>>> the currently running kernel and the hibernated kernel, which
>>> is being restored and resumed. Kernel memory corruption is thus
>>> possible if the host clock updates are allowed to run while the
>>> hibernated kernel is relocated to its original physical memory
>>> locations.
>>>
>>> This is similar to the problem solved for kexec by
>>> commit 1e977aa12dd4 ("x86: KVM guest: disable clock before rebooting.")
>>>
>>> Commit 95a3d4454bb1 ("x86/kvmclock: Switch kvmclock data to a
>>> PER_CPU variable") innocently increased the exposure for this
>>> problem by dynamically allocating the physical pages that are
>>> used for host clock updates when the vcpu count exceeds 64.
>>> This increases the likelihood that the registered kvmclock
>>> locations will differ for vcpus above 64.
>>>
>>> Reported-by: Xiaoyi Chen <cxiaoyi@amazon.com>
>>> Tested-by: Mohamed Aboubakr <mabouba@amazon.com>
>>> Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
>>> ---
>>>   arch/x86/kernel/kvmclock.c | 34 ++++++++++++++++++++++++++++++++--
>>>   1 file changed, 32 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>>> index aa593743acf6..291ffca41afb 100644
>>> --- a/arch/x86/kernel/kvmclock.c
>>> +++ b/arch/x86/kernel/kvmclock.c
>>> @@ -187,8 +187,18 @@ static void kvm_register_clock(char *txt)
>>>   	pr_info("kvm-clock: cpu %d, msr %llx, %s", smp_processor_id(), pa, txt);
>>>   }
>>>   
>>> +/*
>>> + * Turn off host clock updates to the registered memory location when the
>>> + * cpu clock context is saved via save_processor_state(). Enables correct
>>> + * handling of the primary cpu clock when transitioning to a hibernated
>>> + * kernel in resume_target_kernel(), where the old and new registered
>>> + * memory locations may differ.
>>> + */
>>>   static void kvm_save_sched_clock_state(void)
>>>   {
>>> +	native_write_msr(msr_kvm_system_time, 0, 0);
>>> +	kvm_disable_steal_time();
>>> +	pr_info("kvm-clock: cpu %d, clock stopped", smp_processor_id());
>>>   }
>> 
>> Nitpick: should we rename kvm_save_sched_clock_state() to something more
>> generic, like kvm_disable_host_clock_updates() to indicate, that what it
>> does is not only sched clock related?
>
> I see your rationale. But if I rename kvm_save_sched_clock_state()
> then shouldn't I also rename kvm_restore_sched_clock_state().
> The names appear to reflect the callback that invokes them,
> from save_processor_state()/restore_state(), rather than what these
> functions need to do.
>
>          x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
>          x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
>   
> For V2 of my patch, I kept these names as they were. But if you have a strong
> desire for a different name, then I think both routines should be renamed
> similarly, since they are meant to be a complimentary pair.
>
>> 
>>>   
>>>   static void kvm_restore_sched_clock_state(void)
>>> @@ -311,9 +321,23 @@ static int kvmclock_setup_percpu(unsigned int cpu)
>>>   	return p ? 0 : -ENOMEM;
>>>   }
>>>   
>>> +/*
>>> + * Turn off host clock updates to the registered memory location when a
>>> + * cpu is placed offline. Enables correct handling of secondary cpu clocks
>>> + * when transitioning to a hibernated kernel in resume_target_kernel(),
>>> + * where the old and new registered memory locations may differ.
>>> + */
>>> +static int kvmclock_cpu_offline(unsigned int cpu)
>>> +{
>>> +	native_write_msr(msr_kvm_system_time, 0, 0);
>>> +	pr_info("kvm-clock: cpu %d, clock stopped", cpu);
>> 
>> I'd say this pr_info() is superfluous: on a system with hundereds of
>> vCPUs users will get flooded with 'clock stopped' messages which don't
>> actually mean much: in case native_write_msr() fails the error gets
>> reported in dmesg anyway. I'd suggest we drop this and pr_info() in
>> kvm_save_sched_clock_state().
>> 
>
> Agreed. I was essentially using it as a pr_debug(). Gone in V2.
>
>>> +	return 0;
>> 
>> Why don't we disable steal time accounting here? MSR_KVM_STEAL_TIME is
>> also per-cpu. Can we merge kvm_save_sched_clock_state() with
>> kvmclock_cpu_offline() maybe?
>> 
>
> kvm_cpu_down_prepare() in arch/x86/kernel/kvm.c already calls
> kvm_disable_steal_time() when a vcpu is placed offline.
> So there is no need to do that in kvmclock_cpu_offline().
>
> In the case of the hibernation resume code path, resume_target_kernel()
> in kernel/power/hibernate.c, the secondary cpus are placed offline,
> but the primary is not. Instead, we are going to be switching contexts
> of the primary cpu from the boot kernel to the kernel that was restored
> from the hibernation image.
>
> This is where save_processor_state()/restore_processor_state() and kvm_save_sched_clock_state()/restore_sched_clock_state() come into play
> to stop the kvmclock of the boot kernel's primary cpu and restart
> the kvmclock of restored hibernated kernel's primary cpu.
>
> And in this case, no one is calling kvm_disable_steal_time(),
> so kvm_save_sched_clock_state() is doing it. (This is very similar
> to the reason why kvm_crash_shutdown() in kvmclock.c needs to call
> kvm_disable_steal_time())
>
> However, I'm now wondering if kvm_restore_sched_clock_state()
> needs to add a call to the equivalent of kvm_register_steal_time(),
> because otherwise no one will do that for the primary vcpu
> on resume from hibernation.

In case this is true, steal time accounting is not our only
problem. kvm_guest_cpu_init(), which is called from
smp_prepare_boot_cpu() hook also sets up Async PF an PV EOI and both
these features establish a shared guest-host memory region, in this
doesn't happen upon resume from hibernation we're in trouble.

smp_prepare_boot_cpu() hook is called very early from start_kernel() but
what happens when we switch to the context of the hibernated kernel?

I'm going to set up an environement and check what's going on.

>
>>> +}
>>> +
>>>   void __init kvmclock_init(void)
>>>   {
>>>   	u8 flags;
>>> +	int cpuhp_prepare;
>>>   
>>>   	if (!kvm_para_available() || !kvmclock)
>>>   		return;
>>> @@ -325,8 +349,14 @@ void __init kvmclock_init(void)
>>>   		return;
>>>   	}
>>>   
>>> -	if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
>>> -			      kvmclock_setup_percpu, NULL) < 0) {
>>> +	cpuhp_prepare = cpuhp_setup_state(CPUHP_BP_PREPARE_DYN,
>>> +					  "kvmclock:setup_percpu",
>>> +					  kvmclock_setup_percpu, NULL);
>>> +	if (cpuhp_prepare < 0)
>>> +		return;
>>> +	if (cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvmclock:cpu_offline",
>>> +			      NULL, kvmclock_cpu_offline) < 0) {
>>> +		cpuhp_remove_state(cpuhp_prepare);
>> 
>> In case we fail to set up kvmclock_cpu_offline() callback we get broken
>> hybernation but without kvmclock_setup_percpu() call we get a broken
>> guest (as kvmclock() may be the only reliable clocksource) so I'm not
>> exactly sure we're active in a best way with cpuhp_remove_state()
>> here. I don't feel strong though, I think it can stay but in that case
>> I'd add a pr_warn() at least.
>
> Something is seriously broken if either of these cpuhp_setup_state()
> calls fail. I first considered using the "down" callback of the
> CPUHP_BP_PREPARE_DYN state, as in:
>
>          if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
> 			      kvmclock_setup_percpu, kvmclock_cpu_offline) < 0) {
>
> This would have minimized the change, but I wasn't comfortable with how late
> it would be called. Other examples in the kernel, including kvm.c, use
> CPUHP_AP_ONLINE_DYN for cpu online/offline events.
>
> But I do agree that a failure of either cpuhp_setup_state() should not
> be silent. So in V2 I added a pr_err().
>
> Thank you for your review comments.
>
>                          -Lenny.
>
>> 
>>>   		return;
>>>   	}
>> 
>

-- 
Vitaly

