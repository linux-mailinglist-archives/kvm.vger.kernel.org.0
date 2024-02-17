Return-Path: <kvm+bounces-8932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D4F858C53
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D98711F2251D
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB092C1B9;
	Sat, 17 Feb 2024 00:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="0pz4NuHu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D57623755
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131532; cv=none; b=c78WU8XloIMOe622jD4jzSAxYTlf6c2L+RjqnJkzk0DtGbzRKDuDhdj2LnurQoTi/8D/uZWaDNLAVVE6nUxUCiSEjdWJ+bSYkiPV5itJeG7WF4LPvzerP7ejoFG5r8JDOAAu906UsGKRgQKZhClX03ZGV+sho67NqPtloH6WQfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131532; c=relaxed/simple;
	bh=J/nUjSpDDRlWKOd+glSKUmQVTgB87Hi4aIJEf0ePzoM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QeVE3b+hwEnxCake1nQLig7u0mH0Ur+KYNrezFVzULNfLAV+JN1VTA72k5Xq4fUJulmhM26jfPOxs4O/9ktUvUA+0sk/h9Ojq3CWlu3Vk7bOsk3/WCHaBqaKVFNabPb3soyfP3t3kZ/Kr1hZwr9tQ6Jc7meYWpDBfXykjYwUEiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=0pz4NuHu; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-214def5da12so746547fac.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131528; x=1708736328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HfeB7JYlXDGaZw65RVXErpfWL8gtCGpiY1jb8zlR4wA=;
        b=0pz4NuHuXakKwKcMx6qJLQRNeWKPjhCtPoO/1M5yjsPK5d33JOBcxE9+OJ/ag2H48Q
         MgkbFWoe0sN6fFlt1Wt+BDahFkhliHWIJVWEZFWk9c37KtmRa3WMBACt7wYzxPUCDfqY
         ItYR4zi/ZpkQIMzS6RS4mPJ3tlFq36hsrpfYIuYoKHoeWHAJyzYfPdSzFr455QbjVcTm
         giA1MvjvFMnnWFYeP7fzrD8/IilUtROK+QBgb7cpyxpytkcpUpIcRAxOohdO1i9Sqh+z
         5M1raTrbKZOAa5N2zQNxMS22Jwv0Oby1/MjmTgNsA+PQ/0aGTFH38yA7u3ccP5M2bhie
         c1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131528; x=1708736328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HfeB7JYlXDGaZw65RVXErpfWL8gtCGpiY1jb8zlR4wA=;
        b=dD33SX35YCuHFYk6Qyd02/J3fghofhyJUi0LI6MPFsnvT7porEbwVtvnhidOCc4qiz
         QnVVnvPwYG6Mu360VH/WsiyDSUNwHBzyDzwLFFsUhX8d98KNRxvJUXJ6CrCBrBtltVPE
         nC2x9Px8j6kAk06usndQup33SxeJ1hMa86ivWjUn8s05dbbOp13P0xsCLhBd4ijsaQMy
         FkAFKAEKVHD0Y65GMg3FTbjW5ChRyXyRWwV0j7jM9knaMWNw87T1VrSaWMN59Pjt147I
         VLcnMaRz2j0gZUmVM9NEBVyvPfrIQBzLsEMl5Q//Ee48E2bHs92SEchlIkPt+uvyOGdx
         FY6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWVmvb3cxn6wKGBOPs4GfvzOTGG6EJtEdlLA4pezgBtZ/J/2bi0RvCGoQuUGwhwdTzqVZzeCbKMklz2WGJ5YR98CcnF
X-Gm-Message-State: AOJu0Ywctn12qUSQ8g6btp8HX3C25Nzp++P5I9jMCfrALxNA9vKCWvaO
	yFkLD3jVcftcpkioCQ0r3KsjBuFmrzddADbCPUnPaogJbuFVoApUpUN8RRpSz+c=
X-Google-Smtp-Source: AGHT+IFFZ3X88HR6RYt1MMNPiWVJNj8Aa/iDSy7euok8DzEZ8WyuLJr/udPPXDrFxWGsgBos41HN4g==
X-Received: by 2002:a05:6870:d88d:b0:218:df68:87b2 with SMTP id oe13-20020a056870d88d00b00218df6887b2mr6753363oac.44.1708131528256;
        Fri, 16 Feb 2024 16:58:48 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:47 -0800 (PST)
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
Subject: [PATCH RFC 13/20] RISC-V: perf: Implement supervisor counter delegation support
Date: Fri, 16 Feb 2024 16:57:31 -0800
Message-Id: <20240217005738.3744121-14-atishp@rivosinc.com>
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

