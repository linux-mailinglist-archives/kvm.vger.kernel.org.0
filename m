Return-Path: <kvm+bounces-42150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 867E7A73EC8
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D3FB1B6044F
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6005222F3B8;
	Thu, 27 Mar 2025 19:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="obMIAQtj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA9B22CBFA
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104193; cv=none; b=M4eTWlamQqY/yqoz5zQkmY547r4ytWOID2jIck+VaA9+LbOrUdfFcsaP9Ejrzuj9OtAzpv+bdK5VwIPOcjONUfpAu/2ydUoT3Ix08SM/LuUOockxsC7RtqYeRLgY5tdFKqny5+IjeejVH0b0nsuB/ZhdAbbmLwMnYMxAQjmv3OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104193; c=relaxed/simple;
	bh=FxJQJ6PjIeTL2kHIM6ooMQ4Mcuj/izNF3sQ/CHF55wQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Sl8mcqXP93eLupqzTYDGV+GKg9QXbA81WdvsLzkkGGzTf5BQOzdhnOI0cHi6ABzd6TAvmODhldnO3OuaDKkMGhYTwwTRHVQXPVt//RFdFB3PRD0oOIHnniUwu1myeC2K8/wKx2wQdvzOg/dlqd2o/S1asM/p9xiiVP3Hn3C5zS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=obMIAQtj; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-301c4850194so1888910a91.2
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1743104190; x=1743708990; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QEfPyANpbYRBoZefiNVqWngRZRURustBhOqTRxWoYpA=;
        b=obMIAQtjdaDJjvDHiw9Di/ScySzA21Fgy1Kf+TGHEaetSAY2K6LBT134R/VPX0CufG
         6Q/ZS0Qn8Tt1o1jo7hZvAVrDianUK7QBcXeqy9zIbBw5tLDnr4tr+G2unNJuuZoOJMt1
         lE7bFm6quyShGJr+uVDKYE0fHjEKeATkp4kJo6hecuJNq9uLnmZsK+UP1ZiKT9+xPyJA
         juhJ3GTW9efG1Kog0J0an312j4EoSuuUh0SgE9TeHvB8SnIkEVyfzE/KojGczH+sX6uH
         2v0RMjL4QuwKYWMf3005yO9gaqrIFykE8kNBk0OajUihhQ4i6YTqTwGSXokqzubSepoh
         TPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104190; x=1743708990;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QEfPyANpbYRBoZefiNVqWngRZRURustBhOqTRxWoYpA=;
        b=a30TmvdkoP6BfhJ6PBfIPXM9T5Ux7vDVdLumx0DXC9Yp+YUnukL8gJNEXpuEpqyR38
         zys0a6bfqLImdmVb1SXVsViK3Rcwth+uYuAphvDTxvu+t3b9/95kRnV2Sq/C/D2iwQEN
         fJOZOopW3uheK8EBMdX4T4ZeB8zmr4eDPHclE1zXVTn0EyeXeS5rXWskb9m8JS/9oXMB
         sbECkqkoKKcXDxHmL56HLC2R1oAEN6tehQeb+ieGB5lrOQFJlQE4ihtoRC38rKk90iAy
         qXe3P4uRReMNAlTniSANh90iJ3fM2A7SDrdBomtI0h6iRrK7oMomvzejT/666CUQ11uC
         tuVA==
X-Forwarded-Encrypted: i=1; AJvYcCVWLOe+w+pTKibJ01cd1QRg43zvaoYnHIJsGI9B9mR0Z7Nb+mH9bdCHDY2huWaqOVgfci0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+3Csbni8TtMaLOIqlnYWXki/RHGbWdSoDv7grpBWcM6r2o7OC
	G21Z8DNHZo0mqvmrfCnDbpNR0z1ox5F0jVgutyN7SHRV87p/fhOqifumyGhYWPs=
X-Gm-Gg: ASbGncuj3vNc0Kkk1Dp/77h1TTwLHFwF1ReF1J0zGYjRX5C3Wk9wEynMcW4vOLJRbe4
	akUkNktANtRaYORJu+jfyjOD0rjmNdsmkPLt4gVECQ9fSXFdx/ItvC7wFTH60Nm2zIKD/ev43lt
	EwbF/c/90h9MQngowBUlGI3/I0k+a1WA7IiMj77hBSe1+0RD+dCzU4vKHP/V96/8B5tng9jmF7F
	N9p9UcknL5AEcLfySxUkhaaorQKBOuQWbStsfkZeEndLZmG42WV6koLKS2LJprCdXRV0zHBfJri
	c0Cy+LBJgZIMxV6tPVEHz2lPz4MszUe9xQ3b9vDXz7IQrZ1IIVGcEb0qfA==
