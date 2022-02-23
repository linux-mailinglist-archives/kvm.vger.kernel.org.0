Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008274C0BA6
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbiBWFYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237725AbiBWFYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:18 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37904692AD
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:51 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w1-20020a05690204e100b006244315a721so15100815ybs.0
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=w8tfMjRpTHBn0meL0Ch0aZ7WXP9rbXxYNEO8B63hsno=;
        b=davxLdvboa7AnosMDU4YZaonHOXc2mWvmXUYJD5HKzin8o36/qY50HjsjugGaI/D5l
         Ru80WqGe/FnLjt+8HnlGtPjt4Zi6YBsphfykkNdK7xrLMzwOVzFL31vs2n/ZZ0O/HnpI
         LOgi7W6aQ+4Zmn4Z1cOc+jbXsnCew4XJAl85YB5PRtJ03TFKlpmUqcnmAJ1Qg9xnXjcb
         4yfUNHBaaQoJYVar5RgqzCzuUxniA1Jjald3axQoDsLvTOuO9FNS+ARVJ1i5nxUMdGko
         1OO6tdOVImcBTLT1zhrx+dYQEI4jcgxd4WQZmhlrRvv7dBLxB4zea6BzNV1mQ4MyCUUD
         fnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=w8tfMjRpTHBn0meL0Ch0aZ7WXP9rbXxYNEO8B63hsno=;
        b=y2krTEA+q3DurwCqr4WWU2pNRH8HHWvKDTbdt0SAanwmgUse7HOnjVCcp1cfQ9f0rF
         76g7/X76C4lILHcV/n8SQVA0uUsrXHQpSMMtmo3bZ86wbXD81q4JXkhe7YX5GcfwOwsX
         J5eH4CeU2eLMBkhNohv7V2qkcGwTIqmpciwSMe68jLhlv6JA3HosrM/2+XdM2AUD1QB6
         UuEsHpwI1ajG1+XUdldPaZ69Y51T0A90ydmhhYvsFz2LG3EF17ee+Kiq2cN2FGx2Yyag
         lBE61AnmntIldxFms1PJwiw4z2fK6XM176CoxwMe6SAPsCFYW6ZZCmHFtJGCN5VQse3i
         MlTA==
X-Gm-Message-State: AOAM532p1+LWAv5XO2Gpw4qJ76jtyJgI0pRYIBkr2Nnte7USUGfNBEmu
        Qzy3HnZ2NyWzIbTboZc0ESwLKjd2irhE
X-Google-Smtp-Source: ABdhPJxbYNkojrkaLjILQ8n9XN/i4xd/c0tZZOEcEinUXddidcFfUTlIca2QMtLlpZBc7xT9Yey+F1gwDIpI
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:2551:0:b0:613:2017:b879 with SMTP id
 l78-20020a252551000000b006132017b879mr26593133ybl.557.1645593830476; Tue, 22
 Feb 2022 21:23:50 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:38 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-3-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 02/47] mm: asi: Add command-line parameter to
 enable/disable ASI
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A parameter named "asi" is added, disabled by default. A feature flag
X86_FEATURE_ASI is set if ASI is enabled.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h               | 17 ++++++++++----
 arch/x86/include/asm/cpufeatures.h       |  1 +
 arch/x86/include/asm/disabled-features.h |  8 ++++++-
 arch/x86/mm/asi.c                        | 29 ++++++++++++++++++++++++
 arch/x86/mm/init.c                       |  2 +-
 include/asm-generic/asi.h                |  2 ++
 6 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index f9fc928a555d..0a4af23ed0eb 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -6,6 +6,7 @@
 
 #include <asm/pgtable_types.h>
 #include <asm/percpu.h>
+#include <asm/cpufeature.h>
 
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 
@@ -52,18 +53,24 @@ void asi_exit(void);
 
 static inline void asi_set_target_unrestricted(void)
 {
-	barrier();
-	this_cpu_write(asi_cpu_state.target_asi, NULL);
+	if (static_cpu_has(X86_FEATURE_ASI)) {
+		barrier();
+		this_cpu_write(asi_cpu_state.target_asi, NULL);
+	}
 }
 
 static inline struct asi *asi_get_current(void)
 {
-	return this_cpu_read(asi_cpu_state.curr_asi);
+	return static_cpu_has(X86_FEATURE_ASI)
+	       ? this_cpu_read(asi_cpu_state.curr_asi)
+	       : NULL;
 }
 
 static inline struct asi *asi_get_target(void)
 {
-	return this_cpu_read(asi_cpu_state.target_asi);
+	return static_cpu_has(X86_FEATURE_ASI)
+	       ? this_cpu_read(asi_cpu_state.target_asi)
+	       : NULL;
 }
 
 static inline bool is_asi_active(void)
@@ -76,6 +83,8 @@ static inline bool asi_is_target_unrestricted(void)
 	return !asi_get_target();
 }
 