There are few new RISC-V ISA exensions (ssccfg, sscsrind, smcntrpmf) which
allows the hpmcounter/hpmevents to be programmed directly from S-mode. The
implementation detects the ISA extension at runtime and uses them if
available instead of SBI PMU extension. SBI PMU extension will still be
used for firmware counters if the user requests it.

The current linux driver relies on event encoding defined by SBI PMU
specification for standard perf events. However, there are no standard
event encoding available in the ISA. In the future, we may want to
decouple the counter delegation and SBI PMU completely. In that case,
counter delegation supported platforms must rely on the event encoding
defined in the perf json file only.

For firmware events, it will continue to use the SBI PMU encoding as
one can not support firmware event without SBI PMU.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/csr.h   |   1 +
 arch/riscv/include/asm/sbi.h   |   2 +-
 arch/riscv/kvm/vcpu_pmu.c      |   2 +-
 drivers/perf/riscv_pmu_dev.c   | 428 ++++++++++++++++++++++++++++-----
 include/linux/perf/riscv_pmu.h |   3 +
 5 files changed, 369 insertions(+), 67 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index e1bf1466f32e..efcd956c517a 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -239,6 +239,7 @@
 #endif
 
 #define SISELECT_SSCCFG_BASE		0x40
+#define HPMEVENT_MASK			GENMASK_ULL(63, 56)
 
 /* symbolic CSR names: */
 #define CSR_CYCLE		0xc00
diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 6e68f8dff76b..ad0c8a686d6c 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -147,7 +147,7 @@ union sbi_pmu_ctr_info {
 	};
 };
 
-#define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
+#define RISCV_PMU_SBI_RAW_EVENT_MASK GENMASK_ULL(47, 0)
 #define RISCV_PMU_RAW_EVENT_IDX 0x20000
 
 /** General pmu event codes specified in SBI PMU extension */
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 86391a5061dd..4c9502a79a54 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -125,7 +125,7 @@ static u64 kvm_pmu_get_perf_event_config(unsigned long eidx, uint64_t evt_data)
 		config = kvm_pmu_get_perf_event_cache_config(ecode);
 		break;
 	case SBI_PMU_EVENT_TYPE_RAW:
-		config = evt_data & RISCV_PMU_RAW_EVENT_MASK;
+		config = evt_data & RISCV_PMU_SBI_RAW_EVENT_MASK;
 		break;
 	case SBI_PMU_EVENT_TYPE_FW:
 		if (ecode < SBI_PMU_FW_MAX)
diff --git a/drivers/perf/riscv_pmu_dev.c b/drivers/perf/riscv_pmu_dev.c
index dfc0ddee9da4..0cdad0dafb71 100644
--- a/drivers/perf/riscv_pmu_dev.c
+++ b/drivers/perf/riscv_pmu_dev.c
@@ -23,6 +23,8 @@
 #include <asm/errata_list.h>
 #include <asm/sbi.h>
 #include <asm/cpufeature.h>
+#include <asm/hwcap.h>
+#include <asm/csr_ind.h>
 
 #define SYSCTL_NO_USER_ACCESS	0
 #define SYSCTL_USER_ACCESS	1
@@ -32,7 +34,20 @@
 #define PERF_EVENT_FLAG_USER_ACCESS	BIT(SYSCTL_USER_ACCESS)
 #define PERF_EVENT_FLAG_LEGACY		BIT(SYSCTL_LEGACY)
 
-PMU_FORMAT_ATTR(event, "config:0-47");
+#define RVPMU_SBI_PMU_FORMAT_ATTR	"config:0-47"
+#define RVPMU_CDELEG_PMU_FORMAT_ATTR	"config:0-55"
+
+static ssize_t __maybe_unused rvpmu_format_show(struct device *dev,
+			struct device_attribute *attr, char *buf);
+
+#define RVPMU_ATTR_ENTRY(_name, _func, _config)	(			\
+	&((struct dev_ext_attribute[]) {				\
+		{ __ATTR(_name, 0444, _func, NULL), (void *)_config }	\
+	})[0].attr.attr)
+
+#define RVPMU_FORMAT_ATTR_ENTRY(_name, _config) \
+	RVPMU_ATTR_ENTRY(_name, rvpmu_format_show, (char *)_config)
+
 PMU_FORMAT_ATTR(firmware, "config:63");
 
 static DEFINE_STATIC_KEY_FALSE(riscv_pmu_sbi_available);
