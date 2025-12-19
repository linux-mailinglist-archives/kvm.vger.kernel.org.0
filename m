Return-Path: <kvm+bounces-66424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F717CD227A
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CE9943001BED
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 22:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5782EBB98;
	Fri, 19 Dec 2025 22:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sZzngBRS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629DA2ED151
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 22:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185174; cv=none; b=jKQSoFCPaf/p0lzKiDNXjhmXNcjMx7FtkNmF1ApJ0y5R9cEsoxJDhl7wVJV3tEn+1lzywc7mk/uerRWar588oXqWT2A8OdGehHoHU5jVFwfPhf2GMD0jKPvDooLG1M9XluHmG9WjmBWIGLnfJN9zC8WZJaGO0D57RIGTpCZn3r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185174; c=relaxed/simple;
	bh=lYbEda0CITVCXbBWjb5WX3YsY0pJLI8EcV1RBverf24=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JMrcmoJFBGYwBYY2UigvQ0Kvo1rxEJ/pfBHXWOt/QXG+bPOE3Uwtj90ipqztd2ZLf9qj0yy053Ipcps4KMWs0rp+RF6iIktZRDgXBIGirDahmPZZvSn8dqTlgpYc0wBa8bU9w2RgElVhBlaKnLCq1jFEjrxHaaKzFWBxXW1whiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sZzngBRS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34cc88eca7eso3865894a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 14:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185172; x=1766789972; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tDWyhTTmHWENMtiqaNM8acsVuQ4iVO0h3aqBxTPZsdA=;
        b=sZzngBRSBaINopqWsKGJcRg4/1/FgnF/dg/mNcqY30YFJtArxETuJ927aXbcZsGg50
         cNlIuHgUnbSZJ64ckuaVkFNtRd3o1Y6hRMKE1XRfr3PGfEOazkGBWUnI50+0+11NgdS8
         yIK3WuMSYpD+KUdA+vHsrWwpXwC+pQExMBGpBjwOzexDn1trlijoFmbBWy3K1nW+8e9Q
         l2DGK7A+yjTAIV3zBZ0QyQ5J/WWQrapuS75zeK/Z6NxP+9eaMW9av2vfFroQjrMOUSgq
         y43O/R2Drh5Ut75568qwws3Yqx2lQSoXZwpaAaef9uRFn+s+RFKOmd0ErVRcbh5npPg7
         2GVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185172; x=1766789972;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tDWyhTTmHWENMtiqaNM8acsVuQ4iVO0h3aqBxTPZsdA=;
        b=dAd4eMkVhKrjGVd+FHPI7IVjkrLHeXB2KGkmaQjexO3+wOm4ZkKSAZDEG7SnJFjkUj
         z176kdGP3GdEFLcdgrOZDrkkr9R2SatVx48Xbyu/oWoG3DNj2YXIS0zTvIrjmQnbSddt
         Qduq7Zj47kr783eEkQP+gcXQLP091GfMYG4MNFXXVToVYrC3/b76nbryM7WFDFksXCR7
         anrysoZZ0EM8VVRiTJpbZg5i/eF/wyEyv/LXMwb3ky2wBK8QLP5aOg3/5AE0kVM+u8Bb
         l/wRJVrjmo6ODWXjRL3lv9OSEWZzBtwCtTqxyihSxW+KxOere1+V8mdoLywYBhaPgs0U
         bg+g==
X-Gm-Message-State: AOJu0YyxRGQNvVr93f8HLlCTLogrdVuMUmxcdh/5MqwwSE3AZJaQxBK7
	MU97lFmO1hTolRZM8/WYqGSEsdWjbRnFqNzlgx51KR+2spReM2lpw3zE1iHOJ+wY54eCfog0L5o
	6CJ5XmIbZ8lyihJvACrjNqot7qOPB/tnEuyAk8KQWOzlUjhKVdqiQdIH3UXyAq9ZYi5tptTMJ7m
	DGR05XbczbVkGa1HmSyBgrWLXV8iXjHy7/pzvhUzlUiKs=
X-Google-Smtp-Source: AGHT+IGKN0TgJlL4YZxowO57cpPMTRfbJzU6sfgew6FuDLpUh8jjQGpFRccIRtWyTKPpXhJxyGQsGGTsDYJOOw==
X-Received: from pjbpw2.prod.google.com ([2002:a17:90b:2782:b0:34b:e29d:f74c])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2585:b0:341:8ac6:2244 with SMTP id 98e67ed59e1d1-34e9212a9fbmr3362850a91.9.1766185171535;
 Fri, 19 Dec 2025 14:59:31 -0800 (PST)
Date: Fri, 19 Dec 2025 22:59:08 +0000
In-Reply-To: <20251219225908.334766-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219225908.334766-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219225908.334766-10-chengkev@google.com>
Subject: [kvm-unit-tests PATCH 9/9] x86/svm: Add event injection check tests
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
 x86/svm_tests.c | 192 ++++++++++++++++++++++++++++++------------------
 1 file changed, 121 insertions(+), 71 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index a40468693b396..a069add43d078 100644
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
 
@@ -2548,6 +2480,126 @@ static void test_dr(void)
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
+	static u8 exception_vectors[32] = {
+		[DE_VECTOR] = 1, [DB_VECTOR] = 1, [BP_VECTOR] = 1,
+		[UD_VECTOR] = 1, [NM_VECTOR] = 1, [DF_VECTOR] = 1,
+		[TS_VECTOR] = 1, [NP_VECTOR] = 1, [SS_VECTOR] = 1,
+		[GP_VECTOR] = 1, [PF_VECTOR] = 1, [MF_VECTOR] = 1,
+		[AC_VECTOR] = 1, [MC_VECTOR] = 1, [XF_VECTOR] = 1,
+		[CP_VECTOR] = 1, [SX_VECTOR] = 1,
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
+static void test_event_injection(void)
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
@@ -2893,6 +2945,7 @@ static void svm_guest_state_test(void)
 	test_dr();
 	test_msrpm_iopm_bitmap_addrs();
 	test_canonicalization();
+	test_event_injection();
 }
 
 extern void guest_rflags_test_guest(struct svm_test *test);
@@ -4074,9 +4127,6 @@ struct svm_test svm_tests[] = {
 	{ "latency_svm_insn", default_supported, lat_svm_insn_prepare,
 	  default_prepare_gif_clear, null_test,
 	  lat_svm_insn_finished, lat_svm_insn_check },
-	{ "exc_inject", default_supported, exc_inject_prepare,
-	  default_prepare_gif_clear, exc_inject_test,
-	  exc_inject_finished, exc_inject_check },
 	{ "pending_event", default_supported, pending_event_prepare,
 	  default_prepare_gif_clear,
 	  pending_event_test, pending_event_finished, pending_event_check },
-- 
2.52.0.322.g1dd061c0dc-goog


