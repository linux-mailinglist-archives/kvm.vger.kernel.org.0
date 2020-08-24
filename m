Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40F424F69D
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbgHXJB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729884AbgHXI4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:40 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C552AC061575;
        Mon, 24 Aug 2020 01:56:39 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id E9D8B1823;
        Mon, 24 Aug 2020 10:56:31 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: [PATCH v6 75/76] x86/efi: Add GHCB mappings when SEV-ES is active
Date:   Mon, 24 Aug 2020 10:55:10 +0200
Message-Id: <20200824085511.7553-76-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824085511.7553-1-joro@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Calling down to EFI runtime services can result in the firmware performing
VMGEXIT calls. The firmware is likely to use the GHCB of the OS (e.g., for
setting EFI variables), so each GHCB in the system needs to be identity
mapped in the EFI page tables, as unencrypted, to avoid page faults.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: Moved GHCB mapping loop to sev-es.c ]
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20200724160336.5435-75-joro@8bytes.org
---
 arch/x86/boot/compressed/sev-es.c |  1 +
 arch/x86/include/asm/sev-es.h     |  2 ++
 arch/x86/kernel/sev-es.c          | 30 ++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi_64.c    | 10 ++++++++++
 4 files changed, 43 insertions(+)

diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
index 1ce144e0ddc3..b522c18c0588 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -12,6 +12,7 @@
  */
 #include "misc.h"
 
+#include <asm/pgtable_types.h>
 #include <asm/sev-es.h>
 #include <asm/trapnr.h>
 #include <asm/trap_pf.h>
diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index 21fdee11ac83..f22c4531624c 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -101,11 +101,13 @@ static __always_inline void sev_es_nmi_complete(void)
 	if (static_branch_unlikely(&sev_es_enable_key))
 		__sev_es_nmi_complete();
 }
+extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
 static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
 static inline void sev_es_nmi_complete(void) { }
+static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
 #endif
 
 #endif
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 7202d2f5deb8..2d73f5abe04b 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -495,6 +495,36 @@ int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
 	return 0;
 }
 
+/*
+ * This is needed by the OVMF UEFI firmware which will use whatever it finds in
+ * the GHCB MSR as its GHCB to talk to the hypervisor. So make sure the per-cpu
+ * runtime GHCBs used by the kernel are also mapped in the EFI page-table.
+ */
+int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
+{
+	struct sev_es_runtime_data *data;
+	unsigned long address, pflags;
+	int cpu;
+	u64 pfn;
+
+	if (!sev_es_active())
+		return 0;
+
+	pflags = _PAGE_NX | _PAGE_RW;
+
+	for_each_possible_cpu(cpu) {
+		data = per_cpu(runtime_data, cpu);
+
+		address = __pa(&data->ghcb_page);
+		pfn = address >> PAGE_SHIFT;
+
+		if (kernel_map_pages_in_pgd(pgd, pfn, address, 1, pflags))
+			return 1;
+	}
+
+	return 0;
+}
+
 static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct pt_regs *regs = ctxt->regs;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6af4da1149ba..8f5759df7776 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -47,6 +47,7 @@
 #include <asm/realmode.h>
 #include <asm/time.h>
 #include <asm/pgalloc.h>
+#include <asm/sev-es.h>
 
 /*
  * We allocate runtime services regions top-down, starting from -4G, i.e.
@@ -229,6 +230,15 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 		return 1;
 	}
 
+	/*
+	 * When SEV-ES is active, the GHCB as set by the kernel will be used
+	 * by firmware. Create a 1:1 unencrypted mapping for each GHCB.
+	 */
+	if (sev_es_efi_map_ghcbs(pgd)) {
+		pr_err("Failed to create 1:1 mapping for the GHCBs!\n");
+		return 1;
+	}
+
 	/*
 	 * When making calls to the firmware everything needs to be 1:1
 	 * mapped and addressable with 32-bit pointers. Map the kernel
-- 
2.28.0

