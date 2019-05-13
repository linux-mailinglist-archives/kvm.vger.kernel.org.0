Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A201B8B9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbfEMOle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:41:34 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39128 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729639AbfEMOle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:41:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEdhZb193417;
        Mon, 13 May 2019 14:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=I1kUHuKiSH9QzRVSTdzQMnQ4Y46T3IjTtH8oraLYUKM=;
 b=ajrelu+23EpPoZzOm46NJouVlFfpY/7VuA8j/AA2maWWZv6PEWO74sb0JEOk8WTm7MlX
 zkCzIK+uulNLm3Uc5+fKPE0rSLiDjjJLejX1G+rGS4A2aaX6wwImF2XGsend6ZiCm1fm
 P8RiX9tW+RIc4zR0FuNImR/j0P1fr1IsIkAxcMSKq1XNd8xla45EpEAzSsqq0KaMJbcU
 mGTuD8FX0uYid5B79ED/WxOVxHhFvK/EkRkDNZuXjosZo4JvYLUzGo5D2aW2dE1YBaP0
 wQ7ypO/K2a5rX9NiNfuwOPDx8wO0Hl7bt9/GOcZqO+YBs4IdO/Hb+PDVBfNbd7Ra1TXZ Dw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2sdkwdfm0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:50 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQR022780;
        Mon, 13 May 2019 14:39:47 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 24/27] kvm/isolation: KVM page fault handler
Date:   Mon, 13 May 2019 16:38:32 +0200
Message-Id: <1557758315-12667-25-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM page fault handler handles page fault occurring while using
the KVM address space by switching to the kernel address space and
retrying the access (except if the fault occurs while switching
to the kernel address space). Processing of page faults occurring
while using the kernel address space is unchanged.

Page fault log is cleared when creating a vm so that page fault
information doesn't persist when qemu is stopped and restarted.

The KVM module parameter page_fault_stack can be used to disable
dumping stack trace when a page fault occurs while using the KVM
address space. The fault will still be reported but without the
stack trace.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kernel/dumpstack.c |    1 +
 arch/x86/kvm/isolation.c    |  202 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault.c         |   12 +++
 3 files changed, 215 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 2b58864..aa28763 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -292,6 +292,7 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 
 	show_trace_log_lvl(task, NULL, sp, KERN_DEFAULT);
 }
