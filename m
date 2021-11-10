Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DB044CB41
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhKJVXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbhKJVXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:33 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35101C06120E
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:30 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 76-20020a63054f000000b002c9284978aaso2129078pgf.10
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NP6FiWe6Se9ZE9bHI8uQWohZGgmsxfNQ6bkZaVjL4lU=;
        b=i0v/3lqSyF0vUEwy8cpPkl0n2ChZqK90Xw4Cp8jGfRN1xb/dTkjxhyQtVZA70TcHCA
         64Jv0rMpNJ09I8Uyq0lLMKdBNSDF+ilWNX7knNVUYV9CeWLF3QPqaHQcK8WAQNJdi2HB
         jDNJFpqDS5AeSj2PAUS3+RdI3fvn0636YgIBDYBSYsyVtGae0Sp3u3BaIRXKOAxzr6yw
         ETHTk6mxRg9vdEKI+F6QYhfBxm2KwMV7mo9xl9rqh5p8kmR1x8NNYOCCfrJa7WJq2p7S
         4G7AaaXNe8asb+6Zhnwvogzlf9sv6nVFCjOA4NYMxq1IEANv6A3P5x9sAPVGlBDFYONu
         Sj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NP6FiWe6Se9ZE9bHI8uQWohZGgmsxfNQ6bkZaVjL4lU=;
        b=yBA2VAa9AtI2wh1ZrN6Wk/7IMU4t53VLIUbXmDfB4A8TSBeXEJ9/5LBI8r26U+GEMf
         G9Kr4c8FJbxyHaIo9etd24wCrXujOBBCCy8Kop0zKbPRHf651I9UXrm1nKVH4RvtH3DO
         kPjjPbhy6ufPFJ2RPlmd0HA9fkPhyTJKJZ8I6I5ehRZWwT3hAfloX7p65mhTU9GgUQb3
         nU1b73tMnp4ZhHFNZTbA+PTbpBptdLeCz0I4XUtDNqfyI+hh+6kqO0o/rI20FedkUzEH
         gFzRGQy999rg8oq1xNjyLAObuSlpXeNI8MXE0I8LnIqYZlpYIhjiCFebXNIHTDmMTXZo
         F/Lg==
X-Gm-Message-State: AOAM5308iShCXtk6/5jkrJcxhqCnSHPo0o8Nex8Ga0JveN6ymLGdTsMS
        IJE/aBoBEzci1KvJ15iL2Acgb9948Ne0ygq/OneT0Q+1s3E8Yy220M5BAPCNf9UkLT9J7bVKcLK
        1zHqLAtf/0cIGZb14fdlNcE+lW4uUYr6jrFID/DnGqZrD0yrHWWchH276pXMR+VulUjt9
X-Google-Smtp-Source: ABdhPJzVcAj08M6yXfCRF9gly1l8L8KZpSV0bFVbUz7XGCbNx8IKPCUhfjnKY8t72sTViP2jiDbXfCkIf4oVm8UN
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:3810:: with SMTP id
 mq16mr20364953pjb.128.1636579229484; Wed, 10 Nov 2021 13:20:29 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:57 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-11-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 10/14] x86: Look up the PTEs rather than
 assuming them
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than assuming which PTEs the SMEP test runs on, look them up to
ensure they are correct.  If this test were to run on a different page
table (ie: run in an L2 test) the wrong PTEs would be set.  Switch to
looking up the PTEs to avoid this from happening.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 lib/libcflat.h |  1 +
 lib/x86/vm.c   | 21 +++++++++++++++++++++
 lib/x86/vm.h   |  3 +++
 x86/access.c   | 26 ++++++++++++++++++--------
 x86/cstart64.S |  1 -
 x86/flat.lds   |  1 +
 6 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 9bb7e08..c1fd31f 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -35,6 +35,7 @@
 #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 #define __ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
 #define ALIGN(x, a)		__ALIGN((x), (a))
+#define ALIGN_DOWN(x, a)	__ALIGN((x) - ((a) - 1), (a))
 #define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
 
 #define MIN(a, b)		((a) < (b) ? (a) : (b))
diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 5cd2ee4..6a70ef6 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -281,3 +281,24 @@ void force_4k_page(void *addr)
 	if (pte & PT_PAGE_SIZE_MASK)
 		split_large_page(ptep, 2);
 }
+
+/*
+ * Call the callback on each page from virt to virt + len.
+ */
+void walk_pte(void *virt, size_t len, pte_callback_t callback)
+{
+    pgd_t *cr3 = current_page_table();
+    uintptr_t start = (uintptr_t)virt;
+    uintptr_t end = (uintptr_t)virt + len;
+    struct pte_search search;
+    size_t page_size;
+    uintptr_t curr;
+
+    for (curr = start; curr < end; curr = ALIGN_DOWN(curr + page_size, page_size)) {
+        search = find_pte_level(cr3, (void *)curr, 1);
+        assert(found_leaf_pte(search));
+        page_size = 1ul << PGDIR_BITS(search.level);
+
+        callback(search, (void *)curr);
+    }
+}
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index d9753c3..4c6dff9 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -52,4 +52,7 @@ struct vm_vcpu_info {
         u64 cr0;
 };
 
+typedef void (*pte_callback_t)(struct pte_search search, void *va);
+void walk_pte(void *virt, size_t len, pte_callback_t callback);
+
 #endif
diff --git a/x86/access.c b/x86/access.c
index a781a0c..8e3a718 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -201,10 +201,24 @@ static void set_cr0_wp(int wp)
     }
 }
 
+static void clear_user_mask(struct pte_search search, void *va)
+{
+	*search.pte &= ~PT_USER_MASK;
+}
+
+static void set_user_mask(struct pte_search search, void *va)
+{
+	*search.pte |= PT_USER_MASK;
+
+	/* Flush to avoid spurious #PF */
+	invlpg(va);
+}
+
 static unsigned set_cr4_smep(int smep)
 {
+    extern char stext, etext;
+    size_t len = (size_t)&etext - (size_t)&stext;
     unsigned long cr4 = shadow_cr4;
-    extern u64 ptl2[];
     unsigned r;
 
     cr4 &= ~CR4_SMEP_MASK;
@@ -214,14 +228,10 @@ static unsigned set_cr4_smep(int smep)
         return 0;
 
     if (smep)
-        ptl2[2] &= ~PT_USER_MASK;
+        walk_pte(&stext, len, clear_user_mask);
     r = write_cr4_checking(cr4);
-    if (r || !smep) {
-        ptl2[2] |= PT_USER_MASK;
-
-	/* Flush to avoid spurious #PF */
-	invlpg((void *)(2 << 21));
-    }
+    if (r || !smep)
+        walk_pte(&stext, len, set_user_mask);
     if (!r)
         shadow_cr4 = cr4;
     return r;
diff --git a/x86/cstart64.S b/x86/cstart64.S
index ddb83a0..ff79ae7 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -17,7 +17,6 @@ stacktop:
 .data
 
 .align 4096
-.globl ptl2
 ptl2:
 i = 0
 	.rept 512 * 4
diff --git a/x86/flat.lds b/x86/flat.lds
index a278b56..337bc44 100644
--- a/x86/flat.lds
+++ b/x86/flat.lds
@@ -3,6 +3,7 @@ SECTIONS
     . = 4M + SIZEOF_HEADERS;
     stext = .;
     .text : { *(.init) *(.text) *(.text.*) }
+    etext = .;
     . = ALIGN(4K);
     .data : {
           *(.data)
-- 
2.34.0.rc1.387.gb447b232ab-goog

