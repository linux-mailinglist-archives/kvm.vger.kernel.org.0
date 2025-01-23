Return-Path: <kvm+bounces-36319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E30A19D40
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 04:26:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1394D7A2C64
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 03:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776F77082E;
	Thu, 23 Jan 2025 03:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="rX6Lxwj9"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F51B1BC3F;
	Thu, 23 Jan 2025 03:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602770; cv=none; b=eiIzfY+IYU8oFh0EcUNYC6mn3llZor/HHVqzo7XJC031sFcUOTePJYPDWAE2rcETguxJuTu48Gc1O8MKl8n8jQaJ9RsgJmDVG0tDexs8mZjA4MV4RogaqXuUE9jssNK6NL0CTjhtNGzA9XgCVWhRhsDGx4Lo6fufXoeuNcxtim4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602770; c=relaxed/simple;
	bh=NW3KQOc3AD0L9fmRbl6c11MEcyiYy9146An3JPau5ic=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CKEi9R8+9bgix97KeBWdTZmNw14UQU6xcnCIlIYKnl+DoCpn+rsAEHHGGRBNdIwziVQ0262OxaIfLt1iNDebRXGscb3T5ULygPL9SGASzaxjnobajKcBtX185grQEbfvPkvqzatSgIY2WeQUvmwVnzejEhoxrV4kA5J1I9lROK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=rX6Lxwj9; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1737602747;
	bh=MBvyQpr2bYhEtUSEXDN1il1fD7Xgx4lIrndP8tj/bGg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rX6Lxwj9FItpxDyjo08oi8ZCa1PTKeaAe+KthhM94SiVJvYsZ+N+xd4TwK1D1EL3m
	 FMRsbajQAGY4sFLaEUFJ5hV8syjsdOOw/YejqA+tu6KMwTleEOgb4RqYi6xBNWJgd4
	 U10FPvygAWW341fCGR/DowEQKXVMKYh/JspNOddL7ouTTP3hrRMiUCr4xvMoL45s57
	 zoNPMsYTFsmOow49hf/FYf9ttSziXK97ri71B7O2JIyQJy2uDzQx6i2UvFvhSwetx4
	 mh6i5nhG2A3BXWlBb+wgjGzI3x5he7xoLmRMXUKbCWJG1OfWl/+Iu2hCTH7+syT67K
	 4SkyKU6vroq7Q==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4YdmYQ1bz6z4x2c;
	Thu, 23 Jan 2025 14:25:46 +1100 (AEDT)
Date: Thu, 23 Jan 2025 14:25:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
 <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, "Borislav Petkov
 (AMD)" <bp@alien8.de>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-x86 tree with the tip tree
