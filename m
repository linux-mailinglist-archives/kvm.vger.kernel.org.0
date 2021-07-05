Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142DC3BB938
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 10:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhGEIar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 04:30:47 -0400
Received: from 8bytes.org ([81.169.241.247]:59210 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhGEI27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 04:28:59 -0400
Received: from cap.home.8bytes.org (p5b006775.dip0.t-ipconnect.de [91.0.103.117])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 61136CAE;
        Mon,  5 Jul 2021 10:26:19 +0200 (CEST)
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
Subject: [RFC PATCH 12/12] x86/sev: Support kexec under SEV-ES with AP Jump Table blob
Date:   Mon,  5 Jul 2021 10:24:43 +0200
Message-Id: <20210705082443.14721-13-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210705082443.14721-1-joro@8bytes.org>
References: <20210705082443.14721-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When the AP Jump Table blob is installed the kernel can hand over the
APs from the old to the new kernel. Enable kexec when the AP Jump
Table blob has been installed.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/sev.h         |  2 ++
 arch/x86/kernel/machine_kexec_64.c |  6 +++++-
 arch/x86/kernel/sev.c              | 12 ++++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index cd14b6e10f12..61910caf2a0d 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -87,6 +87,7 @@ static __always_inline void sev_es_stop_this_cpu(void)
 	if (static_branch_unlikely(&sev_es_enable_key))
 		__sev_es_stop_this_cpu();
 }
+bool sev_kexec_supported(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -94,6 +95,7 @@ static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { ret
 static inline void sev_es_nmi_complete(void) { }
 static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
 static inline void sev_es_stop_this_cpu(void) { }
+static bool sev_kexec_supported(void) { return true; }
 #endif
 
 #endif
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index f902cc9cc634..d08eae4f7694 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -26,6 +26,7 @@
 #include <asm/kexec-bzimage64.h>
 #include <asm/setup.h>
 #include <asm/set_memory.h>
+#include <asm/sev.h>
 
 #ifdef CONFIG_ACPI
 /*
@@ -626,5 +627,8 @@ void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages)
  */
 bool arch_kexec_supported(void)
 {
-	return !sev_es_active();
+	if (!sev_kexec_supported())
+		return false;
+
+	return true;
 }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 113903ba3095..731bbf941a82 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -901,6 +901,18 @@ static int __init sev_es_setup_ap_jump_table_blob(void)
 }
 core_initcall(sev_es_setup_ap_jump_table_blob);
 
+bool sev_kexec_supported(void)
+{
+	/*
+	 * KEXEC with SEV-ES and more than one CPU is only supported
+	 * when the AP Jump Table is installed.
+	 */
+	if (num_possible_cpus() > 1)
+		return !sev_es_active() || sev_ap_jumptable_blob_installed;
+	else
+		return true;
+}
+
 static void __init alloc_runtime_data(int cpu)
 {
 	struct sev_es_runtime_data *data;
-- 
2.31.1

