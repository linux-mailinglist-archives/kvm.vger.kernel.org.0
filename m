Return-Path: <kvm+bounces-20527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8215A917998
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 09:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B40601C234C8
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 07:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38FE815DBBA;
	Wed, 26 Jun 2024 07:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ydsAod9K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31371159598
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 07:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719386660; cv=none; b=SkMkp4MsXI68GHFt3wG/oqCoaO7Roa6gdgbD3xyrrMZLXSB1Faq0SBojLcw/jdRxdOzqT6W4HpA73EyEk+w1cjBhzILQueHHaUdzxqD6DB7CCT3Gw+XCjWSwtKH6zQIhQ/rlvnEokcuck5A2wPGhi0M6OW/NBk/pyTA2ZUZMVng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719386660; c=relaxed/simple;
	bh=06RBFHMu9Nmr2Q1NPTzjbWGxYqYy2/kVWYTcvUcMgCg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WupoBHdp4qNUA+hqEp3U6NXS76LN4AOOZebcUYkVs0Isv4dGI1G2gkIvf8FQZwmfy1jmifunFi90/5YF3oSkYgjxl7CXZobuI0wUS1vJ+g3SBFfOduFwgxXTTvwdpBXjGOHn/qE9xJ4xRxxaUI9DVbbKcyPxwWD+JToqZ70sK58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ydsAod9K; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7066a4a611dso2803729b3a.3
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 00:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1719386657; x=1719991457; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8anUdf9RYagj+8dVpBIC/eX2xYMTPOXrNSg/TEplCt8=;
        b=ydsAod9K6yXeRpcMm8tDmaqjjNyUKIdzyPtNMlOEduO6KV+O77ZIJvbPFTym+ao7n2
         ldrGpMu6MpOLla/t1FYY+iPf44ZN3G+Nh6MoNOmVLKJAhDcK4gO8VQR3eNt2yjlpui7k
         OA7p6CJ1TWmz3TrL/uKEiN2eB9BpzCL0lK6dKrX1CpGnjhONmaQBNAjWGmTqpl8qrI2Z
         ZwXQ2XOrQnlImygpB3UMOfUordVXLosu7h77IyeLiXPjWhJVjI+QXijgI24MidyjEDXz
         aUyNROmUaPistqK54MKpxsIxPhosOmRC03wiNjcRIMDcxPZQJMNueauvBmTzYsBbzZA3
         QLCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719386657; x=1719991457;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8anUdf9RYagj+8dVpBIC/eX2xYMTPOXrNSg/TEplCt8=;
        b=Bs5uBIjpskP06FwOltUnnmwGrlheN3iasQrtB/AGMPApr0Q8AeppASQWu2sHblD9h8
         7rRnT2iVnfwOwcU27RFQAz4y+5T84mUe1wf6jf17jU3LUMDGht31IKuIZIAUCjvvMKG1
         K8Th/YOGkBFR7sUhEGLQY5CEAs7MRBuc6Z5qgwK2jU1WQXrVBgmzcaUC8xTwAiRMVr+H
         af9loLPlWEW5JuP4cVtKOQR5dlfXX82eAS36M1O9nfVUZq4nPfM4Z1VaO9hBTSQIm5la
         2NxkatGGCT5FJdRYwiDlza4KBLCWY9i1LSXTMFUwobCm9BD8oMYDKdC9lMuQGWUD71h6
         qG8w==
X-Forwarded-Encrypted: i=1; AJvYcCUcP4oCbMnWSVMEF0mEtz5fqfGSRjYSuKIVIeamglbtNSy4sWnacbH+1KAc8ulNGmnNry+VEL5sRAXLg3NkY9s4GQxL
X-Gm-Message-State: AOJu0YxlNm+aXNK7yCqCRhJmVN7XhT+xRBrsUyM09wi72dwUIf66+Zvh
	s/u8Wz7yVPOuIvFLkAxBeMeoApsGt+zdsBYBnjf743/Ps50xVou2UJqrJLiA+aM=
X-Google-Smtp-Source: AGHT+IG/ltx0PscjisU5QEngpWeqUQrsUK17QM5DEDcSKzn36CUqRKBVIIjNHW6RZ5CQaoW0qeXI4Q==
X-Received: by 2002:a05:6a00:bf0:b0:705:9aac:ffb8 with SMTP id d2e1a72fcca58-70674582b1bmr8915411b3a.9.1719386657496;
        Wed, 26 Jun 2024 00:24:17 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-706984a721csm2692218b3a.37.2024.06.26.00.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 00:24:17 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 26 Jun 2024 00:23:01 -0700
Subject: [PATCH v3 1/3] drivers/perf: riscv: Do not update the event data
 if uptodate
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-misc_perf_fixes-v3-1-de3f8ed88dab@rivosinc.com>
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
 kvm@vger.kernel.org, Atish Patra <atishp@rivosinc.com>, garthlei@pku.edu.cn
X-Mailer: b4 0.15-dev-13183

In case of an counter overflow, the event data may get corrupted
if called from an external overflow handler. This happens because
we can't update the counter without starting it when SBI PMU
extension is in use. However, the prev_count has been already
updated at the first pass while the counter value is still the
old one.

The solution is simple where we don't need to update it again
if it is already updated which can be detected using hwc state.

Fixes: a8625217a054 ("drivers/perf: riscv: Implement SBI PMU snapshot function")

Reported-by: garthlei@pku.edu.cn
Closes:https://lore.kernel.org/all/CC51D53B-846C-4D81-86FC-FBF969D0A0D6@pku.edu.cn/
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu.c
index 78c490e0505a..0a02e85a8951 100644
--- a/drivers/perf/riscv_pmu.c
+++ b/drivers/perf/riscv_pmu.c
@@ -167,7 +167,7 @@ u64 riscv_pmu_event_update(struct perf_event *event)
 	unsigned long cmask;
 	u64 oldval, delta;
 
-	if (!rvpmu->ctr_read)
+	if (!rvpmu->ctr_read || (hwc->state & PERF_HES_UPTODATE))
 		return 0;
 
 	cmask = riscv_pmu_ctr_get_width_mask(event);

-- 
2.34.1


