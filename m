Return-Path: <kvm+bounces-4575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B04814BA5
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 16:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF51EB20F40
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 15:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE7F39FC9;
	Fri, 15 Dec 2023 15:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="pde2aIGI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083CA374D9
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 15:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ca03103155so8450491fa.0
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 07:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1702653615; x=1703258415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hmyST/XrGHFNC+XNE6mnVIuH8tC17821dmJgq7RAt7M=;
        b=pde2aIGImpukFp6qLv3idtH09uJrjySQmEC5EeeYrUqBs4NG3mn53HxltTmkp977bM
         S7JyyGP4AYAXVW6m7RodsOxUqxJ4eYtZU9EesN3oEJgcCvXfTuIUwwWp5kM841SW8LFX
         QG1JyFoDvyjWzu4DW1o/+WjZ+paMtH2PIl9GY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702653615; x=1703258415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hmyST/XrGHFNC+XNE6mnVIuH8tC17821dmJgq7RAt7M=;
        b=qi6Ib1J77Lav9Fr5qtTB849+8cByYpBpP0zhWn69aAjs5DH5SAcrnyyxanVdIsAJIw
         qayaYfNOr8UOIHvPze64lPsbmgkUcreB0b/0SaX7QHErupLTVVNK8dQKUaLQrzPTod3j
         2fUkTs3Z4As57y5XpHi0g0o6AbLd91B8QFrAJnTW+jKnhe6JA1xN3Yt81q79O1vsgtHS
         KKu63i3vrMwSDw6f8STi8NLLrlgk29HzLkBaIEd8PD9deS7h+o0kNWkozG1NCSlbtIni
         ldWs5u0AiR0V5TPM3qEeCgp5XgbUXTCKYcSq7fCX/SIQ4Mhf5u9BHwEKQIqxYoB14CIF
         /NDQ==
X-Gm-Message-State: AOJu0YxQfVet2cUuIm8CeWrrY1PN4rWDiEz5rGpiXilkvFGMLZFwzPD/
	QwTS96tA58LVGObEGBJqfx46V8HCe0+4U6Y5RfwW3g==
X-Google-Smtp-Source: AGHT+IHGzTVf/MkzNYE3KUJWVaOjTuqnRhV8YfrMGuKmVCSWI+OeZn5gjO0Sw2hniyy0Cu8uzW8era/J832E6Hh8DoE=
X-Received: by 2002:a2e:a588:0:b0:2cb:3169:b348 with SMTP id
 m8-20020a2ea588000000b002cb3169b348mr3145402ljp.96.1702653614855; Fri, 15 Dec
 2023 07:20:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <CAO7JXPihjjko6qe8tr6e6UE=L7uSR6AACq1Zwg+7n95s5A-yoQ@mail.gmail.com>
 <ZXth7hu7jaHbJZnj@google.com>
In-Reply-To: <ZXth7hu7jaHbJZnj@google.com>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Fri, 15 Dec 2023 10:20:03 -0500
Message-ID: <CAEXW_YTfgemRBKRv2UNjsOLhokxvvmHbVVj1JLtVmhywKtqeHA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
To: Sean Christopherson <seanjc@google.com>
Cc: Vineeth Remanan Pillai <vineeth@bitbyteword.org>, Ben Segall <bsegall@google.com>, 
	Borislav Petkov <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, 
	Barret Rhoden <brho@google.com>, David Vernet <dvernet@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sean,
Nice to see your quick response to the RFC, thanks. I wanted to
clarify some points below:

On Thu, Dec 14, 2023 at 3:13=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Dec 14, 2023, Vineeth Remanan Pillai wrote:
> > On Thu, Dec 14, 2023 at 11:38=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > Now when I think about it, the implementation seems to
> > suggest that we are putting policies in kvm. Ideally, the goal is:
> > - guest scheduler communicates the priority requirements of the workloa=
d
> > - kvm applies the priority to the vcpu task.
>
> Why?  Tasks are tasks, why does KVM need to get involved?  E.g. if the pr=
oblem
> is that userspace doesn't have the right knobs to adjust the priority of =
a task
> quickly and efficiently, then wouldn't it be better to solve that problem=
 in a
