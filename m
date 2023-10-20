Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B027D0C5F
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 11:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376736AbjJTJz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 05:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376319AbjJTJz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 05:55:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B119DC2;
        Fri, 20 Oct 2023 02:55:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03568C433C8;
        Fri, 20 Oct 2023 09:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697795756;
        bh=Z8ZuvLU9qD1wAS9sgFRuBmjbVEM7Pn+nD5WWqHJs10M=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=AUJJlKphrqw/o7lmtSQ+IkqWYh8FwAzZh4+CvrE6unyvvs3EQGCT5g/YTWZTTcKpS
         3tscwUlRHcVkD5AvTyY5/rX5LfoJ4dSlRuNzNO3PGkbwl6jQ4oCCI4BMm3kQftVhvH
         VRPKVmf5M4QDnnJy06buHR/ZKq3ZUNAgwoIYH9TChGSW/5l9TW3xXkHO11u0EzEANG
         whJs0N6uL5udv7BZ0zh3XaiaOAZdxqEhjlMtC3crlOzXstm4C74Nvh8ZHFR+MFI3RF
         3aDRCXQCRFea8KycE+r5iHmcYlc1/TXKhp8QT+8YrKpLpIjoqIxrGcnmj1oGc6L3DW
         lAnCrZgHvoqZQ==
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
Subject: Re: [PATCH v3 8/9] tty: Add SBI debug console support to HVC SBI
 driver
In-Reply-To: <20231020072140.900967-9-apatel@ventanamicro.com>
References: <20231020072140.900967-1-apatel@ventanamicro.com>
 <20231020072140.900967-9-apatel@ventanamicro.com>
Date:   Fri, 20 Oct 2023 11:55:53 +0200
Message-ID: <87mswdbot2.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
>  drivers/tty/hvc/hvc_riscv_sbi.c | 82 ++++++++++++++++++++++++++++++---
>  2 files changed, 76 insertions(+), 8 deletions(-)
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
> index 31f53fa77e4a..56da1a4b5aca 100644
> --- a/drivers/tty/hvc/hvc_riscv_sbi.c
> +++ b/drivers/tty/hvc/hvc_riscv_sbi.c
> @@ -39,21 +39,89 @@ static int hvc_sbi_tty_get(uint32_t vtermno, char *bu=
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
> +	if (is_vmalloc_addr(buf)) {
> +		pa =3D page_to_phys(vmalloc_to_page(buf)) + offset_in_page(buf);
> +		if (PAGE_SIZE < (offset_in_page(buf) + count))
> +			count =3D PAGE_SIZE - offset_in_page(buf);

Thanks for fixing the cross-page issue. Now you're cutting the buffer
off. What about doing two SBI calls instead? (Dito on the get side)


Bj=C3=B6rn