@@ -40,19 +55,35 @@ static DEFINE_STATIC_KEY_FALSE(riscv_pmu_cdeleg_available);
 static bool cdeleg_available;
 static bool sbi_available;
 
-static struct attribute *riscv_arch_formats_attr[] = {
-	&format_attr_event.attr,
+static struct attribute *riscv_sbi_pmu_formats_attr[] = {
+	RVPMU_FORMAT_ATTR_ENTRY(event, RVPMU_SBI_PMU_FORMAT_ATTR),
+	&format_attr_firmware.attr,
+	NULL,
+};
+
+static struct attribute_group riscv_sbi_pmu_format_group = {
+	.name = "format",
+	.attrs = riscv_sbi_pmu_formats_attr,
+};
+
+static const struct attribute_group *riscv_sbi_pmu_attr_groups[] = {
+	&riscv_sbi_pmu_format_group,
+	NULL,
+};
+
+static struct attribute *riscv_cdeleg_pmu_formats_attr[] = {
+	RVPMU_FORMAT_ATTR_ENTRY(event, RVPMU_CDELEG_PMU_FORMAT_ATTR),
 	&format_attr_firmware.attr,
 	NULL,
 };
 
-static struct attribute_group riscv_pmu_format_group = {
+static struct attribute_group riscv_cdeleg_pmu_format_group = {
 	.name = "format",
-	.attrs = riscv_arch_formats_attr,
+	.attrs = riscv_cdeleg_pmu_formats_attr,
 };
 
-static const struct attribute_group *riscv_pmu_attr_groups[] = {
-	&riscv_pmu_format_group,
+static const struct attribute_group *riscv_cdeleg_pmu_attr_groups[] = {
+	&riscv_cdeleg_pmu_format_group,
 	NULL,
 };
 
@@ -275,6 +306,14 @@ static const struct sbi_pmu_event_data pmu_cache_event_map[PERF_COUNT_HW_CACHE_M
 	},
 };
 
+static ssize_t rvpmu_format_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *eattr = container_of(attr,
+				struct dev_ext_attribute, attr);
+	return sysfs_emit(buf, "%s\n", (char *)eattr->var);
+}
+
 static int rvpmu_ctr_get_width(int idx)
 {
 	return pmu_ctr_list[idx].width;
@@ -327,6 +366,39 @@ static uint8_t rvpmu_csr_index(struct perf_event *event)
 	return pmu_ctr_list[event->hw.idx].csr - CSR_CYCLE;
 }
 
+static uint64_t get_deleg_priv_filter_bits(struct perf_event *event)
+{
+	uint64_t priv_filter_bits = 0;
+	bool guest_events = false;
+
+	if (event->attr.config1 & RISCV_PMU_CONFIG1_GUEST_EVENTS)
+		guest_events = true;
+	if (event->attr.exclude_kernel)
+		priv_filter_bits |= guest_events ? HPMEVENT_VSINH : HPMEVENT_SINH;
+	if (event->attr.exclude_user)
+		priv_filter_bits |= guest_events ? HPMEVENT_VUINH : HPMEVENT_UINH;
+	if (guest_events && event->attr.exclude_hv)
+		priv_filter_bits |= HPMEVENT_SINH;
+	if (event->attr.exclude_host)
+		priv_filter_bits |= HPMEVENT_UINH | HPMEVENT_SINH;
+	if (event->attr.exclude_guest)
+		priv_filter_bits |= HPMEVENT_VSINH | HPMEVENT_VUINH;
+
+
+	return priv_filter_bits;
+}
+
+static bool pmu_sbi_is_fw_event(struct perf_event *event)
+{
+	u32 type = event->attr.type;
+	u64 config = event->attr.config;
+
+	if ((type == PERF_TYPE_RAW) && ((config >> 63) == 1))
+		return true;
+	else
+		return false;
+}
+
 static unsigned long rvpmu_sbi_get_filter_flags(struct perf_event *event)
 {
 	unsigned long cflags = 0;
@@ -355,7 +427,8 @@ static int rvpmu_sbi_ctr_get_idx(struct perf_event *event)
 	struct cpu_hw_events *cpuc = this_cpu_ptr(rvpmu->hw_events);
 	struct sbiret ret;
 	int idx;
-	uint64_t cbase = 0, cmask = rvpmu->cmask;
+	uint64_t cbase = 0;
+	unsigned long ctr_mask = rvpmu->cmask;
 	unsigned long cflags = 0;
 
 	cflags = rvpmu_sbi_get_filter_flags(event);
@@ -368,21 +441,24 @@ static int rvpmu_sbi_ctr_get_idx(struct perf_event *event)
 	if (hwc->flags & PERF_EVENT_FLAG_LEGACY) {
 		if (event->attr.config == PERF_COUNT_HW_CPU_CYCLES) {
 			cflags |= SBI_PMU_CFG_FLAG_SKIP_MATCH;
-			cmask = 1;
+			ctr_mask = 1;
 		} else if (event->attr.config == PERF_COUNT_HW_INSTRUCTIONS) {
 			cflags |= SBI_PMU_CFG_FLAG_SKIP_MATCH;
-			cmask = 1UL << (CSR_INSTRET - CSR_CYCLE);
+			ctr_mask = 1UL << (CSR_INSTRET - CSR_CYCLE);
 		}
 	}
 
+	if (pmu_sbi_is_fw_event(event) && cdeleg_available)
+		ctr_mask = firmware_cmask;
+
 	/* retrieve the available counter index */
 #if defined(CONFIG_32BIT)
 	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase,
-			cmask, cflags, hwc->event_base, hwc->config,
+			ctr_mask, cflags, hwc->event_base, hwc->config,
 			hwc->config >> 32);
 #else
 	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase,
-			cmask, cflags, hwc->event_base, hwc->config, 0);
+			ctr_mask, cflags, hwc->event_base, hwc->config, 0);
 #endif
 	if (ret.error) {
 		pr_debug("Not able to find a counter for event %lx config %llx\n",
@@ -391,7 +467,7 @@ static int rvpmu_sbi_ctr_get_idx(struct perf_event *event)
 	}
 
 	idx = ret.value;
-	if (!test_bit(idx, &rvpmu->cmask) || !pmu_ctr_list[idx].value)
+	if (!test_bit(idx, &ctr_mask) || !pmu_ctr_list[idx].value)
 		return -ENOENT;
 
 	/* Additional sanity check for the counter id */
@@ -441,15 +517,20 @@ static int pmu_event_find_cache(u64 config)
 	return ret;
 }
 
