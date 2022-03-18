Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5614DD748
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 10:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbiCRJq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 05:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbiCRJq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 05:46:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2CD2C3DFE;
        Fri, 18 Mar 2022 02:45:38 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DF9C31F390;
        Fri, 18 Mar 2022 09:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647596736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=46+RjIEClxR9XFFyT7pvwEuTqwhr+bO0mNiF6x4dYhs=;
        b=XYVS/T7iOGGrjQCLLd0iRjY6srB39CwNkYjb8Gu5a6YDoEV2rlkpHIAYqmYTr57eEtgRLZ
        HvSJp9msNyR5FedXA1ISWuv0yvd+4DUihbAiYeeEjHLOzELE+SXdWntpVLyyIdJPaenr81
        x4OeqnopjJt+OAtWXIr8jKHJDHdfvfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647596736;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=46+RjIEClxR9XFFyT7pvwEuTqwhr+bO0mNiF6x4dYhs=;
        b=dm1dO3EBFos5cJfavv8X3IDH550LLeHa3PtB3orJ9jpF20O14xrQS/xj9wV/bScv4iS0Z9
        MF+kFGAKojj1wMDw==
Received: from vasant-suse.suse.de (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id 8B942A3B81;
        Fri, 18 Mar 2022 09:45:36 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org
Cc:     bp@alien8.de, x86@kernel.org, thomas.lendacky@amd.com,
        varad.gautam@suse.com, Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v6 3/4] x86/tests: Add tests for AMD SEV-ES #VC handling Add KUnit based tests to validate Linux's VC handling for instructions accessing registers such as MSR and DR7. These tests: 1. install a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to access GHCB before/after the resulting VMGEXIT). 2. trigger an NAE by accessing either MSR or DR7. 3. check that the kretprobe was hit with the right exit_code available in GHCB.
Date:   Fri, 18 Mar 2022 10:45:31 +0100
Message-Id: <20220318094532.7023-4-vkarasulli@suse.de>
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
 arch/x86/tests/sev-test-vc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/tests/sev-test-vc.c b/arch/x86/tests/sev-test-vc.c
index 9d415b9708dc..b27b9f114a12 100644
--- a/arch/x86/tests/sev-test-vc.c
+++ b/arch/x86/tests/sev-test-vc.c
@@ -7,6 +7,7 @@

 #include <asm/cpufeature.h>
 #include <asm/sev-common.h>
+#include <asm/debugreg.h>
 #include <asm/svm.h>
 #include <kunit/test.h>
 #include <linux/kprobes.h>
@@ -99,9 +100,22 @@ static void sev_es_nae_wbinvd(struct kunit *test)
 	check_op(test, SVM_EXIT_WBINVD, wbinvd());
 }

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
 static struct kunit_case sev_es_vc_testcases[] = {
 	KUNIT_CASE(sev_es_nae_cpuid),
 	KUNIT_CASE(sev_es_nae_wbinvd),
+	KUNIT_CASE(sev_es_nae_msr),
+	KUNIT_CASE(sev_es_nae_dr7_rw),
 	{}
 };

--
2.32.0

