Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6870A549CE4
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347266AbiFMTKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347693AbiFMTIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:08:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C2D35262;
        Mon, 13 Jun 2022 10:04:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A5AFB21B20;
        Mon, 13 Jun 2022 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655139873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y7XqRusKLZHg2MAsYj31tc7FKcxL4xcYD2sDGg0rjck=;
        b=1uGoiuXPUKuk38YwfxQ/jX0RG/8piqm5i7lVWT4hCP6Kcj485+B2yDRsOBGEegq+hHWsF9
        4UrOkwPiz6ZTfjOxVhaLrpb3ABC0etDA9HNeCHJF4cEFefQyw5p1lqjVefO5+oO3jgF52E
        +WoSsMQsf7FC73XBkp4HvAKDnhRVziY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655139873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y7XqRusKLZHg2MAsYj31tc7FKcxL4xcYD2sDGg0rjck=;
        b=ETxTyfqN4F2E592ZrQLZuJb45I5sVfYoswnJy5ON37LkEklgxbDy0l4KKTSkvIkE6o6tJh
        S4FjFoB1G68ubnCA==
Received: from vasant-suse.fritz.box (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id 6E6D92C143;
        Mon, 13 Jun 2022 17:04:33 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bp@alien8.de, jroedel@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, seanjc@google.com,
        Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v7 3/4] KVM: SEV-ES: Add tests to validate VC handling for MSR and DR7 register accesses
Date:   Mon, 13 Jun 2022 19:04:19 +0200
Message-Id: <20220613170420.18521-4-vkarasulli@suse.de>
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
   2. trigger an NAE by accessing either MSR or DR7.
   3. check that the kretprobe was hit with the right exit_code available
      in GHCB.

To run these tests, configuration options CONFIG_X86_TESTS and
CONFIG_AMD_SEV_ES_TEST_VC have to be enabled. These tests run
at the kernel boot time. Result of the test execution can be
monitored in the kernel log.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/tests/sev-test-vc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/tests/sev-test-vc.c b/arch/x86/tests/sev-test-vc.c
index 900ca357a273..629aa0ca1c86 100644
--- a/arch/x86/tests/sev-test-vc.c
+++ b/arch/x86/tests/sev-test-vc.c
@@ -7,6 +7,7 @@

 #include <asm/cpufeature.h>
 #include <asm/sev-common.h>
+#include <asm/debugreg.h>
 #include <asm/svm.h>
 #include <kunit/test.h>
 #include <linux/kprobes.h>
@@ -89,9 +90,22 @@ static void sev_es_nae_wbinvd(struct kunit *test)
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