-static bool pmu_sbi_is_fw_event(struct perf_event *event)
+static int rvpmu_deleg_event_map(struct perf_event *event, u64 *econfig)
 {
-	u32 type = event->attr.type;
 	u64 config = event->attr.config;
 
-	if ((type == PERF_TYPE_RAW) && ((config >> 63) == 1))
-		return true;
-	else
-		return false;
+	/*
+	 * The Perf tool for RISC-V is expected to remap the standard perf event to platform
+	 * specific encoding if counter delegation extension is present.
+	 * Thus, the mapped value should be event encoding value specified in the userspace
+	 * There is no additional mapping/validation can be done in the driver.
+	 */
+	*econfig = config & RISCV_PMU_DELEG_RAW_EVENT_MASK;
+
+	/* event_base is not used for counter delegation config is sufficient for event encoding */
+	return 0;
 }
 
 static int rvpmu_sbi_event_map(struct perf_event *event, u64 *econfig)
@@ -476,7 +557,7 @@ static int rvpmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 		 * raw event and firmware events.
 		 */
 		bSoftware = config >> 63;
-		raw_config_val = config & RISCV_PMU_RAW_EVENT_MASK;
+		raw_config_val = config & RISCV_PMU_SBI_RAW_EVENT_MASK;
 		if (bSoftware) {
 			ret = (raw_config_val & 0xFFFF) |
 				(SBI_PMU_EVENT_TYPE_FW << 16);
@@ -493,7 +574,7 @@ static int rvpmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 	return ret;
 }
 
-static u64 rvpmu_sbi_ctr_read(struct perf_event *event)
+static u64 rvpmu_ctr_read(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
@@ -550,10 +631,6 @@ static void rvpmu_sbi_ctr_start(struct perf_event *event, u64 ival)
 	if (ret.error && (ret.error != SBI_ERR_ALREADY_STARTED))
 		pr_err("Starting counter idx %d failed with error %d\n",
 			hwc->idx, sbi_err_map_linux_errno(ret.error));
-
-	if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
-	    (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
-		rvpmu_set_scounteren((void *)event);
 }
 
 static void rvpmu_sbi_ctr_stop(struct perf_event *event, unsigned long flag)
@@ -561,10 +638,6 @@ static void rvpmu_sbi_ctr_stop(struct perf_event *event, unsigned long flag)
 	struct sbiret ret;
 	struct hw_perf_event *hwc = &event->hw;
 
-	if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
-	    (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
-		rvpmu_reset_scounteren((void *)event);
-
 	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, hwc->idx, 1, flag, 0, 0, 0);
 	if (ret.error && (ret.error != SBI_ERR_ALREADY_STOPPED) &&
 		flag != SBI_PMU_STOP_FLAG_RESET)
@@ -583,12 +656,6 @@ static int rvpmu_sbi_find_num_ctrs(void)
 		return sbi_err_map_linux_errno(ret.error);
 }
 