> generic way?

No, it is not only about tasks. We are boosting anything RT or above
such as softirq, irq etc as well. Could you please see the other
patches? Also, Vineeth please make this clear in the next revision.

> > > Pushing the scheduling policies to host userspace would allow for far=
 more control
> > > and flexibility.  E.g. a heavily paravirtualized environment where ho=
st userspace
> > > knows *exactly* what workloads are being run could have wildly differ=
ent policies
> > > than an environment where the guest is a fairly vanilla Linux VM that=
 has received
> > > a small amount of enlightment.
> > >
> > > Lastly, if the concern/argument is that userspace doesn't have the ri=
ght knobs
> > > to (quickly) boost vCPU tasks, then the proposed sched_ext functional=
ity seems
> > > tailor made for the problems you are trying to solve.
> > >
> > > https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org
> > >
> > You are right, sched_ext is a good choice to have policies
> > implemented. In our case, we would need a communication mechanism as
> > well and hence we thought kvm would work best to be a medium between
> > the guest and the host.
>
> Making KVM be the medium may be convenient and the quickest way to get a =
PoC
> out the door, but effectively making KVM a middle-man is going to be a hu=
ge net
> negative in the long term.  Userspace can communicate with the guest just=
 as
> easily as KVM, and if you make KVM the middle-man, then you effectively *=
must*
> define a relatively rigid guest/host ABI.

At the moment, the only ABI is a shared memory structure and a custom
MSR. This is no different from the existing steal time accounting
where a shared structure is similarly shared between host and guest,
we could perhaps augment that structure with other fields instead of
adding a new one? On the ABI point, we have deliberately tried to keep
it simple (for example, a few months ago we had hypercalls and we went
to great lengths to eliminate those).

> If instead the contract is between host userspace and the guest, the ABI =
can be
> much more fluid, e.g. if you (or any setup) can control at least some amo=
unt of
> code that runs in the guest

I see your point of view. One way to achieve this is to have a BPF
program run to implement the boosting part, in the VMEXIT path. KVM
then just calls a hook. Would that alleviate some of your concerns?

> then the contract between the guest and host doesn't
> even need to be formally defined, it could simply be a matter of bundling=
 host
> and guest code appropriately.
>
> If you want to land support for a given contract in upstream repositories=
, e.g.
> to broadly enable paravirt scheduling support across a variety of usersep=
ace VMMs
> and/or guests, then yeah, you'll need a formal ABI.  But that's still not=
 a good
> reason to have KVM define the ABI.  Doing it in KVM might be a wee bit ea=
sier because
> it's largely just a matter of writing code, and LKML provides a centraliz=
ed channel
> for getting buyin from all parties.  But defining an ABI that's independe=
nt of the
> kernel is absolutely doable, e.g. see the many virtio specs.
>
> I'm not saying KVM can't help, e.g. if there is information that is known=
 only
> to KVM, but the vast majority of the contract doesn't need to be defined =
by KVM.

The key to making this working of the patch is VMEXIT path, that is
only available to KVM. If we do anything later, then it might be too
late. We have to intervene *before* the scheduler takes the vCPU
thread off the CPU. Similarly, in the case of an interrupt injected
into the guest, we have to boost the vCPU before the "vCPU run" stage
-- anything later might be too late.

Also you mentioned something about the tick path in the other email,
we have no control over the host tick preempting the vCPU thread. The
guest *will VMEXIT* on the host tick. On ChromeOS, we run multiple VMs
and overcommitting is very common especially on devices with smaller
number of CPUs.

Just to clarify, this isn't a "quick POC". We have been working on
this for many months and it was hard to get working correctly and
handle all corner cases. We are finally at a point where - it just
works (TM) and is roughly half the code size of when we initially
started.

thanks,

 - Joel

