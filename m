Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3AD549CF1
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348069AbiFMTKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347659AbiFMTIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:08:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83AE344E2;
        Mon, 13 Jun 2022 10:04:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6850C21B02;
        Mon, 13 Jun 2022 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655139873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b7X589VWrIUFJoNoWquElpqrv8TAnvhX16s1XXo/inY=;
        b=RikLPCF39pVt3g3b4ugbUekSgX96TB3fL+WAFK5x9fSGCQxmswvZfjuWv+vJ3UwLpYdd8p
        JcmvyiN4zHj2LyDI7N12G0RGEThqKpODd59Ua6Wz8i3isycni2n+fXx4oGl9THn+R+BLF4
        O4iLbslL8oVJjNLZQdTERDzBBBSxiFY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655139873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b7X589VWrIUFJoNoWquElpqrv8TAnvhX16s1XXo/inY=;
        b=eNl5+EEZ5LPM+oVlbys4uV0gdHanrKxULODcCG8Ql4RyL6SD3K90H1hwFnLH33O3ZDhIR/
        WwTarEir+HDmNQAg==
Received: from vasant-suse.fritz.box (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id 2E78F2C142;
        Mon, 13 Jun 2022 17:04:33 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bp@alien8.de, jroedel@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, seanjc@google.com,
        Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v7 2/4] KVM: SEV-ES:  Add tests to validate VC handling for CPUID and WBINVD
Date:   Mon, 13 Jun 2022 19:04:18 +0200
Message-Id: <20220613170420.18521-3-vkarasulli@suse.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220613170420.18521-1-vkarasulli@suse.de>
References: <20220613170420.18521-1-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These tests:
     1. install a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to
        access GHCB before/after the resulting VMGEXIT).
     2. trigger an NAE by executing either CPUID or WBINVD.
     3. check that the kretprobe was hit with the right exit_code
        available in GHCB.

To run these tests, configuration options CONFIG_X86_TESTS and
CONFIG_AMD_SEV_ES_TEST_VC have to be enabled. These tests run
at the kernel boot time. Result of the test execution can be
monitored in the kernel log.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/tests/Makefile      |   3 +
 arch/x86/tests/sev-test-vc.c | 104 +++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+)
 create mode 100644 arch/x86/tests/Makefile
 create mode 100644 arch/x86/tests/sev-test-vc.c

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
index 000000000000..900ca357a273
--- /dev/null
+++ b/arch/x86/tests/sev-test-vc.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 SUSE
+ *
+ * Author: Varad Gautam <varad.gautam@suse.com>
+ */
+
+#include <asm/cpufeature.h>
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
+	if (test && strstr(test->name, "sev_es_"))
+		*((u64 *)&test->priv) = ghcb->save.sw_exit_code;
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
+out:
+	return ret;
+}
+
+void sev_es_test_vc_exit(struct kunit *test)
+{
+	if (hv_call_krp.kp.addr)
+		unregister_kretprobe(&hv_call_krp);
+}
+
+#define check_op(kt, ec, op)			        \
+do {						        \
+	struct kunit *t = (struct kunit *) kt;	        \
+	op;					        \
+	KUNIT_EXPECT_EQ(t, (typeof(ec)) ec,	        \
+			((typeof(ec))((u64)(t->priv))));\
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
+static struct kunit_case sev_es_vc_testcases[] = {
+	KUNIT_CASE(sev_es_nae_cpuid),
+	KUNIT_CASE(sev_es_nae_wbinvd),
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

