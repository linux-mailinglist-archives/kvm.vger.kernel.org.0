Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930D14AD948
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349522AbiBHNQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356441AbiBHMWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 07:22:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB743C03FEC0
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 04:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644322922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4m1xJmbwrr/oQuxoGqrKefFITYBH/tT5cQ5+2a7U9g=;
        b=ix6GVchW5gSUvLscjuEGV0BhWCS4CeKJhOi6QattMR+FnGaAvct2QGucftYJtoNxXhWWRw
        HMGMoDoKVnE5UcBa3zpeE6ak/qO6IhSfLv+ldfAsaorUsNTPw+277imM0R0Uumog8GHevY
        ZJWFMAZGluem9Qhx1hOTrtO2gPTiPTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-bnZJWbqjOD-rfbtuZQzUfA-1; Tue, 08 Feb 2022 07:22:01 -0500
X-MC-Unique: bnZJWbqjOD-rfbtuZQzUfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 099E4835B52
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 12:21:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C4067B9D6;
        Tue,  8 Feb 2022 12:21:57 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5/7] svm: add SVM_BARE_VMRUN
Date:   Tue,  8 Feb 2022 14:21:46 +0200
Message-Id: <20220208122148.912913-6-mlevitsk@redhat.com>
In-Reply-To: <20220208122148.912913-1-mlevitsk@redhat.com>
References: <20220208122148.912913-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be useful in nested LBR tests to ensure that no extra
branches are made in the guest entry.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm.c | 32 --------------------------------
 x86/svm.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 62da2af..6f4e023 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -196,41 +196,9 @@ struct regs get_regs(void)
 
 // rax handled specially below
 
-#define SAVE_GPR_C                              \
-        "xchg %%rbx, regs+0x8\n\t"              \
-        "xchg %%rcx, regs+0x10\n\t"             \
-        "xchg %%rdx, regs+0x18\n\t"             \
-        "xchg %%rbp, regs+0x28\n\t"             \
-        "xchg %%rsi, regs+0x30\n\t"             \
-        "xchg %%rdi, regs+0x38\n\t"             \
-        "xchg %%r8, regs+0x40\n\t"              \
-        "xchg %%r9, regs+0x48\n\t"              \
-        "xchg %%r10, regs+0x50\n\t"             \
-        "xchg %%r11, regs+0x58\n\t"             \
-        "xchg %%r12, regs+0x60\n\t"             \
-        "xchg %%r13, regs+0x68\n\t"             \
-        "xchg %%r14, regs+0x70\n\t"             \
-        "xchg %%r15, regs+0x78\n\t"
-
-#define LOAD_GPR_C      SAVE_GPR_C
 
 struct svm_test *v2_test;
 
-#define ASM_PRE_VMRUN_CMD                       \
-                "vmload %%rax\n\t"              \
-                "mov regs+0x80, %%r15\n\t"      \
-                "mov %%r15, 0x170(%%rax)\n\t"   \
-                "mov regs, %%r15\n\t"           \
-                "mov %%r15, 0x1f8(%%rax)\n\t"   \
-                LOAD_GPR_C                      \
-
-#define ASM_POST_VMRUN_CMD                      \
-                SAVE_GPR_C                      \
-                "mov 0x170(%%rax), %%r15\n\t"   \
-                "mov %%r15, regs+0x80\n\t"      \
-                "mov 0x1f8(%%rax), %%r15\n\t"   \
-                "mov %%r15, regs\n\t"           \
-                "vmsave %%rax\n\t"              \
 
 u64 guest_stack[10000];
 
diff --git a/x86/svm.h b/x86/svm.h
index f74b13a..6d072f4 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -416,10 +416,57 @@ void vmcb_ident(struct vmcb *vmcb);
 struct regs get_regs(void);
 void vmmcall(void);
 int __svm_vmrun(u64 rip);
+void __svm_bare_vmrun(void);
 int svm_vmrun(void);
 void test_set_guest(test_guest_func func);
 
 extern struct vmcb *vmcb;
 extern struct svm_test svm_tests[];
 
+
+#define SAVE_GPR_C                              \
+        "xchg %%rbx, regs+0x8\n\t"              \
+        "xchg %%rcx, regs+0x10\n\t"             \
+        "xchg %%rdx, regs+0x18\n\t"             \
+        "xchg %%rbp, regs+0x28\n\t"             \
+        "xchg %%rsi, regs+0x30\n\t"             \
+        "xchg %%rdi, regs+0x38\n\t"             \
+        "xchg %%r8, regs+0x40\n\t"              \
+        "xchg %%r9, regs+0x48\n\t"              \
+        "xchg %%r10, regs+0x50\n\t"             \
+        "xchg %%r11, regs+0x58\n\t"             \
+        "xchg %%r12, regs+0x60\n\t"             \
+        "xchg %%r13, regs+0x68\n\t"             \
+        "xchg %%r14, regs+0x70\n\t"             \
+        "xchg %%r15, regs+0x78\n\t"
+
+#define LOAD_GPR_C      SAVE_GPR_C
+
+#define ASM_PRE_VMRUN_CMD                       \
+                "vmload %%rax\n\t"              \
+                "mov regs+0x80, %%r15\n\t"      \
+                "mov %%r15, 0x170(%%rax)\n\t"   \
+                "mov regs, %%r15\n\t"           \
+                "mov %%r15, 0x1f8(%%rax)\n\t"   \
+                LOAD_GPR_C                      \
+
+#define ASM_POST_VMRUN_CMD                      \
+                SAVE_GPR_C                      \
+                "mov 0x170(%%rax), %%r15\n\t"   \
+                "mov %%r15, regs+0x80\n\t"      \
+                "mov 0x1f8(%%rax), %%r15\n\t"   \
+                "mov %%r15, regs\n\t"           \
+                "vmsave %%rax\n\t"              \
+
+
+
+#define SVM_BARE_VMRUN \
+	asm volatile ( \
+		ASM_PRE_VMRUN_CMD \
+                "vmrun %%rax\n\t"               \
+		ASM_POST_VMRUN_CMD \
+		: \
+		: "a" (virt_to_phys(vmcb)) \
+		: "memory", "r15") \
+
 #endif
-- 
2.26.3

