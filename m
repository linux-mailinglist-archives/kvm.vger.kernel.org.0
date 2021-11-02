Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4B144384A
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 23:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhKBWUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 18:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhKBWUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 18:20:10 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC81AC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 15:17:34 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id w13-20020a63934d000000b002a2935891daso457880pgm.15
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 15:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QpWL/KVxlQS+ksdg6RdsHomZYKAxlmPIJlHyIXJnaPg=;
        b=QCq+2w6m+n2JF0im0u2AJJGvi01afcDpZv0sqhT6siXxvmcROlJ8X0DQWyBQ5hl6E5
         mAgfTCqmYOG4owJ9HRF+XQzYHte/OzZvKalHZ+cHUzZW+/kpXhvVd1yIeEb87x18idAZ
         DEutnjDZuqO08xuWfXqnO8y1Vx/IhZoJysNKMneQNMc+FQNL9ICLM9T7lQiU1MWRM3up
         1gOtNSJ4q6U4iyBB2cnOebTwrugzdfaaV5O93hMT6vSH4lLEld6QU+RdKbcVly0RIZb/
         CcGHb7Is0+rxjyfsdbMVfdVDpPkRt8ao4vJrybNmD0m172dn5EeTM79RZvB++gPcJv28
         KVwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QpWL/KVxlQS+ksdg6RdsHomZYKAxlmPIJlHyIXJnaPg=;
        b=b98KzKa+/26UfXQv3mwbvVTBf/xwtcaB2CuQw4Lg+SHFOo8loMRmMaiaOhOLfBlmpa
         4IXWfNOQZJsvQ4aEUHd0wTSJkRTQVsTonaHc02B+0Xds1x3z56CBCx5aqbTdDg7iWi9Q
         VMB1Tdf+m/AjI+HUo4RIXn15iWPTp0HSrUq0symMfjjVrmBPIPu34lGuh6dFVLRJZJ4P
         hTu6otVCN6slHWSGuqmrv7TIiZzjTp6DwIuaOqV4uSQTvSLkkfDj76EC5j2iw80xrAbh
         oB1fRS4MGaZ25ye3z1qR/fcTzsOnuP59d2yMwNCY9SMyN3/sDKkP+FUiUuL7WbJvsbYr
         mleQ==
X-Gm-Message-State: AOAM532SANVgrlT2IavzOmoNVIe8dM2EtTsTA4JJiVZzt7zjZrAAFWGj
        +8r0pA71hfZK4KqW7VfzwZcr/aK97s0MU1aA3vt3UWNqcvhftITkpqblZd00EjgRKf+rZj7W8MW
        mn4D75NWoOQqn2meOZfc68Q2KykKuXrseqMcTRBB77aRT5eL7y8FfdPdR8CKsWk6CK1Ua
X-Google-Smtp-Source: ABdhPJyw5HNmXiQyp2WU8B5Ofd7SEXiXkeS/qqkoVIdumPb1vgPs+VPCgEE9yI/zplhPxvxDO3tzlpnSYJ0lio8W
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:4306:: with SMTP id
 q6mr10310151pjg.17.1635891454276; Tue, 02 Nov 2021 15:17:34 -0700 (PDT)
Date:   Tue,  2 Nov 2021 22:14:57 +0000
Message-Id: <20211102221456.2662560-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [kvm-unit-tests PATCH v2] x86: Look up the PTEs rather than assuming them
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
 lib/x86/vm.c   | 19 +++++++++++++++++++
 lib/x86/vm.h   |  3 +++
 x86/access.c   | 23 +++++++++++++++--------
 x86/cstart64.S |  1 -
 x86/flat.lds   |  1 +
 6 files changed, 39 insertions(+), 9 deletions(-)

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
index 5cd2ee4..cbecddc 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -281,3 +281,22 @@ void force_4k_page(void *addr)
 	if (pte & PT_PAGE_SIZE_MASK)
 		split_large_page(ptep, 2);
 }
+
+/*
+ * Call the callback, function, on each page from va_start to va_end.
+ */
+void walk_pte(void *va_start, void *va_end,
+	      void (*function)(pteval_t *pte, void *va)){
+    struct pte_search search;
+    uintptr_t curr_addr;
+    u64 page_size;
+
+    for (curr_addr = (uintptr_t)va_start; curr_addr < (uintptr_t)va_end;
+         curr_addr = ALIGN_DOWN(curr_addr + page_size, page_size)) {
+        search = find_pte_level(current_page_table(), (void *)curr_addr, 1);
+        assert(found_leaf_pte(search));
+        page_size = 1ul << PGDIR_BITS(search.level);
+
+        function(search.pte, (void *)curr_addr);
+    }
+}
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index d9753c3..f4ac2c5 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -52,4 +52,7 @@ struct vm_vcpu_info {
         u64 cr0;
 };
 
+void walk_pte(void *va_start, void *va_end,
+	      void (*function)(pteval_t *pte, void *va));
+
 #endif
diff --git a/x86/access.c b/x86/access.c
index 4725bbd..17a6ef9 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -201,10 +201,21 @@ static void set_cr0_wp(int wp)
     }
 }
 
+static void clear_user_mask(pteval_t *pte, void *va) {
+	*pte &= ~PT_USER_MASK;
+}
+
+static void set_user_mask(pteval_t *pte, void *va) {
+	*pte |= PT_USER_MASK;
+
+	/* Flush to avoid spurious #PF */
+	invlpg(va);
+}
+
 static unsigned set_cr4_smep(int smep)
 {
+    extern char stext, etext;
     unsigned long cr4 = shadow_cr4;
-    extern u64 ptl2[];
     unsigned r;
 
     cr4 &= ~CR4_SMEP_MASK;
@@ -214,14 +225,10 @@ static unsigned set_cr4_smep(int smep)
         return 0;
 
     if (smep)
-        ptl2[2] &= ~PT_USER_MASK;
+        walk_pte(&stext, &etext, clear_user_mask);
     r = write_cr4_checking(cr4);
-    if (r || !smep) {
-        ptl2[2] |= PT_USER_MASK;
-
-	/* Flush to avoid spurious #PF */
-	invlpg((void *)(2 << 21));
-    }
+    if (r || !smep)
+        walk_pte(&stext, &etext, set_user_mask);
     if (!r)
         shadow_cr4 = cr4;
     return r;
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 5c6ad38..4ba9943 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -26,7 +26,6 @@ ring0stacktop:
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
2.34.0.rc0.344.g81b53c2807-goog

