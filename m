Return-Path: <kvm+bounces-21780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4017A933F6F
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 17:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 715B91C232A3
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 15:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D4B181BA0;
	Wed, 17 Jul 2024 15:20:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15813381DE;
	Wed, 17 Jul 2024 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721229605; cv=none; b=IajDUhXFRGTgKDtEdzKoMMY85M9Lb+aBWuXNTg6wOPht+Lb+vaiOsCKp7Pq0DNLmwZFrQQZuoWwyX+OVScCKotvuluRaW0fCqvJU0MykgEPePl4buidxACUbqdI0A9ztn+R07X1X7mskPxwE34lqlTl+fO5E5XQmAchQLLctJ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721229605; c=relaxed/simple;
	bh=TqAHcdZNs4x+UJUeVu6C2dl+LJgO8SWutw1zoRpdcfM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AHy8RsrVmCJV0z4EVfzPSlJtJQ//FRlPGFmi+ll8oQ3vm851PN/Zzy4ip4VXcbVEbL/XO3ZPxc5JpqOQY4Fo3hJgn5s858lLTnr0v9ZygEGOtttReM1stEXX+8rser3W7XDFZ8q0bZhQRRo9LiuOi8v1Lf1/JN+vXWTUEnkBc9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E281C2BD10;
	Wed, 17 Jul 2024 15:20:01 +0000 (UTC)
Date: Wed, 17 Jul 2024 11:20:00 -0400
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
Message-ID: <20240717112000.63136c12@rorschach.local.home>
In-Reply-To: <20240717105233.07b4ec00@rorschach.local.home>
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
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Jul 2024 10:52:33 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> We could possibly add a new sched class that has a dynamic priority.

It wouldn't need to be a new sched class. This could work with just a
task_struct flag.

It would only need to be checked in pick_next_task() and
try_to_wake_up(). It would require that the shared memory has to be
allocated by the host kernel and always present (unlike rseq). But this
coming from a virtio device driver, that shouldn't be a problem.

If this flag is set on current, then the first thing that
pick_next_task() should do is to see if it needs to change current's
priority and policy (via a callback to the driver). And then it can
decide what task to pick, as if current was boosted, it could very well
be the next task again.

In try_to_wake_up(), if the task waking up has this flag set, it could
boost it via an option set by the virtio device. This would allow it to
preempt the current process if necessary and get on the CPU. Then the
guest would be require to lower its priority if it the boost was not
needed.

Hmm, this could work.

-- Steve