Message-ID: <20250123142553.12c76c11@canb.auug.org.au>
In-Reply-To: <20250106150509.19432acd@canb.auug.org.au>
References: <20250106150509.19432acd@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TfFFt7RpZgjcPYI.qENiH2n";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/TfFFt7RpZgjcPYI.qENiH2n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 6 Jan 2025 15:05:09 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the kvm-x86 tree got a conflict in:
>=20
>   arch/x86/kvm/cpuid.c
>=20
> between commit:
>=20
>   716f86b523d8 ("KVM: x86: Advertise SRSO_USER_KERNEL_NO to userspace")
>=20
> from the tip tree and commits:
>=20
>   ccf93de484a3 ("KVM: x86: Unpack F() CPUID feature flag macros to one fl=
ag per line of code")
>   3cc359ca29ad ("KVM: x86: Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init(=
)")
>   75c489e12d4b ("KVM: x86: Add a macro for features that are synthesized =
into boot_cpu_data")
>   871ac338ef55 ("KVM: x86: Use only local variables (no bitmask) to init =
kvm_cpu_caps")
>=20
> from the kvm-x86 tree.
>=20
> I fixed it up (I think - see below) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc arch/x86/kvm/cpuid.c
> index f7e222953cab,edef30359c19..000000000000
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@@ -808,50 -1134,72 +1134,73 @@@ void kvm_set_cpu_caps(void
>   	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
>   		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>  =20
> - 	/*
> - 	 * Hide all SVM features by default, SVM will set the cap bits for
> - 	 * features it emulates and/or exposes for L1.
> - 	 */
> - 	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
> -=20
> - 	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
> - 		0 /* SME */ | 0 /* SEV */ | 0 /* VM_PAGE_FLUSH */ | 0 /* SEV_ES */ |
> - 		F(SME_COHERENT));
> -=20
> - 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
> - 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
> - 		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
> - 		F(WRMSR_XX_BASE_NS) | F(SRSO_USER_KERNEL_NO)
> + 	/* All SVM features required additional vendor module enabling. */
> + 	kvm_cpu_cap_init(CPUID_8000_000A_EDX,
> + 		VENDOR_F(NPT),
> + 		VENDOR_F(VMCBCLEAN),
> + 		VENDOR_F(FLUSHBYASID),
> + 		VENDOR_F(NRIPS),
> + 		VENDOR_F(TSCRATEMSR),
> + 		VENDOR_F(V_VMSAVE_VMLOAD),
> + 		VENDOR_F(LBRV),
> + 		VENDOR_F(PAUSEFILTER),
> + 		VENDOR_F(PFTHRESHOLD),
> + 		VENDOR_F(VGIF),
> + 		VENDOR_F(VNMI),
> + 		VENDOR_F(SVME_ADDR_CHK),
>   	);
>  =20
> - 	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
> - 	kvm_cpu_cap_check_and_set(X86_FEATURE_IBPB_BRTYPE);
> - 	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_NO);
> -=20
> - 	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0022_EAX,
> - 		F(PERFMON_V2)
> + 	kvm_cpu_cap_init(CPUID_8000_001F_EAX,
> + 		VENDOR_F(SME),
> + 		VENDOR_F(SEV),
> + 		/* VM_PAGE_FLUSH */
> + 		VENDOR_F(SEV_ES),
> + 		F(SME_COHERENT),
> + 	);
> +=20
> + 	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
> + 		F(NO_NESTED_DATA_BP),
> + 		/*
> + 		 * Synthesize "LFENCE is serializing" into the AMD-defined entry
> + 		 * in KVM's supported CPUID, i.e. if the feature is reported as
> + 		 * supported by the kernel.  LFENCE_RDTSC was a Linux-defined
> + 		 * synthetic feature long before AMD joined the bandwagon, e.g.
> + 		 * LFENCE is serializing on most CPUs that support SSE2.  On
> + 		 * CPUs that don't support AMD's leaf, ANDing with the raw host
> + 		 * CPUID will drop the flags, and reporting support in AMD's
> + 		 * leaf can make it easier for userspace to detect the feature.
> + 		 */
> + 		SYNTHESIZED_F(LFENCE_RDTSC),
> + 		/* SmmPgCfgLock */
> + 		F(NULL_SEL_CLR_BASE),
> + 		F(AUTOIBRS),
> + 		EMULATED_F(NO_SMM_CTL_MSR),
> + 		/* PrefetchCtlMsr */
> + 		F(WRMSR_XX_BASE_NS),
> ++		F(SRSO_USER_KERNEL_NO),
> + 		SYNTHESIZED_F(SBPB),
> + 		SYNTHESIZED_F(IBPB_BRTYPE),
> + 		SYNTHESIZED_F(SRSO_NO),
> + 	);
> +=20
> + 	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
> + 		F(PERFMON_V2),
>   	);
>  =20
> - 	/*
> - 	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
> - 	 * KVM's supported CPUID if the feature is reported as supported by the
> - 	 * kernel.  LFENCE_RDTSC was a Linux-defined synthetic feature long
> - 	 * before AMD joined the bandwagon, e.g. LFENCE is serializing on most
> - 	 * CPUs that support SSE2.  On CPUs that don't support AMD's leaf,
> - 	 * kvm_cpu_cap_mask() will unfortunately drop the flag due to ANDing
> - 	 * the mask with the raw host CPUID, and reporting support in AMD's
> - 	 * leaf can make it easier for userspace to detect the feature.
> - 	 */
> - 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
> - 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
>   	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>   		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
> - 	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
>  =20
> - 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
> - 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
> - 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
> - 		F(PMM) | F(PMM_EN)
> + 	kvm_cpu_cap_init(CPUID_C000_0001_EDX,
> + 		F(XSTORE),
> + 		F(XSTORE_EN),
> + 		F(XCRYPT),
> + 		F(XCRYPT_EN),
> + 		F(ACE2),
> + 		F(ACE2_EN),
> + 		F(PHE),
> + 		F(PHE_EN),
> + 		F(PMM),
> + 		F(PMM_EN),
>   	);
>  =20
>   	/*

This is now a conflict between the kvm tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/TfFFt7RpZgjcPYI.qENiH2n
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmeRtsEACgkQAVBC80lX
0Gzqywf+NjZBx64y4Cm+R6ICuj7zQYhrqzyiCUIE2jpENvtAx31a81SsZmrAj1P5
X4OcDF4pNI5C/XVOb6wEmL+OWjt7c4VwzYiwdrJKtTnuouLCtFl19gFHR8cDLO6u
274U9B1Siz5KYZbT3T0Nv8sToG/ukOJpjKQnRYNDreAwORydF132mPHYnutqBZcM
+A1hV4TaYWNtnA8Jq/+HhPdyWisgFAlhiUHJ4063TKpSxrv/qJTEFrcnZrY7ohhV
Bpr5sl5mY3lRjvmhjyf82OW3mEnYm6MAUyfF3ir9aLC4wd39v5o8ArE5kczi18ps
/fbktbPclC1TjV7sJ2RrxMuMxtodDg==
=F/Ca
-----END PGP SIGNATURE-----

--Sig_/TfFFt7RpZgjcPYI.qENiH2n--

