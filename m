Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682A863412C
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiKVQPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbiKVQOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C154C79926
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aVtYY7KmEzrvZLR2lTZaYaKEOP1XpFAW1GamivF5f80=;
        b=KI2tCMmB/tXu8TTOVKRWi/i4V0mBBOphM3HG1YsGATyDuMTuS2Hyk9KBs5S9mRZa0MfYvb
        YYWNUCbvtqM9+q+ZBLZFFDB04WkQpzzODrKFZVJ1tbyBVTDBokvW8ZECc+YyTGQhy0d0RZ
        MNaPkLwiJjIoGI1nt0dxcy9N1u6FJY8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-4nZ0xdtRPP6Td1kCoWFJ0g-1; Tue, 22 Nov 2022 11:12:15 -0500
X-MC-Unique: 4nZ0xdtRPP6Td1kCoWFJ0g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 206221C08972;
        Tue, 22 Nov 2022 16:12:14 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 260EF1121314;
        Tue, 22 Nov 2022 16:12:12 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v3 08/27] x86: Add a simple test for SYSENTER instruction.
Date:   Tue, 22 Nov 2022 18:11:33 +0200
Message-Id: <20221122161152.293072-9-mlevitsk@redhat.com>
In-Reply-To: <20221122161152.293072-1-mlevitsk@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 x86/sysenter.c      | 203 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   5 ++
 3 files changed, 210 insertions(+)
 create mode 100644 x86/sysenter.c

diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 5d66b201..f76ff18a 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -34,6 +34,7 @@ tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 tests += $(TEST_DIR)/pmu_pebs.$(exe)
+tests += $(TEST_DIR)/sysenter.$(exe)
 
 
 ifeq ($(CONFIG_EFI),y)
@@ -61,3 +62,4 @@ $(TEST_DIR)/hyperv_clock.$(bin): $(TEST_DIR)/hyperv_clock.o
 $(TEST_DIR)/vmx.$(bin): $(TEST_DIR)/vmx_tests.o
 $(TEST_DIR)/svm.$(bin): $(TEST_DIR)/svm_tests.o
 $(TEST_DIR)/svm_npt.$(bin): $(TEST_DIR)/svm_npt.o
