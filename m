Return-Path: <kvm+bounces-66420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 99275CD2274
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 70016301CC7C
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 22:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18DD2E88B6;
	Fri, 19 Dec 2025 22:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PGm0ziWu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6D52DEA75
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 22:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185169; cv=none; b=H+lvYVV2yhyUMWEyCNjxQqJmAN8UkvhLleFK9qqRy8kGQT9slUi88skwoTNt8D0na1F585VdP3F+SLhXUaxQubYmx8YhWS5AbKqptNJTJnq92jyAXJ2ehKDjA5kt0uTquVc+HlatlBnsOrgSCOsIjdx/d5nEdJUeMer6ht8EG5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185169; c=relaxed/simple;
	bh=hEX9aip50ID8Z8XuSk7ouWzJqKVBU8JtT4cBGLois8c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FEuj/JbaFcXOisX3chhh/h5ThnPcZLCyOpE+ahJooXE0kjxe2BzrAzGgwaCutgRgqTmoJxIXIN6FGYPwOIO2AOAea3e8SlzKducWe55TdazRn7F0sZ/G3IfV8YBOujOwz5jQ5HskUJZIM1+GPeov1041LfkT9rL0/GJ5HmkqeSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PGm0ziWu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c5d7865e4so3189257a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 14:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185164; x=1766789964; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lLAKCAylKBOd9Fb2+MvnhZ3Owxlt63a/ZtwBQu/zTsU=;
        b=PGm0ziWuehuShJIGsLd/yFSPonbtaHZlJIk1JXJGvUkuvSShpwqdQUuJb8RxU323aX
         Q4d5R9bAnA3BNdbOdndaGySMThz0o5Y7QcDxrkhnqB6aert2Vc44QqfUoX4MgEnvF3bM
         xdNwMYr0qaoXfBM9qFvPjByvU/u11YSIpJjasCfu0lx9uE1m1xxA7QP5SRhxrj/s4TzB
         dDrXxxeQbQ8jrKc+RJvLf2+3aFLIJIKJgl/7aXOmqRah0fRjH66Is+M0nGzS5omoQ5aJ
         IBBbvHgGAMaejwURhbfSLbIY/8nBXHX/+VqiWB2kimiEkozk6LKdV8sND6WZHT0lgVUh
         P0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185164; x=1766789964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lLAKCAylKBOd9Fb2+MvnhZ3Owxlt63a/ZtwBQu/zTsU=;
        b=tWzY9Mv5TJisxc9PYkc2VGSSHFh4DCW56rBtTjaXOBNLb5jSFrE7HxXjRKv6pFfdHD
         d+xgHUzygIu84CsAaJN03/RnHzUGPY1j/ulQewTDUT6B/LV4YsIRQaPIswH3ZDm04XWV
         b0ByLgBQQzNOINOqwstsnWrwpPIct5bbAIt2Frpb5cIo76quzdLnWzU6zwokzFPpqbvz
         M5lDZh6QDeran5rK3IWa6gVDLm5nPBEjg8Kwj6hy4Ke9FeVVnNvumbvBo2hQUeiL+5ha
         1Bd11Fp1ytmgz053pE4RDPhyk2TF8V9tHbrqGhff3GKxxeAdMfJViVQUIBywkkuBvrTr
         kY7A==
X-Gm-Message-State: AOJu0YzpSdG9c0CznZ9s58gtCLqVlU/hwCJUHIAKoTfYWO/3SNUCevSP
	eixhgBt9UKjoRjSn14p9d898ESMLA7tSYlhxl1ePM0MCz4oquOwO8VcOKhwtUQF1H9iY7Tr9iuJ
	x3yxpBT0BZCrj4mMiQqpKx0hzHMH0JXy3Nvn6pm68t4FN4TllbMfb53xLhRVQ0JkWVQZbgzjzX1
	2NWfbTCt6SU1tiFSiF+GCEcw9iego84OVH3FW6hQknfu4=
