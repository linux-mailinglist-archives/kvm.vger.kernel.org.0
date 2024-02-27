Return-Path: <kvm+bounces-10105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F06E7869D90
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A90962855E9
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 17:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD9C71487FE;
	Tue, 27 Feb 2024 17:23:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3935D4D9E9
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 17:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709054633; cv=none; b=Sx392Nkko3TfmjS58ZIgm78FP5ZvfocyHX+6hcWnTmzia+Fkzb+6/zIySh5+lOVLiOzxt0+AcjKuYr8u2KDM1VqLaqBBBGL7GT6JYHqGTf+HHTNTLfiwjkdT26GMXRO1lTpKijIg+8bENMY7Fs4lM00/PrQmiytz+S8Zhpbv1iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709054633; c=relaxed/simple;
	bh=y4YSPdc3H2ZxHI/wJY60qI603cOP9kISBRM38MkuG0I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ycggw7/nlT1sR4mrA23tgnxIS1lZmMXlTXetClqfxEj5Nr2cJmYbDB+G+rVk9L3vFFiHCUW+puQOuHzu76xe0RRvCdtcySgbHEwxyLWjr4HxRR2KXWdwzxTRrbvDFnI4tOYIHy2SEgFjy39sD7FuCpr1NiP6OnVEzLgqKqw//ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C61C433C7;
	Tue, 27 Feb 2024 17:23:50 +0000 (UTC)
Date: Tue, 27 Feb 2024 12:25:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Paul
 Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj
 <mhal@rbox.co>, Paul Durrant <pdurrant@amazon.com>, David Woodhouse
 <dwmw@amazon.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra
 <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v2 7/8] KVM: x86/xen: avoid blocking in hardirq context
 in kvm_xen_set_evtchn_fast()
Message-ID: <20240227122552.20126460@gandalf.local.home>
In-Reply-To: <8C04AFD0-FC16-4572-AD23-FC7EEF663F11@infradead.org>
References: <20240227115648.3104-1-dwmw2@infradead.org>
	<20240227115648.3104-8-dwmw2@infradead.org>
	<20240227094326.04fd2b09@gandalf.local.home>
	<8C04AFD0-FC16-4572-AD23-FC7EEF663F11@infradead.org>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Feb 2024 17:00:42 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> On 27 February 2024 14:43:26 GMT, Steven Rostedt <rostedt@goodmis.org> wr=
ote:
> >On Tue, 27 Feb 2024 11:49:21 +0000
> >David Woodhouse <dwmw2@infradead.org> wrote:
> > =20
> >> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> >> index c16b6d394d55..d8b5326ecebc 100644
> >> --- a/arch/x86/kvm/xen.c
> >> +++ b/arch/x86/kvm/xen.c
> >> @@ -1736,9 +1736,23 @@ static int set_shinfo_evtchn_pending(struct kvm=
_vcpu *vcpu, u32 port)
> >>  	unsigned long flags;
> >>  	int rc =3D -EWOULDBLOCK;
> >> =20
> >> -	read_lock_irqsave(&gpc->lock, flags);
> >> +	local_irq_save(flags);
> >> +	if (!read_trylock(&gpc->lock)) { =20
> >
> >Note, directly disabling interrupts in PREEMPT_RT is just as bad as doing
> >so in non RT and the taking a mutex. =20
>=20
> Well, it *isn't* a mutex in non-RT. It's basically a spinlock. And even
> though RT turns it into a mutex this is only a trylock with a fall back
> to a slow path in process context, so it ends up being a very short
> period of irqdisable/lock =E2=80=93 just to validate the target address o=
f the
> cache, and write there. (Or fall back to that slow path, if the cache
> needs revalidating).

Yes, but if the trylock fails, you then call:

+	if (!read_trylock(&gpc->lock)) {
+		/*
+		 * When PREEMPT_RT turns locks into mutexes, rwlocks are
+		 * turned into mutexes and most interrupts are threaded.
+		 * But timer events may be delivered in hardirq mode due
+		 * to using HRTIMER_MODE_ABS_HARD. So bail to the slow
+		 * path if the trylock fails in interrupt context.
+		 */
+		if (in_interrupt())
+			goto out;
+
+		read_lock(&gpc->lock);

That takes the read_lock() with interrupts still disabled. On RT, that will
likely schedule as it had just failed a trylock.

+	}
+
>=20
> So I think this is probably OK, but...
>=20
>=20
> >Worse yet, in PREEMPT_RT read_unlock_irqrestore() isn't going to
> >re-enable interrupts. =20
>=20
> ... that's kind of odd. I think there's code elsewhere which assumes it
> will, and pairs it with an explicit local_irq_save() like the above, in a
> different atomic context (updating runstate time info when being
> descheduled). So *that* needs changing for RT?


I see Thomas replied. I'll leave the rest to him.

-- Steve

