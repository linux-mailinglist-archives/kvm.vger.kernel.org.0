Return-Path: <kvm+bounces-41646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F08A6B3AE
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 05:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CEFC483114
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 04:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FFE61E990E;
	Fri, 21 Mar 2025 04:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="DVEpDhE+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74C1B664;
	Fri, 21 Mar 2025 04:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742531405; cv=none; b=Ue468iubYQA9UPxFSJ4Uu7lxzTIcRYrqWxp9+OCH1jaK9cgEwlj3z+A5WhA8htKnhUNx5vW/qM4LaqqRbIGgy8p/1PddCBBZT8/gBgSPpOnBZId17Zzjiq6hoOA0fvsGr5tvdCBwTx3X17K0XXLbD1CzKEIlPHIR48m2O15IHrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742531405; c=relaxed/simple;
	bh=K3uz40tk8l4FQvHosvvh3hDNWs8nec3XOBvNz8AMz6A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KWJYy6JsWg7t0dkchcM/ncUHkhNtVw78fd0cJoqsNLZglJUD6CST6g2G+cy1kC2Co1Y5KA/B6T+h7s/bcWKK7QoZglepcW7n3NSooK3+4CyGTUYBAh6fxnZdEkl1RwlDcODvdjIcFy/3VfjEFdGvYUcGC9+aOdwFClAlMgdaiO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=DVEpDhE+; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1742531397;
	bh=9LPlOVa7EM6+dhZWS2UYDtcUeCmZ1BJ3Bl4/7DTmRgg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DVEpDhE+fL2UmmQfJw5P5is/GrG4YuxFubvQ0Q0wxwSkYRtQHcHoJiVZJxNjNDtsx
	 02gaNKl2nL+yb4coNGY6n8Ps/U32T2k/vqUAgI00S6AsHEGy3z43maGl1TWwOJiMRQ
	 86e2UDR+8W5PW8lxqOOpHe4CRQvvSRVPmq7Y0oJ4DMEcqug0d7PV1G8ouGU7UGdtQ5
	 v0ifiUN2AfzTDvb1qjcwNVLPfvxqJCGuj/01wEVjzoPSAN3l2BKrdF/C1POsH+rPU3
	 jhM4yM3AoY7Hc9HX4GTKt7zsZVsk1jq89TwPcTPLfHYYzy+6NOpixCY/SaK5Uk7hsy
	 ibcgsKxRBKe0w==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4ZJqH84gNkz4wnp;
	Fri, 21 Mar 2025 15:29:56 +1100 (AEDT)
Date: Fri, 21 Mar 2025 15:29:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
 Douglas Anderson <dianders@chromium.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, KVM
 <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the arm64
 tree
