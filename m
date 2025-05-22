Return-Path: <kvm+bounces-47400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D3AAC140E
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC72E504799
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B50029ACCE;
	Thu, 22 May 2025 19:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="JTd3WUXO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79453289830
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 19:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747940629; cv=none; b=iwN7I7Z81l2IIaXNgXva4B0m1pqk1iY1AqsZqBtPVP9oUYGUGh19ARlCCTRLoxUoHJYJjyjTKNZVwbHcQKYjTz+Cbj/8+pSLJJ/er8lVLL8vTkNY4JL7SMPe6SbHeCbetY9XhxciaJnIB/OaQUklUsEIsVGvJETnvLYKCBB/8p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747940629; c=relaxed/simple;
	bh=yOk4Au5mSZlqyc+VJN4Q60m39cr1WKJMLznBn6OTtgI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aSkuDJF/Z6/nL6csVHMT8T6VkDRrpTURO+9KuSQN4D5gye+8mr1GZ8+Ay2B+Cb3C06E1W/OepPdaQ8pLgucqLlTLksmLzvPgclG7z4OeerM+nJN7ffsalfDoNtajMbST4/A+U5G2LrfT3+3FXs2ni2/Jp5be/hW919YKFI0Fm2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=JTd3WUXO; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-231e331baceso66978795ad.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 12:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747940627; x=1748545427; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LdMt+/71IZVg41NURvd5gzpotrZUIy+pYhJIn00Ob54=;
        b=JTd3WUXOtP502Po+/2hwr3IbPmS3Dr1LbgwRIQcHeQhMc6w02JYtDBpcDwnrQ/2OFi
         fb/zZBEKPyp4zL80YDYutfDQWrzUsiavXOxztSCELRK0Vc3HQ8hn9TkPT3fRddBHmjXU
         +ubgkwSxogMXnEcDpCM/qnCnyGll8wNIcK0KHHuKLgYVJ37886xYULROuflGrx928W7a
         UWX96e8sZwUEeL9e1apBNV81MDyddJbNI0qlF9zNsl9H/YgE5eMPYLfnYOzPnh3aNebD
         XNhQLSFCwMTnvW/cX9JHPP5MJsRKO3MGVtyILnI+CxWChHQZA/9y0bwNPI8FoPQOl7Ky
         psiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747940627; x=1748545427;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LdMt+/71IZVg41NURvd5gzpotrZUIy+pYhJIn00Ob54=;
        b=mn376sz4NmexUgiZZS7f+01T7UEAVOS/w/uKqIUBQuhGjvCAkTTHjQCD+WuT2Yln62
         m3THinPZbf12o+Lrd1bApIpnCuJNBLGok1dhwqFHPWv79OEFagi+CZkmcpSbK+VTHOVL
         f/U/Nq2gy6TiPsFMxjq7kzQelABJyXmzVHEk1qmmreOf6gtDBf+tQ9QMIuGIiAxm4psI
         w8S9d8jyZk+0K6kA5PhpDIOBAjupBvpTr1BZ21avarDTOvUks1j7Fm8lNnodhFSUPDti
         XzCzww/zy6lig/1j9JXjvmk1XFurBj66/gadTBwomF1OdCrSFBC0OP5oJJMjCowU5F2A
         o/JQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVC4tkubU1dpKN6kSTezXnerp+2q/P/aq7RJGkyewgDrBv2uVux49u3jOLaiArcJ/vjj0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr4h7uHLGWiPqmEUTVuPThDYk1NE+5kPObblv+oeyZnNS3zD/I
	XNkfSHVAu+zPc5JdRW+4Y1B54qXWY0j43c0sIEL/JlBu7QOHZNxlRIuiDKRCOfFiUX8=
