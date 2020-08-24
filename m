Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA1024F773
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbgHXJOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:14:51 -0400
Received: from 8bytes.org ([81.169.241.247]:37490 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730445AbgHXI4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:02 -0400
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 18D91DE0;
        Mon, 24 Aug 2020 10:55:59 +0200 (CEST)
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
Subject: [PATCH v6 24/76] x86/boot/compressed/64: Unmap GHCB page before booting the kernel
Date:   Mon, 24 Aug 2020 10:54:19 +0200
Message-Id: <20200824085511.7553-25-joro@8bytes.org>
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

Force a page-fault on any further accesses to the GHCB page when they
shouldn't happen anymore. This will catch the bugs where a #VC exception
is raised when no one is expected anymore.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20200724160336.5435-24-joro@8bytes.org
---
 arch/x86/boot/compressed/ident_map_64.c | 17 +++++++++++++++--
 arch/x86/boot/compressed/misc.h         |  6 ++++++
 arch/x86/boot/compressed/sev-es.c       | 14 ++++++++++++++
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index 05742f641a06..063a60edcf99 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -298,6 +298,11 @@ int set_page_encrypted(unsigned long address)
 	return set_clr_page_flags(&mapping_info, address, _PAGE_ENC, 0);
 }
 
+int set_page_non_present(unsigned long address)
+{
+	return set_clr_page_flags(&mapping_info, address, 0, _PAGE_PRESENT);
+}
+
 static void do_pf_error(const char *msg, unsigned long error_code,
 			unsigned long address, unsigned long ip)
 {
@@ -316,8 +321,14 @@ static void do_pf_error(const char *msg, unsigned long error_code,
 
 void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
-	unsigned long address = native_read_cr2() & PMD_MASK;
-	unsigned long end = address + PMD_SIZE;
+	unsigned long address = native_read_cr2();
+	unsigned long end;
+	bool ghcb_fault;
+
+	ghcb_fault = sev_es_check_ghcb_fault(address);
+
+	address   &= PMD_MASK;
+	end        = address + PMD_SIZE;
 
 	/*
 	 * Check for unexpected error codes. Unexpected are:
@@ -327,6 +338,8 @@ void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 */
 	if (error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD))
 		do_pf_error("Unexpected page-fault:", error_code, address, regs->ip);
+	else if (ghcb_fault)
+		do_pf_error("Page-fault on GHCB page:", error_code, address, regs->ip);
 
 	/*
 	 * Error code is sane - now identity map the 2M region around
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 9995c70ca813..c0e0ffeee50a 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -100,6 +100,7 @@ static inline void choose_random_location(unsigned long input,
 #ifdef CONFIG_X86_64
 extern int set_page_decrypted(unsigned long address);
 extern int set_page_encrypted(unsigned long address);
+extern int set_page_non_present(unsigned long address);
 extern unsigned char _pgtable[];
 #endif
 
@@ -117,8 +118,13 @@ void set_sev_encryption_mask(void);
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 void sev_es_shutdown_ghcb(void);
+extern bool sev_es_check_ghcb_fault(unsigned long address);
 #else
 static inline void sev_es_shutdown_ghcb(void) { }
+static inline bool sev_es_check_ghcb_fault(unsigned long address)
+{
+	return false;
+}
 #endif
 
 /* acpi.c */
diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
index 7e2cec170026..e3abf8737015 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -121,6 +121,20 @@ void sev_es_shutdown_ghcb(void)
 	 */
 	if (set_page_encrypted((unsigned long)&boot_ghcb_page))
 		error("Can't map GHCB page encrypted");
+
+	/*
+	 * GHCB page is mapped encrypted again and flushed from the cache.
+	 * Mark it non-present now to catch bugs when #VC exceptions trigger
+	 * after this point.
+	 */
+	if (set_page_non_present((unsigned long)&boot_ghcb_page))
+		error("Can't unmap GHCB page");
+}
+
+bool sev_es_check_ghcb_fault(unsigned long address)
+{
+	/* Check whether the fault was on the GHCB page */
+	return ((address & PAGE_MASK) == (unsigned long)&boot_ghcb_page);
 }
 
 void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
-- 
2.28.0

