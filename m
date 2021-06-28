Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8A03B6695
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 18:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbhF1QWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 12:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhF1QWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 12:22:08 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC18C061574
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 09:19:41 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id v11-20020a4a8c4b0000b029024be8350c45so4866517ooj.12
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 09:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n0yIfbRDVNTq48IjodhdGwBC259FDu2ciPrbXRjaDZA=;
        b=V8sA/2Q/rE0AD0lqP8hoKODppfm4tqJXwNBDBQ2iMtsiiMSc4QLlU9bvkxWJNstrr0
         jq7UVJAECndSInY5ATFz4qqp+Qu2wQ9KYYvGPuJeMC1IPmeALyhnhKllpY1cD7LbzQGa
         vDX/A/wMj96fETOieSotDQ5J+aWnUbU3eJZo1tQDqr2LmIIXBCXcV2gglW3+tARST5Xx
         +nhB6qoJw9+hoFTWqOxJ5TmQs6t9I6C1cp5/TnUAXhMk+R0IIx3W+5VVz+3rbZqm63FI
         H1Lz+KCNaU4x5o02JigkG6irRaN2i7uJ1VzC8HQx9LCaZ4vbAIzcYJn8fk14r5GI5z8e
         OTZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n0yIfbRDVNTq48IjodhdGwBC259FDu2ciPrbXRjaDZA=;
        b=hVQ0gBSQoWlhcgr73AGc7EccUlzgmdJZ75qkEyPVrQHtk99hqMxlSeWqH4jGUV7u6H
         nCMYVf/n7+Jsr0CXgyQzuK9I8aAt6/5Qp08dnA/+dJEVIpuDUMJAvc9PRh017XE4yXLH
         YWHYN1AK9/TaZJ1D05a7rYCQ3tDIgYKvIH8HEWCZRY7mOsuHYVSbIUoLF9aheUQluM4E
         iBn0PwL1DXdbVvklBQrY6EoumiKfcVAvzriee5UJztn/3JERk6cae3BJ2OUyxu0VXQh7
         DNqa0Sbgax0XC89Y0/snzHC41CXn0RD+nfd22yiqa+us1N6dg0L8QtkfobfXlqnJ33X6
         iMOA==
X-Gm-Message-State: AOAM5316Ge7LEKpHSFghW12a9Iitsokhv87pXyxgftzR7zHJZQomiP6t
        Pcl/RU0wtgo/gg1l9cBgFbJ/aH0jSq9/e5CJfhJojA==
X-Google-Smtp-Source: ABdhPJzakioQYAbOXZmmviz7HOkn8ur2gCv1rmgHQ1eZePt706krGWr7/2MKnZs+qQs105Hegkdb74avhRhfV7EI0Tk=
X-Received: by 2002:a4a:6c0c:: with SMTP id q12mr174796ooc.81.1624897180105;
 Mon, 28 Jun 2021 09:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210627233819.857906-1-stsp2@yandex.ru>
In-Reply-To: <20210627233819.857906-1-stsp2@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 28 Jun 2021 09:19:28 -0700
Message-ID: <CALMp9eQdxTy4w6NBPbXbJEpyatYB_zhiwykRKCpeoC9Cbuv5gw@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Fix exception untrigger on ret to user
To:     Stas Sergeev <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 27, 2021 at 4:38 PM Stas Sergeev <stsp2@yandex.ru> wrote:
>
> When returning to user, the special care is taken about the
> exception that was already injected to VMCS but not yet to guest.
> cancel_injection removes such exception from VMCS. It is set as
> pending, and if the user does KVM_SET_REGS, it gets completely canceled.
>
> This didn't happen though, because the vcpu->arch.exception.injected
> and vcpu->arch.exception.pending were forgotten to update in
> cancel_injection. As the result, KVM_SET_REGS didn't cancel out
> anything, and the exception was re-injected on the next KVM_RUN,
> even though the guest registers (like EIP) were already modified.
> This was leading to an exception coming from the "wrong place".
>
> This patch makes sure the vcpu->arch.exception.injected and
> vcpu->arch.exception.pending are in sync with the reality (and
> with VMCS). Also it adds WARN_ON_ONCE() to __set_regs() to make
> sure vcpu->arch.exception.injected is never set here, because
> if it is, the exception context is going to be corrupted the same
> way it was before that patch.
> Adding WARN_ON_ONCE() alone, without the fix, was verified to
> actually trigger and detect a buggy scenario.
>
> Signed-off-by: Stas Sergeev <stsp2@yandex.ru>
>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Sean Christopherson <seanjc@google.com>
> CC: Vitaly Kuznetsov <vkuznets@redhat.com>
> CC: Wanpeng Li <wanpengli@tencent.com>
> CC: Jim Mattson <jmattson@google.com>
> CC: Joerg Roedel <joro@8bytes.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: x86@kernel.org
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: kvm@vger.kernel.org
> ---
>  arch/x86/kvm/x86.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0f4a46649d7..bc6ca8641824 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9450,7 +9450,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  cancel_injection:
>         if (req_immediate_exit)
>                 kvm_make_request(KVM_REQ_EVENT, vcpu);
> -       static_call(kvm_x86_cancel_injection)(vcpu);
> +       if (vcpu->arch.exception.injected) {
> +               static_call(kvm_x86_cancel_injection)(vcpu);
> +               vcpu->arch.exception.injected = false;
> +               vcpu->arch.exception.pending = true;
> +       }
>         if (unlikely(vcpu->arch.apic_attention))
>                 kvm_lapic_sync_from_vapic(vcpu);
>  out:
> @@ -9822,6 +9826,7 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>         kvm_rip_write(vcpu, regs->rip);
>         kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
>
> +       WARN_ON_ONCE(vcpu->arch.exception.injected);
>         vcpu->arch.exception.pending = false;
>
>         kvm_make_request(KVM_REQ_EVENT, vcpu);
> --
> 2.32.0
>

This doesn't work. Kvm has no facilities for converting an injected
exception back into a pending exception. In particular, if the
exception has side effects, such as a #PF which sets CR2, those side
effects have already taken place. Once kvm sets the VM-entry
interruption-information field, the next VM-entry must deliver that
exception. You could arrange to back it out, but you would also have
to back out the changes to CR2 (for #PF) or DR6 (for #DB).

Cancel_injection *should* leave the exception in the 'injected' state,
and KVM_SET_REGS *should not* clear an injected exception. (I don't
think it's right to clear a pending exception either, if that
exception happens to be a trap, but that's a different discussion).

It seems to me that the crux of the problem here is that
run->ready_for_interrupt_injection returns true when it should return
false. That's probably where you should focus your efforts.
