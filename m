Return-Path: <kvm+bounces-30683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5114E9BC5B6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:41:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B52ABB22EEE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C561FEFA9;
	Tue,  5 Nov 2024 06:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RPtoZOi6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0151FDFAF
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788794; cv=none; b=tXK0SfpoQbALvSaDO0akGNa5ILSfemON33ahb4hoYN2X9lhtfQ1nd2iVXgR794Dic04NLEcrdG1BiaHVrlVI1bq8E3kZy8Xq1CP35T9s1o2MHPtn0pso7OlCE8d7+dCnu/R1D9cxfXVwKLpv0Yzcgx+oCOJ/8S/SuhWGgEhfeX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788794; c=relaxed/simple;
	bh=st5/vyvnaPY+w7rPqzvPYRhQDfLRvMD4QU7tirPy57w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bXSZqVICH8OKbXzpX4afXjVU1HsapH7bwpSTrEB3ZIwFZsC+sSkUbZ7IPhDtzqVoy680gRDVC/fNipPGAlCItJHXU76FDRgi9Ix4JzEaEftx432xeAwIcBcM4Cggctp0hDeZzQV1B1awyVkKiu3/lAkOUY3V4JQTfv+yDKXSCJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RPtoZOi6; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788793; x=1762324793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=st5/vyvnaPY+w7rPqzvPYRhQDfLRvMD4QU7tirPy57w=;
  b=RPtoZOi6812G48VKY9WxMqPcDohJ4oUh6rfqFlAa9ikuVq5NUILnT7aB
   34YLXQtjdRhPKfkx6Y2GAEuyPmOXUhlaIOhrkrylTv7hvbXvHwMBBAYkP
   7z8g0rJ8Tk3Tn3OPkH6GVw1FQONmRMTKw85IjzRQD0nUxM2Q9rUpAcLZk
   acQCuQbXMb9f8mL62LfF2tCu5yP5AWi/pxNdDPRw/zm/XEBVg7EwNZK9i
   9/BDMRonEiEwhq9Wf88jAt5drQwjtbILNuh/ns2L1iZ3CEkRm/uEAEe1W
   i64cneQKZdy/KSzc16tYTi8hYUWtSsW83ii+k70LH28U6Q4i+IJ9r8lfQ
   g==;
X-CSE-ConnectionGUID: vRd2jjP5Szy/xUmrub6oRA==
X-CSE-MsgGUID: oFZDQL06QXi2V15lQqTTXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689856"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689856"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:53 -0800
X-CSE-ConnectionGUID: 5WJ5xED5SVGuZQVUr6MnSA==
X-CSE-MsgGUID: 5It1nMLzSeKHTxiykp0Vsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989825"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:48 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 49/60] i386/tdx: Mask off CPUID bits by unsupported TD Attributes
Date: Tue,  5 Nov 2024 01:23:57 -0500
Message-Id: <20241105062408.3533704-50-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For TDX, some CPUID feature bit is configured via TD attributes. Adjust
the supported CPUID to mask off the bit if its matched attribute is
unsupported.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.h     |  4 ++++
 target/i386/kvm/tdx.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 8118356af4fc..e02e23d972a0 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -903,6 +903,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_0_ECX_LA57              (1U << 16)
 /* Read Processor ID */
 #define CPUID_7_0_ECX_RDPID             (1U << 22)
+/* KeyLocker */
+#define CPUID_7_0_ECX_KeyLocker         (1U << 23)
 /* Bus Lock Debug Exception */
 #define CPUID_7_0_ECX_BUS_LOCK_DETECT   (1U << 24)
 /* Cache Line Demote Instruction */
@@ -955,6 +957,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_1_EAX_AVX_VNNI          (1U << 4)
 /* AVX512 BFloat16 Instruction */
 #define CPUID_7_1_EAX_AVX512_BF16       (1U << 5)
+/* Linear address space separation */
+#define CPUID_7_1_EAX_LASS              (1U << 6)
 /* CMPCCXADD Instructions */
 #define CPUID_7_1_EAX_CMPCCXADD         (1U << 7)
 /* Fast Zero REP MOVS */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index bc1581d1e43b..5ac5f93907ca 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -533,6 +533,58 @@ KvmCpuidInfo tdx_fixed1_bits = {
     },
 };
 
+typedef struct TdxAttrsMap {
+    uint32_t attr_index;
+    uint32_t cpuid_leaf;
+    uint32_t cpuid_subleaf;
+    int cpuid_reg;
+    uint32_t feat_mask;
+} TdxAttrsMap;
+
+static TdxAttrsMap tdx_attrs_maps[] = {
+    {.attr_index = 27,
+     .cpuid_leaf = 7,
+     .cpuid_subleaf = 1,
+     .cpuid_reg = R_EAX,
+     .feat_mask = CPUID_7_1_EAX_LASS},
+    {.attr_index = 30,
+     .cpuid_leaf = 7,
+     .cpuid_subleaf = 0,
+     .cpuid_reg = R_ECX,
+     .feat_mask = CPUID_7_0_ECX_PKS,},
+    {.attr_index = 31,
+     .cpuid_leaf = 7,
+     .cpuid_subleaf = 0,
+     .cpuid_reg = R_ECX,
+     .feat_mask = CPUID_7_0_ECX_KeyLocker,
+    },
+};
+
+static void tdx_mask_cpuid_by_attrs(uint32_t feature, uint32_t index,
+                                    int reg, uint32_t *value)
+{
+    TdxAttrsMap *map;
+    uint64_t unavail = 0;
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(tdx_attrs_maps); i++) {
+        map = &tdx_attrs_maps[i];
+
+        if (feature != map->cpuid_leaf || index != map->cpuid_subleaf ||
+            reg != map->cpuid_reg) {
+            continue;
+        }
+
+        if (!((1ULL << map->attr_index) & tdx_caps->supported_attrs)) {
+            unavail |= map->feat_mask;
+        }
+    }
+
+    if (unavail) {
+        *value &= ~unavail;
+    }
+}
+
 static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
                                           uint32_t feature, uint32_t index,
                                           int reg, uint32_t value)
@@ -566,6 +618,8 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
         break;
     }
 
+    tdx_mask_cpuid_by_attrs(feature, index, reg, &value);
+
     e = cpuid_find_entry(&tdx_fixed0_bits.cpuid, feature, index);
     if (e) {
         fixed0 = cpuid_entry_get_reg(e, reg);
-- 
2.34.1


