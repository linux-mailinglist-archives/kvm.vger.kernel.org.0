Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECD51A1B4A
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgDHFF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:05:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgDHFFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03854CmS180113;
        Wed, 8 Apr 2020 05:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=7QyLiBCO3vyvqJ8QQH0U81XYGVivm5nwHGLYsFlNJAo=;
 b=AvHVQP9qtew1hsN6EtCaOeF520A4+Z8TUiZF8HI5faa0Jz1VTdsvMiJby5SU8RUz1GIi
 Rg7/4ShQivVruZUqr7xq5Zo5D65mgdKB0GzTlFD1YqCjZqnXWqZVYy6AbPPQA8DcQ9w6
 nb8znQ4P7Cgfx/4eWvv5Co9yR3rhKguPsyGKTvdcq+RXTH7hGYWKx4rlfUfNxTY2kMyp
 jH65pvII+gGiUkKYMJUofuBTG0cihFr4kMmZSaPbLnay6cPDpOUebP8eRjiWZ18zM8Do
 sJDeBhv3oYGnjqdviRm8ykKGhEvBOZE88dP/yx/gC9JPyQDY4ir2oY0TfZnbZUoc8nA/ Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3091mnh150-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03852X3K062284;
        Wed, 8 Apr 2020 05:05:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3091mh1kvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:29 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03855SHY007473;
        Wed, 8 Apr 2020 05:05:28 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:27 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 21/26] x86/alternatives: Paravirt runtime selftest
Date:   Tue,  7 Apr 2020 22:03:18 -0700
Message-Id: <20200408050323.4237-22-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest that triggers paravirt_runtime_patch() which
toggles between the paravirt and native pv_lock_ops.

The selftest also register an NMI handler, which exercises the
patched pv-ops by spin-lock operations. These are triggered via
artificially sent NMIs.

And last, introduce patch sites in the primary and secondary
patching code which are hit while during the patching process.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/Kconfig.debug        |  13 ++
 arch/x86/kernel/Makefile      |   1 +
 arch/x86/kernel/alternative.c |  20 +++
 arch/x86/kernel/kvm.c         |   4 +-
 arch/x86/kernel/pv_selftest.c | 264 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pv_selftest.h |  15 ++
 6 files changed, 315 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kernel/pv_selftest.c
 create mode 100644 arch/x86/kernel/pv_selftest.h

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 2e74690b028a..82a8e3fa68c7 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -252,6 +252,19 @@ config X86_DEBUG_FPU
 
 	  If unsure, say N.
 
+config DEBUG_PARAVIRT_SELFTEST
+	bool "Enable paravirt runtime selftest"
+	depends on PARAVIRT
+	depends on PARAVIRT_RUNTIME
+	depends on PARAVIRT_SPINLOCKS
+	depends on KVM_GUEST
+	help
+	  This option enables sanity testing of the runtime paravirtualized
+	  patching code. Triggered via debugfs.
+
+	  Might help diagnose patching problems in different
+	  configurations and loads.
+
 config PUNIT_ATOM_DEBUG
 	tristate "ATOM Punit debug driver"
 	depends on PCI
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index ba89cabe5fcf..ed3c93681f12 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -114,6 +114,7 @@ obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
 
 obj-$(CONFIG_AMD_NB)		+= amd_nb.o
 obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
+obj-$(CONFIG_DEBUG_PARAVIRT_SELFTEST) += pv_selftest.o
 
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch.o
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 385c3e6ea925..26407d7a54db 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -26,6 +26,7 @@
 #include <asm/insn.h>
 #include <asm/io.h>
 #include <asm/fixmap.h>
+#include "pv_selftest.h"
 
 int __read_mostly alternatives_patched;
 