X-Gm-Gg: ASbGncvuvMXbCLRflDBKvKgDIBSpmwyCwbFKRmcbyHHzc8T+LZ2AnihxYw7ofITKh5t
	zeEHNU8up6dpL0Kl2aJBUGQdZh43otUI14H5vO+aacZi05FdBZdex8PKprI0HfBPSejVRoeDI7M
	VA32JHL69FJJQvCy9eZbXbh8UhghSZkaiXvf96MNFmeKCPZturteGMSTe2FpvGt5wESiPSRjsP9
	GHfk2fKL0i2afOreHVeyLuLD3qrfZWeubg27DHNt/RqRij+c4Yk+ZojR030aj09FKOXLIg25At+
	/NeEZJCJfvEmvFn25daCxrmdTQpD3Xazy6gLMS4mVToKfA9l8MtEpGgtS+UMKVt/
X-Google-Smtp-Source: AGHT+IFfCV//qxOe2okhTwLGpNoq8DsTJkacWkNUL4qxPXo2ylZ1GEBeSAkJ2y8sxhW9UlvW9cu03w==
X-Received: by 2002:a17:903:124b:b0:231:fc6a:9639 with SMTP id d9443c01a7336-233f23cbf73mr1605975ad.27.1747940626613;
        Thu, 22 May 2025 12:03:46 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9736esm111879155ad.149.2025.05.22.12.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 12:03:46 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 12:03:36 -0700
Subject: [PATCH v3 2/9] drivers/perf: riscv: Add raw event v2 support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-pmu_event_info-v3-2-f7bba7fd9cfe@rivosinc.com>
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

SBI v3.0 introduced a new raw event type that allows wider
mhpmeventX width to be programmed via CFG_MATCH.

Use the raw event v2 if SBI v3.0 is available.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h |  4 ++++
 drivers/perf/riscv_pmu_sbi.c | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 3d250824178b..6ce385a3a7bb 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -160,7 +160,10 @@ struct riscv_pmu_snapshot_data {
 
 #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
 #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
+/* SBI v3.0 allows extended hpmeventX width value */
+#define RISCV_PMU_RAW_EVENT_V2_MASK GENMASK_ULL(55, 0)
 #define RISCV_PMU_RAW_EVENT_IDX 0x20000
+#define RISCV_PMU_RAW_EVENT_V2_IDX 0x30000
 #define RISCV_PLAT_FW_EVENT	0xFFFF
 
 /** General pmu event codes specified in SBI PMU extension */
@@ -218,6 +221,7 @@ enum sbi_pmu_event_type {
 	SBI_PMU_EVENT_TYPE_HW = 0x0,
 	SBI_PMU_EVENT_TYPE_CACHE = 0x1,
 	SBI_PMU_EVENT_TYPE_RAW = 0x2,
+	SBI_PMU_EVENT_TYPE_RAW_V2 = 0x3,
 	SBI_PMU_EVENT_TYPE_FW = 0xf,
 };
 
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index cfd6946fca42..273ed70098a3 100644
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
+		 * As per SBI v3.0 specification,
+		 *  -- the upper 8 bits must be unused for a hardware raw event.
 		 * Bits 63:62 are used to distinguish between raw events
 		 * 00 - Hardware raw event
 		 * 10 - SBI firmware events
@@ -537,8 +539,14 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 
 		switch (config >> 62) {
 		case 0:
+			if (sbi_v3_available) {
+			/* Return error any bits [56-63] is set  as it is not allowed by the spec */
+				if (!(config & ~RISCV_PMU_RAW_EVENT_V2_MASK)) {
+					*econfig = config & RISCV_PMU_RAW_EVENT_V2_MASK;
+					ret = RISCV_PMU_RAW_EVENT_V2_IDX;
+				}
 			/* Return error any bits [48-63] is set  as it is not allowed by the spec */
-			if (!(config & ~RISCV_PMU_RAW_EVENT_MASK)) {
+			} else if (!(config & ~RISCV_PMU_RAW_EVENT_MASK)) {
 				*econfig = config & RISCV_PMU_RAW_EVENT_MASK;
 				ret = RISCV_PMU_RAW_EVENT_IDX;
 			}

-- 
2.43.0


