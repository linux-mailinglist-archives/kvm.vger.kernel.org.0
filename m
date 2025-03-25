Return-Path: <kvm+bounces-42003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4167A70C46
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 22:43:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FB981895866
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 21:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2836026A097;
	Tue, 25 Mar 2025 21:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H+ZDICrQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A07D269D13
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 21:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742938807; cv=none; b=tJawioMR4hmY3kW1jIaQ1z6WECgJPPYiHza6aA9GY3gf6hB+LbmIuiI1lJTQjmoXM7oK6htk5kw5tTm3+f87I4ejFRlnWGuek4XSKm2FoH5EkdqCmLhSVbpBNlq2lsDVbSJOsY/1yMN7PwsmF8Rxl7UlnlMAigre7yvVKXn+Hk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742938807; c=relaxed/simple;
	bh=gr5C3iKUv9+Qm+cHwkG0yVdflK2MlZncn6K8MTFx4/U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mXbB6cPx3WY1JGyV9zk7pP+FhmK52YwPFRALdLpZenT7lT2F9A0DOs/jbCMpnmnog96O8JXdZi9nbO8pWCLPAWc4Fy0U62EabNi0UaVxvaIYa09Q8f0l5zqEWGzJaYz2guY8CE37oxmRxNeBlx8I8+u5p0u18+dPHu1HJ8+Q1oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H+ZDICrQ; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742938801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zm1afkfwfFnya3XfdChEQoMTsnuGAY9/LUZ+lOu9va4=;
	b=H+ZDICrQiy2BLFiUDpR7peP8ctQjv6vIyx5RdjxlRWvwL/qbHBogUoc/cTdxBkBTntpepf
	uXJ8gx10p4Fl9i8s4xH6d+6DMgL5z2hsWPVaVKvSOk7OrYHDnDqGANOgCYELrDAGxvQLBN
	d+IVnXq/JJqkz4lFzdtQCVq3Hw7gCi8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 5/9] arm64: Combine kvm-config-arch.h
Date: Tue, 25 Mar 2025 14:39:35 -0700
Message-Id: <20250325213939.2414498-6-oliver.upton@linux.dev>
In-Reply-To: <20250325213939.2414498-1-oliver.upton@linux.dev>
References: <20250325213939.2414498-1-oliver.upton@linux.dev>
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


