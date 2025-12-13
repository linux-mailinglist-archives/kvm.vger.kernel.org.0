Return-Path: <kvm+bounces-65928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 44812CBB0AF
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 16:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CA4A93066D8A
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 15:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3103C261B96;
	Sat, 13 Dec 2025 15:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NOL4r1A3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CD725F984
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765638552; cv=none; b=e6QNXKHCDXJtoe/DCFukpFSuiWsryXJ3jjsfnZ2fczVtJ6gpGxHCuf5iC2M7RSM1SCKjyEBrXt8DjuRbfhhRiJPhdeJX4aU7LIRaB5LE58O/P8jOkPTCuz9qvsjdD6IWg7oKGI95KuzdWA9NAGvvaVdy+kv/niI/t18BDWEv3cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765638552; c=relaxed/simple;
	bh=xM1GKl/8Rs0dztFRcI7a7H9CKvqD1JgE3YLOwj72J6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppZh3P3BMyy+y95c/dN0GyJ6AIS7GjIobK+3QTpDZuD53zFUW9q9z0pJiW5R6zhRZvkntnq1s/4iHl9VJlNGh3+012PRG3ZkQyH4rTwTWF3OyuYTQI/j4VsFBp4vRopLsBdkSdIJ/VpIBij0QATtHTNSf53F5/vaEEtNCx01o2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NOL4r1A3; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29ba9249e9dso29869555ad.3
        for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 07:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765638549; x=1766243349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DV+YsCSpJyz8LU2DSgDk8rLLAaInxe4ioSw123lddU8=;
        b=NOL4r1A3Oxz5HGQg8Z7WViKJB2/Fms1OeFDMaYKTV1lEwO/zIdlG6NZIS3mJQhOSyo
         zuftpSIcu9eB9yf/L18hRF6/aef50O4B+06Q9I+5V6iZrOHXLIjThax1pXlGwTURLZ7c
         KQPSxEo2Hv59F2HCzimLdKzSXuNc1YsMcsQPPO5yw6HGPXwmQHyNxHn8C7dUrIWgd+5z
         0n5asqr6lYf8qs/Olhqy1DSlCyLM+5I7QpQJJ0vqlvCtJ1IvnHxxVcdYzQLd8ehu414w
         axyNuXyFBAg1do3C8ToOLIPBmBxwMUA90uPBIa2E6Iyo6tRSUEu/3NVVl4GHwN9BB8TG
         D7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765638549; x=1766243349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DV+YsCSpJyz8LU2DSgDk8rLLAaInxe4ioSw123lddU8=;
        b=o6qDXmhfQfB9QokmorZh9wa1Lth/na+W/UBT2DunOB+hmLeYvd+fO/sihZR8QdCXqR
         N1evDvGExi3vswFxamc0gglNMTDJS40igNv2CTEiTgX92uIBPXbSXUah+2SbuMWpELTi
         bqblz8zZVkbp8VHnT+FxOQyMtoYb+FMABrwKYJ2YvNLdyGkvM51F9BBhlLEoKHKlJwrB
         QScmZ50VO3Zmlv4pVhiDGXd4GhsNO2lKjqpzQYDZAI5a6iKjNwLFxmbcyCloRaqj6U3b
         +36K8dj/t62Yx93ZwMZCTl3A3Sr6zZW50ecvYg8h8TVuy7ninoYPuulXWocg1KWriwtg
         yVfA==
X-Gm-Message-State: AOJu0YwbLioQve85wCjuTIaLf5iwoN7EHlJGFbsGuDBx0Sru2IGLo+1P
	Aa+I1imm1y45LEkTnLaI/DLs9vkwImEs4o1vaL0tota1jrucBBJorIQcwf1owzQnDI5Vww==
X-Gm-Gg: AY/fxX6KTv5+WvwT9OpHjZDpp2ZHYOHGCTiuOSR1g0kw4HeAACivlLlJqkJYcuI6H2x
	wzV3ijGGjTMg/sfL00TrCm29W6gEo+ztmZHxUdU2YnU8KbzWMDIp4R7sYTZ8VfnZk9Byzp3VeJP
	oliThjxPW1TwBx3IkcDpDyESNciwwRcaLf8idNIra97Ad3O1YjrCv6rbypwCCCPy6qhWqM+1FK8
	dIXw68Em9+t6NEGMotsXCtm7MQ6Mmzc+CtJZBBn2Gdg9M2OL+Bfi9084N9P0G7DwPZRMRxkNkkE
	1xhLiJeRDkhc2dZ4crD4P/WoRRujT5EtXi1NbE000mz5a61Q9xgKcvWZZrzA+b+cml6ZpK9Y/VO
	DfyIYTCWV1743WsR0Fbmr3US6wg/dWE9uXP3LaDfdUkOdxU55OXQiyTyloP77gaIXgr2U/01It4
	gTKbYrAMeAhqtwCbT4
