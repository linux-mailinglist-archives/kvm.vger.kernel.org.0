Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E8A428E24
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 15:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbhJKNip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 09:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbhJKNin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 09:38:43 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FAEC061745
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 06:36:44 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id q129so3940209oib.0
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 06:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/JNfG7kesfRccmBVAhgQG5AruC/McrlnRGzPRsyxeyM=;
        b=NifGimNaB2ZW4w+nudH3Crr3IAjX+qDkvy69+ohEL27gn2rQ2wjsXz1N232aoWVZxx
         ipJe3zMObIHGcqEGDwPBNxIdci8gIDofGP+QoyDXYTLNXOTWawZ1/PlCTKG3ngJpo7EO
         oLLKgBt0JFyU86cgQGcqG0nxjkhmnhbOqUl1ok+B3oH88pcem65YTGdQ6TumCIHEcKH1
         VJ3XSGwVybDV+ASkqVpmhLFyVwFVlZu6OoFq9m27Vy+uHD7enH7QOt5wC9NnLBtUXtWs
         2uFLlGCV04JFgFcjG6ysHt15JS9u7jH2fAiJsQZVEKJc/UdbdptpFmhMZY3j7SwKOe0/
         WzvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/JNfG7kesfRccmBVAhgQG5AruC/McrlnRGzPRsyxeyM=;
        b=voZECkIww/l1931AEOXTSC8vbVAZUm0Tg/x5mEe0W3MknSXR90F+0rt8G6eu9EZrzo
         iXGShxq8Q4A23Pe9ttDDJYRs5+67R9EZXSAJUyECsVZI3pqKUanSOBxTllR0c4vcPkyj
         eDkfn6pN1qEIB7Vwuv6v6CQNfZptPdKHXwpQ5f2cpPdwjLpMtfpvLib3nOBpc62POSrU
         tB9sGtNC/kuwSnbnNmfkGjWEUcMEWSeCYX0veeFjRIIcjFQnI85mbxXMJJjNunc3He8o
         74+JSY+57VNCuLn9XffU5NXzvRbXT5kTUvq6P3jRYhWpXYtzi0xRQl3eJzJvWjZCU8eD
         wGpQ==
X-Gm-Message-State: AOAM530+3ZbK/kVt8U2ETtHNmQ2cNm6G8xP3C8+EK9+vi9VnIki4bPF4
        R9lqHABoqPja8DJeSc8kVhjvkiQJgMBxQXZVyuQgQQ==
X-Google-Smtp-Source: ABdhPJxSU1RD8HB9ikjK3AC6DC3JCIDrsYxB9kWDH3QApKuFfDrikxmBHv7urC3iR+Spt9gzOmk7NSFXmKQug5Q3HIc=
X-Received: by 2002:aca:c0c4:: with SMTP id q187mr14780782oif.96.1633959403235;
 Mon, 11 Oct 2021 06:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com> <20211010145636.1950948-12-tabba@google.com>
 <87o87vpuze.wl-maz@kernel.org>
In-Reply-To: <87o87vpuze.wl-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 11 Oct 2021 14:36:06 +0100
Message-ID: <CA+EHjTxKn7Ff7zOCnoVR+L-qKg7OE81EerkO-SgcXVUZxJjbug@mail.gmail.com>
Subject: Re: [PATCH v8 11/11] KVM: arm64: Handle protected guests at 32 bits
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

On Mon, Oct 11, 2021 at 2:11 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sun, 10 Oct 2021 15:56:36 +0100,
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
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 34 ++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 2c72c31e516e..f25b6353a598 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -232,6 +232,37 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
> >       return hyp_exit_handlers;
> >  }
> >
> > +/*
> > + * Some guests (e.g., protected VMs) are not be allowed to run in AArch32.
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
> > +     struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> > +
> > +     if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu)) {
> > +             /*
> > +              * As we have caught the guest red-handed, decide that it isn't
> > +              * fit for purpose anymore by making the vcpu invalid. The VMM
> > +              * can try and fix it by re-initializing the vcpu with
> > +              * KVM_ARM_VCPU_INIT, however, this is likely not possible for
> > +              * protected VMs.
> > +              */
> > +             vcpu->arch.target = -1;
> > +             *exit_code = ARM_EXCEPTION_IL;
>
> Aren't we losing a potential SError here, which the original commit
> doesn't need to handle? I'd expect something like:
>
>                 *exit_code &= BIT(ARM_EXIT_WITH_SERROR_BIT);
>                 *exit_code |= ARM_EXCEPTION_IL;

Yes, you're right. That would ensure the SError is preserved.

Thanks,
/fuad


> > +             return false;
> > +     }
> > +
> > +     return true;
> > +}
> > +
> >  /* Switch to the guest for legacy non-VHE systems */
> >  int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> > @@ -294,6 +325,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
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
