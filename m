Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE09C4AE96E
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 06:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiBIFmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 00:42:15 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiBIFdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 00:33:02 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B4FC002B5D
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 21:32:57 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso1192832pjh.5
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 21:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D7+YcMiVd9Hc5kLj7x+yGkNfQLVgsxIrCv5I0j/D974=;
        b=T/1vFjr/klDZo5A5X5ggCsvek2MMTbk5/3/i0aHupQOIkDv86nwidKxw/tbeAw4R19
         Tf1mQM82xZ4gsc6MAxi7PJemsCUcAWjT5AaDo5pBTyXIcNIhFanNPRxndhMgx3/04N+D
         DDhg91V0jNUa5K0L4nbzVAGhBAS8G1c7dihUsmbTmbEqTLwf6vO7U7rI4Z5g9tJ1T9CI
         Dh+fL1WOHq8aiEjwqYDP16LGjrmstu+zW7Uaf1XykxhMXWKDLSbs8gCpQoI/UHtsJrgJ
         hASFrEqTdoNJBXQXGj0i+uxaW+qCqcT1+vm9ttrv/slQzgYTh0BXNwAVHh/tCk9f+lSc
         sU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D7+YcMiVd9Hc5kLj7x+yGkNfQLVgsxIrCv5I0j/D974=;
        b=aImNLKVZlc/GSyKLWk7m35VTqqWbjk0wPIeXNe389NkWvUvbNbWstgPVl3ajv7dyph
         0efvFhvR6xFB1UACpQwk4aJ/0HBpxqXRNFOz6BDGjsLB5KLA+UfA5nhCm9yiuRYcbQP1
         TgK6EEUK1u/rV+Ja5Ku+Q1T+6erAmbUO7o4YN7A8Dhp5b7RYn2j0C0LaGTrbb+mZF8gn
         MEIdnRAVg3aPh+g8kabs4s8dnkRVoBzDc92iDlQWDe7TPc+T+mzBKQjWrE/vrVY0bIF1
         2EGyKl3HDILXouDHl9lRbPZroWhmEiHVmmurGFozofCGf5EM9RGdeG0q16pfrVxUVnDO
         YM5g==
X-Gm-Message-State: AOAM533+TWs/UIc7yDGyWNdLCNl2t9t8bNDvf5RIeGI78ISPutFCgYsP
        p2jbwChJTf98RmhCx9FyIbypUFCvfbEC/iySAqEGJg==
X-Google-Smtp-Source: ABdhPJznT0fnJAY2aJA3dYTn4irEUJ2fBda+hZqSpZYoIBeH+8guaG7eqjsRvBe9hvrs6mGMqzYzGv9YSYlFZfRrQ9s=
X-Received: by 2002:a17:902:bc83:: with SMTP id bb3mr573731plb.172.1644384772628;
 Tue, 08 Feb 2022 21:32:52 -0800 (PST)
