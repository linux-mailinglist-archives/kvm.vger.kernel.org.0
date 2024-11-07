Return-Path: <kvm+bounces-31143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F209C0DAC
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 19:17:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B49F31F25506
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 18:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B0A216E10;
	Thu,  7 Nov 2024 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJpXhk6d"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB2F17C96;
	Thu,  7 Nov 2024 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731003463; cv=none; b=d2tf/Bk3wulZdNamttHmpkAOkyoNqIvfO+aEMod6zHrV3nSGEiAERsOxjnqc83KQBelL6v1uyX7IhFMlMsIXV2i/JOzNp+E8h+RsiUJRq0DBDxn9sJrWZI0+PmeOHmKYoaq3f4ZzaIlLWI3AHRk7CxDrRQruDgTbqawVGzxJMSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731003463; c=relaxed/simple;
	bh=fkLbHhGlHgj6qtcMJulagW1UwPzPTWEasY2EBTv33Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+/mZN2Our7Au8idwIgnXSIXvfviZJWxntLitglnUmHmqii8F35yeRDWYZzQboem92sEcPV4Z4mlaeVv/g9AywudKTQwIspVmuzDeWQcgpHQE7AJLHdXeNuPtlmbFPWK3tVZAS8B/1QAxquYS6n65FlAYFcBA3ADQOmq0/PWtM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJpXhk6d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DD6C4CECC;
	Thu,  7 Nov 2024 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731003463;
	bh=fkLbHhGlHgj6qtcMJulagW1UwPzPTWEasY2EBTv33Ag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NJpXhk6d7fTv2QUn1aMxH1iQfnHWOzfUfrWyMULktSXXfDNcgiISkaw7vvd18/6kl
	 TyYz1wb+obs+W/WZIwkQ4bjgvk5xJOk6e5r58wdJXh8nZ638nF+cHSdAPeVL4IE0mt
	 Vtf392DEn5My3djAyvqc66PoraPQUOJgoV7csB9BZm1RHE43eEkg3HpxVQI2U/y2Hu
	 qlIypCqkd3jZ1zKfkLxaj25AI73tLXgU2KyJkgiZqzCu7KiB6ciWHsxgJNMvOhRh7l
	 zSsGrRWzXTdubIQK4zAdaaDY3sfajDubsoreWo9qNBzD5O+VHL4TogmTJ6wa3zyGz8
	 KKmlaYD5kf3uw==
Date: Thu, 7 Nov 2024 18:17:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
	maz@kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	joey.gouly@arm.com, oliver.upton@linux.dev, shuah@kernel.org,
	pbonzini@redhat.com
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
Message-ID: <c5ebf131-5182-4dde-8c21-b364b9e93786@sirena.org.uk>
References: <20241107094000.70705-1-eric.auger@redhat.com>
 <20241107094000.70705-3-eric.auger@redhat.com>
 <Zyz_KGtoXt0gnMM8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="afSuzDBVqO9u/vk5"
Content-Disposition: inline
In-Reply-To: <Zyz_KGtoXt0gnMM8@google.com>
X-Cookie: Professional driver on closed track.


--afSuzDBVqO9u/vk5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 07, 2024 at 09:55:52AM -0800, Sean Christopherson wrote:

> If memory utilization is a concern for the vgic_init test (which seems unlikely),
> I would much rather solve that problem by expanding KVM selftests support for the
> selftests harness so that each testcase runs as a child process.

> https://lore.kernel.org/all/ZjUwqEXPA5QVItyX@google.com

That would in general be useful, having individual test cases be visible
is helpful from a UI and triage point of view and having them all run
even if one of them has failed even more so.

--afSuzDBVqO9u/vk5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmctBEEACgkQJNaLcl1U
h9A9IQf+LLCb5DkMs9gARSP6zVAeEZ6w6I6e9rSgs4l7VEcWANBRckklvNi4gkI3
b0yChpooPQlMn5EYFWAm7UTy2gmDhs3BqGSIwL23JX3PjQtJYSqsxinmnDNs9FqS
K7jUOgG+PRg1JX0gUNUOgvuvKilKALZmS+PE4canZPPlQMIbY5Ira8ojRKHBBbSx
EyJMETkOVJKmLHimHVDPrmbm7ft8rRdGn6fcJopoCR5k/7kFMU+0kZnq2C3SKTw7
rOmQv8fNkY9LxTngQ1AlCg5XhKgX2yTm/RThvFHGG5FpM2pJPa4clEW/iTb2MkK6
Xr4+q6R86vzzissdvHNfIietQx0q+Q==
=tBft
-----END PGP SIGNATURE-----

--afSuzDBVqO9u/vk5--

