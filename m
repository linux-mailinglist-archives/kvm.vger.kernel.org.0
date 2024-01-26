Return-Path: <kvm+bounces-7212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFC283E3CD
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:19:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C0E5B22BCB
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 21:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4EFD250E8;
	Fri, 26 Jan 2024 21:19:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5940124B21;
	Fri, 26 Jan 2024 21:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706303960; cv=none; b=iLVfEb2q9TIMx+W96UNCDj/cdxgftyO3y03XxxSjASyRQ1WAbPFJ/PX/wEwRcLpO1vF3b57uKcy73noqoSIF2IBDL7LDU2AQVekPkZe3Bu/eqLnSWcbE2DC//llgLy6bzSPqfRlXsE2VdQiZjugZrelRinhUs4aFAQtErH4m6Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706303960; c=relaxed/simple;
	bh=eQKYfO/cv8kC+WzuBVji+qbCXw8oz0VQZF3PPQci9YQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QY4FYPvfF6L78tOXKgN5nlAGx0mVXBStoOf3sTzue5jjepd6BwS3vS1deHsXHmp78Hh7eFiXmKfS4+/2kzpuU+3oHLQB3jH2clLYScw9bqSEWMKgJ/C3j7XAJ8Voc99AqjRsNXYydZQik5HlFWH7l3QrKgX6jOYhSMQIotc18UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=manifault.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=manifault.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6e0e08c70f7so468171a34.2;
        Fri, 26 Jan 2024 13:19:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706303957; x=1706908757;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eQKYfO/cv8kC+WzuBVji+qbCXw8oz0VQZF3PPQci9YQ=;
        b=ejiCyMSLR1nRQsFZDpSEjXTDigh/eUOKY+HxZUlq7aAMchEpo3GB92EpHEEay9vU0O
         ZAji4rOfFzWKqsHSYT1+mkxnfTlH2e5YJzNYFj310ZEn3BDRoCk+T3cfF/2Ar6Bs7Hhq
         6KvSN1RjnMv1QdObjvqowoqewavpGzIC4CKYtuHsvDmvSPe89HiUs6H+OrwKlpCr8bd8
         i3fbb0LUbe5ziaVx2QYHnoQQldz4g6ZFgruhgoC8Nnxj1rXFz69pVEaZ3/6Cy/cRCkUl
         s9f/TfFCvcsApdpg571mLM0gwV5PY4/gyQn2/jozK5IaKT876fQE7aYvzAnUxXE1Wx/4
         6Gxg==
X-Gm-Message-State: AOJu0YxgyIiM1kTaPX5OHlc3J7AHSQ6H0bViwBBe3mOydeBniLOgmcnP
	HvLe92lx52uxoxWCJXcyTWS8IGsRke8dTP+Zv9MYruelZEkqMMFq
X-Google-Smtp-Source: AGHT+IHf09Gfyvt0G8S1AhkYf+4bQllzPxaanyaMqPuBvf+9+61iV07vF4yoABPOCLr7VssJR6u4iQ==
X-Received: by 2002:a05:6830:6a8e:b0:6dc:69e3:48e1 with SMTP id da14-20020a0568306a8e00b006dc69e348e1mr448962otb.39.1706303957230;
        Fri, 26 Jan 2024 13:19:17 -0800 (PST)
Received: from maniforge (c-24-1-27-177.hsd1.il.comcast.net. [24.1.27.177])
        by smtp.gmail.com with ESMTPSA id jc11-20020a05622a714b00b00429d86c5c68sm870970qtb.32.2024.01.26.13.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jan 2024 13:19:16 -0800 (PST)
Date: Fri, 26 Jan 2024 15:19:13 -0600
From: David Vernet <void@manifault.com>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Sean Christopherson <seanjc@google.com>,
	"Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>,
	Barret Rhoden <brho@google.com>, David Dunn <daviddunn@google.com>,
	julia.lawall@inria.fr, himadrispandya@gmail.com,
	jean-pierre.lozi@inria.fr, ast@kernel.org, paulmck@kernel.org
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
Message-ID: <20240126211913.GB28094@maniforge>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com>
 <20231215181014.GB2853@maniforge>
 <6595bee6.e90a0220.57b35.76e9@mx.google.com>
 <20240104223410.GE303539@maniforge>
 <052b0521-2273-4b1f-bd94-a3decceb9b05@joelfernandes.org>
 <20240124170648.GA249939@maniforge>
 <CAEXW_YR5weKdRD3DfJCUPr4eyXtj=HgTqw0=oV_0Kh2VDVhDdg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PdQvZZuf75rcA8TD"
Content-Disposition: inline
In-Reply-To: <CAEXW_YR5weKdRD3DfJCUPr4eyXtj=HgTqw0=oV_0Kh2VDVhDdg@mail.gmail.com>
User-Agent: Mutt/2.2.12 (2023-09-09)


--PdQvZZuf75rcA8TD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 08:08:56PM -0500, Joel Fernandes wrote:
> Hi David,

Hi Joel,

>=20
> On Wed, Jan 24, 2024 at 12:06=E2=80=AFPM David Vernet <void@manifault.com=
> wrote:
> >
> [...]
> > > There might be a caveat to the unboosting path though needing a hyper=
call and I
> > > need to check with Vineeth on his latest code whether it needs a hype=
rcall, but
> > > we could probably figure that out. In the latest design, one thing I =
know is
> > > that we just have to force a VMEXIT for both boosting and unboosting.=
 Well for
