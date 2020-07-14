Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDD521F0CF
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 14:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgGNMQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 08:16:56 -0400
Received: from 8bytes.org ([81.169.241.247]:53184 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728168AbgGNMKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 08:10:44 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 10C596B1;
        Tue, 14 Jul 2020 14:10:42 +0200 (CEST)
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
Subject: [PATCH v4 17/75] x86/boot/compressed/64: Change add_identity_map() to take start and end
Date:   Tue, 14 Jul 2020 14:08:19 +0200
Message-Id: <20200714120917.11253-18-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714120917.11253-1-joro@8bytes.org>
References: <20200714120917.11253-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Changing the function to take start and end as parameters instead of
start and size simplifies the callers, which don't need to calculate
the size if they already have start and end.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/ident_map_64.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index c63257bf8373..62e42c11a336 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -89,10 +89,8 @@ static struct x86_mapping_info mapping_info;
 /*
  * Adds the specified range to the identity mappings.
  */
-static void add_identity_map(unsigned long start, unsigned long size)
+static void add_identity_map(unsigned long start, unsigned long end)
 {
-	unsigned long end = start + size;
-
 	/* Align boundary to 2M. */
 	start = round_down(start, PMD_SIZE);
 	end = round_up(end, PMD_SIZE);
@@ -107,8 +105,6 @@ static void add_identity_map(unsigned long start, unsigned long size)
 /* Locates and clears a region for a new top level page table. */
 void initialize_identity_maps(void)
 {
-	unsigned long start, size;
-
 	/* If running as an SEV guest, the encryption mask is required. */
 	set_sev_encryption_mask();
 
@@ -155,9 +151,7 @@ void initialize_identity_maps(void)
 	 * New page-table is set up - map the kernel image and load it
 	 * into cr3.
 	 */
-	start = (unsigned long)_head;
-	size  = _end - _head;
-	add_identity_map(start, size);
+	add_identity_map((unsigned long)_head, (unsigned long)_end);
 	write_cr3(top_level_pgt);
 }
 
@@ -189,7 +183,8 @@ static void do_pf_error(const char *msg, unsigned long error_code,
 
 void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
-	unsigned long address = native_read_cr2();
+	unsigned long address = native_read_cr2() & PMD_MASK;
+	unsigned long end = address + PMD_SIZE;
 
 	/*
 	 * Check for unexpected error codes. Unexpected are:
@@ -204,5 +199,5 @@ void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 * Error code is sane - now identity map the 2M region around
 	 * the faulting address.
 	 */
-	add_identity_map(address & PMD_MASK, PMD_SIZE);
+	add_identity_map(address, end);
 }
-- 
2.27.0

