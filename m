Return-Path: <kvm+bounces-47401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1BD3AC1419
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38F711B653D0
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CBBC29993A;
	Thu, 22 May 2025 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Rzauf9hl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6010528C870
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 19:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747940630; cv=none; b=SYD0flGHLDEQlCPLXcfC8h60YSeiKjbac2aBqdIthm5q/CJ/ZlfZ6GuF9+cJ5tJgJc7r6ryqCq5IguGKqUl+yXjlYlFdd9mhqesQbMI7x/Vta4XesjX4S5SZ87AT7gdjxunNd/RvMYAwg6dSJOvo+x5nwQc33+h2TWw5gyUcGjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747940630; c=relaxed/simple;
	bh=rbEY388+vf1xBc6RFqGTgB4Goxixu7Il6QwVlf57D/w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S/aaW9lNzPLflvu6CeUSnDGbAnht7jkVJzyvx4HEn7Vxs7Sz5ibn0WdUiIPRa+3m9hU5CF6QKtgS6qAlQvAU3dh/yiCnUSkkQ5nOiZvHbj/nBlHiZZY46KSPpqUSI3udFgQ3LmZb0aUYzZPcteO2nyRCG67mWwC1CvE1pTsVOyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Rzauf9hl; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso7191437b3a.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 12:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747940628; x=1748545428; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MgSYDCFyOFl1ODnG5fRD1TrPKu6WyFc6mOzCNie7R+g=;
        b=Rzauf9hlYaWgf6QBa9mPFeUETAwkIByhOV79ZeCfw1mZB7/WUO88IT3G2uBv01fuk/
         tll0bgTbNnycSFx68qEjzWp6BYL+Zhk2gRcghhOupMlqRYw1uSaTPWnMW/36VTQaJKKt
         RUbgmDyEYSQiEn6oj4VnNBNsDznav0qnXxZw9hbbXuRUkZRQNBr93b5Azj6WMwEKvGQ3
         9ficnQEiN/dgyUJLOGcDxDsksRwS9BdJ+Mlvs0TsewgdyW2tWXe6Qj7MeHWPvQe1PiDm
         3QRoC/UyLQyKldk5+Kx5oxSiOX1jYm4/7Dd6fONt0cyEXvYX82/mOyLoo4o4sCrwF82T
         CuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747940628; x=1748545428;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MgSYDCFyOFl1ODnG5fRD1TrPKu6WyFc6mOzCNie7R+g=;
        b=rmSRIqIHMmH6Uv2IfDPQArSB+Um555GfkD4Fjcep1UHQtdGHdrqi+AWCQ9mGJGSsgc
         SMMPtdMMb8jSFZ35c7W6O0XCuzo4pOHn3cBHdd4rRjQe7/P60qsARflVo2wrtWjvU+HT
         wUxWeGB5r5DU2cJOTInx8NcZimmQAJdW7yVl89DLd7YBgTl+uS4LDTuLInJDLcy846eq
         zKscRynEB3j3bYb0GrWHu2fDlR5YqnWO7l0F/0S1NjCMMV1d6m/21nLgGOK7+HAjLcKi
         jK2qvWdlgt7pJZ+B/h4pvp/8ahDjR65CZb2GYkfl3AnNH7M2LRMYah/qh/3RkoQnMkZ8
         gC5g==
X-Forwarded-Encrypted: i=1; AJvYcCX+QInMclQch/BIpuBP9zeZg5nouOEoXYdIVoCOccJ5ORgCUX+cVyXw/A5CbkPjEv9BG7I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRQfhlFX/ZRqBXEJMvrK1BGGCIGlUTBOTLxp0K6/DO0IIHMqwF
	16hZZY4Ky5mqEFdeW6KKb8zvdroTlWp5RnVnEnhRddID9K+u3QCfbF6Cs1FvHLiRmtY=
X-Gm-Gg: ASbGncvBisPGL+gXZZKmu0OOJiEOOZPkmMvNUDMs8bBC1Dgw+OHtC//Fx3BXekaG6Xf
	kTFI+tuBTqfVnYhs1vLOM8+kW59FkXFXLglwYpamDprWcRn6lZUiIlyS95o2CBfVkyG67Z7chcp
	jGSjaTvfTachs38LAB4NUNcy3eDIuz5LW/au7D2rQgMbsy3F381JScFGZx1P1MvCAglBcrIxQ52
	f7or6+Q1RrJm2pI89qyc3HPR/+y1P5BepA0u06jiN97vtpuQrUoQmRaYpj0K33V+hJINVR0kGtg
	2aoqLxMdfxO9LtdPxGH4k8L2FOs/5MW+lEYL3w9dA/Pr6ppG4clM84G8SFV2EElE
X-Google-Smtp-Source: AGHT+IGs856eL1BrViuwG7Snet4kjwTZqseUJx/cN/TovXlD6rlR9pixORAh5bRSKluNwVXzmFHaxw==
X-Received: by 2002:a17:903:2301:b0:22e:364b:4f3e with SMTP id d9443c01a7336-231d4562cc5mr379326455ad.49.1747940627664;
        Thu, 22 May 2025 12:03:47 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9736esm111879155ad.149.2025.05.22.12.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 12:03:47 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 12:03:37 -0700
Subject: [PATCH v3 3/9] RISC-V: KVM: Add support for Raw event v2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-pmu_event_info-v3-3-f7bba7fd9cfe@rivosinc.com>
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

SBI v3.0 introuced a new raw event type v2 for wider mhpmeventX
programming. Add the support in kvm for that.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 78ac3216a54d..15d71a7b75ba 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -60,6 +60,7 @@ static u32 kvm_pmu_get_perf_event_type(unsigned long eidx)
 		type = PERF_TYPE_HW_CACHE;
 		break;
 	case SBI_PMU_EVENT_TYPE_RAW:
+	case SBI_PMU_EVENT_TYPE_RAW_V2:
 	case SBI_PMU_EVENT_TYPE_FW:
 		type = PERF_TYPE_RAW;
 		break;
@@ -128,6 +129,9 @@ static u64 kvm_pmu_get_perf_event_config(unsigned long eidx, uint64_t evt_data)
 	case SBI_PMU_EVENT_TYPE_RAW:
 		config = evt_data & RISCV_PMU_RAW_EVENT_MASK;
 		break;
+	case SBI_PMU_EVENT_TYPE_RAW_V2:
+		config = evt_data & RISCV_PMU_RAW_EVENT_V2_MASK;
+		break;
 	case SBI_PMU_EVENT_TYPE_FW:
 		if (ecode < SBI_PMU_FW_MAX)
 			config = (1ULL << 63) | ecode;

-- 
2.43.0


