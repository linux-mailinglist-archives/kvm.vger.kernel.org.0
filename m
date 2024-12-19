Return-Path: <kvm+bounces-34142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7203F9F7A46
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 12:22:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 928537A4E7D
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 11:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30F0223C4C;
	Thu, 19 Dec 2024 11:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="bq7NSf9U"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zeus03.de (zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBCD22146C
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 11:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734607306; cv=none; b=MCfrUe7c07Ph0PYZBneey14jKmt4D3u0qJ7gbCK13t6Ov/4oLXPu8yqOOIf8OQh54uO8IP++VpXiXAN9wKlShGMhuCuSO0n1RDUQr0YRLpgEiiDEgPCS0ao5MrQDmrzNZCJ3lCWDXof9yQvfWJfLJZ7p21BjfPfkQf2lSzLihVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734607306; c=relaxed/simple;
	bh=og3bxqkl6A2sUuc2XQTD2nz9L7b5HVspSYCy+EAH59M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STH1CsK9o9y2eDooSIaqICggW/BI7i4rKIFiiLdwFISRKUfspfv5borXItCNIACes6Hq4qyKOKe/b3j0r0pjcyKwp+yWZjCixntOS/u652+EGIEM+JqwGu1Ny7eeTew5PVLp29C7rTO64RH+n2obVc8v/fo+mk8AtdGgt2TUK6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=bq7NSf9U; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=date:from:to:cc:subject:message-id
	:references:mime-version:content-type:in-reply-to; s=k1; bh=VYKy
	amdsuIeuxGPUqFPAGVbzAqPu7W0X+5ZSU0lQyuU=; b=bq7NSf9UMH4NV/ENEh9y
	9Y7plcrlm/PE9Ky15Hw4N3nps4ztYK6CanxBfp7c1OPo7xsY4fAOul+ElpaCJ3y3
	7CgAT709cqADi4k2k2iALLhN3wcwlP3wGfQ0T+VMcaDD1qi/lXaUiO+GYpHQdSzL
	drM5iy5sa2QzDsMZbRfIDdvf0xFy0xRJS3iu7JK6jQCxvn8jh/aKRmLA+OsCP6A0
	WeQU5Or+ornfWZ9NiycCLCuq29TViEYBzZWjcheAgT3b/aruHHF34S1SFOcPFD9Z
	6YRPl+8HpYr/uq3WU//6LWOTt/FrChVT9axAG+EVPUpMko8xruq0IIMCecqKRCc5
	RQ==
Received: (qmail 649199 invoked from network); 19 Dec 2024 12:21:32 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 19 Dec 2024 12:21:32 +0100
X-UD-Smtp-Session: l3s3148p1@LWJ4u50pZo8gAwDPXwAQAA/MfjDm1Sk8
Date: Thu, 19 Dec 2024 12:21:31 +0100
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] KVM: VMX: don't include '<linux/find.h>' directly
Message-ID: <Z2QBu4qIsJERcbHF@shikoro>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <20241217070539.2433-2-wsa+renesas@sang-engineering.com>
 <Z2Goxx27WL-G-13y@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Lz7/8WUBvPzVMeRB"
Content-Disposition: inline
In-Reply-To: <Z2Goxx27WL-G-13y@google.com>


--Lz7/8WUBvPzVMeRB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2024 at 08:37:27AM -0800, Sean Christopherson wrote:
> +Yury and Rasmus
>=20
> On Tue, Dec 17, 2024, Wolfram Sang wrote:
> > The header clearly states that it does not want to be included directly,
>=20
> I definitely don't object to the KVM change, but the if y'all expect deve=
lopers
> to actually honor the "rule", it needs to have teeth.  As evidenced by a =
similar
> rule in arch/x86/include/asm/bitops.h that also gets ignored, an #error t=
hat's
> buried under an include guard and triggers on a macro that's never #undef=
'd is
> quite useless.

To follow up, I am willing to do the proposed change. But before sending
this out, it would be nice if the existing broken includes would be
fixed. So, can this patch be applied first?


--Lz7/8WUBvPzVMeRB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmdkAbgACgkQFA3kzBSg
KbbcuA/+P8GZIsARGnJ/fg/J8q1So5PbMPIOPkQasYlmgcplWOZ6V8HCJwOvz8wr
VaQSArBBL/ahfcOxIaFjlhvdfc621yJAIMrplOTauAR20v/qvqNafYBd0sWl/g47
cAu+wy+l1mi7rXaGyDqU6sC9sRS+QJpZ7mJl3o9aQ50x8YSqn1Y3RDn27gHTdgd1
6tqWbfe9Jaw+G/58J5liDlQpz6fveX1GlVl0E4k8YiZ7XDlBBnScmPWQ6DkcKcwx
GAs8jRnOoEsXqfWj0Ef9GhUPtg0JL8T/wV01SoRX9TrSOZf81zkFo03uTyxm2XlE
zlViO9lr3lni+2t7Bf31exwkZ48D7GtJrnUNnFwKADBmIvgeubEMjy4pHfBy+S3p
JK70hrU4mbeOxqZ1zQbgGUwF0g+q+KP4Si8M0N/rPOdKtO18G7xrdQM2T5RCY3iS
hfmRltS78rZBUOnX41lOp189LkyN3E0msbwlS4ImPEZVscbtuhGlbGMK4/1ag+u9
2xN0WIezKF1qkpeYgOF6MZ9HzqexYoUSfhQ6ln7VZBLcJKfVOSP/27a8+K9LneN+
cyi4eL0ZIy0cFaSTc4SSVWxWVGfDwmNM06OcLe5vSrOpXL0vaYjqZWwJhbU/SODI
3Sy+8c/budV6XYKFgTH+tdwQPnNrvL8oXUGMqXy9M6h9k2sifRQ=
=uGQR
-----END PGP SIGNATURE-----

--Lz7/8WUBvPzVMeRB--

