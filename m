Return-Path: <kvm+bounces-14186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 641798A047B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 02:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98CC3B21648
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2021CAA3;
	Thu, 11 Apr 2024 00:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="UUo1MK4s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2BB3234
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 00:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712794113; cv=none; b=AMczsTfDAMCcQKJ7lY0aQykFaf9nbXvUBiOoqmWAvoN8ipJCwWaMNwj6qxJRfsI6ldWR1QwAnPIPFthBQCm8jMCjYYgrddET1jKEL8OwPqkDeRIuHg+paXpuPNuOwvx3X77AxiIKzNiNP/qoaNfu6Z04GVJ8mkvof5E7CgsTrsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712794113; c=relaxed/simple;
	bh=D0imf4yjCHU2zhJ+7daOWQHL1eFBZOwPbAsJ9dWbVdE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jhCY6E5xMhvhxikF9kmNw6nqpkuD4OQZuXw2qwprE/owMVqlm1H/KKM1FLeEKV7nl2eTaxX+t58j5wPp7l3PjsHSDqXabHv291Ps2qWQdKCiT63j4PR2aHIZuimO3WjdKHIn3roRqALzY6Ba3/xk9TUMN3qpwPIaVRcpJo31VX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=UUo1MK4s; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e4c4fb6af3so2253735ad.0
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 17:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712794111; x=1713398911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JsjqhFGYXnwJEbG5VdNtPW4Uvi+s8iNjRkGrxpWiI64=;
        b=UUo1MK4sQ0yjw/CZUcZtPELWt6uMhQSp184xKQmukXZX/vXynmJFW6syT7OgCGmQew
         M1eC4ogCi7VsSYP5XtpUkbwtoywdq+5pQm8OaO2JDvW0rrSaNyS2gjWhW1OU5GfYofsc
         zKOKV5MfLVRPfgnxAwypIO6DnR6/57V9ZXTNzr7hfgsWm+FYet7V2UALmVra/hhRhXsl
         DIFkrXf4L561R3cIvVeXmdNRsqQEFPgH7Ck+l2tpwQWfjcAnPzZz25+wYxDCDeu/k7hl
         pDxrijfO9m+79qVJLI7n0l/T9PJVZGNINTagVhjuA4wRgydBFwOfZn8xpVy6fg1+WpSE
         Szeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712794111; x=1713398911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JsjqhFGYXnwJEbG5VdNtPW4Uvi+s8iNjRkGrxpWiI64=;
        b=FExOvcci9euog+u4A1yEsTD61atGOVno+xoHPVEmQgNFAX5xLWsgC56Ck1I9f9A8uT
         9egBMhgkVuD9WcdB4RdNHidX4b8klgxww5L8JDJ9XOFBo/nJ8IPzE4e1M4dOl72/nnnc
         0Tr3BaFupRZWUhht0cL8D3mGhoeiyQjS36z/Btu+J8LHuC4rc7WdQgRLQqe3HQMuUWeo
         bvZbmKNFFBpt/uG0w6o5tCfVMKzuU2Q6dNK6yCT4AUtB0C21Ayhyyt32jw5TN8SIWSy2
         7e4vHQN94K4X1nydbAd10uNckmak3FnhgtFoI21wk/MqLmX0i8ZDAQAawsyjz4osXyO2
         4g1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXjHphZV/ccfRoxwoUtc7W2RndEjpbmhEF1ny7BMcRA1n1tBUtueYVEjLBtPKtOkYl2qk6rTxIxxIYUZXX8mU3ezNG5
X-Gm-Message-State: AOJu0YyWrTh/U2/6QXmNnlGrrFqHDi+XkaHoXePcRDFKMZMmT9sjD/lC
	8ct6/J5OCWgTz4atyyx5QO+yPch0k2+qEb7Jfu7mG0rr2nl8Dbr7/+TrMMXMiP0=
X-Google-Smtp-Source: AGHT+IGuFutR246dxqGbmU1WdGFmdIotjRuJtHTIKb2Ia1SDWO/lAEbkSs2TMc+GghFhVq0a3R7XvA==
X-Received: by 2002:a17:902:f94e:b0:1e4:7bf1:521 with SMTP id kx14-20020a170902f94e00b001e47bf10521mr1213882plb.19.1712794111648;
        Wed, 10 Apr 2024 17:08:31 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902684700b001e3d8a70780sm130351pln.171.2024.04.10.17.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 17:08:30 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Alexey Makhalov <alexey.amakhalov@broadcom.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Juergen Gross <jgross@suse.com>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v6 09/24] drivers/perf: riscv: Fix counter mask iteration for RV32
Date: Wed, 10 Apr 2024 17:07:37 -0700
Message-Id: <20240411000752.955910-10-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411000752.955910-1-atishp@rivosinc.com>
References: <20240411000752.955910-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For RV32, used_hw_ctrs can have more than 1 word if the firmware chooses
to interleave firmware/hardware counters indicies. Even though it's a
unlikely scenario, handle that case by iterating over all the words
instead of just using the first word.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index e2881415ca0a..a6e74f4ad1c2 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -772,13 +772,15 @@ static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
 {
 	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
 	unsigned long flag = 0;
+	int i;
 
 	if (sbi_pmu_snapshot_available())
 		flag = SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
 
-	/* No need to check the error here as we can't do anything about the error */
-	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, 0,
-		  cpu_hw_evt->used_hw_ctrs[0], flag, 0, 0, 0);
+	for (i = 0; i < BITS_TO_LONGS(RISCV_MAX_COUNTERS); i++)
+		/* No need to check the error here as we can't do anything about the error */
+		sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, i * BITS_PER_LONG,
+			  cpu_hw_evt->used_hw_ctrs[i], flag, 0, 0, 0);
 }
 
 /*
@@ -790,7 +792,7 @@ static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
 static noinline void pmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cpu_hw_evt,
 						unsigned long ctr_ovf_mask)
 {
-	int idx = 0;
+	int idx = 0, i;
 	struct perf_event *event;
 	unsigned long flag = SBI_PMU_START_FLAG_SET_INIT_VALUE;
 	unsigned long ctr_start_mask = 0;
@@ -798,11 +800,12 @@ static noinline void pmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cpu_hw_evt
 	struct hw_perf_event *hwc;
 	u64 init_val = 0;
 
-	ctr_start_mask = cpu_hw_evt->used_hw_ctrs[0] & ~ctr_ovf_mask;
-
-	/* Start all the counters that did not overflow in a single shot */
-	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, 0, ctr_start_mask,
-		  0, 0, 0, 0);
+	for (i = 0; i < BITS_TO_LONGS(RISCV_MAX_COUNTERS); i++) {
+		ctr_start_mask = cpu_hw_evt->used_hw_ctrs[i] & ~ctr_ovf_mask;
+		/* Start all the counters that did not overflow in a single shot */
+		sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, i * BITS_PER_LONG, ctr_start_mask,
+			0, 0, 0, 0);
+	}
 
 	/* Reinitialize and start all the counter that overflowed */
 	while (ctr_ovf_mask) {
-- 
2.34.1


