Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB98C6CFBDB
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 08:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjC3Grj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 02:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjC3Grg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 02:47:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C1446AA
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 23:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680158808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B2Lu2p8xaiftb4OTX9kXdBQYcEW+MwWgIlLGAAXm/D4=;
        b=EpkytWBoeP8FI5rYojNicFYtHj5RVsp5coR4qfFiRU5LmxTZviIjzr0q65PZKC+CoXsN2e
        M2Bw42PmTnNi8McdYyeRrSonT2Q0oeXFVuz/1D9zjqiBnjNDRbAFwMj9VJXS5/jiEi9AHh
        XNlg9GsSnKj0PVzNcKj9Q60Hq0KwtS4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-U459f912OFGE5al70jkeUA-1; Thu, 30 Mar 2023 02:46:46 -0400
X-MC-Unique: U459f912OFGE5al70jkeUA-1
Received: by mail-pj1-f69.google.com with SMTP id d5-20020a17090ac24500b0023cb04ec86fso4998207pjx.7
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 23:46:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680158805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B2Lu2p8xaiftb4OTX9kXdBQYcEW+MwWgIlLGAAXm/D4=;
        b=kZljzm2cAwPfMocZnVWCy6mFuRTVSeh4d5uHi2TAVA9df96tkkDv2w4fQc6Ol0K03G
         t/4DtM+3CFJk0ulFn5vKHZHnan2mDTskPblCmPtEH9kB5vx7b6ujxsqGAv52YX3iTn7G
         ZBKspduStBphFOeDD3UIgjLmzjFFPIt1AQ1XOdSuWIKFbGTJLezjlFJWE0YrP/L5kmXv
         H8zomqkc5eYjbP/8NrJtDTjO558UnCcco48h1BQM/sVabe6tAmUMhefpJEDtLMAF1RVj
         V5+lap2rq/0/H3X8wMyB9zPPPKRU1fSbu4XpUpQe9FyokOStqAwCKuGUjKL/m7V/NZxE
         lpaA==
X-Gm-Message-State: AAQBX9e8xxeiuOIMEi4azcxRb7k75hxMTBjfZ0aSn7k1fVPwvevomxkx
        UTMS7CA/rm2DbCqKsurf+z+EKmTd84nrr83Y7Gxy70rIqoR/FmYayu71HT6XU0zVFJpDUmueStB
        lCv+6Br/4R/Zs
X-Received: by 2002:a05:6a20:7da6:b0:c0:2875:9e8c with SMTP id v38-20020a056a207da600b000c028759e8cmr1213776pzj.1.1680158805443;
        Wed, 29 Mar 2023 23:46:45 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z42Ql+MfW3NYKeuJ6HJp+/RvlwL24iB52Wp06xn7wfu7g6k/pvbrNdoR2jKqhEQe0s8IMNaQ==
X-Received: by 2002:a05:6a20:7da6:b0:c0:2875:9e8c with SMTP id v38-20020a056a207da600b000c028759e8cmr1213758pzj.1.1680158804973;
        Wed, 29 Mar 2023 23:46:44 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x4-20020aa784c4000000b0062a7462d398sm12617428pfn.170.2023.03.29.23.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 23:46:44 -0700 (PDT)
Message-ID: <4af8a2c9-f808-f727-2185-277eb7ef7d77@redhat.com>
Date:   Thu, 30 Mar 2023 14:46:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 16/30] arm64: Add support for gic initialization
 through ACPI
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-17-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230213101759.2577077-17-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

