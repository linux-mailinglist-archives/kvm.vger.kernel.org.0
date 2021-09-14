Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B60D40B4A9
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhINQbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:31:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229757AbhINQbb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 12:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631637013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AofGbr4aDyfvOhWFMKTpSqqKNlWjUfjejTE8wl4g838=;
        b=ibgqY6DiACKspGp6JNYp1OJNb2USujaFlGhgZURjTKhANY8E3yrftt0FhngaIQwrz2Jr0A
        ofX8Z9BE4FgWOk6D3qQhGRNubWCcAmwoU2jFqMdcALPU8Dv61gFNdEm+e2KzrMD8dHdcbP
        l+AIZ0V2wdHlQNnCLYOkrxC80YASzFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-wo48sw1nOa6PEx2QBmgQyg-1; Tue, 14 Sep 2021 12:30:12 -0400
X-MC-Unique: wo48sw1nOa6PEx2QBmgQyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9080D1922035
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 16:30:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B56661972E;
        Tue, 14 Sep 2021 16:30:10 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/4] svm: add SVM_BARE_VMRUN
Date:   Tue, 14 Sep 2021 19:30:05 +0300
Message-Id: <20210914163008.309356-2-mlevitsk@redhat.com>
In-Reply-To: <20210914163008.309356-1-mlevitsk@redhat.com>
References: <20210914163008.309356-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index beb40b7..f109caa 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -194,41 +194,9 @@ struct regs get_regs(void)
 
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
index ae35d08..74ba818 100644
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

