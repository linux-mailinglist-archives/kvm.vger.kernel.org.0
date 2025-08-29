Return-Path: <kvm+bounces-56316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BECD6B3BE29
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48D5A168EDF
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851C3322C9E;
	Fri, 29 Aug 2025 14:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="OC8PKl0g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26C73218DF
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478477; cv=none; b=Q0zs2pcRYWbQ7WJAqrD4+03SP7kQLDHlewZ+6RoGI7lWopLuHr0KNbU7QjIrL7my0T3O6eBuWOCbQFDrJTszcD6QGcllvJm8UqYxJhye16+VcVTJloISZugnHwVVRpAb0exFC2FvXbCIlae1+XtKN1SesuEUeFeZzzgOOuvNaHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478477; c=relaxed/simple;
	bh=k+LqgjXzzLmGK6Fr1/7D9cO9WxsdSZi3fAFA+heh200=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fdozft2dRRysGKEebZsuCnz42v2i+u1TYNY/43fxavHtCZKyMtdocyLyXCM6/KCT+ehno2E3chgEUs4+Abe3c+oxJTBBUGG19WpLBbVVNr1/8zPavht/abfHOjDzTmgEnKytH/ARf7JMCJJi9g3muWXNOFXM3szVOXkw1sJFwKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=OC8PKl0g; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-771ff6f117aso1952690b3a.2
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756478473; x=1757083273; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DuhopmvMJD6AmI9ErsWAbRzYROuI1OFJgLKz4muMCjk=;
        b=OC8PKl0gBAj++yaGLyQ3jKNZvlby8fI1wznHsN2Eok8nXOal0/+jlGAR1q5g2seeE+
         2cZUYmgqUSxjNkbA5P5mlCNpBv/R2nFlTvjPyHymErEPheeGgZuQFTEf8UWlgmZz9TqW
         4c1rGwqbqgFVDZdORjMobmu54uYNezpb1Ob4X5/p2/pEyevq5kmjxJYTWbmqGDkxrJtI
         BynS/lerBqap5sG+Rc04V29M0AwD0Xo9DuSLY8sNAnIe0e4BSzYnEs36+tSBAG98cn7f
         RwdClGLhc/4LLIj7d+MkZLAox21M/TCcdafF7RmeDlUOdUSGU6ceuhjqWsQDa2tQVHZg
         Z0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478473; x=1757083273;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DuhopmvMJD6AmI9ErsWAbRzYROuI1OFJgLKz4muMCjk=;
        b=lhzJUFUPM74ig5zaxuOUzPB/KOK7NgldxF4HgJyim5CErMI3sbnyj80h8G3Tfd6i1M
         06CjsDJJbXmeLtgyPVIVeOdJS5mXiFHJYeiV1xVYUSLSi3elnedf0dKiUSs9gvKHcC1K
         bzeFBRWnH0JcdLjtwqMewXC3M49ilAR2Z9Dx/3XDElE3OkbBGTsnFzNBfMMjlnJtbo95
         Q9KucfDulY1henWwBGpeVF31VgofwWCThtKRV6cI5MEf51jh7dFFxZ0XLRaCIQ/bwwNu
         DPzsC5Uwc5emcJU40eal8QhTeIEiOHpN2WGoAjO/y23p5CmEDbsspz7qzEEQq5aajRSR
         /P2A==
X-Forwarded-Encrypted: i=1; AJvYcCWXuaCsVj9s6zM4Mn9AhHXfxj/GDu9k9b6ni/hQRfyQ3oaDo+FWg2t/qrHwHs4bNb4/ysQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaWnkGlHrtK0kNs2XeDVo55Sfo0cClDUg4VzndhgDnQWJI9DEU
	tMExmsWJ30bYUcIECHid9NRz9hOLOy6XX7jNVcXgYCaZIy7K/9QHGMf1AE9sSLWlnHY=
