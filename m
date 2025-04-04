Return-Path: <kvm+bounces-42673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 406DFA7C1D3
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 18:54:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DF673B84E4
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8087621171C;
	Fri,  4 Apr 2025 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C1ms4v91"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B8421480B
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 16:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785582; cv=none; b=EX6MWEAMThh0UVctkcRxnl1z8gcLuYiK84+xpZyhueLYle5XZpZcqRZY0f6lif69SEYSrxwp06sp3FmDEVWvBfmFQyJTQMqpt82SfzE1Mt1b4WSGahGpGYOzWnWQhwK0o+SO//wRTvq1lkMp1/OMo22C/D6+9iNHqggExLhctto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785582; c=relaxed/simple;
	bh=IGg8J+9xu1H2I8o4uXzQ0WJuo3+twH/AnkuRrNtMwHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KOpNUWgVCb9KnYrLn2J8yM2M/HTfshIMMghoHbe/YMdwpUwJeNbZeN22q/5jZjGbENwCLYhsHiykh40gDgwLjEQ5iVuxgxoMrjM+fsFlzV/x8OyeWiv5l1RhY1In5AbKRi7F/rQhNGz8mW1WRHmQAUYwsyAU8l/BzZ7XQzUDA9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C1ms4v91; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8zXze+5FFXW4N7ik6GEto22tSoougkRNGTH3nTiOR2M=;
	b=C1ms4v91Im0/s/dcV3XY7FxphKDlcGNMGUGhB3WmbZDQCOoxsPYShQIT8rHF9zR//nVyEV
	zdBFZOMouoyZwaWsvc42UELPmH1gEv2olGDYHUoNfxTWJCXxursoNuIkik61b5gxV7LwPD
	QA68NCy76+kMsLk/uZllHtumJmBRjso=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v2 5/9] arm64: Combine kvm-config-arch.h
Date: Fri,  4 Apr 2025 09:52:28 -0700
Message-Id: <20250404165233.3205127-6-oliver.upton@linux.dev>
In-Reply-To: <20250404165233.3205127-1-oliver.upton@linux.dev>
References: <20250404165233.3205127-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

You get the point...

Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/kvm-config-arch.h     | 29 -------------------
 .../{arm-common => kvm}/kvm-config-arch.h     | 24 +++++++++++++--
 2 files changed, 22 insertions(+), 31 deletions(-)
 delete mode 100644 arm/aarch64/include/kvm/kvm-config-arch.h
 rename arm/include/{arm-common => kvm}/kvm-config-arch.h (54%)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
deleted file mode 100644
index 642fe67..0000000
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef KVM__KVM_CONFIG_ARCH_H
-#define KVM__KVM_CONFIG_ARCH_H
-
-int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
-int sve_vl_parser(const struct option *opt, const char *arg, int unset);
-
-#define ARM_OPT_ARCH_RUN(cfg)						\
-	OPT_BOOLEAN('\0', "aarch32", &(cfg)->aarch32_guest,		\
-			"Run AArch32 guest"),				\
-	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
-			"Create PMUv3 device. The emulated PMU will be" \
-			" set to the PMU associated with the"		\
-			" main thread, unless --vcpu-affinity is set"),	\
-	OPT_BOOLEAN('\0', "disable-mte", &(cfg)->mte_disabled,		\
-			"Disable Memory Tagging Extension"),		\
-	OPT_CALLBACK('\0', "vcpu-affinity", kvm, "cpulist",  		\
-			"Specify the CPU affinity that will apply to "	\
-			"all VCPUs", vcpu_affinity_parser, kvm),	\
-	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
-			"Specify random seed for Kernel Address Space "	\
-			"Layout Randomization (KASLR)"),		\
-	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
-			" stolen time"),				\
-	OPT_CALLBACK('\0', "sve-max-vl", NULL, "vector length",		\
-		     "Specify the max SVE vector length (in bits) for "	\
-		     "all vCPUs", sve_vl_parser, kvm),
-#include "arm-common/kvm-config-arch.h"
-
-#endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/kvm/kvm-config-arch.h
similarity index 54%
rename from arm/include/arm-common/kvm-config-arch.h
rename to arm/include/kvm/kvm-config-arch.h
index 4722d8f..ee031f0 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/kvm/kvm-config-arch.h
@@ -18,17 +18,37 @@ struct kvm_config_arch {
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
+int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
+int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 
 #define OPT_ARCH_RUN(pfx, cfg)							\
 	pfx,									\
-	ARM_OPT_ARCH_RUN(cfg)							\
+	OPT_BOOLEAN('\0', "aarch32", &(cfg)->aarch32_guest,			\
+			"Run AArch32 guest"),					\
+	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,				\
+			"Create PMUv3 device. The emulated PMU will be" 	\
+			" set to the PMU associated with the"			\
+			" main thread, unless --vcpu-affinity is set"),		\
+	OPT_BOOLEAN('\0', "disable-mte", &(cfg)->mte_disabled,			\
+			"Disable Memory Tagging Extension"),			\
+	OPT_CALLBACK('\0', "vcpu-affinity", kvm, "cpulist",  			\
+			"Specify the CPU affinity that will apply to "		\
+			"all VCPUs", vcpu_affinity_parser, kvm),		\
+	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,				\
+			"Specify random seed for Kernel Address Space "		\
+			"Layout Randomization (KASLR)"),			\
+	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"		\
+			" stolen time"),					\
+	OPT_CALLBACK('\0', "sve-max-vl", NULL, "vector length",			\
+		     "Specify the max SVE vector length (in bits) for "		\
+		     "all vCPUs", sve_vl_parser, kvm),				\
 	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,			\
 		   ".dtb file", "Dump generated .dtb to specified file"),	\
 	OPT_UINTEGER('\0', "override-bad-firmware-cntfrq", &(cfg)->force_cntfrq,\
 		     "Specify Generic Timer frequency in guest DT to "		\
 		     "work around buggy secure firmware *Firmware should be "	\
 		     "updated to program CNTFRQ correctly*"),			\
-	OPT_CALLBACK_NOOPT('\0', "force-pci", NULL, "",			\
+	OPT_CALLBACK_NOOPT('\0', "force-pci", NULL, "",				\
 			   "Force virtio devices to use PCI as their default "	\
 			   "transport (Deprecated: Use --virtio-transport "	\
 			   "option instead)", virtio_transport_parser, kvm),	\
-- 
2.39.5


