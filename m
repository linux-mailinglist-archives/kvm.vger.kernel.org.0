Return-Path: <kvm+bounces-9356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB0FD85F046
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 04:59:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8723E285BC0
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 03:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1791775E;
	Thu, 22 Feb 2024 03:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="WC+T892F"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECC3FBF2;
	Thu, 22 Feb 2024 03:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708574335; cv=none; b=ibSjauyWTXjqWBcv2e3hUtLw2JtGHWVL9YTLSqF6TglxywmOwTsHxf9bKpkl2xXjkulN99RlPomMXi3QWjanVuteHK+mQf0RaeayCGPu2mH9poorUJz0tjWIRZKF9TtQxyqZEtSYga3Y05a86uc/XX8mHI2oFNbV7LvCgDSUhow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708574335; c=relaxed/simple;
	bh=+p4ZKVjWl5lZooQvNzTz/nwRMpvJy45X7Bqh4CNH1JA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=JKcVg131PdR6XBcgZtS+gfq2XBmB99LPvJeL/QyVErB9PIFvixpTJmIRIwjrm3E+tL00gvmUcwhRlYSKiJfWq/VvZoj+4ZOy7C1N3YAIvyziPyNOhK2BIqvix5EidfqehNRR4vYs2R8U5dIm8XHs2DWY0e688BFEB4Nm2bVahkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=WC+T892F; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1708574324;
	bh=emV0MkgJME9zlEcVVPyA53ouLSsHaJyiSI9ys/B7uzw=;
	h=Date:From:To:Cc:Subject:From;
	b=WC+T892FO1v5FRGYWML2pkV/JGvBkjWNxWHVFw0JaF4BykGV0Fjuce34YLjlQoXny
	 N7E8w9PbFEvG9JFTT6AI2hdK9+G7/SmGTJupNoPidnfbqu9nWxxnATXDZKzBBMKCAT
	 ImX8/ubTQq4a3IYmge6NHibJkGg7PIzrlEXW2STT49/82sAo7Oo+lA7+P1EjafmtU8
	 rGu53vaEr4N+nAezJMI8U5mT0//y2XLVuvWLnMD2/wwrqF8fD3gw5LjdAp26H0z2u8
	 lhF3HFv5uPW/XzICtrPX/hRwq1vZ3T1uSZ6R5JaQVden25O+CErPRlA5f6V1UcZoO6
	 wokwWE4QCBgZQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TgKBW3gDPz4wb2;
	Thu, 22 Feb 2024 14:58:43 +1100 (AEDT)
Date: Thu, 22 Feb 2024 14:58:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, Lucas De Marchi
 <lucas.demarchi@intel.com>, Oded Gabbay <ogabbay@kernel.org>, Thomas
 =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>
Cc: DRM XE List <intel-xe@lists.freedesktop.org>, KVM <kvm@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, Yury Norov
 <yury.norov@gmail.com>
Subject: linux-next: manual merge of the kvm tree with the drm-xe tree
Message-ID: <20240222145842.1714b195@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ikOHUZBlsvlN1FF4nRb3mHW";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/ikOHUZBlsvlN1FF4nRb3mHW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  include/linux/bits.h

between commits:

  b77cb9640f1f ("bits: introduce fixed-type genmasks")
  34b80df456ca ("bits: Introduce fixed-type BIT")

from the drm-xe tree and commit:

  3c7a8e190bc5 ("uapi: introduce uapi-friendly macros for GENMASK")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/bits.h
index 811846ce110e,0eb24d21aac2..000000000000
--- a/include/linux/bits.h
+++ b/include/linux/bits.h
@@@ -4,10 -4,9 +4,11 @@@
 =20
  #include <linux/const.h>
  #include <vdso/bits.h>
+ #include <uapi/linux/bits.h>
  #include <asm/bitsperlong.h>
 =20
 +#define BITS_PER_TYPE(type)	(sizeof(type) * BITS_PER_BYTE)
 +
  #define BIT_MASK(nr)		(UL(1) << ((nr) % BITS_PER_LONG))
  #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
  #define BIT_ULL_MASK(nr)	(ULL(1) << ((nr) % BITS_PER_LONG_LONG))
