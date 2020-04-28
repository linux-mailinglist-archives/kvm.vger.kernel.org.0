Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79A81BC312
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgD1PVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:21:48 -0400
Received: from 8bytes.org ([81.169.241.247]:37910 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgD1PSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:18:10 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 86BB6F2B; Tue, 28 Apr 2020 17:17:50 +0200 (CEST)
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
Subject: [PATCH v3 44/75] x86/sev-es: Allocate and Map IST stacks for #VC handler
Date:   Tue, 28 Apr 2020 17:16:54 +0200
Message-Id: <20200428151725.31091-45-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Allocate and map enough stacks for the #VC handler to support sufficient
levels of nesting and the NMI-in-#VC scenario.

Also setup the IST entrys for the #VC handler on all CPUs because #VC
needs to work before cpu_init() has set up the per-cpu TSS.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/cpu_entry_area.h | 61 +++++++++++++++++++++++++++
 arch/x86/include/asm/page_64_types.h  |  1 +
 arch/x86/kernel/cpu/common.c          |  1 +
 arch/x86/kernel/sev-es.c              | 40 ++++++++++++++++++
 4 files changed, 103 insertions(+)

diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index 02c0078d3787..85aac6c63653 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -64,6 +64,61 @@ enum exception_stack_ordering {
 #define CEA_ESTACK_PAGES					\
 	(sizeof(struct cea_exception_stacks) / PAGE_SIZE)
 
+/*
+ * VC Handler IST Stacks
+ *
+ * The IST stacks for the #VC handler are only allocated when SEV-ES is active,
+ * so they are not part of 'struct exception_stacks'.
+ *
+ * The VC handler uses shift_ist so that #VC can be nested. Nesting happens for
+ * example when the #VC handler has to call printk in the case of and error or
+ * when emulating 'movs' instructions.
+ *
+ * NMIs are another special case which can cause nesting of #VC handlers. The
+ * do_nmi() code path can cause #VC, e.g. for RDPMC. An NMI can also hit in
+ * the time window when the #VC handler is raised but before it has shifted its
+ * IST entry. To make sure any #VC raised from the NMI code path uses a new
+ * stack, the NMI handler unconditionally shifts the #VC handlers IST entry.
+ * This can cause one IST stack for #VC to be omitted.
+ *
+ * To support sufficient levels of nesting for the #VC handler, make the number
+ * of nesting levels configurable. It is currently set to 5 to support this
+ * scenario:
+ *
+ * #VC - IST stack 4, IST entry already shifted to 3
+ *
+ *     -> NMI - shifts #VC IST entry to 2
+ *
+ *     -> #VC(RDPMC) - shifts #VC IST to 1, something goes wrong, print
+ *                     an error message
+ *
+ *     -> #VC(printk) - shifts #VC IST entry to 0, output driver
+ *                      uses 'movs'
+ *
+ *     -> #VC(movs) - shifts IST to unmapped stack, further #VCs will
+ *                    cause #DF
+ *
+ */
+#define N_VC_STACKS		5
+
+#define VC_STACK_MEMBERS(guardsize, holesize)			\
+	char	hole[holesize];					\
+	struct {						\
+		char guard[guardsize];				\
+		char stack[EXCEPTION_STKSZ];			\
+	} stacks[N_VC_STACKS];					\
+	char top_guard[guardsize];				\
+
+/* Physical storage */
+struct vmm_exception_stacks {
+	VC_STACK_MEMBERS(0, 0)
+};
+
+/* Mapping in cpu_entry_area */
+struct cea_vmm_exception_stacks {
+	VC_STACK_MEMBERS(PAGE_SIZE, EXCEPTION_STKSZ)
+};
+
 #endif
 
 #ifdef CONFIG_X86_32
@@ -110,6 +165,12 @@ struct cpu_entry_area {
 	 * Exception stacks used for IST entries with guard pages.
 	 */
 	struct cea_exception_stacks estacks;
+
+	/*
+	 * IST Exception stacks for VC handler - Only allocated and mapped when
+	 * SEV-ES is active.
+	 */
+	struct cea_vmm_exception_stacks vc_stacks;
 #endif
 	/*
 	 * Per CPU debug store for Intel performance monitoring. Wastes a
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 288b065955b7..d0c6c10c18a0 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -28,6 +28,7 @@
 #define	IST_INDEX_NMI		1
 #define	IST_INDEX_DB		2
 #define	IST_INDEX_MCE		3
+#define	IST_INDEX_VC		4
 
 /*
  * Set __PAGE_OFFSET to the most negative possible address +
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bed0cb83fe24..214765635e86 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1808,6 +1808,7 @@ static inline void tss_setup_ist(struct tss_struct *tss)
 	tss->x86_tss.ist[IST_INDEX_NMI] = __this_cpu_ist_top_va(NMI);
 	tss->x86_tss.ist[IST_INDEX_DB] = __this_cpu_ist_top_va(DB);
 	tss->x86_tss.ist[IST_INDEX_MCE] = __this_cpu_ist_top_va(MCE);
+	/* IST_INDEX_VC already set up for all CPUs during early boot */
 }
 
 #else /* CONFIG_X86_64 */
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index a43d80d5e50e..e5d87f2af357 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 
+#include <asm/cpu_entry_area.h>
 #include <asm/trap_defs.h>
 #include <asm/sev-es.h>
 #include <asm/insn-eval.h>
@@ -37,6 +38,9 @@ static struct ghcb __initdata *boot_ghcb;
 /* #VC handler runtime per-cpu data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
+
+	/* Physical storage for the per-cpu IST stacks of the #VC handler */
+	struct vmm_exception_stacks vc_stacks __aligned(PAGE_SIZE);
 };
 
 static DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
@@ -236,11 +240,46 @@ static void __init sev_es_init_ghcb(int cpu)
 	memset(&data->ghcb_page, 0, sizeof(data->ghcb_page));
 }
 
