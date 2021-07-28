Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21503D89A2
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 10:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbhG1ISo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 04:18:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234487AbhG1ISj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 04:18:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627460318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=crKmmuF3vSFeLNrZsABSm5kyODHNC6gu4soJ8ICOTvw=;
        b=Y0qBJgnEXvh61l+Zk6jYrHPi9S+/aw3WwghmYkQGSTu86Fwt5HSx1oUgI3V85AE7A7GSmv
        APAdERDhD5gLJliAdbFhIoz7G/pZgzNl7oV7iaL2iNI7GwUbysRGdR+ZtPhw0XsPMYmMN7
        C4lmT2TI2oDkCbAU5kEUDUOldmxgGU4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-2wRsAZBoMY2jHt_ufrN2Vg-1; Wed, 28 Jul 2021 04:18:36 -0400
X-MC-Unique: 2wRsAZBoMY2jHt_ufrN2Vg-1
Received: by mail-ed1-f69.google.com with SMTP id c20-20020a0564021014b029039994f9cab9so851570edu.22
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 01:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=crKmmuF3vSFeLNrZsABSm5kyODHNC6gu4soJ8ICOTvw=;
        b=hsZaM86zR43r0ceAy+ZV7APkcvV2ffvi51zu2aJ0SNGyghaqksY/oWEdag5qj+dy+H
         3f8xiDG+1HbAeebm0tdP1FWbJvGGpn+Qj/4CH2wZ5n/z3Deg97cyPMDYfy+FOEOBu3n9
         aV8UwwjZ6PW5oYa009ZqcKujhCnJaLH1lnteo8wZjxMUmkRlQxxJj/IqgAKAO80mEPLp
         UXZ4Nb675rCv2A4gAkypCenTSBmSJV00KgGrn0nnNNg5C0ObUfGEr2TkmxpDL7bBGh7D
         hEdjWkaW9aacDZ6QCEjWCvA9UMmvxkhB3vhlqEO5VR1EMu/sNtGXQIWFx4Alzp+Yfc0L
         9lGQ==
X-Gm-Message-State: AOAM530z2kQ0n5kwbF0qOcifxFy+r6R+50rMQl58BrcoIgx121iZnir7
        VvzTvimvDfvpoxo0mbyyWgebGQM9GsMKZlwD3dZSDnC0kfiC6yHcZGV0IDEmAXHgmjyQ/UFxDmA
        K1OWLSiS1LyHP
X-Received: by 2002:a50:a456:: with SMTP id v22mr32224229edb.333.1627460315730;
        Wed, 28 Jul 2021 01:18:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRbmAu4lAhEfewYa9Hmlor8TFe5yKDcZw3jUIl3o2oxP/V0Eq5Q+BPPoJfCrH+1EnY8l1sBw==
X-Received: by 2002:a50:a456:: with SMTP id v22mr32224202edb.333.1627460315603;
        Wed, 28 Jul 2021 01:18:35 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h1sm1742941eji.46.2021.07.28.01.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 01:18:35 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     ssouhlal@FreeBSD.org, joelaf@google.com, senozhatsky@chromium.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [RFC PATCH 2/2] kvm,x86: Report preempt_count to host.
In-Reply-To: <20210728073700.120449-3-suleiman@google.com>
References: <20210728073700.120449-1-suleiman@google.com>
 <20210728073700.120449-3-suleiman@google.com>
Date:   Wed, 28 Jul 2021 10:18:33 +0200
Message-ID: <87tuke6ecm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suleiman Souhlal <suleiman@google.com> writes:

> When KVM_PREEMPT_COUNT_REPORTING is enabled, the host can use
> preempt_count to determine if the guest is in a critical section,
> if it also has CONFIG_KVM_HETEROGENEOUS_RT enabled, in order to
> use heterogeneous RT VCPU configurations.
>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  arch/x86/Kconfig      | 11 +++++++++++
>  arch/x86/kernel/kvm.c | 10 ++++++++++
>  2 files changed, 21 insertions(+)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 49270655e827..d8b62789df57 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -846,6 +846,17 @@ config PARAVIRT_TIME_ACCOUNTING
>  config PARAVIRT_CLOCK
>  	bool
>  
> +config KVM_PREEMPT_COUNT_REPORTING
> +	bool "KVM preempt_count reporting to the host"
> +	depends on KVM_GUEST && PREEMPT_COUNT
> +	default n
> +	help
> +	  Select this option to enable KVM preempt_count reporting to the host,
> +	  which can be useful in cases where some VCPUs are RT and the rest
> +	  aren't.
> +
> +	  If in doubt, say N here.
> +
>  config JAILHOUSE_GUEST
>  	bool "Jailhouse non-root cell support"
>  	depends on X86_64 && PCI
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a26643dc6bd6..7ec53ea3f979 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -363,6 +363,16 @@ static void kvm_guest_cpu_init(void)
>  
>  	if (has_steal_clock)
>  		kvm_register_steal_time();
> +
> +#ifdef CONFIG_KVM_PREEMPT_COUNT_REPORTING
> +	if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_COUNT)) {
> +		unsigned long pa;
> +
> +		pa = slow_virt_to_phys(this_cpu_ptr(&__preempt_count)) |
> +		    KVM_MSR_ENABLED;
> +		wrmsrl(MSR_KVM_PREEMPT_COUNT, pa);
> +	}
> +#endif
>  }

Please also disable the feature in kvm_guest_cpu_offline() as e.g. upon
kexec the memory address looses its meaning.

>  
>  static void kvm_pv_disable_apf(void)

-- 
Vitaly

