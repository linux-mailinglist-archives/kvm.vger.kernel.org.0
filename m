Return-Path: <kvm+bounces-63273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D108C5F488
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 730FA3A5DC6
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8AD2FC890;
	Fri, 14 Nov 2025 20:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mw9709YW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B32334B1A6
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153497; cv=none; b=ER6FK/gLMjIYjQHrgJijvGatqfXofxMhs5xfWkUg1Co8HWOQ80n96lZiiLko/LCR4k6RAsod/pSlANu05hvd4MEO/z7sGkR02swkK9fBeI17kRxLWSkDzBGPE+XPnbxr1qeN+9cEhScVal733G1WhxmhRMqW8VHtGHPAA/EIWFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153497; c=relaxed/simple;
	bh=nTNIyLwcv0yPx/eVPgn1VQWhSPT1MxsMDrQFHIIN348=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gmbRRZytqVxF/vYMXM29waUvG4bTfpux2ncDaoghHPAvB/nn970bAAPxSFhF3B7DDQCqh0ySSDcs3l0mNPEsiXjo+oLvX0TZ0C3nL/K1xu0A6MMZH3UziSY2l+uhOF2m3g9NXRBgrkaZZky958HGzaN6lMzN36CSLemKyBEinFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mw9709YW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340d3b1baafso4401076a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153495; x=1763758295; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Mz6aPFFcTFdQiASleExCvHlK1FPEgPeWcQjtN1TDbFQ=;
        b=mw9709YWOro3M685vFUq9AB+ju+SAc4VwmXT9MWumaiMLyqN1eJxuYsUZ6oRskk4Jm
         JQ5WKgC32hsFOkL3wKoahphVzefET4JhFcSbOuR+9A+CP2d6c6K4PcUAeq/KDK13a0XM
         +/1wdOi1xb0UydfHlhyThl+vrn6Hs+sdKVRcxjvrZ3hhTglqQqdKre1kXzMzvdeZ1BHW
         rx1dT0/W3G55ZWueiFsotEbxtLfyY/bHURt5Pc/KYJzCp4cg9IfBgRfehbA68Dq2W1ky
         8t9unfuwjfg7kOFF7mk3NX2MoXbY4SRV4so5mXJ1U9vrgZ/oeIko3tI/HRTJWE8mM7Jv
         bxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153495; x=1763758295;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mz6aPFFcTFdQiASleExCvHlK1FPEgPeWcQjtN1TDbFQ=;
        b=b8Al5yXyBrGOLRvVsf9PmdUTwHBJbJajF75Y5AWOkJw8tSgY17Zda3YbnqYqws/hTw
         vzJvB6Wa2DfHuMPeYegaj27a1JFVpTLKTF2luL9tkXc0F52F00N9AOMrXBMEExvOfuBo
         9ZchTP5iSb5HS3T+OZF5I69wv8jWRTVNx3I5hDGIiuzPEEiYZvxj/IB9dSUDtfDvYCTz
         n99ou4MAtRL77KS5MdCNJiKiXxDV3xD6uAPnoSpteqLEfq2Kuc2B2eTk2k2Alo3/AFX7
         Z6XMWMws+Sn1KoNc8MYvTIIolxAky5zu2uzDQJyI7dGK4WHuppXX3H59YSPERIVVD/i1
         z4Sw==
X-Gm-Message-State: AOJu0YwoG4Zb8wE+iCM3I7ar4ajIeroZ5m+9TgFf1V0wCwzE9qYMz3+N
	EEXL5x9AvBapNlhcMtlSUFRK41pHpPKialrnHtRBdGjNBavGJjUKv3KNj4iUej4CLdnVCI+64JY
	RVSYbaQ==
X-Google-Smtp-Source: AGHT+IEVVpB0f1lFNGNS9yi0q18o6t+1Lhsj0KDAVC85nxCamGf6TA5M1ymzXAQZxGrxjaYHw6bguLah1as=
X-Received: from pjbnl15.prod.google.com ([2002:a17:90b:384f:b0:339:ae3b:2bc7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3fc8:b0:343:a631:28b1
 with SMTP id 98e67ed59e1d1-343fa0e07e2mr6003603a91.16.1763153495410; Fri, 14
 Nov 2025 12:51:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:59 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-18-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 17/18] x86: cet: Reset IBT tracker state on
 #CP violations
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Reset the IBT tracker state back to IDLE on #CP violations to not
influence follow-up tests with a poisoned starting state.

Opportunistically rename "rvc" to "got_cp" to make it more obvious what
the flag tracks ("rvc" is presumably "raised vector CP"?).

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
[sean: add helper, align indentation, use handler+callback instead of "extra"]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/usermode.c | 12 +++++++++---
 lib/x86/usermode.h | 13 ++++++++++---
 x86/cet.c          | 31 +++++++++++++++++++++++++++----
 3 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index f896e3bd..b65c5378 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -21,12 +21,17 @@ static void restore_exec_to_jmpbuf(void)
 	longjmp(jmpbuf, 1);
 }
 