X-Google-Smtp-Source: AGHT+IEOlb00xsx6qvCRvcBcJe0cR9hipMt0kCrJs6CZll3dBgknyAuS0T/5Yec9LG66BxNUt++2sA==
X-Received: by 2002:a17:90b:2d46:b0:2fa:1e3e:9be5 with SMTP id 98e67ed59e1d1-303a6c35c4dmr8832732a91.0.1743104189643;
        Thu, 27 Mar 2025 12:36:29 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039f6b638csm2624220a91.44.2025.03.27.12.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 12:36:29 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 27 Mar 2025 12:35:52 -0700
Subject: [PATCH v5 11/21] RISC-V: perf: Restructure the SBI PMU code
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250327-counter_delegation-v5-11-1ee538468d1b@rivosinc.com>
References: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
In-Reply-To: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
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
 Atish Patra <atishp@rivosinc.com>, 
 =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <cleger@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

With Ssccfg/Smcdeleg, we no longer need SBI PMU extension to program/
access hpmcounter/events. However, we do need it for firmware counters.
Rename the driver and its related code to represent generic name
that will handle both sbi and ISA mechanism for hpmcounter related
operations. Take this opportunity to update the Kconfig names to
match the new driver name closely.

No functional change intended.

Reviewed-by: Clément Léger <cleger@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 MAINTAINERS                                       |   4 +-
 arch/riscv/include/asm/kvm_vcpu_pmu.h             |   4 +-
 arch/riscv/include/asm/kvm_vcpu_sbi.h             |   2 +-
 arch/riscv/kvm/Makefile                           |   4 +-
 arch/riscv/kvm/vcpu_sbi.c                         |   2 +-
 drivers/perf/Kconfig                              |  16 +-
 drivers/perf/Makefile                             |   4 +-
 drivers/perf/{riscv_pmu.c => riscv_pmu_common.c}  |   0
 drivers/perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c} | 214 +++++++++++++---------
 include/linux/perf/riscv_pmu.h                    |   8 +-
 10 files changed, 151 insertions(+), 107 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ed7aa6867674..b6d174f7735e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20406,9 +20406,9 @@ M:	Atish Patra <atishp@atishpatra.org>
 R:	Anup Patel <anup@brainfault.org>
 L:	linux-riscv@lists.infradead.org
 S:	Supported
-F:	drivers/perf/riscv_pmu.c
+F:	drivers/perf/riscv_pmu_common.c
+F:	drivers/perf/riscv_pmu_dev.c
 F:	drivers/perf/riscv_pmu_legacy.c
-F:	drivers/perf/riscv_pmu_sbi.c
 
 RISC-V SPACEMIT SoC Support
 M:	Yixun Lan <dlan@gentoo.org>
diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 1d85b6617508..aa75f52e9092 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -13,7 +13,7 @@
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/sbi.h>
 
-#ifdef CONFIG_RISCV_PMU_SBI
+#ifdef CONFIG_RISCV_PMU
 #define RISCV_KVM_MAX_FW_CTRS	32
 #define RISCV_KVM_MAX_HW_CTRS	32
 #define RISCV_KVM_MAX_COUNTERS	(RISCV_KVM_MAX_HW_CTRS + RISCV_KVM_MAX_FW_CTRS)
@@ -128,5 +128,5 @@ static inline int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned lon
 
 static inline void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu) {}
-#endif /* CONFIG_RISCV_PMU_SBI */
+#endif /* CONFIG_RISCV_PMU */
 #endif /* !__KVM_VCPU_RISCV_PMU_H */
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 4ed6203cdd30..745690d9e8b4 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -90,7 +90,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
 
-#ifdef CONFIG_RISCV_PMU_SBI
+#ifdef CONFIG_RISCV_PMU
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
 #endif
 #endif /* __RISCV_KVM_VCPU_SBI_H__ */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 4e0bba91d284..1ffe8c3400c0 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -23,11 +23,11 @@ kvm-y += vcpu_exit.o
 kvm-y += vcpu_fp.o
 kvm-y += vcpu_insn.o
 kvm-y += vcpu_onereg.o
-kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
+kvm-$(CONFIG_RISCV_PMU) += vcpu_pmu.o
 kvm-y += vcpu_sbi.o
 kvm-y += vcpu_sbi_base.o
 kvm-y += vcpu_sbi_hsm.o
-kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_sbi_pmu.o
+kvm-$(CONFIG_RISCV_PMU) += vcpu_sbi_pmu.o
 kvm-y += vcpu_sbi_replace.o
 kvm-y += vcpu_sbi_sta.o
 kvm-y += vcpu_sbi_system.o
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d1c83a77735e..7bb4517921d9 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -20,7 +20,7 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
 };
 #endif
 
-#ifndef CONFIG_RISCV_PMU_SBI
+#ifndef CONFIG_RISCV_PMU
 static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
 	.extid_start = -1UL,
 	.extid_end = -1UL,
diff --git a/drivers/perf/Kconfig b/drivers/perf/Kconfig
index 4e268de351c4..b3bdff2a99a4 100644
--- a/drivers/perf/Kconfig
+++ b/drivers/perf/Kconfig
@@ -75,7 +75,7 @@ config ARM_XSCALE_PMU
 	depends on ARM_PMU && CPU_XSCALE
 	def_bool y
 
-config RISCV_PMU
+config RISCV_PMU_COMMON
 	depends on RISCV
 	bool "RISC-V PMU framework"
 	default y
@@ -86,7 +86,7 @@ config RISCV_PMU
 	  can reuse it.
 
 config RISCV_PMU_LEGACY
-	depends on RISCV_PMU
+	depends on RISCV_PMU_COMMON
 	bool "RISC-V legacy PMU implementation"
 	default y
 	help
@@ -95,15 +95,15 @@ config RISCV_PMU_LEGACY
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
 
 config STARFIVE_STARLINK_PMU
 	depends on ARCH_STARFIVE || COMPILE_TEST
diff --git a/drivers/perf/Makefile b/drivers/perf/Makefile
index de71d2574857..0805d740c773 100644
--- a/drivers/perf/Makefile
+++ b/drivers/perf/Makefile
@@ -16,9 +16,9 @@ obj-$(CONFIG_FSL_IMX9_DDR_PMU) += fsl_imx9_ddr_perf.o
 obj-$(CONFIG_HISI_PMU) += hisilicon/
 obj-$(CONFIG_QCOM_L2_PMU)	+= qcom_l2_pmu.o
 obj-$(CONFIG_QCOM_L3_PMU) += qcom_l3_pmu.o
-obj-$(CONFIG_RISCV_PMU) += riscv_pmu.o
+obj-$(CONFIG_RISCV_PMU_COMMON) += riscv_pmu_common.o
 obj-$(CONFIG_RISCV_PMU_LEGACY) += riscv_pmu_legacy.o
-obj-$(CONFIG_RISCV_PMU_SBI) += riscv_pmu_sbi.o
+obj-$(CONFIG_RISCV_PMU) += riscv_pmu_dev.o
 obj-$(CONFIG_STARFIVE_STARLINK_PMU) += starfive_starlink_pmu.o
 obj-$(CONFIG_THUNDERX2_PMU) += thunderx2_pmu.o
 obj-$(CONFIG_XGENE_PMU) += xgene_pmu.o
diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu_common.c
similarity index 100%
rename from drivers/perf/riscv_pmu.c
rename to drivers/perf/riscv_pmu_common.c
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_dev.c
similarity index 87%
rename from drivers/perf/riscv_pmu_sbi.c
rename to drivers/perf/riscv_pmu_dev.c
index 698de8ddf895..6cebbc16bfe4 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_dev.c
@@ -8,7 +8,7 @@
  * sparc64 and x86 code.
  */
 
-#define pr_fmt(fmt) "riscv-pmu-sbi: " fmt
+#define pr_fmt(fmt) "riscv-pmu-dev: " fmt
 
 #include <linux/mod_devicetable.h>
 #include <linux/perf/riscv_pmu.h>
