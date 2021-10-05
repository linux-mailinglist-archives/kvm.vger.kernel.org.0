Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC6F4221A6
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 11:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhJEJHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 05:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbhJEJHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 05:07:35 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D4AC061745
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 02:05:45 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id w190so222567oif.5
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 02:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZM3Zs1hD0IvxW0NEoOVRpgIBxIg0g/Aefp92Tu/RS14=;
        b=DGxWG2YlpVunKcb7OQr0SKzOX9CTc0PhPEnwq/MUvowulZ084/74w+yMqV8HfUqupl
         Z8i6/b71iIdwf+SVw4wxivnoh5EpKdwJEDO7eb4Wp1Zv8utuUQc65OrqfF+TcYSt6Gwy
         3SF4c04jFlYufVJ3N3z1MG3Beo6zWubWbiNzAncDftNled8YOM767waM69j1UDGGuy6L
         1+/BL38Q7i0U/Y3mY4Allok0YDrxxDrc8oBAuit2EmoDXcENtSNL5/iGh18RsDGpzjHt
         iAoM9jSihkQLb79YcfOmYUZ06/jPuKCqzVhfEUK3YihTHoRGo4Jf5lxo5CX9KoWqXb2/
         qvWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZM3Zs1hD0IvxW0NEoOVRpgIBxIg0g/Aefp92Tu/RS14=;
        b=sczYBnuB121eOEB4BFLOHxeEMOa+S0jzdalzZ9eDUtwHcnrMRIV0fdzmdJgIN3F0Tg
         3ZoJgcZxOeMT2tjpdOmfEVhq4yZ78jxIMd3MdSH9I25I2GzJ21GW9Af6wTUDiBJPZOlv
         8FMU3NjIxmrcj+W1IB0o1z11eWveIAkVmv3VhAVuVBUSnGPdjk85nbGax6LybLwkle+X
         FTak1KXspETNbB5b9M8QCyOX4wbYXIhomiW45JXcdABdFVhDSesazsVWPyxzV9yWuqc+
         plQXHQmOaA6tyKPophe21Jyv9EOOnVCBV8T3834xyaHk/nOKgGbbMiWUnNIdr3tbd3Uw
         9C7w==
X-Gm-Message-State: AOAM532zqRjA5gNp+GYkB5V/dOMipj0Wqb8mYZIIjfyNzKtHLx0A9mbc
        0y9TSiZ75slb9nYC1zKj2ulZ/mpvyMQJuBxaOUyT0A==
X-Google-Smtp-Source: ABdhPJz67hcp3PPxwZdQScqsFRDex6KiMAh2iDnZJJt+LUbAzcOQmphJP5sqXjayKo9PJSWuAvxT7mO1+VdmpRsxF9Q=
X-Received: by 2002:aca:604:: with SMTP id 4mr1531266oig.8.1633424744609; Tue,
 05 Oct 2021 02:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com> <20210922124704.600087-13-tabba@google.com>
 <87sfxfrh6k.wl-maz@kernel.org>
In-Reply-To: <87sfxfrh6k.wl-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 5 Oct 2021 10:05:08 +0100
Message-ID: <CA+EHjTyYz4Hf6-awZTLinWxkr3N_j9K-m7TEe=EKCFUuQL_mYA@mail.gmail.com>
Subject: Re: [PATCH v6 12/12] KVM: arm64: Handle protected guests at 32 bits
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Oct 5, 2021 at 9:48 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 22 Sep 2021 13:47:04 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Protected KVM does not support protected AArch32 guests. However,
> > it is possible for the guest to force run AArch32, potentially
> > causing problems. Add an extra check so that if the hypervisor
> > catches the guest doing that, it can prevent the guest from
> > running again by resetting vcpu->arch.target and returning
> > ARM_EXCEPTION_IL.
> >
> > If this were to happen, The VMM can try and fix it by re-
> > initializing the vcpu with KVM_ARM_VCPU_INIT, however, this is
> > likely not possible for protected VMs.
> >
> > Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> > AArch32 systems")
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 40 ++++++++++++++++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 2bf5952f651b..d66226e49013 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -235,6 +235,43 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
> >       return hyp_exit_handlers;
> >  }
> >
> > +/*
> > + * Some guests (e.g., protected VMs) might not be allowed to run in AArch32.
> > + * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
> > + * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
> > + * hypervisor spots a guest in such a state ensure it is handled, and don't
> > + * trust the host to spot or fix it.  The check below is based on the one in
> > + * kvm_arch_vcpu_ioctl_run().
> > + *
> > + * Returns false if the guest ran in AArch32 when it shouldn't have, and
> > + * thus should exit to the host, or true if a the guest run loop can continue.
> > + */
> > +static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     struct kvm *kvm = (struct kvm *) kern_hyp_va(vcpu->kvm);
>
> There is no need for an extra cast. kern_hyp_va() already provides a
> cast to the type of the parameter.

Will drop it.

> > +     bool is_aarch32_allowed =
> > +             FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
> > +                       get_pvm_id_aa64pfr0(vcpu)) >=
> > +                             ID_AA64PFR0_ELx_32BIT_64BIT;
> > +
> > +
> > +     if (kvm_vm_is_protected(kvm) &&
> > +         vcpu_mode_is_32bit(vcpu) &&
> > +         !is_aarch32_allowed) {
>
> Do we really need to go through this is_aarch32_allowed check?
> Protected VMs don't have AArch32, and we don't have the infrastructure
> to handle 32bit at all. For non-protected VMs, we already have what we
> need at EL1. So the extra check only adds complexity.

No. I could change it to a build-time assertion just to make sure that
AArch32 is not allowed instead.

Thanks,
/fuad

> > +             /*
> > +              * As we have caught the guest red-handed, decide that it isn't
> > +              * fit for purpose anymore by making the vcpu invalid. The VMM
> > +              * can try and fix it by re-initializing the vcpu with
> > +              * KVM_ARM_VCPU_INIT, however, this is likely not possible for
> > +              * protected VMs.
> > +              */
> > +             vcpu->arch.target = -1;
> > +             *exit_code = ARM_EXCEPTION_IL;
> > +             return false;
> > +     }
> > +
> > +     return true;
> > +}
> > +
> >  /* Switch to the guest for legacy non-VHE systems */
> >  int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> > @@ -297,6 +334,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >               /* Jump in the fire! */
> >               exit_code = __guest_enter(vcpu);
> >
> > +             if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
> > +                     break;
> > +
> >               /* And we're baaack! */
> >       } while (fixup_guest_exit(vcpu, &exit_code));
> >
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
