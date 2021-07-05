Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09CA3BB942
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 10:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhGEIau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 04:30:50 -0400
Received: from 8bytes.org ([81.169.241.247]:59126 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhGEI25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 04:28:57 -0400
Received: from cap.home.8bytes.org (p5b006775.dip0.t-ipconnect.de [91.0.103.117])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 954FDA56;
        Mon,  5 Jul 2021 10:26:17 +0200 (CEST)
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 09/12] x86/sev: Use AP Jump Table blob to stop CPU
Date:   Mon,  5 Jul 2021 10:24:40 +0200
Message-Id: <20210705082443.14721-10-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210705082443.14721-1-joro@8bytes.org>
References: <20210705082443.14721-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

To support kexec under SEV-ES the APs can't be parked with HLT. Upon
wakeup the AP needs to find its way to execute at the reset vector set
by the new kernel and in real-mode.

This is what the AP Jump Table blob provides, so stop the APs the
SEV-ES way by calling the AP-reset-hold VMGEXIT from the AP Jump
Table.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev.h |  7 +++++++
 arch/x86/kernel/process.c  |  8 ++++++++
 arch/x86/kernel/sev.c      | 11 ++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 134a7c9d91b6..cd14b6e10f12 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -81,12 +81,19 @@ static __always_inline void sev_es_nmi_complete(void)
 		__sev_es_nmi_complete();
 }
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
+void __sev_es_stop_this_cpu(void);
+static __always_inline void sev_es_stop_this_cpu(void)
+{
+	if (static_branch_unlikely(&sev_es_enable_key))
+		__sev_es_stop_this_cpu();
+}
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
 static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
 static inline void sev_es_nmi_complete(void) { }
 static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
+static inline void sev_es_stop_this_cpu(void) { }
 #endif
 
 #endif
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 5e1f38179f49..c5da02f9100f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -43,6 +43,7 @@
 #include <asm/io_bitmap.h>
 #include <asm/proto.h>
 #include <asm/frame.h>
+#include <asm/sev.h>
 
 #include "process.h"
 
@@ -736,6 +737,13 @@ void stop_this_cpu(void *dummy)
 	if (boot_cpu_has(X86_FEATURE_SME))
 		native_wbinvd();
 	for (;;) {
+		/*
+		 * SEV-ES guests need a special stop routine to support
+		 * kexec. Try this first, if it fails the function will
+		 * return and native_halt() is used.
+		 */
+		sev_es_stop_this_cpu();
+
 		/*
 		 * Use native_halt() so that memory contents don't change
 		 * (stack usage and variables) after possibly issuing the
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 2147ebd0e919..5fdfa94c823c 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -695,7 +695,6 @@ static bool __init sev_es_setup_ghcb(void)
 	return true;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static void __noreturn sev_jumptable_ap_park(void)
 {
 	local_irq_disable();
@@ -725,6 +724,16 @@ static void __noreturn sev_jumptable_ap_park(void)
 }
 STACK_FRAME_NON_STANDARD(sev_jumptable_ap_park);
 
+void __sev_es_stop_this_cpu(void)
+{
+	/* Only park in the AP Jump Table when the code has been installed */
+	if (!sev_ap_jumptable_blob_installed)
+		return;
+
+	sev_jumptable_ap_park();
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
 static void sev_es_ap_hlt_loop(void)
 {
 	struct ghcb_state state;
-- 
2.31.1

