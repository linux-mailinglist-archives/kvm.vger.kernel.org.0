Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAB552D53F
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbiESN5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbiESNz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:55:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77764EC332
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652968488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tTanSs7ixnkAjo9zyEJ/DPrrL683Og2jCRv+H++Lzi4=;
        b=ekSoMz54dTatnGONj8xQUfQO6u2BFr6QcoQBJJxP/USCzW3IIq+ovPxnhlAzKZrI4I1wMi
        oZHS2okjE6QYIt2dOYHygOhAnMxJjWFSLpRzt6GNvx9Y6NDthEh4hmoSmWFYpX99H01/pw
        npbtD/a5rVp+AjlW5EjC3HRf/b7QXn4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-8utqmHhxN6S8KP6B39cHzw-1; Thu, 19 May 2022 09:54:47 -0400
X-MC-Unique: 8utqmHhxN6S8KP6B39cHzw-1
Received: by mail-wr1-f72.google.com with SMTP id z5-20020a5d4d05000000b0020e6457f2b4so1140344wrt.1
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tTanSs7ixnkAjo9zyEJ/DPrrL683Og2jCRv+H++Lzi4=;
        b=YHwd5lwtzb+OgP4tH5sMWI4PmluadIqUNsjWUh2wZuM7aJvSkIi/lFf82G4vZyOSiU
         C0doYbedYWx1fuG6+9XXIsyvy2JCzvE7LcuvPxWB3j+zaLsr1h1lr7Myuy6wmUxqanWW
         UTl8aJ/DIMbi/L+dkZa9pszJRECyVrF1X2Dg7MmHDknHlEeWDBPAHaMfYFehooJy/qoz
         G9/v++ih/37awBe7Dch3TRglLY29VieAFDAknhY0EgA8Ubvhqx3j/gPqKIwihwMYzc+j
         ajB6SvkfIZ4jRT/UKuQxPy1hkWm8NTxthzCFYhWowcHZtxt068PwGv//6l0vPwK56ccx
         ivmg==
X-Gm-Message-State: AOAM530CEpMPfptc/h/54NqgCU9Nctbazvd+jYILrLRO/Z0ZOV1GAYH0
        u6kz2l2R+d1TnTP8dloTNaoobkLRGZIDLKWiWHtlZ+7pmaPEmZEbRlnlaCL7Kad5llZcfIXkBDO
        HvuJGYC6RXsAa
X-Received: by 2002:a5d:5952:0:b0:20d:9f7:ff5b with SMTP id e18-20020a5d5952000000b0020d09f7ff5bmr4159746wri.11.1652968486058;
        Thu, 19 May 2022 06:54:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUZ+fxCxgWklkkHWV/qnYHTFBU0kYGaf3DC5+ppxGQo8FPVsDkSx/e4OjI7ysGObCV380A4g==
X-Received: by 2002:a5d:5952:0:b0:20d:9f7:ff5b with SMTP id e18-20020a5d5952000000b0020d09f7ff5bmr4159729wri.11.1652968485849;
        Thu, 19 May 2022 06:54:45 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id t17-20020adfa2d1000000b0020cf071a168sm5339749wra.29.2022.05.19.06.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 06:54:45 -0700 (PDT)
Date:   Thu, 19 May 2022 15:54:43 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 05/23] arm/arm64: Add support for
 setting up the PSCI conduit through ACPI
Message-ID: <20220519135443.pwhntjvxk64n7toc@gator>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-6-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-6-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:47PM +0100, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the FADT to discover whether PSCI calls need to use smc or hvc
> calls. This change implements this but retains the default behavior;
> we check if a valid DT is provided, if not, we try to setup the PSCI
> conduit using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  arm/Makefile.common |  1 +
>  lib/acpi.h          |  5 +++++
>  lib/arm/psci.c      | 23 ++++++++++++++++++++++-
>  lib/devicetree.c    |  2 +-
>  4 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 38385e0..8e9b3bb 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -38,6 +38,7 @@ cflatobjs += lib/alloc_page.o
>  cflatobjs += lib/vmalloc.o
>  cflatobjs += lib/alloc.o
>  cflatobjs += lib/devicetree.o
> +cflatobjs += lib/acpi.o
>  cflatobjs += lib/pci.o
>  cflatobjs += lib/pci-host-generic.o
>  cflatobjs += lib/pci-testdev.o
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 9f27eb1..139ccba 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -130,6 +130,11 @@ struct acpi_table_fadt
>      u64 hypervisor_id;      /* Hypervisor Vendor ID (ACPI 6.0) */
>  }  __attribute__ ((packed));
>  
> +/* Masks for FADT ARM Boot Architecture Flags (arm_boot_flags) ACPI 5.1 */
> +
> +#define ACPI_FADT_PSCI_COMPLIANT    (1)         /* 00: [V5+] PSCI 0.2+ is implemented */
> +#define ACPI_FADT_PSCI_USE_HVC      (1<<1)      /* 01: [V5+] HVC must be used instead of SMC as the PSCI conduit */
> +
>  struct facs_descriptor_rev1
>  {
>      u32 signature;           /* ACPI Signature */
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index 9c031a1..0e96d19 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -6,6 +6,7 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <acpi.h>
>  #include <devicetree.h>
>  #include <asm/psci.h>
>  #include <asm/setup.h>
> @@ -56,7 +57,7 @@ void psci_system_off(void)
>  	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
>  }
>  
> -void psci_set_conduit(void)
> +static void psci_set_conduit_fdt(void)
>  {
>  	const void *fdt = dt_fdt();
>  	const struct fdt_property *method;
> @@ -75,3 +76,23 @@ void psci_set_conduit(void)
>  	else
>  		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
>  }
> +
> +static void psci_set_conduit_acpi(void)
> +{
> +	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
> +	assert_msg(fadt, "Unable to find ACPI FADT");
> +	assert_msg(fadt->arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT,
> +		   "PSCI is not supported in this platfrom");
> +	if (fadt->arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
> +		psci_invoke = psci_invoke_hvc;
> +	else
> +		psci_invoke = psci_invoke_smc;
> +}
> +
> +void psci_set_conduit(void)
> +{
> +	if (dt_available())
> +		psci_set_conduit_fdt();
> +	else
> +		psci_set_conduit_acpi();
> +}
> diff --git a/lib/devicetree.c b/lib/devicetree.c
> index 78c1f6f..3ff9d16 100644
> --- a/lib/devicetree.c
> +++ b/lib/devicetree.c
> @@ -16,7 +16,7 @@ const void *dt_fdt(void)
>  
>  bool dt_available(void)
>  {
> -	return fdt_check_header(fdt) == 0;
> +	return fdt && fdt_check_header(fdt) == 0;
>  }
>  
>  int dt_get_nr_cells(int fdtnode, u32 *nr_address_cells, u32 *nr_size_cells)
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

