Return-Path: <kvm+bounces-67478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 821AFD06564
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 22:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1C9230285EA
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 21:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5992133D6CA;
	Thu,  8 Jan 2026 21:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xuywXjtF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687DF1DF97C
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 21:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767908065; cv=pass; b=SQBytsOQeA2/fEt8njfAQoT/VP+ekn49xMzqI279Sg55AKXcQbxZ1Ec30x6UTKz9PFmm5gBN08k3GSc2sT7gsQnlwO0gcxwmC0AYarVVFT0NHK3ycDbWNFkqx5B7LER+7vnLNw+rX4zPDpSNZ1m7gPDYleAREIAbo0wIuc3WD0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767908065; c=relaxed/simple;
	bh=BIFMGdisYPVJDEKUwNK9cGSBgYcc6A+epTuz8Zo/MyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TLheO0A65TY7wiyihkAIURv2Av+dJmTtbh2c9B4viqm40ELnu/9QsRnv3t4I7CxCO9QGpPW1cVKYwKJ1M4E87g8TuvNzQ3vuk+1N/kURCbuL8IOUDDYeFS60IvAOQWsQCnzAeERbybIP1lYI0Ns/fovmB3+28ZizW59u3Ig4jhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xuywXjtF; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee243b98caso38071cf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 13:34:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767908061; cv=none;
        d=google.com; s=arc-20240605;
        b=RNN1dlLFd+9yDZ+nsGvnVuIUGPch1pjS1iM8fOGPhp064LLKl5nqbOWb0Fu+WsGcqL
         NwDK66oWQV1JgSLT+gEhQVlR1ICbv0aP6srH/PTr625HAlP7Y594BiBwyDA4IQGKw8u5
         bu6VXz0T9sGDi0/rqO3PcuzzycLWm7/DHzhIQrzU0KeevjYEG6+1Wvx4v3es03B89CUx
         sJVaF5sZHIT8EJbXPa6LqdzNVuFU52tUbWCfW01fyKYAy2vDB6O6bcIZOn23elairz9q
         GjHFmoMSUwia7ex+AkZFhA2GjJCuvISOr2fVCsqTW3adEOdarI1yPG6V43s76ZfrXzRa
         EJ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t8xfNAiLYTrj2PkrzfwvKzprYCcDxmoMPbij5imaAm4=;
        fh=fZIoNmhYinhWsZXQPCVKgzwq01BLkza2xOPCXrn97xE=;
        b=N0x9PVcZuIMiD83zIdtobFd+zTOwWGPSmXS7r3/VmliVNcyHLbwVpeELSylU6y3ZtT
         TrQhm+259qXtgAW8WH0blVWDnlF6EUc9EtHG8DkwrE5NH7ebju/6RjSk2KqoKOIm6eih
         lid+p5tDqZCEeEmEVH4M/uij81nvJRCBVZlpdTfgUAvSj38rc3vGN076MPs9dnI+bbB7
         yXam7bSPCPEYZSHxmTuJXzSz9xvOuj51kZqDS5+S1TEgq6iuRdWsFog7FcPIjZuSzelD
         S10nnHjjHl35yPAMEBhJC+VWP1gnCuMIwb55g4QLZhPApGtmGA8Ik1cyilYfrU645lnm
         J1rA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767908061; x=1768512861; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8xfNAiLYTrj2PkrzfwvKzprYCcDxmoMPbij5imaAm4=;
        b=xuywXjtF3Ui3ey8jyqsZaGrjl6L4TBxT1UKutDjQvB6V08UWVpbSllz7Ehq6D6/z6+
         alD8pGGTEGkWeOXpn5BK2xUpPZpOFMg7cegAgYkomvN7E49hUjSkxSAH77yUMqqg54nV
         qj2zpDn9+N1VZbULFozztkuQ5z+ilbNPVpC+YDsXCI0Eq9gjY/sa79nqBAOByrKMmajE
         R1pNvb/C7uBd5/dYizGvACfp0Ft6iwxFj3Ukmo7hxKhH8EHNnPRCARS3oJsWBboVnn3o
         Fa2o4c6D4zBVvHj93iQLqPB3d+CcYhunzp2/J2m03nMoxzGHG9T8s8iVOlUCgfebIQUz
         BKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767908061; x=1768512861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t8xfNAiLYTrj2PkrzfwvKzprYCcDxmoMPbij5imaAm4=;
        b=AHCHlqFNbGkTXH5JnmFI4U7iy3yjFdasS3BCwFtnm+5EHdldHd9/3XucusIjy1Tdgm
         lryKkM40v0yqj6Tgm+a9dLIbW5UwxgRbWM6zfl2WfgfB19FQDWGn6nzUmzps0zg941Gt
         zlL7B8DkfmELqAUOU549c9aDoVsbp+Zc7G0bGQ1NoOrWa2ihI9kzvJ/Oaam2JDFRp/iM
         /Txdbgduwzxy8E6SHZxZkFgbylo/JvThpt2TQ6uZG7OOoV2rJYLrMutDnUbpf+mTlqlA
         uQP7DrF/DTXSULhyGOeRJqN2FOrgpDlblHXPMrrBz9N8J5mXfCZvRmcmK8/xR7BqdnD6
         LzAA==
