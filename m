Return-Path: <kvm+bounces-48010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C95EAC83BF
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 908589E069F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80668293743;
	Thu, 29 May 2025 21:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zfNYgPOa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396A5335C7
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 21:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748555839; cv=none; b=b1dTRVim1USRfQE3MNTLXI3zDYsQr344sphM7rJLFS5Ipp/gQADJL7Hopula+mfhC6YFzS49XMZgP1uhtTReJDRlD7ltgbVevEq8WOyvGlfDFbdNmDOXIP5VufHpTBq7+WuJT3WIXtsbuSHkzxHvKw1lXoXob2pCEb9LiMohwRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748555839; c=relaxed/simple;
	bh=1gnyVVyFa3hiwugS4uT6NxlcOI+glZeUGGE5W2e3blg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BhE52bh4zdcETirkgDA9hvGJEdb1nBFU6Lu54zxYAgJnPu0+ulr8QepmIKECkIRI8UT4L0c1UjtazSBf/CI+esnJl0KYNDBRMGXOTRYLmVI9HATCn/IukEH8vmWBmtU0WHHFU2NmlMvPZZqIY4/NY32338szLf5jfDqK3p3Ha9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zfNYgPOa; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-745fd5b7b65so1093617b3a.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 14:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748555837; x=1749160637; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fNQMCLybSWll6RdUWvxE2OUF6yZ99geKI6W60n/AIVo=;
        b=zfNYgPOahmrHikmkegT3LOQftA/l4Je6XSeSp5lYqPhtaf2UuccFSHxHUgHJ9nh7/W
         JvbSlt3tsMPBAh9mUxVZx2ed+cv3zl4Xi4z6TkTXn38Z2LpBUkTCXGIFaWldnvOWEdR1
         x7uObsYwhcPCIkPaalhYKViSIvF2G8PlxyGp84i2w7ck2PK2KQviawVUtxn74zdYSVHX
         EXgGj10hoVPTOumMb81Ap8Sqdjj0h9WsOCDm4b4omCZdLyKY/jIi2uP1ihhbD8S0b8+H
         f6FmzO7Ccwv7n2EQawysB4mdoC8qqk4UbZ1ULFJpuJN47Uyb/Hke3S7u0iavWcBpONHf
         EFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748555837; x=1749160637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fNQMCLybSWll6RdUWvxE2OUF6yZ99geKI6W60n/AIVo=;
        b=pkdPndXzUcYSz36HE7zHhbZLLFkbX1awMcPWbMjmQdtOsIU+hGdVRLjj1UiJSbUAeu
         +auXihORBwEtTgtxNiawwPQZu9GWQ64OH/UQZCA941LtKN+vbMD3XruKWpPssQ7YUeHp
         6zxWLMvLTwvnpyF65k/26XYaFRTCfY3gUVY3RzjaziBw6P4nAJUDp+rPa9rzzEBXA/Vc
         vWxKP1U5uKxJ02b4PcElPzkHJjfnjh8a60H275b6NSiJhzS6v4B34xYP1ggfTlctOzTj
         +8Xi+O2JEbIHvgwIfgOlrLXBA7g80zwd7zXlDD+873Nfo9eAmOmuSiP8vORqrLMbNzE3
         6GHw==
X-Gm-Message-State: AOJu0Yzm+EVDLYPUxggGTtiDwieF2YOX8zD4o/xmKSfApoonlJ0GBFRX
	STbc/pXlUty+6TXY6YSp7BGOlApuSJb1wnNuV02TnKkckbtVaP7Kc0/mLEgMgAPLBgP5wQP51yh
	qX3qm6g==
X-Google-Smtp-Source: AGHT+IEWom3kcF5amNKNHod9AZOLGnCyhGpfT9YI8AqiNSB/ujYrnDS4D4INDcKlBcwsNjYTAxRzEZ8krU8=
X-Received: from pfwy40.prod.google.com ([2002:a05:6a00:1ca8:b0:747:a8ac:ca05])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4605:b0:73e:1e24:5a4e
 with SMTP id d2e1a72fcca58-747bda3c61bmr1637618b3a.24.1748555837388; Thu, 29
 May 2025 14:57:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 14:57:12 -0700
In-Reply-To: <20250529215713.3802116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529215713.3802116-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529215713.3802116-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/2] x86/svm: Actually report missed MSR
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
 x86/svm_tests.c | 68 +++++++++++++++----------------------------------
 1 file changed, 21 insertions(+), 47 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 416b6aad..de9ab1b9 100644
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
@@ -340,10 +341,10 @@ static void test_msr_intercept(struct svm_test *test)
 
 		test->scratch = -1;
 
-		rdmsr(msr_index);
-
-		/* Check that a read intercept occurred for MSR at msr_index */
-		if (test->scratch != msr_index)
+		vector = rdmsr_safe(msr_index, &ignored);
+		if (vector)
+			report_fail("Expected RDMSR to #VMEXIT, got exception %u", vector);
+		else if (test->scratch != msr_index)
 			report_fail("MSR 0x%lx read intercept", msr_index);
 
 		/*
@@ -352,10 +353,10 @@ static void test_msr_intercept(struct svm_test *test)
 		 */
 		msr_value += (msr_value << 1);
 
-		wrmsr(msr_index, msr_value);
-
-		/* Check that a write intercept occurred for MSR with msr_value */
-		if (test->scratch != msr_value)
+		vector = wrmsr_safe(msr_index, msr_value);
+		if (vector)
+			report_fail("Expected RDMSR to #VMEXIT, got exception %u", vector);
+		else if (test->scratch != msr_value)
 			report_fail("MSR 0x%lx write intercept", msr_index);
 	}
 
@@ -365,41 +366,13 @@ static void test_msr_intercept(struct svm_test *test)
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
@@ -413,9 +386,8 @@ static bool msr_intercept_finished(struct svm_test *test)
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
 
@@ -3065,7 +3037,7 @@ static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected
 		*counter = 0;
 
 	sti();  // host IF value should not matter
-	clgi(); // vmrun will set back GI to 1
+	clgi(); // vmrun will set back GIF to 1
 
 	svm_vmrun();
 
@@ -3077,7 +3049,9 @@ static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected
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
2.49.0.1204.g71687c7c1d-goog


