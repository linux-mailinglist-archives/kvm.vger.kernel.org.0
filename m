Return-Path: <kvm+bounces-21776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06345933E3C
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 16:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 390AF1C215AE
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 14:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956AA18131F;
	Wed, 17 Jul 2024 14:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZnXAoNP7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F925181308
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721225703; cv=none; b=MCmXDYIT0PpaxbEaX3HdkpPCHLDgiUYqnXbp2LuJqxZZzajg/+lPO6W2vtO+MwMIhaOMsCCA49zV/nYNJIWEq7DKKeYpTNvBgKSY+L2zunyw0A+s5jzp79cIolHxtWw/tsMhXbNngVJtEJnnFt2Z1omoefFn1hKVDrJFzrJ/hkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721225703; c=relaxed/simple;
	bh=+mNL3SMgOOdYptPNdpuhLuZrQ6eKZUvUI2Io7zuGatE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L2/4KSu4clpSz9pq5/aQDboCaweEVDRqPVAA2n6CdeR53uAqmbX1ZtsrB2ooynIvKAIgCVpU6gE5halgrfTInFJyP2WJlu7wVad/3hljVa9FIXWvuYV+Df7sGEOw5iTdRtzY7oi6J3bhDa2HQbidUiFXymvEjd4XQETUWhDjpz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZnXAoNP7; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e05faf3fdc4so264327276.2
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 07:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721225701; x=1721830501; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yfOwLepSJ5Yy5OSl359lPsDoTvmGyUvqzWSdLdogSHo=;
        b=ZnXAoNP7aBop6pJ9BsQBqSixcDxreP4tSFKeOsz9IBhBoxmXU7DniMY2aqUeJeEHna
         epaF34X1zafmpATmbKCmZvIZ6W/kG8sKC9e42jPoX5PX9gf6fDkE4FMNMxyIQPP0O4S+
         0O6dcg27APLgNqahIoU53Pd4aVeTNEd+RhHSMOS4kI1jm8jTQN1vmajYyuvy/wc3XX6s
         HFJGILi7jFzhvrMz/PjE30E5V2Z2g8HHAPtlhig6I8SXmscEiZi7vG+SkOPkXVNYzuV+
         yrs8WGkQ6aWrJ6zdlHAdjukNt3cZJu53Ru+oe65Zn0etGOvztPeU6MGOd2NfJ3bVJSn7
         EMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721225701; x=1721830501;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yfOwLepSJ5Yy5OSl359lPsDoTvmGyUvqzWSdLdogSHo=;
        b=wJ0eT7Bnxl2tVsgBj1ICd2XP5zzkmKIZ9TWJ5iDHoEuQzVcHkFC+ZEbNzm9mJyFU2u
         KQAEO88z20jbHXeckLfum/vVg35eTYwoal0G6kYn4DZ1mRsasLo2Nj8nBHcUSgo3knyN
         FD4uDW9rA+/cBnl0rdxQotHFeo/ucfMpjEkUtnvb4w7eF2LZotzfIvORES0weuQ+AeRw
         1K1+yISxLYUpSoGRoDnjJuN8ufxYGgS3sP2wk+CjuanHyjzRSZ00Ah4mPHjY3Y4h16DQ
         1FXdqlJh3rreC2hJ+BdzzCdXAQHNjYF2fEiFjeDbKANyPixJ+o1Iid8e5JxAVNHtJ0Hq
         TGtw==
X-Forwarded-Encrypted: i=1; AJvYcCWnU7PoUPjgiIlUdxHYtAGROAeaOVK4TiaVIv1D6ciTQ0eTUrHoBDaD3DstYAPjlRG5pp79PGu+d6NG/cm8kIDlYTby
X-Gm-Message-State: AOJu0YyOvdK+Cu96YV4R2X6qvoZ6X/dsH7Y779Grm5i+a4O6ZOP5w5Kq
	ueKlhS9/13UL3g9CENBY2H0eAeK6AfU0NHtZ9J615Pf+54mwX9nBRc233WK4JHKen/9A3pj/+o1
	crg==