X-Google-Smtp-Source: AGHT+IF5tvERXCT4zL1GzpqSj7FJysIN0r9EWu8eFo/hMMsmKS1TDjFNfsRwtI3jsiOKYfKWOYjI0A==
X-Received: by 2002:a17:903:2ece:b0:295:4936:d1e9 with SMTP id d9443c01a7336-29f23c7b7e3mr49941505ad.36.1765638549520;
        Sat, 13 Dec 2025 07:09:09 -0800 (PST)
Received: from JRT-PC.. ([111.94.32.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016c6esm85494715ad.59.2025.12.13.07.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Dec 2025 07:09:09 -0800 (PST)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 1/4] lib: riscv: Add SBI PMU CSRs and enums
Date: Sat, 13 Dec 2025 23:08:45 +0800
Message-ID: <20251213150848.149729-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251213150848.149729-1-jamestiotio@gmail.com>
References: <20251213150848.149729-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the CSRs and enum values used by the RISC-V SBI PMU extension.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/csr.h | 31 +++++++++++++++++
 lib/riscv/asm/sbi.h | 82 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index 6a8e0578..d5b1c7cc 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -14,7 +14,38 @@
 #define CSR_STIMECMP		0x14d
 #define CSR_STIMECMPH		0x15d
 #define CSR_SATP		0x180
+#define CSR_CYCLE		0xc00
 #define CSR_TIME		0xc01
+#define CSR_INSTRET		0xc02
+#define CSR_HPMCOUNTER3		0xc03
+#define CSR_HPMCOUNTER4		0xc04
+#define CSR_HPMCOUNTER5		0xc05
+#define CSR_HPMCOUNTER6		0xc06
+#define CSR_HPMCOUNTER7		0xc07
+#define CSR_HPMCOUNTER8		0xc08
+#define CSR_HPMCOUNTER9		0xc09
+#define CSR_HPMCOUNTER10	0xc0a
+#define CSR_HPMCOUNTER11	0xc0b
+#define CSR_HPMCOUNTER12	0xc0c
+#define CSR_HPMCOUNTER13	0xc0d
+#define CSR_HPMCOUNTER14	0xc0e
+#define CSR_HPMCOUNTER15	0xc0f
+#define CSR_HPMCOUNTER16	0xc10
+#define CSR_HPMCOUNTER17	0xc11
+#define CSR_HPMCOUNTER18	0xc12
+#define CSR_HPMCOUNTER19	0xc13
+#define CSR_HPMCOUNTER20	0xc14
+#define CSR_HPMCOUNTER21	0xc15
+#define CSR_HPMCOUNTER22	0xc16
+#define CSR_HPMCOUNTER23	0xc17
+#define CSR_HPMCOUNTER24	0xc18
+#define CSR_HPMCOUNTER25	0xc19
+#define CSR_HPMCOUNTER26	0xc1a
+#define CSR_HPMCOUNTER27	0xc1b
+#define CSR_HPMCOUNTER28	0xc1c
+#define CSR_HPMCOUNTER29	0xc1d
+#define CSR_HPMCOUNTER30	0xc1e
+#define CSR_HPMCOUNTER31	0xc1f
 
 #define SR_SIE			_AC(0x00000002, UL)
 #define SR_SPP			_AC(0x00000100, UL)
diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 289a6a24..35dbf508 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -47,6 +47,7 @@ enum sbi_ext_id {
 	SBI_EXT_IPI = 0x735049,
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
+	SBI_EXT_PMU = 0x504d55,
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_SUSP = 0x53555350,
 	SBI_EXT_FWFT = 0x46574654,
@@ -94,6 +95,87 @@ enum sbi_ext_hsm_hart_suspend_type {
 	SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE = 0x80000000,
 };
 
+enum sbi_ext_pmu_fid {
+	SBI_EXT_PMU_NUM_COUNTERS = 0,
+	SBI_EXT_PMU_COUNTER_GET_INFO,
+	SBI_EXT_PMU_COUNTER_CONFIG_MATCHING,
+	SBI_EXT_PMU_COUNTER_START,
+	SBI_EXT_PMU_COUNTER_STOP,
+	SBI_EXT_PMU_COUNTER_FW_READ,
+	SBI_EXT_PMU_COUNTER_FW_READ_HI,
+	SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
+	SBI_EXT_PMU_EVENT_GET_INFO,
+};
+
+enum sbi_ext_pmu_eid_type {
+	SBI_EXT_PMU_EVENT_HW_GENERAL = 0,
+	SBI_EXT_PMU_EVENT_HW_CACHE,
+	SBI_EXT_PMU_EVENT_HW_RAW,
+	SBI_EXT_PMU_EVENT_HW_RAW_V2,
+	SBI_EXT_PMU_EVENT_FW = 15,
+};
+
+enum sbi_ext_pmu_hw_generic_event_code_id {
+	SBI_EXT_PMU_HW_NO_EVENT = 0,
+	SBI_EXT_PMU_HW_CPU_CYCLES,
+	SBI_EXT_PMU_HW_INSTRUCTIONS,
+	SBI_EXT_PMU_HW_CACHE_REFERENCES,
+	SBI_EXT_PMU_HW_CACHE_MISSES,
+	SBI_EXT_PMU_HW_BRANCH_INSTRUCTIONS,
+	SBI_EXT_PMU_HW_BRANCH_MISSES,
+	SBI_EXT_PMU_HW_BUS_CYCLES,
+	SBI_EXT_PMU_HW_STALLED_CYCLES_FRONTEND,
+	SBI_EXT_PMU_HW_STALLED_CYCLES_BACKEND,
+	SBI_EXT_PMU_HW_REF_CPU_CYCLES,
+};
+
+enum sbi_ext_pmu_hw_cache_id {
+	SBI_EXT_PMU_HW_CACHE_L1D = 0,
+	SBI_EXT_PMU_HW_CACHE_L1I,
+	SBI_EXT_PMU_HW_CACHE_LL,
+	SBI_EXT_PMU_HW_CACHE_DTLB,
+	SBI_EXT_PMU_HW_CACHE_ITLB,
+	SBI_EXT_PMU_HW_CACHE_BPU,
+	SBI_EXT_PMU_HW_CACHE_NODE,
+};
+
+enum sbi_ext_pmu_hw_cache_op_id {
+	SBI_EXT_PMU_HW_CACHE_OP_READ = 0,
+	SBI_EXT_PMU_HW_CACHE_OP_WRITE,
+	SBI_EXT_PMU_HW_CACHE_OP_PREFETCH
+};
+
+enum sbi_ext_pmu_hw_cache_op_result_id {
+	SBI_EXT_PMU_HW_CACHE_RESULT_ACCESS = 0,
+	SBI_EXT_PMU_HW_CACHE_RESULT_MISS,
+};
+
+enum sbi_ext_pmu_fw_event_code_id {
+	SBI_EXT_PMU_FW_MISALIGNED_LOAD = 0,
+	SBI_EXT_PMU_FW_MISALIGNED_STORE,
+	SBI_EXT_PMU_FW_ACCESS_LOAD,
+	SBI_EXT_PMU_FW_ACCESS_STORE,
+	SBI_EXT_PMU_FW_ILLEGAL_INSN,
+	SBI_EXT_PMU_FW_SET_TIMER,
+	SBI_EXT_PMU_FW_IPI_SENT,
+	SBI_EXT_PMU_FW_IPI_RECEIVED,
+	SBI_EXT_PMU_FW_FENCE_I_SENT,
+	SBI_EXT_PMU_FW_FENCE_I_RECEIVED,
+	SBI_EXT_PMU_FW_SFENCE_VMA_SENT,
+	SBI_EXT_PMU_FW_SFENCE_VMA_RECEIVED,
+	SBI_EXT_PMU_FW_SFENCE_VMA_ASID_SENT,
+	SBI_EXT_PMU_FW_SFENCE_VMA_ASID_RECEIVED,
+	SBI_EXT_PMU_FW_HFENCE_GVMA_SENT,
+	SBI_EXT_PMU_FW_HFENCE_GVMA_RECEIVED,
+	SBI_EXT_PMU_FW_HFENCE_GVMA_VMID_SENT,
+	SBI_EXT_PMU_FW_HFENCE_GVMA_VMID_RECEIVED,
+	SBI_EXT_PMU_FW_HFENCE_VVMA_SENT,
+	SBI_EXT_PMU_FW_HFENCE_VVMA_RECEIVED,
+	SBI_EXT_PMU_FW_HFENCE_VVMA_ASID_SENT,
+	SBI_EXT_PMU_FW_HFENCE_VVMA_ASID_RECEIVED,
+	SBI_EXT_PMU_FW_PLATFORM = 65535,
+};
+
 enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
 	SBI_EXT_DBCN_CONSOLE_READ,
-- 
2.43.0


