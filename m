Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133F8F042D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 18:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390506AbfKERfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 12:35:25 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44934 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389475AbfKERfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 12:35:25 -0500
Received: by mail-io1-f68.google.com with SMTP id w12so23559549iol.11
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 09:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YXVxqwM20iATtuLm+TaFp/C5wa802sVG3d1I3LYHhRM=;
        b=m8HMah4OwpyMZMr/iHC4UZpo2eScdFCidT45VTc/NzEJXQXAhJahEu0j6hQJSzRjr2
         AviCD8hMd1bRDJuFTAX2d+bFQY099a0am8Ly4DIZN8ObUoXJeCu4AicSDfEVnvEl6nqZ
         Qm9dU6uhB4Pxf+//+HvKWw/ogv4bHFFPIgO4iQI88vhbKB/HrfRoyf8/R8BU9D8rCgOe
         LQeI7T2FFVR+5o751QtVXZKfuRodkRXY5pL7YpJZqdBcE3h7/slo3WBUKPSM0sOrjkhO
         719YL0x2Z2J1/N23jcSD3CCCyO+DdmZhvqHSRloIyvYFh7AfMvMnlhJ96KQUmMU4OMMP
         L/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YXVxqwM20iATtuLm+TaFp/C5wa802sVG3d1I3LYHhRM=;
        b=VFzDZm7RKsZTFj/2uOtpc1LNB6/S4HCE8Kv6Y/yy7sbLyuE34lvnuYQIsE2EMF3r9Y
         90BzUR7D2tDvpi7T5Rg/UUpsPnkTmMkRd1b2Z+zSPvzkzbHTZNjx8W0/AT1hwebW4O5n
         cUhSNgr/1joDP9hzEhHRNuumYcmW5FJ3f0XhxGiIxuWhUuRHvhEiNrVNNUfU4F+mBe2h
         oB3D3Cr1J5fVfjE07SFE6KJeBvQ7KdAqIvk7+WztNec1/mtpLZPVNmH1bFnrVt183VJO
         zyB8mWng7xgyfPIqkhP3KIkiSGiJ7HgJ5cth8Sp9RtVj6EjscEd6cHvApjl5fkt1UsGL
         2Yfg==
X-Gm-Message-State: APjAAAXeVQCnADOOx03jTjNb4nEU9+PPPr+zLJuZjocTlJ11rAhC8hKQ
        jGe9+z8xq3DkKlcmoOji2lYPRi+t9zikzUHjI3M/eA==
X-Google-Smtp-Source: APXvYqyIQoEKcl1p2lGy+dC1Gp27DPA+E3Vv00Lxy94zOJFoA8/nH2RM/TmoFOnJjcTp8P/PzNsRUjzmQdfwk88olwM=
X-Received: by 2002:a5d:8146:: with SMTP id f6mr30651144ioo.108.1572975322845;
 Tue, 05 Nov 2019 09:35:22 -0800 (PST)
MIME-Version: 1.0
References: <20191105161737.21395-1-vkuznets@redhat.com> <83B55424-13A9-4395-98E8-466FFF4C698E@oracle.com>
 <D00B364F-BB9D-40A2-9092-D79EBD0B4135@oracle.com>
In-Reply-To: <D00B364F-BB9D-40A2-9092-D79EBD0B4135@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 5 Nov 2019 09:35:11 -0800
Message-ID: <CALMp9eSqMoFxmxXsCoXu1rqCzLca5GyhHf6RV0MUq6SKZsjzWw@mail.gmail.com>
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is trustworthy
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 5, 2019 at 9:32 AM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 5 Nov 2019, at 19:17, Liran Alon <liran.alon@oracle.com> wrote:
> >
> >
> >
> >> On 5 Nov 2019, at 18:17, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >> Virtualized guests may pick a different strategy to mitigate hardware
> >> vulnerabilities when it comes to hyper-threading: disable SMT complete=
ly,
> >> use core scheduling, or, for example, opt in for STIBP. Making the
> >> decision, however, requires an extra bit of information which is curre=
ntly
> >> missing: does the topology the guest see match hardware or if it is 'f=
ake'
> >> and two vCPUs which look like different cores from guest's perspective=
 can
> >> actually be scheduled on the same physical core. Disabling SMT or doin=
g
> >> core scheduling only makes sense when the topology is trustworthy.
> >
> > This is not only related to vulnerability mitigations.
> > It=E2=80=99s also important for guest to know if it=E2=80=99s SMT topol=
ogy is trustworthy for various optimisation algorithms.
> > E.g. Should it attempt to run tasks that share memory on same NUMA node=
?
> >
> >>
> >> Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the mean=
ing
> >> that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the exposed=
 SMT