@@ -87,6 +87,8 @@ static const struct attribute_group *riscv_pmu_attr_groups[] = {
 static int sysctl_perf_user_access __read_mostly = SYSCTL_USER_ACCESS;
 
 /*
+ * This structure is SBI specific but counter delegation also require counter
+ * width, csr mapping. Reuse it for now.
  * RISC-V doesn't have heterogeneous harts yet. This need to be part of
  * per_cpu in case of harts with different pmu counters
  */
@@ -119,7 +121,7 @@ struct sbi_pmu_event_data {
 	};
 };
 
-static struct sbi_pmu_event_data pmu_hw_event_map[] = {
+static struct sbi_pmu_event_data pmu_hw_event_sbi_map[] = {
 	[PERF_COUNT_HW_CPU_CYCLES]		= {.hw_gen_event = {
 							SBI_PMU_HW_CPU_CYCLES,
 							SBI_PMU_EVENT_TYPE_HW, 0}},
@@ -153,7 +155,7 @@ static struct sbi_pmu_event_data pmu_hw_event_map[] = {
 };
 
 #define C(x) PERF_COUNT_HW_CACHE_##x
-static struct sbi_pmu_event_data pmu_cache_event_map[PERF_COUNT_HW_CACHE_MAX]
+static struct sbi_pmu_event_data pmu_cache_event_sbi_map[PERF_COUNT_HW_CACHE_MAX]
 [PERF_COUNT_HW_CACHE_OP_MAX]
 [PERF_COUNT_HW_CACHE_RESULT_MAX] = {
 	[C(L1D)] = {
@@ -298,7 +300,7 @@ static struct sbi_pmu_event_data pmu_cache_event_map[PERF_COUNT_HW_CACHE_MAX]
 	},
 };
 
-static void pmu_sbi_check_event(struct sbi_pmu_event_data *edata)
+static void rvpmu_sbi_check_event(struct sbi_pmu_event_data *edata)
 {
 	struct sbiret ret;
 
@@ -313,25 +315,25 @@ static void pmu_sbi_check_event(struct sbi_pmu_event_data *edata)
 	}
 }
 
-static void pmu_sbi_check_std_events(struct work_struct *work)
+static void rvpmu_sbi_check_std_events(struct work_struct *work)
 {
-	for (int i = 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
-		pmu_sbi_check_event(&pmu_hw_event_map[i]);
+	for (int i = 0; i < ARRAY_SIZE(pmu_hw_event_sbi_map); i++)
+		rvpmu_sbi_check_event(&pmu_hw_event_sbi_map[i]);
 
-	for (int i = 0; i < ARRAY_SIZE(pmu_cache_event_map); i++)
-		for (int j = 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++)
-			for (int k = 0; k < ARRAY_SIZE(pmu_cache_event_map[i][j]); k++)
-				pmu_sbi_check_event(&pmu_cache_event_map[i][j][k]);
+	for (int i = 0; i < ARRAY_SIZE(pmu_cache_event_sbi_map); i++)
+		for (int j = 0; j < ARRAY_SIZE(pmu_cache_event_sbi_map[i]); j++)
+			for (int k = 0; k < ARRAY_SIZE(pmu_cache_event_sbi_map[i][j]); k++)
+				rvpmu_sbi_check_event(&pmu_cache_event_sbi_map[i][j][k]);
 }
 
-static DECLARE_WORK(check_std_events_work, pmu_sbi_check_std_events);
+static DECLARE_WORK(check_std_events_work, rvpmu_sbi_check_std_events);
 
-static int pmu_sbi_ctr_get_width(int idx)
+static int rvpmu_ctr_get_width(int idx)
 {
 	return pmu_ctr_list[idx].width;
 }
 
-static bool pmu_sbi_ctr_is_fw(int cidx)
+static bool rvpmu_ctr_is_fw(int cidx)
 {
 	union sbi_pmu_ctr_info *info;
 
@@ -373,12 +375,12 @@ int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr)
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
@@ -399,7 +401,7 @@ static unsigned long pmu_sbi_get_filter_flags(struct perf_event *event)
 	return cflags;
 }
 
-static int pmu_sbi_ctr_get_idx(struct perf_event *event)
+static int rvpmu_sbi_ctr_get_idx(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct riscv_pmu *rvpmu = to_riscv_pmu(event->pmu);
@@ -409,7 +411,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 	uint64_t cbase = 0, cmask = rvpmu->cmask;
 	unsigned long cflags = 0;
 
-	cflags = pmu_sbi_get_filter_flags(event);
+	cflags = rvpmu_sbi_get_filter_flags(event);
 
 	/*
 	 * In legacy mode, we have to force the fixed counters for those events
@@ -446,7 +448,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 		return -ENOENT;
 
 	/* Additional sanity check for the counter id */
-	if (pmu_sbi_ctr_is_fw(idx)) {
+	if (rvpmu_ctr_is_fw(idx)) {
 		if (!test_and_set_bit(idx, cpuc->used_fw_ctrs))
 			return idx;
 	} else {
@@ -457,7 +459,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 	return -ENOENT;
 }
 
-static void pmu_sbi_ctr_clear_idx(struct perf_event *event)
+static void rvpmu_ctr_clear_idx(struct perf_event *event)
 {
 
 	struct hw_perf_event *hwc = &event->hw;
@@ -465,13 +467,13 @@ static void pmu_sbi_ctr_clear_idx(struct perf_event *event)
 	struct cpu_hw_events *cpuc = this_cpu_ptr(rvpmu->hw_events);
 	int idx = hwc->idx;
 
-	if (pmu_sbi_ctr_is_fw(idx))
+	if (rvpmu_ctr_is_fw(idx))
 		clear_bit(idx, cpuc->used_fw_ctrs);
 	else
 		clear_bit(idx, cpuc->used_hw_ctrs);
 }
 
-static int pmu_event_find_cache(u64 config)
+static int sbi_pmu_event_find_cache(u64 config)
 {
 	unsigned int cache_type, cache_op, cache_result, ret;
 
@@ -487,7 +489,7 @@ static int pmu_event_find_cache(u64 config)
 	if (cache_result >= PERF_COUNT_HW_CACHE_RESULT_MAX)
 		return -EINVAL;
 
-	ret = pmu_cache_event_map[cache_type][cache_op][cache_result].event_idx;
+	ret = pmu_cache_event_sbi_map[cache_type][cache_op][cache_result].event_idx;
 
 	return ret;
 }
@@ -503,7 +505,7 @@ static bool pmu_sbi_is_fw_event(struct perf_event *event)
 		return false;
 }
 
-static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
+static int rvpmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 {
 	u32 type = event->attr.type;
 	u64 config = event->attr.config;
@@ -519,10 +521,10 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 	case PERF_TYPE_HARDWARE:
 		if (config >= PERF_COUNT_HW_MAX)
 			return -EINVAL;
-		ret = pmu_hw_event_map[event->attr.config].event_idx;
+		ret = pmu_hw_event_sbi_map[event->attr.config].event_idx;
 		break;
 	case PERF_TYPE_HW_CACHE:
-		ret = pmu_event_find_cache(config);
+		ret = sbi_pmu_event_find_cache(config);
 		break;
 	case PERF_TYPE_RAW:
 		/*
@@ -648,7 +650,7 @@ static int pmu_sbi_snapshot_setup(struct riscv_pmu *pmu, int cpu)
 	return 0;
 }
 
-static u64 pmu_sbi_ctr_read(struct perf_event *event)
+static u64 rvpmu_sbi_ctr_read(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
@@ -690,25 +692,25 @@ static u64 pmu_sbi_ctr_read(struct perf_event *event)
 	return val;
 }
 
-static void pmu_sbi_set_scounteren(void *arg)
+static void rvpmu_set_scounteren(void *arg)
 {
 	struct perf_event *event = (struct perf_event *)arg;
 
 	if (event->hw.idx != -1)
 		csr_write(CSR_SCOUNTEREN,
-			  csr_read(CSR_SCOUNTEREN) | BIT(pmu_sbi_csr_index(event)));
+			  csr_read(CSR_SCOUNTEREN) | BIT(rvpmu_csr_index(event)));
 }
 
-static void pmu_sbi_reset_scounteren(void *arg)
+static void rvpmu_reset_scounteren(void *arg)
 {
 	struct perf_event *event = (struct perf_event *)arg;
 
 	if (event->hw.idx != -1)
 		csr_write(CSR_SCOUNTEREN,
-			  csr_read(CSR_SCOUNTEREN) & ~BIT(pmu_sbi_csr_index(event)));
+			  csr_read(CSR_SCOUNTEREN) & ~BIT(rvpmu_csr_index(event)));
 }
 
-static void pmu_sbi_ctr_start(struct perf_event *event, u64 ival)
+static void rvpmu_sbi_ctr_start(struct perf_event *event, u64 ival)
 {
 	struct sbiret ret;
 	struct hw_perf_event *hwc = &event->hw;
@@ -728,10 +730,10 @@ static void pmu_sbi_ctr_start(struct perf_event *event, u64 ival)
 
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
@@ -741,7 +743,7 @@ static void pmu_sbi_ctr_stop(struct perf_event *event, unsigned long flag)
 
 	if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
 	    (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
-		pmu_sbi_reset_scounteren((void *)event);
+		rvpmu_reset_scounteren((void *)event);
 
 	if (sbi_pmu_snapshot_available())
 		flag |= SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
@@ -767,7 +769,7 @@ static void pmu_sbi_ctr_stop(struct perf_event *event, unsigned long flag)
 	}
 }
 
-static int pmu_sbi_find_num_ctrs(void)
+static int rvpmu_sbi_find_num_ctrs(void)
 {
 	struct sbiret ret;
 
@@ -778,7 +780,7 @@ static int pmu_sbi_find_num_ctrs(void)
 		return sbi_err_map_linux_errno(ret.error);
 }
 
-static int pmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
+static int rvpmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
 {
 	struct sbiret ret;
 	int i, num_hw_ctr = 0, num_fw_ctr = 0;
@@ -809,7 +811,7 @@ static int pmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
 	return 0;
 }
 
-static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
+static inline void rvpmu_sbi_stop_all(struct riscv_pmu *pmu)
 {
 	/*
 	 * No need to check the error because we are disabling all the counters
@@ -819,7 +821,7 @@ static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
 		  0, pmu->cmask, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
 }
 
-static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
+static inline void rvpmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
 {
 	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
 	struct riscv_pmu_snapshot_data *sdata = cpu_hw_evt->snapshot_addr;
@@ -863,8 +865,8 @@ static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
  * while the overflowed counters need to be started with updated initialization
  * value.
  */
-static inline void pmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cpu_hw_evt,
-					      u64 ctr_ovf_mask)
+static inline void rvpmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cpu_hw_evt,
+						u64 ctr_ovf_mask)
 {
 	int idx = 0, i;
 	struct perf_event *event;
@@ -902,8 +904,8 @@ static inline void pmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cpu_hw_evt,
 	}
 }
 
