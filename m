Return-Path: <kvm+bounces-11151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2118873A62
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 590DB289726
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 15:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AF31350F2;
	Wed,  6 Mar 2024 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4POVxNX1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ADA131745
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 15:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709737819; cv=none; b=HKrnxVPU5BkW1ISe74d0sDMi4tORy4LHuH2KYrHpfkoWr2lRX9DSEYr1m/fjCnfJ79Ict4ko5+Bct+yUT/wAGG+KRMhqUp8Ib5h9qGKRERCuEvdjkTx4XnoNTBr+dTTgntDX90jJUEEGaFZwhCE2Ao7dweyvO6uPIvM2korKF+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709737819; c=relaxed/simple;
	bh=qjcYnOAyDzwpMl+5pOVw0IVok5rrLJ4e3o/tFfBhl94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PsYwdPvqm9HMFmY3mCRhyRA/mZdHEf5bqgGWE8ZHbh3jTwFK10WlZ19jl1A4LWqxSrnIUMRTN16yKfv6c1KA45YiBVzwz9wU8cy25kTc8nRCXKdpxfEmQQZO2pecb2Mmd4M2voqIoom+psK6hnJW7B1rvD7eWtTTGbD/kz51b9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4POVxNX1; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-566b160f6eeso11967a12.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 07:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709737815; x=1710342615; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WiqlRH5D1PVFZ4xdoZ1pgXd2c0JlwaOYFpF6GFPgDLc=;
        b=4POVxNX1J4awkvhNO9sXZexzqvQAHV34MdBl8y6xO9Awujdm3GUH9gp5dbsCJIV7B8
         vXIc6LWF1a4ejkZyuMUxSVnw4TqSaN6sU3NyqQ6fvnH870xpXw2ef4DVAs2Foobpb6j+
         OuxHbpm7i37920BGc3KCEhFW1MVXWcAjQk2JDHDDaz8Jo+y2SqPDZJwnNtmdt6xkyhBI
         Sv+xYkB9V2U/p2HeiWH4a0ewMIXraEIiKPdwELd5/mIQhhA7uz+NdNVJi7TSNgXbBMRh
         zbK1XfnHDYDgoRinYB2gNvyGr+u286RaTf+GOboyI03dzGvI+ySwll3+kmG36ADJcnxP
         3/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709737815; x=1710342615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WiqlRH5D1PVFZ4xdoZ1pgXd2c0JlwaOYFpF6GFPgDLc=;
        b=mYAOKSWl1c0mVIhrsPqQYz3HDOoLVkaIGw+TIrj1qcUdYSm355H5opVD6XL8/D74mm
         /E2xUno+FDvEwGAD+7LjaQ7WkT73BdnXVGI7mLh6j258DhgioBz9spvWlQBQVznqVqyG
         Fi06WbwXD0f2k58TM6Lx0YyDH5srHGVux2NwVPxu2I5E2UzLNQd9CfyHQDm2qarQI0pq
         9htWo+HiJxCklXCXwkQ62KyFV81+Re5QB4H4EXn6a5PbukX8LNvah2Y7C+yrN2PXYs2Z
         wd1g1qWjuloqa480thKB6f/lMrD2qw+GGcWJVf3oKdDt40dhctuM7WdWWV6uQLsaTejT
         g7Uw==
X-Forwarded-Encrypted: i=1; AJvYcCXukUTVyCb3ReelGarCIU73QTtF6gvHu7622Gxiv8jwlafCC5LKpBnBPnBj6w8oIwHwF2Dm7TdUviDewhTKOLOeAire
X-Gm-Message-State: AOJu0Yzs6JwVvfYYU+TanSi/yPoOGG/QUUZk5NDnyZilrYFZ7Mvw2f94
	T35Qod+PQFX7fEgPT8jFVQ84RzulAO9U4GkvSmMzBxXK+2BndulHReU68dUkY/I25NCMF1vHV/c
	xKGVqsJyFXvtEBSqANlrNMM6SeTrt+SL3XyL6
