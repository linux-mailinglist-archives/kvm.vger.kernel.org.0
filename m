Return-Path: <kvm+bounces-4676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E587816714
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:11:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B56D1F21800
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7F81078B;
	Mon, 18 Dec 2023 07:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f4fiyh36"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8022D101D3
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883439; x=1734419439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eoQVcT+O7jp9KKx1NjBwMZmhGMNqL1RJbZqdptwCNkY=;
  b=f4fiyh36V+Ezj52tpbnWzXIU9HRbutAuUz92rJpZvOr7VqBxf3wbtj3a
   I1fK+HT1I2ugtX2R1okartuULNROSRtqkcUPXDg1ycrJWwrryooYW028J
   OZhnljFvofz7eLHAQorfTLxPuI3+cjuFiiPRKiQftuj/wBCKF/sF3MH3F
   5lESQimZPYvwN6d9iHPZ8bTgSoMbfL8LRsyZMuFlmCV+vokyOF3GhmzRy
   mpsT/WO3k208iX1MmuaVd8CKaT/1poB3dTvTmmg+SouorLEqpBbn2+sct
   NiJ2bAiCmSchpjkUClKs3maKa6Bf9oLcWRTUoWWHxOAQi1Ki5r2iwaxmP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667923"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667923"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824728"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824728"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:35 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 10/18] acpi: Add MADT table parse code
Date: Mon, 18 Dec 2023 15:22:39 +0800
Message-Id: <20231218072247.2573516-11-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Support LAPIC, X2APIC and WAKEUP sub-table, other sub-table are ignored
for now. Also add a wakeup wrapping function which is used by TDX.

The parsed result is stored in id_map[] and acpi_mp_wake_mailbox.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-10-zhenzhong.duan@intel.com
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/acpi.c      | 160 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/acpi.h      |  59 +++++++++++++++++-
 lib/x86/setup.c |   4 ++
 3 files changed, 222 insertions(+), 1 deletion(-)

diff --git a/lib/acpi.c b/lib/acpi.c
index 0440cddb..9db32e2a 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -1,5 +1,7 @@
 #include "libcflat.h"
 #include "acpi.h"
+#include "errno.h"
+#include "asm/barrier.h"
 
 #ifdef CONFIG_EFI
 struct acpi_table_rsdp *efi_rsdp = NULL;
@@ -127,3 +129,161 @@ int acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler)
 
 	return count;
 }
