Return-Path: <kvm+bounces-67891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B36FD160F8
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D300F305BD05
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951A9277035;
	Tue, 13 Jan 2026 00:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ib/44rE4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911C7284686
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264338; cv=none; b=mhWZN3jB74uLhyaBnnryLXn3tp4P/ukUKpt73B7aGbNWdEDEp1B8cRg5xo04m1gpL7M5jRCJqVVR+z9dpYl5JoijPsm7a61iC0Sa0+U7wxeq4qIcDZRCo6rfiofSX3CRuUWFHdxAjbGu9nxCSs+tl3RT1g1/MnHHkmYzg65yyX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264338; c=relaxed/simple;
	bh=JwHazvaKw3gRHsOn0/pfe0/cSVRnHOp4KT6BeEaFLOw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mdySIeLhXX4lWTvQ5NTG7NxvIJGeB6RGID5gYSErjASdmIuttdoqtNTHBRV4WDxgbafWx44WN4iuy235y7/e0wk5+1qiwnZhcOT4O4LBT5fCAHECi0u3PIO4g8hLRcElLIKdGtkPucSXgMyfEK1ByeKxj9tQ673kX/Ta13ZzPyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ib/44rE4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c704d5d15so2548035a91.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264333; x=1768869133; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IqxIuO6tL0gXPSbELS1g1t+7RVUooMov9sT0oSfhD1s=;
        b=ib/44rE4qL+EBzldoYPx+B5Htddwi+qzzdpWio5iR5hNl2xJ95Nob5ySsGHD/rh1s1
         7uthoCwZXSUIBt4tfrPPHw614cTvdcr4vw52L02kCPqcn3dQJ8f1E0db4AeWe78FBlRO
         vTgm+g6UrHaTWvkP5oSOA4LM4jhdKoGwcRlg2c+i0gjvGqzGJkRPpuccXeJbIIwX9Px2
         /bF3045SneoRUkfxP0PPzVtsOIRMdDLXRkaJpN87OE+4K/VegJ5adTjghwMwoocVt0pj
         fQswndJA9VR5xKccI3pB37JGbCMMjzkow6rKiBebO/5CCz9TkJEYfev689r7PhfAZ7mR
         yn0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264333; x=1768869133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IqxIuO6tL0gXPSbELS1g1t+7RVUooMov9sT0oSfhD1s=;
        b=WAOSCzWm7cH/gh5ohaj2aWna/0XHrXTqEuTU3Rj2/AeBZzcwKPTGhapZccUekeLcGP
         E3FySoTO5JXHazXV+sp3S0vjQE4qwu4x78NQYAhbE2NYnCBUvijprmzO54DRFCJIHkGT
         87Nd1XkurvjfGsUCIi7utJQHuHQtrW35VfRBHlV0Hjqsf/j1BKua550I4Hg5uF4MDqph
         pzqu+vEoDGy1bH9HH/C1OqWA1xHmvD+/EdtwfTvUMwWLTGwpYb5EGnCeOqEmCe12QqCK
         Yt75wwKPYkUG0S+x9eO0zygBe/fDNDXdAvmBhYb2D7vn4kNg48GP2ucDzyuWfhMF+tSX
         6dTg==
X-Gm-Message-State: AOJu0YxExqQQJu26npcoDUrvdOYYy7Kp8jL67Yk/QiUUko5m7BvPB3MV
	RTd2CW1L/v/T0udr+3nAEvDjM0B6g+ktWcu5nplimSpjALW06AOhlGllGJLSypFtihWSkDGBlp4
	LYz+LJiygFQ4GVcS3LfV6tZ/cB54aVWj8WXA8ERDeTpMbdjMdsDdVmlq52AJHbP7w9tLDqhjoxv
	reM6c1GMSA+SKYMpJ0Za0lE/gIUstyYIedaiW4PTYKoD0=
X-Google-Smtp-Source: AGHT+IGCxB2nDyEPOUaON4c0UGkvado0nEsBXerucb0visikpK1jSNtjpPftwkgckOzJ0apzmd9pn95uDcYPpg==
X-Received: from pjvc17.prod.google.com ([2002:a17:90a:d911:b0:34c:567d:ede4])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5784:b0:343:66e2:5f9b with SMTP id 98e67ed59e1d1-34f68c4dcd8mr20030107a91.24.1768264332771;
 Mon, 12 Jan 2026 16:32:12 -0800 (PST)
Date: Tue, 13 Jan 2026 00:31:51 +0000
In-Reply-To: <20260113003153.3344500-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003153.3344500-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003153.3344500-10-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2 09/10] x86/svm: Add event injection check tests
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The APM Vol #2 - 15.20 lists illegal combinations related to event
injection. Add testing to verify that these illegal combinations cause
an invalid VM exit.

