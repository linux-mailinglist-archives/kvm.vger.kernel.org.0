Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED2B6B1C1D
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 08:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjCIHNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 02:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjCIHM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 02:12:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33592C4EB9
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 23:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678345926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MN7OMtHxmNp2m1gq5YKxzv3cvMXxiYKibiatKk9Kb4E=;
        b=O5KqxhTNnaskWRjiHr0j64DIPwTL7euXqyzf680T7YSxH6u2GtR/viLaZCgjSVExW0Mx7/
        ZkiYtaS57vZxxQLN9hFsxpm3n9FQOXWnPjFU1h/nXW0K8Uz5F09JXg/cPw92yYMx+BtGLS
        NRB6bNCuNub3RbxKlX3/UvAmJpH9xR8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-IOgHRzCqMZ-AyxO2wuVUSw-1; Thu, 09 Mar 2023 02:12:02 -0500
X-MC-Unique: IOgHRzCqMZ-AyxO2wuVUSw-1
Received: by mail-qk1-f199.google.com with SMTP id s21-20020a05620a0bd500b0074234f33f24so750506qki.3
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 23:12:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678345922;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MN7OMtHxmNp2m1gq5YKxzv3cvMXxiYKibiatKk9Kb4E=;
        b=3EfdgvWUUsEmzjQBY7dBawiP7uyrpuN4xfYjSX8na/lUXrRnSy/E3+qwNjAdYgZY0Q
         QGwn09Qw2KleYnT/UgCURAX0P0Ui7HWAy5LbNDQKfr59aQ+XmQwuXlQhev6w9vDrravq
         fMzzQ2q70z0nnIGLaQwGv+QZk9J/yRDwjY+OhEkjC/RBhRCysJ/kUX3W7xRl3gixJedf
         Ij2vXRpU+4p5TKA+cfvlNDFvRYaAj2knRBo9APLSH7Pt5bUoiuvKg5fQQnq/wsInAX6R
         kZYOwoUwFRqplalM5sVtrfSMhI753yrn43JTW8CWl/RlVXc4z6uCTArLbsbzGx3qbBi4
         hgtA==
X-Gm-Message-State: AO0yUKVYAMrfDe7b3G0Tpqtiet/lqyaBG/8+cS5usSCLNMvqlcYUue3i
        fnPXrO2grb4JvRm0Ek6TR2mnB98u7eMRN35VmUhO185ECv2Gd1ZGop9ANl392g7z6PIIHbRmLrY
        eetKkFNlsy46t
X-Received: by 2002:ac8:5f07:0:b0:3bf:bfde:91bd with SMTP id x7-20020ac85f07000000b003bfbfde91bdmr39608527qta.5.1678345922383;
        Wed, 08 Mar 2023 23:12:02 -0800 (PST)
X-Google-Smtp-Source: AK7set9m886q+QGhzFVxkj5HdOJQx4Rf6yuj/OBRdIqBpZPO3tqzchqiGqvVQFrM0gXIr7FPVA6+jA==
X-Received: by 2002:ac8:5f07:0:b0:3bf:bfde:91bd with SMTP id x7-20020ac85f07000000b003bfbfde91bdmr39608504qta.5.1678345922082;
        Wed, 08 Mar 2023 23:12:02 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c26-20020a05620a0cfa00b0073b81e888bfsm12573602qkj.56.2023.03.08.23.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 23:12:01 -0800 (PST)
Message-ID: <5a8887b2-a276-b087-964e-fa3f98826185@redhat.com>
Date:   Thu, 9 Mar 2023 15:11:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 04/30] lib: Apply Lindent to acpi.{c,h}
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-5-nikos.nikoleris@arm.com>
Content-Language: en-US
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230213101759.2577077-5-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SPF_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

On 2/13/23 18:17, Nikos Nikoleris wrote:
> The change was done by modifying Linux's scripts/Lindent to use 100
> columns instead of 80.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>   lib/acpi.c |  70 ++++++++++++------------
>   lib/acpi.h | 157 ++++++++++++++++++++++++++---------------------------
>   2 files changed, 111 insertions(+), 116 deletions(-)
> 
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
                   ^
> +	u8  oem_table_id [8];		/* OEM table identification */			\
                         ^
> +	u32 oem_revision;		/* OEM revision number */			\
> +	u8  asl_compiler_id [4];	/* ASL compiler vendor ID */			\
                            ^
nit: These space should also be deleted.

Thanks,
Shaoqin
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

