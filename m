Return-Path: <kvm+bounces-6889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12EEA83B664
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 02:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37AF21C234B5
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 01:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781A86FC7;
	Thu, 25 Jan 2024 01:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="M1limboU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD254566A
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 01:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706144952; cv=none; b=d3CJAcMuSVIKWWNCnWS9o+U8AJcOdNw7OMNqo98F4xYBTxHrypd6ruRQkfT9c/qvAKKn+x4/RDuT8aqHxttHDNnU1ndFuPR+rox0fExYdpnGaucls/jGLidhjO/LXgQ+XPVzAdsQGE9yW1FSZhP4w6isfpn5JRK08NAWUQPRWDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706144952; c=relaxed/simple;
	bh=XfnH0XnxBRxSw8s+Kmggue61fl8TjZsRhAk9ljaDQ/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ReWljtIC0A0S70W5a74R59BO3Y+tWEtUIB6/6fgqKsPSADWv/7SxrWxam5Zxz0eyRSJh3eRf30Kv+kluiPY0/7IaItdvtlPy/2kktwjJEFLSJ4/DB0WHWgNLnWQk2q2irMG8nNyffsM+YRT39JDFrePid0q1tSrmv2BqMn4Puhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org; spf=pass smtp.mailfrom=joelfernandes.org; dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b=M1limboU; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2cf108d8dbeso29209161fa.3
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 17:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1706144949; x=1706749749; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PiUW1kySFY5d/pkzoDzjFVz4adphI3+IFsUwCl7g0Cw=;
        b=M1limboU6m+53976lC325ZeB0bSQMABBxqExECk6McTgXWGObUxu5ocGquLfaT2XQM
         fR27aMpNBTLy3GJCLB0VkY/uXts/f3HLltthLAg/jH934I8QsGAxgJrwKVhu1z2x0VqP
         p+CNS2aand+nHQpF5PpP1xt/K4MW5CoRpsyu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706144949; x=1706749749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PiUW1kySFY5d/pkzoDzjFVz4adphI3+IFsUwCl7g0Cw=;
        b=kC9H9lUXudnJAeARZUCjxMxY+Vhf3mMnHP3gHRXz+b83fHnZFvYxSs+mtm4dhWOXEO
         noCVi+YP59GqGaVWa49fh3UJ1CSxDo7qUlIAIFIEuAdJczsAUaGnnMJJiHfQOUaqGEiq
         snhoiigtgfdK5SEPZCUudPvGBIOkPI3UQG5WDdKJxbwYaGtfZ5j4xm91Yiyre/2YvvTC
         UK8eZE8KmWvSZI9NlONRu+cIh6a3XQi8x86pFrd3t+wrE9GbuOldRupAnE6Blz97rVCk
         eXnj0vH0Z/Co/OQbdg82LiUdDRobFPncs2y1ox7wcHUP0XXUHw86XQ1Bzvqf31+tb79X
         G3pg==
X-Gm-Message-State: AOJu0YwbgleBTs2eWbAZytBgJp0CmxFfVwSQYnJa+uG0rCUxCCzfWwzO
	OlHnVPg7c9WGfObDEoxyYe/ZZW9oWcAEiiLcARQFwORp1KyKyAbyZx9LocJA0B74pzNQAAtX71D
	7POPmt/W3sE2MTm7ISJJKYx2EjhupOZNv4bYtJQ==
X-Google-Smtp-Source: AGHT+IHJ7U3y7K16MAJwZ9L7zwf69BBYdFrG85RGACDOZ5s5lNNGtUA2ZLqUoinUEmFG3pgoJzQ6zATtiiWTOT6o3Fk=
X-Received: by 2002:a2e:3a03:0:b0:2cf:1c74:9bcb with SMTP id
 h3-20020a2e3a03000000b002cf1c749bcbmr100829lja.106.1706144948656; Wed, 24 Jan
 2024 17:09:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <20231215181014.GB2853@maniforge>
 <6595bee6.e90a0220.57b35.76e9@mx.google.com> <20240104223410.GE303539@maniforge>
 <052b0521-2273-4b1f-bd94-a3decceb9b05@joelfernandes.org> <20240124170648.GA249939@maniforge>
In-Reply-To: <20240124170648.GA249939@maniforge>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Wed, 24 Jan 2024 20:08:56 -0500
Message-ID: <CAEXW_YR5weKdRD3DfJCUPr4eyXtj=HgTqw0=oV_0Kh2VDVhDdg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
To: David Vernet <void@manifault.com>
Cc: Sean Christopherson <seanjc@google.com>, "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>, 
	Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, 
	Barret Rhoden <brho@google.com>, David Dunn <daviddunn@google.com>, julia.lawall@inria.fr, 
	himadrispandya@gmail.com, jean-pierre.lozi@inria.fr, ast@kernel.org, 
	paulmck@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, Jan 24, 2024 at 12:06=E2=80=AFPM David Vernet <void@manifault.com> =
