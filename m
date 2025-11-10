Return-Path: <kvm+bounces-62542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 39195C484CB
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:25:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8DF124EDD72
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D76029BD95;
	Mon, 10 Nov 2025 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbris9J7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B76429B77C;
	Mon, 10 Nov 2025 17:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795240; cv=none; b=p3s77HHRpKbd7TuQ/IylsF19+uAsRVJSqeO3dEG89eqxZ5xRc9A2fC7umv/uynPbxhDPeeYO4jJocBtiA3FE+OqtWlgUABnoFCW8Oa0ZjDKYGsH67BF3Iqfokmds05HSz50OKTMCkwJEF0y2dP+vdcKvmNDfgjwvtTBR/74H9JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795240; c=relaxed/simple;
	bh=me6n6FjNH5PUu5+Jq5h9LLQT7A7eQf9qsR5sK2e3W/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EBnan4AEelos7MMKK/FX7oQAWjS4xQOHOdYRK49jKGeKVOSicWNrDuwlmXP0GQavpCytcMVm9E5tWWMP9mwJSq+9MnIrVgyyhtFMemUmbzUhvR3S28VqhT6SqoMAF2+RXAxrYopaw2PD1FExqhNhQw75aJab3OFuWn1tSzRm43o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbris9J7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77769C19425;
	Mon, 10 Nov 2025 17:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762795239;
	bh=me6n6FjNH5PUu5+Jq5h9LLQT7A7eQf9qsR5sK2e3W/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hbris9J72y9lCN1y6TBrpBKmdp9WH5v1/hEHp9Fwx0jmdj0+RmLyv8+JVG8O1iSYV
	 JveYr9YC5UcNBOsp6CGHsFduHNYpmMQKftwDQFNUlbs7JvCvVyTfmp0xDOEQ7VNouP
	 PwIZNxFux3oUui+zAcCG/tID5r4+fm24GEtPY6cXocjaEplFg0e9+nCxQaZuSxCVRH
	 O+2b5ehZnZzk4A1ddBjX0KS7nzDbGRNVHzICQzirQLjuYut46qJiSrkITi4zE/bdgi
	 rG6ad9iRL/ZLO1SCYaSTcvMdBj4DkkJuYZMfrIVajSAxRBBN82IokKQNJ6FfQYqXyN
	 a5nUpedO1mhrA==
Date: Mon, 10 Nov 2025 17:20:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 3/3] KVM: arm64: Limit clearing of
 ID_{AA64PFR0,PFR1}_EL1.GIC to userspace irqchip
Message-ID: <aRIe5I5TCnvHt9oM@finisterre.sirena.org.uk>
References: <20251030122707.2033690-1-maz@kernel.org>
 <20251030122707.2033690-4-maz@kernel.org>
 <aRHf6x5umkTYhYJ3@finisterre.sirena.org.uk>
 <865xbiuj6e.wl-maz@kernel.org>
 <aRHzf5wgJg5vSoKo@finisterre.sirena.org.uk>
 <864ir2ufke.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HOGTRvsQdiipdvmF"
Content-Disposition: inline
In-Reply-To: <864ir2ufke.wl-maz@kernel.org>
X-Cookie: You dialed 5483.


--HOGTRvsQdiipdvmF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 10, 2025 at 02:29:05PM +0000, Marc Zyngier wrote:

> Yeah, I just found out by exhuming the dusty dregs. As it turns out,
> this catches a pre-existing bug that wasn't noticed until we moved
> over to the standard accessors rather than bypassing them.

> The hack below fixes it for me on XGene.

Yes, that seems to work for me too on the boards I tried.  Thanks!

--HOGTRvsQdiipdvmF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkSHt8ACgkQJNaLcl1U
h9CiAgf9FSF7G/oQEtNSUVbFMyHeGGb3mZUjyQIQ7gpouZT33sKNzEmd7S91E5vQ
k8wsplgA3HTBwkoT9AzCuWZJ8+Vgt4aja2ZMLXwsIcNJewmOQnhDr7BUMKxx57q7
gew2x/GbJJkFpO6r41FyR4rGrSnr0gxD+gTOa80KjRBBAcmbRYgyfofzpHGFARkF
AO2VsTyjQfpfOLwdREYBg5G2uMv/iRBl3RBIwHwaz2c9KpB/uy1j/ym4l6HJvOT0
Fsg9utR2voNS/oNwbZpOva2YpTrns5L4TLM+lScsT88+YfKj0ZGr0dSw4+e3+ikT
k35PPosh5/Q456zHpAKncMSkgLouMw==
=+I2+
-----END PGP SIGNATURE-----

--HOGTRvsQdiipdvmF--

