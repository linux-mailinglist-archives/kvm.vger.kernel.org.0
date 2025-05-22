Return-Path: <kvm+bounces-47402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A83FAC142D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:05:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 471D3A40664
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F0929C330;
	Thu, 22 May 2025 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="pr0sl2Ls"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E349929AAFE
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747940632; cv=none; b=kwV0erj2DmPTW1MVsqmvimx6N19iA0JRIBjatmgb8IVGSSf4RfuaLDUQX39CFpl9IBDKb0qx6+9uoiolg2sSFlh5Fcj6hWb0QiVPvQURsXjlPQdjgowDrxwiGAQYeGEb/BL7CY+KfQwZKrPWZFx75oh8k3z2X00zmUV0iE0bhJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747940632; c=relaxed/simple;
	bh=H9KzbsOadvXKfagdeIiEb89m8/n30ul8CWjn2anZ1Ww=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C9E0nSh7UN2OfWM92f9iZZ+DkXwp0SW9GLtZK+jgQclkml3P9ZCyNLL4A8IJJOevKohZX9GLJlXsm47sWGRlAp9j1MXs+JcdcOu6IgvbxaSUTLfhw6xNGM1AVyBVh0m2PpB3Yu7A2XzP04KQMqH2mIuLJEQXLwMMlVre3TXimeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=pr0sl2Ls; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b1a1930a922so5691907a12.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 12:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747940629; x=1748545429; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fDxMnssaauwljQxlk9zc0qXTf5HAsn9k6GC49F2uSIA=;
        b=pr0sl2LsUduqLrQhnx6l2dXR7ZXc4JQiquUmHnwAF1y/1+cHit834oob72gqtcmymC
         BYxh39qlf5E8/WpvQN2AlHB3oTZUd4DH7pgpigiboNesh6JFQLyvOFPf2dtX09oCjg5e
         ek0aMYUqUyJE3OdVMXtK9jZVnrn3JgOKOLhNwyK75Eh1TTdxdWg1XpEMw2h40V6PJgC0
         6Y3KDaBlsL3pWfu0tO9vTDa84ljX2DxieP9LMNYTSn+Tsmt6NGM0QnQbjB/6E/16OBh6
         Dbae9HU3lAP+/btiZxghgkKzODEC5HN1faya6t7tS1J0novIVYmQ4PQ4i2uc+A+CRLeU
         YQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747940629; x=1748545429;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDxMnssaauwljQxlk9zc0qXTf5HAsn9k6GC49F2uSIA=;
        b=VY8KrgdZBkuLlCFln56+DWuuyQ3noBu10bNSdrMbvD3wY7fK2+jXtoSxFVxAgEIEFm
         wca3kHlb99DC5IGG6VJMafcNfHkE7vHoN3avzzsnRhNLAoRIQZzj3AgYNZaguwyT2x/p
         60nq5kXLuQpD3OfF+LJyu8XFf1DkItko1cGUuZH8gLfq1uEPfC1LcCRaf6HyuyOfFhGk
         BstBcJxIBUXGdVkLzHy+0O9LAB6JsJ81EhxtPy6PYUnsIG55AHCc6/eHQNCsF1Ooiwzr
         ibBcEJmThZXRLapQoTseB8zCv+8HIKzn+ZljWKKxygdOUHctWJkyeiXqRt01vZPTxR0W
         t1BQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2QqmPU+mTgIMKYXGrAtFn+GKWdkAfjRZtlMcxAow1r/5MMD0CS8MOXlioPrR6X5OT16c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgBke3G8JZ6MlM6pSlVsjuZ0ewCnVCbbxiF3tIyVszxa/cE59Z
	2Li+DxvN+TOxFroKmEHksla1VDcelljXt852bKwSTbx+EMs+qZ09Hh1joTfcimVL/hg=
X-Gm-Gg: ASbGncuK+SdH3Wdmt7a9yREdEPqpaKDxyCikAmmkU8+HDFi8LgI3C5XAn5ESWX4cH2R
	JQtz1Cij8GDSlMoVbfcKptK2uH+f2Z/ZmUNR7bn8oSO4hFerZU7VzoA8TnScCxtcN1WW96IS7eB
	eP9w9C9lL0LEdMvgpTZdjU70KNmVrgyF+nfORBwlbhJntpDaN5QL0YC0GxOsEQb+4ja9eTqo3kt
	t+XWTBG/eVn+NpWdBd3J9Bg+pDaRlvNK9SWASVDMcE9ylHdaRZdczQ4fdeSaxJXuH5YGeJRwSSO
	qCqX+XcICY4Z8m0Kljqtr08o2OPMAkFnkUq4u2e/T7yewoTLFjtj81ox+V9E/6Q4
