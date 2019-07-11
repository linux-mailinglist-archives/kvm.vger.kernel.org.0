Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 227AC65904
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfGKO12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:27:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36792 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728553AbfGKO12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO9M4001474;
        Thu, 11 Jul 2019 14:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=N1S18AguseqvsteFhWr/8Dc0t6ablZh92+dI5Teb2M0=;
 b=aEmCnnwO0ArceoX+05Si1M+AHvh5m5JJ1bSo9UUo9F7KLd7OqzZym5b7ZPYuJjAW3g4s
 Gb7xZ3/STbdj4kYw8hKG/DtOtrLsatWwPXpImxRc8wftUMiHP7PR1oUssKSt8pbPiUFk
 nOqjHRqOXAb4/fQSVgHDj2BF7mvKm78/5UcHY8N02qZKTsjiTAfY8DQq2Lf8iHYOueTq
 x/h6EnEuXbJlxgYKOboLBJWJ/+nQMtliAUEUPoaDXOXG/UfKOlKbOCOAR2+mYE6dul7p
 hiUvWM7MnEfAJk+hfdeMiPyCJVFvALeGy7d/JxN9SdvyplS80ju1Ttaf/csNEpaxSMA5 6Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0dw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:02 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPctu021444;
        Thu, 11 Jul 2019 14:25:53 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 03/26] mm/asi: Handle page fault due to address space isolation
Date:   Thu, 11 Jul 2019 16:25:15 +0200
Message-Id: <1562855138-19507-4-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When address space isolation is active, kernel page faults can occur
because data are not mapped in the ASI page-table. In such a case, log
information about the fault and report the page fault as handled. As
the page fault handler (like any exception handler) aborts isolation
and switch back to the full kernel page-table, the faulty instruction
will be retried using the full kernel address space.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h |    7 ++++
 arch/x86/mm/asi.c          |   68 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault.c        |    7 ++++
 3 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index ff126e1..013d77a 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -9,9 +9,14 @@
 #include <linux/spinlock.h>
 #include <asm/pgtable.h>
 
+#define ASI_FAULT_LOG_SIZE	128
+
 struct asi {
 	spinlock_t		lock;		/* protect all attributes */
 	pgd_t			*pgd;		/* ASI page-table */
+	spinlock_t		fault_lock;	/* protect fault_log */
+	unsigned long		fault_log[ASI_FAULT_LOG_SIZE];
+	bool			fault_stack;	/* display stack of fault? */
 };
 
 /*
@@ -42,6 +47,8 @@ struct asi_session {
 extern void asi_destroy(struct asi *asi);
 extern int asi_enter(struct asi *asi);
 extern void asi_exit(struct asi *asi);
+extern bool asi_fault(struct pt_regs *regs, unsigned long error_code,
+		      unsigned long address);
 
 /*
  * Function to exit the current isolation. This is used to abort isolation
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index fabb923..717160d 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -9,6 +9,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
+#include <linux/sched/debug.h>
 #include <linux/slab.h>
 
 #include <asm/asi.h>
@@ -18,6 +19,72 @@
 /* ASI sessions, one per cpu */
 DEFINE_PER_CPU_PAGE_ALIGNED(struct asi_session, cpu_asi_session);
 
+static void asi_log_fault(struct asi *asi, struct pt_regs *regs,
+			  unsigned long error_code, unsigned long address)
+{
+	int i = 0;
+
+	/*
+	 * Log information about the fault only if this is a fault
+	 * we don't know about yet (and the fault log is not full).
+	 */
+	spin_lock(&asi->fault_lock);
+	for (i = 0; i < ASI_FAULT_LOG_SIZE; i++) {
+		if (asi->fault_log[i] == regs->ip) {
+			spin_unlock(&asi->fault_lock);
+			return;
+		}
+		if (!asi->fault_log[i]) {
+			asi->fault_log[i] = regs->ip;
+			break;
+		}
+	}
+	spin_unlock(&asi->fault_lock);
+
+	if (i >= ASI_FAULT_LOG_SIZE)
+		pr_warn("ASI %p: fault log buffer is full [%d]\n", asi, i);
+
+	pr_info("ASI %p: PF#%d (%ld) at %pS on %px\n", asi, i,
+		error_code, (void *)regs->ip, (void *)address);
+
+	if (asi->fault_stack)
+		show_stack(NULL, (unsigned long *)regs->sp);
+}
+
+bool asi_fault(struct pt_regs *regs, unsigned long error_code,
+	       unsigned long address)
+{
+	struct asi_session *asi_session;
+
+	/*
+	 * If address space isolation was active when the fault occurred
+	 * then the page fault handler has already aborted the isolation
+	 * (exception handlers abort isolation very early) and switched
+	 * CR3 back to its original value.
+	 */
+
+	/*
+	 * If address space isolation is not active, or we have a fault
+	 * after isolation was aborted then this is a regular kernel fault,
+	 * and we don't handle it.
+	 */
+	asi_session = &get_cpu_var(cpu_asi_session);
+	if (asi_session->state == ASI_SESSION_STATE_INACTIVE)
+		return false;
+
+	WARN_ON(asi_session->state != ASI_SESSION_STATE_ABORTED);
+	WARN_ON(asi_session->abort_depth != 1);
+
+	/*
+	 * We have a fault while the cpu is using address space isolation.
+	 * Log the fault and report that we have handled fault. This way,
+	 * the faulty instruction will be retried with no isolation.
+	 *
+	 */
+	asi_log_fault(asi_session->asi, regs, error_code, address);
+	return true;
+}
+
 static int asi_init_mapping(struct asi *asi)
 {
 	/*
@@ -43,6 +110,7 @@ struct asi *asi_create(void)
 
 	asi->pgd = page_address(page);
 	spin_lock_init(&asi->lock);
+	spin_lock_init(&asi->fault_lock);
 
 	err = asi_init_mapping(asi);
 	if (err)
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 46df4c6..a405c43 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -29,6 +29,7 @@
 #include <asm/efi.h>			/* efi_recover_from_page_fault()*/
 #include <asm/desc.h>			/* store_idt(), ...		*/
 #include <asm/cpu_entry_area.h>		/* exception stack		*/
+#include <asm/asi.h>			/* asi_fault()			*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -1252,6 +1253,12 @@ static int fault_in_kernel_space(unsigned long address)
 	 */
 	WARN_ON_ONCE(hw_error_code & X86_PF_PK);
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/* Check if the fault occurs with address space isolation */
+	if (asi_fault(regs, hw_error_code, address))
+		return;
+#endif
+
 	/*
 	 * We can fault-in kernel-space virtual memory on-demand. The
 	 * 'reference' page table is init_mm.pgd.
-- 
1.7.1

