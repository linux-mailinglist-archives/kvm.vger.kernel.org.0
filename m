Return-Path: <kvm+bounces-32098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 424BD9D2F7F
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 21:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F9E2B24244
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 20:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B181D8DEA;
	Tue, 19 Nov 2024 20:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="MqBkJpn5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E331D5CDB
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 20:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732048258; cv=none; b=qWiBCia3MGXAS1+DK3+8+ZAgbAeUIULoDAcOnvbapmWEd+NwBdAjR2d+GGgP3YjszRS1e7Pq7ny5ii5vSyOjycqFqTxVkLhbgR6A9E22DzFQTsmzLKDtazlme8ILG7CTxD7RnF7j9fBhWNvMUk8IU2uAAv48j5evUZ6gGYaL/tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732048258; c=relaxed/simple;
	bh=d19CQgPNvBcsQ2Thiefa99k9qqPTIyWGn7bjCj3eHBA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JYLUXSaUwq83QyGnc2bkOE9kZiTyq1kUxCFTSbpySVf7YD66LWykaSzgN4e08NwXCHTpC88jIOksLr+v2hNa4jxq4uKESjeOu2dVRokMHP1fNZo/l0y4JIt0o3+y4kdL4521e/5bKlYtQhZYGMwouRLFdnik1QC/Y+xmX+t/CD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=MqBkJpn5; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-211fd6a0a9cso12460015ad.3
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 12:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732048255; x=1732653055; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EvI6ELyRBC+Fyndrrci/LAt1a0lV7o2VMX1QjdFEcW8=;
        b=MqBkJpn5QNDHy+wljOqirYIG88ONCqUBdaWFNubLra3+LX9NGJ3BFxDhCLNBHYiYNC
         dKCxhzr6K8ZPP27rg4Zp+ufOqjZ1GspmJZpBbXAeH/8Vm8CVB8KZ/W2h9MZF0fwPEtBt
         wn5jQ2h8U83akh4LbkKVLmXgmG3A5cP8M+UdO12HOH0+vws8Q/2FiO4LqefcOfL3l4mw
         kprpnuutUb3ZHdzxRt3utuyjvpsAU7jrYfH4VWp5EFfHQpPG/E2GWpHTqDulqoLiKLDc
         DrtMOmL+KEo0xvVdJteoGLGoTSsM5b1z2dtoYtGGjZDs3SBooH6bfQSp6ABVBwcdbSwv
         0E5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732048255; x=1732653055;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EvI6ELyRBC+Fyndrrci/LAt1a0lV7o2VMX1QjdFEcW8=;
        b=Ok10I5+2hUTBnqkJWO54TsrJcoXQ5dr9RQVmq5zNYJtZ/wVRFYAI34q+Em1gfB5FSF
         9LDwQBzcWtxlY6MQqJJnuYWwn7WpefPLpd9CbeUIVZNFXogkGwL+qxThgGKObYWSNjcK
         qnRPOI2sz92bC0+dv/WeD3BIfjNGMzPTiOOMz69efvPYT11HRR72gD3kDvrzVIfaYmTM
         DSZ5K/3CUbXIzJ7k6bTlctfVHleXRHcEB8sWM1BHM2Uvv9CVat8RE6sOcqLJpw6rcVPe
         3J8WYYwo1iTKZV3YH2nMmXsOR2sxZUncFvk9TXBQ3o+zhFtHptCGPx9/Q3nEx6llMULV
         +VmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVklE2luo3c8W+w28Iko10E8+8ajsPTNHJKQcnjmhCSkpe8nB4HJSw+Xbd+LP5e5OohPBY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/qcfyUdUzrBeA0l5VOJqcTYIxrGFXLB7yU00MZxkPjQKqpA1C
	zUAzGZuGuSXFcyskkOzwBNbH59VAV7wKeyctl2lLD9bjYx7Z7yxnV+/eHPc5rak=
X-Google-Smtp-Source: AGHT+IE8OiqtfXItkGe53z5hjcs0b0CjneyIZkfN6utXnoNwtgLN2RoemxkaTVHNqe744fxPZ0nP9g==
X-Received: by 2002:a17:902:d509:b0:212:40e0:9562 with SMTP id d9443c01a7336-2126a3b4478mr2002835ad.25.1732048255602;
        Tue, 19 Nov 2024 12:30:55 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f34f2fsm79001315ad.159.2024.11.19.12.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 12:30:55 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 19 Nov 2024 12:29:54 -0800
Subject: [PATCH 6/8] drivers/perf: riscv: Export PMU event info function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241119-pmu_event_info-v1-6-a4f9691421f8@rivosinc.com>
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

The event mapping function can be used in event info function to find out
the corresponding SBI PMU event encoding during the get_event_info function
as well. Refactor and export it so that it can be invoked from kvm and
internal driver.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c   | 111 ++++++++++++++++++++++-------------------
 include/linux/perf/riscv_pmu.h |   2 +
 2 files changed, 62 insertions(+), 51 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 2a6527cc9d97..8ddd094c82ad 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -414,6 +414,65 @@ static bool pmu_sbi_ctr_is_fw(int cidx)
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
+				if (econfig)
+					*econfig = config & RISCV_PMU_RAW_EVENT_V2_MASK;
+				ret = RISCV_PMU_RAW_EVENT_V2_IDX;
+			} else {
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
+		}
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(riscv_pmu_get_event_info);
+
 /*
  * Returns the counter width of a programmable counter and number of hardware
  * counters. As we don't support heterogeneous CPUs yet, it is okay to just
@@ -579,7 +638,6 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 {
 	u32 type = event->attr.type;
 	u64 config = event->attr.config;
-	int ret;
 
 	/*
 	 * Ensure we are finished checking standard hardware events for
@@ -587,56 +645,7 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
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
-		switch (config >> 62) {
-		case 0:
-			if (sbi_v3_available) {
-				*econfig = config & RISCV_PMU_RAW_EVENT_V2_MASK;
-				ret = RISCV_PMU_RAW_EVENT_V2_IDX;
-			} else {
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
-		}
-		break;
-	default:
-		ret = -ENOENT;
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
2.34.1


