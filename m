Return-Path: <kvm+bounces-44151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE84A9B06A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E577F3BA58F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C322820B6;
	Thu, 24 Apr 2025 14:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NHz03KRf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EA127F4C7
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504038; cv=none; b=CAnWDwKs82mk8SG2x6i2VLhso2qiqOAJmHDk3biK2mZQ6qK52LTyGmDEy4zcV9EfdyNkjdG5G2FhxBpcRdUUUqgPJspCMi7hjbc5psMQV0kLnW3FdXfFC8lZ/pT81cwGYSS11IXt2KjdFOeSmCIANV39Tsw9o4JDWkCVIAW+Q9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504038; c=relaxed/simple;
	bh=mRPK+89hbVEkRoZvoKf3k11XmtiTEyAylGP5LEAOcB4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d++hSWMHPl9qkEWX7p4BW86bwew8jxGeiepTqmbKCKoWImhc/IZU8De1VFnaKm3QBnJB3dN50yhlCTXYg7xNsVZxQ0KFr7niK6jn7VSvrZHdqaHWDmUk+ADaI2JOZYqwIv3f0yz2c6fko5G+acddGY77PMEky3mMdgMUVPV+/a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NHz03KRf; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3913d129c1aso753239f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504033; x=1746108833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jfERcd+/8hI2lWUkL6Z3PV6Xql42InuHmm1RJaBik0=;
        b=NHz03KRfKRU1ydrBTpF950pSDo/fHHj/qFQsZBAH0nAr4J9XrBebUanz4RG0Ixizpb
         zizFOX7Vu6tkDrj2qPw3CD+XTvSRf647mi6yu15W/sUo85Ma/WYJ03VBSbAyl3QveuSj
         y+rNVChsDvDU1Owq9C37MZKVnLhZcFMRtLzhu9lxwqU4fxn2gQzaTp0qmCCwCCdkyUob
         GKkWZ9icDjECa2TnEhe8KvnOI/31ftMaK1j05MmE06f1oYp23/LsxAb0xjpcv5N66sz+
         xsWF4R4435th0RzZhvo28yWhWepgCqYIkW7Is/iTl37ZQJa/SEUSfIzKb2Tm1RJkuXbn
         BUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504033; x=1746108833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8jfERcd+/8hI2lWUkL6Z3PV6Xql42InuHmm1RJaBik0=;
        b=XgixO3tOe9KKAO5WlRI4SmTDPhOcnuuFUQ24Jzguli5ydf41uVY/qAI3yO5y0Ku2MR
         Cs/uLQI7znrt4wjktehvAnthUDxe55x8Zn107vEgo0Av4ucilIDyY0bvKHBf7lO0lagw
         th1LPUw8rFLxiHLwnEqq/FaCiLCfcZe2EF6wG2HIap91hQM/RDezrYgpJ/RvHm1HxStV
         GDqO1RKo/+Arq00mW7Q5yss0Zoc0EnHJqzem1vBRxoKqg2m6Ie1+UnlMKEBya3J0VkTn
         huAC7fSqjlYnpWHPlWd1/Mi/MV+xAl1neja1DnXGWr67888lXKZ1GZv/5Q3o5jcjcOdF
         n74g==
X-Forwarded-Encrypted: i=1; AJvYcCVoVU70KA45aDrQR7TD5lO3VMN2HFXqRDAqQoFJxPBPZpUauViWTLhnUeUki/U/JnxiOF0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFbbP3MmWunrA4/36oUT7B+2AW3COAhvafZVJuGAYQnoq29vuJ
	ez7gt7n4qtq8tEMcJ37bsI/cCnT3QRHgH5XF6D683GpQVnIr2fYf/rCIvQ6XayA=
