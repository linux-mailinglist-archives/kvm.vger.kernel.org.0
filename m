Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D66658F5
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfGKO2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39866 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbfGKO2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOGvV100511;
        Thu, 11 Jul 2019 14:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=eEi0ZTZbIEZ47JResTnFegGOS+nY5vwRKMSKjoZA8rw=;
 b=doVQHd64if/2kjiu3iJcq23b/ysNGaO3zFQ1Fbt9B8gbpk5AqZTdAGLfrkqQEQ1t29L7
 vIj+rjQt4iariplk3zmGOGhNmniQGZlOnZRXIEVu/XP2NILI1mTBKcs9y9sxpXNe7zLm
 WTpN/PNi/5Jc1UHjSLknTN0GAMM8aeWagwwQaQOKeG6DbEY5KTVF1BDM73GoF0OnyPfM
 bujoi6mhv9a226crDPB4jhcZ5qwIaENDIb5Eyq65a1CYJBrVBQCE3nFbdPTH6gGouBW2
 4zVkdrvRe3v52Mrj+Eaw7ZDk5eDA1G0rOGRsj+izv+9ASQxDllLZRPrfz0ej8u3KokCM vA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2tjkkq0c69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:25:58 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPctt021444;
        Thu, 11 Jul 2019 14:25:50 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 02/26] mm/asi: Abort isolation on interrupt, exception and context switch
Date:   Thu, 11 Jul 2019 16:25:14 +0200
Message-Id: <1562855138-19507-3-git-send-email-alexandre.chartre@oracle.com>
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

Address space isolation should be aborted if there is an interrupt,
an exception or a context switch. Interrupt/exception handlers and
context switch code need to run with the full kernel address space.
Address space isolation is aborted by restoring the original CR3
value used before entering address space isolation.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/entry/entry_64.S     |   42 ++++++++++-
 arch/x86/include/asm/asi.h    |  114 ++++++++++++++++++++++++++++
 arch/x86/kernel/asm-offsets.c |    4 +
 arch/x86/mm/asi.c             |  165 ++++++++++++++++++++++++++++++++++++++---
 kernel/sched/core.c           |    4 +
 5 files changed, 315 insertions(+), 14 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 11aa3b2..3dc6174 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -38,6 +38,7 @@
 #include <asm/export.h>
 #include <asm/frame.h>
 #include <asm/nospec-branch.h>
+#include <asm/asi.h>
 #include <linux/err.h>
 
 #include "calling.h"
@@ -558,8 +559,15 @@ ENTRY(interrupt_entry)
 	TRACE_IRQS_OFF
 
 	CALL_enter_from_user_mode
-
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	jmp	2f
+#endif
 1:
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/* Abort address space isolation if it is active */
+	ASI_START_ABORT
+2:
+#endif
 	ENTER_IRQ_STACK old_rsp=%rdi save_ret=1
 	/* We entered an interrupt context - irqs are off: */
 	TRACE_IRQS_OFF
@@ -583,6 +591,9 @@ common_interrupt:
 	call	do_IRQ	/* rdi points to pt_regs */
 	/* 0(%rsp): old RSP */
 ret_from_intr:
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	ASI_FINISH_ABORT
+#endif
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 
@@ -947,6 +958,9 @@ ENTRY(\sym)
 	addq	$\ist_offset, CPU_TSS_IST(\shift_ist)
 	.endif
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	ASI_FINISH_ABORT
+#endif
 	/* these procedures expect "no swapgs" flag in ebx */
 	.if \paranoid
 	jmp	paranoid_exit
