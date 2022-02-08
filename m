Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63AD4ADE52
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 17:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383258AbiBHQ0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 11:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236721AbiBHQ0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 11:26:31 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A68FC061576;
        Tue,  8 Feb 2022 08:26:30 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 15ACD210F1;
        Tue,  8 Feb 2022 16:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644337589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5xIdhuy2kjyX6uCE+3FfTK5aUS0wDFM6jy8jPdMFDBY=;
        b=R0AdqzXOYY/X+apWYvCTsX8+J4SUfpiaQoCmWrmRWYDqYbdAojsfBqGwIiMjyI2DHDBhrR
        66oyr2TlUJPfQq3ClAswKmXAIeAVrP1hmJUX6Y+7uWJWD988JMLC/UE+C2huT14FX80B1Z
        p/UMXRDzh8fEhK4eaA+dRWV4cqYBOKg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644337589;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5xIdhuy2kjyX6uCE+3FfTK5aUS0wDFM6jy8jPdMFDBY=;
        b=ZPBzJB614T18lDab53hkJ2UzOjHBpDxbQAAT6ugShYCU1rFla2oDu2rW8A6htgi1MFdEp+
        FkG7iZckVQOIXlCA==
Received: from vasant-suse.fritz.box (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id CE730A3B87;
        Tue,  8 Feb 2022 16:26:28 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org
Cc:     bp@alien8.de, jroedel@suse.de, kvm@vger.kernel.org, x86@kernel.org,
        thomas.lendacky@amd.com, Varad Gautam <varad.gautam@suse.com>,
        Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v5 1/1] x86/test: Add a test for AMD SEV-ES #VC handling 
Date:   Tue,  8 Feb 2022 17:26:23 +0100
Message-Id: <20220208162623.18368-2-vkarasulli@suse.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220208162623.18368-1-vkarasulli@suse.de>
References: <20220208162623.18368-1-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Varad Gautam <varad.gautam@suse.com>

Add a KUnit based test to validate Linux's VC handling, and introduce
a new CONFIG_X86_TESTS to cover such tests. The test:
1. installs a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to
   access GHCB before/after the resulting VMGEXIT).
2. triggers an NAE.
3. checks that the kretprobe was hit with the right exit_code available
   in GHCB.

Since relying on kprobes, the test does not cover NMI contexts.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/Kbuild              |   2 +
 arch/x86/Kconfig.debug       |  16 ++++
 arch/x86/kernel/Makefile     |   7 ++
 arch/x86/tests/Makefile      |   3 +
 arch/x86/tests/sev-test-vc.c | 154 +++++++++++++++++++++++++++++++++++
 5 files changed, 182 insertions(+)
 create mode 100644 arch/x86/tests/Makefile
 create mode 100644 arch/x86/tests/sev-test-vc.c

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index f384cb1a4f7a..90470c76866a 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -26,5 +26,7 @@ obj-y += net/
 
 obj-$(CONFIG_KEXEC_FILE) += purgatory/
 
+obj-y += tests/
+
 # for cleaning
 subdir- += boot tools
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index d3a6f74a94bd..e4f61af66816 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -279,3 +279,19 @@ endchoice
 config FRAME_POINTER
 	depends on !UNWINDER_ORC && !UNWINDER_GUESS
 	bool
+
+config X86_TESTS
+	bool "Tests for x86"
+	help
+	    This enables building the tests under arch/x86/tests.
+
+if X86_TESTS
+config AMD_SEV_TEST_VC
+	bool "Test for AMD SEV VC exception handling"
+	depends on AMD_MEM_ENCRYPT
+	select FUNCTION_TRACER
+	select KPROBES
+	select KUNIT
+	help
+	  Enable KUnit-based testing for AMD SEV #VC exception handling.
+endif # X86_TESTS
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 6aef9ee28a39..69472a576909 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -24,6 +24,13 @@ CFLAGS_REMOVE_sev.o = -pg
 CFLAGS_REMOVE_cc_platform.o = -pg
 endif
 
+# AMD_SEV_TEST_VC registers a kprobe by function name. IPA-SRA creates
+# function copies and renames them to have an .isra suffix, which breaks kprobes'
+# lookup. Build with -fno-ipa-sra for the test.
+ifdef CONFIG_AMD_SEV_TEST_VC
+CFLAGS_sev.o	+= -fno-ipa-sra
+endif
+
 KASAN_SANITIZE_head$(BITS).o				:= n
 KASAN_SANITIZE_dumpstack.o				:= n
 KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
