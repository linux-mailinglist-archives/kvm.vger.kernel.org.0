Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE91421F093
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 14:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgGNMOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 08:14:09 -0400
Received: from 8bytes.org ([81.169.241.247]:53718 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728399AbgGNMLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 08:11:01 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 728A9F91;
        Tue, 14 Jul 2020 14:10:57 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v4 45/75] x86/sev-es: Adjust #VC IST Stack on entering NMI handler
Date:   Tue, 14 Jul 2020 14:08:47 +0200
Message-Id: <20200714120917.11253-46-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714120917.11253-1-joro@8bytes.org>
References: <20200714120917.11253-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When an NMI hits in the #VC handler entry code before it switched to
another stack, any subsequent #VC exception in the NMI code-path will
overwrite the interrupted #VC handlers stack.

Make sure this doesn't happen by  explicitly adjusting the #VC IST entry
in the NMI handler for the time in can cause #VC exceptions.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev-es.h |  8 +++++
 arch/x86/kernel/nmi.c         |  6 ++++
 arch/x86/kernel/sev-es.c      | 61 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c       |  2 ++
 4 files changed, 77 insertions(+)

diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index 824e9e6b067c..330140a189be 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -77,4 +77,12 @@ static inline u64 lower_bits(u64 val, unsigned int bits)
 extern void vc_no_ghcb(void);
 extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+extern void sev_es_ist_enter(struct pt_regs *regs);
+extern void sev_es_ist_exit(void);
+#else
+static inline void sev_es_ist_enter(struct pt_regs *regs) { }
+static inline void sev_es_ist_exit(void) { }
+#endif
+
 #endif
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index d7c5e44b26f7..d94a5bb0bebc 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -33,6 +33,7 @@
 #include <asm/reboot.h>
 #include <asm/cache.h>
 #include <asm/nospec-branch.h>
+#include <asm/sev-es.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -489,6 +490,9 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 	this_cpu_write(nmi_cr2, read_cr2());
 nmi_restart:
 
+	/* Needs to happen before DR7 is accessed */
+	sev_es_ist_enter(regs);
+
 	this_cpu_write(nmi_dr7, local_db_save());
 
 	nmi_enter();
@@ -502,6 +506,8 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 
 	local_db_restore(this_cpu_read(nmi_dr7));
 
+	sev_es_ist_exit();
+
 	if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))
 		write_cr2(this_cpu_read(nmi_cr2));
 	if (this_cpu_dec_return(nmi_state))
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index d415368f16ec..2a7cc72db1d5 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -78,6 +78,67 @@ static void __init sev_es_setup_vc_stacks(int cpu)
 	tss->x86_tss.ist[IST_INDEX_VC] = CEA_ESTACK_TOP(&cea->estacks, VC);
 }
 
+static bool on_vc_stack(unsigned long sp)
+{
+	return ((sp >= __this_cpu_ist_bot_va(VC)) && (sp < __this_cpu_ist_top_va(VC)));
+}
+
+/*
+ * This function handles the case when an NMI or an NMI-like exception
+ * like #DB is raised in the #VC exception handler entry code. In this
+ * case the IST entry for VC must be adjusted, so that any subsequent VC
+ * exception will not overwrite the stack contents of the interrupted VC
+ * handler.
+ *
+ * The IST entry is adjusted unconditionally so that it can be also be
+ * unconditionally back-adjusted in sev_es_nmi_exit(). Otherwise a
+ * nested nmi_exit() call (#VC->NMI->#DB) may back-adjust the IST entry
+ * too early.
+ */
+void noinstr sev_es_ist_enter(struct pt_regs *regs)
+{
+	unsigned long old_ist, new_ist;
+	unsigned long *p;
+
+	if (!sev_es_active())
+		return;
+
+	/* Read old IST entry */
+	old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
+
+	/* Make room on the IST stack */
+	if (on_vc_stack(regs->sp))
+		new_ist = ALIGN_DOWN(regs->sp, 8) - sizeof(old_ist);
+	else
+		new_ist = old_ist - sizeof(old_ist);
+
+	/* Store old IST entry */
+	p       = (unsigned long *)new_ist;
+	*p      = old_ist;
+
+	/* Set new IST entry */
+	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], new_ist);
+}
+
+void noinstr sev_es_ist_exit(void)
+{
+	unsigned long ist;
+	unsigned long *p;
+
+	if (!sev_es_active())
+		return;
+
+	/* Read IST entry */
+	ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
+
+	if (WARN_ON(ist == __this_cpu_ist_top_va(VC)))
+		return;
+
+	/* Read back old IST entry and write it to the TSS */
+	p = (unsigned long *)ist;
+	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], *p);
+}
+
 /* Needed in vc_early_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 907ac2b378a8..59d17e541df9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -59,6 +59,7 @@
 #include <asm/umip.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
+#include <asm/sev-es.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -733,6 +734,7 @@ static bool is_sysenter_singlestep(struct pt_regs *regs)
 
 static __always_inline void debug_enter(unsigned long *dr6, unsigned long *dr7)
 {
+
 	/*
 	 * Disable breakpoints during exception handling; recursive exceptions
 	 * are exceedingly 'fun'.
-- 
2.27.0