+#define static_asi_enabled() cpu_feature_enabled(X86_FEATURE_ASI)
+
 #endif	/* CONFIG_ADDRESS_SPACE_ISOLATION */
 
 #endif
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d5b5f2ab87a0..0b0ead3cdd48 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -295,6 +295,7 @@
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
 #define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
 #define X86_FEATURE_SGX2		(11*32+ 9) /* "" SGX Enclave Dynamic Memory Management (EDMM) */
+#define X86_FEATURE_ASI			(11*32+10) /* Kernel Address Space Isolation */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 8f28fafa98b3..9659cd9f867d 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -56,6 +56,12 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+# define DISABLE_ASI		0
+#else
+# define DISABLE_ASI		(1 << (X86_FEATURE_ASI & 31))
+#endif
+
 /* Force disable because it's broken beyond repair */
 #define DISABLE_ENQCMD		(1 << (X86_FEATURE_ENQCMD & 31))
 
@@ -79,7 +85,7 @@
 #define DISABLED_MASK8	0
 #define DISABLED_MASK9	(DISABLE_SMAP|DISABLE_SGX)
 #define DISABLED_MASK10	0
-#define DISABLED_MASK11	0
+#define DISABLED_MASK11	(DISABLE_ASI)
 #define DISABLED_MASK12	0
 #define DISABLED_MASK13	0
 #define DISABLED_MASK14	0
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 9928325f3787..d274c86f89b7 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/init.h>
+
 #include <asm/asi.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
@@ -18,6 +20,9 @@ int asi_register_class(const char *name, uint flags,
 {
 	int i;
 
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return 0;
+
 	VM_BUG_ON(name == NULL);
 
 	spin_lock(&asi_class_lock);
@@ -43,6 +48,9 @@ EXPORT_SYMBOL_GPL(asi_register_class);
 
 void asi_unregister_class(int index)
 {
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return;
+
 	spin_lock(&asi_class_lock);
 
 	WARN_ON(asi_class[index].name == NULL);
@@ -52,10 +60,22 @@ void asi_unregister_class(int index)
 }
 EXPORT_SYMBOL_GPL(asi_unregister_class);
 
+static int __init set_asi_param(char *str)
+{
+	if (strcmp(str, "on") == 0)
+		setup_force_cpu_cap(X86_FEATURE_ASI);
+
+	return 0;
+}
+early_param("asi", set_asi_param);
+
 int asi_init(struct mm_struct *mm, int asi_index)
 {
 	struct asi *asi = &mm->asi[asi_index];
 
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return 0;
+
 	/* Index 0 is reserved for special purposes. */
 	WARN_ON(asi_index == 0 || asi_index >= ASI_MAX_NUM);
 	WARN_ON(asi->pgd != NULL);
@@ -79,6 +99,9 @@ EXPORT_SYMBOL_GPL(asi_init);
 
 void asi_destroy(struct asi *asi)
 {
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return;
+
 	free_pages((ulong)asi->pgd, PGD_ALLOCATION_ORDER);
 	memset(asi, 0, sizeof(struct asi));
 }
@@ -109,6 +132,9 @@ static void __asi_enter(void)
 
 void asi_enter(struct asi *asi)
 {
+	if (!static_cpu_has(X86_FEATURE_ASI))
+		return;
+
 	VM_WARN_ON_ONCE(!asi);
 
 	this_cpu_write(asi_cpu_state.target_asi, asi);
@@ -123,6 +149,9 @@ void asi_exit(void)
 	u64 unrestricted_cr3;
 	struct asi *asi;
 
+	if (!static_cpu_has(X86_FEATURE_ASI))
+		return;
+
 	preempt_disable();
 
 	VM_BUG_ON(this_cpu_read(cpu_tlbstate.loaded_mm) ==
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 000cbe5315f5..dfff17363365 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -240,7 +240,7 @@ static void __init probe_page_size_mask(void)
 	__default_kernel_pte_mask = __supported_pte_mask;
 	/* Except when with PTI or ASI where the kernel is mostly non-Global: */
 	if (cpu_feature_enabled(X86_FEATURE_PTI) ||
-	    IS_ENABLED(CONFIG_ADDRESS_SPACE_ISOLATION))
+	    cpu_feature_enabled(X86_FEATURE_ASI))
 		__default_kernel_pte_mask &= ~_PAGE_GLOBAL;
 
 	/* Enable 1 GB linear kernel mappings if available: */
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index e5ba51d30b90..dae1403ee1d0 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -44,6 +44,8 @@ static inline struct asi *asi_get_target(void) { return NULL; }
 
 static inline struct asi *asi_get_current(void) { return NULL; }
 
+#define static_asi_enabled() false
+
 #endif  /* !_ASSEMBLY_ */
 
 #endif /* !CONFIG_ADDRESS_SPACE_ISOLATION */
-- 
2.35.1.473.g83b2b277ed-goog

