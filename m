Return-Path: <kvm+bounces-12557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D4BA8898E1
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 10:54:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66E40B2DAF2
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 09:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BA113FEE;
	Mon, 25 Mar 2024 04:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZI8ycIw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1596139D15;
	Mon, 25 Mar 2024 00:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711326500; cv=none; b=Z107uTTh0dBIWqVINyLAnGa0kMoC5TcRPhzeXFCtJuhiex4ff1G4HqVm1cfdUABtS/n8xJwDBQ5a81RQdK4xeH1thuVrsUr49L2edPzgPy2qD9brhfN29cUF8zUEzNM2lODBVbaoOArqUH2kdYFcQfqsM1/Qgq0uw0/T0hCvDk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711326500; c=relaxed/simple;
	bh=BVWLjTbmz5oiAxJYHAqEBajtSYKBRXc96W8qzZ7xURY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z+/jbzPnCJeO3UWWrHHygSc3nmEfZ+OIX74tx6CeiMsM24ZrR0UEfK1hvkg8J7tiiuf5172TG8Cg0+HahQVEOEOyO799VWFYpHia5EQVQ7lMgHBfqTxI6mSx3pDS0IV1n/5B6JGjHoBxts9wJsZNAPB3jSnfjAsYj1nnHhQIGKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZI8ycIw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB05C433F1;
	Mon, 25 Mar 2024 00:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711326499;
	bh=BVWLjTbmz5oiAxJYHAqEBajtSYKBRXc96W8qzZ7xURY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OZI8ycIwaKcxmE7KIAn30Y8ny3oR7/6Gxo2kOd2VEJfZ1Y8IvzviL58uHxfkl+kn5
	 5tebdOzZnL6cYyRMbOY0JgJTI6z226AHVDffT0K0VinTVX7mvXk5A9dxOMmSE67EnO
	 2rqKxp6FyYwiaHolbcYM66rna8XVmMRqU8V8Fx3ELSN3Xc29n8VAe7Q0uuPIXgSi+D
	 fyaH0x9aJ985QHsrT4TIOc3upjMEBycZieamErG6SM9+fYyrsr/tmXohT3TnlKk77J
	 QcvzhlMv+T/nTqId9i1i7q2B2lBYc0jfn4kjErOle9c0620yoDgC1dHuJ9Zp7UBWSU
	 rBRNdNyfR0g1w==
Date: Mon, 25 Mar 2024 00:28:14 +0000
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
Message-ID: <ba16843c-c5e2-43f0-a582-6c82eebaf942@sirena.org.uk>
References: <20240322170945.3292593-1-maz@kernel.org>
 <20240322170945.3292593-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XckN4UvjfbjBKZB8"
Content-Disposition: inline
In-Reply-To: <20240322170945.3292593-6-maz@kernel.org>
X-Cookie: To order, call toll-free.


--XckN4UvjfbjBKZB8
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

Reviewed-by: Mark Brown <broonie@kernel.org>

--XckN4UvjfbjBKZB8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYAxR0ACgkQJNaLcl1U
h9BihAf+Px1ZG5v2qg2Ov0e0VVh0t+3jJmNFIiA6oiSFaVVZIMEQO9cxwSLyOSKl
N/yCN7Dj1vU0I3uEANsfKzAXbRjlrOwo3VTsc4iNxVb4IciHA6WqeTTJ4s149K+2
gVIgVeLvmXoFLO8ppJCcElg0uzsyNw3JNX3y5OxNKd7pvWSCoKNzKwEUNggUp7Xv
SgaRbBR3dTVei/xo1/5NLAa09I+32FUhgfQg+htkPxByJqMdMdLgER08df2G0ze7
lgTxkrpUCHcoYzaWOlKIusUnbfCHXGRhsfZBxZLA61CzV93xWXktY/hcCQeXDLps
f/m9pBNjVLxce0bL/DMOIMLozl+7Ww==
=KJA2
-----END PGP SIGNATURE-----

--XckN4UvjfbjBKZB8--

