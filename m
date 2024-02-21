Return-Path: <kvm+bounces-9333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D67485E418
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 18:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C747B2844AE
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D513183CB3;
	Wed, 21 Feb 2024 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="j3vcledb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF02C7FBD2;
	Wed, 21 Feb 2024 17:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708535483; cv=none; b=Dcl3M567R0PEpiuQEllPHsuYT+VjhyvXsjiVGBjhzBt/HtpG4ACwOezxGbtL57gIn5n+ciGJoB45hWjY/Q8Vh/pnMNdkiV8j49PNPYlRntJ9zfDhJPUZpByvS5RUq9ERF1i2Z4gObewONG9xCCmnb6LDRPaOe7fLLQ9GLBQmBd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708535483; c=relaxed/simple;
	bh=RdPgpa+YXsbUuiD5e/mvq6eImHUit013/agYC5hJ5NQ=;
	h=Subject:MIME-Version:Content-Type:Date:Message-ID:To:CC:From:
	 References:In-Reply-To; b=lgx+C9NLNtJgHX/LxMU8lSsjsvz7FVgnH8WtqHkIBhKgai3CUU9btk8fr1aPwi0Oar0Y+CSmkeGSDmhDLjluOz2K/aCNrqIN0bSlUoBHtH8GnUXLrMo+etE8FujF6BxrZmxB42WYtRanGqs1pSuxAyBr7PzAye9da+HSKNe/TZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.es; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=j3vcledb; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.es
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1708535481; x=1740071481;
  h=mime-version:content-transfer-encoding:date:message-id:
   to:cc:from:references:in-reply-to:subject;
  bh=HNyaS2ubZ/63dCqupZWCaWz7EUlNlA2EX3ub2DgQAs8=;
  b=j3vcledbFp2X4L5NKxF5ZbNCSleHjgGNQNQ4WL4ZQbeXGyYc2Fiiz1jI
   C+HZ6J4IBvCL1cbW7yVHZUk8OUUX/ZsECyRwy2AgTFqXdTmW/ADKQld5E
   1gCbe9cHhiN8C9gFCTQFUMfij0JDG3UWMj4+td/I383/FxgsXxT3tCmcp
   k=;
X-IronPort-AV: E=Sophos;i="6.06,176,1705363200"; 
   d="scan'208";a="388182292"
Subject: Re: [RFC] cputime: Introduce option to force full dynticks accounting on
 NOHZ & NOHZ_IDLE CPUs
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 17:11:18 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:46546]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.16.90:2525] with esmtp (Farcaster)
 id 90dc1c36-4357-440a-b4ed-45fb23dc3039; Wed, 21 Feb 2024 17:11:17 +0000 (UTC)
X-Farcaster-Flow-ID: 90dc1c36-4357-440a-b4ed-45fb23dc3039
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Wed, 21 Feb 2024 17:11:17 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Wed, 21 Feb
 2024 17:11:13 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Feb 2024 17:11:09 +0000
Message-ID: <CZAX9ZA1VRUZ.353NNERCBGKUU@amazon.com>
To: Sean Christopherson <seanjc@google.com>
CC: <frederic@kernel.org>, <paulmck@kernel.org>, <jalliste@amazon.co.uk>,
	<mhiramat@kernel.org>, <akpm@linux-foundation.org>, <pmladek@suse.com>,
	<rdunlap@infradead.org>, <tsi@tuyoix.net>, <nphamcs@gmail.com>,
	<gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <pbonzini@redhat.com>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
X-Mailer: aerc 0.16.0-127-gec0f4a50cf77
References: <20240219175735.33171-1-nsaenz@amazon.com>
 <ZdTQyb23KJEYqbcw@google.com> <CZA43Y64EK8R.1M8J5Q6L39LFB@amazon.com>
 <ZdYjvBItrl20oHXC@google.com>
In-Reply-To: <ZdYjvBItrl20oHXC@google.com>
X-ClientProxiedBy: EX19D040UWA002.ant.amazon.com (10.13.139.113) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Wed Feb 21, 2024 at 4:24 PM UTC, Sean Christopherson wrote:
> On Tue, Feb 20, 2024, Nicolas Saenz Julienne wrote:
> > Hi Sean,
> >
> > On Tue Feb 20, 2024 at 4:18 PM UTC, Sean Christopherson wrote:
> > > On Mon, Feb 19, 2024, Nicolas Saenz Julienne wrote:
> > > > Under certain extreme conditions, the tick-based cputime accounting=
 may
