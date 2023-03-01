Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5292D6A726C
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 18:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCAR5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 12:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjCAR5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 12:57:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A93748E09
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 09:57:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA93B61378
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 17:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C81C433D2;
        Wed,  1 Mar 2023 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677693422;
        bh=GlG9WTRvFOhd1/rVEqTp3kzsLKTNiR+U47FXnoFLqAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UdIeclJWPodc2tetrm+Tv8ed3QOvi/LDxZ1tRYO0ie9yS0IxLS6VQShm8h822ItBx
         SViUO5c9N39gpN40F4l0LIHJPElpZkibrb3RddBG/KxJA47qKEyBEZQY45UFMXb/qW
         lnWltCI6n63ksXMP27OM1ZPOnm8FK9qFiI1ZtLs+QG4SgnCP2T5FVp+7WG9nZR2Gdn
         wOj2Mpg/+TKUhgS03LqEmJAYXtON+PByco53c2kDeTpCqAQ3EAebG2XnI2lxT+U1+B
         aFjbyBw+cCzKfhsGgzYrI/PNuQa8TK6qu4uUbiLgfgNmr1Akjb/ZK//YCRA2yJsrSk
         +Adm+OnPBpx+g==
Date:   Wed, 1 Mar 2023 17:56:56 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: Re: [PATCH -next v14 12/19] riscv: signal: check fp-reserved words
 unconditionally
Message-ID: <Y/+R6NfBHSGGI3MX@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-13-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nhH51729ejvc3Gu0"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-13-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--nhH51729ejvc3Gu0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:11PM +0000, Andy Chiu wrote:
> In order to let kernel/user locate and identify an extension context on
> the existing sigframe, we are going to utilize reserved space of fp and
> encode the information there. And since the sigcontext has already
> preserved a space for fp context w or w/o CONFIG_FPU, we move those
> reserved words checking/setting routine back into generic code.
>=20
> This commit also undone an additional logical change carried by the
> refactor commit 007f5c3589578
> ("Refactor FPU code in signal setup/return procedures"). Originally we
> did not restore fp context if restoring of gpr have failed. And it was
> fine on the other side. In such way the kernel could keep the regfiles
> intact, and potentially react at the failing point of restore.
>=20
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---

> @@ -90,11 +66,29 @@ static long restore_sigcontext(struct pt_regs *regs,
>  	struct sigcontext __user *sc)
>  {
>  	long err;
> +	size_t i;
> +
>  	/* sc_regs is structured the same as the start of pt_regs */
>  	err =3D __copy_from_user(regs, &sc->sc_regs, sizeof(sc->sc_regs));
> +	if (unlikely(err))
> +		return err;
>  	/* Restore the floating-point state. */

Please preserve the newline after return from where you moved this from.

> -	if (has_fpu())
> -		err |=3D restore_fp_state(regs, &sc->sc_fpregs);
> +	if (has_fpu()) {
> +		err =3D restore_fp_state(regs, &sc->sc_fpregs);
> +		if (unlikely(err))
> +			return err;
> +	}

> @@ -145,11 +139,16 @@ static long setup_sigcontext(struct rt_sigframe __u=
ser *frame,
>  {
>  	struct sigcontext __user *sc =3D &frame->uc.uc_mcontext;
>  	long err;
> +	size_t i;
> +
>  	/* sc_regs is structured the same as the start of pt_regs */
>  	err =3D __copy_to_user(&sc->sc_regs, regs, sizeof(sc->sc_regs));
>  	/* Save the floating-point state. */
>  	if (has_fpu())
>  		err |=3D save_fp_state(regs, &sc->sc_fpregs);
> +	/* We support no other extension state at this time. */
> +	for (i =3D 0; i < ARRAY_SIZE(sc->sc_fpregs.q.reserved); i++)
> +		err |=3D __put_user(0, &sc->sc_fpregs.q.reserved[i]);
>  	return err;

And one before the return here would not go amiss. Those are nitpick
bits though, so:
Acked-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--nhH51729ejvc3Gu0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/+R6AAKCRB4tDGHoIJi
0lq/AP428d0SH5OMhQupf5wh4N6S5tKO9jWU6/2xyschVhjytAD9GcFjI+Ismiko
4y2zOe36Bd7jHxEgMFDw5wtPcx87DAU=
=yvDD
-----END PGP SIGNATURE-----

--nhH51729ejvc3Gu0--
