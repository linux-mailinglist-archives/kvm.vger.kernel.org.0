Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D80E44CB42
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhKJVXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbhKJVXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:34 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8278FC061220
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:32 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p12-20020a17090b010c00b001a65bfe8054so1723137pjz.8
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=56RSg2WG+CC/xcFYHTtOxL1OzNea6nTzWtRdveDulCw=;
        b=FO5xcQdyWC820CBwc57jayjDRNQIae/utOM2q3OH2hR0+uZIVHstFOJvhnR8+frYYi
         IE8x81BZkkWAFVNe4SrTHTbsv3sU9x/ZUPaO6D1gvt+5wJJEqcd5v1Z97GuOj+8MaefB
         PvK1LstmK0IqrXoC0rSfP+ecDidj317dXSTr4IxoP4CsqDJGTRqQ1/aEy+fHyOnoW9Kp
         h0xbAyoGIsv0ySvwx0udYC52k5XFfs5bLGgiTmG5rUTxrnS4cl2MljdqroBcMClaAvrA
         Ig3zlv2VqlAewW3SnLL6NBG81QP7sICRK4ktfWzNQw/WFT3B8IzPaNAVTw2I05RDtI2M
         yoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=56RSg2WG+CC/xcFYHTtOxL1OzNea6nTzWtRdveDulCw=;
        b=IHLrSPVPwjAFbkQoGyF0l7+LJzRMdmXyuEs5aI6d7OMJ5nj7vrOx8HV96PduLCqLAP
         ZuAkBpfD4eltnC/lEmmT1EappUWS3kib71P3tqam7kV7+JFFhUyt3TpfCpwRc/5yNwvE
         02b2ctstjUcEZgPCGg3/LXftEzqNJr7hi5C9GIZCEZ2HGM9p0GeqEAbOKppZLFTNiHWR
         dLPw2tkqDXicxT1d/lnn/rHzLAvVQq+rX2xjD/eOE9LGeSeBXyn+4HcnfTTaHWjeEg9F
         /7jprApCi1du2faJ54dOxO1zMFB5jwoiiL8YCByozNFvPRf6o9yoyDlrmLyLUzL7QuLE
         8nCg==
X-Gm-Message-State: AOAM532cFtm8b+FeS2t3yNfsKCgtsYUqja2nLqvut2GYmcCytQKfzMad
        +m5O5RvRr1xerQ4ZCONaZWb1ZnwjuLGun/QUXeMA6VI8E+P82wypIzP/iU3fP7qPfFeot6pGllL
        wz46YfdOO8xYWCaCSRzRotFGS1UOT44QFbecqpyoeLKT9Kmt0n604SDZuCEdsVMshFKNH
