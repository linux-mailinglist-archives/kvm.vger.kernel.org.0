Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1A5606453
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiJTPYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiJTPY3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE1B38B3
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruJUIK6ckQ5Yx6rfxfbot+5UZRlTCmIHEQZOzqkfFZQ=;
        b=EDZ/kgWzjeZvOEZGsW54BRNl7IP+V0X21D0oXxSETwqwdugYGkDG/afgZ4qD22cWudPYxS
        zJ4YZlwPmZGoeYgl2FLhh8FMQI9BpkziQ0AxhnT7x+EHAmLDV3sboM+VQpEeLSL+AM8YyK
        v2MImlEfvl72HxJ6Si+RuK3xz/QekxI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-NpwZLY__MTqQUYqxUSKscA-1; Thu, 20 Oct 2022 11:24:19 -0400
X-MC-Unique: NpwZLY__MTqQUYqxUSKscA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 454D8833AEC
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:19 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 138002024CB7;
        Thu, 20 Oct 2022 15:24:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 07/16] x86: Add a simple test for SYSENTER instruction.
Date:   Thu, 20 Oct 2022 18:23:55 +0300
Message-Id: <20221020152404.283980-8-mlevitsk@redhat.com>
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

Run the test with Intel's vendor ID and in the long mode,
to test the emulation of this instruction on AMD.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/Makefile.x86_64 |   2 +
 x86/sysenter.c      | 127 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   5 ++
 3 files changed, 134 insertions(+)
 create mode 100644 x86/sysenter.c

diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 865da07d..8ce53650 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -33,6 +33,7 @@ tests += $(TEST_DIR)/vmware_backdoors.$(exe)
 tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
+tests += $(TEST_DIR)/sysenter.$(exe)
 
 
 ifeq ($(CONFIG_EFI),y)
@@ -60,3 +61,4 @@ $(TEST_DIR)/hyperv_clock.$(bin): $(TEST_DIR)/hyperv_clock.o
 $(TEST_DIR)/vmx.$(bin): $(TEST_DIR)/vmx_tests.o
 $(TEST_DIR)/svm.$(bin): $(TEST_DIR)/svm_tests.o
 $(TEST_DIR)/svm_npt.$(bin): $(TEST_DIR)/svm_npt.o
+$(TEST_DIR)/sysenter.o: CFLAGS += -Wa,-mintel64
diff --git a/x86/sysenter.c b/x86/sysenter.c
new file mode 100644
index 00000000..6c32fea4
--- /dev/null
+++ b/x86/sysenter.c
@@ -0,0 +1,127 @@
+#include "alloc.h"
+#include "libcflat.h"
+#include "processor.h"
+#include "msr.h"
+#include "desc.h"
+
+
+// undefine this to run the syscall instruction in 64 bit mode.
+// this won't work on AMD due to disabled code in the emulator.
+#define COMP32
+
+int main(int ac, char **av)
+{
+    extern void sysenter_target(void);
+    extern void test_done(void);
+
+    setup_vm();
+
+    int gdt_index = 0x50 >> 3;
+    ulong rax = 0xDEAD;
+
+    /* init the sysenter GDT block */
+    /*gdt64[gdt_index+0] = gdt64[KERNEL_CS >> 3];
+    gdt64[gdt_index+1] = gdt64[KERNEL_DS >> 3];
+    gdt64[gdt_index+2] = gdt64[USER_CS >> 3];
+    gdt64[gdt_index+3] = gdt64[USER_DS >> 3];*/
+
+    /* init the sysenter msrs*/
+    wrmsr(MSR_IA32_SYSENTER_CS, gdt_index << 3);
+    wrmsr(MSR_IA32_SYSENTER_ESP, 0xAAFFFFFFFF);
+    wrmsr(MSR_IA32_SYSENTER_EIP, (uint64_t)sysenter_target);
+
+    u8 *thunk = (u8*)malloc(50);
+    u8 *tmp = thunk;
+
+    printf("Thunk at 0x%lx\n", (u64)thunk);
+
+    /* movabs test_done, %rdx*/
+    *tmp++ = 0x48; *tmp++ = 0xBA;
+    *(u64 *)tmp = (uint64_t)test_done; tmp += 8;
+    /* jmp %%rdx*/
+    *tmp++ = 0xFF; *tmp++ = 0xe2;
+
+    asm volatile (
+#ifdef COMP32
+        "# switch to comp32, mode prior to running the test\n"
+        "ljmpl *1f\n"
+        "1:\n"
+        ".long 1f\n"
+        ".long " xstr(KERNEL_CS32) "\n"
+        "1:\n"
+        ".code32\n"
+#else
+		"# store the 64 bit thunk address to rdx\n"
+		"mov %[thunk], %%rdx\n"
+#endif
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++"
+		"# user code (64 bit or comp32)"
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++"
+
+		"# use sysenter to enter 64 bit system code\n"
+        "mov %%esp, %%ecx #stash rsp value\n"
+        "mov $1, %%ebx\n"
+        "sysenter\n"
+        "ud2\n"
+
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+        "# 64 bit cpl=0 code"
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+
+        ".code64\n"
+		"sysenter_target:\n"
+
+#ifdef COMP32
+		"test %%rbx, %%rbx # check if we are here for second time \n"
+        "jne 1f\n"
+        "movq %%rcx, %%rsp # restore stack pointer manually\n"
+        "jmp test_done\n"
+        "1:\n"
+#endif
+
+		"# test that MSR_IA32_SYSENTER_ESP is correct\n"
+        "movq $0xAAFFFFFFFF, %%rbx\n"
+        "movq $0xDEAD, %%rax\n"
+        "cmpq %%rsp, %%rbx \n"
+        "jne 1f\n"
+        "movq $0xACED, %%rax\n"
+
+        "# use sysexit to exit back\n"
+        "1:\n"
+#ifdef COMP32
+		"leaq sysexit_target, %%rdx\n"
+        "sysexit\n"
+        "sysexit_target:\n"
+		"# second sysenter to return to CPL=0 and 64 bit\n"
+        "# the sysenter handler will jump back to here without sysexit due to ebx=0\n"
+        ".code32\n"
+		"mov $0, %%ebx\n"
+        "sysenter\n"
+#else
+		"# this will go through thunk to test_done, which tests,\n"
+		"# that we can sysexit to high addresses\n"
+		".byte 0x48\n"
+        "sysexit\n"
+        "ud2\n"
+#endif
+
+		".code64\n"
+        "test_done:\n"
+		"nop\n"
+
+        : /*outputs*/
+        "=a" (rax)
+        : /* inputs*/
+		[thunk] "r" (thunk)
+        : /*clobbers*/
+        "rbx",  /* action flag for sysenter_target */
+        "rcx",  /* saved RSP */
+        "rdx",  /* used for SYSEXIT*/
+        "flags"
+     );
+
+    report(rax == 0xACED, "MSR_IA32_SYSENTER_ESP has correct value");
+    return report_summary();
+}
+
+
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index db9bb3ac..ebb3fdfc 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -223,6 +223,11 @@ file = syscall.flat
 arch = x86_64
 extra_params = -cpu Opteron_G1,vendor=AuthenticAMD
 
+[sysenter]
+file = sysenter.flat
+arch = x86_64
+extra_params = -cpu host,vendor=GenuineIntel
+
 [tsc]
 file = tsc.flat
 extra_params = -cpu kvm64,+rdtscp
-- 
2.26.3

