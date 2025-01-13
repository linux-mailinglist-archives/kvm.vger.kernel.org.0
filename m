Return-Path: <kvm+bounces-35315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EDD5A0C122
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 20:15:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BDDB3A853E
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 19:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3DC1CC8AE;
	Mon, 13 Jan 2025 19:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fpUUarWE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840931C5F36
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 19:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736795723; cv=none; b=rskH3WkxvpYZKP4938qOnMB8LPW4z6rXgrjjavDJdkLsCa7F+yeXgAbU2+VZVWrp8t9cGHF+BGFbY2J5lMoHIADKER+GZpLtlJ7b9QXXDmIo/9nc/iSefrpSVdGjvS7k/OtE7ywdssIhQRVkt9VKZovd0ePgPVxj6STNkFOnz6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736795723; c=relaxed/simple;
	bh=jh8EsFjL30RqJJWE8+6zmIg2C6jFVg8q4vqby6c0BxQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GimRlEc0qXQ21XLPLDYXJWJpCcHNSgkCLwE0r87wuWdv8wnkRa3ojduhcNKiJ1jzQDDO7iidnkM/2uoVWKvgoIyqy2S5IWLWO1A4SkQdIYvgLKAhZx/aPx/C7AYpYPu1GbWvnlMpEmYYFNaoHumhK6sLAhniqsS+S5IIdmWO80c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fpUUarWE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef35de8901so8034607a91.3
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 11:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736795721; x=1737400521; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ycvUTxtX9nC8ysHW1oAemDXmm646w3J2HOjD84b52Q=;
        b=fpUUarWEy0UwbQjfGKX3OqXsgD9o4t7j61mh4jvTEkbZYZadIqtXF8SC22NhqFvKyX
         J0bNQI2UwbwihhAN/Ff2draxS2pc4rGRAZ/KVj/vKDG3W7JVjI2VWdAFtizMZdsvxF8T
         Bfc1i5k/tHkYQvDVNzW4IJVg+mvSmleyr0puQu8emyDgBzeNTpz3Potka5/l5/dN0EIU
         1MQgjLzIYZAkT7X8ETcjRQ1WYp9gSh4EGxdKQ1K3cmehWYN7i+Lu9n89kmVy/dMRF7xD
         caZ8eGriQDKFWIVxQzRaPyo9LHvkE+MNwhMuIU537KMu6lgDEvzoe/h28ZhaGkVhzXzl
         1LWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736795721; x=1737400521;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4ycvUTxtX9nC8ysHW1oAemDXmm646w3J2HOjD84b52Q=;
        b=JP4gKESP/O6HW3Y+PKsk3nTRPOwbXP94BbtpJk62FK5QvkWT7nl7Hn2c/XeE64nJyl
         ButMmCkcWXRHkZ/CUZIURUEk/ugjX+x9HyJ+ASrBo/QTKpBVtWMdfMBmKGh1xXVIy/ak
         71cXUmEQz069PKrocHj4RVve/P2/TuY2nGSs69l0AwTLnTFWoD8T4fa5TTSmIg147h76
         ouKAX37aq+QlgrdU9kFM1Fvn6FHqnuvSUBndbKBMFzoqhavIf+rAs8k13JOJqyq9CDve
         lajy2FLadXHSwUJFmAMbInQoaXTVx/Wduyynk+8ASQ409vqV4xCrVr1dwhKYQDHAGAUc
         YYmg==
X-Forwarded-Encrypted: i=1; AJvYcCXzc4IliSd6gU2lxSkKzz63WXVZBQ8uJ2c4PNNtpemBvJPHuWCZ94/V4ftaRo+Ulyz6jTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDDVBXU14J82XBP9iwVTMVBzAfmKLFddcXXUQpsuSf4vjQXb80
	3j08yvyJpBVazNAF9tYKOZ0H7wUavJQShkWSOYE2yAGRB2xoaIinXql+oEj1qclSFxeLV5oEYrt
	wzw==
