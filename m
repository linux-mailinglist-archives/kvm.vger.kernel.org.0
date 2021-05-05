Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D42437398D
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 13:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhEELiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 07:38:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51665 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232934AbhEELiN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 07:38:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620214637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C5Lah4Bb8DHKwVhTcxaDUF/2d0Qp2D0Gt9JdNQHVqpM=;
        b=cS8nttodLPIoZIbVgioB46dFRuxkbzBmW6AZDwgkbCquUe4YUdf980ieMNvIp99qr0les2
        d0dIngTa5tVU+NLToPWMNj9BibpmKXTZcqeCxv7hDAaciHEt9dI0kIQ1QytrS9UqcuuEAy
        nwgVIosjX8H8d5zZObIjbkz5tHSoQRA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-J9SQjKcyPiiVRJexcA_8sg-1; Wed, 05 May 2021 07:37:15 -0400
X-MC-Unique: J9SQjKcyPiiVRJexcA_8sg-1
Received: by mail-ej1-f72.google.com with SMTP id r14-20020a1709062cceb0290373a80b4002so331820ejr.20
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 04:37:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C5Lah4Bb8DHKwVhTcxaDUF/2d0Qp2D0Gt9JdNQHVqpM=;
        b=NJZvEeFZGJfd4Cr3TpYvU0G/uP5KhHRvaZdHuI5mrwB+45H6TxvnmjsycVsct74pU3
         8sTQ64yHG97Dq46GQpCOR+vRLHEhjwa5i4EA5cYpeL4KY+38UQuiKIRyJBZ92lrxZkcd
         mzNwGYtJ7lJWZBK5d2OvHZEWUR8IWUpfV9p4wv1L/664YMI9w5uB1Npv1SU15vMRjvOS
         MzjwLp0v2kA3BXEaANw2SVetPTzEyUjU+/yTOu1OTKSKT3n819M6FajmKSeh7PzZQbG8
         JQTf1bqWJJLgLx9cngIuODd5tfIf0jWc70iRkr0KTevUZOpF5N7fVFhR1hoQ47kAwucd
         XKhg==
X-Gm-Message-State: AOAM530lc5r6KlvMqISTUh52KsFDGWf6oZNk1/BGOyT5UiE9IP507Hen
        d7h1e/odGCkHsp6+Ad1STPFSSUZMaTbf1YQAf6xdqMLYqwJpbI/q17ZSaSywDSGdEFG4yBoktwD
        QVvlE2CbQldgH
X-Received: by 2002:a17:906:ce5a:: with SMTP id se26mr27558900ejb.332.1620214634249;
        Wed, 05 May 2021 04:37:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvqQBG09+x9kPbhc/155unYddBlPP6BJb1muXWMIK8OXYKn1M29PWBNb8X2eVyIfruqOJ9YQ==
X-Received: by 2002:a17:906:ce5a:: with SMTP id se26mr27558870ejb.332.1620214634029;
        Wed, 05 May 2021 04:37:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u25sm2780048ejb.12.2021.05.05.04.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 04:37:13 -0700 (PDT)
Subject: Re: [PATCH 4/6] kvm: Select SCHED_INFO instead of TASK_DELAY_ACCT
To:     Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
References: <20210505105940.190490250@infradead.org>
 <20210505111525.187225172@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4f35124c-1127-2629-2e00-800bc965e9f1@redhat.com>
Date:   Wed, 5 May 2021 13:37:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210505111525.187225172@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 12:59, Peter Zijlstra wrote:
> AFAICT KVM only relies on SCHED_INFO. Nothing uses the p->delays data
> that belongs to TASK_DELAY_ACCT.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Right, SCHED_INFO didn't exist at the time (it was introduced in 2015, 
while KVM started using run_delay in 2011).  I'm not sure if it could 
have used SCHEDSTATS instead.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> ---
>   arch/arm64/kvm/Kconfig |    5 +----
>   arch/x86/kvm/Kconfig   |    5 +----
>   2 files changed, 2 insertions(+), 8 deletions(-)
> 
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -20,8 +20,6 @@ if VIRTUALIZATION
>   menuconfig KVM
>   	bool "Kernel-based Virtual Machine (KVM) support"
>   	depends on OF
> -	# for TASKSTATS/TASK_DELAY_ACCT:
> -	depends on NET && MULTIUSER
>   	select MMU_NOTIFIER
>   	select PREEMPT_NOTIFIERS
>   	select HAVE_KVM_CPU_RELAX_INTERCEPT
> @@ -38,8 +36,7 @@ menuconfig KVM
>   	select IRQ_BYPASS_MANAGER
>   	select HAVE_KVM_IRQ_BYPASS
>   	select HAVE_KVM_VCPU_RUN_PID_CHANGE
> -	select TASKSTATS
> -	select TASK_DELAY_ACCT
> +	select SCHED_INFO
>   	help
>   	  Support hosting virtualized guest machines.
>   
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -22,8 +22,6 @@ config KVM
>   	tristate "Kernel-based Virtual Machine (KVM) support"
>   	depends on HAVE_KVM
>   	depends on HIGH_RES_TIMERS
> -	# for TASKSTATS/TASK_DELAY_ACCT:
> -	depends on NET && MULTIUSER
>   	depends on X86_LOCAL_APIC
>   	select PREEMPT_NOTIFIERS
>   	select MMU_NOTIFIER
> @@ -36,8 +34,7 @@ config KVM
>   	select KVM_ASYNC_PF
>   	select USER_RETURN_NOTIFIER
>   	select KVM_MMIO
> -	select TASKSTATS
> -	select TASK_DELAY_ACCT
> +	select SCHED_INFO
>   	select PERF_EVENTS
>   	select HAVE_KVM_MSI
>   	select HAVE_KVM_CPU_RELAX_INTERCEPT
> 
> 

