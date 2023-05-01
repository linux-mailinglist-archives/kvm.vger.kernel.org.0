Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA046F314B
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 14:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbjEAM5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 08:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbjEAM5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 08:57:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F5A1719
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 05:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682945793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kuMXQ1oTFDse+TOeXYPyubhb/2KQJ1FQpoh96k+T9K8=;
        b=HdwGcfxNCG+whkbuBI2/6eCyzyhmR7hwJC9YUE/tuAS2itpreB5XOWC9No/wGWrNBJmMU4
        JgpArkoYdV4f+3djquiQqb7qTFPvnog0IT13i87FPI3iy37KJeaW2yQPx+Ca5NGPT0D8uH
        T4v+Xem9hRDrApvYGQeDti5WCHmT3dY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-VRtcteB2O3e7J9LZor9BUQ-1; Mon, 01 May 2023 08:56:32 -0400
X-MC-Unique: VRtcteB2O3e7J9LZor9BUQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-63b653f5cb4so467296b3a.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 05:56:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945791; x=1685537791;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kuMXQ1oTFDse+TOeXYPyubhb/2KQJ1FQpoh96k+T9K8=;
        b=AwCP9TwH/37T5zu5L0Rii1ES3GLX8nD/gAA7X30gBn2tL5HXJet+uHg81ioRsIYatl
         HBJF8xw8Gn6uuLszithdFZe+90A9XAIpPjm6CkkPj26Ut5jksg/DTDzCPpi3/vwydgNE
         AazQiu+HsSm7V3J+zozHIwwc/NyZhbc7wH+2smK66w/SCC94AgeLlVvVwA/xwup48GNO
         Cxam8nb+3KWgcCXFrpYgC8l4pkfEw+BsuCZQzsAFNenUqkypDBMNuuUxhp8+4VGpX1A1
         9wOZx8CV2i7JpUQDcsm1u91fPe+9KWbnLySfmBZnB35kKpIpklX7ES4SycR7+5orfPAi
         343w==
X-Gm-Message-State: AC+VfDzE2r/8y2uOovDW+Jg3o9hnDBPb/7AyByZ//7s0gsHG/SH8O9zm
        y273D3Ilv5HuzwkEVnXI+pqwoGkBzBsU/aYs0cDMGNj5r70SfeGEBVjHLW4KmfyHATfg7bHSjDF
        SLUkSnFqRHLEU
X-Received: by 2002:a05:6a21:33a0:b0:e8:dcca:d9cb with SMTP id yy32-20020a056a2133a000b000e8dccad9cbmr17261062pzb.5.1682945791094;
        Mon, 01 May 2023 05:56:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5ZwCAl1DrTuQmjl3laGfbrtvDbJ99ZPOdsEXRTAKapaIY/ruPUej6+rtE2TEbIoTRZ4Uuitw==
X-Received: by 2002:a05:6a21:33a0:b0:e8:dcca:d9cb with SMTP id yy32-20020a056a2133a000b000e8dccad9cbmr17261042pzb.5.1682945790775;
        Mon, 01 May 2023 05:56:30 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q6-20020a654946000000b00528b78ddbcesm5259069pgs.70.2023.05.01.05.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:56:30 -0700 (PDT)
