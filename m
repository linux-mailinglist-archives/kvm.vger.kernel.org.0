Return-Path: <kvm+bounces-22289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C178393CE6A
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76B0C1F21E53
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 07:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED25D176259;
	Fri, 26 Jul 2024 07:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8fWX/fU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5201741F4;
	Fri, 26 Jul 2024 07:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721977335; cv=none; b=ZQndNqWg2JZca/DmbhUVjwyLRdIp/A9hVUVLRwq2fKrykJrVhh/6JMjPXItq4ksOhwzXL5t72yok1V4goV+aubtGPRJ3XxCXT9+5N2/DJwWf8ugTzoz7QxQJk44mykAndgc1+v0Gly5B/wQDv9iOmwI88s89tkYJrxKZrgdREyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721977335; c=relaxed/simple;
	bh=GZQrcW0Y7vey9tkNsG4QwCN75Ki6SMeJW7jE4UMjgM8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T/4WLtcQadMnkTwfy4LRiICzpChHFohnsk/Z6TIDc8olu/QvY8w4tAozMKgsSQMbAc5JT84RRrNmRiuDsjNpQPM2CXLad4ZbhG2jQevdgr1rHPGDETyixtznlqRZPUfplgHhWPsztLu4CiPNRXeBmFpoa5PQBhD58R86h1krgTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k8fWX/fU; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7aa4ca9d72so165285666b.0;
        Fri, 26 Jul 2024 00:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721977332; x=1722582132; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TiN10QU3ln4IVzwcdee1zyYPsgPcAP0rqrhYJUQ92Xs=;
        b=k8fWX/fUUk3IegFgAc80F9bEEdxLcPeczFTo+1+MpXD5SfFI4oqaEPWmBQOktT0VAN
         QFklJfMg1Rks8EDOhwTZoQBGKw31xgcFbMoJvdZMVPWV6ikE3jpCQxR6Dow5CvZGvjHq
         r79/jQXgyiuezisJ/+Qw5cCJkH1f3bzmHdA/y8x4XokBjhjjlCh/DkkDO+2A041blDMG
         V8ENc4MLv9TKwm6SNm6dISvzmXIaR8yqufK6ZPTaj9Iu59xARDTWKUhHtUflcoRpty0q
         +Rwo8iJU2/bptU2Gq9rtcho3S/vimfCB7pxBvN8BmKHEAPPmi3+7+OAKep7pe+YyKmZQ
         qUeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721977332; x=1722582132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TiN10QU3ln4IVzwcdee1zyYPsgPcAP0rqrhYJUQ92Xs=;
        b=ADsRstsTXXOT43pGOgkBsHqiVzaKAHfC3xarRaoYlRodCwKKblhuQXOfWSvOXDUIFx
         hrGT3zkqtvWRxm4rbmtNTMB/hDxEQnqiGM2W07SJ9JpN4OAHBFxylSrqhk/y9rWjFKgy
         uu8pdGHKkKwIbZjtQoXRTHeGYPic6HkU9gmn85rKO9Y3xYNx9Qnc/r51lcDlrBSw9oMG
         NXT8wnno186IqHzL9VP3WLHuJLDklTdimNlYPvHrkhMsUO5IF32fygk8TYKpdKLiJLr5
         oUpM6wHU0AXZRQFjSQhN0AmeyXI8nLANq72TmuNojY08aBArq2K8Yt6UGRZkvKh9SSzy
         rjGg==
X-Forwarded-Encrypted: i=1; AJvYcCUgrYYtdMRxelKMDhWvRbzZUdS6qPITshbw3bAkHVgDhABwFRIADmDFmvN7AY9pyEEOsx0ZVEBx211F0qSIztv+9439FgzTQW04+e6Q1nnT6XZuflbZwcUq6wyzMMYX5lw8
X-Gm-Message-State: AOJu0YxPrRQcUtQd485KwMVxYIoAV3TnD5z9730GTG0bbws5788qFWPE
	0SqMDYVpErjsileBhthddyS9Tb3yiIl3+LUFYInpJ0zAj1JVHEjXbdVnxLCqazw5nKM0RVAAnpb
	of4W0CoCX7fKFOEIsZ0lwc6eh+koClnY2JUvgqw==
X-Google-Smtp-Source: AGHT+IEH4nrJ6XjApLySHmEBDowqEzG/9wU3GxFLLvxtx37bVbVAH/Z1q9+58LoRnZaqSoCILC8QUPfzVY0WvHn3X24=
X-Received: by 2002:a17:907:9403:b0:a7a:952b:95b1 with SMTP id
 a640c23a62f3a-a7acb411eb7mr326822566b.24.1721977331615; Fri, 26 Jul 2024
 00:02:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACZJ9cV2gv+A_2wCXowzi9M-HrySeBxNLKfK+bXRLffwR94=fA@mail.gmail.com>
 <CABgObfYzEzZuDSKjB1SYcveTaRMaayvY8cvtPD8qGLvkDiwV5A@mail.gmail.com>
In-Reply-To: <CABgObfYzEzZuDSKjB1SYcveTaRMaayvY8cvtPD8qGLvkDiwV5A@mail.gmail.com>
From: Liam Ni <zhiguangni01@gmail.com>
Date: Fri, 26 Jul 2024 15:01:59 +0800
Message-ID: <CACZJ9cWTpWNCHucOec=inUdNXLKZyZvxO4h4vzioogcZJGtA4g@mail.gmail.com>
Subject: Re: [PATCH] KVM:x86:Fix an interrupt injection logic error during PIC
 interrupt simulation
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jul 2024 at 22:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On Thu, Jul 25, 2024 at 4:00=E2=80=AFPM Liam Ni <zhiguangni01@gmail.com> =
wrote:
> >
> > The input parameter level to the pic_irq_request function indicates
> > whether there are interrupts to be injected,
> > a level value of 1 indicates that there are interrupts to be injected,
> > and a level value of 0 indicates that there are no interrupts to be inj=
ected.
> > And the value of level will be assigned to s->output,
> > so we should set s->wakeup_needed to true when s->output is true.
> >
> > Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> > ---
> >  arch/x86/kvm/i8259.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> > index 8dec646e764b..ec9d6ee7d33d 100644
> > --- a/arch/x86/kvm/i8259.c
> > +++ b/arch/x86/kvm/i8259.c
> > @@ -567,7 +567,7 @@ static void pic_irq_request(struct kvm *kvm, int le=
vel)
> >  {
> >     struct kvm_pic *s =3D kvm->arch.vpic;
> >
> > -   if (!s->output)
> > +   if (s->output)
>
> This is the old value of s->output. wakeup is needed if you have a
> 0->1 transition, so what you're looking for is either

I would like to know the reason why we monitor the 0->1 transformations?

>
> if (level)
>   s->wakeup_needed =3D true;
This solution seems more appropriate with level=3Dtrue,
indicating that there is a pending interrupt in the PIC

Thanks
Liam Ni

>
> or
>
> if (!s->output && level)
>   s->wakeup_needed =3D true;
>
> but your version is incorrect because it would look for a 1->1
> transition instead.
>
> Thanks,
>
> Paolo
>

