Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800373A27E8
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 11:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFJJN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 05:13:56 -0400
Received: from 8bytes.org ([81.169.241.247]:43784 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhFJJNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 05:13:54 -0400
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 9BC8D41A;
        Thu, 10 Jun 2021 11:11:56 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v4 3/6] x86/sev-es: Split up runtime #VC handler for correct state tracking
Date:   Thu, 10 Jun 2021 11:11:38 +0200
Message-Id: <20210610091141.30322-4-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610091141.30322-1-joro@8bytes.org>
References: <20210610091141.30322-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Split up the #VC handler code into a from-user and a from-kernel part.
This allows clean and correct state tracking, as the #VC handler needs
to enter NMI-state when raised from kernel mode and plain IRQ state when
raised from user-mode.

Fixes: 62441a1fb532 ("x86/sev-es: Correctly track IRQ states in runtime #VC handler")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev.c | 118 ++++++++++++++++++++++++------------------
 1 file changed, 68 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 2a922d1b03c8..475bbc1b3547 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1326,43 +1326,14 @@ static __always_inline bool on_vc_fallback_stack(struct pt_regs *regs)
 	return (sp >= __this_cpu_ist_bottom_va(VC2) && sp < __this_cpu_ist_top_va(VC2));
 }
 
-/*
- * Main #VC exception handler. It is called when the entry code was able to
- * switch off the IST to a safe kernel stack.
- *
- * With the current implementation it is always possible to switch to a safe
- * stack because #VC exceptions only happen at known places, like intercepted
- * instructions or accesses to MMIO areas/IO ports. They can also happen with
- * code instrumentation when the hypervisor intercepts #DB, but the critical
- * paths are forbidden to be instrumented, so #DB exceptions currently also
- * only happen in safe places.
- */
-DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
+static bool vc_raw_handle_exception(struct pt_regs *regs, unsigned long error_code)
 {
-	irqentry_state_t irq_state;
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
 	enum es_result result;
 	unsigned long flags;
 	struct ghcb *ghcb;
-
-	/*
-	 * Handle #DB before calling into !noinstr code to avoid recursive #DB.
-	 */
-	if (error_code == SVM_EXIT_EXCP_BASE + X86_TRAP_DB) {
-		vc_handle_trap_db(regs);
-		return;
-	}
-
-	irq_state = irqentry_nmi_enter(regs);
-	lockdep_assert_irqs_disabled();
-	instrumentation_begin();
-
-	/*
-	 * This is invoked through an interrupt gate, so IRQs are disabled. The
-	 * code below might walk page-tables for user or kernel addresses, so
-	 * keep the IRQs disabled to protect us against concurrent TLB flushes.
-	 */
+	bool ret = true;
 
 	ghcb = sev_es_get_ghcb(&state, &flags);
 
@@ -1382,15 +1353,18 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 	case ES_UNSUPPORTED:
 		pr_err_ratelimited("Unsupported exit-code 0x%02lx in #VC exception (IP: 0x%lx)\n",
 				   error_code, regs->ip);
-		goto fail;
+		ret = false;
+		break;
 	case ES_VMM_ERROR:
 		pr_err_ratelimited("Failure in communication with VMM (exit-code 0x%02lx IP: 0x%lx)\n",
 				   error_code, regs->ip);
-		goto fail;
+		ret = false;
+		break;
 	case ES_DECODE_FAILED:
 		pr_err_ratelimited("Failed to decode instruction (exit-code 0x%02lx IP: 0x%lx)\n",
 				   error_code, regs->ip);
-		goto fail;
+		ret = false;
+		break;
 	case ES_EXCEPTION:
 		vc_forward_exception(&ctxt);
 		break;
@@ -1406,24 +1380,16 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 		BUG();
 	}
 
-out:
-	instrumentation_end();
-	irqentry_nmi_exit(regs, irq_state);
+	return ret;
+}
 
-	return;
+static void vc_handle_from_kernel(struct pt_regs *regs, unsigned long error_code)
+{
+	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
 
-fail:
-	if (user_mode(regs)) {
-		/*
-		 * Do not kill the machine if user-space triggered the
-		 * exception. Send SIGBUS instead and let user-space deal with
-		 * it.
-		 */
-		force_sig_fault(SIGBUS, BUS_OBJERR, (void __user *)0);
-	} else {
-		pr_emerg("PANIC: Unhandled #VC exception in kernel space (result=%d)\n",
-			 result);
+	instrumentation_begin();
 
+	if (!vc_raw_handle_exception(regs, error_code)) {
 		/* Show some debug info */
 		show_regs(regs);
 
@@ -1434,7 +1400,59 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 		panic("Returned from Terminate-Request to Hypervisor\n");
 	}
 
-	goto out;
+	instrumentation_end();
+	irqentry_nmi_exit(regs, irq_state);
+}
+
+static void vc_handle_from_user(struct pt_regs *regs, unsigned long error_code)
+{
+	irqentry_state_t irq_state = irqentry_enter(regs);
+
+	instrumentation_begin();
+
+	if (!vc_raw_handle_exception(regs, error_code)) {
+		/*
+		 * Do not kill the machine if user-space triggered the
+		 * exception. Send SIGBUS instead and let user-space deal with
+		 * it.
+		 */
+		force_sig_fault(SIGBUS, BUS_OBJERR, (void __user *)0);
+	}
+
+	instrumentation_end();
+	irqentry_exit(regs, irq_state);
+}
+/*
+ * Main #VC exception handler. It is called when the entry code was able to
+ * switch off the IST to a safe kernel stack.
+ *
+ * With the current implementation it is always possible to switch to a safe
+ * stack because #VC exceptions only happen at known places, like intercepted
+ * instructions or accesses to MMIO areas/IO ports. They can also happen with
+ * code instrumentation when the hypervisor intercepts #DB, but the critical
+ * paths are forbidden to be instrumented, so #DB exceptions currently also
+ * only happen in safe places.
+ */
+DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
+{
+	/*
+	 * Handle #DB before calling into !noinstr code to avoid recursive #DB.
+	 */
+	if (error_code == SVM_EXIT_EXCP_BASE + X86_TRAP_DB) {
+		vc_handle_trap_db(regs);
+		return;
+	}
+
+	/*
+	 * This is invoked through an interrupt gate, so IRQs are disabled. The
+	 * code below might walk page-tables for user or kernel addresses, so
+	 * keep the IRQs disabled to protect us against concurrent TLB flushes.
+	 */
+
+	if (user_mode(regs))
+		vc_handle_from_user(regs, error_code);
+	else
+		vc_handle_from_kernel(regs, error_code);
 }
 
 /* This handler runs on the #VC fall-back stack. It can cause further #VC exceptions */
-- 
2.31.1

