Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763F465902
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfGKO1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:27:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39134 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728596AbfGKO13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOEWc100497;
        Thu, 11 Jul 2019 14:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=01fwbgJFKdvEoWu4pwKWewOW1PRaOpulx/v99NC5AeE=;
 b=OUZHm+j4S+p6/v1st7v0l2XFGb9Yzt9tSB6OEwidnVH8C7ZbftVmyTxkNolkQOvSzhgY
 cbHKPq4ORwMiLSvoraLOmO32yfqW3gASglaC7FLB9Ef9R707DAjk/G6dzWZVUMkGyvAu
 iay9bQQTO3wg3AefHAS5a13R3q6omWxKLrNSwhL0s5bdk/AqX+ms0qxcg6eBJqXRKS+p
 1w7YM5+MF3gpt84KMBf39eDBip4O9sr14o2Z9tFI78xInQo9JS7l178MkVnONAP6qWu2
 2HBBJ2jtAhFVr8aFlUUKhi4FcgaY2f8JyFXyHWl81HeHbgMzGEK96qXqtVniyPis1l+7 jw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2tjkkq0c5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:25:50 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcts021444;
        Thu, 11 Jul 2019 14:25:47 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 01/26] mm/x86: Introduce kernel address space isolation
Date:   Thu, 11 Jul 2019 16:25:13 +0200
Message-Id: <1562855138-19507-2-git-send-email-alexandre.chartre@oracle.com>
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

Introduce core functions and structures for implementing Address Space
Isolation (ASI). Kernel address space isolation provides the ability to
run some kernel code with a reduced kernel address space.

An address space isolation is defined with a struct asi structure which
has its own page-table. While, for now, this page-table is empty, it
will eventually be possible to populate it so that it is much smaller
than the full kernel page-table.

Isolation is entered by calling asi_enter() which switches the kernel
page-table to the address space isolation page-table. Isolation is then
exited by calling asi_exit() which switches the page-table back to the
kernel page-table.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h |   41 ++++++++++++
 arch/x86/mm/Makefile       |    2 +
 arch/x86/mm/asi.c          |  152 ++++++++++++++++++++++++++++++++++++++++++++
 security/Kconfig           |   10 +++
 4 files changed, 205 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/asi.h
 create mode 100644 arch/x86/mm/asi.c

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
new file mode 100644
index 0000000..8a13f73
--- /dev/null
+++ b/arch/x86/include/asm/asi.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef ARCH_X86_MM_ASI_H
+#define ARCH_X86_MM_ASI_H
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+#include <linux/spinlock.h>
+#include <asm/pgtable.h>
+
+struct asi {
+	spinlock_t		lock;		/* protect all attributes */
+	pgd_t			*pgd;		/* ASI page-table */
+};
+
+/*
+ * An ASI session maintains the state of address state isolation on a
+ * cpu. There is one ASI session per cpu. There is no lock to protect
+ * members of the asi_session structure as each cpu is managing its
+ * own ASI session.
+ */
+
+enum asi_session_state {
+	ASI_SESSION_STATE_INACTIVE,	/* no address space isolation */
+	ASI_SESSION_STATE_ACTIVE,	/* address space isolation is active */
+};
+
+struct asi_session {
+	struct asi		*asi;		/* ASI for this session */
+	enum asi_session_state	state;		/* state of ASI session */
+	unsigned long		original_cr3;	/* cr3 before entering ASI */
+	struct task_struct	*task;		/* task during isolation */
+} __aligned(PAGE_SIZE);
+
+extern struct asi *asi_create(void);
+extern void asi_destroy(struct asi *asi);
+extern int asi_enter(struct asi *asi);
+extern void asi_exit(struct asi *asi);
+
+#endif	/* CONFIG_ADDRESS_SPACE_ISOLATION */
+
+#endif
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 84373dc..dae5c8a 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -49,7 +49,9 @@ obj-$(CONFIG_X86_INTEL_MPX)			+= mpx.o
 obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
 obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
 obj-$(CONFIG_PAGE_TABLE_ISOLATION)		+= pti.o
