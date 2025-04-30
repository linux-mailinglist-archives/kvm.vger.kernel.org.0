Return-Path: <kvm+bounces-44864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BF7AA44FA
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 10:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 255461BC4B11
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 08:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F2621931B;
	Wed, 30 Apr 2025 08:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="RBP7+1fs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFC6214223
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 08:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746000998; cv=none; b=Uhk+cGexAjyotBw/IRVqPtvkpE0P5viwZtfZjD5agH7qfoHsd4v+r4pP3qTZtxoU0603fV9hVaLAb2XzFkEcdye5vt2aXl1awNjAMoNpwHlz7D/wlabgq67adcM/n2wwzGSVqBE0p+ffQQjbGSI1CPcqj7+qAWp5KClgFNW3HkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746000998; c=relaxed/simple;
	bh=bGusNtEUlaX23wJD2XfALVYCzkrJMuPAiNTlbGcMBJM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EoRiRJyLYyM5OnMDLRmEoQV1W0ld8SipVkozKfaKUdLK7JmbLwJLubrEkH3aOa5qOuTLVA2WKSCoC5C7S+KmJN0WQ8dZsdz5Ws5FVVzYRCshf8Y5V0+/E1ab3Z7nC6oLES43bOtm2F5+hIuZ9vrMK1U6TojUlfjHeV0FAFCGzeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=RBP7+1fs; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7370a2d1981so5627567b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 01:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746000996; x=1746605796; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aRFZ5FKZBztRGxrY6vVfDYbRzHdpxr6eQNzNURiD5s8=;
        b=RBP7+1fsgaaEszj/50cmRkgRo9X444NsS4dDL+X4apzaNhk3/dIGOmRe8Ij0JgEfGi
         ikOjlkUBSMjcVILPd4Qh+RxSzNbRD4s5sppoBXNnFZegd9oVurUCFsKgq0J4dKsUZsZa
         rqoYYdvO9J30T9sjOQD13DWdwHs3f4D/Sk/jdSd23RFJ+yD2uRfz5pHyAizzRfay9EVg
         39njVFsQPMt4dgmEPIHyBZUzBiGJpzSngtKjUiLrQZu8Zqtfb3PARx9KRwvp4mgTG9lf
         ge3BNpwPzGWyhbg72aPeRwY1E46DsnYDs+Z7t3+pTHfxlVBemFFSVOJsJLipbUlaFbSx
         gt4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746000996; x=1746605796;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aRFZ5FKZBztRGxrY6vVfDYbRzHdpxr6eQNzNURiD5s8=;
        b=RVOXzL8DQaX6zWCtcBMTRbgqmbWMC+KlcZ/3AK09cqK5tKUFdFcshedliJHVuCMDM/
         4RMPhHogtDmot2IZWMKqZKQKQufUiPvftricZvSws3tguby/v8jaC74fQyvJ6teGn1PF
         oxu5EasIV/5jgu06jgag9bhDBFoVGAzmaLiFryQmL6+mflwY+ZfwnQ+vODkr+KjgeO8M
         eIhJ6EiMZLbVFeTUPxNBKQCDuJ78vguVOyviCj1+sTrjYkzAhccFP/tR/q598rCnM4Yd
         bqnx9GnfMnI3Oyn1sWDeVllUKCQeb+pchHn/VGjqMYBL3hCgvteVJarc+LSG2SAeuEfs
         VTfA==
X-Gm-Message-State: AOJu0YwjKVnpCPbd2zpAsiLYM/MH3G0GhsYSZGWWYrG1SXB5XFLQ5J2h
	K+DpOlYnYWdgRTC1mtQ0vBZcdQQbtNksijopGx7o5mK/h9Iyat+og8XZ5J7lSQs=
X-Gm-Gg: ASbGncsFC7p/FddokPywdlrLp/gJf1+8NPYxr5q4HCzaY6vldrIfCTRM/Pq94CoJVJk
	m4Bltgwb+oRVMnjGK7kpJC8xs5RwY5vsm3+Tomz1Gb0zvkLFtLvqiTi24KxIJB41OgbvbdKK5lB
	8RQrnJzBTODho/UbLMkLTT0qLz/pdAknY6Tul2FT8gHRYr7feSYFAqRzJ1drf6Xi/x/7XE9W1W+
	FX2lTbUG7eWsZMdMUk4FR7+9EH8p132IkNXl5TIPth41AVIYta7/pq7+fu5GUekBvOVG+i8q3pK
	ohF+zRsKlhqvyThRcz5/5jjSxJohKEnY8mLe9jxNqJh63IxlQL0teJuI1vQn762p
