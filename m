Return-Path: <kvm+bounces-10103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A6FB869D5A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:19:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95BB31C24185
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 17:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1248A481AD;
	Tue, 27 Feb 2024 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0a07aQHy";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="/G4A9lkG"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322653D541
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 17:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709054343; cv=none; b=MZNYtjpVi+WpJk50lKH4R3Exuf+SxeAYl+/xT7AQ6ts/h2QEL3RwO2IEn7pEY8gHx2omVhBmiYKp/N7vjXAc8guZ2qA2EdC6Ra271S3y42EUqyU2SMtJIkLunBgj1ibXhu6EwXHPX8ar20FVVzOUPdlO7J2rfGGKa7E5bYQ/1Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709054343; c=relaxed/simple;
	bh=xpYxmPEdGmI5zt7suwZbWaQmvNlv83NEIj7LE/rTlI0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=q3pFRul0Rhw4MeukvwAko86w8KRGHcTKUFvMAzyAR2o2ETamPaSzBqBhtkJId2y1QCnA8oTaf5JLhbADmdvoUMFf87VhlTV/vPcmqxdT1p3z8/V0QN0qk9rUDkAzf2JnF+QOqvTcbzy3YUCkZA5zAP1S4j3qbI8aesQoujzr9gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0a07aQHy; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=/G4A9lkG; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1709054339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B3n+7oYvK7GdVabyNbEUjinCuseZ/u8SnhsemE0ZGRM=;
	b=0a07aQHy7trE9QXX7OawNYpt7O4/d2YlBfNcOmcmZGHQPQU9oc8GMGOgPVCnV7rUREOsm5
	T5qRG2SC/XuESJK2hh+GUp5tmnXwebXk+RpqPvaN5ON5jLZirklJMOaP3J3R9F8qrMWu+B
	78eo/EImJMHX2KUNizD9FNHxiHfeNWSD536KWjRNJcqu6O8KrmuzUjiCclFjNDy78/+sUi
	XGHAdtCV5LyPPfHT+dTuf6UOWUp0cWRdqkxtM8f/KkNMbm54jBIWIcyZ7ehDTCykzcK0JJ
	qkoPGMygO89aEXO7VNxKRNXp3cbYn7UboqdhXiGlYQdaTOmfY/6xN3ocutaDsg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1709054339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B3n+7oYvK7GdVabyNbEUjinCuseZ/u8SnhsemE0ZGRM=;
	b=/G4A9lkGMuqnclnariBZ9p0kEHF9PDGhrWqQ1/BHn/NgtkjmvrEW2yd7mgl570KTlntcN6
	XjMQtTRXrEKqw+BQ==
To: David Woodhouse <dwmw2@infradead.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Paul
 Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj
 <mhal@rbox.co>, Paul Durrant <pdurrant@amazon.com>, David Woodhouse
 <dwmw@amazon.co.uk>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org
Subject: Re: [PATCH v2 7/8] KVM: x86/xen: avoid blocking in hardirq context
 in kvm_xen_set_evtchn_fast()
In-Reply-To: <8C04AFD0-FC16-4572-AD23-FC7EEF663F11@infradead.org>
References: <20240227115648.3104-1-dwmw2@infradead.org>
 <20240227115648.3104-8-dwmw2@infradead.org>
 <20240227094326.04fd2b09@gandalf.local.home>
 <8C04AFD0-FC16-4572-AD23-FC7EEF663F11@infradead.org>
Date: Tue, 27 Feb 2024 18:18:58 +0100
Message-ID: <871q8xakql.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27 2024 at 17:00, David Woodhouse wrote:
> On 27 February 2024 14:43:26 GMT, Steven Rostedt <rostedt@goodmis.org> wr=
ote:
>>On Tue, 27 Feb 2024 11:49:21 +0000
>>David Woodhouse <dwmw2@infradead.org> wrote:
>>
>>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>>> index c16b6d394d55..d8b5326ecebc 100644
>>> --- a/arch/x86/kvm/xen.c
>>> +++ b/arch/x86/kvm/xen.c
>>> @@ -1736,9 +1736,23 @@ static int set_shinfo_evtchn_pending(struct kvm_=
vcpu *vcpu, u32 port)
>>>  	unsigned long flags;
>>>  	int rc =3D -EWOULDBLOCK;
>>>=20=20
>>> -	read_lock_irqsave(&gpc->lock, flags);
>>> +	local_irq_save(flags);
>>> +	if (!read_trylock(&gpc->lock)) {
>>
>>Note, directly disabling interrupts in PREEMPT_RT is just as bad as doing
>>so in non RT and the taking a mutex.
>
> Well, it *isn't* a mutex in non-RT. It's basically a spinlock. And
> even though RT turns it into a mutex this is only a trylock with a
> fall back to a slow path in process context, so it ends up being a
> very short period of irqdisable/lock =E2=80=93 just to validate the target
> address of the cache, and write there. (Or fall back to that slow
> path, if the cache needs revalidating).
>
> So I think this is probably OK, but...
>
>>Worse yet, in PREEMPT_RT read_unlock_irqrestore() isn't going to re-enable
>>interrupts.
>
> ... that's kind of odd. I think there's code elsewhere which assumes
> it will, and pairs it with an explicit local_irq_save() like the
> above, in a different atomic context (updating runstate time info when
> being descheduled).

While it is legit, it simply cannot work for RT. We fixed the few places
which had it open coded (mostly for no good reason).

> So *that* needs changing for RT?

No. It's not required anywhere and we really don't change that just to
accomodate the xen shim.

I'll look at the problem at hand tomorrow.

Thanks,

        tglx

