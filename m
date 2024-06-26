Return-Path: <kvm+bounces-20528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F6C91799C
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 09:25:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BA1D1C23237
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 07:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26EB715F3FB;
	Wed, 26 Jun 2024 07:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="g1wmV/pH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF7715B10D
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 07:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719386661; cv=none; b=gkkKlFW962TAP6LX2Ph3kqdJRfWR9iCeV0JhqlQedIx4XT3lpVGmz5syIio8S+WBBNdSVfebNWrjW/YVZR/Ba+3b5LpZA4u13hhqbqucKdQd8sBVRx0SFZgZZ8voHVUZuO6hgJMIUZA6F46tETzknKIwlqqs5gJMJO1CBI3Agy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719386661; c=relaxed/simple;
	bh=Q6fB+0U1vwNDij8/HH+ONSB+ggEQtVYZcG1us9ReQnY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Nk8M9aShmtcFnAyR4Dm72atlNQE/mcKE1zs487bgG3OwIFlm1F0iIRGTgCREthvKtrd48z4WGllrO/e8LGUN5kxVhWUWIJ2fhZQcKjkA6q3IiZFP4otCdhNJhHsxukG/wVtEZuzcUtxw/tWj1r0nXbxVB0PGJJ2D3oezlGf9luM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=g1wmV/pH; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70677422857so2269410b3a.2
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 00:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1719386659; x=1719991459; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njNBT7xpsrpGcVD9LgzuKuD8VWJ85LTW2hNYGRcpIO8=;
        b=g1wmV/pH4O5LWKvS6hBr7YOkbXJGRiIh5pz2efN5qPfQrlwRjDVvMP+9B0yqgx/YPW
         IiLvqbO305UCLNExCAZj++IAc1fM2foAN+5+54abI4JFu6u3xhK8Ts/A0EibS1naTKLG
         NdSHrHnnRyp3JSIt/guO37fYnS2NwPmU88b7QZCV2Lp5tQ28ChbFLRZjPw/NaAXy9o+Y
         xqPyg8U7aBySoOdn/9EC6p1r0KZjmWkb12h4ngpPLE9nBYRTLhH8tUssM+bFT6uC0Ocn
         XTMdHETYhK4Uk5DHc0dhsQSYPZofnlxISQNBOesdc4PC55UsCpSv3wOy5VDpSBQhO5/e
         KP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719386659; x=1719991459;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=njNBT7xpsrpGcVD9LgzuKuD8VWJ85LTW2hNYGRcpIO8=;
        b=LOlYjm1txmlGOM4kqtVsWRXJaizADhfGDLukmLQvhxa6W0+WOZzznEwvdr53msqILf
         Zp6i8foMN8CmEgNIzeNDo0gCxzft1iVees2Y5Ye1i4rqlOA8Q2n2H/pjrxyyOESWRoQV
         cRLhPsPZu3kqVDfksId76mFCUXic4hNnYRHOAiYm2Ezw/NgaKN/OwIMR10xjOdILH0GZ
         kEBozqnV/3ioHWkUCMK4VALJ03TLokt367kRRthSpTqLSDLRGXz39MDmcx2yqzREnTzQ
         MfLLD2uyJOGv5iZ7JWcpbUoPrr/osrD1vjnRDN/lPPo2xKiszRojH59dAtSKxluJVj5J
         hYIw==
X-Forwarded-Encrypted: i=1; AJvYcCVV48ZvYZn8TJUIthLurz/jfAWp6kuUk9nLTJZ3xsUKnebYk9sssDZ1eG2lXZNZgxDjv16V00I3Cd0w6Sb1tJM8UW+c
X-Gm-Message-State: AOJu0YxuzyQ9D2a7b9Mrqq9V7VaBIbntpze0buUSyZAyMyGkajydi6zW
	wwxJYiYA5GO691ZcxUrRYqADycg8MgxYuu5z6+PfzdUPkhtzqD9+IMticI5kVak=
X-Google-Smtp-Source: AGHT+IFjsQF5e7oc0NKST2xoCih6SJziqYjY4xf7uMtfC2cP8xPNNQr3F5oh1Cg01FunjCN8iViJ7Q==
X-Received: by 2002:aa7:8ecb:0:b0:706:57ce:f042 with SMTP id d2e1a72fcca58-7067455bfd2mr9223061b3a.7.1719386659342;
        Wed, 26 Jun 2024 00:24:19 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-706984a721csm2692218b3a.37.2024.06.26.00.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 00:24:18 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 26 Jun 2024 00:23:02 -0700
Subject: [PATCH v3 2/3] drivers/perf: riscv: Reset the counter to hpmevent
 mapping while starting cpus
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-misc_perf_fixes-v3-2-de3f8ed88dab@rivosinc.com>
References: <20240626-misc_perf_fixes-v3-0-de3f8ed88dab@rivosinc.com>
In-Reply-To: <20240626-misc_perf_fixes-v3-0-de3f8ed88dab@rivosinc.com>
To: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org
Cc: Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Conor Dooley <conor.dooley@microchip.com>, 
 Samuel Holland <samuel.holland@sifive.com>, 
 Palmer Dabbelt <palmer@rivosinc.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

From: Samuel Holland <samuel.holland@sifive.com>

Currently, we stop all the counters while a new cpu is brought online.
However, the hpmevent to counter mappings are not reset. The firmware may
have some stale encoding in their mapping structure which may lead to
undesirable results. We have not encountered such scenario though.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index a2e4005e1fd0..94bc369a3454 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -762,7 +762,7 @@ static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
 	 * which may include counters that are not enabled yet.
 	 */
 	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP,
-		  0, pmu->cmask, 0, 0, 0, 0);
+		  0, pmu->cmask, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
 }
 
 static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)

-- 
2.34.1


