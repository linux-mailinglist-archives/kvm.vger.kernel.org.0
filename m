Return-Path: <kvm+bounces-63274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC85C5F4C1
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:55:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CBE23346BF4
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE2B34B669;
	Fri, 14 Nov 2025 20:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rhSUMwU7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAE334BA5B
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153499; cv=none; b=nOOazrNzW+JBpbEdZGeXMhQc9q/benEWQpkdgh84sPSdsVi2x8fALYKHoS6YdDUl7JBU6srFkRYnf9BmhENTPB3xdCtWHuXEeMwCFzWlRVAew0CxLPUHIgCu1utQKmnKSyPze3Qhgd2J1fo6FVb9ySRXhM6Ko94dsrF0BtJwD0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153499; c=relaxed/simple;
	bh=uQTA6COeZ6DjcNcFJEPi6q937JKUyll/LvCwssVxKkM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K57TFyQYtyzxb24M1dH+gjsGCVfGz9N1o7YaUeO/WL6HB1ySPuXWZ9UpCB/rUp9Pm1EE8PTOTn1OqUXhbANAmPxee6XVqNUQoWW9iL1y/p/bW1LnIL3FHYYYoUFxCEcQRmGEqP6vGAaos+XTax3pC/RVaRsXJQhfQCwU126VnLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rhSUMwU7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297b35951b7so33266525ad.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153497; x=1763758297; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fbuFuuD62CvDPHvWSRvvmZQr/l8oke3jB2nA1E1KeBk=;
        b=rhSUMwU7reXBjXzgRF94+EvMKkNlqh+kaK3OWXXTX2VV30YAgSzk3jdWV6tiA8n1PT
         6b4OhxfcTelOlzkyQAF5TvGXTDSoynFXPzm8EqCUK5G5WdMVSALuBCd2fMy1RSIENLmy
         ud6rWV09EX0NGmOXxULLX1pVaR0o0NjGVPSiVXDKFv1XeOn7o13IZNgUkP6w1Z1w/XlO
         5ALD79fs1czUFAyd+hfEuHpkeco+j2TvdYffvpwmRCDoj27cnNjLa28QeZ0Dyg2xvoQS
         ndkHikvE6xU9u2ixnQzpajwd6S0CWaJdM+byxrrl2+wT++YHl7mMaeSR4o6gr09m40op
         ByxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153497; x=1763758297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fbuFuuD62CvDPHvWSRvvmZQr/l8oke3jB2nA1E1KeBk=;
        b=A1P0fqQNblc7duvww37zD/9eZ3kc6EMgOxemJ9Ai3aUTi8PLklk03pXojmn8QJnVX/
         hRR217iqSxRx2wNu9brE2daQu65SR4lL6eKwyO3NvRBJR+5EGb6NA3iLd1WbjVdiqG+4
         MZscEJN3SKzZuH/gDdbXxVMEuf8j2VkBipkVub5oPIZukZKHqfTNXHQzbQUL0zFDBUTB
         C+kFUKqPoLDZVKM16mlFeATPnFbn/tk9GyjHIyG8wNiw3mtEemZn8ZC0ffoIgSy/UMCA
         ygrJ4D7sejUwreqY3zfgNJ0XlKeYRMTcI1BzdgPRr9Xl7iHKKf7rWVVRQf15ePI3ISgi
         xioQ==
X-Gm-Message-State: AOJu0YxtNQOtXZxRDtZ+GalSl4/ZfG0BicZTCFm+k1oGRkOEdWVyLFTz
	4xkJpr9pvqevlOdDl6fSjwGkOO6NEXVFdxHH09RHYfMp73RzzEeptvQN9biePcfr+0b3XTSUibN
	ZhCB+Ig==
