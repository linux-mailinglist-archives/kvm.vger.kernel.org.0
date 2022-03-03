Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFB64CB7C9
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiCCH26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiCCH2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:42 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AEB1B7A9
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292463; x=1677828463;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aUWllZgcNcb3+4EQxRve/ekcY65dBqxxATMgqK0CxdU=;
  b=aXFJl4GROAczQdPmdUPEVWQm2fHgmKkpg/H+KQWocw0qn03qE0dnHQDv
   vqQXcDQxMvRaj82Xp8kJmjjO7fQGEd4aVZ4c+qF/SFuVFOYMSgZ7PKmrQ
   gkoHvv/1D39DbaND4fHnWMqq76fuUu63Nva6z7rMki5g5Qb132bwIHVIC
   BmwmMAxQKzW6BDB105zn1iLWkjtyfwxHJPz1BRDB9sCPWkFPI5412MmH1
   rSKaxp/BMx25yLeTWYLcH3Zs02EuiRVt5cGBpr1h+FlDdes9yGDXPdifp
   PQrTFNE7NReOocP3Z+FsKf6woyx6eXcj8VRSuBWCzsBT+w/vtYtjn+mTP
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251176987"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251176987"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:41 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631676"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:39 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 09/17] acpi: Add MADT table parse code
Date:   Thu,  3 Mar 2022 15:18:59 +0800
Message-Id: <20220303071907.650203-10-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support LAPIC, X2APIC and WAKEUP sub-table, other sub-table are ignored
for now. Also add a wakeup wrapping function which is used by TDX.

The parsed result is stored in id_map[] and acpi_mp_wake_mailbox.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/acpi.c  | 171 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/acpi.h  |  85 ++++++++++++++++++++++++
 lib/x86/setup.c |   4 ++
 3 files changed, 260 insertions(+)

diff --git a/lib/x86/acpi.c b/lib/x86/acpi.c
index 1a82ced0b90f..6fb8ece7eabe 100644
--- a/lib/x86/acpi.c
+++ b/lib/x86/acpi.c
@@ -1,7 +1,12 @@
 #include "libcflat.h"
+#include "errno.h"
 #include "acpi.h"
+#include "apic.h"
+#include "asm/barrier.h"
+#include "processor.h"
 
 #ifdef TARGET_EFI
+unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
 struct rsdp_descriptor *efi_rsdp = NULL;
 
 void set_efi_rsdp(struct rsdp_descriptor *rsdp)
@@ -16,6 +21,172 @@ static struct rsdp_descriptor *get_rsdp(void)
 	}
 	return efi_rsdp;
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
+int acpi_wakeup_cpu(int apicid, unsigned long start_ip)
+{
+	u8 timeout = 0xFF;
+
+	/*
+	 * According to the ACPI specification r6.4, sec 5.2.12.19, the
+	 * mailbox-based wakeup mechanism cannot be used more than once
+	 * for the same CPU, so skip sending wake commands to already
+	 * awake CPU.
+	 */
+	if (test_bit(apicid, online_cpus)) {
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
+	if (timeout) {
+		/*
+		 * If the CPU wakeup process is successful, store the
+		 * status in online_cpus to prevent re-wakeup
+		 * requests.
+		 */
+		set_bit(apicid, online_cpus);
+		return 0;
+	}
+
+	/* If timed out (timeout == 0), return error */
+	return -EIO;
+}
+
+static bool parse_madt_table(struct acpi_table *madt)
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
+bool parse_acpi_table(void)
+{
+	struct acpi_table *tb;
+
+	tb = find_acpi_table_addr(MADT_SIGNATURE);
+	if (tb)
+		return parse_madt_table(tb);
+
+	return false;
+}
 #else
 static struct rsdp_descriptor *get_rsdp(void)
 {
diff --git a/lib/x86/acpi.h b/lib/x86/acpi.h
index 67ba3899b1d7..509d9b5bb0b4 100644
--- a/lib/x86/acpi.h
+++ b/lib/x86/acpi.h
@@ -10,6 +10,7 @@
 #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
+#define MADT_SIGNATURE ACPI_SIGNATURE('A','P','I','C')
 
 
 #define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
@@ -46,6 +47,88 @@ struct acpi_table {
     char data[0];
 };
 
+/*******************************************************************************
+ *
+ * MADT - Multiple APIC Description Table
+ *        Version 3
+ *
+ ******************************************************************************/
+
+struct acpi_table_madt {
+	ACPI_TABLE_HEADER_DEF
+	u32 address;            /* Physical address of local APIC */
+	u32 flags;
+};
+
+/* Generic subtable header (used in MADT, SRAT, etc.) */
+
+struct acpi_subtable_header {
+	u8 type;
+	u8 length;
+};
+
+#define ACPI_MADT_TYPE_LOCAL_APIC	0
+#define ACPI_MADT_TYPE_LOCAL_X2APIC	9
+#define ACPI_MADT_TYPE_MULTIPROC_WAKEUP	16
+
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
+/* MADT Local APIC flags */
+
+#define ACPI_MADT_ENABLED		(1) /* 00: Processor is usable if set */
+
 struct rsdt_descriptor_rev1 {
     ACPI_TABLE_HEADER_DEF
     u32 table_offset_entry[0];
@@ -108,5 +191,7 @@ struct facs_descriptor_rev1
 
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
 void* find_acpi_table_addr(u32 sig);
+int acpi_wakeup_cpu(int apicid, unsigned long start_ip);
+bool parse_acpi_table(void);
 
 #endif
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 29202478ae0d..63c4dbb25064 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -314,6 +314,10 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 		return status;
 	}
 
+	/* Parse all acpi tables, currently only MADT table */
+	if (!parse_acpi_table())
+		return EFI_NOT_FOUND;
+
 	phase = "AMD SEV";
 	status = setup_amd_sev();
 
-- 
2.25.1

