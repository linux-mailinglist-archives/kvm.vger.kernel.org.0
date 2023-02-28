Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123F66A6389
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 00:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjB1XCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 18:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjB1XCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 18:02:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D304537B42
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 15:01:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DE4CB80ED5
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 23:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40E1C433D2;
        Tue, 28 Feb 2023 23:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677625245;
        bh=Qt0O6bdmuPJ7B8iB7q/Qgq8LDlFMZVmphOThxG+DNs4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=US53Li4XsbGHVslS+XKSdC0EukXurbrRhhBajJ1eIV76Fu6J1d40QoLwu+k82TGdj
         oTJ5VLcgXNIT2lg7/3ZVunGO7jnL7sH/lELh4PdwC5XI7s7vSOn3qJXZOTLcoM5Hpb
         T0xFov1a+6uSsSkRSLVVT+5Ay2Du+qaJINLkXNOgKryh6qoMag6aLDNzASzPTrRsfT
         Bi2lxPNFV8IBDjxsTNAAjHMgN5yedExng5xrjnjBfsP0XyjMQHmX8olgP6AAOpGUIb
         l79KmLfc3a9CrVImLPtZD4xZOdhVusleAZdJQcEEBpI4bBAwiN3yGmCPEtgut831h7
         6w7k81N3sQvyQ==
Date:   Tue, 28 Feb 2023 23:00:40 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v14 08/19] riscv: Introduce struct/helpers to
 save/restore per-task Vector state
Message-ID: <Y/6HmORLbsFWsEbu@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-9-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lRGnHR3a+VMRRi/J"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-9-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--lRGnHR3a+VMRRi/J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:07PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> Add vector state context struct to be added later in thread_struct. And
> prepare low-level helper functions to save/restore vector contexts.
>=20
> This include Vector Regfile and CSRs holding dynamic configuration state
> (vstart, vl, vtype, vcsr). The Vec Register width could be implementation
> defined, but same for all processes, so that is saved separately.
>=20
> This is not yet wired into final thread_struct - will be done when
> __switch_to actually starts doing this in later patches.
>=20
> Given the variable (and potentially large) size of regfile, they are
> saved in dynamically allocated memory, pointed to by datap pointer in
> __riscv_v_ext_state.
>=20
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> [vineetg: merged bits from 2 different patches]
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> [andy.chiu: use inline asm to save/restore context, remove asm vaiant]
> ---
>  arch/riscv/include/asm/vector.h      | 84 ++++++++++++++++++++++++++++
>  arch/riscv/include/uapi/asm/ptrace.h | 17 ++++++
>  2 files changed, 101 insertions(+)
>=20
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vec=
tor.h
> index 692d3ee2d2d3..9c025f2efdc3 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -12,6 +12,9 @@
> =20
>  #include <asm/hwcap.h>
>  #include <asm/csr.h>
> +#include <asm/asm.h>
> +
> +#define CSR_STR(x) __ASM_STR(x)

TBH, I'm not really sure what this definition adds.

>  extern unsigned long riscv_v_vsize;
>  void riscv_v_setup_vsize(void);
> @@ -21,6 +24,26 @@ static __always_inline bool has_vector(void)
>  	return riscv_has_extension_likely(RISCV_ISA_EXT_v);
>  }
> =20
> +static inline void __riscv_v_vstate_clean(struct pt_regs *regs)
> +{
> +	regs->status =3D (regs->status & ~(SR_VS)) | SR_VS_CLEAN;
> +}
> +
> +static inline void riscv_v_vstate_off(struct pt_regs *regs)
> +{
> +	regs->status =3D (regs->status & ~SR_VS) | SR_VS_OFF;

Inconsistent use of brackets here compared to the other items.
They're not actually needed anywhere here, are they?

> +}
> +
> +static inline void riscv_v_vstate_on(struct pt_regs *regs)
> +{
> +	regs->status =3D (regs->status & ~(SR_VS)) | SR_VS_INITIAL;
> +}

Other than that, this seems fine? I only really had a quick check of the
asm though, so with the brackets thing fixed up:
Acked-by: Conor Dooley <conor.dooley@microchip.com>

--lRGnHR3a+VMRRi/J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/6HmAAKCRB4tDGHoIJi
0vfUAQCyJLijRLHfYjJGEK456WGOGrOTPZyx5PaZ3cx4i49JaQEAxShulI0ueyUc
D64I4CrBdKBKVfjbUMm+Xnxa+Wjd/gY=
=m4E8
-----END PGP SIGNATURE-----

--lRGnHR3a+VMRRi/J--
