Return-Path: <kvm+bounces-33061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F066F9E4338
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:21:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E7BF1667F0
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 194FA1A8F7F;
	Wed,  4 Dec 2024 18:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P8zJzR0H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C99423918A;
	Wed,  4 Dec 2024 18:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733336505; cv=none; b=NZPSMX3ldyKl2pK7xfbNNt/Fwh5S6I5Dirc38930UOFx/7vvF4ZVVu9pf63m2ENRBV3V20ztLidMOcQ2LilVV2kuDlISu9JodrkT8FqrtO9rvL+p1SaS2fllz2y8SVW8trRYF4qBCzahHfOEjl4ZLPcc9OjYTsltAOlviGX7XYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733336505; c=relaxed/simple;
	bh=uME13l5HovQ3NZyv34mfUDUdqGg1uJwju50MkEmn3vQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QljQ7eY1nPi6ozBMjLr+WQZRueM9ruim0rwDojIyg6eZi/R+cfwzhcUXlCk3RGIAipBo6rnWPaAhFFJayx/IHBLYpbzhDBsXawW6DHbe6ekoYPcIdfmuPdwzt9dAMf+zWECeCFbgz0+pD6nD/y+/c2K0afbFuSvMNKZC7taPHSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P8zJzR0H; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53de8ecb39bso146653e87.2;
        Wed, 04 Dec 2024 10:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733336502; x=1733941302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uME13l5HovQ3NZyv34mfUDUdqGg1uJwju50MkEmn3vQ=;
        b=P8zJzR0HjnbeGcX1DzZL+RtzGWJiq54pmlkX9DrPWYGyRT77Rf8MfvMXJASJkRYyX9
         8R9RDma09a25Ufepuoj6RN4WCU5IDqeZdyq0SYeVZJlYq5gjr9XinWnHsMvn/w6iKPno
         Ddxfu4zpVoV44lhlrtTnadHvQEayvOBMo3F+7Si55hah8BTn/iAsV8CcILaEIYsQJPS0
         YFnxfJ/++0cn3WnxtHYMJh0v9bGk99bsHLrLzyrcxHQvTV1ClVznrDVMnPvY8UV0JBrs
         JwZkztVrCSDqa9GVQbGLNgtuGgtrEw7GKoSOGRLHUTZjcHeLdhf7EyyRj0gwS46hHCUh
         Tf7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733336502; x=1733941302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uME13l5HovQ3NZyv34mfUDUdqGg1uJwju50MkEmn3vQ=;
        b=dOrOXYKcFwz5HwDMfmzsMiC8Y0jRQYVmOIv3/UfuH5UY5naFnmgyg7jaEjpSaxm8Nd
         IZZRti4LQBICqLnzxiIdjK6Nq2/0B7CI6f4zmuf3XdQo/Hb+7VHTZUec4nsQswFbsSMQ
         p8roWVQ0MvGLcYYbWUdn06kUQ5vsYBI5+afoFOlQVC2TvwFjTvA4/zx2UylZxEgD0gUt
         hNOaKwn2GMr6WB0t8SxKD1hDMp0Vc5gha9DRgv4H5Zu3nz/dn1XWhthcmP305+cxnvhr
         H7T7Sn7s+l+zfydjANhCg5TAjXYnENjnWdu9Yuek8Sm4sfxIo0YeRIDTSEnVNOu9HkgF
         EUEA==
X-Forwarded-Encrypted: i=1; AJvYcCUO/Vu20E9x4r/wDPledn53EtxLLUXFIg5czQbnMGl3yWrsPdYmxeAsgw6ZBNY8aNXVDPo=@vger.kernel.org, AJvYcCVwhLLXwJt1EpAqJnP+S8TkbIlc6VbWR4BZXFw3cXMCUYkpiHbK3qlkhabfhezfspsUI5dMTe5n4YY8+A/i@vger.kernel.org
X-Gm-Message-State: AOJu0YxzjlZagBfspnHyTt4YHPe6VskBmeKH6Vcv6FnvsKPuzstt0iGo
	fthpoNY+G/YoUYQ2XYqF0uBrAb2G3GBPpT3uS+rs7ocsJ4bR497tdcnzP2M/9GCYeIXU1eQ5q0k
	u+jy+oPSj0Y3dm1OYU5isrTMxcmU=
X-Gm-Gg: ASbGncuJSWdNlaY3xqW7LR824lgir+qQSKkkVE7jCXbYGSVMUb0gAuuVM7vDlcgw9bX
	+6TczZcY606XeUVoqucpvilv1aokwah8=
X-Google-Smtp-Source: AGHT+IHqZimxoCyGtBnst+WJ5pzCbapVWH5mhYIjHSkEmNWXMwGSZsnIZshHuLlPBJphjw0Ao4JRV6PYRdpAc2LLuH4=
X-Received: by 2002:a05:6512:3ca2:b0:53e:1b9d:4a4 with SMTP id
 2adb3069b0e04-53e1b9d0560mr3729506e87.3.1733336501332; Wed, 04 Dec 2024
 10:21:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-4-arnd@kernel.org>
 <87ed2nsi4d.ffs@tglx> <3B214995-70A6-4777-B7E3-F10018F7D71E@zytor.com>
In-Reply-To: <3B214995-70A6-4777-B7E3-F10018F7D71E@zytor.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 4 Dec 2024 20:21:04 +0200
Message-ID: <CAHp75VfZW2A1s+QLdVHXnFV16dWhM=T5gtWw97d1gM-Pys+CZw@mail.gmail.com>
Subject: Re: [PATCH 03/11] x86: Kconfig.cpu: split out 64-bit atom
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Andy Shevchenko <andy@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Davide Ciminaghi <ciminaghi@gnudd.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 5:55=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrote=
:
>
> On December 4, 2024 5:16:50 AM PST, Thomas Gleixner <tglx@linutronix.de> =
wrote:
> >On Wed, Dec 04 2024 at 11:30, Arnd Bergmann wrote:
> >> From: Arnd Bergmann <arnd@arndb.de>
> >>
> >> Both 32-bit and 64-bit builds allow optimizing using "-march=3Datom", =
but
> >> this is somewhat suboptimal, as gcc and clang use this option to refer
> >> to the original in-order "Bonnell" microarchitecture used in the early
> >> "Diamondville" and "Silverthorne" processors that were mostly 32-bit o=
nly.
> >>
> >> The later 22nm "Silvermont" architecture saw a significant redesign to
> >> an out-of-order architecture that is reflected in the -mtune=3Dsilverm=
ont
> >> flag in the compilers, and all of these are 64-bit capable.
> >
> >In theory. There are quite some crippled variants of silvermont which
> >are 32-bit only (either fused or at least officially not-supported to
> >run 64-bit)...

> Yeah. That was a sad story, which I unfortunately am not at liberty to sh=
are.

Are they available in the wild? What I know with that core are
Merrifield, Moorefield, and Bay Trail that were distributed in
millions and are perfectly available, but I never heard about ones
that are 32-bit only. The Avoton and Rangley I have read about on
https://en.wikipedia.org/wiki/Silvermont seems specific to the servers
and routers and most likely are gone from use.


--=20
With Best Regards,
Andy Shevchenko

