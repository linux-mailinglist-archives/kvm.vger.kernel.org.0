Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66447C6C83
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 13:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377488AbjJLLit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 07:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343824AbjJLLit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 07:38:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672C394;
        Thu, 12 Oct 2023 04:38:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F688C433C7;
        Thu, 12 Oct 2023 11:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697110727;
        bh=VIjNs8XAzFrSrD46vd4rLb+i7yS6FSpOQzPGdLFca3I=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hyQLEv+1J8r5uGrpnxlhbH7cdZUYJ0sUhwdXhnH7m6avcqRv3zQP0sQ8LYdf6kWu7
         /x/B7UHwjQPXgeKsT9kxZr2GB9McF6/+brZFPn1Tb8vtntOLd2ZLGCrWdhdV51SRpG
         mKex4JFjTf6Jp+hTRKW1er/RxhxwXCGxmat7LLs5jzr3rMXlHwVLQaQtN5jr1ZRsfU
         6Cvvwj9rHZjPx9fH1FkgB2pfdSwSrnCHFVouAwZzQprfpoBBkgp5i8kW3cxlnG/k7t
         IOTbVEM1v972unfuwienAF3jcsYgP6l6gf41BNyPK1Wv3Qjy7L1n3vHC+XGwkkixMT
         Dh/KwmVXd9J/g==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>
Subject: Re: [PATCH v2 7/8] tty: Add SBI debug console support to HVC SBI
 driver
In-Reply-To: <20231012051509.738750-8-apatel@ventanamicro.com>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
 <20231012051509.738750-8-apatel@ventanamicro.com>
Date:   Thu, 12 Oct 2023 13:38:44 +0200
Message-ID: <87fs2ghxyz.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anup Patel <apatel@ventanamicro.com> writes:

> From: Atish Patra <atishp@rivosinc.com>
>
> RISC-V SBI specification supports advanced debug console
> support via SBI DBCN extension.
>
> Extend the HVC SBI driver to support it.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  drivers/tty/hvc/Kconfig         |  2 +-
>  drivers/tty/hvc/hvc_riscv_sbi.c | 76 ++++++++++++++++++++++++++++++---
>  2 files changed, 70 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
> index 4f9264d005c0..6e05c5c7bca1 100644
> --- a/drivers/tty/hvc/Kconfig
> +++ b/drivers/tty/hvc/Kconfig
> @@ -108,7 +108,7 @@ config HVC_DCC_SERIALIZE_SMP
>=20=20
>  config HVC_RISCV_SBI
>  	bool "RISC-V SBI console support"
> -	depends on RISCV_SBI_V01
> +	depends on RISCV_SBI
>  	select HVC_DRIVER
>  	help
>  	  This enables support for console output via RISC-V SBI calls, which
> diff --git a/drivers/tty/hvc/hvc_riscv_sbi.c b/drivers/tty/hvc/hvc_riscv_=
sbi.c
> index 31f53fa77e4a..da318d7f55c5 100644
> --- a/drivers/tty/hvc/hvc_riscv_sbi.c
> +++ b/drivers/tty/hvc/hvc_riscv_sbi.c
> @@ -39,21 +39,83 @@ static int hvc_sbi_tty_get(uint32_t vtermno, char *bu=
f, int count)
>  	return i;
>  }
>=20=20
> -static const struct hv_ops hvc_sbi_ops =3D {
> +static const struct hv_ops hvc_sbi_v01_ops =3D {
>  	.get_chars =3D hvc_sbi_tty_get,
>  	.put_chars =3D hvc_sbi_tty_put,
>  };
>=20=20
> -static int __init hvc_sbi_init(void)
> +static int hvc_sbi_dbcn_tty_put(uint32_t vtermno, const char *buf, int c=
ount)
>  {
> -	return PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_ops, 16));
> +	phys_addr_t pa;
> +	struct sbiret ret;
> +
> +	if (is_vmalloc_addr(buf))
> +		pa =3D page_to_phys(vmalloc_to_page(buf)) + offset_in_page(buf);

What is assumed from buf here? If buf is crossing a page, you need to
adjust the count, no?

> +	else
> +		pa =3D __pa(buf);
> +
> +	if (IS_ENABLED(CONFIG_32BIT))
> +		ret =3D sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
> +				count, lower_32_bits(pa), upper_32_bits(pa),
> +				0, 0, 0);
> +	else
> +		ret =3D sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
> +				count, pa, 0, 0, 0, 0);
> +	if (ret.error)
> +		return 0;
> +
> +	return count;
>  }
> -device_initcall(hvc_sbi_init);
>=20=20
> -static int __init hvc_sbi_console_init(void)
> +static int hvc_sbi_dbcn_tty_get(uint32_t vtermno, char *buf, int count)
>  {
> -	hvc_instantiate(0, 0, &hvc_sbi_ops);
> +	phys_addr_t pa;
> +	struct sbiret ret;
> +
> +	if (is_vmalloc_addr(buf))
> +		pa =3D page_to_phys(vmalloc_to_page(buf)) + offset_in_page(buf);

And definitely adjust count here, if we're crossing a page!


Bj=C3=B6rn
