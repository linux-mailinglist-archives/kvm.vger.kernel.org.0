Return-Path: <kvm+bounces-30330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D377C9B9594
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 102A01C21C0F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B211CB506;
	Fri,  1 Nov 2024 16:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uh05FzQo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0EB381BA;
	Fri,  1 Nov 2024 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730479036; cv=none; b=t7QzkcZbMOHskaWhlD7kSGxppFQS94EDbKGmMphJ2UyJhC2z9gcfyZojodAOWogu2cIi3EdQODe4ErGM2SNKD4ZQheMGO2RT7FPAWOHNrj2sbH5vYUWwULjdD93XXjDwATD9WOso60LiA63wu3EfqIO1hOtejNEn6vxK/8b4Jmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730479036; c=relaxed/simple;
	bh=9cb/qIM5GkNHvDl4cwky8lRENEhP+MSleP+ED061UOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jysNCS2S0+eq+ClBZRivGNwmwIWPHGk/34JBNWNZUtm91Yui4X3iCrurrkeOgG7CDkZeOiJ7qBZn1590X7rwtRLgBAhJ9hFMkokzOPcqcizQgOcyxlSa2hpQOWAlf/8mqmEFMUQZnwhZJOmcE3yKecqVksN8XtGW00r0unIO7i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uh05FzQo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A122C4CED1;
	Fri,  1 Nov 2024 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730479036;
	bh=9cb/qIM5GkNHvDl4cwky8lRENEhP+MSleP+ED061UOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uh05FzQohbCjpLPYZYiml+DBPG180jE/ft2iaztx7zdHObx0fRlIrEPAlxioA9rcz
	 +wRvnqqNwgJRpMWjOOmxtuVVbeAR9g9B99Ox8qTevpgx21JJfi5ND/9pWsI1Hx4YbZ
	 sxEV8RuzAEdsYosylUirvfywlml0oXIHTeeNsym6IuCQkG6u+VKwfIP0ZhN/Hotfni
	 xvUDHx0/XqGHacfhf/JuOQaMcZZey97NEHMW2czpefWD6Ky/KG7q0rlhrN68zqQxr7
	 BHs8TYKpiWOzhi0byj6MM09cFWw7TBIiArMsOybXd66+nsfTVQGGQFFWa3H6C8JZNa
	 u2/RrSX9ce07g==
Date: Fri, 1 Nov 2024 16:37:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Jones <ajones@ventanamicro.com>,
	James Houghton <jthoughton@google.com>,
	David Woodhouse <dwmw@amazon.co.uk>, linux-next@vger.kernel.org
Subject: Re: [PATCH v3 03/14] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
Message-ID: <0bd90020-4175-48f9-9017-2eb6073101d0@sirena.org.uk>
References: <20241009154953.1073471-1-seanjc@google.com>
 <20241009154953.1073471-4-seanjc@google.com>
 <39ea24d8-9dae-447a-ae37-e65878c3806f@sirena.org.uk>
 <ZyTpwwm0s89iU9Pk@google.com>
 <ZyT2CB6zodtbWEI9@linux.dev>
 <ZyT61FF0-g8gKZfc@google.com>
 <ZyT9rSnLcDWkWoL_@linux.dev>
 <ZyT-6iCNlA1VSAV3@google.com>
 <ZyUARgGV4G6DOrRL@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6kYfSRqCQpL5xm5l"
Content-Disposition: inline
In-Reply-To: <ZyUARgGV4G6DOrRL@linux.dev>
X-Cookie: We read to say that we have read.


--6kYfSRqCQpL5xm5l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 01, 2024 at 09:22:30AM -0700, Oliver Upton wrote:
> On Fri, Nov 01, 2024 at 09:16:42AM -0700, Sean Christopherson wrote:

> > One thing I'll add to my workflow would be to do a local merge (and smoke test)
> > of linux-next into kvm-x86 next before pushing it out.  This isn't the only snafu
> > this cycle where such a sanity check would have saved me and others a bit of pain.

> Eh, shit happens, that's what -next is for :)

> The only point I wanted to make was that it is perfectly fine by me to
> spread the workload w/ a topic branch if things blow up sometime after
> your changes show up in -next.

Yeah, the -next breakage is a bit annoying but so long as it gets fixed
promptly it's kind of what it's there for.  It's much more of an issue
when things make it into mainline, and can be very problematic if it
makes it into a tagged -rc (especially -rc1) or something.

--6kYfSRqCQpL5xm5l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmclA7QACgkQJNaLcl1U
h9Diegf/bQqyrBGdbW3sZYLGgcu7GKElqVo35sLnznNUwNVBjwT3ED3phcFvs0e+
ykVAaeCQQQhw8p45KLci5zxYxGlymTW+lThmUSLbxAAiqZEOaP/nVcS+aKw+iS2a
2nVXVegHJ0RXjxyupuOHJ5fEyCjnr46tPbW4Ok3W3cGrEvAhEsFqB5K9leegPLwn
XZBPXERi3tAFS1Y57FBz9EjPLijPil2knc3/sEapi/7kjV7mZ9ahYYkscl88Fmms
8lH1QX/Im7iQ0ayGvSFRd+o6AnCeN/vI8aGInfytJwchPrlKxDKDYlOPd6uRBj86
6F4W4ExH23evr6zeMxhiNHXMyGbMqg==
=KB5M
-----END PGP SIGNATURE-----

--6kYfSRqCQpL5xm5l--