diff --git a/arch/x86/tests/Makefile b/arch/x86/tests/Makefile
new file mode 100644
index 000000000000..4beca64bd2aa
--- /dev/null
+++ b/arch/x86/tests/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_AMD_SEV_TEST_VC)	+= sev-test-vc.o
diff --git a/arch/x86/tests/sev-test-vc.c b/arch/x86/tests/sev-test-vc.c
new file mode 100644
index 000000000000..eb5f790b64f5
--- /dev/null
+++ b/arch/x86/tests/sev-test-vc.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 SUSE
+ *
+ * Author: Varad Gautam <varad.gautam@suse.com>
+ */
+
+#include <asm/cpufeature.h>
+#include <asm/debugreg.h>
+#include <asm/io.h>
+#include <asm/sev-common.h>
+#include <asm/svm.h>
+#include <kunit/test.h>
+#include <linux/kprobes.h>
+
+static struct kretprobe hv_call_krp;
+
+static int hv_call_krp_entry(struct kretprobe_instance *krpi,
+			     struct pt_regs *regs)
+{
+	unsigned long ghcb_vaddr = regs_get_kernel_argument(regs, 0);
+	*((unsigned long *) krpi->data) = ghcb_vaddr;
+
+	return 0;
+}
+
+static int hv_call_krp_ret(struct kretprobe_instance *krpi,
+			   struct pt_regs *regs)
+{
+	unsigned long ghcb_vaddr = *((unsigned long *) krpi->data);
+	struct ghcb *ghcb = (struct ghcb *) ghcb_vaddr;
+	struct kunit *test = current->kunit_test;
+
+	if (test && strstr(test->name, "sev_es_") && test->priv)
+		*((u64 *)test->priv) = ghcb->save.sw_exit_code;
+
+	return 0;
+}
+
+int sev_es_test_vc_init(struct kunit *test)
+{
+	int ret;
+
+	if (!cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
+		kunit_info(test, "Not a SEV-ES guest. Skipping.");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	memset(&hv_call_krp, 0, sizeof(hv_call_krp));
+	hv_call_krp.entry_handler = hv_call_krp_entry;
+	hv_call_krp.handler = hv_call_krp_ret;
+	hv_call_krp.maxactive = 100;
+	hv_call_krp.data_size = sizeof(unsigned long);
+	hv_call_krp.kp.symbol_name = "sev_es_ghcb_hv_call";
+	hv_call_krp.kp.addr = 0;
+
+	ret = register_kretprobe(&hv_call_krp);
+	if (ret) {
+		kunit_info(test, "Could not register kretprobe. Skipping.");
+		goto out;
+	}
+
+	test->priv = kunit_kzalloc(test, sizeof(u64), GFP_KERNEL);
+	if (!test->priv) {
+		ret = -ENOMEM;
+		kunit_info(test, "Could not allocate. Skipping.");
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+void sev_es_test_vc_exit(struct kunit *test)
+{
+	if (test->priv)
+		kunit_kfree(test, test->priv);
+
+	if (hv_call_krp.kp.addr)
+		unregister_kretprobe(&hv_call_krp);
+}
+
+#define check_op(kt, ec, op)			\
+do {						\
+	struct kunit *t = (struct kunit *) kt;	\
+	op;					\
+	KUNIT_EXPECT_EQ(t, (typeof(ec)) ec,	\
+		*((typeof(ec) *)(t->priv)));		\
+} while (0)
+
+static void sev_es_nae_cpuid(struct kunit *test)
+{
+	unsigned int cpuid_fn = 0x8000001f;
+
+	check_op(test, SVM_EXIT_CPUID, native_cpuid_eax(cpuid_fn));
+}
+
+static void sev_es_nae_wbinvd(struct kunit *test)
+{
+	check_op(test, SVM_EXIT_WBINVD, wbinvd());
+}
+
+static void sev_es_nae_msr(struct kunit *test)
+{
+	check_op(test, SVM_EXIT_MSR, __rdmsr(MSR_IA32_TSC));
+}
+
+static void sev_es_nae_dr7_rw(struct kunit *test)
+{
+	check_op(test, SVM_EXIT_WRITE_DR7,
+		   native_set_debugreg(7, native_get_debugreg(7)));
+}
+
+static void sev_es_nae_ioio(struct kunit *test)
+{
+	unsigned long port = 0x80;
+	char val = 0;
+
+	check_op(test, SVM_EXIT_IOIO, val = inb(port));
+	check_op(test, SVM_EXIT_IOIO, outb(val, port));
+	check_op(test, SVM_EXIT_IOIO, insb(port, &val, sizeof(val)));
+	check_op(test, SVM_EXIT_IOIO, outsb(port, &val, sizeof(val)));
+}
+
+static void sev_es_nae_mmio(struct kunit *test)
+{
+	unsigned long lapic_ver_pa = 0xfee00030; /* APIC_DEFAULT_PHYS_BASE + APIC_LVR */
+	unsigned long __iomem *lapic = ioremap(lapic_ver_pa, 0x4);
+	unsigned long lapic_version = 0;
+
+	check_op(test, SVM_VMGEXIT_MMIO_READ, lapic_version = *lapic);
+	check_op(test, SVM_VMGEXIT_MMIO_WRITE, *lapic = lapic_version);
+
+	iounmap(lapic);
+}
+
+static struct kunit_case sev_es_vc_testcases[] = {
+	KUNIT_CASE(sev_es_nae_cpuid),
+	KUNIT_CASE(sev_es_nae_wbinvd),
+	KUNIT_CASE(sev_es_nae_msr),
+	KUNIT_CASE(sev_es_nae_dr7_rw),
+	KUNIT_CASE(sev_es_nae_ioio),
+	KUNIT_CASE(sev_es_nae_mmio),
+	{}
+};
+
+static struct kunit_suite sev_es_vc_test_suite = {
+	.name = "sev_es_test_vc",
+	.init = sev_es_test_vc_init,
+	.exit = sev_es_test_vc_exit,
+	.test_cases = sev_es_vc_testcases,
+};
+kunit_test_suite(sev_es_vc_test_suite);
-- 
2.32.0