@@ -1182,6 +1196,16 @@ ENTRY(paranoid_entry)
 	xorl	%ebx, %ebx
 
 1:
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/*
+	 * If address space isolation is active then abort it and return
+	 * the original kernel CR3 in %r14.
+	 */
+	ASI_START_ABORT_ELSE_JUMP 2f
+	movq	%rdi, %r14
+	ret
+2:
+#endif
 	/*
 	 * Always stash CR3 in %r14.  This value will be restored,
 	 * verbatim, at exit.  Needed if paranoid_entry interrupted
@@ -1265,6 +1289,15 @@ ENTRY(error_entry)
 	CALL_enter_from_user_mode
 	ret
 
+.Lerror_entry_check_address_space_isolation:
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/*
+	 * Abort address space isolation if it is active. This will restore
+	 * the original kernel CR3.
+	 */
+	ASI_START_ABORT
+#endif
+
 .Lerror_entry_done:
 	TRACE_IRQS_OFF
 	ret
@@ -1283,7 +1316,7 @@ ENTRY(error_entry)
 	cmpq	%rax, RIP+8(%rsp)
 	je	.Lbstep_iret
 	cmpq	$.Lgs_change, RIP+8(%rsp)
-	jne	.Lerror_entry_done
+	jne	.Lerror_entry_check_address_space_isolation
 
 	/*
 	 * hack: .Lgs_change can fail with user gsbase.  If this happens, fix up
@@ -1632,7 +1665,10 @@ end_repeat_nmi:
 	movq	%rsp, %rdi
 	movq	$-1, %rsi
 	call	do_nmi
-
+	
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	ASI_FINISH_ABORT
+#endif
 	/* Always restore stashed CR3 value (see paranoid_entry) */
 	RESTORE_CR3 scratch_reg=%r15 save_reg=%r14
 
diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 8a13f73..ff126e1 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -4,6 +4,8 @@
 
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 
+#ifndef __ASSEMBLY__
+
 #include <linux/spinlock.h>
 #include <asm/pgtable.h>
 
