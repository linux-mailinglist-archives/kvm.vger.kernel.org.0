Return-Path: <kvm+bounces-6492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F1C83561B
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 15:33:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27ABE1C20FF3
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 14:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF77374E3;
	Sun, 21 Jan 2024 14:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="VUtB2zWW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9CD12E7C
	for <kvm@vger.kernel.org>; Sun, 21 Jan 2024 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705847595; cv=none; b=LVicXFvC4zjqgnDI3RdU+UHFI0pBTg3rVoOFtLpTdAd+XS+xrWu6YTw4sBb0rB99K51Ox94Hq3Wg21YS5j9UB7h1HGX+Hqgt2SsDvEgOJmZczBQWf1VSAtwhDo4fO5RKHKMWjeb1cIsMvKWLdPiZS9uBFT9AlMv3X0vZPg+hB+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705847595; c=relaxed/simple;
	bh=QZgDpKatiwHbivVfvq1VSFXH6HZOq0Kd5Fdk05P+G4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=haceEuMgaDSFUAYY3DEGNc6Zo2jtWTUWCWOZ4mGhHSBYk7F+ALdaIWIlKMIEXmDGfqJ8pNNOCHf4D5MN+bPYO2fnVvSa698kO21Dxp5TgQpjhxz84WpYUnjthBSVHHBALjHuCGmjvtmvrvNccAK8yW3BYImXg/tjTZFncjmA7Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=VUtB2zWW; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-50e72e3d435so2048311e87.2
        for <kvm@vger.kernel.org>; Sun, 21 Jan 2024 06:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1705847591; x=1706452391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJE8OZBFkDTsEKIKYcuzQslvx5cqQPu3UG0j6ooiPi4=;
        b=VUtB2zWWFeMetXRQTGNinbpGNsXBlh5xaBhp76a7OSEeNIJNET751qWDZiEHPzDHGr
         qTjhdvh8Ak9bNqV8xfUlX1ALXFGQiUv2ivGSz2iIfwrYY+d48Cbkb3e23ycOBVrWdR5D
         hWY8mOKDcRVQXUZuaWX6jCR8Qa9pHGRYHrDHGFoloGF8vvt8pgRDl5ryezuKF3KqIfX6
         Iz7qiXuItCL6ue3cAT5On6aW8oe10t31r44xym29TJVNAiCeVGFGys+YRAMnDSBr85g9
         riY4yHAZQiO1SMLOiCRsnVmyAzY50gmkEeE04jbA4sJBLiOlbO0QCJtwQGMAA0x4AlOS
         VL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705847591; x=1706452391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LJE8OZBFkDTsEKIKYcuzQslvx5cqQPu3UG0j6ooiPi4=;
        b=SJRvyZ2wruPXCiuqXzYQzVRmE/why2suSNtZV3vE0WqdHKxBfaOF3WswvygPfcYB5R
         5Qi50IbY4ZaUwEbj6jHBbO+7zABA1iioga2apLvLUDE94RWRgCwIjydVaP3oDrrDPNh5
         8ckMO0rJxrdWAUS8WFJQLSoed3xdoxauhSNjcfP2lbBid0/HibiAcLVveaH5kisaVGeP
         LUz4EfyyDzAFd+3k5IX9nL+hV49CtlTkILCYVM5nfG139f1jvb/+p9W5RuLdik3ACWlj
         6ZoLC27487tK9UyRwxCAnfW9QTAxnrr4BXawYe2g4yKDMN39Q2G/+T1dCRURbhuZuVVt
         c3wQ==
X-Gm-Message-State: AOJu0Yxs0AfVP+UR9qXf0jWBc2kI+nvGcit/sS9QzebMIDPnEZ4O39sc
	eY2s66nULXSSYdhkI6MspEqSu+Nz8yYLkPSf4A6OJxxBHjkDbSoC5/LNjx/Sv1NmxgP8wFPDdA/
	wDWygGFABm7zn/2uNwHItPQnMp4N2++WsN/ARhw==
X-Google-Smtp-Source: AGHT+IHKIXirYl8NrFW1DcPSJph3DFRJYP7/XgMmw+Lupa75vIdqahT/p0CIPU2Xazeyk/5FYR4FTnBLHo6Xh0ZJMGE=
X-Received: by 2002:ac2:44a4:0:b0:50e:64f5:ad71 with SMTP id
 c4-20020ac244a4000000b0050e64f5ad71mr580427lfm.146.1705847591228; Sun, 21 Jan
 2024 06:33:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121011341.GA97368@sol.localdomain> <mhng-e4b5de69-859d-43ea-b35d-b568e6a621ef@palmer-ri-x1c9>
In-Reply-To: <mhng-e4b5de69-859d-43ea-b35d-b568e6a621ef@palmer-ri-x1c9>
From: Andy Chiu <andy.chiu@sifive.com>
Date: Sun, 21 Jan 2024 22:32:59 +0800
Message-ID: <CABgGipW0pZCESu7dyiUdta2JtrpeMsJ3EABNjj_0GO9fbbTwQg@mail.gmail.com>
Subject: Re: [PATCH -next v21 23/27] riscv: detect assembler support for
 .option arch
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: ebiggers@kernel.org, Nelson Chu <nelson.chu@sifive.com>, 
	linux-riscv@lists.infradead.org, anup@brainfault.org, atishp@atishpatra.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com, guoren@linux.alibaba.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu, nathan@kernel.org, 
	ndesaulniers@google.com, trix@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 21, 2024 at 10:55=E2=80=AFAM Palmer Dabbelt <palmer@dabbelt.com=
> wrote:
>
> On Sat, 20 Jan 2024 17:13:41 PST (-0800), ebiggers@kernel.org wrote:
> > Hi Andy,
> >
> > On Mon, Jun 05, 2023 at 11:07:20AM +0000, Andy Chiu wrote:
> >> +config AS_HAS_OPTION_ARCH
> >> +    # https://reviews.llvm.org/D123515
> >> +    def_bool y
> >> +    depends on $(as-instr, .option arch$(comma) +m)
> >> +    depends on !$(as-instr, .option arch$(comma) -i)
> >
> > With tip-of-tree clang (llvm-project commit 85a8e5c3e0586e85), I'm seei=
ng
> > AS_HAS_OPTION_ARCH be set to n.  It's the second "depends on" that make=
s it be
> > set to n, so apparently clang started accepting ".option arch -i".  Wha=
t was
> > your intent here for checking that ".option arch -i" is not supported? =
 I'd
> > think that just the first "depends on" would be sufficient.

The reason why I added the second check is because clang and gcc only
return an assembler warning when it does not support ".option arch" at
all. No errors were reported. So, it ended up passing the first
condition check for old toolchains that shouldn't be passing.

>
> I'm not sure what Andy's rationale was, but de3a913df6e ("RISC-V:
> Clarify the behavior of .option arch directive.") in binutils-gdb
> stopped accepting `.option arch, -i` along with fixing a handful of
> other oddities in our `.option arch` handling.
>
> If that's all this is testing for then we should probably add some sort
> of version check for old binutils (or maybe just ignore it, looks like
> it was a bugfix and the old version was never released).
>
> +Nelson, as he probably knows better than I do.
>
> That said: what does LLVM do if you ask it to turn the "I" base ISA off?
> I'd argue there's no instructions left at that point...

Maybe what we really should do is to upgrade the condition check to a
one liner shell script and grep if "Warning" is being printed. Sadly
this warning is not failing the compilation with -Werror.

I can try forming a patch on this if it feels alright to people.

Thanks,
Andy

