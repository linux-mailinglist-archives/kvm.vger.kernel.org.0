Return-Path: <kvm+bounces-12555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 27B4588971F
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 10:08:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95C07B33054
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 09:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211B26EB45;
	Mon, 25 Mar 2024 04:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slcQVupW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00618139CED;
	Mon, 25 Mar 2024 00:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711326469; cv=none; b=tMccDUXrIPDVel6zC+3p1TOI0wX5XrmBOTvJX2J8V98UX+wEwpJ0fwwULbTXEPQ6YvjgoXQkmX2+oqZsiPJ6EwossjDqkLtNr3NRIib8IGg6H/bhYuGItr74YlEzhi7mIB/qJq8X7bAe+tWS8ckl1YsdiUpUufTU+4lTgIjI4Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711326469; c=relaxed/simple;
	bh=ZVLxUpVlIvjbnpmT2kSzRca0o7lSJyL7hhcWuoMZ+rI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2PjibipCXr465o/yp3ug4vAhxaVpp45AtKpwF/aVEMCToLyqfd2sJsqSegHzDakil9M1Aebi/NZlkwE23g4jqDDyS6jrEjvphSJg/52qsWtHVYasBOX9gf6FpFTFQGqXR+FPg+TQsjFusRKzpxRtztInGjDAHFEEYeGyVWOuDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slcQVupW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649DEC433F1;
	Mon, 25 Mar 2024 00:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711326468;
	bh=ZVLxUpVlIvjbnpmT2kSzRca0o7lSJyL7hhcWuoMZ+rI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=slcQVupWCneGjeDxb9bFbNb+n+B7z9OfDHUdFec56clRKUt5ShKk7S2RUoUrELIXD
	 2rKCfL4aHZXsQjn/cg6m0B14xco9x2iCZyP6w54TjS3wgc53o4Bh/agft+lCafwyEr
	 na/WunzwAKfliEqbqiNBVanFksNkFLpnGuUVNPdd1CyQhdUjmole8DfQ3BVEzrmAuh
	 vs63h7IAlmVe0pDMw1nvLvr6+2tApj3a8laekBX6Qf1leWS+uPVrmOfktWUTjC7LiG
	 DthjPfPs85Qtf/tlX+9Ok8qfitorIeCKMmbFzqhsWECN8CD5XOq/e4fEk8mYFKmnp5
	 V0QafA+HdDAqA==
Date: Mon, 25 Mar 2024 00:27:43 +0000
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
Message-ID: <252bc993-e93d-4412-bfc6-13930b80dbd8@sirena.org.uk>
References: <20240322170945.3292593-1-maz@kernel.org>
 <20240322170945.3292593-6-maz@kernel.org>
 <fe5edef8-e61d-42b3-b4da-6f6bebd60013@sirena.org.uk>
 <87edc0sr7z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YEMFtPRhUeSHVnyH"
Content-Disposition: inline
In-Reply-To: <87edc0sr7z.wl-maz@kernel.org>
X-Cookie: To order, call toll-free.


--YEMFtPRhUeSHVnyH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 23, 2024 at 07:06:24PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > There's still the thing with the interaction with SME support - to
> > summarise what I think you're asking for the userspace ABI there:

> Well, the SME support is still pretty prospective, and this patch has
> no impact on an existing ABI.

Sure, hopefully I should have a new verison out this release - it was
mostly held up waiting for the ID register parsing framework you got
merged last release.  Though holidays do make things a bit tight timing
wise.

> >  - Add support for the V registers in the sysreg interface when SVE is
> >    enabled.

> We already support the V registers with KVM_REG_ARM_CORE_REG(). Why
> would you add any new interface for this?  The kernel should be
> perfectly capable of dealing with the placement of the data in the
> internal structures, and there is no need to tie the userspace ABI to
> how we deal with that placement (kvm_regs is already purely
> userspace).

This was referring to the fact that currently when SVE is enabled access
to the V registers as V registers via _CORE_REG() is blocked and they
can only be accessed as a subset of the Z registers (see the check at
the end of core_reg_size_from_offset() in guest.c).

> > then the implementation can do what it likes to achieve that, the most
> > obvious thing being to store in native format for the current hardware
> > mode based on SVCR.{SM,ZA}.  Does that sound about right?

> Apart from the statement about the V registers, this seems OK. But
> again, I want to see this agreed with the QEMU folks.

Great, thanks.

--YEMFtPRhUeSHVnyH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYAxP4ACgkQJNaLcl1U
h9CH2Qf9Fx+ewTCANRoicCF0rfM1fQqAlV3VSgLdU71g83ieZ6J/qY4xCDhv9sBG
OiXMksNTT6IzR7+uNkNcv9Zyqziu7YZYEtl7x+AbHLxLH3Vmyhzz2gIz4KEzoTm+
bv9EsL48ZPQj6luzAcWy9MXwv1m4XqUC7JF/oCoPPVXctVVd6MYowBzwJbSfBYuD
G6YVaGuXLdGv+xMCq2/+5hznLC7ILu0WXvBInFjyMVW99Tip55AFTO+ZCsoZVxFm
6TiTAm3xrkT99CvHrokMVtnbK1x6VM2M/kKtnqC+LSH/X6D7UrxB+VbvbCiMgUau
68nmUNhFO+NLq4iCVwEdZ3fNpMpcfw==
=x8zP
-----END PGP SIGNATURE-----

--YEMFtPRhUeSHVnyH--