> > > > produce inaccurate data. For instance, guest CPU usage is sensitive=
 to
> > > > interrupts firing right before the tick's expiration.
>
> Ah, this confused me.  The "right before" is a bit misleading.  It's more=
 like
> "shortly before", because if the interrupt that occurs due to the guest's=
 tick
> arrives _right_ before the host tick expires, then commit 160457140187 sh=
ould
> avoid horrific accounting.
>
> > > > This forces the guest into kernel context, and has that time slice
> > > > wrongly accounted as system time. This issue is exacerbated if the
> > > > interrupt source is in sync with the tick,
>
> It's worth calling out why this can happen, to make it clear that getting=
 into
> such syncopation can happen quite naturally.  E.g. something like:
>
>       interrupt source is in sync with the tick, e.g. if the guest's tick
>       is configured to run at the same frequency as the host tick, and th=
e
>       guest tick is every so slightly ahead of the host tick.

I'll incorporate both comments into the description. :)

> > > > significantly skewing usage metrics towards system time.
> > >
> > > ...
> > >
> > > > NOTE: This wasn't tested in depth, and it's mostly intended to high=
light
> > > > the issue we're trying to solve. Also ccing KVM folks, since it's
> > > > relevant to guest CPU usage accounting.
> > >
> > > How bad is the synchronization issue on upstream kernels?  We tried t=
o address
> > > that in commit 160457140187 ("KVM: x86: Defer vtime accounting 'til a=
fter IRQ handling").
> > >
> > > I don't expect it to be foolproof, but it'd be good to know if there'=
s a blatant
> > > flaw and/or easily closed hole.
> >
> > The issue is not really about the interrupts themselves, but their side
> > effects.
> >
> > For instance, let's say the guest sets up an Hyper-V stimer that
> > consistently fires 1 us before the preemption tick. The preemption tick
> > will expire while the vCPU thread is running with !PF_VCPU (maybe insid=
e
> > kvm_hv_process_stimers() for ex.). As long as they both keep in sync,
> > you'll get a 100% system usage. I was able to reproduce this one throug=
h
> > kvm-unit-tests, but the race window is too small to keep the interrupts
> > in sync for long periods of time, yet still capable of producing random
> > system usage bursts (which unacceptable for some use-cases).
> >
> > Other use-cases have bigger race windows and managed to maintain high
> > system CPU usage over long periods of time. For example, with user-spac=
e
> > HPET emulation, or KVM+Xen (don't know the fine details on these, but
> > VIRT_CPU_ACCOUNTING_GEN fixes the mis-accounting). It all comes down to
> > the same situation. Something triggers an exit, and the vCPU thread goe=
s
> > past 'vtime_account_guest_exit()' just in time for the tick interrupt t=
o
> > show up.
>
> I suspect the common "problem" with those flows is that emulating the gue=
st timer
> interrupt is (a) slow, relatively speaking and (b) done with interrupts e=
nabled.
>
> E.g. on VMX, the TSC deadline timer is emulated via VMX preemption timer,=
 and both
> the programming of the guest's TSC deadline timer and the handling of the=
 expiration
> interrupt is done in the VM-Exit fastpath with IRQs disabled.  As a resul=
t, even
> if the host tick interrupt is a hair behind the guest tick, it doesn't af=
fect
> accounting because the host tick interrupt will never be delivered while =
KVM is
> emulating the guest's periodic tick.
>
> I'm guessing that if you tested on SVM (or a guest that doesn't use the A=
PIC timer
> in deadline mode), which doesn't utilize the fastpath since KVM needs to =
bounce
> through hrtimers, then you'd see similar accounting problems even without=
 using
> any of the problematic "slow" timer sources.

That's right, the "problem" will show up when periodically emulating
something with interrupts enabled. The slower the emulation the bigger
the race window. It's just a limitation of tick based accounting, I have
the feeling there isn't much KVM can do.

Nicolas

