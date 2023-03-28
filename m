Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5D26CB661
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 07:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjC1Fxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 01:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC1Fx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 01:53:28 -0400
Received: from mx1.emlix.com (mx1.emlix.com [136.243.223.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579E12685
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 22:53:15 -0700 (PDT)
Received: from mailer.emlix.com (p5098be52.dip0.t-ipconnect.de [80.152.190.82])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 0298D5FB8C;
        Tue, 28 Mar 2023 07:53:12 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Andy Chiu <andy.chiu@sifive.com>
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Qing Zhang <zhangqing@loongson.cn>
Subject: Re: [PATCH -next v17 11/20] riscv: Add ptrace vector support
Date:   Tue, 28 Mar 2023 07:53:00 +0200
Message-ID: <5660672.DvuYhMxLoT@devpool47.emlix.com>
Organization: emlix GmbH
In-Reply-To: <20230327164941.20491-12-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
 <20230327164941.20491-12-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5919597.lOV4Wx5bFT";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--nextPart5919597.lOV4Wx5bFT
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Rolf Eike Beer <eb@emlix.com>
Subject: Re: [PATCH -next v17 11/20] riscv: Add ptrace vector support
Date: Tue, 28 Mar 2023 07:53:00 +0200
Message-ID: <5660672.DvuYhMxLoT@devpool47.emlix.com>
Organization: emlix GmbH
In-Reply-To: <20230327164941.20491-12-andy.chiu@sifive.com>
MIME-Version: 1.0

On Montag, 27. M=C3=A4rz 2023 18:49:31 CEST Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> This patch adds ptrace support for riscv vector. The vector registers will
> be saved in datap pointer of __riscv_v_ext_state. This pointer will be set
> right after the __riscv_v_ext_state data structure then it will be put in
> ubuf for ptrace system call to get or set. It will check if the datap got
> from ubuf is set to the correct address or not when the ptrace system call
> is trying to set the vector registers.
>=20
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> ---
>  arch/riscv/include/uapi/asm/ptrace.h |  7 +++
>  arch/riscv/kernel/ptrace.c           | 70 ++++++++++++++++++++++++++++
>  include/uapi/linux/elf.h             |  1 +
>  3 files changed, 78 insertions(+)
>=20
> diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
> index 23c48b14a0e7..75e66c040b64 100644
> --- a/arch/riscv/kernel/ptrace.c
> +++ b/arch/riscv/kernel/ptrace.c
> @@ -80,6 +84,61 @@ static int riscv_fpr_set(struct task_struct *target,
>  }
>  #endif
>=20
> +#ifdef CONFIG_RISCV_ISA_V
> +static int riscv_vr_get(struct task_struct *target,
> +			const struct user_regset *regset,
> +			struct membuf to)
> +{
> +	struct __riscv_v_ext_state *vstate =3D &target->thread.vstate;
> +
> +	if (!riscv_v_vstate_query(task_pt_regs(target)))
> +		return -EINVAL;
> +
> +	/*
> +	 * Ensure the vector registers have been saved to the memory before
> +	 * copying them to membuf.
> +	 */
> +	if (target =3D=3D current)
> +		riscv_v_vstate_save(current, task_pt_regs(current));
> +
> +	/* Copy vector header from vstate. */
> +	membuf_write(&to, vstate, offsetof(struct __riscv_v_ext_state,=20
datap));
> +	membuf_zero(&to, sizeof(void *));

No idea why I have not seen it in any previous version, but this "sizeof(vo=
id=20
*)" just made me thing "what is going on here?". I personally would have=20
written something like "sizeof(to.var)" or "offsetof(to.buf)" or something =
like=20
that. That makes it easier for me to understand what is skipped/zeroed here=
,=20
let alone making it a bit more fool proof when someone changes one of the=20
struct layouts. YMMV.

Regards,

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source

--nextPart5919597.lOV4Wx5bFT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCZCKAvAAKCRCr5FH7Xu2t
/MJqA/43E26RHc98CNLURi6a5ci9ANMlv1pRjWuGyTEhG7ZIhzJwW/ys2IXttNkq
ffUrDmMgY9C24EggVrxESn9Qp2pn2tlZpE5+Xfn8tvULfzzhcO4HFRMJddIVI1pX
YdXWklrHCdQSwU6abUys9yyAkM/cK1G1VB36bANrm3nXoDQI7A==
=OeNr
-----END PGP SIGNATURE-----

--nextPart5919597.lOV4Wx5bFT--



