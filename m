Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1833E5751
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238224AbhHJJoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 05:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238220AbhHJJog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 05:44:36 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942F2C0613D3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 02:44:14 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id l4so13450944ljq.4
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 02:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yE5wXZDXK6p9cpZ2q0EZSEm3h7xR70bZBY+/kdRRL0c=;
        b=CRO03wZGW9IhDXyoC7tHi98Ja0XupCcBdJAnNO0LJgz5Hr/4tX8bE7lC8sh5nXSMz4
         r+qJDvdQOTJPMcSkKA/yt+ECcOjls9JMmmNgIfvfEbnxM4o2xQzyJUelT1TmznCjSYzs
         gGwHdKzl9m+H/hhxsyxOSa4DDTSAnlGCJsGkgMFlMB2hC8pZZEjX6C4Yphf8RjExvNff
         1rulAz0nxCsvsAdwaL/xE/pIPBdDLbeRyJC0Qubdu7z/oe4INRDK8fgSAu4JgknRPv96
         xtaOetA4RrzmQ4YJ6NLsjhuKMtZjvZybtrccCQH9GJrw+fTpwpiAfP/232Tf44PidSLD
         Lefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yE5wXZDXK6p9cpZ2q0EZSEm3h7xR70bZBY+/kdRRL0c=;
        b=WZQ++hUppehmbtxTM2ichC1ImPbPcR3/OE4MFTKjKglK7wpUpkgbXvDb4vojOrlD1n
         bVeJkFVgX+XakkPYMef1ftlopn9kyqQuB6CyXo4+m7EdX0gema8zavaCgJWgRrJ3evP+
         29A75/1abhnsOyeCVeZjlyHy9UrD/R7TArOYTrABAAnBRaWJJUdFGYs7gFhSefE4gL86
         itjGALW6EJGaRque30aW4l+Nw8h2WugiizoChfTHYME1Ygt2QHK2UwqxlEgTJxPcw+Pj
         9UNz6+LfFelwMLhbVQK0tXXxWGx9nrlSpRW8sDRMo+5A/bx+9tKwfrjBgNk/CmfdeA67
         yTfg==
X-Gm-Message-State: AOAM531K3L7F86IiaWBHLSURrz+Zv9PoZox8Z8dgHP2RDlkYrL+MLofX
        bCi4SPfTdbtHZBy8wvMckYikhUgLGUz9Rn5knd8MVtlL+N2kqw==
X-Google-Smtp-Source: ABdhPJxUnypR2IsyYSmdqkzIj2TFW6CoDKEXzQYFw/rzkhRclEucBFJqITY4bz5cpiueE/RXRyoyQxJgKvpb1EKKg+k=
X-Received: by 2002:a2e:89c4:: with SMTP id c4mr18569718ljk.275.1628588652559;
 Tue, 10 Aug 2021 02:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com> <20210804085819.846610-14-oupton@google.com>
 <87czqlbq15.wl-maz@kernel.org>
In-Reply-To: <87czqlbq15.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 10 Aug 2021 02:44:01 -0700
Message-ID: <CAOQ_Qsjiyp_HQLhgFfF-o7T=Qpe+djL9KCFjAU2xmj8OXhAf4w@mail.gmail.com>
Subject: Re: [PATCH v6 13/21] KVM: arm64: Allow userspace to configure a
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
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 2:35 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 04 Aug 2021 09:58:11 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Allow userspace to access the guest's virtual counter-timer offset
> > through the ONE_REG interface. The value read or written is defined to
> > be an offset from the guest's physical counter-timer. Add some
> > documentation to clarify how a VMM should use this and the existing
> > CNTVCT_EL0.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst    | 10 ++++++++++
> >  arch/arm64/include/uapi/asm/kvm.h |  1 +
> >  arch/arm64/kvm/arch_timer.c       | 11 +++++++++++
> >  arch/arm64/kvm/guest.c            |  6 +++++-
> >  include/kvm/arm_arch_timer.h      |  1 +
> >  5 files changed, 28 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 8d4a3471ad9e..28a65dc89985 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -2487,6 +2487,16 @@ arm64 system registers have the following id bit patterns::
> >       derived from the register encoding for CNTV_CVAL_EL0.  As this is
> >       API, it must remain this way.
> >
> > +.. warning::
> > +
> > +     The value of KVM_REG_ARM_TIMER_OFFSET is defined as an offset from
> > +     the guest's view of the physical counter-timer.
> > +
> > +     Userspace should use either KVM_REG_ARM_TIMER_OFFSET or
> > +     KVM_REG_ARM_TIMER_CVAL to pause and resume a guest's virtual
>
> You probably mean KVM_REG_ARM_TIMER_CNT here, despite the broken
> encoding.

Indeed I do!

>
> > +     counter-timer. Mixed use of these registers could result in an
> > +     unpredictable guest counter value.
> > +
> >  arm64 firmware pseudo-registers have the following bit pattern::
> >
> >    0x6030 0000 0014 <regno:16>
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index b3edde68bc3e..949a31bc10f0 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -255,6 +255,7 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_REG_ARM_TIMER_CTL                ARM64_SYS_REG(3, 3, 14, 3, 1)
> >  #define KVM_REG_ARM_TIMER_CVAL               ARM64_SYS_REG(3, 3, 14, 0, 2)
> >  #define KVM_REG_ARM_TIMER_CNT                ARM64_SYS_REG(3, 3, 14, 3, 2)
> > +#define KVM_REG_ARM_TIMER_OFFSET     ARM64_SYS_REG(3, 4, 14, 0, 3)
>
> I don't think we can use the encoding for CNTPOFF_EL2 here, as it will
> eventually clash with a NV guest using the same feature for its own
> purpose. We don't want this offset to overlap with any of the existing
> features.
>
> I actually liked your previous proposal of controlling the physical
> offset via a device property, as it clearly indicated that you were
> dealing with non-architectural state.

That's actually exactly what I did here :) That said, the macro name
is horribly obfuscated from CNTVOFF_EL2. I did this for the sake of
symmetry with other virtual counter-timer registers above, though this
may warrant special casing given the fact that we have a similarly
named device attribute to handle the physical offset.

--
Thanks,
Oliver
