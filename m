Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D5B409813
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhIMP6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344280AbhIMP5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 11:57:44 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EF2C061760;
        Mon, 13 Sep 2021 08:56:28 -0700 (PDT)
Received: from cap.home.8bytes.org (p549ad441.dip0.t-ipconnect.de [84.154.212.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 5DC2810B2;
        Mon, 13 Sep 2021 17:56:24 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <joro@8bytes.org>, linux-coco@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 12/12] x86/sev: Support kexec under SEV-ES with AP Jump Table blob
Date:   Mon, 13 Sep 2021 17:56:03 +0200
Message-Id: <20210913155603.28383-13-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913155603.28383-1-joro@8bytes.org>
References: <20210913155603.28383-1-joro@8bytes.org>
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
index a8e16a411b40..06ff51b2b3fb 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -26,6 +26,7 @@
 #include <asm/kexec-bzimage64.h>
 #include <asm/setup.h>
 #include <asm/set_memory.h>
+#include <asm/sev.h>
 
 #ifdef CONFIG_ACPI
 /*
@@ -597,5 +598,8 @@ void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages)
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
index 5d4b1d317317..8c7f1ad69185 100644
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
2.33.0

