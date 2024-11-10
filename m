Return-Path: <kvm+bounces-31390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB6B49C33F0
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 18:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7363F1F2115A
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 17:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3F313B59A;
	Sun, 10 Nov 2024 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZV5DvRBY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514C31384BF
	for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731259017; cv=none; b=rAuFiowuD1fgo4Nk4uuOc3bVrWTLPQpRKhWZVOag/b/hEJ3xZ6TcTTC4KeRJsfV4m/2eGxcRAP3g/QM/Pv7GReoEgFxyCbD6XzCy01Vsvq5k97CWOoCrrC2Mu0uCMb9902rlYDAG2pVaEzHtaNHqSqf55sSUZzzOXPjs6Khq0I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731259017; c=relaxed/simple;
	bh=gTXlWbi+3Cmei3RKXLx62CuOZlTuuc50odxGlr8slA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1ph0N2s0rNQBtdHJ7diV29yWN2xXyMw9tspeBLtjFXYdb2VyeydDUvVDQeQW0cufyaXbe+drJQ5cWkMUAiElGAKBx436M9C0pf/8CvkRLO2j5tkuOu6JCxFiHeuMMvn5KSsjZFnQBAYU8iegh9JAEohjZuypBxQBsHJJxAND0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZV5DvRBY; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71ec997ad06so3059992b3a.3
        for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 09:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731259015; x=1731863815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ds30340H5u/Hl2oqGpMQaS9rIjLGNP90ApJLeFxnb+c=;
        b=ZV5DvRBYbjDaPzvYZG19JJosi+10qoeobuaRRyuW6jAe5oX94lUpat/HzBt6aGQ0+M
         +p8YKGOsvLyt6vX7wimmUcNZBOzxJl4RHgw5bamOrFCxtcLoWPmXzTW00kx49onZDdcc
         jBLLLswxEWR4eosm4mDD83Xnj5IbD2CsYzYuIGnwum39RB5TAMSJigRBXUp41V4Uk3ux
         B3hfI+cT9PBCsp5QWsN9FWlGNd1R+iPLaCbW2gAUN5Leo9ayUdJU/VmLE+UePw09Q+KD
         q7qzGVPeGfxMEKYPQz47sMlcImFa1kynS45bI0JulJIVzI32c9Vm9O+AQvJtsjeDn73k
         7zeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731259015; x=1731863815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ds30340H5u/Hl2oqGpMQaS9rIjLGNP90ApJLeFxnb+c=;
        b=QU6gBO/EcuUshhrcKDGF3zbrb8C3lEvr9oDTzSRlsQ2+eV4lOy0t7zCZzuewgZVxc9
         LPVqyoCSL81DrCd4yIT2TxdV97Fw1j1Q0p8xl1fAwlmVw/cVjeykafaeLMXzHBw097c9
         toGVLvsEKci/JEOCQc8GAShlPEngf7cQPd29BqQuXXg48CTmeNsUn94fSSG2pjs7xB7G
         9ldd79R1h66t/fLVStGDQojU8y1+hP5fJBdmDLWfZSYDEJIDAzyc+3FSVAiU7X/NU6QW
         m5jTxRO9Q7g3noQQMmaoWkIf54+b1ZYz3LlXJvAy7rhtuNdACrKpQvYgg75auRbwyRQR
         eIUA==
X-Gm-Message-State: AOJu0Yzu7zxuFc3Z351Y2JGZG+sjSDZWwr4y1jBIe+eiAceriwzlnkBj
	Iu+K+Rx3ieZT5EMb7T6lxmdioV/aHaVowbQGFwlUDesi1J9bdLDEJ8iavjAu
X-Google-Smtp-Source: AGHT+IHvTy5s8BptVPzH0lYKXRzguVjuoBL+jf+PoLw+XgNdo7eSV70D8xFOcrXuyM1hrj21MWWujQ==
X-Received: by 2002:a05:6a20:7f8c:b0:1db:d738:f2ff with SMTP id adf61e73a8af0-1dc228ac37fmr15670992637.2.1731259015238;
        Sun, 10 Nov 2024 09:16:55 -0800 (PST)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078641a2sm7578415b3a.20.2024.11.10.09.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 09:16:54 -0800 (PST)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v7 1/2] riscv: sbi: Fix entry point of HSM tests
