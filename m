Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE837643095
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 19:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbiLESkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 13:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiLESkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 13:40:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F6F23159;
        Mon,  5 Dec 2022 10:36:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E142B80E6F;
        Mon,  5 Dec 2022 18:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B86C433D6;
        Mon,  5 Dec 2022 18:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670265410;
        bh=OQdvaLSoaiBbTTeKD827k+4rYmwOJ9xbFSL1aPRYkUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G+9IUmmxBh5gC369f8/d/uPzj6Zkb+7CI3SvLvLo7xJHLH0rBA21oTgkmVrPWOViT
         rBQy1UaWCVNWSCxSCPIsD0emZrqBpxiBVLv3QYarlQaYthhWsUkj1x0WCRTHeM1Wfd
         D0BEi6k9iFMCNmtqzN+bd0wndTufsRWdRrd+1yJH5Pi6xCLbUzOyki2MUBtjCK7BUr
         IuOqXY0BT0velhXHVw2msD1Iuf4jDJ6hh8LttPHoxVnbAFFmpw4gENyBZV41CNb2R7
         QTOchzLUTlY/Hb/Wpq7nlC/ShzOBLStlp9KyP7Mfe+ERAYA69bfrwQFjsiL4r2KrG5
         uU05A4S2JhIYg==
Date:   Mon, 5 Dec 2022 18:36:45 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/13] riscv: fix jal offsets in patched alternatives
Message-ID: <Y446PdlUPGw5iB71@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-2-jszhang@kernel.org>
 <4764569.GXAFRqVoOG@diego>
 <Y44Q/B6THtP38eyL@xhacker>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ygsvAbVCNFXeErrf"
Content-Disposition: inline
In-Reply-To: <Y44Q/B6THtP38eyL@xhacker>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ygsvAbVCNFXeErrf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Heiko, Jisheng,

