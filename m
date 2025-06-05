Return-Path: <kvm+bounces-48590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E2A1DACF7C4
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EF7D7A222F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33F627C84C;
	Thu,  5 Jun 2025 19:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pOP81Eye"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A108278E5A
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151356; cv=none; b=UpiZMGuQPFoVy3tm+D2B6Rc2VtGcws0Xbea7MX/TUuLrxYKiVMuAoIU6zEOMr8y3Z1ZYmwJ4Nrzxfwq2TQ5EAeXZzlhN3BelUZMwZwU0iex7p7slwAFhQWbnY5l9xjNs9d3Zjrjrps1s26XwQKFeTPm3+iflFFdSaYrtIce5A2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151356; c=relaxed/simple;
	bh=5BErT8dBkIQcrnkduh4UwHpR67138dtSgkTz4kAKjv4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ssQr8trFQmP13zJOTDo+CPhsX9DuvSL1Y67+S9Qc5oIlNewOH7cgjLTSvqK6X7zfCsJ/uempavGeM5V+MNHdXz+rv5y8IeTgmNSVzhUWHGCWS6Cw/CskRHkfC+tR+zZnzCtGl7oSb8DuaMktjgV2lMun9ao8WNX90Bp9Tz4/3gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pOP81Eye; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235842baba4so12454615ad.3
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151354; x=1749756154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WsYg7uOzDuU0liFF4tHgWz1zOOEZTXyEYJdgtuUiCiE=;
        b=pOP81Eye5QbbMD5XFOX+D6CT9LQEhHa2X/2O30emYGonxQgWxDv2jOO1NGdd+PzWIv
         OjDpAWxgOqoAaM8tx8i6iPNIQs4FnLKOhz//yW5mfPN6MWAmIzlYYHG3u/sVVUvEmoYK
         jlySlI6aA8OMCq4WV7OgL2Gu/XiQybzE8zbNT5UpYFvHPoTSDv+XLs8BWD0/e1dE1pqI
         FOX4CnOYpKTR/GlZ8VLUtPCSK1erSzUX7cyMyMmrx6WyBmO1KOnEwFKUuBAScbTPaXBJ
         cXWwSVuOlY1Jt/dfW7FBS4XMsvYvFKvxGhk2dLUeoS2wj3wjRHbIENF184AU5jEZEpOs
         OteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151354; x=1749756154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WsYg7uOzDuU0liFF4tHgWz1zOOEZTXyEYJdgtuUiCiE=;
        b=cGMtDLdObDnPJrzg0R1exeDYEX8G6TV6WTBi8umvGXDKoN1JP40kgcwamGc3j9fBHe
         DqaiQg/R9bR+siAktftmPqwcFH1qIltmkDP5swnm0zHKNUcKN1WTG36qxIP9ftN8tXZQ
         ZbZ9KFfmDlfJRXQoqb3fBSk0dADmIHKS1lta481mtUDNRMvU1CQvQt4xwD0N2NQDRQWG
         7GMhMW7G3RVBDIUlmQrZg/ZjuG+4P29ib1YVLIWDewam6AI9l0X5XWnvV/aDp6VfJ6oS
         JYz5jVgMSDrmZjNL1FDbsWSok1HWQI/g06fHZwxhBeUmi/fCqSQL/nEjlrE/MyxDk3sU
         Axrw==
X-Gm-Message-State: AOJu0Yw3MKSA3P851cYNrxanjSeXys5ClQCXrm5IjPWfvHj3THP3A2SW
	CDji6+Zr7y/bBbtiqBky2i9dQE2ddrJ6smnWas4wAYkZRjOq1twZvlQrvH8aGAdkTXWdjGwB4QU
	q/l1KNA==
