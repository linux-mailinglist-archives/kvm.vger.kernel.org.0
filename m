Return-Path: <kvm+bounces-32095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71CD29D2F78
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 21:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06D011F23928
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 20:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D580C1D6DA4;
	Tue, 19 Nov 2024 20:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="szgdI7d1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B051D318A
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 20:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732048255; cv=none; b=lumPKB5lvzbjxtOZjQr66X9lbTEVhCd42qBIfguCINIPWrCCyZA29keJ84F4Qyx2UBQixFIJOPQO+RLNbRbwmrqTSTZD9uDcZQPl3ZHA11948l1syzXMY5SOr+bqXCRFNq5jrA7oebaJmCk9TsI3CuFzeIBu/F/jsDfYVbZZTJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732048255; c=relaxed/simple;
	bh=d2OWDcgMWNTgpuTUqhaseMx00dJ1C9AXSYm/wfcfCPo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pjFBd8K/jusU5u0J2OXNnjHv+FRwmG8fD/nQz8vwi5ugPAhbYlRRVPDvYttnbpvRg+r2Bfwx+XqOR1gcy/M9zE3Nk2kJw07LyWlII+fHC9ZeiTIrD9gGenlW5QYYDgcZ8OEB93ciKINlbvQKvnsMhuLxToVt7tCbHwDGyx816WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=szgdI7d1; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7ee020ec76dso1086633a12.3
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 12:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732048253; x=1732653053; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FB/tddqfX+5D+NwPYtCZBvpcbtznximYassXddDySaI=;
        b=szgdI7d1MF+HBQFcrcrbz1J3B3biwR9HJnw0k2Y6oV3Uj+pIDW6AYkRyZdHFm3hGAY
         W/WfQ5obz8cYmJ5U3k/1axsYPvXa61VOyp633kj0xGDpA03cuvP4XO48jkH0Wl4bk3O3
         KPq8dohzNoWE/cYQDwizzAPXqAEbraOWUKkbObY8KNapPu+7Wa5d0bcAnHP0LdWh3FG4
         /fDgNBQ593gcBVsvloQW6oBU2HORVocS+EVoj9L60xX/yplQZ2gZhthZZtgOD9vuKowM
         TrpiE2aGQlPVuXwu3Stjg9X+9y0mnLj1Ei6SbdS1AJJgSeZ196xBk+Z8gnBpJQF6/wai
         43cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732048253; x=1732653053;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FB/tddqfX+5D+NwPYtCZBvpcbtznximYassXddDySaI=;
        b=F3cDv2YIMWVLBFdJllpUHxQFt52wIlvxaDdnIrohWB2DUx3Knjfib65Xy1miV2Eza0
         g37aAiF3QhAYUpoFUh3iodC+rv7cvho2fYls1/i1iZhLpdbUa/r+ow0zHLBaWtZXL6CD
         u4qIsLQ1HwndjRL9ucDnJ3GFzmvZtOzN4br/n7cjfwTid7ZPX4MPH8sRwigKadgTMI97
         hb42iKoqVFnFuq7WkEJfIWcGnGKZmuH9mCkJYFHH3WIqoC3cepVCDtb/0CDd0DH8IaKx
         i7TFF78NqG3Chk0jjd+ZLbJ3rAO3Hwz7Q+sKKpHpsVt/nC0hfLr9RGkSb8jdsO5lG4Uj
         h36A==
X-Forwarded-Encrypted: i=1; AJvYcCVAcamv/JfhXmA0S7FdeDSDSfbKgCGyD9LMi19JRPDm3GlHFc63ftfo8N38U+3zPrT1rak=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNiE6Y7HVZBtD6qaHifJczt+mR7o7qGH35c1Flstfk9Zwh1A74
	iSLnF+bJgbvYAkCWOqZCHNOiLTD+pSpvL6Zw2dXUsHRUQ92OkknCr9zocU7LJow=
X-Google-Smtp-Source: AGHT+IGG3BOEKBQHByHPNxLGRscpaUzNEj7RMHYMCOiguADUgT/ZA6zCcmpHgOYphyvS5L29CLFFRQ==
X-Received: by 2002:a05:6a21:3287:b0:1d8:a29b:8f6f with SMTP id adf61e73a8af0-1ddae4e24bbmr613518637.16.1732048251371;
        Tue, 19 Nov 2024 12:30:51 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f34f2fsm79001315ad.159.2024.11.19.12.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 12:30:51 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 19 Nov 2024 12:29:50 -0800
Subject: [PATCH 2/8] drivers/perf: riscv: Fix Platform firmware event data
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241119-pmu_event_info-v1-2-a4f9691421f8@rivosinc.com>
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

Platform firmware event data field is allowed to be 62 bits for
Linux as uppper most two bits are reserved to indicate SBI fw or
platform specific firmware events.
However, the event data field is masked as per the hardware raw
event mask which is not correct.

Fix the platform firmware event data field with proper mask.

Fixes: f0c9363db2dd ("perf/riscv-sbi: Add platform specific firmware event handling")

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h |  1 +
 drivers/perf/riscv_pmu_sbi.c | 12 +++++-------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 98f631b051db..9be38b05f4ad 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -158,6 +158,7 @@ struct riscv_pmu_snapshot_data {
 };
 
 #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
+#define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
 #define RISCV_PMU_RAW_EVENT_IDX 0x20000
 #define RISCV_PLAT_FW_EVENT	0xFFFF
 
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index cb98efa9b106..50cbdbf66bb7 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -508,7 +508,6 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 {
 	u32 type = event->attr.type;
 	u64 config = event->attr.config;
-	u64 raw_config_val;
 	int ret;
 
 	/*
@@ -529,21 +528,20 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 	case PERF_TYPE_RAW:
 		/*
 		 * As per SBI specification, the upper 16 bits must be unused
-		 * for a raw event.
+		 * for a hardware raw event.
 		 * Bits 63:62 are used to distinguish between raw events
 		 * 00 - Hardware raw event
 		 * 10 - SBI firmware events
 		 * 11 - Risc-V platform specific firmware event
 		 */
-		raw_config_val = config & RISCV_PMU_RAW_EVENT_MASK;
+
 		switch (config >> 62) {
 		case 0:
 			ret = RISCV_PMU_RAW_EVENT_IDX;
-			*econfig = raw_config_val;
+			*econfig = config & RISCV_PMU_RAW_EVENT_MASK;
 			break;
 		case 2:
-			ret = (raw_config_val & 0xFFFF) |
-				(SBI_PMU_EVENT_TYPE_FW << 16);
+			ret = (config & 0xFFFF) | (SBI_PMU_EVENT_TYPE_FW << 16);
 			break;
 		case 3:
 			/*
@@ -552,7 +550,7 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 			 * Event data - raw event encoding
 			 */
 			ret = SBI_PMU_EVENT_TYPE_FW << 16 | RISCV_PLAT_FW_EVENT;
-			*econfig = raw_config_val;
+			*econfig = config & RISCV_PMU_PLAT_FW_EVENT_MASK;
 			break;
 		}
 		break;

-- 
2.34.1


