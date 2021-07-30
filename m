Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCC23DBC1A
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 17:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbhG3PWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 11:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239558AbhG3PWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 11:22:20 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE94EC06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 08:22:14 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id h2so18622204lfu.4
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 08:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/1o7+QKd97cIwS/kb/Ro1mV06vaGWcTs0D3fJHtTeso=;
        b=nVqXEBrlXTGcTUwaUH5Wm8FEDfko7xv0Xdqrq5ntdbi6gth09eo2rp2GDwyHrYvBtt
         qcCaJ8HQgf4tyQdQ6aro6IyWLEpR5ja2MABBOxIHdNHEOIYAAx4P6J0nwbLx1/VjwT3z
         MnxgpQjuj/UbcnSfMYqagxbISEsp7GkQYhqGVNHjVMqv0GR0qtz9XXiVfUvngr69Llko
         Zlutqz6DBFg76VF5mD1QAh2yDxoxr7I/kjDc3v6eRfwv/YBPGLIJ1G6ckwEqO9WL8UT4
         LTjGh2P4o7HCw6SZOwcuTIAbcdkvvScewj+4RG5cfRjkKrck+bbowZ88vu01qTxghj3R
         HVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/1o7+QKd97cIwS/kb/Ro1mV06vaGWcTs0D3fJHtTeso=;
        b=skE5X0Pt/L7yJnGB5NFVJPseL/hh+yTsHST59ud03vYRb8K7mhxKMD4KvcnRYQHq7+
         pDzuh7RD12rTpz6Fkaf0QVsXIVU0Xa6dGrVleoVNUUbfbtoKlQNIabYSH2y6rG2e9Min
         4mjV/IIQPZe0J2Y4jzCLz61TyCX2701rRvEdDNaF0aXz5GRosV6Pd8TwxNZzvPnEKd7l
         4/hdyzpf0tNUudSuWrihkcsC+KnBGJGv8R9ITZA5ySNbNDifegLat3dlo4l8TcJCR6ws
         1XvijAgf0kcDFb5oK36YxvRmEwyTX/ZUUZYx0Soh+TrXP3TiNMCbeNAoomVJWjdF9w1V
         owDA==
X-Gm-Message-State: AOAM532XTIR0bBY6t0D72IynqdaXXuW6469sO6BMvd/Wf0D3JRfGBw7a
        VhuJvfueFvi6SLKHaCj5mVfPDrAR0E6I1jfEZMwdEA==
X-Google-Smtp-Source: ABdhPJy3MzOJEL7JUXn3pv247OvpOyrn4DFM65cNNeDejFTsyvt+MsdJW5ifOeeaLmsG2MxQDXZ+nQuM/comVP/br64=
X-Received: by 2002:a05:6512:3d26:: with SMTP id d38mr2131778lfv.411.1627658532665;
 Fri, 30 Jul 2021 08:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com> <20210729173300.181775-12-oupton@google.com>
 <875yws2h5w.wl-maz@kernel.org>
In-Reply-To: <875yws2h5w.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 30 Jul 2021 08:22:01 -0700
Message-ID: <CAOQ_QsgCrEWQqakicR3Peu_c8oCMeq8Cok+CK8vJVURUwAdG0A@mail.gmail.com>
Subject: Re: [PATCH v5 11/13] KVM: arm64: Provide userspace access to the
 physical counter offset
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 4:08 AM Marc Zyngier <maz@kernel.org> wrote:
> > FEAT_ECV provides a guest physical counter-timer offset register
> > (CNTPOFF_EL2), but ECV-enabled hardware is nonexistent at the time of
> > writing so support for it was elided for the sake of the author :)
>
> You seem to have done most the work for that, and there are SW models
> out there that implement ECV. If anything, the ECV support should come
> first, and its emulation only as a poor man's workaround.
>
> It is also good to show silicon vendors that they suck at providing
> useful features, and pointing them to the code that would use these
> features *is* an incentive.

Lol, then so be it. I'll add ECV support to this series. What can I
test with, though? I don't recall QEMU supporting ECV last I checked..

> I really dislike the fallback to !vhe here. I'd rather you
> special-case the emulated ptimer in the VHE case:
>
>         if (has_vhe()) {
>                 map->direct_vtimer = vcpu_vtimer(vcpu);
>                 if (!timer_get_offset(vcpu_ptimer(vcpu)))
>                         map->direct_ptimer = vcpu_ptimer(vcpu);
>                         map->emul_ptimer = NULL;
>                 } else {
>                         map->direct_ptimer = NULL;
>                         map->emul_ptimer = vcpu_ptimer(vcpu);
>                 }
>         } else {

Ack.

> and you can drop the timer_emulation_required() helper which doesn't
> serve any purpose.

Especially if I add ECV to this series, I'd prefer to carry it than
open-code the check for CNTPOFF && !ECV in get_timer_map(). Do you
concur? I can tighten it to ptimer_emulation_required() and avoid
taking an arch_timer context if you prefer.

> > +static inline bool __hyp_handle_counter(struct kvm_vcpu *vcpu)
> > +{
> > +     u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
> > +     int rt = kvm_vcpu_sys_get_rt(vcpu);
> > +     u64 rv;
> > +
> > +     if (sysreg != SYS_CNTPCT_EL0)
>
> That's feels really optimistic. You don't check for the exception
> class, and pray that the bits will align? ;-)

Doh! Missed the EC check.

> Please don't add more small includes like this. It makes things hard
> to read and hides bugs

Ack.

> the counter read can (and will) be speculated,
> so you definitely need an ISB before the access. Please also look at
> __arch_counter_get_cntpct() and arch_counter_enforce_ordering().

Wouldn't it be up to the guest to decide if it wants the counter to be
speculated or not? I debated this a bit myself in the implementation,
as we would trap both ordered and un-ordered reads. Well, no way to
detect it :)

> >
> > -/*
> > - * Should only be called on non-VHE systems.
> > - * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
> > - */
>
> This comment still applies. this function *is* nVHE specific.
>

Ack.

>
> You now pay the price of reprogramming CNTHCTL_EL2 on every entry for
> VHE, and that's not right. On VHE, it should be enough to perform the
> programming on vcpu_load() only.
>

True. I'll rework the programming in the next series.

> Overall, this patch needs a bit of splitting up (userspace interface,
> HV rework), re-optimise VHE, and it *definitely* wants the ECV support
> for the physical timer.
>

Sure thing, thanks for the review Marc!

--
Best,
Oliver
