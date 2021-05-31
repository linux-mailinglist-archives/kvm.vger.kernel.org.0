Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B332F396709
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 19:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhEaR3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 13:29:32 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50650 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbhEaR3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 13:29:19 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A1B861FD2D;
        Mon, 31 May 2021 17:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622482054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9r+HYlHoDmXgDEx/An+i51OIXR93+B0KpGhVQdrq2ug=;
        b=Ioq8YZwwWG+c/LG8OkwMX8dnz44ErBxS0wdLi1yq1IueF6vSHbjX269GM9tiMZ3wks7aZi
        BiluPS4Tc2lJ1ZpBjmi617tc4pO2YnKzLQs+Sm6pjaWg5hC2Am6OW5fuaJ2reOHb60gf9K
        VfObev3hM7B95hVjU9dPDjFX3wH3hps=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id F13C4118DD;
        Mon, 31 May 2021 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622482054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9r+HYlHoDmXgDEx/An+i51OIXR93+B0KpGhVQdrq2ug=;
        b=Ioq8YZwwWG+c/LG8OkwMX8dnz44ErBxS0wdLi1yq1IueF6vSHbjX269GM9tiMZ3wks7aZi
        BiluPS4Tc2lJ1ZpBjmi617tc4pO2YnKzLQs+Sm6pjaWg5hC2Am6OW5fuaJ2reOHb60gf9K
        VfObev3hM7B95hVjU9dPDjFX3wH3hps=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id LYHcOIUctWAXWgAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Mon, 31 May 2021 17:27:33 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v2] x86: Add a test for AMD SEV-ES #VC handling
Date:   Mon, 31 May 2021 19:27:07 +0200
Message-Id: <20210531172707.7909-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210531125035.21105-1-varad.gautam@suse.com>
References: <20210531125035.21105-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: imap.suse.de;
        none
X-Spam-Level: 
X-Spam-Score: 0.00
X-Spamd-Result: default: False [0.00 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         REPLY(-4.00)[];
         BROKEN_CONTENT_TYPE(1.50)[];
         DKIM_SIGNED(0.00)[suse.com:s=susede1];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCPT_COUNT_SEVEN(0.00)[7];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2]
X-Spam-Flag: NO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some vmexits on a SEV-ES guest need special handling within the guest
before exiting to the hypervisor. This must happen within the guest's
\#VC exception handler, triggered on every non automatic exit.

Add a KUnit based test to validate Linux's VC handling. The test:
1. installs a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to
   access GHCB before/after the resulting VMGEXIT).
2. tiggers an NAE.
3. checks that the kretprobe was hit with the right exit_code available
   in GHCB.

Since relying on kprobes, the test does not cover NMI contexts.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
v2: Add a testcase for MMIO read/write.

 arch/x86/Kconfig              |   9 ++
 arch/x86/kernel/Makefile      |   5 ++
 arch/x86/kernel/sev-test-vc.c | 155 ++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+)
 create mode 100644 arch/x86/kernel/sev-test-vc.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0045e1b441902..0a3c3f31813f1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1543,6 +1543,15 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
 	  If set to N, then the encryption of system memory can be
 	  activated with the mem_encrypt=on command line option.
 
+config AMD_MEM_ENCRYPT_TEST_VC
+	bool "Test for AMD Secure Memory Encryption (SME) support"
+	depends on AMD_MEM_ENCRYPT
+	select KUNIT
+	select FUNCTION_TRACER
+	help
+	  Enable KUnit-based testing for the encryption of system memory
+	  using AMD SEV-ES. Currently only tests #VC handling.
+
 # Common NUMA Features
 config NUMA
 	bool "NUMA Memory Allocation and Scheduler Support"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0f66682ac02a6..360c5d33580ca 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -23,6 +23,10 @@ CFLAGS_REMOVE_head64.o = -pg
 CFLAGS_REMOVE_sev.o = -pg
 endif
 
+ifdef CONFIG_AMD_MEM_ENCRYPT_TEST_VC
+CFLAGS_sev.o	+= -fno-ipa-sra
+endif
+
 KASAN_SANITIZE_head$(BITS).o				:= n
 KASAN_SANITIZE_dumpstack.o				:= n
 KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
@@ -149,6 +153,7 @@ obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
 obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)		+= sev.o
