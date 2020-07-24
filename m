Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CF422CA7E
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 18:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgGXQEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 12:04:11 -0400
Received: from 8bytes.org ([81.169.241.247]:59394 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbgGXQEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 12:04:10 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 82F65F3C;
        Fri, 24 Jul 2020 18:04:07 +0200 (CEST)
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
Subject: [PATCH v5 21/75] x86/boot/compressed/64: Add set_page_en/decrypted() helpers
Date:   Fri, 24 Jul 2020 18:02:42 +0200
Message-Id: <20200724160336.5435-22-joro@8bytes.org>
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

The functions are needed to map the GHCB for SEV-ES guests. The GHCB is
used for communication with the hypervisor, so its content must not be
encrypted. After the GHCB is not needed anymore it must be mapped
encrypted again so that the running kernel image can safely re-use the
memory.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/ident_map_64.c | 133 ++++++++++++++++++++++++
 arch/x86/boot/compressed/misc.h         |   2 +
 2 files changed, 135 insertions(+)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index aa91bebc0fe9..05742f641a06 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -24,6 +24,7 @@
 
 /* These actually do the work of building the kernel identity maps. */
 #include <linux/pgtable.h>
+#include <asm/cmpxchg.h>
 #include <asm/trap_pf.h>
 #include <asm/trapnr.h>
 #include <asm/init.h>
@@ -165,6 +166,138 @@ void finalize_identity_maps(void)
 	write_cr3(top_level_pgt);
 }
 
+static pte_t *split_large_pmd(struct x86_mapping_info *info,
+			      pmd_t *pmdp, unsigned long __address)
+{
+	unsigned long page_flags;
+	unsigned long address;
+	pte_t *pte;
+	pmd_t pmd;
+	int i;
+
+	pte = (pte_t *)info->alloc_pgt_page(info->context);
+	if (!pte)
+		return NULL;
+
+	address     = __address & PMD_MASK;
+	/* No large page - clear PSE flag */
+	page_flags  = info->page_flag & ~_PAGE_PSE;
+
+	/* Populate the PTEs */
+	for (i = 0; i < PTRS_PER_PMD; i++) {
+		set_pte(&pte[i], __pte(address | page_flags));
+		address += PAGE_SIZE;
+	}
+
+	/*
+	 * Ideally we need to clear the large PMD first and do a TLB
+	 * flush before we write the new PMD. But the 2M range of the
+	 * PMD might contain the code we execute and/or the stack
+	 * we are on, so we can't do that. But that should be safe here
+	 * because we are going from large to small mappings and we are
+	 * also the only user of the page-table, so there is no chance
+	 * of a TLB multihit.
+	 */
+	pmd = __pmd((unsigned long)pte | info->kernpg_flag);
+	set_pmd(pmdp, pmd);
+	/* Flush TLB to establish the new PMD */
+	write_cr3(top_level_pgt);
+
+	return pte + pte_index(__address);
+}
+
+static void clflush_page(unsigned long address)
+{
+	unsigned int flush_size;
+	char *cl, *start, *end;
+
+	/*
+	 * Hardcode cl-size to 64 - CPUID can't be used here because that might
+	 * cause another #VC exception and the GHCB is not ready to use yet.
+	 */
+	flush_size = 64;
+	start      = (char *)(address & PAGE_MASK);
+	end        = start + PAGE_SIZE;
+
+	/*
+	 * First make sure there are no pending writes on the cache-lines to
+	 * flush.
+	 */
+	asm volatile("mfence" : : : "memory");
+
+	for (cl = start; cl != end; cl += flush_size)
+		clflush(cl);
+}
+
+static int set_clr_page_flags(struct x86_mapping_info *info,
+			      unsigned long address,
+			      pteval_t set, pteval_t clr)
+{
+	pgd_t *pgdp = (pgd_t *)top_level_pgt;
+	p4d_t *p4dp;
+	pud_t *pudp;
+	pmd_t *pmdp;
+	pte_t *ptep, pte;
+
+	/*
+	 * First make sure there is a PMD mapping for 'address'.
+	 * It should already exist, but keep things generic.
+	 *
+	 * To map the page just read from it and fault it in if there is no
+	 * mapping yet. add_identity_map() can't be called here because that
+	 * would unconditionally map the address on PMD level, destroying any
+	 * PTE-level mappings that might already exist. Use assembly here so
+	 * the access won't be optimized away.
+	 */
+	asm volatile("mov %[address], %%r9"
+		     :: [address] "g" (*(unsigned long *)address)
+		     : "r9", "memory");
+
+	/*
+	 * The page is mapped at least with PMD size - so skip checks and walk
+	 * directly to the PMD.
+	 */
+	p4dp = p4d_offset(pgdp, address);
+	pudp = pud_offset(p4dp, address);
+	pmdp = pmd_offset(pudp, address);
+
+	if (pmd_large(*pmdp))
+		ptep = split_large_pmd(info, pmdp, address);
+	else
+		ptep = pte_offset_kernel(pmdp, address);
+
+	if (!ptep)
+		return -ENOMEM;
+
+	/*
+	 * Changing encryption attributes of a page requires to flush it from
+	 * the caches.
+	 */
+	if ((set | clr) & _PAGE_ENC)
+		clflush_page(address);
+
+	/* Update PTE */
+	pte = *ptep;
+	pte = pte_set_flags(pte, set);
+	pte = pte_clear_flags(pte, clr);
+	set_pte(ptep, pte);
+
+	/* Flush TLB after changing encryption attribute */
+	write_cr3(top_level_pgt);
+
+	return 0;
+}
+
+int set_page_decrypted(unsigned long address)
+{
+	return set_clr_page_flags(&mapping_info, address, 0, _PAGE_ENC);
+}
+
+int set_page_encrypted(unsigned long address)
+{
+	return set_clr_page_flags(&mapping_info, address, _PAGE_ENC, 0);
+}
+
 static void do_pf_error(const char *msg, unsigned long error_code,
 			unsigned long address, unsigned long ip)
 {
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 65da40777bc1..5e569e8a7d75 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -98,6 +98,8 @@ static inline void choose_random_location(unsigned long input,
 #endif
 
 #ifdef CONFIG_X86_64
+extern int set_page_decrypted(unsigned long address);
+extern int set_page_encrypted(unsigned long address);
 extern unsigned char _pgtable[];
 #endif
 
-- 
2.27.0

