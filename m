Return-Path: <kvm+bounces-8930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A85858C3D
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:02:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B0EB1C21204
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A9922325;
	Sat, 17 Feb 2024 00:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="xQSbW4E5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E92210ED
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131526; cv=none; b=Vn25WPlh+fX5UmstS4sOuiv428NMbv0hoSXWhUBBqVcAgGAO6cyZgbTX8vsJd5ZaHE1mlqTuikjH/6uNfwe7Ko9Ib8RA+TuN0W+Gy01esXPOZFmXV1RyZS0d1UWma7xWxHpOpUJJFHjH+s+4b8FZz/LIdoCljT6IzTHEo6Smguo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131526; c=relaxed/simple;
	bh=CeJwCHznNBIxDkzwFWSOXL/WQcV/2s2x2IaiHYjktNM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hX2Cp9YZo01/SV0YFw81T0osz8ObS9sSrrppmbu66ruOST+Yz72ycQ8XebazzmoZLkeKNuiTJuFAuesje6GkYLqKJwd2E4zAMnVzntlFbLXpVhhHISiB8cTi7EXFCnuy2HZFzpfMSTiY0g7SJBZgpR8qYB5HpzGgMOzYvHnNjsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=xQSbW4E5; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2185739b64cso1538040fac.0
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131523; x=1708736323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z7baHfz5wM1sAulxZ7aqcH3C+Q/jK4GirAIqj+bIgHg=;
        b=xQSbW4E5+JoryKpUWEu3puyukAverGJFHLGhYlHAI83RIQUk34P8kX3mb188knkk10
         qJBbzdKKd4LzwYPuHV6AX0aav3Bg5R/iRbUqyoPfpX+xQHYqbITetVPGTx9x73rDqXXN
         qx9NkJhbv8EzgnFpJvN/UO+Bu3No0zaIgZaDgb09OYJXIOgWGaIiSb3YiN3ozpHc9a6d
         H2M0inf926G4vbBvRgYWrG2TJhPRL8QB/rC5hsc0mKCFSuBQlDLYEPtsEokuEP41CWLI
         SD4+Z2r1TyyWIX5EeL4c655H8r1HDgavaqk5AdbpNH+beT2HISpymqFOlcTQBmA974V9
         kzlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131523; x=1708736323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7baHfz5wM1sAulxZ7aqcH3C+Q/jK4GirAIqj+bIgHg=;
        b=dnsz/6pdf3HAF0jGWYa0BrPAX3v/U3Gi3uCJOrM1x3BNoHnliR5gb4Fbgr/QVz6h+d
         KJu8U8TW8VQX8OBOyY4DQFMBHCl6D0TLDoZKUq0uATeIOXO/rYJX1Kft1JvAxIZpa6pm
         6kgP1KZ+c0Rt4UR9clm1+l7BYahYZBgc7CSB75agCwJFrlVC1Us0zRe59DAeJ2h5E3nj
         5+rV1JtzVYoXK4V50CyITsxC5yiPn0uWOXYqCsjp8+HOyLuOiNfGr392yOffK2ANIln3
         +iRE+83C+pd/pAkavuriNLBtP37t1XWIviyouoKe0Ckwc4c0ZGqEWkKNjZV/idFUOItL
         PlDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWYOnpA/0fZpCcM+cXnbXojXQObKKHm7GhXPCXCVG6uL64BoXKsRFElutmPo0eaHCq0mpH8yygc8A5DgDfCaGQnTvr
X-Gm-Message-State: AOJu0YyQsQBgO/j1phvgqyqfMF+T24GU3qGCnfXP3xGQPlab7/ibacyF
	Bc3vFAehGYsVuTRXiEDwiD0c8xPhU85Q0XSCBp9Lx0WMnbpyqLRbg/kMK1950v4=
