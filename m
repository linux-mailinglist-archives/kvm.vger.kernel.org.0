Return-Path: <kvm+bounces-21777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1606933EAC
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 16:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B1292813B2
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 14:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67BB18133B;
	Wed, 17 Jul 2024 14:36:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4A71109;
	Wed, 17 Jul 2024 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721227012; cv=none; b=KuifIsfHrRLGLiGQnTjKcrT0UNvazq1JU4z2qqu24TY1XICDLu5SerNY/yrr4FhczcoNazXpqpD/RSTu3a+9BM5Q7ugw0DXjh/z/XqqEzH3jIapqN6oLN0pjh1/b5nSdFMWxTFz1Vmo5ECjscZlnjoXU+MgtPq+D9kyZBZhmomg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721227012; c=relaxed/simple;
	bh=CE9pKa3ma8lBfS7ILiZhNE4HGmrbG06pXvftfTT5KIk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RyeT7zwDr6aWbYL6F/aSjSMhuDzdHso7suTeXXu6YEpsRPMAyd+huqzheIF0sIa2B7icx0paOMiTAAEetw6/cAmBYPNb/VYm4VhNScFOFzK7HeAdj1dcrDqCao67XEWGQMTkO2IOXVu6ElccLSrWvEM7feGCbWJR/9JRiIWAtrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78D1C4AF0E;
	Wed, 17 Jul 2024 14:36:48 +0000 (UTC)
Date: Wed, 17 Jul 2024 10:36:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, Mathieu Desnoyers
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
Message-ID: <20240717103647.735563af@rorschach.local.home>
In-Reply-To: <ZpfR49IcXNLS9qbu@google.com>
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
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Jul 2024 07:14:59 -0700
Sean Christopherson <seanjc@google.com> wrote:

> > What you're saying is the scheduler should change the priority of the
> > vCPU thread dynamically. That's really not the job of the scheduler.
> > The user of the scheduler is what changes the priority of threads, not
> > the scheduler itself.  
> 
> No.  If we go the proposed route[*] of adding a data structure that lets userspace
> and/or the guest express/adjust the task's priority, then the scheduler simply
> checks that data structure when querying the priority of a task.

The problem with that is the only use case for such a feature is for
vCPUS. There's no use case for a single thread to up and down its
priority. I work a lot in RT applications (well, not as much anymore,
but my career was heavy into it). And I can't see any use case where a
single thread would bounce its priority around. In fact, if I did see
that, I would complain that it was a poorly designed system.

Now for a guest kernel, that's very different. It has to handle things
like priority inheritance and such, where bouncing a threads (or its
own vCPU thread) priority most definitely makes sense.

So you are requesting that we add a bad user space interface to allow
lazy priority management from a thread so that we can use it in the
proper use case of a vCPU?

-- Steve