+
+struct acpi_madt_multiproc_wakeup_mailbox *acpi_mp_wake_mailbox;
+
+#define smp_store_release(p, val)					\
+do {									\
+	barrier();							\
+	WRITE_ONCE(*p, val);						\
+} while (0)
+
+static inline bool test_bit(int nr, const void *addr)
+{
+	const u32 *p = (const u32 *)addr;
+	return ((1UL << (nr & 31)) & (p[nr >> 5])) != 0;
+}
+
+int acpi_wakeup_cpu(int apicid, unsigned long start_ip, unsigned char* cpus)
+{
+	u8 timeout = 0xFF;
+
+	/*
+	 * According to the ACPI specification r6.4, sec 5.2.12.19, the
+	 * mailbox-based wakeup mechanism cannot be used more than once
+	 * for the same CPU, so skip sending wake commands to already
+	 * awake CPU.
+	 */
+	if (test_bit(apicid, cpus)) {
+		printf("CPU already awake (APIC ID %x), skipping wakeup\n",
+		       apicid);
+		return -EINVAL;
+	}
+
+	/*
+	 * Mailbox memory is shared between firmware and OS. Firmware will
+	 * listen on mailbox command address, and once it receives the wakeup
+	 * command, CPU associated with the given apicid will be booted. So,
+	 * the value of apic_id and wakeup_vector has to be set before updating
+	 * the wakeup command. So use smp_store_release to let the compiler know
+	 * about it and preserve the order of writes.
+	 */
+	smp_store_release(&acpi_mp_wake_mailbox->apic_id, apicid);
+	smp_store_release(&acpi_mp_wake_mailbox->wakeup_vector, start_ip);
+	smp_store_release(&acpi_mp_wake_mailbox->command,
+			  ACPI_MP_WAKE_COMMAND_WAKEUP);
+
+	/*
+	 * After writing wakeup command, wait for maximum timeout of 0xFF
+	 * for firmware to reset the command address back zero to indicate
+	 * the successful reception of command.
+	 * NOTE: 255 as timeout value is decided based on our experiments.
+	 *
+	 * XXX: Change the timeout once ACPI specification comes up with
+	 *      standard maximum timeout value.
+	 */
+	while (READ_ONCE(acpi_mp_wake_mailbox->command) && timeout--)
+		cpu_relax();
+
+	/* If timed out (timeout == 0), return error.
+	 * Otherwise, the CPU wakes up successfully.
+	 */
+	return timeout == 0 ? -EIO : 0;
+}
+
+static bool parse_madt_table(struct acpi_table *madt, unsigned char* id_map)
+{
+	u64 table_start = (unsigned long)madt + sizeof(struct acpi_table_madt);
+	u64 table_end = (unsigned long)madt + madt->length;
+	struct acpi_subtable_header *sub_table;
+	bool failed = false;
+	u32 uid, apic_id;
+	u8 enabled;
+
+	while (table_start < table_end && !failed) {
+		struct acpi_madt_local_apic *processor;
+		struct acpi_madt_local_x2apic *processor2;
+		struct acpi_madt_multiproc_wakeup *mp_wake;
+
+		sub_table = (struct acpi_subtable_header *)table_start;
+
+		switch (sub_table->type) {
+		case ACPI_MADT_TYPE_LOCAL_APIC:
+			processor = (struct acpi_madt_local_apic *)sub_table;
+
+			if (BAD_MADT_ENTRY(processor, table_end)) {
+				failed = true;
+				break;
+			}
+
+			uid = processor->processor_id;
+			apic_id = processor->id;
+			enabled = processor->lapic_flags & ACPI_MADT_ENABLED;
+
+			/* Ignore invalid ID */
+			if (apic_id == 0xff)
+				break;
+			if (enabled)
+				id_map[uid] = apic_id;
+
+			printf("apicid %x uid %x %s\n", apic_id, uid,
+			       enabled ? "enabled" : "disabled");
+			break;
+
+		case ACPI_MADT_TYPE_LOCAL_X2APIC:
+			processor2 = (struct acpi_madt_local_x2apic *)sub_table;
+
+			if (BAD_MADT_ENTRY(processor2, table_end)) {
+				failed = true;
+				break;
+			}
+
+			uid = processor2->uid;
+			apic_id = processor2->local_apic_id;
+			enabled = processor2->lapic_flags & ACPI_MADT_ENABLED;
+
+			/* Ignore invalid ID */
+			if (apic_id == 0xffffffff)
+				break;
+			if (enabled)
+				id_map[uid] = apic_id;
+
+			printf("x2apicid %x uid %x %s\n", apic_id, uid,
+			       enabled ? "enabled" : "disabled");
+			break;
+		case ACPI_MADT_TYPE_MULTIPROC_WAKEUP:
+			mp_wake = (struct acpi_madt_multiproc_wakeup *)sub_table;
+
+			if (BAD_MADT_ENTRY(mp_wake, table_end)) {
+				failed = true;
+				break;
+			}
+
+			if (acpi_mp_wake_mailbox)
+				printf("WARN: duplicate mailbox %lx\n", (u64)acpi_mp_wake_mailbox);
+
+			acpi_mp_wake_mailbox = (void *)mp_wake->base_address;
+			printf("MP Wake (Mailbox version[%d] base_address[%lx])\n",
+					mp_wake->mailbox_version, mp_wake->base_address);
+			break;
+		default:
+			/* Ignored currently */
+			break;
+		}
+		if (!failed)
+			table_start += sub_table->length;
+	}
+
+	return !failed;
+}
+
+bool parse_acpi_table(unsigned char* id_map)
+{
+	struct acpi_table *tb;
+
+	tb = find_acpi_table_addr(MADT_SIGNATURE);
+	if (tb)
+		return parse_madt_table(tb, id_map);
+
+	return false;
+}
diff --git a/lib/acpi.h b/lib/acpi.h
index c330c877..311fbb1b 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -245,9 +245,64 @@ enum acpi_madt_type {
 	ACPI_MADT_TYPE_GENERIC_MSI_FRAME = 13,
 	ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR = 14,
 	ACPI_MADT_TYPE_GENERIC_TRANSLATOR = 15,
-	ACPI_MADT_TYPE_RESERVED = 16	/* 16 and greater are reserved */
+	ACPI_MADT_TYPE_MULTIPROC_WAKEUP = 16,
+	ACPI_MADT_TYPE_RESERVED = 17	/* 17 and greater are reserved */
 };
 
