Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DD57CFE54
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 17:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346416AbjJSPle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 11:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346382AbjJSPlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 11:41:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA566CF
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:41:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9cad450d5fso1388404276.1
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697730060; x=1698334860; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=adJjdu4zvZG+fV58j+myDpWsiZ+K2SAIeatTq8Py4kU=;
        b=foQ+LfGo9+WT/avUhTGnzauJXTbM6NwkDppKG6a6BczeQrxlDRXJYrpTq7LFkp1oc3
         ucia+fPj6pyW/NxlwRhedJ3svJTBZ+/AGrQBkx9TyAsDibGmGE4DsR8sW+8hzsAKznDG
         frGCjG6YGA0Fq3jeKguwDSyq7nBf2JeH/YuyB9ydwEezF5hZODCsWKKhvyF4bSpOwXnd
         tdi3jl9W+0rjmsORyEsXec/os1LOym/GmNtunZ0qGVoh8ositeNy0nYTY2lQVN47Hf8H
         py0Yz8UVi9duYVDFfXWc57DedgXABf59d/dlWDXT4gRddiTnAUc/jIw5gTxOt4Ks45RR
         So2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697730060; x=1698334860;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=adJjdu4zvZG+fV58j+myDpWsiZ+K2SAIeatTq8Py4kU=;
        b=tUD14cXyURuL+rplQ5kvM/0nbja8LKvr1C/BnQIi2o9+WTH591IxwNs2T0e5a6cc7l
         hMmWQkWehuEuFDrTrhf5Xg2tqnx3gUCYmZRaQFOBokhiPyja17md+emy+FaCPmEqlBzO
         bGPLYrppwtgMhmhKVD1tyXOg3uAhTNSNrPAJ0WNn45MrXqG//wkgilY0UEa2kZ/K90O0
         Rz6FdUTStXAFdIy4E+1ScoplkCyg/NGyulWAPP2SRzjRfrwdfcuZprVNELm+CYKwAY9F
         ompv1Kj4rtABAHs1mA3co8qh4ndsFJRw8NFYsMmLUE2CbX7evc6TFC1yB/YsY99MeZ6e
         nhxQ==
X-Gm-Message-State: AOJu0YzjibUHsUE9zoIgH7sJLaxcCG+qayMUZnint+vCyW8hgmXPdz4j
        3maHGI7bJHqRlH0tCfBDaMPMK9QglCw=
X-Google-Smtp-Source: AGHT+IEdAkwGSI4JXsyGWR6R4FkKE7IdPr0rYajN80sqqfNdMpoFfjfsMAfenGioX8KaYubfndjOkTOpzXY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:a04:0:b0:d9a:6855:6d31 with SMTP id
 k4-20020a5b0a04000000b00d9a68556d31mr59932ybq.3.1697730059906; Thu, 19 Oct
 2023 08:40:59 -0700 (PDT)
Date:   Thu, 19 Oct 2023 08:40:58 -0700
In-Reply-To: <87ttqm6d3f.fsf@redhat.com>
Mime-Version: 1.0
References: <20231018221123.136403-1-dongli.zhang@oracle.com> <87ttqm6d3f.fsf@redhat.com>
Message-ID: <ZTFOCqMCuSiH8VEt@google.com>
Subject: Re: [PATCH RFC 1/1] x86/paravirt: introduce param to disable pv sched_clock
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        pv-drivers@vmware.com, xen-devel@lists.xenproject.org,
        linux-hyperv@vger.kernel.org, jgross@suse.com, akaher@vmware.com,
        amakhalov@vmware.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, peterz@infradead.org,
        dwmw2@infradead.org, joe.jin@oracle.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023, Vitaly Kuznetsov wrote:
> Dongli Zhang <dongli.zhang@oracle.com> writes:
>=20
> > As mentioned in the linux kernel development document, "sched_clock() i=
s
> > used for scheduling and timestamping". While there is a default native
> > implementation, many paravirtualizations have their own implementations=
.
> >
> > About KVM, it uses kvm_sched_clock_read() and there is no way to only
> > disable KVM's sched_clock. The "no-kvmclock" may disable all
> > paravirtualized kvmclock features.

...

> > Please suggest and comment if other options are better:
> >
> > 1. Global param (this RFC patch).
> >
> > 2. The kvmclock specific param (e.g., "no-vmw-sched-clock" in vmware).
> >
> > Indeed I like the 2nd method.
> >
> > 3. Enforce native sched_clock only when TSC is invariant (hyper-v metho=
d).
> >
> > 4. Remove and cleanup pv sched_clock, and always use pv_sched_clock() f=
or
> > all (suggested by Peter Zijlstra in [3]). Some paravirtualizations may
> > want to keep the pv sched_clock.
>=20
> Normally, it should be up to the hypervisor to tell the guest which
> clock to use, i.e. if TSC is reliable or not. Let me put my question
> this way: if TSC on the particular host is good for everything, why
> does the hypervisor advertises 'kvmclock' to its guests?

I suspect there are two reasons.

  1. As is likely the case in our fleet, no one revisited the set of advert=
ised
     PV features when defining the VM shapes for a new generation of hardwa=
re, or
     whoever did the reviews wasn't aware that advertising kvmclock is actu=
ally
     suboptimal.  All the PV clock stuff in KVM is quite labyrinthian, so i=
