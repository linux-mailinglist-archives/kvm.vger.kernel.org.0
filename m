Return-Path: <kvm+bounces-21766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1640693364E
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 07:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 399401C22452
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7248F101E2;
	Wed, 17 Jul 2024 05:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="UwEHZOxU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDC1B662
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 05:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721193379; cv=none; b=cnGqp/W4YflXsF7gMU27mpRn0L2UxptINhmTQq9fphmsvmCfXNP17XnaTFGeEkNzdLsR13GjPkNbP4WePDMWwrOzPQi8kxb3tK8fa/h/WNdnv0ylsVZWUYkj3jOa80MY208/KL3HsjeAGLOQENzg48+IqbNZbSI0RP8Ih8U0Y5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721193379; c=relaxed/simple;
	bh=1Y1mUI3HPhwo0NAWTL5IpJscsEB6hm8Op+om2+k+qK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=auH3vGnF/PPm1BpJXO69z8y/QwTW7w4bMivRtNV62VMJPSbSvEa1H2gxqnRNg5EJOVWj+67C+JAHc4vXT6LE4spAaByKsfbL6FtJOVWdsp7QHKDgQC/L0ItnScNA65eq4PVDFaFf1nyZb21tlXBuTJAentrAfDNCEKF+6+HH5z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org; spf=pass smtp.mailfrom=joelfernandes.org; dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b=UwEHZOxU; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ee91d9cb71so65127651fa.0
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 22:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1721193376; x=1721798176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J878m7YDuJ1vsJ0IM1yJyHlQQ/ZT+kMU4XzKikRHpPI=;
        b=UwEHZOxURuZrMM2sJF95oR8sGnYKKvair2UXP8+WPJMZgh2uiVd5uYg33bTLuK0bnr
         GsQ2TQ+RDMmt0e+fiXLFaKkfsXrQQXOAAI7TGYTkgX/3wgUOTXdHSkOvqx6g5rLAIaah
         /C9xHa9+fSjOJ1fxO/aLDGW/hB0KIBOAN1TYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721193376; x=1721798176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J878m7YDuJ1vsJ0IM1yJyHlQQ/ZT+kMU4XzKikRHpPI=;
        b=VS2zUPuyoAwG8FcinrBozxcCEphK7LQ3g1a29NZMKpjWd8keXgK1SKZxxiVR1CWk7Y
         tBZ6TTLoo+i5qClFzF91jozr3UhQT4DFUbv38hq9C6TNimHrEKzNa4t0c95jnMXwfMVk
         knfn5QwmrcsfbHMpBU28mKWyUaQ/WKrFlkVcyRnayfiwnuhGiSB0RgaCict7/+m93cGO
         Uupxi0+G4Fo5f4XS3dNbrBuBpfG2HRsSguDmcnztlabRYqiTmZf0lAVnQvpTIim+eSZ6
         WGYeTkpdnv5RHiOvfBjnDmfJeKjHk98rVT7tfPkS0xcmvs1ofUanVQ/Z8NSmgbL/P1pr
         QPug==
X-Forwarded-Encrypted: i=1; AJvYcCWtOOGKVu7BCyXBQ2Kw1IRjROybYW51YX9UhcYV/y1xpBboGDbMJl0JXhu+IT+vSYzFG1rjVvqBIcqnvOLUCWkmWjeH
X-Gm-Message-State: AOJu0YzLwaPPDjY3lswLfL/q1c3aS5a6y72Rp8AChOO6SaS+qbDKI/OJ
	qAH8su3PctvyXPG5us/QjFI0Cz0j4thFHmzCUcB09FBuZzFh8WKT8I0XZmKv1oldZ4roPrMZC/O
	rAFDEJ/TOJzbKvh0UY5Pv5sp9m7xNrwFCEzctDQ==
X-Google-Smtp-Source: AGHT+IEPk4eucy360gs4rur9MKsXi1tM/A23BVAysA9hiOIWXo2S+IFc1TCcIgXo5U4T8uWc+qN9+jXeVxdml8wubFs=
X-Received: by 2002:a2e:92c3:0:b0:2ec:5945:6301 with SMTP id
 38308e7fff4ca-2eefd08fe2cmr3539771fa.18.1721193375684; Tue, 16 Jul 2024
 22:16:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
 <ZjJf27yn-vkdB32X@google.com> <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com> <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
 <20240712122408.3f434cc5@rorschach.local.home> <ZpFdYFNfWcnq5yJM@google.com>
 <20240712131232.6d77947b@rorschach.local.home> <ZpcFxd_oyInfggXJ@google.com>
In-Reply-To: <ZpcFxd_oyInfggXJ@google.com>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Wed, 17 Jul 2024 01:16:00 -0400
Message-ID: <CAEXW_YS+8VKjUZ8cnkZxCfEcjcW=z52uGYzrfYj+peLfgHL75Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
To: Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Vineeth Remanan Pillai <vineeth@bitbyteword.org>, Ben Segall <bsegall@google.com>, 
	Borislav Petkov <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	graf@amazon.com, drjunior.org@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2024 at 7:44=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jul 12, 2024, Steven Rostedt wrote:
> > On Fri, 12 Jul 2024 09:44:16 -0700
> > Sean Christopherson <seanjc@google.com> wrote:
> >
> > > > All we need is a notifier that gets called at every VMEXIT.
> > >
> > > Why?  The only argument I've seen for needing to hook VM-Exit is so t=
hat the
> > > host can speculatively boost the priority of the vCPU when deliveryin=
g an IRQ,
> > > but (a) I'm unconvinced that is necessary, i.e. that the vCPU needs t=
o be boosted
> > > _before_ the guest IRQ handler is invoked and (b) it has almost no be=
nefit on
> > > modern hardware that supports posted interrupts and IPI virtualizatio=
n, i.e. for
> > > which there will be no VM-Exit.
> >
> > No. The speculatively boost was for something else, but slightly
> > related. I guess the ideal there was to have the interrupt coming in
> > boost the vCPU because the interrupt could be waking an RT task. It may
> > still be something needed, but that's not what I'm talking about here.
> >
> > The idea here is when an RT task is scheduled in on the guest, we want
> > to lazily boost it. As long as the vCPU is running on the CPU, we do
> > not need to do anything. If the RT task is scheduled for a very short
> > time, it should not need to call any hypercall. It would set the shared
> > memory to the new priority when the RT task is scheduled, and then put
> > back the lower priority when it is scheduled out and a SCHED_OTHER task
> > is scheduled in.
> >
> > Now if the vCPU gets preempted, it is this moment that we need the host
> > kernel to look at the current priority of the task thread running on
> > the vCPU. If it is an RT task, we need to boost the vCPU to that
> > priority, so that a lower priority host thread does not interrupt it.
>
> I got all that, but I still don't see any need to hook VM-Exit.  If the v=
CPU gets
> preempted, the host scheduler is already getting "notified", otherwise th=
e vCPU
> would still be scheduled in, i.e. wouldn't have been preempted.

What you're saying is the scheduler should change the priority of the
vCPU thread dynamically. That's really not the job of the scheduler.
The user of the scheduler is what changes the priority of threads, not
the scheduler itself.

Joel

