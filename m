Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DBF1BC341
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgD1PSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:18:00 -0400
Received: from 8bytes.org ([81.169.241.247]:37386 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbgD1PR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:17:57 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B4E01E92; Tue, 28 Apr 2020 17:17:44 +0200 (CEST)
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
Subject: [PATCH v3 14/75] x86/boot/compressed/64: Rename kaslr_64.c to ident_map_64.c
Date:   Tue, 28 Apr 2020 17:16:24 +0200
Message-Id: <20200428151725.31091-15-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The file contains only code related to identity mapped page-tables.
Rename the file and compile it always in.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/Makefile                    |  2 +-
 .../boot/compressed/{kaslr_64.c => ident_map_64.c}   | 12 ++++++++++++
 arch/x86/boot/compressed/kaslr.c                     |  9 ---------
 arch/x86/boot/compressed/misc.h                      |  8 ++++++++
 4 files changed, 21 insertions(+), 10 deletions(-)
 rename arch/x86/boot/compressed/{kaslr_64.c => ident_map_64.c} (93%)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 954842333d1d..c6909d10a6b9 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -81,7 +81,7 @@ vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/kernel_info.o $(obj)/head_$(BITS).o
 vmlinux-objs-$(CONFIG_EARLY_PRINTK) += $(obj)/early_serial_console.o
 vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/kaslr.o
 ifdef CONFIG_X86_64
-	vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/kaslr_64.o
+	vmlinux-objs-y += $(obj)/ident_map_64.o
 	vmlinux-objs-y += $(obj)/idt_64.o $(obj)/idt_handlers_64.o
 	vmlinux-objs-y += $(obj)/mem_encrypt.o
 	vmlinux-objs-y += $(obj)/pgtable_64.o
diff --git a/arch/x86/boot/compressed/kaslr_64.c b/arch/x86/boot/compressed/ident_map_64.c
similarity index 93%
rename from arch/x86/boot/compressed/kaslr_64.c
rename to arch/x86/boot/compressed/ident_map_64.c
index 9557c5a15b91..3a2115582920 100644
--- a/arch/x86/boot/compressed/kaslr_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -29,6 +29,18 @@
 #define __PAGE_OFFSET __PAGE_OFFSET_BASE
 #include "../../mm/ident_map.c"
 
+#ifdef CONFIG_X86_5LEVEL
+unsigned int __pgtable_l5_enabled;
+unsigned int pgdir_shift = 39;
+unsigned int ptrs_per_p4d = 1;
+#endif
+
+/* Used by PAGE_KERN* macros: */
+pteval_t __default_kernel_pte_mask __read_mostly = ~0;
+
+/* Used by pgtable.h asm code to force instruction serialization. */
+unsigned long __force_order;
+
 /* Used to track our page table allocation area. */
 struct alloc_pgt_data {
 	unsigned char *pgt_buf;
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index d7408af55738..7c61a8c5b9cf 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -43,17 +43,8 @@
 #define STATIC
 #include <linux/decompress/mm.h>
 
-#ifdef CONFIG_X86_5LEVEL
-unsigned int __pgtable_l5_enabled;
-unsigned int pgdir_shift __ro_after_init = 39;
-unsigned int ptrs_per_p4d __ro_after_init = 1;
-#endif
-
 extern unsigned long get_cmd_line_ptr(void);
 
-/* Used by PAGE_KERN* macros: */
-pteval_t __default_kernel_pte_mask __read_mostly = ~0;
-
 /* Simplified build-specific string for starting entropy. */
 static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 062ae3ae6930..3a030a878d53 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -134,6 +134,14 @@ int count_immovable_mem_regions(void);
 static inline int count_immovable_mem_regions(void) { return 0; }
 #endif
 
+/* ident_map_64.c */
+#ifdef CONFIG_X86_5LEVEL
+extern unsigned int __pgtable_l5_enabled, pgdir_shift, ptrs_per_p4d;
+#endif
+
+/* Used by PAGE_KERN* macros: */
+extern pteval_t __default_kernel_pte_mask;
+
 /* idt_64.c */
 extern gate_desc boot_idt[BOOT_IDT_ENTRIES];
 extern struct desc_ptr boot_idt_desc;
-- 
2.17.1

