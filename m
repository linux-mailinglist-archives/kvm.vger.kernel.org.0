Return-Path: <kvm+bounces-21778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 620A5933EDF
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 16:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17DDF1F21A3B
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 14:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDED8181B8D;
	Wed, 17 Jul 2024 14:53:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62360180A6A;
	Wed, 17 Jul 2024 14:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721227984; cv=none; b=MV9yNNkfBWIeq86+/72TSMd6DUfaIxMMHJLnjkk6mqsOfdQuYns852TU3wMK4dBsoW+L8YKd6FMt0iV0wHz2RA9waL6Z1RTwGalqRgRFkH2c1ueb7invl3sCjV3eXJnixiss2X3lOdCuj29IoDEwPxaQjdiRAteql0G02ZRHG9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721227984; c=relaxed/simple;
	bh=BQu8Xb+iJ8oHoZnOrFTXzZJSBfjBKhTJEwYVf9DXSxY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pYYWbaIuT14fSfIT/lUk5GQNjObrkDKFdtq/8YEGMVwFQfOu1zq66Ixk2qNF7AUDg5vo4hpI4X892w3WlMZe1Na63LSkhoZbGvdtlTl37flP3IXzyCfQEJAVKqnG/Jovn9z7fKYcWGYIVmWOB6gZBxX7mpUK5c713SaEn3ac6Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1570BC2BD10;
	Wed, 17 Jul 2024 14:52:37 +0000 (UTC)
Date: Wed, 17 Jul 2024 10:52:33 -0400
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
Message-ID: <20240717105233.07b4ec00@rorschach.local.home>
In-Reply-To: <20240717103647.735563af@rorschach.local.home>
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
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Jul 2024 10:36:47 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> The problem with that is the only use case for such a feature is for
> vCPUS. There's no use case for a single thread to up and down its
> priority. I work a lot in RT applications (well, not as much anymore,
> but my career was heavy into it). And I can't see any use case where a
> single thread would bounce its priority around. In fact, if I did see
> that, I would complain that it was a poorly designed system.
> 
> Now for a guest kernel, that's very different. It has to handle things
> like priority inheritance and such, where bouncing a threads (or its
> own vCPU thread) priority most definitely makes sense.
> 
> So you are requesting that we add a bad user space interface to allow
> lazy priority management from a thread so that we can use it in the
> proper use case of a vCPU?

Now I stated the above thinking you wanted to add a generic interface
for all user space. But perhaps there is a way to get this to be done
by the scheduler itself. But its use case is still only for VMs.

We could possibly add a new sched class that has a dynamic priority.
That is, it can switch between other sched classes. A vCPU thread could
be assigned to this class from inside the kernel (via a virtio device)
where this is not exposed to user space at all. Then the virtio device
would control the mapping of a page between the vCPU thread and the
host kernel. When this task gets scheduled, it can call into the code
that handles the dynamic priority. This will require buy-in from the
scheduler folks.

This could also handle the case of a vCPU being woken up by an
interrupt, as the hooks could be there on the wakeup side as well.

Thoughts?

-- Steve