X-Gm-Gg: ASbGncu/sJkxhSCwj1zWxGHTjx0tuXbmRvzrqQZ9boYcIRWnezMS9R7d0yg++dSTdZR
	tkWLMMQdG/ZaSwKy7Af6QH8QFIwFBhOYDS+8sOiJCoIUHsd7ZwttrcaPDAevJDXkrK7HPShhq7y
	wIPTCwXo+3ADlshWtcy2JbeMXGdPPj313Inr//3eJxD8KPY+mG+QsrNFcgO2B+n6H4FcrJIs+42
	Qq+xd4nH4OC67ao/Y4RvCZ8gLI2SELC9EYpGSyNSjQwZWAoq7137RVu+gf87eNc5I1Lm3hNcH1Y
	R/8Fimj4rVfeB9Sb9M4GpfVNRxRG3tPGPXTGgWTqW8Qoi6mfhC696Q4NBdi/T0bdAnCWB6oLv6/
	OAbQsq3qADJRdsaI/
X-Google-Smtp-Source: AGHT+IGx0xNiXWRY0y1pEy2kIqf26zFRwFHT6eClNX/GVzcfRlYZlyiUPQIhI5t0dInRmkb4qoBxLw==
X-Received: by 2002:adf:e2d0:0:b0:39c:1f02:44d8 with SMTP id ffacd0b85a97d-3a06d647344mr1972721f8f.4.1745504032796;
        Thu, 24 Apr 2025 07:13:52 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:52 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 06/34] KVM: gunyah: Add initial Gunyah backend support
Date: Thu, 24 Apr 2025 15:13:13 +0100
Message-Id: <20250424141341.841734-7-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces the initial skeleton for supporting the Gunyah
hypervisor [1] as a KVM backend on arm64. The Gunyah backend implements
a different KVM architecture backend under `arch/arm64/kvm/` alongside
the existing support for AArch64's native virtualization. Please, note
that the two are mutually exclusive at build time.

Key highlights of this patch:

- Introduces a new Kconfig split: `CONFIG_KVM_ARM` for native support,
  and a variant for Gunyah-backed virtualization.
- Adds `gunyah.c`, a new arch backend file that implements the minimal
  KVM architecture callbacks and stub interfaces required by the KVM
  core to build and boot.
- Refactors Makefile and build rules to support mutually exclusive
  builds of `CONFIG_KVM_ARM` and `CONFIG_GUNYAH`.
- Introduces a dummy implementation of required KVM stubs such as:
  `kvm_arch_init_vm()`, `kvm_arch_vcpu_create()`, `kvm_age_gfn()`, etc.

This serves as a starting point for developing virtualization
support for guests running under the Gunyah hypervisor. Subsequent
patches in the series will add support for memory mapping,
virtual CPUs, IRQ injection, and other guest lifecycle mechanisms.

CONFIG_GUNYAH is going to be introduced in the next patch imlpementing
the Gunyah driver.

[1] https://www.qualcomm.com/developer/blog/2024/01/gunyah-hypervisor-software-supporting-protected-vms-android-virtualization-framework

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h     |   2 +-
 arch/arm64/include/asm/virt.h         |   7 +
 arch/arm64/kernel/cpufeature.c        |   4 +
 arch/arm64/kernel/image-vars.h        |   2 +-
 arch/arm64/kvm/Kconfig                |  22 +-
 arch/arm64/kvm/Makefile               |  14 +-
 arch/arm64/kvm/gunyah.c               | 736 ++++++++++++++++++++++++++
 include/kvm/arm_pmu.h                 |   2 +-
 include/linux/irqchip/arm-vgic-info.h |   2 +-
 include/linux/perf/arm_pmu.h          |   2 +-
 10 files changed, 781 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm64/kvm/gunyah.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e98cfe7855a6..efbfe31d262d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1417,7 +1417,7 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 	return (!has_vhe() && attr->exclude_host);
 }
 
-#ifdef CONFIG_KVM
+#ifdef CONFIG_KVM_ARM
 void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index ebf4a9f943ed..80ddb409e0cb 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -82,11 +82,18 @@ bool is_kvm_arm_initialised(void);
 
 DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
