Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88203F489E
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 12:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbhHWK0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 06:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235975AbhHWK0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 06:26:39 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D469C061575
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 03:25:57 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id i3-20020a056830210300b0051af5666070so25264243otc.4
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 03:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iil3g1xzE54TUwgwxXbVjp/I2BXWoZeDWrISpeeZe14=;
        b=BEW3pF7bCpIXQquKczEegFeZjB4PN2FJINV+cpI96e+ZQKAUumwIkxkDwpbx3KxVX/
         jEV7r2X/PXB2J5H9vROz1yIGrg/C9BzHL2ENP4rws1a69K/LMgiALseDgDCqMkZf1zTT
         iXMVQXasH/iLEIZZQ2O019Dd8bfQCg7UE4mAC5hsYCzmN3+VqRSGWNbgF2jwGtyaNrbq
         2dh21hx5nfjAG1EedyrdGR+2AIZE0gAzriJ9sCGtm4N9Rxdpdj5w5BYRgmlh+IHNZiu9
         wOpyw2qGxapWYcgQ0s4wMPR5DW1y51wv1BZX/EIraK4Wzwln68WzoQTFeaTaW1NQ3nYg
         c3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iil3g1xzE54TUwgwxXbVjp/I2BXWoZeDWrISpeeZe14=;
        b=LDg37IEYGPCmi2MB72xlnt0OTw4xJ/ijjrsiDvYQVpB19em2I+vAvCW9ocj2iEoOVJ
         udQJqNFDckQD5q4uvaQQtdcl+RjOiaX5VGkc1r9CPppvUzrSxBKNeKyhcp5QCJZ83Ia4
         O3cTlg36fd84r6LcsyAho6YBapqIwmJaoTCkLBK8UwXLJFBYQ3pobNNTXCu4EdyVL2U8
         3g8w33/iHfM9MQ4PWxTcX/V63ASnZmUJPk11UeGi+S40j4t6dcFJYwuE1jzYNkawC4FG
         95WnRIuPsEVbMqRBAl/l3b+59CQAEE6M0JMT0+3oVjUe2V3N7NGsw7+00+/PLnfQ/L2t
         habQ==
X-Gm-Message-State: AOAM533h3Atd/xro7YoOjv7bFq+JXaYaAbI58uIiOyVZ1PUV2Ab+39a9
        rB9kGPwqSI8zPspGVuhkhoq/hHsV3fTzALxAVt+FpQ==
X-Google-Smtp-Source: ABdhPJyc5KKsDid+ISzlkW07QeZX7D5K3hIbXU4y15H3axJsNCGDbA+XxfiyQc68SzeSTbGJu39OzYXXM1Av29ZlITE=
X-Received: by 2002:a05:6830:1dac:: with SMTP id z12mr23465282oti.52.1629714356807;
 Mon, 23 Aug 2021 03:25:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com> <20210817081134.2918285-16-tabba@google.com>
 <CAOQ_QsgSfHVjJkSJku5DwUe0_=ds4GduPbJ7vC-t+4_=fPVFBQ@mail.gmail.com>
In-Reply-To: <CAOQ_QsgSfHVjJkSJku5DwUe0_=ds4GduPbJ7vC-t+4_=fPVFBQ@mail.gmail.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 23 Aug 2021 11:25:20 +0100
Message-ID: <CA+EHjTwPgjXtrR5dFx0RBN9xdX0j7ugO=NqAmkmZqYE9N_jP7w@mail.gmail.com>
Subject: Re: [PATCH v4 15/15] KVM: arm64: Handle protected guests at 32 bits
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Thu, Aug 19, 2021 at 9:10 AM Oliver Upton <oupton@google.com> wrote:
>
> Hi Fuad,
>
> On Tue, Aug 17, 2021 at 1:12 AM Fuad Tabba <tabba@google.com> wrote:
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
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 37 ++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 398e62098898..0c24b7f473bf 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -20,6 +20,7 @@
> >  #include <asm/kprobes.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> > +#include <asm/kvm_fixed_config.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/fpsimd.h>
> > @@ -195,6 +196,39 @@ exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
> >                 return NULL;
> >  }
> >
> > +/*
> > + * Some guests (e.g., protected VMs) might not be allowed to run in AArch32. The
> > + * check below is based on the one in kvm_arch_vcpu_ioctl_run().
> > + * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
> > + * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
> > + * hypervisor spots a guest in such a state ensure it is handled, and don't
> > + * trust the host to spot or fix it.
> > + *
> > + * Returns true if the check passed and the guest run loop can continue, or
> > + * false if the guest should exit to the host.
> > + */
> > +static bool check_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
>
> This does a bit more than just check & return, so maybe call it
> handle_aarch32_guest()?
>
> > +{
> > +       if (kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
>
> maybe initialize a local with a hyp pointer to the kvm structure.

Will do.

> > +           vcpu_mode_is_32bit(vcpu) &&
> > +           FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
> > +                                        PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) <
> > +               ID_AA64PFR0_ELx_32BIT_64BIT) {
>
> It may be more readable to initialize a local variable with this
> feature check, i.e:
>
> bool aarch32_allowed = FIELD_GET(...) == ID_AA64PFR0_ELx_32BIT_64BIT;
>
> and then:
>
>   if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu) &&
> !aarch32_allowed) {

I agree.

Thanks,
/fuad

> > +               /*
> > +                * As we have caught the guest red-handed, decide that it isn't
> > +                * fit for purpose anymore by making the vcpu invalid. The VMM
> > +                * can try and fix it by re-initializing the vcpu with
> > +                * KVM_ARM_VCPU_INIT, however, this is likely not possible for
> > +                * protected VMs.
> > +                */
> > +               vcpu->arch.target = -1;
> > +               *exit_code = ARM_EXCEPTION_IL;
> > +               return false;
> > +       }
> > +
> > +       return true;
> > +}
> > +
> >  /* Switch to the guest for legacy non-VHE systems */
> >  int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> > @@ -255,6 +289,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >                 /* Jump in the fire! */
> >                 exit_code = __guest_enter(vcpu);
> >
> > +               if (unlikely(!check_aarch32_guest(vcpu, &exit_code)))
> > +                       break;
> > +
> >                 /* And we're baaack! */
> >         } while (fixup_guest_exit(vcpu, &exit_code));
> >
> > --
> > 2.33.0.rc1.237.g0d66db33f3-goog
> >
