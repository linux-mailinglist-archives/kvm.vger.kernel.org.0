Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12D648D204
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 06:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiAMFdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 00:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiAMFdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 00:33:38 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3CBC06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 21:33:38 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id m13so9183967pji.3
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 21:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p+r0LPZOfGniF2N+vDyRSD/lUF/vLa2MZKw07kH77DU=;
        b=SZXola/5bZftUkpaDVEqwhjFOzmbQ4qvJgirlkjTGO+p7XRCkKS0mIL+QCB+oBRQ0d
         tbpDHOZVuU+eOTTIPdwJc2/lc5azw/P37zrp8XxHq9/WglqfsBkzfUMSWfAlKtJkHK5H
         pF73lnEKuqYmguEZrk0ot0kx2MRFI6VND9TzMsF88+QD6IJ6a4bV/N/xf/OmhJmBzuDu
         yP1A4kLVy0QHAfUA/X0Z5vZBXLcYShP5s7QPcXnbqvKieYhDJTJuvnTeBYmLwnV+XtFx
         98Ve/5Hun9tjeK9nSBP7fhHmbelxDkYC/6CGldF0iB4JCYiiKc8S3dPWLuQt3VOBtT9u
         C8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p+r0LPZOfGniF2N+vDyRSD/lUF/vLa2MZKw07kH77DU=;
        b=wB+XYkBTETZoCdy1VcKwnktlUkkvA8Ka0qUzPrS61/wBt5/Z03T/NU3mlhTWplNFaU
         F/c+QeVv8aQrHDG7VIiygijxNykjrGn5WomAJarkj4JmgAuYfHl2sJPEAp5zvshQ0XEQ
         wat+5Sp5AP1pzGimZBKT98Fi9GlmVWkbtNffTPDPJiE8m5i5JTWLJDggDQm7qtQ9lQbY
         hHZAIXXKcuxrVuSp3M9BYCC1u2zE2iB8Z5/t7ZgkUfQyyejhIbgNdsrMu9LgX3nSMJPj
         TW8VnQ/LyWSYLoSfsy6Oi1XaqR6SSAN04N8A0hJ6ASEpK+O9ep7KSpJQCXV1o1Hxf4xB
         RW1A==
X-Gm-Message-State: AOAM53389iJFxZfnUliUOUjkeinVvYT6f0gh6nNfMIgyB+YvE2atQgx7
        +yrkntcYUWTpU5WhRP6rnAlR9BstMWjgjY2cwxT+tA==
X-Google-Smtp-Source: ABdhPJxRejhJ4rImaa5T0dvK3sqkItOKQW3Nq/2+rpgfD4lSO6ngdk1tncp/0Wak0SXUznMf9+X8ef+BRb0JTXBOn+Q=
X-Received: by 2002:a05:6a00:ccf:b0:4ba:ea96:dff with SMTP id
 b15-20020a056a000ccf00b004baea960dffmr2767397pfv.82.1642052017693; Wed, 12
 Jan 2022 21:33:37 -0800 (PST)
MIME-Version: 1.0
References: <20220110054042.1079932-1-reijiw@google.com> <YdwPCcZWD8Uc1eej@monolith.localdoman>
 <CAAeT=Fz1KPbpmcSbukBuGWMJH=V_oXAJoaDHAen_Gy9Qswo_1Q@mail.gmail.com>
 <875yqqtn5q.wl-maz@kernel.org> <Yd2sLbiw/XPCZe7q@monolith.localdoman>
In-Reply-To: <Yd2sLbiw/XPCZe7q@monolith.localdoman>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 12 Jan 2022 21:33:21 -0800
Message-ID: <CAAeT=Fx62SZJvQYfFWj2sA-pcvrghuh8dSGuAaAtYWnJ5T5HCA@mail.gmail.com>
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

Hi Marc and Alex,

