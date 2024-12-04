Return-Path: <kvm+bounces-32984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87A3E9E3301
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 06:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47D08286112
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 05:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3694418452C;
	Wed,  4 Dec 2024 05:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bTO8gjm6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CFD2500D2
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 05:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733289103; cv=none; b=kLs4L2TbvIjo173UtAyswoQOB2LDY+dOdn2Uj+dmBt5B9jWYS9OBZQXSp25BF8ZIqtcOI8VsTCswt6PtbWYyIyrhGFGRD4760V76Pc5DkXB9oGLQeEK8TJN0gpMfLbQB08eofiobVQSe1mHkJ6P8VlHuTi3ud5+Za4y0cMw3YyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733289103; c=relaxed/simple;
	bh=xffhHSYwhEi8ZBeG9FEdhfkMsJOeKckYEI5eS9txTmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EcLg2Ny83R4tUokUikosEsoV505DnULRSONAaP+yBgJSNg+5Gdfm2LVZas09XaWOc4YHI+5AKF0LK7Byt3bcTvy64t4Tvr+KKEYSfad8CbhgVlf2WRnZNFW4N/Yeeb/b3zgeFyY3+9t6ZSGX/P5yIcWbQAdW2vpWzDOgYfiTvvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bTO8gjm6; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6d8918ec243so29766916d6.1
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 21:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733289100; x=1733893900; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0PEPY4Svd+G/rAUjBuAPsk0Dzw54MiAt9xCf3ocSeQ=;
        b=bTO8gjm6O2NkGPizDO4McuLGghL2oJh4HJhEaVFvG62NDXYpFpmN2SFYHB1WTnDNLq
         wx70+oBjgeb4/tpUz5EDRmVz9Kw91UdS0oEvLMM+WNfZEilu9YkiEWstQ3bfOnzsSV8z
         mErGvknE7yqXLa/3iP/7OLBLxxiW1XHi/RfWe2QdcDCfzoe3fQLQhsfwxRm6/r/NRQum
         BeS+IZ82JBf+JWZ1Si9XNqm/a0TUJj8fUfgW/aghlZ1f1QDuci8qvgoMNCoPjNwZlaov
         lRgJwD0FMFlvj9NT6WTfrsxMnPxjXw5MGyOoauqA+hB3QR35O4dtIb4+Hq0YMw+HwKjj
         0/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733289100; x=1733893900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0PEPY4Svd+G/rAUjBuAPsk0Dzw54MiAt9xCf3ocSeQ=;
        b=VrtBdWTEEaJvaxLKXh+TRZpmmI6tQlRV6peudK20axdeWe+eCsxo4YJ87AIwavhkq4
         ABvzv9JZCd4ECLcxBDj5kYJwJYor4zj5P+VPIJkieLl/JvOMzvoxGbZzRDxXAExAVpOh
         xhvYE+hi2aGOzOSw8mZz8GYLZ4AvS5nunQ+CVryIS9rH4umCsyENqeMhWkDo1ZApvy3Y
         /Lrz5siWuaQKc3HFbXnzu63VPDCDFf6LMg3Aqs/vOjA9UXpQAdvOcTiaOOAm+AKL3XtH
         Iu1uN/WztDxzDU4ZaxHXm0xSx2BotAfsZv8wx2XWfgQYCepOKcyAZGYxGd/9ncGnUcQB
         J8qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVITL2Rhd78mVEcGG2V8nD4vVKohXaks36EilviOXg/SZP6LsroLaMqiF0ytUdac7vfAyw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnzMsSuSU6FQqHf+5rfdOavvV4aJl+2irx7W8JZPUHoCr5k4Zy
	aoanRAxpHHrIHDpMsb9+OuWBjS5BQu44DJgcCyVmSyps54nUyTawczL0l9n/nwaA3L5JdtgkI/V
	w9bzXgSKG01XulTE/JGwHPlaFOUxoUnG8iG8l
X-Gm-Gg: ASbGncuUN090YnLPvkhcjqJzBO0cln4G8i35OqdLxYcg9fgMfcGrgmEuRVDBo0/iCW8
	EAE2gvXcXoq+uwks7gJSXxgbmIgl2q+J6HA==
