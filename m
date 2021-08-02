Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B513DE30B
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 01:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhHBX2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 19:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbhHBX2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 19:28:21 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D1BC061798
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 16:28:11 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id e5so25996962ljp.6
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 16:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J9HZ+dRqIjGaHUpE5nN2lo/SuVqbz/56Q93GhSWxRHU=;
        b=f3ulRBAIBoSniofTbVTngfqKcyPVhP5suwWHrT1VOLa5IUa7oaZDDSU1UCNv83pwBE
         lsPAlcmUJkJczrayqXzvYqg8mar0U+oKeYEBdagjvUHxFyRZESgQbkjUVetXdgFZIPL/
         8vpYfIz+pZQjQDijDsbLshqY+5eyeFNoaUMiCzUwVyLCg8xXLVUtHdEPuDpttN0oREdc
         VlSECrTomjtYtZ06L6dpF9BN0tR3h0+p4W/M2XOcJOLZIU6NdzjUtbHymwlsqeRxBGus
         GusToQoR7B2uj7do4M5GrfcA/yWnUAEFYpfrDQWW9VmQKVoj4uJOcwv4eyS54g7cjcxj
         gPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J9HZ+dRqIjGaHUpE5nN2lo/SuVqbz/56Q93GhSWxRHU=;
        b=rXXXmVCx90yZyhDFiEt2yjTvnpCLl0vqeO7y+YShl/fnwU6cq9FHf48ndd6u3slN9J
         MC10XgHkt7jBRUtmIIvEj/EL98PddYobm4XYGqIxttoLWfT3tQri/mKsv4VYrQ0EE0lg
         kyH0iO3UvzMMeMsBqHIjazS0jkIhTbdnNiinbrXHWoUiCJMNV13C8TWcSmTMCI0wrWTV
         /yT4QwntC1lDI+0QzIaNdQx1C5BLV7t6xTdiKg/5URSu87TgbOJ2gmVTIwgihLgDvNrP
         OlbB5NWMmYJekZ5wWy59n/RO5E+KDPBNA4ehksAsa9L5iuyVx2gtf/lAg8ewKAQ/GgPc
         vOZA==
X-Gm-Message-State: AOAM532ypG7Di8p6F9xtmQu+csrDb/5M78UcUYl2/+nxLTpgOgk5iQwt
        zz/cmFjIZ2DE3b19RREs+/0QnW0UQBTAjFT2rjrIvA==
X-Google-Smtp-Source: ABdhPJx4PMflNKq4l++/Ia5h4WkHkX05BnmK2AolU5x1FQ8DXEXIM1Eagkz5xAjX4eGnRjHffPcUhFrmG57FcQFcx8I=
X-Received: by 2002:a2e:535c:: with SMTP id t28mr12614273ljd.129.1627946888933;
 Mon, 02 Aug 2021 16:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com> <20210729173300.181775-10-oupton@google.com>
 <877dh82jrh.wl-maz@kernel.org>
In-Reply-To: <877dh82jrh.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 2 Aug 2021 16:27:57 -0700
Message-ID: <CAOQ_QsiLLUgPYO4q3kn1mApTMysCO=5U9g0h3Xqu8a11bpbAJA@mail.gmail.com>
Subject: Re: [PATCH v5 09/13] KVM: arm64: Allow userspace to configure a
 vCPU's virtual offset
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

