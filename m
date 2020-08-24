Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF4224F785
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgHXJPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730443AbgHXI4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:00 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D587DC061573;
        Mon, 24 Aug 2020 01:55:59 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 9F74997A;
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
Subject: [PATCH v6 16/76] x86/boot/compressed/64: Always switch to own page-table
Date:   Mon, 24 Aug 2020 10:54:11 +0200
Message-Id: <20200824085511.7553-17-joro@8bytes.org>
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

When booted through startup_64 the kernel keeps running on the EFI
page-table until the KASLR code sets up its own page-table. Without
KASLR the pre-decompression boot code never switches off the EFI
page-table. Change that by unconditionally switching to a kernel
controlled page-table after relocation.

This makes sure we can make changes to the mapping when necessary, for
example map pages unencrypted in SEV and SEV-ES guests.

Also remove the debug_putstr() calls in initialize_identity_maps()
because the function now runs before console_init() is called.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20200724160336.5435-16-joro@8bytes.org
---
 arch/x86/boot/compressed/head_64.S      |  3 +-
 arch/x86/boot/compressed/ident_map_64.c | 51 +++++++++++++++----------
 arch/x86/boot/compressed/kaslr.c        |  3 --
 3 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 260c7940f960..013b29921836 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -533,10 +533,11 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
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
index e3d980ae9c2b..ecf9353b064d 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -86,9 +86,31 @@ phys_addr_t physical_mask = (1ULL << __PHYSICAL_MASK_SHIFT) - 1;
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
 
@@ -121,37 +143,24 @@ void initialize_identity_maps(void)
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
index 0b1551f19920..9016f2268aa7 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -861,9 +861,6 @@ void choose_random_location(unsigned long input,
 
 	boot_params->hdr.loadflags |= KASLR_FLAG;
 
-	/* Prepare to add new identity pagetables on demand. */
-	initialize_identity_maps();
-
 	if (IS_ENABLED(CONFIG_X86_32))
 		mem_limit = KERNEL_IMAGE_SIZE;
 	else
-- 
2.28.0

