Return-Path: <kvm+bounces-32979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C37A9E3108
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 02:59:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1732284B26
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 01:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E569F282FA;
	Wed,  4 Dec 2024 01:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wsEMoe1I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D313487BF
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 01:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733277553; cv=none; b=gWHtLKdBxLza/O3NZXx26qROYnx0nynPIS2SnJwMAo02eWhs8oTAMN1DZ2X/bXPUTbGcqkSoSNmAbtmvsd5ris0qR74JPtoN6TmJwn+9KPZZkJGujzMktpQ9fxqnStN86Vxj02Q8X6S0gi7AM9+GYCKCF/367G3JNdjcmcHtCBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733277553; c=relaxed/simple;
	bh=gQmwL+28JoOX3uRXxqS/5bngvFoEsI4Svi+cbQQefbM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NQoVrqvuRZ2f3qynkvKULSoRH+iAkJ/OMfyR6nfHzW0alH3vNiH8SjnFuhr0ziSyPvkFvDF7ombsMncc8dz1Ii6pwLsAnSh12jBgBhAhOGLIm57Dz/nX+EHEIvdg8qCHC2KPs1+FfqlvgLcrceqxzVAVu9r8ijmwbyc8O3VUqLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wsEMoe1I; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee36569f4cso5337193a91.2
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 17:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733277551; x=1733882351; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CuMOF6fBqUYJuUUew2J1LJLi0r8GH1qnPK4X1uoy7mI=;
        b=wsEMoe1Irpi9956X2+5ncY1sLyEXCC29Lt2m4bnjq+pd3JIwSMgLoc/OkkjLh3kZRG
         p9ERS7dGGg2HE9s6WkqB0c6U0k3CAWdu+ng9D/NttRBZc+mzPWkHZVB7UQ3cxq/eQwn3
         4Odfx9/8fqLSALxv0hWxbd6KtkPgldX8z/GKIXwapwbcrGB5dinTtBisYonB1tZGsajV
         LKT4pzRggzvliAtAqk/cJcIErTlQ1gEKJquRqtF5YlmOu+i6TUIRd14qZVNUwbj2xDBa
         pgTU7lRQYLVYH3wYIzqN8po0T5Z86FNwJjQQc4GugEPNXy633Emr4nNe5fGLJXuP7PM2
         OXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733277551; x=1733882351;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CuMOF6fBqUYJuUUew2J1LJLi0r8GH1qnPK4X1uoy7mI=;
        b=I3ywB/9LYPvJem30+foHuD/AMXP3jTwwgKsBrIVfCeX9dGpNtT/p5cxdsGEmTGO1lt
         hFjqqXIPa6FLdcAH0fSuJkGOW7IrO6LG1qE5MulI9jpA8o7NzZjJCAM4qIxAQ4rtmwx2
         us/wFjtrpdfjZKqeXJuc9fYqCWZo93K8uxyLZasCrHtkCjTmg+7fmLodCw+eBNq3KLLE
         lY2AxIbZzhYTDTQl2GzUaMyK7T43vp679mFbYgly9wn/kVfeFzGyjGKgqOsRR9WOf5vb
         tGK+PulPFa62OnTvtJQd1CPWaY69XqD1D/2uqAUvzRV0w7acEqbW1g6mcGELJGnK7yYg
         VQqQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1cwB00FdwcqXQX7vBLYznQ6ljHpwTGoOsf/B8xnbfzRUqB+AHCvZMHh7HQGUFCIIPpfA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww5c/16COR+FyX7i328r3rIgJGqnL7ZIEQpj0Nyn5vzXGt/4Le
	WGbjoAb7ktaI0ohYWX2vDtCyn/7klO8rqy5OwM0gLHLuwApTaf7YgsrNjLxQt5bQY4NMXrnnLJ+
	j5g==
X-Google-Smtp-Source: AGHT+IHxiQNTqlvGDFnwTGaPH6L5TImxiPZR/b+7S9Y2Q0HqG03dOcOWZldI1AisuR15V4CEpODHuWhqEGY=
X-Received: from pjur6.prod.google.com ([2002:a17:90a:d406:b0:2e9:ee22:8881])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e81:b0:2ea:2a8d:dd2a
 with SMTP id 98e67ed59e1d1-2ef0124f722mr5869624a91.27.1733277550734; Tue, 03
 Dec 2024 17:59:10 -0800 (PST)
Date: Tue, 3 Dec 2024 17:59:09 -0800
In-Reply-To: <CALMp9eTCe1-ZA47kcktTQ4WZ=GUbg8x3HpBd0Rf9Yx_pDFkkNg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com> <Z0-R-_GPWu-iVAYM@google.com>
 <CALMp9eTCe1-ZA47kcktTQ4WZ=GUbg8x3HpBd0Rf9Yx_pDFkkNg@mail.gmail.com>
Message-ID: <Z0-3bc1reu1slCtL@google.com>
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

