Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2F652D570
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 16:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237854AbiESOBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 10:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240114AbiESOBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 10:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8E76515A9
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 07:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652968804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AZhjCiUM7ZbW+8UgMzwUnmwHI6mxzQPTryoAn5xTJEk=;
        b=DTRkzWg5myIMgu4WNchb0BHxyY1WlFpQI2JyOGNWNW7LadY67i7oZGir+rcBju7sRw5e1k
        LBCHH60EkMYdff4vRu5CwVFk6UFpQ8Mfdqk3gPUNWyiz4xfOxeCQWmiAIzHTORTwyfAr0J
        3XgYwqa/pWU+MkvfPFbok9oySvtxyG0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-GYSPZbshOb23WqQQPdvN6w-1; Thu, 19 May 2022 10:00:03 -0400
X-MC-Unique: GYSPZbshOb23WqQQPdvN6w-1
Received: by mail-wm1-f71.google.com with SMTP id z23-20020a05600c221700b003942fd37764so4548899wml.8
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 07:00:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AZhjCiUM7ZbW+8UgMzwUnmwHI6mxzQPTryoAn5xTJEk=;
        b=k7I5ajMKIAvuwlRPUhok4t7Xd+mFopODabdgTqoHQJn2jg0LkTKhSAXWX2hDQS02TA
         ZQkjDzFvw5KwwN0M3Xqj+QIIdD0Yu76xv2+mj6EVT373V85uf+hM71IZkRxNS8WPw4Q+
         db4Reee1G/JwMtf6s0i3ZmmQUw/zKwleg3KIvyfutZMXfOh+iL5ZNq27Tt94FxNoYl9z
         M69OYD4fN4T91Ww6rDbuAk7YcxicX6rdJNBPmRbE7c4Prglq9Kaba7ktxzZ0BAh4vi/L
         EyDjYrXtg4YrOQOiu/YY1joog5ntmh6eyRPe5r+JIU80ovkDt8aza79b9eDZRsHnK9/D
         ilbw==
X-Gm-Message-State: AOAM532jSCWRyfnpsBV9pVD3Cbpky4qXLbEjR2x2TxM+rVkLwenQ/Eg+
        2mBEn5oNqu+nVRoElkfMaESWnd2yzyYLigwz5wqFOs98suvW4LAgjhjqTGvf1WnQZ0h3909RG+0
        DyldApqRtUL7R
X-Received: by 2002:a05:600c:26d2:b0:393:fb8c:dc31 with SMTP id 18-20020a05600c26d200b00393fb8cdc31mr4530528wmv.129.1652968802478;
        Thu, 19 May 2022 07:00:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXy3MMxvqCdKEHcRn0B35e9ggfx7RG3ztDvWIY/AikYd1+l7BmVkOcFL6CXOUbaWyRP9yBbQ==
X-Received: by 2002:a05:600c:26d2:b0:393:fb8c:dc31 with SMTP id 18-20020a05600c26d200b00393fb8cdc31mr4530507wmv.129.1652968802184;
        Thu, 19 May 2022 07:00:02 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id g14-20020adfbc8e000000b0020e66dbb9dbsm3157199wrh.81.2022.05.19.07.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 07:00:01 -0700 (PDT)
Date:   Thu, 19 May 2022 15:59:59 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 06/23] arm/arm64: Add support for
 discovering the UART through ACPI
Message-ID: <20220519135959.zpu4t6hlpztv5pqh@gator>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-7-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-7-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:48PM +0100, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the SPCR to discover the serial port address range. This change
> implements this but retains the default behavior; we check if a valid
> DT is provided, if not, we try to discover the UART using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/acpi.h     | 25 +++++++++++++++++++++++++
>  lib/arm/io.c   | 21 +++++++++++++++++++--
>  lib/arm/psci.c |  4 +++-
>  3 files changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 139ccba..5213299 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -16,6 +16,7 @@
>  #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>  #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>  #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
> +#define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
>  
>  
>  #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
> @@ -147,6 +148,30 @@ struct facs_descriptor_rev1
>      u8  reserved3 [40];         /* Reserved - must be zero */
>  } __attribute__ ((packed));
>  
> +struct spcr_descriptor {
> +    ACPI_TABLE_HEADER_DEF   /* ACPI common table header */
> +    u8 interface_type;      /* 0=full 16550, 1=subset of 16550 */
> +    u8 reserved[3];
> +    struct acpi_generic_address serial_port;
> +    u8 interrupt_type;
> +    u8 pc_interrupt;
> +    u32 interrupt;
> +    u8 baud_rate;
> +    u8 parity;
> +    u8 stop_bits;
> +    u8 flow_control;
> +    u8 terminal_type;
> +    u8 reserved1;
> +    u16 pci_device_id;
> +    u16 pci_vendor_id;
> +    u8 pci_bus;
> +    u8 pci_device;
> +    u8 pci_function;
> +    u32 pci_flags;
> +    u8 pci_segment;
> +    u32 reserved2;
> +} __attribute__ ((packed));
> +
>  void set_efi_rsdp(struct rsdp_descriptor *rsdp);
>  void* find_acpi_table_addr(u32 sig);
>  
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 343e108..893bdfc 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -8,6 +8,7 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <acpi.h>

nit: below libcflat.h

>  #include <libcflat.h>
>  #include <devicetree.h>
>  #include <chr-testdev.h>
> @@ -29,7 +30,7 @@ static struct spinlock uart_lock;
>  #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
>  static volatile u8 *uart0_base = UART_EARLY_BASE;
>  
> -static void uart0_init(void)
> +static void uart0_init_fdt(void)
>  {
>  	/*
>  	 * kvm-unit-tests uses the uart only for output. Both uart models have
> @@ -73,9 +74,25 @@ static void uart0_init(void)
>  	}
>  }
>  
> +static void uart0_init_acpi(void)
> +{
> +	struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
> +	assert_msg(spcr, "Unable to find ACPI SPCR");
> +	uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
> +
> +	if (uart0_base != UART_EARLY_BASE) {
> +		printf("WARNING: early print support may not work. "
> +		       "Found uart at %p, but early base is %p.\n",
> +			uart0_base, UART_EARLY_BASE);
> +	}
> +}
> +
>  void io_init(void)
>  {
> -	uart0_init();
> +	if (dt_available())
> +		uart0_init_fdt();
> +	else
> +		uart0_init_acpi();
>  	chr_testdev_init();
>  }
>  
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index 0e96d19..afbc33d 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -80,9 +80,11 @@ static void psci_set_conduit_fdt(void)
>  static void psci_set_conduit_acpi(void)
>  {
>  	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
> +
>  	assert_msg(fadt, "Unable to find ACPI FADT");
>  	assert_msg(fadt->arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT,
> -		   "PSCI is not supported in this platfrom");
> +		   "PSCI is not supported in this platform");
> +

These psci_set_conduit_acpi() cleanups belong in the last patch.

>  	if (fadt->arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
>  		psci_invoke = psci_invoke_hvc;
>  	else
> -- 
> 2.25.1
>

Besides the patch cleanup and the #include nit,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

