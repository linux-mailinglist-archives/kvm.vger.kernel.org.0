Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D757D7CF7A6
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 13:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbjJSL42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 07:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345399AbjJSL40 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 07:56:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E532C132
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 04:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697716537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JG4lTBZAdQNjQdsOUJfgsaU+O9WpyXKgw/EAl16ov/Y=;
        b=gOudsoRwwVFKdJpvQ+05OK4tNUuOPajXCuhfdvcrX/PTywGA74oQWp+7nhcnufefKnO1FM
        RxFKuTNXaL3KYa4pGH/maZOY9ThlsfcohQHKHpM2r5qieh3WV3UGu78gR6vGNP1WewQ0Ut
        AlJeM9wqSkJWze/7YqduHLv9P67aBSk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-hAOqE7dHN623aqRvIW7sPA-1; Thu, 19 Oct 2023 07:55:35 -0400
X-MC-Unique: hAOqE7dHN623aqRvIW7sPA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9b97f1b493dso574355766b.3
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 04:55:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697716534; x=1698321334;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JG4lTBZAdQNjQdsOUJfgsaU+O9WpyXKgw/EAl16ov/Y=;
        b=YPJ7YxuuOgBYG/wszC7cWrsjVamI046nM8QMKBH39WgH5iw1B0C7ZdA9GktpOUw/iV
         /estwyy5dGNB19UkJMTVufjN4vsvLIvnGFK6qZQzsvWK2dO3hPokz5aS20mbkuQcLB59
         QuRyvPa25PNmQJceFkLeKicGXN/rhTq4GHfZaLWg7ebm4miKjQEacsAkRIyNlwCfNOwm
         MRQlfoQAyYvAbQBzBL4A+XQVb2Q3WCnmCmb7vqC3TS3WJN1c8ZFYCVVObhGu+D5FfF3o
         r0KFg97hXbHwhl87NHg69vQadIJ+radGONczKdh0RxTMAxsA8hLGwQek2F1OzSSkeo2d
         SAug==
X-Gm-Message-State: AOJu0YzUO0wF1/iYEZ6IejbEpsGhlO6DPUokC71aFpJA2hmXQmh9QVVh
        QTNLaqALJMHeK317mxqlA59SFQVj/184al0sJ+LqvNVKsEY0NOkTmTFQo7PmgcZHPq3uUdC3457
        oVa6Fu0vk7bCJ
X-Received: by 2002:a17:907:7f0f:b0:9c4:d19:4a6a with SMTP id qf15-20020a1709077f0f00b009c40d194a6amr1860675ejc.53.1697716534555;
        Thu, 19 Oct 2023 04:55:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9mIPgfvn9ZU7nuvj7xbGgy8xMbs+UZxNrZmJKG1kLP0WAJ1c7LQRgVQvXQZF9O5leQxJekQ==
X-Received: by 2002:a17:907:7f0f:b0:9c4:d19:4a6a with SMTP id qf15-20020a1709077f0f00b009c40d194a6amr1860648ejc.53.1697716534168;
        Thu, 19 Oct 2023 04:55:34 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id hb6-20020a170906b88600b009b8dbdd5203sm3372788ejb.107.2023.10.19.04.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 04:55:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        pv-drivers@vmware.com, xen-devel@lists.xenproject.org,
        linux-hyperv@vger.kernel.org
Cc:     jgross@suse.com, akaher@vmware.com, amakhalov@vmware.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, peterz@infradead.org, seanjc@google.com,
        dwmw2@infradead.org, joe.jin@oracle.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/1] x86/paravirt: introduce param to disable pv
 sched_clock
In-Reply-To: <20231018221123.136403-1-dongli.zhang@oracle.com>
References: <20231018221123.136403-1-dongli.zhang@oracle.com>
Date:   Thu, 19 Oct 2023 13:55:32 +0200
Message-ID: <87ttqm6d3f.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dongli Zhang <dongli.zhang@oracle.com> writes:

> As mentioned in the linux kernel development document, "sched_clock() is
> used for scheduling and timestamping". While there is a default native
> implementation, many paravirtualizations have their own implementations.
>
> About KVM, it uses kvm_sched_clock_read() and there is no way to only
> disable KVM's sched_clock. The "no-kvmclock" may disable all
> paravirtualized kvmclock features.
>
>  94 static inline void kvm_sched_clock_init(bool stable)
>  95 {
>  96         if (!stable)
>  97                 clear_sched_clock_stable();
>  98         kvm_sched_clock_offset = kvm_clock_read();
>  99         paravirt_set_sched_clock(kvm_sched_clock_read);
> 100
> 101         pr_info("kvm-clock: using sched offset of %llu cycles",
> 102                 kvm_sched_clock_offset);
> 103
> 104         BUILD_BUG_ON(sizeof(kvm_sched_clock_offset) >
> 105                 sizeof(((struct pvclock_vcpu_time_info *)NULL)->system_time));
> 106 }
>
> There is known issue that kvmclock may drift during vCPU hotplug [1].
> Although a temporary fix is available [2], we may need a way to disable pv
> sched_clock. Nowadays, the TSC is more stable and has less performance
> overhead than kvmclock.
>
> This is to propose to introduce a global param to disable pv sched_clock
> for all paravirtualizations.
>
> Please suggest and comment if other options are better:
>
> 1. Global param (this RFC patch).
>
> 2. The kvmclock specific param (e.g., "no-vmw-sched-clock" in vmware).
>
> Indeed I like the 2nd method.
>
> 3. Enforce native sched_clock only when TSC is invariant (hyper-v method).
>
> 4. Remove and cleanup pv sched_clock, and always use pv_sched_clock() for
> all (suggested by Peter Zijlstra in [3]). Some paravirtualizations may
> want to keep the pv sched_clock.

