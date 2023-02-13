Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289B5694292
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjBMKSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjBMKSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:11 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16BFA8A69
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:10 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 354CD19F0;
        Mon, 13 Feb 2023 02:18:52 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B1C23F703;
        Mon, 13 Feb 2023 02:18:08 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [PATCH v4 04/30] lib: Apply Lindent to acpi.{c,h}
Date:   Mon, 13 Feb 2023 10:17:33 +0000
Message-Id: <20230213101759.2577077-5-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The change was done by modifying Linux's scripts/Lindent to use 100
columns instead of 80.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.c |  70 ++++++++++++------------
 lib/acpi.h | 157 ++++++++++++++++++++++++++---------------------------
 2 files changed, 111 insertions(+), 116 deletions(-)

diff --git a/lib/acpi.c b/lib/acpi.c
index de275caf..836156a1 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -36,47 +36,45 @@ static struct rsdp_descriptor *get_rsdp(void)
 }
 #endif /* CONFIG_EFI */
 
-void* find_acpi_table_addr(u32 sig)
+void *find_acpi_table_addr(u32 sig)
 {
-    struct rsdp_descriptor *rsdp;
-    struct rsdt_descriptor_rev1 *rsdt;
-    void *end;
-    int i;
+	struct rsdp_descriptor *rsdp;
+	struct rsdt_descriptor_rev1 *rsdt;
+	void *end;
+	int i;
 
-    /* FACS is special... */
-    if (sig == FACS_SIGNATURE) {
-        struct fadt_descriptor_rev1 *fadt;
-        fadt = find_acpi_table_addr(FACP_SIGNATURE);
-        if (!fadt) {
-            return NULL;
-        }
-        return (void*)(ulong)fadt->firmware_ctrl;
-    }
+	/* FACS is special... */
+	if (sig == FACS_SIGNATURE) {
+		struct fadt_descriptor_rev1 *fadt;
+		fadt = find_acpi_table_addr(FACP_SIGNATURE);
+		if (!fadt)
+			return NULL;
 
-    rsdp = get_rsdp();
-    if (rsdp == NULL) {
-        printf("Can't find RSDP\n");
-        return 0;
-    }
+		return (void *)(ulong) fadt->firmware_ctrl;
+	}
 
-    if (sig == RSDP_SIGNATURE) {
-        return rsdp;
-    }
+	rsdp = get_rsdp();
+	if (rsdp == NULL) {
+		printf("Can't find RSDP\n");
+		return NULL;
+	}
 
-    rsdt = (void*)(ulong)rsdp->rsdt_physical_address;
-    if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
-        return 0;
+	if (sig == RSDP_SIGNATURE)
+		return rsdp;
 
-    if (sig == RSDT_SIGNATURE) {
-        return rsdt;
-    }
+	rsdt = (void *)(ulong) rsdp->rsdt_physical_address;
+	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
+		return NULL;
+
+	if (sig == RSDT_SIGNATURE)
+		return rsdt;
 
-    end = (void*)rsdt + rsdt->length;
-    for (i=0; (void*)&rsdt->table_offset_entry[i] < end; i++) {
-        struct acpi_table *t = (void*)(ulong)rsdt->table_offset_entry[i];
-        if (t && t->signature == sig) {
-            return t;
-        }
-    }
-   return NULL;
+	end = (void *)rsdt + rsdt->length;
+	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
+		struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
+		if (t && t->signature == sig) {
+			return t;
+		}
+	}
+	return NULL;
 }
diff --git a/lib/acpi.h b/lib/acpi.h
index 1e89840c..b67bbe19 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -3,7 +3,7 @@
 
 #include "libcflat.h"
 
-#define ACPI_SIGNATURE(c1, c2, c3, c4) \
+#define ACPI_SIGNATURE(c1, c2, c3, c4)				\
 	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
 
 #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
@@ -11,102 +11,99 @@
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
 
