Return-Path: <kvm+bounces-50801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 283DFAE96E2
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB7DC7B542C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D3C625C839;
	Thu, 26 Jun 2025 07:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="nuP5tC4e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E90925BF02
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923313; cv=none; b=VHhs0SFg17edmrpxy7RPTG01FVVG0XGeaPkwFznriisjrblVWqAiXYZcYxY1e5DvBbXCeh/7gHAE3n2fBteMQ0xY9jQYTyGj6Ibks2xO7IDtQcrRWlP7dp5jt2HYrM882KfmqsLW99moc/xS9I7Lcz1CTZ1mNjyAGulbgnyx5Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923313; c=relaxed/simple;
	bh=nj4Q1sOiRL3ioZNP8gY+6nQn0Yocj6gwVHV0ssUGAJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdEU+fH3mhogKmeCy3UlL46vOYYVOTDF7RGHDYuPQa6rtNZIvtkAavLIHSwPHXMMh6gXzzJfeSUmWbvVEOjMOyHYcYPjFhBk5vGhL0XCtDhO+PURgKWejm3G3HFUG57irT6aQsStYIyKrOaqRvsg9dw65Tv+GpAyYpmKOVgDWrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=nuP5tC4e; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a6e2d85705so354670f8f.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923310; x=1751528110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/yGrU84tw3dJA3MONK9Wv42UEBMze9+bUOZal1gM96E=;
        b=nuP5tC4erA8Y52b+S/iuvFmmtwaVRE3YVXs/beOGpTjjJxFMcNeshsPuMCa/DITDZo
         3dYQ2ws3eZ+lW2+P5ZfgVXh+kbKrAkY9f1+aLe10tM2yrDXR/qAV3q7GSO7DkN+fjnfp
         jVE8rU65JTn/zdfn8Hdg92VqC0lNRq9apATULp0TbtKLEBonq98y4uUQh2IPqq+F5XR4
         9bYc5THJ34JQUS7FJ0eVlCxa1aEs/Bvl6pmAZBcxSNB7QT7iDpxClI1wZzE2qxa2PVn0
         6fp4WwWOWEbmrufTNZOUfspxOJz2+GRSv0wsDR+SGev6NvcNlozdmhQNbOlHacB32fpZ
         kQ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923310; x=1751528110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/yGrU84tw3dJA3MONK9Wv42UEBMze9+bUOZal1gM96E=;
        b=XpIJvPH1/Lkvo57JLo2x+/1Cd0sJLCMgHPPA47jsZuIGJpHl1OQkrTQwiJGA436Gq/
         LLCu4Ex4DqdVNdNU8+d+3PV4RvY9QTVNuqepTSghIXQMJDMPel31mpqQNoPQwDjxG0QZ
         pBOcUKshwoUCbPh81hKT1bBce9zDE331seVb+J5KMuegDKsYCee6R92TTVh5MPqI1YL4
         +5ZrrtGdMXeOPq8Hc6V1yy2HfL7tHAOxjGX/igqHeC8e01lQxDwdH1wMiPW4aAZpSBGC
         prY7u0+V9KJ2Tvq0QxYC7wIfD8LWVAZmU3L6aVC8NhBYIUbZYPqwSY0kqorAPDzSaG45
         XDGA==
X-Forwarded-Encrypted: i=1; AJvYcCX6Vwi3So/TYNNicE/Yrh4zhFjs5kktztbnczA70KgPQ75gU8HIuABgkHttt8y5GlccFGw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc9PhSuc2Kkra1K/ipL/kvBwZd9oULjTzdTU99H1qdea6UDWoP
	sk19LM78EOtnYRhTrIwV5d2shAT6P4hMQJP1cwWA3QFfArWi1eA4PfQomG+BK5JKsa0=