On Fri, Jul 30, 2021 at 3:12 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 29 Jul 2021 18:32:56 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Add a new vCPU attribute that allows userspace to directly manipulate
> > the virtual counter-timer offset. Exposing such an interface allows for
> > the precise migration of guest virtual counter-timers, as it is an
> > indepotent interface.
> >
> > Uphold the existing behavior of writes to CNTVOFF_EL2 for this new
> > interface, wherein a write to a single vCPU is broadcasted to all vCPUs
> > within a VM.
> >
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  Documentation/virt/kvm/devices/vcpu.rst | 22 ++++++++
> >  arch/arm64/include/uapi/asm/kvm.h       |  1 +
> >  arch/arm64/kvm/arch_timer.c             | 68 ++++++++++++++++++++++++-
> >  3 files changed, 89 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> > index 0f46f2588905..ecbab7adc602 100644
> > --- a/Documentation/virt/kvm/devices/vcpu.rst
> > +++ b/Documentation/virt/kvm/devices/vcpu.rst
> > @@ -139,6 +139,28 @@ configured values on other VCPUs.  Userspace should configure the interrupt
> >  numbers on at least one VCPU after creating all VCPUs and before running any
> >  VCPUs.
> >
> > +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
> > +------------------------------------------------
> > +
> > +:Parameters: Pointer to a 64-bit unsigned counter-timer offset.
> > +
> > +Returns:
> > +
> > +      ======= ======================================
> > +      -EFAULT Error reading/writing the provided
> > +              parameter address
> > +      -ENXIO  Attribute not supported
> > +      ======= ======================================
> > +
> > +Specifies the guest's virtual counter-timer offset from the host's
> > +virtual counter. The guest's virtual counter is then derived by
> > +the following equation:
> > +
> > +  guest_cntvct = host_cntvct - KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
>
> I still have a problem with this, specially as you later introduce a
> physical timer offset. My gut feeling is that the virtual offset
> should be relative to the physical counter *of the guest*, and not
> that of the host. The physical offset should be the only one that is
> relative to the host. Anything else should be deriving from it.
>
> If you don't set the ptimer offset, then the two definitions are
> strictly identical. It will also match the definition of a
> userspace-visible CNTVOFF_EL2 with NV, which is strictly relative to
> the guest view of the physical counter.

Yeah, this sounds good to me. I very much like the idea of maintaining
exactly one offset from the host to the guest. So long as users are
fine with paying the cost of an emulated physical counter-timer on
non-ECV hosts. That said, a non-NV guest shouldn't be using the
physical counter in the first place..

>
> > +
> > +KVM does not allow the use of varying offset values for different vCPUs;
> > +the last written offset value will be broadcasted to all vCPUs in a VM.
> > +
>
> Please document the effects of this attribute w.r.t. writing
> CNTVCT_EL0 from userspace.
>

Good idea.

> > -int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> > +int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> > +{
> > +     u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> > +     u64 offset;
> > +
> > +     if (get_user(offset, uaddr))
> > +             return -EFAULT;
> > +
> > +     switch (attr->attr) {
> > +     case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> > +             update_vtimer_cntvoff(vcpu, offset);
>
> Probably not a good idea if the timer is already enabled on any of the
> CPUs (we probably already have that problem, so let's fix it once and
> for all).

hmm... would this cause any issues to enforce ordering on an existing
UAPI? If I understand the suggestion correctly, we will refuse to
write the counter offset for a VM with an active timer.

If that is the case, then when we migrate a guest the VMM would have
to be very deliberate about the order in which it restores registers,
no?

> > +int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> > +{
> > +     u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> > +     struct arch_timer_context *timer;
> > +     u64 offset;
> > +
> > +     switch (attr->attr) {
> > +     case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> > +             timer = vcpu_vtimer(vcpu);
> > +             break;
> > +     default:
> > +             return -ENXIO;
>
> What is the rational for retrieving this offset the first place? I
> don't dislike the symmetry, but we already have an architectural way
> of getting it (read the counter registers).

I don't believe this is necessary any more.

The reason that I had exposed the virtual counter offset as a device
attribute was to separate VMM and guest manipulation of the virtual
counter. A VMM migrating an EL2 guest would likely want to adjust the
vtimer according to the difference in virtual counters between two
hosts without changing any guest-visible sysregs. However, if we go
with your suggestion above, the hypervisor would only ever need to
poke a physical offset attribute to make transparent changes to *both*
counters.

So, I suppose this is what I'm proposing: treat VMM writes to
CNTVOFF_EL2 the same as guest writes. For CNTPOFF_EL2, we do a special
dance; guest writes to CNTPOFF_EL2 will be visible in the register
_and_ change the value KVM writes to CNTPOFF_EL2 in hardware. Host
writes to a physical offset device attribute will cause KVM to change
the hardware value of CNTPOFF_EL2, but not update the guest-visible
register value. This way, a guest can be transparently migrated
between hosts with different counters.

>
> > +     }
> > +
> > +     offset = timer_get_offset(timer);
> > +     return put_user(offset, uaddr);
> > +}
> > +
> > +int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> > +{
> > +     switch (attr->attr) {
> > +     case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> > +     case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> > +             return kvm_arm_timer_get_attr_irq(vcpu, attr);
> > +     case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> > +             return kvm_arm_timer_get_attr_offset(vcpu, attr);
> > +     }
> > +
> > +     return -ENXIO;
> > +}
> > +
> >  int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> >  {
> >       switch (attr->attr) {
> >       case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> >       case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> > +     case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> >               return 0;
> >       }
> >
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