X-Google-Smtp-Source: ABdhPJxcO1fuBu/UPCewuL0Mbz7pB8bDEFO9KEOxS4FIlpLdl4p4/fvTXhHgx2kAb6RaqUunbG8J25m81LxW3cxu
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:1254:b0:4a0:3da:3568 with SMTP
 id u20-20020a056a00125400b004a003da3568mr2013333pfi.57.1636579231899; Wed, 10
 Nov 2021 13:20:31 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:58 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-12-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 11/14] x86: Prepare access test for running in L2
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move main out of access.c in preparation for running the test in L2.
This allows access.c to be used as common code that will be
included in a nested tests later in this series.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/Makefile.common |  2 ++
 x86/Makefile.x86_64 |  2 +-
 x86/access.c        | 24 +++---------------------
 x86/access.h        |  8 ++++++++
 x86/access_test.c   | 22 ++++++++++++++++++++++
 x86/unittests.cfg   |  4 ++--
 6 files changed, 38 insertions(+), 24 deletions(-)
 create mode 100644 x86/access.h
 create mode 100644 x86/access_test.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 52bb7aa..a665854 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -72,6 +72,8 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
 
 $(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
 
+$(TEST_DIR)/access_test.elf: $(TEST_DIR)/access.o
+
 $(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o
 
 $(TEST_DIR)/hyperv_synic.elf: $(TEST_DIR)/hyperv.o
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 8134952..390d0e9 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -9,7 +9,7 @@ cflatobjs += lib/x86/setjmp64.o
 cflatobjs += lib/x86/intel-iommu.o
 cflatobjs += lib/x86/usermode.o
 
-tests = $(TEST_DIR)/access.flat $(TEST_DIR)/apic.flat \
+tests = $(TEST_DIR)/access_test.flat $(TEST_DIR)/apic.flat \
 	  $(TEST_DIR)/emulator.flat $(TEST_DIR)/idt_test.flat \
 	  $(TEST_DIR)/xsave.flat $(TEST_DIR)/rmap_chain.flat \
 	  $(TEST_DIR)/pcid.flat $(TEST_DIR)/debug.flat \
diff --git a/x86/access.c b/x86/access.c
index 8e3a718..de6726e 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -1,9 +1,9 @@
-
 #include "libcflat.h"
 #include "desc.h"
 #include "processor.h"
 #include "asm/page.h"
 #include "x86/vm.h"
+#include "access.h"
 
 #define smp_id() 0
 
@@ -14,7 +14,7 @@ static _Bool verbose = false;
 
 typedef unsigned long pt_element_t;
 static int invalid_mask;
-static int page_table_levels;
+int page_table_levels;
 
 #define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) & PAGE_MASK))
 #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
@@ -1069,7 +1069,7 @@ const ac_test_fn ac_test_cases[] =
 	check_effective_sp_permissions,
 };
 
-static int ac_test_run(void)
+int ac_test_run()
 {
     ac_test_t at;
     ac_pool_t pool;
@@ -1150,21 +1150,3 @@ static int ac_test_run(void)
 
     return successes == tests;
 }
-
-int main(void)
-{
-    int r;
-
-    printf("starting test\n\n");
-    page_table_levels = 4;
-    r = ac_test_run();
-
-    if (this_cpu_has(X86_FEATURE_LA57)) {
-        page_table_levels = 5;
-        printf("starting 5-level paging test.\n\n");
-        setup_5level_page_table();
-        r = ac_test_run();
-    }
-
-    return r ? 0 : 1;
-}
diff --git a/x86/access.h b/x86/access.h
new file mode 100644
index 0000000..4f67b62
--- /dev/null
+++ b/x86/access.h
@@ -0,0 +1,8 @@
+#ifndef X86_ACCESS_H
+#define X86_ACCESS_H
+
+int ac_test_run(void);
+
+extern int page_table_levels;
+
+#endif // X86_ACCESS_H
\ No newline at end of file
diff --git a/x86/access_test.c b/x86/access_test.c
new file mode 100644
index 0000000..497f286
--- /dev/null
+++ b/x86/access_test.c
@@ -0,0 +1,22 @@
+#include "libcflat.h"
+#include "processor.h"
+#include "x86/vm.h"
+#include "access.h"
+
+int main(void)
+{
+    int r;
+
+    printf("starting test\n\n");
+    page_table_levels = 4;
+    r = ac_test_run();
+
+    if (this_cpu_has(X86_FEATURE_LA57)) {
+        page_table_levels = 5;
+        printf("starting 5-level paging test.\n\n");
+        setup_5level_page_table();
+        r = ac_test_run();
+    }
+
+    return r ? 0 : 1;
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3000e53..dbeb8a2 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -114,13 +114,13 @@ groups = vmexit
 extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 
 [access]
-file = access.flat
+file = access_test.flat
 arch = x86_64
 extra_params = -cpu max
 timeout = 180
 
 [access-reduced-maxphyaddr]
-file = access.flat
+file = access_test.flat
 arch = x86_64
 extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off
 timeout = 180
-- 
2.34.0.rc1.387.gb447b232ab-goog