X-Google-Smtp-Source: AGHT+IG3oxLFDfbSNt6EH0ZdTZ5dYeLSDKnP9JAmNGN1V7oKcB4sbiLpNV8c6lgFnjfD3N9PA0Fqjg==
X-Received: by 2002:a17:902:cf09:b0:22d:b240:34fe with SMTP id d9443c01a7336-231d451b294mr410839265ad.25.1747940628742;
        Thu, 22 May 2025 12:03:48 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9736esm111879155ad.149.2025.05.22.12.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 12:03:48 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 12:03:38 -0700
Subject: [PATCH v3 4/9] drivers/perf: riscv: Implement PMU event info
 function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-pmu_event_info-v3-4-f7bba7fd9cfe@rivosinc.com>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

With the new SBI PMU event info function, we can query the availability
of the all standard SBI PMU events at boot time with a single ecall.
This improves the bootime by avoiding making an SBI call for each
standard PMU event. Since this function is defined only in SBI v3.0,
invoke this only if the underlying SBI implementation is v3.0 or higher.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h |  9 ++++++
 drivers/perf/riscv_pmu_sbi.c | 68 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 6ce385a3a7bb..77b6997eb6c5 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -135,6 +135,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_FW_READ,
 	SBI_EXT_PMU_COUNTER_FW_READ_HI,
 	SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
+	SBI_EXT_PMU_EVENT_GET_INFO,
 };
 
 union sbi_pmu_ctr_info {
@@ -158,6 +159,14 @@ struct riscv_pmu_snapshot_data {
 	u64 reserved[447];
 };
 
+struct riscv_pmu_event_info {
+	u32 event_idx;
+	u32 output;
+	u64 event_data;
+};
+
+#define RISCV_PMU_EVENT_INFO_OUTPUT_MASK 0x01
+
 #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
 #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
 /* SBI v3.0 allows extended hpmeventX width value */
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 273ed70098a3..33d8348bf68a 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -299,6 +299,66 @@ static struct sbi_pmu_event_data pmu_cache_event_map[PERF_COUNT_HW_CACHE_MAX]
 	},
 };
 
+static int pmu_sbi_check_event_info(void)
+{
+	int num_events = ARRAY_SIZE(pmu_hw_event_map) + PERF_COUNT_HW_CACHE_MAX *
+			 PERF_COUNT_HW_CACHE_OP_MAX * PERF_COUNT_HW_CACHE_RESULT_MAX;
+	struct riscv_pmu_event_info *event_info_shmem;
+	phys_addr_t base_addr;
+	int i, j, k, result = 0, count = 0;
+	struct sbiret ret;
+
+	event_info_shmem = kcalloc(num_events, sizeof(*event_info_shmem), GFP_KERNEL);
+	if (!event_info_shmem)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
+		event_info_shmem[count++].event_idx = pmu_hw_event_map[i].event_idx;
+
+	for (i = 0; i < ARRAY_SIZE(pmu_cache_event_map); i++) {
+		for (j = 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++) {
+			for (k = 0; k < ARRAY_SIZE(pmu_cache_event_map[i][j]); k++)
+				event_info_shmem[count++].event_idx =
+							pmu_cache_event_map[i][j][k].event_idx;
+		}
+	}
+
+	base_addr = __pa(event_info_shmem);
+	if (IS_ENABLED(CONFIG_32BIT))
+		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_EVENT_GET_INFO, lower_32_bits(base_addr),
+				upper_32_bits(base_addr), count, 0, 0, 0);
+	else
+		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_EVENT_GET_INFO, base_addr, 0,
+				count, 0, 0, 0);
+	if (ret.error) {
+		result = -EOPNOTSUPP;
+		goto free_mem;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pmu_hw_event_map); i++) {
+		if (!(event_info_shmem[i].output & RISCV_PMU_EVENT_INFO_OUTPUT_MASK))
+			pmu_hw_event_map[i].event_idx = -ENOENT;
+	}
+
+	count = ARRAY_SIZE(pmu_hw_event_map);
+
+	for (i = 0; i < ARRAY_SIZE(pmu_cache_event_map); i++) {
+		for (j = 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++) {
+			for (k = 0; k < ARRAY_SIZE(pmu_cache_event_map[i][j]); k++) {
+				if (!(event_info_shmem[count].output &
+				      RISCV_PMU_EVENT_INFO_OUTPUT_MASK))
+					pmu_cache_event_map[i][j][k].event_idx = -ENOENT;
+				count++;
+			}
+		}
+	}
+
+free_mem:
+	kfree(event_info_shmem);
+
+	return result;
+}
+
 static void pmu_sbi_check_event(struct sbi_pmu_event_data *edata)
 {
 	struct sbiret ret;
@@ -316,6 +376,14 @@ static void pmu_sbi_check_event(struct sbi_pmu_event_data *edata)
 
 static void pmu_sbi_check_std_events(struct work_struct *work)
 {
+	int ret;
+
+	if (sbi_v3_available) {
+		ret = pmu_sbi_check_event_info();
+		if (!ret)
+			return;
+	}
+
 	for (int i = 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
 		pmu_sbi_check_event(&pmu_hw_event_map[i]);
 

-- 
2.43.0


