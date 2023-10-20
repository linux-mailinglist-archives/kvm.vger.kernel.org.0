Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5837D0DDC
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 12:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377021AbjJTKrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 06:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377155AbjJTKrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 06:47:32 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88891BEA
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 03:46:49 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-52bd9ddb741so953710a12.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 03:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697798808; x=1698403608; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C4FNgEavOCML3+P3zV8vrHxk6JHiOQKnLJ34VOXcto0=;
        b=I+U0/W+nxa0AT0kG1eL+c5Ly/SNKmeK4/ez6MnXTJfz7denXzzVahRybJ11PHRb8kZ
         re2PUuSIN0Q3s+hxb+dPRF6r+Vo5CqDjKiZOFT+61xT1C3WJPD2j4UtIl5BjEEui4WHP
         HWLu1FKzX4nUcMu7D/KvTgKcfMyQSzDjhcPgu0ZspzuAnzZu8KxAnRxi+sQOWMswECn5
         b36+uNSYwSsP+TydCRwaJxqJYv+1tMnW3SNxE/HOr9MRqPbIRdBzEe09n+oTqCR6MW1I
         sI0UsXP8+ltJ7gJGsXtmUmu1Wf0P3XK/2zteUzNSCC+b+TRTDhoTjBLpGD96vvPR8gbW
         HB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697798808; x=1698403608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C4FNgEavOCML3+P3zV8vrHxk6JHiOQKnLJ34VOXcto0=;
        b=iliv8tPrgVIKSRuAvc7qV8HNCkaH/6IyFKKtZVToHtRQ5cisjvk7Pt5ADhgigh7TEL
         V2koF5njl8IzkCR+NVBfq7Vmp4afbyE9le54Dsm7WAZ48tDpg2tYA75uL0Z/AHR1nthR
         L7j2w59wO/ytyWIxvEhDrWhnAo9gbfKe6M6noGzZEYg2QDJb1o5bSeJFcEjn19xQHVUW
         DSkjlWxTqWvcya9IxAz8Pj9KhXuUp1YuxOWk0byah173KEwpf3PoFkXZzOmVpDT4jsmP
         ay3PJNzAIIZ9+yEOxhcWCaI8bHi/MX1Q+TiIe5arXstfpWxktNbIkKl3LjwQU09+ANbq
         k7Dg==
X-Gm-Message-State: AOJu0Yz8s0Ilow+PnHPNudI1shyQlO4aK/Her6uXOt4k8YgavNsDvPoZ
        ngEbUaGkQXmViq6xQKYRluYCKA==
X-Google-Smtp-Source: AGHT+IGO0GMjn00PKL7e3zKeoD4F27QBrWs+IFdZxdcX9F+Azofcpoji3ND0CTBFW2yKpQjyxJQKzg==
X-Received: by 2002:a17:907:3d92:b0:9b2:b71f:83be with SMTP id he18-20020a1709073d9200b009b2b71f83bemr978732ejc.1.1697798807645;
        Fri, 20 Oct 2023 03:46:47 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id f17-20020a1709062c5100b009c5c5c2c5a4sm1205348ejh.219.2023.10.20.03.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 03:46:47 -0700 (PDT)
Date:   Fri, 20 Oct 2023 12:46:46 +0200
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
        linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Subject: Re: [PATCH v3 8/9] tty: Add SBI debug console support to HVC SBI
 driver
