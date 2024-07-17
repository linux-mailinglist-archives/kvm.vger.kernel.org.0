Return-Path: <kvm+bounces-21787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 645D0934397
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 23:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 972A11C2173E
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 21:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E35184124;
	Wed, 17 Jul 2024 21:00:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEAB1CD2B;
	Wed, 17 Jul 2024 21:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721250053; cv=none; b=DVofZEss51TeUtHYNMAddzyB7YOIHt4jFpc3zgkykNlTBlvy9r0BkrTpro75fz0VjQSDAxqDh8AA1XfiXtvCQ8EIEyip3W3DBt3Gxac2T+UKh6v0z9OiJLT27ifgEnVqE1xG6xHwcPxz6MHtemS8rYHW4qG/Tfkp9lXw4ISkUH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721250053; c=relaxed/simple;
	bh=sd17yyCSogEJ+geKjLkRzNk0EkzA6aa7NHHO4q+ztWE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jq6rQVt9Tb2VUaRIzuNko0xc7YeO++Szu/Wvz54U22Puo5/+Fm8CabHK5a9l0HUaz8DYR4rIau77BMUVa9sgM8x64QwX+0vH/qkgW2fUI9CUbMrHYbIyi1N9uBQhsF/DxpcfJx1Afth75H/z3sMZ1YF+n0oVczJzWU3HAMgRklw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DF3C2BD10;
	Wed, 17 Jul 2024 21:00:49 +0000 (UTC)
Date: Wed, 17 Jul 2024 17:00:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Sean Christopherson <seanjc@google.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Vineeth Remanan Pillai
 <vineeth@bitbyteword.org>, Ben Segall <bsegall@google.com>, Borislav Petkov
 <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar
 <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Mel Gorman
 <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner
 <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, Vincent
 Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal
 <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 himadrics@inria.fr, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 x86@kernel.org, graf@amazon.com, drjunior.org@gmail.com
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority
 management)
Message-ID: <20240717170047.5e1094f0@rorschach.local.home>
In-Reply-To: <CAEXW_YSpaKJg_7eHf4MeEFMASR_rJ9JoRfDPogsB4_66YA2abA@mail.gmail.com>
References: <ZjJf27yn-vkdB32X@google.com>
	<CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
	<CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
	<66912820.050a0220.15d64.10f5@mx.google.com>
	<19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
	<20240712122408.3f434cc5@rorschach.local.home>
	<ZpFdYFNfWcnq5yJM@google.com>
	<20240712131232.6d77947b@rorschach.local.home>
	<ZpcFxd_oyInfggXJ@google.com>
	<CAEXW_YS+8VKjUZ8cnkZxCfEcjcW=z52uGYzrfYj+peLfgHL75Q@mail.gmail.com>
	<ZpfR49IcXNLS9qbu@google.com>
	<20240717103647.735563af@rorschach.local.home>
	<20240717105233.07b4ec00@rorschach.local.home>
	<20240717112000.63136c12@rorschach.local.home>
	<CAEXW_YSpaKJg_7eHf4MeEFMASR_rJ9JoRfDPogsB4_66YA2abA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jul 2024 16:57:43 -0400
Joel Fernandes <joel@joelfernandes.org> wrote:

> On Wed, Jul 17, 2024 at 11:20=E2=80=AFAM Steven Rostedt <rostedt@goodmis.=
org> wrote:
> >
> > On Wed, 17 Jul 2024 10:52:33 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > =20
> > > We could possibly add a new sched class that has a dynamic priority. =
=20
> >
> > It wouldn't need to be a new sched class. This could work with just a
> > task_struct flag.
> >
> > It would only need to be checked in pick_next_task() and
> > try_to_wake_up(). It would require that the shared memory has to be
> > allocated by the host kernel and always present (unlike rseq). But this
> > coming from a virtio device driver, that shouldn't be a problem. =20
>=20
> Problem is its not only about preemption, if we set the vCPU boosted
> to RT class, and another RT task is already running on the same CPU,

That can only happen on wakeup (interrupt). As the point of lazy
priority changing, it is only done when the vCPU is running.

-- Steve


> then the vCPU thread should get migrated to different CPU. We can't do
> that I think if we just did it without doing a proper
> sched_setscheduler() / sched_setattr() and let the scheduler handle
> things.  Vineeth's patches was doing that in VMEXIT..