X-Google-Smtp-Source: AGHT+IHkxfl5wojcZa7LsnbDVFHdZ6Fhtr81hemCG8W0Rrsj2MuzO5YyD77D//b4vSu9rHffY04CAQ==
X-Received: by 2002:a05:6870:331e:b0:219:7f2b:1f2c with SMTP id x30-20020a056870331e00b002197f2b1f2cmr7394263oae.37.1708131522858;
        Fri, 16 Feb 2024 16:58:42 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:42 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Atish Patra <atishp@atishpatra.org>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Conor Dooley <conor@kernel.org>,
	devicetree@vger.kernel.org,
	Evan Green <evan@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	John Garry <john.g.garry@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kan Liang <kan.liang@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	linux-doc@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Will Deacon <will@kernel.org>,
	kaiwenxue1@gmail.com,
	Yang Jihong <yangjihong1@huawei.com>
Subject: [PATCH RFC 11/20] RISC-V: perf: Restructure the SBI PMU code
Date: Fri, 16 Feb 2024 16:57:29 -0800
Message-Id: <20240217005738.3744121-12-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240217005738.3744121-1-atishp@rivosinc.com>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With Ssccfg/Smcdeleg, we no longer need SBI PMU extension to program/
access hpmcounter/events. However, we do need it for firmware counters.
Rename the driver and its related code to represent generic name
that will handle both sbi and ISA mechanism for hpmcounter related
operations. Take this opportunity to update the Kconfig names to
match the new driver name closely.