X-Google-Smtp-Source: AGHT+IH/Vmo/+QbxWem6WulFZ1R02aWj+agCguGICQRZ1nvhXgATs70hrnLLhl9CSVs2QCJw5CIz7HwFc8sOX/H1g+M=
X-Received: by 2002:ad4:5bce:0:b0:6d8:a70d:5e41 with SMTP id
 6a1803df08f44-6d8b73fd386mr66881906d6.33.1733289100166; Tue, 03 Dec 2024
 21:11:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com> <Z0-R-_GPWu-iVAYM@google.com>
 <CALMp9eTCe1-ZA47kcktTQ4WZ=GUbg8x3HpBd0Rf9Yx_pDFkkNg@mail.gmail.com> <Z0-3bc1reu1slCtL@google.com>
In-Reply-To: <Z0-3bc1reu1slCtL@google.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Tue, 3 Dec 2024 21:11:03 -0800
Message-ID: <CAL715W+Av8FLod00zxkniwn1q3ZnZDHUatN7R8iKBpf1+K5h2Q@mail.gmail.com>
Subject: Re: [RFC PATCH 00/22] KVM: x86: Virtualize IA32_APERF and IA32_MPERF MSRs
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry for the duplicate message...


On Tue, Dec 3, 2024 at 5:59=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, Dec 03, 2024, Jim Mattson wrote:
> > On Tue, Dec 3, 2024 at 3:19=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Thu, Nov 21, 2024, Mingwei Zhang wrote:
> > > > Linux guests read IA32_APERF and IA32_MPERF on every scheduler tick
> > > > (250 Hz by default) to measure their effective CPU frequency. To av=
oid
> > > > the overhead of intercepting these frequent MSR reads, allow the gu=
est
> > > > to read them directly by loading guest values into the hardware MSR=
s.
> > > >
> > > > These MSRs are continuously running counters whose values must be
> > > > carefully tracked during all vCPU state transitions:
> > > > - Guest IA32_APERF advances only during guest execution
> > >
> > > That's not what this series does though.  Guest APERF advances while =
the vCPU is
> > > loaded by KVM_RUN, which is *very* different than letting APERF run f=
reely only
> > > while the vCPU is actively executing in the guest.
> > >
> > > E.g. a vCPU that is memory oversubscribed via zswap will account a si=
gnificant
> > > amount of CPU time in APERF when faulting in swapped memory, whereas =
traditional
> > > file-backed swap will not due to the task being scheduled out while w=
aiting on I/O.
> >
> > Are you saying that APERF should stop completely outside of VMX
> > non-root operation / guest mode?
> > While that is possible, the overhead would be significantly
> > higher...probably high enough to make it impractical.
>
> No, I'm simply pointing out that the cover letter is misleading/inaccurat=
e.
>
> > > In general, the "why" of this series is missing.  What are the use ca=
ses you are
> > > targeting?  What are the exact semantics you want to define?  *Why* d=
id are you
> > > proposed those exact semantics?
> >
> > I get the impression that the questions above are largely rhetorical, a=
nd
>
> Nope, not rhetorical, I genuinely want to know.  I can't tell if ya'll th=
ought
> about the side effects of things like swap and emulated I/O, and if you d=
id, what
> made you come to the conclusion that the "best" boundary is on sched_out(=
) and
> return to userspace.

Even for the slice of hardware case, KVM still needs to maintain the
guest aperfmperf context and do the context switch. Even if vcpu is
pinned, the host system design always has corner cases. For instance,
the host may want to move a bunch of vCPUs from one chunk to another,
say from 1 CCX to another CCX in AMD. Or maybe in some cases,
balancing the memory usage by moving VMs from one (v)NUMA to another.
Those should be corner cases and thus rare, but could happen in
reality.

Even for the slice of hardware case, KVM still needs to maintain the
guest aperfmperf context and do the context switch. Even if vcpu is
pinned, the host system design always has corner cases. For instance,
the host may want to move a bunch of vCPUs from one chunk to another,
say from 1 CCX to another CCX in AMD. Or maybe in some cases,
balancing the memory usage by moving VMs from one (v)NUMA to another.
Those should be corner cases and thus rare, but could happen in
reality.

