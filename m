Return-Path: <kvm+bounces-21523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9707392FD8C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:28:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8C091C2381E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD5BF1741C2;
	Fri, 12 Jul 2024 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDkU4R6G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E618E17085D;
	Fri, 12 Jul 2024 15:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720798093; cv=none; b=MWKk+aqjZXVTpXtOHexqeM1rCIdybEede1feutKipa4UWwIwxh4hD44Wom7QXfquD7k0t8pRzGeGnyy8PwiOseUpS8pO3z2D9Ap5Yu5j0IhyC9bxLSRMRtnewJ6KMOk8QbsPqCj2DLTldcAkjqiKqdGHuYMa+uOwk9YB3xOfljY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720798093; c=relaxed/simple;
	bh=Zb5kv2QXTh+sNV8ZQ9sP9rL7n6zW1PcQIE0L82HpVt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ua8OC+5B0DSHSJzGq0T+jXoUHBNmiiL3feKqb3wAPm5Hr1G7WA+n8z02pQMRj30v6r8XGx//uBkOKSZjQ+57s8FPYZwB8OrNLQmyNIUD9V8wx9Wmj20NEzgXeL8mStv3XprPxQnOT2V9tMyGCbfOxa2iSA8L7mN71WAXSmTmSEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDkU4R6G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE1FC32782;
	Fri, 12 Jul 2024 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720798092;
	bh=Zb5kv2QXTh+sNV8ZQ9sP9rL7n6zW1PcQIE0L82HpVt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EDkU4R6G7RgUPFJ1TDD4o3ZjvAdRRc3ajxoKOVGOn1fTHdQ7clFgMM+dUgBEd8UAV
	 uz3/dqrQeDNKrCLvcpSx99vl2icC7b2SeTyfQUqIEkqLEz16XZ7gJZEfQc5d3GFwkj
	 YNvM27Hl7nfxXaS0TOT/gae0FrNKOmK9beHsZmRGFc434pc6CAw/bKQ8nmZWXsWfEO
	 ErITVVZZH8+fuDuZfv0cCcvJ397aoUg/SelvrJKGtgVdSQU3pqqVoYwcxVWIXVF/43
	 ufUNYdsR7nbjrUQSWJBTEOdPld5hdISP2M4wb8s6tCz9QZXlo7B/lddEiRhzgZkmtf
	 W5vzYUneOcpSA==
Date: Fri, 12 Jul 2024 16:28:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 3/7] KVM: arm64: Add save/restore support for FPMR
Message-ID: <c8860282-250a-4ef4-af93-894977de1b1f@sirena.org.uk>
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
	protocol="application/pgp-signature"; boundary="TOTkxYnYS4823nOn"
Content-Disposition: inline
In-Reply-To: <861q433pfl.wl-maz@kernel.org>
X-Cookie: Individualists unite!


--TOTkxYnYS4823nOn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 10:06:06AM +0100, Marc Zyngier wrote:

> So after cherry-picking my own fixes and realising that I had left
> pKVM in the lurch, this is what I have added to this patch, which
> hopefully does the right thing.

My IT issues were resolved so I've kicked the tires on this and it all
seems to be working, I'll go through again a bit more thorougly when you
repost but I'd be surprised if there were any issues.

--TOTkxYnYS4823nOn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaRS4cACgkQJNaLcl1U
h9DYRgf+KKKLA3PHDOPfYARs15+wmAVWgJL+DfyLCVa+yQdgioDPlUCdCfLyLg59
6tw3G9WFA0zKdWbDq3qI6jo/a1SP9Zs60xCunIFHIDacZlg+fuy0qEz7ufNRoyRc
LtXaIhRgO7zT9+jTkKysLP31PFjYVmmZqR2cHxvta7m4n/QEi/b64qSfjrWEns5n
SJmYlvzEPPKVSjVoSQ3oOEX2Se0vQo60WD9gXklrwlSRG7mvoF8STwKsES3wMdDR
MjDbRIsTmOsO1qaWtN6ppdtKVmPBFvW7eoP6W526u9T6cDswz7rwSfR3wq1t++kh
3j5p4AjIBaDtoX7FVqiNiY3941LqfQ==
=V2Eu
-----END PGP SIGNATURE-----

--TOTkxYnYS4823nOn--