-
-#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
-	((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |       \
+#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8)	\
+	((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |		\
 	((uint64_t)(ACPI_SIGNATURE(c5, c6, c7, c8)) << 32)
 
 #define RSDP_SIGNATURE_8BYTE (ACPI_SIGNATURE_8BYTE('R', 'S', 'D', ' ', 'P', 'T', 'R', ' '))
 
-struct rsdp_descriptor {        /* Root System Descriptor Pointer */
-    u64 signature;              /* ACPI signature, contains "RSD PTR " */
-    u8  checksum;               /* To make sum of struct == 0 */
-    u8  oem_id [6];             /* OEM identification */
-    u8  revision;               /* Must be 0 for 1.0, 2 for 2.0 */
-    u32 rsdt_physical_address;  /* 32-bit physical address of RSDT */
-    u32 length;                 /* XSDT Length in bytes including hdr */
-    u64 xsdt_physical_address;  /* 64-bit physical address of XSDT */
-    u8  extended_checksum;      /* Checksum of entire table */
-    u8  reserved [3];           /* Reserved field must be 0 */
+struct rsdp_descriptor {	/* Root System Descriptor Pointer */
+	u64 signature;		/* ACPI signature, contains "RSD PTR " */
+	u8 checksum;		/* To make sum of struct == 0 */
+	u8 oem_id[6];		/* OEM identification */
+	u8 revision;		/* Must be 0 for 1.0, 2 for 2.0 */
+	u32 rsdt_physical_address;	/* 32-bit physical address of RSDT */
+	u32 length;		/* XSDT Length in bytes including hdr */
+	u64 xsdt_physical_address;	/* 64-bit physical address of XSDT */
+	u8 extended_checksum;	/* Checksum of entire table */
+	u8 reserved[3];		/* Reserved field must be 0 */
 };
 
-#define ACPI_TABLE_HEADER_DEF   /* ACPI common table header */ \
-    u32 signature;          /* ACPI signature (4 ASCII characters) */ \
-    u32 length;                 /* Length of table, in bytes, including header */ \
-    u8  revision;               /* ACPI Specification minor version # */ \
-    u8  checksum;               /* To make sum of entire table == 0 */ \
-    u8  oem_id [6];             /* OEM identification */ \
-    u8  oem_table_id [8];       /* OEM table identification */ \
-    u32 oem_revision;           /* OEM revision number */ \
-    u8  asl_compiler_id [4];    /* ASL compiler vendor ID */ \
-    u32 asl_compiler_revision;  /* ASL compiler revision number */
+#define ACPI_TABLE_HEADER_DEF		/* ACPI common table header */			\
+	u32 signature;			/* ACPI signature (4 ASCII characters) */	\
+	u32 length;			/* Length of table, in bytes, including header */ \
+	u8  revision;			/* ACPI Specification minor version # */	\
+	u8  checksum;			/* To make sum of entire table == 0 */		\
+	u8  oem_id [6];			/* OEM identification */			\
+	u8  oem_table_id [8];		/* OEM table identification */			\
+	u32 oem_revision;		/* OEM revision number */			\
+	u8  asl_compiler_id [4];	/* ASL compiler vendor ID */			\
+	u32 asl_compiler_revision;	/* ASL compiler revision number */
 
 struct acpi_table {
-    ACPI_TABLE_HEADER_DEF
-    char data[0];
+	ACPI_TABLE_HEADER_DEF
+	char data[0];
 };
 
 struct rsdt_descriptor_rev1 {
-    ACPI_TABLE_HEADER_DEF
-    u32 table_offset_entry[0];
+	ACPI_TABLE_HEADER_DEF
+	u32 table_offset_entry[1];
 };
 
-struct fadt_descriptor_rev1
-{
-    ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
-    u32 firmware_ctrl;          /* Physical address of FACS */
-    u32 dsdt;                   /* Physical address of DSDT */
-    u8  model;                  /* System Interrupt Model */
-    u8  reserved1;              /* Reserved */
-    u16 sci_int;                /* System vector of SCI interrupt */
-    u32 smi_cmd;                /* Port address of SMI command port */
-    u8  acpi_enable;            /* Value to write to smi_cmd to enable ACPI */
-    u8  acpi_disable;           /* Value to write to smi_cmd to disable ACPI */
-    u8  S4bios_req;             /* Value to write to SMI CMD to enter S4BIOS state */
-    u8  reserved2;              /* Reserved - must be zero */
-    u32 pm1a_evt_blk;           /* Port address of Power Mgt 1a acpi_event Reg Blk */
-    u32 pm1b_evt_blk;           /* Port address of Power Mgt 1b acpi_event Reg Blk */
-    u32 pm1a_cnt_blk;           /* Port address of Power Mgt 1a Control Reg Blk */
-    u32 pm1b_cnt_blk;           /* Port address of Power Mgt 1b Control Reg Blk */
-    u32 pm2_cnt_blk;            /* Port address of Power Mgt 2 Control Reg Blk */
-    u32 pm_tmr_blk;             /* Port address of Power Mgt Timer Ctrl Reg Blk */
-    u32 gpe0_blk;               /* Port addr of General Purpose acpi_event 0 Reg Blk */
-    u32 gpe1_blk;               /* Port addr of General Purpose acpi_event 1 Reg Blk */
-    u8  pm1_evt_len;            /* Byte length of ports at pm1_x_evt_blk */
-    u8  pm1_cnt_len;            /* Byte length of ports at pm1_x_cnt_blk */
-    u8  pm2_cnt_len;            /* Byte Length of ports at pm2_cnt_blk */
-    u8  pm_tmr_len;             /* Byte Length of ports at pm_tm_blk */
-    u8  gpe0_blk_len;           /* Byte Length of ports at gpe0_blk */
-    u8  gpe1_blk_len;           /* Byte Length of ports at gpe1_blk */
-    u8  gpe1_base;              /* Offset in gpe model where gpe1 events start */
-    u8  reserved3;              /* Reserved */
-    u16 plvl2_lat;              /* Worst case HW latency to enter/exit C2 state */
-    u16 plvl3_lat;              /* Worst case HW latency to enter/exit C3 state */
-    u16 flush_size;             /* Size of area read to flush caches */
-    u16 flush_stride;           /* Stride used in flushing caches */
-    u8  duty_offset;            /* Bit location of duty cycle field in p_cnt reg */
-    u8  duty_width;             /* Bit width of duty cycle field in p_cnt reg */
-    u8  day_alrm;               /* Index to day-of-month alarm in RTC CMOS RAM */
-    u8  mon_alrm;               /* Index to month-of-year alarm in RTC CMOS RAM */
-    u8  century;                /* Index to century in RTC CMOS RAM */
-    u8  reserved4;              /* Reserved */
-    u8  reserved4a;             /* Reserved */
-    u8  reserved4b;             /* Reserved */
+struct fadt_descriptor_rev1 {
+	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
+	u32 firmware_ctrl;	/* Physical address of FACS */
+	u32 dsdt;		/* Physical address of DSDT */
+	u8 model;		/* System Interrupt Model */
+	u8 reserved1;		/* Reserved */
+	u16 sci_int;		/* System vector of SCI interrupt */
+	u32 smi_cmd;		/* Port address of SMI command port */
+	u8 acpi_enable;		/* Value to write to smi_cmd to enable ACPI */
+	u8 acpi_disable;	/* Value to write to smi_cmd to disable ACPI */
+	u8 S4bios_req;		/* Value to write to SMI CMD to enter S4BIOS state */
+	u8 reserved2;		/* Reserved - must be zero */
+	u32 pm1a_evt_blk;	/* Port address of Power Mgt 1a acpi_event Reg Blk */
+	u32 pm1b_evt_blk;	/* Port address of Power Mgt 1b acpi_event Reg Blk */
+	u32 pm1a_cnt_blk;	/* Port address of Power Mgt 1a Control Reg Blk */
+	u32 pm1b_cnt_blk;	/* Port address of Power Mgt 1b Control Reg Blk */
+	u32 pm2_cnt_blk;	/* Port address of Power Mgt 2 Control Reg Blk */
+	u32 pm_tmr_blk;		/* Port address of Power Mgt Timer Ctrl Reg Blk */
+	u32 gpe0_blk;		/* Port addr of General Purpose acpi_event 0 Reg Blk */
+	u32 gpe1_blk;		/* Port addr of General Purpose acpi_event 1 Reg Blk */
+	u8 pm1_evt_len;		/* Byte length of ports at pm1_x_evt_blk */
+	u8 pm1_cnt_len;		/* Byte length of ports at pm1_x_cnt_blk */
+	u8 pm2_cnt_len;		/* Byte Length of ports at pm2_cnt_blk */
+	u8 pm_tmr_len;		/* Byte Length of ports at pm_tm_blk */
+	u8 gpe0_blk_len;	/* Byte Length of ports at gpe0_blk */
+	u8 gpe1_blk_len;	/* Byte Length of ports at gpe1_blk */
+	u8 gpe1_base;		/* Offset in gpe model where gpe1 events start */
+	u8 reserved3;		/* Reserved */
+	u16 plvl2_lat;		/* Worst case HW latency to enter/exit C2 state */
+	u16 plvl3_lat;		/* Worst case HW latency to enter/exit C3 state */
+	u16 flush_size;		/* Size of area read to flush caches */
+	u16 flush_stride;	/* Stride used in flushing caches */
+	u8 duty_offset;		/* Bit location of duty cycle field in p_cnt reg */
+	u8 duty_width;		/* Bit width of duty cycle field in p_cnt reg */
+	u8 day_alrm;		/* Index to day-of-month alarm in RTC CMOS RAM */
+	u8 mon_alrm;		/* Index to month-of-year alarm in RTC CMOS RAM */
+	u8 century;		/* Index to century in RTC CMOS RAM */
+	u8 reserved4;		/* Reserved */
+	u8 reserved4a;		/* Reserved */
+	u8 reserved4b;		/* Reserved */
 };
 
-struct facs_descriptor_rev1
-{
-    u32 signature;           /* ACPI Signature */
-    u32 length;                 /* Length of structure, in bytes */
-    u32 hardware_signature;     /* Hardware configuration signature */
-    u32 firmware_waking_vector; /* ACPI OS waking vector */
-    u32 global_lock;            /* Global Lock */
-    u32 S4bios_f        : 1;    /* Indicates if S4BIOS support is present */
-    u32 reserved1       : 31;   /* Must be 0 */
-    u8  reserved3 [40];         /* Reserved - must be zero */
+struct facs_descriptor_rev1 {
+	u32 signature;		/* ACPI Signature */
+	u32 length;		/* Length of structure, in bytes */
+	u32 hardware_signature;	/* Hardware configuration signature */
+	u32 firmware_waking_vector;	/* ACPI OS waking vector */
+	u32 global_lock;	/* Global Lock */
+	u32 S4bios_f:1;		/* Indicates if S4BIOS support is present */
+	u32 reserved1:31;	/* Must be 0 */
+	u8 reserved3[40];	/* Reserved - must be zero */
 };
 
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
-void* find_acpi_table_addr(u32 sig);
+void *find_acpi_table_addr(u32 sig);
 
 #endif
-- 
2.25.1