-static int rvpmu_deleg_find_ctrs(void)
-{
-	/* TODO */
-	return -1;
-}
-
 static int rvpmu_sbi_get_ctrinfo(int nsbi_ctr, int ndeleg_ctr)
 {
 	struct sbiret ret;
@@ -647,19 +714,85 @@ static inline void rvpmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
 		  cpu_hw_evt->used_hw_ctrs[0], 0, 0, 0, 0);
 }
 
+static void rvpmu_deleg_ctr_start_mask(unsigned long mask)
+{
+	unsigned long scountinhibit_val = 0;
+
+	scountinhibit_val = csr_read(CSR_SCOUNTINHIBIT);
+	scountinhibit_val &= ~mask;
+
+	csr_write(CSR_SCOUNTINHIBIT, scountinhibit_val);
+}
+
+static void rvpmu_deleg_ctr_enable_irq(struct perf_event *event)
+{
+	unsigned long hpmevent_curr;
+	unsigned long of_mask;
+	struct hw_perf_event *hwc = &event->hw;
+	int counter_idx = hwc->idx;
+	unsigned long sip_val = csr_read(CSR_SIP);
+
+	if (!is_sampling_event(event) || (sip_val & SIP_LCOFIP))
+		return;
+
+#if defined(CONFIG_32BIT)
+	hpmevent_curr = csr_ind_read(CSR_SIREG5, SISELECT_SSCCFG_BASE, counter_idx);
+	of_mask = (u32)~HPMEVENTH_OF;
+#else
+	hpmevent_curr = csr_ind_read(CSR_SIREG2, SISELECT_SSCCFG_BASE, counter_idx);
+	of_mask = ~HPMEVENT_OF;
+#endif
+
+	hpmevent_curr &= of_mask;
+#if defined(CONFIG_32BIT)
+	csr_ind_write(CSR_SIREG4, SISELECT_SSCCFG_BASE, counter_idx, hpmevent_curr);
+#else
+	csr_ind_write(CSR_SIREG2, SISELECT_SSCCFG_BASE, counter_idx, hpmevent_curr);
+#endif
+}
+
+static void rvpmu_deleg_ctr_start(struct perf_event *event, u64 ival)
+{
+	unsigned long scountinhibit_val = 0;
+	struct hw_perf_event *hwc = &event->hw;
+
+#if defined(CONFIG_32BIT)
+	csr_ind_write(CSR_SIREG, SISELECT_SSCCFG_BASE, hwc->idx, ival & 0xFFFFFFFF);
+	csr_ind_write(CSR_SIREG4, SISELECT_SSCCFG_BASE, hwc->idx, ival >> BITS_PER_LONG);
+#else
+	csr_ind_write(CSR_SIREG, SISELECT_SSCCFG_BASE, hwc->idx, ival);
+#endif
+
+	rvpmu_deleg_ctr_enable_irq(event);
+
+	scountinhibit_val = csr_read(CSR_SCOUNTINHIBIT);
+	scountinhibit_val &= ~(1 << hwc->idx);
+
+	csr_write(CSR_SCOUNTINHIBIT, scountinhibit_val);
+}
+
+static void rvpmu_deleg_ctr_stop_mask(unsigned long mask)
+{
+	unsigned long scountinhibit_val = 0;
+
+	scountinhibit_val = csr_read(CSR_SCOUNTINHIBIT);
+	scountinhibit_val |= mask;
+
+	csr_write(CSR_SCOUNTINHIBIT, scountinhibit_val);
+}
+
 /*
  * This function starts all the used counters in two step approach.
  * Any counter that did not overflow can be start in a single step
  * while the overflowed counters need to be started with updated initialization
  * value.
  */