wrote:
>
[...]
> > There might be a caveat to the unboosting path though needing a hyperca=
ll and I
> > need to check with Vineeth on his latest code whether it needs a hyperc=
all, but
> > we could probably figure that out. In the latest design, one thing I kn=
ow is
> > that we just have to force a VMEXIT for both boosting and unboosting. W=
ell for
> > boosting, the VMEXIT just happens automatically due to vCPU preemption,=
 but for
> > unboosting it may not.
>
> As mentioned above, I think we'd need to add UAPI for setting state from
> the guest scheduler, even if we didn't use a hypercall to induce a
> VMEXIT, right?

I see what you mean now. I'll think more about it. The immediate
thought is to load BPF programs to trigger at appropriate points in
the guest. For instance, we already have tracepoints for preemption
disabling. I added that upstream like 8 years ago or something. And
sched_switch already knows when we switch to RT, which we could
leverage in the guest. The BPF program would set some shared memory
state in whatever format it desires, when it runs is what I'm
envisioning.

By the way, one crazy idea about loading BPF programs into a guest..
Maybe KVM can pass along the BPF programs to be loaded to the guest?
The VMM can do that. The nice thing there is only the host would be
the only responsible for the BPF programs. I am not sure if that makes
sense, so please let me know what you think. I guess the VMM should
also be passing additional metadata, like which tracepoints to hook
to, in the guest, etc.

> > In any case, can we not just force a VMEXIT from relevant path within t=
he guest,
> > again using a BPF program? I don't know what the BPF prog to do that wo=
uld look
> > like, but I was envisioning we would call a BPF prog from within a gues=
t if
> > needed at relevant point (example, return to guest userspace).
>
> I agree it would be useful to have a kfunc that could be used to force a
> VMEXIT if we e.g. need to trigger a resched or something. In general
> that seems like a pretty reasonable building block for something like
> this. I expect there are use cases where doing everything async would be
> useful as well. We'll have to see what works well in experimentation.

Sure.

> > >> Still there is a lot of merit to sharing memory with BPF and let BPF=
 decide
> > >> the format of the shared memory, than baking it into the kernel... s=
o thanks
> > >> for bringing this up! Lets talk more about it... Oh, and there's my =
LSFMMBPF
> > >> invitiation request ;-) ;-).
> > >
> > > Discussing this BPF feature at LSFMMBPF is a great idea -- I'll submi=
t a
> > > proposal for it and cc you. I looked and couldn't seem to find the
> > > thread for your LSFMMBPF proposal. Would you mind please sending a li=
nk?
> >
> > I actually have not even submitted one for LSFMM but my management is s=
upportive
> > of my visit. Do you want to go ahead and submit one with all of us incl=
uded in
> > the proposal? And I am again sorry for the late reply and hopefully we =
did not
> > miss any deadlines. Also on related note, there is interest in sched_ex=
t for
>
> I see that you submitted a proposal in [2] yesterday. Thanks for writing
> it up, it looks great and I'll comment on that thread adding a +1 for
> the discussion.
>
> [2]: https://lore.kernel.org/all/653c2448-614e-48d6-af31-c5920d688f3e@joe=
lfernandes.org/
>
> No worries at all about the reply latency. Thank you for being so open
> to discussing different approaches, and for driving the discussion. I
> think this could be a very powerful feature for the kernel so I'm
> pretty excited to further flesh out the design and figure out what makes
> the most sense here.

Great!

> > As mentioned above, for boosting, there is no hypercall. The VMEXIT is =
induced
> > by host preemption.
>
> I expect I am indeed missing something then, as mentioned above. VMEXIT
> aside, we still need some UAPI for the shared structure between the
> guest and host where the guest indicates its need for boosting, no?

Yes you are right, it is more clear now what you were referring to
with UAPI. I think we need figure that issue out. But if we can make
the VMM load BPF programs, then the host can completely decide how to
structure the shared memory.

> > > 2. What is the cost we're imposing on users if we force paravirt to b=
e
> > >    done through BPF? Is this prohibitively high?
> > >
> > > There is certainly a nonzero cost. As you pointed out, right now Andr=
oid
> > > apparently doesn't use much BPF, and adding the requisite logic to us=
e
> > > and manage BPF programs is not insigificant.
> > >
> > > Is that cost prohibitively high? I would say no. BPF should be fully
> > > supported on aarch64 at this point, so it's really a user space probl=
em.
> > > Managing the system is what user space does best, and many other
> > > ecosystems have managed to integrate BPF to great effect. So while th=
e
> > > cost is cetainly nonzero, I think there's a reasonable argument to be
> > > made that it's not prohibitively high.
> >
> > Yes, I think it is doable.
> >
> > Glad to be able to finally reply, and I shall prioritize this thread mo=
re on my
> > side moving forward.
>
> Thanks for your detailed reply, and happy belated birthday :-)

Thank you!!! :-)

 - Joel

