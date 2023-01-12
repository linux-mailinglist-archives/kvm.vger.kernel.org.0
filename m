Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7317C668640
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 22:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjALV7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 16:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbjALV6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 16:58:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97C669B11;
        Thu, 12 Jan 2023 13:49:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5AA0621B1;
        Thu, 12 Jan 2023 21:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A29CC433D2;
        Thu, 12 Jan 2023 21:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673560171;
        bh=FyGX2N8aLoabTK610ZZd/vvyeem2o/slSLIb7/XhtWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EtSPrpnYWWixDYtTIsuM/ysEZQxEU51r/TwZkJV3ZhIeHXyh44gSWFXRI3SitsRbs
         URnUgfWRkOaZR6hi2epr8XdXnrK+I52tuFErEcqLFbGAj5NgFSuJuA0AOlRHI+R0ZC
         Ug13EEevVWaXyjx/9aBHNqflPjwYjoKwynwsZ90nxz8jKHT06t6JrcOvAQZFF9xrtC
         vgwTcadoFKxbmrjzCn0nNz9TFRid4fM8bnvJkzZsa2dWk9+5T6URKUME7LZbieBdjl
         x8DsJfhrcsh8QCZvHPP97dzdC8dsHT9Hapf4m1nnblrO0ehkyJpiPF7lxAKRQEZGqI
         WoCgA56GmRTAg==
Date:   Thu, 12 Jan 2023 21:49:26 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 09/13] riscv: switch to relative alternative entries
Message-ID: <Y8CAZiEnhiMmuiDK@spud>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-10-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KBYdV67AIH88VZb7"
Content-Disposition: inline
In-Reply-To: <20230111171027.2392-10-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--KBYdV67AIH88VZb7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Jisheng,

On Thu, Jan 12, 2023 at 01:10:23AM +0800, Jisheng Zhang wrote:
> Instead of using absolute addresses for both the old instrucions and
> the alternative instructions, use offsets relative to the alt_entry
> values. So this not only cuts the size of the alternative entry, but
> also meets the prerequisite for patching alternatives in the vDSO,
> since absolute alternative entries are subject to dynamic relocation,
> which is incompatible with the vDSO building.
>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  arch/riscv/errata/sifive/errata.c           |  4 +++-
>  arch/riscv/errata/thead/errata.c            | 11 ++++++++---
>  arch/riscv/include/asm/alternative-macros.h | 20 ++++++++++----------
>  arch/riscv/include/asm/alternative.h        | 12 ++++++------
>  arch/riscv/kernel/cpufeature.c              |  8 +++++---
>  5 files changed, 32 insertions(+), 23 deletions(-)
>=20
> diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive=
/errata.c
> index 1031038423e7..0e537cdfd324 100644
> --- a/arch/riscv/errata/sifive/errata.c
> +++ b/arch/riscv/errata/sifive/errata.c
> @@ -107,7 +107,9 @@ void __init_or_module sifive_errata_patch_func(struct=
 alt_entry *begin,
> =20
>  		tmp =3D (1U << alt->errata_id);
>  		if (cpu_req_errata & tmp) {
> -			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> +			patch_text_nosync((void *)&alt->old_offset + alt->old_offset,
> +					  (void *)&alt->alt_offset + alt->alt_offset,
> +					  alt->alt_len);

I left a comment on v2 that went unanswered:
https://lore.kernel.org/all/Y4+3nJ53nvmmc8+z@spud/

The TL;DR is that I would like you to create a macro for this so that
this messy operation is done in a central location, with a nice comment
explaining the offsets. If my "analysis" there was correct, feel free to
use it as a starting point for said comment.

The macro would then reduce the above to something like:
patch_text_nosync(ALT_OFFSET_ADDRESS(alt->old_offset),
		  ALT_OFFSET_ADDRESS(alt->alt_offset),
		  alt->alt_len);

Which I think is easier to understand since this "concept" will show up
in several places & is less intuitive than what we currently have.
Nothing beats having this stuff well explained in the codebase IMO.

> diff --git a/arch/riscv/include/asm/alternative.h b/arch/riscv/include/as=
m/alternative.h
> index 1bd4027d34ca..b6050a235f50 100644
> --- a/arch/riscv/include/asm/alternative.h
> +++ b/arch/riscv/include/asm/alternative.h
> @@ -31,12 +31,12 @@ void riscv_alternative_fix_offsets(void *alt_ptr, uns=
igned int len,
>  				   int patch_offset);
> =20
>  struct alt_entry {
> -	void *old_ptr;		 /* address of original instruciton or data  */
> -	void *alt_ptr;		 /* address of replacement instruction or data */
> -	unsigned long vendor_id; /* cpu vendor id */
> -	unsigned long alt_len;   /* The replacement size */
> -	unsigned int errata_id;  /* The errata id */
> -} __packed;
> +	s32 old_offset;		/* offset relative to original instruciton or data  */
> +	s32 alt_offset;		/* offset relative to replacement instruction or data =
*/

This wording is better, but you should fix the "instruciton" typo while
you are in the area.

> +	u16 vendor_id;		/* cpu vendor id */
> +	u16 alt_len;		/* The replacement size */
> +	u32 errata_id;		/* The errata id */
> +};

Thanks,
Conor.


--KBYdV67AIH88VZb7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8CAZgAKCRB4tDGHoIJi
0shtAP9YcW0IezycxZIeGPU2tI7zgPrK7D5cL+jPTDAw3FrW1gD/T/HO7bWcWRuk
60IRzPs4I2pBqCYKCgvADxQUJBaheAY=
=pQ/k
-----END PGP SIGNATURE-----

--KBYdV67AIH88VZb7--
