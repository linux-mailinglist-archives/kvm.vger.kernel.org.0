Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCAF4366F0
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhJUP7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231756AbhJUP7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 11:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B91A61056;
        Thu, 21 Oct 2021 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634831837;
        bh=thJx0ql4zsrQ3ldjl2tC3lMokz2U/gzzD30/9U8kz/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HONkM9N7y+63m80uXk6oJMy3DWWv8D4t1Lj0tv5+bqUpIvORBrFvWI6agd8TPeZIq
         BPs9tFFTDlZDwYoS7fgpy2qfPHofu9XIATLjdjSoVlij85MvHlNSrusXefBsGbinzL
         QbevuOpdSqt4VgorJOMj4Gfieou5bPNuLAi40y1JlEA0lKiiHPZ5P0qJw0rz2Q7NNL
         y9R0azVeYjwaBgWqoKDgPMMQhcliuiXg5n5O43XMlvgLy1GxPNZvkBq/dUsfjq0TSx
         4Qx4bjUufFxriAPvdFnpFesnNwu/ZrhLjNs505mSZOanWw9DM+T5jVYN9EsQGonI7/
         K0NdgguyUzn/w==
Date:   Thu, 21 Oct 2021 16:57:15 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH 4/4] arm64/fpsimd: Document the use of
 TIF_FOREIGN_FPSTATE by KVM
Message-ID: <YXGN26tHnRyWkWns@sirena.org.uk>
References: <20211021151124.3098113-1-maz@kernel.org>
 <20211021151124.3098113-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IeDufIOZPw7Arkzk"
Content-Disposition: inline
In-Reply-To: <20211021151124.3098113-5-maz@kernel.org>
X-Cookie: I program, therefore I am.
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--IeDufIOZPw7Arkzk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 21, 2021 at 04:11:24PM +0100, Marc Zyngier wrote:
> The bit of documentation that talks about TIF_FOREIGN_FPSTATE
> does not mention the ungodly tricks that KVM plays with this flag.
>=20
> Try and document this for the posterity.

Yes, more documentation here would definitely be helpful - it's pretty
hard to follow what KVM is doing here.

>   * CPU currently contain the most recent userland FPSIMD state of the cu=
rrent
> - * task.
> + * task *or* the state of the corresponding KVM vcpu if userspace is beh=
aving
> + * as a VMM and that the vcpu has used FP during its last run. In the la=
tter
> + * case, KVM will set TIF_FOREIGN_FPSTATE on kvm_vcpu_put(). For all int=
ents
> + * and purposes, the vcpu FP state is treated identically to userspace's.

I'm not able to find a kvm_vcpu_put() function in upstream, just
kvm_cpu_put_sysregs_vhe().  There's kvm_arch_vcpu_put() which is called
=66rom the vcpu_put() function in generic KVM code but they don't show up
until you start mangling the name in that comment.  It'd be good to
mention what vcpu_put() is actually doing and a bit more about the
general model, KVM is behaving differently here AFAICT in that it flags
the current state as invalid when it saves the context to memory rather
than when an event happens that requires that the context be reloaded.
There's no problem there but it's a bit surprising due the difference
and worth highlighting.

I think I'd also be inclined to restructure this to foreground the fact
that it's the state of the current task but that task may be a VMM.  So
something more like

	...contain the most recent FPSIMD state of the current userspace
	task.  If the task is behaving as a VMM then this will be
	managed by KVM which will...

making it a bit easier to follow (assuming my understanding of what's
going on is correct, if not then I guess something else needs
clarifying!).

--IeDufIOZPw7Arkzk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFxjdoACgkQJNaLcl1U
h9A4wgf/dZ00LwDAdKbmHEpnXv8/wNofkka0/fogNjInmTdPmd23jPG2rP3KZ/yC
t7YubXwU8NRBAlxIG7570hCwq5PuOfaw3DYpb+vzrkgJaHuM4OUFlsUqZj2PqZDX
4cPa+zOkdR4bPABHHKkvMArt8CgfF20qeV+MjJTyksG8GNhpaLC+xbQMFzSTxx/8
j4CK8DtfI12HzqH6VP29HkXjZJhjc+y+goTCJdm+IK91wkdG/bcDaz5hauC9rjsO
77FcO+oedQsdOdsxxUZZ+4zQ0w8htwq62JF+gorJyDZLdSY85hT9B9+zPXTRcWZm
0zmnxUJCvu9ggcIxpllmZ1vjqjbn/A==
=mdJ2
-----END PGP SIGNATURE-----

--IeDufIOZPw7Arkzk--
