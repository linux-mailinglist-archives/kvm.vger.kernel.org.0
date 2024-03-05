Return-Path: <kvm+bounces-10873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 001348715E0
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 07:29:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0819285D91
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 06:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1E57BB0F;
	Tue,  5 Mar 2024 06:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEm6tb25"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3DB7BAE1
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 06:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709620182; cv=none; b=hkxl4Pvzs8sGS4dHy7W2oGZ/1etC0fT4d4BoOZM/1gLauHWeUMaduX0J1WWayK+/17aWBp/Wv6BrfI9VwPxUcucbCY4wA9ARkwuWGLYc3sRe4VsAF+N7Sx1G3ZbhIOy5OfdZpkjC0MaQ0KVhmlqaEpyx7o5MYnCtDUw6IIZOwGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709620182; c=relaxed/simple;
	bh=/EW5tRFeZVDjPz7iwyKSFKZU1ofkauumh9ShgZcv4Ok=;
	h=Mime-Version:Content-Type:Date:Cc:Subject:From:To:Message-Id:
	 References:In-Reply-To; b=vDo9NXOoCi9V5BO5LIC2oieZND+gC/g/teXf51l2VBEeZrR1v7uPj0/xdRfRGAcQadg4PiNPHtWv8lH8g38DpYGoYUUu1g+T37NnTwbSzTlzt4nhyE6FPCt2UjZBFxZg5PFaTB494wZmFeO307ftzs3oxpmZ/VMCSLXaO0+Ta0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FEm6tb25; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5dca1efad59so4498604a12.2
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 22:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709620180; x=1710224980; darn=vger.kernel.org;
        h=in-reply-to:references:message-id:to:from:subject:cc:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehs1FMrNqF0Qm4Cmnd1jrKgeBA2AS8z5jsASXRqX00s=;
        b=FEm6tb25p76wxC1wHzEZZ5idpB75tQFO8Tuw5TPjz0USzTyhRJ6tWP5Qu3QgE1h2Bc
         cmaP+SaNux3qtEbsngeW4iIs7wNfidO7p34CHYyEnqizN3OOyoz/EwMQ1vEmvsI6Z8Mk
         /JWh2ZW1KmrEtHWR9yZEqpQOGmdyDC7zXYaHEX6Xu9t/SRYZV3A1gyrtGCIliQUgIFo2
         XWjo0AmsFts4LLEv9YEipVfkwgau0XoVxT2nz6BkeGUCej4RHUtDCpCOr6NqDCewKt3Q
         YNyMy7svCCCecRuh/IrP9mswh1eob9KqFevCZ0U4oBU0NWx+B/t0EMRBVKFSUNw6jnFc
         xLTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709620180; x=1710224980;
        h=in-reply-to:references:message-id:to:from:subject:cc:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ehs1FMrNqF0Qm4Cmnd1jrKgeBA2AS8z5jsASXRqX00s=;
        b=D2EK6psAEn12OGYVhXWbJi6lLrSjsnxSxnVylx+qmfbwIfBj3jDZ4RdPba9DrQ0lxA
         7/tGVa5co6y6uk2+8A+PtihEa6aBVmjf2Lt4/r2+h8Pl+8b21ameVYgzkeUhs3b2K+EC
         ZcSEOKwupdnqCh6OPzPU+yw7cS7zlJze/nVhjG8PzMW8e53DtUr8jraB3Kjf6KUxz+KE
         yFjQC1MtHaVqpU27afZKUIc3LosoXVa+VWBF7ADbN2nXwgibAhqZsVmXq9Mkwn+N4LLt
         mlYTjUP2VP3pUJw6IshqazmTcEtMSitHzZJ7kwcFIII859+9wpp6lyVm2xDtFqmcGV3L
         PuBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVh0SL4WAPdxdYDzulBBXi+jRiaW3kn47cpwIMO1Gx67juPCp4CDVB7X8z1qUQUwREWarQouTWq//ZWKXAaAcYfCc9q
X-Gm-Message-State: AOJu0Yw/AGXM+D4BWo+VLEwr7HFnKw2vTjo90V4d+SgbrX4ILQoIOh2Y
	5Vit5nxXslj3qtD0KlJwkKb03sq+j+kssQBKwHbIPFIkSjqY95VRl8SdURQ+
