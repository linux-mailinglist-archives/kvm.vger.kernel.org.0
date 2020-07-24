Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBE922CA87
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 18:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgGXQKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 12:10:42 -0400
Received: from 8bytes.org ([81.169.241.247]:59268 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726895AbgGXQEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 12:04:07 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id CBDE9E2D;
        Fri, 24 Jul 2020 18:04:04 +0200 (CEST)
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
Subject: [PATCH v5 16/75] x86/boot/compressed/64: Don't pre-map memory in KASLR code
Date:   Fri, 24 Jul 2020 18:02:37 +0200
Message-Id: <20200724160336.5435-17-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200724160336.5435-1-joro@8bytes.org>
References: <20200724160336.5435-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

With the page-fault handler in place the identity mapping can be built
on-demand. So remove the code which manually creates the mappings and
unexport/remove the functions used for it.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/ident_map_64.c |  6 ++----
 arch/x86/boot/compressed/kaslr.c        | 24 +-----------------------
 arch/x86/boot/compressed/misc.h         | 10 ----------
 3 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index ecf9353b064d..c63257bf8373 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -87,11 +87,9 @@ phys_addr_t physical_mask = (1ULL << __PHYSICAL_MASK_SHIFT) - 1;
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
2.27.0

