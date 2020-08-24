Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C260E24F78B
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgHXJQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:16:47 -0400
Received: from 8bytes.org ([81.169.241.247]:37260 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbgHXIz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 04:55:59 -0400
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 26B1A915;
        Mon, 24 Aug 2020 10:55:54 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v6 15/76] x86/boot/compressed/64: Add page-fault handler
Date:   Mon, 24 Aug 2020 10:54:10 +0200
Message-Id: <20200824085511.7553-16-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824085511.7553-1-joro@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20200724160336.5435-15-joro@8bytes.org
---
 arch/x86/boot/compressed/ident_map_64.c    | 39 ++++++++++++++++++++++
 arch/x86/boot/compressed/idt_64.c          |  2 ++
 arch/x86/boot/compressed/idt_handlers_64.S |  2 ++
 arch/x86/boot/compressed/misc.h            |  6 ++++
 4 files changed, 49 insertions(+)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index d9932a133ac9..e3d980ae9c2b 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -19,10 +19,13 @@
 /* No PAGE_TABLE_ISOLATION support needed either: */
 #undef CONFIG_PAGE_TABLE_ISOLATION
 
+#include "error.h"
 #include "misc.h"
 
 /* These actually do the work of building the kernel identity maps. */
 #include <linux/pgtable.h>
+#include <asm/trap_pf.h>
+#include <asm/trapnr.h>
 #include <asm/init.h>
 /* Use the static base for this part of the boot process */
 #undef __PAGE_OFFSET
@@ -160,3 +163,39 @@ void finalize_identity_maps(void)
 {
 	write_cr3(top_level_pgt);
 }
+
+static void do_pf_error(const char *msg, unsigned long error_code,
+			unsigned long address, unsigned long ip)
+{
+	error_putstr(msg);
+
+	error_putstr("\nError Code: ");
+	error_puthex(error_code);
+	error_putstr("\nCR2: 0x");
+	error_puthex(address);
+	error_putstr("\nRIP relative to _head: 0x");
+	error_puthex(ip - (unsigned long)_head);
+	error_putstr("\n");
+
+	error("Stopping.\n");
+}
+
+void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	unsigned long address = native_read_cr2();
+
+	/*
+	 * Check for unexpected error codes. Unexpected are:
+	 *	- Faults on present pages
+	 *	- User faults
+	 *	- Reserved bits set
+	 */
+	if (error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD))
+		do_pf_error("Unexpected page-fault:", error_code, address, regs->ip);
+
+	/*
+	 * Error code is sane - now identity map the 2M region around
+	 * the faulting address.
+	 */
+	add_identity_map(address & PMD_MASK, PMD_SIZE);
+}
diff --git a/arch/x86/boot/compressed/idt_64.c b/arch/x86/boot/compressed/idt_64.c
index 082cd6bca033..5f083092a86d 100644
--- a/arch/x86/boot/compressed/idt_64.c
+++ b/arch/x86/boot/compressed/idt_64.c
@@ -40,5 +40,7 @@ void load_stage2_idt(void)
 {
 	boot_idt_desc.address = (unsigned long)boot_idt;
 
+	set_idt_entry(X86_TRAP_PF, boot_page_fault);
+
 	load_boot_idt(&boot_idt_desc);
 }
diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
index 36dee2f40a8b..b20e57504a94 100644
--- a/arch/x86/boot/compressed/idt_handlers_64.S
+++ b/arch/x86/boot/compressed/idt_handlers_64.S
@@ -68,3 +68,5 @@ SYM_FUNC_END(\name)
 
 	.text
 	.code64
+
+EXCEPTION_HANDLER	boot_page_fault do_boot_page_fault error_code=1
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 98b7a1df9c59..f0e199174c5f 100644
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
+void boot_page_fault(void);
+
 #endif /* BOOT_COMPRESSED_MISC_H */
-- 
2.28.0