On 2/13/23 18:17, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the MADTs to figure out if it implements a GICv2 or a GICv3 and
> discover the GIC parameters. This change implements this but retains
> the default behavior; we check if a valid DT is provided, if not, we
> try to discover the cores in the system using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>   lib/acpi.c     |   9 +++-
>   lib/acpi.h     |  46 +++++++++++++++-
>   lib/arm/gic.c  | 139 ++++++++++++++++++++++++++++++++++++++++++++++++-
>   lib/libcflat.h |   1 +
>   4 files changed, 191 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/acpi.c b/lib/acpi.c
> index bbe33d08..760cd8b2 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -103,11 +103,12 @@ void *find_acpi_table_addr(u32 sig)
>   	return NULL;
>   }
>   
> -void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler)
> +int acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler)
>   {
>   	struct acpi_table_madt *madt;
>   	struct acpi_subtable_header *header;
>   	void *end;
> +	int count = 0;
>   
>   	madt = find_acpi_table_addr(MADT_SIGNATURE);
>   	assert(madt);
> @@ -116,9 +117,13 @@ void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler
>   	end = (void *)((ulong) madt + madt->length);
>   
>   	while ((void *)header < end) {
> -		if (header->type == mtype)
> +		if (header->type == mtype) {
>   			handler(header);
> +			count++;
> +		}
>   
>   		header = (void *)(ulong) header + header->length;
>   	}
> +
> +	return count;
>   }
> diff --git a/lib/acpi.h b/lib/acpi.h
> index af02fd83..a2c0f982 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -184,6 +184,50 @@ struct acpi_madt_generic_interrupt {
>   	u16 spe_interrupt;	/* ACPI 6.3 */
>   };
>   
> +#define ACPI_MADT_ENABLED           (1)	/* 00: Processor is usable if set */
This macro has been defined in previous patch, so at here we don't need 
to add it again.

Thanks,
Shaoqin

