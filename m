Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B74D6A7634
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCAVep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCAVen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:34:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D55231E3
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 13:34:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 060AAB81135
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 21:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6DCC433EF;
        Wed,  1 Mar 2023 21:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677706479;
        bh=ig3Hl3nEpWU8/6DTitC4SLqyY6r2VKOxYmzoDEYw5Hk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A7/qFped6BFkAhwq8aIEJkFaj2VUXZuQC8mgKvVGiSMzeUb2HPLlgpLovW3lb0+1R
         BVuOo0CjTFEzUiVvJgGOs33kQ/eKbrQ/Yi6mtPLZTicM/L9bodlr4yCP72z37mU89s
         I3QQTAJqoxYKe5tPWU9MzuakcUEwEdh7H2ivqgKEzo3s7180Vsa3R+jULvBtzux/vR
         AvAXNwThZk87ZRjCXGP3pUOwjWqvdMeqcF8CLYIyqUaMQ9S050D1UdHeocN456r5Wm
         LiTxsYD3He8qOLtFOgyIsXgfjHW3LJcDu1br+dz6ozv75cQzSVs4EqYQfsmrdKNn0V
         Si+4OXiUIccTQ==
Date:   Wed, 1 Mar 2023 21:34:33 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, ShihPo Hung <shihpo.hung@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH -next v14 16/19] riscv: prevent stack corruption by
 reserving task_pt_regs(p) early
Message-ID: <d20d93b0-a36f-41e0-aa4d-8525caca7fb5@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-17-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NGS829YiPh9QiuzW"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-17-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--NGS829YiPh9QiuzW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Andy
On Fri, Feb 24, 2023 at 05:01:15PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> Early function calls, such as setup_vm, relocate_enable_mmu,

Here, and elsewhere in the series, please append the () to functions in
commit text.

> soc_early_init etc, are free to operate on stack. However,
> PT_SIZE_ON_STACK bytes at the head of the kernel stack are purposedly
> reserved for the placement of per-task register context pointed by
> task_pt_regs(p). Those functions may corrupt task_pt_regs if we overlap
> the $sp with it. In fact, we had accidentally corrupted sstatus.VS in some
> tests, treating the kernel to save V context before V was actually
> allocated, resulting in a kernel panic.
>=20
> Thus, we should skip PT_SIZE_ON_STACK for $sp before making C function
> calls from the top-level assembly.
>=20
> Co-developed-by: ShihPo Hung <shihpo.hung@sifive.com>
> Signed-off-by: ShihPo Hung <shihpo.hung@sifive.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  arch/riscv/kernel/head.S | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index e16bb2185d55..11c3b94c4534 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -301,6 +301,7 @@ clear_bss_done:
>  	la tp, init_task
>  	la sp, init_thread_union + THREAD_SIZE
>  	XIP_FIXUP_OFFSET sp
> +	addi sp, sp, -PT_SIZE_ON_STACK
>  #ifdef CONFIG_BUILTIN_DTB
>  	la a0, __dtb_start
>  	XIP_FIXUP_OFFSET a0
> @@ -318,6 +319,7 @@ clear_bss_done:
>  	/* Restore C environment */
>  	la tp, init_task
>  	la sp, init_thread_union + THREAD_SIZE
> +	addi sp, sp, -PT_SIZE_ON_STACK

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

--NGS829YiPh9QiuzW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY//E6QAKCRB4tDGHoIJi
0gIeAP47Q3iTPP/wbfPgD3XmUbXTwv5fVRKeyc6wKddNiLcobAEAiajdMX1TNBfm
Owh93zEEyBj/ENwFB2HjBlakLoxH3Ag=
=VuoZ
-----END PGP SIGNATURE-----

--NGS829YiPh9QiuzW--
