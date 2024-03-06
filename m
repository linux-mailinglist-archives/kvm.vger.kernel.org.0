Return-Path: <kvm+bounces-11159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C70D873C25
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:24:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71ADFB24A53
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66862137904;
	Wed,  6 Mar 2024 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CvfCSJPJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8D8135403
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709742263; cv=none; b=YCfyqHxoy2hwa9foXoyr1L0K17UZs1yLsk2cPw7OjNMIofdCsfZpKfkOHquIDqJr3b4gt6Akheh8racFz5n6rKPaeUbiviaCPJX3+DFmYSdSwk9uP9y4HWHkmow886lQfma4mtNVo/uPteORLyCamlD6tZcaQZTnzR36tji9ASM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709742263; c=relaxed/simple;
	bh=+orz6fSrLcPsK6NvAS+55uMz7L4IS9AzF77yIgkEdo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bjeWtRSN9d4QEejTEblEoyXo5/PUUeQCoHZOO4g48Oz0+MfyCx6g6Q1BliXCcrwhNK3DCV4XQ1nmby5eMYVJRehgDbqn73xDWC/AP2+IfvX4cW0YZ5WtPoyvT1mqBRv9fysvA+9QjdMGnHjOQLuzXRQrnr74ox1fsP1V2fx7/A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CvfCSJPJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709742260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AeZZRlg1U/vwkr/sKYo3DPV+nCx3HdNirL3eM+WCUy4=;
	b=CvfCSJPJvgqSQC7N5BPPrYOEX70l46Ja3lHuq65agniIYzQTROF/bdMKRouKNV3ecvkGj3
	BsxHlzO22eKg6ZzA8BEGwaQF5Uhk8fggc14o3sssY9Sy1cHTwBpj7K21+qXSlWTTKuUDuV
	DjQBSNzCi290Wnvp0BCrfQ/ulhwppYw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-v86B57HfPjy-_0DCHhckzw-1; Wed, 06 Mar 2024 11:24:18 -0500
X-MC-Unique: v86B57HfPjy-_0DCHhckzw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a44d0cb0596so310069966b.2
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 08:24:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709742258; x=1710347058;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AeZZRlg1U/vwkr/sKYo3DPV+nCx3HdNirL3eM+WCUy4=;
        b=i82lHByyvP9zN1UcAk1Je9VzIbH6VajqZkDa+KivJNPHdoojNMh8kmLI1aBh5ypguP
         za0UswAFLDtS4mJJRw9q8CFVF3J73B+HF/pb5HvRQwtanzvewiMsE4pZgmgQ7Tb0T4qw
         2N3zJ2M4HKf/MJAe7VQW8ALQpHshX+nOlcOZ8md/vdapbDNw6+gml6qW03mISFARVlZu
         fEsVMT3k0kEmNfUautEREE5MbSMzDwFva8bd4e+/pPDgicKb+YcwC0HbtzxvtARzYpL2
         P5cI1BU2eFns2W5bkiI1JUIU+DKosXXBnpQvmJhkKbaDHPF6ydf6QIDmTmFniIXyjAs9
         gtgg==
X-Forwarded-Encrypted: i=1; AJvYcCVT649bA10D28QNrVrto8VDdEuvQgbakLe0xLZeiq36Dd0KqYoyYl1mxYjuqNeezJRvXbbxx2IZ2CBYpQ/lx8SDtbmn
X-Gm-Message-State: AOJu0Yx+Ubwt7saqq3Qk47uav9/YP9Q9HdsyQfco9OQ/dtXlu/ZRzOwh
	1HN6ytTxLx3/EljabtOpw+Xy1AFbv83Sx1HlHqIaA7VEU71XIbvbeUN6lHDTYBXyVD8I/IWO1Vo
	wG5X0lCMns2wcTavKb2+CUmhp0utC6yYEXEOGCGnwOiTxL//zCg==
