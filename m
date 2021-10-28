Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4635E43E190
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 15:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhJ1NFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 09:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhJ1NFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 09:05:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F34960F02;
        Thu, 28 Oct 2021 13:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635426175;
        bh=HS3bqWpOjF2gD6b9ws2zfTWy7XJxCId1PuTDK2PG8SQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AAQ/6Gy8cTjxo00NXScYPV7aekKaW9wpGTKrOhUxLOyWoNk5aj4Ou3/1XYJ4aSkWz
         pV5U+1HsFarcxnzjYdZQTuEGgJ5uSG3tRR+B9jEEZDYBte3o7EydK7oTwrtMXtxxsv
         qUUcMPuvP36l6pkJY2Kj/0hFbhtE0NUtMebbnz6aVZAuJkAV9nzF7H5yGxrernMuXw
         sPLUkf6g/v0WDvaNTLqfhqsqyIOoFn9PE6OWASWLyeGq0z5s/FwLF/khqeBKr7eyiw
         Db3TxEmGH6es3BvbblqT5lAZa7Ml06xNZ7xUNQyKhnSluzHKcXgJcxUoZrIJrZX87y
         25LvV03aLK5bQ==
Date:   Thu, 28 Oct 2021 14:02:50 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH v2 2/5] KVM: arm64: Get rid of host SVE tracking/saving
Message-ID: <YXqfegqTu80ruUPP@sirena.org.uk>
References: <20211028111640.3663631-1-maz@kernel.org>
 <20211028111640.3663631-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iTgLDb21f45sENgM"
Content-Disposition: inline
In-Reply-To: <20211028111640.3663631-3-maz@kernel.org>
X-Cookie: try again
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--iTgLDb21f45sENgM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 28, 2021 at 12:16:37PM +0100, Marc Zyngier wrote:
> The SVE host tracking in KVM is pretty involved. It relies on a
> set of flags tracking the ownership of the SVE register, as well
> as that of the EL0 access.

> It is also pretty scary: __hyp_sve_save_host() computes
> a thread_struct pointer and obtains a sve_state which gets directly
> accessed without further ado, even on nVHE. How can this even work?

> The answer to that is that it doesn't, and that this is mostly dead
> code. Closer examination shows that on executing a syscall, userspace
> loses its SVE state entirely. This is part of the ABI. Another
> thing to notice is that although the kernel provides helpers such as
> kernel_neon_begin()/end(), they only deal with the FP/NEON state,
> and not SVE.

> Given that you can only execute a guest as the result of a syscall,
> and that the kernel cannot use SVE by itself, it becomes pretty
> obvious that there is never any host SVE state to save, and that
> this code is only there to increase confusion.

Ah, this explains a lot and does in fact make life a lot easier, though
we're going to get some of the fun back for SME since the ABI does not
invalidate ZA on syscall.  That said there we have a register we can
check to see if the state is live rather than having to track what's
going on with TIF.  I've also currently got changes in the SME patch set
which do mean that we won't clear TIF_SVE on syscall entry while SME is
active, however I can rework that to fit in with this change easily
enough which given the simplifications introduced seems like it is
clearly the right thing to do so:

Reviewed-by: Mark Brown <broonie@kernel.org>

--iTgLDb21f45sENgM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmF6n3kACgkQJNaLcl1U
h9DsCQf9EFvV/AS5kqg1XCjZtSOxwVpUegl7BRhkzM0GAp+XZVvQhhe3+1WZ923E
7GFNl6LlJST3Ey6ZwpwpR956TJPk20on7q/v31194sRtikdoZhFsgRq55hDnD9vi
591aPeInRI5K61V83HJExubBHm24HHlE1t2nk7sJylWKfSP0qjeLeOvA6IABskJf
bsRDvysWc7KiuQKJUQ1BFW9RWGn4ItD0eawIQfG+iEFMjdr3rA0U500eFc+5DBa3
v31nrJA4a9aRnl2TgWozh+t7wzqkMcDZb06QvxhXDiNYKAqtcgVOq6Nkn10vbQYc
Zm2aPpB82LAyPzfPFjHgRb2cjuxL4w==
=Bf9h
-----END PGP SIGNATURE-----

--iTgLDb21f45sENgM--
