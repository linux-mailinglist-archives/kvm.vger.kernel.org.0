Return-Path: <kvm+bounces-36737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F1DA203C9
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:05:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D38F163193
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 719701F8EF9;
	Tue, 28 Jan 2025 05:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="WXFezE8B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D60B1F8687
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040419; cv=none; b=fOMkuvN2/MKXuhqJfuxqKl2tO9Ru56AxsyecM6F9egOPncv75u0RVsLEnjbSj7qNvSEQmocIxYWc6fWaZhtR2epAhfO1wiXCxEKLm4nGsJhQZWiDdfiqrBDivgtLBa+8ehwV7szZ4T/EMJhVB8sv0Tm7nlLsJ2uPH2FBJkKPewE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040419; c=relaxed/simple;
	bh=09lWzd/6dCgnZxyO1zDKn3zFDr4WFTaCMF6mVse96Ps=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kiFvrTB5WRsgTeD7trBbY2wqrprBRVd7e4g2Xi4WgL4mrZ2XDinFR+D/paTfXcavQh38mmN7OXI+QCQxEqzHh9YwUun6nu2CYE7zd3CVrmvxXtGhCdmp3geR+5hlYt6s3g1J5AfPv45xA0CH3cYynDZrgJMdMBZzSGnvXFXfK7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=WXFezE8B; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f43da61ba9so6862158a91.2
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040415; x=1738645215; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WwSJXYJYJ2QsfeksDYzOVoprLyqehfXihnOY7v/vL40=;
        b=WXFezE8BDMAqFakkSspMdsynQ9P0lD1Xaq++3GkLoFdYay0kdncsoiDFgPaSpJGsDN
         9KiV3sIfNmbLBGnoIrTYZ1LY8uWTDMJBTVNE3z+3d4HfeTJ5DJk6Hp6DrMiOTDhO5iv6
         4yzXYWX62XIdsubjELstgH7j2wR3JAkAv94gl0lUk2H9RtU+GE5UsOwAyYPeXJ/CGXsu
         45Ijs371f3Tiy9ssP+er9vBJF+KsMwdsAv2JSBfrEXw6ANmiRdqeYIQLlhEqVvLi8Qeq
         5cZYgJIStI6KHDX538hbRyNqUO1S08/Xk1vtC5Cs7Zx09xCy8jh+MY1v/s044MhoHEZS
         aoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040415; x=1738645215;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WwSJXYJYJ2QsfeksDYzOVoprLyqehfXihnOY7v/vL40=;
        b=lZpHBcJZI2uEZCfCalATIzLkwkUJV1QVDE1PRmCrUtrw1E87JP2YmhoRV0O1Aak/yJ
         cfGM20TjuM1B9I3SgJZFyINLde0hPj8hJESxQQ6YOcbRx+JWwZB1MAsIgA0CcLnp089O
         y9JTmVSW3zcpI8c17P+lEKjSAGR5iZ11k9AL1j0VSrstSl3msWYcZ0YAxCbCaCSCoOI5
         aPjCZvZFKtjUVc5tD8Pzcsuw/2pwrRW2m6mkVY5UIdBKJ8u7qPODe19HO+ouseroBIqA
         MOxAGjWNDK50FEphCKcCCYc6Ubhv/1onSwDrD72PM5M3UpfjN0uoXBnCEvfxMP6aNYZD
         euBw==
X-Forwarded-Encrypted: i=1; AJvYcCVLOPo5JXwDZDwXYUltJ2LvR3Kjlf8J7GzvGiWnKYfHVsqq003wiwpfQzglVRCGesQSsLA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/p/w5DZvVqSL4k6Boci01ZmiFf4uvzqkTOqP6FYOJOGr6/Eam
	4p5MP6685Oc3UsPz5LZFAd9K9rSc9+wRZwCzhFCrhIi4BbjOHShX96K5sfKkqvQ=
