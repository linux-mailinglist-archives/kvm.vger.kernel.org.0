Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC43C6A828E
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 13:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCBMrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 07:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCBMri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 07:47:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F6483C0
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 04:47:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F58C615A9
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 12:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148D2C433D2;
        Thu,  2 Mar 2023 12:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677761256;
        bh=qxXTnDSLnDzW9XAyEfZfFJ17v1GiXAfCisIZtfQIIPo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=OYcpprr9dhQKjHmcVs7d8egim+jJLpW13T/wP/TIGqikCONYhmOcc8NlPT9/lGrqO
         x+oq1UUOUVKsrd3KgH7aUCR/hQNjkJ0+GIs6mZsn046YcJ/5+GGah2vhBD3oIauTop
         XghD8GAhousLG9vCqz+d5wP3ly7DlN1IX1ivUUQXMyV7Au1kQ1hiXaU6J865LDzLqt
         /8gz1ldt8wIOU5899UKyjt9lWyfxdkqNtbctf25DFViwrEM2lb/vuQaXh+infWZIDM
         VAQvFd9Gf25AQS5yYJ21j+askqMYM4JizbOHYwkWad5dxjUe1nqAtVC/zGLBvt6VWd
         QXBfZZJE9ly8g==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>, guoren@linux.alibaba.com,
        Kees Cook <keescook@chromium.org>,
        Nick Knight <nick.knight@sifive.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        vineetg@rivosinc.com, Al Viro <viro@zeniv.linux.org.uk>,
        Vincent Chen <vincent.chen@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        greentime.hu@sifive.com, Zong Li <zong.li@sifive.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH -next v14 14/19] riscv: signal: Report signal frame size
 to userspace via auxv
In-Reply-To: <20230224170118.16766-15-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-15-andy.chiu@sifive.com>
Date:   Thu, 02 Mar 2023 13:47:33 +0100
Message-ID: <877cvz48wq.fsf@all.your.base.are.belong.to.us>
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

> From: Vincent Chen <vincent.chen@sifive.com>
>
> The vector register belongs to the signal context. They need to be stored
> and restored as entering and leaving the signal handler. According to the
> V-extension specification, the maximum length of the vector registers can
> be 2^(XLEN-1). Hence, if userspace refers to the MINSIGSTKSZ to create a
> sigframe, it may not be enough. To resolve this problem, this patch refers
> to the commit 94b07c1f8c39c
> ("arm64: signal: Report signal frame size to userspace via auxv") to enab=
le
> userspace to know the minimum required sigframe size through the auxiliary
> vector and use it to allocate enough memory for signal context.
>
> Note that auxv always reports size of the sigframe as if V exists for
> all starting processes, whenever the kernel has CONFIG_RISCV_ISA_V. The
> reason is that users usually reference this value to allocate an
> alternative signal stack, and the user may use V anytime. So the user
> must reserve a space for V-context in sigframe in case that the signal
> handler invokes after the kernel allocating V.
>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  arch/riscv/include/asm/elf.h         |  9 +++++++++
>  arch/riscv/include/asm/processor.h   |  2 ++
>  arch/riscv/include/uapi/asm/auxvec.h |  1 +
>  arch/riscv/kernel/signal.c           | 20 +++++++++++++++-----
>  4 files changed, 27 insertions(+), 5 deletions(-)
>
> diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
> index 30e7d2455960..ca23c4f6c440 100644
> --- a/arch/riscv/include/asm/elf.h
> +++ b/arch/riscv/include/asm/elf.h
> @@ -105,6 +105,15 @@ do {								\
>  		get_cache_size(3, CACHE_TYPE_UNIFIED));		\
>  	NEW_AUX_ENT(AT_L3_CACHEGEOMETRY,			\
>  		get_cache_geometry(3, CACHE_TYPE_UNIFIED));	\
> +	/*							 \
> +	 * Should always be nonzero unless there's a kernel bug. \
> +	 * If we haven't determined a sensible value to give to	 \
> +	 * userspace, omit the entry:				 \
> +	 */							 \
> +	if (likely(signal_minsigstksz))				 \
> +		NEW_AUX_ENT(AT_MINSIGSTKSZ, signal_minsigstksz); \
> +	else							 \
> +		NEW_AUX_ENT(AT_IGNORE, 0);			 \
>  } while (0)
>  #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
>  struct linux_binprm;
> diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/=
processor.h
> index f0ddf691ac5e..38ded8c5f207 100644
> --- a/arch/riscv/include/asm/processor.h
> +++ b/arch/riscv/include/asm/processor.h
> @@ -7,6 +7,7 @@
>  #define _ASM_RISCV_PROCESSOR_H
>=20=20
>  #include <linux/const.h>
> +#include <linux/cache.h>
>=20=20
>  #include <vdso/processor.h>
>=20=20
> @@ -81,6 +82,7 @@ int riscv_of_parent_hartid(struct device_node *node, un=
signed long *hartid);
>  extern void riscv_fill_hwcap(void);
>  extern int arch_dup_task_struct(struct task_struct *dst, struct task_str=
uct *src);
>=20=20
> +extern unsigned long signal_minsigstksz __ro_after_init;
>  #endif /* __ASSEMBLY__ */
>=20=20
>  #endif /* _ASM_RISCV_PROCESSOR_H */
> diff --git a/arch/riscv/include/uapi/asm/auxvec.h b/arch/riscv/include/ua=
pi/asm/auxvec.h
> index fb187a33ce58..2c50d9ca30e0 100644
> --- a/arch/riscv/include/uapi/asm/auxvec.h
> +++ b/arch/riscv/include/uapi/asm/auxvec.h
> @@ -35,5 +35,6 @@
>=20=20
>  /* entries in ARCH_DLINFO */
>  #define AT_VECTOR_SIZE_ARCH	9
> +#define AT_MINSIGSTKSZ 51

Proper tab alignment missing.

>=20=20
>  #endif /* _UAPI_ASM_RISCV_AUXVEC_H */
> diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
> index 76c0480ee4cd..aa8ee95dee2d 100644
> --- a/arch/riscv/kernel/signal.c
> +++ b/arch/riscv/kernel/signal.c
> @@ -21,6 +21,8 @@
>  #include <asm/vector.h>
>  #include <asm/csr.h>
>=20=20
> +unsigned long __ro_after_init signal_minsigstksz;

Nit: __ro_after_init placement insistent with the declaration above.


Bj=C3=B6rn
