Return-Path: <kvm+bounces-47398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE98AC13F1
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 21:04:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC4C1A27AC5
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 19:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCCF429189F;
	Thu, 22 May 2025 19:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vmyVhTgK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF5C288C1B
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747940627; cv=none; b=GK6pyOTB+1JGe8rRP6U0tvOq6/3IOap+ktFWD595O9XFbyNYVcEv2vIoBkMRSHWJNJbab4o3IgXcraOgb2o2o3kRDzIESV83gRWIoRGLsY4vP0GY+Xs5bXybtGc+3t6IhghLRV87kGzyGT8hwCwrInkZtRKHwyfe7H8YSgCUaT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747940627; c=relaxed/simple;
	bh=3aJLhlZAq85VhJRCvA3+qitnySOgX8ITRb2RAt2NMqo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QWDFdoGHV5/mzx54wp+h1cQEHQx2l9NrPKttEQ1Zkoqjolyj+O9RO0Iwpy1bnR/s/mGlkUEoloVyTM5zJB4E6QxTNWuaRIrq5brQkUADcdjfGhZh5g6HbcXaaq97Q1GfV4u07uiJWEh5JLGy1zguTze2XXoDtyWTUyqCHDSOxuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vmyVhTgK; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2322bace4ceso47538245ad.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 12:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747940625; x=1748545425; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1p4+AtteizaQRcJNZKx3uxkrKCkThIoqx663iDBnv3Q=;
        b=vmyVhTgKzwZYeNfv7D89dhW5tS1+vi5yWe1c0Xtws8mC/Jpd48FyXDApWIlzJbP/8f
         a+PeWDpN+MTKyNlZpcYCBjApG8/rKbhw/LFg79QFYukG9pskZqUv4gWwCFHUURlOC/S4
         NcPxvccyhwbVXCS7bkRVs2e88Zz69Fz4YNkuTLR6mDPxDM746msnuzoBvwq2R4kF1GEE
         zdTEu2yq/Rwg+XSNKuZ0w2RdAQAjAIeShWMdo2ztInPbD/JHiPoKzMwyTQ8AQFjYuTce
         ykZH/yCWUHL/HldR+V9si6XjkF0WdG4BD24+E4VymXHc6SBswmHLWWlAF3q5kjF+hJLr
         nlOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747940625; x=1748545425;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1p4+AtteizaQRcJNZKx3uxkrKCkThIoqx663iDBnv3Q=;
        b=ZPudSpSTVfTngajeKRccZDHs4i0UnzRYi7fE9LrFbYs9hackFSZxFNS/Ml1e84d1nX
         5rkU8MjF1+gvvkLHYNINjMdfXjS0jwf0yc3eyx1Hf2Ju6oddri3ahMeA7COl/C64P/zM
         Uo6+kuqpZb0P8iG1Cat666k5LeI6Q6C4P/QbRQOBbFnLHvL+4Ymsys69F4QvsbsE0i0M
         n7punXF0IohMMgVvn5WfyGa9n/BNCulDwW8UuX9rBeXOEmaeN6wUQztIn45vJ2MMFALi
         vUxTcIidIztFBX7EyIedukvg32TUXpL08k4mHJSHui5fc+iItkxlL8FxKx290Nli7M58
         kHcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXg+1dciz9pD7oysKOuV40oP7+aDrTKS1xx8cPUu4aJRxK+iRxlHH0/aBxyXgwoY1lXSjM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD3OpdfUGOjhtkuxtyVCAkM9mBezKjla1N9q5eEMqvWjriVvWQ
	T8ppwJVWyzNxGJkXCnvbvb93PnwkxZ7ca3tCCPQ1H9eNvYISZEJUyldenGi/qpU59nM=
X-Gm-Gg: ASbGncv0Re6TlDIYqEGFzgTnHY1zMbUsVRk8Fk1c218iQDkd9QLxPaYW59qlDgLn7rI
	IH+EupLuXVTGlXW/C1u4jeFxRzLW9bx2ByFCeuCvmlieol32lKxpyG7q7L+AhGzLJvxxnwY02TY
	gz2vKjzamhK/CbqoJSP89LfMzum4DHacMaW6Hb50zrPcunxjvZCLkfcPHkUmoMMJwZzmm7oLhmd
	83JXjaNmBecM+FKdCcpwqG0UQ2Y9y/ZKc2OE7q8h/Jgh99SINqw9BL1nc8NN4NgjpOCnHx87CIj
	tUBei5vRn4CctjOR8hHMbLeMXVZEpQXAlRjy4dv9B5ayE7PIwxv9XA9NnojwNhU/
X-Google-Smtp-Source: AGHT+IF60CjGVS+XkZOaK5ku4lafcj/BktLeKZMLaYLRiMYA2gu0KSgvj+oaPNmS3vGSkFgOpISftg==
X-Received: by 2002:a17:903:18d:b0:224:c47:cbd with SMTP id d9443c01a7336-231d3257fc6mr374153715ad.0.1747940625547;
        Thu, 22 May 2025 12:03:45 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9736esm111879155ad.149.2025.05.22.12.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 12:03:45 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 12:03:35 -0700
Subject: [PATCH v3 1/9] drivers/perf: riscv: Add SBI v3.0 flag
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-pmu_event_info-v3-1-f7bba7fd9cfe@rivosinc.com>
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

There are new PMU related features introduced in SBI v3.0.
1. Raw Event v2 which allows mhpmeventX value to be 56 bit wide.
2. Get Event info function to do a bulk query at one shot.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 698de8ddf895..cfd6946fca42 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -63,6 +63,7 @@ PMU_FORMAT_ATTR(event, "config:0-47");
 PMU_FORMAT_ATTR(firmware, "config:62-63");
 
 static bool sbi_v2_available;
+static bool sbi_v3_available;
 static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
 #define sbi_pmu_snapshot_available() \
 	static_branch_unlikely(&sbi_pmu_snapshot_available)
@@ -1452,6 +1453,9 @@ static int __init pmu_sbi_devinit(void)
 	if (sbi_spec_version >= sbi_mk_version(2, 0))
 		sbi_v2_available = true;
 
+	if (sbi_spec_version >= sbi_mk_version(3, 0))
+		sbi_v3_available = true;
+
 	ret = cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
 				      "perf/riscv/pmu:starting",
 				      pmu_sbi_starting_cpu, pmu_sbi_dying_cpu);

-- 
2.43.0


