Return-Path: <kvm+bounces-8202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A073D84C39B
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 05:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F123B2971B
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 04:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F01F1429F;
	Wed,  7 Feb 2024 04:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lJXwqnRt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2419112E7E
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 04:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707280108; cv=none; b=WX4b8/1c8YhohbUc0QVMxf1b2GjWvybq8HXqBUgcIBrUdajdqEinJi7WvyQ8fvDVd0wFTim+vtGTvWln/j47IDY8T3/1brLb8hygxwh6dDomQiPYBxXj8sw9dP9CIfMe1ifEKt6Zg5gAsFz8hPXghJW2we0NAaFOuNRoBmkUKFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707280108; c=relaxed/simple;
	bh=8ehiZ8S594GAV53sSwBEcddx0O0RVISkZMdA4sB4qk4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N46C4bi5NMBNQ3KkWumuzLe8d8XXtuBILuCeBS92hcOXdhynm+ZSvv6bPvkwC94feyq8MG4F2Id6oTitoKTx/1DCeo/qfYE7CCtrGtuEUztbt6Gw+c8d+CBuCgsYbig5KTRoQIVXvYz5UDJMBr++8SwCGT9r+BlNZ7grAWRtf+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lJXwqnRt; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6ffb9fd8cso351536276.2
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 20:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707280106; x=1707884906; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0u5NrceOYzCOKx+73MFK71e5+5At+9gEeFz068cC2z4=;
        b=lJXwqnRt/Rd5HzRKLKv87BbwzNTlLTsWB60Eoc+PpbivhvYpL/AsoLiW4UVTxl1GZJ
         uHRBSf6hJr6kds0ZHRxAnoGsb+T3oGgJ9oVaG3tqh00zJPceRpsL92mwp8WcIQ42T7hA
         giHuKsGwpHM5fXJAlZ2jAZHCecvmAdEc4W9ap/6Kjgq7IINLdKm/MiP4hMf3rCIg4vgF
         72hTCBnjmOi4muZr5AfnFjKoBve66IY1+xoxP2fw2b5VI9jQwRWE4iPGlesg8ijjj2Mq
         UCCm4+zLhxwji1mGb6W97QarCPSThE0GjN+WrvRu5xubg9ZvD5ZRmT8AIQPw3BSgAiPs
         F9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707280106; x=1707884906;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0u5NrceOYzCOKx+73MFK71e5+5At+9gEeFz068cC2z4=;
        b=E8iol72c3N/21eckihyCxWU5+5NfKVQ8Dzyl5ZSznu4demAQPgLERN1KsHt2ol4g0y
         u0NPj+0j9IpVtxIRA9ewegRCSnfPe8tJ/kLZlUBVtC4CTeDHclrnSHpnWkAcYAzSs/yV
         KJRrP+PA8BwK8LZugQ31QMftb+2hPQ39F2Q1tVoyN8NFLqrE8gf+DrUxsR6jxPosf4Q9
         uSqgjiDas4fh59gz7NKjPpzhkzlgF6qZ/i9rBiT0FprAeih95Pk/z0w9+WSwZqASbwYa
         ODQ1Actt11e6FAwso2w6iBLF0lFV33kLLAuFKlkdUhNa1stxQsc7+iXnSZoz5ZaayTAQ
         yUiw==
X-Gm-Message-State: AOJu0YzBU2UwIz/K0zLrL04Tzu65xxEfHZtXxzQUkWVPHbff7a5glkqe
	wN839KjzzvSbN8R6w8IIKblGHe5CKhyHZylN7iEBBDBw9UAfY9hYn1IdROZ2SxielGNAFFFBHZP
	bsw==
X-Google-Smtp-Source: AGHT+IHA3sVJ1EpvSbGHgcDcap7YmiZDqRXMnrrbmJJd50cFvSwRp8Ii+3lZAl+y6BwbFq62lxIeDVUYL2c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:11ce:b0:dc7:4b9:fbc6 with SMTP id
 n14-20020a05690211ce00b00dc704b9fbc6mr968233ybu.10.1707280106249; Tue, 06 Feb
 2024 20:28:26 -0800 (PST)
Date: Tue, 6 Feb 2024 20:28:24 -0800
In-Reply-To: <165f07deb8d1e082756e6cae21a25b0060c18f85.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f21ee3bd852761e7808240d4ecaec3013c649dc7.camel@infradead.org>
 <ZcJ9bXxU_Pthq_eh@google.com> <19a1ac538e6cb1b479122df677909fb49fedbb28.camel@infradead.org>
 <ZcLxzrbvSs0jNeR4@google.com> <165f07deb8d1e082756e6cae21a25b0060c18f85.camel@infradead.org>
Message-ID: <ZcMG6NA63MqOR1V9@google.com>
Subject: Re: [PATCH v3] KVM: x86: Use fast path for Xen timer delivery
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>, g@google.com
Cc: kvm <kvm@vger.kernel.org>, Paul Durrant <paul@xen.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 06, 2024, David Woodhouse wrote:
> On Tue, 2024-02-06 at 18:58 -0800, Sean Christopherson wrote:
> > On Tue, Feb 06, 2024, David Woodhouse wrote:
> > > On Tue, 2024-02-06 at 10:41 -0800, Sean Christopherson wrote:
> > > >=20
> > > > This has an obvious-in-hindsight recursive deadlock bug.=C2=A0 If K=
VM actually needs
> > > > to inject a timer IRQ, and the fast path fails, i.e. the gpc is inv=
alid,
> > > > kvm_xen_set_evtchn() will attempt to acquire xen.xen_lock, which is=
 already held
> > >=20
> > > Hm, right. In fact, kvm_xen_set_evtchn() shouldn't actually *need* th=
e
> > > xen_lock in an ideal world; it's only taking it in order to work arou=
nd
> > > the fact that the gfn_to_pfn_cache doesn't have its *own* self-
> > > sufficient locking. I have patches for that...
> > >=20
> > > I think the *simplest* of the "patches for that" approaches is just t=
o
> > > use the gpc->refresh_lock to cover all activate, refresh and deactiva=
te
> > > calls. I was waiting for Paul's series to land before sending that on=
e,
> > > but I'll work on it today, and double-check my belief that we can the=
n
> > > just drop xen_lock from kvm_xen_set_evtchn().
> >=20
> > While I definitely want to get rid of arch.xen.xen_lock, I don't want t=
o address
> > the deadlock by relying on adding more locking to the gpc code.=C2=A0 I=
 want a teeny
> > tiny patch that is easy to review and backport.=C2=A0 Y'all are *proabl=
y* the only
> > folks that care about Xen emulation, but even so, that's not a valid re=
ason for
> > taking a roundabout way to fixing a deadlock.
>=20
> I strongly disagree. I get that you're reticent about fixing the gpc
> locking, but what I'm proposing is absolutely *not* a 'roundabout way
> to fixing a deadlock'. The kvm_xen_set_evtchn() function shouldn't
> *need* that lock; it's only taking it because of the underlying problem
> with the gpc itself, which needs its caller to do its locking for it.
>=20
> The solution is not to do further gymnastics with the xen_lock.

I agree that's the long term solution, but I am not entirely confident that=
 a big
overhaul is 6.9 material at this point.  Squeezing an overhaul into 6.8 (an=
d if
we're being nitpicky, backporting to 6.7) is out of the question.

