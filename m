Return-Path: <kvm+bounces-47403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BFA1AC142E
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B954016A5AA
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D7F29CB20;
	Thu, 22 May 2025 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="hBqJluA7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11E229ACE3
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 19:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747940633; cv=none; b=gQwM6y0hmq7hprTxQaTaMHwfSOzYUAn1QBg6Yq72PdgOyf9HSP7C8qraiUF2PXqmCcaZfDfECYT7QGVOYKFiRYuYCsAxJaXCp3V4voKcjPUOAirkWXIg28CtyWi/ppzxk3/7xu4+FQm1VST3DsaeRIDcVPWdtMW+vNEy0LmNdSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747940633; c=relaxed/simple;
	bh=XtnAlGo1CMxnPO6JKVTmzRQxeB6Au4XDCuScFVWUWUo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hGNbOnCaqPwJLDaZyPTLKcjXriKfSGXp5B25wra6V2QKhXk2NvtGSLUlDY40XluaRU0u43tjI5ALnHu1ahSAbFYtv3FNEUovyiCbtYWipCM/bpjX5S8gm5+2+PUzpt29wgPc0BX9RxmdiokrM0ww4boSyw/i6XpEUakgnTzykHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=hBqJluA7; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b1396171fb1so4807250a12.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 12:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747940630; x=1748545430; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vACMU+uOLyj1bSQA4LVJfCqGiOCws5jCYjHnigZ5yyQ=;
        b=hBqJluA7T1hPq4nhcbGH1tMB+Flx7JrRS30F7wX7GSI4gvdRq0cELC8J2mjLeXfDPn
         sfSzcsmqfC9nW+lqU7ZM3sRRbsAZLviIN8qzhW2UpS854v+NqEIyrorzD+vGoyql13lo
         L/v4hXWiML5xuWQSDc6h4FvMygPXxG31DuFwfEN+i7MBWUkOEX7f3js4laNonnjJJCK+
         PUyG09Z0LuzQZ7Rw4GnT2chn1/FPidZCZRzgsqcKH4bvgN+cFiZhwtVZxo48lC9u2hH5
         5hVXVemJ+rVqQMubhJ08cg9uRNPWtIbHDTBC2bEqpUJUHedUTmRKkX8YQ7Z76UaS9Je6
         7/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747940630; x=1748545430;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vACMU+uOLyj1bSQA4LVJfCqGiOCws5jCYjHnigZ5yyQ=;
        b=wNQqcNfI4hb3icuzz9ZV2cI4hvil/SztB/gWRuioxHVjy63Rly1W+GTxJAe53gIaN0
         A8G9b78g78GSv4XSTg5AFn0I0rq4WoEjEQBLtpbFc9kdS0STAP2TGR2YLAUyLJQoRoeR
         1kScXMYEGsLoJZ+8VHd0ag/BpwHsh5OCJFblz8kE50yYFLMNJvhO3T4NQMiT6/9rzrVy
         bnLY8XrkCf1w4VZ/CD0XYcPV8xnqtyaHaNHzAdgNrKPJz5GKqwXyCZlmn39gJANn1Ya6
         fniNzb/hXe2pzL3H5alBaWT9WV7oyJVKTe11QGpspYR++yKBEj+/blucWLbH7C+UOgKO
         jOrA==
X-Forwarded-Encrypted: i=1; AJvYcCU+3cpTQrLRx9hsyBkgXmjKRDBwXBaRa808/nQAGEHyJeMoxNiEx7+F++/2W97Jk8iKFqk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqqjCtQvfzbsCIoXVrN6xy2mDFYON2981dPg4wHZvKMbp/H3rE
	yhBLG7VSUQjEF6LvcvSr+p0N4x/H2ETEG6mFBsJNkclW7LO5HQitzx9p3MDBr3TdayE=
