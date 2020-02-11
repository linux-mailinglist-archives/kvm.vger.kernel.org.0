Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C911590B8
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgBKNy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:54:26 -0500
Received: from 8bytes.org ([81.169.241.247]:52198 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729543AbgBKNxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:30 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 657A4EA7; Tue, 11 Feb 2020 14:53:17 +0100 (CET)
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 57/62] x86/realmode: Setup AP jump table
Date:   Tue, 11 Feb 2020 14:52:51 +0100
Message-Id: <20200211135256.24617-58-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
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
		     real-mode setup code ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev-es.h   | 11 ++++++
 arch/x86/include/uapi/asm/svm.h |  3 ++
 arch/x86/kernel/sev-es.c        | 63 +++++++++++++++++++++++++++++++++
 arch/x86/realmode/init.c        |  6 ++++
 4 files changed, 83 insertions(+)

diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index a2d0c77dabc3..a4d7574c5c6a 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -78,4 +78,15 @@ static inline u64 copy_lower_bits(u64 out, u64 in, unsigned int bits)
 extern void early_vc_handler(void);
 extern int boot_vc_exception(struct pt_regs *regs);
 
+struct real_mode_header;
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+int sev_es_setup_ap_jump_table(struct real_mode_header *rmh);
+#else /* CONFIG_AMD_MEM_ENCRYPT */
+static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
+{
+	return 0;
+}
+#endif /* CONFIG_AMD_MEM_ENCRYPT*/
+
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
index 6924bb1ad8b2..d8193d37ed2b 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 
 #include <asm/trap_defs.h>
+#include <asm/realmode.h>
 #include <asm/sev-es.h>
 #include <asm/fpu/internal.h>
 #include <asm/processor.h>
@@ -42,6 +43,8 @@ static DEFINE_PER_CPU_DECRYPTED(struct ghcb, ghcb_page) __aligned(PAGE_SIZE);
 /* Needed in early_forward_exception */
 extern void early_exception(struct pt_regs *regs, int trapnr);
 
+static inline u64 read_ghcb_msr(void);
+
 static inline u64 read_ghcb_msr(void)
 {
 	return native_read_msr(MSR_AMD64_SEV_ES_GHCB);
@@ -139,6 +142,66 @@ static phys_addr_t es_slow_virt_to_phys(struct ghcb *ghcb, long vaddr)
 /* Include code shared with pre-decompression boot stage */
 #include "sev-es-shared.c"
 
+static u64 sev_es_get_jump_table_addr(void)
+{
+	unsigned long flags;
+	struct ghcb *ghcb;
+	u64 ret;
+
+	local_irq_save(flags);
+
+	ghcb = this_cpu_ptr(&ghcb_page);
+	ghcb_invalidate(ghcb);
+
+	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_AP_JUMP_TABLE);
+	ghcb_set_sw_exit_info_1(ghcb, SVM_VMGEXIT_GET_AP_JUMP_TABLE);
+	ghcb_set_sw_exit_info_2(ghcb, 0);
+
+	write_ghcb_msr(__pa(ghcb));
+	VMGEXIT();
+
+	if (!ghcb_is_valid_sw_exit_info_1(ghcb) ||
+	    !ghcb_is_valid_sw_exit_info_2(ghcb))
+		ret = 0;
+
+	ret = ghcb->save.sw_exit_info_2;
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
+	u16 *jump_table;
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
+	jump_table[0] = startup_ip;
+	jump_table[1] = startup_cs;
+
+	iounmap(jump_table);
+
+	return 0;
+}
+
 static enum es_result handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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