@@ -1549,6 +1550,12 @@ static void __maybe_unused text_poke_site(struct text_poke_state *tps,
 	 */
 	poke_sync(tps, PATCH_SYNC_0, offset, &int3, INT3_INSN_SIZE);
 
+	/*
+	 * We have an INT3 in place; execute a contrived selftest that
+	 * has an insn sequence that is under patching.
+	 */
+	pv_selftest_primary();
+
 	/* Poke remaining */
 	poke_sync(tps, PATCH_SYNC_1, offset + INT3_INSN_SIZE,
 		  tp->text + INT3_INSN_SIZE, tp->native.len - INT3_INSN_SIZE);
@@ -1634,6 +1641,19 @@ static void text_poke_sync_site(struct text_poke_state *tps)
 		smp_cond_load_acquire(&tps->state,
 				      prevstate != VAL);
 
+		/*
+		 * Send an NMI to one of the other CPUs.
+		 */
+		pv_selftest_send_nmi();
+
+		/*
+		 * We have an INT3 in place; execute a contrived selftest that
+		 * has an insn sequence that is under patching.
+		 *
+		 * Note that this function is also called from BP fixup but
+		 * is just an NOP when called from there.
+		 */
+		pv_selftest_secondary();
 		prevstate = READ_ONCE(tps->state);
 
 		/*
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6efe0410fb72..e56d263159d7 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -779,7 +779,7 @@ arch_initcall(kvm_alloc_cpumask);
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
 /* Kick a cpu by its apicid. Used to wake up a halted vcpu */
-static void kvm_kick_cpu(int cpu)
+void kvm_kick_cpu(int cpu)
 {
 	int apicid;
 	unsigned long flags = 0;
@@ -790,7 +790,7 @@ static void kvm_kick_cpu(int cpu)
 
 #include <asm/qspinlock.h>
 
-static void kvm_wait(u8 *ptr, u8 val)
+void kvm_wait(u8 *ptr, u8 val)
 {
 	unsigned long flags;
 
diff --git a/arch/x86/kernel/pv_selftest.c b/arch/x86/kernel/pv_selftest.c
new file mode 100644
index 000000000000..e522f444bd6e
--- /dev/null
+++ b/arch/x86/kernel/pv_selftest.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/memory.h>
+#include <linux/nmi.h>
+#include <linux/uaccess.h>
+#include <asm/apic.h>
+#include <asm/text-patching.h>
+#include <asm/paravirt.h>
+#include <asm/paravirt_types.h>
+#include "pv_selftest.h"
+
+static int nmi_selftest;
+static bool cond_state;
+
+#define SELFTEST_PARAVIRT	1
+static int test_mode;
+
+/*
+ * Mark this and the following functions __always_inline to ensure
+ * we generate multiple patch sites that can be hit independently
+ * in thread, NMI etc contexts.
+ */
+static __always_inline void selftest_pv(void)
+{
+	struct qspinlock test;
+
+	memset(&test, 0, sizeof(test));
+
+	test.locked = _Q_LOCKED_VAL;
+
+	/*
+	 * Sits directly in the path of the test.
+	 *
+	 * The primary sets up an INT3 instruction at pv_queued_spin_unlock().
+	 * Both the primary and secondary CPUs should hit that in both
+	 * thread and NMI contexts.
+	 *
+	 * Additionally, this also gets inlined in nmi_pv_callback() so we
+	 * should hit this with nmi_selftest.
+	 *
+	 * The fixup takes place in poke_int3_native().
+	 */
+	pv_queued_spin_unlock(&test);
+}
+
+static __always_inline void patch_selftest(void)
+{
+	if (test_mode == SELFTEST_PARAVIRT)
+		selftest_pv();
+}
+
+static DEFINE_PER_CPU(int, selftest_count);
+void pv_selftest_secondary(void)
+{
+	/*
+	 * On the secondary we execute the same code in both the
+	 * thread-context and the BP-context and so would hit this
+	 * recursively if we do inside the fixup context.
+	 *
+	 * So we trigger the selftest only if it's not ongoing already
+	 * (thus allowing the thread or NMI context, but excluding
+	 * the INT3 handling path.)
+	 */
+	if (this_cpu_read(selftest_count))
+		return;
+
+	this_cpu_inc(selftest_count);
+
+	patch_selftest();
+
+	this_cpu_dec(selftest_count);
+}
+
+void pv_selftest_primary(void)
+{
+	patch_selftest();
+}
+
+/*
+ * We only come here if nmi_selftest > 0.
+ *  - nmi_selftest >= 1: execute a pv-op that will be patched
+ *  - nmi_selftest >= 2: execute a paired pv-op that is also contended
+ *  - nmi_selftest >= 3: add lock contention
+ */
+static int nmi_callback(unsigned int val, struct pt_regs *regs)
+{
+	static DEFINE_SPINLOCK(nmi_spin);
+
+	if (!nmi_selftest)
+		goto out;
+
+	patch_selftest();
+
+	if (nmi_selftest >= 2) {
+		/*
+		 * Depending on whether CONFIG_[UN]INLINE_SPIN_* are
+		 * defined or not, these would get patched or just
+		 * create race conditions between via NMIs.
+		 */
+		spin_lock(&nmi_spin);
+
+		/* Dilate the critical section to force contention. */
+		if (nmi_selftest >= 3)
+			udelay(1);
+
+		spin_unlock(&nmi_spin);
+	}
+
+	/*
+	 * nmi_selftest > 0, but we should really have a bitmap where
+	 * to check if this really was destined for us or not.
+	 */
+	return NMI_HANDLED;
+out:
+	return NMI_DONE;
+}
+
+void pv_selftest_register(void)
+{
+	register_nmi_handler(NMI_LOCAL, nmi_callback,
+			     0, "paravirt_nmi_selftest");
+}
+
+void pv_selftest_unregister(void)
+{
+	unregister_nmi_handler(NMI_LOCAL, "paravirt_nmi_selftest");
+}
+
+void pv_selftest_send_nmi(void)
+{
+	int cpu = smp_processor_id();
+	/* NMI or INT3 */
+	if (nmi_selftest && !in_interrupt())
+		apic->send_IPI(cpu + 1 % num_online_cpus(), NMI_VECTOR);
+}
+
+/*
+ * Just declare these locally here instead of having them be
+ * exposed to the whole world.
+ */
+void kvm_wait(u8 *ptr, u8 val);
+void kvm_kick_cpu(int cpu);
+bool __raw_callee_save___kvm_vcpu_is_preempted(long cpu);
+static void pv_spinlocks(void)
+{
+	paravirt_stage_alt(cond_state,
+			   lock.queued_spin_lock_slowpath,
+			   __pv_queued_spin_lock_slowpath);
+	paravirt_stage_alt(cond_state, lock.queued_spin_unlock.func,
+			   PV_CALLEE_SAVE(__pv_queued_spin_unlock).func);
+	paravirt_stage_alt(cond_state, lock.wait, kvm_wait);
+	paravirt_stage_alt(cond_state, lock.kick, kvm_kick_cpu);
+
+	paravirt_stage_alt(cond_state,
+			   lock.vcpu_is_preempted.func,
+			   PV_CALLEE_SAVE(__kvm_vcpu_is_preempted).func);
+}
+
+void pv_trigger(void)
+{
+	bool nmi_mode = nmi_selftest ? true : false;
+	int ret;
+
+	pr_debug("%s: nmi=%d; NMI-mode=%d\n", __func__, nmi_selftest, nmi_mode);
+
+	mutex_lock(&text_mutex);
+
+	paravirt_stage_zero();
+	pv_spinlocks();
+
+	/*
+	 * paravirt patching for pv_locks can potentially deadlock
+	 * if we are running with nmi_mode=false and we get an NMI.
+	 *
+	 * For the sake of testing that path, we risk it. However, if
+	 * we are generating synthetic NMIs (nmi_selftest > 0) then
+	 * run with nmi_mode=true.
+	 */
+	ret = paravirt_runtime_patch(nmi_mode);
+
+	/*
+	 * Flip the state so we switch the pv_lock_ops on the next test.
+	 */
+	cond_state = !cond_state;
+
+	mutex_unlock(&text_mutex);
+
+	pr_debug("%s: nmi=%d; NMI-mode=%d, ret=%d\n", __func__, nmi_selftest,
+		 nmi_mode, ret);
+}
+
+static void pv_selftest_trigger(void)
+{
+	test_mode = SELFTEST_PARAVIRT;
+	pv_trigger();
+}
+
+static ssize_t pv_selftest_write(struct file *file, const char __user *ubuf,
+				 size_t count, loff_t *ppos)
+{
+	pv_selftest_register();
+	pv_selftest_trigger();
+	pv_selftest_unregister();
+
+	return count;
+}
+
+static ssize_t pv_nmi_read(struct file *file, char __user *ubuf,
+			   size_t count, loff_t *ppos)
+{
+	char buf[32];
+	unsigned int len;
+
+	len = snprintf(buf, sizeof(buf), "%d\n", nmi_selftest);
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static ssize_t pv_nmi_write(struct file *file, const char __user *ubuf,
+			    size_t count, loff_t *ppos)
+{
+	char buf[32];
+	unsigned int len;
+	unsigned int enabled;
+
+	len = min(sizeof(buf) - 1, count);
+	if (copy_from_user(buf, ubuf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoint(buf, 0, &enabled))
+		return -EINVAL;
+
+	nmi_selftest = enabled > 3 ? 3 : enabled;
+
+	return count;
+}
+
+static const struct file_operations pv_selftest_fops = {
+	.read = NULL,
+	.write = pv_selftest_write,
+	.llseek = default_llseek,
+};
+
+static const struct file_operations pv_nmi_fops = {
+	.read = pv_nmi_read,
+	.write = pv_nmi_write,
+	.llseek = default_llseek,
+};
+
+static int __init pv_selftest_init(void)
+{
+	struct dentry *d = debugfs_create_dir("pv_selftest", NULL);
+
+	debugfs_create_file("toggle", 0600, d, NULL, &pv_selftest_fops);
+	debugfs_create_file("nmi", 0600, d, NULL, &pv_nmi_fops);
+
+	return 0;
+}
+
+late_initcall(pv_selftest_init);
diff --git a/arch/x86/kernel/pv_selftest.h b/arch/x86/kernel/pv_selftest.h
new file mode 100644
index 000000000000..5afa0f7db5cc
--- /dev/null
+++ b/arch/x86/kernel/pv_selftest.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _PVR_SELFTEST_H
+#define _PVR_SELFTEST_H
+
+#ifdef CONFIG_DEBUG_PARAVIRT_SELFTEST
+void pv_selftest_send_nmi(void);
+void pv_selftest_primary(void);
+void pv_selftest_secondary(void);
+#else
+static inline void pv_selftest_send_nmi(void) { }
+static inline void pv_selftest_primary(void) { }
+static inline void pv_selftest_secondary(void) { }
+#endif /*! CONFIG_DEBUG_PARAVIRT_SELFTEST */
+
+#endif /* _PVR_SELFTEST_H */
-- 
2.20.1