> +
> +/* 12: Generic Distributor (ACPI 5.0 + ACPI 6.0 changes) */
> +
> +struct acpi_madt_generic_distributor {
> +	struct acpi_subtable_header header;
> +	u16 reserved;		/* reserved - must be zero */
> +	u32 gic_id;
> +	u64 base_address;
> +	u32 global_irq_base;
> +	u8 version;
> +	u8 reserved2[3];	/* reserved - must be zero */
> +};
> +
> +/* Values for Version field above */
> +
> +enum acpi_madt_gic_version {
> +	ACPI_MADT_GIC_VERSION_NONE = 0,
> +	ACPI_MADT_GIC_VERSION_V1 = 1,
> +	ACPI_MADT_GIC_VERSION_V2 = 2,
> +	ACPI_MADT_GIC_VERSION_V3 = 3,
> +	ACPI_MADT_GIC_VERSION_V4 = 4,
> +	ACPI_MADT_GIC_VERSION_RESERVED = 5	/* 5 and greater are reserved */
> +};
> +
> +/* 14: Generic Redistributor (ACPI 5.1) */
> +
> +struct acpi_madt_generic_redistributor {
> +	struct acpi_subtable_header header;
> +	u16 reserved;		/* reserved - must be zero */
> +	u64 base_address;
> +	u32 length;
> +};
> +
> +/* 15: Generic Translator (ACPI 6.0) */
> +
> +struct acpi_madt_generic_translator {
> +	struct acpi_subtable_header header;
> +	u16 reserved;		/* reserved - must be zero */
> +	u32 translation_id;
> +	u64 base_address;
> +	u32 reserved2;
> +};
> +
>   /* Values for MADT subtable type in struct acpi_subtable_header */
>   
>   enum acpi_madt_type {
> @@ -254,6 +298,6 @@ struct acpi_table_gtdt {
>   
>   void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
>   void *find_acpi_table_addr(u32 sig);
> -void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler);
> +int acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler);
>   
>   #endif
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 1bfcfcfb..8fc5596f 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -3,6 +3,7 @@
>    *
>    * This work is licensed under the terms of the GNU LGPL, version 2.
>    */
> +#include <acpi.h>
>   #include <devicetree.h>
>   #include <asm/gic.h>
>   #include <asm/io.h>
> @@ -120,7 +121,7 @@ int gic_version(void)
>   	return 0;
>   }
>   
> -int gic_init(void)
> +static int gic_init_fdt(void)
>   {
>   	if (gicv2_init()) {
>   		gic_common_ops = &gicv2_common_ops;
> @@ -133,6 +134,142 @@ int gic_init(void)
>   	return gic_version();
>   }
>   
> +#ifdef CONFIG_EFI
> +
> +#define ACPI_GICV2_DIST_MEM_SIZE	(SZ_4K)
> +#define ACPI_GIC_CPU_IF_MEM_SIZE	(SZ_8K)
> +#define ACPI_GICV3_DIST_MEM_SIZE	(SZ_64K)
> +#define ACPI_GICV3_ITS_MEM_SIZE		(SZ_128K)
> +
> +static int gic_acpi_version(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_distributor *dist = (void *)header;
> +	int version = dist->version;
> +
> +	if (version == 2)
> +		gic_common_ops = &gicv2_common_ops;
> +	else if (version == 3)
> +		gic_common_ops = &gicv3_common_ops;
> +
> +	return version;
> +}
> +
> +static int gicv2_acpi_parse_madt_cpu(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_interrupt *gicc = (void *)header;
> +	static phys_addr_t gicc_base_address;
> +
> +	if (!(gicc->flags & ACPI_MADT_ENABLED))
> +		return 0;
> +
> +	if (!gicc_base_address) {
> +		gicc_base_address = gicc->base_address;
> +		gicv2_data.cpu_base = ioremap(gicc_base_address, ACPI_GIC_CPU_IF_MEM_SIZE);
> +	}
> +	assert(gicc_base_address == gicc->base_address);
> +
> +	return 0;
> +}
> +
> +static int gicv2_acpi_parse_madt_dist(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_distributor *dist = (void *)header;
> +
> +	gicv2_data.dist_base = ioremap(dist->base_address, ACPI_GICV2_DIST_MEM_SIZE);
> +
> +	return 0;
> +}
> +
> +static int gicv3_acpi_parse_madt_gicc(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_interrupt *gicc = (void *)header;
> +	static phys_addr_t gicr_base_address;
> +
> +	if (!(gicc->flags & ACPI_MADT_ENABLED))
> +		return 0;
> +
> +	if (!gicr_base_address) {
> +		gicr_base_address = gicc->gicr_base_address;
> +		gicv3_data.redist_bases[0] = ioremap(gicr_base_address, SZ_64K * 2);
> +	}
> +	assert(gicr_base_address == gicc->gicr_base_address);
> +
> +	return 0;
> +}
> +
> +static int gicv3_acpi_parse_madt_dist(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_distributor *dist = (void *)header;
> +
> +	gicv3_data.dist_base = ioremap(dist->base_address, ACPI_GICV3_DIST_MEM_SIZE);
> +
> +	return 0;
> +}
> +
> +static int gicv3_acpi_parse_madt_redist(struct acpi_subtable_header *header)
> +{
> +	static int i;
> +	struct acpi_madt_generic_redistributor *redist = (void *)header;
> +
> +	gicv3_data.redist_bases[i++] = ioremap(redist->base_address, redist->length);
> +
> +	return 0;
> +}
> +
> +static int gicv3_acpi_parse_madt_its(struct acpi_subtable_header *header)
> +{
> +	struct acpi_madt_generic_translator *its_entry = (void *)header;
> +
> +	its_data.base = ioremap(its_entry->base_address, ACPI_GICV3_ITS_MEM_SIZE - 1);
> +
> +	return 0;
> +}
> +
> +static int gic_init_acpi(void)
> +{
> +	int count;
> +
> +	acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR, gic_acpi_version);
> +	if (gic_version() == 2) {
> +		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +				     gicv2_acpi_parse_madt_cpu);
> +		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
> +				      gicv2_acpi_parse_madt_dist);
> +	} else if (gic_version() == 3) {
> +		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
> +				      gicv3_acpi_parse_madt_dist);
> +		count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR,
> +					      gicv3_acpi_parse_madt_redist);
> +		if (!count)
> +			acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +					      gicv3_acpi_parse_madt_gicc);
> +		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_TRANSLATOR,
> +				      gicv3_acpi_parse_madt_its);
> +#ifdef __aarch64__
> +		its_init();
> +#endif
> +	}
> +
> +	return gic_version();
> +}
> +
> +#else
> +
> +static int gic_init_acpi(void)
> +{
> +	assert_msg(false, "ACPI not available");
> +}
> +
> +#endif /* CONFIG_EFI */
> +
> +int gic_init(void)
> +{
> +	if (dt_available())
> +		return gic_init_fdt();
> +	else
> +		return gic_init_acpi();
> +}
> +
>   void gic_enable_defaults(void)
>   {
>   	if (!gic_common_ops) {
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index c1fd31ff..700f4352 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -161,6 +161,7 @@ extern void setup_vm(void);
>   #define SZ_8K			(1 << 13)
>   #define SZ_16K			(1 << 14)
>   #define SZ_64K			(1 << 16)
> +#define SZ_128K			(1 << 17)
>   #define SZ_1M			(1 << 20)
>   #define SZ_2M			(1 << 21)
>   #define SZ_1G			(1 << 30)

-- 
Shaoqin