Message-ID: <20250321152955.18426a1d@canb.auug.org.au>
In-Reply-To: <20250317171701.71c8677a@canb.auug.org.au>
References: <20250317171701.71c8677a@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/W=n.2.FLSeUV4GP3L4eaeWE";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/W=n.2.FLSeUV4GP3L4eaeWE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 17 Mar 2025 17:17:01 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the kvm-arm tree got a conflict in:
>=20
>   arch/arm64/kernel/proton-pack.c
>=20
> between commits:
>=20
>   e403e8538359 ("arm64: errata: Assume that unknown CPUs _are_ vulnerable=
 to Spectre BHB")
>   a5951389e58d ("arm64: errata: Add newer ARM cores to the spectre_bhb_lo=
op_affected() lists")
>=20
> from the arm64 tree and commit:
>=20
>   e3121298c7fc ("arm64: Modify _midr_range() functions to read MIDR/REVID=
R internally")
>=20
> from the kvm-arm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
>=20
> diff --cc arch/arm64/kernel/proton-pack.c
> index 0f51fd10b4b0,a573fa40d4b6..000000000000
> --- a/arch/arm64/kernel/proton-pack.c
> +++ b/arch/arm64/kernel/proton-pack.c
> @@@ -845,86 -845,52 +845,86 @@@ static unsigned long system_bhb_mitigat
>    * This must be called with SCOPE_LOCAL_CPU for each type of CPU, befor=
e any
>    * SCOPE_SYSTEM call will give the right answer.
>    */
>  -u8 spectre_bhb_loop_affected(int scope)
>  +static bool is_spectre_bhb_safe(int scope)
>  +{
>  +	static const struct midr_range spectre_bhb_safe_list[] =3D {
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A35),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A53),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A510),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A520),
>  +		MIDR_ALL_VERSIONS(MIDR_BRAHMA_B53),
>  +		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_2XX_SILVER),
>  +		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_3XX_SILVER),
>  +		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_SILVER),
>  +		{},
>  +	};
>  +	static bool all_safe =3D true;
>  +
>  +	if (scope !=3D SCOPE_LOCAL_CPU)
>  +		return all_safe;
>  +
> - 	if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_safe_list))
> ++	if (is_midr_in_range_list(spectre_bhb_safe_list))
>  +		return true;
>  +
>  +	all_safe =3D false;
>  +
>  +	return false;
>  +}
>  +
>  +static u8 spectre_bhb_loop_affected(void)
>   {
>   	u8 k =3D 0;
>  -	static u8 max_bhb_k;
>  =20
>  -	if (scope =3D=3D SCOPE_LOCAL_CPU) {
>  -		static const struct midr_range spectre_bhb_k32_list[] =3D {
>  -			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
>  -			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78AE),
>  -			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
>  -			MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
>  -			MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
>  -			MIDR_ALL_VERSIONS(MIDR_CORTEX_X2),
>  -			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
>  -			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
>  -			{},
>  -		};
>  -		static const struct midr_range spectre_bhb_k24_list[] =3D {
>  -			MIDR_ALL_VERSIONS(MIDR_CORTEX_A76),
>  -			MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
>  -			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
>  -			{},
>  -		};
>  -		static const struct midr_range spectre_bhb_k11_list[] =3D {
>  -			MIDR_ALL_VERSIONS(MIDR_AMPERE1),
>  -			{},
>  -		};
>  -		static const struct midr_range spectre_bhb_k8_list[] =3D {
>  -			MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
>  -			MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
>  -			{},
>  -		};
>  +	static const struct midr_range spectre_bhb_k132_list[] =3D {
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_X3),
>  +		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V2),
>  +	};
>  +	static const struct midr_range spectre_bhb_k38_list[] =3D {
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A715),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A720),
>  +	};
>  +	static const struct midr_range spectre_bhb_k32_list[] =3D {
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78AE),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_X2),
>  +		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
>  +		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
>  +		{},
>  +	};
>  +	static const struct midr_range spectre_bhb_k24_list[] =3D {
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A76),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A76AE),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
>  +		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
>  +		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_GOLD),
>  +		{},
>  +	};
>  +	static const struct midr_range spectre_bhb_k11_list[] =3D {
>  +		MIDR_ALL_VERSIONS(MIDR_AMPERE1),
>  +		{},
>  +	};
>  +	static const struct midr_range spectre_bhb_k8_list[] =3D {
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
>  +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
>  +		{},
>  +	};
>  =20
> - 	if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k132_list))
>  -		if (is_midr_in_range_list(spectre_bhb_k32_list))
>  -			k =3D 32;
>  -		else if (is_midr_in_range_list(spectre_bhb_k24_list))
>  -			k =3D 24;
>  -		else if (is_midr_in_range_list(spectre_bhb_k11_list))
>  -			k =3D 11;
>  -		else if (is_midr_in_range_list(spectre_bhb_k8_list))
>  -			k =3D  8;
>  -
>  -		max_bhb_k =3D max(max_bhb_k, k);
>  -	} else {
>  -		k =3D max_bhb_k;
>  -	}
> ++	if (is_midr_in_range_list(spectre_bhb_k132_list))
>  +		k =3D 132;
> - 	else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k38_list))
> ++	else if (is_midr_in_range_list(spectre_bhb_k38_list))
>  +		k =3D 38;
> - 	else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k32_list))
> ++	else if (is_midr_in_range_list(spectre_bhb_k32_list))
>  +		k =3D 32;
> - 	else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k24_list))
> ++	else if (is_midr_in_range_list(spectre_bhb_k24_list))
>  +		k =3D 24;
> - 	else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k11_list))
> ++	else if (is_midr_in_range_list(spectre_bhb_k11_list))
>  +		k =3D 11;
> - 	else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k8_list))
> ++	else if (is_midr_in_range_list(spectre_bhb_k8_list))
>  +		k =3D  8;
>  =20
>   	return k;
>   }

This is now a conflict between the kvm tree and the arm64 tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/W=n.2.FLSeUV4GP3L4eaeWE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmfc60MACgkQAVBC80lX
0Gx1KQf/QakLQJaI3LaakUKeYthZeFl4BCWmch4uy7UcxqvQTqqmwyFR61rE9cNn
V9D2H1hW4226U1Ms76XRp8ujypxWHgh7851QfyU36EY24fhrsHUSp3TTJu9vWAur
q3mpufSvqgDf7uLZQGPiaI28NLnHLyJCsSVcZuy6xUtFEPCGcrTOSZccOQtjXoKt
TlHk+oBTfBRUw0mLfAr/WXGl9D9Vh0BGZu2ftXIS9hnfhXGl3c+HPUWHlEMCVFnK
1yGQP4p+wvP1nPUsKn/AMmyaGefS0Fc4dCU0UCC4BUDLeQcNmvfrf7zbdpcSy39i
Y+2ou91gQSPFLksK4bXItdLFtpB0Sw==
=QH2I
-----END PGP SIGNATURE-----

--Sig_/W=n.2.FLSeUV4GP3L4eaeWE--