@@ -22,20 +24,132 @@ struct asi {
 enum asi_session_state {
 	ASI_SESSION_STATE_INACTIVE,	/* no address space isolation */
 	ASI_SESSION_STATE_ACTIVE,	/* address space isolation is active */
+	ASI_SESSION_STATE_ABORTED,	/* isolation has been aborted */
 };
 
 struct asi_session {
 	struct asi		*asi;		/* ASI for this session */
 	enum asi_session_state	state;		/* state of ASI session */
+	bool			retry_abort;	/* always retry abort */
+	unsigned int		abort_depth;	/* abort depth */
 	unsigned long		original_cr3;	/* cr3 before entering ASI */
 	struct task_struct	*task;		/* task during isolation */
 } __aligned(PAGE_SIZE);
 
+DECLARE_PER_CPU_PAGE_ALIGNED(struct asi_session, cpu_asi_session);
+
 extern struct asi *asi_create(void);
 extern void asi_destroy(struct asi *asi);
 extern int asi_enter(struct asi *asi);
 extern void asi_exit(struct asi *asi);
 
+/*
+ * Function to exit the current isolation. This is used to abort isolation
+ * when a task using isolation is scheduled out.
+ */
+static inline void asi_abort(void)
+{
+	enum asi_session_state asi_state;
+
+	asi_state = this_cpu_read(cpu_asi_session.state);
+	if (asi_state == ASI_SESSION_STATE_INACTIVE)
+		return;
+
+	asi_exit(this_cpu_read(cpu_asi_session.asi));
+}
+
+/*
+ * Barriers for code which sets CR3 to use the ASI page-table. That's
+ * the case, for example, when entering isolation, or during a VMExit if
+ * isolation was active. If such a code is interrupted before CR3 is
+ * effectively set, then the interrupt will abort isolation and restore
+ * the original CR3 value. But then, the code will sets CR3 to use the
+ * ASI page-table while isolation has been aborted by the interrupt.
+ *
+ * To prevent this issue, such a code should call asi_barrier_begin()
+ * before CR3 gets updated, and asi_barrier_end() after CR3 has been
+ * updated.
+ *
+ * asi_barrier_begin() will set retry_abort to true. This will force
+ * interrupts to retain the isolation abort state. Then, after the code
+ * has updated CR3, asi_barrier_end() will be able to check if isolation
+ * was aborted and effectively abort isolation in that case. Setting
+ * retry_abort to true will also force all interrupt to restore the
+ * original CR3; that's in case we have interrupts both before and
+ * after CR3 is set.
+ */
+static inline unsigned long asi_restore_cr3(void)
+{
+	unsigned long original_cr3;
+
+	/* TODO: Kick sibling hyperthread before switching to kernel cr3 */
+	original_cr3 = this_cpu_read(cpu_asi_session.original_cr3);
+	if (original_cr3)
+		write_cr3(original_cr3);
+
+	return original_cr3;
+}
+
+static inline void asi_barrier_begin(void)
+{
+	this_cpu_write(cpu_asi_session.retry_abort, true);
+	mb();
+}
+
+static inline void asi_barrier_end(void)
+{
+	enum asi_session_state state;
+
+	this_cpu_write(cpu_asi_session.retry_abort, false);
+	mb();
+	state = this_cpu_read(cpu_asi_session.state);
+	if (state == ASI_SESSION_STATE_ABORTED) {
+		(void) asi_restore_cr3();
+		asi_abort();
+		return;
+	}
+
+}
+
+#else  /* __ASSEMBLY__ */
+
+/*
+ * If address space isolation is active, start aborting isolation.
+ */
+.macro ASI_START_ABORT
+	movl	PER_CPU_VAR(cpu_asi_session + CPU_ASI_SESSION_state), %edi
+	testl	%edi, %edi
+	jz	.Lasi_start_abort_done_\@
+	call	asi_start_abort
+.Lasi_start_abort_done_\@:
+.endm
+
+/*
+ * If address space isolation is active, finish aborting isolation.
+ */
+.macro ASI_FINISH_ABORT
+	movl	PER_CPU_VAR(cpu_asi_session + CPU_ASI_SESSION_state), %edi
+	testl	%edi, %edi
+	jz	.Lasi_finish_abort_done_\@
+	call	asi_finish_abort
+.Lasi_finish_abort_done_\@:
+.endm
+
+/*
+ * If address space isolation is inactive then jump to the specified
+ * label. Otherwise, start aborting isolation.
+ */
+.macro ASI_START_ABORT_ELSE_JUMP asi_inactive_label:req
+	movl	PER_CPU_VAR(cpu_asi_session + CPU_ASI_SESSION_state), %edi
+	testl	%edi, %edi
+	jz	\asi_inactive_label
+	call	asi_start_abort
+	testq	%rdi, %rdi
+	jz	\asi_inactive_label
+.endm
+
+#endif	/* __ASSEMBLY__ */
+
 #endif	/* CONFIG_ADDRESS_SPACE_ISOLATION */
 
 #endif
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 168543d..395d0c6 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -18,6 +18,7 @@
 #include <asm/bootparam.h>
 #include <asm/suspend.h>
 #include <asm/tlbflush.h>
+#include <asm/asi.h>
 
 #ifdef CONFIG_XEN
 #include <xen/interface/xen.h>
@@ -105,4 +106,7 @@ static void __used common(void)
 	OFFSET(TSS_sp0, tss_struct, x86_tss.sp0);
 	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
 	OFFSET(TSS_sp2, tss_struct, x86_tss.sp2);
+
+	BLANK();
+	OFFSET(CPU_ASI_SESSION_state, asi_session, state);
 }
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index c3993b7..fabb923 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -84,9 +84,17 @@ int asi_enter(struct asi *asi)
 	enum asi_session_state state;
 	struct asi *current_asi;
 	struct asi_session *asi_session;
