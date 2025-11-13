Return-Path: <kvm+bounces-63042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 56171C59A8D
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 20:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A0B5C4EAB36
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 19:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D4E3191AF;
	Thu, 13 Nov 2025 19:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBF1FrJs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5EF3191DE;
	Thu, 13 Nov 2025 19:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763060798; cv=none; b=Aea+iWbVfKYZUegeFNRnBVgeXlg9xwP9xsZRwvTi/AwKv9SnATASwZoFf/PHa4IfU/4aD4Dd5XMAgDqYv757GpLhTW9a3C3heOfY5NWjj3JYZgJC/teD1sXke8W6lqXH0SA5vh55Fv0xVxrwhXdJFtDIgTg7Szq0BXkEvSAstKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763060798; c=relaxed/simple;
	bh=c4o0ryZTMkuy62CEXa12XiKN4UsmvuV0qmwiIssY1rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3KCtNBryB/LVrqKtv4vj1O3KiNFeABUZohMF1qQXnbJMISxPBcxuxGmNRAsC4Aw5N3AtmLrT4IjsORlQks33kz1OOVQH5k5bEo0MyOYubowIzK8tGLTWR4cJKV4YAanBLOZU0LHu9s9J3PNl7M0OApMM7WMweH9g9TB+Oo6MgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBF1FrJs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB13C19421;
	Thu, 13 Nov 2025 19:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763060797;
	bh=c4o0ryZTMkuy62CEXa12XiKN4UsmvuV0qmwiIssY1rc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FBF1FrJsur20m/Sikm1MD0deGRjb2V1j7lLOlUSAewPjJ91BsoD2M1dS392jnYW22
	 tpB8BSWlGdYSTpz3aleB9TbWGT4BXJFvy9iZ5KRcqX9/nf+xEYtpZ+X0T+jr/WuVEq
	 ScEGsNK9XKfCkXjK15/58K3vufm+oGxVlWGmUVuTK9KacRCyHD+O/Q7DBf3z3Hi0wM
	 4VG7cQIAlgOXgKAn3wHvfZLqWKbGeUCA1u+gNwn2EdiDt71J8ujBOt6BzsUhK7py92
	 Y3UJgmmunkGGlOrNy95Qt6B9lZc7XVO1cNKDZW++wySH8oL/iB6xr3gj7402pCa3Ir
	 c/V8fuAVoBcvA==
Date: Thu, 13 Nov 2025 19:06:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 05/45] KVM: arm64: GICv3: Detect and work around the
 lack of ICV_DIR_EL1 trapping
Message-ID: <7ea5c49d-b093-475e-9f27-ad92dcc4b560@sirena.org.uk>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-6-maz@kernel.org>
 <7ae5874e-366f-4abd-9142-ffbe21fed3a8@sirena.org.uk>
 <86ikfdu7cu.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IqwhI93WVr97nscY"
Content-Disposition: inline
In-Reply-To: <86ikfdu7cu.wl-maz@kernel.org>
X-Cookie: An idle mind is worth two in the bush.


--IqwhI93WVr97nscY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 13, 2025 at 06:15:29PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > The arch_timer case bisects to this patch in -next, regular nVHE mode
> > runs this test happily.

> My hunch is that we're missing something like the hack below, but I
> haven't tried it yet.

> I'll probably get to it tomorrow.

That still fails FWIW.

--IqwhI93WVr97nscY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkWLDcACgkQJNaLcl1U
h9CHwAf/T+DZlAAEflS6H6jO+BA36LhxPkjMUd+GbOOat4+PEXU0sJf3AtFWB2WK
aIQlFqC7YpzBL7UxoqajhZzrGK26TZFr3hyuVCL9wo5gRhqSPbH2JVTyqQ6I5rrE
gF9vdJdeWmLYVdEOj+UAtnFwNqqZdm3hiSZaAANBxcr1C6C9u7OUlZhxlKMYGUkf
PzQpwZzBudtqiRHCo2uRLEeNQffLLhO/MmQJeLo1r/BGAf9LHNLZ/Jj+YpUkyjHp
zuUYITl4AfLiyyzcuLSi0CzEawlU6OLLHf+cdaryobUa+DzIIsXzcYr2orVum7Xl
6Mkc3eWj3QdABeeu4lRGQ7fTyD7b8g==
=Moc7
-----END PGP SIGNATURE-----

--IqwhI93WVr97nscY--

