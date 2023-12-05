Return-Path: <kvm+bounces-3440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D26480453C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE8B5281049
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7DF7C8D2;
	Tue,  5 Dec 2023 02:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="KOMlUAwv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44F5197
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 18:43:40 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6d8766f4200so2258561a34.1
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 18:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1701744220; x=1702349020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ARpkTD0DGKCutL1TwjMjDMoOjcqYmkFa31lyR5g4T2Q=;
        b=KOMlUAwvldFKgdnWVLDmJTfUo6zxkGezTTyO5DgVzigxj+xvrmKAC+oVLWVemfsfUA
         F5nHpRor4TACjK5jJy6oVHWLsRnM1veLLA0pTS4cbL4jcLcpn0jYRCLF78cpnReK07Z0
         tXP1FKMdOW445sZnx7co1epZcmc7pPcl1WWRDcvgIaa7sFRglcR3LsI1LL9j1FpnosP2
         WCbYg0gE24RA1MVkxwNI+iV/C3Rc+SOU8ez5dnWQBk+NYgiDuJwq5HX8Em4/7APsAKAD
         L1o/ESgxZyC6rKs02dT7GjK1oHgr5X2rDDqlSlIZXfA9YftFZ4DMD6GxGylB7vr9nwm0
         5TRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701744220; x=1702349020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ARpkTD0DGKCutL1TwjMjDMoOjcqYmkFa31lyR5g4T2Q=;
        b=teAz35Yyu6BrUkhYDOPEYzjI6fFAsFntLHtte88H6LfCbEEVP1yi81E/yUgD5Ryu9Q
         Khb8Rdvw8gVFyX9ZTUkhMK709J+Yhw6uZbzW2oIwmtYxLiY+5g0snovP9OQEfG6rmPxn
         J8+38KGp2yZwxT7+mhvgfOw78vQoyg5pmiQlEZ4A/cnNaWWhuNFQi12AJx3HUiWHRvXP
         LafyAfVbUL/TQbQaQwIUg0/7SP6/MUDTDFu11qycnPNmsqgQG0ifRm5nPWiczMQb/eLk
         Ls+l3QMTno6+/K2DN3DgDGaZNxjeZGhkkE9qxocD5FRplbS3rB1G0Q/ZxkV0qjuvWASI
         ehnw==
X-Gm-Message-State: AOJu0Yy6dYelEhyM+60VNdMa5eERkkyA4cQwx1LeFIObGszyCUwWgD0a
	IIRrbLlikT/F31wmKRsZHYUZOQ==
X-Google-Smtp-Source: AGHT+IFXeXXz41Hsj4C/GCefAovxqAXWbbpNAzmIuIuJp4iWAyn+2eqWNtIeCNa4tWlwO/mFe0g5LA==
X-Received: by 2002:a05:6830:61c7:b0:6d8:74e2:7cdc with SMTP id cc7-20020a05683061c700b006d874e27cdcmr7785693otb.55.1701744219906;
        Mon, 04 Dec 2023 18:43:39 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id z17-20020a9d62d1000000b006b9848f8aa7sm2157655otk.45.2023.12.04.18.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 18:43:39 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [RFC 5/9] RISC-V: Add SBI PMU snapshot definitions
Date: Mon,  4 Dec 2023 18:43:06 -0800
Message-Id: <20231205024310.1593100-6-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231205024310.1593100-1-atishp@rivosinc.com>
References: <20231205024310.1593100-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SBI PMU Snapshot function optimizes the number of traps to
higher privilege mode by leveraging a shared memory between the S/VS-mode
and the M/HS mode. Add the definitions for that extension

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index f3eeca79a02d..29821addb9b7 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -122,6 +122,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_STOP,
 	SBI_EXT_PMU_COUNTER_FW_READ,
 	SBI_EXT_PMU_COUNTER_FW_READ_HI,
+	SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
 };
 
 union sbi_pmu_ctr_info {
@@ -138,6 +139,13 @@ union sbi_pmu_ctr_info {
 	};
 };
 
+/* Data structure to contain the pmu snapshot data */
+struct riscv_pmu_snapshot_data {
+	uint64_t ctr_overflow_mask;
+	uint64_t ctr_values[64];
+	uint64_t reserved[447];
+};
+
 #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
 #define RISCV_PMU_RAW_EVENT_IDX 0x20000
 
@@ -234,9 +242,11 @@ enum sbi_pmu_ctr_type {
 
 /* Flags defined for counter start function */
 #define SBI_PMU_START_FLAG_SET_INIT_VALUE (1 << 0)
+#define SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT (1 << 1)
 
 /* Flags defined for counter stop function */
 #define SBI_PMU_STOP_FLAG_RESET (1 << 0)
+#define SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT (1 << 1)
 
 enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
-- 
2.34.1


