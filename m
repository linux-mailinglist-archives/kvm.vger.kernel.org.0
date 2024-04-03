Return-Path: <kvm+bounces-13433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E3089679A
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 10:07:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DF841F22AED
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 08:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41646D1A8;
	Wed,  3 Apr 2024 08:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2iixUOkb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5528176023
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 08:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712131529; cv=none; b=PIRFBsG0OCv8PzZE/wsEA9Fcqng9vMf6ZkQXHvYhDWfPwiOy/gdchMWjsY5KCjESRynvZujzgsiTdFOA+uUuVWU6vlzoy08bTVZieopxtIWHgr9eQued5vuAUkO32wOMFbv8UOFrKpeWagJGJclPGv1qS1HEXIA7NVThcvNqvd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712131529; c=relaxed/simple;
	bh=aDfanLTs21GL0maDPQpRseQyiyuKg+u1j0b2hveDXpI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SfvzYX82uN5zluU4Ie+upKWBbmbTPkpVCe+aamgaFNo194+Ztc1Aa8CQ67tYcyIZuClwmHQVDsgjy4HrkGbfrptXstanvCH6AjhJ9Dgh3R9qIMbSyMOcbzABnE37NxNq95ITgY/geoNfcQ3T6cUPy85h30JFMFp5LzC5zKhUTEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2iixUOkb; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6eae2b57ff2so4888317b3a.2
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 01:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712131527; x=1712736327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4rw21DNPDWpaXnd5Gs3cWE2qTmUGGOZ0JnLHhYLDMiI=;
        b=2iixUOkb5ZvcS909cd2IhppvnztzEejMRSDC99adKGajjgp1jtLAQJ5lGxpJnmnkXf
         FKM3oJrgfdEAKK3vfP76gfrAjghy5khVIwIYF7SFJunpu52SD0BTSTKxP/BD27F4utB9
         jTfRLGEBLDRrvUmjpBVJUVHf16VfmhhhsQNjQXFQIJI7KB2mpwfepVwdczJGhAMKYbCM
         aagO54xA8Bj2XqknrkufVfHoo/UOcQwcra9A1ZcLz/+Xyrfu8plWr+PwAwsahUkm10Mb
         XNUcukZutv8afK4JgJf4PdCY2I3mBfyn5ZjrbXcTJR2txMIppT3GM5JtHvvP+7RA/5/H
         Ii/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712131527; x=1712736327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4rw21DNPDWpaXnd5Gs3cWE2qTmUGGOZ0JnLHhYLDMiI=;
        b=HToXTfF3iQ/aBLM+XcVwftAmQ1+O+Is0dafBtoup2bnQObRXB836MCYvQPgakmra2U
         /hR7sAo0+s0RmS5IfuYdGbF79cMsLBMXqPRG00P1SvxrZp/Kmd9FrTtS3YRZ9FKjaRz9
         aXOxm7Y4QeV50gJoET3S5SXm66WpUEeYFWIYlZqnTv6dFEOCU30RQDDb1bb1AziRlfU4
         JWsQiZdIViMlP0lXSL6umnOikUunBRp3l7v8GSj9Cjhc/DD2/UK/EnDUWFjURQMnXVUX
         CNICTvHitynBO0l5Q9xQRUGIEo80B/LdCrriu1BZRa4e8aZLUqlYNiZE0O6SoD+c5sSr
         Olaw==
X-Forwarded-Encrypted: i=1; AJvYcCUjzcejFeuJPLCOEO+w868294O4iOnnWzZLa9tcUFd9/jw4KnfEI2OqaRwPQg5+g6LW1kOfYcv6hgyXe/N5qqlH6X3S
X-Gm-Message-State: AOJu0YzWE8TqrLtQVfpgbgIY5WTgOu509NeveZJsDAz4Npcl0wAOb8vn
	zMvAsQfU4BzLJPE3227sNeREpI9GgeII+MIX96sZTcA6OJByEGkS8b93paJeJgI=
X-Google-Smtp-Source: AGHT+IHZeguUWEErPiWxvNkeVU9lmGoRHX/48aTBnxr2DMrqRPKV9Qdy9c2zpt6UamZ4tC6ZYgwGwA==
X-Received: by 2002:a05:6a20:17a7:b0:1a3:34c4:b184 with SMTP id bl39-20020a056a2017a700b001a334c4b184mr13823636pzb.19.1712131527654;
        Wed, 03 Apr 2024 01:05:27 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902d48c00b001e0b5d49fc7sm12557229plg.161.2024.04.03.01.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 01:05:26 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Ajay Kaher <akaher@vmware.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Alexey Makhalov <amakhalov@vmware.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
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
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v5 07/22] drivers/perf: riscv: Fix counter mask iteration for RV32
Date: Wed,  3 Apr 2024 01:04:36 -0700
Message-Id: <20240403080452.1007601-8-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240403080452.1007601-1-atishp@rivosinc.com>
References: <20240403080452.1007601-1-atishp@rivosinc.com>
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

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 8c3475d55433..82336fec82b8 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -771,13 +771,15 @@ static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
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
@@ -789,7 +791,7 @@ static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
 static noinline void pmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cpu_hw_evt,
 						unsigned long ctr_ovf_mask)
 {
-	int idx = 0;
+	int idx = 0, i;
 	struct perf_event *event;
 	unsigned long flag = SBI_PMU_START_FLAG_SET_INIT_VALUE;
 	unsigned long ctr_start_mask = 0;
@@ -797,11 +799,12 @@ static noinline void pmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cpu_hw_evt
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


