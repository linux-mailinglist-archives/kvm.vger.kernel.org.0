Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A362660645C
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiJTPZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiJTPYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1A23AE77
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TSeThcm4f2xEy4CsHnnXxZCDBGd59epLAw9tCAjgHLA=;
        b=VkJZbafabB//N0NhqoGhKg5eapvv3iwJO9UpS8LjHFAj66yD9taSCafqSJS9SeajibOm+G
        +7l8g5r2BFPd50PATPUn7chwD72WUV55FwaQcd8IY5M4wx4qw4LsqWEqtm9bIIs7DESc+C
        s3hYzRrBaO3t2Uz88VT4dkVjWZNgjow=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-NYqzSvYWPuCD9GgUi47g6A-1; Thu, 20 Oct 2022 11:24:24 -0400
X-MC-Unique: NYqzSvYWPuCD9GgUi47g6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45D533810D2D
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:24 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13B172028DC1;
        Thu, 20 Oct 2022 15:24:22 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 10/16] svm: move some svm support functions into lib/x86/svm_lib.h
Date:   Thu, 20 Oct 2022 18:23:58 +0300
Message-Id: <20221020152404.283980-11-mlevitsk@redhat.com>
In-Reply-To: <20221020152404.283980-1-mlevitsk@redhat.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/svm_lib.h | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 x86/svm.c         | 36 +-------------------------------
 x86/svm.h         | 18 ----------------
 x86/svm_npt.c     |  1 +
 x86/svm_tests.c   |  1 +
 5 files changed, 56 insertions(+), 53 deletions(-)
 create mode 100644 lib/x86/svm_lib.h

diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
new file mode 100644
index 00000000..04910281
--- /dev/null
+++ b/lib/x86/svm_lib.h
@@ -0,0 +1,53 @@
+#ifndef SRC_LIB_X86_SVM_LIB_H_
+#define SRC_LIB_X86_SVM_LIB_H_
+
+#include <x86/svm.h>
+#include "processor.h"
+
+static inline bool npt_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_NPT);
+}
+
+static inline bool vgif_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_VGIF);
+}
+
+static inline bool lbrv_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_LBRV);
+}
+
+static inline bool tsc_scale_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_TSCRATEMSR);
+}
+
+static inline bool pause_filter_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_PAUSEFILTER);
+}
+
+static inline bool pause_threshold_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
+}
+
+static inline void vmmcall(void)
+{
+	asm volatile ("vmmcall" : : : "memory");
+}
+
+static inline void stgi(void)
+{
+	asm volatile ("stgi");
+}
+
+static inline void clgi(void)
+{
+	asm volatile ("clgi");
+}
+
+
+#endif /* SRC_LIB_X86_SVM_LIB_H_ */
diff --git a/x86/svm.c b/x86/svm.c
index ba435b4a..e4e638c7 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -14,6 +14,7 @@
 #include "alloc_page.h"
 #include "isr.h"
 #include "apic.h"
+#include "svm_lib.h"
 
 /* for the nested page table*/
 u64 *pml4e;
@@ -54,32 +55,6 @@ bool default_supported(void)
 	return true;
 }
 
-bool vgif_supported(void)
-{
-	return this_cpu_has(X86_FEATURE_VGIF);
-}
-
-bool lbrv_supported(void)
-{
-	return this_cpu_has(X86_FEATURE_LBRV);
-}
-
-bool tsc_scale_supported(void)
-{
-	return this_cpu_has(X86_FEATURE_TSCRATEMSR);
-}
-
-bool pause_filter_supported(void)
-{
-	return this_cpu_has(X86_FEATURE_PAUSEFILTER);
-}
-
-bool pause_threshold_supported(void)
-{
-	return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
-}
-
-
 void default_prepare(struct svm_test *test)
 {
 	vmcb_ident(vmcb);
@@ -94,10 +69,6 @@ bool default_finished(struct svm_test *test)
 	return true; /* one vmexit */
 }
 
-bool npt_supported(void)
-{
-	return this_cpu_has(X86_FEATURE_NPT);
-}
 
 int get_test_stage(struct svm_test *test)
 {
@@ -128,11 +99,6 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 	seg->base = base;
 }
 
-inline void vmmcall(void)
-{
-	asm volatile ("vmmcall" : : : "memory");
-}
-
 static test_guest_func guest_main;
 
 void test_set_guest(test_guest_func func)
diff --git a/x86/svm.h b/x86/svm.h
index 73800bc7..075ac566 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -53,21 +53,14 @@ u64 *npt_get_pdpe(u64 address);
 u64 *npt_get_pml4e(void);
 bool smp_supported(void);
 bool default_supported(void);
-bool vgif_supported(void);
-bool lbrv_supported(void);
-bool tsc_scale_supported(void);
-bool pause_filter_supported(void);
-bool pause_threshold_supported(void);
 void default_prepare(struct svm_test *test);
 void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
-bool npt_supported(void);
 int get_test_stage(struct svm_test *test);
 void set_test_stage(struct svm_test *test, int s);
 void inc_test_stage(struct svm_test *test);
 void vmcb_ident(struct vmcb *vmcb);
 struct regs get_regs(void);
-void vmmcall(void);
 int __svm_vmrun(u64 rip);
 void __svm_bare_vmrun(void);
 int svm_vmrun(void);
@@ -76,17 +69,6 @@ u64* get_npt_pte(u64 *pml4, u64 guest_addr, int level);
 
 extern struct vmcb *vmcb;
 
-static inline void stgi(void)
-{
-    asm volatile ("stgi");
-}
-
-static inline void clgi(void)
-{
-    asm volatile ("clgi");
-}
-
-
 
 #define SAVE_GPR_C                              \
         "xchg %%rbx, regs+0x8\n\t"              \
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index b791f1ac..8aac0bb6 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -2,6 +2,7 @@
 #include "vm.h"
 #include "alloc_page.h"
 #include "vmalloc.h"
+#include "svm_lib.h"
 
 static void *scratch_page;
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 2c29c2b0..bbf64af2 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -11,6 +11,7 @@
 #include "apic.h"
 #include "delay.h"
 #include "vmalloc.h"
+#include "svm_lib.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
-- 
2.26.3

