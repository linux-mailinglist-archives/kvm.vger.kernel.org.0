Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96BEC237AF
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732118AbfETMy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 08:54:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39244 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730323AbfETMy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 08:54:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id n25so12519412wmk.4
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 05:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U85pRBHGrRMlyH8JX2I6eaC18PlfD1m7nOZTuLAWrQI=;
        b=e5Bs/PwP39A58Uv0Hzm/OSBJxoQc7Iuwrf7CW3O6zt9il1SNGWNPAuSl/JaowrnVb6
         Fz1WsTQBAu0Z8ybsiS7vfYaqLJDBIL7+frNwyJW5MvRQ4R5pWLFP9BJnjhUTqH6trpVC
         miCY/EWif7FIoE8TTh9lCLQO8KhE8Jk2eMB8MyNBPjrI86bMQRgdrolpuLj2B6IGsENQ
         RJCJf1Lqh3PUj9xZKHVbMN/8p75DqbuXflZjxPgJedSiSftdQgRURqGvTMTP79wGYu2+
         xSMJDOQ+nKpS/AO09605hCLH8DCCMG1TSbGnC9eUU25pvK+iBFBm/o7ym9PvkTH3kWkf
         nWdw==
X-Gm-Message-State: APjAAAVAkooCcyCzow4RpdjtV0C1YY0kkphk5ZGU5tmvXwKsnY+7EVjz
        QxCrJqMMHjpLin2KmxfiZUL5dJll+kh9AQ==
X-Google-Smtp-Source: APXvYqyCGEuYfRU94pPQVHopuciZuEwYX+zbpJfBTwzG9/vB2G058y0rsvDZiyb/Isahg51AaIs+dQ==
X-Received: by 2002:a1c:e30a:: with SMTP id a10mr41644796wmh.128.1558356894653;
        Mon, 20 May 2019 05:54:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id b10sm40914348wrh.59.2019.05.20.05.54.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 05:54:54 -0700 (PDT)
Subject: Re: [PATCH] kvm: Check irqchip mode before assign irqfd
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20190505085642.6773-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <94af836c-762b-5986-2b94-bb979398a3df@redhat.com>
Date:   Mon, 20 May 2019 14:54:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505085642.6773-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/19 10:56, Peter Xu wrote:
> When assigning kvm irqfd we didn't check the irqchip mode but we allow
> KVM_IRQFD to succeed with all the irqchip modes.  However it does not
> make much sense to create irqfd even without the kernel chips.  Let's
> provide a arch-dependent helper to check whether a specific irqfd is
> allowed by the arch.  At least for x86, it should make sense to check:
> 
> - when irqchip mode is NONE, all irqfds should be disallowed, and,
> 
> - when irqchip mode is SPLIT, irqfds that are with resamplefd should
>   be disallowed.
> 
> For either of the case, previously we'll silently ignore the irq or
> the irq ack event if the irqchip mode is incorrect.  However that can
> cause misterious guest behaviors and it can be hard to triage.  Let's
> fail KVM_IRQFD even earlier to detect these incorrect configurations.
> 
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Radim Krčmář <rkrcmar@redhat.com>
> CC: Alex Williamson <alex.williamson@redhat.com>
> CC: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/irq.c | 7 +++++++
>  arch/x86/kvm/irq.h | 1 +
>  virt/kvm/eventfd.c | 9 +++++++++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index faa264822cee..007bc654f928 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -172,3 +172,10 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
>  	__kvm_migrate_apic_timer(vcpu);
>  	__kvm_migrate_pit_timer(vcpu);
>  }
> +
> +bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
> +{
> +	bool resample = args->flags & KVM_IRQFD_FLAG_RESAMPLE;
> +
> +	return resample ? irqchip_kernel(kvm) : irqchip_in_kernel(kvm);
> +}
> diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
> index d5005cc26521..fd210cdd4983 100644
> --- a/arch/x86/kvm/irq.h
> +++ b/arch/x86/kvm/irq.h
> @@ -114,6 +114,7 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
>  	return mode != KVM_IRQCHIP_NONE;
>  }
>  
> +bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
>  void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
>  void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
>  void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 001aeda4c154..3972a9564c76 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -44,6 +44,12 @@
>  
>  static struct workqueue_struct *irqfd_cleanup_wq;
>  
> +bool __attribute__((weak))
> +kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
> +{
> +	return true;
> +}
> +
>  static void
>  irqfd_inject(struct work_struct *work)
>  {
> @@ -297,6 +303,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	if (!kvm_arch_intc_initialized(kvm))
>  		return -EAGAIN;
>  
> +	if (!kvm_arch_irqfd_allowed(kvm, args))
> +		return -EINVAL;
> +
>  	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL_ACCOUNT);
>  	if (!irqfd)
>  		return -ENOMEM;
> 

Queued, thanks.

Paolo
