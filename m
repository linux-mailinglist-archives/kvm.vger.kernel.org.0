Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3F252D5DE
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 16:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbiESOXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 10:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiESOXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 10:23:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C81356FA2B
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 07:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652970226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DiKXDmoBfHysmvRaQthsBVOOfjPaGd0LGHAqdGGHnNY=;
        b=iztQHMrc+s60tAYBkSt4e4eVzSuIIyUNZaPyINBF6cI5WYMjirEYM8LUMcs6eqjWu0CbSa
        o5tHC965aBJKfF4jmLIz6Nkx2CJ6S/NUUMi4UdmtaGH5bpUQXtBWLrgW1V157bbtnVh138
        VD81QqAUql1pEzUZKxn0uxJ83BN1Xqg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-b6j8epqFOdaMZx9G3eedww-1; Thu, 19 May 2022 10:23:38 -0400
X-MC-Unique: b6j8epqFOdaMZx9G3eedww-1
Received: by mail-wm1-f69.google.com with SMTP id v126-20020a1cac84000000b00396fe5959d2so2094222wme.8
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 07:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DiKXDmoBfHysmvRaQthsBVOOfjPaGd0LGHAqdGGHnNY=;
        b=c9upnNhdvIV/cHLBesh56AzO7wVE7+3l5SqwPgH39fQQCxBXJ2/4daKd6X88vLDB/r
         hBKaQk+i70qaEvty2keWccXupDD2fhQbnbm1LNvcnAfK7CIrS4BurFazHxNKKaFPwETE
         qsdZTqjkwPBAKBUxJBDmC2f2pNSeBdarKsQF1E1VRfEQrrKPYz6Jn1nKEzUObdwqGTP2
         9T9trCAIfCO3trFvamkNQIlb1QyFMknd3X7BQyrIwFR7l6dQ2PqKlzDKRqdbrF++9MuI
         CLQSAADsI2iwT3fNX+CJDT7vDuUptThsRte9XxAY+M7kFp7xL4ZcA2hc9iniLXR1EQQY
         cksA==
X-Gm-Message-State: AOAM530muHkNK2zqeGQL23Lvb3ZgbjIR7wpJeaioeo2tTOslPSyLn3Ez
        fb9bKQOHpK1IQft/37tiLY4anX6uP0vFJX98XgJrpn1IK09MmNBI6/wMvG+r+9Lx1QcKP+jBrxv
        I1VvhFYBKc9js
X-Received: by 2002:a5d:6406:0:b0:20e:5bf9:8e31 with SMTP id z6-20020a5d6406000000b0020e5bf98e31mr4265008wru.432.1652970216983;
        Thu, 19 May 2022 07:23:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwADyJAfSH7bFHhKQGU6wSo9Ydu/Zg7VhS/f0GY24VGalZk3WunopOrByLlxqrLeywAl8yHAg==
X-Received: by 2002:a5d:6406:0:b0:20e:5bf9:8e31 with SMTP id z6-20020a5d6406000000b0020e5bf98e31mr4264993wru.432.1652970216760;
        Thu, 19 May 2022 07:23:36 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id i5-20020adfb645000000b0020e62feca05sm4449677wre.32.2022.05.19.07.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 07:23:36 -0700 (PDT)
Date:   Thu, 19 May 2022 16:23:34 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 08/23] arm/arm64: Add support for cpu
 initialization through ACPI