No functional change intended.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 MAINTAINERS                                   |   4 +-
 drivers/perf/Kconfig                          |  16 +-
 drivers/perf/Makefile                         |   4 +-
 .../perf/{riscv_pmu.c => riscv_pmu_common.c}  |   0
 .../perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c} | 170 +++++++++++-------
 include/linux/perf/riscv_pmu.h                |   8 +-
 6 files changed, 123 insertions(+), 79 deletions(-)
 rename drivers/perf/{riscv_pmu.c => riscv_pmu_common.c} (100%)
 rename drivers/perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c} (87%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 73d898383e51..6adb24d6cc0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18856,9 +18856,9 @@ M:	Atish Patra <atishp@atishpatra.org>
 R:	Anup Patel <anup@brainfault.org>
 L:	linux-riscv@lists.infradead.org
 S:	Supported
-F:	drivers/perf/riscv_pmu.c
+F:	drivers/perf/riscv_pmu_common.c
+F:	drivers/perf/riscv_pmu_dev.c
 F:	drivers/perf/riscv_pmu_legacy.c
-F:	drivers/perf/riscv_pmu_sbi.c
 
 RISC-V THEAD SoC SUPPORT
 M:	Jisheng Zhang <jszhang@kernel.org>
diff --git a/drivers/perf/Kconfig b/drivers/perf/Kconfig
index ec6e0d9194a1..86aaa1c1161b 100644
--- a/drivers/perf/Kconfig
+++ b/drivers/perf/Kconfig
@@ -56,7 +56,7 @@ config ARM_PMU
 	  Say y if you want to use CPU performance monitors on ARM-based
 	  systems.
 
-config RISCV_PMU
+config RISCV_PMU_COMMON
 	depends on RISCV
 	bool "RISC-V PMU framework"
 	default y
@@ -67,7 +67,7 @@ config RISCV_PMU
 	  can reuse it.
 
 config RISCV_PMU_LEGACY
-	depends on RISCV_PMU
+	depends on RISCV_PMU_COMMON
 	bool "RISC-V legacy PMU implementation"
 	default y
 	help
@@ -76,15 +76,15 @@ config RISCV_PMU_LEGACY
 	  of cycle/instruction counter and doesn't support counter overflow,
 	  or programmable counters. It will be removed in future.
 
-config RISCV_PMU_SBI
-	depends on RISCV_PMU && RISCV_SBI
-	bool "RISC-V PMU based on SBI PMU extension"
+config RISCV_PMU
+	depends on RISCV_PMU_COMMON && RISCV_SBI
+	bool "RISC-V PMU based on SBI PMU extension and/or Counter delegation extension"
 	default y
 	help
 	  Say y if you want to use the CPU performance monitor
-	  using SBI PMU extension on RISC-V based systems. This option provides
-	  full perf feature support i.e. counter overflow, privilege mode
-	  filtering, counter configuration.
+	  using SBI PMU extension or counter delegation ISA extension on RISC-V
+	  based systems. This option provides full perf feature support i.e.
+	  counter overflow, privilege mode filtering, counter configuration.
 
 config ARM_PMU_ACPI
 	depends on ARM_PMU && ACPI
diff --git a/drivers/perf/Makefile b/drivers/perf/Makefile
index a06338e3401c..f2c72915e11d 100644
--- a/drivers/perf/Makefile
+++ b/drivers/perf/Makefile
@@ -12,9 +12,9 @@ obj-$(CONFIG_FSL_IMX9_DDR_PMU) += fsl_imx9_ddr_perf.o
 obj-$(CONFIG_HISI_PMU) += hisilicon/
 obj-$(CONFIG_QCOM_L2_PMU)	+= qcom_l2_pmu.o
 obj-$(CONFIG_QCOM_L3_PMU) += qcom_l3_pmu.o
-obj-$(CONFIG_RISCV_PMU) += riscv_pmu.o
+obj-$(CONFIG_RISCV_PMU_COMMON) += riscv_pmu_common.o
 obj-$(CONFIG_RISCV_PMU_LEGACY) += riscv_pmu_legacy.o
-obj-$(CONFIG_RISCV_PMU_SBI) += riscv_pmu_sbi.o
+obj-$(CONFIG_RISCV_PMU) += riscv_pmu_dev.o
 obj-$(CONFIG_THUNDERX2_PMU) += thunderx2_pmu.o
 obj-$(CONFIG_XGENE_PMU) += xgene_pmu.o
 obj-$(CONFIG_ARM_SPE_PMU) += arm_spe_pmu.o
diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu_common.c
similarity index 100%
rename from drivers/perf/riscv_pmu.c
rename to drivers/perf/riscv_pmu_common.c
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_dev.c
similarity index 87%
rename from drivers/perf/riscv_pmu_sbi.c
rename to drivers/perf/riscv_pmu_dev.c
index 16acd4dcdb96..3d27bd65f140 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_dev.c
@@ -8,7 +8,7 @@
  * sparc64 and x86 code.
  */
 
-#define pr_fmt(fmt) "riscv-pmu-sbi: " fmt
+#define pr_fmt(fmt) "riscv-pmu-dev: " fmt
 
 #include <linux/mod_devicetable.h>
 #include <linux/perf/riscv_pmu.h>
@@ -55,6 +55,8 @@ static const struct attribute_group *riscv_pmu_attr_groups[] = {
 static int sysctl_perf_user_access __read_mostly = SYSCTL_USER_ACCESS;
 
 /*
+ * This structure is SBI specific but counter delegation also require counter
+ * width, csr mapping. Reuse it for now.
  * RISC-V doesn't have heterogeneous harts yet. This need to be part of
  * per_cpu in case of harts with different pmu counters
  */
@@ -265,12 +267,12 @@ static const struct sbi_pmu_event_data pmu_cache_event_map[PERF_COUNT_HW_CACHE_M
 	},
 };
 
-static int pmu_sbi_ctr_get_width(int idx)
+static int rvpmu_ctr_get_width(int idx)
 {
 	return pmu_ctr_list[idx].width;
 }
 
-static bool pmu_sbi_ctr_is_fw(int cidx)
+static bool rvpmu_ctr_is_fw(int cidx)
 {
 	union sbi_pmu_ctr_info *info;
 
@@ -312,12 +314,12 @@ int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr)
 }
 EXPORT_SYMBOL_GPL(riscv_pmu_get_hpm_info);
 
