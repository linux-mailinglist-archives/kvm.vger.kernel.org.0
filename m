Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2681590E2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgBKN4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:56:02 -0500
Received: from 8bytes.org ([81.169.241.247]:52240 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729545AbgBKNx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:26 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 762BFE7B; Tue, 11 Feb 2020 14:53:13 +0100 (CET)
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 35/62] x86/sev-es: Setup per-cpu GHCBs for the runtime handler
Date:   Tue, 11 Feb 2020 14:52:29 +0100
Message-Id: <20200211135256.24617-36-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The runtime handler needs a GHCB per CPU. Set them up and map them
unencrypted.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/mem_encrypt.h |  2 ++
 arch/x86/kernel/sev-es.c           | 25 ++++++++++++++++++++++++-
 arch/x86/kernel/traps.c            |  3 +++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 6f61bb93366a..d48e7be9bb49 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -48,6 +48,7 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
 void __init mem_encrypt_init(void);
 void __init mem_encrypt_free_decrypted_mem(void);
 
+void __init encrypted_state_init_ghcbs(void);
 bool sme_active(void);
 bool sev_active(void);
 bool sev_es_active(void);
@@ -71,6 +72,7 @@ static inline void __init sme_early_init(void) { }
 static inline void __init sme_encrypt_kernel(struct boot_params *bp) { }
 static inline void __init sme_enable(struct boot_params *bp) { }
 
+static inline void encrypted_state_init_ghcbs(void) { }
 static inline bool sme_active(void) { return false; }
 static inline bool sev_active(void) { return false; }
 static inline bool sev_es_active(void) { return false; }
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 0e0b28477627..9a5530857db7 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -8,8 +8,11 @@
  */
 
 #include <linux/sched/debug.h>	/* For show_regs() */
-#include <linux/kernel.h>
+#include <linux/percpu-defs.h>
+#include <linux/mem_encrypt.h>
 #include <linux/printk.h>
+#include <linux/set_memory.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
 
 #include <asm/trap_defs.h>
@@ -28,6 +31,9 @@ struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
  */
 struct ghcb __initdata *boot_ghcb;
 
+/* Runtime GHCBs */
+static DEFINE_PER_CPU_DECRYPTED(struct ghcb, ghcb_page) __aligned(PAGE_SIZE);
+
 /* Needed in early_forward_exception */
 extern void early_exception(struct pt_regs *regs, int trapnr);
 
@@ -133,6 +139,23 @@ static bool __init setup_ghcb(void)
 	return true;
 }
 
+void encrypted_state_init_ghcbs(void)
+{
+	int cpu;
+
+	if (!sev_es_active())
+		return;
+
+	/* Initialize per-cpu GHCB pages */
+	for_each_possible_cpu(cpu) {
+		struct ghcb *ghcb = &per_cpu(ghcb_page, cpu);
+
+		set_memory_decrypted((unsigned long)ghcb,
+				     sizeof(ghcb_page) >> PAGE_SHIFT);
+		memset(ghcb, 0, sizeof(*ghcb));
+	}
+}
+
 static void __init early_forward_exception(struct es_em_ctxt *ctxt)
 {
 	int trapnr = ctxt->fi.vector;
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 6ef00eb6fbb9..9c9a7fae36d3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -918,6 +918,9 @@ void __init trap_init(void)
 	/* Init cpu_entry_area before IST entries are set up */
 	setup_cpu_entry_areas();
 
+	/* Init GHCB memory pages when running as an SEV-ES guest */
+	encrypted_state_init_ghcbs();
+
 	idt_setup_traps();
 
 	/*
-- 
2.17.1

