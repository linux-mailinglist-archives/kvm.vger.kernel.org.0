Return-Path: <kvm+bounces-36527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F27BEA1B71F
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F072A18813C6
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E8214AD3D;
	Fri, 24 Jan 2025 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cl/qVUoX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B7D135A63
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725978; cv=none; b=uUkfeZhj2PbFVFBbpW9bQFJN6AyN4h07Q1sjME318/clNNfFHTWDFdukP66h2R/GC6yw5AtpleuyhMpq+Qvrv7G1wl3fnRHjiqHIP0X7ZhZXyFxeFfGlA9ebB9STHOSJbV1fbvuzKV+yDu13AArjhoQ6HfOUS71suX1cn0rKMzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725978; c=relaxed/simple;
	bh=nEl4TCuOb3xMvomAtSQmQ5FpTfT7WK6HIdgq9DzAG/A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J5MvQMf6gGbVn+jMXqRzRdOBp5zqa9LDZ6LolXUHr59nRRtwj5k73TwpKewvmEO6X5hYL1NAmYEqZqrLv/5wmQVbO2d7xTYjQF8iJac3nGT9tJAGA8IwcuxYbBy/3TZ053m4SFA2Mr4iIHJHwk3avc53UBQ5NzaykE6+DTRBhvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cl/qVUoX; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725977; x=1769261977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nEl4TCuOb3xMvomAtSQmQ5FpTfT7WK6HIdgq9DzAG/A=;
  b=cl/qVUoXPaWpCfc3dRhhZIbLNkLOZOSxl9doXiOa6xZ944JkWwb124L9
   0ydiyGIavf5y6asjpO17v3i+2KUnPemPf8UXSZvocLi/WSaFktSGj3zr5
   gLeejKP8AsQfQV8h35nE8NOvdIIGpzSEATkJ5Zr6THn9iK70HvUE9FdhS
   jHFnJuXTbqOQOrMewDUzW0Ixq4z3rb4pDuTQAsFaKfNLmrzLCfk86YuID
   HB1Wl0nbn1kY9HNah19xJKpMRrLSSOUa0jZWOZSuNn7kD0uH6+QOjtUji
   2Lt3qzruajRrVepEkhXL7f2yVbckkOZoC3AsvG4F1AQaS/70YEKH2v0uq
   A==;
X-CSE-ConnectionGUID: MSbNzfYCQXeYx0VxB14GSg==
X-CSE-MsgGUID: R2gMCUrQSoWaxMeaZJ4+yQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246561"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246561"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:37 -0800
X-CSE-ConnectionGUID: ifW55XqjSmCxoKv9I1zumQ==
X-CSE-MsgGUID: fZJtod0oTJ+gDSX001OnKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804448"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:39:32 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 41/52] i386/tdx: Implement adjust_cpuid_features() for TDX
Date: Fri, 24 Jan 2025 08:20:37 -0500
Message-Id: <20250124132048.3229049-42-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1. QEMU's support for Intel PT is borken in general, thus doesn't
   support for TDX.

2. Only limited KVM PV features are supported for TD guest.

3. Drop the AMD specific bits that are reserved on Intel platform.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 44 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index dcbbe350ec91..9bdb9d795952 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -30,6 +30,8 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+#include "standard-headers/asm-x86/kvm_para.h"
+
 #define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
 #define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
 
@@ -42,6 +44,14 @@
                                  TDX_TD_ATTRIBUTES_PKS | \
                                  TDX_TD_ATTRIBUTES_PERFMON)
 
+#define TDX_SUPPORTED_KVM_FEATURES  ((1U << KVM_FEATURE_NOP_IO_DELAY) | \
+                                     (1U << KVM_FEATURE_PV_UNHALT) | \
+                                     (1U << KVM_FEATURE_PV_TLB_FLUSH) | \
+                                     (1U << KVM_FEATURE_PV_SEND_IPI) | \
+                                     (1U << KVM_FEATURE_POLL_CONTROL) | \
+                                     (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
+                                     (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
+
 static TdxGuest *tdx_guest;
 
 static struct kvm_tdx_capabilities *tdx_caps;
@@ -430,6 +440,39 @@ static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
     x86cpu->enable_cpuid_0x1f = true;
 }
 
+static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
+                                          uint32_t feature, uint32_t index,
+                                          int reg, uint32_t value)
+{
+    switch (feature) {
+    case 0x7:
+        if (index == 0 && reg == R_EBX) {
+            /* QEMU Intel PT support is broken */
+            value &= ~CPUID_7_0_EBX_INTEL_PT;
+        }
+        break;
+    case 0x40000001:
+        if (reg == R_EAX) {
+            value &= TDX_SUPPORTED_KVM_FEATURES;
+        }
+        break;
+    case 0x80000001:
+        if (reg == R_EDX) {
+            value &= ~CPUID_EXT2_AMD_ALIASES;
+        }
+        break;
+    case 0x80000008:
+        if (reg == R_EBX) {
+            value &= CPUID_8000_0008_EBX_WBNOINVD;
+        }
+        break;
+    default:
+        break;
+    }
+
+    return value;
+}
+
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
 {
     if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
@@ -789,4 +832,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
     klass->kvm_init = tdx_kvm_init;
     x86_klass->kvm_type = tdx_kvm_type;
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
+    x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
 }
-- 
2.34.1


