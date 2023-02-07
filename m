Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D646268DBD4
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjBGOkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbjBGOjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:39:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA143EC6B
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 06:37:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E33B60C66
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 14:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FD8C433D2;
        Tue,  7 Feb 2023 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675780622;
        bh=5V2Syffk8V3ekNhiqQlGMq9dI2fG3xmtlwW6CrEnKH8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=I2yhgFhinb6T8bdHK0Fx54Twb94PXrpghjeDVP6T+wP1qa/ucgsMWdSa7RP9a3nkg
         hZJ6JDxoSN2gi8bZWqgpyesv6Iv1IGIXFwPPe20lpSvmt/vR1eHWQEQ4o2Wl8B3I90
         Zcaf9clscGDRq76H7y4Pfc4ze9UuBcv4IWbF+cscgV0ZZg64ymh8PYQImXy+wyWeSQ
         t4KeCUg/oInGdlim3dNKeyTer7D9RV2QG8nCb/AWPP5NbpwN6zPVMMncKBFy4oJ0py
         en1mTniZz/myPMDEhIa7A3RHSSQX/VhSxrxlLOyEfwbaqbLY6J9bv7mHpQxaDVm6Pk
         /CfOi7YlgTgcQ==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Changbin Du <changbin.du@intel.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v13 10/19] riscv: Allocate user's vector context
 in the first-use trap
In-Reply-To: <20230125142056.18356-11-andy.chiu@sifive.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-11-andy.chiu@sifive.com>
Date:   Tue, 07 Feb 2023 15:36:59 +0100
Message-ID: <875ycdy22c.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy,

(Keeping the huge Cc:-list for now...)

Andy Chiu <andy.chiu@sifive.com> writes:

> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> new file mode 100644
> index 000000000000..cdd58d1c8b3c
> --- /dev/null
> +++ b/arch/riscv/kernel/vector.c
> @@ -0,0 +1,89 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2023 SiFive
> + * Author: Andy Chiu <andy.chiu@sifive.com>
> + */
> +#include <linux/sched/signal.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +
> +#include <asm/thread_info.h>
> +#include <asm/processor.h>
> +#include <asm/insn.h>
> +#include <asm/vector.h>
> +#include <asm/ptrace.h>
> +#include <asm/bug.h>
> +
> +static bool insn_is_vector(u32 insn_buf)
> +{
> +	u32 opcode =3D insn_buf & __INSN_OPCODE_MASK;
> +	/*
> +	 * All V-related instructions, including CSR operations are 4-Byte. So,
> +	 * do not handle if the instruction length is not 4-Byte.
> +	 */
> +	if (unlikely(GET_INSN_LENGTH(insn_buf) !=3D 4))
> +		return false;
> +	if (opcode =3D=3D OPCODE_VECTOR) {
> +		return true;
> +	} else if (opcode =3D=3D OPCODE_LOADFP || opcode =3D=3D OPCODE_STOREFP)=
 {
> +		u32 width =3D EXTRACT_LOAD_STORE_FP_WIDTH(insn_buf);
> +
> +		if (width =3D=3D LSFP_WIDTH_RVV_8 || width =3D=3D LSFP_WIDTH_RVV_16 ||
> +		    width =3D=3D LSFP_WIDTH_RVV_32 || width =3D=3D LSFP_WIDTH_RVV_64)
> +			return true;
> +	} else if (opcode =3D=3D RVG_OPCODE_SYSTEM) {
> +		u32 csr =3D EXTRACT_SYSTEM_CSR(insn_buf);
> +
> +		if ((csr >=3D CSR_VSTART && csr <=3D CSR_VCSR) ||
> +		    (csr >=3D CSR_VL && csr <=3D CSR_VLENB))
> +			return true;
> +	}
> +	return false;
> +}
> +
> +int rvv_thread_zalloc(void)
> +{
> +	void *datap;
> +
> +	datap =3D kzalloc(riscv_vsize, GFP_KERNEL);
> +	if (!datap)
> +		return -ENOMEM;
> +	current->thread.vstate.datap =3D datap;
> +	memset(&current->thread.vstate, 0, offsetof(struct __riscv_v_state,
> +						    datap));
> +	return 0;
> +}
> +
> +bool rvv_first_use_handler(struct pt_regs *regs)
> +{
> +	__user u32 *epc =3D (u32 *)regs->epc;
> +	u32 tval =3D (u32)regs->badaddr;
> +
> +	/* If V has been enabled then it is not the first-use trap */
> +	if (vstate_query(regs))
> +		return false;
> +	/* Get the instruction */
> +	if (!tval) {
> +		if (__get_user(tval, epc))
> +			return false;
> +	}
> +	/* Filter out non-V instructions */
> +	if (!insn_is_vector(tval))
> +		return false;
> +	/* Sanity check. datap should be null by the time of the first-use trap=
 */
> +	WARN_ON(current->thread.vstate.datap);
> +	/*
> +	 * Now we sure that this is a V instruction. And it executes in the
> +	 * context where VS has been off. So, try to allocate the user's V
> +	 * context and resume execution.
> +	 */
> +	if (rvv_thread_zalloc()) {
> +		force_sig(SIGKILL);
> +		return true;
> +	}

Should the altstack size be taken into consideration, like x86 does in
validate_sigaltstack() (see __xstate_request_perm()).

Related; Would it make sense to implement sigaltstack_size_valid() for
riscv, analogous to x86?


Bj=C3=B6rn