On Mon, Dec 05, 2022 at 11:40:44PM +0800, Jisheng Zhang wrote:
> On Mon, Dec 05, 2022 at 04:31:08PM +0100, Heiko St=FCbner wrote:
> > Am Sonntag, 4. Dezember 2022, 18:46:20 CET schrieb Jisheng Zhang:
> > > Alternatives live in a different section, so offsets used by jal
> > > instruction will point to wrong locations after the patch got applied.
> > >=20
> > > Similar to arm64, adjust the location to consider that offset.
> > >=20
> > > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > > ---
> > >  arch/riscv/include/asm/alternative.h |  2 ++
> > >  arch/riscv/kernel/alternative.c      | 38 ++++++++++++++++++++++++++=
++
> > >  arch/riscv/kernel/cpufeature.c       |  3 +++
> > >  3 files changed, 43 insertions(+)
> > >=20
> > > diff --git a/arch/riscv/include/asm/alternative.h b/arch/riscv/includ=
e/asm/alternative.h
> > > index c58ec3cc4bc3..33eae9541684 100644
> > > --- a/arch/riscv/include/asm/alternative.h
> > > +++ b/arch/riscv/include/asm/alternative.h
> > > @@ -29,6 +29,8 @@ void apply_module_alternatives(void *start, size_t =
length);
> > > =20
> > >  void riscv_alternative_fix_auipc_jalr(void *alt_ptr, unsigned int le=
n,
> > >  				      int patch_offset);
> > > +void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
> > > +			       int patch_offset);
> > > =20
> > >  struct alt_entry {
> > >  	void *old_ptr;		 /* address of original instruciton or data  */
> > > diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alte=
rnative.c
> > > index 292cc42dc3be..9d88375624b5 100644
> > > --- a/arch/riscv/kernel/alternative.c
> > > +++ b/arch/riscv/kernel/alternative.c
> > > @@ -125,6 +125,44 @@ void riscv_alternative_fix_auipc_jalr(void *alt_=
ptr, unsigned int len,
> > >  	}
> > >  }
> > > =20
> > > +#define to_jal_imm(value)						\
> > > +	(((value & (RV_J_IMM_10_1_MASK << RV_J_IMM_10_1_OFF)) << RV_I_IMM_1=
1_0_OPOFF) | \
> > > +	 ((value & (RV_J_IMM_11_MASK << RV_J_IMM_11_OFF)) << RV_J_IMM_11_OP=
OFF) | \
> > > +	 ((value & (RV_J_IMM_19_12_OPOFF << RV_J_IMM_19_12_OFF)) << RV_J_IM=
M_19_12_OPOFF) | \
> > > +	 ((value & (1 << RV_J_IMM_SIGN_OFF)) << RV_J_IMM_SIGN_OPOFF))
> > > +
> > > +void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
> > > +			       int patch_offset)
> > > +{
> >=20
> > I think we might want to unfiy this into a common function like
> >=20
> > 	riscv_alternative_fix_offsets(...)
> >=20
> > so that we only run through the code block once
> >=20
> > 	for (i =3D 0; i < num_instr; i++) {
> > 		if (riscv_insn_is_auipc_jalr(inst1, inst2)) {
> > 			riscv_alternative_fix_auipc_jalr(...)
> > 			continue;
> > 		}
> >=20
> > 		if (riscv_insn_is_jal(inst)) {
> > 			riscv_alternative_fix_jal(...)
> > 			continue;
> > 		}
> > 	}
> >=20
> > This would also remove the need from calling multiple functions
> > after patching alternatives.
>=20
> Yesterday, I also wanted to unify the two instruction fix into
> one. But that would need to roll back the
> riscv_alternative_fix_auipc_jalr() to your v1 version. And IMHO,
> it's better if you can split the Zbb string optimizations series
> into two: one for alternative improvements, another for Zbb. Then
> we may get the alternative improvements and this inst extension
> series merged in v6.2-rc1.

Heiko, perhaps you can correct me here:

Last Wednesday you & Palmer agreed that it was too late in the cycle to
apply any of the stuff touching alternatives?
If I do recall correctly, gives plenty of time to sort out any
interdependent changes here.

Could easily be misremembering, wouldn't be the first time!

Thanks,
Conor.

> > > +	int num_instr =3D len / sizeof(u32);
> > > +	unsigned int call;
> > > +	int i;
> > > +	int imm;
> > > +
> > > +	for (i =3D 0; i < num_instr; i++) {
> > > +		u32 inst =3D riscv_instruction_at(alt_ptr, i);
> > > +
> > > +		if (!riscv_insn_is_jal(inst))
> > > +			continue;
> > > +
> > > +		/* get and adjust new target address */
> > > +		imm =3D RV_EXTRACT_JTYPE_IMM(inst);
> > > +		imm -=3D patch_offset;
> > > +
> > > +		/* pick the original jal */
> > > +		call =3D inst;
> > > +
> > > +		/* drop the old IMMs, all jal imm bits sit at 31:12 */
> > > +		call &=3D ~GENMASK(31, 12);
> > > +
> > > +		/* add the adapted IMMs */
> > > +		call |=3D to_jal_imm(imm);
> > > +
> > > +		/* patch the call place again */
> > > +		patch_text_nosync(alt_ptr + i * sizeof(u32), &call, 4);
> > > +	}
> > > +}
> > > +
> > >  /*
> > >   * This is called very early in the boot process (directly after we =
run
> > >   * a feature detect on the boot CPU). No need to worry about other C=
PUs
> > > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufe=
ature.c
> > > index ba62a4ff5ccd..c743f0adc794 100644
> > > --- a/arch/riscv/kernel/cpufeature.c
> > > +++ b/arch/riscv/kernel/cpufeature.c
> > > @@ -324,6 +324,9 @@ void __init_or_module riscv_cpufeature_patch_func=
(struct alt_entry *begin,
> > >  			riscv_alternative_fix_auipc_jalr(alt->old_ptr,
> > >  							 alt->alt_len,
> > >  							 alt->old_ptr - alt->alt_ptr);
> > > +			riscv_alternative_fix_jal(alt->old_ptr,
> > > +						  alt->alt_len,
> > > +						  alt->old_ptr - alt->alt_ptr);
> > >  		}
> > >  	}
> > >  }
> > >=20
> >=20
> >=20
> >=20
> >=20

--ygsvAbVCNFXeErrf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY446PQAKCRB4tDGHoIJi
0ldEAPwJgljT3AEEEsnqENoQ+sR344tG9T7LxDrQkdoYyWpvjgEAuK3E28qSwJLI
qWSBSkWndIm2Tg+iQ+ibDY6yCGsg5w4=
=2L1g
-----END PGP SIGNATURE-----

--ygsvAbVCNFXeErrf--
