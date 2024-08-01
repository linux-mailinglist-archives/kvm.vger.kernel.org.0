Return-Path: <kvm+bounces-22990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F049694531C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 21:07:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E97B1C22FA6
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 19:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464CD149003;
	Thu,  1 Aug 2024 19:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JOe4CT0W"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B03813C832;
	Thu,  1 Aug 2024 19:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722539243; cv=none; b=qBV6w4rdMbVUXV5pThXXmT6gnq22XXWASQvYkXJEPn1HRyzkZlngaRNd6fDifpZvG/mxOjH48Kro8DDafSCnSIcrxPVkox4t9getI6yXSHv0cJ0lwNHYgzoAVBiLl/23XZTR49A8VBs+jIzcQlRR8qQbZP/C9V0brXMK3xPtnj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722539243; c=relaxed/simple;
	bh=tNpnTWvsIE5V07rG1mHukfAwFOGjd+/BGaRx9L1/i/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4icCE57czfJX413cmbQLmWRSh1aGo1lTf0g8HoAUAkIi4FO9qq8jOw7UeRrMWB8qmhpiszW/xrFQIxuIRLypjazAR5e/UyIYh4UGvVhaC0Qxy7iuQheBodnC2xokEa/opUOIyEAzusp5umBGlwqWPO7WCS7BnXhax/3ID5inas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JOe4CT0W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8851C32786;
	Thu,  1 Aug 2024 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722539243;
	bh=tNpnTWvsIE5V07rG1mHukfAwFOGjd+/BGaRx9L1/i/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JOe4CT0W01q2w4wLUfsdxMf1BBG2SO168tpPxZrox6sq6Zvo7LYRQBZDOi6Qug42a
	 hD5YvP9BVhgwlctCItX5VjCnPBhuaSQaS/GU8rTvbcUomC5nfm6RsxErVNYNkWpiCi
	 FSHQZi5WphGaEqt8pZ0/No6U9LZbVEEnduMwGV2PsaroucKXFIhRKRQepxD1GrH+Sr
	 /t438cxdYVPNgrNQzUhkVJGZgtSdmGTjIqIph2QgijyX5wtBRhevO3nYI2pDyDhfq4
	 MPpPdR1ASiiuBL3JsWBvOcUj0OvwbU9SaJhS1pUhMEPBarKn+Wz28aMCVzosZSWBGg
	 Um1eYy2fKNKEg==
Date: Thu, 1 Aug 2024 20:07:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH v2 4/8] KVM: arm64: Add save/restore support for FPMR
Message-ID: <1a00165f-7ae5-4c58-9283-836716205db7@sirena.org.uk>
References: <20240801091955.2066364-1-maz@kernel.org>
 <20240801091955.2066364-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UP17P9dMGGZrnuYZ"
Content-Disposition: inline
In-Reply-To: <20240801091955.2066364-5-maz@kernel.org>
X-Cookie: Be cautious in your daily affairs.


--UP17P9dMGGZrnuYZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 01, 2024 at 10:19:51AM +0100, Marc Zyngier wrote:

> index 6af179c6356d..2466dd231362 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -198,6 +198,15 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
>  	} else {
>  		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
>  	}
> +
> +	if (kvm_has_fpmr(vcpu->kvm)) {

nVHE is faulting for me, apparently on the kvm_has_fpmr() check though I
ran out of time to actually figure out where exactly it is going wrong.
I'll have a further poke tomorrow.  Backtrace below.

> +		u64 fpmr = read_sysreg_s(SYS_FPMR);
> +
> +		if (unlikely(is_protected_kvm_enabled()))
> +			*host_data_ptr(fpmr) = fpmr;

That looks wrong until you remember what host_data_ptr() does but but
it's actually fine.  host_data_ptr() is looking inside the struct
kvm_host_data for the CPU rather than referencing the locally defined
variable fpmr here.  I do think it's worth avoiding the name collision
though, perhaps just avoid the temporary variable?

[ 1610.219274][  T247] kvm [247]: nVHE hyp panic at: [<ffffffc080ce3fc8>] __kvm_
nvhe_$x.262+0x24/0x38!
[ 1610.219435][  T247] kvm [247]: nVHE call trace:
[ 1610.219509][  T247] kvm [247]:  [<ffffffc080ce3c2c>] __kvm_nvhe_hyp_panic+0xb
4/0xf8
[ 1610.219657][  T247] kvm [247]:  [<ffffffc080ce3df4>] __kvm_nvhe_$x.238+0x14/0x60
[ 1610.219803][  T247] kvm [247]:  [<ffffffc080ce33f8>] __kvm_nvhe_$x.88+0x24/0x23c
[ 1610.219942][  T247] kvm [247]:  [<ffffffc080ce64b4>] __kvm_nvhe_$x.26+0x8/0x2c
[ 1610.220080][  T247] kvm [247]:  [<ffffffc080ce617c>] __kvm_nvhe_$x.1+0x9c/0xa4
[ 1610.220216][  T247] kvm [247]:  [<ffffffc080ce50fc>] __kvm_nvhe___skip_pauth_save+0x4/0x4
[ 1610.220356][  T247] kvm [247]: ---[ end nVHE call trace ]---
[ 1610.220435][  T247] kvm [247]: Hyp Offset: 0xffffff807fe00000
[ 1610.220566][  T247] Kernel panic - not syncing: HYP panic:
[ 1610.220566][  T247] PS:1624023c9 PC:0000004000ee3fc8 ESR:0000000096000004
[ 1610.220566][  T247] FAR:ffffff880115cd1c HPFAR:0000000000000000 PAR:1d00007edbadc8de
[ 1610.220566][  T247] VCPU:0000004801e88000
[ 1610.220743][  T247] CPU: 0 UID: 0 PID: 247 Comm: kvm-vcpu-0 Not tainted 6.11.0-rc1+ #247
[ 1610.220878][  T247] Hardware name: FVP Base RevC (DT)
[ 1610.220958][  T247] Call trace:
[ 1610.221023][  T247]  dump_backtrace+0xfc/0x140
[ 1610.221132][  T247]  show_stack+0x24/0x38
[ 1610.221239][  T247]  dump_stack_lvl+0x3c/0x118
[ 1610.221358][  T247]  dump_stack+0x18/0x40
[ 1610.221474][  T247]  panic+0x134/0x368
[ 1610.221609][  T247]  nvhe_hyp_panic_handler+0x114/0x1a0
[ 1610.221758][  T247]  kvm_arm_vcpu_enter_exit+0x54/0xc0
[ 1610.221895][  T247]  kvm_arch_vcpu_ioctl_run+0x494/0xa28

--UP17P9dMGGZrnuYZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmar3OQACgkQJNaLcl1U
h9BxZAf/eG0DRkq8+lSJZn2eZWw79ujhY7MpdW3KaE5Zr7PwbXf5Y2/ht28j3E0y
A7IhKlj9Ya2brKHhfRNKb6DU45qH3yP3alB+DIEgkCWEUePTrcEbD0ZShKRFpfMI
NeFnXxD0aoiqha6DTn/H60uS3k88GmGkfaOoz7n/ZegXXypLc86uIvBLHDH7GlqY
+Q7qrjbRdwTeNQYoFuDHA6CEQY3K/LLydXW8sva70kWlvFmye992IyX2cUmGZ48R
+8TokGkRUn2ZJ/aS2LZBj5Ht1TFom8TDmqh8rxhJJCxATwlICyzik0Lv2Th2/NPh
2t2uGBHkEYMzulfNqBTqrvqep0gghQ==
=c5ht
-----END PGP SIGNATURE-----

--UP17P9dMGGZrnuYZ--