X-Received: by 2002:a17:906:57d4:b0:a45:a2cc:eb8b with SMTP id u20-20020a17090657d400b00a45a2cceb8bmr4147721ejr.13.1709742257697;
        Wed, 06 Mar 2024 08:24:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXVo8ajrCuPeqNatq8PDMHBz0IDnfV09zuPdbYX2YloKtOMpJrQxcUJe0gjqzzlzgV7knvXw==
X-Received: by 2002:a17:906:57d4:b0:a45:a2cc:eb8b with SMTP id u20-20020a17090657d400b00a45a2cceb8bmr4147700ejr.13.1709742257233;
        Wed, 06 Mar 2024 08:24:17 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-151.web.vodafone.de. [109.43.178.151])
        by smtp.gmail.com with ESMTPSA id b10-20020a170906194a00b00a43491ff7e4sm7245309eje.111.2024.03.06.08.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 08:24:16 -0800 (PST)
Message-ID: <2e68cd45-0ef3-4835-a5c7-98f5c4210e4d@redhat.com>
Date: Wed, 6 Mar 2024 17:24:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 05/18] hw/i386/acpi: Remove
 PCMachineClass::legacy_acpi_table_size
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, devel@lists.libvirt.org,
 David Hildenbrand <david@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>
References: <20240305134221.30924-1-philmd@linaro.org>
 <20240305134221.30924-6-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240305134221.30924-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
