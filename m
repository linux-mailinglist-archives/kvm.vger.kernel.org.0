Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F5233F129
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 14:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhCQNbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 09:31:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230331AbhCQNav (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 09:30:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615987851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tPNFSfNB6p+yJ3oKcYm7yhqfHOqwB/rvOL94ppns3z4=;
        b=Bg0PVhhK6GR/SWNed34uy1wTEvaDS1/Y8IMeGJeABJ4q6i/JXPlzyXBVdmxEXmqVeoiZRE
        9yBnJelQNluuzMZbLT/Lx3UfnB7R93vh17T2qKNYR2sbPPc4QLve2DE+Devxx2PbmhGLLT
        GYmynaGJuv/RBM4+kcxeV1afUD/oglc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-MbbrA2MUM7ySlnl0h_7h5A-1; Wed, 17 Mar 2021 09:30:48 -0400
X-MC-Unique: MbbrA2MUM7ySlnl0h_7h5A-1
Received: by mail-ed1-f70.google.com with SMTP id i6so19468302edq.12
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 06:30:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tPNFSfNB6p+yJ3oKcYm7yhqfHOqwB/rvOL94ppns3z4=;
        b=UZma63vyL+ugHUa0OUSMOzd77Y6FMTckJcRbeZs99vdtNM7tj6aBWefKym6pYk1TgG
         9Anvk8YSK6Ed+F4LWoVq6h3Zknpwx5EtiVCtw4E1LY1LL+rldn40V+cbPG8MfB5suOMQ
         Oc+WkIA7tl2VB3J3CX1wSj0St4UgTh47rg/P1HVcwFab1zK+Pu7ogSu48STHoxokN3Ji
         d5yriiYneq8juJOL0eSW5Yyo1JfX97cnIwU5rGsAJHYKHNJ+JxK0yjR1ubxnPUzY+Hp5
         GUXx54MY6/sokDr+2DQummVffL5hjGPzNVzfE79bEcJzjTWqJ7HjUKgeURlZDnsBuaG8
         koWg==
X-Gm-Message-State: AOAM533ah+VHf64Bh7Lc7OltWZUlRC1F1Qqx3vtEkHVGWxI04wOgf1Hq
        6j/hGTnPk9qAdd1Vn00N80X9hkQeo0Fw5j2DtVQj5LqWmf9GDQ7Y7e4WRgX1R/VYgF4Gk2IRNgP
        kOUL68z7+/LB4
X-Received: by 2002:a05:6402:888:: with SMTP id e8mr41146977edy.51.1615987847496;
        Wed, 17 Mar 2021 06:30:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtfPFBtob+QS+AgsVD1O9FUMF3KpeNixXiQo7UStUuzmD2EXfxhFGoVaizdbjA5R21sBc89A==
X-Received: by 2002:a05:6402:888:: with SMTP id e8mr41146943edy.51.1615987847291;
        Wed, 17 Mar 2021 06:30:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v8sm12698750edx.38.2021.03.17.06.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 06:30:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Lenny Szubowicz <lszubowi@redhat.com>, pbonzini@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/kvmclock: Stop kvmclocks for hibernate restore
In-Reply-To: <20210311132847.224406-1-lszubowi@redhat.com>
References: <20210311132847.224406-1-lszubowi@redhat.com>
Date:   Wed, 17 Mar 2021 14:30:45 +0100
Message-ID: <87sg4t7vqy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lenny Szubowicz <lszubowi@redhat.com> writes:

> Turn off host updates to the registered kvmclock memory
> locations when transitioning to a hibernated kernel in
> resume_target_kernel().
>
> This is accomplished for secondary vcpus by disabling host
> clock updates for that vcpu when it is put offline. For the
> primary vcpu, it's accomplished by using the existing call back
> from save_processor_state() to kvm_save_sched_clock_state().
>
> The registered kvmclock memory locations may differ between
> the currently running kernel and the hibernated kernel, which
> is being restored and resumed. Kernel memory corruption is thus
> possible if the host clock updates are allowed to run while the
> hibernated kernel is relocated to its original physical memory
> locations.
>
> This is similar to the problem solved for kexec by
> commit 1e977aa12dd4 ("x86: KVM guest: disable clock before rebooting.")
>
> Commit 95a3d4454bb1 ("x86/kvmclock: Switch kvmclock data to a
> PER_CPU variable") innocently increased the exposure for this
> problem by dynamically allocating the physical pages that are
> used for host clock updates when the vcpu count exceeds 64.
> This increases the likelihood that the registered kvmclock
> locations will differ for vcpus above 64.
>
> Reported-by: Xiaoyi Chen <cxiaoyi@amazon.com>
> Tested-by: Mohamed Aboubakr <mabouba@amazon.com>
> Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
> ---
>  arch/x86/kernel/kvmclock.c | 34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index aa593743acf6..291ffca41afb 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -187,8 +187,18 @@ static void kvm_register_clock(char *txt)
>  	pr_info("kvm-clock: cpu %d, msr %llx, %s", smp_processor_id(), pa, txt);
>  }
>  
> +/*
> + * Turn off host clock updates to the registered memory location when the
> + * cpu clock context is saved via save_processor_state(). Enables correct
> + * handling of the primary cpu clock when transitioning to a hibernated
> + * kernel in resume_target_kernel(), where the old and new registered
> + * memory locations may differ.
> + */
>  static void kvm_save_sched_clock_state(void)
>  {
> +	native_write_msr(msr_kvm_system_time, 0, 0);
> +	kvm_disable_steal_time();
> +	pr_info("kvm-clock: cpu %d, clock stopped", smp_processor_id());
>  }

Nitpick: should we rename kvm_save_sched_clock_state() to something more
generic, like kvm_disable_host_clock_updates() to indicate, that what it
does is not only sched clock related?

>  
>  static void kvm_restore_sched_clock_state(void)
> @@ -311,9 +321,23 @@ static int kvmclock_setup_percpu(unsigned int cpu)
>  	return p ? 0 : -ENOMEM;
>  }
>  
> +/*
> + * Turn off host clock updates to the registered memory location when a
> + * cpu is placed offline. Enables correct handling of secondary cpu clocks
> + * when transitioning to a hibernated kernel in resume_target_kernel(),
> + * where the old and new registered memory locations may differ.
> + */
> +static int kvmclock_cpu_offline(unsigned int cpu)
> +{
> +	native_write_msr(msr_kvm_system_time, 0, 0);
> +	pr_info("kvm-clock: cpu %d, clock stopped", cpu);

I'd say this pr_info() is superfluous: on a system with hundereds of
vCPUs users will get flooded with 'clock stopped' messages which don't
actually mean much: in case native_write_msr() fails the error gets
reported in dmesg anyway. I'd suggest we drop this and pr_info() in
kvm_save_sched_clock_state().

> +	return 0;

Why don't we disable steal time accounting here? MSR_KVM_STEAL_TIME is
also per-cpu. Can we merge kvm_save_sched_clock_state() with
kvmclock_cpu_offline() maybe?

> +}
> +
>  void __init kvmclock_init(void)
>  {
>  	u8 flags;
> +	int cpuhp_prepare;
>  
>  	if (!kvm_para_available() || !kvmclock)
>  		return;
> @@ -325,8 +349,14 @@ void __init kvmclock_init(void)
>  		return;
>  	}
>  
> -	if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
> -			      kvmclock_setup_percpu, NULL) < 0) {
> +	cpuhp_prepare = cpuhp_setup_state(CPUHP_BP_PREPARE_DYN,
> +					  "kvmclock:setup_percpu",
> +					  kvmclock_setup_percpu, NULL);
> +	if (cpuhp_prepare < 0)
> +		return;
> +	if (cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvmclock:cpu_offline",
> +			      NULL, kvmclock_cpu_offline) < 0) {
> +		cpuhp_remove_state(cpuhp_prepare);

In case we fail to set up kvmclock_cpu_offline() callback we get broken
hybernation but without kvmclock_setup_percpu() call we get a broken
guest (as kvmclock() may be the only reliable clocksource) so I'm not
exactly sure we're active in a best way with cpuhp_remove_state()
here. I don't feel strong though, I think it can stay but in that case
I'd add a pr_warn() at least.

>  		return;
>  	}

-- 
Vitaly

