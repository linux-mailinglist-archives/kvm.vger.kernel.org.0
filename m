Return-Path: <kvm+bounces-53057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C38A4B0D01D
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C0883B3BC9
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 03:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DF3328C5C9;
	Tue, 22 Jul 2025 03:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="OGALig4b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E592028C02A
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154129; cv=none; b=giAqRGQwxW0xPSJVaCuWCQ7SYVhnWUprmmtxSP2h2D4r9yfA/rshoSNPz2FAP9RVfHnDRxS3s5pm7lPIsBszWcGkNY7lL5zRwi/ElI3TxV8Sep58ezSOyg0HWi1Cuknfak2psWIQZ6NVAHrnaN3PkFzdJMP42NguVL/fIIdzU2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154129; c=relaxed/simple;
	bh=0VfGT/sW+BOyeAlGwTbRc/p0DZepzw2VTroKK4qkIkc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ad8yux09Ao0fvztERkV/a3E/9SPmoqRHfLqn4XkKzNHn2RmU/pZK4PM/LDnSgwnrQZR2jSGrUY6eQfwCrzo5Y6X5RnjzPGpgzp/W+oGxbarzkRri+lpVsp0yDHwEnKLTSXSzQhog/JpxVJjhWmfkbip5k5hhppzZm1Ou+zS1+UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=OGALig4b; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-748e81d37a7so3277510b3a.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753154127; x=1753758927; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oaJ9aiB4PvqQF4lL2czHSQpu5RmdGPHGPdEr5UPHKqo=;
        b=OGALig4bJpTUJC6ZQBcACrAugi10sX0EPX2l8qzY3h8P34AeD3Dj2LZKHnMWABsd08
         ycOgpToxzARhgFCpqkUMWwq7Yc83CQBl2rQ6Y3YbUuBc/k2b6s9d8uwK+Q0UlV4e0RIp
         xnMT9fMoR83EIyMWE91CLZPvzdwO2UVmy786+tfCYJa0mQO2splkfctewD3Kd3vWQ7QF
         EH7WEXA1vSxJRwIy+T0GphnBypToLjr+EIQkDKkfN3yuny8J/8dPq61AlQ8X+KkN/FDM
         UgaT3ikKz1J8Pk4XCECNFZxRn+YvSnR33DK6e4dXutY2GCXTAEvASUpgofh8Is1xi0Fl
         yxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753154127; x=1753758927;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oaJ9aiB4PvqQF4lL2czHSQpu5RmdGPHGPdEr5UPHKqo=;
        b=Sby9HugSFIhup75DVSv72eDftA3HWA2NHgcJAnTcYi+rKVZPzSGb07CHb643d3cEPp
         9zNwK+LHB+DEolhDxwAx0jMxTAhdizumUw3/a1ae4eONZuxrGe6ReQ4WGj10y1QOE10J
         W7IpELgO1Nwodj4LL6wQMP+H30OV57frig1bvOgxbFaNNlVG893sVBaF9KR5B2VW9FUS
         FUIjbxHNWzf5Mgmau9O1DhCWB+1IuHpp6kfm/D4mVy4lQTkNuSQfqJsarQkhRX68j8So
         QwBXo9TIQjT7o5q9inIAX/03rNMuhfPm1DYStXRXtwxDdQM8RBTQABDBFpPm34JEbSd4
         GTJw==
X-Forwarded-Encrypted: i=1; AJvYcCUNJNaBAWKgU/Z9vbIZLKto+rCxBd63nCBzxQ5bEfpLJ+rHjSIN03s8lizPK5LwwCdq8hc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI9RFjddgchQFjbaTnt7hsc4wHcR7D2icAdPD/Ih1L5DfOXmUm
	yT5G+djv7uXBmDGsiFq1+E/nvALdUQ/KSOmic8AotJ3X2leeviF8jex5FYFP4hRG66I=
X-Gm-Gg: ASbGnctaHaSINGKnfaFYrjeyT0XKArKflGw+P1s+UbX/GdBuDTDEbZhxW9HA0EBucol
	90CylYWtL5wQt7Uo6B09LtWFTEgy67ELmqyf1xkOh35bMHppIc8gHkmdziLGcHQ+BaDagR9uw++
	2xdEWw9MNuY6SrKaovNVjcrmuYfi7XH88e+eFPwHcqkXT2cGZrJEnM6STgzUz7TzDEiDgZ0rb2M
	dZgX2o+k2Gmh849Ok83rS0FXT/u87x1CqIpA8l0t7NlC3fxWWOGyImEXknhUEL68YXOiJhoYPtY
	dq4N7fqC42w0ovPahKf9Swi1W06ll2rTUIfcFhMCYzv0eiFuO7Mq30vUe05QZg/FoE4GgBbPN5N
	eQK4d6AEJhH29KLw6HlVx4OgZMSDXb77GgZg=
X-Google-Smtp-Source: AGHT+IGF6Po1DKvJeXFzJdS6UmW3bPEOUN9x/0ZpQhlGwgu/vmfAIzOtjATRI7XYcQq7ZH2Dfk1C/g==
X-Received: by 2002:a05:6a21:a81:b0:1f5:8e94:2e81 with SMTP id adf61e73a8af0-2391c92a648mr23761386637.9.1753154127264;
        Mon, 21 Jul 2025 20:15:27 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2feac065sm6027612a12.33.2025.07.21.20.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 20:15:26 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 21 Jul 2025 20:15:18 -0700
Subject: [PATCH v4 2/9] drivers/perf: riscv: Add raw event v2 support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-pmu_event_info-v4-2-ac76758a4269@rivosinc.com>
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

SBI v3.0 introduced a new raw event type that allows wider
mhpmeventX width to be programmed via CFG_MATCH.

Use the raw event v2 if SBI v3.0 is available.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h |  4 ++++
 drivers/perf/riscv_pmu_sbi.c | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

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
index cfd6946fca42..7331808b1192 100644
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


