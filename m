Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBDF7C0250
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 19:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbjJJRMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 13:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbjJJRMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 13:12:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8638C97;
        Tue, 10 Oct 2023 10:12:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E682C433C7;
        Tue, 10 Oct 2023 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1696957965;
        bh=+k83Wr/EUECBDmTY4zF/z/iAjbCmN1Z0PcCaY918fko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h8/uqYlf08jWlRslIBjTFO+O3KgIK4hpU8keuMdttxUwK2/9BA0rrNe2DhBa7HpYl
         I/alfdg11rxUhylY0/9H2xtDI6H1yC7wPztb9/1hUE9ZzcSiPSz0b0kYJerOuVfCok
         WHXS5S9wReYUkDvdHstV1VmsH6cDy1VV/U/4BhNk=
Date:   Tue, 10 Oct 2023 19:12:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Subject: Re: [PATCH 5/6] tty: Add SBI debug console support to HVC SBI driver
Message-ID: <2023101045-hazard-popcorn-7d19@gregkh>
References: <20231010170503.657189-1-apatel@ventanamicro.com>
 <20231010170503.657189-6-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010170503.657189-6-apatel@ventanamicro.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 10:35:02PM +0530, Anup Patel wrote:
> --- a/drivers/tty/hvc/hvc_riscv_sbi.c
> +++ b/drivers/tty/hvc/hvc_riscv_sbi.c
> @@ -15,6 +15,7 @@
>  
>  #include "hvc_console.h"
>  
> +#ifdef CONFIG_RISCV_SBI_V01

Please no #ifdef in a .c file, that's not a good style for Linux code at
all.

And what if you want to build the driver for both options here?  What
will happen?

> +static int hvc_sbi_dbcn_tty_put(uint32_t vtermno, const char *buf, int count)
>  {
> -	return PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_ops, 16));
> +	phys_addr_t pa;
> +	struct sbiret ret;
> +
> +	if (is_vmalloc_addr(buf))
> +		pa = page_to_phys(vmalloc_to_page(buf)) + offset_in_page(buf);
> +	else
> +		pa = __pa(buf);
> +
> +	ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
> +#ifdef CONFIG_32BIT
> +		  count, pa, (u64)pa >> 32,
> +#else
> +		  count, pa, 0,
> +#endif

This is not how to do an api, sorry, again, please no #ifdef if you want
to support this code for the next 20+ years.

thanks,

gre gk-h
