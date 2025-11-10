Return-Path: <kvm+bounces-62511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4495CC471F3
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9723189379D
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 14:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE35830EF7D;
	Mon, 10 Nov 2025 14:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GA42ph7s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB6722FDEC;
	Mon, 10 Nov 2025 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762784131; cv=none; b=a7Q/GEuiXUVaFU1Kr2ckRV6t35rHIitYxijE/FfT0XQODFryVi3ZrMh8NfPE3NYKyetdsXTN+ZOXFBXwsG/5GW/rexpDpXNIX4ThYXxASNPXd5mygfxlu3oEUIWZ5NnXSZZCC1JSnHErLuB5dzAOk8BoEwJBRrKP9YQ8uXHHs1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762784131; c=relaxed/simple;
	bh=Zjtpe0PcMapcWqqZkDdW+4o/kiPNnUphphvNHXelxIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=elQnFZfrTGbF9OAhZHzkeqL8nYfHRhC61UhXQL/LTI9eGB/dfr5ZcKNbwCobBT5+uVWiyBGhnwRdH1RTL2UXTBTtsNFje8ZBso33M88YVdUq7Hb8B+8BYhTwIvpjTwFeiotNG7JFxlls6MkXIVYQEimf50GAaSmo9EnhtB7p/AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GA42ph7s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A5AC16AAE;
	Mon, 10 Nov 2025 14:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762784130;
	bh=Zjtpe0PcMapcWqqZkDdW+4o/kiPNnUphphvNHXelxIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GA42ph7s2s7+Yl7kwe6WfC59VTGLEboLESGwJyU1V1aigA81vgr0GaSEHqSq7Vzou
	 aOjGL/skU+9gr0wuCZMkj+dYY/k99CGv8IbvjRMfgDJMAQcpafQ4rwxR0DskeKbd3c
	 k/bly5tjvA0+25B5Klj3vQzAF4hK2DyU+2f8gFGIOiQSJa4fbeNo8UKuG4+32R8DA5
	 iSkb4zzDc1K0xysjIYCXJNR1NgLDu7br3jUdOPz2AKgTblQFRc9GFLk5pVh9C81U4K
	 6AgVr8+MQWs+dUxApCQXJAdol1IPGOCqnjX1DZb1UwVGbi1l6ib1pncC4w5c1ntAiz
	 4kwn8cI0TPScQ==
Date: Mon, 10 Nov 2025 14:15:27 +0000
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
Message-ID: <aRHzf5wgJg5vSoKo@finisterre.sirena.org.uk>
References: <20251030122707.2033690-1-maz@kernel.org>
 <20251030122707.2033690-4-maz@kernel.org>
 <aRHf6x5umkTYhYJ3@finisterre.sirena.org.uk>
 <865xbiuj6e.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nmuVcHVoFc1KSfwu"
Content-Disposition: inline
In-Reply-To: <865xbiuj6e.wl-maz@kernel.org>
X-Cookie: You dialed 5483.


--nmuVcHVoFc1KSfwu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 10, 2025 at 01:11:05PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Today's next/pending-fixes is showing regressions on a range of physical
> > arm64 platforms (including at least a bunch of A53 systems, an A55 one
> > and an A72 one) in the steal_time selftest which bisect to this patch.
> > We get asserts in the kernel on ID register sets:

> Please name the platforms this fails on. Here, on a sample of one A72
> box, I don't see the issue:

It looks like it's GICv2 that's affected - I'm seeing this on at least
Raspberry Pi 3B+ and 4, Pine 64 Plus and Libretech Potato, Solitude and
Tritum.  The platforms with GICv3 that I have results for (eg, the
Toradex Verdin i.MX8MP and Mallow AM625) all seem fine.

--nmuVcHVoFc1KSfwu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkR834ACgkQJNaLcl1U
h9BOeQf9F0JppM6Dk5c7+DhSmGwO4/k/K/NN2DSDzXyrzdW9KWlMWhKIfk0uvhLD
7Ne8pxY4YiamvsR/BgueeBbMum8BTfEZdT8nIkMdksIEDXrTTNz59bsDyqSw836z
vvrIGpN1rtR8w61ptev/8jF9EDH3QQF+GkoRF6RFOW0rMMNMIN7EHciTVHcE2xBW
T0Cf2fVgdYQAGNIs4j1dO3mmttXmQwNPeUAbasMw2qo8mw4kSqCGBhKO4mqvLBy4
UQcK5zFxuf4S4gQCHTkBUHbiBReMvtgJJOV9wOA9+mK3KOwKC2+cuhVUfNl1s3zd
Fs1H3D7kNPzDwNJl47kxXxHRqeQjHA==
=/URp
-----END PGP SIGNATURE-----

--nmuVcHVoFc1KSfwu--