X-Google-Smtp-Source: AGHT+IGbD1Zl91/g/+st4aTTgt5Bkror5XgxZ0mOSUBOJaMyTd1yJdlz0KXAlGwPjFYFs62/1RdnzA==
X-Received: by 2002:a05:6a00:2e05:b0:732:2484:e0ce with SMTP id d2e1a72fcca58-7403a811cadmr2252321b3a.17.1746000996180;
        Wed, 30 Apr 2025 01:16:36 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a309edsm1073084b3a.91.2025.04.30.01.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 01:16:35 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 30 Apr 2025 01:16:29 -0700
Subject: [PATCH v3 2/3] KVM: riscv: selftests: Decode stval to identify
 exact exception type
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250430-kvm_selftest_improve-v3-2-eea270ff080b@rivosinc.com>
References: <20250430-kvm_selftest_improve-v3-0-eea270ff080b@rivosinc.com>
In-Reply-To: <20250430-kvm_selftest_improve-v3-0-eea270ff080b@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Currently, the sbi_pmu_test continues if the exception type is illegal
instruction because access to hpmcounter will generate that. However
illegal instruction exception may occur due to the other reasons
which should result in test assertion.

Use the stval to decode the exact type of instructions and which csrs are
being accessed if it is csr access instructions. Assert in all cases
except if it is a csr access instructions that access valid PMU related
registers.

Take this opportunity to remove the CSR_CYCLEH reference as the test is
compiled for RV64 only.

Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 .../testing/selftests/kvm/include/riscv/processor.h  | 13 +++++++++++++
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c     | 20 +++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
index 1b5aef87de0f..162f303d9daa 100644
--- a/tools/testing/selftests/kvm/include/riscv/processor.h
+++ b/tools/testing/selftests/kvm/include/riscv/processor.h
@@ -11,6 +11,19 @@
 #include <asm/csr.h>
 #include "kvm_util.h"
 
+#define INSN_OPCODE_MASK	0x007c
+#define INSN_OPCODE_SHIFT	2
+#define INSN_OPCODE_SYSTEM	28
+
+#define INSN_MASK_FUNCT3	0x7000
+#define INSN_SHIFT_FUNCT3	12
+
+#define INSN_CSR_MASK		0xfff00000
+#define INSN_CSR_SHIFT		20
+
+#define GET_RM(insn)            (((insn) & INSN_MASK_FUNCT3) >> INSN_SHIFT_FUNCT3)
+#define GET_CSR_NUM(insn)       (((insn) & INSN_CSR_MASK) >> INSN_CSR_SHIFT)
+
 static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t subtype,
 				    uint64_t idx, uint64_t size)
 {
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 6e66833e5941..924a335d2262 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -73,7 +73,6 @@ unsigned long pmu_csr_read_num(int csr_num)
 
 	switch (csr_num) {
 	switchcase_csr_read_32(CSR_CYCLE, ret)
-	switchcase_csr_read_32(CSR_CYCLEH, ret)
 	default :
 		break;
 	}
@@ -130,9 +129,28 @@ static void stop_counter(unsigned long counter, unsigned long stop_flags)
 
 static void guest_illegal_exception_handler(struct pt_regs *regs)
 {
+	unsigned long insn;
+	int opcode, csr_num, funct3;
+
 	__GUEST_ASSERT(regs->cause == EXC_INST_ILLEGAL,
 		       "Unexpected exception handler %lx\n", regs->cause);
 
+	insn = regs->badaddr;
+	opcode = (insn & INSN_OPCODE_MASK) >> INSN_OPCODE_SHIFT;
+	__GUEST_ASSERT(opcode == INSN_OPCODE_SYSTEM,
+		       "Unexpected instruction with opcode 0x%x insn 0x%lx\n", opcode, insn);
+
+	csr_num = GET_CSR_NUM(insn);
+	funct3 = GET_RM(insn);
+	/* Validate if it is a CSR read/write operation */
+	__GUEST_ASSERT(funct3 <= 7 && (funct3 != 0 && funct3 != 4),
+		       "Unexpected system opcode with funct3 0x%x csr_num 0x%x\n",
+		       funct3, csr_num);
+
+	/* Validate if it is a HPMCOUNTER CSR operation */
+	__GUEST_ASSERT((csr_num >= CSR_CYCLE && csr_num <= CSR_HPMCOUNTER31),
+		       "Unexpected csr_num 0x%x\n", csr_num);
+
 	illegal_handler_invoked = true;
 	/* skip the trapping instruction */
 	regs->epc += 4;

-- 
2.43.0


