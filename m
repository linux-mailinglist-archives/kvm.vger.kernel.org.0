Return-Path: <kvm+bounces-4584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9EE7814EFA
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 18:40:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17C84B22BD2
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 17:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4572F3011A;
	Fri, 15 Dec 2023 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="BVtp74CP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D971930105
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6da4893142aso733614a34.0
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 09:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702662036; x=1703266836; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2xNwxrUoQHabToj/i/64zScVcUx7+IRz98c/crxfGeI=;
        b=BVtp74CPxjNm5QaKeaSkn2w0WyrHXpP8EKKdjrCHGQgBiDjsFLPXLVku0qk2U0cBiz
         AlnmI+wgYFgMMt7Ma0YZAkQ/vVCah/5xqW5blOCxVr2c0E4dUAtCXZF7XmA5rZ1jcdzW
         pfzNyzpMr2qmGlRsVFGOJf8hZUnU4le3FcXa/VKqDaFs0023d3BWv8sfgmAfzE/bD6vj
         b0i77gmETNiZXcf0MIu10MPp6hNUuAxs/iXxZGmlXbTqz3oQKS6clrhAJEps52CqC6bj
         QMQVS7GbHbiATPIqi6JrGB89Dg88oUCaTv5EqeZ19hvHg6DtBiOctmtQHd/WlDbAiU/f
         /v1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702662036; x=1703266836;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2xNwxrUoQHabToj/i/64zScVcUx7+IRz98c/crxfGeI=;
        b=lfewXz/tDet9THjFyfgGcr7WLlOD35Kiq/tsQMWWKvtGB1coFjYckcPUx+1MvEqvDe
         1bjsunaxJ+ZGPnG8nXZwtMnUn/q3Q0DiyKfOrzFQALSliFVWa2KY7hZbq7fxVflppl+k
         mWsuVHU9jQNi2CvcIIh2pm0Kch2HD9xY5yIJgIf0lI/cvGe2EdS1tIrLh4vQfoyc1p9D
         9feLQltBUGROO4516iaEeHBImDmVn3k6BllpRReKHDYv0jQSBP0nlIl4kgH9irui3SON
         9Zw175V9ud5yiUo5bjHggT/ZUNYexg7FjWp+VjrnnnoRlO4djQhuxORmRkOw5dl3NnCv
         K3aA==
X-Gm-Message-State: AOJu0YzN45j+HAjWANjpvY9RxLGVbzQfOjS8xHpQnrKA1vxJnh2H9KK+
	/308fR3HwdHt2LhwME1R8M4aXj9WWlFr4kaFPyIGmA==
X-Google-Smtp-Source: AGHT+IEZFg9Ga9F9cLX+1b4+m4Vq0StxR+3I2Y87jSC/8Vw5HOHVENnoE+BwBn2fZGPSKTAo7P+qKG4Vg3+mLBJAWtg=
X-Received: by 2002:a9d:7518:0:b0:6d9:ebaf:a5fa with SMTP id
 r24-20020a9d7518000000b006d9ebafa5famr11871714otk.54.1702662035860; Fri, 15
 Dec 2023 09:40:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com> <CAO7JXPhQ3zPzsNeuUphLx7o_+DOfJrmCoyRXXjcQMEzrKnGc9g@mail.gmail.com>
 <ZXuiM7s7LsT5hL3_@google.com> <CAO7JXPik9eMgef6amjCk5JPeEhg66ghDXowWQESBrd_fAaEsCA@mail.gmail.com>
 <ZXyFWTSU3KRk7EtQ@google.com>
In-Reply-To: <ZXyFWTSU3KRk7EtQ@google.com>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Fri, 15 Dec 2023 12:40:24 -0500
Message-ID: <CAO7JXPgH6Z9X5sWXLa_15VMQ-LU6Zy-tArauRowyDNTDWjwA2g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
To: Sean Christopherson <seanjc@google.com>
Cc: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
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
	Barret Rhoden <brho@google.com>, David Vernet <dvernet@meta.com>, 
	Joel Fernandes <joel@joelfernandes.org>
