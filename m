Return-Path: <kvm+bounces-22679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BB994150E
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 17:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC1831C22FA3
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 15:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F56F1A2C29;
	Tue, 30 Jul 2024 15:02:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD0F2A1C7
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 15:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722351732; cv=none; b=qDlZLrx0QgehvTXSeyzet17gMn6XcReCcBvEdBrCYDcLaW6oqetslbEwizqgoTRvnvi+MHa6Zlt/16++O4rv8sWeHE6xKR7NioB7lxN1PJXPhzduZuCk6KXUltFFJTubMobyTyC/vQyvQlaEbGaZDx8J3R6WIt/AmZ9biMbH0R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722351732; c=relaxed/simple;
	bh=dCAjbSVHlMwkD7O7vy5fSGdy6Q04vhWwEMcL2tkVET4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o8G+bcuJj2jEgbkd4axfEsbdGqqwCpaztbZsZ1iDGbj9k/H/6Yqn3IdXzrezxR4+/wmgElNhwIRRGXHg4LJlKmyrki8AcjNvKwSvOG6oyvZPdqEky/E31epdpMVpMq2tplkDDOcLdrwIrmObQ0jA/hPBp6hZ9dSIAF1xwpQPtS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 788E11007;
	Tue, 30 Jul 2024 08:02:35 -0700 (PDT)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1D103F5A1;
	Tue, 30 Jul 2024 08:02:08 -0700 (PDT)
Date: Tue, 30 Jul 2024 16:02:00 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: "J. =?UTF-8?B?TmV1c2Now6RmZXI=?=" <j.neuschaefer@gmx.net>,
 kvm@vger.kernel.org, Alyssa Ross <hi@alyssa.is>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool v2 2/2] Get __WORDSIZE from <sys/reg.h> for musl
 compat
Message-ID: <20240730160200.3e0480da@donnerap.manchester.arm.com>
In-Reply-To: <ZqfCOOhF9dGf3G_c@raptor>
References: <20240727-musl-v2-0-b106252a1cba@gmx.net>
	<20240727-musl-v2-2-b106252a1cba@gmx.net>
	<ZqfCOOhF9dGf3G_c@raptor>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Jul 2024 17:24:24 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Hi,
>=20
> CC'ing the maintainers (can be found in README).
>=20
> On Sat, Jul 27, 2024 at 07:11:03PM +0200, J. Neusch=C3=A4fer wrote:
> > musl-libc doesn't provide <bits/wordsize.h>, but it defines __WORDSIZE
> > in <sys/reg.h> and <sys/user.h>.
> >=20
> > Signed-off-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> > ---
> >  include/linux/bitops.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> > index ae33922..4f133ba 100644
> > --- a/include/linux/bitops.h
> > +++ b/include/linux/bitops.h
> > @@ -1,7 +1,7 @@
> >  #ifndef _KVM_LINUX_BITOPS_H_
> >  #define _KVM_LINUX_BITOPS_H_
> >=20
> > -#include <bits/wordsize.h>
> > +#include <sys/reg.h> =20
>=20
> When cross-compiling on x86 for arm64, as well as when compiling natively=
 for
> arm64 I get this error:
>=20
> In file included from include/linux/bitmap.h:7,
>                  from util/find.c:4:
> include/linux/bitops.h:5:10: fatal error: sys/reg.h: No such file or dire=
ctory
>     5 | #include <sys/reg.h>
>       |          ^~~~~~~~~~~
> compilation terminated.
> make: *** [Makefile:510: util/find.o] Error 1
> make: *** Waiting for unfinished jobs....
> In file included from include/linux/bitmap.h:7,
>                  from util/bitmap.c:9:
> include/linux/bitops.h:5:10: fatal error: sys/reg.h: No such file or dire=
ctory
>     5 | #include <sys/reg.h>
>       |          ^~~~~~~~~~~
> compilation terminated.
> make: *** [Makefile:510: util/bitmap.o] Error 1
>=20
> Also, grep finds __WORDSIZE only in bits/wordsize.h on an x86 and arm64 m=
achine:

I wonder if __WORDSIZE (with two leading underscores!) is something
portable enough to be used in userland tools in the first place. The
kernel seems to use it, and that's where we inherited it from, I guess.
But since we only use it in one place (to define BITS_PER_LONG), can't we
just replace this there, with something based on "sizeof(long)"?
Looks cleaner anyway, since "word" is an overloaded term.

Cheers,
Andre

>=20
> $ grep -r "define __WORDSIZE" /usr/include/
> /usr/include/bits/wordsize.h:# define __WORDSIZE			64
> /usr/include/bits/wordsize.h:# define __WORDSIZE			32
> /usr/include/bits/wordsize.h:# define __WORDSIZE32_SIZE_ULONG	1
> /usr/include/bits/wordsize.h:# define __WORDSIZE32_PTRDIFF_LONG	1
> /usr/include/bits/wordsize.h:#define __WORDSIZE_TIME64_COMPAT32	0
>=20
>=20
> Thanks,
> Alex
>=20
> >=20
> >  #include <linux/kernel.h>
> >  #include <linux/compiler.h>
> >=20
> > --
> > 2.43.0
> >=20
> >  =20
>=20