X-Google-Smtp-Source: AGHT+IHwNa/2nGsRFQ45mYfcczxhR/nKADpuDHPNFMxX+PL1oSr6Pb8/h2298XcHjQYMp7dMV3I1svNGuscVqA==
X-Received: from pjbne24.prod.google.com ([2002:a17:90b:3758:b0:33b:ba24:b207])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3882:b0:340:d511:e167 with SMTP id 98e67ed59e1d1-34e9207378fmr3590350a91.0.1766185163782;
 Fri, 19 Dec 2025 14:59:23 -0800 (PST)
Date: Fri, 19 Dec 2025 22:59:04 +0000
In-Reply-To: <20251219225908.334766-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219225908.334766-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219225908.334766-6-chengkev@google.com>
Subject: [kvm-unit-tests PATCH 5/9] x86/svm: Add tests for PF exception testing
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The nVMX tests already has coverage for PF exception testing by running
ac_test_run() in L2. Add a similar test for nSVM to improve test parity
between nSVM and nVMX.

The VMX tests intercept MSR accesses and CPUID by default, hence why
there is special handling for MSR and CPUID VM exits. The svm tests do
not intercept the EFER accesses by default and EFER updates in L2 do not
affect L1, so we do not need to handle MSR exits like the VMX tests.
CPUID should be emulated by KVM so the interception is not required
there either.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 x86/Makefile.common |  2 ++
 x86/svm.h           |  1 +
 x86/svm_tests.c     | 71 +++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   | 33 ++++++++++++++++++++-
 4 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index ef0e09a65b07f..31d1ed5777123 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -117,6 +117,8 @@ $(TEST_DIR)/access_test.$(bin): $(TEST_DIR)/access.o
 
 $(TEST_DIR)/vmx.$(bin): $(TEST_DIR)/access.o
 
+$(TEST_DIR)/svm.$(bin): $(TEST_DIR)/access.o
+
 $(TEST_DIR)/svm_npt.$(bin): $(TEST_DIR)/svm.o
 
 $(TEST_DIR)/kvmclock_test.$(bin): $(TEST_DIR)/kvmclock.o
diff --git a/x86/svm.h b/x86/svm.h
index 052324c683019..66733570f0e37 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -112,6 +112,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 #define TLB_CONTROL_DO_NOTHING 0
 #define TLB_CONTROL_FLUSH_ALL_ASID 1
+#define TLB_CONTROL_FLUSH_ASID 3
 
 #define V_TPR_MASK 0x0f
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 8dbc033533c00..a40468693b396 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -13,6 +13,7 @@
 #include "x86/usermode.h"
 #include "vmalloc.h"
 #include "fwcfg.h"
+#include "access.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -3943,6 +3944,60 @@ static void svm_apic_passthrough_tpr_threshold_test(void)
 	report(svm_apic_passthrough_tpr_threshold_ipi_isr_fired, "self-IPI fired");
 }
 
