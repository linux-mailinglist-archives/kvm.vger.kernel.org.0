Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EC11BCF82
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 00:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgD1WNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 18:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726256AbgD1WND (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 18:13:03 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF75DC03C1AD
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 15:13:03 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k6so72187iob.3
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 15:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gnQqjUvKpyMsis4oOApN0h3EDNNd+Azb0xcg4b/vjcs=;
        b=kZzhRSnrJxZwXhdOI/fI3lvLpC+7xIFWoXU2sU0jetTYkdbg3ZN2tuAPVvpCEOnD+s
         k+q4hXVwXGUUr/swaxDajYb47LkgdTB5QaJMLnl2EwE2RgCEG5RqTvNEPqRWnh+Jx7t3
         +917jYC8s46KZ93AckNQFVpwJHqtII8pvAN1FaqddsQq89DZPdNpQXBWi5Ju5ifm54Lx
         bvPHuAL7AayMLfXES/RPI8iRUQwa2mQSr0vUIBT4WfW/Qmoqc6fV1Rhw/pCUprVpXIBR
         VG9aaxQXD8l7PeXXSFwtacF0ew+l9QCgqZKiLO+RQHGrmiLzHwNT4EfPbclFYTf/OrZ0
         fsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gnQqjUvKpyMsis4oOApN0h3EDNNd+Azb0xcg4b/vjcs=;
        b=AT9jw77mbhb4Pzp1V7C2H0qcLbqnHF/EbjTR7SidRhJRtKHLTDvAHYnsd0V/Z0VuSI
         FJT1FcY6i2whpw++PygqI/uTt0f13hte2YebYXPUxJi9nyL9qiCF8KYKcOBWrMfh8NJm
         W47iF/lqsMNxuRV3ZMUNnVRbpo+XEl2H19vZDZf3iWefeFduPQWSuX3tMA21NMnprxcm
         5KsWKHaO2YI/UmewMSAlcSBJUbmMAcCSpo27t7NmokzMNL8UZpm+TTIExpze4g9FbPpq
         2sY+p2HE+l5LNJehJJc0LxOBGRhaQJs4c1XFPTbo1YMof2H79lx8rOflfauwVhwJE3B5
         6mBw==
X-Gm-Message-State: AGi0PuYRX0lnJcNWV8+Uezb11/JfSBnzyjPoWqtOrzsP5Gno4xNLKY7g
        UvsbPlUUSpqiMU0mTIdJrnNUVT/XA9HETX7PEwtGPA==
X-Google-Smtp-Source: APiQypJhmdycxi2l+Whpqz2kZ3PEyv15q3UtEQ45cUy224IkB+0AEj7mEygJg53jPGHTjn9MGzrpV3m8W4RY61/MgCY=
X-Received: by 2002:a02:b09:: with SMTP id 9mr27125656jad.24.1588111982671;
 Tue, 28 Apr 2020 15:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-13-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-13-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 15:12:51 -0700
Message-ID: <CALMp9eTiGdYPpejAOLNz7zzqP1wPXb_zSL02F27VMHeHGzANJg@mail.gmail.com>
Subject: Re: [PATCH 12/13] KVM: x86: Replace late check_nested_events() hack
 with more precise fix
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Add a separate hook for checking if interrupt injection is blocked and
> use the hook to handle the case where an interrupt arrives between
> check_nested_events() and the injection logic.  Drop the retry of
> check_nested_events() that hack-a-fixed the same condition.
>
> Blocking injection is also a bit of a hack, e.g. KVM should do exiting
> and non-exiting interrupt processing in a single pass, but it's a more
> precise hack.  The old comment is also misleading, e.g. KVM_REQ_EVENT is
> purely an optimization, setting it on every run loop (which KVM doesn't
> do) should not affect functionality, only performance.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm/svm.c          |  1 +
>  arch/x86/kvm/vmx/vmx.c          | 13 +++++++++++++
>  arch/x86/kvm/x86.c              | 22 ++++------------------
>  4 files changed, 19 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 787636acd648..16fdeddb4a65 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1140,6 +1140,7 @@ struct kvm_x86_ops {
>         void (*queue_exception)(struct kvm_vcpu *vcpu);
>         void (*cancel_injection)(struct kvm_vcpu *vcpu);
>         bool (*interrupt_allowed)(struct kvm_vcpu *vcpu);
> +       bool (*interrupt_injection_allowed)(struct kvm_vcpu *vcpu);
>         bool (*nmi_allowed)(struct kvm_vcpu *vcpu);
>         bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
>         void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f21f734861dd..6d3ccbfc9e6a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3993,6 +3993,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>         .queue_exception = svm_queue_exception,
>         .cancel_injection = svm_cancel_injection,
>         .interrupt_allowed = svm_interrupt_allowed,
> +       .interrupt_injection_allowed = svm_interrupt_allowed,
>         .nmi_allowed = svm_nmi_allowed,
>         .get_nmi_mask = svm_get_nmi_mask,
>         .set_nmi_mask = svm_set_nmi_mask,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2f8cacb3aa9b..68b3748b5383 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4550,6 +4550,18 @@ static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
>         return !vmx_interrupt_blocked(vcpu);
>  }
>
> +static bool vmx_interrupt_injection_allowed(struct kvm_vcpu *vcpu)
> +{
> +       /*
> +        * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
> +        * e.g. if the IRQ arrived asynchronously after checking nested events.
> +        */
> +       if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
> +               return false;
> +
> +       return vmx_interrupt_allowed(vcpu);
> +}
> +
>  static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
>  {
>         int ret;
> @@ -7823,6 +7835,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>         .queue_exception = vmx_queue_exception,
>         .cancel_injection = vmx_cancel_injection,
>         .interrupt_allowed = vmx_interrupt_allowed,
> +       .interrupt_injection_allowed = vmx_interrupt_injection_allowed,
>         .nmi_allowed = vmx_nmi_allowed,
>         .get_nmi_mask = vmx_get_nmi_mask,
>         .set_nmi_mask = vmx_set_nmi_mask,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7c49a7dc601f..d9d6028a77e0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7755,24 +7755,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>                 --vcpu->arch.nmi_pending;
>                 vcpu->arch.nmi_injected = true;
>                 kvm_x86_ops.set_nmi(vcpu);
> -       } else if (kvm_cpu_has_injectable_intr(vcpu)) {
> -               /*
> -                * Because interrupts can be injected asynchronously, we are
> -                * calling check_nested_events again here to avoid a race condition.
> -                * See https://lkml.org/lkml/2014/7/2/60 for discussion about this
> -                * proposal and current concerns.  Perhaps we should be setting
> -                * KVM_REQ_EVENT only on certain events and not unconditionally?
> -                */
> -               if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
> -                       r = kvm_x86_ops.check_nested_events(vcpu);
> -                       if (r != 0)
> -                               return r;
> -               }
> -               if (kvm_x86_ops.interrupt_allowed(vcpu)) {
> -                       kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
> -                                           false);
> -                       kvm_x86_ops.set_irq(vcpu);
> -               }
> +       } else if (kvm_cpu_has_injectable_intr(vcpu) &&
> +                  kvm_x86_ops.interrupt_injection_allowed(vcpu)) {
> +               kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
> +               kvm_x86_ops.set_irq(vcpu);
>         }
So, that's what this mess was all about! Well, this certainly looks better.

Reviewed-by: Jim Mattson <jmattson@google.com>
