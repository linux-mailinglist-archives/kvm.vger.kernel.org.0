Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D112159130
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbgBKN6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:58:54 -0500
Received: from 8bytes.org ([81.169.241.247]:51876 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbgBKNxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:16 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 2839268C; Tue, 11 Feb 2020 14:53:09 +0100 (CET)
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
Subject: [PATCH 11/62] x86/boot/compressed/64: Always switch to own page-table
Date:   Tue, 11 Feb 2020 14:52:05 +0100
Message-Id: <20200211135256.24617-12-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When booted through startup_64 the kernel keeps running on the EFI
page-table until the KASLR code sets up its own page-table. Without
KASLR the pre-decompression boot code never switches off the EFI
page-table. Change that by unconditionally switching to our own
page-table once the kernel is relocated.

This makes sure we can make changes to the mapping when necessary, for
example map pages unencrypted in SEV and SEV-ES guests.

Also remove the debug_putstr() calls in initialize_identity_maps()
because the function now runs before console_init() is called.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/head_64.S      |  3 +-
 arch/x86/boot/compressed/ident_map_64.c | 51 +++++++++++++++----------
 arch/x86/boot/compressed/kaslr.c        |  3 --
 3 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index d27a9ce1bcb0..5164d2e8631a 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -491,10 +491,11 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
 	rep	stosq
 
 /*
- * Load stage2 IDT
+ * Load stage2 IDT and switch to our own page-table
  */
 	pushq	%rsi
 	call	load_stage2_idt
+	call	initialize_identity_maps
 	popq	%rsi
 
 /*
diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index 0865d181b85d..6a3890caaa19 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -88,9 +88,31 @@ phys_addr_t physical_mask = (1ULL << __PHYSICAL_MASK_SHIFT) - 1;
  */
 static struct x86_mapping_info mapping_info;
 
+/*
+ * Adds the specified range to what will become the new identity mappings.
+ * Once all ranges have been added, the new mapping is activated by calling
+ * finalize_identity_maps() below.
+ */
+void add_identity_map(unsigned long start, unsigned long size)
+{
+	unsigned long end = start + size;
+
+	/* Align boundary to 2M. */
+	start = round_down(start, PMD_SIZE);
+	end = round_up(end, PMD_SIZE);
+	if (start >= end)
+		return;
+
+	/* Build the mapping. */
+	kernel_ident_mapping_init(&mapping_info, (pgd_t *)top_level_pgt,
+				  start, end);
+}
+
 /* Locates and clears a region for a new top level page table. */
 void initialize_identity_maps(void)
 {
+	unsigned long start, size;
+
 	/* If running as an SEV guest, the encryption mask is required. */
 	set_sev_encryption_mask();
 
@@ -123,37 +145,24 @@ void initialize_identity_maps(void)
 	 */
 	top_level_pgt = read_cr3_pa();
 	if (p4d_offset((pgd_t *)top_level_pgt, 0) == (p4d_t *)_pgtable) {
-		debug_putstr("booted via startup_32()\n");
 		pgt_data.pgt_buf = _pgtable + BOOT_INIT_PGT_SIZE;
 		pgt_data.pgt_buf_size = BOOT_PGT_SIZE - BOOT_INIT_PGT_SIZE;
 		memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
 	} else {
-		debug_putstr("booted via startup_64()\n");
 		pgt_data.pgt_buf = _pgtable;
 		pgt_data.pgt_buf_size = BOOT_PGT_SIZE;
 		memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
 		top_level_pgt = (unsigned long)alloc_pgt_page(&pgt_data);
 	}
-}
 
-/*
- * Adds the specified range to what will become the new identity mappings.
- * Once all ranges have been added, the new mapping is activated by calling
- * finalize_identity_maps() below.
- */
-void add_identity_map(unsigned long start, unsigned long size)
-{
-	unsigned long end = start + size;
-
-	/* Align boundary to 2M. */
-	start = round_down(start, PMD_SIZE);
-	end = round_up(end, PMD_SIZE);
-	if (start >= end)
-		return;
-
-	/* Build the mapping. */
-	kernel_ident_mapping_init(&mapping_info, (pgd_t *)top_level_pgt,
-				  start, end);
+	/*
+	 * New page-table is set up - map the kernel image and load it
+	 * into cr3.
+	 */
+	start = (unsigned long)_head;
+	size  = _end - _head;
+	add_identity_map(start, size);
+	write_cr3(top_level_pgt);
 }
 
 /*
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 7c61a8c5b9cf..856dc1c9bb0d 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -903,9 +903,6 @@ void choose_random_location(unsigned long input,
 
 	boot_params->hdr.loadflags |= KASLR_FLAG;
 
-	/* Prepare to add new identity pagetables on demand. */
-	initialize_identity_maps();
-
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init(input, input_size, *output);
 
-- 
2.17.1

