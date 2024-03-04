Return-Path: <kvm+bounces-10831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68342870BBF
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A9701C209A9
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74509947B;
	Mon,  4 Mar 2024 20:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXaE9l9Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9112310A1D;
	Mon,  4 Mar 2024 20:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709585122; cv=none; b=PCla01+u0axDMBUdK4uT1ZcfgPk7Z84WsjOQ9T5nVKSnO8nO/J9aa2zknF1Gqxp++WoyJB1R2Fc4ssFq79B+A2OWuqoV60pIVPgSZD2eVjic92a71pifs+h6ugjYmb0HH7+xcNbJdKvc4CqyndI4uppyD/N5+8J5V+mJmqodCvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709585122; c=relaxed/simple;
	bh=ULDkS8RkWD6QDE68IwwR2M/s5AOQ7RG4h0RyTMv5QG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=irSd7B7rqSC8AJgPqYJt3cwWJxxuuSNQj7f+k/62EF1yDjTdEhoeyagKIGaack2VQPA1cq1dLNfG7YapXx6hdmxlFy0eBYrFDYax6YcoYEjN0BoSQCCfrJF9KJcvnFpWKoLcgIzLPa+DQxKHizVgaCHQ5vuQntSty4PHO6hzW98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXaE9l9Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DC2C433F1;
	Mon,  4 Mar 2024 20:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709585122;
	bh=ULDkS8RkWD6QDE68IwwR2M/s5AOQ7RG4h0RyTMv5QG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MXaE9l9YDQIXNKz9r/Q/Vvjz8IKAIimL/AgqgawrhqrW4UiYogbIdJMloK4Ojm8AJ
	 1FKfwV60OU/31DUkpkmZ5FwtYl4bEQX9eS+FACpHwxaG6e8YNhJ+CYClIDaIY0UWmX
	 dkiymdt8fjemv/ha3Ggv/xkQ/avde+Y2kEQfEV3ycoaZR0dp/ClMGjLqkQHAD8nX7L
	 bX/FxTb77BzOK/JCEhrJOuGrk1c19x2nani9ITFUwhajyxnI4XNQv8+vQcAqY61kSF
	 JO61Xy6ABZu8Jwp4xH/HlJvG53cVyRGnfMdfQbTMUR8AoEq70OVhYWvCCEId9xcNKv
	 Eb5vfRYltHo9w==
Date: Mon, 4 Mar 2024 20:45:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 4/5] KVM: arm64: Exclude host_fpsimd_state pointer from
 kvm_vcpu_arch
Message-ID: <1b2bdbc4-9c88-4764-96b6-ccc276dbc450@sirena.org.uk>
References: <20240302111935.129994-1-maz@kernel.org>
 <20240302111935.129994-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ch1OVIoC65ICBkrp"
Content-Disposition: inline
In-Reply-To: <20240302111935.129994-5-maz@kernel.org>
X-Cookie: He who hesitates is last.


--Ch1OVIoC65ICBkrp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 02, 2024 at 11:19:34AM +0000, Marc Zyngier wrote:
> As the name of the field indicates, host_fpsimd_state is strictly
> a host piece of data, and we reset this pointer on each PID change.
>=20
> So let's move it where it belongs, and set it at load-time. Although
> this is slightly more often, it is a well defined life-cycle which
> matches other pieces of data.

Reviewed-by: Mark Brown <broonie@kernel.org>

--Ch1OVIoC65ICBkrp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmXmMtwACgkQJNaLcl1U
h9DiZAf/Uv1+L9/4aFLjTpfXLUBONd7LgDqShmDWUjPPiaFHywW/ftHKn2AYnzpe
B4yuTg4WLLLbF8hOHxrQdziVNSbmo8w913TjHoxrTBJR7XbqQUC/6p+GSV0hfBEt
Ll5xFhum2w1qBHxjXpZyLx9EzszyLvRnrYGfMfxUcOAKegNygamWV6Xj7T1gKQHJ
9t/IKXZqndnrt1ZVGZLThgcJlePGJ3+1EyioEZl0ppn/E887Go3bRxQaSj5JKSxp
FlULCkjTuasu1OxGyDlXMU9TIEJsimH0HkEWtucjbgRRD71OipPvwLih8YrHnRla
ynnlxdoVs7I8eqWQGwV2f2sOoHfkyA==
=/9Dk
-----END PGP SIGNATURE-----

--Ch1OVIoC65ICBkrp--

