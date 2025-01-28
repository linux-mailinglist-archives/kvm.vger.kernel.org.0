Return-Path: <kvm+bounces-36733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5B0A203BE
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CACBB1882B20
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BC81F78E9;
	Tue, 28 Jan 2025 05:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="bPhMRP8Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4DB145B3E
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040412; cv=none; b=NSmmh7QeFc1uRePbm7gHpC9TzI6VrfOtO/JkyUowG2P12a1kot5aFTuFN6YQ8NDeXu2UdkDkXy/LvhFWey/vwREHgvPJN3BnyvvkC6EmJQu+0yvdHgMAo/tacvrZRgV51lKYbWZUYtjPO6scY7j3v/dwlaCVyYBMJVyYc5qfowM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040412; c=relaxed/simple;
	bh=NNCAGOvQW6c/wi47Uw3HHaYfIMwEpEg/G/qFp9b1ufY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Jtng0Bic6mJI2kXQ2ApuG9vca7HwGWERb1E3UgKOqsVBCWBIrH2rKWDaX9mDcHtaJtzULUkIsyGKfwOhzcG/NSzhwptlQ5KkopZPWk3IbyKX03PR21b7AtQUQ5KBD0NjHFy+jfWzTcsvxPvBvMZQxDrKj2INmp5H80e6IVuXcoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=bPhMRP8Q; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ef760a1001so8867144a91.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040409; x=1738645209; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8bYgqzdVcJEs+5Om17+8npB3p9rTqd8el94+SSiomKA=;
        b=bPhMRP8Qv7Xi19NAk6Ar8lztO7V8wYVCIe0gwoWgTQtsJWUZx08QhD8NgqQDWi0pM0
         xwoPtDZLW9lrSadfaTxoKuPRR6Gl7SOpQ6DF+hx7Rj1Pc8AWDyM5ctuqa8RX1vCmb6K4
         Bba14fhqOFcmu+zy+ro0SyX4R5gt8kkuJEAGjSMU2Va0Zt2Lu2lZzFSJ5g/DGiqOoUeE
         bbDTD5NNSbV0yBANGVJsP1bNXAW/0XWfQWfvf9BTRZozD+OKU+SV3a7dnlbW9187kySQ
         9SAxfSE2XNYNRq8f2JxNYrZmOAptzB8cp29Rggm+/5mzpVsaBR4nSXlwXKT6JfuJxqQz
         ik0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040409; x=1738645209;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8bYgqzdVcJEs+5Om17+8npB3p9rTqd8el94+SSiomKA=;
        b=jmjAcMUX5MSuqIi/2Dqkdjqb9VFpivUqRmYWufQt9R8VDwFeMf6a4M3UQaj8lnhqNY
         2WNPTQJOwfoas2lEp5yff0HCKmY0+eH/HaTUSnEiL+qmLpNBKiq8JsQIOJ5IxtrnP4fs
         jkeospafuqv4ZdWk9AizIis7/vB3JJfZtuDZOPnLwmgRS3aVVjv9bCosjNDh1AmM5mNR
         JIfxQd/45aSPyaeIuRhH0jUcq0w+frmRvdBpAX9a6QBCWD/dVV1SgO+M6P3vS5B4pwYV
         /l3LymSh+hAqZtNGcaDkAFl4aZJbr9KxmxomlAfE+FvQFVwchNpjfC7o7MEmXlqwrKW1
         TdnQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/bJZCxXxn55rN2wHhAo8OYOsKx09NPQntV+8+P4y+eK50YUoTyQmxgDNcizTgRIQZiOE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw65dzNcvSmtHdfW1qvkaGOhgdUyodGrWvpwNhV6dWJwrKSwzIr
	H1IqXDn2RAZ5/4vSj3HOb19Ov9a5VVtrQKKD1GiJ19XN/w3fbC9lhrb5zjmaVlY=
X-Gm-Gg: ASbGncvAs392hf/IkYYnQbqfdngWmOchrrH51f3Eqrys8UBMscvj02VWRTcTkrMJecI
	X/Ttph8ryE1snwe2e4uZOc6S9yChCgah9qnb/uJf0NLqRr6KSYU/dMHnA+Hig3rN3SZBFUxacFP
	vwczmxWP1OZczRIMY6mFJw/G4Vp/6o70YguNYDWIAx8P+rP9mTcBmnYylkqF5aHtQcr1I0cbH72
	Uk/FOiqxaiqmEo73rE1nOvGizJMqIvg5ejjnKEIlX7HmerNxHf+66DyAP77qC+IA817UU9wy00P
	Fy4441Ao2wMgrUWPb+MZMVim8FfL