-static inline void rvpmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
+static inline void rvpmu_start_overflow_mask(struct riscv_pmu *pmu,
 					       unsigned long ctr_ovf_mask)
 {
 	int idx = 0;
 	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
 	struct perf_event *event;
-	unsigned long flag = SBI_PMU_START_FLAG_SET_INIT_VALUE;
 	unsigned long ctr_start_mask = 0;
 	uint64_t max_period;
 	struct hw_perf_event *hwc;
@@ -667,9 +800,12 @@ static inline void rvpmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
 
 	ctr_start_mask = cpu_hw_evt->used_hw_ctrs[0] & ~ctr_ovf_mask;
 
-	/* Start all the counters that did not overflow in a single shot */
-	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, 0, ctr_start_mask,
-		  0, 0, 0, 0);
+	if (static_branch_likely(&riscv_pmu_cdeleg_available))
+		rvpmu_deleg_ctr_start_mask(ctr_start_mask);
+	else
+		/* Start all the counters that did not overflow in a single shot */
+		sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, 0, ctr_start_mask,
+			  0, 0, 0, 0);
 
 	/* Reinitialize and start all the counter that overflowed */
 	while (ctr_ovf_mask) {
@@ -678,13 +814,10 @@ static inline void rvpmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
 			hwc = &event->hw;
 			max_period = riscv_pmu_ctr_get_width_mask(event);
 			init_val = local64_read(&hwc->prev_count) & max_period;
-#if defined(CONFIG_32BIT)
-			sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, idx, 1,
-				  flag, init_val, init_val >> 32, 0);
-#else
-			sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, idx, 1,
-				  flag, init_val, 0, 0);
-#endif
+			if (static_branch_likely(&riscv_pmu_cdeleg_available))
+				rvpmu_deleg_ctr_start(event, init_val);
+			else
+				rvpmu_sbi_ctr_start(event, init_val);
 			perf_event_update_userpage(event);
 		}
 		ctr_ovf_mask = ctr_ovf_mask >> 1;
@@ -723,7 +856,10 @@ static irqreturn_t rvpmu_ovf_handler(int irq, void *dev)
 	}
 
 	pmu = to_riscv_pmu(event->pmu);
-	rvpmu_sbi_stop_hw_ctrs(pmu);
+	if (static_branch_likely(&riscv_pmu_cdeleg_available))
+		rvpmu_deleg_ctr_stop_mask(cpu_hw_evt->used_hw_ctrs[0]);
+	else
+		rvpmu_sbi_stop_hw_ctrs(pmu);
 
 	/* Overflow status register should only be read after counter are stopped */
 	ALT_SBI_PMU_OVERFLOW(overflow);
@@ -779,22 +915,174 @@ static irqreturn_t rvpmu_ovf_handler(int irq, void *dev)
 		}
 	}
 
-	rvpmu_sbi_start_overflow_mask(pmu, overflowed_ctrs);
+	rvpmu_start_overflow_mask(pmu, overflowed_ctrs);
 	perf_sample_event_took(sched_clock() - start_clock);
 
 	return IRQ_HANDLED;
 }
 
