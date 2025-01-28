Return-Path: <kvm+bounces-36732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D83B1A203BB
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:04:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A2251882878
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A563B1F76C2;
	Tue, 28 Jan 2025 05:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="lgWOupy1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D711F63DD
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040412; cv=none; b=p1f9PJPDKixTejchJA7pLQaF0JWx2Ilahw3HQ5BBtzFpIVW1x6oxXTLao/IK5ijJHy8RTW5W9B2AlwJaz2oIiiMakV14qUybTWv0lB8XqcPuldEU6eo3ocERbYTXowgqI2UdWalDy+kBVvh5BrpMnLpBse5KMkUasHgIkMSxdjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040412; c=relaxed/simple;
	bh=LjUu+Bdc95smyO3zLcqqrukYQsXPrWRn0+54UGV1T0E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D8f/2ViDKr45X2NNwe2hp+R8wkf8NsDkeyGw8CnteLuqc2/c96PondqNLlY/yyj390ECCkqhZbpV/QkeMuWw6FW59F9V1OOitkoCi4mrvZzYgkgcX1rAuzxaJL9QKN/2tnBlnUCLkwfc6Gtta2IExKo1GXbJRD2tB+cUZ20/BPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=lgWOupy1; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2efded08c79so7213888a91.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040407; x=1738645207; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fbTwmw3a12DS+uI9wjyYWdbyvy5dmCVOaeFZB/A7qpo=;
        b=lgWOupy1bXHtizEARSNabBIzA7gPX4vDmBi2FcWE+3OJNbY8mVY+8Am6JnM7xRBp0j
         RYlWayOiJ+qckWI3SY43YuvTet3jLFyJ6tO4koxWsgCu6UYpF/cd9u2Rrqodq2DZRhkc
         WLGaW+ptlBwP4dwqhQ9WQTohRPJXuOmXW02/6hz8LzxtnkOqciP1Jk8CPTGFhEjcLmO2
         KjWQRBIarNeDh50ugCpXJRP9VXLTabzRmhYAP8qS50kglN6Cy2FthfGNgnhgxOpcV4kP
         rsEQ9mR+gKvEwVLaYdH5N4Y9tX8PJzMJdm8FVt63faY2i0KT0C/32FswxxUrr40A0GRF
         PQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040407; x=1738645207;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fbTwmw3a12DS+uI9wjyYWdbyvy5dmCVOaeFZB/A7qpo=;
        b=D9Ophh7YkQSYGFlhoWClBqaxEw7fTkNMOxXlPApzTG90uiJZRdd2w9y5lYjxS3sOvX
         Ngy8K35N+vl6kgFcC8ASGAToqgUC0pTZfWqzQF/32/Hcwn5WeYjk2tIFKAzPy/ET7UIH
         32tAL4r0XVvUoeegVbOq3fb6QG9RdQs7Oz58rR3pyEeYZ1KUHp/tN8nANP1gYYynCAcm
         JcWxTANjbTeKrMGYE4xNNIxU8HOcQyYjAkm2yKlykty0oEdTdf7Rpo5jTt38BU7cVVni
         n5NMi2yD5V14STaFEymMcpIf/u/aiRyQITBuWmjhcBSEk4hGsttPDiXtuLWk3KiwxFDx
         SCPA==
X-Forwarded-Encrypted: i=1; AJvYcCWUQR2C/oID9XfgKxwFWlr/+3dDNefzPxSFH+kijg/2C8U4aayZSMx9ZnLf6v7BmMmbqA4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbWNq6uHA++ljUEj2FBRV+2jz/XQ3b3DP5a5sPmmIXqTCJY6e6
	zkTlanhMaLO3PWJtauJv2pz/aGeFV0Uop2R5N2Nzea/9xYPCWoO0lFPlNRFuoXQ=
X-Gm-Gg: ASbGnct9tJTngtMAClXjIBLDdI/DE76APbWjfOj/rWLHprKfKJ+/xfKBCP+/ZShl4S+
	/WkuLXj3A3PT6IQWSec0/czEb3GbG2Tv5c5GAO9xU/lBJDkIhgyaKywBLNlCAdMafeGg0H7ChBw
	l1uLj6/Awdu4M76vZeQLk7x/cj/NAtlsyZeXLaMBoFeK1rR0gpFp0czbem8qOupIAu77w9+2fvg
	j2orIK/11SfWD16SQemB1yJIW4jV6KUIjv5VAVdjfPWan96CQXJD1mkx0w6wZ2BUEejNMZDWHsh
	s4dwtCpfbP/VzG7unE4IZg7VMUko
X-Google-Smtp-Source: AGHT+IFwdWiPo7W/0NvsZSa9JGhF7mDCjYsiA/khQq9iwbAgmGdwZAzg8WzYf0KKQuQJnG1UP2dvGA==
X-Received: by 2002:a17:90b:5206:b0:2f4:f7f8:fc8b with SMTP id 98e67ed59e1d1-2f782d4ed77mr61936774a91.27.1738040407091;
        Mon, 27 Jan 2025 21:00:07 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.21.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 21:00:06 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 20:59:52 -0800