Message-ID: <0c5b43a6-34d0-c15b-c30e-d7a9be66bd90@redhat.com>
Date:   Mon, 1 May 2023 20:56:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 14/29] arm64: Add support for cpu
 initialization through ACPI
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        Andrew Jones <drjones@redhat.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-15-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-15-nikos.nikoleris@arm.com>
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
> the MADTs to discover the number of CPUs and their corresponding MIDR.
> This change implements this but retains the default behavior; we check
> if a valid DT is provided, if not, we try to discover the cores in the
> system using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   lib/acpi.h      | 63 +++++++++++++++++++++++++++++++++++++++++++++++++
>   lib/acpi.c      | 20 ++++++++++++++++
>   lib/arm/setup.c | 42 ++++++++++++++++++++++++++++++---
>   3 files changed, 122 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 04e4d1c3..4a59f543 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -17,6 +17,7 @@
>   #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>   #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>   #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
> +#define MADT_SIGNATURE ACPI_SIGNATURE('A','P','I','C')
>   #define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
>   #define GTDT_SIGNATURE ACPI_SIGNATURE('G','T','D','T')
>   
> @@ -147,6 +148,67 @@ struct acpi_table_facs_rev1 {
>   	u8 reserved3[40];	/* Reserved - must be zero */
>   };
>   
> +struct acpi_table_madt {
> +	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
> +	u32 address;		/* Physical address of local APIC */
> +	u32 flags;
> +};
> +
> +struct acpi_subtable_header {
> +	u8 type;
> +	u8 length;
> +};
> +
> +typedef int (*acpi_table_handler)(struct acpi_subtable_header *header);
> +
> +/* 11: Generic interrupt - GICC (ACPI 5.0 + ACPI 6.0 + ACPI 6.3 changes) */
> +
> +struct acpi_madt_generic_interrupt {
> +	u8 type;
> +	u8 length;
> +	u16 reserved;		/* reserved - must be zero */
> +	u32 cpu_interface_number;
> +	u32 uid;
> +	u32 flags;
> +	u32 parking_version;
> +	u32 performance_interrupt;
> +	u64 parked_address;
> +	u64 base_address;
> +	u64 gicv_base_address;
> +	u64 gich_base_address;
> +	u32 vgic_interrupt;
> +	u64 gicr_base_address;
> +	u64 arm_mpidr;
> +	u8 efficiency_class;
> +	u8 reserved2[1];
> +	u16 spe_interrupt;	/* ACPI 6.3 */
> +};
> +
> +/* Values for MADT subtable type in struct acpi_subtable_header */
> +
> +enum acpi_madt_type {
> +	ACPI_MADT_TYPE_LOCAL_APIC = 0,
> +	ACPI_MADT_TYPE_IO_APIC = 1,
> +	ACPI_MADT_TYPE_INTERRUPT_OVERRIDE = 2,
> +	ACPI_MADT_TYPE_NMI_SOURCE = 3,
> +	ACPI_MADT_TYPE_LOCAL_APIC_NMI = 4,
> +	ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE = 5,
> +	ACPI_MADT_TYPE_IO_SAPIC = 6,
> +	ACPI_MADT_TYPE_LOCAL_SAPIC = 7,
> +	ACPI_MADT_TYPE_INTERRUPT_SOURCE = 8,
> +	ACPI_MADT_TYPE_LOCAL_X2APIC = 9,
> +	ACPI_MADT_TYPE_LOCAL_X2APIC_NMI = 10,
> +	ACPI_MADT_TYPE_GENERIC_INTERRUPT = 11,
> +	ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR = 12,
> +	ACPI_MADT_TYPE_GENERIC_MSI_FRAME = 13,
> +	ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR = 14,
> +	ACPI_MADT_TYPE_GENERIC_TRANSLATOR = 15,
> +	ACPI_MADT_TYPE_RESERVED = 16	/* 16 and greater are reserved */
> +};
> +
> +/* MADT Local APIC flags */
> +#define ACPI_MADT_ENABLED		(1)	/* 00: Processor is usable if set */
> +
>   struct spcr_descriptor {
>   	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
>   	u8 interface_type;	/* 0=full 16550, 1=subset of 16550 */
> @@ -192,5 +254,6 @@ struct acpi_table_gtdt {
>   
>   void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
>   void *find_acpi_table_addr(u32 sig);
> +void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler);
>   
>   #endif
> diff --git a/lib/acpi.c b/lib/acpi.c
> index a197f3dd..bbe33d08 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -102,3 +102,23 @@ void *find_acpi_table_addr(u32 sig)
>   
>   	return NULL;
>   }
> +
> +void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler)
> +{
> +	struct acpi_table_madt *madt;
> +	struct acpi_subtable_header *header;
> +	void *end;
> +
> +	madt = find_acpi_table_addr(MADT_SIGNATURE);
> +	assert(madt);
> +
> +	header = (void *)(ulong) madt + sizeof(struct acpi_table_madt);
> +	end = (void *)((ulong) madt + madt->length);
> +
> +	while ((void *)header < end) {
> +		if (header->type == mtype)
> +			handler(header);
> +
> +		header = (void *)(ulong) header + header->length;
> +	}
> +}
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 1572c64e..59b0aedd 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -55,7 +55,7 @@ int mpidr_to_cpu(uint64_t mpidr)
>   	return -1;
>   }
>   
> -static void cpu_set(int fdtnode __unused, u64 regval, void *info __unused)
> +static void cpu_set_fdt(int fdtnode __unused, u64 regval, void *info __unused)
>   {
>   	int cpu = nr_cpus++;
>   
> @@ -65,13 +65,49 @@ static void cpu_set(int fdtnode __unused, u64 regval, void *info __unused)
>   	set_cpu_present(cpu, true);
>   }
>   
> +#ifdef CONFIG_EFI
> +
> +#include <acpi.h>
> +
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
> +static void cpu_init_acpi(void)
> +{
> +	acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT, cpu_set_acpi);
> +}
> +
> +#else
> +
> +static void cpu_init_acpi(void)
> +{
> +	assert_msg(false, "ACPI not available");
> +}
> +
> +#endif
> +
>   static void cpu_init(void)
>   {
>   	int ret;
>   
>   	nr_cpus = 0;
> -	ret = dt_for_each_cpu_node(cpu_set, NULL);
> -	assert(ret == 0);
> +	if (dt_available()) {
> +		ret = dt_for_each_cpu_node(cpu_set_fdt, NULL);
> +		assert(ret == 0);
> +	} else {
> +		cpu_init_acpi();
> +	}
> +
>   	set_cpu_online(0, true);
>   }
>   

-- 
Shaoqin

