Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B9F65900
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfGKOaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:30:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36882 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbfGKO1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOgjM001960;
        Thu, 11 Jul 2019 14:26:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=SJbrUhc02AgBQXRxdyh8NMsUj+oqXOnPmIbZ5Fc5Oh8=;
 b=xzFz4q2m+w7TU5mOs3ALiXB2uWjQppudBO654kJwJ3xcjzMIDadZ8a8b6jz4YyHWy1y3
 WQjbtVLYHkN/sQca6bf2zIB7mNhCTUasiGxRSTnzAv+FRaXEzVfw9Y+TtQO4hmByjCup
 HS11ZsQytlUEzwToD8/1Qka8/FUyswUFS6tpdq5B5ty/H9uU9+lZ/iY44X92sv0bKyZR
 FyCRbHGO9wKQsS+KaiSfk6fjhgaVbgZ3csy84EpWlVvgjG8YbMp2E1bRONCx7joKhrFT
 fgbFCcCBEHZLg4ujshUEkzIPwKG7zacpaOBPeP/3uweuUnh4D/616+hC65KocGucwirZ aQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0dw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:00 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPctv021444;
        Thu, 11 Jul 2019 14:25:56 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 04/26] mm/asi: Functions to track buffers allocated for an ASI page-table
Date:   Thu, 11 Jul 2019 16:25:16 +0200
Message-Id: <1562855138-19507-5-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add functions to track buffers allocated for an ASI page-table. An ASI
page-table can have direct references to the kernel page table, at
different levels (PGD, P4D, PUD, PMD). When freeing an ASI page-table,
we should make sure that we free parts actually allocated for the ASI
page-table, and not parts of the kernel page table referenced from the
ASI page-table. To do so, we will keep track of buffers when building
the ASI page-table.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h  |   26 +++++++++++
 arch/x86/mm/Makefile        |    2 +-
 arch/x86/mm/asi.c           |    3 +
 arch/x86/mm/asi_pagetable.c |   99 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/mm/asi_pagetable.c

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 013d77a..3d965e6 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -8,12 +8,35 @@
 
 #include <linux/spinlock.h>
 #include <asm/pgtable.h>