-static inline void pmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_events *cpu_hw_evt,
-						   u64 ctr_ovf_mask)
+static inline void rvpmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_events *cpu_hw_evt,
+						     u64 ctr_ovf_mask)
 {
 	int i, idx = 0;
 	struct perf_event *event;
@@ -937,18 +939,18 @@ static inline void pmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_events *cpu_hw_
 	}
 }
 
-static void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
-					u64 ctr_ovf_mask)
+static void rvpmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
+					  u64 ctr_ovf_mask)
 {
 	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
 
 	if (sbi_pmu_snapshot_available())
-		pmu_sbi_start_ovf_ctrs_snapshot(cpu_hw_evt, ctr_ovf_mask);
+		rvpmu_sbi_start_ovf_ctrs_snapshot(cpu_hw_evt, ctr_ovf_mask);
 	else
-		pmu_sbi_start_ovf_ctrs_sbi(cpu_hw_evt, ctr_ovf_mask);
+		rvpmu_sbi_start_ovf_ctrs_sbi(cpu_hw_evt, ctr_ovf_mask);
 }
 
-static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
+static irqreturn_t rvpmu_ovf_handler(int irq, void *dev)
 {
 	struct perf_sample_data data;
 	struct pt_regs *regs;
@@ -980,7 +982,7 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
 	}
 
 	pmu = to_riscv_pmu(event->pmu);
