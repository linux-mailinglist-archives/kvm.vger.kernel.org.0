Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60362602F2
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgIGRi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:38:59 -0400
Received: from 8bytes.org ([81.169.241.247]:43596 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729460AbgIGNSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:18:04 -0400
Received: from cap.home.8bytes.org (p549add56.dip0.t-ipconnect.de [84.154.221.86])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 298771017;
        Mon,  7 Sep 2020 15:17:04 +0200 (CEST)
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
Subject: [PATCH v7 43/72] x86/sev-es: Adjust #VC IST Stack on entering NMI handler
Date:   Mon,  7 Sep 2020 15:15:44 +0200
Message-Id: <20200907131613.12703-44-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907131613.12703-1-joro@8bytes.org>
References: <20200907131613.12703-1-joro@8bytes.org>
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
 arch/x86/include/asm/sev-es.h | 19 +++++++++++++
 arch/x86/kernel/nmi.c         |  9 ++++++
 arch/x86/kernel/sev-es.c      | 53 +++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index 9fbeedaa66ee..59176e8c6b81 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -78,4 +78,23 @@ extern void vc_no_ghcb(void);
 extern void vc_boot_ghcb(void);
 extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+extern struct static_key_false sev_es_enable_key;
+extern void __sev_es_ist_enter(struct pt_regs *regs);
+extern void __sev_es_ist_exit(void);
+static __always_inline void sev_es_ist_enter(struct pt_regs *regs)
+{
+	if (static_branch_unlikely(&sev_es_enable_key))
+		__sev_es_ist_enter(regs);
+}
+static __always_inline void sev_es_ist_exit(void)
+{
+	if (static_branch_unlikely(&sev_es_enable_key))
+		__sev_es_ist_exit();
+}
+#else
+static inline void sev_es_ist_enter(struct pt_regs *regs) { }
+static inline void sev_es_ist_exit(void) { }
+#endif
+
 #endif
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 4fc9954a9560..5859cec774a4 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -33,6 +33,7 @@
 #include <asm/reboot.h>
 #include <asm/cache.h>
 #include <asm/nospec-branch.h>
+#include <asm/sev-es.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -488,6 +489,12 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 	this_cpu_write(nmi_cr2, read_cr2());
 nmi_restart:
 
+	/*
+	 * Needs to happen before DR7 is accessed, because the hypervisor can
+	 * intercept DR7 reads/writes, turings those into #VC exceptions.
+	 */
+	sev_es_ist_enter(regs);
+
 	this_cpu_write(nmi_dr7, local_db_save());
 
 	irq_state = idtentry_enter_nmi(regs);
@@ -501,6 +508,8 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 
 	local_db_restore(this_cpu_read(nmi_dr7));
 
+	sev_es_ist_exit();
+
 	if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))
 		write_cr2(this_cpu_read(nmi_cr2));
 	if (this_cpu_dec_return(nmi_state))
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 5541788420ce..69c55f0fdf6a 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -51,6 +51,7 @@ struct sev_es_runtime_data {
 };
 
 static DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
+DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
 
 static void __init setup_vc_stacks(int cpu)
 {
@@ -73,6 +74,55 @@ static void __init setup_vc_stacks(int cpu)
 	cea_set_pte((void *)vaddr, pa, PAGE_KERNEL);
 }
 
+static __always_inline bool on_vc_stack(unsigned long sp)
+{
+	return ((sp >= __this_cpu_ist_bottom_va(VC)) && (sp < __this_cpu_ist_top_va(VC)));
+}
+
+/*
+ * This function handles the case when an NM is raised in the #VC exception
+ * handler entry code. In this case the IST entry for #VC must be adjusted, so
+ * that any subsequent #VC exception will not overwrite the stack contents of the
+ * interrupted #VC handler.
+ *
+ * The IST entry is adjusted unconditionally so that it can be also be
+ * unconditionally adjusted back in sev_es_ist_exit(). Otherwise a nested
+ * sev_es_ist_exit() call may adjust back the IST entry too early.
+ */
+void noinstr __sev_es_ist_enter(struct pt_regs *regs)
+{
+	unsigned long old_ist, new_ist;
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
+	*(unsigned long *)new_ist = old_ist;
+
+	/* Set new IST entry */
+	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], new_ist);
+}
+
+void noinstr __sev_es_ist_exit(void)
+{
+	unsigned long ist;
+
+	/* Read IST entry */
+	ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
+
+	if (WARN_ON(ist == __this_cpu_ist_top_va(VC)))
+		return;
+
+	/* Read back old IST entry and write it to the TSS */
+	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], *(unsigned long *)ist);
+}
+
 /* Needed in vc_early_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
@@ -277,6 +327,9 @@ void __init sev_es_init_vc_handling(void)
 	if (!sev_es_active())
 		return;
 
+	/* Enable SEV-ES special handling */
+	static_branch_enable(&sev_es_enable_key);
+
 	/* Initialize per-cpu GHCB pages */
 	for_each_possible_cpu(cpu) {
 		alloc_runtime_data(cpu);
-- 
2.28.0