t's
     not hard to imagine it getting overlooked.

  2. Legacy VMs.  If VMs have been running with a PV clock for years, forci=
ng
     them to switch to a new clocksource is high-risk, low-reward.

> If for some 'historical reasons' we can't revoke features we can always
> introduce a new PV feature bit saying that TSC is preferred.
>=20
> 1) Global param doesn't sound like a good idea to me: chances are that
> people will be setting it on their guest images to workaround problems
> on one hypervisor (or, rather, on one public cloud which is too lazy to
> fix their hypervisor) while simultaneously creating problems on another.
>=20
> 2) KVM specific parameter can work, but as KVM's sched_clock is the same
> as kvmclock, I'm not convinced it actually makes sense to separate the
> two. Like if sched_clock is known to be bad but TSC is good, why do we
> need to use PV clock at all? Having a parameter for debugging purposes
> may be OK though...
>=20
> 3) This is Hyper-V specific, you can see that it uses a dedicated PV bit
> (HV_ACCESS_TSC_INVARIANT) and not the architectural
> CPUID.80000007H:EDX[8]. I'm not sure we can blindly trust the later on
> all hypervisors.
>=20
> 4) Personally, I'm not sure that relying on 'TSC is crap' detection is
> 100% reliable. I can imagine cases when we can't detect that fact that
> while synchronized across CPUs and not going backwards, it is, for
> example, ticking with an unstable frequency and PV sched clock is
> supposed to give the right correction (all of them are rdtsc() based
> anyways, aren't they?).

Yeah, practically speaking, the only thing adding a knob to turn off using =
PV
clocks for sched_clock will accomplish is creating an even bigger matrix of
combinations that can cause problems, e.g. where guests end up using kvmclo=
ck
timekeeping but not scheduling.

The explanation above and the links below fail to capture _the_ key point:
Linux-as-a-guest already prioritizes the TSC over paravirt clocks as the cl=
ocksource
when the TSC is constant and nonstop (first spliced blob below).

What I suggested is that if the TSC is chosen over a PV clock as the clocks=
ource,
then we have the kernel also override the sched_clock selection (second spl=
iced
blob below).

That doesn't require the guest admin to opt-in, and doesn't create even mor=
e
combinations to support.  It also provides for a smoother transition for wh=
en
customers inevitably end up creating VMs on hosts that don't advertise kvmc=
lock
(or any PV clock).

> > To introduce a param may be easier to backport to old kernel version.
> >
> > References:
> > [1] https://lore.kernel.org/all/20230926230649.67852-1-dongli.zhang@ora=
cle.com/
> > [2] https://lore.kernel.org/all/20231018195638.1898375-1-seanjc@google.=
com/
> > [3] https://lore.kernel.org/all/20231002211651.GA3774@noisy.programming=
.kicks-ass.net/

On Mon, Oct 2, 2023 at 11:18=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> > Do we need to update the documentation to always suggest TSC when it is
> > constant, as I believe many users still prefer pv clock than tsc?
> >
> > Thanks to tsc ratio scaling, the live migration will not impact tsc.
> >
> > >From the source code, the rating of kvm-clock is still higher than tsc=
.
> >
> > BTW., how about to decrease the rating if guest detects constant tsc?
> >
> > 166 struct clocksource kvm_clock =3D {
> > 167         .name   =3D "kvm-clock",
> > 168         .read   =3D kvm_clock_get_cycles,
> > 169         .rating =3D 400,
> > 170         .mask   =3D CLOCKSOURCE_MASK(64),
> > 171         .flags  =3D CLOCK_SOURCE_IS_CONTINUOUS,
> > 172         .enable =3D kvm_cs_enable,
> > 173 };
> >
> > 1196 static struct clocksource clocksource_tsc =3D {
> > 1197         .name                   =3D "tsc",
> > 1198         .rating                 =3D 300,
> > 1199         .read                   =3D read_tsc,
>
> That's already done in kvmclock_init().
>
>         if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
>             boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
>             !check_tsc_unstable())
>                 kvm_clock.rating =3D 299;
>
> See also: https://lore.kernel.org/all/ZOjF2DMBgW%2FzVvL3@google.com
>
> > 2. The sched_clock.
> >
> > The scheduling is impacted if there is big drift.
>
> ...
>
> > Unfortunately, the "no-kvmclock" kernel parameter disables all pv clock
> > operations (not only sched_clock), e.g., after line 300.
>
> ...
>
> > Should I introduce a new param to disable no-kvm-sched-clock only, or t=
o
> > introduce a new param to allow the selection of sched_clock?
>
> I don't think we want a KVM-specific knob, because every flavor of paravi=
rt guest
> would need to do the same thing.  And unless there's a good reason to use=
 a
> paravirt clock, this really shouldn't be something the guest admin needs =
to opt
> into using.


On Mon, Oct 2, 2023 at 2:06=E2=80=AFPM Peter Zijlstra <peterz@infradead.org=
> wrote:
>
> On Mon, Oct 02, 2023 at 11:18:50AM -0700, Sean Christopherson wrote:
> > Assuming the desirable thing to do is to use native_sched_clock() in th=
is
> > scenario, do we need a separate rating system, or can we simply tie the
> > sched clock selection to the clocksource selection, e.g. override the
> > paravirt stuff if the TSC clock has higher priority and is chosen?
>
> Yeah, I see no point of another rating system. Just force the thing back
> to native (or don't set it to that other thing).
