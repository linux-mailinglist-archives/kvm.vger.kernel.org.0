Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C418398E3C
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 17:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhFBPUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 11:20:11 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58470 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhFBPUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 11:20:10 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D936322BCC;
        Wed,  2 Jun 2021 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622647106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xwiNFasbWPElTA67bc6SiF98MBFIqX9yXTH9bP0dODk=;
        b=AnkbJdmMPDma7/9/tt9UQI5UaxU2hcCYgKash0Dt+hDj8WzkYYBZ8o2hB6cE/ME00NohEz
        WpkwQkXj2HPreV4MZyRLNHD2/RbO0DbSZgq+Wj6aq8L9iqAzTGZMQqmwwEQec7pJk9rGyg
        wDhybyYYrqbYMn5jSgJrIlS1Lq1bYr8=
Received: by imap.suse.de (Postfix, from userid 51)
        id CDAB711CDB; Wed,  2 Jun 2021 15:28:32 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 935CC11D81;
        Wed,  2 Jun 2021 10:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622629425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xwiNFasbWPElTA67bc6SiF98MBFIqX9yXTH9bP0dODk=;
        b=plH+bLhaIjZGR4v9T5CxvzsBDF3E8kPFNxc0FIap/GG0pDE7mQ/gp3WabTFjCm6CglSRmo
        DVf0qzVmn5zdr9P8hxeK7d+8tHo23wvpPpjM6fEho1Q6u2lfUjSeazuUeosvlGS8FTMIM2
        t86eGue92wang57/obhvCzcJT4qRxVI=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id HSM0IjFct2BZSgAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Wed, 02 Jun 2021 10:23:45 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3] x86: Add a test for AMD SEV-ES guest #VC handling
Date:   Wed,  2 Jun 2021 12:23:40 +0200
Message-Id: <20210602102340.19441-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210531125035.21105-1-varad.gautam@suse.com>
References: <20210531125035.21105-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 arch/x86/Kconfig                 |   9 ++
 arch/x86/kernel/Makefile         |   8 ++
 arch/x86/kernel/sev-es-test-vc.c | 155 +++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+)
 create mode 100644 arch/x86/kernel/sev-es-test-vc.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0045e1b441902..85b8ac450ba56 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1543,6 +1543,15 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
 	  If set to N, then the encryption of system memory can be
 	  activated with the mem_encrypt=on command line option.
 
+config AMD_SEV_ES_TEST_VC
+	bool "Test for AMD SEV-ES VC exception handling."
+	depends on AMD_MEM_ENCRYPT
+	select FUNCTION_TRACER
+	select KPROBES
+	select KUNIT
+	help
+	  Enable KUnit-based testing for AMD SEV-ES #VC exception handling.
+
 # Common NUMA Features
 config NUMA
 	bool "NUMA Memory Allocation and Scheduler Support"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0f66682ac02a6..1632d6156be6e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -23,6 +23,13 @@ CFLAGS_REMOVE_head64.o = -pg
 CFLAGS_REMOVE_sev.o = -pg
 endif
 
+# AMD_SEV_ES_TEST_VC registers a kprobe by function name. IPA-SRA creates
+# function copies and renames them to have an .isra suffix, which breaks kprobes'
+# lookup. Build with -fno-ipa-sra for the test.
+ifdef CONFIG_AMD_SEV_ES_TEST_VC
+CFLAGS_sev.o	+= -fno-ipa-sra
+endif
+
 KASAN_SANITIZE_head$(BITS).o				:= n
 KASAN_SANITIZE_dumpstack.o				:= n
 KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
@@ -149,6 +156,7 @@ obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
 obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)		+= sev.o
+obj-$(CONFIG_AMD_SEV_ES_TEST_VC)	+= sev-es-test-vc.o
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/sev-es-test-vc.c b/arch/x86/kernel/sev-es-test-vc.c
new file mode 100644
index 0000000000000..98dc38572ed5d
--- /dev/null
+++ b/arch/x86/kernel/sev-es-test-vc.c
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
+		cmpxchg((unsigned long *) test->priv, ghcb->save.sw_exit_code, 1);
+
+	return 0;
+}
+
+int sev_es_test_vc_init(struct kunit *test)
+{
+	int ret;
+
+	if (!sev_es_active()) {
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
+	test->priv = kunit_kzalloc(test, sizeof(unsigned long), GFP_KERNEL);
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
+#define guarded_op(kt, ec, op)						\
+do {									\
+	struct kunit *t = (struct kunit *) kt;				\
+	smp_store_release((typeof(ec) *) t->priv, ec);			\
+	op;								\
+	KUNIT_EXPECT_EQ(t, (typeof(ec)) 1, 				\
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
2.30.2

