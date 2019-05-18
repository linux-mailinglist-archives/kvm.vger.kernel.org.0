Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93A1A22586
	for <lists+kvm@lfdr.de>; Sun, 19 May 2019 01:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfERXNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 May 2019 19:13:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46486 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfERXNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 May 2019 19:13:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id r18so4966681pls.13
        for <kvm@vger.kernel.org>; Sat, 18 May 2019 16:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HesjF5OcICMtyDJeDNsoDyFaLywLAMbKwcCUe/WyvG8=;
        b=aY/nyuwmOb4nEpoFAVwpbn9XpO49efR8j5H7B9QwlWq6H6Aspn0AJtuzuo8bZUBjgl
         MpgbSz20qiK4j8Vq3bq6y2arobdXuQz8RQK4Lc/3BkAQWbmgwi6EUyE+WlrVCZMekJt5
         6XuM07pmlUnv0/bserZPdwP6VJiOVDQWqHmoPsNzkD1x1WCo3g2SUzYEpJVRompmY9pL
         muQSmhRnTUMLo3QF1x/lc2Uv2t/Z+oB035TH1PaP0flTZ43KiFQkJvAUUhPtgpGBnBpP
         /kMGbMANBOK32qP0bfgE/5NIXz8oHeGgrV9Ogkk1so+kxsEirhAJBQSW1j5lfYJOUohS
         2P6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HesjF5OcICMtyDJeDNsoDyFaLywLAMbKwcCUe/WyvG8=;
        b=c+qtoybS7jRUAjBh8vjVCK1GnX6NJlHrFKjU06g0K6l36R3umC/IlzxA9G/KytZoj7
         fS4+A61XFStO7Sj1AOp3WxaEvppRmwZgeAEmOtuOqfmmH4bW3mJNaaEcCwieQIvoNDAS
         yEOHCpPDvZajc4ReSK1LaFszggfr69xva5Jiu4yHP4aabKn9K3g8fL0WcV7mjJv+58mG
         x4fGmD0hon6FiLiHSbvs4pdjgX2j81lJthwrgvJ4bidWgteI09cLlLlKXmyenN7OQ7er
         n3Pf5nLJCt2PWdjXaP4t38LeBQt0DATcNvATnxGw1t8D+xf4fdhMn74XTrN3peX5oJ54
         BONA==
X-Gm-Message-State: APjAAAVETRgaggfnHajuBnmAv+n+5yUSBvDDToIfSwp8CYupXjStsJ9w
        gEcQ4RRrfKuoT5HTa1Tv9F0=
X-Google-Smtp-Source: APXvYqze/NB3VX/0gM+bZNyybwQK561zvBQW9uZkVV8IxqRMC1Ahc/eM1Pk3aQwaScIMxcnHvixPrg==
X-Received: by 2002:a17:902:347:: with SMTP id 65mr54132617pld.232.1558221209563;
        Sat, 18 May 2019 16:13:29 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id a6sm15671757pgd.67.2019.05.18.16.13.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 16:13:28 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: Do not run vmx tests if feature is unsupported by CPU
Date:   Sat, 18 May 2019 08:53:21 -0700
Message-Id: <20190518155321.3832-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instruction tests of VMX should not be executed if the feature is
unsupported by the CPU. Even if the execution controls allow to trap
exits on the feature, the feature might be disabled, for example through
IA32_MISC_ENABLES. Therefore, checking that the feature is supported
through CPUID is needed.

Introduce a general mechanism to check that a feature is supported and
use it for monitor/mwait.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx_tests.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index cade812..bdff938 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -842,6 +842,17 @@ extern void insn_rdseed(void);
 u32 cur_insn;
 u64 cr3;
 