X-Google-Smtp-Source: AGHT+IH18O5LFBdsLpktwCroTuMJlwOF6iTEArIOyRVsqpUOs7BQNUt+beK6fLDuiL/mHelE097xid8WOuk=
X-Received: from pgct2.prod.google.com ([2002:a05:6a02:5282:b0:bac:a20:5f05])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:350d:b0:290:94ed:184c
 with SMTP id d9443c01a7336-2986a6be347mr47118365ad.15.1763153497641; Fri, 14
 Nov 2025 12:51:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:51:00 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-19-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 18/18] x86: cet: Add testcases to verify KVM
 rejects emulation of CET instructions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add SHSTK and IBT testcases to verify that KVM rejects (forced) emulation
of instructions that interact with SHSTK and/or IBT state, as KVM doesn't
support emulating SHSTK or IBT (rejecting emulation is preferable to
compromising guest security).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 124 insertions(+), 1 deletion(-)

diff --git a/x86/cet.c b/x86/cet.c
index 7ffe234b..e94ffb72 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -74,6 +74,116 @@ static uint64_t cet_ibt_func(void)
 	return 0;
 }
 
+#define __CET_TEST_UNSUPPORTED_INSTRUCTION(insn)			\
+({									\
+	struct far_pointer32 fp = {					\
+		.offset = 0,						\
+		.selector = USER_CS,					\
+	};								\
+									\
+	asm volatile ("push %%rax\n"					\
+		      ASM_TRY_FEP("1f") insn "\n\t"			\
+		      "1:"						\
+		      "pop %%rax\n"					\
+		      : : "m" (fp), "a" (NONCANONICAL) : "memory");	\
+									\
+	exception_vector();					\
+})
+
+#define SHSTK_TEST_UNSUPPORTED_INSTRUCTION(insn)			\
+do {									\
+	uint8_t vector = __CET_TEST_UNSUPPORTED_INSTRUCTION(insn);	\
+									\
+	report(vector == UD_VECTOR, "SHSTK: Wanted #UD on %s, got %s",	\
+	       insn, exception_mnemonic(vector));			\
+} while (0)
+
+/*
+ * Treat IRET as unsupported with IBT even though the minimal interactions with
+ * IBT _could_ be easily emulated by KVM, as KVM doesn't support emulating IRET
+ * outside of Real Mode.
+ */
+#define CET_TEST_UNSUPPORTED_INSTRUCTIONS(CET)				\
+do {									\
+	CET##_TEST_UNSUPPORTED_INSTRUCTION("callq *%%rax");		\
+	CET##_TEST_UNSUPPORTED_INSTRUCTION("lcall *%0");		\
+	CET##_TEST_UNSUPPORTED_INSTRUCTION("syscall");			\
+	CET##_TEST_UNSUPPORTED_INSTRUCTION("sysenter");			\
+	CET##_TEST_UNSUPPORTED_INSTRUCTION("iretq");			\
+} while (0)
+
+static uint64_t cet_shstk_emulation(void)
+{
+	CET_TEST_UNSUPPORTED_INSTRUCTIONS(SHSTK);
+
+	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("call 1f");
+	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("retq");
+	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("retq $10");
+	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("lretq");
+	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("lretq $10");
+
+	/* Do a handful of JMPs to verify they aren't impacted by SHSTK. */
+	asm volatile(KVM_FEP "jmp 1f\n\t"
+		     "1:\n\t"
+		     KVM_FEP "lea 2f(%%rip), %%rax\n\t"
+		     KVM_FEP "jmp *%%rax\n\t"
+		     "2:\n\t"
+		     KVM_FEP "push $" xstr(USER_CS) "\n\t"
+		     KVM_FEP "lea 3f(%%rip), %%rax\n\t"
+		     KVM_FEP "push %%rax\n\t"
+		     /*
+		      * Manually encode ljmpq, which gas doesn't recognize due
+		      * to AMD not supporting the instruction (64-bit JMP FAR).
+		      */
+		     KVM_FEP ".byte 0x48\n\t"
+		     "ljmpl *(%%rsp)\n\t"
+		     "3:\n\t"
+		     KVM_FEP "pop %%rax\n\t"
+		     KVM_FEP "pop %%rax\n\t"
+		     ::: "eax");
+
+	return 0;
+}
+
+/*
+ * Don't invoke printf() or report() in the IBT testcase, as it will likely
+ * generate an indirect branch without an endbr64 annotation and thus #CP.
+ * Return the line number of the macro invocation to signal failure.
+ */
+#define IBT_TEST_UNSUPPORTED_INSTRUCTION(insn)				\
+do {									\
+	uint8_t vector = __CET_TEST_UNSUPPORTED_INSTRUCTION(insn);	\
+									\
+	report(vector == UD_VECTOR, "IBT: Wanted #UD on %s, got %s",	\
+	       insn, exception_mnemonic(vector));			\
+} while (0)
+
+static uint64_t cet_ibt_emulation(void)
+{
+	CET_TEST_UNSUPPORTED_INSTRUCTIONS(IBT);
+
+	IBT_TEST_UNSUPPORTED_INSTRUCTION("jmp *%%rax");
+	IBT_TEST_UNSUPPORTED_INSTRUCTION("ljmpl *%0");
+
+	/* Verify direct CALLs and JMPs, and all RETs aren't impacted by IBT. */
+	asm volatile(KVM_FEP "jmp 2f\n\t"
+		     "1: " KVM_FEP " ret\n\t"
+		     "2: " KVM_FEP " call 1b\n\t"
+		     KVM_FEP "push $" xstr(USER_CS) "\n\t"
+		     KVM_FEP "lea 3f(%%rip), %%rax\n\t"
+		     KVM_FEP "push %%rax\n\t"
+		     KVM_FEP "lretq\n\t"
+		     "3:\n\t"
+		     KVM_FEP "push $0x55555555\n\t"
+		     KVM_FEP "push $" xstr(USER_CS) "\n\t"
+		     KVM_FEP "lea 4f(%%rip), %%rax\n\t"
+		     KVM_FEP "push %%rax\n\t"
+		     KVM_FEP "lretq $8\n\t"
+		     "4:\n\t"
+		     ::: "eax");
+	return 0;
+}
+
 #define CP_ERR_NEAR_RET	0x0001
 #define CP_ERR_FAR_RET	0x0002
 #define CP_ERR_ENDBR	0x0003
