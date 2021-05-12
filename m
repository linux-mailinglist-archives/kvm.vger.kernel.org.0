Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBDB37D0D6
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 19:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbhELRnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 13:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346251AbhELRNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 13:13:08 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80E1C061355
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 10:06:05 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id d24so12469537ios.2
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 10:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y+4pg3rwkiDnuJBqtvuUh3QFCbaIgxsSCSbdWf98D3w=;
        b=YrxU8hDxHTRvmKdW7cz69M5sIiPtvdcm2p5XzpaGtw59HWYPPNaQVqDt+jjaA0kxLm
         S1pLO1oMF2EE2/Azgo3xLE5+/S7iMMdgAsEn4p1iCh83/5ek2XFX+5R61x1PI/pV3gms
         5eafyQ9lzKT7N1g4A6E2Bmj+bULfoKJpc/qLYvtmf8BPi5qVRe3+T9ZRf+dHrAaOToOV
         dR4mSP8KxfyGQ59opzUjbnZfR4ApB1kg9dnDkH6GDIVwTOM834SFg974PGioiApPRO4b
         Gk5GdHMtzA/WD54DYntqMjXtffw2X6yRFqywcgixGHoVG2LEo0ALNcsxp6im5AMl7sJY
         68Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y+4pg3rwkiDnuJBqtvuUh3QFCbaIgxsSCSbdWf98D3w=;
        b=ltm56UbA9JvagevsQYd3zjtH7KPr4Z6Hnzwz9GPBLvclBUcPw/V2YBfc/RTsI4fPo6
         feTrivW0f0YBXp57hIsddy1CltMnLSvCjkM35u78PSRcbTU6tbZ+xVouoHHKsrnnywgw
         FHboBm2Lwy3RBZpiLoKNaZ68mYzSEjuXE6f/21QG6y4+8o6prG/16tbh8JL23DVmxUvz
         WFMUxzpzvF1zPJ2O6lItGZ4J2tKzUJGjKm4A6jFwhtnEUpGR02mkmSXM3R5llCViwB8t
         f8mR8zFyfxGGuCaoERVyI/7gYP3Ye8I0aoQiWE64GYR5f3/frTtSfS/Q2XRGXvKgUaxz
         6how==
X-Gm-Message-State: AOAM533Zir5Ex8B3TldqFuJEadsVP85qYky/R0bRmB08TJXakGyHy5PN
        Bz0CUmCNrEWsKf81Cnc43TLbt37FXdvVjjipZhzuig==
X-Google-Smtp-Source: ABdhPJyBWR9gAdG3dHeOG3HAoMoQNXTh/RRI6+5ysnRneGpynrQM0HwnGI5uoqcPtMaTB8LWmM7lTS3/odR7zEd6iww=
X-Received: by 2002:a5d:9acd:: with SMTP id x13mr27033517ion.134.1620839164789;
 Wed, 12 May 2021 10:06:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200116001635.174948-1-jmattson@google.com> <FE5AE42B-107F-4D7E-B728-E33780743434@oracle.com>
In-Reply-To: <FE5AE42B-107F-4D7E-B728-E33780743434@oracle.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 12 May 2021 10:05:54 -0700
Message-ID: <CANgfPd8wFZx977enc+kbbTP1DfMdxkbi5uzhAgpRZhU0yXOzKg@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Don't dirty guest memory on every vcpu_put()
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Mcgaire <kevinmcgaire@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 15, 2020 at 4:32 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 16 Jan 2020, at 2:16, Jim Mattson <jmattson@google.com> wrote:
> >
> > Beginning with commit 0b9f6c4615c99 ("x86/kvm: Support the vCPU
> > preemption check"), the KVM_VCPU_PREEMPTED flag is set in the guest
> > copy of the kvm_steal_time struct on every call to vcpu_put(). As a
> > result, guest memory is dirtied on every call to vcpu_put(), even when
> > the VM is quiescent.
> >
> > To avoid dirtying guest memory unnecessarily, don't bother setting the
> > flag in the guest copy of the struct if it is already set in the
> > kernel copy of the struct.
>
> I suggest adding this comment to code as-well.

Ping. I don't know if a v2 of this change with the comment in code is
needed for acceptance, but I don't want this to fall through the
cracks and get lost.

>
> >
> > If a different vCPU thread clears the guest copy of the flag, it will
> > no longer get reset on the next call to vcpu_put, but it's not clear
> > that resetting the flag in this case was intentional to begin with.
>
> I agree=E2=80=A6 I find it hard to believe that guest vCPU is allowed to =
clear the flag
> and expect host to set it again on the next vcpu_put() call. Doesn=E2=80=
=99t really make sense.
>
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Tested-by: Kevin Mcgaire <kevinmcgaire@google.com>
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
>
> Good catch.
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
>
> -Liran
>
> >
> > ---
> > arch/x86/kvm/x86.c | 3 +++
> > 1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index cf917139de6b..3dc17b173f88 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3504,6 +3504,9 @@ static void kvm_steal_time_set_preempted(struct k=
vm_vcpu *vcpu)
> >       if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
> >               return;
> >
> > +     if (vcpu->arch.st.steal.preempted & KVM_VCPU_PREEMPTED)
> > +             return;
> > +
> >       vcpu->arch.st.steal.preempted =3D KVM_VCPU_PREEMPTED;
> >
> >       kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,
> > --
> > 2.25.0.rc1.283.g88dfdc4193-goog
> >
>