X-Gm-Gg: ASbGncvCcG9lMR5vSYxGzpSo4gGAPrEBX/fbOSZuCFG6X9U0ahi5N6ilvm7LRqPW/mX
	4RT/OInbph6KF4pBg/0L+YQxRiyY1M05rduI4In1oWyfCSX7nWJuqNxE8ZxpviaBuVOpW8bZNEc
	ayoPEjhgj+VA9WEE4VfpNyozlLI2d8FLyIDlqF4gzTRrsbsg3OoCowgnu72vpKR6MgMEsOMHN9y
	KbAJBr/I5L0yBmSznkqJJtmrQsNOLGMBRJSaVZcrwSRDf0ObzLow2BgOSoh8ZEYfxmI/GcnIOOU
	YogNTV2nFYaGi/O1QWQLEhTbQWTH
X-Google-Smtp-Source: AGHT+IEKLNFZOaVvDJ2grs7h9hb4mxjnaquPb5u1sc5MAJh5NiIGfsglFThj6u7Oc3KeiatM4ZLmwA==
X-Received: by 2002:a17:90b:2d48:b0:2ee:3fa7:ef4d with SMTP id 98e67ed59e1d1-2f782d4f152mr64397362a91.24.1738040415260;
        Mon, 27 Jan 2025 21:00:15 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.21.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 21:00:15 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 20:59:57 -0800
Subject: [PATCH v3 16/21] RISC-V: perf: Use config2/vendor table for event
 to counter mapping
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-16-64894d7e16d5@rivosinc.com>
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

The counter restriction specified in the json file is passed to
the drivers via config2 paarameter in perf attributes. This allows
any platform vendor to define their custom mapping between event and
hpmcounters without any rules defined in the ISA.

For legacy events, the platform vendor may define the mapping in
the driver in the vendor event table.
The fixed cycle and instruction counters are fixed (0 and 2
respectively) by the ISA and maps to the legacy events. The platform
vendor must specify this in the driver if intended to be used while
profiling. Otherwise, they can just specify the alternate hpmcounters
that may monitor and/or sample the cycle/instruction counts.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_dev.c   | 78 ++++++++++++++++++++++++++++++++++--------
 include/linux/perf/riscv_pmu.h |  2 ++
 2 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/drivers/perf/riscv_pmu_dev.c b/drivers/perf/riscv_pmu_dev.c
