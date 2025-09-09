Return-Path: <kvm+bounces-57056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D047CB4A2DD
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C46CB1BC699F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485653081C3;
	Tue,  9 Sep 2025 07:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="TLkVAUIi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F18D303CBD
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 07:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757401410; cv=none; b=cWd4BqI9WPBNJX/LnYkWGiZIn4/UMDeQcOWA1P1LslbOYNwfUkLnWDJWMHQueZeoKMqe/oRnKKImrQLoR1D/D/Upvx0aZxV2x0d9HunAinOQrVuhjsHMYczJku4axMwAjKZd4NcdSEYqDrDzk12x7BF0UCUCDSAEP1qaBcnX7jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757401410; c=relaxed/simple;
	bh=GrmWjsHjJE1tKkgqTBfGMNOmAW/o67tHqaBrQuxr/k0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nVj3HPTSf8wsgo4dEptFvxh7kTw1KwUKzXAKpz1RHeXR28D6kizi5v69qXTbngMukQyJTjhqTM/I9Dv3A2TxO6lS9VGme4lQ6Pbg3bT0RewwAFCcb5tXeinma62ZbsCDAyYQUIe4aGUvW0U5n7LpOFKTw/W7H4uqU1R5Y+CM/xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=TLkVAUIi; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-76e4f2e4c40so4095457b3a.2
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 00:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1757401407; x=1758006207; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nnmZ8NkUlTZK5sUaPCJm86+BW+WwmmyvWnWnb0ftr9I=;
        b=TLkVAUIi1+x9BEXNzSdEt8kYgATGJ+86iH46LXHJ/DmRkTvpCoU145FLhEXGoYjKOA
         /ocUCzgyuKKSlXyeNtlvqj8MpaiTXmWSW7IQEyjd0pyGmXEWaX3edLyqBkIuVPy22Hev
         Iwa1JdQej0g3M6c2DUngCkvQfJQF5xMLKZW+/MHEqGzHALIHuFbK/NOYPskE0LueRsBR
         I18+zNcTGQtr4vMIEuFQQXWr76pTAiYLS9U9/yCdDhU8nFWA13DD9ga3i9EEWR8cf8JY
         yFwdiK51uoAEFeQXwpGrYc/sz9AHVA8JfX4Hot1M+6f+5MoNRtOIFYve70fdyclk8Wjj
         0b+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757401407; x=1758006207;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nnmZ8NkUlTZK5sUaPCJm86+BW+WwmmyvWnWnb0ftr9I=;
        b=K8YjVDaJz5Dfdh2Kxc0Br1TajcKoGXpKqcmcKVQLSxmbvY3VX5HiaBaJzGsalbvBj5
         laIt/1cvNAZApbyN/tI/vD8FsjqvHo/Km1/r5+MzgfMlM2ENE6AC7GtoYimYc3Jqob2W
         NPp0gMMK8744Jcxd39HqFWHlkqJP6z71hVTl+oqvVdvQvMCUV+kz5mXbeODhZX66DfBm
         6Npe0Pok7GW6XzkdcVWpkHlZBjr14YwsQ1TNnBR2rtfPpkhKG2mvGwmWTSnlNNy103F+
         iJD0Pob1zO/IJm8TAPJMY1DoN9G50LKwqrsB8/eDGd4ys37ecXNYZbMJQigxAjjrTe0m
         xjdg==
X-Forwarded-Encrypted: i=1; AJvYcCU4fg64qwr4Gy9mqLHvr33+hhwwID7VQcG5OhoUctPYkGxhoeM7YUdu4DkS/iyPZPvQBfY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwW7lFjedwK+B1ehPr7xxVSVjy2EagIL0nQFJ9sXurqutPgWuGa
	YQKrHcGhhg5WLJvpQI0huF7YfsjkfHYS1CDdFS6uB0xYKJgzDF16+XeZCNVTdBokqZ8=
X-Gm-Gg: ASbGncs+S8jrYd+FUmwIMEWuWTRroe9iwH5jZMHDu0yUtJU3YqSSwQU2zZdCFPyJnUU
	ebA/bvxEH6lNSwQgmHgvetE6j/hidEBVW7zuGB8v4qN1EYS+iPeB56h9jcheq0NqhhNMCCwF2It
	QoqhdMgpUw++aa1H8i2/kfYYNSpSs9ilUrc0P6O0xgwXsBDFsWP1EEynsE5G3UFyuEJGTTzW37u
	N+Fb/XitHlYa2Dly1F6D9mEMMl3Ujei5BLObfIzUA56bY0+zMCJfV6yQ528KtERcSqIGuFGikfg
	3IU2cdry7klNfaSFP9XoQmv5p4jdlZG27ke8rK2H40JmHwMDtMEolFhm3xbK65gBQDTkj3HiY9h
	eS2qiaSFEHVnZjYXcoBImXLwDEMwWnQgw3+0=
X-Google-Smtp-Source: AGHT+IFiF52xK3MSeJlrfdLEf2QXk0FrME34XTCcy1LZr3L0VGDJ3dsrdXofGTbO3mimC4eb9yJmOw==
X-Received: by 2002:a05:6a00:1793:b0:76e:99fc:db8d with SMTP id d2e1a72fcca58-7742dd1252emr12562314b3a.3.1757401406596;
        Tue, 09 Sep 2025 00:03:26 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662c7158sm1025535b3a.72.2025.09.09.00.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 00:03:26 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 09 Sep 2025 00:03:21 -0700
Subject: [PATCH v6 2/8] drivers/perf: riscv: Add raw event v2 support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-pmu_event_info-v6-2-d8f80cacb884@rivosinc.com>
References: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
In-Reply-To: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
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
 drivers/perf/riscv_pmu_sbi.c | 16 +++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

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
index cfd6946fca42..3644bed4c8ab 100644
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
@@ -537,8 +539,12 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 
 		switch (config >> 62) {
 		case 0:
-			/* Return error any bits [48-63] is set  as it is not allowed by the spec */
-			if (!(config & ~RISCV_PMU_RAW_EVENT_MASK)) {
+			if (sbi_v3_available) {
+				if (!(config & ~RISCV_PMU_RAW_EVENT_V2_MASK)) {
+					*econfig = config & RISCV_PMU_RAW_EVENT_V2_MASK;
+					ret = RISCV_PMU_RAW_EVENT_V2_IDX;
+				}
+			} else if (!(config & ~RISCV_PMU_RAW_EVENT_MASK)) {
 				*econfig = config & RISCV_PMU_RAW_EVENT_MASK;
 				ret = RISCV_PMU_RAW_EVENT_IDX;
 			}

-- 
2.43.0


