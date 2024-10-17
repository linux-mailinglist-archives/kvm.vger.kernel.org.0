Return-Path: <kvm+bounces-29099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F999A2ACE
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 19:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B867AB2CB92
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 17:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52FB01FBC92;
	Thu, 17 Oct 2024 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dDS4lzqE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF631EF94D
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729184288; cv=none; b=f2uALv4U6I0g/qdHU9cv5d5UP+sMkadC5CL3YHOcDxEEonfW1JqdWHWoWA4H5Glyt9h4MkrLzbTRlAxcOVEC5qIPMZCiZotuh5j1UtjGnIpi38LctkcBoYCRYgtNCseN0Vu4uj8roauE2tKhKaP6LbrnEUQN09eA2FK1i6CMmNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729184288; c=relaxed/simple;
	bh=PrFPdr0NKJQKUfFjYkGfH7X4s8YeIB65gqZrdgLFzgg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W0fYUfNrucp7/S0fAcMNru1btLVWJCmOBronfYEL2/VuqM51f5vt9lLIdRQHSW1qmASefWDfFtMV7guayIHwPxVnfcRXTrWvJCWkk4/A1ORs6CFfIkBTx3kJXcJuNbtxn1CagdKswryzK3jPXGw0ZC3y0ATSvv/nBT14m8jJ2LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dDS4lzqE; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e315a5b199so20197497b3.2
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 09:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729184286; x=1729789086; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JPTate8nHmfNvm5RLlOrViAXjwxlfzdSZEYjXEbaR7Q=;
        b=dDS4lzqE+qvGsIXjESIHfbSiHuUkgmRuua1qeCfqtdFdLhGDXK6aDNl7HXYVCKo71/
         Y2loqRt/wXqvaCY+Ob7nw15H42rqOrPWGhc0c7d0ZsyEs+iIo6XfEsTE7EzhcYFYF3Ay
         HPkpv9Wa1q6rFoa9vO6oGaicPXO1xeAorbrVtbeuIRf47JxpLmuDBvvett906w+r4WcL
         MZdwWfpe/mdlGsbA62xEAD2QsHIxtpGYgH04XltImtK+f6YzI5dQyw84QXWGF7PAv60f
         qkvEerPsuqSYodb9nmdhUIXH/KXBeT37ztQsfIJhxQTSILU0NgHMA+Vyp7cCx9neBPW4
         Ne1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729184286; x=1729789086;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JPTate8nHmfNvm5RLlOrViAXjwxlfzdSZEYjXEbaR7Q=;
        b=BrqSQfj0ie8z9lrL0xJUaxp/E0/wURulIOVsFtDPL4k4qdm7z/3JOZAWYClbPdFln5
         rbYl5ScurZt6vdUL/5aLiKaenPC0s7iUYFRkh4IgzM/ToLklpw6QJpBRX02+ASJLQOxn
         mDVEbOl2nGGg3ORLskKBqJr4hdH/eZX9GInPZlBG9xspIxBNSXCnlaYYbetJm1+05Dg7
         6cm+SRiYlHenazItcbHSaAVbReaXTw3bkvv++Xt8lnQOdK6IMWG6qCKJn+y4mWqzE47/
         IFb8GU+p/3kKe8OMYRZP84KykS7fzmoBLK36BisDwzVMYMaF6fDWEsg/O+qJf1IJeOR+
         22HQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKWYtx6scqqfs18NSgzCU5opEpvBqBayMP8nwAZrPKqpPyRvQH/mB447qdjoA8mnFy+Vs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx85vWpuIpgrNDZgi+w669OWsH8IG19p3EBco7C/xOSH4hgp21
	ksgBnVT63NrjiL0e2nHG/H36O98PxJt/qvXXrMRRIsKuyHT8ErgPn/ooA6XpbOyTqaMhYc8HAbF
	fOQ==
X-Google-Smtp-Source: AGHT+IF7B084V115Sr72nxCNj1jAu1r6gImTDt3pvbXTzRx/HxKwq71Gvz4aJ0aVLn+pxpF6UyiW5mTVJRo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:9bc9:0:b0:e2b:a511:2e51 with SMTP id
 3f1490d57ef6-e2ba5112f27mr2946276.11.1729184285606; Thu, 17 Oct 2024 09:58:05
 -0700 (PDT)
Date: Thu, 17 Oct 2024 09:58:03 -0700
In-Reply-To: <bd116c27908111619b6cfffbe9a25e98e0e7cc20.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240927161657.68110-1-iorlov@amazon.com> <20240927161657.68110-4-iorlov@amazon.com>
 <ZwnBGtdbvmKHc4in@google.com> <bd116c27908111619b6cfffbe9a25e98e0e7cc20.camel@infradead.org>
Message-ID: <ZxFCG7pxWXs1D0p5@google.com>
Subject: Re: [PATCH 3/3] selftests: KVM: Add test case for MMIO during event delivery
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ivan Orlov <iorlov@amazon.com>, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, jalliste@amazon.com, 
	nh-open-source@amazon.com, pdurrant@amazon.co.uk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024, David Woodhouse wrote:
> On Fri, 2024-10-11 at 17:21 -0700, Sean Christopherson wrote:
> >=20
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* We should never reach t=
his point */
> >=20
> > No pronouns.=C2=A0 Yes, it's nitpicky, but "we" gets _very_ ambiguous w=
hen "we" could
> > mean the admin, the user, the VMM, KVM, the guest, etc.
> >=20
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0GUEST_ASSERT(0);
>=20
>=20
> Is there really *any* way that can be interpreted as anything other
> than "the CPU executing this code will never get to this point and
> that's why there's an ASSERT(0) right after this comment"?
>=20
> I don't believe there's *any* way that particular pronoun can be
> ambiguous, and now we've got to the point of fetishising the bizarre
> "no pronouns" rule just for the sake of it.

No, it's not just for the sake of it.  In this case, "we" isn't all that am=
biguous,
(though my interpretation of it is "the test", not "the CPU"), but only bec=
ause the
comment is utterly useless.  The GUEST_ASSERT(0) communicates very clearly =
that it's
supposed to be unreachable.

And if the comment were rewritten to explain _why_ the code is unreachable,=
 then
"we" is all bug guaranateed to become ambiguous, because explaining "why" l=
ikely
means preciesly describing the behavior the userspace side, the guest side,=
 and/or
KVM.  In other words, using "we" or "us" is often a hint that either the st=
atement
is likely ambiguous or doesn't add value.

And irrespective of whether or not you agree with the above, having a hard =
rule of
"no we, no us" eliminates all subjectivity, and for me that is sufficient r=
eason
to enforce the rule.

> I get it, especially for some individuals it *can* be difficult to take
> context into account, and the wilful use of pronouns instead of
> spelling things out explicitly *every* *single* *time* can sometimes
> help. But at a cost of conciseness and brevity.

In this particular case, I am more than willing to sacrifice brevity.  I 10=
0%
agree that there is value in having to-the-point comments and changelogs, b=
ut I
can't recall a single time where avoiding a "we" or "us" made a statement
meaningfully harder to read and understand.  On ther hand, I can recall man=
y, many
changelogs I had to re-read multiple times because I struggled to figure ou=
t how
the author _intended_ "we" or "us" to be interpreted.

