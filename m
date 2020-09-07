Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE74D2602D3
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgIGRdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729490AbgIGNS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:18:26 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D61C061796;
        Mon,  7 Sep 2020 06:18:03 -0700 (PDT)
Received: from cap.home.8bytes.org (p549add56.dip0.t-ipconnect.de [84.154.221.86])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 12C97FF7;
        Mon,  7 Sep 2020 15:17:00 +0200 (CEST)
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
Subject: [PATCH v7 35/72] x86/head/64: Move early exception dispatch to C code
Date:   Mon,  7 Sep 2020 15:15:36 +0200
Message-Id: <20200907131613.12703-36-joro@8bytes.org>
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

Move the assembly coded dispatch between page-faults and all other
exceptions to C code to make it easier to maintain and extend.

Also change the return-type of early_make_pgtable() to bool and make it
static.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/pgtable.h |  2 +-
 arch/x86/include/asm/setup.h   |  4 +++-
 arch/x86/kernel/head64.c       | 19 +++++++++++++++----
 arch/x86/kernel/head_64.S      | 11 +----------
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 5e0dcc20614d..a02c67291cfc 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -28,7 +28,7 @@
 #include <asm-generic/pgtable_uffd.h>
 
 extern pgd_t early_top_pgt[PTRS_PER_PGD];
-int __init __early_make_pgtable(unsigned long address, pmdval_t pmd);
+bool __init __early_make_pgtable(unsigned long address, pmdval_t pmd);
 
 void ptdump_walk_pgd_level(struct seq_file *m, struct mm_struct *mm);
 void ptdump_walk_pgd_level_debugfs(struct seq_file *m, struct mm_struct *mm,
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 4b3ca5ade2fd..7d7a064af6ff 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -39,6 +39,8 @@ void vsmp_init(void);
 static inline void vsmp_init(void) { }
 #endif
 
+struct pt_regs;
+
 void setup_bios_corruption_check(void);
 void early_platform_quirks(void);
 
@@ -49,8 +51,8 @@ extern void i386_reserve_resources(void);
 extern unsigned long __startup_64(unsigned long physaddr, struct boot_params *bp);
 extern unsigned long __startup_secondary_64(void);
 extern void startup_64_setup_env(unsigned long physbase);
-extern int early_make_pgtable(unsigned long address);
 extern void early_setup_idt(void);
+extern void __init do_early_exception(struct pt_regs *regs, int trapnr);
 
 #ifdef CONFIG_X86_INTEL_MID
 extern void x86_intel_mid_early_setup(void);
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 7bfd5c27c773..4282dac694c3 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -38,6 +38,8 @@
 #include <asm/fixmap.h>
 #include <asm/realmode.h>
 #include <asm/desc.h>
+#include <asm/extable.h>
+#include <asm/trapnr.h>
 
 /*
  * Manage page tables very early on.
@@ -317,7 +319,7 @@ static void __init reset_early_page_tables(void)
 }
 
 /* Create a new PMD entry */
-int __init __early_make_pgtable(unsigned long address, pmdval_t pmd)
+bool __init __early_make_pgtable(unsigned long address, pmdval_t pmd)
 {
 	unsigned long physaddr = address - __PAGE_OFFSET;
 	pgdval_t pgd, *pgd_p;
@@ -327,7 +329,7 @@ int __init __early_make_pgtable(unsigned long address, pmdval_t pmd)
 
 	/* Invalid address or early pgt is done ?  */
 	if (physaddr >= MAXMEM || read_cr3_pa() != __pa_nodebug(early_top_pgt))
-		return -1;
+		return false;
 
 again:
 	pgd_p = &early_top_pgt[pgd_index(address)].pgd;
@@ -384,10 +386,10 @@ int __init __early_make_pgtable(unsigned long address, pmdval_t pmd)
 	}
 	pmd_p[pmd_index(address)] = pmd;
 
-	return 0;
+	return true;
 }
 
-int __init early_make_pgtable(unsigned long address)
+static bool __init early_make_pgtable(unsigned long address)
 {
 	unsigned long physaddr = address - __PAGE_OFFSET;
 	pmdval_t pmd;
@@ -397,6 +399,15 @@ int __init early_make_pgtable(unsigned long address)
 	return __early_make_pgtable(address, pmd);
 }
 
+void __init do_early_exception(struct pt_regs *regs, int trapnr)
+{
+	if (trapnr == X86_TRAP_PF &&
+	    early_make_pgtable(native_read_cr2()))
+		return;
+
+	early_fixup_exception(regs, trapnr);
+}
+
 /* Don't add a printk in there. printk relies on the PDA which is not initialized 
    yet. */
 static void __init clear_bss(void)
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 1de09b58e578..3b40ec44a67d 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -341,18 +341,9 @@ SYM_CODE_START_LOCAL(early_idt_handler_common)
 	pushq %r15				/* pt_regs->r15 */
 	UNWIND_HINT_REGS
 
-	cmpq $14,%rsi		/* Page fault? */
-	jnz 10f
-	GET_CR2_INTO(%rdi)	/* can clobber %rax if pv */
-	call early_make_pgtable
-	andl %eax,%eax
-	jz 20f			/* All good */
-
-10:
 	movq %rsp,%rdi		/* RDI = pt_regs; RSI is already trapnr */
-	call early_fixup_exception
+	call do_early_exception
 
-20:
 	decl early_recursion_flag(%rip)
 	jmp restore_regs_and_return_to_kernel
 SYM_CODE_END(early_idt_handler_common)
-- 
2.28.0

