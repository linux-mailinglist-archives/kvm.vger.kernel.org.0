Return-Path: <kvm+bounces-10101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8372B869D39
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:10:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C7791C20F8F
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 17:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942984EB3B;
	Tue, 27 Feb 2024 17:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ROmZ9oje"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8534E1C8
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709053743; cv=none; b=YV5AKE4b/OqKDiG5GSVbiKnJq1oQjBIyv9soCaWztBVJcFu6ZB/9+PQ/BiTpmqdWQ9DjXcI90PXrlGTAbnjaxpnwY+W46E0WRrFPi+jLd14vgvdUJ+fLX98138Rt6JjvQCtVgjVHrzCxoti8MrBEbuMW0npkcU+bq8VCbhHRkbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709053743; c=relaxed/simple;
	bh=5gvfqP3F7ceosk+hCq9y0C2+JFcxqYZUz+ERejnWbzA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=d4zgI1r19YhQnr+EKb5G25v9LdBufZmD7tDemWiNDlm+0+W5ommAtbAJ6c3xnOqvOKtTHP1pmasT5ajXljRRaI2A0/tBi4X4Agu9bYD8KZqhjzoVtgFiB7Lyew8IaFKQ4o1DaOGcYiPkJo2zxu027mcxKLZ3fBM0rntW2+SDcBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ROmZ9oje; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=B3lmvzyvwteiy9I8UwjpOgIVKjTLtjPNkbjt4+sv0AY=; b=ROmZ9ojefnQOz1Iu9+vnGyIQrd
	gaSKGtQFyZL6tRgzSxPauhxsko9ZVU1qTPqxnzy6BiO7MoHPRKPbJUmY76n5XlK7RRfuLuFlqcnqI
	cHFrQEGBF/vc9ywC88kh6wkTRmTyeALDbo+zkjfG62xQPtRDjOCrMP3ofcVy1WeacchJSbTURt/NU
	09Bduzvmj1OVR6zfIAGR87d9wY7r0y1PQHg+9CYTeu0zhw6T7CTkXdY+MxSbvWypmkTRp+rGXVw26
	ElTUF8LFOoy6kaXLtlRXJqUOSlWOri4hAVjD6xPrbicj8NMlCV/2caOZF/qmBT2d9lRCP9549ZFOL
	aA6we0jw==;
Received: from [2a00:23ee:2310:b61:2cd1:6cc6:6a39:1f9c] (helo=[IPv6:::1])
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf0wd-00000001qhj-3zdW;
	Tue, 27 Feb 2024 17:08:47 +0000
Date: Tue, 27 Feb 2024 17:00:42 +0000
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
In-Reply-To: <20240227094326.04fd2b09@gandalf.local.home>
References: <20240227115648.3104-1-dwmw2@infradead.org> <20240227115648.3104-8-dwmw2@infradead.org> <20240227094326.04fd2b09@gandalf.local.home>
Message-ID: <8C04AFD0-FC16-4572-AD23-FC7EEF663F11@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 27 February 2024 14:43:26 GMT, Steven Rostedt <rostedt@goodmis=2Eorg> wr=
ote:
>On Tue, 27 Feb 2024 11:49:21 +0000
>David Woodhouse <dwmw2@infradead=2Eorg> wrote:
>
>> diff --git a/arch/x86/kvm/xen=2Ec b/arch/x86/kvm/xen=2Ec
>> index c16b6d394d55=2E=2Ed8b5326ecebc 100644
>> --- a/arch/x86/kvm/xen=2Ec
>> +++ b/arch/x86/kvm/xen=2Ec
>> @@ -1736,9 +1736,23 @@ static int set_shinfo_evtchn_pending(struct kvm_=
vcpu *vcpu, u32 port)
>>  	unsigned long flags;
>>  	int rc =3D -EWOULDBLOCK;
>> =20
>> -	read_lock_irqsave(&gpc->lock, flags);
>> +	local_irq_save(flags);
>> +	if (!read_trylock(&gpc->lock)) {
>
>Note, directly disabling interrupts in PREEMPT_RT is just as bad as doing
>so in non RT and the taking a mutex=2E

Well, it *isn't* a mutex in non-RT=2E It's basically a spinlock=2E And eve=
n though RT turns it into a mutex this is only a trylock with a fall back t=
o a slow path in process context, so it ends up being a very short period o=
f irqdisable/lock =E2=80=93 just to validate the target address of the cach=
e, and write there=2E (Or fall back to that slow path, if the cache needs r=
evalidating)=2E

So I think this is probably OK, but=2E=2E=2E


>Worse yet, in PREEMPT_RT read_unlock_irqrestore() isn't going to re-enabl=
e
>interrupts=2E

=2E=2E=2E that's kind of odd=2E I think there's code elsewhere which assum=
es it will, and pairs it with an explicit local_irq_save() like the above, =
in a different atomic context (updating runstate time info when being desch=
eduled)=2E So *that* needs changing for RT?


