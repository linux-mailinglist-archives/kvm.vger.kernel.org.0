Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30964DD868
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 11:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiCRKtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 06:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiCRKsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 06:48:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A012C57BE;
        Fri, 18 Mar 2022 03:46:50 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8048D1F38E;
        Fri, 18 Mar 2022 10:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647600409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=elhfYpEcfi++YUKVQIaGo3i0soEjTysccIuPgbZtBlw=;
        b=ShVExYtkgd0cUNgcgI0M3PA8opJXV1sRtMI+lT1Zp2Qoc/IzciX03iYTdi/yQgr12hDIVw
        A7U5ZDmwQeipGm5RsUz0sZQiblzV9xqyFLrp6Ivc3ZBzeRekxiJFro5/guiPd7x/qCU3UK
        HxxV/PtM/NnLqqke0T2qybC7bp3zy0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647600409;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=elhfYpEcfi++YUKVQIaGo3i0soEjTysccIuPgbZtBlw=;
        b=Q/n7wkBRdWzh8Z8KulBCNp4bZs6oZMDQpBiX2tkapiflkd435BJdOCl5ep1orVN6Kw3JFj
        c4hzco6kbgygMwAg==
Received: from vasant-suse.suse.de (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id 42229A3B88;
        Fri, 18 Mar 2022 10:46:49 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org
Cc:     bp@alien8.de, x86@kernel.org, thomas.lendacky@amd.com,
        varad.gautam@suse.com, Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v6 1/4] x86/tests: Add tests for AMD SEV-ES #VC handling
Date:   Fri, 18 Mar 2022 11:46:43 +0100
Message-Id: <20220318104646.8313-2-vkarasulli@suse.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220318104646.8313-1-vkarasulli@suse.de>
References: <20220318104646.8313-1-vkarasulli@suse.de>
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

 Add Kconfig options for testing AMD SEV
 related features.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/Kbuild          |  2 ++
 arch/x86/Kconfig.debug   | 16 ++++++++++++++++
 arch/x86/kernel/Makefile |  7 +++++++
 arch/x86/tests/Makefile  |  1 +
 4 files changed, 26 insertions(+)
 create mode 100644 arch/x86/tests/Makefile

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
index 000000000000..f66554cd5c45
--- /dev/null
+++ b/arch/x86/tests/Makefile
@@ -0,0 +1 @@
+# SPDX-License-Identifier: GPL-2.0
--
2.32.0

