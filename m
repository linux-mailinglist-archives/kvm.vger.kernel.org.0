Return-Path: <kvm+bounces-41877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7473DA6E7AB
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 01:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C9A23B7D83
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 00:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0350F188734;
	Tue, 25 Mar 2025 00:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="S+rchpqw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A869C14900B
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 00:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742863248; cv=none; b=CLD/g+MU4AHhxluVE2/oNVmju9GAz2S8rmSqJFhw83xxrOsYlmANd/Vin9fDarkPNzh496YU/p2RVsCB4UyaiJDvymw2ifzjuXB5s5Riup4VggjTQi2lWlJdN11gQi7PXPK7gXpY2zsNioGarzKpZllhJjgoRf+Yj8AuMgjFESc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742863248; c=relaxed/simple;
	bh=QN3DCBPWjckW+ez0UByt9KYuOWBHnXzOgLR953n7h0A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GXpFYbnXDRgiqRU+0P8ArnvLov9tVm2p19t3ppaC013DciFwCLFINtp5685s4R4bAEU3asXYfehcKq4oyFViYU2muT1RXga8o/itfQnWaMxhIo2GSR15Uru3eLEPaAtvTvE3yzMsMsEAFtZ9/BNboiP7Ve987Ov+7e1B7ZI+cVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=S+rchpqw; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-225df540edcso116624475ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742863245; x=1743468045; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XNqfGek6IDvMlkuJpE58iTKo9lOFsf02qvhKRUoqiBo=;
        b=S+rchpqwX3GqxetPRwgVkbKcIbDUhzD5zp+05pG88hfrAtn05/C3DtLSgJah9XLsow
         Ci/R633dCnYoWbztOXMkM8N/TWkq5eytQbwqYI6Pf5HjLvs0rT/ueQKvNeOZQ9XqAA6/
         2seT/U0G4Tp22BR3jJQ92tYyeGh1tK38P/eG50umCBuwqCpxTToy9Iz0QuKhNIFTl2QL
         JReO3iwL/tUEWXR6LDueJ9h8SrKC3CT44vHfOpO0R2qbEBapXn+nKcSJnO85rBnr0HsZ
         2KYX9ut354DUCTDn4CV0q9+jcy3Y6+HHt9l7rsoN9beUglovm1x+J945Dtk1nZu1M+U/
         IaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742863245; x=1743468045;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XNqfGek6IDvMlkuJpE58iTKo9lOFsf02qvhKRUoqiBo=;
        b=PtzMiQb+2ljxjwiHNJT3Mq3vFWLOjY11LUrqlSksG+FuT+yjNhQUowDWcg6dfPDokQ
         QsgGRrrlPX0kZalkBg7ud7YKOu2koX0xicLikGlfcgEDKo182NgmOSKql15Qlog9wnvG
         0V//vJFlGQzwGgXH8fJSvVTzfUUSqIFHC/o0teHKpV8oCtmuXg/zHuyBwhJEPgcmUmIH
         C3xGpxZ8IAr64TBY0Zv9JTnju5cvQNwz9gYj2dXeSUzwQHNjVhAF7oVjsNA409UeYThm
         CFQGoYeHtG4Sz+0OPyd4S1+zJ2OSXdfifeulR1z6lXxreXanCJbjsieENhXGw2dGZ4Hk
         cufA==
X-Gm-Message-State: AOJu0YzmImBzjNGCCDiCK2TFpUUBSeDdM6qbMgYuQG9PHtvhhdcRbXDp
	Ll+7ga0Yu7i7Xs0BqG2PCZGL7dtfPWhIuoSp6qAqN9ujhqtHJgEdYp5vrEebyjafaWpQUxGdQuL
	u
X-Gm-Gg: ASbGncuZPPg64f0GP5eLc77uFfOgidYnFdB2xPTne0YLIIDo5MZjDh82fSnfuQDpUbD
	ZrteLCar9+EsfmtvVdQ8u/1vJuqBRkRG/r3Fd2MWbPUEmbCw2gKP1v78iopPPMwVlZms2jvywgr
	qn3wQD3MPBm7xwHUw9W+bIpdxq/yNmPv2+JKym7ojY9DHgxzOYOI/UJlJ+l9qX4gPxUKT3gz8fz
	C1djyeHgAOxCf8dfNvhCTZYRDlJQcjjL8bMfyoEmVRA3KrsLewcd+gQ7eJnajQIwpeLA/4M+49x
	dgbqCudGuNivuOGb4r3jfRmSLSZdALmYWdpyndq4odzoJ9U3iNg+ffZxpg==
X-Google-Smtp-Source: AGHT+IEyY0aS2TVZ43j4wneKeZ/YRErGKGqWBRTFQa7kE7mGVqq6ifmaSYPLNtOafQQXufixCh8D6Q==
X-Received: by 2002:a05:6a00:638d:b0:736:aea8:c9b7 with SMTP id d2e1a72fcca58-7377a08766dmr27319740b3a.2.1742863244847;
        Mon, 24 Mar 2025 17:40:44 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390600a501sm8705513b3a.79.2025.03.24.17.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 17:40:44 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 24 Mar 2025 17:40:30 -0700
Subject: [PATCH 2/3] KVM: riscv: selftests: Decode stval to identify exact
 exception type
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250324-kvm_selftest_improve-v1-2-583620219d4f@rivosinc.com>
References: <20250324-kvm_selftest_improve-v1-0-583620219d4f@rivosinc.com>
In-Reply-To: <20250324-kvm_selftest_improve-v1-0-583620219d4f@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Currently, the sbi_pmu_test continues if the exception type is illegal
instruction because access to hpmcounter will generate that. However, we
may get illegal for other reasons as well which should result in test
assertion.

Use the stval to decode the exact type of instructions and which csrs are
being accessed if it is csr access instructions. Assert in all cases
except if it is a csr access instructions that access valid PMU related
registers.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 32 ++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 03406de4989d..11bde69b5238 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -128,11 +128,43 @@ static void stop_counter(unsigned long counter, unsigned long stop_flags)
 		       "Unable to stop counter %ld error %ld\n", counter, ret.error);
 }
 
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
 static void guest_illegal_exception_handler(struct ex_regs *regs)
 {
+	unsigned long insn;
+	int opcode, csr_num, funct3;
+
 	__GUEST_ASSERT(regs->cause == EXC_INST_ILLEGAL,
 		       "Unexpected exception handler %lx\n", regs->cause);
 
+	insn = regs->stval;
+	opcode = (insn & INSN_OPCODE_MASK) >> INSN_OPCODE_SHIFT;
+	__GUEST_ASSERT(opcode == INSN_OPCODE_SYSTEM,
+		       "Unexpected instruction with opcode 0x%x insn 0x%lx\n", opcode, insn);
+
+	csr_num = GET_CSR_NUM(insn);
+	funct3 = GET_RM(insn);
+	/* Validate if it is a CSR read/write operation */
+	__GUEST_ASSERT(funct3 <= 7 && (funct3 != 0 || funct3 != 4),
+		       "Unexpected system opcode with funct3 0x%x csr_num 0x%x\n",
+		       funct3, csr_num);
+
+	/* Validate if it is a HPMCOUNTER CSR operation */
+	__GUEST_ASSERT(csr_num == CSR_CYCLE || csr_num <= CSR_HPMCOUNTER31,
+		       "Unexpected csr_num 0x%x\n", csr_num);
+
 	illegal_handler_invoked = true;
 	/* skip the trapping instruction */
 	regs->epc += 4;

-- 
2.43.0


