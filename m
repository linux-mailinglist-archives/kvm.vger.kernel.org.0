Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632604594BC
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240340AbhKVSdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:33:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240331AbhKVSd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:33:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01DD260F9E;
        Mon, 22 Nov 2021 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637605822;
        bh=ZgkUoAWdmiRKUbUvietPcNzDO9GCs6GkFq0UMKXm6rc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hz+rMmjnlhRyBqUgiwuunFGaOjPQwIy/9Avd97+VzBIa8jbSBbl0frxmpG0siIso8
         bJ5ZEovNEnQaex4ae2Mx7W7w2ptZO56uRASSqe4z9icO3YkjjCMdhVtH9HJ7/ZV5TW
         aRzyo8QxdGLpmG8oQwQMeo1/ns60pjQUURWkHiHlouR2qkc2WoqiQeIMM3shDU5rG4
         Plo9CEma+eJx7bKdB4eICRXbg+n9VbbJAo0tYsADDqSxrWMkdCbXwKZPnBRRKHMOot
         hSpH7taEBNG9Pq1eTlTNQ+PBv2yKWqbTTOVWZio3Ryj4frJzs9dlnEAq7RRVR5d49k
         0VOon6XV6Cqvw==
Date:   Mon, 22 Nov 2021 18:30:16 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH v2 2/5] KVM: arm64: Get rid of host SVE tracking/saving
Message-ID: <YZvhuD7cVU/4AaFC@sirena.org.uk>
References: <20211028111640.3663631-1-maz@kernel.org>
 <20211028111640.3663631-3-maz@kernel.org>
 <5ab3836f-2b39-2ff5-3286-8258addd01e4@huawei.com>
 <871r38dvyr.wl-maz@kernel.org>
 <YZvaKOLPxwFE9vQz@sirena.org.uk>
 <87v90kcb8u.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+FNNm7pPPOruqt76"
Content-Disposition: inline
In-Reply-To: <87v90kcb8u.wl-maz@kernel.org>
X-Cookie: Lake Erie died for your sins.
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--+FNNm7pPPOruqt76
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 22, 2021 at 06:10:25PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > While we're on the subject of potential future work we might in future
> > want to not disable SVE on every syscall if (as seems likely) it turns
> > out that that's more performant for small vector lengths

> How are you going to retrofit that into userspace? This would be an
> ABI change, and I'm not sure how you'd want to deal with that
> transition...

We don't need to change the ABI, the ABI just says we zero the registers
that aren't shared with FPSIMD.  Instead of doing that on taking a SVE
access trap to reenable SVE after having disabled TIF_SVE we could do
that during the syscall, userspace can't tell the difference other than
via the different formats we use to report the SVE register set via
ptrace if it single steps over a syscall.  Even then I'm struggling to
think of a scenario where userspace would be relying on that.

You could also implement a similar optimisation by forcing on TIF_SVE
whenever we return to userspace but that would create a cost for
userspace tasks that don't use SVE on SVE capable hardware so doesn't
seem as good.  In any case it's not an issue for now since anything here
will need benchmarking on a reasonable range of hardware.

--+FNNm7pPPOruqt76
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGb4bgACgkQJNaLcl1U
h9BJJAf/ciD1MtXHX5JAbHk0igE0oidNp8b9PC8Lr45L0awCj8NLgZsO8rtHptI/
3SfqfKNTSaf0s7Z66yhULasICS/LyqlWKT9xzQ/DgkEZ+RopR8Tp5DBzzhE0p+mQ
vJ1PvKLbsoxF2D8xKVSMkQQYPCwxPujhiG0zncarGpC7S7CVIvxfNtwxw7ZcIfv5
aj9qc2LC3+KM75nh99y5Cmo2mIJd5B624FCsIYgv8uTi5G2ARPIDnGQLHSshCOgI
eF26xy4TiO5BSDlEBLy4fsNjGGlt8cFkSgK6PzOcbVg8hpYAetyRdTQDfF2+AdX0
SwnDsW/jAH/An8aFkvvSUGb/YuZGvA==
=Me7X
-----END PGP SIGNATURE-----

--+FNNm7pPPOruqt76--