Normally, it should be up to the hypervisor to tell the guest which
clock to use, i.e. if TSC is reliable or not. Let me put my question
this way: if TSC on the particular host is good for everything, why
does the hypervisor advertises 'kvmclock' to its guests? If for some
'historical reasons' we can't revoke features we can always introduce a
new PV feature bit saying that TSC is preferred.

1) Global param doesn't sound like a good idea to me: chances are that
people will be setting it on their guest images to workaround problems
on one hypervisor (or, rather, on one public cloud which is too lazy to
fix their hypervisor) while simultaneously creating problems on another.

2) KVM specific parameter can work, but as KVM's sched_clock is the same
as kvmclock, I'm not convinced it actually makes sense to separate the
two. Like if sched_clock is known to be bad but TSC is good, why do we
need to use PV clock at all? Having a parameter for debugging purposes
may be OK though...

3) This is Hyper-V specific, you can see that it uses a dedicated PV bit
(HV_ACCESS_TSC_INVARIANT) and not the architectural
CPUID.80000007H:EDX[8]. I'm not sure we can blindly trust the later on
all hypervisors.

4) Personally, I'm not sure that relying on 'TSC is crap' detection is
100% reliable. I can imagine cases when we can't detect that fact that
while synchronized across CPUs and not going backwards, it is, for
example, ticking with an unstable frequency and PV sched clock is
supposed to give the right correction (all of them are rdtsc() based
anyways, aren't they?).

>
> To introduce a param may be easier to backport to old kernel version.
>
> References:
> [1] https://lore.kernel.org/all/20230926230649.67852-1-dongli.zhang@oracle.com/
> [2] https://lore.kernel.org/all/20231018195638.1898375-1-seanjc@google.com/
> [3] https://lore.kernel.org/all/20231002211651.GA3774@noisy.programming.kicks-ass.net/
>
> Thank you very much for the suggestion!
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  arch/x86/include/asm/paravirt.h |  2 +-
>  arch/x86/kernel/kvmclock.c      | 12 +++++++-----
>  arch/x86/kernel/paravirt.c      | 18 +++++++++++++++++-
>  3 files changed, 25 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 6c8ff12140ae..f36edf608b6b 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -24,7 +24,7 @@ u64 dummy_sched_clock(void);
>  DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
>  DECLARE_STATIC_CALL(pv_sched_clock, dummy_sched_clock);
>  
> -void paravirt_set_sched_clock(u64 (*func)(void));
> +int paravirt_set_sched_clock(u64 (*func)(void));
>  
>  static __always_inline u64 paravirt_sched_clock(void)
>  {
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index fb8f52149be9..0b8bf5677d44 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -93,13 +93,15 @@ static noinstr u64 kvm_sched_clock_read(void)
>  
>  static inline void kvm_sched_clock_init(bool stable)
>  {
> -	if (!stable)
> -		clear_sched_clock_stable();
>  	kvm_sched_clock_offset = kvm_clock_read();
> -	paravirt_set_sched_clock(kvm_sched_clock_read);
>  
> -	pr_info("kvm-clock: using sched offset of %llu cycles",
> -		kvm_sched_clock_offset);
> +	if (!paravirt_set_sched_clock(kvm_sched_clock_read)) {
> +		if (!stable)
> +			clear_sched_clock_stable();
> +
> +		pr_info("kvm-clock: using sched offset of %llu cycles",
> +			kvm_sched_clock_offset);
> +	}
>  
>  	BUILD_BUG_ON(sizeof(kvm_sched_clock_offset) >
>  		sizeof(((struct pvclock_vcpu_time_info *)NULL)->system_time));
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 97f1436c1a20..2cfef94317b0 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -118,9 +118,25 @@ static u64 native_steal_clock(int cpu)
>  DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
>  DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
>  
> -void paravirt_set_sched_clock(u64 (*func)(void))
> +static bool no_pv_sched_clock;
> +
> +static int __init parse_no_pv_sched_clock(char *arg)
> +{
> +	no_pv_sched_clock = true;
> +	return 0;
> +}
> +early_param("no_pv_sched_clock", parse_no_pv_sched_clock);
> +
> +int paravirt_set_sched_clock(u64 (*func)(void))
>  {
> +	if (no_pv_sched_clock) {
> +		pr_info("sched_clock: not configurable\n");
> +		return -EPERM;
> +	}
> +
>  	static_call_update(pv_sched_clock, func);
> +
> +	return 0;
>  }
>  
>  /* These are in entry.S */

-- 
Vitaly