@@ -119,7 +229,7 @@ static void test_shstk(void)
 	/* Store shadow-stack pointer. */
 	wrmsr(MSR_IA32_PL3_SSP, (u64)(shstk_virt + 0x1000));
 
-	printf("Unit tests for CET user mode...\n");
+	printf("Running user mode Shadow Stack tests\n");
 	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == CP_ERR_NEAR_RET,
 	       "NEAR RET shadow-stack protection test");
@@ -128,6 +238,12 @@ static void test_shstk(void)
 	report(rvc && exception_error_code() == CP_ERR_FAR_RET,
 	       "FAR RET shadow-stack protection test");
 
+	if (is_fep_available &&
+	    (run_in_user(cet_shstk_emulation, CP_VECTOR, 0, 0, 0, 0, &rvc) || rvc))
+		report_fail("Forced emulation with SHSTK generated %s(%u)",
+			    exception_mnemonic(exception_vector()),
+			    exception_error_code());
+
 	/* SSP should be 4-Byte aligned */
 	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
 	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
@@ -158,6 +274,7 @@ static uint64_t ibt_run_in_user(usermode_func func, bool *got_cp)
 static void test_ibt(void)
 {
 	bool got_cp;
+	uint64_t l;
 
 	if (!this_cpu_has(X86_FEATURE_IBT)) {
 		report_skip("IBT not supported");
@@ -170,6 +287,12 @@ static void test_ibt(void)
 	ibt_run_in_user(cet_ibt_func, &got_cp);
 	report(got_cp && exception_error_code() == CP_ERR_ENDBR,
 	       "Indirect-branch tracking test");
+
+	if (is_fep_available &&
+	    ((l = ibt_run_in_user(cet_ibt_emulation, &got_cp)) || got_cp))
+		report_fail("Forced emulation with IBT generated %s(%u) at line %lu",
+			    exception_mnemonic(exception_vector()),
+			    exception_error_code(), l);
 }
 
 int main(int ac, char **av)
-- 
2.52.0.rc1.455.g30608eb744-goog