X-Gm-Gg: ASbGncvqZUN4Uo/f3/nLUoecF8QclNXsnveOAx8DP0fOfxn2fwsvQpNFhBSps4sA+1O
	A0XP76htJlUiMZFq3LceQsR60eo7db0k5OKBahZnen6HK0xbsP8qsn6IL4PUCeYHEZMwDnehDh/
	cfipmKWR1hUz/WwBalXhEr0UOqG3AZypWPia+NHka/17zjwQ0jD29XpP/dyns6ytOpDzxQC3vZF
	zwXmq10Ve3tbI207fzPVtMinWJwaiPIHokhnR3miOjOYiOl9ubwN/D1wEl8+gCDPc8dNkAvfE3T
	6GQeC2Z2eyZPFX8aAKv3NIM2xY6X02p2ir34bfDgR6QoJs1lhhjb+q1esHgfteSpWgJiyQu0fmQ
	=
X-Google-Smtp-Source: AGHT+IE3kKHYdKAzGiVNjvDReRIr3YIXelNJnoPPmROIVHQY8jqz/Q50hb8MBVNgcI6K6CgV+C9sRg==
X-Received: by 2002:a17:902:ea0e:b0:22e:8183:1fae with SMTP id d9443c01a7336-233f25f4019mr1589425ad.41.1747940629899;
        Thu, 22 May 2025 12:03:49 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9736esm111879155ad.149.2025.05.22.12.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 12:03:49 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 12:03:39 -0700
Subject: [PATCH v3 5/9] drivers/perf: riscv: Export PMU event info function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-pmu_event_info-v3-5-f7bba7fd9cfe@rivosinc.com>
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

The event mapping function can be used in event info function to find out
the corresponding SBI PMU event encoding during the get_event_info function
as well. Refactor and export it so that it can be invoked from kvm and
internal driver.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c   | 124 ++++++++++++++++++++++-------------------
 include/linux/perf/riscv_pmu.h |   2 +
 2 files changed, 69 insertions(+), 57 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 33d8348bf68a..f5d3db6dba18 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -100,6 +100,7 @@ static unsigned int riscv_pmu_irq;
 /* Cache the available counters in a bitmask */
 static unsigned long cmask;
 
