Return-Path: <kvm+bounces-53059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31B55B0D022
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5188754627F
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 03:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7346328D854;
	Tue, 22 Jul 2025 03:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ghFdOTZG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7842222D7
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154131; cv=none; b=k8UTntmmL5ReeTJXGBHixWGsobJ09uPzLSkI3PYpcb4LPRO5S1f/5AsfU6Gw8G0w/NWRHDDm50AMhhn7Chg5E5gyLISW9EG7mCKYPEWZEXEz1DNnisYXQGw2rBnpwnCwJu0YtzN/59SfXgvIvdkFM78Uv+oniB3+OrysJJRc6mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154131; c=relaxed/simple;
	bh=IzHWWZDhpoWbiCLmY/J2cSfKIfgXeRaJyx31cs9ScgU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c2YyISDkrnJZTXjCYd1hC5d/5CuL+rGvP6L/Oc7wr/AP4OPl7vr3uINQ4sPw3vFe4k8bfY6UAbChQwoF6lBkXB6rt5eonQXWdnTLOfTMsCqMxvm9Yt5qXIldzAx3w/8bHgdozU1MA3GAW5DkA58uyLCAadZZln/3V9UP1EngaBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ghFdOTZG; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-74af4af04fdso4186924b3a.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753154129; x=1753758929; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YOiuLvmg0zyyTxkdzmKKTYBl9SQzDB7q/BZgYmb7rvg=;
        b=ghFdOTZG6l/oi22GK/plQJ29dmS6rMRWBRf/mALNHGkP5eb5gXvd2q0BTDRbKoT6Rv
         UGqp7eWpOITgLIKzaGDodrDyFxf34HNQG2UUfPTFyZ/p/Rb87Lmf0mQmJnqFGXJyEdER
         E72/EbhNHP+KqReQoFSvKwbCGSkfwpp2cBMrXfiMUVmLBWyfaYYAxKAEz5U8m0kj5T1z
         KCs6/CAZ3Sg7jbozjxoZhlMSOwuvxgwXc6WKdDa3PWGFJ2hX+aFfmBIvuJ8ECY+Jp2eJ
         5wOG6cwQUSrfY9qfLhbLDR0JLT2bIFL+nVVLEXIurmMdRWGixT63lMZ4Ew+4rQxgZIh5
         SR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753154129; x=1753758929;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YOiuLvmg0zyyTxkdzmKKTYBl9SQzDB7q/BZgYmb7rvg=;
        b=XwX3hoJIYvKCgPJmrdfVNfhe9rIZsNqT2Mie2Xk8QvAedviqkGSRDvdnMfmpNKiolr
         CeYwdQrgYACGp7nZ0NrMEdKP6vlrO9PeWEKwWXAD3Hbz+8Z1s71HQd2g0oBFFv3VlnyY
         QEbk2DCWbhK/BnC+9fBXA7Sy+7WbBROYZoKL0rwhTy4lkupDO2rFRdLVysBnqtO/HGHs
         g2sDJJspQ9lKi0Nu1c7QemtH4rhyvSgABW07tU1+MjBbTzRathYAsGIYF6eUzDPAsP+b
         N91JG91s782/58CJqbHDgwHLnOBoaiVWsMpAPS6bHBXHqNMh2X13FM6UNz+b2AkSkV5j
         kDhw==
X-Forwarded-Encrypted: i=1; AJvYcCU9/ppEyNvvT8VmpPIL0KJX2Cp9y/7X0z3PdgH9vl+zjaWYrzKVKCDq5OHVFMt8rL0jqxA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi02MT9ZGd8cGg/NTff7EP/97+egXrryO8ZmgHG7uBWdifXr3b
	646E6sYIWs0JN0bQ3yffpq8GlLCSFYA9gKpvIPF8GsPboRN8YjBumjXIE1sr5GhevSg=
X-Gm-Gg: ASbGncujrHY+FjLXWrYu7FQ1a7OWw6fxKtDVkQMdti7ue2kav1U+KZLOXqmbjg2rK0b
	RWXI6pzp0kFvn9yg/0kGVPxxi02JpISpfqwQFrdg75jvSWZJ9rhjbZYSHP9BTC+7xLNvhJ0WPKF
	WYvUrOuhX4p7fwzqQY/h60t0gPVP1DN7LNxP3f/4J5PLmERZqbjGwV/Etw8kg1Pij+fURB2o17B
	hRJ2RDWaNIkhdCpPzBLAMyJqX7ji1sGr32j0/Ey6qcmfQWni1srgEcz9JzIlGOo7FucddbmQDsB
	2fXqoT4nYOdrCPKFWz9/R4LTYKsBRSlJ1wb8Ouo/xK9tgfuo7uyc3fUqZvkoNqi8aWnJ/d4YEht
	1XGdC7JUwQ7VvkCTQKU3DpITEU6rpLjEb7+w=
X-Google-Smtp-Source: AGHT+IE4m/tGD4iWa8+mTThA0s1cqsabkUVocojZBeVv2a32z+xQKzcohOpb05G+cpoLAKrGJbuRZA==
X-Received: by 2002:a05:6a21:99a1:b0:233:aec3:ce69 with SMTP id adf61e73a8af0-23d37ccbf52mr3181460637.3.1753154129335;
        Mon, 21 Jul 2025 20:15:29 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2feac065sm6027612a12.33.2025.07.21.20.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 20:15:29 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 21 Jul 2025 20:15:20 -0700
Subject: [PATCH v4 4/9] drivers/perf: riscv: Implement PMU event info
 function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-pmu_event_info-v4-4-ac76758a4269@rivosinc.com>
References: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
In-Reply-To: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

With the new SBI PMU event info function, we can query the availability
of the all standard SBI PMU events at boot time with a single ecall.
This improves the bootime by avoiding making an SBI call for each
standard PMU event. Since this function is defined only in SBI v3.0,
invoke this only if the underlying SBI implementation is v3.0 or higher.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h |  9 ++++++
 drivers/perf/riscv_pmu_sbi.c | 69 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index b0c41ef56968..5ca7cebc13cc 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -136,6 +136,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_FW_READ,
 	SBI_EXT_PMU_COUNTER_FW_READ_HI,
 	SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
+	SBI_EXT_PMU_EVENT_GET_INFO,
 };
 
 union sbi_pmu_ctr_info {
@@ -159,6 +160,14 @@ struct riscv_pmu_snapshot_data {
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
index 7331808b1192..433d122f1f41 100644
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
@@ -316,6 +376,15 @@ static void pmu_sbi_check_event(struct sbi_pmu_event_data *edata)
 
 static void pmu_sbi_check_std_events(struct work_struct *work)
 {
+	int ret;
+
+	if (sbi_v3_available) {
+		ret = pmu_sbi_check_event_info();
+		if (ret)
+			pr_err("pmu_sbi_check_event_info failed with error %d\n", ret);
+		return;
+	}
+
 	for (int i = 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
 		pmu_sbi_check_event(&pmu_hw_event_map[i]);
 

-- 
2.43.0


