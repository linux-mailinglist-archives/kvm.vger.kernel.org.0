Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E87549CE9
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346213AbiFMTKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348071AbiFMTIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:08:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CB4344FC;
        Mon, 13 Jun 2022 10:04:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 278C01F8F9;
        Mon, 13 Jun 2022 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655139873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gn9ietmj8gdTelf73NeKf1ZXLc/MBdCgQzvoK6rFKsE=;
        b=Nv//hmAtfJPmP6Bq4t85OZg9VXxJudcJ7cd0Q8wGPinYnGEwuBdsF0ilpN6GwSiLQ1dRLX
        4Tz0I8r2dK/WpWqKM064Z8U7cEp7i/VM0okdqk4GFhCk+BA9T4GOuf8nYFOryOSrBBwPjY
        w5fSODjvzyElYwowuJKzG31goJuDn5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655139873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gn9ietmj8gdTelf73NeKf1ZXLc/MBdCgQzvoK6rFKsE=;
        b=9kDsIcxxI3aP5ACZMBTiUhPfiXzIymnZSscNKj/EmShRMKuR+yNYaya6GodHK9U6H9b50u
        xhiq1t8hIo/HrNCA==
Received: from vasant-suse.fritz.box (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id E0F272C141;
        Mon, 13 Jun 2022 17:04:32 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bp@alien8.de, jroedel@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, seanjc@google.com,
        Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v7 1/4] KVM: SEV-ES: Add configuration options to test #VC handling
Date:   Mon, 13 Jun 2022 19:04:17 +0200
Message-Id: <20220613170420.18521-2-vkarasulli@suse.de>
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

Configuration options CONFIG_X86_TESTS and CONFIG_AMD_SEV_ES_TEST_VC
enable the execution of the KUnit tests added under arch/x86/tests that
test AMD SEV-ES #VC handling.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/Kbuild          |  2 ++
 arch/x86/Kconfig.debug   | 19 +++++++++++++++++++
 arch/x86/kernel/Makefile |  7 +++++++
 3 files changed, 28 insertions(+)

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index 5a83da703e87..ec01cd024bae 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -28,5 +28,7 @@ obj-y += net/

 obj-$(CONFIG_KEXEC_FILE) += purgatory/

+obj-y += tests/
+
 # for cleaning
 subdir- += boot tools
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 340399f69954..b0687173fb97 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -278,3 +278,22 @@ endchoice
 config FRAME_POINTER
 	depends on !UNWINDER_ORC && !UNWINDER_GUESS
 	bool
+
+config X86_TESTS
+	bool "x86 unit tests"
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
+	  When this configuration option is enabled, these Kunit tests
+	  get executed at the kernel boot time. Results of the test
+	  execution can be monitored in the kernel log.
+endif # X86_TESTS
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 03364dc40d8d..3fa9ce2a700e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -23,6 +23,13 @@ CFLAGS_REMOVE_head64.o = -pg
 CFLAGS_REMOVE_sev.o = -pg
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
--
2.32.0