index 52d927576c9b..ab84f83df5e1 100644
--- a/drivers/perf/riscv_pmu_dev.c
+++ b/drivers/perf/riscv_pmu_dev.c
@@ -76,6 +76,7 @@ static ssize_t __maybe_unused rvpmu_format_show(struct device *dev, struct devic
 	RVPMU_ATTR_ENTRY(_name, rvpmu_format_show, (char *)_config)
 
 PMU_FORMAT_ATTR(firmware, "config:62-63");
+PMU_FORMAT_ATTR(counterid_mask, "config2:0-31");
 
 static bool sbi_v2_available;
 static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
@@ -112,6 +113,7 @@ static const struct attribute_group *riscv_sbi_pmu_attr_groups[] = {
 static struct attribute *riscv_cdeleg_pmu_formats_attr[] = {
 	RVPMU_FORMAT_ATTR_ENTRY(event, RVPMU_CDELEG_PMU_FORMAT_ATTR),
 	&format_attr_firmware.attr,
+	&format_attr_counterid_mask.attr,
 	NULL,
 };
 
@@ -1383,24 +1385,76 @@ static int rvpmu_deleg_find_ctrs(void)
 	return num_hw_ctr;
 }
 
+/* The json file must correctly specify counter 0 or counter 2 is available
+ * in the counter lists for cycle/instret events. Otherwise, the drivers have
+ * no way to figure out if a fixed counter must be used and pick a programmable
+ * counter if available.
+ */
 static int get_deleg_fixed_hw_idx(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
-	return -EINVAL;
+	struct hw_perf_event *hwc = &event->hw;
+	bool guest_events = event->attr.config1 & RISCV_PMU_CONFIG1_GUEST_EVENTS;
+
+	if (guest_events) {
+		if (hwc->event_base == SBI_PMU_HW_CPU_CYCLES)
+			return 0;
+		if (hwc->event_base == SBI_PMU_HW_INSTRUCTIONS)
+			return 2;
+		else
+			return -EINVAL;
+	}
+
+	if (!event->attr.config2)
+		return -EINVAL;
+
+	if (event->attr.config2 & RISCV_PMU_CYCLE_FIXED_CTR_MASK)
+		return 0; /* CY counter */
+	else if (event->attr.config2 & RISCV_PMU_INSTRUCTION_FIXED_CTR_MASK)
+		return 2; /* IR counter */
+	else
+		return -EINVAL;
 }
 
 static int get_deleg_next_hpm_hw_idx(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
-	unsigned long hw_ctr_mask = 0;
+	u32 hw_ctr_mask = 0, temp_mask = 0;
+	u32 type = event->attr.type;
+	u64 config = event->attr.config;
+	int ret;
 
-	/*
-	 * TODO: Treat every hpmcounter can monitor every event for now.
-	 * The event to counter mapping should come from the json file.
-	 * The mapping should also tell if sampling is supported or not.
-	 */
+	/* Select only available hpmcounters */
+	hw_ctr_mask = cmask & (~0x7) & ~(cpuc->used_hw_ctrs[0]);
+
+	switch (type) {
+	case PERF_TYPE_HARDWARE:
+		temp_mask = current_pmu_hw_event_map[config].counter_mask;
+		break;
+	case PERF_TYPE_HW_CACHE:
+		ret = cdeleg_pmu_event_find_cache(config, NULL, &temp_mask);
+		if (ret)
+			return ret;
+		break;
+	case PERF_TYPE_RAW:
+		/*
+		 * Mask off the counters that can't monitor this event (specified via json)
+		 * The counter mask for this event is set in config2 via the property 'Counter'
+		 * in the json file or manual configuration of config2. If the config2 is not set,
+		 * it is assumed all the available hpmcounters can monitor this event.
+		 * Note: This assumption may fail for virtualization use case where they hypervisor
+		 * (e.g. KVM) virtualizes the counter. Any event to counter mapping provided by the
+		 * guest is meaningless from a hypervisor perspective. Thus, the hypervisor doesn't
+		 * set config2 when creating kernel counter and relies default host mapping.
+		 */
+		if (event->attr.config2)
+			temp_mask = event->attr.config2;
+		break;
+	default:
+		break;
+	}
+
+	if (temp_mask)
+		hw_ctr_mask &= temp_mask;
 
-	/* Select only hpmcounters */
-	hw_ctr_mask = cmask & (~0x7);
-	hw_ctr_mask &= ~(cpuc->used_hw_ctrs[0]);
 	return __ffs(hw_ctr_mask);
 }
 
@@ -1429,10 +1483,6 @@ static int rvpmu_deleg_ctr_get_idx(struct perf_event *event)
 	u64 priv_filter;
 	int idx;
 
-	/*
-	 * TODO: We should not rely on SBI Perf encoding to check if the event
-	 * is a fixed one or not.
-	 */
 	if (!is_sampling_event(event)) {
 		idx = get_deleg_fixed_hw_idx(cpuc, event);
 		if (idx == 0 || idx == 2) {
diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
index 9e2758c32e8b..e58f83811988 100644
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -30,6 +30,8 @@
 #define RISCV_PMU_CONFIG1_GUEST_EVENTS 0x1
 
 #define RISCV_PMU_DELEG_RAW_EVENT_MASK GENMASK_ULL(55, 0)
+#define RISCV_PMU_CYCLE_FIXED_CTR_MASK 0x01
+#define RISCV_PMU_INSTRUCTION_FIXED_CTR_MASK 0x04
 
 #define HW_OP_UNSUPPORTED		0xFFFF
 #define CACHE_OP_UNSUPPORTED		0xFFFF

-- 
2.34.1