X-Google-Smtp-Source: AGHT+IHAgL65SrsUap9oLk8sgkDEhEl7hhfaitDvekS6/QgatWemDsFxo+e9KMYoAtW+baVNukp3gB4q8uI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c0b:b0:e05:a890:5abb with SMTP id
 3f1490d57ef6-e05ed69e706mr11325276.1.1721225701169; Wed, 17 Jul 2024 07:15:01
 -0700 (PDT)
Date: Wed, 17 Jul 2024 07:14:59 -0700
In-Reply-To: <CAEXW_YS+8VKjUZ8cnkZxCfEcjcW=z52uGYzrfYj+peLfgHL75Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZjJf27yn-vkdB32X@google.com> <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com> <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
 <20240712122408.3f434cc5@rorschach.local.home> <ZpFdYFNfWcnq5yJM@google.com>
 <20240712131232.6d77947b@rorschach.local.home> <ZpcFxd_oyInfggXJ@google.com> <CAEXW_YS+8VKjUZ8cnkZxCfEcjcW=z52uGYzrfYj+peLfgHL75Q@mail.gmail.com>
Message-ID: <ZpfR49IcXNLS9qbu@google.com>
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
From: Sean Christopherson <seanjc@google.com>
To: Joel Fernandes <joel@joelfernandes.org>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024, Joel Fernandes wrote:
> On Tue, Jul 16, 2024 at 7:44=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Jul 12, 2024, Steven Rostedt wrote:
> > > On Fri, 12 Jul 2024 09:44:16 -0700
> > > Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > > > All we need is a notifier that gets called at every VMEXIT.
> > > >
> > > > Why?  The only argument I've seen for needing to hook VM-Exit is so=
 that the
> > > > host can speculatively boost the priority of the vCPU when delivery=
ing an IRQ,
> > > > but (a) I'm unconvinced that is necessary, i.e. that the vCPU needs=
 to be boosted
> > > > _before_ the guest IRQ handler is invoked and (b) it has almost no =
benefit on
> > > > modern hardware that supports posted interrupts and IPI virtualizat=
ion, i.e. for
> > > > which there will be no VM-Exit.
> > >
> > > No. The speculatively boost was for something else, but slightly
> > > related. I guess the ideal there was to have the interrupt coming in
> > > boost the vCPU because the interrupt could be waking an RT task. It m=
ay
> > > still be something needed, but that's not what I'm talking about here=
.
> > >
> > > The idea here is when an RT task is scheduled in on the guest, we wan=
t
> > > to lazily boost it. As long as the vCPU is running on the CPU, we do
> > > not need to do anything. If the RT task is scheduled for a very short
> > > time, it should not need to call any hypercall. It would set the shar=
ed
> > > memory to the new priority when the RT task is scheduled, and then pu=
t
> > > back the lower priority when it is scheduled out and a SCHED_OTHER ta=
sk
> > > is scheduled in.
> > >
> > > Now if the vCPU gets preempted, it is this moment that we need the ho=
st
> > > kernel to look at the current priority of the task thread running on
> > > the vCPU. If it is an RT task, we need to boost the vCPU to that
> > > priority, so that a lower priority host thread does not interrupt it.
> >
> > I got all that, but I still don't see any need to hook VM-Exit.  If the=
 vCPU gets
> > preempted, the host scheduler is already getting "notified", otherwise =
the vCPU
> > would still be scheduled in, i.e. wouldn't have been preempted.
>=20
> What you're saying is the scheduler should change the priority of the
> vCPU thread dynamically. That's really not the job of the scheduler.
> The user of the scheduler is what changes the priority of threads, not
> the scheduler itself.

No.  If we go the proposed route[*] of adding a data structure that lets us=
erspace
and/or the guest express/adjust the task's priority, then the scheduler sim=
ply
checks that data structure when querying the priority of a task.

[*] https://lore.kernel.org/all/ZpFWfInsXQdPJC0V@google.com

