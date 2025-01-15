Return-Path: <kvm+bounces-35586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA890A12AE4
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:31:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39C0A166966
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2421D79B1;
	Wed, 15 Jan 2025 18:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="LHs7oues"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693101D63C5
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736965860; cv=none; b=qSdNbqqaKcOyNdkejvnM9cR23Ke1NIEvfxxPV3sm+vny3F74QzrIRCKauCjBQuVVBO92jtLDWjv7WWRDYtzYNjNitvaof5gYycPEPHJmhjV5shmx6lxg+qVGV85KOHGjB3JWpFFuaADcI2kfVCMifcPnakMKeAbdmYABMZVwjsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736965860; c=relaxed/simple;
	bh=C2yg3QgtuxibTBRy1VBsgb98ZP1o7dJeXGlHHQuTfM8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=I5YcUGzBetbYDFr5h1QFUAkhyAE1w4EEyO436HdVn1dk73S/2QnexiUZf1g5mc3ropkMj/7u3VJvFFiCjxCQCuqKIwpBjLLwmDZMNre6sWXVTCx1CcdUJNzc7sKtE/W4V1pRnykhrNDbD3u0eSmJ98hXEm4VtfkVJkJOVbyRYrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=LHs7oues; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2167141dfa1so1961245ad.1
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736965858; x=1737570658; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nTd9Qo5vidtOLE+cxHwuaQqNzwk6goJIP9mJXkel4TI=;
        b=LHs7ouesPdcBD/sHmOaAIgtbX2sEhwhBDScp3XPSeRssl6YoRva4njcBwMEoFySyPZ
         lth5Ocg8Fihq6ncLEatWf+Bhf7foPy3tdSqiG1NbjB1h9+F9HGLMpNvfPgWrxqr1FQ5a
         ldmCOCi6yjymuzY//9GQT527aZvCE3/yIJL6PYE53FYNz0RUqXoUwA7SJG55ghpopSUk
         mgOPU5y9iPRm+rxQlVhVvPk0qnV8vTKzF4Jw8ENyyBIoje0m4af6SNRF8hGwLsNX2eLk
         UPyeCPub0grs8IfPTYm7H5PWKeR2JN0W+ityrjy2GZR8DFUDF394vwDDawzBjXCt8c6A
         q8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736965858; x=1737570658;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nTd9Qo5vidtOLE+cxHwuaQqNzwk6goJIP9mJXkel4TI=;
        b=moMP8YibHGrFWRl1YvAYGCayVolEGJqKZuH68vERz03zqpFqMoh3eTjKRpuVa3SIQf
         cYkyHKPgFtDyBlqvbBWCb06Z4yvweXskXUD7ZyjFW2gXt0iHsnjPhTwz7fKdN7ga3NQ5
         e+LaXpMe5soyj8MMDjFgkhrATcrnKYWuEpETQkhqgOUn8A2uY0FYQWlRjIEoezToV2CG
         iQy0fery1JSoZ/M9Ht2ULSkKAyiwabzLggP5vJ/8pGcujYACy72wO0/OClLgJ7aIV5jA
         UGtkjzhN/gAJxkdgKRCoKOnMX7sFSxWged4uEodiq1P9pEZbp4Tsf+IzfEWSSpzPJou0
         Z7Lg==
X-Forwarded-Encrypted: i=1; AJvYcCVN+aokehA9+0oZtAKUVhL64nyQYZ2Q5YiyPiFxkvpHAmRi5TG+krEAEe0SG211toC5RtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzukE0Q7ljcdBycjHyrxABfG3SjgKk3aZn7oItgDSaRDyO1iCPK
	iQlNFGWvSqCWdvRpezecGUYDQ6jSECwkCaejzGNpF4ZMFUdAVjks50zGEW5mbI4=
X-Gm-Gg: ASbGncudoxdidHerRfGWsunRCqnB36eG9oonBew2SpJLx88gSnCU1+YHw/+Ql3GxcTv
	8fNpyOgxGuCNwEuqxNNKm1w+P1qEGae+A5vTnW0tgf2Fq9O/2B93yhF2PbHnDolPUss4szf+tol
	Q1bgY8NZEKM5uEhKsTnTDsnqeDLikFBVn0S+ONzE4aYOq4vJBZUj27XZ+K28gULoD3zRhIoqdlm
	ckZVi375ieVfOvEZ06eH2LRg5aJdUbRyUBsMVJTFo4F7V8P+JggdQUTwugJBF04uUczIw==
X-Google-Smtp-Source: AGHT+IHHO3B1HJhEuywvwBIX7b7bfSC/4ve6r1ZbOzw3ZYVhbL87vWT2YRpjRvKHUMwV10zBAIgK0g==
X-Received: by 2002:a17:903:2291:b0:215:58be:334e with SMTP id d9443c01a7336-21bf0bb89cemr59154695ad.10.1736965857674;
        Wed, 15 Jan 2025 10:30:57 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219f0dsm85333195ad.139.2025.01.15.10.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 10:30:57 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 15 Jan 2025 10:30:42 -0800
Subject: [PATCH v2 2/9] drivers/perf: riscv: Add raw event v2 support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250115-pmu_event_info-v2-2-84815b70383b@rivosinc.com>
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
index 170aa93106b9..5d5b399b3e77 100644
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
2.34.1