X-Gm-Gg: ASbGncvzl+jZr4H0CxkhtvZi9+Xx1gA7BIwJOZbDjisly5wjaMQgGLhKJvbZw0JdJ8J
	SE6/Jfq2rsyqGQ2R/U5UQXiwT5qhfFTKDiqGfOUOuzuF/PHbVjXliRr8eu2jXdowizJ4xZwYcTo
	gwZIwuPfsbE44zWiRIbMIm/EwGowqzAg8wbdsEe0k7IhggbyRz6kPn6jOmcTG2rSa1mKRdsAS35
	4Dqlz0g13bgTaiJzFltWqhUrErD3h2NpzBTWCqKYFZKZ0PRhST17IGL71e6M1Y/qkxJkclWLvQB
	qlANabEruqWMmN/qdti3+iZoUlmbJ3dai08eAAkRRgZh0DlASJqIk4T3r0/ZMoC48Jtia/YfZG+
	uwoKoZYVH7daqpX43gfcFSQuBOc2QO6c3NC2j23/iQ1DU3e/SH7hz84I=
X-Google-Smtp-Source: AGHT+IEN3PgSSiyan4HmdjHWlqOfV7k7VErurAJxG6tdMnyMnUs1Ls8IsKOWm9K4q4fVDainjqWqFA==
X-Received: by 2002:a05:6000:1a8d:b0:3a4:e6bb:2d32 with SMTP id ffacd0b85a97d-3a6f2e8e619mr2083125f8f.22.1750923309714;
        Thu, 26 Jun 2025 00:35:09 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:09 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 08/13] x86: cet: Validate CET states during VMX transitions
Date: Thu, 26 Jun 2025 09:34:54 +0200
Message-ID: <20250626073459.12990-9-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Gao <chao.gao@intel.com>

Add tests to verify that CET states are correctly handled during VMX
transitions.

The following behaviors are verified:

1. Host states are loaded from VMCS iff "Load CET" VM-exit control is set
2. Guest states are loaded from VMCS iff "Load CET" VM-entry control is set
3. Guest states are saved to VMCS during VM exits unconditionally
4. Invalid guest or host CET states leads to VM entry failures.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/msr.h     |  1 +
 x86/vmx.h         |  8 +++--
 x86/vmx_tests.c   | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg |  7 ++++
 4 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index cc4cb8551ea1..df6d3049f8ca 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -296,6 +296,7 @@
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 #define MSR_IA32_TSC_ADJUST		0x0000003b
 #define MSR_IA32_U_CET                  0x000006a0
+#define MSR_IA32_S_CET                  0x000006a2
 #define MSR_IA32_PL3_SSP                0x000006a7
 #define MSR_IA32_PKRS			0x000006e1
 
