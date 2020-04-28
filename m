Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3321E1BC32B
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgD1PSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728072AbgD1PSA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 11:18:00 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BF2C03C1AD;
        Tue, 28 Apr 2020 08:17:59 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E427FEDB; Tue, 28 Apr 2020 17:17:45 +0200 (CEST)
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
Subject: [PATCH v3 20/75] x86/boot/compressed/64: Call set_sev_encryption_mask earlier
Date:   Tue, 28 Apr 2020 17:16:30 +0200
Message-Id: <20200428151725.31091-21-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Call set_sev_encryption_mask() while still on the stage 1 #VC-handler,
because the stage 2 handler needs our own page-tables to be set up, to
which calling set_sev_encryption_mask() is a prerequisite.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/head_64.S      | 8 +++++++-
 arch/x86/boot/compressed/ident_map_64.c | 3 ---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index af571127c9ba..940d44149a29 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -534,9 +534,15 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
 	rep	stosq
 
 /*
- * Load stage2 IDT and switch to our own page-table
+ * If running as an SEV guest, the encryption mask is required in the
+ * page-table setup code below. When the guest also has SEV-ES enabled
+ * set_sev_encryption_mask() will cause #VC exceptions, but the stage2
+ * handler can't map its GHCB because the page-table is not set up yet.
+ * So set up the encryption mask here while still on the stage1 #VC
+ * handler. Then load stage2 IDT and switch to our own page-table.
  */
 	pushq	%rsi
+	call	set_sev_encryption_mask
 	call	load_stage2_idt
 	call	initialize_identity_maps
 	popq	%rsi
diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index 83385a551f01..6ee089fdc65a 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -107,9 +107,6 @@ static void add_identity_map(unsigned long start, unsigned long end)
 /* Locates and clears a region for a new top level page table. */
 void initialize_identity_maps(void)
 {
-	/* If running as an SEV guest, the encryption mask is required. */
-	set_sev_encryption_mask();
-
 	/* Exclude the encryption mask from __PHYSICAL_MASK */
 	physical_mask &= ~sme_me_mask;
 
-- 
2.17.1

