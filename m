Return-Path: <kvm+bounces-21117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B66692A844
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 19:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 559F5281CD3
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FAD8146A98;
	Mon,  8 Jul 2024 17:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IXkHcf2H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39383AD2C;
	Mon,  8 Jul 2024 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720460082; cv=none; b=cmTX0frcSkced2+7Pmn5gjULSSEIsByXzcEnVPBrHo2nM/sw1+B3kT4l6ugxqKyJnC8qKbsje12rfIS2OfCZ8F8qMXhYjhZFbGnse22AeC8iJalRZNQlQXT8EAlzfkkqKP0tpYlWg1st2XUr564CLjdmxE9Mm/2yTgDk0utmn3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720460082; c=relaxed/simple;
	bh=hMmuYy6vLkrib8Hgk6hGxb8j2gbFonpFMGYtC6TgC1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUxZ6PVQio0Ozvcwb0knc1vZEVNqdYoI7alP8z9QKja7IN6soGW4+GCN6da9DZ3GrAeclmIXGQ2VbRx27f7ZYc0T3wlOuJCXMZp45A3IT/7mzpeN6pEGZHhINlvX0UVM+F1oBMfCRA9D8wiP5RwUHa7BPdJ74rkLKHYybox1sp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IXkHcf2H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD74C116B1;
	Mon,  8 Jul 2024 17:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720460081;
	bh=hMmuYy6vLkrib8Hgk6hGxb8j2gbFonpFMGYtC6TgC1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IXkHcf2HKeXG17oprJVZ99ydw8MwWEn25mw8MZM1iS5Ck88fFhVC8ZjlJ/L2MOLrr
	 S2LrtHfScLMrmHOMuRlUjn5DuUBGegOv8R5a4hCfuzvB6ywyrepEc/7G9+TNOLK4uP
	 VQCmwutRKZnSvSXgCjWf35PNSHB/5BnVEdrk+fnUR8RoLavmsDnqCwf8f7+blRr7N3
	 ZU74uIHKNpAiXRUScLXeQqJI4emeRxJiiVyb3ri7mynpVoFjH/VAcuCuokK0iMDX2M
	 Cq/UJT11COgeiE/ZMnZAdTLv44gqHYzS1j6Rnt1pKf7WJTbfRq+PwLCiAJSa0Hm/P9
	 wAIC6quCzeXjA==
Date: Mon, 8 Jul 2024 18:34:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 3/7] KVM: arm64: Add save/restore support for FPMR
Message-ID: <b44b29f0-b4c5-43a2-a5f6-b4fd84f77192@sirena.org.uk>
References: <20240708154438.1218186-1-maz@kernel.org>
 <20240708154438.1218186-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="I02iQLvc5V7smg/4"
Content-Disposition: inline
In-Reply-To: <20240708154438.1218186-4-maz@kernel.org>
X-Cookie: Many are cold, but few are frozen.


--I02iQLvc5V7smg/4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2024 at 04:44:34PM +0100, Marc Zyngier wrote:
> Just like the rest of the FP/SIMD state, FPMR needs to be context
> switched.

> The only interesting thing here is that we need to treat the pKVM
> part a bit differently, as the host FP state is never written back
> to the vcpu thread, but instead stored locally and eagerly restored.

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h  | 10 ++++++++++
>  arch/arm64/kvm/fpsimd.c            |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |  4 ++++
>  arch/arm64/kvm/hyp/nvhe/switch.c   | 10 ++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c    |  4 ++++
>  5 files changed, 29 insertions(+)

I'm possibly missing something here but I'm not seeing where we load the
state for the guest, especially in the VHE case.  I would expect to see
a change in kvm_hyp_handle_fpsimd() to load FPMR for guests with the
feature (it needs to be in there to keep in sync with the ownership
tracking for the rest of the FP state, and to avoid loading needlessly
in cases where the guest never touches FP).

Saving for the guest was handled in the previous patch.

> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 77010b76c150f..a307c1d5ac874 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -312,6 +312,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
>  {
>  	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
> +
> +	if (system_supports_fpmr() &&
> +	    kvm_has_feat(vcpu->kvm, ID_AA64PFR2_EL1, FPMR, IMP))
> +		**host_data_ptr(fpmr_ptr) = read_sysreg_s(SYS_FPMR);
>  }

That's only saving the host state, it doesn't load the guest state.

--I02iQLvc5V7smg/4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaMIywACgkQJNaLcl1U
h9CtgQf/cQbOHeKIQqMm9LlO5tNE54ez4ADCnEh6SfqxupD80tCAHXW+bzPRbhyg
2oo/lhOBIJasFXPaialNiBdq6vZGX3nDFiDtQWobDKnTf76m2goX9kx2dXNLoIK9
Do1oIaB6hIu5LsB9xUK+qmptD8OwUjStSwxtzk1i2hAOObR+lAX6raLb9ETij8C1
1OIK94xn2YkvhA8PjEP9jSQxIc0bREoaAiRzDU4ZNEBMblude2KrxraVSUffIo28
5jxGhT59oOlWezLcmv8On74kFLNr6H6y41nP0GWgRz+/YaIx5d1lkAkNLPCHJf2c
4uL26P0YQB/uHoniVg5ghpvBisZ6BA==
=RDza
-----END PGP SIGNATURE-----

--I02iQLvc5V7smg/4--