-static uint8_t pmu_sbi_csr_index(struct perf_event *event)
+static uint8_t rvpmu_csr_index(struct perf_event *event)
 {
 	return pmu_ctr_list[event->hw.idx].csr - CSR_CYCLE;
 }
 
-static unsigned long pmu_sbi_get_filter_flags(struct perf_event *event)
+static unsigned long rvpmu_sbi_get_filter_flags(struct perf_event *event)
 {
 	unsigned long cflags = 0;
 	bool guest_events = false;
@@ -338,7 +340,7 @@ static unsigned long pmu_sbi_get_filter_flags(struct perf_event *event)
 	return cflags;
 }
 
-static int pmu_sbi_ctr_get_idx(struct perf_event *event)
+static int rvpmu_sbi_ctr_get_idx(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct riscv_pmu *rvpmu = to_riscv_pmu(event->pmu);
@@ -348,7 +350,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 	uint64_t cbase = 0, cmask = rvpmu->cmask;
 	unsigned long cflags = 0;
 
-	cflags = pmu_sbi_get_filter_flags(event);
+	cflags = rvpmu_sbi_get_filter_flags(event);
 
 	/*
 	 * In legacy mode, we have to force the fixed counters for those events
@@ -385,7 +387,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 		return -ENOENT;
 
 	/* Additional sanity check for the counter id */
-	if (pmu_sbi_ctr_is_fw(idx)) {
+	if (rvpmu_ctr_is_fw(idx)) {
 		if (!test_and_set_bit(idx, cpuc->used_fw_ctrs))
 			return idx;
 	} else {
@@ -396,7 +398,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 	return -ENOENT;
 }
 
-static void pmu_sbi_ctr_clear_idx(struct perf_event *event)
+static void rvpmu_ctr_clear_idx(struct perf_event *event)
 {
 
 	struct hw_perf_event *hwc = &event->hw;
@@ -404,7 +406,7 @@ static void pmu_sbi_ctr_clear_idx(struct perf_event *event)
 	struct cpu_hw_events *cpuc = this_cpu_ptr(rvpmu->hw_events);
 	int idx = hwc->idx;
 
-	if (pmu_sbi_ctr_is_fw(idx))
+	if (rvpmu_ctr_is_fw(idx))
 		clear_bit(idx, cpuc->used_fw_ctrs);
 	else
 		clear_bit(idx, cpuc->used_hw_ctrs);
@@ -442,7 +444,7 @@ static bool pmu_sbi_is_fw_event(struct perf_event *event)
 		return false;
 }
 
-static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
+static int rvpmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 {
 	u32 type = event->attr.type;
 	u64 config = event->attr.config;
@@ -483,7 +485,7 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 	return ret;
 }
 
-static u64 pmu_sbi_ctr_read(struct perf_event *event)
+static u64 rvpmu_sbi_ctr_read(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
@@ -506,25 +508,25 @@ static u64 pmu_sbi_ctr_read(struct perf_event *event)
 	return val;
 }
 
-static void pmu_sbi_set_scounteren(void *arg)
+static void rvpmu_set_scounteren(void *arg)
 {
 	struct perf_event *event = (struct perf_event *)arg;
 
 	if (event->hw.idx != -1)
 		csr_write(CSR_SCOUNTEREN,
-			  csr_read(CSR_SCOUNTEREN) | (1 << pmu_sbi_csr_index(event)));
+				  csr_read(CSR_SCOUNTEREN) | (1 << rvpmu_csr_index(event)));
 }
 
-static void pmu_sbi_reset_scounteren(void *arg)
+static void rvpmu_reset_scounteren(void *arg)
 {
 	struct perf_event *event = (struct perf_event *)arg;
 
 	if (event->hw.idx != -1)
 		csr_write(CSR_SCOUNTEREN,
-			  csr_read(CSR_SCOUNTEREN) & ~(1 << pmu_sbi_csr_index(event)));
+				  csr_read(CSR_SCOUNTEREN) & ~(1 << rvpmu_csr_index(event)));
 }
 
