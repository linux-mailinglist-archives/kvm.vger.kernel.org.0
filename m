Return-Path: <kvm+bounces-32973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 121539E30AB
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 02:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C63C528370F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 01:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF9AEAF1;
	Wed,  4 Dec 2024 01:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vw91Wwjp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF188F5E
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 01:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733274805; cv=none; b=aBGCViwQ2gvKWMhiBTI860seWeYs+Kqn/GFh5w2Sep8xCY7tgjDIcrpkDBfhQm6mr9urRUiBdTbeqMMtazoLqWON8PqLFoGExeyXefsily7nqea6k1sGP41H3pgWOUeWOnAwBPSB9LK3pox/I/UgNP9hE3p4T4cw4xNWHWwJycc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733274805; c=relaxed/simple;
	bh=X9QMyCri7xd0ctEKT112opd9F2dHzDJbNA+4wFyXh5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CBzMBIYYy8JJKvij2IK2C9T9vvDcCPYiv0utU0oiDaMoXxGKHMNGpJ/NtIRwbDEVhCpIKMAessJ/QER+RjpUAWsfETFVNaEcmvDDHM6WJOmLbMCJk+el3f7za10n2L0iW7TEe0airRegr3aHHt/lrWGIVaW2TeAP0Lj4AJ00+jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vw91Wwjp; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a7dfcd40fcso34795ab.1
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 17:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733274802; x=1733879602; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p1M+SJMhJjrH+hJzaD87l5T01lxeHhsp9ZAJGXnGoUM=;
        b=Vw91WwjposEBAiMD0WlkOIbyoNMFpOu310ZH8BD772vVjnoeN8KpCaBFFlp+lyBSyI
         PCH2LAG3WthFLGX4DJD5xeXCivUgmvTXsxFF3hG4NAXVO+3+NBrP23c67m1wHAF7V0RW
         M16WWD8Qn0jbuzkjrpaJmipwsyHxY3h4ouyDh3khYtXxHWjB44HgCVGHEKPJAIatCbKb
         5Iso8ZWGPYNGdkGmArSb7RTZ71z6VwpgQMHkuwJnFpBpNA7AZdkjxmY9ehVOVMY7G+2F
         qmscawg1kc57e5HP83zAvvkrI9Ur6tqOAIPUcb7OSE/gBa5EMODkY6ZxNKY60+4fe5fn
         NpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733274802; x=1733879602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p1M+SJMhJjrH+hJzaD87l5T01lxeHhsp9ZAJGXnGoUM=;
        b=I5ZZCdyXuWUwYwM5psrY/90yCFSWawUti4IsUbi+WGuYQAMHuanU8kDT2HdFMS/BiP
         UzbNtNwg+vTEaiVltDWfp8TYdoKGQCBLlqJdt9zywUukSjbV+ujvYFEPkpg3DcVo+4Fu
         EYr946xfMlzPVAxzDX+y/3aoCvPoXm/toYIwcBA42O0aQcABcV3ypcy3JfegiEj2IMqI
         arL36A+jRgMZxibz/v2ykJL01vT3THErBDx0de81V6elVIRMYHz3lzYGUY2Hs4S2Kbmv
         QRiER6mhGRUrWaJNjnXI6JKxXAgq59qE4qrpJrkFQ04Db4l6mwNkF9F8VYO6kIGKPwMp
         vVcw==
X-Forwarded-Encrypted: i=1; AJvYcCU/WIFikmneOahQLkVlcu0WwoTKWoKA1Z40oBf56BnO1xbZsUfFHMARP47amuK0qEhXe5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+v7lmC8uQJxIdEktyN8ETxaesScbw4G06pKgIa5FlGcyW9jlm
	JAMNyxzGLyPHhELMCZhxL9K7GaekUbZh5etRjNDQVs8EJ9s5mmGbxVS2pOxMdjRKZnbaPq2ZThA
	+22ThR/5OAO+gYB+1fn1GEZQbeglrXOuh/2V+NtNK1qCwstFY9gcq
X-Gm-Gg: ASbGncvuRXN2LX1kvlC9WysXL5v4olFvRADXHTBP3Atinz8kGpe4/bCLc+jJMpJgfhP
	MK+DMZpgS/H+dat076L/0j2Qt/U8O5w==
