Return-Path: <kvm+bounces-32097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DF3029D2F7B
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 21:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 391CAB259E8
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 20:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2781D86C6;
	Tue, 19 Nov 2024 20:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="OIXZdX4r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9821D3585
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 20:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732048257; cv=none; b=VGYqx5TuGkpH/7wvjI4QEUghAL/1ix/TfCKoxGJRV2GnIhW7EJx4V8avaxP2S7B2SiwTmhdY+G9G9DvWIIeJ2J709fjxsoSoLFgYkfFDl26j5js8UpSm2/3sFcixbqUWLpHJRuipDBUXi91gXY0GlNHh97Xx6lD30k5WlNMd83o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732048257; c=relaxed/simple;
	bh=5onDZuiSnkP2aXc6vh2wdwjeSxZ8XhBViklh3y0fpJo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WqNCMGbTNJwjGaPNRJVfoezmWuQyKlPkCPlNENnmmsZFJRH5/qhALtl0ZgeSQK+ASbDGXNz4pde4f7gUO8TGs0NMcRBe9uK6Yd9aB7zkOsbheoONxoD2S7O9yljE4ACGCJ3UBhseL4M6jcUtP1Db5of899d5qSqQxCI7HOqL4jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=OIXZdX4r; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-211fb27cc6bso33283825ad.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 12:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732048254; x=1732653054; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=40lt9LB/BTg/O24BZtpczZbDrdTkukX/GA7UpRzp0pg=;
        b=OIXZdX4rg/67XB2uYoxo+BdiMcIIImmGS3IqXzVpnA02peEDqOaUF4RBSOEXmlkp04
         LDZ+uIVlmu0OOf8EaxvdReIksX2jT4014V4Etk4ZCh2L6FM7dwV6HYD2k9LTB/lajm7A
         wn2IC3BFMqUAMSENK/Y/4m3DL6hlMqrPQ0L8TuOLdaEnwNMYUQhAC85JjNjzTcK+5ioD
         EZkZrZuNAsNOxLEMrNyXtjyHwZrSbbC5EoYjeAwsCDSKtZOWYw/Btm9cYa9SHzMpPJjg
         ufRrd3Ctnlb2xcFXu0McPjTFbdlQgenEI9sBAI2sVqKMS65XdxUyAIoOFfH2PYtagJUu
         yI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732048254; x=1732653054;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=40lt9LB/BTg/O24BZtpczZbDrdTkukX/GA7UpRzp0pg=;
        b=Ijftg0D1CHhjeT1dkNxhktRG+XuN792bkgbGolulu195pBsGlkmoU3WOol+rxQxNC1
         jNUeFu81AR6U47cyeXazWiXAT5x7YQbGCIrWtx5LPdjHw9ZAxxmqL8EHNaycpU0Zkt7A
         zH7VKz+lcCpe72DjCfN07KJpULJWm1/nMBy8f1SAEXGQmAncKbWOyHM6j4nuJc0CMle3
         gjgXMUtX96MxjmWB6JgcPDbAnYSvtyk+vJBD0aR/aBFGNLXQVJMgLKJLZkiyh7x9qi0C
         pk0ouurZDVocFNTpVqHRJCqeDLfPZoaXxyu2+gsXrb15ENSn+9rvtFohVOVMycWihP8J
         k5TQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDEmRwRHUG3z3OL5SvGh2coQ0MGIbLIPV1yNaXGPS5rBWkAF9qMSXMhtv43eo9C0Z7EUA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh2bwJ1/kfiahPrHuI/wnyME92+tXfIv0MN2NdE1rcc/BLqNTA
	NxFIKFHPje8ggTwmYHHGqpjTys3jPERi1zitOPij6wxzluJS6qx4nmWS3owM41mev/MNEmXTxGA
	0
X-Google-Smtp-Source: AGHT+IHsJO0hcJESjwh6eQu7qwaEvcwUlwaSmtArcLLxZHqVuVRuaI9OsGKiZZ86BxWZYDPkCaGZqQ==
X-Received: by 2002:a17:902:d2d2:b0:20c:5533:36da with SMTP id d9443c01a7336-2126b381b65mr257415ad.42.1732048254555;
        Tue, 19 Nov 2024 12:30:54 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f34f2fsm79001315ad.159.2024.11.19.12.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 12:30:54 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 19 Nov 2024 12:29:53 -0800
Subject: [PATCH 5/8] drivers/perf: riscv: Implement PMU event info function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241119-pmu_event_info-v1-5-a4f9691421f8@rivosinc.com>
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
In-Reply-To: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
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
 arch/riscv/include/asm/sbi.h |  7 +++++
 drivers/perf/riscv_pmu_sbi.c | 71 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 3ee9bfa5e77c..c04f64fbc01d 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -134,6 +134,7 @@ enum sbi_ext_pmu_fid {
 	SBI_EXT_PMU_COUNTER_FW_READ,
 	SBI_EXT_PMU_COUNTER_FW_READ_HI,
 	SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
+	SBI_EXT_PMU_EVENT_GET_INFO,
 };
 
 union sbi_pmu_ctr_info {
@@ -157,6 +158,12 @@ struct riscv_pmu_snapshot_data {
 	u64 reserved[447];
 };
 
+struct riscv_pmu_event_info {
+	u32 event_idx;
+	u32 output;
+	u64 event_data;
+};
+
 #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
 #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
 /* SBI v3.0 allows extended hpmeventX width value */
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index f0e845ff6b79..2a6527cc9d97 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -100,6 +100,7 @@ static unsigned int riscv_pmu_irq;
 /* Cache the available counters in a bitmask */
 static unsigned long cmask;
 
+static int pmu_event_find_cache(u64 config);
 struct sbi_pmu_event_data {
 	union {
 		union {
@@ -299,6 +300,68 @@ static struct sbi_pmu_event_data pmu_cache_event_map[PERF_COUNT_HW_CACHE_MAX]
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
+	event_info_shmem = (struct riscv_pmu_event_info *)
+			   kcalloc(num_events, sizeof(*event_info_shmem), GFP_KERNEL);
+	if (!event_info_shmem) {
+		pr_err("Can not allocate memory for event info query\n");
+		return -ENOMEM;
+	}
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
+	/* Do we need some barriers here or priv mode transition will ensure that */
+	for (i = 0; i < ARRAY_SIZE(pmu_hw_event_map); i++) {
+		if (!(event_info_shmem[i].output & 0x01))
+			pmu_hw_event_map[i].event_idx = -ENOENT;
+	}
+
+	count = ARRAY_SIZE(pmu_hw_event_map);
+
+	for (i = 0; i < ARRAY_SIZE(pmu_cache_event_map); i++) {
+		for (j = 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++) {
+			for (k = 0; k < ARRAY_SIZE(pmu_cache_event_map[i][j]); k++) {
+				if (!(event_info_shmem[count].output & 0x01))
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
@@ -316,6 +379,14 @@ static void pmu_sbi_check_event(struct sbi_pmu_event_data *edata)
 
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


