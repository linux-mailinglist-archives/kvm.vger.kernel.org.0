Return-Path: <kvm+bounces-46300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66111AB4CA5
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57A0A3A55F6
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CC31F3B98;
	Tue, 13 May 2025 07:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gYceEjqF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AA41F1522
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 07:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747120992; cv=none; b=gy0NDCRL10/fHfg7ogeztK8K1XGiTqm74ftgxDMlg4Ps2DEG/5JfrJKQhwZ7RRcy/0PO/Od/cdkRcVXB56H5uWBAFiCnLa6nzWysLRzJ29URwUcwB2wEQvGz5smou8PA7Ie+6M4nHkgLKAHdLQW7OV5Lrk6ZHKCFE/3DCpMTYY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747120992; c=relaxed/simple;
	bh=s3ebZRCtIQl5T5Y3d/L1JYOKgqGaXdI9Sn6jU1fe77Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgVVCN8k8U3gOmvMnGJN8v8Xt7Y5OVC3G0mOEXfsYnbsLftT/OiEO3XAjjCOElLjK+piP6rsywOv2+zgJXoD8wEilnHeC23ebuzWJWIgXaHnde+SuuPq1lbYzE4ik8NxWfBMBif8dwvFxcyHNPvFBfltFkNbF+Qw0j3kQEQGc5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gYceEjqF; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747120991; x=1778656991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s3ebZRCtIQl5T5Y3d/L1JYOKgqGaXdI9Sn6jU1fe77Q=;
  b=gYceEjqFl/7RJTQTsYP9xB5ZPUNXtUvwDXMTHfo0L+c1ko4hKXmWp2Ld
   qQEyDNZbb2lcCcoGA6J5Bbi0TI7MPgAqnmRFNMFYvoP3SUtL5cVnhwxX7
   knelXUGG9qGQSPvg6gXnNYbDYtTASx9VWhibGIvpekL/0T/v3QPu1GW9K
   WoyCiQat6BqVaVakqyv1xCc+UEksxYCVfumcOLvY0ML5aqCA+M9u7ypry
   iLp3drBplFaXfy6twKmuzOZjQnRgZHZ1PUUaP7HQIoJ8LTVoN6hNQQLII
   YG5DHtcBRuvi+s3OWSK5e2GT+xoHE8ZQkAa200qXUiGv+U24Cx9amnyIx
   A==;
X-CSE-ConnectionGUID: jJ8cHpRiS+CIs2/DbpHhaA==
X-CSE-MsgGUID: OjAc4bEmRjaXjOIslXGiQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48941023"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48941023"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:04 -0700
X-CSE-ConnectionGUID: rXjLQlO3TWKVwE/migERTQ==
X-CSE-MsgGUID: 3uXKIDOFQsCzqI8jA9vdwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142740621"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:03 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [kvm-unit-tests PATCH v1 8/8] x86: cet: Validate CET states during VMX transitions
Date: Tue, 13 May 2025 00:22:50 -0700
Message-ID: <20250513072250.568180-9-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250513072250.568180-1-chao.gao@intel.com>
References: <20250513072250.568180-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests to verify that CET states are correctly handled during VMX
transitions.

The following behaviors are verified:

1. Host states are loaded from VMCS iff "Load CET" VM-exit control is set
2. Guest states are loaded from VMCS iff "Load CET" VM-entry control is set
3. Guest states are saved to VMCS during VM exits unconditionally
4. Invalid guest or host CET states leads to VM entry failures.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 lib/x86/msr.h     |  1 +
 x86/unittests.cfg |  7 ++++
 x86/vmx.h         |  8 +++--
 x86/vmx_tests.c   | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 658d237f..b9edb19b 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -292,6 +292,7 @@
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 #define MSR_IA32_TSC_ADJUST		0x0000003b
 #define MSR_IA32_U_CET                  0x000006a0
+#define MSR_IA32_S_CET                  0x000006a2
 #define MSR_IA32_PL3_SSP                0x000006a7
 #define MSR_IA32_PKRS			0x000006e1
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 6e69c50b..044d6ba2 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -437,6 +437,13 @@ arch = x86_64
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
diff --git a/x86/vmx.h b/x86/vmx.h
index 9cd90488..33373bd1 100644
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
index 2f178227..1a6dccbe 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -11376,6 +11376,85 @@ static void vmx_posted_interrupts_test(void)
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
@@ -11489,5 +11568,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(vmx_pf_vpid_test),
 	TEST(vmx_exception_test),
 	TEST(vmx_canonical_test),
+	/* "Load CET" VM-entry/exit controls tests. */
+	TEST(vmx_cet_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.47.1


