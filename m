Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757B07CF285
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 10:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbjJSI10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 04:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235288AbjJSI1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 04:27:24 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A79186
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:27:22 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-408425c7c10so6770195e9.0
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697704040; x=1698308840; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aS9ZmATMA5UdrpXcs84XzGO/WomcKSWd4ogsdFNAVRI=;
        b=XeWRh86NjQnJhCBd8Cr+Vl4dZlXoiCz0GwycngbJlR16x1ywvojIjh/UUDdn7MHnNq
         VqwtW1qQGPrXZ0fZQGGc9U6ybwc8y0HmfLDerpVU6QRjNXeJqRRm3vFTXkwfUZRHtslf
         4XNr+sqxHbvhiVFOkgO4gz+YtI8lfSRtdtDbaCJFydbNfCfwaGgHdqmjgg2SWbGvvPgH
         AF46fUdxRtIY8bpcoxoCHrZE0EkVj0HdWLotshF/LILmyJ4y2GLpprUfpXNaigkLPe4+
         Ro549X/Nx3m0SnNguhOZJbl3GRqXuyP7ZJokkFvtKjMDu5xvFKoPfeSnJ6C3bKDpR7R9
         iS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697704040; x=1698308840;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aS9ZmATMA5UdrpXcs84XzGO/WomcKSWd4ogsdFNAVRI=;
        b=UM4d/7kJjEy/A6X6y0wbEmMLkQNr31sS2ZAzLe6xyo4ec7nULgL0eWNJ1MsNflgnG7
         5ldG73PuchLKSzw0pQMm3vSgy31tT/5ickzBXZCcHBwKRWhh0uERXOObivSGA5wTTxvJ
         GjSGYCAFmSjFb6BzOJ9Sa4uCEafDRe2NGMVbVQ+syL/Eefmzv/jOJ2lT3ysCP05GJq9G
         KdIuLdrrjMCIhPsXIOkewS6hEXP7nmHLX3anKYq8+b0J8bhE8N2T5yqhs3a4JkKwEgH3
         xVLdXuVU4YdbpCbzCsMSxyZRG+51YGpVKgMMIFGxVURARDODn7hc41zJK92jYqvBM2h3
         L9XQ==
X-Gm-Message-State: AOJu0YxlyxrSIOqk8DsppKanFeqj/9EwMUymkNn+ZapgCyRRKTwSN9fi
        /5GPZxUzh2Hu85DyKYDfxa3n7I28bkh1X9nIZ8o=
X-Google-Smtp-Source: AGHT+IHskKNqI6cyPtwKoTi5Al9ucFLHv3VeiXwM9dmzqt6kOBsKQXH4yfubGN4sdMpzP0jv+CThYA==
X-Received: by 2002:a05:600c:3542:b0:401:73b2:f039 with SMTP id i2-20020a05600c354200b0040173b2f039mr1228282wmq.7.1697704040501;
        Thu, 19 Oct 2023 01:27:20 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id o36-20020a05600c512400b00405959469afsm3842187wms.3.2023.10.19.01.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 01:27:19 -0700 (PDT)
Date:   Thu, 19 Oct 2023 10:27:13 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/8] tty/serial: Add RISC-V SBI debug console based
 earlycon
Message-ID: <20231019-f3c3768f5e95e747e1457c49@orel>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
 <20231012051509.738750-7-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012051509.738750-7-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 10:45:07AM +0530, Anup Patel wrote:
> We extend the existing RISC-V SBI earlycon support to use the new
> RISC-V SBI debug console extension.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  drivers/tty/serial/Kconfig              |  2 +-
>  drivers/tty/serial/earlycon-riscv-sbi.c | 32 +++++++++++++++++++++----
>  2 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index bdc568a4ab66..cec46091a716 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -87,7 +87,7 @@ config SERIAL_EARLYCON_SEMIHOST
>  
>  config SERIAL_EARLYCON_RISCV_SBI
>  	bool "Early console using RISC-V SBI"
> -	depends on RISCV_SBI_V01
> +	depends on RISCV_SBI
>  	select SERIAL_CORE
>  	select SERIAL_CORE_CONSOLE
>  	select SERIAL_EARLYCON
> diff --git a/drivers/tty/serial/earlycon-riscv-sbi.c b/drivers/tty/serial/earlycon-riscv-sbi.c
> index 27afb0b74ea7..c21cdef254e7 100644
> --- a/drivers/tty/serial/earlycon-riscv-sbi.c
> +++ b/drivers/tty/serial/earlycon-riscv-sbi.c
> @@ -15,17 +15,41 @@ static void sbi_putc(struct uart_port *port, unsigned char c)
>  	sbi_console_putchar(c);
>  }
>  
> -static void sbi_console_write(struct console *con,
> -			      const char *s, unsigned n)
> +static void sbi_0_1_console_write(struct console *con,
> +				  const char *s, unsigned int n)
>  {
>  	struct earlycon_device *dev = con->data;
>  	uart_console_write(&dev->port, s, n, sbi_putc);
>  }
>  
> +static void sbi_dbcn_console_write(struct console *con,
> +				   const char *s, unsigned int n)
> +{
> +	phys_addr_t pa = __pa(s);
> +
> +	if (IS_ENABLED(CONFIG_32BIT))
> +		sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
> +			  n, lower_32_bits(pa), upper_32_bits(pa), 0, 0, 0);
> +	else
> +		sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
> +			  n, pa, 0, 0, 0, 0);
> +}
> +
>  static int __init early_sbi_setup(struct earlycon_device *device,
>  				  const char *opt)
>  {
> -	device->con->write = sbi_console_write;
> -	return 0;
> +	int ret = 0;
> +
> +	if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&
> +	    (sbi_probe_extension(SBI_EXT_DBCN) > 0)) {
> +		device->con->write = sbi_dbcn_console_write;
> +	} else {
> +		if (IS_ENABLED(CONFIG_RISCV_SBI_V01))
> +			device->con->write = sbi_0_1_console_write;
> +		else
> +			ret = -ENODEV;
> +	}
> +
> +	return ret;
>  }
>  EARLYCON_DECLARE(sbi, early_sbi_setup);
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
