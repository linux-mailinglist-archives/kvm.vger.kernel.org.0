Return-Path: <kvm+bounces-35470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77507A114C3
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:02:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87BCA169692
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0155215055;
	Tue, 14 Jan 2025 22:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="KjeUBiB9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60C022617E
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895522; cv=none; b=M/k4bDr52YX6VaI/W9w1ObPuxqniyOVVJNc5sIwg/aMTpL2lAWvMusc0Wo22OW2pivmK03v3DSHti7EknQvkNE2yhI0s+txZ6PRVeqyOn+OIzu4hukVONtAcWB0f1MIZmkMgSn0xfO3tqE09XTHjL7Zrg0Gqs3eo1W3L5wh1KJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895522; c=relaxed/simple;
	bh=NNCAGOvQW6c/wi47Uw3HHaYfIMwEpEg/G/qFp9b1ufY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gs2wDlt8ABfB6Q60aCD4yEc4lDrKKaca8CYF8QNZtCv4sejOt36RKsNmomOn6c5SvzjVrXTYfNdJQ+u4lN7CfBk1hFxpWBGAvk2t28xTE4laaHNC9UCW40+6o3nxwN3wREpS2wgBBkva1x/Kg6H2+HXOcGRkK1hlNhK6gHxRv6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=KjeUBiB9; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2163bd70069so110772415ad.0
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895519; x=1737500319; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8bYgqzdVcJEs+5Om17+8npB3p9rTqd8el94+SSiomKA=;
        b=KjeUBiB997Gnc+M2XOyeddgOO/CmMMTfDF5+Gi6FUuVUrSw1Xvi+mGo5qO5Hd00Ayo
         rjqhO0MEJPJhf7batZIcG3UXYQ0w8iATsmhGYso/uzuZKH3PDXNBCE7oIuTTP3d5N0Tw
         PIddZFVOb33J4PvoOYYXkZJERpRRA1BfeQG/6jJkK3qdgkgPhExQLKS3JSVv8hxe66zZ
         xoR36XkHQ/osE/3B/4bJ1Eq2hQxE28Xa0kPPWm71wwsyBajeHiwdun3lWYgjuspa6Z8P
         AkfXabCVdM6XFna9BsoixqNeTwEMpBnaiw/jyhoTZG0FdnLCY71gESeMvGjk0fiBHHJJ
         ZIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895519; x=1737500319;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8bYgqzdVcJEs+5Om17+8npB3p9rTqd8el94+SSiomKA=;
        b=KkDNOn2iXoO/hqVEk/2O+F5KGnqmIp6cwZG+k/QCpV1Bl7SvgykEEoUDdH5lL+7rVp
         sCSOP+OOUiq7NKDwfD0Y0skbqFclvMNxSMmeBCSicJh4U6rJv9ois08B0xrqAYTHivxA
         2mFfWbvdvGgvLSAuT88hobP6rrOBoSVN6orwo5kxRbKVtM7RBCcpIzsCPdBEx++cPc/L
         6ja3ZvPttHTX2+QeetYQRQCkfbeLctwWa2N8EtBiORtR0ChkzCyy+YR5MxZvsVEL2hMk
         NHDn9VlSHK+H/dIPaYViL2h3HLRS/zNBSUev/BnX4U43DdCG4o1vZbELosGmjXwn1iZ0
         oKZA==
X-Forwarded-Encrypted: i=1; AJvYcCXLevX7+5o3yy/KBGl+WHxEFlvk0drmBc47DWSW7CILV3CN8RQW+SK4vcPc29DawQA25jc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWtHWl6JLX0O4Q76M/YbBwqRj18TDph8uc90JMiR16DaXKboL3
	9wo3jUk3CSm7lm50Z61KCOLl+fgu73lJ+5arlFbweDgTKALOWnCsQ1pKbscl+DQ=
X-Gm-Gg: ASbGncth6f/nXhh/b9NFMpRe1dt1Lf02esJwItUAzv3ZMUKDF0D1o9FnIrPz8nmbOUz
	2siEqMLyIoYz/cyotXjY+2oi4UKnlfc7z20u32wbJNR9Siq5vSljZ9xVsdyeKMxYOY73jR8LlZi
	qZwKtjnaGYi1tXWzBnxZ56MOzDKUwVIMIRR29dCZWIhkX8Nvvnv32DEy+8jgIQUoCbl5C1rKQ82
	DcTfbIpMyzTcammB2O7MAOA9yH+n6QXHmhXsUzYm8baxru3+ubCfEcRjIryofFfXaXQBQ==
X-Google-Smtp-Source: AGHT+IH9ogDBtRPiI1E6tTGHRsPWCReutJMs+52UHs8LJjUAyGy5atztuKvytDsOF0kiZ6ZXmGsVKw==
X-Received: by 2002:a17:902:d511:b0:215:6489:cfbf with SMTP id d9443c01a7336-21a83f48cc0mr401663355ad.11.1736895519126;
        Tue, 14 Jan 2025 14:58:39 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:38 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:37 -0800
Subject: [PATCH v2 12/21] RISC-V: perf: Modify the counter discovery
 mechanism
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-12-8ba74cdb851b@rivosinc.com>
References: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
In-Reply-To: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
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
 Palmer Dabbelt <palmer@sifive.com>, Conor Dooley <conor@kernel.org>, 
 devicetree@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-perf-users@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
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


