Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75165CB152
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388956AbfJCVje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:39:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:52653 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388080AbfJCVjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:39:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051635"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:57 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 08/13] x86/boot: Rename USE_EARLY_PGTABLE_L5
Date:   Thu,  3 Oct 2019 14:23:55 -0700
Message-Id: <20191003212400.31130-9-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename USE_EARLY_PGTABLE_L5 to USE_EARLY_PGTABLE so that it can be used
by other early boot detectable page table features.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/boot/compressed/misc.h         | 2 +-
 arch/x86/include/asm/pgtable_64_types.h | 4 ++--
 arch/x86/kernel/cpu/common.c            | 2 +-
 arch/x86/kernel/head64.c                | 2 +-
 arch/x86/mm/kasan_init_64.c             | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index c8181392f70d..45a23aa807bd 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -14,7 +14,7 @@
 #undef CONFIG_KASAN
 
 /* cpu_feature_enabled() cannot be used this early */
-#define USE_EARLY_PGTABLE_L5
+#define USE_EARLY_PGTABLE
 
 #include <linux/linkage.h>
 #include <linux/screen_info.h>
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 52e5f5f2240d..6b55b837ead4 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -23,7 +23,7 @@ typedef struct { pteval_t pte; } pte_t;
 #ifdef CONFIG_X86_5LEVEL
 extern unsigned int __pgtable_l5_enabled;
 
-#ifdef USE_EARLY_PGTABLE_L5
+#ifdef USE_EARLY_PGTABLE
 /*
  * cpu_feature_enabled() is not available in early boot code.
  * Use variable instead.
@@ -34,7 +34,7 @@ static inline bool pgtable_l5_enabled(void)
 }
 #else
 #define pgtable_l5_enabled() cpu_feature_enabled(X86_FEATURE_LA57)
-#endif /* USE_EARLY_PGTABLE_L5 */
+#endif /* USE_EARLY_PGTABLE */
 
 #else
 #define pgtable_l5_enabled() 0
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f125bf7ecb6f..4f08e164c0b1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* cpu_feature_enabled() cannot be used this early */
-#define USE_EARLY_PGTABLE_L5
+#define USE_EARLY_PGTABLE
 
 #include <linux/memblock.h>
 #include <linux/linkage.h>
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 29ffa495bd1c..55f5294c3cdf 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -8,7 +8,7 @@
 #define DISABLE_BRANCH_PROFILING
 
 /* cpu_feature_enabled() cannot be used this early */
-#define USE_EARLY_PGTABLE_L5
+#define USE_EARLY_PGTABLE
 
 #include <linux/init.h>
 #include <linux/linkage.h>
diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 296da58f3013..9466d7abae49 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -3,7 +3,7 @@
 #define pr_fmt(fmt) "kasan: " fmt
 
 /* cpu_feature_enabled() cannot be used this early */
-#define USE_EARLY_PGTABLE_L5
+#define USE_EARLY_PGTABLE
 
 #include <linux/memblock.h>
 #include <linux/kasan.h>
-- 
2.17.1

