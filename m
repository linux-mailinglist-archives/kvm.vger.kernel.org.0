Return-Path: <kvm+bounces-56312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79D86B3BE19
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 853D917EFAF
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C3B321445;
	Fri, 29 Aug 2025 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="LlHbSHF0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CE9313E0A
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478472; cv=none; b=Hv03K3EcFvcpwwU33h9Uig+dSJWYHZE+4Fdf548dBYyPzJGSKXs88p2JZPkDHLbr/JLMONzUMe3C/wGZkuVVekSYVKBCCc5rW+oDoeJS8Mos69yn6rykEfhgdel1c1eYpFHvFuZyXNJGxtv0jmXhHa+oXydBEm2mz/3sbLac3bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478472; c=relaxed/simple;
	bh=5a42n+9lUYW8j8nzv38kypGGaOUyfv0cna4E1TQCaGY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hOaBBY6BDAbNOkqx4cXSIvIMa2VFgVgpjXX3BFcoeD3R6FFDVEzNTWHODR+Vh4EPVpmdWTpHNq6bq9VzmblZp34EC8KssKefm3UQz/4OAGXGQ1EtSfko7Kn/3HVp0yE/ie4AYKXjQzNXa92ZJ+00fQIHKAdN8Jv6Yh2ns7oIzJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=LlHbSHF0; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-77201f3d389so2312466b3a.2
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756478470; x=1757083270; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tI741R36HWDh2RhVHZyQphWWAJjaxVoQsq24GTtFdYc=;
        b=LlHbSHF0cBJquMcepqNY3+jppsv6CidYIcqxQz0r9YMPkBJ3wdim7gEVjfmGmOceVN
         JaFetMALYtbQ+3pzwd4M4D4cwI71yzShhUlRS5SooWrY0XM+Nxx8FtEwB0zmyiHYnl4u
         n60j+wVWRE/wPV30Dt7EG2kwbGU8gkE2A3ab1o1A/ZOx0+xst3N3obU02G0k4HCrYk+Y
         q4dhUhUFnXgwZdTk0WGHaJ7zL1ev6hwbDRvINEIKgghSH6V6eY52TyVks++B/qixAoh4
         1HR8N/ac7BYD3jgaAgdWfpCg84iq9GkO0ZjQCHYElWb/KHhSczud9qIY+lDhcUcu/qgP
         miAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478470; x=1757083270;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tI741R36HWDh2RhVHZyQphWWAJjaxVoQsq24GTtFdYc=;
        b=YdTPUfxd65i9DFc0SF0+H/MtlDPrH0QVFy3QRla92AiPG5A1bYzizgBUtvz2PeeQFm
         i+STaxIFOJur7niqqcRMELpgvaaIXb2HmlWkHVfe14HKDk2n3SW+KlGdES7CG7eB5r07
         JjhE6LPs6WCbanXwCgazOmdfJBuv3hIyjqtTsERGQS/FZTxLatMHsrw71NOLFP6ZZy7y
         G31t9TWCmRUfajb/pCGG8pTRkY76qLPJRLCSb/YObxwIH4HoZQ92iG9rzAt0h4zXLoKZ
         GTRdz1GsdXaB4khKeZ15i9HKkGZys+fe3eHrncM1FN9l7ZzzrcAAhiL3n52siXYVonXp
         rAQw==
X-Forwarded-Encrypted: i=1; AJvYcCU/t1PoCbS6LVnV6sTunp1kLwzpWE2UQ7vCzgZS5ZaelOv+NS5TU2jNr69wZwnTgwvaXDU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWQjIXhl3eSCmeVZKMT6JHh0YX/1ay924FoKu0tq8W4WLxIw4G
	0nnwz+1OXW1xx6sbghRSKRFp5dvCgAvUYIjIzNY+sYPg7Ibxpiuycydn3k0BI/+ZW3w=
X-Gm-Gg: ASbGncshUq2b1pDIP3FMcMonqkW4j7RdFdy+uvt7Ty6ygeMQFdh0NqyTjfvrCt4Iyfg
	uTg3XGtGCUDWqA9zPKLH0cBsOVBnGMa1oZF12xFMhg94b0FXIu5FweNWLDz+2rgi0Td6exNB/8a
	SfWooZI+oluXxz5uJv8fvpW25Awuq6SSoKrA4ZohiLBWICks0A72G0Nk06MAHpIHZ3PL2dQZIYk
	y8gcvEO1WD5H1vLCBtviB2hNSgX5EIfHEyRv0ZMfqDYZiQJf1W8nRWg4VyVahkyEUwhODWhYwUZ
	s1tGf/gLXK8PYtd2y9oRg4aniZYNDAkK39vaOEt/8ec2ViuKLjnU60aV2NKbpkraPKqr5kXmPkp
	wwXQLeBspBvvhd3UD4e4n4DwlHJpLSoy7c8ExIPrBRWK4vg==
