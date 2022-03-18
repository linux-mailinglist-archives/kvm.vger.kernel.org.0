Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CC64DD745
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 10:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbiCRJq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 05:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbiCRJq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 05:46:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21782E7120;
        Fri, 18 Mar 2022 02:45:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7E56521106;
        Fri, 18 Mar 2022 09:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647596736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j91Po3nZulBUNLEMmTrcd0Gf5q5qXtcw62oM/y9MtGM=;
        b=RwOUpvVvs9ls3ETEjNWteR5wQwfZaNS6yPViQJXddBVnM2kbTsb9aol43NQ/nekbHz1VDM
        sNCWXwBL8E6w7hdkYwuYbWZQcqZIfMMFbeetmrjhuNREz/qzujN00pocoC8bMCcX82TCQd
        9ogOGNg70ZYoCF6IX+v+nmBkzazxDQw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647596736;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j91Po3nZulBUNLEMmTrcd0Gf5q5qXtcw62oM/y9MtGM=;
        b=nVfrRN/sFcj/FxvSo62iki3OTGABkLx8HwPBaMqx6va6Lwrv7isqka72kpvR3Tin159dRj
        uzAa1m9Nr3T8PRBg==
Received: from vasant-suse.suse.de (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id 321ECA3B92;
        Fri, 18 Mar 2022 09:45:36 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org
Cc:     bp@alien8.de, x86@kernel.org, thomas.lendacky@amd.com,
        varad.gautam@suse.com, Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v6 2/4] x86/tests: Add tests for AMD SEV-ES #VC handling Add KUnit based tests to validate Linux's VC handling for instructions cpuid and wbinvd. These tests: 1. install a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to access GHCB before/after the resulting VMGEXIT). 2. trigger an NAE by executing either cpuid or wbinvd. 3. check that the kretprobe was hit with the right exit_code available in GHCB.
Date:   Fri, 18 Mar 2022 10:45:30 +0100
Message-Id: <20220318094532.7023-3-vkarasulli@suse.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220318094532.7023-1-vkarasulli@suse.de>
References: <20220318094532.7023-1-vkarasulli@suse.de>
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

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/tests/Makefile      |   2 +
 arch/x86/tests/sev-test-vc.c | 114 +++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)
 create mode 100644 arch/x86/tests/sev-test-vc.c

diff --git a/arch/x86/tests/Makefile b/arch/x86/tests/Makefile
index f66554cd5c45..4beca64bd2aa 100644
--- a/arch/x86/tests/Makefile
+++ b/arch/x86/tests/Makefile
@@ -1 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_AMD_SEV_TEST_VC)	+= sev-test-vc.o
diff --git a/arch/x86/tests/sev-test-vc.c b/arch/x86/tests/sev-test-vc.c
new file mode 100644
index 000000000000..9d415b9708dc
--- /dev/null
+++ b/arch/x86/tests/sev-test-vc.c
@@ -0,0 +1,114 @@
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