+obj-$(CONFIG_ADDRESS_SPACE_ISOLATION)		+= asi.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_identity.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
+
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
new file mode 100644
index 0000000..c3993b7
--- /dev/null
+++ b/arch/x86/mm/asi.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
+ *
+ * Kernel Address Space Isolation (ASI)
+ */
+
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/mm.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+
+#include <asm/asi.h>
+#include <asm/bug.h>
+#include <asm/mmu_context.h>
+
+/* ASI sessions, one per cpu */
+DEFINE_PER_CPU_PAGE_ALIGNED(struct asi_session, cpu_asi_session);
+
+static int asi_init_mapping(struct asi *asi)
+{
+	/*
+	 * TODO: Populate the ASI page-table with minimal mappings so
+	 * that we can at least enter isolation and abort.
+	 */
+	return 0;
+}
+
+struct asi *asi_create(void)
+{
+	struct page *page;
+	struct asi *asi;
+	int err;
+
+	asi = kzalloc(sizeof(*asi), GFP_KERNEL);
+	if (!asi)
+		return NULL;
+
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!page)
+		goto error;
+
+	asi->pgd = page_address(page);
+	spin_lock_init(&asi->lock);
+
+	err = asi_init_mapping(asi);
+	if (err)
+		goto error;
+
+	return asi;
+
+error:
+	asi_destroy(asi);
+	return NULL;
+}
+EXPORT_SYMBOL(asi_create);
+
+void asi_destroy(struct asi *asi)
+{
+	if (!asi)
+		return;
+
+	if (asi->pgd)
+		free_page((unsigned long)asi->pgd);
+
+	kfree(asi);
+}
+EXPORT_SYMBOL(asi_destroy);
+
+
+/*
+ * When isolation is active, the address space doesn't necessarily map
+ * the percpu offset value (this_cpu_off) which is used to get pointers
+ * to percpu variables. So functions which can be invoked while isolation
+ * is active shouldn't be getting pointers to percpu variables (i.e. with
+ * get_cpu_var() or this_cpu_ptr()). Instead percpu variable should be
+ * directly read or written to (i.e. with this_cpu_read() or
+ * this_cpu_write()).
+ */
+
+int asi_enter(struct asi *asi)
+{
+	enum asi_session_state state;
+	struct asi *current_asi;
+	struct asi_session *asi_session;
+
+	state = this_cpu_read(cpu_asi_session.state);
+	/*
+	 * We can re-enter isolation, but only with the same ASI (we don't
+	 * support nesting isolation). Also, if isolation is still active,
+	 * then we should be re-entering with the same task.
+	 */
+	if (state == ASI_SESSION_STATE_ACTIVE) {
+		current_asi = this_cpu_read(cpu_asi_session.asi);
+		if (current_asi != asi) {
+			WARN_ON(1);
+			return -EBUSY;
+		}
+		WARN_ON(this_cpu_read(cpu_asi_session.task) != current);
+		return 0;
+	}
+
+	/* isolation is not active so we can safely access the percpu pointer */
+	asi_session = &get_cpu_var(cpu_asi_session);
+	asi_session->asi = asi;
+	asi_session->task = current;
+	asi_session->original_cr3 = __get_current_cr3_fast();
+	if (!asi_session->original_cr3) {
+		WARN_ON(1);
+		err = -EINVAL;
+		goto err_clear_asi;
+	}
+	asi_session->state = ASI_SESSION_STATE_ACTIVE;
+
+	load_cr3(asi->pgd);
+
+	return 0;
+
+err_clear_asi:
+	asi_session->asi = NULL;
+	asi_session->task = NULL;
+
+	return err;
+
+}
+EXPORT_SYMBOL(asi_enter);
+
+void asi_exit(struct asi *asi)
+{
+	struct asi_session *asi_session;
+	enum asi_session_state asi_state;
+	unsigned long original_cr3;
+
+	asi_state = this_cpu_read(cpu_asi_session.state);
+	if (asi_state == ASI_SESSION_STATE_INACTIVE)
+		return;
+
+	/* TODO: Kick sibling hyperthread before switching to kernel cr3 */
+	original_cr3 = this_cpu_read(cpu_asi_session.original_cr3);
+	if (original_cr3)
+		write_cr3(original_cr3);
+
+	/* page-table was switched, we can now access the percpu pointer */
+	asi_session = &get_cpu_var(cpu_asi_session);
+	WARN_ON(asi_session->task != current);
+	asi_session->state = ASI_SESSION_STATE_INACTIVE;
+	asi_session->asi = NULL;
+	asi_session->task = NULL;
+	asi_session->original_cr3 = 0;
+}
+EXPORT_SYMBOL(asi_exit);
diff --git a/security/Kconfig b/security/Kconfig
index 466cc1f..241b9a7 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -65,6 +65,16 @@ config PAGE_TABLE_ISOLATION
 
 	  See Documentation/x86/pti.txt for more details.
 
+config ADDRESS_SPACE_ISOLATION
+	bool "Allow code to run with a reduced kernel address space"
+	default y
+	depends on (X86_64 || X86_PAE) && !UML
+	help
+	   This feature provides the ability to run some kernel code
+	   with a reduced kernel address space. This can be used to
+	   mitigate speculative execution attacks which are able to
+	   leak data between sibling CPU hyper-threads.
+
 config SECURITY_INFINIBAND
 	bool "Infiniband Security Hooks"
 	depends on SECURITY && INFINIBAND
-- 
1.7.1