X-Google-Smtp-Source: AGHT+IFF8VEo1uPvNaAIFv8C/+fiPXouMqAeY9Jx+FQMbKLtAKcRvd4Ch7pGF/LiqKMh1EOfkolHEw==
X-Received: by 2002:a05:6a00:148e:b0:771:f4d4:24fa with SMTP id d2e1a72fcca58-771f4d4290bmr21272864b3a.18.1756478470351;
        Fri, 29 Aug 2025 07:41:10 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1f86sm2560999b3a.72.2025.08.29.07.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 07:41:10 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 29 Aug 2025 07:41:03 -0700
Subject: [PATCH v5 2/9] drivers/perf: riscv: Add raw event v2 support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-pmu_event_info-v5-2-9dca26139a33@rivosinc.com>
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

SBI v3.0 introduced a new raw event type that allows wider
mhpmeventX width to be programmed via CFG_MATCH.

Use the raw event v2 if SBI v3.0 is available.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h |  4 ++++
 drivers/perf/riscv_pmu_sbi.c | 18 +++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 341e74238aa0..b0c41ef56968 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -161,7 +161,10 @@ struct riscv_pmu_snapshot_data {
 
 #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
 #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
+/* SBI v3.0 allows extended hpmeventX width value */
+#define RISCV_PMU_RAW_EVENT_V2_MASK GENMASK_ULL(55, 0)
 #define RISCV_PMU_RAW_EVENT_IDX 0x20000
+#define RISCV_PMU_RAW_EVENT_V2_IDX 0x30000
 #define RISCV_PLAT_FW_EVENT	0xFFFF
 
 /** General pmu event codes specified in SBI PMU extension */
@@ -219,6 +222,7 @@ enum sbi_pmu_event_type {
 	SBI_PMU_EVENT_TYPE_HW = 0x0,
 	SBI_PMU_EVENT_TYPE_CACHE = 0x1,
 	SBI_PMU_EVENT_TYPE_RAW = 0x2,
+	SBI_PMU_EVENT_TYPE_RAW_V2 = 0x3,
 	SBI_PMU_EVENT_TYPE_FW = 0xf,
 };
 
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index cfd6946fca42..7e984ab717c6 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -59,7 +59,7 @@ asm volatile(ALTERNATIVE(						\
 #define PERF_EVENT_FLAG_USER_ACCESS	BIT(SYSCTL_USER_ACCESS)
 #define PERF_EVENT_FLAG_LEGACY		BIT(SYSCTL_LEGACY)
 
-PMU_FORMAT_ATTR(event, "config:0-47");
+PMU_FORMAT_ATTR(event, "config:0-55");
 PMU_FORMAT_ATTR(firmware, "config:62-63");
 
 static bool sbi_v2_available;
@@ -527,8 +527,10 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 		break;
 	case PERF_TYPE_RAW:
 		/*
-		 * As per SBI specification, the upper 16 bits must be unused
-		 * for a hardware raw event.
+		 * As per SBI v0.3 specification,
+		 *  -- the upper 16 bits must be unused for a hardware raw event.
+		 * As per SBI v2.0 specification,
+		 *  -- the upper 8 bits must be unused for a hardware raw event.
 		 * Bits 63:62 are used to distinguish between raw events
 		 * 00 - Hardware raw event
 		 * 10 - SBI firmware events
@@ -537,8 +539,14 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 
 		switch (config >> 62) {
 		case 0:
-			/* Return error any bits [48-63] is set  as it is not allowed by the spec */
-			if (!(config & ~RISCV_PMU_RAW_EVENT_MASK)) {
+			if (sbi_v3_available) {
+			/* Return error if any bits [56-63] is set  as it is not allowed by the spec */
+				if (!(config & ~RISCV_PMU_RAW_EVENT_V2_MASK)) {
+					*econfig = config & RISCV_PMU_RAW_EVENT_V2_MASK;
+					ret = RISCV_PMU_RAW_EVENT_V2_IDX;
+				}
+			/* Return error if any bits [48-63] is set  as it is not allowed by the spec */
+			} else if (!(config & ~RISCV_PMU_RAW_EVENT_MASK)) {
 				*econfig = config & RISCV_PMU_RAW_EVENT_MASK;
 				ret = RISCV_PMU_RAW_EVENT_IDX;
 			}

-- 
2.43.0