X-Google-Smtp-Source: AGHT+IHIYYuQtqS0F/i6cQjBW10zNWzbuGB2R1vTgeNkjVwR3RJ9xvDa6ArYyZ7HT2BUnF/IASYQgg==
X-Received: by 2002:a05:6a20:9f89:b0:1a1:44c8:e61a with SMTP id mm9-20020a056a209f8900b001a144c8e61amr1036917pzb.59.1709620180295;
        Mon, 04 Mar 2024 22:29:40 -0800 (PST)
Received: from localhost ([1.146.6.26])
        by smtp.gmail.com with ESMTPSA id lo16-20020a170903435000b001dcc160a4ddsm9651538plb.169.2024.03.04.22.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 22:29:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 16:29:34 +1000
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>, "Joel
 Stanley" <joel@jms.id.au>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 03/32] powerpc: Fix stack backtrace
 termination
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Message-Id: <CZLLLI5JUI8L.1CQ5IF84ZGBYO@wheely>
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-4-npiggin@gmail.com>
 <94491aab-b252-4590-b2a7-7a581297606f@redhat.com>
In-Reply-To: <94491aab-b252-4590-b2a7-7a581297606f@redhat.com>

On Tue Feb 27, 2024 at 6:50 PM AEST, Thomas Huth wrote:
> On 26/02/2024 11.11, Nicholas Piggin wrote:
> > The backtrace handler terminates when it sees a NULL caller address,
> > but the powerpc stack setup does not keep such a NULL caller frame
> > at the start of the stack.
> >=20
> > This happens to work on pseries because the memory at 0 is mapped and
> > it contains 0 at the location of the return address pointer if it
> > were a stack frame. But this is fragile, and does not work with powernv
> > where address 0 contains firmware instructions.
> >=20
> > Use the existing dummy frame on stack as the NULL caller, and create a
> > new frame on stack for the entry code.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   powerpc/cstart64.S | 12 ++++++++++--
> >   1 file changed, 10 insertions(+), 2 deletions(-)
>
> Thanks for tackling this! ... however, not doing powerpc work since years=
=20
> anymore, I have some ignorant questions below...
>
> > diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> > index e18ae9a22..14ab0c6c8 100644
> > --- a/powerpc/cstart64.S
> > +++ b/powerpc/cstart64.S
> > @@ -46,8 +46,16 @@ start:
> >   	add	r1, r1, r31
> >   	add	r2, r2, r31
> >  =20
> > +	/* Zero backpointers in initial stack frame so backtrace() stops */
> > +	li	r0,0
> > +	std	r0,0(r1)
>
> 0(r1) is the back chain pointer ...
>
> > +	std	r0,16(r1)
>
> ... but what is 16(r1) ? I suppose that should be the "LR save word" ? Bu=
t=20
> isn't that at 8(r1) instead?? (not sure whether I'm looking at the right =
ELF=20
> abi spec right now...)
>
> Anyway, a comment in the source would be helpful here.
>
> > +
> > +	/* Create entry frame */
> > +	stdu	r1,-INT_FRAME_SIZE(r1)
>
> Since we already create an initial frame via stackptr from powerpc/flat.l=
ds,=20
> do we really need to create this additional one here? Or does the one fro=
m=20
> flat.lds have to be completely empty, i.e. also no DTB pointer in it?

Oh you already figured the above questions. For this, we do have
one frame allocated already statically yes. But if we don't create
another one here then our callee will store LR into it, but the
unwinder only exits when it sees a NULL return address so it would
keep trying to walk.

We could make it terminate on NULL back chain pointer, but that's
a bit more change that also touches non-powerpc code in the generic
unwinder, and still needs some changes here. Maybe we should do
that after this series though. I'll include a comment to look at
redoing it later.

>
> >   	/* save DTB pointer */
> > -	std	r3, 56(r1)
> > +	SAVE_GPR(3,r1)
>
> Isn't SAVE_GPR rather meant for the interrupt frame, not for the normal C=
=20
> calling convention frames?
>
> Sorry for asking dumb questions ... I still have a hard time understandin=
g=20
> the changes here... :-/

Ah, that was me being lazy and using an interrupt frame for the new
frame.

Thanks,
Nick

>
> >   	/*
> >   	 * Call relocate. relocate is C code, but careful to not use
> > @@ -101,7 +109,7 @@ start:
> >   	stw	r4, 0(r3)
> >  =20
> >   	/* complete setup */
> > -1:	ld	r3, 56(r1)
> > +1:	REST_GPR(3, r1)
> >   	bl	setup
> >  =20
> >   	/* run the test */
>
>   Thomas