On Tue, Jan 11, 2022 at 8:11 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi Marc,
>
> On Tue, Jan 11, 2022 at 01:30:41PM +0000, Marc Zyngier wrote:
> > On Tue, 11 Jan 2022 07:37:57 +0000,
> > Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > Hi Alex,
> > >
> > > On Mon, Jan 10, 2022 at 2:48 AM Alexandru Elisei
> > > <alexandru.elisei@arm.com> wrote:
> > > >
> > > > Hi Reiji,
> > > >
> > > > On Sun, Jan 09, 2022 at 09:40:41PM -0800, Reiji Watanabe wrote:
> > > > > vcpu_allowed_register_width() checks if all the VCPUs are either
> > > > > all 32bit or all 64bit.  Since the checking is done even for vCPUs
> > > > > that are not initialized (KVM_ARM_VCPU_INIT has not been done) yet,
> > > > > the non-initialized vCPUs are erroneously treated as 64bit vCPU,
> > > > > which causes the function to incorrectly detect a mixed-width VM.
> > > > >
> > > > > Fix vcpu_allowed_register_width() to skip the check for vCPUs that
> > > > > are not initialized yet.
> > > > >
> > > > > Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
> > > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > > ---
> > > > >  arch/arm64/kvm/reset.c | 11 +++++++++++
> > > > >  1 file changed, 11 insertions(+)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > > > > index 426bd7fbc3fd..ef78bbc7566a 100644
> > > > > --- a/arch/arm64/kvm/reset.c
> > > > > +++ b/arch/arm64/kvm/reset.c
> > > > > @@ -180,8 +180,19 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> > > > >       if (kvm_has_mte(vcpu->kvm) && is32bit)
> > > > >               return false;
> > > > >
> > > > > +     /*
> > > > > +      * Make sure vcpu->arch.target setting is visible from others so
> > > > > +      * that the width consistency checking between two vCPUs is done
> > > > > +      * by at least one of them at KVM_ARM_VCPU_INIT.
> > > > > +      */
> > > > > +     smp_mb();
> > > >
> > > > From ARM DDI 0487G.a, page B2-146 ("Data Memory Barrier (DMB)"):
> > > >
> > > > "The DMB instruction is a memory barrier instruction that ensures the relative
> > > > order of memory accesses before the barrier with memory accesses after the
> > > > barrier."
> > > >
> > > > I'm going to assume from the comment that you are referring to completion of
> > > > memory accesses ("Make sure [..] is visible from others"). Please correct me if
> > > > I am wrong. In this case, DMB ensures ordering of memory accesses with regards
> > > > to writes and reads, not *completion*.  Have a look at
> > > > tools/memory-model/litmus-tests/MP+fencewmbonceonce+fencermbonceonce.litmus for
> > > > the classic message passing example as an example of memory ordering.
> > > > Message passing and other patterns are also explained in ARM DDI 0487G.a, page
> > > > K11-8363.
> > > >
> > > > I'm not saying that your approach is incorrect, but the commit message should
> > > > explain what memory accesses are being ordered relative to each other and why.
> > >
> > > Thank you so much for the review.
> > > What I meant with the comment was:
> > > ---
> > >   DMB is used to make sure that writing @vcpu->arch.target, which is done
> > >   by kvm_vcpu_set_target() before getting here, is visible to other PEs
> > >   before the following kvm_for_each_vcpu iteration reads the other vCPUs'
> > >   target field.
> > > ---
> > > Did the comment become more clear ?? (Or do I use DMB incorrectly ?)
> > >
> > > > > +
> > > > >       /* Check that the vcpus are either all 32bit or all 64bit */
> > > > >       kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> > > > > +             /* Skip if KVM_ARM_VCPU_INIT is not done for the vcpu yet */
> > > > > +             if (tmp->arch.target == -1)
> > > > > +                     continue;
> > >
> > > I just noticed DMB(ishld) is needed here to assure ordering between
> > > reading tmp->arch.target and reading vcpu->arch.features for this fix.
> > > Similarly, kvm_vcpu_set_target() needs DMB(ishst) to assure ordering
> > > between writing vcpu->arch.features and writing vcpu->arch.target...
> > > I am going to fix them in the v2 series.
> >
> > Yes, you'd need at least this, and preferably in their smp_rmb/wmb
> > variants.
> >
> > However, this looks like a pretty fragile construct, as there are
> > multiple paths where we can change target (including some error
> > paths from the run loop).
> >
> > I'd rather all changes to target and the feature bits happen under the
> > kvm->lock, and take that lock when checking for consistency in
> > vcpu_allowed_register_width(), as this isn't a fast path. I wrote the
> > following, which is obviously incomplete and as usual untested.
>
> I think this is the better approach, because we also want to make sure that
> a PE observes changes to target and features as soon as they have been
> made, to avoid situations where one PE sets the target and the 32bit
> feature, and another PE reads the old values and skips the check, in which
> case memory ordering is not enough.

Thank you for the comments and the suggestion.
I will look into fixing this based on the suggestion.

Thanks,
Reiji