X-Google-Smtp-Source: AGHT+IHju945MtaRkbwQ/CP/ArztD7l3kNHyp5aLRq44LvJZjo33eyweI/6vuadGPPkK5zAV7sMEH0slQz4=
X-Received: from pjbsz8.prod.google.com ([2002:a17:90b:2d48:b0:2ee:3128:390f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270d:b0:2ef:31a9:95c6
 with SMTP id 98e67ed59e1d1-2f548ebf526mr34357464a91.14.1736795720936; Mon, 13
 Jan 2025 11:15:20 -0800 (PST)
Date: Mon, 13 Jan 2025 19:15:19 +0000
In-Reply-To: <CALMp9eSbRzDs2iSEL=rAXTzj822bhzpm69qGWkt5n4Tk72JJcw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com> <Z0-R-_GPWu-iVAYM@google.com>
 <CALMp9eTCe1-ZA47kcktTQ4WZ=GUbg8x3HpBd0Rf9Yx_pDFkkNg@mail.gmail.com>
 <Z0-3bc1reu1slCtL@google.com> <CALMp9eRqHkiZMMJ2MDXOHPbGx1rE9n5R2aR-F=qkuGo0BPS=og@mail.gmail.com>
 <Z1MnoQcYpzE-4EZy@google.com> <CALMp9eSbRzDs2iSEL=rAXTzj822bhzpm69qGWkt5n4Tk72JJcw@mail.gmail.com>
Message-ID: <Z4VmRwIxuIfzh8sl@google.com>
Subject: Re: [RFC PATCH 00/22] KVM: x86: Virtualize IA32_APERF and IA32_MPERF MSRs
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2024, Jim Mattson wrote:
> On Fri, Dec 6, 2024 at 8:34=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> As we discussed off-list, it appears that the primary motivation for
> this change was to minimize the crosscalls executed when examining
> /proc/cpuinfo. I don't really think that use case justifies reading
> these MSRs *every scheduler tick*, but I'm admittedly biased.

Heh, yeah, we missed that boat by ~2 years.  Or maybe KVM's "slow" emulatio=
n
would only have further angered the x86 maintainers :-)

> 1. Guest Requirements
>=20
> Unlike vPMU, which is primarily a development tool, our customers want
> APERFMPERF enabled on their production VMs, and they are unwilling to
> trade any amount of performance for the feature. They don't want
> frequency-invariant scheduling; they just want to observe the
> effective frequency (possibly via /proc/cpuinfo).
>=20
> These requests are not limited to slice-of-hardware VMs. No one can
> tell me what customers expect with respect to KVM "steal time," but it
> seems to me that it would be disingenuous to ignore "steal time." By
> analogy with HDC, the effective frequency should drop to zero when the
> vCPU is "forced idle."
>=20
> 2. Host Requirements
>=20
> The host needs reliable APERF/MPERF access for:
> - Frequency-invariant scheduling
> - Monitoring through /proc/cpuinfo
> - Turbostat, maybe?
>=20
> Our goal was for host APERFMPERF to work as it always has, counting
> both host cycles and guest cycles. We lose cycles on every WRMSR, but
> most of the time, the loss should be very small relative to the
> measurement.
>=20
> To be honest, we had not even considered breaking APERF/MPERF on the
> host. We didn't think such an approach would have any chance of
> upstream acceptance.

FWIW, my stance on gifting features to KVM guests is that it's a-ok so long=
 as it
requires an explicit opt-in from the system admin, and that it's decoupled =
from
KVM.  E.g. add a flag (or KConfig) to disable APERF/MPERF usage, at which p=
oint
there's no good reason to prevent KVM from virtualizing the feature.

Unfortunately, my idea of hiding a feature from the kernel has never panned=
 out,
because apparently there's no feature that Linux can't squeeze some amount =
of
usefulness out of.  :-)

> 3. Design Choices
>=20
> We evaluated three approaches:
>=20
> a) Userspace virtualization via MSR filtering
>=20
>    This approach was implemented before we knew about
>    frequency-invariant scheduling. Because of the frequent guest
>    reads, we observed a 10-16% performance hit, depending on vCPU
>    count. The performance impact was exacerbated by contention for a
>    legacy PIC mutex on KVM_RUN, but even if the mutex were replaced
>    with a reader/writer lock, the performance impact would be too
>    high. Hence, we abandoned this approach.
>=20
> b) KVM intercepts RDMSR of APERF/MPERF
>=20
>    This approach was ruled out by back-of-the-envelope
>    calculation. We're not going to be able to provide this feature for
>    free, but we could argue that 0.01% overhead is negligible. On a 2
>    GHz processor that gives us a budget of 200,000 cycles per
>    second. With a 250 Hz guest tick generating 500 RDMSR intercepts
>    per second, we have a budget of just 400 cycles per
>    intercept. That's likely to be insufficient for most platforms. A
>    guest with CONFIG_HZ_1000 would drop the budget to just 100 cycles
>    per intercept. That's unachievable.

I think we'd actually have a bit more headroom.  The overhead would be rela=
tive
to bare metal, not absolute.  RDMSR is typically ~80 cycles, so even if we =
are
super duper strict in how that 0.01% overhead is accounted, KVM would have =
more
like 150+ cycles?  But I'm mostly just being pedantic, I'm pretty sure AMD =
CPUs
can't achieve 400 cycle roundtrips, i.e. hardware alone would exhaust the b=
udget.

>    We should have a discussion about just how much overhead is
>    negligible, and that may open the door to other implementation
>    options.
>=20
> c) Current RDMSR pass-through approach
>=20
>    The biggest downside is the loss of cycles on every WRMSR. An NMI
>    or SMI in the critical region could result in millions of lost
>    cycles. However, the damage only persists until all in-progress
>    measurements are completed.

FWIW, the NMI problem is solvable, e.g. by bumping a sequence counter if th=
e CPU
takes an NMI in the critical section, and then retrying until there are no =
NMIs
(or maybe retry a very limited number of times to avoid creating a set of p=
roblems
that could be worse than the loss in accuracy).