MIME-Version: 1.0
References: <20220118041923.3384602-1-reijiw@google.com> <87a6f15skj.wl-maz@kernel.org>
In-Reply-To: <87a6f15skj.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 8 Feb 2022 21:32:36 -0800
Message-ID: <CAAeT=FwjcgTM0hKSERfVMYDvYWqdC+Deqd=x2xT=-Zymb6SLtA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Feb 8, 2022 at 6:41 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 18 Jan 2022 04:19:22 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > KVM allows userspace to configure either all 32bit or 64bit vCPUs
> > for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
> > if the vcpu's register width is consistent with all other vCPUs'.
> > Since the checking is done even against vCPUs that are not initialized
> > (KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
> > are erroneously treated as 64bit vCPU, which causes the function to
> > incorrectly detect a mixed-width VM.
> >
> > Introduce a new flag (el1_reg_width) in kvm_arch to indicates that
> > the guest needs to be configured with all 32bit or 64bit vCPUs,
> > and initialize it at the first KVM_ARM_VCPU_INIT for the guest.
> > Check vcpu's register width against the flag at the vcpu's
> > KVM_ARM_VCPU_INIT (instead of against other vCPUs' register width).
> >
> > Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++
> >  arch/arm64/kvm/arm.c              | 30 ++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/reset.c            |  8 --------
> >  3 files changed, 43 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 2a5f7f38006f..c02b7caf2c82 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -102,6 +102,12 @@ struct kvm_s2_mmu {
> >  struct kvm_arch_memory_slot {
> >  };
> >
> > +enum kvm_el1_reg_width {
> > +     EL1_WIDTH_UNINITIALIZED = 0,
> > +     EL1_32BIT,
> > +     EL1_64BIT,
> > +};
> > +
> >  struct kvm_arch {
> >       struct kvm_s2_mmu mmu;
> >
> > @@ -137,6 +143,13 @@ struct kvm_arch {
> >
> >       /* Memory Tagging Extension enabled for the guest */
> >       bool mte_enabled;
> > +
> > +     /*
> > +      * EL1 register width for the guest.
> > +      * This is set at the first KVM_ARM_VCPU_INIT for the guest based
> > +      * on whether the vcpu has KVM_ARM_VCPU_EL1_32BIT or not.
> > +      */
> > +     enum kvm_el1_reg_width el1_reg_width;
>
> I really don't like that we need to keep track of yet another bit of
> state on top of the existing one. Duplicating state is a source of
> bugs, because you always end up checking the wrong one at the wrong
> time (and I have scars to prove it).
>
> >  };
> >
> >  struct kvm_vcpu_fault_info {
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e4727dc771bf..54ae8bf9d187 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1058,6 +1058,32 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
> >       return -EINVAL;
> >  }
> >
> > +/*
> > + * A guest can have either all 32bit or 64bit vcpus only.
>
> That's not strictly true. All we are enforcing is that EL1 is either
> 32 or 64bit.

I will fix the comment.


>
> > + * Either one the guest has is indicated in kvm->arch.el1_reg_width.
> > + * Check if the vcpu's register width is consistent with
> > + * kvm->arch.el1_reg_width.  If kvm->arch.el1_reg_width is not set yet,
> > + * set it based on the vcpu's KVM_ARM_VCPU_EL1_32BIT configuration.
> > + */
> > +static int kvm_register_width_check_or_init(struct kvm_vcpu *vcpu)
> > +{
> > +     bool is32bit;
> > +     bool allowed = true;
> > +     struct kvm *kvm = vcpu->kvm;
> > +
> > +     is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> > +
> > +     mutex_lock(&kvm->lock);
> > +
> > +     if (kvm->arch.el1_reg_width == EL1_WIDTH_UNINITIALIZED)
> > +             kvm->arch.el1_reg_width = is32bit ? EL1_32BIT : EL1_64BIT;
> > +     else
> > +             allowed = (is32bit == (kvm->arch.el1_reg_width == EL1_32BIT));
> > +
> > +     mutex_unlock(&kvm->lock);
> > +     return allowed ? 0 : -EINVAL;
> > +}
> > +
> >  static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >                              const struct kvm_vcpu_init *init)
> >  {
> > @@ -1097,6 +1123,10 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >
> >       /* Now we know what it is, we can reset it. */
> >       ret = kvm_reset_vcpu(vcpu);
> > +
> > +     if (!ret)
> > +             ret = kvm_register_width_check_or_init(vcpu);
> > +
> >       if (ret) {
> >               vcpu->arch.target = -1;
> >               bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 426bd7fbc3fd..dbf2939a6a96 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -168,9 +168,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
> >
> >  static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> >  {
> > -     struct kvm_vcpu *tmp;
> >       bool is32bit;
> > -     int i;
> >
> >       is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> >       if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
> > @@ -180,12 +178,6 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> >       if (kvm_has_mte(vcpu->kvm) && is32bit)
> >               return false;
> >
> > -     /* Check that the vcpus are either all 32bit or all 64bit */
> > -     kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> > -             if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
> > -                     return false;
> > -     }
> > -
>
> In [1], I suggested another approach that didn't require extra state,
> and moved the existing checks under the kvm lock. What was wrong with
> that approach?

With that approach, even for a vcpu that has a broken set of features,
which leads kvm_reset_vcpu() to fail for the vcpu, the vcpu->arch.features
are checked by other vCPUs' vcpu_allowed_register_width() until the
vcpu->arch.target is set to -1.
Due to this, I would think some or possibly all vCPUs' kvm_reset_vcpu()
may or may not fail (e.g. if userspace tries to configure vCPU#0 with
32bit EL1, and vCPU#1 and #2 with 64 bit EL1, KVM_ARM_VCPU_INIT
for either vCPU#0, or both vCPU#1 and #2 should fail.  But, with that
approach, it doesn't always work that way.  Instead, KVM_ARM_VCPU_INIT
for all vCPUs could fail or KVM_ARM_VCPU_INIT for vCPU#0 and #1 could
fail while the one for CPU#2 works).
Also, even after the first KVM_RUN for vCPUs are already done,
(the first) KVM_ARM_VCPU_INIT for another vCPU could cause the
kvm_reset_vcpu() for those vCPUs to fail.

I would think those behaviors are odd, and I wanted to avoid them.

Thanks,
Reiji




>
> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/r/875yqqtn5q.wl-maz@kernel.org
>
> --
> Without deviation from the norm, progress is not possible.
