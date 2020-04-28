Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E0E1BC30E
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgD1PVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:21:30 -0400
Received: from 8bytes.org ([81.169.241.247]:37630 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbgD1PSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:18:11 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id DBEACF2C; Tue, 28 Apr 2020 17:17:50 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
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
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 46/75] x86/sev-es: Shift #VC IST Stack in nmi_enter()/nmi_exit()
Date:   Tue, 28 Apr 2020 17:16:56 +0200
Message-Id: <20200428151725.31091-47-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When an NMI hits in the #VC handler entry code before it shifted its IST
entry, then any subsequent #VC exception in the NMI code-path will
overwrite the interrupted #VC handlers stack.

Make sure this doesn't happen by  explicitly shifting the #VC IST entry
in the NMI handler for the time in can cause #VC exceptions.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/hardirq.h   | 14 ++++++++++++++
 arch/x86/include/asm/sev-es.h    |  2 ++
 arch/x86/kernel/asm-offsets_64.c |  1 +
 arch/x86/kernel/nmi.c            |  1 +
 arch/x86/kernel/sev-es.c         | 21 +++++++++++++++++++++
 5 files changed, 39 insertions(+)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 07533795b8d2..4920556dcbf8 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -80,4 +80,18 @@ static inline bool kvm_get_cpu_l1tf_flush_l1d(void)
 static inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
 #endif /* IS_ENABLED(CONFIG_KVM_INTEL) */
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+
+#define arch_nmi_enter()		\
+	do {				\
+		sev_es_nmi_enter();	\
+	} while (0)
+
+#define arch_nmi_exit()			\
+	do {				\
+		sev_es_nmi_exit();	\
+	} while (0)
+
+#endif
+
 #endif /* _ASM_X86_HARDIRQ_H */
diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index 265da8351475..ca0e12cb089c 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -82,6 +82,8 @@ enum stack_type;
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 const char *vc_stack_name(enum stack_type type);
+void sev_es_nmi_enter(void);
+void sev_es_nmi_exit(void);
 #else /* CONFIG_AMD_MEM_ENCRYPT */
 static inline const char *vc_stack_name(enum stack_type type)
 {
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index c2a47016f243..b8b57faed147 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -60,6 +60,7 @@ int main(void)
 	OFFSET(TSS_ist, tss_struct, x86_tss.ist);
 	DEFINE(DB_STACK_OFFSET, offsetof(struct cea_exception_stacks, DB_stack) -
 	       offsetof(struct cea_exception_stacks, DB1_stack));
+	DEFINE(VC_STACK_OFFSET, sizeof(((struct cea_vmm_exception_stacks *)0)->stacks[0]));
 	BLANK();
 
 #ifdef CONFIG_STACKPROTECTOR
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 6407ea21fa1b..27d1016ec840 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -37,6 +37,7 @@
 #include <asm/reboot.h>
 #include <asm/cache.h>
 #include <asm/nospec-branch.h>
+#include <asm/sev-es.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index dd60d24db3d0..a4fa7f351bf2 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 
+#include <generated/asm-offsets.h>
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
 #include <asm/trap_defs.h>
@@ -49,6 +50,26 @@ struct sev_es_runtime_data {
 
 static DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
 
+/*
+ * Shift/Unshift the IST entry for the #VC handler during
+ * nmi_enter()/nmi_exit().  This is needed when an NMI hits in the #VC handlers
+ * entry code before it has shifted its IST entry. This way #VC exceptions
+ * caused by the NMI handler are guaranteed to use a new stack.
+ */
+void sev_es_nmi_enter(void)
+{
+	struct tss_struct *tss = this_cpu_ptr(&cpu_tss_rw);
+
+	tss->x86_tss.ist[IST_INDEX_VC] -= VC_STACK_OFFSET;
+}
+
+void sev_es_nmi_exit(void)
+{
+	struct tss_struct *tss = this_cpu_ptr(&cpu_tss_rw);
+
+	tss->x86_tss.ist[IST_INDEX_VC] += VC_STACK_OFFSET;
+}
+
 /* Needed in vc_early_vc_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
-- 
2.17.1

