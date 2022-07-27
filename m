Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CAB58321D
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 20:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbiG0SfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 14:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbiG0SfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 14:35:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8331E9516A
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 10:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F299615D5
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 17:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F3AC433C1;
        Wed, 27 Jul 2022 17:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658943157;
        bh=q47QgoXCm1d+pbl6jIqi2IRTu7bwzcZuMzbuDfSeIRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tHtY/iIkrpMF/Uv7EFlWhixNyJBu2K9QHZz+9n431yeiYJNvpwKwRYlHpssWbZTyd
         uxBnpxL5+VyORGuHopD8TijpL+aGXyD5fr7vA70GrSIaqxk13toS5uVO6o4oFWz1H0
         uYPGNYIknDmwI/NqDN5EJWxhQ3Cog3q4g7/4huHVtFTz5oteRS0TDLasiwCrYjRtK9
         SiNFVXeY5rgS+aUBiR0YdOx4K5osShIlptdmg2gztTLWCXUERRa/eh+ScC7bMsZnpa
         7VG5knWzWxZEi0H5CJrmOH0CIPw294RLxCYc4AjP1UOtmoAUQoPPyFGuSshJacgG5Y
         V052/lig31PCA==
Date:   Wed, 27 Jul 2022 18:32:29 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, mark.rutland@arm.com,
        madvenka@linux.microsoft.com, tabba@google.com,
        oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, vincenzo.frascino@arm.com,
        mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
        elver@google.com, keirf@google.com, yuzenghui@huawei.com,
        ardb@kernel.org, oupton@google.com, kernel-team@android.com
Subject: Re: [PATCH 3/6] KVM: arm64: Make unwind()/on_accessible_stack()
 per-unwinder functions
Message-ID: <YuF2rfXvhPM60GkC@sirena.org.uk>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
 <20220727142906.1856759-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hbdw/Jodnr/WTir2"
Content-Disposition: inline
In-Reply-To: <20220727142906.1856759-4-maz@kernel.org>
X-Cookie: No motorized vehicles allowed.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--hbdw/Jodnr/WTir2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 27, 2022 at 03:29:03PM +0100, Marc Zyngier wrote:
> Having multiple versions of on_accessible_stack() (one per unwinder)
> makes it very hard to reason about what is used where due to the
> complexity of the various includes, the forward declarations, and
> the reliance on everything being 'inline'.
>=20
> Instead, move the code back where it should be. Each unwinder
> implements:
>=20
> - on_accessible_stack() as well as the helpers it depends on,
>=20
> - unwind()/unwind_next(), as they pass on_accessible_stack as
>   a parameter to unwind_next_common() (which is the only common
>   code here)

Reviewed-by: Mark Brown <broonie@kernel.org>

It feels like more of the accessibility stuff *should* be sharable, but
yeah.

--hbdw/Jodnr/WTir2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLhdqwACgkQJNaLcl1U
h9Drtwf+K7Q5M0yDprpbWSTZ0Syqie6HYKfELQLgEhMb2bOBWuV0OqB/qxlHp4IA
gjP6FYZ1zifSN71xa4FkRiDDSFVEoJt7nCGUMZ9pI7OtRBS2kfYpADm4PqNgPehO
0Jc/GLnGVpjElbcT5GWIw4u+B5/MiV5WHXg+Oh9cc+XsJ0IDkUQEzEYe6r8fjJ4Y
a9bkkJkJDPXbzsWjQyOEwaJb180/oNnZ11M82yKceTA04WVX0kkE07wi8mcu+3zj
uX3ZmhBEBzzorRIFsDbWr/ae/gNZD8+m8HVilhX4XguihkQVJSa4eUKinsEok0ck
fNLlqdAjhoFixn0YXu7iJAIq1OaZEg==
=ejhR
-----END PGP SIGNATURE-----

--hbdw/Jodnr/WTir2--