X-Google-Smtp-Source: AGHT+IFB1IcbYq+9PUXUuTDs2L8KEUVjGvpB3JhRS9KEiojP6irE5Yzg60XIM8yO4VltL6KJuGJoi6jd4Dm6myghMKI=
X-Received: by 2002:aa7:c397:0:b0:566:a44d:2a87 with SMTP id
 k23-20020aa7c397000000b00566a44d2a87mr405942edq.0.1709737815010; Wed, 06 Mar
 2024 07:10:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230824020546.1108516-1-dapeng1.mi@linux.intel.com>
 <ZeepGjHCeSfadANM@google.com> <2677739b-bc84-43ee-ba56-a5e243148ceb@gmail.com>
In-Reply-To: <2677739b-bc84-43ee-ba56-a5e243148ceb@gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 6 Mar 2024 07:09:59 -0800
Message-ID: <CALMp9eQ531ZC-8-Y+gwLer9mCK-hZ9yVNQZAFE6z76RXkMNnPA@mail.gmail.com>
Subject: Re: [Patch v3] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
To: Like Xu <like.xu.linux@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Kan Liang <kan.liang@linux.intel.com>, 
	Like Xu <likexu@tencent.com>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 6, 2024 at 1:11=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> wr=
ote:
>
> On 6/3/2024 7:22 am, Sean Christopherson wrote:
> > +Mingwei
> >
> > On Thu, Aug 24, 2023, Dapeng Mi wrote:
> >   diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> >> index 7d9ba301c090..ffda2ecc3a22 100644
> >> --- a/arch/x86/kvm/pmu.h
> >> +++ b/arch/x86/kvm/pmu.h
> >> @@ -12,7 +12,8 @@
> >>                                        MSR_IA32_MISC_ENABLE_BTS_UNAVAI=
L)
> >>
> >>   /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
> >> -#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & =
0xf)
> >> +#define fixed_ctrl_field(ctrl_reg, idx) \
> >> +    (((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_=
BITS_MASK)
> >>
> >>   #define VMWARE_BACKDOOR_PMC_HOST_TSC               0x10000
> >>   #define VMWARE_BACKDOOR_PMC_REAL_TIME              0x10001
> >> @@ -165,7 +166,8 @@ static inline bool pmc_speculative_in_use(struct k=
vm_pmc *pmc)
> >>
> >>      if (pmc_is_fixed(pmc))
> >>              return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> >> -                                    pmc->idx - INTEL_PMC_IDX_FIXED) &=
 0x3;
> >> +                                    pmc->idx - INTEL_PMC_IDX_FIXED) &
> >> +                                    (INTEL_FIXED_0_KERNEL | INTEL_FIX=
ED_0_USER);
> >>
> >>      return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
> >>   }
> >> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel=
.c
> >> index f2efa0bf7ae8..b0ac55891cb7 100644
> >> --- a/arch/x86/kvm/vmx/pmu_intel.c
> >> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> >> @@ -548,8 +548,13 @@ static void intel_pmu_refresh(struct kvm_vcpu *vc=
pu)
> >>              setup_fixed_pmc_eventsel(pmu);
> >>      }
> >>
> >> -    for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++)
> >> -            pmu->fixed_ctr_ctrl_mask &=3D ~(0xbull << (i * 4));
> >> +    for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >> +            pmu->fixed_ctr_ctrl_mask &=3D
> >> +                     ~intel_fixed_bits_by_idx(i,
> >> +                                              INTEL_FIXED_0_KERNEL |
> >> +                                              INTEL_FIXED_0_USER |
> >> +                                              INTEL_FIXED_0_ENABLE_PM=
I);
> >> +    }
> >>      counter_mask =3D ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
> >>              (((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC=
_IDX_FIXED));
> >>      pmu->global_ctrl_mask =3D counter_mask;
> >> @@ -595,7 +600,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcp=
u)
> >>                      pmu->reserved_bits &=3D ~ICL_EVENTSEL_ADAPTIVE;
> >>                      for (i =3D 0; i < pmu->nr_arch_fixed_counters; i+=
+) {
> >>                              pmu->fixed_ctr_ctrl_mask &=3D
> >> -                                    ~(1ULL << (INTEL_PMC_IDX_FIXED + =
i * 4));
> >
> > OMG, this might just win the award for most obfuscated PMU code in KVM,=
 which is
> > saying something.  The fact that INTEL_PMC_IDX_FIXED happens to be 32, =
the same
> > bit number as ICL_FIXED_0_ADAPTIVE, is 100% coincidence.  Good riddance=
.
> >
> > Argh, and this goofy code helped introduce a real bug.  reprogram_fixed=
_counters()
> > doesn't account for the upper 32 bits of IA32_FIXED_CTR_CTRL.
> >
> > Wait, WTF?  Nothing in KVM accounts for the upper bits.  This can't pos=
sibly work.
> >
> > IIUC, because KVM _always_ sets precise_ip to a non-zero bit for PEBS e=
vents,
> > perf will _always_ generate an adaptive record, even if the guest reque=
sted a
> > basic record.  Ugh, and KVM will always generate adaptive records even =
if the
> > guest doesn't support them.  This is all completely broken.  It probabl=
y kinda
> > sorta works because the Basic info is always stored in the record, and =
generating
> > more info requires a non-zero MSR_PEBS_DATA_CFG, but ugh.
>
> Yep, it works at least on machines with both adaptive and pebs_full featu=
res.
>
> I remember one generation of Atom core (? GOLDMONT) that didn't have both
> above PEBS sub-features, so we didn't set x86_pmu.pebs_ept on that platfo=
rm.
>
> Mingwei or others are encouraged to construct use cases in KUT::pmu_pebs.=
flat
> that violate guest-pebs rules (e.g., leak host state), as we all recogniz=
e that
> testing
> is the right way to condemn legacy code, not just lengthy emails.
>
> >
> > Oh great, and it gets worse.  intel_pmu_disable_fixed() doesn't clear t=
he upper
> > bits either, i.e. leaves ICL_FIXED_0_ADAPTIVE set.  Unless I'm misreadi=
ng the code,
> > intel_pmu_enable_fixed() effectively doesn't clear ICL_FIXED_0_ADAPTIVE=
 either,
> > as it only modifies the bit when it wants to set ICL_FIXED_0_ADAPTIVE.
> >
> > *sigh*
> >
> > I'm _very_ tempted to disable KVM PEBS support for the current PMU, and=
 make it
> > available only when the so-called passthrough PMU is available[*].  Bec=
ause I
> > don't see how this is can possibly be functionally correct, nor do I se=
e a way
> > to make it functionally correct without a rather large and invasive ser=
ies.
>
> Considering that I've tried the idea myself, I have no inclination toward=
s
> "passthrough PMU", and I'd like to be able to take the time to review tha=
t
> patchset while we all wait for a clear statement from that perf-core man,
> who don't really care about virtualization and don't want to lose control
> of global hardware resources.
>
> Before we actually get to that ideal state you want, we have to deal with
> some intermediate state and face to any users that rely on the current co=
de,
> you had urged to merge in a KVM document for vPMU, not sure how far
> along that part of the work is.
>
> >
> > Ouch.  And after chatting with Mingwei, who asked the very good questio=
n of
> > "can this leak host state?", I am pretty sure that yes, this can leak h=
ost state.
>
> The Basic Info has a tsc field, I suspect it's the host-state-tsc.
>
> >
> > When PERF_CAP_PEBS_BASELINE is enabled for the guest, i.e. when the gue=
st has
> > access to adaptive records, KVM gives the guest full access to MSR_PEBS=
_DATA_CFG
> >
> >       pmu->pebs_data_cfg_mask =3D ~0xff00000full;
> >
> > which makes sense in a vacuum, because AFAICT the architecture doesn't =
allow
> > exposing a subset of the four adaptive controls.
> >
> > GPRs and XMMs are always context switched and thus benign, but IIUC, Me=
mory Info
> > provides data that might now otherwise be available to the guest, e.g. =
if host
> > userspace has disallowed equivalent events via KVM_SET_PMU_EVENT_FILTER=
.
>
> Indeed, KVM_SET_PMU_EVENT_FILTER doesn't work in harmony with
> guest-pebs, and I believe there is a big problem here, especially with th=
e
> lack of targeted testing.
>
> One reason for this is that we don't use this cockamamie API in our
> large-scale production environments, and users of vPMU want to get real
> runtime information about physical cpus, not just virtualised hardware
> architecture interfaces.
>
> >
> > And unless I'm missing something, LBRs are a full leak of host state.  =
Nothing
> > in the SDM suggests that PEBS records honor MSR intercepts, so unless K=
VM is
> > also passing through LBRs, i.e. is context switching all LBR MSRs, the =
guest can
> > use PEBS to read host LBRs at will.
>
> KVM is also passing through LBRs when guest uses LBR but not at the
> granularity of vm-exit/entry. I'm not sure if the LBR_EN bit is required
> to get LBR information via PEBS, also not confirmed whether PEBS-lbr
> can be enabled at the same time as independent LBR;
>
> I recall that PEBS-assist, per cpu-arch, would clean up this part of the
> record when crossing root/non-root boundaries, or not generate record.
>
> We're looking forward to the tests that will undermine this perception.
>
> There are some devilish details during the processing of vm-exit and
> the generation of host/guest pebs, and those interested can delve into
> the short description in this SDM section "20.9.5 EPT-Friendly PEBS".
>
> >
> > Unless someone chimes in to point out how PEBS virtualization isn't a b=
roken mess,
> > I will post a patch to effectively disable PEBS virtualization.
>
> There are two factors that affect the availability of guest-pebs:
>
> 1. the technical need to use core-PMU in both host/guest worlds;
> (I don't think Googlers are paying attention to this part of users' needs=
)

Let me clear up any misperceptions you might have that Google alone is
foisting the pass-through PMU on the world. The work so far has been a
collaboration between Google and Intel. Now, AMD has joined the
collaboration as well. Mingwei is taking the lead on the project, but
Googlers are outnumbered by the x86 CPU vendors ten to one.

The pass-through PMU allows both the host and guest worlds to use the
core PMU, more so than the existing vPMU implementation. I assume your
complaint is about the desire for host software to monitor guest
behavior with core PMU events while the guest is running. Today,
Google Cloud does this for fleet management, and losing this
capability is not something we are looking forward to. However, the
writing is on the wall: Coco is going to take this capability away
from us anyway.

> 2. guest-pebs is temporarily disabled in the case of cross-mapping counte=
r,
> which reduces the number of performance samples collected by guest;
>
> >
> > diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabil=
ities.h
> > index 41a4533f9989..a2f827fa0ca1 100644
> > --- a/arch/x86/kvm/vmx/capabilities.h
> > +++ b/arch/x86/kvm/vmx/capabilities.h
> > @@ -392,7 +392,7 @@ static inline bool vmx_pt_mode_is_host_guest(void)
> >
> >   static inline bool vmx_pebs_supported(void)
> >   {
> > -       return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
> > +       return false;
>
> As you know, user-space VMM may disable guest-pebs by filtering out the
> MSR_IA32_PERF_CAPABILITIE.PERF_CAP_PEBS_FORMAT or CPUID.PDCM.
>
> In the end, if our great KVM maintainers insist on doing this,
> there is obviously nothing I can do about it.
>
> Hope you have a good day.
>
> >   }
> >
> >   static inline bool cpu_has_notify_vmexit(void)
> >
>