Subject: [PATCH v3 11/21] RISC-V: perf: Restructure the SBI PMU code
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-11-64894d7e16d5@rivosinc.com>
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

With Ssccfg/Smcdeleg, we no longer need SBI PMU extension to program/
access hpmcounter/events. However, we do need it for firmware counters.
Rename the driver and its related code to represent generic name
that will handle both sbi and ISA mechanism for hpmcounter related
operations. Take this opportunity to update the Kconfig names to
match the new driver name closely.

No functional change intended.

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
 drivers/perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c} | 206 +++++++++++++---------
 include/linux/perf/riscv_pmu.h                    |   8 +-
 10 files changed, 147 insertions(+), 103 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 30cbc3d44cd5..2ef7ff933266 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20177,9 +20177,9 @@ M:	Atish Patra <atishp@atishpatra.org>
 R:	Anup Patel <anup@brainfault.org>
 L:	linux-riscv@lists.infradead.org
 S:	Supported
-F:	drivers/perf/riscv_pmu.c
+F:	drivers/perf/riscv_pmu_common.c
+F:	drivers/perf/riscv_pmu_dev.c
 F:	drivers/perf/riscv_pmu_legacy.c
-F:	drivers/perf/riscv_pmu_sbi.c
 
 RISC-V THEAD SoC SUPPORT
 M:	Drew Fustini <drew@pdp7.com>
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
index b96705258cf9..764bb158e760 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -89,7 +89,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
 
-#ifdef CONFIG_RISCV_PMU_SBI
+#ifdef CONFIG_RISCV_PMU
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
 #endif
 #endif /* __RISCV_KVM_VCPU_SBI_H__ */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 0fb1840c3e0a..f4ad7af0bdab 100644
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
 kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 6e704ed86a83..4eaf9b0f736b 100644
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
similarity index 88%
rename from drivers/perf/riscv_pmu_sbi.c
rename to drivers/perf/riscv_pmu_dev.c
index 1aa303f76cc7..b69654554288 100644
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
 	for (int i = 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
-		pmu_sbi_check_event(&pmu_hw_event_map[i]);
+		rvpmu_sbi_check_event(&pmu_hw_event_map[i]);
 
 	for (int i = 0; i < ARRAY_SIZE(pmu_cache_event_map); i++)
 		for (int j = 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++)
 			for (int k = 0; k < ARRAY_SIZE(pmu_cache_event_map[i][j]); k++)
-				pmu_sbi_check_event(&pmu_cache_event_map[i][j][k]);
+				rvpmu_sbi_check_event(&pmu_cache_event_map[i][j][k]);
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
@@ -520,10 +522,10 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
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
@@ -646,7 +648,7 @@ static int pmu_sbi_snapshot_setup(struct riscv_pmu *pmu, int cpu)
 	return 0;
 }
 
-static u64 pmu_sbi_ctr_read(struct perf_event *event)
+static u64 rvpmu_sbi_ctr_read(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
@@ -688,25 +690,25 @@ static u64 pmu_sbi_ctr_read(struct perf_event *event)
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
@@ -726,10 +728,10 @@ static void pmu_sbi_ctr_start(struct perf_event *event, u64 ival)
 
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
@@ -739,7 +741,7 @@ static void pmu_sbi_ctr_stop(struct perf_event *event, unsigned long flag)
 
 	if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
 	    (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
-		pmu_sbi_reset_scounteren((void *)event);
+		rvpmu_reset_scounteren((void *)event);
 
 	if (sbi_pmu_snapshot_available())
 		flag |= SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
@@ -765,7 +767,7 @@ static void pmu_sbi_ctr_stop(struct perf_event *event, unsigned long flag)
 	}
 }
 
-static int pmu_sbi_find_num_ctrs(void)
+static int rvpmu_sbi_find_num_ctrs(void)
 {
 	struct sbiret ret;
 
@@ -776,7 +778,7 @@ static int pmu_sbi_find_num_ctrs(void)
 		return sbi_err_map_linux_errno(ret.error);
 }
 
-static int pmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
+static int rvpmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
 {
 	struct sbiret ret;
 	int i, num_hw_ctr = 0, num_fw_ctr = 0;
@@ -807,7 +809,7 @@ static int pmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
 	return 0;
 }
 