>    We had considered context-switching host and guest values on
>    VM-entry and VM-exit. This would have kept everything within KVM,
>    as long as the host doesn't access the MSRs during an NMI or
>    SMI. However, 4 additional RDMSRs and 4 additional WRMSRs on a
>    VM-enter/VM-exit round-trip would have blown the budget. Even
>    without APERFMPERF, an active guest vCPU takes a minimum of two
>    VM-exits per timer tick, so we have even less budget per
>    VM-enter/VM-exit round-trip than we had per RDMSR intercept in (b).
>=20
>    Internally, we have already moved the mediated vPMU context-switch
>    from VM-entry/VM-exit to the KVM_RUN loop boundaries, so it seemed
>    natural to do the same for APERFMPERF. I don't have a
>    back-of-the-envelope calculation for this overhead, but I have run
>    Virtuozzo's cpuid_rate benchmark in a guest with and without
>    APERFMPERF, 100 times for each configuration, and a Student's
>    t-test showed that there is no statistically significant difference
>    between the means of the two datasets.
>=20
> 4. APERF/MPERF Accounting
>=20
>    Virtual MPERF cycles are easy to define. They accumulate at the
>    virtual TSC frequency as long as the vCPU is in C0. There are only
>    a few ways the vCPU can leave C0. If HLT or MWAIT exiting is
>    disabled, then the vCPU can leave C) in VMX non-root operation (or
>    AMD guest mode). If HLT exiting is not disabled, then the vCPU will
>    leave C0 when a HLT instruction is intercepted, and it will reenter
>    C0 when it receives an interrupt (or a PV kick) and starts running
>    again.
>=20
>    Virtual APERF cycles are more ambiguous, especially in VMX root
>    operation (or AMD host mode). I think we can all agree that they
>    should accumulate at some non-zero rate as long as the code being
>    executed on the logical processor contributes in some way to guest
>    vCPU progress, but should the virtual APERF accumulate cycles at
>    the same frequency as the physical APERF? Probably not. Ultimately,
>    the decision was pragmatic. Virtual APERF accumulates at the same
>    rate as physical APERF while the guest context is live in the
>    MSR. Doing anything else would have been too expensive.

Hmm, I'm ok stopping virtual APERF while the vCPU task is in userspace, and=
 the
more I poke at it, the more I agree it's the only sane approach.  However, =
I most
definitely want to document the various gotchas with the alternative.

At first glance, keeping KVM's preempt notifier registered on exits to user=
space
would be very doable, but there are lurking complexities that make it very
unpalatable when digging deeper.  E.g. handling the case where userspace
invokes KVM_RUN on a different task+CPU would likely require a per-CPU spin=
lock,
which is all kinds of gross.  And userspace would need a way to disassociat=
ed a
task from a vCPU.

Maybe this would be a good candidate for Paolo's idea of using the merge co=
mmit
to capture information that doesn't belong in Documentation, but that is to=
o
specific/detailed for a single commit's changelog.

> 5. Live Migration
>=20
>    The IA32_MPERF MSR is serialized independently of the
>    IA32_TIME_STAMP_COUNTER MSR. Yes, this means that the two MSRs do
>    not advance in lock step across live migration, but this is no
>    different from a general purpose vPMU counter programmed to count
>    "unhalted reference cycles." In general, our implementation of
>    guest IA32_MPERF is far superior to the vPMU implementation of
>    "unhalted reference cycles."

Aha!  The SDM gives us an out:

  Only the IA32_APERF/IA32_MPERF ratio is architecturally defined; software=
 should
  not attach meaning to the content of the individual of IA32_APERF or IA32=
_MPERF
  MSRs.

While the SDM kinda sorta implies that MPERF and TSC will operrate in lock-=
step,
the above gives me confidence that some amount of drift is tolerable.

Off-list you floated the idea of tying save/restore to TSC as an offset, bu=
t I
think that's unnecessary complexity on two fronts.  First, the writes to TS=
C and
MPERF must happen separately, so even if KVM does back-to-back WRMSRs, some=
 amount
of drift is inevitable.  Second, because virtual TSC doesn't stop on vcpu_{=
load,put},
there will be non-trivial drift irrespective of migration (and it might eve=
n be
worse?).

> 6. Guest TSC Scaling
>=20
>    It is not possible to support TSC scaling with IA32_MPERF
>    RDMSR-passthrough on Intel CPUs, because reads of IA32_MPERF in VMX
>    non-root operation are not scaled by the hardware. It is possible
>    to support TSC scaling with IA32_MPERF RDMSR-passthrough on AMD
>    CPUs, but the implementation is left as an exercise for the reader.

So, what's the proposed solution?  Either the limitation needs to be docume=
nted
as a KVM erratum, or KVM needs to actively prevent APERF/MPREF virtualizati=
on if
TSC scaling is in effect.  I can't think of a third option off the top of m=
y
head.

I'm not sure how I feel about taking an erratum for this one.  The SDM expl=
icitly
states, in multiple places, that MPREF counts at a fixed frequency, e.g.

  IA32_MPERF MSR (E7H) increments in proportion to a fixed frequency, which=
 is
  configured when the processor is booted.

Drift between TSC and MPERF is one thing, having MPERF suddenly count at a
different frequency is problematic on a different level.