>
> > that you would not be happy with the answers anyway, but if you really =
are
> > inviting a version 2, I will gladly expound upon the why.
>
> No need for a new version at this time, just give me the details.
>
> > > E.g. emulated I/O that is handled in KVM will be accounted to APERF, =
but I/O that
> > > requires userspace exits will not.  It's not necessarily wrong for he=
avy userspace
> > > I/O to cause observed frequency to drop, but it's not obviously corre=
ct either.
> > >
> > > The use cases matter a lot for APERF/MPERF, because trying to reason =
about what's
> > > desirable for an oversubscribed setup requires a lot more work than d=
efining
> > > semantics for setups where all vCPUs are hard pinned 1:1 and memory i=
s more or
> > > less just partitioned.  Not to mention the complexity for trying to s=
upport all
> > > potential use cases is likely quite a bit higher.
> > >
> > > And if the use case is specifically for slice-of-hardware, hard pinne=
d/partitioned
> > > VMs, does it matter if the host's view of APERF/MPERF is not accurate=
ly captured
> > > at all times?  Outside of maybe a few CPUs running bookkeeping tasks,=
 the only
> > > workloads running on CPUs should be vCPUs.  It's not clear to me that=
 observing
> > > the guest utilization is outright wrong in that case.
> >
> > My understanding is that Google Cloud customers have been asking for th=
is
> > feature for all manner of VM families for years, and most of those VM
> > families are not slice-of-hardware, since we just launched our first su=
ch
> > offering a few months ago.
>
> But do you actually want to expose APERF/MPERF to those VMs?  With my ups=
tream
> hat on, what someone's customers are asking for isn't relevant.  What's r=
elevant
> is what that someone wants to deliver/enable.
>
> > > One idea for supporting APERF/MPERF in KVM would be to add a kernel p=
aram to
> > > disable/hide APERF/MPERF from the host, and then let KVM virtualize/p=
assthrough
> > > APERF/MPERF if and only if the feature is supported in hardware, but =
hidden from
> > > the kernel.  I.e. let the system admin gift APERF/MPERF to KVM.
> >
> > Part of our goal has been to enable guest APERF/MPERF without impacting=
 the
> > use of host APERF/MPERF, since one of the first things our support team=
s look
> > at in response to a performance complaint is the effective frequencies =
of the
> > CPUs as reported on the host.
>
> But is looking at the host's view even useful if (a) the only thing runni=
ng on
> those CPUs is a single vCPU, and (b) host userspace only sees the effecti=
ve
> frequencies when _host_ code is running?  Getting the effective frequency=
 for
> when the userspace VMM is processing emulated I/O probably isn't going to=
 be all
> that helpful.
>
> And gifting APERF/MPERF to VMs doesn't have to mean the host can't read t=
he MSRs,
> e.g. via turbostat.  It just means the kernel won't use APERF/MPERF for s=
cheduling
> decisions or any other behaviors that rely on an accurate host view.
>
> > I can explain all of this in excruciating detail, but I'm not really
> > motivated by your initial response, which honestly seems a bit hostile.
>
> Probably because this series made me a bit grumpy :-)  As presented, this=
 feels
> way, way too much like KVM's existing PMU "virtualization".  Mostly works=
 if you
> stare at it just so, but devoid of details on why X was done instead of Y=
, and
> seemingly ignores multiple edge cases.

ah, I can understand your feelings :) In the existing implementation
of vPMU, the guest counter value is really really hard to fetch
because part of it is always located in the perf subsystem. But in the
case of aperfmperf, the guest value is always in one place when code
is within the KVM loop. We pass through rdmsr to aperfmperf. Writes
need some adjustment, but it is on the host-level offset, not the
guest value. The offset we maintain is quite simple math.

>
> I'm not saying you and Mingwei haven't thought about edge cases and desig=
n
> tradeoffs, but nothing in the cover letter, changelogs, comments (none), =
or
> testcases (also none) communicates those thoughts to others.
>
> > At least you looked at the code, which is a far warmer reception than I
> > usually get.

