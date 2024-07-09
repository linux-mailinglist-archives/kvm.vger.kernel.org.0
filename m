Return-Path: <kvm+bounces-21209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11BB792BEAA
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 17:43:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC1701F2223C
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9521019D08B;
	Tue,  9 Jul 2024 15:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n2JB6iq7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBB33612D;
	Tue,  9 Jul 2024 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720539790; cv=none; b=g3kDQBvO1t1nKcrjC10KHf73DVy/B9EXZro5EP8mWJ6Fx6s1ChoKII8EMUwAhuQeDwXJND8aEYkf8IKSa+6w6+V66iI5CGhcZJk47oG5mYh+iYmy9KJS9pNGANLLPoGU8uBBSRKZNxP40y9+GuCjxEtgJX29Asyj7Q5Ydi6/Ohg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720539790; c=relaxed/simple;
	bh=Xh50jVznnnrgVuEfpXECB/Xt/aQhO5s53/1JHVye+aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYWjI7Yj5TrJuG5qPkyVV3f/jlfXarmvZE0vUzp91xyE0s8ZI0dtaoK4a1w2zTHre1IT0x/Vh7TXhQD62AcqjCsuE20ehFbIbvJCNV+aB1duF+F1rTzwpkVCrXPF+TqaQUty+SDotes7IAThCONbyWwswAqspbq/1I9I6yGsVjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n2JB6iq7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8D0C3277B;
	Tue,  9 Jul 2024 15:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720539790;
	bh=Xh50jVznnnrgVuEfpXECB/Xt/aQhO5s53/1JHVye+aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n2JB6iq7voz8SLZh6chZCTvNKvuB9HbtKKdooxEsH8/zXdFy5xplbXCdsvg48+tE/
	 Aw9GRL19r3z7F2LH2NFtbulpmM9RPqRW/iraVEh6sTphvvfM7Mv/PvWWQcJriZ1UKN
	 dfHuzHEmuowjfkn/eb0LHfcV+eWIOwKwhQm9u9XkMn6ZF8b++0dFj0+4ZemNJvldma
	 aINbsVlJzPMBgu/WlXwTXYjpZwex5rGleN1rJvxaXDxH+cL10LLAzK9/XwLN5j+tKE
	 GE4yg8BksVSrStz1PGkBkAwLvxLvGrdrdzXus5QnufwS4GCnK18zjsgDhZ8a0QytcC
	 Pw0j0YCY85VNg==
Date: Tue, 9 Jul 2024 16:43:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 3/7] KVM: arm64: Add save/restore support for FPMR
Message-ID: <Zo1ahL-ejGg-Go7e@finisterre.sirena.org.uk>
References: <20240708154438.1218186-1-maz@kernel.org>
 <20240708154438.1218186-4-maz@kernel.org>
 <b44b29f0-b4c5-43a2-a5f6-b4fd84f77192@sirena.org.uk>
 <864j8z4vy6.wl-maz@kernel.org>
 <8634oj4voc.wl-maz@kernel.org>
 <861q433pfl.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DZ91qXFJmkwfzx8W"
Content-Disposition: inline
In-Reply-To: <861q433pfl.wl-maz@kernel.org>
X-Cookie: Your love life will be... interesting.


--DZ91qXFJmkwfzx8W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 10:06:06AM +0100, Marc Zyngier wrote:

> So after cherry-picking my own fixes and realising that I had left
> pKVM in the lurch, this is what I have added to this patch, which
> hopefully does the right thing.

This looks good to me from review, unfortunately I've got IT issues
at the moment which mean I can't test anything with a model with FPMR
support.  Whenever those get resolved I'll try to take this for a spin.

--DZ91qXFJmkwfzx8W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaNWn0ACgkQJNaLcl1U
h9CUdQf/d0rMhhDUjvBtV912PVIMsE0o72T2yKmajoj21aQCqTxtjT4UuAGWCsiO
2Tt2HopXlO6/6vJpMUlo+GrmDFBPBeSDiPbTwxC8R1Lhpk4xev6sOKMYFIEi7hGM
3xb2tqosebv2/yfA60zvhn2SeE+uJM4qbh8rsVEQivZEkQa3MiPE97FA+R1A7dYD
4//h8qaT4lQDaI8DTJpKFEz2VlSqYYEpZbO1NLiplpyiZZG9RUVYMYPhbNY8KxEU
z7IwTZW4O/z4jJFSg345yUUpm8Pkjx6V5NlpiGGuGF9a9PA2hm9MuvZtLnRNpjoZ
YlFulpFygeH8bKaQahnyB8YCR+QKQg==
=eOtd
-----END PGP SIGNATURE-----

--DZ91qXFJmkwfzx8W--

