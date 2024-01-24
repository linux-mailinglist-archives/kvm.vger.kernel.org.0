Return-Path: <kvm+bounces-6748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD194839E9D
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:16:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C58C1F26EBB
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 130F51874;
	Wed, 24 Jan 2024 02:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nZ4s/fnj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09781FAA;
	Wed, 24 Jan 2024 02:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706062590; cv=none; b=g6Yo/KTQ9gfCmFl89IznwHsuQnrQDFknz+KW/wGOHhR+Ri589ipbOC65mrYV3yaJGJFcNqzCeu9fQokHFRcEYFf5Y1dLQMif+X1RxxBk3gqQr+ITjZt76hyadOFSJskPp7hOEOa1SryL4TJ5Hoe65FB3vuYHtujJkMGsyheeLlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706062590; c=relaxed/simple;
	bh=8pMbtIOoXJMol0Vc+8Ttda6UFgII52v3WUVdIlQZpY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CJQL3QQ46EdiJeAxd0v1OdsZ2MbymZFIxKIe3JdnqlQiMnXEI6ABibDliagUHY53qc4wXPOQ1EIOQFV8GJnW8WSDYCxPdKqi4vY7bPIFr9hVAu+/JZ5muu8pyy9bfZt0x8/nOAU7d8yPJGtwm68lK7feZj0fGhaTbjnpOOU5dW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nZ4s/fnj; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dc24f395c84so4096252276.1;
        Tue, 23 Jan 2024 18:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706062587; x=1706667387; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=26UUWP5FsT7ts1M8733toiraR59N3yxGAjQ5B/FLR/s=;
        b=nZ4s/fnjTR4fAw2DXTjt49ArbqY5yG8hShfBNpwA6XtG7Dd3CtMmhYcwAIKKJPvyvb
         11eRvzCNpRfMEjsBQejwj3O1Nb0xYGdcf075rPVSMD1juCm1A2dwxtiepYxb/qgxlWuT
         /DISAiwIv1lrUWOcMgmiGj+Xc+TCwFueSZyUWqNN4vJbKp51xyepaa9HM9HanSndmANF
         chvczHx3c6SyJnjX9+bDKiceb2YUe5U94/eyVypTnCfi+FFq+i/5CsacansFPV9OKcnn
         X5VFMbwxFX+HIzrWxyBPCE3prwOPt4uRE3oMOAEDJ4G+jbXAH6PAhgW8+DWuVHDeDKsu
         QWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706062587; x=1706667387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=26UUWP5FsT7ts1M8733toiraR59N3yxGAjQ5B/FLR/s=;
        b=GPKkFm4Xul8atU0aEaXgs2uwgugR7F0B0VaxMOuZHjRMa9p0v8rMB8fsuwOTwKu0bD
         bKanzp2Npjw00HDLr5zGi2yi/Yrj07vQzXeQUxb/BAg289OuB80y4anD/RJWUn1YCN0o
         tyNZcb1PhQceTpzGQPZddWKewuOygthdK8/PVF0NolPUMYVdTpPA5DkYHc/z3u49OKfW
         bMORB7UL2AYODyCOauIEPeMKsW/p/tk6xRdNkXgBOSlYftWHXcw+9pAne179D9cTfav7
         35BX3psnb42V0VDZPPSa08ccgf99Sg+ceku69XtuzSIzdYIxE4z/yg2WrFsE+WTRIQJR
         2AKg==
X-Gm-Message-State: AOJu0YxdEqG6h+dgxGPCGHVX96pRWKTq+IbORInloopSjjL5x/m6I0S8
	DEmzxbRdYznlOcHqhFo3mO3FyXjhwRH8fXShxZTosclHFCnym1YiiREq57lmePTBGF1oHn+8gyv
	/AGHfGjs/GySAR/wPSV2ytqTQWhbWARuVDaeUtI8r
X-Google-Smtp-Source: AGHT+IEAcYqR78xGgiKBzWF5d/9cH5/Q3UuTa5TaWRbR62SNrkPoDs6WlA9ZfRikGvWbbls/kUxwscWIPi9JJBku6xQ=
X-Received: by 2002:a25:df12:0:b0:dc2:4c43:6e6a with SMTP id
 w18-20020a25df12000000b00dc24c436e6amr90965ybg.57.1706062586692; Tue, 23 Jan
 2024 18:16:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121111730.262429-1-foxywang@tencent.com> <20240121111730.262429-5-foxywang@tencent.com>
 <ZbALemDF9sAYS2AM@linux.dev>
In-Reply-To: <ZbALemDF9sAYS2AM@linux.dev>
From: Yi Wang <up2wing@gmail.com>
Date: Wed, 24 Jan 2024 10:16:15 +0800
Message-ID: <CAN35MuR-t0THwSQa5ye8inLon3hMCZiHWnu5ofVNxmPJQ6+izg@mail.gmail.com>
Subject: Re: [v2 4/4] KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
To: Oliver Upton <oliver.upton@linux.dev>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	wanpengli@tencent.com, foxywang@tencent.com, maz@kernel.org, 
	anup@brainfault.org, atishp@atishpatra.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 2:54=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Sun, Jan 21, 2024 at 07:17:30PM +0800, Yi Wang wrote:
> > As we have setup empty irq routing in kvm_create_vm(), there's
> > no need to setup dummy routing when KVM_CREATE_IRQCHIP.
> >
> > Signed-off-by: Yi Wang <foxywang@tencent.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 13 +++++--------
> >  1 file changed, 5 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index acc81ca6492e..7c836c973b75 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2999,14 +2999,11 @@ int kvm_arch_vm_ioctl(struct file *filp, unsign=
ed int ioctl, unsigned long arg)
> >               break;
> >       }
> >       case KVM_CREATE_IRQCHIP: {
> > -             struct kvm_irq_routing_entry routing;
> > -
> > -             r =3D -EINVAL;
> > -             if (kvm->arch.use_irqchip) {
> > -                     /* Set up dummy routing. */
> > -                     memset(&routing, 0, sizeof(routing));
> > -                     r =3D kvm_set_irq_routing(kvm, &routing, 0, 0);
> > -             }
> > +             /*
> > +              * As we have set up empty routing, there is no need to
> > +              * setup dummy routing here.
> > +              */
>
> Where exactly?
>
> In the context of this patch series it is rather obvious, but this
> comment does not stand on its own. You can either throw the reader a
> bone by mentioning where the dummy routing is created or just drop the
> comment altogether.

Yeap, you are right. I will drop this in the upcoming patch.

>
> > +             r =3D 0;
> >               break;
> >       }
> >       case KVM_SET_DEVICE_ATTR: {
> > --
> > 2.39.3
> >
>
> --
> Thanks,
> Oliver



--=20
---
Best wishes
Yi Wang

