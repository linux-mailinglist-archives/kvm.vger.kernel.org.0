Return-Path: <kvm+bounces-12591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F115988A9E1
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EC8A1C2D8AA
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 16:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A1C13249F;
	Mon, 25 Mar 2024 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HppgJVyw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8071417109E;
	Mon, 25 Mar 2024 14:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711378653; cv=none; b=W6E0M9OCq1EteYXyhzrOdcBu8j8XCGCjcnvobZVME918R/IuTTFmLGMPkjL4v0WVEn8J79dwjPTPyfDnmxbSNxHeoh8s5uJdzDyhobFGpVJQSWIm7NX0tD/fcWgvKhoAWmvT3uLOtPF5abbEVo5b1LIIZRgS81DteiIlAdKAcSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711378653; c=relaxed/simple;
	bh=4iYKYravWH9cBjEWpiEgWot/Rprt2Qy66JfxmdpsEds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWDrESUfPsl7MngNDGyT6Hun4wPRLodOtpCHAG6dKPqq8hNaNYxsgqMBYRp0WHRq48jg9rej+J0x2OyW1R2QU0sA0gdDQfsoCooWj0hxb4IlIBI2uChBvfDF0FlDIsQnk7uy4TcPQd74y3a/qxIxxkKGD/ucOeic4Q1QCPIDJU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HppgJVyw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5168C43399;
	Mon, 25 Mar 2024 14:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711378652;
	bh=4iYKYravWH9cBjEWpiEgWot/Rprt2Qy66JfxmdpsEds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HppgJVywSnViwY+ifBCk3LJ/5bTDtvM5hTK94hEq7ilMYe7NnVlmoqPbx2aLGiDeT
	 yZyPfhlUcBEGT+FY5G9KUnkEpt074+dVr20q4MoKpnzIQpY0tZZ/MYQR6OjD/9A9QM
	 pce7M5gVIrqDkpZM/PjZRTgPCnpZ7UMd7EIsjMeG9mspvdSzYKooXMFKDi9z+vJeNU
	 4B9BAICFWNBh7rS8EuBOZpcg+65Q/N+0JIWbJG1xUUlAANoBv+uaAf8XxHECNFodXX
	 ar6jUxdk7ZyC8TYum99LQnZ1zQCzRHF6h3if2qH5UCXIASQfNvrXtgxxqXsUWxasZk
	 Px3BBUoz6+GWA==
Date: Mon, 25 Mar 2024 14:57:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH v2 5/5] KVM: arm64: Exclude FP ownership from
 kvm_vcpu_arch
Message-ID: <55f2f1f7-6f23-45f2-ae6c-a1111e3271db@sirena.org.uk>
References: <20240322170945.3292593-1-maz@kernel.org>
 <20240322170945.3292593-6-maz@kernel.org>
 <fe5edef8-e61d-42b3-b4da-6f6bebd60013@sirena.org.uk>
 <87edc0sr7z.wl-maz@kernel.org>
 <252bc993-e93d-4412-bfc6-13930b80dbd8@sirena.org.uk>
 <87cyrism0p.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TZBBMhFGqQPVUNeD"
Content-Disposition: inline
In-Reply-To: <87cyrism0p.wl-maz@kernel.org>
X-Cookie: Evil isn't all bad.


--TZBBMhFGqQPVUNeD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2024 at 09:23:18AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > This was referring to the fact that currently when SVE is enabled access
> > to the V registers as V registers via _CORE_REG() is blocked and they
> > can only be accessed as a subset of the Z registers (see the check at
> > the end of core_reg_size_from_offset() in guest.c).

> But what behaviour do you expect from allowing such a write? Insert in
> place? Or zero the upper bits of the vector, as per R_WKYLB? One is
> wrong, and the other wrecks havoc on unsuspecting userspace.

It would have to be the former due to the ABI issue I think.

> My take on this is that when a VM is S*E aware, only the writes to the
> largest *enabled* registers should take place. This is similar to what
> we do for FP/SIMD: we only allow writes to the V registers, and not to
> Q, D, S, H or B, although that happens by construction. For S*E,
> dropping the write on the floor (or return some error that userspace
> will understand as benign) is the least bad option.

OK, this does mean that in the case of a SME only guest we'll end up
with registers not just changing size but appearing and disappearing
depending on SVCR.SM.  It wasn't clear to me that this was a good idea
=66rom an ABI point of view, it's a level up beyond the size changing
thing and there's a tradeoff with the "model what the architecture does"
model.

--TZBBMhFGqQPVUNeD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYBkNYACgkQJNaLcl1U
h9ByJwf/U/oIV6AVIVoNAwLZzAornj6Pob8m36s2usB/NGn2FM/OBCqaAjCYBPPO
G+h3JWn4Esv2fR2rPsmObyN4hUuYb9YORvoEzt7o37u9BPCwnk89KfIDBMxZBQ2c
dhZ8wF69nYwATMf0JrVqPi7QkXAMoFy4kbaGVavuYksABFnqH8IfL4PpSrKulmJL
+IQ1x7rrPAPWiUpoH2bFBvlxHxETYrCQNNakQ6BiGvQ8FZsUvOBXkmFpX24tBhvm
6TItHxSAIJIiHPXbuMcJ32CTCa/0BccsQBfOVoAAGX86x8voLVRMufVIImbnUYnJ
/XjM6kyFpFkPyV2gx+HkNoDLyURW3g==
=pUvj
-----END PGP SIGNATURE-----

--TZBBMhFGqQPVUNeD--

