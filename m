Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910BB6A8105
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 12:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCBL1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 06:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCBL1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 06:27:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB5530B33
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 03:27:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB5F9B811EC
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAEAC433D2;
        Thu,  2 Mar 2023 11:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677756467;
        bh=l+LO1Vs1YrHHAkxHk22l+CM6O/lYeoi6XiciBgeCBHs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Fl4M+0Ro3ODDP6XedsF7+17UpxG4N+wcvIYSZiyFwJU432XZd2JnbccMNgMXAhz0+
         WtF+h+V+HnDm5N8cZG6VzpflZEn24QpJj1N/tXHHlnVd+spMvcrShunSoV2+vNFyKw
         bgFZg8UogBcO9no3y4KjUnv5XK/gv9qTwITycMXPo27j7zzKojhln6tKAJppeXPoxU
         37W0bRSFS3M21mu1w9iyUOv/7RbmsCy9GdxlSTOqV+2HZFSEISkMx7RNxyMlAC0Hnd
         UzwzfEeWnxIDH0x8m78PRYdW5t2EACHJr2bMbt2kfAQwjz2Kw2M+CgQjaPsOPL1FOF
         K6tYHq2BLni3w==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rolf Eike Beer <eb@emlix.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH -next v14 11/19] riscv: Add ptrace vector support
In-Reply-To: <20230224170118.16766-12-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-12-andy.chiu@sifive.com>
Date:   Thu, 02 Mar 2023 12:27:45 +0100
Message-ID: <87mt4v4clq.fsf@all.your.base.are.belong.to.us>
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

Andy Chiu <andy.chiu@sifive.com> writes:

> diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
> index 2ae8280ae475..3c0e01d7f8fb 100644
> --- a/arch/riscv/kernel/ptrace.c
> +++ b/arch/riscv/kernel/ptrace.c
> @@ -83,6 +87,62 @@ static int riscv_fpr_set(struct task_struct *target,
>  }
>  #endif
>=20=20
> +#ifdef CONFIG_RISCV_ISA_V
> +static int riscv_vr_get(struct task_struct *target,
> +			const struct user_regset *regset,
> +			struct membuf to)
> +{
> +	struct __riscv_v_ext_state *vstate =3D &target->thread.vstate;
> +
> +	if (!riscv_v_vstate_query(task_pt_regs(target)))
> +		return -EINVAL;
> +	/*
> +	 * Ensure the vector registers have been saved to the memory before
> +	 * copying them to membuf.
> +	 */
> +	if (target =3D=3D current)
> +		riscv_v_vstate_save(current, task_pt_regs(current));
> +
> +	/* Copy vector header from vstate. */
> +	membuf_write(&to, vstate, offsetof(struct __riscv_v_ext_state, datap));
> +	membuf_zero(&to, sizeof(void *));
> +#if __riscv_xlen =3D=3D 32
> +	membuf_zero(&to, sizeof(__u32));
> +#endif

Remind me why the extra care is needed for 32b?


Bj=C3=B6rn
