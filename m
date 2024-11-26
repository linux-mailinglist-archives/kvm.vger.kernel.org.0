Return-Path: <kvm+bounces-32528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5530D9D9A23
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 16:03:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEBDF1624C4
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 15:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318221D61BB;
	Tue, 26 Nov 2024 15:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0qRSqXui";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="me/O3mCh"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0105F194080;
	Tue, 26 Nov 2024 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732633416; cv=none; b=f5N/v6F+sBHj6YxopZmAv/fRj4/s8PYbio9V5ZxUpUM4zbKHJu6g7wnoDFnsK9gCtmHas9kzay4Ekw9Aow3CtS2PmjsRpuKRwlkHwygqxyogWJSOYDPhtn4o8s8Ij99tQWh3gpQVpGJ9k+BClwgczSnQFzVrBVjjyRB2NYUF9Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732633416; c=relaxed/simple;
	bh=q1h7SByQ7GQP7MMiC+0DryV20kNggyhmkuzAAcwSlJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHZH+OkyDqmAIE0eEaI++8p0qOmnqt0pGDxPLlGVPCdXOXmPUfGU2TF/g0nYi/ZENR2mP0UQeH3XsDnNXQp/7vr54jUiP8vgobgoMs0LjjtpiG5/rUKo8xCzrq0HA8y67XGAqQcURHAR0YaSyVNCJVAPDVqkciGUQtW98Ldjw6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0qRSqXui; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=me/O3mCh; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Tue, 26 Nov 2024 16:03:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1732633413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yuzWLJOLOSj45DFP2QwtkJKfcCrxhdccXghvTUPt3Xc=;
	b=0qRSqXuibRgljbtykCbb/Cr51LVs6RXQj/bR9vTbxFjnRlon62MntHAIo/7EdjeC4yJddl
	P0C/Y3mCLfzzdOx3fL8cDg4CsJpBiOH55JS9hu6cWjr35lgUIxMfPhrLmm+ekzkyivAwin
	xrt4NEslxHJDPc4HTlsYXHwG00dTJudx/0z1dl3xOWpJg/61LrnkB59vpJ6s0flTBToYsS
	70WxYwkNBjoRE54saX26ENSkWnW8XvCTGgdrUyQBccqy94e9YQllWsD+mh1teNIRNQ+OH0
	R36k7kcBOypEM1ppxPVtInk8yx92UJE113idL4heJJkdgh2Q5LchLc/gNhLvbw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1732633413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yuzWLJOLOSj45DFP2QwtkJKfcCrxhdccXghvTUPt3Xc=;
	b=me/O3mChBNdt7tFoFZ7jxGuyt53A0s89YdyFK3oBVVZBHEpx5yBVzgn+1Wy3HyDo9uLLpy
	+u32TM1EylsL8HBw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: syzbot <syzbot+919877893c9d28162dc2@syzkaller.appspotmail.com>,
	boqun.feng@gmail.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hdanton@sina.com, hpa@zytor.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, longman@redhat.com, mingo@redhat.com,
	paul@xen.org, pbonzini@redhat.com, seanjc@google.com,
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: [syzbot] [kvm?] WARNING: locking bug in kvm_xen_set_evtchn_fast
Message-ID: <20241126150331.E3qHY1JP@linutronix.de>
References: <6745da06.050a0220.1286eb.0018.GAE@google.com>
 <391f1c231cfce2c4107494b47114ed049c4d6266.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <391f1c231cfce2c4107494b47114ed049c4d6266.camel@infradead.org>

On 2024-11-26 14:49:40 [+0000], David Woodhouse wrote:
> On Tue, 2024-11-26 at 06:24 -0800, syzbot wrote:
> > syzbot has bisected this issue to:
> >=20
> > commit 560af5dc839eef08a273908f390cfefefb82aa04
> > Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Date:=C2=A0=C2=A0 Wed Oct 9 15:45:03 2024 +0000
> >=20
> > =C2=A0=C2=A0=C2=A0 lockdep: Enable PROVE_RAW_LOCK_NESTING with PROVE_LO=
CKING.
>=20
> That's not it; this has always been broken with PREEMPT_RT I think.
> There was an attempt to fix it in
> https://lore.kernel.org/all/20240227115648.3104-8-dwmw2@infradead.org/
>=20
> I'll dust that off and try again.

Oh thank you. The timer has been made to always expire in hardirq due to
HRTIMER_MODE_ABS_HARD, this is why you see the splat. If the hardirq
invocation is needed/ possible then the callback needs to be updated.

The linked patch has this hunk:
|-	read_lock_irqsave(&gpc->lock, flags);
|+	local_irq_save(flags);
|+	if (!read_trylock(&gpc->lock)) {
=E2=80=A6
|+		if (in_interrupt())
|+			goto out;
|+
|+		read_lock(&gpc->lock);

This does not work. If interrupts are disabled (due to local_irq_save())
then read_lock() must not be used. in_interrupt() does not matter.

Side note: Using HRTIMER_MODE_ABS would avoid the splat at the cost that
on PREEMPT_RT the timer will be invoked in softirq context (as with
HRTIMER_MODE_ABS_SOFT on !PREEMPT_RT). There is no changed behaviour on
!PREEMPT_RT.

Sebastian