+#ifndef CONFIG_KVM_ARM
+static inline bool is_pkvm_initialized(void)
+{
+	return false;
+}
+#else
 static inline bool is_pkvm_initialized(void)
 {
 	return IS_ENABLED(CONFIG_KVM) &&
 	       static_branch_likely(&kvm_protected_mode_initialized);
 }
+#endif
 
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9c4d6d552b25..50a251c28a48 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3548,6 +3548,9 @@ static void verify_sme_features(void)
 	cpacr_restore(cpacr);
 }
 
+#ifndef CONFIG_KVM_ARM
+static void verify_hyp_capabilities(void) { }
+#else
 static void verify_hyp_capabilities(void)
 {
 	u64 safe_mmfr1, mmfr0, mmfr1;
@@ -3578,6 +3581,7 @@ static void verify_hyp_capabilities(void)
 		cpu_die_early();
 	}
 }
+#endif
 
 static void verify_mpam_capabilities(void)
 {
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 5e3c4b58f279..7688f53b55bd 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -72,7 +72,7 @@ PROVIDE(__pi__data                	= _data);
 PROVIDE(__pi___bss_start		= __bss_start);
 PROVIDE(__pi__end			= _end);
 
-#ifdef CONFIG_KVM
+#ifdef CONFIG_KVM_ARM
 
 /*
  * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_, to
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 096e45acadb2..eb43eabcf61b 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -17,9 +17,25 @@ menuconfig VIRTUALIZATION
 
 if VIRTUALIZATION
 
+###################### Gunyah-based KVM ######################
+menuconfig KVM
+	bool "Kernel-based Virtual Machine (KVM) under Gunyah"
+	depends on GUNYAH
+	select KVM_COMMON
+	select KVM_GENERIC_MMU_NOTIFIER
+	select KVM_MMIO
+	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_READONLY_MEM
+
+###################### Native ARM KVM ######################
+config KVM_ARM
+	bool
+	depends on !GUNYAH
+
 menuconfig KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
-	depends on AS_HAS_ARMV8_4
+	depends on !GUNYAH && AS_HAS_ARMV8_4
+	select KVM_ARM
 	select KVM_COMMON
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_MMU_NOTIFIER
@@ -43,6 +59,8 @@ menuconfig KVM
 
 	  If unsure, say N.
 
+if KVM_ARM
+
 config NVHE_EL2_DEBUG
 	bool "Debug mode for non-VHE EL2 object"
 	depends on KVM
@@ -82,5 +100,5 @@ config PTDUMP_STAGE2_DEBUGFS
 	  kernel.
 
 	  If in doubt, say N.
-
+endif # KVM_ARM
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 209bc76263f1..5b54eb329ce2 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -8,12 +8,14 @@ ccflags-y += -I $(src)
 include $(srctree)/virt/kvm/Makefile.kvm
 
 obj-$(CONFIG_KVM) += kvm.o
-obj-$(CONFIG_KVM) += hyp/
+obj-$(CONFIG_KVM_ARM) += hyp/
 
 CFLAGS_sys_regs.o += -Wno-override-init
 CFLAGS_handle_exit.o += -Wno-override-init
 
-kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
+kvm-$(CONFIG_GUNYAH) += gunyah.o
+
+kvm-$(CONFIG_KVM_ARM) += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
@@ -25,9 +27,11 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o
 
-kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
-kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
-kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
+ifeq ($(CONFIG_KVM_ARM),y)
+	kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
+	kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
+	kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
+endif
 
 always-y := hyp_constants.h hyp-constants.s
 
diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
new file mode 100644
index 000000000000..0095610166ad
--- /dev/null
+++ b/arch/arm64/kvm/gunyah.c
@@ -0,0 +1,736 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM port to Qualcomm's Gunyah Hypervisor
+ *
+ * Copyright (C) 2024-2025 Linaro Ltd.
+ *
+ * Author: Karim Manaouil <karim.manaouil@linaro.org>
+ *
+ */
+#include <linux/cpumask.h>
+#include <linux/kvm_host.h>
+#include <linux/kvm_irqfd.h>
+#include <asm/kvm_mmu.h>
+#include <linux/perf_event.h>
+
+static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
+
+enum kvm_mode kvm_get_mode(void)
+{
+	return kvm_mode;
+}
+
+const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+	KVM_GENERIC_VM_STATS()
+};
+
+const struct kvm_stats_header kvm_vm_stats_header = {
+	.name_size = KVM_STATS_NAME_SIZE,
+	.num_desc = ARRAY_SIZE(kvm_vm_stats_desc),
+	.id_offset =  sizeof(struct kvm_stats_header),
+	.desc_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE,
+	.data_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE +
+		       sizeof(kvm_vm_stats_desc),
+};
+
+const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+	KVM_GENERIC_VCPU_STATS(),
+	STATS_DESC_COUNTER(VCPU, hvc_exit_stat),
+	STATS_DESC_COUNTER(VCPU, wfe_exit_stat),
+	STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
+	STATS_DESC_COUNTER(VCPU, mmio_exit_user),
+	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
+	STATS_DESC_COUNTER(VCPU, exits)
+};
+
+const struct kvm_stats_header kvm_vcpu_stats_header = {
+	.name_size = KVM_STATS_NAME_SIZE,
+	.num_desc = ARRAY_SIZE(kvm_vcpu_stats_desc),
+	.id_offset = sizeof(struct kvm_stats_header),
+	.desc_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE,
+	.data_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE +
+		       sizeof(kvm_vcpu_stats_desc),
+};
+
+static bool core_reg_offset_is_vreg(u64 off)
+{
+	return off >= KVM_REG_ARM_CORE_REG(fp_regs.vregs) &&
+		off < KVM_REG_ARM_CORE_REG(fp_regs.fpsr);
+}
+
+static u64 core_reg_offset_from_id(u64 id)
+{
+	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
+}
+
+static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
+{
+	int size;
+
+	switch (off) {
+	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
+	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
+	case KVM_REG_ARM_CORE_REG(regs.sp):
+	case KVM_REG_ARM_CORE_REG(regs.pc):
+	case KVM_REG_ARM_CORE_REG(regs.pstate):
+	case KVM_REG_ARM_CORE_REG(sp_el1):
+	case KVM_REG_ARM_CORE_REG(elr_el1):
+	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
+	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
+		size = sizeof(__u64);
+		break;
+
+	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
+	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
+		size = sizeof(__uint128_t);
+		break;
+
+	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
+	case KVM_REG_ARM_CORE_REG(fp_regs.fpcr):
+		size = sizeof(__u32);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (!IS_ALIGNED(off, size / sizeof(__u32)))
+		return -EINVAL;
+
+	/*
+	 * The KVM_REG_ARM64_SVE regs must be used instead of
+	 * KVM_REG_ARM_CORE for accessing the FPSIMD V-registers on
+	 * SVE-enabled vcpus:
+	 */
+	if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
+		return -EINVAL;
+
+	return size;
+}
+
+static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	u64 off = core_reg_offset_from_id(reg->id);
+	int size = core_reg_size_from_offset(vcpu, off);
+
+	if (size < 0)
+		return NULL;
+
+	if (KVM_REG_SIZE(reg->id) != size)
+		return NULL;
+
+	switch (off) {
+	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
+	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
+		off -= KVM_REG_ARM_CORE_REG(regs.regs[0]);
+		off /= 2;
+		return &vcpu->arch.ctxt.regs.regs[off];
+
+	case KVM_REG_ARM_CORE_REG(regs.sp):
+		return &vcpu->arch.ctxt.regs.sp;
+
+	case KVM_REG_ARM_CORE_REG(regs.pc):
+		return &vcpu->arch.ctxt.regs.pc;
+
+	case KVM_REG_ARM_CORE_REG(regs.pstate):
+		return &vcpu->arch.ctxt.regs.pstate;
+
+	case KVM_REG_ARM_CORE_REG(sp_el1):
+		return __ctxt_sys_reg(&vcpu->arch.ctxt, SP_EL1);
+
+	case KVM_REG_ARM_CORE_REG(elr_el1):
+		return __ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_EL1]):
+		return __ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1);
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_ABT]):
+		return &vcpu->arch.ctxt.spsr_abt;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_UND]):
+		return &vcpu->arch.ctxt.spsr_und;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_IRQ]):
+		return &vcpu->arch.ctxt.spsr_irq;
+
+	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_FIQ]):
+		return &vcpu->arch.ctxt.spsr_fiq;
+
+	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
+	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
+		off -= KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]);
+		off /= 4;
+		return &vcpu->arch.ctxt.fp_regs.vregs[off];
+
+	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
+		return &vcpu->arch.ctxt.fp_regs.fpsr;
+
+	case KVM_REG_ARM_CORE_REG(fp_regs.fpcr):
+		return &vcpu->arch.ctxt.fp_regs.fpcr;
+
+	default:
+		return NULL;
+	}
+}
+
+static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	/*
+	 * Because the kvm_regs structure is a mix of 32, 64 and
+	 * 128bit fields, we index it as if it was a 32bit
+	 * array. Hence below, nr_regs is the number of entries, and
+	 * off the index in the "array".
+	 */
+	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
+	int nr_regs = sizeof(struct kvm_regs) / sizeof(__u32);
+	void *addr;
+	u32 off;
+
+	/* Our ID is an index into the kvm_regs struct. */
+	off = core_reg_offset_from_id(reg->id);
+	if (off >= nr_regs ||
+	    (off + (KVM_REG_SIZE(reg->id) / sizeof(__u32))) >= nr_regs)
+		return -ENOENT;
+
+	addr = core_reg_addr(vcpu, reg);
+	if (!addr)
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, addr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
+	int nr_regs = sizeof(struct kvm_regs) / sizeof(__u32);
+	__uint128_t tmp;
+	void *valp = &tmp, *addr;
+	u64 off;
+	int err = 0;
+
+	/* Our ID is an index into the kvm_regs struct. */
+	off = core_reg_offset_from_id(reg->id);
+	if (off >= nr_regs ||
+	    (off + (KVM_REG_SIZE(reg->id) / sizeof(__u32))) >= nr_regs)
+		return -ENOENT;
+
+	addr = core_reg_addr(vcpu, reg);
+	if (!addr)
+		return -EINVAL;
+
+	if (KVM_REG_SIZE(reg->id) > sizeof(tmp))
+		return -EINVAL;
+
+	if (copy_from_user(valp, uaddr, KVM_REG_SIZE(reg->id))) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	memcpy(addr, valp, KVM_REG_SIZE(reg->id));
+out:
+	return err;
+}
+
+static int get_sys_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
+	u64 dummy_val = 0;
+
+	if (copy_to_user(uaddr, &dummy_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
+				 u64 __user *uindices)
+{
+	unsigned int i;
+	int n = 0;
+
+	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
+		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
+		int size = core_reg_size_from_offset(vcpu, i);
+
+		if (size < 0)
+			continue;
+
+		switch (size) {
+		case sizeof(__u32):
+			reg |= KVM_REG_SIZE_U32;
+			break;
+
+		case sizeof(__u64):
+			reg |= KVM_REG_SIZE_U64;
+			break;
+
+		case sizeof(__uint128_t):
+			reg |= KVM_REG_SIZE_U128;
+			break;
+
+		default:
+			WARN_ON(1);
+			continue;
+		}
+
+		if (uindices) {
+			if (put_user(reg, uindices))
+				return -EFAULT;
+			uindices++;
+		}
+
+		n++;
+	}
+
+	return n;
+}
+
+static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
+{
+	return copy_core_reg_indices(vcpu, NULL);
+}
+
+int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	/* We currently use nothing arch-specific in upper 32 bits */
+	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
+		return -EINVAL;
+
+	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
+	case KVM_REG_ARM_CORE:
+		return get_core_reg(vcpu, reg);
+	case KVM_REG_ARM64_SYSREG:
+		return get_sys_reg(vcpu, reg);
+	default:
+		return -ENOENT;
+	}
+}
+
+int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	/* We currently use nothing arch-specific in upper 32 bits */
+	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
+		return -EINVAL;
+
+	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
+	case KVM_REG_ARM_CORE:
+		return set_core_reg(vcpu, reg);
+	default:
+		return -ENOENT;
+	}
+}
+
+int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
+}
+
+vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+void kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+}
+
+void kvm_arch_destroy_vm(struct kvm *kvm)
+{
+	kvm_destroy_vcpus(kvm);
+	return;
+}
+
+long kvm_arch_dev_ioctl(struct file *filp,
+			unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
+
+bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
+{
+	return false;
+}
+
+bool kvm_arch_intc_initialized(struct kvm *kvm)
+{
+	return true;
+}
+
+struct kvm_vcpu *kvm_arch_vcpu_alloc(void)
+{
+	return NULL;
+}
+
+int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
+{
+	return 0;
+}
+
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	return -EINVAL;
+}
+
+void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
+{
+}
+
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
+{
+	return 0;
+}
+
+bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+{
+	return -EINVAL;
+}
+
+long kvm_arch_vcpu_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg)
+{
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	long r;
+
+	switch (ioctl) {
+	case KVM_ARM_VCPU_INIT: {
+		struct kvm_vcpu_init init;
+
+		r = -EFAULT;
+		if (copy_from_user(&init, argp, sizeof(init)))
+			break;
+
+		vcpu_set_flag(vcpu, VCPU_INITIALIZED);
+		r = 0;
+		break;
+	}
+	case KVM_SET_ONE_REG:
+	case KVM_GET_ONE_REG: {
+		struct kvm_one_reg reg;
+
+		r = -ENOEXEC;
+		if (unlikely(!kvm_vcpu_initialized(vcpu)))
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			break;
+
+		if (ioctl == KVM_SET_ONE_REG)
+			r = kvm_arm_set_reg(vcpu, &reg);
+		else
+			r = kvm_arm_get_reg(vcpu, &reg);
+		break;
+	}
+	case KVM_GET_REG_LIST: {
+		struct kvm_reg_list __user *user_list = argp;
+		struct kvm_reg_list reg_list;
+		unsigned n;
+
+		r = -ENOEXEC;
+		if (unlikely(!kvm_vcpu_initialized(vcpu)))
+			break;
+
+		r = -EFAULT;
+		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
+			break;
+
+		n = reg_list.n;
+		reg_list.n = num_core_regs(vcpu);
+		if (copy_to_user(user_list, &reg_list, sizeof(reg_list)))
+			break;
+		r = -E2BIG;
+		if (n < reg_list.n)
+			break;
+
+		r = 0;
+		copy_core_reg_indices(vcpu, user_list->reg);
+		break;
+	}
+	case KVM_ARM_VCPU_FINALIZE: {
+		return 0;
+	}
+	default:
+		pr_info("gunyah: %s: unrecognised vcpu ioctl %u\n", __func__, ioctl);
+		r = -EINVAL;
+	}
+
+	return r;
+}
+
+int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
+				  struct kvm_translation *tr)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
+{
+	return -EINVAL;
+}
+
+void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
+{
+}
+
+int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
+			    struct kvm_enable_cap *cap)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+
+	switch (ioctl) {
+	case KVM_ARM_PREFERRED_TARGET: {
+		struct kvm_vcpu_init init = {
+			.target = KVM_ARM_TARGET_GENERIC_V8,
+		};
+
+		if (copy_to_user(argp, &init, sizeof(init)))
+			return -EFAULT;
+
+		return 0;
+	}
+	case KVM_ARM_SET_COUNTER_OFFSET: {
+		return -ENXIO;
+	}
+	case KVM_ARM_SET_DEVICE_ADDR: {
+		struct kvm_arm_device_addr dev_addr;
+
+		if (copy_from_user(&dev_addr, argp, sizeof(dev_addr)))
+			return -EFAULT;
+
+		return -ENODEV;
+	}
+	case KVM_HAS_DEVICE_ATTR: {
+		return -ENXIO;
+	}
+	case KVM_SET_DEVICE_ATTR: {
+		return -ENXIO;
+	}
+	case KVM_ARM_GET_REG_WRITABLE_MASKS: {
+		return -ENXIO;
+	}
+	default:
+		return -EINVAL;
+	}
+}
+
+int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_IOEVENTFD:
+	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_SYNC_MMU:
+	case KVM_CAP_ONE_REG:
+	case KVM_CAP_READONLY_MEM:
+	case KVM_CAP_VCPU_ATTRIBUTES:
+	case KVM_CAP_ARM_USER_IRQ:
+	case KVM_CAP_ARM_SET_DEVICE_ADDR:
+		r = 1;
+		break;
+	case KVM_CAP_NR_VCPUS:
+		/*
+		 * ARM64 treats KVM_CAP_NR_CPUS differently from all other
+		 * architectures, as it does not always bound it to
+		 * KVM_CAP_MAX_VCPUS. It should not matter much because
+		 * this is just an advisory value.
+		 */
+		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
+		break;
+	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
+		r = KVM_MAX_VCPUS;
+		break;
+	default:
+		r = 0;
+	}
+
+	return r;
+}
+
+int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
+			  bool line_status)
+{
+	return -ENXIO;
+}
+
+int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
+{
+	return 0;
+}
+
+void kvm_arch_flush_shadow_all(struct kvm *kvm)
+{
+}
+
+int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
+				      gfn_t gfn, u64 nr_pages)
+{
+	return -EINVAL;
+}
+
+void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
+		struct kvm_memory_slot *slot,
+		gfn_t gfn_offset, unsigned long mask)
+{
+}
+
+void kvm_arch_commit_memory_region(struct kvm *kvm,
+				   struct kvm_memory_slot *old,
+				   const struct kvm_memory_slot *new,
+				   enum kvm_mr_change change)
+{
+}
+
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
+				   enum kvm_mr_change change)
+{
+	return 0;
+}
+
+void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+}
+
+void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
+{
+}
+
+void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
+				   struct kvm_memory_slot *slot)
+{
+}
+
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+{
+	return -EINVAL;
+}
+
+__init void kvm_compute_layout(void)
+{
+}
+
+__init void kvm_apply_hyp_relocations(void)
+{
+}
+
+void __init kvm_hyp_reserve(void)
+{
+}
+
+void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+}
+
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	return -EINVAL;
+}
+
+struct kvm *kvm_arch_alloc_vm(void)
+{
+	return NULL;
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b411..575864e93f79 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -12,7 +12,7 @@
 
 #define KVM_ARMV8_PMU_MAX_COUNTERS	32
 
-#if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
+#if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM_ARM)
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
 	struct perf_event *perf_event;
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
index a75b2c7de69d..7a4a6051ffa6 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -36,7 +36,7 @@ struct gic_kvm_info {
 	bool		no_hw_deactivation;
 };
 
-#ifdef CONFIG_KVM
+#ifdef CONFIG_KVM_ARM
 void vgic_set_kvm_info(const struct gic_kvm_info *info);
 #else
 static inline void vgic_set_kvm_info(const struct gic_kvm_info *info) {}
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index 6dc5e0cd76ca..c6cb2db9402a 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -170,7 +170,7 @@ int arm_pmu_acpi_probe(armpmu_init_fn init_fn);
 static inline int arm_pmu_acpi_probe(armpmu_init_fn init_fn) { return 0; }
 #endif
 
-#ifdef CONFIG_KVM
+#ifdef CONFIG_KVM_ARM
 void kvm_host_pmu_init(struct arm_pmu *pmu);
 #else
 #define kvm_host_pmu_init(x)	do { } while(0)
-- 
2.39.5


