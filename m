Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D63E349FCA
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhCZC1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:27:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbhCZC1A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 22:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616725619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yIh1QQuYJfzK4sKlNfFUdvGoGXJbMr7BFoUhHpD4vXc=;
        b=LjJG/gkb+RaGxHgTCve1Nc7JzqISxE3AQTIOY7trxuxRXsPsZI0dSU0B8lBcZOfMzlkbnX
        ya8XZAaVUo0f8tDBSm/vvJYtbOWcZTb+rQCUJETzWjGBi3gnw/zHX7YBs9eBlSMkbZbihY
        9dDVFCU2MYm5esbOzhc0BURce4k4Pqo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-mSJ9HGrJNOK-WaNSHHQYYQ-1; Thu, 25 Mar 2021 22:26:57 -0400
X-MC-Unique: mSJ9HGrJNOK-WaNSHHQYYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB2E41084CA0;
        Fri, 26 Mar 2021 02:26:55 +0000 (UTC)
Received: from [10.10.110.35] (unknown [10.10.110.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3089B891AD;
        Fri, 26 Mar 2021 02:26:50 +0000 (UTC)
Subject: Re: [PATCH] x86/kvmclock: Stop kvmclocks for hibernate restore
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, pbonzini@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210311132847.224406-1-lszubowi@redhat.com>
 <87sg4t7vqy.fsf@vitty.brq.redhat.com>
From:   Lenny Szubowicz <lszubowi@redhat.com>
Message-ID: <5048babd-a40b-5a95-9dee-ab13367de6cb@redhat.com>
Date:   Thu, 25 Mar 2021 22:26:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <87sg4t7vqy.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/17/21 9:30 AM, Vitaly Kuznetsov wrote:
> Lenny Szubowicz <lszubowi@redhat.com> writes:
> 
>> Turn off host updates to the registered kvmclock memory
>> locations when transitioning to a hibernated kernel in
>> resume_target_kernel().
>>
>> This is accomplished for secondary vcpus by disabling host
>> clock updates for that vcpu when it is put offline. For the
>> primary vcpu, it's accomplished by using the existing call back
>> from save_processor_state() to kvm_save_sched_clock_state().
>>
>> The registered kvmclock memory locations may differ between
>> the currently running kernel and the hibernated kernel, which
>> is being restored and resumed. Kernel memory corruption is thus
>> possible if the host clock updates are allowed to run while the
>> hibernated kernel is relocated to its original physical memory
>> locations.
>>
>> This is similar to the problem solved for kexec by
>> commit 1e977aa12dd4 ("x86: KVM guest: disable clock before rebooting.")
>>
>> Commit 95a3d4454bb1 ("x86/kvmclock: Switch kvmclock data to a
>> PER_CPU variable") innocently increased the exposure for this
>> problem by dynamically allocating the physical pages that are
>> used for host clock updates when the vcpu count exceeds 64.
>> This increases the likelihood that the registered kvmclock
>> locations will differ for vcpus above 64.
>>
>> Reported-by: Xiaoyi Chen <cxiaoyi@amazon.com>
>> Tested-by: Mohamed Aboubakr <mabouba@amazon.com>
>> Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
>> ---
>>   arch/x86/kernel/kvmclock.c | 34 ++++++++++++++++++++++++++++++++--
>>   1 file changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>> index aa593743acf6..291ffca41afb 100644
>> --- a/arch/x86/kernel/kvmclock.c
>> +++ b/arch/x86/kernel/kvmclock.c
>> @@ -187,8 +187,18 @@ static void kvm_register_clock(char *txt)
>>   	pr_info("kvm-clock: cpu %d, msr %llx, %s", smp_processor_id(), pa, txt);
>>   }
>>   
>> +/*
>> + * Turn off host clock updates to the registered memory location when the
>> + * cpu clock context is saved via save_processor_state(). Enables correct
>> + * handling of the primary cpu clock when transitioning to a hibernated
>> + * kernel in resume_target_kernel(), where the old and new registered
>> + * memory locations may differ.
>> + */
>>   static void kvm_save_sched_clock_state(void)
>>   {
>> +	native_write_msr(msr_kvm_system_time, 0, 0);
>> +	kvm_disable_steal_time();
>> +	pr_info("kvm-clock: cpu %d, clock stopped", smp_processor_id());
>>   }
> 
> Nitpick: should we rename kvm_save_sched_clock_state() to something more
> generic, like kvm_disable_host_clock_updates() to indicate, that what it
> does is not only sched clock related?

I see your rationale. But if I rename kvm_save_sched_clock_state()
then shouldn't I also rename kvm_restore_sched_clock_state().
The names appear to reflect the callback that invokes them,
from save_processor_state()/restore_state(), rather than what these
functions need to do.

         x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
         x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
  
For V2 of my patch, I kept these names as they were. But if you have a strong
desire for a different name, then I think both routines should be renamed
similarly, since they are meant to be a complimentary pair.

> 
>>   
>>   static void kvm_restore_sched_clock_state(void)
>> @@ -311,9 +321,23 @@ static int kvmclock_setup_percpu(unsigned int cpu)
>>   	return p ? 0 : -ENOMEM;
>>   }
>>   
>> +/*
>> + * Turn off host clock updates to the registered memory location when a
>> + * cpu is placed offline. Enables correct handling of secondary cpu clocks
>> + * when transitioning to a hibernated kernel in resume_target_kernel(),
>> + * where the old and new registered memory locations may differ.
>> + */
>> +static int kvmclock_cpu_offline(unsigned int cpu)
>> +{
>> +	native_write_msr(msr_kvm_system_time, 0, 0);
>> +	pr_info("kvm-clock: cpu %d, clock stopped", cpu);
> 
> I'd say this pr_info() is superfluous: on a system with hundereds of
> vCPUs users will get flooded with 'clock stopped' messages which don't
> actually mean much: in case native_write_msr() fails the error gets
> reported in dmesg anyway. I'd suggest we drop this and pr_info() in
> kvm_save_sched_clock_state().
> 

Agreed. I was essentially using it as a pr_debug(). Gone in V2.

>> +	return 0;
> 
> Why don't we disable steal time accounting here? MSR_KVM_STEAL_TIME is
> also per-cpu. Can we merge kvm_save_sched_clock_state() with
> kvmclock_cpu_offline() maybe?
> 

kvm_cpu_down_prepare() in arch/x86/kernel/kvm.c already calls
kvm_disable_steal_time() when a vcpu is placed offline.
So there is no need to do that in kvmclock_cpu_offline().

In the case of the hibernation resume code path, resume_target_kernel()
in kernel/power/hibernate.c, the secondary cpus are placed offline,
but the primary is not. Instead, we are going to be switching contexts
of the primary cpu from the boot kernel to the kernel that was restored
from the hibernation image.

This is where save_processor_state()/restore_processor_state() and kvm_save_sched_clock_state()/restore_sched_clock_state() come into play
to stop the kvmclock of the boot kernel's primary cpu and restart
the kvmclock of restored hibernated kernel's primary cpu.

And in this case, no one is calling kvm_disable_steal_time(),
so kvm_save_sched_clock_state() is doing it. (This is very similar
to the reason why kvm_crash_shutdown() in kvmclock.c needs to call
kvm_disable_steal_time())

However, I'm now wondering if kvm_restore_sched_clock_state()
needs to add a call to the equivalent of kvm_register_steal_time(),
because otherwise no one will do that for the primary vcpu
on resume from hibernation.

>> +}
>> +
>>   void __init kvmclock_init(void)
>>   {
>>   	u8 flags;
>> +	int cpuhp_prepare;
>>   
>>   	if (!kvm_para_available() || !kvmclock)
>>   		return;
>> @@ -325,8 +349,14 @@ void __init kvmclock_init(void)
>>   		return;
>>   	}
>>   
>> -	if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
>> -			      kvmclock_setup_percpu, NULL) < 0) {
>> +	cpuhp_prepare = cpuhp_setup_state(CPUHP_BP_PREPARE_DYN,
>> +					  "kvmclock:setup_percpu",
>> +					  kvmclock_setup_percpu, NULL);
>> +	if (cpuhp_prepare < 0)
>> +		return;
>> +	if (cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvmclock:cpu_offline",
>> +			      NULL, kvmclock_cpu_offline) < 0) {
>> +		cpuhp_remove_state(cpuhp_prepare);
> 
> In case we fail to set up kvmclock_cpu_offline() callback we get broken
> hybernation but without kvmclock_setup_percpu() call we get a broken
> guest (as kvmclock() may be the only reliable clocksource) so I'm not
> exactly sure we're active in a best way with cpuhp_remove_state()
> here. I don't feel strong though, I think it can stay but in that case
> I'd add a pr_warn() at least.

Something is seriously broken if either of these cpuhp_setup_state()
calls fail. I first considered using the "down" callback of the
CPUHP_BP_PREPARE_DYN state, as in:

         if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
			      kvmclock_setup_percpu, kvmclock_cpu_offline) < 0) {

This would have minimized the change, but I wasn't comfortable with how late
it would be called. Other examples in the kernel, including kvm.c, use
CPUHP_AP_ONLINE_DYN for cpu online/offline events.

But I do agree that a failure of either cpuhp_setup_state() should not
be silent. So in V2 I added a pr_err().

Thank you for your review comments.

                         -Lenny.

> 
>>   		return;
>>   	}
> 