+static bool tlb_control_flush;
+
+static void svm_pf_inv_asid_test_prepare(struct svm_test *test)
+{
+	vmcb->control.intercept |= BIT_ULL(INTERCEPT_INVLPG);
+	tlb_control_flush = false;
+}
+
+static void svm_pf_inv_tlb_ctl_test_prepare(struct svm_test *test)
+{
+	vmcb->control.intercept |= BIT_ULL(INTERCEPT_INVLPG);
+	tlb_control_flush = true;
+}
+
+static void svm_pf_exception_test(struct svm_test *test)
+{
+	ac_test_run(PT_LEVEL_PML4, false);
+}
+
+static void svm_pf_exception_forced_emulation_test(struct svm_test *test)
+{
+	ac_test_run(PT_LEVEL_PML4, true);
+}
+
+static bool svm_pf_exception_test_finished(struct svm_test *test)
+{
+	switch (vmcb->control.exit_code) {
+	case SVM_EXIT_VMMCALL:
+		break;
+	case SVM_EXIT_INVLPG:
+		if (tlb_control_flush) {
+			/* Flush L2 TLB by using TLB Control field */
+			vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+		} else {
+			/* Flush L2 TLB by assigning a new ASID. */
+			vmcb->control.asid++;
+		}
+		break;
+	default:
+		report_fail("Unexpected exit to L1, Exit reason: 0x%x",
+			    vmcb->control.exit_code);
+	}
+
+	/* Advance guest RIP to the instruction after exit instruction. */
+	vmcb->save.rip = vmcb->control.next_rip;
+
+	return vmcb->control.exit_code == SVM_EXIT_VMMCALL;
+}
+
+static bool svm_pf_exception_test_check(struct svm_test *test)
+{
+	return vmcb->control.exit_code == SVM_EXIT_VMMCALL;
+}
+
 struct svm_test svm_tests[] = {
 	{ "null", default_supported, default_prepare,
 	  default_prepare_gif_clear, null_test,
@@ -4069,6 +4124,22 @@ struct svm_test svm_tests[] = {
 	  svm_apic_passthrough_thread_test_prepare, default_prepare_gif_clear,
 	  svm_apic_passthrough_guest, svm_apic_passthrough_test_finished,
 	  svm_apic_passthrough_test_check},
+	{ "svm_pf_exception_test", next_rip_supported,
+	  default_prepare, default_prepare_gif_clear,
+	  svm_pf_exception_test, svm_pf_exception_test_finished,
+	  svm_pf_exception_test_check},
+	{ "svm_pf_exception_forced_emulation_test", next_rip_supported,
+	  default_prepare, default_prepare_gif_clear,
+	  svm_pf_exception_forced_emulation_test, svm_pf_exception_test_finished,
+	  svm_pf_exception_test_check},
+	{ "svm_pf_inv_asid_test", next_rip_supported,
+	  svm_pf_inv_asid_test_prepare, default_prepare_gif_clear,
+	  svm_pf_exception_test, svm_pf_exception_test_finished,
+	  svm_pf_exception_test_check},
+	{ "svm_pf_inv_tlb_ctl_test", next_rip_supported,
+	  svm_pf_inv_tlb_ctl_test_prepare, default_prepare_gif_clear,
+	  svm_pf_exception_test, svm_pf_exception_test_finished,
+	  svm_pf_exception_test_check},
 	TEST(svm_apic_passthrough_tpr_threshold_test),
 	TEST(svm_cr4_osxsave_test),
 	TEST(svm_guest_state_test),
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 1a89101a5b2dd..65dcf8b6cba89 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -253,7 +253,7 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-test_args = "-pause_filter_test -svm_intr_intercept_mix_smi -svm_insn_intercept_test"
+test_args = "-pause_filter_test -svm_intr_intercept_mix_smi -svm_insn_intercept_test -svm_pf_exception_test -svm_pf_exception_forced_emulation_test -svm_pf_inv_asid_test -svm_pf_inv_tlb_ctl_test"
 qemu_params = -cpu max,+svm -m 4g
 arch = x86_64
 groups = svm
@@ -265,6 +265,37 @@ qemu_params = -cpu max,+svm -m 4g
 arch = x86_64
 groups = svm
 
+[svm_pf_inv_asid_test]
+file = svm.flat
+test_args = svm_pf_inv_asid_test
+qemu_params = -cpu max,+svm -m 4g
+arch = x86_64
+groups = svm
+timeout = 240
+
+[svm_pf_inv_tlb_ctl_test]
+file = svm.flat
+test_args = svm_pf_inv_tlb_ctl_test
+qemu_params = -cpu max,+svm -m 4g
+arch = x86_64
+groups = svm
+timeout = 240
+
+[svm_pf_exception_test]
+file = svm.flat
+test_args = svm_pf_exception_test
+qemu_params = -cpu max,+svm -m 4g
+arch = x86_64
+groups = svm
+
+[svm_pf_exception_fep]
+file = svm.flat
+test_args = svm_pf_exception_forced_emulation_test
+qemu_params = -cpu max,+svm -m 4g
+arch = x86_64
+groups = svm
+timeout = 480
+
 [svm_intr_intercept_mix_smi]
 file = svm.flat
 test_args = svm_intr_intercept_mix_smi
-- 
2.52.0.322.g1dd061c0dc-goog


