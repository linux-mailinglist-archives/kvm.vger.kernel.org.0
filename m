Return-Path: <kvm+bounces-32982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EDFA9E3287
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 05:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 734601678AF
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 04:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E0D10F9;
	Wed,  4 Dec 2024 04:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ixCdqJLs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29548374CB
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 04:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733284822; cv=none; b=cV97a1vYmF3hExPIjYtNejOPFaT83mXZ2BDsx+L53/8nr4BdGjozuwUhqmpGbwBcHoMBJU2ZhZdtxgcbsbiMec9YznL/u7ajpJaStQqWoLXz44Yqkf2XKe7LeKnOuNSvjTSu9aEdoAQfS48hZlBnOg7/b7fEq7fjxEBiIMGNLRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733284822; c=relaxed/simple;
	bh=plu8dRbwA//TIE7V3u7EkRjHASWu+GTYdXd54J9egbw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KwZK0h4icr0K6qp3p4q2wToYZ+CZbpqgPaNeeM+4BH/DJrIXuoNoQPkkBwqOrVpGD0vxrXMs9cy/RACav4wRJzzQQHCnXY3M0OZOUeTCszlkpNxokcCLi+WgJLgtZEQWsQZpVln73u7vLg2PB4P7jHrBMJlxIeKMigb2PH1v5d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ixCdqJLs; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a77ab3ebfaso57385ab.1
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 20:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733284820; x=1733889620; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CngGMvpmpyr10C47QW7O8tll8PdmhQ22t96lvuVqUS8=;
        b=ixCdqJLszwdzQwoUWVJOSX5EVQClSBiYYHB5aqLwFrhOjXghzpGkn3RrUYmtKj3yWD
         9D60WEl5Iklp1HM0rQBGvr+H8APj+cPBXLMy8E6rxtSOga29kBH1Xqz5RqSCl9+0mj+m
         /EokJT31NrYeNom6zu2mvTU29BPZ6N5aLWd8gztCzwGQCadcypFxcqYrP2SaKR+WBgKB
         GutZT37xzMHhVMUbKSbphwQKs1rpo4cuDSfBgQAguw7U/qCHVGYzWdPeHKPvTDWBOPzO
         3+n7BqGGAkWa2XZTOgSnfoowU0BLICkQx/AMHNZVCRpLavx/4K36puraljq1CEVBLRRZ
         ib+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733284820; x=1733889620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CngGMvpmpyr10C47QW7O8tll8PdmhQ22t96lvuVqUS8=;
        b=bmbR7Wi+TWYA5EHmp4d7mmilhyeeFhgJc4iSXt5uYN9+9ZUG+TI8D/rlZOZ78NCdHB
         UXVMYh8PLXmr1h92DmugNFce4tHjhI+H4GDFYuTRuCh+sEkATAR08K9m4QPIIoP/bH+U
         x9OBUFlpf1hwgDveCqvyzgjDRc/uEiBenW7+X8lob5PPW+i5emrxdRp+1WrGbOkxdL9E
         UDI2UuBmsM/ba+q1WMWikzThlL4dRVRNr0QH/kn0aybAE4oK7Tp3HHWEcfefvuov0eJf
         U9WQCG2h7f0lUxd1O3/AJwmYqo0fTuqHZxQfGYqW/bx7MXabdKEJV03XWh4b0vlL9ZeE
         PxKg==
X-Forwarded-Encrypted: i=1; AJvYcCXLFG19WbYdLXe4m96+jo1ZMZYEyEp4PYjkfcL5A1tFD183OAB9zrZtmqq9pGNQyVnuWcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNEVCs8bDNrhG4RevmriYq6+tVz/JlQkEPxQ7SjpP8UfGLgBWe
	A3JY25OJQ0KI+hFC4/BXEBJAE/Sm16RCmmMGxzjsoJN26b7qOTSjc9PgsQDpSmV7jyl2dOmcJtW
	wiCdGAurl2OUMTd9CruP7PZO1qFSiFMcSXSol
X-Gm-Gg: ASbGncuaWLJoLgPjymK7BfptPMJZ3eCJBoG/Eu+00IONqng0kGzfY1jNsnDkXJoHEsZ
	dV8AH/4gNqN2Qyhr+j2LBZ6E+jhaLFA==
X-Google-Smtp-Source: AGHT+IFSAC1wz2QxEeAFRYo7HSv2GzEQcAHLbAsspH6/KMJCC8WlUpKuMmIDvejZ+31FQWIAyUvMlyBEiyGwx5JATfo=
X-Received: by 2002:a05:6e02:3f8d:b0:3a7:cd21:493f with SMTP id
 e9e14a558f8ab-3a8001a949dmr1896425ab.26.1733284820117; Tue, 03 Dec 2024
 20:00:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com> <Z0-R-_GPWu-iVAYM@google.com>
 <CALMp9eTCe1-ZA47kcktTQ4WZ=GUbg8x3HpBd0Rf9Yx_pDFkkNg@mail.gmail.com> <Z0-3bc1reu1slCtL@google.com>
In-Reply-To: <Z0-3bc1reu1slCtL@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 3 Dec 2024 20:00:09 -0800
Message-ID: <CALMp9eT9ne4HmwqMED0nGT1aEem7VjTHbehQhb1MPn-Z-Lg9=Q@mail.gmail.com>
Subject: Re: [RFC PATCH 00/22] KVM: x86: Virtualize IA32_APERF and IA32_MPERF MSRs
To: Sean Christopherson <seanjc@google.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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

(a) is your constraint, not mine, and (b) certainly sounds pointless,
but that isn't the behavior of this patch set, so I'm not sure why
you're even going there.

With this patch set, host APERF/MPERF still reports all cycles
accumulated on the logical processor, regardless of whether in the
host or the guest. There will be a small loss every time the MSRs are
written, but that loss is minimized by writing the MSRs as
infrequently as possible.

I get ahead of myself, but I just couldn't let this
mischaracterization stand uncorrected while I get the rest of my
response together.

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
>
> I'm not saying you and Mingwei haven't thought about edge cases and desig=
n
> tradeoffs, but nothing in the cover letter, changelogs, comments (none), =
or
> testcases (also none) communicates those thoughts to others.
>
> > At least you looked at the code, which is a far warmer reception than I
> > usually get.

