Return-Path: <kvm+bounces-12520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9152C887231
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C9E428446A
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2EC60872;
	Fri, 22 Mar 2024 17:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYyN6W22"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63E5605C4;
	Fri, 22 Mar 2024 17:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711129970; cv=none; b=ZVzkf/Q3FsdbYFfCBM45MxSJdPmQHCq9g1s+VSPPIGRLXfPR6h50Vg/0Y9S9H0nXSRG7oMnBfhCCVs1tKY/bm4T01MIbT9zYAOm2ACNMiNbISQ9YPFB/cB5gMPmR8sKdD2u+b4UJAt9b08TqIxm7VjMtuvdjKztK3sNdc0J+ctw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711129970; c=relaxed/simple;
	bh=3GTy8CpE7PWJRNWG4ydJgHPnATDiEg8zppGoo53CT8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FeaICVRRsygI0wBZh6gsasiKpWA8hNVnzIPTUdRfIGX0bDW/HdvEU3R6NtOahtkm2UAsbXhvVYgU3pQXkl9Uff2E2ysVqCWVOtXmgmHGRq3K7Lq0tPiihvxqVmGPB+23nCWStSwTf+ND81Ng6XBllup339PlaMXooNE7Sc+RP4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYyN6W22; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E205C43390;
	Fri, 22 Mar 2024 17:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711129970;
	bh=3GTy8CpE7PWJRNWG4ydJgHPnATDiEg8zppGoo53CT8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DYyN6W22y0by64Ie88DWur9X90zTsXuhPe9if4egxh2y5zGv1QzaN934YSVCF0vh8
	 Dw+g/O94fwO/of2g3YWWFYI2mdPfF2RdCcImIVCje0atXqo1xmRxODbRgHa+6FV85J
	 d3oYknkBRgN+E0w8iO/UlnION+5rVrDiRVmYObxYayNvLVDZ6wfSw3uks+9usyzSJs
	 UhbI1CGseSE4sglvXgfARQRpn0vw6VLPwFr9M2vOorOlEWFLv20vg4vYG4HRanQ1Ob
	 PQowtWV/PZCrdcwZZOm6kR8iSRHErak3Cywgdjez/JizKfMLtzGXs3xyjFfXeJH4b9
	 xSXpHxaw1MTZw==
Date: Fri, 22 Mar 2024 17:52:45 +0000
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
Message-ID: <fe5edef8-e61d-42b3-b4da-6f6bebd60013@sirena.org.uk>
References: <20240322170945.3292593-1-maz@kernel.org>
 <20240322170945.3292593-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="U6i2yOWc9fVcGEad"
Content-Disposition: inline
In-Reply-To: <20240322170945.3292593-6-maz@kernel.org>
X-Cookie: No passes accepted for this engagement.


--U6i2yOWc9fVcGEad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 22, 2024 at 05:09:45PM +0000, Marc Zyngier wrote:
> In retrospect, it is fairly obvious that the FP state ownership
> is only meaningful for a given CPU, and that locating this
> information in the vcpu was just a mistake.
>=20
> Move the ownership tracking into the host data structure, and
> rename it from fp_state to fp_owner, which is a better description
> (name suggested by Mark Brown).

There's still the thing with the interaction with SME support - to
summarise what I think you're asking for the userspace ABI there:

 - Create a requirement for userspace to set SVCR prior to setting any
   vector impacted register to ensure the correct format and that data
   isn't zeroed when SVCR is set.
 - Use the value of SVCR.SM and the guest maximum SVE and SME VLs to
   select the currently visible vector length for the Z, P and FFR
   registers, and if FFR can be accessed if not available in streaming
   mode.
 - Changes to SVCR.SM zero register data in the same way writes to the
   physical register do.
 - This also implies discarding or failing all writes to ZA and ZT0
   unless SVCR.ZA is set for consistency.
 - Add support for the V registers in the sysreg interface when SVE is
   enabled.

then the implementation can do what it likes to achieve that, the most
obvious thing being to store in native format for the current hardware
mode based on SVCR.{SM,ZA}.  Does that sound about right?

--U6i2yOWc9fVcGEad
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmX9xWwACgkQJNaLcl1U
h9AjuAf/W6MXG1iCV8l+REBjJrtYDnRGOAhTkV9QL2RpGEkmiHmW+QsyNz78ozMQ
rkl5SSPp2kbwIFQ6rrCRnbI4jZRY3+HevmUcfEMBYYfWXHnoqkRJBYMEUTo876z2
IkNPxa8wLSTWF4PqgFLQIahJEqHFaX/NXAQBY892P4DWj0C7ynC0U0c4nBsPRy/q
Mmq0KKsWV9KE/VZCkT9Ivc4HbrJk0eBZe7dLJW18Shn0Fdpb0Lifm2FPMQzPnJRX
B3Jplo3Lvz6tfylsIUU1LKzWIRbSKShI11T1EYXqIJXngsy+GVaaEkzvR30yR1eR
p8iAMCf4BYqX79lv/cJJ81jIPTQpyg==
=7qF8
-----END PGP SIGNATURE-----

--U6i2yOWc9fVcGEad--