>
> Thanks,
> Alex
>
> >
> > Thanks,
> >
> >       M.
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e4727dc771bf..42f2ab80646c 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1061,7 +1061,8 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
> >  static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >                              const struct kvm_vcpu_init *init)
> >  {
> > -     unsigned int i, ret;
> > +     unsigned int i;
> > +     int ret = 0;
> >       u32 phys_target = kvm_target_cpu();
> >
> >       if (init->target != phys_target)
> > @@ -1074,32 +1075,46 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >       if (vcpu->arch.target != -1 && vcpu->arch.target != init->target)
> >               return -EINVAL;
> >
> > +     /* Hazard against a concurent check of the target in kvm_reset_vcpu() */
> > +     mutex_lock(&vcpu->kvm->lock);
> > +
> >       /* -ENOENT for unknown features, -EINVAL for invalid combinations. */
> >       for (i = 0; i < sizeof(init->features) * 8; i++) {
> >               bool set = (init->features[i / 32] & (1 << (i % 32)));
> >
> > -             if (set && i >= KVM_VCPU_MAX_FEATURES)
> > -                     return -ENOENT;
> > +             if (set && i >= KVM_VCPU_MAX_FEATURES) {
> > +                     ret = -ENOENT;
> > +                     break;
> > +             }
> >
> >               /*
> >                * Secondary and subsequent calls to KVM_ARM_VCPU_INIT must
> >                * use the same feature set.
> >                */
> >               if (vcpu->arch.target != -1 && i < KVM_VCPU_MAX_FEATURES &&
> > -                 test_bit(i, vcpu->arch.features) != set)
> > -                     return -EINVAL;
> > +                 test_bit(i, vcpu->arch.features) != set) {
> > +                     ret = -EINVAL;
> > +                     break;
> > +             }
> >
> >               if (set)
> >                       set_bit(i, vcpu->arch.features);
> >       }
> >
> > -     vcpu->arch.target = phys_target;
> > +     if (!ret)
> > +             vcpu->arch.target = phys_target;
> > +
> > +     mutex_unlock(&vcpu->kvm->lock);
> > +     if (ret)
> > +             return ret;
> >
> >       /* Now we know what it is, we can reset it. */
> >       ret = kvm_reset_vcpu(vcpu);
> >       if (ret) {
> > +             mutex_lock(&vcpu->kvm->lock);
> >               vcpu->arch.target = -1;
> >               bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> > +             mutex_unlock(&vcpu->kvm->lock);
> >       }
> >
> >       return ret;
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index ef78bbc7566a..fae88a703140 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -180,13 +180,6 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> >       if (kvm_has_mte(vcpu->kvm) && is32bit)
> >               return false;
> >
> > -     /*
> > -      * Make sure vcpu->arch.target setting is visible from others so
> > -      * that the width consistency checking between two vCPUs is done
> > -      * by at least one of them at KVM_ARM_VCPU_INIT.
> > -      */
> > -     smp_mb();
> > -
> >       /* Check that the vcpus are either all 32bit or all 64bit */
> >       kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> >               /* Skip if KVM_ARM_VCPU_INIT is not done for the vcpu yet */
> > @@ -222,14 +215,19 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >  {
> >       struct vcpu_reset_state reset_state;
> > -     int ret;
> > +     int ret = -EINVAL;
> >       bool loaded;
> >       u32 pstate;
> >
> >       mutex_lock(&vcpu->kvm->lock);
> > -     reset_state = vcpu->arch.reset_state;
> > -     WRITE_ONCE(vcpu->arch.reset_state.reset, false);
> > +     if (vcpu_allowed_register_width(vcpu)) {
> > +             reset_state = vcpu->arch.reset_state;
> > +             WRITE_ONCE(vcpu->arch.reset_state.reset, false);
> > +             ret = 0;
> > +     }
> >       mutex_unlock(&vcpu->kvm->lock);
> > +     if (ret)
> > +             goto out;
> >
> >       /* Reset PMU outside of the non-preemptible section */
> >       kvm_pmu_vcpu_reset(vcpu);
> > @@ -257,11 +255,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >               }
> >       }
> >
> > -     if (!vcpu_allowed_register_width(vcpu)) {
> > -             ret = -EINVAL;
> > -             goto out;
> > -     }
> > -
> >       switch (vcpu->arch.target) {
> >       default:
> >               if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
> >
> > --
> > Without deviation from the norm, progress is not possible.