+$(TEST_DIR)/sysenter.o: CFLAGS += -Wa,-mintel64
diff --git a/x86/sysenter.c b/x86/sysenter.c
new file mode 100644
index 00000000..1cc76219
--- /dev/null
+++ b/x86/sysenter.c
@@ -0,0 +1,203 @@
+#include "alloc.h"
+#include "libcflat.h"
+#include "processor.h"
+#include "msr.h"
+#include "desc.h"
+
+// define this to test SYSENTER/SYSEXIT in 64 bit mode
+//#define TEST_64_BIT
+
+static void test_comp32(void)
+{
+	ulong rax = 0xDEAD;
+
+	extern void sysenter_target_32(void);
+
+	wrmsr(MSR_IA32_SYSENTER_EIP, (uint64_t)sysenter_target_32);
+
+	asm volatile (
+		"# switch to comp32, mode prior to running the test\n"
+		"ljmpl *1f\n"
+		"1:\n"
+		".long 1f\n"
+		".long " xstr(KERNEL_CS32) "\n"
+		"1:\n"
+		".code32\n"
+
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+		"# user code (comp32)\n"
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+
+		"# use sysenter to enter 64 bit system code\n"
+		"mov %%esp, %%ecx #stash rsp value\n"
+		"mov $1, %%ebx\n"
+		"sysenter\n"
+		"ud2\n"
+
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+		"# 64 bit cpl=0 code\n"
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+
+		".code64\n"
+		"sysenter_target_32:\n"
+		"test %%rbx, %%rbx # check if we are here for second time\n"
+		"jne 1f\n"
+		"movq %%rcx, %%rsp # restore stack pointer manually\n"
+		"jmp test_done_32\n"
+		"1:\n"
+
+		"# test that MSR_IA32_SYSENTER_ESP is correct\n"
+		"movq $0xAAFFFFFFFF, %%rbx\n"
+		"movq $0xDEAD, %%rax\n"
+		"cmpq %%rsp, %%rbx\n"
+		"jne 1f\n"
+		"movq $0xACED, %%rax\n"
+
+		"# use sysexit to exit back\n"
+		"1:\n"
+		"leaq sysexit_target, %%rdx\n"
+		"sysexit\n"
+
+		"sysexit_target:\n"
+
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+		"# exit back to 64 bit mode using a second sysenter\n"
+		"# due to rbx == 0, the sysenter handler will jump back to\n"
+		"# here without sysexit due to ebx=0\n"
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+
+		".code32\n"
+		"mov $0, %%ebx\n"
+		"sysenter\n"
+
+		".code64\n"
+		"test_done_32:\n"
+		"nop\n"
+
+		: /*outputs*/
+		"=a" (rax)
+		: /* inputs*/
+		: /*clobbers*/
+		"rbx",  /* action flag for sysenter_target */
+		"rcx",  /* saved RSP */
+		"rdx",  /* used for SYSEXIT*/
+		"flags"
+	);
+
+	report(rax == 0xACED, "MSR_IA32_SYSENTER_ESP has correct value");
+}
+
+#ifdef TEST_64_BIT
+static void test_64_bit(void)
+{
+	extern void test_done_64(void);
+	extern void sysenter_target_64(void);
+
+	ulong rax = 0xDEAD;
+	u8 *sysexit_thunk = (u8 *)malloc(50);
+	u8 *tmp = sysexit_thunk;
+
+	/* Allocate SYSEXIT thunk, whose purpose is to be at > 32 bit address,
+	 * to test that SYSEXIT can jump to these addresses
+	 *
+	 * TODO: malloc seems to return addresses from the top of the
+	 * virtual address space, but it is better to use a dedicated API
+	 */
+	printf("SYSEXIT Thunk at 0x%lx\n", (u64)sysexit_thunk);
+
+	/* movabs test_done, %rdx*/
+	*tmp++ = 0x48; *tmp++ = 0xBA;
+	*(u64 *)tmp = (uint64_t)test_done_64; tmp += 8;
+	/* jmp %%rdx*/
+	*tmp++ = 0xFF; *tmp++ = 0xe2;
+
+	wrmsr(MSR_IA32_SYSENTER_EIP, (uint64_t)sysenter_target_64);
+
+	asm volatile (
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+		"# user code (64 bit)\n"
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+
+		"# store the 64 bit thunk address to rdx\n"
+		"mov %[sysexit_thunk], %%rdx\n"
+		"# use sysenter to enter 64 bit system code\n"
+		"mov %%esp, %%ecx #stash rsp value\n"
+		"mov $1, %%ebx\n"
+		"sysenter\n"
+		"ud2\n"
+
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+		"# 64 bit cpl=0 code\n"
+		"#+++++++++++++++++++++++++++++++++++++++++++++++++++\n"
+
+		".code64\n"
+		"sysenter_target_64:\n"
+		"# test that MSR_IA32_SYSENTER_ESP is correct\n"
+		"movq $0xAAFFFFFFFF, %%rbx\n"
+		"movq $0xDEAD, %%rax\n"
+		"cmpq %%rsp, %%rbx\n"
+		"jne 1f\n"
+		"movq $0xACED, %%rax\n"
+
+		"# use sysexit to exit back\n"
+		"1:\n"
+
+		"# this will go through thunk to test_done_64, which tests\n"
+		"# that we can sysexit to a high address\n"
+		".byte 0x48\n"
+		"sysexit\n"
+		"ud2\n"
+
+		".code64\n"
+		"test_done_64:\n"
+		"nop\n"
+
+		: /*outputs*/
+		"=a" (rax)
+		: /* inputs*/
+		[sysexit_thunk] "r" (sysexit_thunk)
+		: /*clobbers*/
+		"rbx",  /* action flag for sysenter_target */
+		"rcx",  /* saved RSP */
+		"rdx",  /* used for SYSEXIT*/
+		"flags"
+	);
+	report(rax == 0xACED, "MSR_IA32_SYSENTER_ESP has correct value");
+}
+#endif
+
+int main(int ac, char **av)
+{
+	setup_vm();
+
+	int gdt_index = 0x50 >> 3;
+
+	/* init the sysenter GDT block */
+	gdt[gdt_index+0] = gdt[KERNEL_CS >> 3];
+	gdt[gdt_index+1] = gdt[KERNEL_DS >> 3];
+	gdt[gdt_index+2] = gdt[USER_CS >> 3];
+	gdt[gdt_index+3] = gdt[USER_DS >> 3];
+
+	/* init the sysenter msrs*/
+	wrmsr(MSR_IA32_SYSENTER_CS, gdt_index << 3);
+	wrmsr(MSR_IA32_SYSENTER_ESP, 0xAAFFFFFFFF);
+	test_comp32();
+
+	/*
+	 * on AMD, the SYSENTER/SYSEXIT instruction is not supported in
+	 * both 64 bit and comp32 modes
+	 *
+	 * However the KVM emulates it in COMP32 mode to support migration,
+	 * iff guest cpu model is intel,
+	 *
+	 * but it doesn't emulate it in 64 bit mode because there is no good
+	 * reason to use this instruction in 64 bit mode anyway.
+	 */
+
+#ifdef TEST_64_BIT
+	test_64_bit();
+#endif
+	return report_summary();
+}
+
+
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index e803ba03..df248dff 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -245,6 +245,11 @@ file = syscall.flat
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
2.34.3