Message-ID: <20220519142334.bmdaxcp7j3qq3fqj@gator>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-9-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-9-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:50PM +0100, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the MADTs to discover the number of CPUs and their corresponding MIDR.
> This change implements this but retains the default behavior; we check
> if a valid DT is provided, if not, we try to discover the cores in the
> system using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/acpi.h      | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/acpi.c      | 21 ++++++++++++++++
>  lib/arm/setup.c | 25 ++++++++++++++++---
>  3 files changed, 107 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 297ad87..55de54a 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -16,6 +16,7 @@
>  #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>  #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>  #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
> +#define MADT_SIGNATURE ACPI_SIGNATURE('A','P','I','C')
>  #define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
>  #define GTDT_SIGNATURE ACPI_SIGNATURE('G','T','D','T')
>  
> @@ -149,6 +150,67 @@ struct facs_descriptor_rev1
>      u8  reserved3 [40];         /* Reserved - must be zero */
>  } __attribute__ ((packed));
>  
> +struct acpi_table_madt {
> +    ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
> +    u32 address;               /* Physical address of local APIC */

nit: some whitespace issues

> +    u32 flags;
> +} __attribute__ ((packed));
> +
> +struct acpi_subtable_header {
> +    u8 type;
> +    u8 length;
> +}  __attribute__ ((packed));
> +
> +typedef int (*acpi_table_handler)(struct acpi_subtable_header *header);
> +
> +/* 11: Generic interrupt - GICC (ACPI 5.0 + ACPI 6.0 + ACPI 6.3 changes) */
> +
> +struct acpi_madt_generic_interrupt {
> +    u8 type;
> +    u8 length;
> +    u16 reserved;           /* reserved - must be zero */
> +    u32 cpu_interface_number;
> +    u32 uid;
> +    u32 flags;
> +    u32 parking_version;
> +    u32 performance_interrupt;
> +    u64 parked_address;
> +    u64 base_address;
> +    u64 gicv_base_address;
> +    u64 gich_base_address;
> +    u32 vgic_interrupt;
> +    u64 gicr_base_address;
> +    u64 arm_mpidr;
> +    u8 efficiency_class;
> +    u8 reserved2[1];
> +    u16 spe_interrupt;      /* ACPI 6.3 */
> +} __attribute__ ((packed));
> +
> +/* Values for MADT subtable type in struct acpi_subtable_header */
> +
> +enum acpi_madt_type {
> +    ACPI_MADT_TYPE_LOCAL_APIC = 0,
> +    ACPI_MADT_TYPE_IO_APIC = 1,
> +    ACPI_MADT_TYPE_INTERRUPT_OVERRIDE = 2,
> +    ACPI_MADT_TYPE_NMI_SOURCE = 3,
> +    ACPI_MADT_TYPE_LOCAL_APIC_NMI = 4,
> +    ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE = 5,
> +    ACPI_MADT_TYPE_IO_SAPIC = 6,
> +    ACPI_MADT_TYPE_LOCAL_SAPIC = 7,
> +    ACPI_MADT_TYPE_INTERRUPT_SOURCE = 8,
> +    ACPI_MADT_TYPE_LOCAL_X2APIC = 9,
> +    ACPI_MADT_TYPE_LOCAL_X2APIC_NMI = 10,
> +    ACPI_MADT_TYPE_GENERIC_INTERRUPT = 11,
> +    ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR = 12,
> +    ACPI_MADT_TYPE_GENERIC_MSI_FRAME = 13,
> +    ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR = 14,
> +    ACPI_MADT_TYPE_GENERIC_TRANSLATOR = 15,
> +    ACPI_MADT_TYPE_RESERVED = 16    /* 16 and greater are reserved */
> +};
> +
> +/* MADT Local APIC flags */
> +#define ACPI_MADT_ENABLED           (1) /* 00: Processor is usable if set */
> +
>  struct spcr_descriptor {
>      ACPI_TABLE_HEADER_DEF   /* ACPI common table header */
>      u8 interface_type;      /* 0=full 16550, 1=subset of 16550 */
> @@ -192,5 +254,7 @@ struct acpi_table_gtdt {
>  
>  void set_efi_rsdp(struct rsdp_descriptor *rsdp);
>  void* find_acpi_table_addr(u32 sig);
> +void acpi_table_parse_madt(enum acpi_madt_type mtype,
> +			   acpi_table_handler handler);

nit: unnecessary line break

>  
>  #endif
> diff --git a/lib/acpi.c b/lib/acpi.c
> index e8440ae..ad3ae8d 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -101,3 +101,24 @@ void* find_acpi_table_addr(u32 sig)
>  
>  	return NULL;
>  }
> +
> +void acpi_table_parse_madt(enum acpi_madt_type mtype,
> +			   acpi_table_handler handler)
> +{
> +	struct acpi_table_madt *madt;
> +	void *end;
> +
> +	madt = find_acpi_table_addr(MADT_SIGNATURE);
> +	assert(madt);
> +
> +	struct acpi_subtable_header *header =
> +		(void *)(ulong)madt + sizeof(struct acpi_table_madt);

nit: unnecessary line break

> +	end = (void *)((ulong)madt + madt->length);
> +
> +	while ((void *)header < end) {
> +		if (header->type == mtype)
> +			handler(header);
> +
> +		header = (void *)(ulong)header + header->length;
> +	}
> +}
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 1572c64..3c24c75 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -13,6 +13,7 @@
>  #include <libcflat.h>
>  #include <libfdt/libfdt.h>
>  #include <devicetree.h>
> +#include <acpi.h>
>  #include <alloc.h>
>  #include <alloc_phys.h>
>  #include <alloc_page.h>
> @@ -55,7 +56,7 @@ int mpidr_to_cpu(uint64_t mpidr)
>  	return -1;
>  }
>  
> -static void cpu_set(int fdtnode __unused, u64 regval, void *info __unused)
> +static void cpu_set_fdt(int fdtnode __unused, u64 regval, void *info __unused)
>  {
>  	int cpu = nr_cpus++;
>  
> @@ -65,13 +66,31 @@ static void cpu_set(int fdtnode __unused, u64 regval, void *info __unused)
>  	set_cpu_present(cpu, true);
>  }
>  
> +static int cpu_set_acpi(struct acpi_subtable_header *header)
> +{
> +	int cpu = nr_cpus++;
> +	struct acpi_madt_generic_interrupt *gicc = (void *)header;
> +
> +	assert_msg(cpu < NR_CPUS, "Number cpus exceeds maximum supported (%d).", NR_CPUS);
> +
> +	cpus[cpu] = gicc->arm_mpidr;
> +	set_cpu_present(cpu, true);
> +
> +	return 0;
> +}
> +
>  static void cpu_init(void)
>  {
>  	int ret;
>  
>  	nr_cpus = 0;
> -	ret = dt_for_each_cpu_node(cpu_set, NULL);
> -	assert(ret == 0);
> +	if (dt_available()) {
> +		ret = dt_for_each_cpu_node(cpu_set_fdt, NULL);
> +		assert(ret == 0);
> +	} else
> +		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +				      cpu_set_acpi);

nit: unnecessary line break and please balance the {} on the else

> +
>  	set_cpu_online(0, true);
>  }
>  
> -- 
> 2.25.1
>

I looked ahead and see you make a lot more use of acpi_table_parse_madt()
when adding the gic support.

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