+static int pmu_event_find_cache(u64 config);
 struct sbi_pmu_event_data {
 	union {
 		union {
@@ -411,6 +412,71 @@ static bool pmu_sbi_ctr_is_fw(int cidx)
 	return (info->type == SBI_PMU_CTR_TYPE_FW) ? true : false;
 }
 
+int riscv_pmu_get_event_info(u32 type, u64 config, u64 *econfig)
+{
+	int ret = -ENOENT;
+
+	switch (type) {
+	case PERF_TYPE_HARDWARE:
+		if (config >= PERF_COUNT_HW_MAX)
+			return -EINVAL;
+		ret = pmu_hw_event_map[config].event_idx;
+		break;
+	case PERF_TYPE_HW_CACHE:
+		ret = pmu_event_find_cache(config);
+		break;
+	case PERF_TYPE_RAW:
+		/*
+		 * As per SBI v0.3 specification,
+		 *  -- the upper 16 bits must be unused for a hardware raw event.
+		 * As per SBI v3.0 specification,
+		 *  -- the upper 8 bits must be unused for a hardware raw event.
+		 * Bits 63:62 are used to distinguish between raw events
+		 * 00 - Hardware raw event
+		 * 10 - SBI firmware events
+		 * 11 - Risc-V platform specific firmware event
+		 */
+		switch (config >> 62) {
+		case 0:
+			if (sbi_v3_available) {
+			/* Return error any bits [56-63] is set  as it is not allowed by the spec */
+				if (!(config & ~RISCV_PMU_RAW_EVENT_V2_MASK)) {
+					if (econfig)
+						*econfig = config & RISCV_PMU_RAW_EVENT_V2_MASK;
+					ret = RISCV_PMU_RAW_EVENT_V2_IDX;
+				}
+			/* Return error any bits [48-63] is set  as it is not allowed by the spec */
+			} else if (!(config & ~RISCV_PMU_RAW_EVENT_MASK)) {
+				if (econfig)
+					*econfig = config & RISCV_PMU_RAW_EVENT_MASK;
+				ret = RISCV_PMU_RAW_EVENT_IDX;
+			}
+			break;
+		case 2:
+			ret = (config & 0xFFFF) | (SBI_PMU_EVENT_TYPE_FW << 16);
+			break;
+		case 3:
+			/*
+			 * For Risc-V platform specific firmware events
+			 * Event code - 0xFFFF
+			 * Event data - raw event encoding
+			 */
+			ret = SBI_PMU_EVENT_TYPE_FW << 16 | RISCV_PLAT_FW_EVENT;
+			if (econfig)
+				*econfig = config & RISCV_PMU_PLAT_FW_EVENT_MASK;
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(riscv_pmu_get_event_info);
+
 /*
  * Returns the counter width of a programmable counter and number of hardware
  * counters. As we don't support heterogeneous CPUs yet, it is okay to just
@@ -576,7 +642,6 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 {
 	u32 type = event->attr.type;
 	u64 config = event->attr.config;
-	int ret = -ENOENT;
 
 	/*
 	 * Ensure we are finished checking standard hardware events for
@@ -584,62 +649,7 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 	 */
 	flush_work(&check_std_events_work);
 
-	switch (type) {
-	case PERF_TYPE_HARDWARE:
-		if (config >= PERF_COUNT_HW_MAX)
-			return -EINVAL;
-		ret = pmu_hw_event_map[event->attr.config].event_idx;
-		break;
-	case PERF_TYPE_HW_CACHE:
-		ret = pmu_event_find_cache(config);
-		break;
-	case PERF_TYPE_RAW:
-		/*
-		 * As per SBI v0.3 specification,
-		 *  -- the upper 16 bits must be unused for a hardware raw event.
-		 * As per SBI v3.0 specification,
-		 *  -- the upper 8 bits must be unused for a hardware raw event.
-		 * Bits 63:62 are used to distinguish between raw events
-		 * 00 - Hardware raw event
-		 * 10 - SBI firmware events
-		 * 11 - Risc-V platform specific firmware event
-		 */
-
-		switch (config >> 62) {
-		case 0:
-			if (sbi_v3_available) {
-			/* Return error any bits [56-63] is set  as it is not allowed by the spec */
-				if (!(config & ~RISCV_PMU_RAW_EVENT_V2_MASK)) {
-					*econfig = config & RISCV_PMU_RAW_EVENT_V2_MASK;
-					ret = RISCV_PMU_RAW_EVENT_V2_IDX;
-				}
-			/* Return error any bits [48-63] is set  as it is not allowed by the spec */
-			} else if (!(config & ~RISCV_PMU_RAW_EVENT_MASK)) {
-				*econfig = config & RISCV_PMU_RAW_EVENT_MASK;
-				ret = RISCV_PMU_RAW_EVENT_IDX;
-			}
-			break;
-		case 2:
-			ret = (config & 0xFFFF) | (SBI_PMU_EVENT_TYPE_FW << 16);
-			break;
-		case 3:
-			/*
-			 * For Risc-V platform specific firmware events
-			 * Event code - 0xFFFF
-			 * Event data - raw event encoding
-			 */
-			ret = SBI_PMU_EVENT_TYPE_FW << 16 | RISCV_PLAT_FW_EVENT;
-			*econfig = config & RISCV_PMU_PLAT_FW_EVENT_MASK;
-			break;
-		default:
-			break;
-		}
-		break;
-	default:
-		break;
-	}
-
-	return ret;
+	return riscv_pmu_get_event_info(type, config, econfig);
 }
 
 static void pmu_sbi_snapshot_free(struct riscv_pmu *pmu)
diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
index 701974639ff2..4a5e3209c473 100644
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -91,6 +91,8 @@ struct riscv_pmu *riscv_pmu_alloc(void);
 int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr);
 #endif
 
+int riscv_pmu_get_event_info(u32 type, u64 config, u64 *econfig);
+
 #endif /* CONFIG_RISCV_PMU */
 
 #endif /* _RISCV_PMU_H */

-- 
2.43.0