+obj-$(CONFIG_AMD_MEM_ENCRYPT_TEST_VC)	+= sev-test-vc.o
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/sev-test-vc.c b/arch/x86/kernel/sev-test-vc.c
new file mode 100644
index 0000000000000..2475270b844e8
--- /dev/null
+++ b/arch/x86/kernel/sev-test-vc.c
@@ -0,0 +1,155 @@
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
+				    struct pt_regs *regs)
+{
+	unsigned long ghcb_vaddr = regs_get_kernel_argument(regs, 0);
+	*((unsigned long *) krpi->data) = ghcb_vaddr;
+
+	return 0;
+}
+
+static int hv_call_krp_ret(struct kretprobe_instance *krpi,
+				    struct pt_regs *regs)
+{
+	unsigned long ghcb_vaddr = *((unsigned long *) krpi->data);
+	struct ghcb *ghcb = (struct ghcb *) ghcb_vaddr;
+	struct kunit *test = current->kunit_test;
+
+	if (test && strstr(test->name, "sev_es_") && test->priv)
+		cmpxchg((unsigned long *) test->priv, ghcb->save.sw_exit_code, 1);
+
+	return 0;
+}
+
+int sev_test_vc_init(struct kunit *test)
+{
+	int ret;
+
+	if (!sev_es_active()) {
+		pr_err("Not a SEV-ES guest. Skipping.");
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
+	if (ret < 0) {
+		pr_err("Could not register kretprobe. Skipping.");
+		goto out;
+	}
+
+	test->priv = kunit_kzalloc(test, sizeof(unsigned long), GFP_KERNEL);
+	if (!test->priv) {
+		ret = -ENOMEM;
+		pr_err("Could not allocate. Skipping.");
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+void sev_test_vc_exit(struct kunit *test)
+{
+	if (test->priv)
+		kunit_kfree(test, test->priv);
+
+	if (hv_call_krp.kp.addr)
+		unregister_kretprobe(&hv_call_krp);
+}
+
+#define guarded_op(kt, ec, op)				\
+do {							\
+	struct kunit *t = (struct kunit *) kt;		\
+	smp_store_release((typeof(ec) *) t->priv, ec);	\
+	op;						\
+	KUNIT_EXPECT_EQ(t, (typeof(ec)) 1, 		\
+		(typeof(ec)) smp_load_acquire((typeof(ec) *) t->priv));	\
+} while(0)
+
+static void sev_es_nae_cpuid(struct kunit *test)
+{
+	unsigned int cpuid_fn = 0x8000001f;
+
+	guarded_op(test, SVM_EXIT_CPUID, native_cpuid_eax(cpuid_fn));
+}
+
+static void sev_es_nae_wbinvd(struct kunit *test)
+{
+	guarded_op(test, SVM_EXIT_WBINVD, wbinvd());
+}
+
+static void sev_es_nae_msr(struct kunit *test)
+{
+	guarded_op(test, SVM_EXIT_MSR, __rdmsr(MSR_IA32_TSC));
+}
+
+static void sev_es_nae_dr7_rw(struct kunit *test)
+{
+	guarded_op(test, SVM_EXIT_WRITE_DR7,
+		   native_set_debugreg(7, native_get_debugreg(7)));
+}
+
+static void sev_es_nae_ioio(struct kunit *test)
+{
+	unsigned long port = 0x80;
+	char val = 0;
+
+	guarded_op(test, SVM_EXIT_IOIO, val = inb(port));
+	guarded_op(test, SVM_EXIT_IOIO, outb(val, port));
+	guarded_op(test, SVM_EXIT_IOIO, insb(port, &val, sizeof(val)));
+	guarded_op(test, SVM_EXIT_IOIO, outsb(port, &val, sizeof(val)));
+}
+
+static void sev_es_nae_mmio(struct kunit *test)
+{
+	unsigned long lapic_ver_pa = 0xfee00030; /* APIC_DEFAULT_PHYS_BASE + APIC_LVR */
+	unsigned __iomem *lapic = ioremap(lapic_ver_pa, 0x4);
+	unsigned lapic_version = 0;
+
+	guarded_op(test, SVM_VMGEXIT_MMIO_READ, lapic_version = *lapic);
+	guarded_op(test, SVM_VMGEXIT_MMIO_WRITE, *lapic = lapic_version);
+
+	iounmap(lapic);
+}
+
+static struct kunit_case sev_test_vc_testcases[] = {
+	KUNIT_CASE(sev_es_nae_cpuid),
+	KUNIT_CASE(sev_es_nae_wbinvd),
+	KUNIT_CASE(sev_es_nae_msr),
+	KUNIT_CASE(sev_es_nae_dr7_rw),
+	KUNIT_CASE(sev_es_nae_ioio),
+	KUNIT_CASE(sev_es_nae_mmio),
+	{}
+};
+
+static struct kunit_suite sev_vc_test_suite = {
+	.name = "sev_test_vc",
+	.init = sev_test_vc_init,
+	.exit = sev_test_vc_exit,
+	.test_cases = sev_test_vc_testcases,
+};
+kunit_test_suite(sev_vc_test_suite);
-- 
2.30.2

