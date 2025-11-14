Return-Path: <kvm+bounces-63143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A0946C5ABD2
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:15:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5D79F353992
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C800B22127E;
	Fri, 14 Nov 2025 00:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JFjVZSgM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD1023F405
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079211; cv=none; b=krQ29jkzrOtIJQSNBu9ECKWOyPplfYObZf8BiAHX+5ye8/Zz8fy8J0NzdwrO8Z/IWscpv/9HMF/y7RXGEmCXkiKeHbYS8aywfSUBR644dMsf2x3HkZRqlVQiEqiCwNifg4m6uhcVLhvGWz781n4Ft7s3o6UjL2iULpu3uAHdXkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079211; c=relaxed/simple;
	bh=Kq2Nmcmszin4B4wXAOxsAGrdureX8CwCX5lE+qoGP9Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eDRpF/QDqe+ByQXqVSp6zOpAd0BKfxEoUprVgpQhudqPoqvPFsbUkasARvATFc/QUOhkTROdFBXadQYS5eU8ghkCeqWdLQz30brEK6ODQu4m7fSFOggZMS5k8MJ8EnrhN5EjvAvJagaeEsJLd2ZxqDWXEG9INaU2GorRpA+ejkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JFjVZSgM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343bf6ded5cso3235723a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079210; x=1763684010; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wxMmPgBHO4HeFsBbyt5lLBi7o6u2hoE9OnMPucwsOKA=;
        b=JFjVZSgMAqOtmr0fDOcK2Mzw2TJF+sfagjHaTRkGsBVEcinKvstUadELWO/SfEz8Vu
         fVK6w/G/zluu5s/qjy2CmsNAr4d9mLOYTSQISzrnxb22GoCn857apMytiKX37P57BfoR
         2reQg49uyhWcPVgLpF2C0AGenwySeyBSlDLJg9EHPdOMV1rmLMH1q+7abmVJ8BD3syY9
         CM466Ll13gXM9sCgxT4SRuWfhb34j91at8Z1/hsZHO+6zGBTOFohNxveQR7kboEafpo/
         /7jVwIL+EP+9UtGgX5nzHGwOt4PZTm0yFh3uUzVZwiKE/WI9k4QlFruTa71tHpDokx4k
         +r4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079210; x=1763684010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wxMmPgBHO4HeFsBbyt5lLBi7o6u2hoE9OnMPucwsOKA=;
        b=JhjdKYMLViPvj19qj5VQ7AZAckfjo5PfOppI7qPAvfns0V/MY5agbsALAqv+2ht7r3
         iFarpGAzgTDAP4abX0JX0iLeQIqJcICG9/XjHjKtiZItSEN3ZVF0fpwYCLJ+0wJt+TUZ
         8hFHUQnv1UW8+GO8lZWdd3/0S2+SG/yQQ4KGwakNXngkCf5+YdeVryVVvdoV7HN3bvh0
         iyeWcu/g5Lopg9T9sK3oHr/BCiLDarU4Y+WSDAWtlNoRGo3z1QmezwHbULvWtexgQdTb
         3kXaRhwkzyB/qHMvUfoLShhAJt8Ytm6/FyuK1cz/giZsnO1SGORI30cWS57IaBF1WcG6
         5jLA==
X-Gm-Message-State: AOJu0YySSDbEsuJub9JaIEXVHyzk5nYAhMEyAEQS2ng3ppjC+EQ8ukLF
	qLmbuMugIHOajHrJhNkUCDbrH6NveOG6AW+m+8XANdZgKimWQP4let0eejP9AGHgq26LucBws3i
	pTPg3BA==
X-Google-Smtp-Source: AGHT+IFA240Df/Xm8j/VNF5oAPG7cvcQ08hQZnX5HjuZuyPJ/vfNzfHBVAHklQ9OxH9OXp9lCQXcHBJCQlU=
X-Received: from pjblp2.prod.google.com ([2002:a17:90b:4a82:b0:33b:51fe:1a97])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a45:b0:341:2141:d809
 with SMTP id 98e67ed59e1d1-343fa74b235mr1283886a91.26.1763079209825; Thu, 13
 Nov 2025 16:13:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:58 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-18-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 17/17] x86/cet: Add testcases to verify KVM
 rejects emulation of CET instructions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

Add SHSTK and IBT testcases to verify that KVM rejects (forced) emulation
of instructions that interact with SHSTK and/or IBT state, as KVM doesn't
support emulating SHSTK or IBT (rejecting emulation is preferable to
compromising guest security).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 121 insertions(+), 2 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 26cd1c9b..34c78210 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -75,6 +75,113 @@ static uint64_t cet_ibt_func(void)
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
+	report(vector == UD_VECTOR, "Wanted #UD on %s, got %s",		\
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
+		     /* Manually encode ljmpq, which gas doesn't recognize :-( */
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
+	if (vector != UD_VECTOR)					\
+		return __LINE__;					\
+} while (0)
+
+static uint64_t cet_ibt_emulation(void)
+{
+	CET_TEST_UNSUPPORTED_INSTRUCTIONS(IBT);
+
+	IBT_TEST_UNSUPPORTED_INSTRUCTION("jmp *%%rax");
+	IBT_TEST_UNSUPPORTED_INSTRUCTION("ljmp *%0");
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
@@ -117,15 +224,20 @@ static void test_shstk(void)
 	/* Store shadow-stack pointer. */
 	wrmsr(MSR_IA32_PL3_SSP, (u64)(shstk_virt + 0x1000));
 
-	printf("Unit tests for CET user mode...\n");
+	printf("Running user mode Shadow Stack tests\n");
 	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == CP_ERR_NEAR_RET,
 	       "NEAR RET shadow-stack protection test");
-
 	run_in_user(cet_shstk_far_ret, CP_VECTOR, 0, 0, 0, 0, &rvc);
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
@@ -133,6 +245,7 @@ static void test_shstk(void)
 
 static void test_ibt(void)
 {
+	uint64_t l;
 	bool rvc;
 
 	if (!this_cpu_has(X86_FEATURE_IBT)) {
@@ -146,6 +259,12 @@ static void test_ibt(void)
 	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == CP_ERR_ENDBR,
 	       "Indirect-branch tracking test");
+
+	if (is_fep_available &&
+	    ((l = run_in_user(cet_ibt_emulation, CP_VECTOR, 0, 0, 0, 0, &rvc)) || rvc))
+		report_fail("Forced emulation with IBT generated %s(%u) at line %lu",
+			    exception_mnemonic(exception_vector()),
+			    exception_error_code(), l);
 }
 
 int main(int ac, char **av)
-- 
2.52.0.rc1.455.g30608eb744-goog


