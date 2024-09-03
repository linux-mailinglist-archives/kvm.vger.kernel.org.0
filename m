Return-Path: <kvm+bounces-25769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3764296A372
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E89E0283412
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D4E188CB2;
	Tue,  3 Sep 2024 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q30lpJEJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D678188900;
	Tue,  3 Sep 2024 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725379104; cv=none; b=gmqC5ZRf04j9+08I8rvyt7iFY8HV+8uTc3HKcQLqyFTj4f3PHnfvunb6HRrfkzt5QcmzZzM0Zpi51pPC2loM9PYwH9gvYklM12BL+3ih2pE8HSUB+8p336hdjJQHwHnArU5mh/2Ki/+VCasg8Vl0HEfm/flz/IR5QyVkbCKfKqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725379104; c=relaxed/simple;
	bh=o6VRWeGGCvTcoven7MIqlGWqibIzLWkxMSmdXNHoSUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6JOXNm2mgq1+W3pq4oNRsgDQZbfo+y0CdQEKIEE7vgY/FQ3ssZQTmkkwz380nQ9cBfP7rvOb0nmmVcB+H5J58siP/UHfmSaE4WwEdEq44YLosoIk0GpNylBggnuuqoHGxx54DxvbcHqqOGCOoDWw5Iwku8/T8yqAFwuKE582k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q30lpJEJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0985DC4CEC4;
	Tue,  3 Sep 2024 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725379104;
	bh=o6VRWeGGCvTcoven7MIqlGWqibIzLWkxMSmdXNHoSUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q30lpJEJOcXtNqczw5Z1pOFcJkLi00aA8JhiYTSpbNOhJHOOzEjuYal4rOZ1j7plS
	 IwS8SGdtyO0o9bBob0xZ1QS0yEXCj0skc2cowm3B3cnTmYADdVf5IzdFZk6G3GX6wQ
	 9H1gHcOlmCK9KBBrM2OxgfFeRMOFz7U/5xSTkvX2LHWjdRcU7X4NGN/LsbPczllCDf
	 khshndLt7WGyBn2mQFYJcVhKjiNcxh+3AaE4ljN0cGkeY8OmsnAe/3CNiwQg4yIjD9
	 RMyQErDSmgBaheqHu46Mu1Sa6OJwlKQFeFGlhTMXKrr3/CTfUt2AhXn1cQ3AxD4s1x
	 WjuaUiChiZ79Q==
Date: Tue, 3 Sep 2024 16:58:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 16/16] KVM: arm64: Rely on visibility to let
 PIR*_ELx/TCR2_ELx UNDEF
Message-ID: <0518de00-aec5-440c-9278-5c85d18719a3@sirena.org.uk>
References: <20240903153834.1909472-1-maz@kernel.org>
 <20240903153834.1909472-17-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fj+Dn3RVYX/MU6I0"
Content-Disposition: inline
In-Reply-To: <20240903153834.1909472-17-maz@kernel.org>
X-Cookie: Words must be weighed, not counted.


--fj+Dn3RVYX/MU6I0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 03, 2024 at 04:38:34PM +0100, Marc Zyngier wrote:
> With a visibility defined for these registers, there is no need
> to check again for S1PIE or TCRX being implemented as perform_access()
> already handles it.

Ah, thanks for updating this:

Reviewed-by: Mark Brown <broonie@kernel.org>

--fj+Dn3RVYX/MU6I0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbXMhoACgkQJNaLcl1U
h9B2igf+OsUVv1cKXIxUIIZEGsgyNjz3nxOXyEjVnJs4ZnEfLlSLmAfUiydbSj/y
4yAOBCx8qLXfAEjcWu5GHm8k1CgeSCS2WgBf6VlnFkLBl1gIKokrYBOKPD5mU9hS
a2UEYa33f0pTHNQ7CChwGqMMOfPgc2WOibsmIAaxiLr9Nclom4JAC0El7Spszqrv
mtuXEMcLSuJX6mz+HHaetPUZR8f89EYfB3Ihe37VIg8xK0eyOCV9kh8xt2V81Kp+
Z/cEsQPMMzso0nM3GsiTYrIblUTLCBo67hjFmmB8WbvyUTdVRg5NOqbDUz5fv1ub
giZS/jjtUpukThtIw4S1N1wycM7UpQ==
=dCMc
-----END PGP SIGNATURE-----

--fj+Dn3RVYX/MU6I0--