X-Google-Smtp-Source: AGHT+IGLp1UCkGagpEBSjEvSyu6FWwXgcrQZ9ubpPbhJGTYHTG61vJv8BZTr3/TOZQCrUeRv8fNh1w==
X-Received: by 2002:a17:90a:c883:b0:2ea:77d9:6345 with SMTP id 98e67ed59e1d1-2f782d3299emr53146392a91.22.1738040408675;
        Mon, 27 Jan 2025 21:00:08 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.21.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 21:00:08 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 20:59:53 -0800
Subject: [PATCH v3 12/21] RISC-V: perf: Modify the counter discovery
 mechanism
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-12-64894d7e16d5@rivosinc.com>
References: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
In-Reply-To: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

If both counter delegation and SBI PMU is present, the counter
delegation will be used for hardware pmu counters while the SBI PMU
will be used for firmware counters. Thus, the driver has to probe
the counters info via SBI PMU to distinguish the firmware counters.

The hybrid scheme also requires improvements of the informational
logging messages to indicate the user about underlying interface
used for each use case.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_dev.c | 118 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 88 insertions(+), 30 deletions(-)

diff --git a/drivers/perf/riscv_pmu_dev.c b/drivers/perf/riscv_pmu_dev.c
index b69654554288..c7adda948b5d 100644
--- a/drivers/perf/riscv_pmu_dev.c
+++ b/drivers/perf/riscv_pmu_dev.c
@@ -66,6 +66,10 @@ static bool sbi_v2_available;
 static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
 #define sbi_pmu_snapshot_available() \
 	static_branch_unlikely(&sbi_pmu_snapshot_available)
