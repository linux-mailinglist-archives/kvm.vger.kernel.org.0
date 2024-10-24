Return-Path: <kvm+bounces-29630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 817549AE4C3
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2CD21C21852
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81C21D5170;
	Thu, 24 Oct 2024 12:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZrhemjU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F9C1CF7AF;
	Thu, 24 Oct 2024 12:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729773135; cv=none; b=ACaCy3R/UdM0PDtkJsooO1oE65gHKRC8NxHbiazwbCJ/BUPgnDjknLDIqt4bOsjRqfx+CCZkfBwsXI27UhiTiI6XX6ql7OxlxQve2TXfHMuHIfmQRy8lgGJ588MQndY16gZIpi0JDA+ovHvjclaH/UpfA6tzv4q1CjiZJwebmTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729773135; c=relaxed/simple;
	bh=LMV1/ZjJryHcoq/PAGVhqnmnz6y8NgUSfp9u9bYAkl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mooPNQy9kZd4BBvk/AAB29FjWnBKgvOZ7b2XMwtCUrbLA37783pJLx2JS74NhsfQK403FuugiudzQuSXZmapyXeQyhMNZAyNXGNRGUopU0lWqZ5Syml+OH0RdRVaoe1RDvYPaTJHMwJart2sy4bGKUpnRVqYtYUFRgIznraNCoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZrhemjU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08AEC4CEC7;
	Thu, 24 Oct 2024 12:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729773134;
	bh=LMV1/ZjJryHcoq/PAGVhqnmnz6y8NgUSfp9u9bYAkl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RZrhemjU7IY3YPHK1vRXxDbr5qeWrcxI65mkq85Pqm2OT53JF0euLXr9ciwNHNPwF
	 qAhLKNhDZmIx4EOaXAnvy7RgCK9WigW7PQdgP7ybl7FzOp1esDme+prG2GVxphj7cZ
	 dEq3xlh8OjvAk1ctNGmS785C86VZBWHYigbhcD1ISJfyDLgSNel5JVmnB5BT0axMFo
	 V6h6qZken2Xy1XIgtFSKHYH3vkwfPOw4CsZDIkJ8cP4D9ZHB8hAObVxhLzPedCH+qj
	 Pq9dXkMO+jgp/FyN6R5TAcUT9HzdTzcEjKVkbJsFHFnH8yIeyw5rGlhpgTK8Mkvjb/
	 o5nxyPbcEj/0Q==
Date: Thu, 24 Oct 2024 13:32:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v5 17/37] KVM: arm64: Sanitise ID_AA64MMFR3_EL1
Message-ID: <33681a4d-2ea4-416e-9e2c-81a89a78c4ed@sirena.org.uk>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-18-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wt33+Se1teOVCKXD"
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-18-maz@kernel.org>
X-Cookie: Real programs don't eat cache.


--wt33+Se1teOVCKXD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 23, 2024 at 03:53:25PM +0100, Marc Zyngier wrote:

> Add the missing sanitisation of ID_AA64MMFR3_EL1, making sure we
> solely expose S1PIE and TCRX (we currently don't support anything
> else).

>  	case SYS_ID_AA64MMFR3_EL1:
> -		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE;
> +
> +		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE |
> +		       ID_AA64MMFR3_EL1_S1PIE;

The changelog is now out of date, POE has been added.

--wt33+Se1teOVCKXD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcaPkkACgkQJNaLcl1U
h9DiwQgAhH+zkGBrN/5cPpNXuLmA1wMq84HXbwEsyxUGI5X55Vgljru0e/29zbCG
jVQ9lEjO5dTEorGFMaF4BoRmag/CbRwMlmXqr8MdtiqM9FMZ08gHKjXaQu3OpJ6x
fEDQqlhkCSXM2NWLrWsxh+pi8dx2IzL4anecrFQMJ6KkJxPj8KxuEeB4BJchcyPx
/+u6Cv8K9YVyMFiKwKGetUQPLqF91wAQJPYtyORrpOI42U5qqaXw+SAXQ0BDmZpm
TM8E3ywD6+cGPiW9K1RNnVO3ENt3u+TNqqgsnKJ8kAoQU3W+X8d+YUuIUnCNEn7l
g31W6yw4j9ryKy3ie8Zs2R1whrYcyg==
=37Mt
-----END PGP SIGNATURE-----

--wt33+Se1teOVCKXD--

