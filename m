Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986EB338301
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 02:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhCLBFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 20:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhCLBFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 20:05:46 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60300C061574;
        Thu, 11 Mar 2021 17:05:46 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id j8so2795342otc.0;
        Thu, 11 Mar 2021 17:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5SYaXQLIqyaer8EuCYNbusIcFmIirlDAWN03ePWYWs4=;
        b=gd8o4OdXvOAJi0Q38livS2n+f8PTgyQOTxb26aXG4P4ZSp6l/4ugq2RHlT0Jiqk4IR
         RBaDqN/+EUS3N18fibeHsIqlLfC1btUqSmk5NgpNaNcE2Z2FAIv8drmd60vgXPurw5QL
         bmma55CdX+vSocYRtus0QWtlDw5PZYwgk/E4LzMQCLh3340heiahMz3o2ZBkxQ6/iT3z
         vJ98X596chB+TI12I0iaXM40oTD7/fo79Mln5ddp7wQ4xB858tM3cH8hkpeknZAnyjbz
         r0AAkFWB6lDliLFbPT9F/lheMgIdfi1b1Aah5Fj52ncDpgxvCzIo1DjkAAidX3qch5AD
         2qJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5SYaXQLIqyaer8EuCYNbusIcFmIirlDAWN03ePWYWs4=;
        b=bfBOkriIr3OVq83wUrajUhfuWgBxqu6mr8tDAhNW1f9TF3pM5uGZPo80YWID9mXF3X
         q67rOZ+ZRqaD6R7GRqBrMpVFkuqYVa71HUoetllHbncz+zvAtzaAxBfQof/adH2MnPy6
         a1iNQJPTRqbfx70MXTotonqUMKxUey4Uiz123HC1/XXt/C9n/U70EiByNhWK3UkT0PBW
         GFlYRD4lBcKGDob8+6zvQHKote0oUBJ5eNR8r1Og2PaBwkJNTp3YW11BzoIppvxt1Jc2
         QTTuv00abG2It1bIwTyRtN8A28UNH0VV5OxesOpzz+Z49btWP5GpdBGvaqMo+qyFbzb6
         YuJw==
X-Gm-Message-State: AOAM5311bgc6pbrYZcOEwc5uPCmvjf92LRcEjJpNEPEIyTowTDEJdOTf
        LMW0t8whdBsUtGxvJ7jjFELoBbqjtzO9Nh3pzjw9n9q0
X-Google-Smtp-Source: ABdhPJzv0EYzeejEWqZ5U/HN8P+FSZpUcUwXbbEQcMUYfXBXJous1D2wMLOOgw5yQhJ3T7psZjOAoPVcm9SVaYFfink=
X-Received: by 2002:a05:6830:22c3:: with SMTP id q3mr1419618otc.56.1615511145713;
 Thu, 11 Mar 2021 17:05:45 -0800 (PST)
MIME-Version: 1.0
References: <20210305021808.3769732-1-seanjc@google.com>
In-Reply-To: <20210305021808.3769732-1-seanjc@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 12 Mar 2021 09:05:34 +0800
Message-ID: <CANRm+CwNL8Ng_apOXZj1kKo=vqZJ243dzOmpU==J-dyz3V5oPg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Ensure deadline timer has truly expired before
 posting its IRQ
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Mar 2021 at 10:19, Sean Christopherson <seanjc@google.com> wrote:
>
> When posting a deadline timer interrupt, open code the checks guarding
> __kvm_wait_lapic_expire() in order to skip the lapic_timer_int_injected()
> check in kvm_wait_lapic_expire().  The injection check will always fail
> since the interrupt has not yet be injected.  Moving the call after
> injection would also be wrong as that wouldn't actually delay delivery
> of the IRQ if it is indeed sent via posted interrupt.
>
> Fixes: 010fd37fddf6 ("KVM: LAPIC: Reduce world switch latency caused by timer_advance_ns")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 45d40bfacb7c..cb8ebfaccfb6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1642,7 +1642,16 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
>         }
>
>         if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
> -               kvm_wait_lapic_expire(vcpu);
> +               /*
> +                * Ensure the guest's timer has truly expired before posting an
> +                * interrupt.  Open code the relevant checks to avoid querying
> +                * lapic_timer_int_injected(), which will be false since the
> +                * interrupt isn't yet injected.  Waiting until after injecting
> +                * is not an option since that won't help a posted interrupt.
> +                */
> +               if (vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
> +                   vcpu->arch.apic->lapic_timer.timer_advance_ns)
> +                       __kvm_wait_lapic_expire(vcpu);

Thanks for the fixing.

    Wanpeng