-static void pmu_sbi_ctr_start(struct perf_event *event, u64 ival)
+static void rvpmu_sbi_ctr_start(struct perf_event *event, u64 ival)
 {
 	struct sbiret ret;
 	struct hw_perf_event *hwc = &event->hw;
@@ -543,17 +545,17 @@ static void pmu_sbi_ctr_start(struct perf_event *event, u64 ival)
 
 	if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
 	    (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
-		pmu_sbi_set_scounteren((void *)event);
+		rvpmu_set_scounteren((void *)event);
 }
 
-static void pmu_sbi_ctr_stop(struct perf_event *event, unsigned long flag)
+static void rvpmu_sbi_ctr_stop(struct perf_event *event, unsigned long flag)
 {
 	struct sbiret ret;
 	struct hw_perf_event *hwc = &event->hw;
 
 	if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
 	    (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
-		pmu_sbi_reset_scounteren((void *)event);
+		rvpmu_reset_scounteren((void *)event);
 
 	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, hwc->idx, 1, flag, 0, 0, 0);
 	if (ret.error && (ret.error != SBI_ERR_ALREADY_STOPPED) &&
@@ -562,7 +564,7 @@ static void pmu_sbi_ctr_stop(struct perf_event *event, unsigned long flag)
 			hwc->idx, sbi_err_map_linux_errno(ret.error));
 }
 
-static int pmu_sbi_find_num_ctrs(void)
+static int rvpmu_sbi_find_num_ctrs(void)
 {
 	struct sbiret ret;
 
@@ -573,7 +575,7 @@ static int pmu_sbi_find_num_ctrs(void)
 		return sbi_err_map_linux_errno(ret.error);
 }
 
-static int pmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
+static int rvpmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
 {
 	struct sbiret ret;
 	int i, num_hw_ctr = 0, num_fw_ctr = 0;
@@ -604,7 +606,7 @@ static int pmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
 	return 0;
 }
 
-static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
+static inline void rvpmu_sbi_stop_all(struct riscv_pmu *pmu)
 {
 	/*
 	 * No need to check the error because we are disabling all the counters
@@ -614,7 +616,7 @@ static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
 		  0, pmu->cmask, 0, 0, 0, 0);
 }
 
-static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
+static inline void rvpmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
 {
 	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
 
@@ -629,7 +631,7 @@ static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
  * while the overflowed counters need to be started with updated initialization
  * value.
  */
-static inline void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
+static inline void rvpmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
 					       unsigned long ctr_ovf_mask)
 {
 	int idx = 0;
@@ -668,7 +670,7 @@ static inline void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
 	}
 }
 
-static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
+static irqreturn_t rvpmu_ovf_handler(int irq, void *dev)
 {
 	struct perf_sample_data data;
 	struct pt_regs *regs;
@@ -699,7 +701,7 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
 	}
 
 	pmu = to_riscv_pmu(event->pmu);
-	pmu_sbi_stop_hw_ctrs(pmu);
+	rvpmu_sbi_stop_hw_ctrs(pmu);
 
 	/* Overflow status register should only be read after counter are stopped */
 	ALT_SBI_PMU_OVERFLOW(overflow);
@@ -755,13 +757,55 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
 		}
 	}
 
-	pmu_sbi_start_overflow_mask(pmu, overflowed_ctrs);
+	rvpmu_sbi_start_overflow_mask(pmu, overflowed_ctrs);
 	perf_sample_event_took(sched_clock() - start_clock);
 
 	return IRQ_HANDLED;
 }
 
