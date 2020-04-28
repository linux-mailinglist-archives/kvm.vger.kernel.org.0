Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B147F1BC2BA
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgD1PSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:18:24 -0400
Received: from 8bytes.org ([81.169.241.247]:37630 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728450AbgD1PSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:18:21 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 0A386F4C; Tue, 28 Apr 2020 17:17:55 +0200 (CEST)
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
Subject: [PATCH v3 71/75] x86/head/64: Don't call verify_cpu() on starting APs
Date:   Tue, 28 Apr 2020 17:17:21 +0200
Message-Id: <20200428151725.31091-72-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The APs are not ready to handle exceptions when verify_cpu() is called
in secondary_startup_64.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/realmode.h | 1 +
 arch/x86/kernel/head_64.S       | 1 +
 arch/x86/realmode/init.c        | 6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 6590394af309..5c97807c38a4 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -69,6 +69,7 @@ extern unsigned char startup_32_smp[];
 extern unsigned char boot_gdt[];
 #else
 extern unsigned char secondary_startup_64[];
+extern unsigned char secondary_startup_64_no_verify[];
 #endif
 
 static inline size_t real_mode_size_needed(void)
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 7f2d5e14db73..72b8f0834de1 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -150,6 +150,7 @@ SYM_CODE_START(secondary_startup_64)
 	/* Sanitize CPU configuration */
 	call verify_cpu
 
+SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	/*
 	 * Retrieve the modifier (SME encryption mask if SME is active) to be
 	 * added to the initial pgdir entry that will be programmed into CR3.
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 1c5cbfd102d5..030c38268069 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -109,6 +109,12 @@ static void __init setup_real_mode(void)
 		trampoline_header->flags |= TH_FLAGS_SME_ACTIVE;
 
 	if (sev_es_active()) {
+		/*
+		 * Skip the call to verify_cpu() in secondary_startup_64 as it
+		 * will cause #VC exceptions when the AP can't handle them yet.
+		 */
+		trampoline_header->start = (u64) secondary_startup_64_no_verify;
+
 		if (sev_es_setup_ap_jump_table(real_mode_header))
 			panic("Failed to update SEV-ES AP Jump Table");
 	}
-- 
2.17.1

