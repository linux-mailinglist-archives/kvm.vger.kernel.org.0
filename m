Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E1A34D5DB
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 19:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhC2RPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 13:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhC2RPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 13:15:16 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35345C061574
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 10:15:14 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bt4so6307634pjb.5
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 10:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4EOZ8Sb48l4lF5h6fA0NMs053uNtaYhsr8erjsTM8FY=;
        b=dJa0dz3LkHSAQnB1HnfNX988JAywvpjQ2nQa+OOmU1Q1d2DwIEnZq29hhBDzKdRxXE
         H2+gweAaru8FyL51vYdLZqQk+LlgGHXWU2s0AkLYMYDGjnZcmDOvU8R/mKFAC+qU1vIX
         XPAyDzVe8NSuyaZAg0cXmd0jGKW4a2IDnsE1zs/Ez/37HUKafd/J/R1ziPJCuX+I4Dpf
         Tw0jZTkcRBH3XrdNeYIA3KmJtNNy2CR8lFZ8Dx508atoQ9r9BethZLU06XK+K63gTZ+l
         2+FqHVY9ZlBOQ7IBm6r/u4vCEUGjGPj33ZrHyK8p+/GuDZNRufuBgGCB6P0PiBFmDIx3
         BvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4EOZ8Sb48l4lF5h6fA0NMs053uNtaYhsr8erjsTM8FY=;
        b=etWg7a0dQGTmcG4UyOudbNBUHJbizG2yVuATZU3zbCK/J/RWC00MYE+0tzmEYsi+8F
         krrLZo5xbINvscBuVl/Hp/KmVLlf+Unn4Hmj2sMMde5Xic/2jVuVhSQmvCzzNlTfbNKJ
         gdWQIFkgf7jWA3rIWD7qQqQVbyuCh/B5Z+agFnI2iQZ2pELHK9H1LhD3svyN6J7Z4Glh
         O42bdKqSwBV71qcbzElWAYsNfzOXHCnKsnItkZSBm34YBblOG1ts8Fm2CH+ito5OUUA2
         1TY+IQEyP+23D2qLY37t7uE53EtxN+yJq2cnpRM7rJCcY8twS/ZHIeGicvgrfJkeD8lz
         O1Cw==
X-Gm-Message-State: AOAM530jSe/Xp3ctC2ygH9NJ769L9F+xcOkdAMIjPgAfQjICs5ZuGB07
        sGdwpzp9Mq3v+pwvpAFdNjjEfa+HZd9fvQ==
X-Google-Smtp-Source: ABdhPJwUSjt0rB7FD0ZPLYYja1hZE1EpzcLffmT9z2Qr4zlV7MsvSmN97Oxmu4wf1Gm80JBrMXnHnQ==
X-Received: by 2002:a17:90b:3884:: with SMTP id mu4mr152309pjb.128.1617038113480;
        Mon, 29 Mar 2021 10:15:13 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d2sm7379997pgp.47.2021.03.29.10.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 10:15:12 -0700 (PDT)
Date:   Mon, 29 Mar 2021 17:15:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: X86: Properly account for guest CPU time when
 considering context tracking
Message-ID: <YGILHM7CHpjXtxaH@google.com>
References: <1617011036-11734-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617011036-11734-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Thomas

On Mon, Mar 29, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> The bugzilla https://bugzilla.kernel.org/show_bug.cgi?id=209831 
> reported that the guest time remains 0 when running a while true 
> loop in the guest.
> 
> The commit 87fa7f3e98a131 ("x86/kvm: Move context tracking where it 
> belongs") moves guest_exit_irqoff() close to vmexit breaks the 
> tick-based time accouting when the ticks that happen after IRQs are 
> disabled are incorrectly accounted to the host/system time. This is 
> because we exit the guest state too early.
> 
> vtime-based time accounting is tied to context tracking, keep the 
> guest_exit_irqoff() around vmexit code when both vtime-based time 
> accounting and specific cpu is context tracking mode active. 
> Otherwise, leave guest_exit_irqoff() after handle_exit_irqoff() 
> and explicit IRQ window for tick-based time accouting.
> 
> Fixes: 87fa7f3e98a131 ("x86/kvm: Move context tracking where it belongs")
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/svm/svm.c | 3 ++-
>  arch/x86/kvm/vmx/vmx.c | 3 ++-
>  arch/x86/kvm/x86.c     | 2 ++
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 58a45bb..55fb5ce 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3812,7 +3812,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  	 * into world and some more.
>  	 */
>  	lockdep_hardirqs_off(CALLER_ADDR0);
> -	guest_exit_irqoff();
> +	if (vtime_accounting_enabled_this_cpu())
> +		guest_exit_irqoff();
>  
>  	instrumentation_begin();
>  	trace_hardirqs_off_finish();
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 32cf828..85695b3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6689,7 +6689,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  	 * into world and some more.
>  	 */
>  	lockdep_hardirqs_off(CALLER_ADDR0);
> -	guest_exit_irqoff();
> +	if (vtime_accounting_enabled_this_cpu())
> +		guest_exit_irqoff();

This looks ok, as CONFIG_CONTEXT_TRACKING and CONFIG_VIRT_CPU_ACCOUNTING_GEN are
selected by CONFIG_NO_HZ_FULL=y, and can't be enabled independently, e.g. the
rcu_user_exit() call won't be delayed because it will never be called in the
!vtime case.  But it still feels wrong poking into those details, e.g. it'll
be weird and/or wrong guest_exit_irqoff() gains stuff that isn't vtime specific.
Maybe that will never happen though?  And of course, my hack alternative also
pokes into the details[*].

Thomas, do you have an input on the least awful way to handle this?  My horrible
hack was to force PF_VCPU around the window where KVM handles IRQs after guest
exit.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d9f931c63293..6ddf341cd755 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9118,6 +9118,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();

+	/*
+	 * Temporarily pretend this task is running a vCPU when potentially
+	 * processing an IRQ exit, including the below opening of an IRQ
+	 * window.  Tick-based accounting of guest time relies on PF_VCPU
+	 * being set when the tick IRQ handler runs.
+	 */
+	current->flags |= PF_VCPU;
 	static_call(kvm_x86_handle_exit_irqoff)(vcpu);

 	/*
@@ -9132,6 +9139,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	++vcpu->stat.exits;
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
+	current->flags &= ~PF_VCPU;

 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;

[*]https://lkml.kernel.org/r/20210206004218.312023-1-seanjc@google.com

>  	instrumentation_begin();
>  	trace_hardirqs_off_finish();
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe806e8..234c8b3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9185,6 +9185,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	++vcpu->stat.exits;
>  	local_irq_disable();
>  	kvm_after_interrupt(vcpu);
> +	if (!vtime_accounting_enabled_this_cpu())
> +		guest_exit_irqoff();
>  
>  	if (lapic_in_kernel(vcpu)) {
>  		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
> -- 
> 2.7.4
> 