+static int get_deleg_hw_ctr_width(int counter_offset)
+{
+	unsigned long hpm_warl;
+	int num_bits;
+
+	if (counter_offset < 3 || counter_offset > 31)
+		return 0;
+
+	hpm_warl = csr_ind_warl(CSR_SIREG, SISELECT_SSCCFG_BASE, counter_offset, -1);
+	num_bits = __fls(hpm_warl);
+
+#if defined(CONFIG_32BIT)
+	hpm_warl = csr_ind_warl(CSR_SIREG4, SISELECT_SSCCFG_BASE, counter_offset, -1);
+	num_bits += __fls(hpm_warl);
+#endif
+	return num_bits;
+}
+
+static int rvpmu_deleg_find_ctrs(void)
+{
+	int i, num_hw_ctr = 0;
+	union sbi_pmu_ctr_info cinfo;
+	unsigned long scountinhibit_old = 0;
+
+	/* Do a WARL write/read to detect which hpmcounters have been delegated */
+	scountinhibit_old = csr_read(CSR_SCOUNTINHIBIT);
+	csr_write(CSR_SCOUNTINHIBIT, -1);
+	cmask = csr_read(CSR_SCOUNTINHIBIT);
+
+	csr_write(CSR_SCOUNTINHIBIT, scountinhibit_old);
+
+	for_each_set_bit(i, &cmask, RISCV_MAX_HW_COUNTERS) {
+		if (unlikely(i == 1))
+			continue; /* This should never happen as TM is read only */
+		cinfo.value = 0;
+		cinfo.type = SBI_PMU_CTR_TYPE_HW;
+		/*
+		 * If counter delegation is enabled, the csr stored to the cinfo will
+		 * be a virtual counter that the delegation attempts to read.
+		 */
+		cinfo.csr = CSR_CYCLE + i;
+		if (i == 0 || i == 2)
+			cinfo.width = 63;
+		else
+			cinfo.width = get_deleg_hw_ctr_width(i) - 1;
+
+		num_hw_ctr++;
+		pmu_ctr_list[i].value = cinfo.value;
+	}
+
+	return num_hw_ctr;
+}
+
+static int get_deleg_fixed_hw_idx(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	return -EINVAL;
+}
+
+static int get_deleg_next_hpm_hw_idx(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	unsigned long hw_ctr_mask = 0;
+
+	/*
+	 * TODO: Treat every hpmcounter can monitor every event for now.
+	 * The event to counter mapping should come from the json file.
+	 * The mapping should also tell if sampling is supported or not.
+	 */
+
+	/* Select only hpmcounters */
+	hw_ctr_mask = cmask & (~0x7);
+	hw_ctr_mask &= ~(cpuc->used_hw_ctrs[0]);
+	return __ffs(hw_ctr_mask);
+}
+
+static void update_deleg_hpmevent(int counter_idx, uint64_t event_value, uint64_t filter_bits)
+{
+	uint64_t hpmevent_value = 0;
+
+	/* OF bit should be enable during the start if sampling is requested */
+	hpmevent_value = (event_value & ~HPMEVENT_MASK) | filter_bits | HPMEVENT_OF;
+#if defined(CONFIG_32BIT)
+	csr_ind_write(CSR_SIREG2, SISELECT_SSCCFG_BASE, counter_idx, hpmevent_value & 0xFFFFFFFF);
+	if (riscv_isa_extension_available(NULL, SSCOFPMF))
+		csr_ind_write(CSR_SIREG5, SISELECT_SSCCFG_BASE, counter_idx,
+			      hpmevent_value >> BITS_PER_LONG);
+#else
+	csr_ind_write(CSR_SIREG2, SISELECT_SSCCFG_BASE, counter_idx, hpmevent_value);
+#endif
+}
+
+static int rvpmu_deleg_ctr_get_idx(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct riscv_pmu *rvpmu = to_riscv_pmu(event->pmu);
+	struct cpu_hw_events *cpuc = this_cpu_ptr(rvpmu->hw_events);
+	unsigned long hw_ctr_max_id;
+	uint64_t priv_filter;
+	int idx;
+
+	/*
+	 * TODO: We should not rely on SBI Perf encoding to check if the event
+	 * is a fixed one or not.
+	 */
+	if (!is_sampling_event(event)) {
+		idx = get_deleg_fixed_hw_idx(cpuc, event);
+		if (idx == 0 || idx == 2) {
+			/* Priv mode filter bits are only available if smcntrpmf is present */
+			if (riscv_isa_extension_available(NULL, SMCNTRPMF))
+				goto found_idx;
+			else
+				goto skip_update;
+		}
+	}
+
+	hw_ctr_max_id = __fls(cmask);
+	idx = get_deleg_next_hpm_hw_idx(cpuc, event);
+	if (idx < 3 || idx > hw_ctr_max_id)
+		goto out_err;
+found_idx:
+	priv_filter = get_deleg_priv_filter_bits(event);
+	update_deleg_hpmevent(idx, hwc->config, priv_filter);
+skip_update:
+	if (!test_and_set_bit(idx, cpuc->used_hw_ctrs))
+		return idx;
+out_err:
+	return -ENOENT;
+}
+
 static void rvpmu_ctr_start(struct perf_event *event, u64 ival)
 {
-	rvpmu_sbi_ctr_start(event, ival);
-	/* TODO: Counter delegation implementation */
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (static_branch_likely(&riscv_pmu_cdeleg_available) && !pmu_sbi_is_fw_event(event))
+		rvpmu_deleg_ctr_start(event, ival);
+	else
+		rvpmu_sbi_ctr_start(event, ival);
+
+
+	if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
+	    (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
+		rvpmu_set_scounteren((void *)event);
 }
 
 static void rvpmu_ctr_stop(struct perf_event *event, unsigned long flag)
 {
-	rvpmu_sbi_ctr_stop(event, flag);
-	/* TODO: Counter delegation implementation */
+	struct hw_perf_event *hwc = &event->hw;
+
+	if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
+	    (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
+		rvpmu_reset_scounteren((void *)event);
+
+	if (static_branch_likely(&riscv_pmu_cdeleg_available) &&
+	    !pmu_sbi_is_fw_event(event)) {
+		/*
+		 * The counter is already stopped. No need to stop again. Counter
+		 * mapping will be reset in clear_idx function.
+		 */
+		if (flag != RISCV_PMU_STOP_FLAG_RESET)
+			rvpmu_deleg_ctr_stop_mask((1 << hwc->idx));
+	} else {
+		rvpmu_sbi_ctr_stop(event, flag);
+	}
 }
 
 static int rvpmu_find_ctrs(void)
@@ -828,20 +1116,18 @@ static int rvpmu_find_ctrs(void)
 
 static int rvpmu_event_map(struct perf_event *event, u64 *econfig)
 {
-	return rvpmu_sbi_event_map(event, econfig);
-	/* TODO: Counter delegation implementation */
+	if (static_branch_likely(&riscv_pmu_cdeleg_available) && !pmu_sbi_is_fw_event(event))
+		return rvpmu_deleg_event_map(event, econfig);
+	else
+		return rvpmu_sbi_event_map(event, econfig);
 }
 
 static int rvpmu_ctr_get_idx(struct perf_event *event)
 {
-	return rvpmu_sbi_ctr_get_idx(event);
-	/* TODO: Counter delegation implementation */
-}
-
-static u64 rvpmu_ctr_read(struct perf_event *event)
-{
-	return rvpmu_sbi_ctr_read(event);
-	/* TODO: Counter delegation implementation */
+	if (static_branch_likely(&riscv_pmu_cdeleg_available) && !pmu_sbi_is_fw_event(event))
+		return rvpmu_deleg_ctr_get_idx(event);
+	else
+		return rvpmu_sbi_ctr_get_idx(event);
 }
 
 static int rvpmu_starting_cpu(unsigned int cpu, struct hlist_node *node)
@@ -859,7 +1145,16 @@ static int rvpmu_starting_cpu(unsigned int cpu, struct hlist_node *node)
 		csr_write(CSR_SCOUNTEREN, 0x2);
 
 	/* Stop all the counters so that they can be enabled from perf */
-	rvpmu_sbi_stop_all(pmu);
+	if (static_branch_likely(&riscv_pmu_cdeleg_available)) {
+		rvpmu_deleg_ctr_stop_mask(cmask);
+		if (static_branch_likely(&riscv_pmu_sbi_available)) {
+			/* Stop the firmware counters as well */
+			sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, 0, firmware_cmask,
+				0, 0, 0, 0);
+		}
+	} else {
+		rvpmu_sbi_stop_all(pmu);
+	}
 
 	if (riscv_pmu_use_irq) {
 		cpu_hw_evt->irq = riscv_pmu_irq;
@@ -1142,7 +1437,10 @@ static int rvpmu_device_probe(struct platform_device *pdev)
 		pmu->pmu.capabilities |= PERF_PMU_CAP_NO_EXCLUDE;
 	}
 
-	pmu->pmu.attr_groups = riscv_pmu_attr_groups;
+	if (cdeleg_available)
+		pmu->pmu.attr_groups = riscv_cdeleg_pmu_attr_groups;
+	else
+		pmu->pmu.attr_groups = riscv_sbi_pmu_attr_groups;
 	pmu->cmask = cmask;
 	pmu->ctr_start = rvpmu_ctr_start;
 	pmu->ctr_stop = rvpmu_ctr_stop;
diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
index 3d2b1d7913f3..f878369fecc8 100644
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -20,6 +20,7 @@
  */
 
 #define RISCV_MAX_COUNTERS	64
+#define RISCV_MAX_HW_COUNTERS	32
 #define RISCV_OP_UNSUPP		(-EOPNOTSUPP)
 #define RISCV_PMU_PDEV_NAME	"riscv-pmu"
 #define RISCV_PMU_LEGACY_PDEV_NAME	"riscv-pmu-legacy"
@@ -28,6 +29,8 @@
 
 #define RISCV_PMU_CONFIG1_GUEST_EVENTS 0x1
 
+#define RISCV_PMU_DELEG_RAW_EVENT_MASK GENMASK_ULL(55, 0)
+
 struct cpu_hw_events {
 	/* currently enabled events */
 	int			n_events;
-- 
2.34.1


