Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5613E6F3124
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 14:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjEAMpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 08:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbjEAMpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 08:45:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F54A1986
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 05:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682945048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E/XpFUk6MEULg1fIO9TK+7Ab6RwwTGIJ5nuTSEsiTSs=;
        b=KhMVoNy7gHVW0Lo+2yZMZB2bMIB1JuGvDbDqmylQCLRCIFSoIszxVeMB2azIPLfay0B1EC
        ebx90KVaXK4wFPccxh4lTTufqUz+Akqg3KJvQ2yWq7pTCgvUlkeAo5pK44S13H3KT+LY0b
        DUGIfxc299CiCeshThL8i7H3hJPXtOQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-JYigfXADP7evlN3gyBgztQ-1; Mon, 01 May 2023 08:44:05 -0400
X-MC-Unique: JYigfXADP7evlN3gyBgztQ-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-517f0c08dfaso387029a12.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 05:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945044; x=1685537044;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E/XpFUk6MEULg1fIO9TK+7Ab6RwwTGIJ5nuTSEsiTSs=;
        b=l5dfHWkQSmls+D00yKORbFs2df2uuDfYSZi8QuSyVns1xhmghGj7VcVCd/ThQR7Tuj
         bOleb2yoiLXDGFX3dQBqPFLcnCBNqM8l9QW2rjbAg39pXc82pz/lfI7jDlxuM/6uYjAl
         e+N+WQMaxaoRT0jD91vwGJSoQ3E08EMXsAeBOa0tNBKZOospu7pleM8umglvvHAdeaoG
         iZyg2LXCvf4Y6nbb9aW/n2mCKd4DG8XAe0Kz5e0RjsLfU1XBVQD1o6kSeHZNJwb3kHTr
         NoO/o4qjBqzF5j+zzOzuNCILjmbwZdbHGbUfWEettsxZumXi6wZ35o45zIgScBas1Nxf
         vWVQ==
X-Gm-Message-State: AC+VfDxibc8dIyqEkoFc3otWUZPfqcTj8aMT6+amC2CAK7X8b4j8jwUI
        rJcuxhiM0XD9jo4oM7yqxf053xg/FHkgherYJpijCe0ayPl6+Sdi1ANN6KHPMC5MC4nOyY9G+a4
        Re6Pw7jpOMUnI
X-Received: by 2002:a05:6a21:32a2:b0:f3:d92:a209 with SMTP id yt34-20020a056a2132a200b000f30d92a209mr18151449pzb.0.1682945043956;
        Mon, 01 May 2023 05:44:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7/DVSzvgACLO8Z00Gujg4Ra4TbWHw7QXPiNmoQFb5u0JKKNWIRCc1qrVjOZ5oT8oBgxVOL/g==
X-Received: by 2002:a05:6a21:32a2:b0:f3:d92:a209 with SMTP id yt34-20020a056a2132a200b000f30d92a209mr18151427pzb.0.1682945043641;
        Mon, 01 May 2023 05:44:03 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m8-20020a654388000000b0051303d3e3c5sm16987907pgp.42.2023.05.01.05.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:44:03 -0700 (PDT)
