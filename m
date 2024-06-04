Return-Path: <kvm+bounces-18712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 580808FA976
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13B4D28900F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D761413D516;
	Tue,  4 Jun 2024 05:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jzax1NTB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA32813DDA3
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 05:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717477517; cv=none; b=msVBgJWDpQHTOih+9qiMcYHGZc39jPYxckaHb+AGPgwhpbE0+twRbWLZ2S4puI2wFdwrj/ajIpGsurBhdzDbccTxvB74NOFzXySIcCW++p6hc0P3UU1NOTmx/s1vifJzyxhJUb8Gg+9R97ZY+kDRwIRdhwlI+wvr+bsXdM5LBVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717477517; c=relaxed/simple;
	bh=ST1aT+ZIOQZIJsJpJM5SeKpqVlsON/qQlVZ1f1tgIlk=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=FoOnzst72iXa7Fj65D0I+ESgQGZWclXJFlQxEDgsN8OWs7K8kPOC6ZShszcdOxPTxP7Lr/Zz2EKq1VdyP/hvvwORgMczV53d3DNeUZfaMGH/NVNZoNFnnlYo2x3+UWhZEdGO0vqKnIWhVrx8OreJ+YtMjaapfStpmMAST7c9DWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jzax1NTB; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1f6262c0a22so28560985ad.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 22:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717477515; x=1718082315; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MP9ddSZIJDyxzHcDOPGE2whW95Q+sS0DCZmdXFauqkg=;
        b=Jzax1NTB8dMdaRYmQ8hCR+NgipHEsCxJ1XYxofOqUYfQao27AIPJ4jY4aVsevADlpw
         +HvEKyGkWySrH2uQy4yQi3Sc5UKYR+d6Dz2yiavQT+XaaLQKcoOmtbNAIyUWnqJxpD5c
         PwHI3tMzEfzYa57nu58bJxdvKOKrJ9m5VfmNYyb+rr1VIFO7kstUrW+yPwo0AZKACiTO
         T1XthHVmO7qw8eRrs1x8dT+BZLSf6aef7IeSCmHyIS9qw9oH5fEZoz7UIikTpsVadJKO
         xx5oI+ll1VIBIznwlIKsieekpmpZ8MJ/ysG3EO0RTybmJAz5JdP3BX1o1O/sCL3wy52x
         vzXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717477515; x=1718082315;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MP9ddSZIJDyxzHcDOPGE2whW95Q+sS0DCZmdXFauqkg=;
        b=oZUV0dB4RbXhUAWLf+uiXYnzk+VxMFFbo5hNJLzPxxDtCcOXXNSNFxCtR9UeJaY6mh
         2Ivw9ZEdny6A26tQvvgaV3e4dBNsXeD+EwpaHWzcttAcLiwNF9RlUmUJTigVwCpm4lLx
         Tkp+dYwJQC54Kr0Sqgfxv8QTXEARGM+k+uhe/MKPTtqjdLQ/6Ju6cN5yamHugRFVWYLM
         8oo/bHpXpMqDzTqiEJrLZtdBisepTfVaZ1oRtZRvVDgLo+kQVDjzhX/8+rpb1duFx6r6
         DUwSdG52dTTC7v63/x+NttfC9vs2iLqrmIAwNvQiVZcZFB3PeVgSuO/7+5qLemhY4Lir
         dPJg==
X-Forwarded-Encrypted: i=1; AJvYcCXN8ZT1WTKoj00zHFvPbIz/K4cnm06GafeXMd1FI5wQErOvOBZteqA93sgIj1OdathSd4JNYOuLJ6xVzoTtmGwbXn/+
X-Gm-Message-State: AOJu0YxQDpz/+ik850Auy9p0JknkZZBS3Di8Z2eCnspLdS6on/Gd8cWc
	YejIZtLKnPrjKR+YL17XVmFd5qcnI912jcssm1Vj8qbyG9AHSxR0
X-Google-Smtp-Source: AGHT+IHMk0DwnulW19nrV+PVxI9lED/KpaMqNXJxX2JEgXQmpOrUclrcB2VmQxzD0BobQPJNUcfIrg==
X-Received: by 2002:a17:902:f545:b0:1f6:53d5:3d89 with SMTP id d9443c01a7336-1f6937bd2bfmr26400915ad.11.1717477514898;
        Mon, 03 Jun 2024 22:05:14 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f63240c8ebsm74241155ad.267.2024.06.03.22.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:05:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 15:05:10 +1000
Message-Id: <D1QYYRZ0LMAR.26MRLHMK0MFDT@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 3/4] build: Make build output pretty
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-4-npiggin@gmail.com>
 <448757a4-46c8-4761-bc51-32ee39f39b97@redhat.com>
In-Reply-To: <448757a4-46c8-4761-bc51-32ee39f39b97@redhat.com>

On Mon Jun 3, 2024 at 6:26 PM AEST, Thomas Huth wrote:
> On 02/06/2024 14.25, Nicholas Piggin wrote:
> > Unless make V=3D1 is specified, silence make recipe echoing and print
> > an abbreviated line for major build steps.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   Makefile                | 14 ++++++++++++++
> >   arm/Makefile.common     |  7 +++++++
> >   powerpc/Makefile.common | 11 +++++++----
> >   riscv/Makefile          |  5 +++++
> >   s390x/Makefile          | 18 +++++++++++++++++-
> >   scripts/mkstandalone.sh |  2 +-
> >   x86/Makefile.common     |  5 +++++
> >   7 files changed, 56 insertions(+), 6 deletions(-)
>
> The short lines look superfluous in verbose mode, e.g.:
>
>   [OBJCOPY] s390x/memory-verify.bin
> objcopy -O binary  s390x/memory-verify.elf s390x/memory-verify.bin
>
> Could we somehow suppress the echo lines in verbose mode, please?
>
> For example in the SLOF project, it's done like this:
>
> https://gitlab.com/slof/slof/-/blob/master/make.rules?ref_type=3Dheads#L4=
8
>
> By putting the logic into $CC and friends, you also don't have to add=20
> "@echo" statements all over the place.

I'll could try a bit harder at it, this was a pretty quick hack.

I probably prefer the cmd_cc style that Linux uses rather than
overloading CC. But maybe that's more work.

Thanks,
Nick

