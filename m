Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEEB37FB4F
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 18:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbhEMQP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 12:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbhEMQPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 May 2021 12:15:55 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959F8C061574
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 09:14:44 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id z24so25460762ioj.7
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 09:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3sw5ViZFIYoD7cHO9bW/jhWGGuW60Jk0+ksnUZs3ziQ=;
        b=RyrgDBFVhCxVBXjrt4gEmtS4OMHJTrHa0aEJaIiDqh5FlAT3i7mGMDmvLnnAlpuQGC
         GkzfxMKViXuRfuuVZEFYlMYiIA/RBWIhAEsaBdWT4uHfsgUNow6Ums/nLwfE3NrlwLW5
         00yZWGcGaFiMTkRc8cgDVmsGCa6Uo50h9lwcn5KgZ49n3ySDsPAYMTshWkm0Sl66AUIC
         ph/SfV7vts6+CRbSnzQORjbmUMK1heE/X1NaJOvRXSl54N1Vs02KUk14hwywT1T6QO9w
         T/4rd/AGGx1wMaV8uV2PmQ27MiEaQpBjPhwhhRqhjjlUCYF6jq/FzBAXG8hgb3HfoM2k
         SsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3sw5ViZFIYoD7cHO9bW/jhWGGuW60Jk0+ksnUZs3ziQ=;
        b=eZhMkwekWeuUj8dY+JTveSeKF9OTIiZ3PpU3VD8uhell3roPNJCRxL4K0MYuvCH/hN
         9z0p/y45H+c4zBP2w8fUUJAB0lByy2PwrdTgKCgqXqj57fdtSnGH2HRnTDpCFfPh5lvR
         dQwTS65eaI3zpuwDNcNlE5Wma/QQjILK2aYhXBhnxRfONT8uSbcZ1zdN/QtvUDRRcYO3
         W1jqbgt6J5VlA3kNGMx656SY1mXkGQy1Xv2tz8oPhe6Gb8eeKWVcigPBVTHx5ff76TIt
         ZHrVhniRexE9mvsyy8KHTc/dDGc+hMLTqVPQurc3D55ZWyyB7aqC3dQcS97Fmg4tXevL
         FLTA==
X-Gm-Message-State: AOAM530xxq6OsTDSXK0S4fPZrrUKIHurl9M9fJoOre03/U6uA8zji7yb
        JJEmPNtCOh0tk4UTNUfJy3/VFiBfPS9bAFMRzmHdLg==
X-Google-Smtp-Source: ABdhPJwmk0MJbY58+fX+kX1uAG4+dUfRpA09sey2QuAtPfeK7xdMzbcK7M9sKPJjL58oOOQH8MU+pUpyE0PhiEOOVK0=
X-Received: by 2002:a6b:7c0b:: with SMTP id m11mr31471281iok.9.1620922483864;
 Thu, 13 May 2021 09:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200116001635.174948-1-jmattson@google.com> <FE5AE42B-107F-4D7E-B728-E33780743434@oracle.com>
 <CANgfPd8wFZx977enc+kbbTP1DfMdxkbi5uzhAgpRZhU0yXOzKg@mail.gmail.com> <YJxf+ho/iu8Gpw6+@google.com>
In-Reply-To: <YJxf+ho/iu8Gpw6+@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 13 May 2021 09:14:32 -0700
Message-ID: <CANgfPd8cujDpRBdD_XBC9h6Q8ijioXHuBUGZ-mBBGBAGHRBt6A@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Don't dirty guest memory on every vcpu_put()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Mcgaire <kevinmcgaire@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 4:08 PM Sean Christopherson <seanjc@google.com> wro=
te:
>
> On Wed, May 12, 2021, Ben Gardon wrote:
> > On Wed, Jan 15, 2020 at 4:32 PM Liran Alon <liran.alon@oracle.com> wrot=
e:
> > >
> > >
> > >
> > > > On 16 Jan 2020, at 2:16, Jim Mattson <jmattson@google.com> wrote:
> > > >
> > > > Beginning with commit 0b9f6c4615c99 ("x86/kvm: Support the vCPU
> > > > preemption check"), the KVM_VCPU_PREEMPTED flag is set in the guest
> > > > copy of the kvm_steal_time struct on every call to vcpu_put(). As a
> > > > result, guest memory is dirtied on every call to vcpu_put(), even w=
hen
> > > > the VM is quiescent.
> > > >
> > > > To avoid dirtying guest memory unnecessarily, don't bother setting =
the
> > > > flag in the guest copy of the struct if it is already set in the
> > > > kernel copy of the struct.
> > >
> > > I suggest adding this comment to code as-well.
> >
> > Ping. I don't know if a v2 of this change with the comment in code is
> > needed for acceptance, but I don't want this to fall through the
> > cracks and get lost.
>
> A version of this was committed a while ago.  The CVE number makes me thi=
nk it
> went stealthily...

That's great to know. Thanks for digging that up Sean.

>
> commit 8c6de56a42e0c657955e12b882a81ef07d1d073e
> Author: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Date:   Wed Oct 30 19:01:31 2019 +0000
>
>     x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit
>
>     kvm_steal_time_set_preempted() may accidentally clear KVM_VCPU_FLUSH_=
TLB
>     bit if it is called more than once while VCPU is preempted.
>
>     This is part of CVE-2019-3016.
>
>     (This bug was also independently discovered by Jim Mattson
>     <jmattson@google.com>)
>
>     Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>     Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
>     Cc: stable@vger.kernel.org
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cf917139de6b..8c9369151e9f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3504,6 +3504,9 @@ static void kvm_steal_time_set_preempted(struct kvm=
_vcpu *vcpu)
>         if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
>                 return;
>
> +       if (vcpu->arch.st.steal.preempted)
> +               return;
> +
>         vcpu->arch.st.steal.preempted =3D KVM_VCPU_PREEMPTED;
>
>         kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,
>
>
> > > > If a different vCPU thread clears the guest copy of the flag, it wi=
ll
> > > > no longer get reset on the next call to vcpu_put, but it's not clea=
r
> > > > that resetting the flag in this case was intentional to begin with.
> > >
> > > I agree=E2=80=A6 I find it hard to believe that guest vCPU is allowed=
 to clear the flag
> > > and expect host to set it again on the next vcpu_put() call. Doesn=E2=
=80=99t really make sense.
> > >
> > > >
> > > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > > Tested-by: Kevin Mcgaire <kevinmcgaire@google.com>
> > > > Reviewed-by: Ben Gardon <bgardon@google.com>
> > > > Reviewed-by: Oliver Upton <oupton@google.com>
> > >
> > > Good catch.
> > > Reviewed-by: Liran Alon <liran.alon@oracle.com>
> > >
> > > -Liran
> > >
> > > >
> > > > ---
> > > > arch/x86/kvm/x86.c | 3 +++
> > > > 1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index cf917139de6b..3dc17b173f88 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -3504,6 +3504,9 @@ static void kvm_steal_time_set_preempted(stru=
ct kvm_vcpu *vcpu)
> > > >       if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
> > > >               return;
> > > >
> > > > +     if (vcpu->arch.st.steal.preempted & KVM_VCPU_PREEMPTED)
> > > > +             return;
> > > > +
> > > >       vcpu->arch.st.steal.preempted =3D KVM_VCPU_PREEMPTED;
> > > >
> > > >       kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime=
,
> > > > --
> > > > 2.25.0.rc1.283.g88dfdc4193-goog
> > > >
> > >