Message-ID: <7c03c78d-8e8c-b2c4-6682-4a24061e01a3@redhat.com>
Date:   Mon, 1 May 2023 20:44:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 03/29] lib: Apply Lindent to acpi.{c,h}
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-4-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-4-nikos.nikoleris@arm.com>
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
> The change was done by modifying Linux's scripts/Lindent to use 100
> columns instead of 80.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   lib/acpi.h | 157 ++++++++++++++++++++++++++---------------------------
>   lib/acpi.c |  70 ++++++++++++------------
>   2 files changed, 111 insertions(+), 116 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 1e89840c..b67bbe19 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -3,7 +3,7 @@
>   
>   #include "libcflat.h"
>   
> -#define ACPI_SIGNATURE(c1, c2, c3, c4) \
> +#define ACPI_SIGNATURE(c1, c2, c3, c4)				\
>   	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
>   
>   #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
> @@ -11,102 +11,99 @@
>   #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>   #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
>   
> -
> -#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
> -	((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |       \
> +#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8)	\
> +	((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |		\
>   	((uint64_t)(ACPI_SIGNATURE(c5, c6, c7, c8)) << 32)
>   
>   #define RSDP_SIGNATURE_8BYTE (ACPI_SIGNATURE_8BYTE('R', 'S', 'D', ' ', 'P', 'T', 'R', ' '))
>   
> -struct rsdp_descriptor {        /* Root System Descriptor Pointer */
> -    u64 signature;              /* ACPI signature, contains "RSD PTR " */
> -    u8  checksum;               /* To make sum of struct == 0 */
> -    u8  oem_id [6];             /* OEM identification */
> -    u8  revision;               /* Must be 0 for 1.0, 2 for 2.0 */
> -    u32 rsdt_physical_address;  /* 32-bit physical address of RSDT */
> -    u32 length;                 /* XSDT Length in bytes including hdr */
> -    u64 xsdt_physical_address;  /* 64-bit physical address of XSDT */
> -    u8  extended_checksum;      /* Checksum of entire table */
> -    u8  reserved [3];           /* Reserved field must be 0 */
> +struct rsdp_descriptor {	/* Root System Descriptor Pointer */
> +	u64 signature;		/* ACPI signature, contains "RSD PTR " */
> +	u8 checksum;		/* To make sum of struct == 0 */
> +	u8 oem_id[6];		/* OEM identification */
> +	u8 revision;		/* Must be 0 for 1.0, 2 for 2.0 */
> +	u32 rsdt_physical_address;	/* 32-bit physical address of RSDT */
> +	u32 length;		/* XSDT Length in bytes including hdr */
> +	u64 xsdt_physical_address;	/* 64-bit physical address of XSDT */
> +	u8 extended_checksum;	/* Checksum of entire table */
> +	u8 reserved[3];		/* Reserved field must be 0 */
>   };
>   
> -#define ACPI_TABLE_HEADER_DEF   /* ACPI common table header */ \
> -    u32 signature;          /* ACPI signature (4 ASCII characters) */ \
> -    u32 length;                 /* Length of table, in bytes, including header */ \
> -    u8  revision;               /* ACPI Specification minor version # */ \
> -    u8  checksum;               /* To make sum of entire table == 0 */ \
> -    u8  oem_id [6];             /* OEM identification */ \
> -    u8  oem_table_id [8];       /* OEM table identification */ \
> -    u32 oem_revision;           /* OEM revision number */ \
> -    u8  asl_compiler_id [4];    /* ASL compiler vendor ID */ \
> -    u32 asl_compiler_revision;  /* ASL compiler revision number */
> +#define ACPI_TABLE_HEADER_DEF		/* ACPI common table header */			\
> +	u32 signature;			/* ACPI signature (4 ASCII characters) */	\
> +	u32 length;			/* Length of table, in bytes, including header */ \
> +	u8  revision;			/* ACPI Specification minor version # */	\
> +	u8  checksum;			/* To make sum of entire table == 0 */		\
> +	u8  oem_id [6];			/* OEM identification */			\
> +	u8  oem_table_id [8];		/* OEM table identification */			\
> +	u32 oem_revision;		/* OEM revision number */			\
> +	u8  asl_compiler_id [4];	/* ASL compiler vendor ID */			\
> +	u32 asl_compiler_revision;	/* ASL compiler revision number */
>   
>   struct acpi_table {
> -    ACPI_TABLE_HEADER_DEF
> -    char data[0];
> +	ACPI_TABLE_HEADER_DEF
> +	char data[0];
>   };
>   
>   struct rsdt_descriptor_rev1 {
> -    ACPI_TABLE_HEADER_DEF
> -    u32 table_offset_entry[0];
> +	ACPI_TABLE_HEADER_DEF
> +	u32 table_offset_entry[1];
>   };
>   
> -struct fadt_descriptor_rev1
> -{
> -    ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
> -    u32 firmware_ctrl;          /* Physical address of FACS */
> -    u32 dsdt;                   /* Physical address of DSDT */
> -    u8  model;                  /* System Interrupt Model */
> -    u8  reserved1;              /* Reserved */
> -    u16 sci_int;                /* System vector of SCI interrupt */
> -    u32 smi_cmd;                /* Port address of SMI command port */
> -    u8  acpi_enable;            /* Value to write to smi_cmd to enable ACPI */
> -    u8  acpi_disable;           /* Value to write to smi_cmd to disable ACPI */
> -    u8  S4bios_req;             /* Value to write to SMI CMD to enter S4BIOS state */
> -    u8  reserved2;              /* Reserved - must be zero */
> -    u32 pm1a_evt_blk;           /* Port address of Power Mgt 1a acpi_event Reg Blk */
> -    u32 pm1b_evt_blk;           /* Port address of Power Mgt 1b acpi_event Reg Blk */
> -    u32 pm1a_cnt_blk;           /* Port address of Power Mgt 1a Control Reg Blk */
> -    u32 pm1b_cnt_blk;           /* Port address of Power Mgt 1b Control Reg Blk */
> -    u32 pm2_cnt_blk;            /* Port address of Power Mgt 2 Control Reg Blk */
> -    u32 pm_tmr_blk;             /* Port address of Power Mgt Timer Ctrl Reg Blk */
> -    u32 gpe0_blk;               /* Port addr of General Purpose acpi_event 0 Reg Blk */
> -    u32 gpe1_blk;               /* Port addr of General Purpose acpi_event 1 Reg Blk */
> -    u8  pm1_evt_len;            /* Byte length of ports at pm1_x_evt_blk */
> -    u8  pm1_cnt_len;            /* Byte length of ports at pm1_x_cnt_blk */
> -    u8  pm2_cnt_len;            /* Byte Length of ports at pm2_cnt_blk */
> -    u8  pm_tmr_len;             /* Byte Length of ports at pm_tm_blk */
> -    u8  gpe0_blk_len;           /* Byte Length of ports at gpe0_blk */
> -    u8  gpe1_blk_len;           /* Byte Length of ports at gpe1_blk */
> -    u8  gpe1_base;              /* Offset in gpe model where gpe1 events start */
> -    u8  reserved3;              /* Reserved */
> -    u16 plvl2_lat;              /* Worst case HW latency to enter/exit C2 state */
> -    u16 plvl3_lat;              /* Worst case HW latency to enter/exit C3 state */
> -    u16 flush_size;             /* Size of area read to flush caches */
> -    u16 flush_stride;           /* Stride used in flushing caches */
> -    u8  duty_offset;            /* Bit location of duty cycle field in p_cnt reg */
> -    u8  duty_width;             /* Bit width of duty cycle field in p_cnt reg */
> -    u8  day_alrm;               /* Index to day-of-month alarm in RTC CMOS RAM */
> -    u8  mon_alrm;               /* Index to month-of-year alarm in RTC CMOS RAM */
> -    u8  century;                /* Index to century in RTC CMOS RAM */
> -    u8  reserved4;              /* Reserved */
> -    u8  reserved4a;             /* Reserved */
> -    u8  reserved4b;             /* Reserved */
> +struct fadt_descriptor_rev1 {
> +	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
> +	u32 firmware_ctrl;	/* Physical address of FACS */
> +	u32 dsdt;		/* Physical address of DSDT */
> +	u8 model;		/* System Interrupt Model */
> +	u8 reserved1;		/* Reserved */
> +	u16 sci_int;		/* System vector of SCI interrupt */
> +	u32 smi_cmd;		/* Port address of SMI command port */
> +	u8 acpi_enable;		/* Value to write to smi_cmd to enable ACPI */
> +	u8 acpi_disable;	/* Value to write to smi_cmd to disable ACPI */
> +	u8 S4bios_req;		/* Value to write to SMI CMD to enter S4BIOS state */
> +	u8 reserved2;		/* Reserved - must be zero */
> +	u32 pm1a_evt_blk;	/* Port address of Power Mgt 1a acpi_event Reg Blk */
> +	u32 pm1b_evt_blk;	/* Port address of Power Mgt 1b acpi_event Reg Blk */
> +	u32 pm1a_cnt_blk;	/* Port address of Power Mgt 1a Control Reg Blk */
> +	u32 pm1b_cnt_blk;	/* Port address of Power Mgt 1b Control Reg Blk */
> +	u32 pm2_cnt_blk;	/* Port address of Power Mgt 2 Control Reg Blk */
> +	u32 pm_tmr_blk;		/* Port address of Power Mgt Timer Ctrl Reg Blk */
> +	u32 gpe0_blk;		/* Port addr of General Purpose acpi_event 0 Reg Blk */
> +	u32 gpe1_blk;		/* Port addr of General Purpose acpi_event 1 Reg Blk */
> +	u8 pm1_evt_len;		/* Byte length of ports at pm1_x_evt_blk */
> +	u8 pm1_cnt_len;		/* Byte length of ports at pm1_x_cnt_blk */
> +	u8 pm2_cnt_len;		/* Byte Length of ports at pm2_cnt_blk */
> +	u8 pm_tmr_len;		/* Byte Length of ports at pm_tm_blk */
> +	u8 gpe0_blk_len;	/* Byte Length of ports at gpe0_blk */
> +	u8 gpe1_blk_len;	/* Byte Length of ports at gpe1_blk */
> +	u8 gpe1_base;		/* Offset in gpe model where gpe1 events start */
> +	u8 reserved3;		/* Reserved */
> +	u16 plvl2_lat;		/* Worst case HW latency to enter/exit C2 state */
> +	u16 plvl3_lat;		/* Worst case HW latency to enter/exit C3 state */
> +	u16 flush_size;		/* Size of area read to flush caches */
> +	u16 flush_stride;	/* Stride used in flushing caches */
> +	u8 duty_offset;		/* Bit location of duty cycle field in p_cnt reg */
> +	u8 duty_width;		/* Bit width of duty cycle field in p_cnt reg */
> +	u8 day_alrm;		/* Index to day-of-month alarm in RTC CMOS RAM */
> +	u8 mon_alrm;		/* Index to month-of-year alarm in RTC CMOS RAM */
> +	u8 century;		/* Index to century in RTC CMOS RAM */
> +	u8 reserved4;		/* Reserved */
> +	u8 reserved4a;		/* Reserved */
> +	u8 reserved4b;		/* Reserved */
>   };
>   
> -struct facs_descriptor_rev1
> -{
> -    u32 signature;           /* ACPI Signature */
> -    u32 length;                 /* Length of structure, in bytes */
> -    u32 hardware_signature;     /* Hardware configuration signature */
> -    u32 firmware_waking_vector; /* ACPI OS waking vector */
> -    u32 global_lock;            /* Global Lock */
> -    u32 S4bios_f        : 1;    /* Indicates if S4BIOS support is present */
> -    u32 reserved1       : 31;   /* Must be 0 */
> -    u8  reserved3 [40];         /* Reserved - must be zero */
> +struct facs_descriptor_rev1 {
> +	u32 signature;		/* ACPI Signature */
> +	u32 length;		/* Length of structure, in bytes */
> +	u32 hardware_signature;	/* Hardware configuration signature */
> +	u32 firmware_waking_vector;	/* ACPI OS waking vector */
> +	u32 global_lock;	/* Global Lock */
> +	u32 S4bios_f:1;		/* Indicates if S4BIOS support is present */
> +	u32 reserved1:31;	/* Must be 0 */
> +	u8 reserved3[40];	/* Reserved - must be zero */
>   };
>   
>   void set_efi_rsdp(struct rsdp_descriptor *rsdp);
> -void* find_acpi_table_addr(u32 sig);
> +void *find_acpi_table_addr(u32 sig);
>   
>   #endif
> diff --git a/lib/acpi.c b/lib/acpi.c
> index de275caf..836156a1 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -36,47 +36,45 @@ static struct rsdp_descriptor *get_rsdp(void)
>   }
>   #endif /* CONFIG_EFI */
>   
> -void* find_acpi_table_addr(u32 sig)
> +void *find_acpi_table_addr(u32 sig)
>   {
> -    struct rsdp_descriptor *rsdp;
> -    struct rsdt_descriptor_rev1 *rsdt;
> -    void *end;
> -    int i;
> +	struct rsdp_descriptor *rsdp;
> +	struct rsdt_descriptor_rev1 *rsdt;
> +	void *end;
> +	int i;
>   
> -    /* FACS is special... */
> -    if (sig == FACS_SIGNATURE) {
> -        struct fadt_descriptor_rev1 *fadt;
> -        fadt = find_acpi_table_addr(FACP_SIGNATURE);
> -        if (!fadt) {
> -            return NULL;
> -        }
> -        return (void*)(ulong)fadt->firmware_ctrl;
> -    }
> +	/* FACS is special... */
> +	if (sig == FACS_SIGNATURE) {
> +		struct fadt_descriptor_rev1 *fadt;
> +		fadt = find_acpi_table_addr(FACP_SIGNATURE);
> +		if (!fadt)
> +			return NULL;
>   
> -    rsdp = get_rsdp();
> -    if (rsdp == NULL) {
> -        printf("Can't find RSDP\n");
> -        return 0;
> -    }
> +		return (void *)(ulong) fadt->firmware_ctrl;
> +	}
>   
> -    if (sig == RSDP_SIGNATURE) {
> -        return rsdp;
> -    }
> +	rsdp = get_rsdp();
> +	if (rsdp == NULL) {
> +		printf("Can't find RSDP\n");
> +		return NULL;
> +	}
>   
> -    rsdt = (void*)(ulong)rsdp->rsdt_physical_address;
> -    if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
> -        return 0;
> +	if (sig == RSDP_SIGNATURE)
> +		return rsdp;
>   
> -    if (sig == RSDT_SIGNATURE) {
> -        return rsdt;
> -    }
> +	rsdt = (void *)(ulong) rsdp->rsdt_physical_address;
> +	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
> +		return NULL;
> +
> +	if (sig == RSDT_SIGNATURE)
> +		return rsdt;
>   
> -    end = (void*)rsdt + rsdt->length;
> -    for (i=0; (void*)&rsdt->table_offset_entry[i] < end; i++) {
> -        struct acpi_table *t = (void*)(ulong)rsdt->table_offset_entry[i];
> -        if (t && t->signature == sig) {
> -            return t;
> -        }
> -    }
> -   return NULL;
> +	end = (void *)rsdt + rsdt->length;
> +	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
> +		struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
> +		if (t && t->signature == sig) {
> +			return t;
> +		}
> +	}
> +	return NULL;
>   }

-- 
Shaoqin

