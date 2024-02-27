Return-Path: <kvm+bounces-10107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB3DB869DB6
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 860E0283F02
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 17:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70451153512;
	Tue, 27 Feb 2024 17:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WKcLxwnM"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A3E149E0B
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 17:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709054945; cv=none; b=fWIILj0qVL+4v+mEzUS2dkun4uabt4TGKfUKdc+0u/8guIDRG5JjLyUjXanekEX8D781fxicACwGeLjWhbipQRrXQ18VnzTh7l3p8cinnFdwEwAysxgp/SZXx38D8/Eff0YM8SdpNQB8RBzh22UMRxlxPsijpqRSAjGJsclL8AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709054945; c=relaxed/simple;
	bh=yegWauqk91FXBaonguUi7Sa9y18Kgg3KLX/GfryF6m0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=fW0l5ziJsqP2sqKggcu7T6AOrxn8R6Br6pet0LcrcWGV+oRmv1enbGK6Qbm8xfWQ7uY2chGeZyUCX2ri1scD1vYjN/tf59HZPXezHLUBYhj4YohoKUHfYY5ehKD06Ku2R9Qwitqhzu9It8N/3NfD5H315IHnOcBzKoXE65hY1bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WKcLxwnM; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=pr9cfDtHjHqsn680nJ+8T5Hqww8VrcwRZXHEgBjm+4k=; b=WKcLxwnM2/Rnieor69RnEs+XmN
	27YKd7WnYNPxfRibmwfK/wDXzkciho4V80eZuqoXmIgFHfIFSfnB5QH//Q3xd6uNEYHTunFhhA498
	KEUpiT04ysGzdjx8tBXAoxOGqiHYVQVKz0ScJ55uIn7V6bQ1EmLWyolejcl50xaOU8y6t0o0qsT7g
	PjtlcGra0+xo6aOzK1Me0Q/RKQr6/WgEt0nNjb55+7oi8nQuS4YWcbCCX2pjeAE5TQaArxPg7i3LG
	8h69cl6C9I3ZC+ixopXic+AzT4abKsVmbfXAqeN16l0fc3ikOWedlAVFO1pH0zemLewSBCTTzFABx
	POkSI1mw==;
Received: from [2a00:23ee:2310:b61:2cd1:6cc6:6a39:1f9c] (helo=[IPv6:::1])
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf1GD-00000002wqu-10wJ;
	Tue, 27 Feb 2024 17:28:57 +0000
Date: Tue, 27 Feb 2024 17:28:54 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
CC: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Michal Luczaj <mhal@rbox.co>, Paul Durrant <pdurrant@amazon.com>,
 David Woodhouse <dwmw@amazon.co.uk>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_7/8=5D_KVM=3A_x86/xen=3A_avoid_blocking?= =?US-ASCII?Q?_in_hardirq_context_in_kvm=5Fxen=5Fset=5Fevtchn=5Ffast=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20240227122552.20126460@gandalf.local.home>
References: <20240227115648.3104-1-dwmw2@infradead.org> <20240227115648.3104-8-dwmw2@infradead.org> <20240227094326.04fd2b09@gandalf.local.home> <8C04AFD0-FC16-4572-AD23-FC7EEF663F11@infradead.org> <20240227122552.20126460@gandalf.local.home>
Message-ID: <24CA3629-B38A-4412-B9E4-36450059977D@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

On 27 February 2024 17:25:52 GMT, Steven Rostedt <rostedt@goodmis=2Eorg> wr=
ote:
>On Tue, 27 Feb 2024 17:00:42 +0000
>David Woodhouse <dwmw2@infradead=2Eorg> wrote:
>
>> On 27 February 2024 14:43:26 GMT, Steven Rostedt <rostedt@goodmis=2Eorg=
> wrote:
>> >On Tue, 27 Feb 2024 11:49:21 +0000
>> >David Woodhouse <dwmw2@infradead=2Eorg> wrote:
>> > =20
>> >> diff --git a/arch/x86/kvm/xen=2Ec b/arch/x86/kvm/xen=2Ec
>> >> index c16b6d394d55=2E=2Ed8b5326ecebc 100644
>> >> --- a/arch/x86/kvm/xen=2Ec
>> >> +++ b/arch/x86/kvm/xen=2Ec
>> >> @@ -1736,9 +1736,23 @@ static int set_shinfo_evtchn_pending(struct k=
vm_vcpu *vcpu, u32 port)
>> >>  	unsigned long flags;
>> >>  	int rc =3D -EWOULDBLOCK;
>> >> =20
>> >> -	read_lock_irqsave(&gpc->lock, flags);
>> >> +	local_irq_save(flags);
>> >> +	if (!read_trylock(&gpc->lock)) { =20
>> >
>> >Note, directly disabling interrupts in PREEMPT_RT is just as bad as do=
ing
>> >so in non RT and the taking a mutex=2E =20
>>=20
>> Well, it *isn't* a mutex in non-RT=2E It's basically a spinlock=2E And =
even
>> though RT turns it into a mutex this is only a trylock with a fall back
>> to a slow path in process context, so it ends up being a very short
>> period of irqdisable/lock =E2=80=93 just to validate the target address=
 of the
>> cache, and write there=2E (Or fall back to that slow path, if the cache
>> needs revalidating)=2E
>
>Yes, but if the trylock fails, you then call:
>
>+	if (!read_trylock(&gpc->lock)) {
>+		/*
>+		 * When PREEMPT_RT turns locks into mutexes, rwlocks are
>+		 * turned into mutexes and most interrupts are threaded=2E
>+		 * But timer events may be delivered in hardirq mode due
>+		 * to using HRTIMER_MODE_ABS_HARD=2E So bail to the slow
>+		 * path if the trylock fails in interrupt context=2E
>+		 */
>+		if (in_interrupt())
>+			goto out;
>+
>+		read_lock(&gpc->lock);
>
>That takes the read_lock() with interrupts still disabled=2E On RT, that =
will
>likely schedule as it had just failed a trylock=2E

Oh=2E=2E=2E pants=2E Right, so it really does need to use read_trylock_irq=
save() in the non-IRQ case, *and* it needs to either read_unlock_irqrestore=
() or separately unlock and local_irq_restore(), according to which way it =
did the locking in the first place=2E Ick=2E