Also add testing to verify that legal combinations for event injection
work as intended. This includes testing all valid injection types and
injecting all exceptions when the exception type is specified.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 lib/x86/processor.h |   5 ++
 x86/svm_tests.c     | 195 ++++++++++++++++++++++++++++----------------
 x86/unittests.cfg   |   9 +-
 3 files changed, 137 insertions(+), 72 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b073ee168ce4b..0ae812df59b1c 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -528,6 +528,11 @@ static inline bool this_cpu_has_mwait(void)
 	return this_cpu_has(X86_FEATURE_MWAIT);
 }
 
+static inline bool this_cpu_has_shstk(void)
+{
+	return this_cpu_has(X86_FEATURE_SHSTK);
+}
+
 struct far_pointer32 {
 	u32 offset;
 	u16 selector;
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index a40468693b396..5d27286129337 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1674,74 +1674,6 @@ static bool vnmi_check(struct svm_test *test)
 	return get_test_stage(test) == 3;
 }
 
-static volatile int count_exc = 0;
-
-static void my_isr(struct ex_regs *r)
-{
-	count_exc++;
-}
-
-static void exc_inject_prepare(struct svm_test *test)
-{
-	default_prepare(test);
-	handle_exception(DE_VECTOR, my_isr);
-	handle_exception(NMI_VECTOR, my_isr);
-}
-
-
-static void exc_inject_test(struct svm_test *test)
-{
-	asm volatile ("vmmcall\n\tvmmcall\n\t");
-}
-
-static bool exc_inject_finished(struct svm_test *test)
-{
-	switch (get_test_stage(test)) {
-	case 0:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
-			return true;
-		}
-		vmcb->save.rip += 3;
-		vmcb->control.event_inj = NMI_VECTOR | SVM_EVTINJ_TYPE_EXEPT | SVM_EVTINJ_VALID;
-		break;
-
-	case 1:
-		if (vmcb->control.exit_code != SVM_EXIT_ERR) {
-			report_fail("VMEXIT not due to error. Exit reason 0x%x",
-				    vmcb->control.exit_code);
-			return true;
-		}
-		report(count_exc == 0, "exception with vector 2 not injected");
-		vmcb->control.event_inj = DE_VECTOR | SVM_EVTINJ_TYPE_EXEPT | SVM_EVTINJ_VALID;
-		break;
-
-	case 2:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
-			return true;
-		}
-		vmcb->save.rip += 3;
-		report(count_exc == 1, "divide overflow exception injected");
-		report(!(vmcb->control.event_inj & SVM_EVTINJ_VALID), "eventinj.VALID cleared");
-		break;
-
-	default:
-		return true;
-	}
-
-	inc_test_stage(test);
-
-	return get_test_stage(test) == 3;
-}
-
-static bool exc_inject_check(struct svm_test *test)
-{
-	return count_exc == 1 && get_test_stage(test) == 3;
-}
-
 static volatile bool virq_fired;
 static volatile unsigned long virq_rip;
 