diff --git a/x86/vmx.h b/x86/vmx.h
index 9cd90488cea6..33373bd1a2a9 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -356,6 +356,7 @@ enum Encoding {
 	GUEST_PENDING_DEBUG	= 0x6822ul,
 	GUEST_SYSENTER_ESP	= 0x6824ul,
 	GUEST_SYSENTER_EIP	= 0x6826ul,
+	GUEST_S_CET		= 0x6828ul,
 
 	/* Natural-Width Host State Fields */
 	HOST_CR0		= 0x6c00ul,
@@ -369,7 +370,8 @@ enum Encoding {
 	HOST_SYSENTER_ESP	= 0x6c10ul,
 	HOST_SYSENTER_EIP	= 0x6c12ul,
 	HOST_RSP		= 0x6c14ul,
-	HOST_RIP		= 0x6c16ul
+	HOST_RIP		= 0x6c16ul,
+	HOST_S_CET		= 0x6c18ul,
 };
 
 #define VMX_ENTRY_FAILURE	(1ul << 31)
@@ -449,6 +451,7 @@ enum Ctrl_exi {
 	EXI_SAVE_EFER		= 1UL << 20,
 	EXI_LOAD_EFER		= 1UL << 21,
 	EXI_SAVE_PREEMPT	= 1UL << 22,
+	EXI_LOAD_CET		= 1UL << 28,
 };
 
 enum Ctrl_ent {
@@ -457,7 +460,8 @@ enum Ctrl_ent {
 	ENT_LOAD_PERF		= 1UL << 13,
 	ENT_LOAD_PAT		= 1UL << 14,
 	ENT_LOAD_EFER		= 1UL << 15,
-	ENT_LOAD_BNDCFGS	= 1UL << 16
+	ENT_LOAD_BNDCFGS	= 1UL << 16,
+	ENT_LOAD_CET		= 1UL << 20,
 };
 
 enum Ctrl_pin {
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0b3cfe50c614..6383bc83da97 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -11377,6 +11377,85 @@ static void vmx_posted_interrupts_test(void)
 	enter_guest();
 }
 
+static u64 guest_s_cet = -1;
+
+static void vmx_cet_test_guest(void)
+{
+	guest_s_cet = rdmsr(MSR_IA32_S_CET);
+	vmcall();
+}
+
+static void vmx_cet_test(void)
+{
+	struct vmcs *curr;
+	u64 val;
+
+	if (!(ctrl_exit_rev.clr & EXI_LOAD_CET)) {
+		report_skip("Load CET state exit control is not available");
+		return;
+	}
+
+	if (!(ctrl_enter_rev.clr & ENT_LOAD_CET)) {
+		report_skip("Load CET state entry control is not available");
+		return;
+	}
+
+	/* Allow the guest to read GUEST_S_CET directly */
+	msr_bmp_init();
+
+	/*
+	 * Check whether VMCS transitions load host and guest values
+	 * according to the settings of the relevant VM-entry and exit
+	 * controls.
+	 */
+	vmcs_write(HOST_S_CET, 2);
+	vmcs_write(GUEST_S_CET, 2);
+	test_set_guest(vmx_cet_test_guest);
+
+	enter_guest();
+	val = rdmsr(MSR_IA32_S_CET);
+
+	/* Validate both guest/host S_CET MSR have the default values */
+	report(val == 0 && guest_s_cet == 0, "Load CET state disabled");
+
+	/*
+	 * CPU supports the 1-setting of the 'load CET' VM-entry control,
+	 * the contents of the IA32_S_CET and IA32_INTERRUPT_SSP_TABLE_ADDR
+	 * MSRs are saved into the corresponding fields
+	 */
+	report(vmcs_read(GUEST_S_CET) == 0, "S_CET is unconditionally saved");
+
+	/* Enable load CET state entry/exit controls and retest */
+	vmcs_set_bits(EXI_CONTROLS, EXI_LOAD_CET);
+	vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_CET);
+	vmcs_write(GUEST_S_CET, 2);
+	test_override_guest(vmx_cet_test_guest);
+
+	enter_guest();
+	val = rdmsr(MSR_IA32_S_CET);
+
+	/* Validate both guest/host S_CET MSR are loaded from VMCS */
+	report(val == 2 && guest_s_cet == 2, "Load CET state enabled");
+
+	/*
+	 * Validate that bit 10 (SUPPRESS) and Bit 11 (TRACKER) cannot be
+	 * both set
+	 */
+	val = BIT(10) | BIT(11);
+	vmcs_write(GUEST_S_CET, val);
+	test_guest_state("Load invalid guest CET state", true, val, "GUEST_S_CET");
+
+	/* Following test_vmx_vmlaunch() needs a "not launched" VMCS */
+	vmcs_save(&curr);
+	vmcs_clear(curr);
+	make_vmcs_current(curr);
+
+	vmcs_write(HOST_S_CET, val);
+	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+
+	test_set_guest_finished();
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -11490,5 +11569,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pf_vpid_test),
 	TEST(vmx_exception_test),
 	TEST(vmx_canonical_test),
+	/* "Load CET" VM-entry/exit controls tests. */
+	TEST(vmx_cet_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index a2b351ff552a..d07f65b6b207 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -427,6 +427,13 @@ arch = x86_64
 groups = vmx nested_exception
 check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
 
+[vmx_cet_test]
+file = vmx.flat
+extra_params = -cpu max,+vmx -append "vmx_cet_test"
+arch = x86_64
+groups = vmx
+timeout = 240
+
 [debug]
 file = debug.flat
 arch = x86_64
-- 
2.47.2


