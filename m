Return-Path: <kvm+bounces-56314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1708AB3BE21
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A7CB1C26F25
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F9032276A;
	Fri, 29 Aug 2025 14:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="NfZAxqw5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D6B321431
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478474; cv=none; b=LIkAP04nx+lRyNivtKjjIzpnGsY3F7+k86nppweXy1mqT6mGa0t7CKwi1h6+8/SgK7GOkzgjVq80rBWCMInc8mCjKRuh21Di14wObCCDl7orXgzUCrpm8N6lKOdPymIXQYYABB4nP0nKPc3g4PYCIqlbqvZYeccR42PBnEILoUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478474; c=relaxed/simple;
	bh=MdulXEOUM7UKpN/Xgy+wJxXxlFoIIiYmV/qS25UDGvM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Gpaw8VKSRDU5cXJI8nE5g1cRmO8Pb6gd6R8dk8EeAYF+JIUHMiO1rK3vCXbXNQdIjNDQkimWLvAEjKXma/S7V6GMeZiDfDxiSd/o9C+PHRGheXUmqoT+FO21MIeuxL2xSyrP6CJV6/IvzUFgU/LwIzXsF6jDQe4QmqdnZ48ny9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=NfZAxqw5; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7722c88fc5fso708160b3a.2
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756478472; x=1757083272; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dxbAHn2gu8hPzgAv8AKJJWeRS0gDiHkMgaOyBvCoSlM=;
        b=NfZAxqw5Ckn9nmjBeNoVPmXgPi2paoprNMbdkJ+vJD36DuPyk3fx4+4KhzmKP538M7
         tj0BHcdROamfUqXf8XC4u1eznOo+v+h5YLqr2ZmqZKSnQbdGDPJTfb9LSXF4oM9G1b54
         tyUvu335hr+ywuelWTPZPjpWJ6aolOHOe4pvCVs4ZlYj/y4Uy5+ELGHG/cTjRRsNUiiC
         dsBdxN6wem8pthYfgRMC6RjHalcL9KjEy8U9QHDel/EsmrfketyqWLWMVYU2l92IRVil
         laaAZ8ufrX3CgKSMvffNvu9oMamDKql4sqSXKD402lJPVjhHg6pznhkJpH2rV4dDW9zc
         +3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478472; x=1757083272;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dxbAHn2gu8hPzgAv8AKJJWeRS0gDiHkMgaOyBvCoSlM=;
        b=bh3TcohEyv7G9Z2omyGkBMqMKc8wfXtgWhVw7eUBfHJEGpvwwxk2qVaA1yuWqire22
         TwIBpqbdyNcaCkBN3Qzf0MnXHH6vMqYOJGKNoaw782veokjMQlVUow9lmfxagh2V/u+Q
         ERxiobECLGQEZkH/dVBV2D/fZwc4gg9p76uxxctqh1YRlgh0ZbDMGEcmM/OyW1IGIVa2
         1HaBoPHaRRBHfPSyDEyhfN4/thVyjTPOp0+eAtfD2uchArRiwWVZGoRvyO1ZdNxqrToi
         0a06m4eNqL0TbM9jAazT68WYRSQlkzngydjSnoTJrfHGPTg+gh6qW+9ig0wLr8AMqEo9
         krWw==
X-Forwarded-Encrypted: i=1; AJvYcCVKkD5+M8AZIUUZQyS73wKrFf7dATD7dE0NwA5NjN0CMmc9rU384tztuTp8sBZ3CgcT+mk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRpbiosMRhsoen/SYlw8VAGch7WwXRRVTS52wErw1XP48auOsX
	EC5UkeS2hnZLFv6LP9+1PT50QcG/SIOBvu9lp8vLHXfuqKx3T3pSNuQe7mT4wmr4m0o=
X-Gm-Gg: ASbGncv71gzGVZvgtl1T6YQpnkDP8QmSxhC/dTfQAP64mZEBlPYYQdeVrCYdXQbPqOp
	tTkAnHL5nbWiVmi8eRXYuzlmClWYy4t0flOTg5ustHQOpWqzx84Qe+XhPa2++wL5epFQu5vF4Ed
	qmvSPC2zO2/GDcuFGD17G6wmZZrDLOuAu0ML+su0aSjcN7LnztZI5+XMqNrh00VHCny5F5Acrkn
	mBjz9ksala/kmOAYBkrP4qsxgTGZjjNdc21U0c7SZWsLnukgQRWhDg1YadbLi7tS6mutYA1PmoM
	SmeUT8/5s8vruEiWNCvOcczvWJ5XOIY3fgrzZA1ANcFtzAb7R/doVJ9jh3XSZCCLxJZXhubm7yM
	aekEq4Y8OWGAWYEIlH7mlVgOylUv8B6HreXMU/gY/EmghJQ==
X-Google-Smtp-Source: AGHT+IEcRaNRwLVZvQ0+PFDpEZBl5TqywmCgn+6HMV79ElMQ8KBIAJHpCBhlQym1EiHDUaUbZ/iP1A==
X-Received: by 2002:a05:6a20:6a26:b0:243:c36f:6a7c with SMTP id adf61e73a8af0-243c36f6f4dmr3879485637.18.1756478472441;
        Fri, 29 Aug 2025 07:41:12 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1f86sm2560999b3a.72.2025.08.29.07.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 07:41:11 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 29 Aug 2025 07:41:05 -0700
Subject: [PATCH v5 4/9] drivers/perf: riscv: Implement PMU event info
 function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-pmu_event_info-v5-4-9dca26139a33@rivosinc.com>
References: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
In-Reply-To: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-50721

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
index 7e984ab717c6..0800ade1d0d5 100644
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