@@ -2548,6 +2480,129 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+/* Returns true if exception can be injected via the SVM_EVTINJ_TYPE_EXEPT type */
+static bool is_injectable_exception(int vec)
+{
+	/*
+	 * Vectors that do not correspond to an exception are excluded. NMI is
+	 * not an exception so it is excluded. BR and OF are excluded because
+	 * BOUND and INTO are not legal in 64-bit mode.
+	 *
+	 * The VE vector is excluded because it is Intel only.
+	 *
+	 * The HV and VC vectors are excluded because they are only relevant
+	 * within secure guest VMs.
+	 */
+	u8 exception_vectors[32] = {
+		[DE_VECTOR] = 1, [DB_VECTOR] = 1,
+		[BP_VECTOR] = 1, [UD_VECTOR] = 1,
+		[NM_VECTOR] = 1, [DF_VECTOR] = 1,
+		[TS_VECTOR] = 1, [NP_VECTOR] = 1,
+		[SS_VECTOR] = 1, [GP_VECTOR] = 1,
+		[PF_VECTOR] = 1, [MF_VECTOR] = 1,
+		[AC_VECTOR] = 1, [MC_VECTOR] = 1,
+		[XF_VECTOR] = 1, [CP_VECTOR] = this_cpu_has_shstk(),
+		[SX_VECTOR] = 1,
+	};
+
+	return exception_vectors[vec];
+}
+
+static bool is_valid_injection_type_mask(int type_mask)
+{
+	return type_mask == SVM_EVTINJ_TYPE_INTR ||
+	       type_mask == SVM_EVTINJ_TYPE_NMI ||
+	       type_mask == SVM_EVTINJ_TYPE_EXEPT ||
+	       type_mask == SVM_EVTINJ_TYPE_SOFT;
+}
+
+static volatile bool event_injection_handled;
+static void event_injection_irq_handler(isr_regs_t *regs)
+{
+	event_injection_handled = true;
+	vmmcall();
+}
+
+static void event_injection_exception_handler(struct ex_regs *r)
+{
+	event_injection_handled = true;
+	vmmcall();
+}
+
+static void svm_event_injection(void)
+{
+	u32 event_inj_saved = vmcb->control.event_inj, vector = 0x22, event_inj;
+	int type, type_mask;
+	bool reserved;
+
+	handle_exception(DE_VECTOR, event_injection_exception_handler);
+	handle_irq(vector, event_injection_irq_handler);
+
+	/* Setting reserved values of TYPE is illegal */
+	for (type = 0; type < 8; type++) {
+		type_mask = type << SVM_EVTINJ_TYPE_SHIFT;
+		reserved = !is_valid_injection_type_mask(type_mask);
+		event_injection_handled = false;
+		event_inj = SVM_EVTINJ_VALID;
+
+		switch (type_mask) {
+		case SVM_EVTINJ_TYPE_EXEPT:
+			event_inj |= DE_VECTOR;
+			break;
+		default:
+			event_inj |= vector;
+		}
+
+		vmcb->control.event_inj = event_inj |
+					  (type << SVM_EVTINJ_TYPE_SHIFT);
+		if (reserved) {
+			report(svm_vmrun() == SVM_EXIT_ERR,
+			       "Test EVENTINJ error code with type %d", type);
+			report(!event_injection_handled,
+			       "Reserved type %d ignores EVENTINJ vector field", type);
+		} else {
+			report(svm_vmrun() == SVM_EXIT_VMMCALL,
+			       "Test EVENTINJ delivers with type %d", type);
+		}
+
+		if (type_mask == SVM_EVTINJ_TYPE_NMI)
+			report(!event_injection_handled,
+			       "Injected NMI ignores EVENTINJ vector field");
+		else if (!reserved)
+			report(event_injection_handled,
+			       "Test EVENTINJ IRQ handler invoked with type %d", type);
+
+		vmcb->control.event_inj = event_inj_saved;
+	}
+
+	/*
+	 * It is illegal to specify event injection type 3 (Exception) with a
+	 * vector that does not correspond to an exception.
+	 */
+	event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT;
+	for (vector = 0; vector < 256; vector++) {
+		vmcb->control.event_inj = event_inj | vector;
+		event_injection_handled = false;
+
+		if (vector >= 32 || !is_injectable_exception(vector)) {
+			report(svm_vmrun() == SVM_EXIT_ERR,
+			       "Test EVENTINJ exception type error code with vector %d",
+			       vector);
+		} else {
+			handle_exception(vector, event_injection_exception_handler);
+			report(svm_vmrun() == SVM_EXIT_VMMCALL,
+			       "Test EVENTINJ exception type delivers with vector %d",
+			       vector);
+			report(event_injection_handled,
+			       "Test EVENTINJ exception handler invoked with vector %d",
+			       vector);
+		}
+
+		vmcb->control.event_inj = event_inj_saved;
+	}
+}
+
+
 asm(
 	"insn_sidt: sidt idt_descr;ret\n\t"
 	"insn_sgdt: sgdt gdt_descr;ret\n\t"
@@ -4074,9 +4129,6 @@ struct svm_test svm_tests[] = {
 	{ "latency_svm_insn", default_supported, lat_svm_insn_prepare,
 	  default_prepare_gif_clear, null_test,
 	  lat_svm_insn_finished, lat_svm_insn_check },
-	{ "exc_inject", default_supported, exc_inject_prepare,
-	  default_prepare_gif_clear, exc_inject_test,
-	  exc_inject_finished, exc_inject_check },
 	{ "pending_event", default_supported, pending_event_prepare,
 	  default_prepare_gif_clear,
 	  pending_event_test, pending_event_finished, pending_event_check },
@@ -4164,6 +4216,7 @@ struct svm_test svm_tests[] = {
 	TEST(pause_filter_test),
 	TEST(svm_shutdown_intercept_test),
 	TEST(svm_insn_intercept_test),
+	TEST(svm_event_injection),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 65dcf8b6cba89..118e7cdd0286d 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -253,7 +253,14 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-test_args = "-pause_filter_test -svm_intr_intercept_mix_smi -svm_insn_intercept_test -svm_pf_exception_test -svm_pf_exception_forced_emulation_test -svm_pf_inv_asid_test -svm_pf_inv_tlb_ctl_test"
+test_args = "-pause_filter_test -svm_intr_intercept_mix_smi -svm_insn_intercept_test -svm_pf_exception_test -svm_pf_exception_forced_emulation_test -svm_pf_inv_asid_test -svm_pf_inv_tlb_ctl_test -svm_event_injection"
+qemu_params = -cpu max,+svm -m 4g
+arch = x86_64
+groups = svm
+
+[svm_event_injection]
+file = svm.flat
+test_args = svm_event_injection
 qemu_params = -cpu max,+svm -m 4g
 arch = x86_64
 groups = svm
-- 
2.52.0.457.g6b5491de43-goog