+#include <linux/xarray.h>
+
+enum page_table_level {
+	PGT_LEVEL_PTE,
+	PGT_LEVEL_PMD,
+	PGT_LEVEL_PUD,
+	PGT_LEVEL_P4D,
+	PGT_LEVEL_PGD
+};
 
 #define ASI_FAULT_LOG_SIZE	128
 
 struct asi {
 	spinlock_t		lock;		/* protect all attributes */
 	pgd_t			*pgd;		/* ASI page-table */
+
+	/*
+	 * An ASI page-table can have direct references to the full kernel
+	 * page-table, at different levels (PGD, P4D, PUD, PMD). When freeing
+	 * an ASI page-table, we should make sure that we free parts actually
+	 * allocated for the ASI page-table, and not part of the full kernel
+	 * page-table referenced from the ASI page-table.
+	 *
+	 * To do so, the backend_pages XArray is used to keep track of pages
+	 * used for the kernel isolation page-table.
+	 */
+	struct xarray		backend_pages;		/* page-table pages */
+	unsigned long		backend_pages_count;	/* pages count */
+
 	spinlock_t		fault_lock;	/* protect fault_log */
 	unsigned long		fault_log[ASI_FAULT_LOG_SIZE];
 	bool			fault_stack;	/* display stack of fault? */
@@ -43,6 +66,9 @@ struct asi_session {
 
 DECLARE_PER_CPU_PAGE_ALIGNED(struct asi_session, cpu_asi_session);
 
+void asi_init_backend(struct asi *asi);
+void asi_fini_backend(struct asi *asi);
+
 extern struct asi *asi_create(void);
 extern void asi_destroy(struct asi *asi);
 extern int asi_enter(struct asi *asi);
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index dae5c8a..b972f0f 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -49,7 +49,7 @@ obj-$(CONFIG_X86_INTEL_MPX)			+= mpx.o
 obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
 obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
 obj-$(CONFIG_PAGE_TABLE_ISOLATION)		+= pti.o
-obj-$(CONFIG_ADDRESS_SPACE_ISOLATION)		+= asi.o
+obj-$(CONFIG_ADDRESS_SPACE_ISOLATION)		+= asi.o asi_pagetable.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_identity.o
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 717160d..dfde245 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -111,6 +111,7 @@ struct asi *asi_create(void)
 	asi->pgd = page_address(page);
 	spin_lock_init(&asi->lock);
 	spin_lock_init(&asi->fault_lock);
+	asi_init_backend(asi);
 
 	err = asi_init_mapping(asi);
 	if (err)
@@ -132,6 +133,8 @@ void asi_destroy(struct asi *asi)
 	if (asi->pgd)
 		free_page((unsigned long)asi->pgd);
 
+	asi_fini_backend(asi);
+
 	kfree(asi);
 }
 EXPORT_SYMBOL(asi_destroy);
diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
new file mode 100644
index 0000000..7a8f791
--- /dev/null
+++ b/arch/x86/mm/asi_pagetable.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ *
+ */
+
+#include <asm/asi.h>
+
+/*
+ * Get the pointer to the beginning of a page table directory from a page
+ * table directory entry.
+ */
+#define ASI_BACKEND_PAGE_ALIGN(entry)	\
+	((typeof(entry))(((unsigned long)(entry)) & PAGE_MASK))
+
+/*
+ * Pages used to build the address space isolation page-table are stored
+ * in the backend_pages XArray. Each entry in the array is a logical OR
+ * of the page address and the page table level (PTE, PMD, PUD, P4D) this
+ * page is used for in the address space isolation page-table.
+ *
+ * As a page address is aligned with PAGE_SIZE, we have plenty of space
+ * for storing the page table level (which is a value between 0 and 4) in
+ * the low bits of the page address.
+ *
+ */
+
+#define ASI_BACKEND_PAGE_ENTRY(addr, level)	\
+	((typeof(addr))(((unsigned long)(addr)) | ((unsigned long)(level))))
+#define ASI_BACKEND_PAGE_ADDR(entry)		\
+	((void *)(((unsigned long)(entry)) & PAGE_MASK))
+#define ASI_BACKEND_PAGE_LEVEL(entry)		\
+	((enum page_table_level)(((unsigned long)(entry)) & ~PAGE_MASK))
+
+static int asi_add_backend_page(struct asi *asi, void *addr,
+				enum page_table_level level)
+{
+	unsigned long index;
+	void *old_entry;
+
+	if ((!addr) || ((unsigned long)addr) & ~PAGE_MASK)
+		return -EINVAL;
+
+	lockdep_assert_held(&asi->lock);
+	index = asi->backend_pages_count;
+
+	old_entry = xa_store(&asi->backend_pages, index,
+			     ASI_BACKEND_PAGE_ENTRY(addr, level),
+			     GFP_KERNEL);
+	if (xa_is_err(old_entry))
+		return xa_err(old_entry);
+	if (old_entry)
+		return -EBUSY;
+
+	asi->backend_pages_count++;
+
+	return 0;
+}
+
+void asi_init_backend(struct asi *asi)
+{
+	xa_init(&asi->backend_pages);
+}
+
+void asi_fini_backend(struct asi *asi)
+{
+	unsigned long index;
+	void *entry;
+
+	if (asi->backend_pages_count) {
+		xa_for_each(&asi->backend_pages, index, entry)
+			free_page((unsigned long)ASI_BACKEND_PAGE_ADDR(entry));
+	}
+}
+
+/*
+ * Check if an offset in the address space isolation page-table is valid,
+ * i.e. check that the offset is on a page effectively belonging to the
+ * address space isolation page-table.
+ */
+static bool asi_valid_offset(struct asi *asi, void *offset)
+{
+	unsigned long index;
+	void *addr, *entry;
+	bool valid;
+
+	addr = ASI_BACKEND_PAGE_ALIGN(offset);
+	valid = false;
+
+	lockdep_assert_held(&asi->lock);
+	xa_for_each(&asi->backend_pages, index, entry) {
+		if (ASI_BACKEND_PAGE_ADDR(entry) == addr) {
+			valid = true;
+			break;
+		}
+	}
+
+	return valid;
+}
-- 
1.7.1