-static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
+static inline void rvpmu_sbi_stop_all(struct riscv_pmu *pmu)
 {
 	/*
 	 * No need to check the error because we are disabling all the counters
@@ -817,7 +819,7 @@ static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
 		  0, pmu->cmask, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
 }
 
-static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
+static inline void rvpmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
 {
 	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
 	struct riscv_pmu_snapshot_data *sdata = cpu_hw_evt->snapshot_addr;
@@ -861,8 +863,8 @@ static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
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
@@ -900,8 +902,8 @@ static inline void pmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cpu_hw_evt,
 	}
 }
 
-static inline void pmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_events *cpu_hw_evt,
-						   u64 ctr_ovf_mask)
+static inline void rvpmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_events *cpu_hw_evt,
+						     u64 ctr_ovf_mask)
 {
 	int i, idx = 0;
 	struct perf_event *event;
@@ -935,18 +937,18 @@ static inline void pmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_events *cpu_hw_
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
@@ -978,7 +980,7 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
 	}
 
 	pmu = to_riscv_pmu(event->pmu);
-	pmu_sbi_stop_hw_ctrs(pmu);
+	rvpmu_sbi_stop_hw_ctrs(pmu);
 
 	/* Overflow status register should only be read after counter are stopped */
 	if (sbi_pmu_snapshot_available())
@@ -1047,13 +1049,55 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
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
@@ -1068,7 +1112,7 @@ static int pmu_sbi_starting_cpu(unsigned int cpu, struct hlist_node *node)
 		csr_write(CSR_SCOUNTEREN, 0x2);
 
 	/* Stop all the counters so that they can be enabled from perf */
-	pmu_sbi_stop_all(pmu);
+	rvpmu_sbi_stop_all(pmu);
 
 	if (riscv_pmu_use_irq) {
 		cpu_hw_evt->irq = riscv_pmu_irq;
@@ -1082,7 +1126,7 @@ static int pmu_sbi_starting_cpu(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int pmu_sbi_dying_cpu(unsigned int cpu, struct hlist_node *node)
+static int rvpmu_dying_cpu(unsigned int cpu, struct hlist_node *node)
 {
 	if (riscv_pmu_use_irq) {
 		disable_percpu_irq(riscv_pmu_irq);
@@ -1097,7 +1141,7 @@ static int pmu_sbi_dying_cpu(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pdev)
+static int rvpmu_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pdev)
 {
 	int ret;
 	struct cpu_hw_events __percpu *hw_events = pmu->hw_events;
@@ -1137,7 +1181,7 @@ static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pde
 		return -ENODEV;
 	}
 
-	ret = request_percpu_irq(riscv_pmu_irq, pmu_sbi_ovf_handler, "riscv-pmu", hw_events);
+	ret = request_percpu_irq(riscv_pmu_irq, rvpmu_ovf_handler, "riscv-pmu", hw_events);
 	if (ret) {
 		pr_err("registering percpu irq failed [%d]\n", ret);
 		return ret;
@@ -1213,7 +1257,7 @@ static void riscv_pmu_destroy(struct riscv_pmu *pmu)
 	cpuhp_state_remove_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
 }
 
-static void pmu_sbi_event_init(struct perf_event *event)
+static void rvpmu_event_init(struct perf_event *event)
 {
 	/*
 	 * The permissions are set at event_init so that we do not depend
@@ -1227,7 +1271,7 @@ static void pmu_sbi_event_init(struct perf_event *event)
 		event->hw.flags |= PERF_EVENT_FLAG_LEGACY;
 }
 
-static void pmu_sbi_event_mapped(struct perf_event *event, struct mm_struct *mm)
+static void rvpmu_event_mapped(struct perf_event *event, struct mm_struct *mm)
 {
 	if (event->hw.flags & PERF_EVENT_FLAG_NO_USER_ACCESS)
 		return;
@@ -1255,14 +1299,14 @@ static void pmu_sbi_event_mapped(struct perf_event *event, struct mm_struct *mm)
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
@@ -1284,7 +1328,7 @@ static void pmu_sbi_event_unmapped(struct perf_event *event, struct mm_struct *m
 
 	if (event->hw.flags & PERF_EVENT_FLAG_USER_ACCESS)
 		on_each_cpu_mask(mm_cpumask(mm),
-				 pmu_sbi_reset_scounteren, (void *)event, 1);
+				 rvpmu_reset_scounteren, (void *)event, 1);
 }
 
 static void riscv_pmu_update_counter_access(void *info)
@@ -1327,7 +1371,7 @@ static struct ctl_table sbi_pmu_sysctl_table[] = {
 	},
 };
 
-static int pmu_sbi_device_probe(struct platform_device *pdev)
+static int rvpmu_device_probe(struct platform_device *pdev)
 {
 	struct riscv_pmu *pmu = NULL;
 	int ret = -ENODEV;
@@ -1338,7 +1382,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	if (!pmu)
 		return -ENOMEM;
 
-	num_counters = pmu_sbi_find_num_ctrs();
+	num_counters = rvpmu_find_num_ctrs();
 	if (num_counters < 0) {
 		pr_err("SBI PMU extension doesn't provide any counters\n");
 		goto out_free;
@@ -1351,10 +1395,10 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
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
@@ -1364,17 +1408,17 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
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
@@ -1430,14 +1474,14 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
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
@@ -1452,20 +1496,20 @@ static int __init pmu_sbi_devinit(void)
 
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
 
@@ -1474,4 +1518,4 @@ static int __init pmu_sbi_devinit(void)
 
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
2.34.1


