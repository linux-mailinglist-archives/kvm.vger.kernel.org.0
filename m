Return-Path: <kvm+bounces-33038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AB399E3C7C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 15:17:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED181B302B2
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AFAF1F7567;
	Wed,  4 Dec 2024 14:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AbNSluFY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EE01F7063;
	Wed,  4 Dec 2024 14:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733320985; cv=none; b=Tc4KeVom9dxU6vdNznHkS4buaycAhSLTJ4M2q5PkTBw1tITD0yCxo1qe0X/Vo9ExsQXN+w/EGqNgnB86P58pez2xJpbrZq1PMLwXC5SH44zly6+2eVRYDK2txMdZ9eA79kvqdopAJLzXDbTq+N5xG+PusPMmQSEvnlP7acCou5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733320985; c=relaxed/simple;
	bh=3KGHbh74PL8FENaLPeIGYJZyqpRguO1ac32S/lCqWBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J1BELklo0Svpca0nqLgRrTU2+M/OdMn12Rj/cqf/yw81O8Xc0L1Qwk5pt9nK3ySQbbqF2MlDRZoJ+mSYFSceJ+3jRaTptFGf2bKD4b+c+3LDmJBkM8k71+vnx2dg0M6pvgk/ZUIL8RHWDIpGocezPZzVF073mdbND2Rd7RsAnqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AbNSluFY; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53dde4f0f23so6850259e87.3;
        Wed, 04 Dec 2024 06:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733320982; x=1733925782; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pLINUAWWHpZc7WEX/isPU9K9d9FAmMIJVRAMNTydl4=;
        b=AbNSluFY4aaH7vFnTCn9xwxQCIXnqGHLay85UH5gI/0zt7w7x3L32FUrom+WRu7b/q
         cpiMQs1yS5cBuJyvK3nc0rDG6C4X/GEBRZYGIE0uZePcJaoa+eXkHMmx5+fGxAuZn4Qn
         s0sLKs6lSQRWzfu9vjEZhtiNbV8vY5hn4yTVvUumtDx+U0Bo2LQlh+X0WOD6zEh0rKWp
         jpL3T0we0Fadk5bgTzTdZpqOvQ13PhiB5Teqqm0WKivbQyHhqBn+snt0lXt0DZfP87Q4
         +wI/SPrxUs0EQFhGYid/fXyb2LifRtocfRS7XUKQAjpPLBs4cQNmnfjBrDOz9bFP/fxm
         mX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733320982; x=1733925782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0pLINUAWWHpZc7WEX/isPU9K9d9FAmMIJVRAMNTydl4=;
        b=ainIGH4v1cLFmNDYGU/IbjAV6zRr9ROetQguxaz7fdVfo0y5nRpBneYvy7jj9cce8q
         WFII2tFWXj9RagMZe9+Ar7ILzCaVWsufw84cPdxqBHeO+esxQo06zrcOUpeeVWGA05Ye
         Rzsq1Nq40ChYL5xjP1Tujc9H2RqO0h4Df7NdT2Rr/eI23As/BpEgSwITgcDqXW1qivRo
         sNKytVQy7YU9nex1n5hlrm+2x4Gc7PFGGlzg6N/hsebskedgyt1mW+aoGBY1d7ki+vE2
         ebZL1unia9dfRnMScR4ZZoGQhR/l5ij6GXFQ3GQdn1NRiX5THJfX5Z9RYP4nzsusAqG2
         Ny/w==
X-Forwarded-Encrypted: i=1; AJvYcCWL6VRMMIKN4Tl5bvkQkDgQ9lBr6XFMOwVVg3HWeZhiKtpya9TpYwxoueFVxYDVKbYvDSmKJAP6jbluTwv5@vger.kernel.org, AJvYcCWLqye0/G+n/Kzl/uL2qskpdsr0oFMwYAuasGLi0UMQqdTBdaytjZmmCBxsrprbjbG2T0E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTNGC7ghg1caJxRwkBxq17gxCXLcAAroUE+T+USlqCe/CCUwUT
	Lb9wCBs0uiYNpOcWF8QxmhmM2TSamuKF04Ov0MfujXUAYXfzkrK8/+UVZgerJzEoHEH7PC8+FYl
	HWQi39kIlCDJSq8YE6FNo4CMb0A==
X-Gm-Gg: ASbGncuwpk7P9IgxY0eK7zyYihzxZKbrZ9nLG5srIR4eh3eHODn3FLeXgLOezuQDKL7
	bKUZM6sDea0HcEjDVi5ZjHyZPfRQTPnF65Ddzt/7UgmKNyQ==
X-Google-Smtp-Source: AGHT+IFM8eESFGwByTwn9nzvvRumhG+01+X3aWsUAJaLsxSd+y2sT6upYNjKhhLCxS3WrtgnS9mpqP6Rpo0mFVw+sNE=
X-Received: by 2002:a05:6512:1247:b0:53d:a321:db74 with SMTP id
 2adb3069b0e04-53e12a28208mr4148964e87.50.1733320980056; Wed, 04 Dec 2024
 06:03:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-6-arnd@kernel.org>
 <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com> <00e344d7-8d2f-41d3-8c6a-1a828ee95967@app.fastmail.com>
In-Reply-To: <00e344d7-8d2f-41d3-8c6a-1a828ee95967@app.fastmail.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Wed, 4 Dec 2024 09:02:48 -0500
Message-ID: <CAMzpN2gTUks3K3Hvwq3MEVBCN-9HHTLM4+FNdHkuQOmgX0Tfjg@mail.gmail.com>
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Andy Shevchenko <andy@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Davide Ciminaghi <ciminaghi@gnudd.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 8:43=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Dec 4, 2024, at 14:29, Brian Gerst wrote:
> > On Wed, Dec 4, 2024 at 5:34=E2=80=AFAM Arnd Bergmann <arnd@kernel.org> =
wrote:
> >>
> >>  - In the early days of x86-64 hardware, there was sometimes the need
> >>    to run a 32-bit kernel to work around bugs in the hardware drivers,
> >>    or in the syscall emulation for 32-bit userspace. This likely still
> >>    works but there should never be a need for this any more.
> >>
> >> Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOTLB.
> >> PAE mode is still required to get access to the 'NX' bit on Atom
> >> 'Pentium M' and 'Core Duo' CPUs.
> >
> > 8GB of memory is still useful for 32-bit guest VMs.
>
> Can you give some more background on this?
>
> It's clear that one can run a virtual machine this way and it
> currently works, but are you able to construct a case where this
> is a good idea, compared to running the same userspace with a
> 64-bit kernel?
>
> From what I can tell, any practical workload that requires
> 8GB of total RAM will likely run into either the lowmem
> limits or into virtual addressig limits, in addition to the
> problems of 32-bit kernels being generally worse than 64-bit
> ones in terms of performance, features and testing.

I use a 32-bit VM to test 32-bit kernel builds.  I haven't benchmarked
kernel builds with 4GB/8GB yet, but logically more memory would be
better for caching files.


Brian Gerst

