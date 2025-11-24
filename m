Return-Path: <kvm+bounces-64396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D5502C813AF
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 16:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 81A97345019
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 15:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B1B42FFF8E;
	Mon, 24 Nov 2025 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aLUhEunI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A937228725B;
	Mon, 24 Nov 2025 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763996798; cv=none; b=ZdZKBa73NPWHvZd+huKELnM9Rs/hNdRedreLTlFJvRzqvQRupVjlSD1vYxnN3ZPnUtnrs2VJsLxlAEEr8o6/kxdZ7PGLAN2MNsoMegdyxynYtkzji9els2gTwnF6FQPeQ6xyTigE1Adkl8D+DhGPN7wTCndcXVMtyYMN6H1594A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763996798; c=relaxed/simple;
	bh=GTAFpH4TJSYDJC+6zyiuuCI/A3Ih+shkhJTdyMtqR4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QjvekXWXjI7piYsmrwHPJr6SK1vCMA7lEG2DjIfWXhTGYYHu9xyqzqQ1VejLWp2K0hkktgXjk1DrbU5LQ/QAmwgcqjBdv5TjlUKt3cO3Zu+KfHFQY2yzdzRuHJlL2I7XsMZlK5bvM7qRBwb7MxctrAMSYJHsrB0Y+vhqfWE4khU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aLUhEunI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CB2C4CEF1;
	Mon, 24 Nov 2025 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763996798;
	bh=GTAFpH4TJSYDJC+6zyiuuCI/A3Ih+shkhJTdyMtqR4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aLUhEunI/PKycRbjz1yN6hgMVJK8jGCFGoUwM59UdyObThw7ePnfya50lykNV0/oN
	 CvSMy3yKFQuFljVU0rBrSkOVl8jvBUiaYivMt8wpbI3ILAGFU3brRvMz91s84Q2bVj
	 q4HJzJVhfExlwk3jAIAJtksbTs6CV6eIuhk4iSK8ipOk1Z2I32VdK6W0CSS2T06l8R
	 3p81c97aN4MFID/lJ+tdNduzQ1KtUWYpJWUl4lRSuau08LzHjzUe67FU2MJBiUgscp
	 hl1BRbPqZrMKCMvbOKYJS+d683sSsnbIGjS7KXou2RK6aruIWnNcFJNInJxAs4w7+h
	 6YT8deCN9pVCw==
Date: Mon, 24 Nov 2025 15:06:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: Re: [PATCH v2 29/45] KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when
 interrupts overflow LR capacity
Message-ID: <499fde92-c6a9-413f-88fe-771be267e0c7@sirena.org.uk>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-30-maz@kernel.org>
 <CA+EHjTzRwswNq+hZQDD5tXj+-0nr04OmR201mHmi82FJ0VHuJA@mail.gmail.com>
 <86cy5ku06v.wl-maz@kernel.org>
 <51f5b5d7-9e98-40b8-8f8b-f50254573f3d@sirena.org.uk>
 <86o6orr356.wl-maz@kernel.org>
 <342302ba-5678-408a-ab63-1a854099d4a1@sirena.org.uk>
 <86ldjvr1kc.wl-maz@kernel.org>
 <86jyzfr03h.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZrY4YkY6KfCCWCC+"
Content-Disposition: inline
In-Reply-To: <86jyzfr03h.wl-maz@kernel.org>
X-Cookie: Single tasking: Just Say No.


--ZrY4YkY6KfCCWCC+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 24, 2025 at 02:12:18PM +0000, Marc Zyngier wrote:
> Marc Zyngier <maz@kernel.org> wrote:

> > Something is badly screwed in -next, and I'm not convinced it is KVM.

> > 	d0f23ccf6ba9e cpumask: Cache num_possible_cpus()

> > is my current suspect.

> Confirmed, and the fix is at 21782b3a5cd40892cb2995aa1ec3e74dd1112f1d.

Great, thanks for checking.  Unfortunately it looks like that missed
today's -next but hopefully it'll show up tomorrow.

--ZrY4YkY6KfCCWCC+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkkdHgACgkQJNaLcl1U
h9AW2wf9Gx09NFZkbOxrWK1ZCPVMxa5QkABW1zwg+HvlAZuCBTPi6h72caAbxgrv
l3VT6gtzb7r0v91RX2qHIqDLFALkYgnHvkDNcKo0vMNSi5MgfZYxP+s0faHHD6Qy
77Ya8IbOqnB8y872kIqYyGluZaPZFWm+BLQPjgcf8dDp70P9p2FS1NLiHa+1iy1j
n7ZVAJ7f8cY0XFE9xpYdubh18g8JFWtqFHmthbvRjn3Cxczw1JO7l/YrjpTkq0Z0
LUisxUstkAykqVck5iLrqma7jhr+sGEksbaz5m4tDj7tpZyjZBDdtSIUSqDq+y8d
iH9d8J4cy4V7D7B9CzZkjFhu38k76A==
=ljRj
-----END PGP SIGNATURE-----

--ZrY4YkY6KfCCWCC+--