-	pmu_sbi_stop_hw_ctrs(pmu);
+	rvpmu_sbi_stop_hw_ctrs(pmu);
 
 	/* Overflow status register should only be read after counter are stopped */
 	if (sbi_pmu_snapshot_available())
@@ -1049,13 +1051,55 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
 		hw_evt->state = 0;
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
@@ -1070,7 +1114,7 @@ static int pmu_sbi_starting_cpu(unsigned int cpu, struct hlist_node *node)
 		csr_write(CSR_SCOUNTEREN, 0x2);
 
 	/* Stop all the counters so that they can be enabled from perf */
-	pmu_sbi_stop_all(pmu);
+	rvpmu_sbi_stop_all(pmu);
 
 	if (riscv_pmu_use_irq) {
 		cpu_hw_evt->irq = riscv_pmu_irq;
@@ -1084,7 +1128,7 @@ static int pmu_sbi_starting_cpu(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int pmu_sbi_dying_cpu(unsigned int cpu, struct hlist_node *node)
+static int rvpmu_dying_cpu(unsigned int cpu, struct hlist_node *node)
 {
 	if (riscv_pmu_use_irq) {
 		disable_percpu_irq(riscv_pmu_irq);
@@ -1099,7 +1143,7 @@ static int pmu_sbi_dying_cpu(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pdev)
+static int rvpmu_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pdev)
 {
 	int ret;
 	struct cpu_hw_events __percpu *hw_events = pmu->hw_events;
@@ -1139,7 +1183,7 @@ static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pde
 		return -ENODEV;
 	}
 
-	ret = request_percpu_irq(riscv_pmu_irq, pmu_sbi_ovf_handler, "riscv-pmu", hw_events);
+	ret = request_percpu_irq(riscv_pmu_irq, rvpmu_ovf_handler, "riscv-pmu", hw_events);
 	if (ret) {
 		pr_err("registering percpu irq failed [%d]\n", ret);
 		return ret;
@@ -1215,7 +1259,7 @@ static void riscv_pmu_destroy(struct riscv_pmu *pmu)
 	cpuhp_state_remove_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
 }
 
-static void pmu_sbi_event_init(struct perf_event *event)
+static void rvpmu_event_init(struct perf_event *event)
 {
 	/*
 	 * The permissions are set at event_init so that we do not depend
@@ -1229,7 +1273,7 @@ static void pmu_sbi_event_init(struct perf_event *event)
 		event->hw.flags |= PERF_EVENT_FLAG_LEGACY;
 }
 
-static void pmu_sbi_event_mapped(struct perf_event *event, struct mm_struct *mm)
+static void rvpmu_event_mapped(struct perf_event *event, struct mm_struct *mm)
 {
 	if (event->hw.flags & PERF_EVENT_FLAG_NO_USER_ACCESS)
 		return;
@@ -1257,14 +1301,14 @@ static void pmu_sbi_event_mapped(struct perf_event *event, struct mm_struct *mm)
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
@@ -1286,7 +1330,7 @@ static void pmu_sbi_event_unmapped(struct perf_event *event, struct mm_struct *m
 
 	if (event->hw.flags & PERF_EVENT_FLAG_USER_ACCESS)
 		on_each_cpu_mask(mm_cpumask(mm),
-				 pmu_sbi_reset_scounteren, (void *)event, 1);
+				 rvpmu_reset_scounteren, (void *)event, 1);
 }
 
 static void riscv_pmu_update_counter_access(void *info)
@@ -1329,7 +1373,7 @@ static const struct ctl_table sbi_pmu_sysctl_table[] = {
 	},
 };
 
-static int pmu_sbi_device_probe(struct platform_device *pdev)
+static int rvpmu_device_probe(struct platform_device *pdev)
 {
 	struct riscv_pmu *pmu = NULL;
 	int ret = -ENODEV;
@@ -1340,7 +1384,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	if (!pmu)
 		return -ENOMEM;
 
-	num_counters = pmu_sbi_find_num_ctrs();
+	num_counters = rvpmu_find_num_ctrs();
 	if (num_counters < 0) {
 		pr_err("SBI PMU extension doesn't provide any counters\n");
 		goto out_free;
@@ -1353,10 +1397,10 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
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
@@ -1366,17 +1410,17 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	pmu->pmu.attr_groups = riscv_pmu_attr_groups;
 	pmu->pmu.parent = &pdev->dev;
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
 
 	ret = riscv_pm_pmu_register(pmu);
 	if (ret)
@@ -1432,14 +1476,14 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
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
@@ -1454,20 +1498,20 @@ static int __init pmu_sbi_devinit(void)
 
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
 
@@ -1476,4 +1520,4 @@ static int __init pmu_sbi_devinit(void)
 
 	return ret;
 }
-device_initcall(pmu_sbi_devinit)
+device_initcall(rvpmu_devinit)
diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
index 701974639ff2..525acd6d96d0 100644
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
@@ -87,10 +87,10 @@ void riscv_pmu_legacy_skip_init(void);
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
2.43.0