Message-ID: <20231020-f1ec2b7e384a4cfeae39966f@orel>
References: <20231020072140.900967-1-apatel@ventanamicro.com>
 <20231020072140.900967-9-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020072140.900967-9-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 12:51:39PM +0530, Anup Patel wrote:
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
>  
>  config HVC_RISCV_SBI
>  	bool "RISC-V SBI console support"
> -	depends on RISCV_SBI_V01
> +	depends on RISCV_SBI
>  	select HVC_DRIVER
>  	help
>  	  This enables support for console output via RISC-V SBI calls, which
> diff --git a/drivers/tty/hvc/hvc_riscv_sbi.c b/drivers/tty/hvc/hvc_riscv_sbi.c
> index 31f53fa77e4a..56da1a4b5aca 100644
> --- a/drivers/tty/hvc/hvc_riscv_sbi.c
> +++ b/drivers/tty/hvc/hvc_riscv_sbi.c
> @@ -39,21 +39,89 @@ static int hvc_sbi_tty_get(uint32_t vtermno, char *buf, int count)
>  	return i;
>  }
>  
> -static const struct hv_ops hvc_sbi_ops = {
> +static const struct hv_ops hvc_sbi_v01_ops = {
>  	.get_chars = hvc_sbi_tty_get,
>  	.put_chars = hvc_sbi_tty_put,
>  };
>  
> -static int __init hvc_sbi_init(void)
> +static int hvc_sbi_dbcn_tty_put(uint32_t vtermno, const char *buf, int count)
>  {
> -	return PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_ops, 16));
> +	phys_addr_t pa;
> +	struct sbiret ret;
> +
> +	if (is_vmalloc_addr(buf)) {
> +		pa = page_to_phys(vmalloc_to_page(buf)) + offset_in_page(buf);
> +		if (PAGE_SIZE < (offset_in_page(buf) + count))

I thought checkpatch complained about uppercase constants being on the
left in comparisons.

> +			count = PAGE_SIZE - offset_in_page(buf);
> +	} else {
> +		pa = __pa(buf);
> +	}
> +
> +	if (IS_ENABLED(CONFIG_32BIT))
> +		ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
> +				count, lower_32_bits(pa), upper_32_bits(pa),
> +				0, 0, 0);
> +	else
> +		ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
> +				count, pa, 0, 0, 0, 0);
> +	if (ret.error)
> +		return 0;
> +
> +	return count;

Shouldn't we return ret.value here in case it's less than count? I see we
already do that below in get().

>  }
> -device_initcall(hvc_sbi_init);
>  
> -static int __init hvc_sbi_console_init(void)
> +static int hvc_sbi_dbcn_tty_get(uint32_t vtermno, char *buf, int count)
>  {
> -	hvc_instantiate(0, 0, &hvc_sbi_ops);
> +	phys_addr_t pa;
> +	struct sbiret ret;
> +
> +	if (is_vmalloc_addr(buf)) {
> +		pa = page_to_phys(vmalloc_to_page(buf)) + offset_in_page(buf);
> +		if (PAGE_SIZE < (offset_in_page(buf) + count))
> +			count = PAGE_SIZE - offset_in_page(buf);
> +	} else {
> +		pa = __pa(buf);
> +	}
> +
> +	if (IS_ENABLED(CONFIG_32BIT))
> +		ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_READ,
> +				count, lower_32_bits(pa), upper_32_bits(pa),
> +				0, 0, 0);
> +	else
> +		ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_READ,
> +				count, pa, 0, 0, 0, 0);
> +	if (ret.error)
> +		return 0;
> +
> +	return ret.value;
> +}
> +
> +static const struct hv_ops hvc_sbi_dbcn_ops = {
> +	.put_chars = hvc_sbi_dbcn_tty_put,
> +	.get_chars = hvc_sbi_dbcn_tty_get,
> +};
> +
> +static int __init hvc_sbi_init(void)
> +{
> +	int err;
> +
> +	if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&
> +	    (sbi_probe_extension(SBI_EXT_DBCN) > 0)) {
> +		err = PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_dbcn_ops, 16));

Why an outbuf size of only 16?

> +		if (err)
> +			return err;
> +		hvc_instantiate(0, 0, &hvc_sbi_dbcn_ops);
> +	} else {
> +		if (IS_ENABLED(CONFIG_RISCV_SBI_V01)) {
> +			err = PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_v01_ops, 16));
> +			if (err)
> +				return err;
> +			hvc_instantiate(0, 0, &hvc_sbi_v01_ops);
> +		} else {
> +			return -ENODEV;
> +		}
> +	}
>  
>  	return 0;
>  }
> -console_initcall(hvc_sbi_console_init);
> +device_initcall(hvc_sbi_init);
> -- 
> 2.34.1
>

Thanks,
drew