@@@ -33,42 -29,11 +34,42 @@@
   * disable the input check if that is the case.
   */
  #define GENMASK_INPUT_CHECK(h, l) 0
 +#define BIT_INPUT_CHECK(type, b) 0
  #endif
 =20
 -#define GENMASK(h, l) \
 -	(GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
 -#define GENMASK_ULL(h, l) \
 -	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_ULL(h, l))
 +/*
 + * Generate a mask for the specified type @t. Additional checks are made =
to
 + * guarantee the value returned fits in that type, relying on
 + * shift-count-overflow compiler check to detect incompatible arguments.
 + * For example, all these create build errors or warnings:
 + *
 + * - GENMASK(15, 20): wrong argument order
 + * - GENMASK(72, 15): doesn't fit unsigned long
 + * - GENMASK_U32(33, 15): doesn't fit in a u32
 + */
- #define __GENMASK(t, h, l) \
++#define ___GENMASK(t, h, l) \
 +	(GENMASK_INPUT_CHECK(h, l) + \
 +	 (((t)~0ULL - ((t)(1) << (l)) + 1) & \
 +	 ((t)~0ULL >> (BITS_PER_TYPE(t) - 1 - (h)))))
 +
- #define GENMASK(h, l)		__GENMASK(unsigned long,  h, l)
- #define GENMASK_ULL(h, l)	__GENMASK(unsigned long long, h, l)
- #define GENMASK_U8(h, l)	__GENMASK(u8,  h, l)
- #define GENMASK_U16(h, l)	__GENMASK(u16, h, l)
- #define GENMASK_U32(h, l)	__GENMASK(u32, h, l)
- #define GENMASK_U64(h, l)	__GENMASK(u64, h, l)
++#define GENMASK(h, l)		___GENMASK(unsigned long,  h, l)
++#define GENMASK_ULL(h, l)	___GENMASK(unsigned long long, h, l)
++#define GENMASK_U8(h, l)	___GENMASK(u8,  h, l)
++#define GENMASK_U16(h, l)	___GENMASK(u16, h, l)
++#define GENMASK_U32(h, l)	___GENMASK(u32, h, l)
++#define GENMASK_U64(h, l)	___GENMASK(u64, h, l)
 +
 +/*
-  * Fixed-type variants of BIT(), with additional checks like __GENMASK().=
  The
++ * Fixed-type variants of BIT(), with additional checks like ___GENMASK()=
.  The
 + * following examples generate compiler warnings due to shift-count-overf=
low:
 + *
 + * - BIT_U8(8)
 + * - BIT_U32(-1)
 + * - BIT_U32(40)
 + */
 +#define BIT_U8(b)		((u8)(BIT_INPUT_CHECK(u8, b) + BIT(b)))
 +#define BIT_U16(b)		((u16)(BIT_INPUT_CHECK(u16, b) + BIT(b)))
 +#define BIT_U32(b)		((u32)(BIT_INPUT_CHECK(u32, b) + BIT(b)))
 +#define BIT_U64(b)		((u64)(BIT_INPUT_CHECK(u64, b) + BIT(b)))
 =20
  #endif	/* __LINUX_BITS_H */

--Sig_/ikOHUZBlsvlN1FF4nRb3mHW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmXWxnIACgkQAVBC80lX
0GyLjQgAm6+l36vr//Nbkn+sd1Ov5uGVFWeFODu5hfsKFwUMBCEhqQtS3RbnD5Ea
vLgm1TIuNZaHdSRloymHtrRt+A46BHnNqxzVGjRsNCw2DkXXJuI9tOBpgagLbU8i
o1veOF74FBWjk/oJrNZ2ZzSETLKh7NzXLrOEJL/iDoUSp+8mOMCSi0D/Dplzn4J7
5mYu1V0UFFeJcXRDOS+bujcmmLv9XqpT/NcwWoj1kS6TlqULrvSIXt3vDG808osT
UMz7l2zFx2gvu1rvpxNwY9bgucK1M1pSyBwHAZNEdmGKLR4iVN/BiXOXt0w8zKHr
cm75A3NyEJIYIweJZbWGUNjVWKDrZw==
=p2KP
-----END PGP SIGNATURE-----

--Sig_/ikOHUZBlsvlN1FF4nRb3mHW--