+static void __init sev_es_setup_vc_stack(int cpu)
+{
+	struct vmm_exception_stacks *stack;
+	struct sev_es_runtime_data *data;
+	struct cpu_entry_area *cea;
+	struct tss_struct *tss;
+	unsigned long size;
+	char *first_stack;
+	int i;
+
+	data  = per_cpu(runtime_data, cpu);
+	stack = &data->vc_stacks;
+	cea   = get_cpu_entry_area(cpu);
+
+	/* Map the stacks to the cpu_entry_area */
+	for (i = 0; i < N_VC_STACKS; i++) {
+		void *vaddr = cea->vc_stacks.stacks[i].stack;
+		phys_addr_t pa = __pa(stack->stacks[i].stack);
+
+		cea_set_pte(vaddr, pa, PAGE_KERNEL);
+	}
+
+	/*
+	 * The #VC handler IST stack is needed in secondary CPU bringup before
+	 * cpu_init() had a chance to setup the rest of the TSS. So setup the
+	 * #VC handlers stack pointer up here for all CPUs
+	 */
+	first_stack = cea->vc_stacks.stacks[N_VC_STACKS - 1].stack;
+	size        = sizeof(cea->vc_stacks.stacks[N_VC_STACKS - 1].stack);
+	tss         = per_cpu_ptr(&cpu_tss_rw, cpu);
+
+	tss->x86_tss.ist[IST_INDEX_VC] = (unsigned long)first_stack + size;
+}
+
 void __init sev_es_init_vc_handling(void)
 {
 	int cpu;
 
 	BUILD_BUG_ON((offsetof(struct sev_es_runtime_data, ghcb_page) % PAGE_SIZE) != 0);
+	BUILD_BUG_ON((offsetof(struct sev_es_runtime_data, vc_stacks) % PAGE_SIZE) != 0);
 
 	if (!sev_es_active())
 		return;
@@ -249,6 +288,7 @@ void __init sev_es_init_vc_handling(void)
 	for_each_possible_cpu(cpu) {
 		sev_es_alloc_runtime_data(cpu);
 		sev_es_init_ghcb(cpu);
+		sev_es_setup_vc_stack(cpu);
 	}
 }
 
-- 
2.17.1