> > > boosting, the VMEXIT just happens automatically due to vCPU preemptio=
n, but for
> > > unboosting it may not.
> >
> > As mentioned above, I think we'd need to add UAPI for setting state from
> > the guest scheduler, even if we didn't use a hypercall to induce a
> > VMEXIT, right?
>=20
> I see what you mean now. I'll think more about it. The immediate
> thought is to load BPF programs to trigger at appropriate points in
> the guest. For instance, we already have tracepoints for preemption
> disabling. I added that upstream like 8 years ago or something. And
> sched_switch already knows when we switch to RT, which we could
> leverage in the guest. The BPF program would set some shared memory
> state in whatever format it desires, when it runs is what I'm
> envisioning.

That sounds like it would work perfectly. Tracepoints are really ideal,
both because BPF doesn't allow (almost?) any kfuncs to be called from
fentry/kprobe progs (whereas they do from tracepoints), and because
tracepoint program arguments are trusted so the BPF verifier knows that
it's safe to pass them onto kfuncs, etc as refernced kptrs.

> By the way, one crazy idea about loading BPF programs into a guest..
> Maybe KVM can pass along the BPF programs to be loaded to the guest?
> The VMM can do that. The nice thing there is only the host would be
> the only responsible for the BPF programs. I am not sure if that makes
> sense, so please let me know what you think. I guess the VMM should
> also be passing additional metadata, like which tracepoints to hook
> to, in the guest, etc.

This I'm not sure I can really share an intelligent opinion on. My first
thought was that the guest VM would load some BPF programs at boot using
something like systemd, and then those progs would somehow register with
the VMM -- maybe through a kfunc implemented by KVM that makes a
hypercall. Perhaps what you're suggesting would work as well.

> > > In any case, can we not just force a VMEXIT from relevant path within=
 the guest,
> > > again using a BPF program? I don't know what the BPF prog to do that =
would look
> > > like, but I was envisioning we would call a BPF prog from within a gu=
est if
> > > needed at relevant point (example, return to guest userspace).
> >
> > I agree it would be useful to have a kfunc that could be used to force a
> > VMEXIT if we e.g. need to trigger a resched or something. In general
> > that seems like a pretty reasonable building block for something like
> > this. I expect there are use cases where doing everything async would be
> > useful as well. We'll have to see what works well in experimentation.
>=20
> Sure.
>=20
> > > >> Still there is a lot of merit to sharing memory with BPF and let B=
PF decide
> > > >> the format of the shared memory, than baking it into the kernel...=
 so thanks
> > > >> for bringing this up! Lets talk more about it... Oh, and there's m=
y LSFMMBPF
> > > >> invitiation request ;-) ;-).
> > > >
> > > > Discussing this BPF feature at LSFMMBPF is a great idea -- I'll sub=
mit a
> > > > proposal for it and cc you. I looked and couldn't seem to find the
> > > > thread for your LSFMMBPF proposal. Would you mind please sending a =
link?
> > >
> > > I actually have not even submitted one for LSFMM but my management is=
 supportive
> > > of my visit. Do you want to go ahead and submit one with all of us in=
cluded in
> > > the proposal? And I am again sorry for the late reply and hopefully w=
e did not
> > > miss any deadlines. Also on related note, there is interest in sched_=
ext for
> >
> > I see that you submitted a proposal in [2] yesterday. Thanks for writing
> > it up, it looks great and I'll comment on that thread adding a +1 for
> > the discussion.
> >
> > [2]: https://lore.kernel.org/all/653c2448-614e-48d6-af31-c5920d688f3e@j=
oelfernandes.org/
> >
> > No worries at all about the reply latency. Thank you for being so open
> > to discussing different approaches, and for driving the discussion. I
> > think this could be a very powerful feature for the kernel so I'm
> > pretty excited to further flesh out the design and figure out what makes
> > the most sense here.
>=20
> Great!
>=20
> > > As mentioned above, for boosting, there is no hypercall. The VMEXIT i=
s induced
> > > by host preemption.
> >
> > I expect I am indeed missing something then, as mentioned above. VMEXIT
> > aside, we still need some UAPI for the shared structure between the
> > guest and host where the guest indicates its need for boosting, no?
>=20
> Yes you are right, it is more clear now what you were referring to
> with UAPI. I think we need figure that issue out. But if we can make
> the VMM load BPF programs, then the host can completely decide how to
> structure the shared memory.

Yep -- if the communication channel is from guest BPF -> host BPF, I
think the UAPI concerns are completely addressed. Figuring out how to
actually load the guest BPF progs and setup the communication channels
is another matter.

Thanks,
David

--PdQvZZuf75rcA8TD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQRBxU1So5MTLwphjdFZ5LhpZcTzZAUCZbQh0QAKCRBZ5LhpZcTz
ZMyjAQDPs1jj5QTrt4NX9R4iZz13HaPvP5cEVDgB359fPOtAMAD+LQVf0hKHUlfW
s3MUuJNykF9SAFO+FrOY4Ce6ALH1oAo=
=bjnI
-----END PGP SIGNATURE-----

--PdQvZZuf75rcA8TD--