X-Gm-Gg: ASbGncsEfgGviQ3hIzPyW8CITjvR2utZkQ0LZZTjOMLINAtsxfY/92DTViM62X8egid
	k0U6Ea2t5fP6tEFWyFOHlnQ2txtgwjL7QYvtSfa9vvr4QXpWoXZW/EHWfxNEkNoUSeP1a3rJZFv
	5tFPabkxGhfNOVqfAZFKjUX2FtCVqBsUWwfA0l/D/OoxjCNlSn2vxc6j6ZsBhg1TaYqzYpTVS7q
	BuaTY3/91fgMX00DBFlQWhl1IQMWKp74N7BIqXW67S6zWyMrUb1ptpbmEwY1NET/7QxgmNIrW1E
	F7bAxZ4mPSIK27OMzQ6AUrnVEKYWeJObtP0HglkIP2WaHaMY/1RXo9vZS2AjGOGyZk8AygRnT+z
	fInE+SRAkAg4+GQNIo3S2b9SKJoVi0q68UJXXl4xeoPkTSA==
X-Google-Smtp-Source: AGHT+IFKu+50yqqSOgpeLJyOFV4rCaLFVpp2RVi5iZb8Nuz83CnzQCACwKb8OL/eXwNpYfHYvSwbXg==
X-Received: by 2002:a05:6a00:4611:b0:772:3676:64d with SMTP id d2e1a72fcca58-77236761dcemr1223973b3a.27.1756478473332;
        Fri, 29 Aug 2025 07:41:13 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1f86sm2560999b3a.72.2025.08.29.07.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 07:41:12 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 29 Aug 2025 07:41:06 -0700
Subject: [PATCH v5 5/9] drivers/perf: riscv: Export PMU event info function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-pmu_event_info-v5-5-9dca26139a33@rivosinc.com>
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

The event mapping function can be used in event info function to find out
the corresponding SBI PMU event encoding during the get_event_info function
as well. Refactor and export it so that it can be invoked from kvm and
internal driver.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
---
 drivers/perf/riscv_pmu_sbi.c   | 124 ++++++++++++++++++++++-------------------
 include/linux/perf/riscv_pmu.h |   1 +
 2 files changed, 68 insertions(+), 57 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 0800ade1d0d5..0392900d828e 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -100,6 +100,7 @@ static unsigned int riscv_pmu_irq;
 /* Cache the available counters in a bitmask */
 static unsigned long cmask;
 
+static int pmu_event_find_cache(u64 config);
 struct sbi_pmu_event_data {
 	union {
 		union {
@@ -412,6 +413,71 @@ static bool pmu_sbi_ctr_is_fw(int cidx)
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
+		 * As per SBI v2.0 specification,
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
@@ -577,7 +643,6 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 {
 	u32 type = event->attr.type;
 	u64 config = event->attr.config;
-	int ret = -ENOENT;
 
 	/*
 	 * Ensure we are finished checking standard hardware events for
@@ -585,62 +650,7 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
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
-		 * As per SBI v2.0 specification,
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
-			/* Return error if any bits [56-63] is set  as it is not allowed by the spec */
-				if (!(config & ~RISCV_PMU_RAW_EVENT_V2_MASK)) {
-					*econfig = config & RISCV_PMU_RAW_EVENT_V2_MASK;
-					ret = RISCV_PMU_RAW_EVENT_V2_IDX;
-				}
-			/* Return error if any bits [48-63] is set  as it is not allowed by the spec */
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
index 701974639ff2..f82a28040594 100644
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -89,6 +89,7 @@ static inline void riscv_pmu_legacy_skip_init(void) {};
 struct riscv_pmu *riscv_pmu_alloc(void);
 #ifdef CONFIG_RISCV_PMU_SBI
 int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr);
+int riscv_pmu_get_event_info(u32 type, u64 config, u64 *econfig);
 #endif
 
 #endif /* CONFIG_RISCV_PMU */

-- 
2.43.0


