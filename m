Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263F61BC296
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgD1PSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:18:01 -0400
Received: from 8bytes.org ([81.169.241.247]:37386 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgD1PR7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:17:59 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 3FEA2EA5; Tue, 28 Apr 2020 17:17:45 +0200 (CEST)
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
Subject: [PATCH v3 17/75] x86/boot/compressed/64: Don't pre-map memory in KASLR code
Date:   Tue, 28 Apr 2020 17:16:27 +0200
Message-Id: <20200428151725.31091-18-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

With the page-fault handler in place the identity mapping can be built
on-demand. So remove the code which manually creates the mappings and
unexport/remove the functions used for it.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/ident_map_64.c | 16 ++--------------
 arch/x86/boot/compressed/kaslr.c        | 24 +-----------------------
 arch/x86/boot/compressed/misc.h         | 10 ----------
 3 files changed, 3 insertions(+), 47 deletions(-)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index aa55e7b5cade..9f6606184797 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -89,11 +89,9 @@ phys_addr_t physical_mask = (1ULL << __PHYSICAL_MASK_SHIFT) - 1;
 static struct x86_mapping_info mapping_info;
 
 /*
- * Adds the specified range to what will become the new identity mappings.
- * Once all ranges have been added, the new mapping is activated by calling
- * finalize_identity_maps() below.
+ * Adds the specified range to the identity mappings.
  */
-void add_identity_map(unsigned long start, unsigned long size)
+static void add_identity_map(unsigned long start, unsigned long size)
 {
 	unsigned long end = start + size;
 
@@ -165,16 +163,6 @@ void initialize_identity_maps(void)
 	write_cr3(top_level_pgt);
 }
 
-/*
- * This switches the page tables to the new level4 that has been built
- * via calls to add_identity_map() above. If booted via startup_32(),
- * this is effectively a no-op.
- */
-void finalize_identity_maps(void)
-{
-	write_cr3(top_level_pgt);
-}
-
 void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	unsigned long address = native_read_cr2();
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 856dc1c9bb0d..c466fb738de0 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -399,8 +399,6 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	 */
 	mem_avoid[MEM_AVOID_ZO_RANGE].start = input;
 	mem_avoid[MEM_AVOID_ZO_RANGE].size = (output + init_size) - input;
-	add_identity_map(mem_avoid[MEM_AVOID_ZO_RANGE].start,
-			 mem_avoid[MEM_AVOID_ZO_RANGE].size);
 
 	/* Avoid initrd. */
 	initrd_start  = (u64)boot_params->ext_ramdisk_image << 32;
@@ -420,14 +418,10 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 		;
 	mem_avoid[MEM_AVOID_CMDLINE].start = cmd_line;
 	mem_avoid[MEM_AVOID_CMDLINE].size = cmd_line_size;
-	add_identity_map(mem_avoid[MEM_AVOID_CMDLINE].start,
-			 mem_avoid[MEM_AVOID_CMDLINE].size);
 
 	/* Avoid boot parameters. */
 	mem_avoid[MEM_AVOID_BOOTPARAMS].start = (unsigned long)boot_params;
 	mem_avoid[MEM_AVOID_BOOTPARAMS].size = sizeof(*boot_params);
-	add_identity_map(mem_avoid[MEM_AVOID_BOOTPARAMS].start,
-			 mem_avoid[MEM_AVOID_BOOTPARAMS].size);
 
 	/* We don't need to set a mapping for setup_data. */
 
@@ -436,11 +430,6 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 
 	/* Enumerate the immovable memory regions */
 	num_immovable_mem = count_immovable_mem_regions();
-
-#ifdef CONFIG_X86_VERBOSE_BOOTUP
-	/* Make sure video RAM can be used. */
-	add_identity_map(0, PMD_SIZE);
-#endif
 }
 
 /*
@@ -919,19 +908,8 @@ void choose_random_location(unsigned long input,
 		warn("Physical KASLR disabled: no suitable memory region!");
 	} else {
 		/* Update the new physical address location. */
-		if (*output != random_addr) {
-			add_identity_map(random_addr, output_size);
+		if (*output != random_addr)
 			*output = random_addr;
-		}
-
-		/*
-		 * This loads the identity mapping page table.
-		 * This should only be done if a new physical address
-		 * is found for the kernel, otherwise we should keep
-		 * the old page table to make it be like the "nokaslr"
-		 * case.
-		 */
-		finalize_identity_maps();
 	}
 
 
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 345c90fbc500..ea6174bad699 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -98,17 +98,7 @@ static inline void choose_random_location(unsigned long input,
 #endif
 
 #ifdef CONFIG_X86_64
-void initialize_identity_maps(void);
-void add_identity_map(unsigned long start, unsigned long size);
-void finalize_identity_maps(void);
 extern unsigned char _pgtable[];
-#else
-static inline void initialize_identity_maps(void)
-{ }
-static inline void add_identity_map(unsigned long start, unsigned long size)
-{ }
-static inline void finalize_identity_maps(void)
-{ }
 #endif
 
 #ifdef CONFIG_EARLY_PRINTK
-- 
2.17.1