> PCMachineClass::legacy_acpi_table_size was only used by the
> pc-i440fx-2.0 machine, which got removed. Remove it and simplify
> acpi_build().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/hw/i386/pc.h |  1 -
>   hw/i386/acpi-build.c | 60 +++++++++-----------------------------------
>   2 files changed, 12 insertions(+), 49 deletions(-)
> 
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index 3360ca2307..758d670a36 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -103,7 +103,6 @@ struct PCMachineClass {
>       /* ACPI compat: */
>       bool has_acpi_build;
>       bool rsdp_in_ram;
> -    int legacy_acpi_table_size;
>       unsigned acpi_data_size;
>       int pci_root_uid;
>   
> diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
> index 15242b9096..8c7fad92e9 100644
> --- a/hw/i386/acpi-build.c
> +++ b/hw/i386/acpi-build.c
> @@ -2496,13 +2496,12 @@ void acpi_build(AcpiBuildTables *tables, MachineState *machine)
>       X86MachineState *x86ms = X86_MACHINE(machine);
>       DeviceState *iommu = pcms->iommu;
>       GArray *table_offsets;
> -    unsigned facs, dsdt, rsdt, fadt;
> +    unsigned facs, dsdt, rsdt;
>       AcpiPmInfo pm;
>       AcpiMiscInfo misc;
>       AcpiMcfgInfo mcfg;
>       Range pci_hole = {}, pci_hole64 = {};
>       uint8_t *u;
> -    size_t aml_len = 0;
>       GArray *tables_blob = tables->table_data;
>       AcpiSlicOem slic_oem = { .id = NULL, .table_id = NULL };
>       Object *vmgenid_dev;
> @@ -2548,19 +2547,12 @@ void acpi_build(AcpiBuildTables *tables, MachineState *machine)
>       build_dsdt(tables_blob, tables->linker, &pm, &misc,
>                  &pci_hole, &pci_hole64, machine);
>   
> -    /* Count the size of the DSDT and SSDT, we will need it for legacy
> -     * sizing of ACPI tables.
> -     */
> -    aml_len += tables_blob->len - dsdt;
> -
>       /* ACPI tables pointed to by RSDT */
> -    fadt = tables_blob->len;
>       acpi_add_table(table_offsets, tables_blob);
>       pm.fadt.facs_tbl_offset = &facs;
>       pm.fadt.dsdt_tbl_offset = &dsdt;
>       pm.fadt.xdsdt_tbl_offset = &dsdt;
>       build_fadt(tables_blob, tables->linker, &pm.fadt, oem_id, oem_table_id);
> -    aml_len += tables_blob->len - fadt;
>   
>       acpi_add_table(table_offsets, tables_blob);
>       acpi_build_madt(tables_blob, tables->linker, x86ms,
> @@ -2691,49 +2683,21 @@ void acpi_build(AcpiBuildTables *tables, MachineState *machine)
>        * too simple to be enough.  4k turned out to be too small an
>        * alignment very soon, and in fact it is almost impossible to
>        * keep the table size stable for all (max_cpus, max_memory_slots)
> -     * combinations.  So the table size is always 64k for pc-i440fx-2.1
> -     * and we give an error if the table grows beyond that limit.
> -     *
> -     * We still have the problem of migrating from "-M pc-i440fx-2.0".  For
> -     * that, we exploit the fact that QEMU 2.1 generates _smaller_ tables
> -     * than 2.0 and we can always pad the smaller tables with zeros.  We can
> -     * then use the exact size of the 2.0 tables.
> +     * combinations.
>        *
>        * All this is for PIIX4, since QEMU 2.0 didn't support Q35 migration.

I think you could remove this "All this is for ..." sentence now, too?

  Thomas


>        */
> -    if (pcmc->legacy_acpi_table_size) {
> -        /* Subtracting aml_len gives the size of fixed tables.  Then add the
> -         * size of the PIIX4 DSDT/SSDT in QEMU 2.0.
> -         */
> -        int legacy_aml_len =
> -            pcmc->legacy_acpi_table_size +
> -            ACPI_BUILD_LEGACY_CPU_AML_SIZE * x86ms->apic_id_limit;
> -        int legacy_table_size =
> -            ROUND_UP(tables_blob->len - aml_len + legacy_aml_len,
> -                     ACPI_BUILD_ALIGN_SIZE);
> -        if ((tables_blob->len > legacy_table_size) &&
> -            !pcmc->resizable_acpi_blob) {
> -            /* Should happen only with PCI bridges and -M pc-i440fx-2.0.  */
> -            warn_report("ACPI table size %u exceeds %d bytes,"
> -                        " migration may not work",
> -                        tables_blob->len, legacy_table_size);
> -            error_printf("Try removing CPUs, NUMA nodes, memory slots"
> -                         " or PCI bridges.\n");
> -        }
> -        g_array_set_size(tables_blob, legacy_table_size);
> -    } else {
> -        /* Make sure we have a buffer in case we need to resize the tables. */
> -        if ((tables_blob->len > ACPI_BUILD_TABLE_SIZE / 2) &&
> -            !pcmc->resizable_acpi_blob) {
> -            /* As of QEMU 2.1, this fires with 160 VCPUs and 255 memory slots.  */
> -            warn_report("ACPI table size %u exceeds %d bytes,"
> -                        " migration may not work",
> -                        tables_blob->len, ACPI_BUILD_TABLE_SIZE / 2);
> -            error_printf("Try removing CPUs, NUMA nodes, memory slots"
> -                         " or PCI bridges.\n");
> -        }
> -        acpi_align_size(tables_blob, ACPI_BUILD_TABLE_SIZE);
> +    /* Make sure we have a buffer in case we need to resize the tables. */
> +    if ((tables_blob->len > ACPI_BUILD_TABLE_SIZE / 2) &&
> +        !pcmc->resizable_acpi_blob) {
> +        /* As of QEMU 2.1, this fires with 160 VCPUs and 255 memory slots.  */
> +        warn_report("ACPI table size %u exceeds %d bytes,"
> +                    " migration may not work",
> +                    tables_blob->len, ACPI_BUILD_TABLE_SIZE / 2);
> +        error_printf("Try removing CPUs, NUMA nodes, memory slots"
> +                     " or PCI bridges.\n");
>       }
> +    acpi_align_size(tables_blob, ACPI_BUILD_TABLE_SIZE);
>   
>       acpi_align_size(tables->linker->cmd_blob, ACPI_BUILD_ALIGN_SIZE);
>   


