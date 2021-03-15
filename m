Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD1433C839
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 22:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhCOVJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 17:09:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232821AbhCOVJa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 17:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615842569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mOTOvCfnoVEFlm1YtEAl1OO4FauKbh9beYLBCLki6/Y=;
        b=i8j8gTpOMvo/lMs+Zygwk7+w39PZOPBnI1ML23KVFWBQx9C+N3aHrGh2xsGNrxZ8eWrOAa
        AyTAfuviPNWTDxaQ1b4gjztT2jJwcQmn+jOmrc+ZqZwy5sBUwimf0JV+5YAxeSnayt5X7J
        zAYGpRszjkMXqEBBDGJ0FhvInfdq4iY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-TW0O-rybPyOD412m-WqC4Q-1; Mon, 15 Mar 2021 17:09:27 -0400
X-MC-Unique: TW0O-rybPyOD412m-WqC4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 435A918460AB
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 21:09:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B26D60C0F;
        Mon, 15 Mar 2021 21:09:25 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/2] Add a simple test for SYSENTER instruction.
Date:   Mon, 15 Mar 2021 23:09:21 +0200
Message-Id: <20210315210921.626351-3-mlevitsk@redhat.com>
In-Reply-To: <20210315210921.626351-1-mlevitsk@redhat.com>
References: <20210315210921.626351-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Run the test with Intel's vendor ID and in the long mode,
to test the emulation of this instruction on AMD.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/Makefile.x86_64 |  3 ++
 x86/cstart64.S      |  1 +
 x86/sysenter.c      | 91 +++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  5 +++
 4 files changed, 100 insertions(+)
 create mode 100644 x86/sysenter.c

diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 8134952..c430bfb 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -16,6 +16,7 @@ tests = $(TEST_DIR)/access.flat $(TEST_DIR)/apic.flat \
 	  $(TEST_DIR)/ioapic.flat $(TEST_DIR)/memory.flat \
 	  $(TEST_DIR)/pku.flat $(TEST_DIR)/hyperv_clock.flat
 tests += $(TEST_DIR)/syscall.flat
+tests += $(TEST_DIR)/sysenter.flat
 tests += $(TEST_DIR)/svm.flat
 tests += $(TEST_DIR)/vmx.flat
 tests += $(TEST_DIR)/tscdeadline_latency.flat
@@ -35,3 +36,5 @@ $(TEST_DIR)/hyperv_clock.elf: $(TEST_DIR)/hyperv_clock.o
 
 $(TEST_DIR)/vmx.elf: $(TEST_DIR)/vmx_tests.o
 $(TEST_DIR)/svm.elf: $(TEST_DIR)/svm_tests.o
+
+$(TEST_DIR)/sysenter.o: CFLAGS += -Wa,-mintel64
\ No newline at end of file
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 5c6ad38..62ace35 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -62,6 +62,7 @@ gdt64_desc:
 	.word gdt64_end - gdt64 - 1
 	.quad gdt64
 
+.globl gdt64
 gdt64:
 	.quad 0
 	.quad 0x00af9b000000ffff // 64-bit code segment
diff --git a/x86/sysenter.c b/x86/sysenter.c
new file mode 100644
index 0000000..c1fc9d5
--- /dev/null
+++ b/x86/sysenter.c
@@ -0,0 +1,91 @@
+
+#include "libcflat.h"
+#include "processor.h"
+#include "msr.h"
+#include "desc.h"
+
+extern uint64_t gdt64[];
+
+// undefine this to run the syscall instruction in 64 bit mode.
+// this won't work on AMD due to disabled code in the emulator.
+#define COMP32
+
+int main(int ac, char **av)
+{
+    extern void sysenter_target(void);
+    int gdt_index = 0x50 >> 3;
+    ulong rax = 0xDEAD;
+
+    /* init the sysenter GDT block */
+    gdt64[gdt_index+0] = gdt64[KERNEL_CS >> 3];
+    gdt64[gdt_index+1] = gdt64[KERNEL_DS >> 3];
+    gdt64[gdt_index+2] = gdt64[USER_CS >> 3];
+    gdt64[gdt_index+3] = gdt64[USER_DS >> 3];
+
+    /* init the sysenter msrs*/
+    wrmsr(MSR_IA32_SYSENTER_CS, gdt_index << 3);
+    wrmsr(MSR_IA32_SYSENTER_ESP, 0xAAFFFFFFFF);
+    wrmsr(MSR_IA32_SYSENTER_EIP, (uint64_t)sysenter_target);
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
+#endif
+        "# use sysenter\n"
+        "mov %%esp, %%ecx #stash rsp value\n"
+        "mov $1, %%ebx\n"
+        "sysenter\n"
+        "ud2\n"
+
+        "# 64 bit cpl=0 code\n"
+        "sysenter_target:\n"
+        ".code64\n"
+        "test %%rbx, %%rbx # check if we are here for second time \n"
+        "jne 1f\n"
+        "movq %%rcx, %%rsp # restore stack pointer manually\n"
+        "jmp test_done\n"
+
+        "1:\n"
+        "# test that MSR_IA32_SYSENTER_ESP is correct\n"
+        "movq $0xAAFFFFFFFF, %%rbx\n"
+        "movq $0xDEAD, %%rax\n"
+        "cmpq %%rsp, %%rbx \n"
+        "jne 1f\n"
+        "movq $0xACED, %%rax\n"
+
+        "# use sysexit to exit back to cpl=3 32 bit code\n"
+        "1:\n"
+        "leaq sysexit_target, %%rdx\n"
+        "sysexit\n"
+        "ud2\n"
+
+        "# second sysenter to return to CPL=0 and 64 bit\n"
+        "# the sysenter handler will jump back to here without sysexit due to ebx=0\n"
+        "sysexit_target:\n"
+        ".code32\n"
+        "mov $0, %%ebx\n"
+        "sysenter\n"
+        "test_done:\n"
+        ".code64\n"
+
+        : /*outputs*/
+        "=a" (rax)
+        : /* inputs*/
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
index 60c4b13..5fe39f5 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -205,6 +205,11 @@ file = syscall.flat
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
2.26.2