> >> topology is actually trustworthy. It would, of course, be possible to =
get
> >> away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose back=
wards
> >> compatibility but the current approach looks more straightforward.
> >
> > Agree.
> >
> >>
> >> There were some offline discussions on whether this new feature bit sh=
ould
> >> be complemented with a 're-enlightenment' mechanism for live migration=
 (so
> >> it can change in guest's lifetime) but it doesn't seem to be very
> >> practical: what a sane guest is supposed to do if it's told that SMT
> >> topology is about to become fake other than kill itself? Also, it seem=
s to
> >> make little sense to do e.g. CPU pinning on the source but not on the
> >> destination.
> >
> > Agree.
> >
> >>
> >> There is also one additional piece of the information missing. A VM ca=
n be
> >> sharing physical cores with other VMs (or other userspace tasks on the
> >> host) so does KVM_FEATURE_TRUSTWORTHY_SMT imply that it's not the case=
 or
> >> not? It is unclear if this changes anything and can probably be left o=
ut
> >> of scope (just don't do that).
> >
> > I don=E2=80=99t think KVM_FEATURE_TRUSTWORTHY_SMT should indicate to gu=
est whether it=E2=80=99s vCPU shares a CPU core with another guest.
> > It should only expose to guest the fact that he can rely on it=E2=80=99=
s virtual SMT topology. i.e. That there is a relation between virtual SMT t=
opology
> > to which physical logical processors run which vCPUs.
> >
> > Guest have nothing to do with the fact that he is now aware host doesn=
=E2=80=99t guarantee to him that one of it=E2=80=99s vCPU shares a CPU core=
 with another guest vCPU.
> > I don=E2=80=99t think we should have a CPUID bit that expose this infor=
mation to guest.
> >
> >>
> >> Similar to the already existent 'NoNonArchitecturalCoreSharing' Hyper-=
V
> >> enlightenment, the default value of KVM_HINTS_TRUSTWORTHY_SMT is set t=
o
> >> !cpu_smt_possible(). KVM userspace is thus supposed to pass it to gues=
t's
> >> CPUIDs in case it is '1' (meaning no SMT on the host at all) or do som=
e
> >> extra work (like CPU pinning and exposing the correct topology) before
> >> passing '1' to the guest.
> >
> > Hmm=E2=80=A6 I=E2=80=99m not sure this is correct.
> > For example, it is possible to expose in virtual SMT topology that gues=
t have 2 vCPUs running on single NUMA node,
> > while in reality each vCPU task can be scheduled to run on different NU=
MA nodes. Therefore, making virtual SMT topology not trustworthy.
> > i.e. Disabling SMT on host doesn=E2=80=99t mean that virtual SMT topolo=
gy is reliable.
> >
> > I think this CPUID bit should just be set from userspace when admin hav=
e guaranteed to guest that it have set vCPU task affinity properly.
> > Without KVM attempting to set this bit by itself.
> >
> > Note that we defined above KVM_HINTS_TRUSTWORTHY_SMT bit differently th=
an =E2=80=9CNoNonArchitecturalCoreSharing=E2=80=9D.
> > =E2=80=9CNoNonArchitecturalCoreSharing=E2=80=9D guarantees to guest tha=
t vCPUs of guest won=E2=80=99t share a physical CPU core unless they are de=
fined as virtual SMT siblings.
> > In contrast, KVM_HINTS_TRUSTWORTHY_SMT bit attempts to state that virtu=
al SMT topology is a subset of how vCPUs are scheduled on physical SMT topo=
logy.
> > i.e. It seems that Hyper-V bit is indeed only attempting to provide gue=
st information related to security mitigations. While newly proposed KVM bi=
t attempts to also
> > assist guest to determine how to perform it=E2=80=99s internal scheduli=
ng decisions.
> >
> > -Liran
>
> Oh I later saw below that you defined KVM_HINTS_TRUSTWORTHY_SMT indeed as=
 Microsoft defined =E2=80=9CNoNonArchitecturalCoreSharing=E2=80=9D.
> If you plan to go with this direction, than I suggest renaming to similar=
 name as Hyper-V.
> But I think having a general vSMT topology is trustworthy is also useful.
> Maybe we should have separate bits for each.

And perhaps a bit each for "vCCX topology is trustworthy" and "vNUMA
topology is trustworthy"?

> -Liran
>
> >
> >>
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >> Documentation/virt/kvm/cpuid.rst     | 27 +++++++++++++++++++--------
> >> arch/x86/include/uapi/asm/kvm_para.h |  2 ++
> >> arch/x86/kvm/cpuid.c                 |  7 ++++++-
> >> 3 files changed, 27 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm=
/cpuid.rst
> >> index 01b081f6e7ea..64b94103fc90 100644
> >> --- a/Documentation/virt/kvm/cpuid.rst
> >> +++ b/Documentation/virt/kvm/cpuid.rst
> >> @@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest=
 checks this feature bit
> >>                                              before using paravirtuali=
zed
> >>                                              sched yield.
> >>
> >> +KVM_FEATURE_TRUSTWORTHY_SMT       14          set when host supports =
'SMT
> >> +                                              topology is trustworthy=
' hint
> >> +                                              (KVM_HINTS_TRUSTWORTHY_=
SMT).
> >> +
> >> KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no gue=
st-side
> >>                                              per-cpu warps are expeced=
 in
> >>                                              kvmclock
> >> @@ -97,11 +101,18 @@ KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          hos=
t will warn if no guest-side
> >>
> >> Where ``flag`` here is defined as below:
> >>
> >> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> -flag               value        meaning
> >> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> -KVM_HINTS_REALTIME 0            guest checks this feature bit to
> >> -                                determine that vCPUs are never
> >> -                                preempted for an unlimited time
> >> -                                allowing optimizations
> >> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >> +flag                              value       meaning
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >> +KVM_HINTS_REALTIME                0           guest checks this featu=
re bit to
> >> +                                              determine that vCPUs ar=
e never
> >> +                                              preempted for an unlimi=
ted time
> >> +                                              allowing optimizations
> >> +
> >> +KVM_HINTS_TRUSTWORTHY_SMT         1           the bit is set when the=
 exposed
> >> +                                              SMT topology is trustwo=
rthy, this
> >> +                                              means that two guest vC=
PUs will
> >> +                                              never share a physical =
core
> >> +                                              unless they are exposed=
 as SMT
> >> +                                              threads.
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/u=
api/asm/kvm_para.h
> >> index 2a8e0b6b9805..183239d5dfad 100644
> >> --- a/arch/x86/include/uapi/asm/kvm_para.h
> >> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> >> @@ -31,8 +31,10 @@
> >> #define KVM_FEATURE_PV_SEND_IPI      11
> >> #define KVM_FEATURE_POLL_CONTROL     12
> >> #define KVM_FEATURE_PV_SCHED_YIELD   13
> >> +#define KVM_FEATURE_TRUSTWORTHY_SMT 14
> >>
> >> #define KVM_HINTS_REALTIME      0
> >> +#define KVM_HINTS_TRUSTWORTHY_SMT   1
> >>
> >> /* The last 8 bits are used to indicate how to interpret the flags fie=
ld
> >> * in pvclock structure. If no bits are set, all flags are ignored.
> >> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >> index f68c0c753c38..dab527a7081f 100644
> >> --- a/arch/x86/kvm/cpuid.c
> >> +++ b/arch/x86/kvm/cpuid.c
> >> @@ -712,7 +712,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid=
_entry2 *entry, u32 function,
> >>                           (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
> >>                           (1 << KVM_FEATURE_PV_SEND_IPI) |
> >>                           (1 << KVM_FEATURE_POLL_CONTROL) |
> >> -                         (1 << KVM_FEATURE_PV_SCHED_YIELD);
> >> +                         (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> >> +                         (1 << KVM_FEATURE_TRUSTWORTHY_SMT);
> >>
> >>              if (sched_info_on())
> >>                      entry->eax |=3D (1 << KVM_FEATURE_STEAL_TIME);
> >> @@ -720,6 +721,10 @@ static inline int __do_cpuid_func(struct kvm_cpui=
d_entry2 *entry, u32 function,
> >>              entry->ebx =3D 0;
> >>              entry->ecx =3D 0;
> >>              entry->edx =3D 0;
> >> +
> >> +            if (!cpu_smt_possible())
> >> +                    entry->edx |=3D (1 << KVM_HINTS_TRUSTWORTHY_SMT);
> >> +
> >>              break;
> >>      case 0x80000000:
> >>              entry->eax =3D min(entry->eax, 0x8000001f);
> >> --
> >> 2.20.1
> >>
> >
>