+static DEFINE_STATIC_KEY_FALSE(riscv_pmu_sbi_available);
+static DEFINE_STATIC_KEY_FALSE(riscv_pmu_cdeleg_available);
+static bool cdeleg_available;
+static bool sbi_available;
 
 static struct attribute *riscv_arch_formats_attr[] = {
 	&format_attr_event.attr,
@@ -88,7 +92,8 @@ static int sysctl_perf_user_access __read_mostly = SYSCTL_USER_ACCESS;
 
 /*
  * This structure is SBI specific but counter delegation also require counter
- * width, csr mapping. Reuse it for now.
+ * width, csr mapping. Reuse it for now we can have firmware counters for
+ * platfroms with counter delegation support.
  * RISC-V doesn't have heterogeneous harts yet. This need to be part of
  * per_cpu in case of harts with different pmu counters
  */
@@ -100,6 +105,8 @@ static unsigned int riscv_pmu_irq;
 
 /* Cache the available counters in a bitmask */
 static unsigned long cmask;
+/* Cache the available firmware counters in another bitmask */
+static unsigned long firmware_cmask;
 
 struct sbi_pmu_event_data {
 	union {
@@ -778,35 +785,49 @@ static int rvpmu_sbi_find_num_ctrs(void)
 		return sbi_err_map_linux_errno(ret.error);
 }
 
-static int rvpmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
+static int rvpmu_deleg_find_ctrs(void)
+{
+	/* TODO */
+	return -1;
+}
+
+static int rvpmu_sbi_get_ctrinfo(int nsbi_ctr, int ndeleg_ctr)
 {
 	struct sbiret ret;
-	int i, num_hw_ctr = 0, num_fw_ctr = 0;
+	int i, num_hw_ctr = 0, num_fw_ctr = 0, num_ctr = 0;
 	union sbi_pmu_ctr_info cinfo;
 
-	pmu_ctr_list = kcalloc(nctr, sizeof(*pmu_ctr_list), GFP_KERNEL);
-	if (!pmu_ctr_list)
-		return -ENOMEM;
-
-	for (i = 0; i < nctr; i++) {
+	for (i = 0; i < nsbi_ctr; i++) {
 		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_GET_INFO, i, 0, 0, 0, 0, 0);
 		if (ret.error)
 			/* The logical counter ids are not expected to be contiguous */
 			continue;
 
-		*mask |= BIT(i);
-
 		cinfo.value = ret.value;
 		if (cinfo.type == SBI_PMU_CTR_TYPE_FW)
 			num_fw_ctr++;
-		else
+
+		if (!cdeleg_available) {
 			num_hw_ctr++;
-		pmu_ctr_list[i].value = cinfo.value;
+			cmask |= BIT(i);
+			pmu_ctr_list[i].value = cinfo.value;
+		} else if (cinfo.type == SBI_PMU_CTR_TYPE_FW) {
+			/* Track firmware counters in a different mask */
+			firmware_cmask |= BIT(i);
+			pmu_ctr_list[i].value = cinfo.value;
+		}
+
 	}
 
-	pr_info("%d firmware and %d hardware counters\n", num_fw_ctr, num_hw_ctr);
+	if (cdeleg_available) {
+		pr_info("%d firmware and %d hardware counters\n", num_fw_ctr, ndeleg_ctr);
+		num_ctr = num_fw_ctr + ndeleg_ctr;
+	} else {
+		pr_info("%d firmware and %d hardware counters\n", num_fw_ctr, num_hw_ctr);
+		num_ctr = nsbi_ctr;
+	}
 
-	return 0;
+	return num_ctr;
 }
 
 static inline void rvpmu_sbi_stop_all(struct riscv_pmu *pmu)
@@ -1067,16 +1088,33 @@ static void rvpmu_ctr_stop(struct perf_event *event, unsigned long flag)
 	/* TODO: Counter delegation implementation */
 }
 
-static int rvpmu_find_num_ctrs(void)
+static int rvpmu_find_ctrs(void)
 {
-	return rvpmu_sbi_find_num_ctrs();
-	/* TODO: Counter delegation implementation */
-}
+	int num_sbi_counters = 0, num_deleg_counters = 0, num_counters = 0;
 
-static int rvpmu_get_ctrinfo(int nctr, unsigned long *mask)
-{
-	return rvpmu_sbi_get_ctrinfo(nctr, mask);
-	/* TODO: Counter delegation implementation */
+	/*
+	 * We don't know how many firmware counters available. Just allocate
+	 * for maximum counters driver can support. The default is 64 anyways.
+	 */
+	pmu_ctr_list = kcalloc(RISCV_MAX_COUNTERS, sizeof(*pmu_ctr_list),
+			       GFP_KERNEL);
+	if (!pmu_ctr_list)
+		return -ENOMEM;
+
+	if (cdeleg_available)
+		num_deleg_counters = rvpmu_deleg_find_ctrs();
+
+	/* This is required for firmware counters even if the above is true */
+	if (sbi_available)
+		num_sbi_counters = rvpmu_sbi_find_num_ctrs();
+
+	if (num_sbi_counters >= RISCV_MAX_COUNTERS || num_deleg_counters >= RISCV_MAX_COUNTERS)
+		return -ENOSPC;
+
+	/* cache all the information about counters now */
+	num_counters = rvpmu_sbi_get_ctrinfo(num_sbi_counters, num_deleg_counters);
+
+	return num_counters;
 }
 
 static int rvpmu_event_map(struct perf_event *event, u64 *econfig)
@@ -1377,12 +1415,21 @@ static int rvpmu_device_probe(struct platform_device *pdev)
 	int ret = -ENODEV;
 	int num_counters;
 
-	pr_info("SBI PMU extension is available\n");
+	if (cdeleg_available) {
+		pr_info("hpmcounters will use the counter delegation ISA extension\n");
+		if (sbi_available)
+			pr_info("Firmware counters will be use SBI PMU extension\n");
+		else
+			pr_info("Firmware counters will be not available as SBI PMU extension is not present\n");
+	} else if (sbi_available) {
+		pr_info("Both hpmcounters and firmware counters will use SBI PMU extension\n");
+	}
+
 	pmu = riscv_pmu_alloc();
 	if (!pmu)
 		return -ENOMEM;
 
-	num_counters = rvpmu_find_num_ctrs();
+	num_counters = rvpmu_find_ctrs();
 	if (num_counters < 0) {
 		pr_err("SBI PMU extension doesn't provide any counters\n");
 		goto out_free;
@@ -1394,9 +1441,6 @@ static int rvpmu_device_probe(struct platform_device *pdev)
 		pr_info("SBI returned more than maximum number of counters. Limiting the number of counters to %d\n", num_counters);
 	}
 
-	/* cache all the information about counters now */
-	if (rvpmu_get_ctrinfo(num_counters, &cmask))
-		goto out_free;
 
 	ret = rvpmu_setup_irqs(pmu, pdev);
 	if (ret < 0) {
@@ -1486,13 +1530,27 @@ static int __init rvpmu_devinit(void)
 	int ret;
 	struct platform_device *pdev;
 
-	if (sbi_spec_version < sbi_mk_version(0, 3) ||
-	    !sbi_probe_extension(SBI_EXT_PMU)) {
-		return 0;
+	if (sbi_spec_version >= sbi_mk_version(0, 3) &&
+	    sbi_probe_extension(SBI_EXT_PMU)) {
+		static_branch_enable(&riscv_pmu_sbi_available);
+		sbi_available = true;
 	}
 
 	if (sbi_spec_version >= sbi_mk_version(2, 0))
 		sbi_v2_available = true;
+	/*
+	 * We need all three extensions to be present to access the counters
+	 * in S-mode via Supervisor Counter delegation.
+	 */
+	if (riscv_isa_extension_available(NULL, SSCCFG) &&
+	    riscv_isa_extension_available(NULL, SMCDELEG) &&
+	    riscv_isa_extension_available(NULL, SSCSRIND)) {
+		static_branch_enable(&riscv_pmu_cdeleg_available);
+		cdeleg_available = true;
+	}
+
+	if (!(sbi_available || cdeleg_available))
+		return 0;
 
 	ret = cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
 				      "perf/riscv/pmu:starting",

-- 
2.34.1


