Return-Path: <kvm+bounces-20637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AC1691B904
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:52:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16CA7284EAE
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 07:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18EB914A4FC;
	Fri, 28 Jun 2024 07:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="loJxZlJM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACAE145334
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 07:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719561129; cv=none; b=PlGmJin3rCbrVBkOvNNE8Y6VYtXSwo53sLZYESpExvvVzNmRFjqaoYDCy8QutRAdSaNTbUPZdbVZ4qhJBjZ07E7SoE5/BQxdIwQyvTdD7nHjU5+5+zo2augbgv/DDMMMV2bF5BKg+Wkqj9hAfniI0EuTeyPlerSoI+CY6xOxn8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719561129; c=relaxed/simple;
	bh=UYQnyeyH4ohjpyhxmQyUsjOd4jl+wfm38hnpNZUDtac=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P1GmhPIpTTXikWO31pI072dmhpKOlq9FIWjHR1A5mtlYbsQNEERrnI12SgZqAzO4IyDm8/5qobgkhZvqifMY9BYaNO0aPmLIknMPPjpjdjjRC94p3/oZZQGL4OhKHRrmIsB43b+Ae+ONvU6k+CNwotJOt2tJdXi62QLI2BjaFRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=loJxZlJM; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6f8d0a00a35so298770a34.2
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 00:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1719561127; x=1720165927; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8QTaOQgSJlRgxGe2DAtbRN63Xb4cFygQnCpr3YrplOU=;
        b=loJxZlJMUieHyNxT02kKCmi4kUOIsRKls+hJFwcSG8KL3vL80Y0mmPNp116Wl8sZJa
         DgRclrjq+bmWkWmEqkfK0ddRCvXF7fNeOg0zne+4/Wi963cXE4z0tVBHfTXXuMiHEbIf
         uYpZChYR0WePqxrRl9IUZ9NrdVTCRDhEI1Uc3ziTGSoTUCyS4hiUIRGOzZzanN1xBy5A
         tmAYJl8xSEc4ezVqIkwFgfBW3+254TnvKCZCNc7CPHCYKtCmjJICu19YhH5oslXMGYt/
         FZt7hveVKgGk8gZDcDuaKQ7IUVYHTvAxI9RCnSTJuLLv/OIm6GotT1y88TNWqFhwoj6k
         ZUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719561127; x=1720165927;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8QTaOQgSJlRgxGe2DAtbRN63Xb4cFygQnCpr3YrplOU=;
        b=dlmHi6uwoFLCh61GbH15p4sS+aifsLBGxDbF5G9SrkkelFk1vpvCEGZS/309IWpRf3
         tG/2EBXCiL0J9kHvyJ+5dOXQMzBj3oPVznJdNfn3RGSSHQyEq7mH/lwLOFm8sG3g2d5H
         jNiucnKofoJO/8dL3gQobqxWLvAszGMLudxfJn1uXIBY2A99B/HA7f2vos4uYdeUK3iI
         iIOmu308oqBD5jEU5Co0Sc1BdrROUvtQQRyjUScqVVHMZXIrCd5wdwr77Jn/hjzGarYy
         F5UxhDqo6/EcOIc+KhNuHYsiaM0jtYlbvksCs0bG8cfG4/ipWRYoR+W8tbvsA5j6EeZJ
         5/5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTFBmFHYspqhRBOWiG4OH4wjb0AhLpA3f7BQv/aQwohbSKRtZuZu6wLLn2G+OCJKuZYQGImAwPuaur3RJ9e+vHxGwP
X-Gm-Message-State: AOJu0YyXSiYRXRtP3wYHa95U7L1eFHTpmEQw65LOtkxczEbm+5lYKk4M
	/ZhxfNkp631U9KNTZW7nWahtCBQPHoBqcYRijJIY5eveg6c1IggRy7F5DV6BNSo=
X-Google-Smtp-Source: AGHT+IE5FpdJsgBgjR00qw7HsO4MmvDOUqzWFrZg+uaxB1OldOrplMNqpPJ7b0OBtuxblj+ltyW8xw==
X-Received: by 2002:a9d:7495:0:b0:701:f1cd:350a with SMTP id 46e09a7af769-701f5874810mr3112027a34.11.1719561126989;
        Fri, 28 Jun 2024 00:52:06 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c69b53bf2sm685068a12.2.2024.06.28.00.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 00:52:06 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 28 Jun 2024 00:51:42 -0700
Subject: [PATCH v4 2/3] drivers/perf: riscv: Reset the counter to hpmevent
 mapping while starting cpus
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240628-misc_perf_fixes-v4-2-e01cfddcf035@rivosinc.com>
References: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
In-Reply-To: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
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

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
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