+	unsigned long original_cr3;
 
 	state = this_cpu_read(cpu_asi_session.state);
 	/*
+	 * The "aborted" state is a transient state used in interrupt and
+	 * exception handlers while aborting isolation. So it shouldn't be
+	 * set when entering isolation.
+	 */
+	WARN_ON(state == ASI_SESSION_STATE_ABORTED);
+
+	/*
 	 * We can re-enter isolation, but only with the same ASI (we don't
 	 * support nesting isolation). Also, if isolation is still active,
 	 * then we should be re-entering with the same task.
@@ -105,15 +113,44 @@ int asi_enter(struct asi *asi)
 	asi_session = &get_cpu_var(cpu_asi_session);
 	asi_session->asi = asi;
 	asi_session->task = current;
-	asi_session->original_cr3 = __get_current_cr3_fast();
-	if (!asi_session->original_cr3) {
+	WARN_ON(asi_session->abort_depth > 0);
+
+	/*
+	 * Instructions ordering is important here because we should be
+	 * able to deal with any interrupt/exception which will abort
+	 * the isolation and restore CR3 to its original value:
+	 *
+	 * - asi_session->original_cr3 must be set before the ASI session
+	 *   becomes active (i.e. before setting asi_session->state to
+	 *   ASI_SESSION_STATE_ACTIVE);
+	 * - the ASI session must be marked as active (i.e. set
+	 *   asi_session->state to ASI_SESSION_STATE_ACTIVE) before
+	 *   loading the CR3 used during isolation.
+	 *
+	 * Any exception or interrupt occurring after asi_session->state is
+	 * set to ASI_SESSION_STATE_ACTIVE will cause the exception/interrupt
+	 * handler to abort the isolation. The handler will then restore
+	 * cr3 to asi_session->original_cr3 and move asi_session->state to
+	 * ASI_SESSION_STATE_ABORTED.
+	 */
+	original_cr3 = __get_current_cr3_fast();
+	if (!original_cr3) {
 		WARN_ON(1);
 		err = -EINVAL;
 		goto err_clear_asi;
 	}
-	asi_session->state = ASI_SESSION_STATE_ACTIVE;
+	asi_session->original_cr3 = original_cr3;
 
+	/*
+	 * Use ASI barrier as we are setting CR3 with the ASI page-table.
+	 * The barrier should begin before setting the state to active as
+	 * any interrupt after the state is active will abort isolation.
+	 */
+	asi_barrier_begin();
+	asi_session->state = ASI_SESSION_STATE_ACTIVE;
+	mb();
 	load_cr3(asi->pgd);
+	asi_barrier_end();
 
 	return 0;
 
@@ -130,23 +167,129 @@ void asi_exit(struct asi *asi)
 {
 	struct asi_session *asi_session;
 	enum asi_session_state asi_state;
-	unsigned long original_cr3;
 
 	asi_state = this_cpu_read(cpu_asi_session.state);
-	if (asi_state == ASI_SESSION_STATE_INACTIVE)
+	switch (asi_state) {
+	case ASI_SESSION_STATE_INACTIVE:
 		return;
-
-	/* TODO: Kick sibling hyperthread before switching to kernel cr3 */
-	original_cr3 = this_cpu_read(cpu_asi_session.original_cr3);
-	if (original_cr3)
-		write_cr3(original_cr3);
+	case ASI_SESSION_STATE_ACTIVE:
+		(void) asi_restore_cr3();
+		break;
+	case ASI_SESSION_STATE_ABORTED:
+		/*
+		 * No need to restore cr3, this was already done during
+		 * the isolation abort.
+		 */
+		break;
+	}
 
 	/* page-table was switched, we can now access the percpu pointer */
 	asi_session = &get_cpu_var(cpu_asi_session);
-	WARN_ON(asi_session->task != current);
+	/*
+	 * asi_exit() can be interrupted before setting the state to
+	 * ASI_SESSION_STATE_INACTIVE. In that case, the interrupt will
+	 * exit isolation before we have started the actual exit. So
+	 * check that the session ASI is still set to verify that an
+	 * exit hasn't already be done.
+	 */
 	asi_session->state = ASI_SESSION_STATE_INACTIVE;
+	mb();
+	if (asi_session->asi == NULL) {
+		/* exit was already done */
+		return;
+	}
+	WARN_ON(asi_session->retry_abort);
+	WARN_ON(asi_session->task != current);
 	asi_session->asi = NULL;
 	asi_session->task = NULL;
 	asi_session->original_cr3 = 0;
+
+	/*
+	 * Reset abort_depth because some interrupt/exception handlers
+	 * (like the user page-fault handler) can schedule us out and so
+	 * exit isolation before abort_depth reaches 0.
+	 */
+	asi_session->abort_depth = 0;
 }
 EXPORT_SYMBOL(asi_exit);