-static int pmu_sbi_starting_cpu(unsigned int cpu, struct hlist_node *node)
+static void rvpmu_ctr_start(struct perf_event *event, u64 ival)
+{
+	rvpmu_sbi_ctr_start(event, ival);
+	/* TODO: Counter delegation implementation */
+}
+
+static void rvpmu_ctr_stop(struct perf_event *event, unsigned long flag)
+{
+	rvpmu_sbi_ctr_stop(event, flag);
+	/* TODO: Counter delegation implementation */
+}
+
+static int rvpmu_find_num_ctrs(void)
+{
+	return rvpmu_sbi_find_num_ctrs();
+	/* TODO: Counter delegation implementation */
+}
+
+static int rvpmu_get_ctrinfo(int nctr, unsigned long *mask)
+{
+	return rvpmu_sbi_get_ctrinfo(nctr, mask);
+	/* TODO: Counter delegation implementation */
+}
+
+static int rvpmu_event_map(struct perf_event *event, u64 *econfig)
+{
+	return rvpmu_sbi_event_map(event, econfig);
+	/* TODO: Counter delegation implementation */
+}
+
+static int rvpmu_ctr_get_idx(struct perf_event *event)
+{
+	return rvpmu_sbi_ctr_get_idx(event);
+	/* TODO: Counter delegation implementation */
+}
+
+static u64 rvpmu_ctr_read(struct perf_event *event)
+{
+	return rvpmu_sbi_ctr_read(event);
+	/* TODO: Counter delegation implementation */
+}
+
+static int rvpmu_starting_cpu(unsigned int cpu, struct hlist_node *node)
 {
 	struct riscv_pmu *pmu = hlist_entry_safe(node, struct riscv_pmu, node);
 	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
@@ -776,7 +820,7 @@ static int pmu_sbi_starting_cpu(unsigned int cpu, struct hlist_node *node)
 		csr_write(CSR_SCOUNTEREN, 0x2);
 
 	/* Stop all the counters so that they can be enabled from perf */
-	pmu_sbi_stop_all(pmu);
+	rvpmu_sbi_stop_all(pmu);
 
 	if (riscv_pmu_use_irq) {
 		cpu_hw_evt->irq = riscv_pmu_irq;
@@ -788,7 +832,7 @@ static int pmu_sbi_starting_cpu(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int pmu_sbi_dying_cpu(unsigned int cpu, struct hlist_node *node)
+static int rvpmu_dying_cpu(unsigned int cpu, struct hlist_node *node)
 {
 	if (riscv_pmu_use_irq) {
 		disable_percpu_irq(riscv_pmu_irq);
@@ -801,7 +845,7 @@ static int pmu_sbi_dying_cpu(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pdev)
+static int rvpmu_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pdev)
 {
 	int ret;
 	struct cpu_hw_events __percpu *hw_events = pmu->hw_events;
@@ -834,7 +878,7 @@ static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pde
 		return -ENODEV;
 	}
 
-	ret = request_percpu_irq(riscv_pmu_irq, pmu_sbi_ovf_handler, "riscv-pmu", hw_events);
+	ret = request_percpu_irq(riscv_pmu_irq, rvpmu_ovf_handler, "riscv-pmu", hw_events);
 	if (ret) {
 		pr_err("registering percpu irq failed [%d]\n", ret);
 		return ret;
@@ -904,7 +948,7 @@ static void riscv_pmu_destroy(struct riscv_pmu *pmu)
 	cpuhp_state_remove_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
 }
 
-static void pmu_sbi_event_init(struct perf_event *event)
+static void rvpmu_event_init(struct perf_event *event)
 {
 	/*
 	 * The permissions are set at event_init so that we do not depend
@@ -918,7 +962,7 @@ static void pmu_sbi_event_init(struct perf_event *event)
 		event->hw.flags |= PERF_EVENT_FLAG_LEGACY;
 }
 
-static void pmu_sbi_event_mapped(struct perf_event *event, struct mm_struct *mm)
+static void rvpmu_event_mapped(struct perf_event *event, struct mm_struct *mm)
 {
 	if (event->hw.flags & PERF_EVENT_FLAG_NO_USER_ACCESS)
 		return;
@@ -946,14 +990,14 @@ static void pmu_sbi_event_mapped(struct perf_event *event, struct mm_struct *mm)
 	 * that it is possible to do so to avoid any race.
 	 * And we must notify all cpus here because threads that currently run
 	 * on other cpus will try to directly access the counter too without
-	 * calling pmu_sbi_ctr_start.
+	 * calling rvpmu_sbi_ctr_start.
 	 */
 	if (event->hw.flags & PERF_EVENT_FLAG_USER_ACCESS)
 		on_each_cpu_mask(mm_cpumask(mm),
-				 pmu_sbi_set_scounteren, (void *)event, 1);
+				 rvpmu_set_scounteren, (void *)event, 1);
 }
 
-static void pmu_sbi_event_unmapped(struct perf_event *event, struct mm_struct *mm)
+static void rvpmu_event_unmapped(struct perf_event *event, struct mm_struct *mm)
 {
 	if (event->hw.flags & PERF_EVENT_FLAG_NO_USER_ACCESS)
 		return;
@@ -975,7 +1019,7 @@ static void pmu_sbi_event_unmapped(struct perf_event *event, struct mm_struct *m
 
 	if (event->hw.flags & PERF_EVENT_FLAG_USER_ACCESS)
 		on_each_cpu_mask(mm_cpumask(mm),
-				 pmu_sbi_reset_scounteren, (void *)event, 1);
+				 rvpmu_reset_scounteren, (void *)event, 1);
 }
 
 static void riscv_pmu_update_counter_access(void *info)
@@ -1019,7 +1063,7 @@ static struct ctl_table sbi_pmu_sysctl_table[] = {
 	{ }
 };
 
-static int pmu_sbi_device_probe(struct platform_device *pdev)
+static int rvpmu_device_probe(struct platform_device *pdev)
 {
 	struct riscv_pmu *pmu = NULL;
 	int ret = -ENODEV;
@@ -1030,7 +1074,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	if (!pmu)
 		return -ENOMEM;
 
-	num_counters = pmu_sbi_find_num_ctrs();
+	num_counters = rvpmu_find_num_ctrs();
 	if (num_counters < 0) {
 		pr_err("SBI PMU extension doesn't provide any counters\n");
 		goto out_free;
@@ -1043,10 +1087,10 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	}
 
 	/* cache all the information about counters now */
-	if (pmu_sbi_get_ctrinfo(num_counters, &cmask))
+	if (rvpmu_get_ctrinfo(num_counters, &cmask))
 		goto out_free;
 
-	ret = pmu_sbi_setup_irqs(pmu, pdev);
+	ret = rvpmu_setup_irqs(pmu, pdev);
 	if (ret < 0) {
 		pr_info("Perf sampling/filtering is not supported as sscof extension is not available\n");
 		pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
@@ -1055,17 +1099,17 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 
 	pmu->pmu.attr_groups = riscv_pmu_attr_groups;
 	pmu->cmask = cmask;
-	pmu->ctr_start = pmu_sbi_ctr_start;
-	pmu->ctr_stop = pmu_sbi_ctr_stop;
-	pmu->event_map = pmu_sbi_event_map;
-	pmu->ctr_get_idx = pmu_sbi_ctr_get_idx;
-	pmu->ctr_get_width = pmu_sbi_ctr_get_width;
-	pmu->ctr_clear_idx = pmu_sbi_ctr_clear_idx;
-	pmu->ctr_read = pmu_sbi_ctr_read;
-	pmu->event_init = pmu_sbi_event_init;
-	pmu->event_mapped = pmu_sbi_event_mapped;
-	pmu->event_unmapped = pmu_sbi_event_unmapped;
-	pmu->csr_index = pmu_sbi_csr_index;
+	pmu->ctr_start = rvpmu_ctr_start;
+	pmu->ctr_stop = rvpmu_ctr_stop;
+	pmu->event_map = rvpmu_event_map;
+	pmu->ctr_get_idx = rvpmu_ctr_get_idx;
+	pmu->ctr_get_width = rvpmu_ctr_get_width;
+	pmu->ctr_clear_idx = rvpmu_ctr_clear_idx;
+	pmu->ctr_read = rvpmu_ctr_read;
+	pmu->event_init = rvpmu_event_init;
+	pmu->event_mapped = rvpmu_event_mapped;
+	pmu->event_unmapped = rvpmu_event_unmapped;
+	pmu->csr_index = rvpmu_csr_index;
 
 	ret = cpuhp_state_add_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
 	if (ret)
@@ -1091,14 +1135,14 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static struct platform_driver pmu_sbi_driver = {
-	.probe		= pmu_sbi_device_probe,
+static struct platform_driver rvpmu_driver = {
+	.probe		= rvpmu_device_probe,
 	.driver		= {
-		.name	= RISCV_PMU_SBI_PDEV_NAME,
+		.name	= RISCV_PMU_PDEV_NAME,
 	},
 };
 
-static int __init pmu_sbi_devinit(void)
+static int __init rvpmu_devinit(void)
 {
 	int ret;
 	struct platform_device *pdev;
@@ -1110,20 +1154,20 @@ static int __init pmu_sbi_devinit(void)
 
 	ret = cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
 				      "perf/riscv/pmu:starting",
-				      pmu_sbi_starting_cpu, pmu_sbi_dying_cpu);
+				      rvpmu_starting_cpu, rvpmu_dying_cpu);
 	if (ret) {
 		pr_err("CPU hotplug notifier could not be registered: %d\n",
 		       ret);
 		return ret;
 	}
 
-	ret = platform_driver_register(&pmu_sbi_driver);
+	ret = platform_driver_register(&rvpmu_driver);
 	if (ret)
 		return ret;
 
-	pdev = platform_device_register_simple(RISCV_PMU_SBI_PDEV_NAME, -1, NULL, 0);
+	pdev = platform_device_register_simple(RISCV_PMU_PDEV_NAME, -1, NULL, 0);
 	if (IS_ERR(pdev)) {
-		platform_driver_unregister(&pmu_sbi_driver);
+		platform_driver_unregister(&rvpmu_driver);
 		return PTR_ERR(pdev);
 	}
 
@@ -1132,4 +1176,4 @@ static int __init pmu_sbi_devinit(void)
 
 	return ret;
 }
-device_initcall(pmu_sbi_devinit)
+device_initcall(rvpmu_devinit)
diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
index 43282e22ebe1..3d2b1d7913f3 100644
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -13,7 +13,7 @@
 #include <linux/ptrace.h>
 #include <linux/interrupt.h>
 
-#ifdef CONFIG_RISCV_PMU
+#ifdef CONFIG_RISCV_PMU_COMMON
 
 /*
  * The RISCV_MAX_COUNTERS parameter should be specified.
@@ -21,7 +21,7 @@
 
 #define RISCV_MAX_COUNTERS	64
 #define RISCV_OP_UNSUPP		(-EOPNOTSUPP)
-#define RISCV_PMU_SBI_PDEV_NAME	"riscv-pmu-sbi"
+#define RISCV_PMU_PDEV_NAME	"riscv-pmu"
 #define RISCV_PMU_LEGACY_PDEV_NAME	"riscv-pmu-legacy"
 
 #define RISCV_PMU_STOP_FLAG_RESET 1
@@ -79,10 +79,10 @@ void riscv_pmu_legacy_skip_init(void);
 static inline void riscv_pmu_legacy_skip_init(void) {};
 #endif
 struct riscv_pmu *riscv_pmu_alloc(void);
-#ifdef CONFIG_RISCV_PMU_SBI
+#ifdef CONFIG_RISCV_PMU
 int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr);
 #endif
 
-#endif /* CONFIG_RISCV_PMU */
+#endif /* CONFIG_RISCV_PMU_COMMON */
 
 #endif /* _RISCV_PMU_H */
-- 
2.34.1