X-Forwarded-Encrypted: i=1; AJvYcCXg7eTrg+K10IQRT42CLXxzM1s4XjEOz/AHvzihKAKoLxdm7cI3ks4nfA11KKqCipGPzkY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQcfuSEeLttC4gyMqBFB2uQgk2wjERo5gv4Pi3V/t+ltHJSbk8
	0szN6KtEfOi5OIadmY+FqAXkjis4cl/dxrMR/ipOPZsAqsOfT+ubWQdPMErikBHKvPe1ICFP2df
	/xWLZkQhw2CpaIFI6+I0dyIIVK+yGRD6bogMEJoKc
X-Gm-Gg: AY/fxX56AxDApofy8wQ9aPq9qpXa92dxNJOn3272iYntb9+H1w5fnX8GEZbsQdLP6y7
	B6g3ho5SO/CpPaw8a4aVnEYwyUhDCQ8wfYlUHBUGrd7iUaD5xHHkx3DEQ/R13d/RB9ge9iqkosE
	jKBLb1CIQP7evHDdZScHcTu5kzavQw/tdwh3pLv3nNH8qOq3KnAi42zTHTvFiCK3nhc1orPT/vA
	E6WlRCHl9PMNtlA8TUXRlAMoPS1wSFOL1LHXcXU2SqUYqoh/PopMP4mTZG3IXH6jeUoll2oh7iW
	d0hfAmjxjYv+abZEyCJNHx5RnQ==
X-Received: by 2002:a05:622a:3:b0:4ff:a98b:7fd3 with SMTP id
 d75a77b69052e-4ffca1df40dmr3413331cf.2.1767908060993; Thu, 08 Jan 2026
 13:34:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com> <20251210181417.3677674-4-rananta@google.com>
 <aV7i6P3FqPZu1Tq0@google.com>
In-Reply-To: <aV7i6P3FqPZu1Tq0@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 8 Jan 2026 13:34:09 -0800
X-Gm-Features: AQt7F2ob7H_BJouLaULso-isBlR0aX6N4tnXuzh9Xt3--aWmgdc_NnsFeWXImMU
Message-ID: <CAJHc60wUEpwRLzaV8a8WG0d7+5+M5c+2s1cLgKK2Kb_rqThufA@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] vfio: selftests: Extend container/iommufd setup
 for passing vf_token
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 2:49=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
> > diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testin=
g/selftests/vfio/lib/libvfio.mk
> > index b7857319c3f1f..459b14c6885a8 100644
> > --- a/tools/testing/selftests/vfio/lib/libvfio.mk
> > +++ b/tools/testing/selftests/vfio/lib/libvfio.mk
> > @@ -15,6 +15,8 @@ LIBVFIO_C +=3D drivers/ioat/ioat.c
> >  LIBVFIO_C +=3D drivers/dsa/dsa.c
> >  endif
> >
> > +LDLIBS +=3D -luuid
> > +
> >  LIBVFIO_OUTPUT :=3D $(OUTPUT)/libvfio
> >
> >  LIBVFIO_O :=3D $(patsubst %.c, $(LIBVFIO_OUTPUT)/%.o, $(LIBVFIO_C))
> > @@ -25,6 +27,6 @@ $(shell mkdir -p $(LIBVFIO_O_DIRS))
> >  CFLAGS +=3D -I$(LIBVFIO_SRCDIR)/include
> >
> >  $(LIBVFIO_O): $(LIBVFIO_OUTPUT)/%.o : $(LIBVFIO_SRCDIR)/%.c
> > -     $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> > +     $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< $(LDLIBS) -o $@
>
> Do we need $(LDLIBS) when compiling the intermediate .o files? I thought
> we would only need it when linking the selftests binaries.
>
You are right. We need it only during the final linking. I'll get rid of it=
.

I'll update this and other nits in the next version.

Thank you
Raghavendra

