Return-Path: <kvm+bounces-65256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 66EFACA2654
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 06:11:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4989830263C1
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 05:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1121305E0C;
	Thu,  4 Dec 2025 05:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Ih//AM08"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AD92D5936;
	Thu,  4 Dec 2025 05:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764825070; cv=none; b=C59hBNZv7X25sgxJzXwgtU31E5rY7st5q1reEwXh/hHKG91aGf4jJyu7EePGNoaQ0WVke7A0pY0/3sp9TBYI0elfJZ2MTlXOVxU6Z3W1DbvTrS4MiOJFALt0r5by4/oI0RTconEMcWboWK7rrsIKr81UktQ9WA6N4XfS0QbUpMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764825070; c=relaxed/simple;
	bh=raE1n6aHvpPE/BqH7V5O/ukjjUc39LJXpaXiCigSCmQ=;
	h=Date:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fm7W7QDK3bqEiXZM9GQGSvmwsBPJvJ+cgY9ZIPIllo7BV2rNLQRcOVzZdP2Ve7z0dVmN2/dx9OlfxoBN6xPM1DsF24v1UKaZxW9g2ZFklcEKn1kbg+d5xHXZR25mqqyxKZuZRbp3hL5KZbQq35pUIVJf840Pzj3N0s3KMOrdrgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=Ih//AM08; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1764825061;
	bh=kT8QF29+xj9Av+QqCECDWufefm28EVgkxRDqz07AdsY=;
	h=Date:From:Cc:Subject:In-Reply-To:References:From;
	b=Ih//AM08TZUG5Fdy7LmikIbszJpsgWvsMqIiD3YAZh22PjEce1S8gi2pwOKy7wO6W
	 KlOlnxyMnRgzdggPxHtx5WYDD+zYa3KJGTRUtOGBX6CNka+1rMw6r8m9hVBdTVjE9n
	 /Lj58nykUPL5Wg00Dr5ucMqTmvF9HduEvxTaMvqHvuReWQ5qx3Gr17hrHhypeDhJSr
	 6MdfI+z2qzdb07RncgHoCwvejfkSHcypdKPNrb1gu4W6c2asV23bxFdqgI4xgvpZtR
	 xRhunld8YJoiJLNPJpKP2cryl0smf6jK63flmpi5tuJk0uNh4/i4Dgl+jgvfjDphoT
	 Yf5qlLYQ+nlYg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4dMMzR0Y1Bz4w0Q;
	Thu, 04 Dec 2025 16:10:58 +1100 (AEDT)
Date: Thu, 4 Dec 2025 16:10:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Babu Moger
 <babu.moger@amd.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Elena Reshetova <elena.reshetova@intel.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, "Naveen N Rao (AMD)"
 <naveen@kernel.org>, Borislav Petkov <bp@alien8.de>, Paolo Bonzini
 <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-x86 tree with the tip tree
Message-ID: <20251204161058.137028db@canb.auug.org.au>
In-Reply-To: <20251125155953.01b486f2@canb.auug.org.au>
References: <20251125155953.01b486f2@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.zn7zffts7T_xquH9AIsFQ0";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/.zn7zffts7T_xquH9AIsFQ0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 25 Nov 2025 15:59:53 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the kvm-x86 tree got a conflict in:
>=20
>   arch/x86/include/asm/cpufeatures.h
>=20
> between commits:
>=20
>   6ffdb49101f0 ("x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN feature =
flag")
>   3767def18f4c ("x86/cpufeatures: Add support for L3 Smart Data Cache Inj=
ection Allocation Enforcement")
>=20
> from the tip tree and commits:
>=20
>   5d0316e25def ("x86/cpufeatures: Add X86_FEATURE_X2AVIC_EXT")
>   f6106d41ec84 ("x86/bugs: Use an x86 feature to track the MMIO Stale Dat=
a mitigation")
>=20
> from the kvm-x86 tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc arch/x86/include/asm/cpufeatures.h
> index d90ce601917c,646d2a77a2e2..000000000000
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@@ -503,9 -500,12 +504,15 @@@
>   #define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to=
-userspace, see VMSCAPE bug */
>   #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring=
 Counters */
>   #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructi=
ons */
>  -#define X86_FEATURE_X2AVIC_EXT		(21*32+17) /* AMD SVM x2AVIC support fo=
r 4k vCPUs */
>  -#define X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO (21*32+18) /*
>  +#define X86_FEATURE_SGX_EUPDATESVN	(21*32+17) /* Support for ENCLS[EUPD=
ATESVN] instruction */
>  +
>  +#define X86_FEATURE_SDCIAE		(21*32+18) /* L3 Smart Data Cache Injection=
 Allocation Enforcement */
> ++#define X86_FEATURE_X2AVIC_EXT		(21*32+19) /* AMD SVM x2AVIC support fo=
r 4k vCPUs */
> ++#define X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO (21*32+20) /*
> + 						      * Clear CPU buffers before VM-Enter if the vCPU
> + 						      * can access host MMIO (ignored for all intents
> + 						      * and purposes if CLEAR_CPU_BUF_VM is set).
> + 						      */
>  =20
>   /*
>    * BUG word(s)

This is now a conflict between the kvm tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/.zn7zffts7T_xquH9AIsFQ0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmkxF+IACgkQAVBC80lX
0Gwi9wgAg2/y5O7M5ClPB53nvv98mx39hI9rnNEl+M6AWwMtYmRBKCXKPet0U3F6
uGMaMdQDa43gEV13OjQSlA5tCYtW/d1p+eo2Im0hNPFB5mrWe4M5PjjOWcQHdc0Z
st1HV1Ip4wF+9y1unlppJwq6SRFZK4FF1inpTSbQNLm6J/y/x38ZlHASk0136vWH
GcqAZCwBsARmQ0CMTcSMkgQvv1PWMACGjHexH5OVYBQY8Ji2izdHj0ta8F+8/7GI
yXeiYYkn4mu9H34YWdDHEuYWGXYcX0qMDf3kwC5uiC0qp4di9XtJGP7hJ2mbsZuv
bS97ZMRSILT0kXWZxPuCoFhopzjr+w==
=b3tP
-----END PGP SIGNATURE-----

--Sig_/.zn7zffts7T_xquH9AIsFQ0--

