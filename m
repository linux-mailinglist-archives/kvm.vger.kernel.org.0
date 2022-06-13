Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E42549CF5
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348388AbiFMTKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347719AbiFMTIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:08:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362303700E;
        Mon, 13 Jun 2022 10:04:35 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E371821BD6;
        Mon, 13 Jun 2022 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655139873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7OtOWClBlY6896CUL2CJUoXz5Le8Wk1ooKrdR/9iq2M=;
        b=xp0mmWyEfPaQm+HgDu9ihr5D73ZTYPe7veggysbfEXnAI4CVVUVIEpa1f0FyNiFf2lYknH
        g1KdLbOxKBEkWIixu7mecIMyTD4oM/KDOwd+1A6knCkskwZmPItQlXudcI7ewSGsysMtqI
        /Kp+RhmamogNS2jELlF7u+F8cLiQN9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655139873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7OtOWClBlY6896CUL2CJUoXz5Le8Wk1ooKrdR/9iq2M=;
        b=jM7YYjvLtx6DNW15GGyf0dqs+QE8ufAtcH3oKUItx8uYtMOiFYhJ7OHtlPwP/K7AS862hF
        2iooN3q0V9F0fpCw==
Received: from vasant-suse.fritz.box (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id AC69E2C141;
        Mon, 13 Jun 2022 17:04:33 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bp@alien8.de, jroedel@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, seanjc@google.com,
        Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v7 4/4] KVM SEV-ES: Add tests to validate VC handling for IO instructions
Date:   Mon, 13 Jun 2022 19:04:20 +0200
Message-Id: <20220613170420.18521-5-vkarasulli@suse.de>
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
   2. trigger an NAE by issuing an IO instruction.
   3. check that the kretprobe was hit with the right
      exit_code available in GHCB.

To run these tests, configuration options CONFIG_X86_TESTS and
CONFIG_AMD_SEV_ES_TEST_VC have to be enabled. These tests run
at the kernel boot time. Result of the test execution can be
monitored in the kernel log.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/tests/sev-test-vc.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/tests/sev-test-vc.c b/arch/x86/tests/sev-test-vc.c
index 629aa0ca1c86..33ca761bf9cb 100644
--- a/arch/x86/tests/sev-test-vc.c
+++ b/arch/x86/tests/sev-test-vc.c
@@ -8,7 +8,9 @@
 #include <asm/cpufeature.h>
 #include <asm/sev-common.h>
 #include <asm/debugreg.h>
+#include <asm/io.h>
 #include <asm/svm.h>
+#include <asm/apicdef.h>
 #include <kunit/test.h>
 #include <linux/kprobes.h>

@@ -101,11 +103,36 @@ static void sev_es_nae_dr7_rw(struct kunit *test)
 		   native_set_debugreg(7, native_get_debugreg(7)));
 }

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
+	unsigned long lapic_ver_pa = APIC_DEFAULT_PHYS_BASE + APIC_LVR;
+	unsigned long __iomem *lapic = ioremap(lapic_ver_pa, 0x4);
+	unsigned long lapic_version = 0;
+
+	check_op(test, SVM_VMGEXIT_MMIO_READ, lapic_version = *lapic);
+	check_op(test, SVM_VMGEXIT_MMIO_WRITE, *lapic = lapic_version);
+
+	iounmap(lapic);
+}
+
 static struct kunit_case sev_es_vc_testcases[] = {
 	KUNIT_CASE(sev_es_nae_cpuid),
 	KUNIT_CASE(sev_es_nae_wbinvd),
 	KUNIT_CASE(sev_es_nae_msr),
 	KUNIT_CASE(sev_es_nae_dr7_rw),
+	KUNIT_CASE(sev_es_nae_ioio),
+	KUNIT_CASE(sev_es_nae_mmio),
 	{}
 };

--
2.32.0