+EXPORT_SYMBOL(show_stack);
 
 void show_stack_regs(struct pt_regs *regs)
 {
diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index e7979b3..db0a7ce 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/printk.h>
+#include <linux/sched/debug.h>
 #include <linux/slab.h>
 
 #include <asm/cpu_entry_area.h>
@@ -17,6 +18,9 @@
 
 #include "isolation.h"
 
+extern bool (*kvm_page_fault_handler)(struct pt_regs *regs,
+				      unsigned long error_code,
+				      unsigned long address);
 
 enum page_table_level {
 	PGT_LEVEL_PTE,
@@ -91,6 +95,25 @@ struct kvm_range_mapping {
 static LIST_HEAD(kvm_range_mapping_list);
 static DEFINE_MUTEX(kvm_range_mapping_lock);
 
+/*
+ * When a page fault occurs, while running with the KVM address space,
+ * the KVM page fault handler prints information about the fault (in
+ * particular the stack trace), and it switches back to the kernel
+ * address space.
+ *
+ * Information printed by the KVM page fault handler can be used to find
+ * out data not mapped in the KVM address space. Then the KVM address
+ * space can be augmented to include the missing mapping so that we don't
+ * fault at that same place anymore.
+ *
+ * The following variables keep track of page faults occurring while running
+ * with the KVM address space to prevent displaying the same information.
+ */
+
+#define KVM_LAST_FAULT_COUNT	128
+
+static unsigned long kvm_last_fault[KVM_LAST_FAULT_COUNT];
+
 
 struct mm_struct kvm_mm = {
 	.mm_rb			= RB_ROOT,
@@ -126,6 +149,14 @@ static void kvm_clear_mapping(void *ptr, size_t size,
 static bool __read_mostly address_space_isolation;
 module_param(address_space_isolation, bool, 0444);
 
+/*
+ * When set to true, KVM dumps the stack when a page fault occurs while
+ * running with the KVM address space. Otherwise the page fault is still
+ * reported but without the stack trace.
+ */
+static bool __read_mostly page_fault_stack = true;
+module_param(page_fault_stack, bool, 0444);
+
 static struct kvm_range_mapping *kvm_get_range_mapping_locked(void *ptr,
 							      bool *subset)
 {
@@ -1195,6 +1226,173 @@ static void kvm_reset_all_task_mapping(void)
 	mutex_unlock(&kvm_task_mapping_lock);
 }
 
+static int bad_address(void *p)
+{
+	unsigned long dummy;
+
+	return probe_kernel_address((unsigned long *)p, dummy);
+}
+
+static void kvm_dump_pagetable(pgd_t *base, unsigned long address)
+{
+	pgd_t *pgd = base + pgd_index(address);
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pr_info("BASE %px ", base);
+
+	if (bad_address(pgd))
+		goto bad;
+
+	pr_cont("PGD %lx ", pgd_val(*pgd));
+
+	if (!pgd_present(*pgd))
+		goto out;
+
+	p4d = p4d_offset(pgd, address);
+	if (bad_address(p4d))
+		goto bad;
+
+	pr_cont("P4D %lx ", p4d_val(*p4d));
+	if (!p4d_present(*p4d) || p4d_large(*p4d))
+		goto out;
+
+	pud = pud_offset(p4d, address);
+	if (bad_address(pud))
+		goto bad;
+
+	pr_cont("PUD %lx ", pud_val(*pud));
+	if (!pud_present(*pud) || pud_large(*pud))
+		goto out;
+
+	pmd = pmd_offset(pud, address);
+	if (bad_address(pmd))
+		goto bad;
+
+	pr_cont("PMD %lx ", pmd_val(*pmd));
+	if (!pmd_present(*pmd) || pmd_large(*pmd))
+		goto out;
+
+	pte = pte_offset_kernel(pmd, address);
+	if (bad_address(pte))
+		goto bad;
+
+	pr_cont("PTE %lx", pte_val(*pte));
+out:
+	pr_cont("\n");
+	return;
+bad:
+	pr_info("BAD\n");
+}
+
+static void kvm_clear_page_fault(void)
+{
+	int i;
+
+	for (i = 0; i < KVM_LAST_FAULT_COUNT; i++)
+		kvm_last_fault[i] = 0;
+}
+
+static void kvm_log_page_fault(struct pt_regs *regs, unsigned long error_code,
+			       unsigned long address)
+{
+	int i;
+
+	/*
+	 * Log information about the fault only if this is a fault
+	 * we don't know about yet (or if the fault tracking buffer
+	 * is full).
+	 */
+	for (i = 0; i < KVM_LAST_FAULT_COUNT; i++) {
+		if (!kvm_last_fault[i]) {
+			kvm_last_fault[i] = regs->ip;
+			break;
+		}
+		if (kvm_last_fault[i] == regs->ip)
+			return;
+	}
+
+	if (i >= KVM_LAST_FAULT_COUNT)
+		pr_warn("KVM isolation: fault tracking buffer is full [%d]\n",
+			i);
+
+	pr_info("KVM isolation: page fault #%d (%ld) at %pS on %px (%pS)\n",
+		i, error_code, (void *)regs->ip,
+		(void *)address, (void *)address);
+	if (page_fault_stack)
+		show_stack(NULL, (unsigned long *)regs->sp);
+}
+
+/*
+ * KVM Page Fault Handler. The handler handles two simple cases:
+ *
+ * - If the fault occurs while using the kernel address space, then let
+ *   the kernel handles the fault normally.
+ *
+ * - If the fault occurs while using the KVM address space, then switch
+ *   to the kernel address space, and retry.
+ *
+ * It also handles a tricky case: if the fault occurs when using the KVM
+ * address space but while switching to the kernel address space then the
+ * switch is failing and we can't recover. In that case, we force switching
+ * to the kernel address space, print information and let the kernel
+ * handles the fault.
+ */
+static bool kvm_page_fault(struct pt_regs *regs, unsigned long error_code,
+			   unsigned long address)
+{
+	struct mm_struct *active_mm = current->active_mm;
+	unsigned long cr3;
+
+	/*
+	 * First, do a quick and simple test to see if we are using
+	 * the KVM address space. If we do then exit KVM isolation,
+	 * log the fault and report that we have handled the fault.
+	 */
+	if (likely(active_mm == &kvm_mm)) {
+		kvm_isolation_exit();
+		kvm_log_page_fault(regs, error_code, address);
+		return true;
+	}
+
+	/*
+	 * Verify that we are effectively using the kernel address space.
+	 * When switching address space, active_mm is not necessarily up
+	 * to date as it can already be set with the next mm while %cr3
+	 * has not been updated yet. So check loaded_mm which is updated
+	 * after %cr3.
+	 *
+	 * If we are effectively using the kernel address space then report
+	 * that we haven't handled the fault.
+	 */
+	if (this_cpu_read(cpu_tlbstate.loaded_mm) != &kvm_mm)
+		return false;
+
+	/*
+	 * We are actually using the KVM address space and faulting while
+	 * switching address space. Force swiching to the kernel address
+	 * space, log information and reported that we haven't handled
+	 * the fault.
+	 */
+	cr3 = __read_cr3();
+	write_cr3(build_cr3(active_mm->pgd, 0));
+	kvm_dump_pagetable(kvm_mm.pgd, address);
+	kvm_dump_pagetable(active_mm->pgd, address);
+	printk(KERN_DEFAULT "KVM isolation: page fault %ld at %pS on %lx (%pS) while switching mm\n"
+	       "  cr3=%lx\n"
+	       "  kvm_mm=%px pgd=%px\n"
+	       "  active_mm=%px pgd=%px\n",
+	       error_code, (void *)regs->ip, address, (void *)address,
+	       cr3,
+	       &kvm_mm, kvm_mm.pgd,
+	       active_mm, active_mm->pgd);
+	dump_stack();
+
+	return false;
+}
+
 
 static int kvm_isolation_init_page_table(void)
 {
@@ -1384,11 +1582,13 @@ static void kvm_isolation_uninit_mm(void)
 static void kvm_isolation_set_handlers(void)
 {
 	kvm_set_isolation_exit_handler(kvm_isolation_exit);
+	kvm_page_fault_handler = kvm_page_fault;
 }
 
 static void kvm_isolation_clear_handlers(void)
 {
 	kvm_set_isolation_exit_handler(NULL);
+	kvm_page_fault_handler = NULL;
 }
 
 int kvm_isolation_init_vm(struct kvm *kvm)
@@ -1396,6 +1596,8 @@ int kvm_isolation_init_vm(struct kvm *kvm)
 	if (!kvm_isolation())
 		return 0;
 
+	kvm_clear_page_fault();
+
 	pr_debug("mapping kvm srcu sda\n");
 
 	return (kvm_copy_percpu_mapping(kvm->srcu.sda,
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 46df4c6..317e105 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,10 @@
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
 
+bool (*kvm_page_fault_handler)(struct pt_regs *regs, unsigned long error_code,
+			       unsigned long address);
+EXPORT_SYMBOL(kvm_page_fault_handler);
+
 /*
  * Returns 0 if mmiotrace is disabled, or if the fault is not
  * handled by mmiotrace:
@@ -1253,6 +1257,14 @@ static int fault_in_kernel_space(unsigned long address)
 	WARN_ON_ONCE(hw_error_code & X86_PF_PK);
 
 	/*
+	 * KVM might be able to handle the fault when running with the
+	 * KVM address space.
+	 */
+	if (kvm_page_fault_handler &&
+	    kvm_page_fault_handler(regs, hw_error_code, address))
+		return;
+
+	/*
 	 * We can fault-in kernel-space virtual memory on-demand. The
 	 * 'reference' page table is init_mm.pgd.
 	 *
-- 
1.7.1

