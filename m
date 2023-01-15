Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBC366B28F
	for <lists+kvm@lfdr.de>; Sun, 15 Jan 2023 17:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjAOQ3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 11:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjAOQ3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 11:29:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21C24C13;
        Sun, 15 Jan 2023 08:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF6BCB80B32;
        Sun, 15 Jan 2023 16:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ECEC433D2;
        Sun, 15 Jan 2023 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673800149;
        bh=Wt8nQy5JPCP9oRkQ5+sBiko1fzkFcMk22feZiNjlTU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hIshr8csUdqzGm8TkqeW8l06ROROLC2+1nMTcDzIuXx3x6Kl2wvCMjNlppAl2RNIc
         ozTVuTuPF50cWUHfS+E7u9koqaCZe96ws8Yjth0tUdzxzDwnkJM4tmJpanVOGcNacG
         A0VbWO6qgqVh96lzVTHX1f6eHu6WZlbEbQxzryl0huIBEh6HExUbZYm80rqAxhDKpg
         jzj39Zx4c3ReasolUUx5gTgttnu9itQ2L5ljgfOZdgDp8BS/iH8E6bN7vk485qOYA3
         T4PwRqyJPV1yCPPpcBuZcSfeGFRadOdiHE1P3Ir1EIJQb6NWmgEE98miwhslidJpRk
         fAGSsk31XECtg==
Date:   Sun, 15 Jan 2023 16:29:04 +0000
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
Subject: Re: [PATCH v4 06/13] riscv: introduce
 riscv_has_extension_[un]likely()
Message-ID: <Y8Qp0NcIPPGqUDGl@spud>
References: <20230115154953.831-1-jszhang@kernel.org>
 <20230115154953.831-7-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HUUCBRPY9dF6efL2"
Content-Disposition: inline
In-Reply-To: <20230115154953.831-7-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--HUUCBRPY9dF6efL2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Jisheng,

On Sun, Jan 15, 2023 at 11:49:46PM +0800, Jisheng Zhang wrote:
> Generally, riscv ISA extensions are fixed for any specific hardware
> platform, so a hart's features won't change after booting. This
> chacteristic makes it straightforward to use a static branch to check
> if a specific ISA extension is supported or not to optimize
> performance.
>=20
> However, some ISA extensions such as SVPBMT and ZICBOM are handled
> via. the alternative sequences.
>=20
> Basically, for ease of maintenance, we prefer to use static branches
> in C code, but recently, Samuel found that the static branch usage in
> cpu_relax() breaks building with CONFIG_CC_OPTIMIZE_FOR_SIZE[1]. As
> Samuel pointed out, "Having a static branch in cpu_relax() is
> problematic because that function is widely inlined, including in some
> quite complex functions like in the VDSO. A quick measurement shows
> this static branch is responsible by itself for around 40% of the jump
> table."
>=20
> Samuel's findings pointed out one of a few downsides of static branches
> usage in C code to handle ISA extensions detected at boot time:
> static branch's metadata in the __jump_table section, which is not
> discarded after ISA extensions are finalized, wastes some space.
>=20
> I want to try to solve the issue for all possible dynamic handling of
> ISA extensions at boot time. Inspired by Mark[2], this patch introduces
> riscv_has_extension_*() helpers, which work like static branches but
> are patched using alternatives, thus the metadata can be freed after
> patching.
>=20
> Link: https://lore.kernel.org/linux-riscv/20220922060958.44203-1-samuel@s=
holland.org/ [1]
> Link: https://lore.kernel.org/linux-arm-kernel/20220912162210.3626215-8-m=
ark.rutland@arm.com/ [2]
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

It'd be great, if, in the future, you would hold off on sending new
versions of patchsets where the previous version is still being
discussed [3].
~3 days between versions is not very much, especially when that includes
a weekend!
I know you replied there earlier today with your opinion, but please
give people a chance to read and respond, before resubmitting, so as not
to split discussion between several threads.

3 - https://lore.kernel.org/linux-riscv/2398293.3Lj2Plt8kZ@diego/

Thanks,
Conor.


--HUUCBRPY9dF6efL2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8Qp0AAKCRB4tDGHoIJi
0pPnAQCsIsNUGq5IDZkIgbOznwtHyiQL3aKdAxLmntEOJDBOJgD/dvpGPPetV8gc
DnsHNxe/93fMhhgnj9EtBjFUkmIeug0=
=naIL
-----END PGP SIGNATURE-----

--HUUCBRPY9dF6efL2--
