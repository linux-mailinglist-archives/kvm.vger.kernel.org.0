Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA8B6F3143
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 14:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbjEAM4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 08:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjEAM4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 08:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CAD10D5
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 05:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682945727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+TaR5oCB/ZW+nk2URwcl1uXQGFB/v6cUjv6KgffBaM=;
        b=OXqBSkFpWSmZ/us7gFXD6Y2xnOhH1D70lh1ia9GVujHY+RjaQij47KlciqaZPdlHJC+/8s
        0ML6pNAWAB9IK08ISxDiT+BdcDjzWWINsWA5ui6uuZcFA8YEHyUra6nq+tpr6je/BNK4Bp
        ElA8nomJzT8RlkXk3D7kgSCdIF4jeXM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-u2Bt4S7UPW2zq0fVY4XkYQ-1; Mon, 01 May 2023 08:55:26 -0400
X-MC-Unique: u2Bt4S7UPW2zq0fVY4XkYQ-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-247500746f0so609711a91.1
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 05:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945726; x=1685537726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1+TaR5oCB/ZW+nk2URwcl1uXQGFB/v6cUjv6KgffBaM=;
        b=N7QqFcxJixnjD6Bw5cuPSNHRUez08tRZKq+W16x/7Reb6fKaDYLZ9jQp8I+JJsU4p7
         IeCphDp6rYDzB6dbCJHwtLZR1zKXgr9X602gymVqKT0Kmp983MpW4Orj/QZ0cVfVFJ1Q
         2J6G3D0pG7m9E67EdnP8wVUMTyUc0WYiHpv0siQHZC2V5HcRjjH8QRTxGlmgd2+b3KcE
         eWXFX8wGPTc3jCy8yHTND2E2+vLupmDsvlohHZE/ehUR01X1KEBPYPafwqoFp1rQq/A+
         NA7lvh/tYqnMk1bnnZViH4KFZQyy6eFDtnbmhZUUtdpi5+TXanYkGMCLxBVjktlNJe3c
         hMpg==
X-Gm-Message-State: AC+VfDy/ULJHzuTmMPZoJm/jRgOTQKEs92MqAmabaHzOyR/kFg3cAb1r
        69Kh7KFJZ1nszwzRFQ1+jqiNuagxidsE7ZqN19Ks0p86sQi4tUu87SyWLUhia7t+v2bItbFX+8j
        OVO7qM8SZxXsa
X-Received: by 2002:a05:6a21:33a0:b0:e8:dcca:d9cb with SMTP id yy32-20020a056a2133a000b000e8dccad9cbmr17258720pzb.5.1682945725798;
        Mon, 01 May 2023 05:55:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ67lH3AoGHejR5vkIwpaHeteJYpyTmHgkg6qoz0NH+VL8nz9qTF5Pa8GvcKpZNiN+UwOMExnQ==
X-Received: by 2002:a05:6a21:33a0:b0:e8:dcca:d9cb with SMTP id yy32-20020a056a2133a000b000e8dccad9cbmr17258706pzb.5.1682945725502;
        Mon, 01 May 2023 05:55:25 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w68-20020a636247000000b00520f4ecd71esm17144243pgb.93.2023.05.01.05.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:55:25 -0700 (PDT)
Message-ID: <e7407747-c0fb-7d6a-4a64-3d29fcdb72e4@redhat.com>
Date:   Mon, 1 May 2023 20:55:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 12/29] arm64: Add support for
 discovering the UART through ACPI
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-13-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-13-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/28/23 20:03, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the SPCR to discover the serial port address range. This change
> implements this but retains the default behavior; we check if a valid
> DT is provided, if not, we try to discover the UART using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   lib/acpi.h   | 25 +++++++++++++++++++++++++
>   lib/arm/io.c | 34 +++++++++++++++++++++++++++++-----
>   2 files changed, 54 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index ef4a8e1d..54ed9ef7 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -17,6 +17,7 @@
>   #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>   #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>   #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
> +#define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
>   
>   #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
>   	(((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |	     \
> @@ -145,6 +146,30 @@ struct acpi_table_facs_rev1 {
>   	u8 reserved3[40];	/* Reserved - must be zero */
>   };
>   
> +struct spcr_descriptor {
> +	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
> +	u8 interface_type;	/* 0=full 16550, 1=subset of 16550 */
> +	u8 reserved[3];
> +	struct acpi_generic_address serial_port;
> +	u8 interrupt_type;
> +	u8 pc_interrupt;
> +	u32 interrupt;
> +	u8 baud_rate;
> +	u8 parity;
> +	u8 stop_bits;
> +	u8 flow_control;
> +	u8 terminal_type;
> +	u8 reserved1;
> +	u16 pci_device_id;
> +	u16 pci_vendor_id;
> +	u8 pci_bus;
> +	u8 pci_device;
> +	u8 pci_function;
> +	u32 pci_flags;
> +	u8 pci_segment;
> +	u32 reserved2;
> +};
> +
>   #pragma pack(0)
>   
>   void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 343e1082..19f93490 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -29,7 +29,7 @@ static struct spinlock uart_lock;
>   #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
>   static volatile u8 *uart0_base = UART_EARLY_BASE;
>   
> -static void uart0_init(void)
> +static void uart0_init_fdt(void)
>   {
>   	/*
>   	 * kvm-unit-tests uses the uart only for output. Both uart models have
> @@ -65,17 +65,41 @@ static void uart0_init(void)
>   	}
>   
>   	uart0_base = ioremap(base.addr, base.size);
> +}
> +
> +#ifdef CONFIG_EFI
> +
> +#include <acpi.h>
> +
> +static void uart0_init_acpi(void)
> +{
> +	struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
> +
> +	assert_msg(spcr, "Unable to find ACPI SPCR");
> +	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
> +}
> +#else
> +
> +static void uart0_init_acpi(void)
> +{
> +	assert_msg(false, "ACPI not available");
> +}
> +
> +#endif
> +
> +void io_init(void)
> +{
> +	if (dt_available())
> +		uart0_init_fdt();
> +	else
> +		uart0_init_acpi();
>   
>   	if (uart0_base != UART_EARLY_BASE) {
>   		printf("WARNING: early print support may not work. "
>   		       "Found uart at %p, but early base is %p.\n",
>   			uart0_base, UART_EARLY_BASE);
>   	}
> -}
>   
> -void io_init(void)
> -{
> -	uart0_init();
>   	chr_testdev_init();
>   }
>   

-- 
Shaoqin

