Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8259347068D
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243175AbhLJRBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 12:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243073AbhLJRBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 12:01:49 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9B4C0617A1
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:58:14 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gf12-20020a17090ac7cc00b001a968c11642so6287717pjb.4
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eKQesUFjYD5NfEB4UvQVXF1znz9HszyH0XL6Z4lPT7E=;
        b=pLZZPADyNN9UJUo/y6m5A586urPxDvD011OjasTyFvpXgxTNPjOdg4iIuHxKiis28b
         zNXWr9X95dauDgG3SrAnWBEDXRw85qrjzgoryyRAoZs9IDhRNTrUol+9RkTtWpiFZKYd
         JSRVHeBkx7lA35hOQxSuziYZFqaf5O5VjQYuHex/vmZtI3gnG/mXbW0WXAyEARz2KNSF
         Di9yci3dLMjlRZO7xrg/io5jI12uK7rcIAT0ZiomJw0mFuwJeYIm1T+BIMJQn3IwxSBL
         NLVrOVQrkanj5ipPAlHDFA/GrGtvruUASEbJEApUjdtEy2Vw1qvgBKVhh3z+5ssnjgD0
         Ulhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eKQesUFjYD5NfEB4UvQVXF1znz9HszyH0XL6Z4lPT7E=;
        b=GawL7OVBQ8PFuzQk3I5LfSSapqUUoaLFrnnACBCNMODy2x4uNIhbEDBGVOLuxOcG6N
         SoYuFDPutshwsWY9CJfDQ+tiJc7b0rSyI3Lxmh68uHo6W+iCYoqxwPJY6HJkNG0jfbsl
         F+pB4zCHv5sOLyE4ycLx+ZSLbm3S6d9ZBlXEVNMykpujc+m2lmof81KYCb/BoceVnCrA
         Yb54+mXn/4dphMs5ALS9mNTeJ+LN+O9UOAcT+yVqGKeP2lRNtKmuP/OivUXR6piQ01NM
         z0J8ZPJum9R1TKsun6S9bELTNLVnlipifsAHSf2rsCCGPW34nhRh2zARHIys2f+blNpF
         yQig==
X-Gm-Message-State: AOAM531ETFXrfwOrvh5R0k14e0xDXlGo+ZjUiNYhK4d6piXgzE29tNhP
        Gg+B/b6M32G2Ab3q+NvJ3KEnnjz1a4vqWh1wcBuM3bNJYfYIKpEtKkPGWONBFPDnqYQnsmJUBMW
        Ksc4e9molBTZ8D2VwWpU+RnL6YAVOk7Nkpv6woBkOLcICmwHx6sGYfYKWLqo31X8=
X-Google-Smtp-Source: ABdhPJxrlb29OM6chmNq04VCtKjTZI3T5q3zrOTqQXOnHJ5M/LwUa4Repgd6cICtUvBgVw2HN6RYjaaTq9xQ5g==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4c4b:: with SMTP id
 np11mr25621615pjb.233.1639155493365; Fri, 10 Dec 2021 08:58:13 -0800 (PST)
Date:   Fri, 10 Dec 2021 08:58:04 -0800
In-Reply-To: <20211210165804.1623253-1-ricarkol@google.com>
Message-Id: <20211210165804.1623253-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20211210165804.1623253-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH 3/3] arm64: debug: add a migration test for
 single-step state
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test the migration of single-step state. Setup single-stepping, migrate,
and check that we are actually single-stepping.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/debug.c       | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg | 12 ++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/arm/debug.c b/arm/debug.c
index b2240d7..54f059d 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -23,8 +23,10 @@
 #define DBGWCR_E		(0x1 << 0)
 
 #define SPSR_D			(1 << 9)
+#define SPSR_SS			(1 << 21)
 
 #define ESR_EC_HW_BP_CURRENT    0x31
+#define ESR_EC_SSTEP_CURRENT    0x33
 #define ESR_EC_WP_CURRENT       0x35
 
 #define ID_AA64DFR0_BRPS_SHIFT	12
@@ -34,6 +36,7 @@
 
 static volatile uint64_t hw_bp_idx, hw_bp_addr[16];
 static volatile uint64_t wp_idx, wp_data_addr[16];
+static volatile uint64_t ss_addr[4], ss_idx;
 
 static void hw_bp_handler(struct pt_regs *regs, unsigned int esr)
 {
@@ -47,6 +50,12 @@ static void wp_handler(struct pt_regs *regs, unsigned int esr)
 	regs->pstate |= SPSR_D;
 }
 
+static void ss_handler(struct pt_regs *regs, unsigned int esr)
+{
+	ss_addr[ss_idx++] = regs->pc;
+	regs->pstate |= SPSR_SS;
+}
+
 static int get_num_hw_bp(void)
 {
 	uint64_t reg = read_sysreg(id_aa64dfr0_el1);
@@ -344,6 +353,36 @@ static void test_wp(bool migrate)
 	}
 }
 
+static void test_ss(bool migrate)
+{
+	extern unsigned char ss_start;
+	uint32_t mdscr;
+
+	install_exception_handler(EL1H_SYNC, ESR_EC_SSTEP_CURRENT, ss_handler);
+
+	reset_debug_state();
+
+	ss_idx = 0;
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_SS;
+	write_sysreg(mdscr, mdscr_el1);
+	isb();
+
+	if (migrate) {
+		do_migrate();
+	}
+
+	asm volatile("msr daifclr, #8");
+
+	asm volatile("ss_start:\n"
+			"mrs x0, esr_el1\n"
+			"add x0, x0, #1\n"
+			"msr daifset, #8\n"
+			: : : "x0");
+
+	report(ss_addr[0] == (uint64_t)&ss_start, "single step");
+}
+
 int main(int argc, char **argv)
 {
 	if (argc < 2)
@@ -365,6 +404,14 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		test_wp(true);
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "ss") == 0) {
+		report_prefix_push(argv[1]);
+		test_ss(false);
+		report_prefix_pop();
+	} else if (strcmp(argv[1], "ss-migration") == 0) {
+		report_prefix_push(argv[1]);
+		test_ss(true);
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index bca2fad..c8c51d2 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -266,3 +266,15 @@ file = debug.flat
 arch = arm64
 extra_params = -append 'wp-migration'
 groups = debug migration
+
+[debug-sstep]
+file = debug.flat
+arch = arm64
+extra_params = -append 'ss'
+groups = debug
+
+[debug-sstep-migration]
+file = debug.flat
+arch = arm64
+extra_params = -append 'ss-migration'
+groups = debug migration
-- 
2.34.1.173.g76aa8bc2d0-goog

