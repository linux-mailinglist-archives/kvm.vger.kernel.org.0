Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC83248A886
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 08:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348561AbiAKHiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 02:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348554AbiAKHiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 02:38:13 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB048C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 23:38:13 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so3567756pja.1
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 23:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HBoBxARFy6SiZCOUqHWoAIktNhDD0wIeh8v5etJtRL0=;
        b=dG9rZ6/KPAgg5bd6NGCUHnqsgIhd4w7VPxJwkXkBnApwI9RP2Dgsbr9D2kibr1TjRI
         pdlDC/l4wgCXS9xgWFzHKPlMxElVqrXrkVFF9FzpPZ3lfie/1HyHSmQE9L4c+C1lVWei
         HKYwCnjcUEe2slBq32vKucnEC+xL9vHu5CjvnB83K8hLHQrbKuEZJHYrNAgZpNL8bX8G
         fdOiGw+THUNwQI6CIpMDVvMoJwyhJKT4gzrwuGLLKf/oPH0w7zU9K79zCozscinN4MhQ
         +EfvmEX09MKhXFYPz63NToRSV/XcncBmzQzXz9KwdIaCBebAMdE0oZLL8mNEH2/xIhOe
         KsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HBoBxARFy6SiZCOUqHWoAIktNhDD0wIeh8v5etJtRL0=;
        b=vKathfWP4ZCE6VBka/XkI2xUHucrxDwW33rRYaHyzG6y7leAE4nP7Cqs3VijlADIDJ
         bNFLkb9Lt5HfHzWFiMdnq8+6ABdCYQrvww9+KUoAoXt/E5smWLg85GSn1KrpNQ8N8bxY
         vrkJPi69W3wrijSQGEyKPfp1g0GYa94yNZeA9JW9BS/Pvsf98E5htYFbXdVY+KpTPdpL
         DWpdbgmLX17xNGlioQ8GrqWgUVOxzcF5q0Kba4qOtGfj2lMyhcu3/PfPUoEy0FkIBQMD
         ze4u6oe89MH8r3BEesZCzCTz6SKK+uIx2Qpo++BWnSxuFCDfkbk9t3GSYMKGXHDbTlwQ
         z+fg==
X-Gm-Message-State: AOAM531Vl7ZBEvsHE1aa/RnyPCZoCyLzSsOdYqMh5wdyEXC2/BiH/71X
        FVOoPA46+e0O5KHBkiu7Au4V1jJB6gs1EQKMusn7mQ==
X-Google-Smtp-Source: ABdhPJzmEay6GVtLGwouJajZnWqAHtCasaWMKbzHB4cSv6G2FA84Dy86G0L0BmKsthK1kYxvXie5lEsLN/niFd22AQw=
X-Received: by 2002:a17:902:b908:b0:149:f6e8:7e0e with SMTP id
 bf8-20020a170902b90800b00149f6e87e0emr3229756plb.138.1641886692993; Mon, 10
 Jan 2022 23:38:12 -0800 (PST)
MIME-Version: 1.0
References: <20220110054042.1079932-1-reijiw@google.com> <YdwPCcZWD8Uc1eej@monolith.localdoman>
In-Reply-To: <YdwPCcZWD8Uc1eej@monolith.localdoman>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 Jan 2022 23:37:57 -0800
Message-ID: <CAAeT=Fz1KPbpmcSbukBuGWMJH=V_oXAJoaDHAen_Gy9Qswo_1Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: mixed-width check should be skipped for
 uninitialized vCPUs
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Mon, Jan 10, 2022 at 2:48 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi Reiji,
>
> On Sun, Jan 09, 2022 at 09:40:41PM -0800, Reiji Watanabe wrote:
> > vcpu_allowed_register_width() checks if all the VCPUs are either
> > all 32bit or all 64bit.  Since the checking is done even for vCPUs
> > that are not initialized (KVM_ARM_VCPU_INIT has not been done) yet,
> > the non-initialized vCPUs are erroneously treated as 64bit vCPU,
> > which causes the function to incorrectly detect a mixed-width VM.
> >
> > Fix vcpu_allowed_register_width() to skip the check for vCPUs that
> > are not initialized yet.
> >
> > Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/reset.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 426bd7fbc3fd..ef78bbc7566a 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -180,8 +180,19 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> >       if (kvm_has_mte(vcpu->kvm) && is32bit)
> >               return false;
> >
> > +     /*
> > +      * Make sure vcpu->arch.target setting is visible from others so
> > +      * that the width consistency checking between two vCPUs is done
> > +      * by at least one of them at KVM_ARM_VCPU_INIT.
> > +      */
> > +     smp_mb();
>
> From ARM DDI 0487G.a, page B2-146 ("Data Memory Barrier (DMB)"):
>
> "The DMB instruction is a memory barrier instruction that ensures the relative
> order of memory accesses before the barrier with memory accesses after the
> barrier."
>
> I'm going to assume from the comment that you are referring to completion of
> memory accesses ("Make sure [..] is visible from others"). Please correct me if
> I am wrong. In this case, DMB ensures ordering of memory accesses with regards
> to writes and reads, not *completion*.  Have a look at
> tools/memory-model/litmus-tests/MP+fencewmbonceonce+fencermbonceonce.litmus for
> the classic message passing example as an example of memory ordering.
> Message passing and other patterns are also explained in ARM DDI 0487G.a, page
> K11-8363.
>
> I'm not saying that your approach is incorrect, but the commit message should
> explain what memory accesses are being ordered relative to each other and why.

Thank you so much for the review.
What I meant with the comment was:
---
  DMB is used to make sure that writing @vcpu->arch.target, which is done
  by kvm_vcpu_set_target() before getting here, is visible to other PEs
  before the following kvm_for_each_vcpu iteration reads the other vCPUs'
  target field.
---
Did the comment become more clear ?? (Or do I use DMB incorrectly ?)

> > +
> >       /* Check that the vcpus are either all 32bit or all 64bit */
> >       kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> > +             /* Skip if KVM_ARM_VCPU_INIT is not done for the vcpu yet */
> > +             if (tmp->arch.target == -1)
> > +                     continue;

I just noticed DMB(ishld) is needed here to assure ordering between
reading tmp->arch.target and reading vcpu->arch.features for this fix.
Similarly, kvm_vcpu_set_target() needs DMB(ishst) to assure ordering
between writing vcpu->arch.features and writing vcpu->arch.target...
I am going to fix them in the v2 series.

Thanks,
Reiji

> > +
> >               if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
> >                       return false;
> >       }
> >
> > base-commit: df0cc57e057f18e44dac8e6c18aba47ab53202f9
> > --
> > 2.34.1.575.g55b058a8bb-goog
> >
