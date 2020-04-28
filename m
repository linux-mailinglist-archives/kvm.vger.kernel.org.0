Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47021BC2DB
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgD1PSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:18:23 -0400
Received: from 8bytes.org ([81.169.241.247]:38536 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbgD1PSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:18:20 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id A29DAF48; Tue, 28 Apr 2020 17:17:55 +0200 (CEST)
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
Subject: [PATCH v3 69/75] x86/realmode: Setup AP jump table
Date:   Tue, 28 Apr 2020 17:17:19 +0200
Message-Id: <20200428151725.31091-70-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Setup the AP jump table to point to the SEV-ES trampoline code so that
the APs can boot.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: - Adapted to different code base
                   - Moved AP table setup from SIPI sending path to
		     real-mode setup code
		   - Fix sparse warnings ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev-es.h   |  6 +++
 arch/x86/include/uapi/asm/svm.h |  3 ++
 arch/x86/kernel/sev-es.c        | 66 +++++++++++++++++++++++++++++++++
 arch/x86/realmode/init.c        |  6 +++
 4 files changed, 81 insertions(+)

diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index ca0e12cb089c..c89b6e2e6439 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -78,17 +78,23 @@ static inline u64 lower_bits(u64 val, unsigned int bits)
 extern void vc_no_ghcb(void);
 extern bool vc_boot_ghcb(struct pt_regs *regs);
 
+struct real_mode_header;
 enum stack_type;
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 const char *vc_stack_name(enum stack_type type);
 void sev_es_nmi_enter(void);
 void sev_es_nmi_exit(void);
+int sev_es_setup_ap_jump_table(struct real_mode_header *rmh);
 #else /* CONFIG_AMD_MEM_ENCRYPT */
 static inline const char *vc_stack_name(enum stack_type type)
 {
 	return NULL;
 }
+static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
+{
+	return 0;
+}
 #endif /* CONFIG_AMD_MEM_ENCRYPT*/
 
 #endif
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 8f36ae021a7f..a19ce9681ec2 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -84,6 +84,9 @@
 /* SEV-ES software-defined VMGEXIT events */
 #define SVM_VMGEXIT_MMIO_READ			0x80000001
 #define SVM_VMGEXIT_MMIO_WRITE			0x80000002
+#define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
+#define		SVM_VMGEXIT_SET_AP_JUMP_TABLE			0
+#define		SVM_VMGEXIT_GET_AP_JUMP_TABLE			1
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 #define SVM_EXIT_ERR           -1
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 047fa47ef9d4..28725c38e6fb 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -25,6 +25,7 @@
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
 #include <asm/trap_defs.h>
+#include <asm/realmode.h>
 #include <asm/sev-es.h>
 #include <asm/insn-eval.h>
 #include <asm/fpu/internal.h>
@@ -159,6 +160,8 @@ static void sev_es_put_ghcb(struct ghcb_state *state)
 /* Needed in vc_early_vc_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
+static inline u64 sev_es_rd_ghcb_msr(void);
+
 static inline u64 sev_es_rd_ghcb_msr(void)
 {
 	return native_read_msr(MSR_AMD64_SEV_ES_GHCB);
@@ -336,6 +339,69 @@ static phys_addr_t vc_slow_virt_to_phys(struct ghcb *ghcb, unsigned long vaddr)
 /* Include code shared with pre-decompression boot stage */
 #include "sev-es-shared.c"
 
+static u64 sev_es_get_jump_table_addr(void)
+{
+	struct ghcb_state state;
+	unsigned long flags;
+	struct ghcb *ghcb;
+	u64 ret;
+
+	local_irq_save(flags);
+
+	ghcb = sev_es_get_ghcb(&state);
+
+	vc_ghcb_invalidate(ghcb);
+	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_AP_JUMP_TABLE);
+	ghcb_set_sw_exit_info_1(ghcb, SVM_VMGEXIT_GET_AP_JUMP_TABLE);
+	ghcb_set_sw_exit_info_2(ghcb, 0);
+
+	sev_es_wr_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	if (!ghcb_is_valid_sw_exit_info_1(ghcb) ||
+	    !ghcb_is_valid_sw_exit_info_2(ghcb))
+		ret = 0;
+
+	ret = ghcb->save.sw_exit_info_2;
+
+	sev_es_put_ghcb(&state);
+
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
+{
+	u16 startup_cs, startup_ip;
+	phys_addr_t jump_table_pa;
+	u64 jump_table_addr;
+	u16 __iomem *jump_table;
+
+	jump_table_addr = sev_es_get_jump_table_addr();
+
+	/* Check if AP Jump Table is non-zero and page-aligned */
+	if (!jump_table_addr || jump_table_addr & ~PAGE_MASK)
+		return 0;
+
+	jump_table_pa = jump_table_addr & PAGE_MASK;
+
+	startup_cs = (u16)(rmh->trampoline_start >> 4);
+	startup_ip = (u16)(rmh->sev_es_trampoline_start -
+			   rmh->trampoline_start);
+
+	jump_table = ioremap_encrypted(jump_table_pa, PAGE_SIZE);
+	if (!jump_table)
+		return -EIO;
+
+	writew(startup_ip, &jump_table[0]);
+	writew(startup_cs, &jump_table[1]);
+
+	iounmap(jump_table);
+
+	return 0;
+}
+
 static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct pt_regs *regs = ctxt->regs;
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 262f83cad355..1c5cbfd102d5 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -9,6 +9,7 @@
 #include <asm/realmode.h>
 #include <asm/tlbflush.h>
 #include <asm/crash.h>
+#include <asm/sev-es.h>
 
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
@@ -107,6 +108,11 @@ static void __init setup_real_mode(void)
 	if (sme_active())
 		trampoline_header->flags |= TH_FLAGS_SME_ACTIVE;
 
+	if (sev_es_active()) {
+		if (sev_es_setup_ap_jump_table(real_mode_header))
+			panic("Failed to update SEV-ES AP Jump Table");
+	}
+
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
 	trampoline_pgd[0] = trampoline_pgd_entry.pgd;
 	trampoline_pgd[511] = init_top_pgt[511].pgd;
-- 
2.17.1

