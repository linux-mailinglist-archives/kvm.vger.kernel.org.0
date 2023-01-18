Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAC0672B1A
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 23:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjARWLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 17:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjARWLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 17:11:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C91630BD;
        Wed, 18 Jan 2023 14:11:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28AE761A30;
        Wed, 18 Jan 2023 22:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB2FC433D2;
        Wed, 18 Jan 2023 22:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674079869;
        bh=CdZG5/YxLc49feLRzoUlE6cnoB+Dyy0CHB+Umiuydq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kRf994SPqMKZzWMUowCxIVLg8cJ3eE51GDjGUNfDpYuDhiK6AtUImg0AJqu0SX7o0
         Jiby7b9qkGsSSTE8oBDuFSSTd7onTrUNaVJ0MIFbPcyl6kcf0NRTLwzmH22tqC3ljd
         SEG8/6VYfKYONMhsM1HcXkI222re2DNCj7E1bC2HBsYlUceHPlKd07wrT0/5kXFuA9
         ICTp6ZR7yRARSiuzNiXGSOEh83InEyf3KLt3u5nClt5LQY2qVo5NC6NTL/UWYGObxa
         O+tTlDAd5OeL3CWusasP3vGZ4IroWGvlV0efHJBtRsIqb5zSnwQT9Q7Ei3tDTASilu
         KWTUw9jCFeTPQ==
Date:   Wed, 18 Jan 2023 22:11:04 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v4 09/13] riscv: switch to relative alternative entries
Message-ID: <Y8hueOxeSzF6MT2+@spud>
References: <20230115154953.831-1-jszhang@kernel.org>
 <20230115154953.831-10-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bmKuqoHkdUUge14f"
Content-Disposition: inline
In-Reply-To: <20230115154953.831-10-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--bmKuqoHkdUUge14f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 15, 2023 at 11:49:49PM +0800, Jisheng Zhang wrote:
> Instead of using absolute addresses for both the old instrucions and
> the alternative instructions, use offsets relative to the alt_entry
> values. So this not only cuts the size of the alternative entry, but
> also meets the prerequisite for patching alternatives in the vDSO,
> since absolute alternative entries are subject to dynamic relocation,
> which is incompatible with the vDSO building.
>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

> +/* add the relative offset to the address of the offset to get the absol=
ute address */
> +#define __ALT_PTR(a, f)			((void *)&(a)->f + (a)->f)
> +#define ALT_OLD_PTR(a)			__ALT_PTR(a, old_offset)
> +#define ALT_ALT_PTR(a)			__ALT_PTR(a, alt_offset)

LGTM, thanks for doing that! Certainly makes things more understandable.
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

> +		oldptr =3D ALT_OLD_PTR(alt);
> +		altptr =3D ALT_ALT_PTR(alt);
>  		if (!__riscv_isa_extension_available(NULL, alt->errata_id))
>  			continue;
> =20

One minor nit, the oldptr/altptr assignments could go down here, below
the if/continue, right? Obviously don't respin for that though!

> -		patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> -		riscv_alternative_fix_offsets(alt->old_ptr, alt->alt_len,
> -					      alt->old_ptr - alt->alt_ptr);
> +		patch_text_nosync(oldptr, altptr, alt->alt_len);
> +		riscv_alternative_fix_offsets(oldptr, alt->alt_len, oldptr - altptr);
>  	}
>  }
>  #endif


--bmKuqoHkdUUge14f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8hueAAKCRB4tDGHoIJi
0vqnAQCu6VGYhfeHulaTR2wdUMiEo1QZs/vLjK4o0+w72tjqvwEA3JzxSPC2w0S5
hP0afumacfOuguJC+7JJkFbi/XEE2wM=
=RVgk
-----END PGP SIGNATURE-----

--bmKuqoHkdUUge14f--