X-Google-Smtp-Source: AGHT+IHGnAwxntp3VQzabhnlxftYrHigmDMHrJGzS49g7zaNchFZzehIYoGjD55oNNuLCQccdPU5V+w/UnY=
X-Received: from plbg5.prod.google.com ([2002:a17:902:d1c5:b0:235:ed02:286a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dac5:b0:234:c65f:6c0f
 with SMTP id d9443c01a7336-23601e1d724mr6264135ad.8.1749151354386; Thu, 05
 Jun 2025 12:22:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:22:19 -0700
In-Reply-To: <20250605192226.532654-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192226.532654-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192226.532654-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 1/8] x86: nSVM: Actually report missed MSR
 intercepts as failures
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Report an error if KVM fails to generate a nested VM-Exit due to MSR
interception instead of eating the #GP and printing a "warning".  Printing
an innocuous message on failure makes the test completely worthless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 76 ++++++++++++++++++-------------------------------
 1 file changed, 27 insertions(+), 49 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 416b6aad..b738eb44 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -312,7 +312,6 @@ static void prepare_msr_intercept(struct svm_test *test)
 {
 	default_prepare(test);
 	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
-	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
 	memset(msr_bitmap, 0xff, MSR_BITMAP_SIZE);
 }
 
@@ -320,6 +319,8 @@ static void test_msr_intercept(struct svm_test *test)
 {
 	unsigned long msr_value = 0xef8056791234abcd; /* Arbitrary value */
 	unsigned long msr_index;
+	u64 ignored;
+	int vector;
 
 	for (msr_index = 0; msr_index <= 0xc0011fff; msr_index++) {
 		if (msr_index == 0xC0010131 /* MSR_SEV_STATUS */) {
@@ -340,11 +341,13 @@ static void test_msr_intercept(struct svm_test *test)
 
 		test->scratch = -1;
 
-		rdmsr(msr_index);
-
-		/* Check that a read intercept occurred for MSR at msr_index */
-		if (test->scratch != msr_index)
-			report_fail("MSR 0x%lx read intercept", msr_index);
+		vector = rdmsr_safe(msr_index, &ignored);
+		if (vector)
+			report_fail("Expected RDMSR(0x%lx) to #VMEXIT, got exception '%u'",
+				    msr_index, vector);
+		else if (test->scratch != msr_index)
+			report_fail("Expected RDMSR(0x%lx) to #VMEXIT, got scratch '%ld",
+				    msr_index, test->scratch);
 
 		/*
 		 * Poor man approach to generate a value that
@@ -352,11 +355,13 @@ static void test_msr_intercept(struct svm_test *test)
 		 */
 		msr_value += (msr_value << 1);
 
-		wrmsr(msr_index, msr_value);
-
-		/* Check that a write intercept occurred for MSR with msr_value */
-		if (test->scratch != msr_value)
-			report_fail("MSR 0x%lx write intercept", msr_index);
+		vector = wrmsr_safe(msr_index, msr_value);
+		if (vector)
+			report_fail("Expected WRMSR(0x%0lx) to #VMEXIT, got exception '%u'",
+				    msr_index, vector);
+		else if (test->scratch != msr_value)
+			report_fail("Expected WRMSR(0x%lx) to #VMEXIT, got scratch '%ld' (wanted %ld)",
+				    msr_index, test->scratch, msr_value);
 	}
 
 	test->scratch = -2;
@@ -365,41 +370,13 @@ static void test_msr_intercept(struct svm_test *test)
 static bool msr_intercept_finished(struct svm_test *test)
 {
 	u32 exit_code = vmcb->control.exit_code;
-	u64 exit_info_1;
-	u8 *opcode;
 
-	if (exit_code == SVM_EXIT_MSR) {
-		exit_info_1 = vmcb->control.exit_info_1;
-	} else {
-		/*
-		 * If #GP exception occurs instead, check that it was
-		 * for RDMSR/WRMSR and set exit_info_1 accordingly.
-		 */
+	if (exit_code == SVM_EXIT_VMMCALL)
+		return true;
 
-		if (exit_code != (SVM_EXIT_EXCP_BASE + GP_VECTOR))
-			return true;
-
-		opcode = (u8 *)vmcb->save.rip;
-		if (opcode[0] != 0x0f)
-			return true;
-
-		switch (opcode[1]) {
-		case 0x30: /* WRMSR */
-			exit_info_1 = 1;
-			break;
-		case 0x32: /* RDMSR */
-			exit_info_1 = 0;
-			break;
-		default:
-			return true;
-		}
-
-		/*
-		 * Warn that #GP exception occurred instead.
-		 * RCX holds the MSR index.
-		 */
-		printf("%s 0x%lx #GP exception\n",
-		       exit_info_1 ? "WRMSR" : "RDMSR", get_regs().rcx);
+	if (exit_code != SVM_EXIT_MSR) {
+		report_fail("Wanted MSR VM-Exit, got reason 0x%x", exit_code);
+		return true;
 	}
 
 	/* Jump over RDMSR/WRMSR instruction */
@@ -413,9 +390,8 @@ static bool msr_intercept_finished(struct svm_test *test)
 	 *      RDX holds the upper 32 bits of the MSR value,
 	 *      while RAX hold its lower 32 bits.
 	 */
-	if (exit_info_1)
-		test->scratch =
-			((get_regs().rdx << 32) | (vmcb->save.rax & 0xffffffff));
+	if (vmcb->control.exit_info_1)
+		test->scratch = ((get_regs().rdx << 32) | (vmcb->save.rax & 0xffffffff));
 	else
 		test->scratch = get_regs().rcx;
 
@@ -3065,7 +3041,7 @@ static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected
 		*counter = 0;
 
 	sti();  // host IF value should not matter
-	clgi(); // vmrun will set back GI to 1
+	clgi(); // vmrun will set back GIF to 1
 
 	svm_vmrun();
 
@@ -3077,7 +3053,9 @@ static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected
 	if (counter)
 		report(*counter == 1, "Interrupt is expected");
 
-	report (vmcb->control.exit_code == expected_vmexit, "Test expected VM exit");
+	report(vmcb->control.exit_code == expected_vmexit,
+	       "Wanted VM-Exit reason 0x%x, got 0x%x",
+	       expected_vmexit, vmcb->control.exit_code);
 	report(vmcb->save.rflags & X86_EFLAGS_IF, "Guest should have EFLAGS.IF set now");
 	cli();
 }
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