+#define X86_FEATURE_MONITOR	(1 << 3)
+#define X86_FEATURE_MCE		(1 << 7)
+#define X86_FEATURE_PCID	(1 << 17)
+
+typedef bool (*supported_fn)(void);
+
+static bool monitor_supported(void)
+{
+	return cpuid(1).c & X86_FEATURE_MONITOR;
+}
+
 struct insn_table {
 	const char *name;
 	u32 flag;
@@ -853,6 +864,8 @@ struct insn_table {
 	// Use FIELD_EXIT_QUAL and FIELD_INSN_INFO to define
 	// which field need to be tested, reason is always tested
 	u32 test_field;
+	const supported_fn supported_fn;
+	u8 disabled;
 };
 
 /*
@@ -868,7 +881,7 @@ static struct insn_table insn_table[] = {
 	{"HLT",  CPU_HLT, insn_hlt, INSN_CPU0, 12, 0, 0, 0},
 	{"INVLPG", CPU_INVLPG, insn_invlpg, INSN_CPU0, 14,
 		0x12345678, 0, FIELD_EXIT_QUAL},
-	{"MWAIT", CPU_MWAIT, insn_mwait, INSN_CPU0, 36, 0, 0, 0},
+	{"MWAIT", CPU_MWAIT, insn_mwait, INSN_CPU0, 36, 0, 0, 0, &monitor_supported},
 	{"RDPMC", CPU_RDPMC, insn_rdpmc, INSN_CPU0, 15, 0, 0, 0},
 	{"RDTSC", CPU_RDTSC, insn_rdtsc, INSN_CPU0, 16, 0, 0, 0},
 	{"CR3 load", CPU_CR3_LOAD, insn_cr3_load, INSN_CPU0, 28, 0x3, 0,
@@ -881,7 +894,7 @@ static struct insn_table insn_table[] = {
 	{"CR8 store", CPU_CR8_STORE, insn_cr8_store, INSN_CPU0, 28, 0x18, 0,
 		FIELD_EXIT_QUAL},
 #endif
-	{"MONITOR", CPU_MONITOR, insn_monitor, INSN_CPU0, 39, 0, 0, 0},
+	{"MONITOR", CPU_MONITOR, insn_monitor, INSN_CPU0, 39, 0, 0, 0, &monitor_supported},
 	{"PAUSE", CPU_PAUSE, insn_pause, INSN_CPU0, 40, 0, 0, 0},
 	// Flags for Secondary Processor-Based VM-Execution Controls
 	{"WBINVD", CPU_WBINVD, insn_wbinvd, INSN_CPU1, 54, 0, 0, 0},
@@ -904,13 +917,19 @@ static struct insn_table insn_table[] = {
 
 static int insn_intercept_init(struct vmcs *vmcs)
 {
-	u32 ctrl_cpu;
+	u32 ctrl_cpu, cur_insn;
 
 	ctrl_cpu = ctrl_cpu_rev[0].set | CPU_SECONDARY;
 	ctrl_cpu &= ctrl_cpu_rev[0].clr;
 	vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu);
 	vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu_rev[1].set);
 	cr3 = read_cr3();
+
+	for (cur_insn = 0; insn_table[cur_insn].name != NULL; cur_insn++) {
+		if (insn_table[cur_insn].supported_fn == NULL)
+			continue;
+		insn_table[cur_insn].disabled = !insn_table[cur_insn].supported_fn();
+	}
 	return VMX_TEST_START;
 }
 
@@ -928,6 +947,12 @@ static void insn_intercept_main(void)
 			continue;
 		}
 
+		if (insn_table[cur_insn].disabled) {
+			printf("\tFeature required for %s is not supported.\n",
+			       insn_table[cur_insn].name);
+			continue;
+		}
+
 		if ((insn_table[cur_insn].type == INSN_CPU0 &&
 		     !(ctrl_cpu_rev[0].set & insn_table[cur_insn].flag)) ||
 		    (insn_table[cur_insn].type == INSN_CPU1 &&
@@ -6841,9 +6866,6 @@ static void vmentry_movss_shadow_test(void)
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
 }
 
-#define X86_FEATURE_PCID       (1 << 17)
-#define X86_FEATURE_MCE        (1 << 7)
-
 static int write_cr4_checking(unsigned long val)
 {
 	asm volatile(ASM_TRY("1f")
-- 
2.17.1