Content-Type: text/plain; charset="UTF-8"

[...snip...]
> > > IMO, this has a significantly lower ceiling than what is possible with something
> > > like sched_ext, e.g. it requires a host tick to make scheduling decisions, and
> > > because it'd require a kernel-defined ABI, would essentially be limited to knobs
> > > that are broadly useful.  I.e. every bit of information that you want to add to
> > > the guest/host ABI will need to get approval from at least the affected subsystems
> > > in the guest, from KVM, and possibly from the host scheduler too.  That's going
> > > to make for a very high bar.
> > >
> > Just thinking out  loud, The ABI could be very simple to start with. A
> > shared page with dedicated guest and host areas. Guest fills details
> > about its priority requirements, host fills details about the actions
> > it took(boost/unboost, priority/sched class etc). Passing this
> > information could be in-band or out-of-band. out-of-band could be used
> > by dedicated userland schedulers. If both guest and host agrees on
> > in-band during guest startup, kvm could hand over the data to
> > scheduler using a scheduler callback. I feel this small addition to
> > kvm could be maintainable and by leaving the protocol for interpreting
> > shared memory to guest and host, this would be very generic and cater
> > to multiple use cases. Something like above could be used both by
> > low-end devices and high-end server like systems and guest and host
> > could have custom protocols to interpret the data and make decisions.
> >
> > In this RFC, we have a miniature form of the above, where we have a
> > shared memory area and the scheduler callback is basically
> > sched_setscheduler. But it could be made very generic as part of ABI
> > design. For out-of-band schedulers, this call back could be setup by
> > sched_ext, a userland scheduler and any similar out-of-band scheduler.
> >
> > I agree, getting a consensus and approval is non-trivial. IMHO, this
> > use case is compelling for such an ABI because out-of-band schedulers
> > might not give the desired results for low-end devices.
> >
> > > > Having a formal paravirt scheduling ABI is something we would want to
> > > > pursue (as I mentioned in the cover letter) and this could help not
> > > > only with latencies, but optimal task placement for efficiency, power
> > > > utilization etc. kvm's role could be to set the stage and share
> > > > information with minimum delay and less resource overhead.
> > >
> > > Making KVM middle-man is most definitely not going to provide minimum delay or
> > > overhead.  Minimum delay would be the guest directly communicating with the host
> > > scheduler.  I get that convincing the sched folks to add a bunch of paravirt
> > > stuff is a tall order (for very good reason), but that's exactly why I Cc'd the
> > > sched_ext folks.
> > >
> > As mentioned above, guest directly talking to host scheduler without
> > involving kvm would mean an out-of-band scheduler and the
> > effectiveness depends on how fast the scheduler gets to run.
>
> No, the "host scheduler" could very well be a dedicated in-kernel paravirt
> scheduler.  It could be a sched_ext BPF program that for all intents and purposes
> is in-band.
>
Yes, if the scheduler is on the same physical cpu and acts on events
like VMEXIT/VMENTRY etc, this would work perfectly. Having the VM talk
to a scheduler running on another cpu and making decisions might not
be quick enough when we do not have enough cpu capacity.

> You are basically proposing that KVM bounce-buffer data between guest and host.
> I'm saying there's no _technical_ reason to use a bounce-buffer, just do zero copy.
>
I was also meaning zero copy only. The help required from the kvm side is:
- Pass the address of the shared memory to bpf programs/scheduler once
the guest sets it up.
- Invoke scheduler registered callbacks on events like VMEXIT,
VEMENTRY, interrupt injection etc. Its the job of guest and host
paravirt scheduler to interpret the shared memory contents and take
actions.

I admit current RFC doesn't strictly implement hooks and callbacks -
it calls sched_setscheduler in place of all callbacks that I mentioned
above. I guess this was your strongest objection.

As you mentioned in the reply to Joel, if it is fine for kvm to allow
hooks into events (VMEXIT, VMENTRY, interrupt injection etc) then, it
makes it easier to develop the ABI I was mentioning and have the hooks
implemented by a paravirt scheduler. We shall re-design the
architecture based on this for v2.

Thanks,
Vineeth

