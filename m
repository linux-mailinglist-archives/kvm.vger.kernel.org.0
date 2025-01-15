Return-Path: <kvm+bounces-35588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61006A12AE7
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:31:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8064F1889D5F
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35AB1D89E4;
	Wed, 15 Jan 2025 18:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="QIzv/UB6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E41C1D7984
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736965862; cv=none; b=sb53+FwyMxyB/mK4xuoqreKtyMEKOasKMJYJzhAV1oHzZQslDdil+WN5xbg4NOmWxVdIA92pR/nGK1rc59WoITCEjw7RoU8MEglJ8iA+IQG7rWZlL2MWIpQ07+YZwTG1o94EU290S4jzN42zxI+9zOLiTTxFgZBh6yRUV6Kjgok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736965862; c=relaxed/simple;
	bh=OfDSy2joQdVcFT7jBgw7uGk7SzYpOcCrRH83Sx1YrrY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Qn+WTDWM0Eh7NI/WdRS7zJJrApeJVbDRTBBU2uxqyGbkCZEac4TaPSp59g3cDLB+grjidNwG8Y5r0K5P9L1nMJDa70SAMT4jUCx5M9Vi8xqLgLzd73+H6Ekjfz6IrYWHWZ75LYfqS/TFk6+XXYMRYqdXfOwEvw8Kw6mZ+ayl6n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=QIzv/UB6; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-216395e151bso1994935ad.0
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736965860; x=1737570660; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JC3EeyOvWf7FtpVzWoJ1Ny8l+dOUVPRncQAFsx1SwlE=;
        b=QIzv/UB6l213YYMuhc9jNO5TWyOxr13SOu3SQN0cCWV8cx7dAyUbWpEV4V4tfDadF4
         sJlC3fbc9DE6M+q/bZBd+337fmI0Ceb+uK4OZdymD0sMPA34rzkjYGIhWe4FvgElAVT6
         Br/sv8nuJqosPsK4oXk2eDQmtoxvwjggcE3ZaW+i8PfYApj21z9DqU8pl5nCRyLoWrry
         jJ7hmhYIeHIc8ThiG6CrTBIffdNtoRN38JqOQz8E+jRsPp9dS+TtXueY1WyOuVQ70jx0
         nlxo5dmf+gE1CbhS3Zwm7Wl1hXtC6JG5uv8v1MfFNOhft2cB+fLSMyhfnqFq4eItsQ5A
         99+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736965860; x=1737570660;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JC3EeyOvWf7FtpVzWoJ1Ny8l+dOUVPRncQAFsx1SwlE=;
        b=uIs2HW3cKWeGmO/XvlifFUmIYexdT9eDaScyoxV4uROE9co1czsmbZjWEnIhuYOZti
         ZhvLNQrTdrQLJZsjPeEcWztBqSrhIE6TX/3s9FWnudEe1rI6treBeZ2j3bTPGGxm7yAR
         CpEBMefNeyuvVVy99LrDBgPO9RXJtoU5gZzwEDmsdjc3qoc3c6Fnbeus3l1+lKs933J2
         lrf0hxKf7Dtlb59QPSH3XgvzOva46SYGvfl6PC9QVGQRUUO2uUKkPmDpVHe5KpUp1spx
         0UubNybHrtNFhQF4H0SvQF5bCr6nkB9iKWFDwUVbOvr5XkMPE3D8ucuXgtGsrvduYO0m
         QWNQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0LpTyxErMMpJgt3BPkQnb0Sy4S46oxzdY/uhBx24gO7uJxEDwyAxPRB0TFukwTzDe4vc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsl6sqEFfLpz2jYRFDTzcyfCf/o6hBl0RT4Hnnyz0/jKshp7Zh
	WJ95AIHpqjqibxi+uec6kPJwUO/wiDr7OT8KYANfCAsVS4aD4BzgjDZXKXdMqRk=
X-Gm-Gg: ASbGncvilu+cmLbbeBtVbxOKgUsvbHrZIFxSAInOcxu0g+f4Zm0Sp4WGQ5WOK7OqF2N
	ZTBnMN8t8MQRrbH+WycZdKzEgkAH7ORF9tZKv5ZAhUsxXEU/CqXIc6f3FaRoar5PTlrORRkGOv3
	8ix6NNR+bOv5ccVs2u8ZPYKHHB0mUpdPhg13vFo9YcEpqG+L2jq0yTnDvrRZL2ex1O/PoQoxRbI
	E+X0x3S3uW3YTNwmz9s6mkAJJSHQM8ACDvM7/f4eFO9oWUsOm+kRe+3X4DszOBgA9QEPQ==
X-Google-Smtp-Source: AGHT+IH3olozIYSo4r3r15dhiFKl3/3XHwJwjdJ6AtULTMFFycwztXRXf6ddeRVzYwbOviD3YM/ZOQ==
X-Received: by 2002:a17:903:1107:b0:216:5db1:5dc1 with SMTP id d9443c01a7336-21bf0b76a05mr61009835ad.1.1736965859902;
        Wed, 15 Jan 2025 10:30:59 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219f0dsm85333195ad.139.2025.01.15.10.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 10:30:59 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 15 Jan 2025 10:30:44 -0800
Subject: [PATCH v2 4/9] drivers/perf: riscv: Implement PMU event info
 function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250115-pmu_event_info-v2-4-84815b70383b@rivosinc.com>
References: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
In-Reply-To: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

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
index 5d5b399b3e77..7db78c7a1524 100644
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
+		for (int j = 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++) {
+			for (int k = 0; k < ARRAY_SIZE(pmu_cache_event_map[i][j]); k++)
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
2.34.1