On Tue, Dec 03, 2024, Jim Mattson wrote:
> On Tue, Dec 3, 2024 at 3:19=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Thu, Nov 21, 2024, Mingwei Zhang wrote:
> > > Linux guests read IA32_APERF and IA32_MPERF on every scheduler tick
> > > (250 Hz by default) to measure their effective CPU frequency. To avoi=
d
> > > the overhead of intercepting these frequent MSR reads, allow the gues=
t
> > > to read them directly by loading guest values into the hardware MSRs.
> > >
> > > These MSRs are continuously running counters whose values must be
> > > carefully tracked during all vCPU state transitions:
> > > - Guest IA32_APERF advances only during guest execution
> >
> > That's not what this series does though.  Guest APERF advances while th=
e vCPU is
> > loaded by KVM_RUN, which is *very* different than letting APERF run fre=
ely only
> > while the vCPU is actively executing in the guest.
> >
> > E.g. a vCPU that is memory oversubscribed via zswap will account a sign=
ificant
> > amount of CPU time in APERF when faulting in swapped memory, whereas tr=
aditional
> > file-backed swap will not due to the task being scheduled out while wai=
ting on I/O.
>=20
> Are you saying that APERF should stop completely outside of VMX
> non-root operation / guest mode?
> While that is possible, the overhead would be significantly
> higher...probably high enough to make it impractical.

No, I'm simply pointing out that the cover letter is misleading/inaccurate.

> > In general, the "why" of this series is missing.  What are the use case=
s you are
> > targeting?  What are the exact semantics you want to define?  *Why* did=
 are you
> > proposed those exact semantics?
>=20
> I get the impression that the questions above are largely rhetorical, and

Nope, not rhetorical, I genuinely want to know.  I can't tell if ya'll thou=
ght
about the side effects of things like swap and emulated I/O, and if you did=
, what
made you come to the conclusion that the "best" boundary is on sched_out() =
and
return to userspace.

> that you would not be happy with the answers anyway, but if you really ar=
e
> inviting a version 2, I will gladly expound upon the why.

No need for a new version at this time, just give me the details.

> > E.g. emulated I/O that is handled in KVM will be accounted to APERF, bu=
t I/O that
> > requires userspace exits will not.  It's not necessarily wrong for heav=
y userspace
> > I/O to cause observed frequency to drop, but it's not obviously correct=
 either.
> >
> > The use cases matter a lot for APERF/MPERF, because trying to reason ab=
out what's
> > desirable for an oversubscribed setup requires a lot more work than def=
ining
> > semantics for setups where all vCPUs are hard pinned 1:1 and memory is =
more or
> > less just partitioned.  Not to mention the complexity for trying to sup=
port all
> > potential use cases is likely quite a bit higher.
> >
> > And if the use case is specifically for slice-of-hardware, hard pinned/=
partitioned
> > VMs, does it matter if the host's view of APERF/MPERF is not accurately=
 captured
> > at all times?  Outside of maybe a few CPUs running bookkeeping tasks, t=
he only
> > workloads running on CPUs should be vCPUs.  It's not clear to me that o=
bserving
> > the guest utilization is outright wrong in that case.
>=20
> My understanding is that Google Cloud customers have been asking for this
> feature for all manner of VM families for years, and most of those VM
> families are not slice-of-hardware, since we just launched our first such
> offering a few months ago.

But do you actually want to expose APERF/MPERF to those VMs?  With my upstr=
eam
hat on, what someone's customers are asking for isn't relevant.  What's rel=
evant
is what that someone wants to deliver/enable.

> > One idea for supporting APERF/MPERF in KVM would be to add a kernel par=
am to
> > disable/hide APERF/MPERF from the host, and then let KVM virtualize/pas=
sthrough
> > APERF/MPERF if and only if the feature is supported in hardware, but hi=
dden from
> > the kernel.  I.e. let the system admin gift APERF/MPERF to KVM.
>=20
> Part of our goal has been to enable guest APERF/MPERF without impacting t=
he
> use of host APERF/MPERF, since one of the first things our support teams =
look
> at in response to a performance complaint is the effective frequencies of=
 the
> CPUs as reported on the host.

But is looking at the host's view even useful if (a) the only thing running=
 on
those CPUs is a single vCPU, and (b) host userspace only sees the effective
frequencies when _host_ code is running?  Getting the effective frequency f=
or
when the userspace VMM is processing emulated I/O probably isn't going to b=
e all
that helpful.

And gifting APERF/MPERF to VMs doesn't have to mean the host can't read the=
 MSRs,
e.g. via turbostat.  It just means the kernel won't use APERF/MPERF for sch=
eduling
decisions or any other behaviors that rely on an accurate host view.

> I can explain all of this in excruciating detail, but I'm not really
> motivated by your initial response, which honestly seems a bit hostile.

Probably because this series made me a bit grumpy :-)  As presented, this f=
eels
way, way too much like KVM's existing PMU "virtualization".  Mostly works i=
f you
stare at it just so, but devoid of details on why X was done instead of Y, =
and
seemingly ignores multiple edge cases.

I'm not saying you and Mingwei haven't thought about edge cases and design
tradeoffs, but nothing in the cover letter, changelogs, comments (none), or
testcases (also none) communicates those thoughts to others.

> At least you looked at the code, which is a far warmer reception than I
> usually get.