+
+/*
+ * Functions to abort isolation. When address space isolation is active,
+ * these functions are used by interrupt/exception handlers to abort
+ * isolation.
+ *
+ * Common Case
+ * -----------
+ * asi_start_abort() is invoked at the beginning of the interrupt/exception
+ * handler. It aborts isolation by restoring the original CR3 value,
+ * increments the abort count, and move the isolation state to "aborted"
+ * (ASI_SESSION_STATE_ABORTED). If the interrupt/exception is interrupted
+ * by another interrupt/exception then the new interrupt/exception will
+ * just increment the abort count.
+ *
+ * asi_finish_abort() is invoked at the end of the interrupt/exception
+ * handler. It decrements is abort count and if that count reaches zero
+ * then it invokes asi_exit() to exit isolation.
+ *
+ * Special Case When Entering Isolation
+ * ------------------------------------
+ * When entering isolation, asi_enter() will set cpu_asi_session.retry_abort
+ * while updating CR3 to the ASI page-table. This forces asi_start_abort()
+ * handlers to abort isolation even if isolation was already aborted. Also
+ * asi_finish_abort() will retain the aborted state and not exit isolation
+ * (no call to asi_exit()).
+ */
+unsigned long asi_start_abort(void)
+{
+	enum asi_session_state state;
+	unsigned long original_cr3;
+
+	state = this_cpu_read(cpu_asi_session.state);
+
+	switch (state) {
+
+	case ASI_SESSION_STATE_INACTIVE:
+		return 0;
+
+	case ASI_SESSION_STATE_ACTIVE:
+		original_cr3 = asi_restore_cr3();
+		this_cpu_write(cpu_asi_session.state,
+			       ASI_SESSION_STATE_ABORTED);
+		break;
+
+	case ASI_SESSION_STATE_ABORTED:
+		/*
+		 * In the normal case, if the session was already aborted
+		 * then CR3 has already been restored. However if retry_abort
+		 * is set then we restore CR3 again.
+		 */
+		if (this_cpu_read(cpu_asi_session.retry_abort))
+			original_cr3 = asi_restore_cr3();
+		else
+			original_cr3 = this_cpu_read(
+				cpu_asi_session.original_cr3);
+		break;
+	}
+
+	this_cpu_inc(cpu_asi_session.abort_depth);
+
+	return original_cr3;
+}
+
+void asi_finish_abort(void)
+{
+	enum asi_session_state state;
+
+	state = this_cpu_read(cpu_asi_session.state);
+	if (state == ASI_SESSION_STATE_INACTIVE)
+		return;
+
+	WARN_ON(state != ASI_SESSION_STATE_ABORTED);
+
+	/* if retry_abort is set then we retain the abort state */
+	if (this_cpu_dec_return(cpu_asi_session.abort_depth) > 0 ||
+	    this_cpu_read(cpu_asi_session.retry_abort))
+		return;
+
+	asi_exit(this_cpu_read(cpu_asi_session.asi));
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 874c427..bb363f3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -14,6 +14,7 @@
 
 #include <asm/switch_to.h>
 #include <asm/tlb.h>
+#include <asm/asi.h>
 
 #include "../workqueue_internal.h"
 #include "../smpboot.h"
@@ -2597,6 +2598,9 @@ static inline void finish_lock_switch(struct rq *rq)
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	asi_abort();
+#endif
 	kcov_prepare_switch(prev);
 	sched_info_switch(rq, prev, next);
 	perf_event_task_sched_out(prev, next);
-- 
1.7.1