Date: Mon, 11 Nov 2024 01:16:32 +0800
Message-ID: <20241110171633.113515-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241110171633.113515-1-jamestiotio@gmail.com>
References: <20241110171633.113515-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the current trick of setting opaque as hartid, the HSM tests would
not be able to catch a bug where a0 is set to opaque and a1 is set to
hartid. Fix this issue by setting a1 to an array with some magic number
as the first element and hartid as the second element, following the
behavior of the SUSP tests.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 riscv/sbi-tests.h | 13 ++++++++++---
 riscv/sbi-asm.S   | 33 +++++++++++++++++++--------------
 riscv/sbi.c       |  1 +
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
index d0a7561a..162f0d53 100644
--- a/riscv/sbi-tests.h
+++ b/riscv/sbi-tests.h
@@ -9,9 +9,16 @@
 #define SBI_CSR_SATP_IDX	4
 
 #define SBI_HSM_TEST_DONE	(1 << 0)
-#define SBI_HSM_TEST_HARTID_A1	(1 << 1)
-#define SBI_HSM_TEST_SATP	(1 << 2)
-#define SBI_HSM_TEST_SIE	(1 << 3)
+#define SBI_HSM_TEST_MAGIC_A1	(1 << 1)
+#define SBI_HSM_TEST_HARTID_A1	(1 << 2)
+#define SBI_HSM_TEST_SATP	(1 << 3)
+#define SBI_HSM_TEST_SIE	(1 << 4)
+
+#define SBI_HSM_MAGIC		0x453
+
+#define SBI_HSM_MAGIC_IDX	0
+#define SBI_HSM_HARTID_IDX	1
+#define SBI_HSM_NUM_OF_PARAMS	2
 
 #define SBI_SUSP_TEST_SATP	(1 << 0)
 #define SBI_SUSP_TEST_SIE	(1 << 1)
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
index e871ea50..9ac77c5c 100644
--- a/riscv/sbi-asm.S
+++ b/riscv/sbi-asm.S
@@ -30,34 +30,39 @@
 .balign 4
 sbi_hsm_check:
 	li	HSM_RESULTS_MAP, 0
-	bne	a0, a1, 1f
+	REG_L	t0, ASMARR(a1, SBI_HSM_MAGIC_IDX)
+	li	t1, SBI_HSM_MAGIC
+	bne	t0, t1, 1f
+	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_MAGIC_A1
+1:	REG_L	t0, ASMARR(a1, SBI_HSM_HARTID_IDX)
+	bne	a0, t0, 2f
 	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_HARTID_A1
-1:	csrr	t0, CSR_SATP
-	bnez	t0, 2f
+2:	csrr	t0, CSR_SATP
+	bnez	t0, 3f
 	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_SATP
-2:	csrr	t0, CSR_SSTATUS
+3:	csrr	t0, CSR_SSTATUS
 	andi	t0, t0, SR_SIE
-	bnez	t0, 3f
+	bnez	t0, 4f
 	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_SIE
-3:	call	hartid_to_cpu
+4:	call	hartid_to_cpu
 	mv	HSM_CPU_INDEX, a0
 	li	t0, -1
-	bne	HSM_CPU_INDEX, t0, 5f
-4:	pause
-	j	4b
-5:	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_DONE
+	bne	HSM_CPU_INDEX, t0, 6f
+5:	pause
+	j	5b
+6:	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_DONE
 	add	t0, HSM_RESULTS_ARRAY, HSM_CPU_INDEX
 	sb	HSM_RESULTS_MAP, 0(t0)
 	la	t1, sbi_hsm_stop_hart
 	add	t1, t1, HSM_CPU_INDEX
-6:	lb	t0, 0(t1)
+7:	lb	t0, 0(t1)
 	pause
-	beqz	t0, 6b
+	beqz	t0, 7b
 	li	a7, 0x48534d	/* SBI_EXT_HSM */
 	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
 	ecall
-7:	pause
-	j	7b
+8:	pause
+	j	8b
 
 .balign 4
 .global sbi_hsm_check_hart_start
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 6f2d3e35..300e5cc9 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -483,6 +483,7 @@ static void check_ipi(void)
 unsigned char sbi_hsm_stop_hart[NR_CPUS];
 unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
 unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];
+unsigned long sbi_hsm_hart_start_params[NR_CPUS * SBI_HSM_NUM_OF_PARAMS];
 
 #define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
 #define DBCN_WRITE_BYTE_TEST_BYTE	((u8)'a')
-- 
2.43.0