+static handler ex_callback;
+
 static void restore_exec_to_jmpbuf_exception_handler(struct ex_regs *regs)
 {
 	this_cpu_write_exception_vector(regs->vector);
 	this_cpu_write_exception_rflags_rf((regs->rflags >> 16) & 1);
 	this_cpu_write_exception_error_code(regs->error_code);
 
+	if (ex_callback)
+		ex_callback(regs);
+
 	/* longjmp must happen after iret, so do not do it now.  */
 	regs->rip = (unsigned long)&restore_exec_to_jmpbuf;
 	regs->cs = KERNEL_CS;
@@ -35,9 +40,9 @@ static void restore_exec_to_jmpbuf_exception_handler(struct ex_regs *regs)
 #endif
 }
 
-uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
-		uint64_t arg1, uint64_t arg2, uint64_t arg3,
-		uint64_t arg4, bool *raised_vector)
+uint64_t run_in_user_ex(usermode_func func, unsigned int fault_vector,
+			uint64_t arg1, uint64_t arg2, uint64_t arg3,
+			uint64_t arg4, bool *raised_vector, handler ex_handler)
 {
 	extern char ret_to_kernel;
 	volatile uint64_t rax = 0;
@@ -45,6 +50,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 	handler old_ex;
 
 	*raised_vector = 0;
+	ex_callback = ex_handler;
 	set_idt_entry(RET_TO_KERNEL_IRQ, &ret_to_kernel, 3);
 	old_ex = handle_exception(fault_vector,
 				  restore_exec_to_jmpbuf_exception_handler);
diff --git a/lib/x86/usermode.h b/lib/x86/usermode.h
index 04e358e2..7eca9079 100644
--- a/lib/x86/usermode.h
+++ b/lib/x86/usermode.h
@@ -20,11 +20,18 @@ typedef uint64_t (*usermode_func)(void);
  * Supports running functions with up to 4 arguments.
  * fault_vector: exception vector that might get thrown during the function.
  * raised_vector: outputs true if exception occurred.
+ * ex_handler: optiona handler to call when handling @fault_vector exceptions
  *
  * returns: return value returned by function, or 0 if an exception occurred.
  */
-uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
-		uint64_t arg1, uint64_t arg2, uint64_t arg3,
-		uint64_t arg4, bool *raised_vector);
+uint64_t run_in_user_ex(usermode_func func, unsigned int fault_vector,
+			uint64_t arg1, uint64_t arg2, uint64_t arg3,
+			uint64_t arg4, bool *raised_vector, handler ex_handler);
 
+static inline uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
+				   uint64_t arg1, uint64_t arg2, uint64_t arg3,
+				   uint64_t arg4, bool *raised_vector)
+{
+	return run_in_user_ex(func, fault_vector, arg1, arg2, arg3, arg4, raised_vector, NULL);
+}
 #endif
diff --git a/x86/cet.c b/x86/cet.c
index 74d3f701..7ffe234b 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -1,4 +1,3 @@
-
 #include "libcflat.h"
 #include "x86/desc.h"
 #include "x86/processor.h"
@@ -85,6 +84,8 @@ static uint64_t cet_ibt_func(void)
 #define CET_ENABLE_SHSTK			BIT(0)
 #define CET_ENABLE_IBT				BIT(2)
 #define CET_ENABLE_NOTRACK			BIT(4)
+#define CET_IBT_SUPPRESS			BIT(10)
+#define CET_IBT_TRACKER_WAIT_FOR_ENDBRANCH	BIT(11)
 
 static void test_shstk(void)
 {
@@ -132,9 +133,31 @@ static void test_shstk(void)
 	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
 }
 
+static void ibt_tracker_cp_fixup(struct ex_regs *regs)
+{
+	u64 cet_u = rdmsr(MSR_IA32_U_CET);
+
+	/*
+	 * Switch the IBT tracker state to IDLE to have a clean state for
+	 * following tests.
+	 */
+	if (cet_u & CET_IBT_TRACKER_WAIT_FOR_ENDBRANCH) {
+		cet_u &= ~CET_IBT_TRACKER_WAIT_FOR_ENDBRANCH;
+		printf("CET: suppressing IBT WAIT_FOR_ENDBRANCH state at RIP: %lx\n",
+		       regs->rip);
+		wrmsr(MSR_IA32_U_CET, cet_u);
+	}
+}
+
+static uint64_t ibt_run_in_user(usermode_func func, bool *got_cp)
+{
+	return run_in_user_ex(func, CP_VECTOR, 0, 0, 0, 0, got_cp,
+			      ibt_tracker_cp_fixup);
+}
+
 static void test_ibt(void)
 {
-	bool rvc;
+	bool got_cp;
 
 	if (!this_cpu_has(X86_FEATURE_IBT)) {
 		report_skip("IBT not supported");
@@ -144,8 +167,8 @@ static void test_ibt(void)
 	/* Enable indirect-branch tracking (notrack handling for jump tables) */
 	wrmsr(MSR_IA32_U_CET, CET_ENABLE_IBT | CET_ENABLE_NOTRACK);
 
-	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc && exception_error_code() == CP_ERR_ENDBR,
+	ibt_run_in_user(cet_ibt_func, &got_cp);
+	report(got_cp && exception_error_code() == CP_ERR_ENDBR,
 	       "Indirect-branch tracking test");
 }
 
-- 
2.52.0.rc1.455.g30608eb744-goog


