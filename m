Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E735918AFC4
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgCSJTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:19:50 -0400
Received: from 8bytes.org ([81.169.241.247]:52110 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbgCSJO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:28 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8CEAB2DF; Thu, 19 Mar 2020 10:14:18 +0100 (CET)
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
Subject: [PATCH 14/70] x86/boot/compressed/64: Add page-fault handler
Date:   Thu, 19 Mar 2020 10:13:11 +0100
Message-Id: <20200319091407.1481-15-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Install a page-fault handler to add an identity mapping to addresses
not yet mapped. Also do some checking whether the error code is sane.

This makes non SEV-ES machines use the exception handling
infrastructure in the pre-decompressions boot code too, making it less
likely to break in the future.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/ident_map_64.c    | 38 ++++++++++++++++++++++
 arch/x86/boot/compressed/idt_64.c          |  2 ++
 arch/x86/boot/compressed/idt_handlers_64.S |  2 ++
 arch/x86/boot/compressed/misc.h            |  6 ++++
 4 files changed, 48 insertions(+)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index 3a2115582920..0865d181b85d 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -19,11 +19,13 @@
 /* No PAGE_TABLE_ISOLATION support needed either: */
 #undef CONFIG_PAGE_TABLE_ISOLATION
 
+#include "error.h"
 #include "misc.h"
 
 /* These actually do the work of building the kernel identity maps. */
 #include <asm/init.h>
 #include <asm/pgtable.h>
+#include <asm/trap_defs.h>
 /* Use the static base for this part of the boot process */
 #undef __PAGE_OFFSET
 #define __PAGE_OFFSET __PAGE_OFFSET_BASE
@@ -163,3 +165,39 @@ void finalize_identity_maps(void)
 {
 	write_cr3(top_level_pgt);
 }
+
+static void pf_error(unsigned long error_code, unsigned long address,
+		     struct pt_regs *regs)
+{
+	error_putstr("Unexpected page-fault:");
+	error_putstr("\nError Code: ");
+	error_puthex(error_code);
+	error_putstr("\nCR2: 0x");
+	error_puthex(address);
+	error_putstr("\nRIP relative to _head: 0x");
+	error_puthex(regs->ip - (unsigned long)_head);
+	error_putstr("\n");
+
+	error("Stopping.\n");
+}
+
+void do_boot_page_fault(struct pt_regs *regs)
+{
+	unsigned long address = native_read_cr2();
+	unsigned long error_code = regs->orig_ax;
+
+	/*
+	 * Check for unexpected error codes. Unexpected are:
+	 *	- Faults on present pages
+	 *	- User faults
+	 *	- Reserved bits set
+	 */
+	if (error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD))
+		pf_error(error_code, address, regs);
+
+	/*
+	 * Error code is sane - now identity map the 2M region around
+	 * the faulting address.
+	 */
+	add_identity_map(address & PMD_MASK, PMD_SIZE);
+}
diff --git a/arch/x86/boot/compressed/idt_64.c b/arch/x86/boot/compressed/idt_64.c
index 46ecea671b90..84ba57d9d436 100644
--- a/arch/x86/boot/compressed/idt_64.c
+++ b/arch/x86/boot/compressed/idt_64.c
@@ -39,5 +39,7 @@ void load_stage2_idt(void)
 {
 	boot_idt_desc.address = (unsigned long)boot_idt;
 
+	set_idt_entry(X86_TRAP_PF, boot_pf_handler);
+
 	load_boot_idt(&boot_idt_desc);
 }
diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
index 3d86ab35ef52..bfb3fc5aa144 100644
--- a/arch/x86/boot/compressed/idt_handlers_64.S
+++ b/arch/x86/boot/compressed/idt_handlers_64.S
@@ -73,3 +73,5 @@ SYM_FUNC_END(\name)
 
 	.text
 	.code64
+
+EXCEPTION_HANDLER	boot_pf_handler do_boot_page_fault error_code=1
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 3a030a878d53..eff4ed0b1cea 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -37,6 +37,9 @@
 #define memptr unsigned
 #endif
 
+/* boot/compressed/vmlinux start and end markers */
+extern char _head[], _end[];
+
 /* misc.c */
 extern memptr free_mem_ptr;
 extern memptr free_mem_end_ptr;
@@ -146,4 +149,7 @@ extern pteval_t __default_kernel_pte_mask;
 extern gate_desc boot_idt[BOOT_IDT_ENTRIES];
 extern struct desc_ptr boot_idt_desc;
 
+/* IDT Entry Points */
+void boot_pf_handler(void);
+
 #endif /* BOOT_COMPRESSED_MISC_H */
-- 
2.17.1

