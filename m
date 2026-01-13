Return-Path: <kvm+bounces-67884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EDBD160AD
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:35:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 707453011448
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37656280A3B;
	Tue, 13 Jan 2026 00:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vczI1VIE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC23265629
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264328; cv=none; b=dX4y9JlUMF63PpNYCQmErv7om71HNIqw0TzqGxMOfGsBigXedMl2BIQ3TJmAeOKBX6j5XpzUWTgOBONkl7bdBk5yDJZAqhzpFR9AvwO/1U9LV8BXkK/NO7LstHnkFUgFQ/JuntQwNoQdC5DXtrfnyXnVz9QUA2DPLCeF2SO9IKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264328; c=relaxed/simple;
	bh=hy0FJJ+ZPChuFZb1dEINDK4qITI/2UJEu967dmAWQoo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IHSZQR7mIJFLuVsCT8UAZtmMmcIKs4vJ36COUmpFT/7JbEunuSXsnkIxsmyHFumjbMEvYXHA8/h227vyGPaak/ufD0sq1y3ZJWluhFzLHOWxvZnoHPfvQuLo7rTjhNvNJ2aneKffGdsGT5bT3E8ooqGBcEu8aHo/md61ZZwHXWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vczI1VIE; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f29ae883bso52387205ad.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264325; x=1768869125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/QVW0whsL+AJB963nkoK2rXbsOvOCMkHW5Jp3QXn/IM=;
        b=vczI1VIEgqA2hb2JqMQ6YNkQDLB8VsXKug4rkVc9sHwxZzCvRnAwZO6cVpv8i2H4nz
         MvBgkaCSWnuMOJOyMw8eYIruncbuOTPvn6MfhoHHDqD4Md9ipRu/Jd62CQWmYRrnbSeY
         pcH4558jTkNjmLrPGX0JeUKKbELhD2/ZqJoWD6oqCDouPbEvcvbT3bzIKp5FjmWxgrsr
         dJbvn7Kes/zm8sb6MKIoKWRN8ZyUw7wDyvG23cST0MbV5Fs5wb7bubysJa4C6uFUtlGo
         Wm+RaLHVXRpr8En22YvRWcc7c/MKPzKwT1maDyyUObTmjGCvneoV1tHwNEKw4uolBp/o
         J1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264325; x=1768869125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/QVW0whsL+AJB963nkoK2rXbsOvOCMkHW5Jp3QXn/IM=;
        b=DN18lKeJ/RJngwmXMy3bP5eDBUIGRhh1ZqGjv+v8/x1oGVGNR1+RJVMOi5XB4Q8B85
         /VqXS230ss/B8qmKAAxS9oW00fTpCB/zBNdwxRjWly5qn5LMU4rRDulT9s8qkBylhLaJ
         4zNT+A+1h2zQrh9qWQ874xs6LKDksNtvps+gN/PpK/QMX2wQNVmJ1zjrQDytJkBMqkGv
         EG6V9OA4unFig4DlbsRNtJL+Qh72LFgd6WMijZd94Ma5M523kbOXTtg1CZYj/JTYXrCD
         pA1vVYCMMVtZYcXrIacxtPkqtmyDGDLhEQn+B5XBmLYQtWU1B1SeOwzaqn1w14yoY+Oi
         zS2w==
X-Gm-Message-State: AOJu0Yxlnpx8Abg2UUoht1JIpwrRgH8wdJ/BHQ+6Txt0ytXCeuQGhd+Y
	Of0JSsnBOtg6UMPw2G0iGr4whG2//8xuK0E/d5p67TgWntXKP4pZFvqKpDLBRO39dr1VZ8aM+2W
	KzrbvBSCN2cI/6If43p/AK+1oWZ1i9UYooIv7XQr6iyqox9sGiiQaGSMFgFhP2B89nJPbVNKDZN
	3HJmjajhEXioOJ1ITpDbkFiSbYoTDEJwM5kVyVetq0GOs=
X-Google-Smtp-Source: AGHT+IHhWP/8XI55e2LUQbLy/8XYZFMl/SOYUp3W/a33rN1wHMl3O38ZWsfclppSd2c7lC716Y6RdskY+HwzrA==
X-Received: from plmj11.prod.google.com ([2002:a17:903:2fcb:b0:298:a8:6ab2])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:17ce:b0:2a0:9970:13fd with SMTP id d9443c01a7336-2a3ee4da3cbmr160645575ad.43.1768264325231;
 Mon, 12 Jan 2026 16:32:05 -0800 (PST)
Date: Tue, 13 Jan 2026 00:31:47 +0000
In-Reply-To: <20260113003153.3344500-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003153.3344500-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003153.3344500-6-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2 05/10] x86/svm: Add tests for PF exception testing
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
2.52.0.457.g6b5491de43-goog