+#define BAD_MADT_ENTRY(entry, end) (                                        \
+		(!entry) || (unsigned long)entry + sizeof(*entry) > end ||  \
+		((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
+
+/*
+ * MADT Subtables, correspond to Type in struct acpi_subtable_header
+ */
+
+/* 0: Processor Local APIC */
+
+struct acpi_madt_local_apic {
+	struct acpi_subtable_header header;
+	u8 processor_id;        /* ACPI processor id */
+	u8 id;                  /* Processor's local APIC id */
+	u32 lapic_flags;
+};
+
+/* 9: Processor Local X2APIC (ACPI 4.0) */
+
+struct acpi_madt_local_x2apic {
+	struct acpi_subtable_header header;
+	u16 reserved;           /* reserved - must be zero */
+	u32 local_apic_id;      /* Processor x2APIC ID  */
+	u32 lapic_flags;
+	u32 uid;                /* ACPI processor UID */
+};
+
+/* 16: Multiprocessor wakeup (ACPI 6.4) */
+
+struct acpi_madt_multiproc_wakeup {
+	struct acpi_subtable_header header;
+	u16 mailbox_version;
+	u32 reserved;		/* reserved - must be zero */
+	u64 base_address;
+};
+
+#define ACPI_MULTIPROC_WAKEUP_MB_OS_SIZE        2032
+#define ACPI_MULTIPROC_WAKEUP_MB_FIRMWARE_SIZE  2048
+
+struct acpi_madt_multiproc_wakeup_mailbox {
+	u16 command;
+	u16 reserved;		/* reserved - must be zero */
+	u32 apic_id;
+	u64 wakeup_vector;
+	u8 reserved_os[ACPI_MULTIPROC_WAKEUP_MB_OS_SIZE];	/* reserved for OS use */
+	u8 reserved_firmware[ACPI_MULTIPROC_WAKEUP_MB_FIRMWARE_SIZE];	/* reserved for firmware use */
+};
+
+#define ACPI_MP_WAKE_COMMAND_WAKEUP	1
+
+/*
+ * Common flags fields for MADT subtables
+ */
+
 /* MADT Local APIC flags */
 #define ACPI_MADT_ENABLED		(1)	/* 00: Processor is usable if set */
 
@@ -298,5 +353,7 @@ struct acpi_table_gtdt {
 void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
 void *find_acpi_table_addr(u32 sig);
 int acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler);
+int acpi_wakeup_cpu(int apicid, unsigned long start_ip, unsigned char* online_cpus);
+bool parse_acpi_table(unsigned char* id_map);
 
 #endif
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 20807700..406d04e3 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -339,6 +339,10 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 		return status;
 	}
 
+	/* Parse all acpi tables, currently only MADT table */
+	if (!parse_acpi_table(id_map))
+		return EFI_NOT_FOUND;
+
 	phase = "AMD SEV";
 	status = setup_amd_sev();
 
-- 
2.25.1