X-Google-Smtp-Source: AGHT+IEbjOm4y6thPTmyr0jvptApsGhO5csQIoANRSYlbJjNqTjiLjxSqDn+CjPq7HdDxPboOhmxx+SLQa7qYKWc5CY=
X-Received: by 2002:a05:6e02:2408:b0:3a7:cb21:7b26 with SMTP id
 e9e14a558f8ab-3a800ab4305mr964485ab.1.1733274802505; Tue, 03 Dec 2024
 17:13:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com> <Z0-R-_GPWu-iVAYM@google.com>
In-Reply-To: <Z0-R-_GPWu-iVAYM@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 3 Dec 2024 17:13:11 -0800
Message-ID: <CALMp9eTCe1-ZA47kcktTQ4WZ=GUbg8x3HpBd0Rf9Yx_pDFkkNg@mail.gmail.com>
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

On Tue, Dec 3, 2024 at 3:19=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Nov 21, 2024, Mingwei Zhang wrote:
> > Linux guests read IA32_APERF and IA32_MPERF on every scheduler tick
> > (250 Hz by default) to measure their effective CPU frequency. To avoid
> > the overhead of intercepting these frequent MSR reads, allow the guest
> > to read them directly by loading guest values into the hardware MSRs.
> >
> > These MSRs are continuously running counters whose values must be
> > carefully tracked during all vCPU state transitions:
> > - Guest IA32_APERF advances only during guest execution
>
> That's not what this series does though.  Guest APERF advances while the =
vCPU is
> loaded by KVM_RUN, which is *very* different than letting APERF run freel=
y only
> while the vCPU is actively executing in the guest.
>
> E.g. a vCPU that is memory oversubscribed via zswap will account a signif=
icant
> amount of CPU time in APERF when faulting in swapped memory, whereas trad=
itional
> file-backed swap will not due to the task being scheduled out while waiti=
ng on I/O.

Are you saying that APERF should stop completely outside of VMX
non-root operation / guest mode?
While that is possible, the overhead would be significantly
higher...probably high enough to make it impractical.

> In general, the "why" of this series is missing.  What are the use cases =
you are
> targeting?  What are the exact semantics you want to define?  *Why* did a=
re you
> proposed those exact semantics?

I get the impression that the questions above are largely rhetorical,
and that you would not be happy with the answers anyway, but if you
really are inviting a version 2, I will gladly expound upon the why.

> E.g. emulated I/O that is handled in KVM will be accounted to APERF, but =
I/O that
> requires userspace exits will not.  It's not necessarily wrong for heavy =
userspace
> I/O to cause observed frequency to drop, but it's not obviously correct e=
ither.
>
> The use cases matter a lot for APERF/MPERF, because trying to reason abou=
t what's
> desirable for an oversubscribed setup requires a lot more work than defin=
ing
> semantics for setups where all vCPUs are hard pinned 1:1 and memory is mo=
re or
> less just partitioned.  Not to mention the complexity for trying to suppo=
rt all
> potential use cases is likely quite a bit higher.
>
> And if the use case is specifically for slice-of-hardware, hard pinned/pa=
rtitioned
> VMs, does it matter if the host's view of APERF/MPERF is not accurately c=
aptured
> at all times?  Outside of maybe a few CPUs running bookkeeping tasks, the=
 only
> workloads running on CPUs should be vCPUs.  It's not clear to me that obs=
erving
> the guest utilization is outright wrong in that case.

My understanding is that Google Cloud customers have been asking for
this feature for all manner of VM families for years, and most of
those VM families are not slice-of-hardware, since we just launched
our first such offering a few months ago.

> One idea for supporting APERF/MPERF in KVM would be to add a kernel param=
 to
> disable/hide APERF/MPERF from the host, and then let KVM virtualize/passt=
hrough
> APERF/MPERF if and only if the feature is supported in hardware, but hidd=
en from
> the kernel.  I.e. let the system admin gift APERF/MPERF to KVM.

Part of our goal has been to enable guest APERF/MPERF without
impacting the use of host APERF/MPERF, since one of the first things
our support teams look at in response to a performance complaint is
the effective frequencies of the CPUs as reported on the host.

I can explain all of this in excruciating detail, but I'm not really
motivated by your initial response, which honestly seems a bit
hostile. At least you looked at the code, which is a far warmer
reception than I usually get.

