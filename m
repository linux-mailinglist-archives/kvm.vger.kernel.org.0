Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CA44E47E6
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 21:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiCVU6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 16:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbiCVU5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 16:57:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F8EBF7C
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647982584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4m1xJmbwrr/oQuxoGqrKefFITYBH/tT5cQ5+2a7U9g=;
        b=ZzK11dBK0Fbj122K6WE53m8FH6+yl5bnVLRTsvM5qC9CF5loBY/J4GUmu4BRVdaPugWg2S
        lHjSojrzx0R88HhzgTY+Suy0PGVfoW1LqF4e7xH1q2E5kEzw3lUfAvjCEU+l/WRghJNO4M
        95mzmQvOpdhvHDzVX0/g3LP30om2/3s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-3Mgbs1OFPcmIpDgbRQRmVg-1; Tue, 22 Mar 2022 16:56:23 -0400
X-MC-Unique: 3Mgbs1OFPcmIpDgbRQRmVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B44C899EC2
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 20:56:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E20C1C27E80;
        Tue, 22 Mar 2022 20:56:21 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 5/9] svm: add SVM_BARE_VMRUN
Date:   Tue, 22 Mar 2022 22:56:09 +0200
Message-Id: <20220322205613.250925-6-mlevitsk@redhat.com>
In-Reply-To: <20220322205613.250925-1-mlevitsk@redhat.com>
References: <20220322205613.250925-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

